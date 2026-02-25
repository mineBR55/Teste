require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");

local frmAction = {};

function frmAction.new()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmAction");

    local sheet = nil;

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end

    obj._e0 = obj.btnRolar:addEventListener("onClick",
        function()
            if sheet ~= nil then
                local dado = sheet.dado or "1d20";
                local mod = sheet.mod or "0";
                Firecast.interpretarRolagem(
                    Firecast.getMesaDe(sheet),
                    dado .. " + " .. mod,
                    sheet.nome or "Ação"
                );
            end
        end);

    return obj;
end

frmAction = {
    newEditor = function() return frmAction.new() end,
    new = function() return frmAction.new() end,
    name = "frmAction"
};

return frmAction;