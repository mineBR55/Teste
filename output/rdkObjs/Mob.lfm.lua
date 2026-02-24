require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_frmMonster()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", obj.setNodeObject);

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
        self:_oldSetNodeObjectFunction(nodeObject);
    end;

    function obj:setNodeDatabase(nodeObject)
        self:setNodeObject(nodeObject);
    end;

    _gui_assignInitialParentForForm(obj.handle);
    obj:beginUpdate();
    obj:setName("frmMonster");
    obj:setWidth(650);
    obj:setHeight(750);
    obj:setTheme("dark");

    obj.dataScopeBox1 = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.dataScopeBox1:setParent(obj);
    obj.dataScopeBox1:setName("dataScopeBox1");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj);
    obj.scrollBox1:setAlign("client");
    obj.scrollBox1:setName("scrollBox1");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.scrollBox1);
    obj.label1:setText("MONSTRO");
    obj.label1:setFontSize(18);
    obj.label1:setFontColor("#FFFFFF");
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.scrollBox1);
    obj.edit1:setField("name");
    obj.edit1:setWidth(500);
    obj.edit1:setHeight(30);
    obj.edit1:setTransparent(true);
    obj.edit1:setName("edit1");

    obj.horzLine1 = GUI.fromHandle(_obj_newObject("horzLine"));
    obj.horzLine1:setParent(obj.scrollBox1);
    obj.horzLine1:setStrokeColor("#666666");
    obj.horzLine1:setStrokeSize(2);
    obj.horzLine1:setName("horzLine1");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.scrollBox1);
    obj.label2:setText("DEFESA");
    obj.label2:setFontSize(14);
    obj.label2:setFontColor("#FFAA00");
    obj.label2:setName("label2");

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj.scrollBox1);
    obj.flowLayout1:setOrientation("horizontal");
    obj.flowLayout1:setHeight(30);
    obj.flowLayout1:setName("flowLayout1");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.flowLayout1);
    obj.label3:setText("AC:");
    obj.label3:setWidth(40);
    obj.label3:setName("label3");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.flowLayout1);
    obj.edit2:setField("ac");
    obj.edit2:setWidth(50);
    obj.edit2:setTransparent(true);
    obj.edit2:setName("edit2");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.flowLayout1);
    obj.label4:setText("HP:");
    obj.label4:setWidth(50);
    obj.label4:setName("label4");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.flowLayout1);
    obj.edit3:setField("hp");
    obj.edit3:setWidth(60);
    obj.edit3:setTransparent(true);
    obj.edit3:setName("edit3");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.flowLayout1);
    obj.label5:setText("/");
    obj.label5:setWidth(20);
    obj.label5:setName("label5");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.flowLayout1);
    obj.edit4:setField("hpMax");
    obj.edit4:setWidth(60);
    obj.edit4:setTransparent(true);
    obj.edit4:setName("edit4");

    obj.flowLayout2 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout2:setParent(obj.scrollBox1);
    obj.flowLayout2:setOrientation("horizontal");
    obj.flowLayout2:setHeight(30);
    obj.flowLayout2:setName("flowLayout2");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.flowLayout2);
    obj.edit5:setField("hpInput");
    obj.edit5:setWidth(200);
    obj.edit5:setTransparent(true);
    obj.edit5:setName("edit5");

    obj.btnDamage = GUI.fromHandle(_obj_newObject("button"));
    obj.btnDamage:setParent(obj.flowLayout2);
    obj.btnDamage:setName("btnDamage");
    obj.btnDamage:setText("Dano");
    obj.btnDamage:setWidth(60);
    obj.btnDamage:setHeight(25);

    obj.btnHeal = GUI.fromHandle(_obj_newObject("button"));
    obj.btnHeal:setParent(obj.flowLayout2);
    obj.btnHeal:setName("btnHeal");
    obj.btnHeal:setText("Cura");
    obj.btnHeal:setWidth(60);
    obj.btnHeal:setHeight(25);

    function obj:_releaseEvents()
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.flowLayout2 ~= nil then self.flowLayout2:destroy(); self.flowLayout2 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.btnDamage ~= nil then self.btnDamage:destroy(); self.btnDamage = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.dataScopeBox1 ~= nil then self.dataScopeBox1:destroy(); self.dataScopeBox1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.btnHeal ~= nil then self.btnHeal:destroy(); self.btnHeal = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.horzLine1 ~= nil then self.horzLine1:destroy(); self.horzLine1 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newfrmMonster()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_frmMonster();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _frmMonster = {
    newEditor = newfrmMonster, 
    new = newfrmMonster, 
    name = "frmMonster", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "", 
    description=""};

frmMonster = _frmMonster;
Firecast.registrarForm(_frmMonster);

return _frmMonster;
