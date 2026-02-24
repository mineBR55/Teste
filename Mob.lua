require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");

local constructNew_frmMonster = function()

    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    obj:setName("frmMonster");
    obj:setFormType("sheetTemplate");
    obj:setDataType("frmMonster");
    obj:setTitle("Ficha de Mob");

    ---------------------------------------------------
    -- VINCULO COM NODE
    ---------------------------------------------------

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end;

    ---------------------------------------------------
    -- UTIL
    ---------------------------------------------------

    local function getMesa()
        if sheet ~= nil then
            return Firecast.getMesaDe(sheet);
        end
        return nil;
    end

    local function enviarMensagem(msg)
        local mesa = getMesa();
        if mesa ~= nil then
            mesa:enviarMensagem(msg);
        end
    end

    local function rolar(expr, label)
        local mesa = getMesa();
        if mesa ~= nil then
            Firecast.interpretarRolagem(mesa, expr, label);
        end
    end

    ---------------------------------------------------
    -- EVENTOS (APÓS LFM CARREGAR)
    ---------------------------------------------------

    obj._e0 = obj.btnDamage:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local current = tonumber(sheet.hp) or 0
            local dmg = tonumber(sheet.hpInput) or 0

            current = current - dmg
            if current < 0 then current = 0 end

            sheet.hp = current
            sheet.hpInput = ""

            enviarMensagem((sheet.name or "Monstro") ..
                " sofreu " .. dmg ..
                " de dano. HP: " .. current ..
                "/" .. (sheet.hpMax or "?"))
        end);

    obj._e1 = obj.btnHeal:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local current = tonumber(sheet.hp) or 0
            local max = tonumber(sheet.hpMax) or current
            local heal = tonumber(sheet.hpInput) or 0

            current = current + heal
            if current > max then current = max end

            sheet.hp = current
            sheet.hpInput = ""

            enviarMensagem((sheet.name or "Monstro") ..
                " curou " .. heal ..
                " HP. HP: " .. current ..
                "/" .. max)
        end);

    obj._e2 = obj.btnMulti:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local count = tonumber(sheet.multiCount) or 1
            local bonus = tonumber(sheet.multiBonus) or 0
            local damage = sheet.multiDamage or "1d6"

            enviarMensagem((sheet.name or "Monstro") .. " realiza Multiattack!")

            for i = 1, count do
                rolar("1d20 + " .. bonus,
                    (sheet.name or "Monstro") .. " - Ataque " .. i)

                rolar(damage,
                    (sheet.name or "Monstro") .. " - Dano " .. i)
            end
        end);

    obj._e3 = obj.btnSaves:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local count = tonumber(sheet.saveCount) or 1
            local dc = tonumber(sheet.saveDC) or 10
            local mod = tonumber(sheet.saveMod) or 0
            local stat = sheet.saveStat or "DEX"

            enviarMensagem((sheet.name or "Monstro") ..
                " força teste de " .. stat ..
                " CD " .. dc)

            for i = 1, count do
                rolar("1d20 + " .. mod,
                    "Save " .. i)
            end
        end);

    obj._e4 = obj.btnSpendLegendary:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local current = tonumber(sheet.legendaryCurrent) or 0

            if current > 0 then
                current = current - 1
                sheet.legendaryCurrent = current

                enviarMensagem((sheet.name or "Monstro") ..
                    " gastou 1 Ação Lendária. Restam: " .. current)
            else
                enviarMensagem((sheet.name or "Monstro") ..
                    " não tem ações lendárias restantes!")
            end
        end);

    obj._e5 = obj.btnResetLegendary:addEventListener("onClick",
        function()
            if sheet == nil then return end

            local max = tonumber(sheet.legendaryMax) or 0
            sheet.legendaryCurrent = max

            enviarMensagem((sheet.name or "Monstro") ..
                " restaurou ações lendárias: " .. max)
        end);

    ---------------------------------------------------
    -- DESTROY
    ---------------------------------------------------

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e0);
        __o_rrpgObjs.removeEventListenerById(self._e1);
        __o_rrpgObjs.removeEventListenerById(self._e2);
        __o_rrpgObjs.removeEventListenerById(self._e3);
        __o_rrpgObjs.removeEventListenerById(self._e4);
        __o_rrpgObjs.removeEventListenerById(self._e5);
    end

    obj._oldDestroy = obj.destroy;

    function obj:destroy()
        self:_releaseEvents();

        if self._oldDestroy then
            self:_oldDestroy();
        end
    end;

    return obj;
end;

---------------------------------------------------
-- REGISTRO
---------------------------------------------------

local _frmMonster = {
    newEditor = constructNew_frmMonster,
    new = constructNew_frmMonster,
    name = "frmMonster",
    dataType = "frmMonster",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Ficha de Mob",
    description = "Ficha simples para monstros"
};

Firecast.registrarForm(_frmMonster);

return _frmMonster;