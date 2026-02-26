require("firecast.lua");
local GUI = require("gui.lua");

local function calcularMod(valor)
    valor = tonumber(valor) or 0
    return math.floor((valor - 10) / 2)
end

local function newfrmMob()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    obj:setName("frmMob");

    local sheet = nil;

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
    end;

    local function atualizar()
        if sheet ~= nil then
            sheet.mod_forca = calcularMod(sheet.forca)
            sheet.mod_destreza = calcularMod(sheet.destreza)
            sheet.mod_constituicao = calcularMod(sheet.constituicao)
            sheet.mod_inteligencia = calcularMod(sheet.inteligencia)
            sheet.mod_sabedoria = calcularMod(sheet.sabedoria)
            sheet.mod_carisma = calcularMod(sheet.carisma)
        end
    end

    obj:addEventListener("onNodeReady",
        function()
            atualizar();
        end);

    obj:addEventListener("onNodeChanged",
        function()
            atualizar();
        end);

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy()
        if self._oldLFMDestroy then
            self:_oldLFMDestroy();
        end;
    end;

    return obj;
end;

local _frmMob = {
    newEditor = newfrmMob,
    new = newfrmMob,
    name = "frmMob",
    dataType = "br.com.mineBR55.mob",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Mob"
};

Firecast.registrarForm(_frmMob);

return _frmMob;