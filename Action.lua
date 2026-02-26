require("firecast.lua");
local GUI = require("gui.lua");

local function newfrmAction()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmAction");
    return obj;
end;

local _frmAction = {
    newEditor = newfrmAction,
    new = newfrmAction,
    name = "frmAction",
    dataType = "",
    formType = "undefined",
    formComponentName = "form"};

Firecast.registrarForm(_frmAction);

return _frmAction;