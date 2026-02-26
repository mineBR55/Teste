require("firecast.lua");
local rrpgObjs = require("rrpgObjs.lua");

local function calcularMod(valor)
    valor = tonumber(valor) or 0;
    return math.floor((valor - 10) / 2);
end;

local function newfrmMob()
    local obj = rrpgObjs.newObject("form");
    obj:setName("frmMob");

    local sheet = nil;

    obj:setNodeDatabase(nil);

    function obj:setNodeDatabase(node)
        sheet = node;
        self.sheet = node;
    end;

    local function atualizarMods()
        if sheet == nil then return end;

        sheet.mod_forca = calcularMod(sheet.forca);
        sheet.mod_destreza = calcularMod(sheet.destreza);
        sheet.mod_constituicao = calcularMod(sheet.constituicao);
        sheet.mod_inteligencia = calcularMod(sheet.inteligencia);
        sheet.mod_sabedoria = calcularMod(sheet.sabedoria);
        sheet.mod_carisma = calcularMod(sheet.carisma);
    end;

    obj._e1 = obj:addEventListener("onNodeReady",
        function ()
            atualizarMods();
        end);

    obj._e2 = obj:addEventListener("onNodeChanged",
        function (_, field)
            if field == "forca" or
               field == "destreza" or
               field == "constituicao" or
               field == "inteligencia" or
               field == "sabedoria" or
               field == "carisma" then
                atualizarMods();
            end;
        end);

    return obj;
end;

Firecast.registrarForm({
    newEditor = newfrmMob,
    new = newfrmMob,
    name = "frmMob",
    dataType = "br.com.mineBR55.mob",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Ficha Monstro DnD"
});