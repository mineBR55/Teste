require("firecast.lua");

local frmAction = {};

function frmAction.new()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmAction");

    local sheet = nil;

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        obj.sheet = nodeObject;
    end

    obj._e0 = obj.btnRolar:addEventListener("onClick",
        function()
            if sheet ~= nil then
                local exp = (sheet.dado or "1d20") .. "+" .. (sheet.mod or "0")
                Firecast.interpretarRolagem(
                    Firecast.getMesaDe(sheet),
                    exp,
                    sheet.nome or "Ação"
                );
            end
        end);

    return obj;
end

local _frmAction = {
    newEditor = function() return frmAction.new() end,
    new       = function() return frmAction.new() end,
    name      = "frmAction",
    dataType  = "br.com.mineBR55.mob.action",
    formType  = "undefined",
    formComponentName = "form"
};

Firecast.registrarForm(_frmAction);

return _frmAction;