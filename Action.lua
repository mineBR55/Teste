require("firecast.lua");
local GUI = require("gui.lua");

local function constructNew_frmAction()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmAction");
    return obj;
end;

local _frmAction = {
    newEditor = constructNew_frmAction,
    new = constructNew_frmAction,
    name = "frmAction",
    dataType = "",
    formType = "undefined",
    formComponentName = "form"
};

Firecast.registrarForm(_frmAction);
return _frmAction;