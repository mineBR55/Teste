require("firecast.lua");

local frmMonster = {};

function frmMonster.new()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmMonster");

    local sheet = nil;

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        obj.sheet = nodeObject;
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy()
        if self._oldLFMDestroy then
            self:_oldLFMDestroy();
        end;
    end;

    return obj;
end;

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
    formComponentName = "form",
    title = "Ficha de Mob",
    description = "Ficha simples de monstro"
};

Firecast.registrarForm(_frmMonster);

return _frmMonster;