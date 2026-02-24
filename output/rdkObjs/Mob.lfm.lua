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
    obj.scrollBox1:setLeft(10);
    obj.scrollBox1:setTop(10);
    obj.scrollBox1:setRight(10);
    obj.scrollBox1:setBottom(10);
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
    obj.edit1:setFontColor("#FFFFFF");
    obj.edit1:setTransparent(true);
    obj.edit1:setHint("Nome");
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
    obj.label3:setFontColor("#FFFFFF");
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
    obj.label4:setWidth(60);
    obj.label4:setFontColor("#FF4444");
    obj.label4:setLeft(20);
    obj.label4:setName("label4");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.flowLayout1);
    obj.edit3:setField("hp");
    obj.edit3:setWidth(60);
    obj.edit3:setFontColor("#FF4444");
    obj.edit3:setTransparent(true);
    obj.edit3:setName("edit3");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.flowLayout1);
    obj.label5:setText("/");
    obj.label5:setWidth(20);
    obj.label5:setFontColor("#FFFFFF");
    obj.label5:setName("label5");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.flowLayout1);
    obj.edit4:setField("hpMax");
    obj.edit4:setWidth(60);
    obj.edit4:setFontColor("#AAAAAA");
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
    obj.edit5:setHint("Valor dano/cura");
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

    obj.horzLine2 = GUI.fromHandle(_obj_newObject("horzLine"));
    obj.horzLine2:setParent(obj.scrollBox1);
    obj.horzLine2:setStrokeColor("#666666");
    obj.horzLine2:setStrokeSize(1);
    obj.horzLine2:setName("horzLine2");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.scrollBox1);
    obj.label6:setText("MULTIATTACK");
    obj.label6:setFontSize(14);
    obj.label6:setFontColor("#FFAA00");
    obj.label6:setName("label6");

    obj.flowLayout3 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout3:setParent(obj.scrollBox1);
    obj.flowLayout3:setOrientation("horizontal");
    obj.flowLayout3:setHeight(30);
    obj.flowLayout3:setName("flowLayout3");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.flowLayout3);
    obj.label7:setText("Ataques:");
    obj.label7:setWidth(70);
    obj.label7:setFontColor("#FFFFFF");
    obj.label7:setName("label7");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.flowLayout3);
    obj.edit6:setField("multiCount");
    obj.edit6:setWidth(50);
    obj.edit6:setTransparent(true);
    obj.edit6:setName("edit6");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.flowLayout3);
    obj.label8:setText("Bonus:");
    obj.label8:setWidth(60);
    obj.label8:setFontColor("#FFFFFF");
    obj.label8:setLeft(10);
    obj.label8:setName("label8");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.flowLayout3);
    obj.edit7:setField("multiBonus");
    obj.edit7:setWidth(50);
    obj.edit7:setTransparent(true);
    obj.edit7:setName("edit7");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.flowLayout3);
    obj.label9:setText("Dano:");
    obj.label9:setWidth(50);
    obj.label9:setFontColor("#FFFFFF");
    obj.label9:setLeft(10);
    obj.label9:setName("label9");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.flowLayout3);
    obj.edit8:setField("multiDamage");
    obj.edit8:setWidth(100);
    obj.edit8:setTransparent(true);
    obj.edit8:setName("edit8");

    obj.btnMulti = GUI.fromHandle(_obj_newObject("button"));
    obj.btnMulti:setParent(obj.flowLayout3);
    obj.btnMulti:setName("btnMulti");
    obj.btnMulti:setText("Atacar");
    obj.btnMulti:setWidth(60);
    obj.btnMulti:setHeight(25);
    obj.btnMulti:setLeft(10);

    obj.horzLine3 = GUI.fromHandle(_obj_newObject("horzLine"));
    obj.horzLine3:setParent(obj.scrollBox1);
    obj.horzLine3:setStrokeColor("#666666");
    obj.horzLine3:setStrokeSize(1);
    obj.horzLine3:setName("horzLine3");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.scrollBox1);
    obj.label10:setText("SAVES");
    obj.label10:setFontSize(14);
    obj.label10:setFontColor("#FFAA00");
    obj.label10:setName("label10");

    obj.flowLayout4 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout4:setParent(obj.scrollBox1);
    obj.flowLayout4:setOrientation("horizontal");
    obj.flowLayout4:setHeight(30);
    obj.flowLayout4:setName("flowLayout4");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.flowLayout4);
    obj.label11:setText("Atrib:");
    obj.label11:setWidth(50);
    obj.label11:setFontColor("#FFFFFF");
    obj.label11:setName("label11");

    obj.cmbSaveStat = GUI.fromHandle(_obj_newObject("comboBox"));
    obj.cmbSaveStat:setParent(obj.flowLayout4);
    obj.cmbSaveStat:setName("cmbSaveStat");
    obj.cmbSaveStat:setField("saveStat");
    obj.cmbSaveStat:setWidth(60);
    obj.cmbSaveStat:setHeight(25);

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.flowLayout4);
    obj.label12:setText("CD:");
    obj.label12:setWidth(40);
    obj.label12:setFontColor("#FFFFFF");
    obj.label12:setLeft(10);
    obj.label12:setName("label12");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.flowLayout4);
    obj.edit9:setField("saveDC");
    obj.edit9:setWidth(50);
    obj.edit9:setTransparent(true);
    obj.edit9:setName("edit9");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.flowLayout4);
    obj.label13:setText("Qtd:");
    obj.label13:setWidth(40);
    obj.label13:setFontColor("#FFFFFF");
    obj.label13:setLeft(10);
    obj.label13:setName("label13");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.flowLayout4);
    obj.edit10:setField("saveCount");
    obj.edit10:setWidth(50);
    obj.edit10:setTransparent(true);
    obj.edit10:setName("edit10");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.flowLayout4);
    obj.label14:setText("Mod:");
    obj.label14:setWidth(40);
    obj.label14:setFontColor("#FFFFFF");
    obj.label14:setLeft(10);
    obj.label14:setName("label14");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.flowLayout4);
    obj.edit11:setField("saveMod");
    obj.edit11:setWidth(50);
    obj.edit11:setTransparent(true);
    obj.edit11:setName("edit11");

    obj.btnSaves = GUI.fromHandle(_obj_newObject("button"));
    obj.btnSaves:setParent(obj.flowLayout4);
    obj.btnSaves:setName("btnSaves");
    obj.btnSaves:setText("Rolar");
    obj.btnSaves:setWidth(60);
    obj.btnSaves:setHeight(25);
    obj.btnSaves:setLeft(10);

    obj.horzLine4 = GUI.fromHandle(_obj_newObject("horzLine"));
    obj.horzLine4:setParent(obj.scrollBox1);
    obj.horzLine4:setStrokeColor("#666666");
    obj.horzLine4:setStrokeSize(1);
    obj.horzLine4:setName("horzLine4");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.scrollBox1);
    obj.label15:setText("ACOES LENDARIAS");
    obj.label15:setFontSize(14);
    obj.label15:setFontColor("#FF6666");
    obj.label15:setName("label15");

    obj.flowLayout5 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout5:setParent(obj.scrollBox1);
    obj.flowLayout5:setOrientation("horizontal");
    obj.flowLayout5:setHeight(30);
    obj.flowLayout5:setName("flowLayout5");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.flowLayout5);
    obj.label16:setText("Atual:");
    obj.label16:setWidth(60);
    obj.label16:setFontColor("#FFFFFF");
    obj.label16:setName("label16");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.flowLayout5);
    obj.edit12:setField("legendaryCurrent");
    obj.edit12:setWidth(50);
    obj.edit12:setTransparent(true);
    obj.edit12:setName("edit12");

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.flowLayout5);
    obj.label17:setText("/");
    obj.label17:setWidth(20);
    obj.label17:setFontColor("#FFFFFF");
    obj.label17:setName("label17");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.flowLayout5);
    obj.edit13:setField("legendaryMax");
    obj.edit13:setWidth(50);
    obj.edit13:setFontColor("#AAAAAA");
    obj.edit13:setTransparent(true);
    obj.edit13:setName("edit13");

    obj.btnSpendLegendary = GUI.fromHandle(_obj_newObject("button"));
    obj.btnSpendLegendary:setParent(obj.flowLayout5);
    obj.btnSpendLegendary:setName("btnSpendLegendary");
    obj.btnSpendLegendary:setText("Gastar");
    obj.btnSpendLegendary:setWidth(70);
    obj.btnSpendLegendary:setHeight(25);
    obj.btnSpendLegendary:setLeft(20);

    obj.btnResetLegendary = GUI.fromHandle(_obj_newObject("button"));
    obj.btnResetLegendary:setParent(obj.flowLayout5);
    obj.btnResetLegendary:setName("btnResetLegendary");
    obj.btnResetLegendary:setText("Reset");
    obj.btnResetLegendary:setWidth(70);
    obj.btnResetLegendary:setHeight(25);

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
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.btnDamage ~= nil then self.btnDamage:destroy(); self.btnDamage = nil; end;
        if self.horzLine3 ~= nil then self.horzLine3:destroy(); self.horzLine3 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.flowLayout4 ~= nil then self.flowLayout4:destroy(); self.flowLayout4 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.cmbSaveStat ~= nil then self.cmbSaveStat:destroy(); self.cmbSaveStat = nil; end;
        if self.btnHeal ~= nil then self.btnHeal:destroy(); self.btnHeal = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.btnResetLegendary ~= nil then self.btnResetLegendary:destroy(); self.btnResetLegendary = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.btnMulti ~= nil then self.btnMulti:destroy(); self.btnMulti = nil; end;
        if self.flowLayout3 ~= nil then self.flowLayout3:destroy(); self.flowLayout3 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.btnSpendLegendary ~= nil then self.btnSpendLegendary:destroy(); self.btnSpendLegendary = nil; end;
        if self.horzLine2 ~= nil then self.horzLine2:destroy(); self.horzLine2 = nil; end;
        if self.flowLayout5 ~= nil then self.flowLayout5:destroy(); self.flowLayout5 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.horzLine4 ~= nil then self.horzLine4:destroy(); self.horzLine4 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.dataScopeBox1 ~= nil then self.dataScopeBox1:destroy(); self.dataScopeBox1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.btnSaves ~= nil then self.btnSaves:destroy(); self.btnSaves = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.horzLine1 ~= nil then self.horzLine1:destroy(); self.horzLine1 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
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
