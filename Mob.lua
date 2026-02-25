require("firecast.lua")
local GUI = require("gui.lua")

local function constructNew_frmMob()
    local obj = GUI.fromHandle(_obj_newObject("form"))
    obj:setName("frmMob")

    local sheet = nil

    -- CORRETO: usa ponto, não dois pontos
    obj.setNodeObject = function(self, nodeObject)
        sheet = nodeObject
        self.sheet = nodeObject
    end

    _gui_assignInitialParentForForm(obj.handle)

    ---------------------------------------------------
    -- FUNÇÃO DE CÁLCULO DE MODIFICADOR
    ---------------------------------------------------
    local function calcularMod(valor)
        valor = tonumber(valor) or 0
        return math.floor((valor - 10) / 2)
    end

    ---------------------------------------------------
    -- DATALINK ATRIBUTOS
    ---------------------------------------------------
    local dataLinkAtributos = GUI.fromHandle(_obj_newObject("dataLink"))
    dataLinkAtributos:setParent(obj)
    dataLinkAtributos:setFields({
        "forca","destreza","constituicao",
        "inteligencia","sabedoria","carisma"
    })

    dataLinkAtributos.onChange = function()
        if sheet ~= nil then
            sheet.mod_forca        = calcularMod(sheet.forca)
            sheet.mod_destreza     = calcularMod(sheet.destreza)
            sheet.mod_constituicao = calcularMod(sheet.constituicao)
            sheet.mod_inteligencia = calcularMod(sheet.inteligencia)
            sheet.mod_sabedoria    = calcularMod(sheet.sabedoria)
            sheet.mod_carisma      = calcularMod(sheet.carisma)
        end
    end

    obj.destroy = function(self)
        if dataLinkAtributos ~= nil then
            dataLinkAtributos:destroy()
            dataLinkAtributos = nil
        end

        if self.handle ~= 0 then
            _obj_deleteObject(self.handle)
        end
    end

    return obj
end

local _frmMob = {
    newEditor = constructNew_frmMob,
    new = constructNew_frmMob,
    name = "frmMob",
    formType = "sheetTemplate",
    formComponentName = "form",
    title = "Mob"
}

Firecast.registrarForm(_frmMob)

return _frmMob