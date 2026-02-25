require("firecast.lua");
require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("ndb.lua");

local function newFrmMonster()
    local self = GUI.fromHandle(_obj_newObject("form"));
    self:setName("frmMonster");

    function self:setNodeObject(nodeObject)
        self.sheet = nodeObject;
    end

    function self:getNodeObject()
        return self.sheet;
    end

    local function calcMod(valor)
        valor = tonumber(valor) or 10
        return math.floor((valor - 10) / 2)
    end

    self._e_event0 = self:addEventListener("onNodeReady",
        function()
            if self.sheet ~= nil then
                self.sheet.mod_forca = calcMod(self.sheet.forca)
                self.sheet.mod_destreza = calcMod(self.sheet.destreza)
                self.sheet.mod_constituicao = calcMod(self.sheet.constituicao)
                self.sheet.mod_inteligencia = calcMod(self.sheet.inteligencia)
                self.sheet.mod_sabedoria = calcMod(self.sheet.sabedoria)
                self.sheet.mod_carisma = calcMod(self.sheet.carisma)
            end
        end);

    return self;
end

local _frmMonster = {
    newEditor = newFrmMonster,
    new = newFrmMonster,
    name = "frmMonster",
    dataType = "br.com.mineBR55.mob",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Ficha de Mob"
};

Firecast.registrarForm(_frmMonster);

return _frmMonster;