require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");

local frmMonster = {};

function frmMonster.new()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmMonster");

    local sheet = nil;

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end

    return obj;
end

local _frmMonster = {
    newEditor = function()
        return frmMonster.new();
    end,

    new = function()
        return frmMonster.new();
    end,

    name = "frmMonster",
    formType = "sheetTemplate",
    dataType = "br.com.mineBR55.mob",
    title = "Ficha de Mob",
    description = "Ficha de Monstro"
};

return _frmMonster;