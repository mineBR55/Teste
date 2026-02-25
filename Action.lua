require("firecast.lua");
require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("ndb.lua");

local function newFrmAction()
    local self = GUI.fromHandle(_obj_newObject("form"));
    self:setName("frmAction");

    function self:setNodeObject(nodeObject)
        self.sheet = nodeObject;
    end

    function self:getNodeObject()
        return self.sheet;
    end

    -- Botão de rolar ataque
    self._e_event0 = self:addEventListener("onClick",
        function(event)
            if event.source.name == "btnRoll" then
                if self.sheet ~= nil then
                    local mesa = Firecast.getMesaDe(self.sheet);
                    local rolagem = (self.sheet.bonus or "0") .. " + " .. (self.sheet.dano or "0");

                    if mesa ~= nil then
                        mesa.chat:rolarDados(rolagem, self.sheet.nome or "Ataque");
                    end
                end
            end
        end);

    return self;
end

local _frmAction = {
    newEditor = newFrmAction,
    new = newFrmAction,
    name = "frmAction",
    dataType = "",
    formType = "undefined",
    formComponentName = "form"
};

Firecast.registrarForm(_frmAction);

return _frmAction;