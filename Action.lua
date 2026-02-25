require("firecast.lua")
local GUI = require("gui.lua")

local function constructNew_frmAction()
    local obj = GUI.fromHandle(_obj_newObject("form"))
    obj:setName("frmAction")

    local sheet = nil

    obj.setNodeObject = function(self, nodeObject)
        sheet = nodeObject
        self.sheet = nodeObject
    end

    _gui_assignInitialParentForForm(obj.handle)

    -------------------------------------------------
    -- BOTÃO ROLAR
    -------------------------------------------------
    local btnRolar = GUI.fromHandle(_obj_newObject("button"))
    btnRolar:setParent(obj)
    btnRolar:setText("Rolar")
    btnRolar:setAlign("right")
    btnRolar:setWidth(80)

    btnRolar.onClick = function()
        if sheet ~= nil then
            local mesa = Firecast.getMesaDe(sheet)
            if mesa ~= nil then
                local bonus = tonumber(sheet.bonusAtaque) or 0
                mesa.chat:rolarDados("1d20+" .. bonus,
                    sheet.nomeAcao or "Ataque")
            end
        end
    end

    obj.destroy = function(self)
        if btnRolar ~= nil then
            btnRolar:destroy()
            btnRolar = nil
        end

        if self.handle ~= 0 then
            _obj_deleteObject(self.handle)
        end
    end

    return obj
end

local _frmAction = {
    newEditor = constructNew_frmAction,
    new = constructNew_frmAction,
    name = "frmAction",
    formComponentName = "form"
}

Firecast.registrarForm(_frmAction)

return _frmAction