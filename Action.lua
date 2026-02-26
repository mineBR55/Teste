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