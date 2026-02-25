require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");

local frmMonster = {};
frmMonster.__index = frmMonster;

function frmMonster.new()
    local self = GUI.fromHandle(_obj_newObject("form"));
    setmetatable(self, frmMonster);

    self:setName("frmMonster");

    local sheet = nil;

    function self:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end

    function self:_releaseEvents()
        if self._e0 then __o_rrpgObjs.removeEventListenerById(self._e0); end
        if self._e1 then __o_rrpgObjs.removeEventListenerById(self._e1); end
    end

    function self:destroy()
        self:_releaseEvents();
    end

    return self;
end

function constructNew_frmMonster()
    local obj = frmMonster.new();

    obj:setFormType("sheetTemplate");
    obj:setDataType("br.com.mineBR55.mob");
    obj:setTitle("Ficha de Mob");

    obj._e0 = obj.btnDamage:addEventListener("onClick",
        function()
            if obj.sheet ~= nil then
                local hp = tonumber(obj.sheet.hp) or 0;
                local dmg = tonumber(obj.sheet.hpInput) or 0;
                hp = hp - dmg;
                if hp < 0 then hp = 0; end
                obj.sheet.hp = hp;
                obj.sheet.hpInput = "";
            end
        end
    );

    obj._e1 = obj.btnHeal:addEventListener("onClick",
        function()
            if obj.sheet ~= nil then
                local hp = tonumber(obj.sheet.hp) or 0;
                local heal = tonumber(obj.sheet.hpInput) or 0;
                hp = hp + heal;
                obj.sheet.hp = hp;
                obj.sheet.hpInput = "";
            end
        end
    );

    return obj;
end

function newfrmMonster()
    local retObj = constructNew_frmMonster();
    return retObj;
end

local _frmMonster = {
    newEditor = newfrmMonster,
    new = newfrmMonster,
    name = "frmMonster",
    formType = "sheetTemplate",
    dataType = "br.com.mineBR55.mob",
    title = "Ficha de Mob"
};

return _frmMonster;