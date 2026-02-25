require("firecast.lua");
require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");

local __o_rrpgObjs = require("rrpgObjs.lua");

local frmMonster = {};

function frmMonster.new()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmMonster");

    local sheet = nil;

    -------------------------------------
    -- VINCULAR NODO
    -------------------------------------
    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end

    -------------------------------------
    -- HP SYSTEM
    -------------------------------------
    local function applyDamage()
        if sheet == nil then return end

        local current = tonumber(sheet.hp) or 0
        local dmg = tonumber(sheet.hpInput) or 0

        current = current - dmg
        if current < 0 then current = 0 end

        sheet.hp = current
        sheet.hpInput = ""
    end

    local function applyHeal()
        if sheet == nil then return end

        local current = tonumber(sheet.hp) or 0
        local max = tonumber(sheet.hpMax) or 0
        local heal = tonumber(sheet.hpInput) or 0

        current = current + heal
        if current > max then current = max end

        sheet.hp = current
        sheet.hpInput = ""
    end

    -------------------------------------
    -- EVENTOS
    -------------------------------------
    obj._e0 = obj.btnDamage:addEventListener("onClick",
        function()
            applyDamage()
        end);

    obj._e1 = obj.btnHeal:addEventListener("onClick",
        function()
            applyHeal()
        end);

    -------------------------------------
    -- CLEANUP
    -------------------------------------
    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e0);
        __o_rrpgObjs.removeEventListenerById(self._e1);
    end

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy()
        self:_releaseEvents();

        if self._oldLFMDestroy then
            self:_oldLFMDestroy();
        end
    end

    return obj;
end

local _frmMonster = {
    newEditor = function()
        return frmMonster:new();
    end,
    new = function()
        return frmMonster:new();
    end,
    name = "frmMonster",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Ficha de Mob",
    description = "Ficha simples de monstro"};

frmMonster = _frmMonster;

return frmMonster;