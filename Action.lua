require("firecast.lua");
require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("ndb.lua");

local function rollDice(expr, label, sheet)
    local mesa = nil
    if sheet ~= nil then
        mesa = Firecast.getMesaDe(sheet)
    end

    if mesa ~= nil then
        Firecast.interpretarRolagem(mesa, expr, label)
    else
        Dialogs.showMessage("Não foi possível rolar os dados.")
    end
end

local function newFrmAction()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmAction");

    function obj:setNodeObject(nodeObject)
        rawset(obj, "sheet", nodeObject);
    end

    function obj:getNodeObject()
        return rawget(obj, "sheet");
    end

    obj._e0 = obj:addEventListener("onClick",
        function(event)
            if event.source and event.source.name == "btnRoll" then
                local sheet = obj.sheet
                if sheet == nil then return end

                local attackType = sheet.tipoRolagem or "1d20"
                local bonus      = sheet.bonus or "0"
                local dano       = sheet.dano or "1d6"

                -- Rolagem de ataque
                rollDice(attackType .. "+" .. bonus,
                         "Ataque: " .. (sheet.nome or "Ação"),
                         sheet)

                -- Rolagem de dano
                rollDice(dano,
                         "Dano: " .. (sheet.nome or "Ação"),
                         sheet)
            end
        end);

    return obj;
end

local _frmAction = {
    newEditor = newFrmAction,
    new       = newFrmAction,
    name      = "frmAction",
    dataType  = "",
    formType  = "undefined",
    formComponentName = "form"
}

Firecast.registrarForm(_frmAction)

return _frmAction