require("firecast.lua");
require("ndb.lua");

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeBonus(txt)
  txt = trim(txt):gsub("%s+", "")
  if txt == "" then txt = "0" end
  if txt:sub(1,1) == "+" then
    txt = txt:sub(2)
    if txt == "" then txt = "0" end
  end
  return txt
end

local function doubleDice(expr)
  expr = tostring(expr or ""):gsub("%s+", "")
  if expr == "" then return "0" end
  local function repl(nStr, faceStr)
    local n = tonumber(nStr)
    if n == nil or nStr == "" then n = 1 end
    return tostring(n * 2) .. "d" .. faceStr
  end
  return expr:gsub("(%d*)d(%d+)", repl)
end

local function getNaturalD20(rolado)
  if rolado == nil or rolado.ops == nil then return nil end
  for i = 1, #rolado.ops do
    local op = rolado.ops[i]
    if op ~= nil and op.tipo == "dado" and tostring(op.face) == "20"
       and op.resultados ~= nil and #op.resultados > 0 then
      return tonumber(op.resultados[1])
    end
  end
  return nil
end

local function getSheetFromAny(anyNode)
  if anyNode == nil then
    return rawget(_G, "sheet")
  end

  -- se já for o sheet
  if anyNode.nome ~= nil or anyNode.cr ~= nil or anyNode.forca ~= nil or anyNode.attacks ~= nil then
    return anyNode
  end

  -- sobe parent
  local p = anyNode
  for i=1, 50 do
    if p == nil then break end
    if p.nome ~= nil or p.cr ~= nil or p.forca ~= nil or p.attacks ~= nil then
      return p
    end
    p = p.parent
  end

  return rawget(_G, "sheet")
end

-- =========================================================
-- AÇÕES (lista direta em sheet.attacks)
-- =========================================================

function addAttack(anyNode)
  local sheet = getSheetFromAny(anyNode)
  if sheet == nil then
    showMessage("addAttack: sheet nil (não achei a ficha).")
    return
  end

  -- LISTA DIRETA: cria o item como filho "attacks" do sheet
  local atk = NDB.createChildNode(sheet, "attacks")
  if atk == nil then
    showMessage("addAttack: falhou ao criar node attacks.")
    return
  end

  atk.name    = atk.name    or "Ataque"
  atk.toHit   = atk.toHit   or "0"
  atk.damage  = atk.damage  or "1d6+0"
  atk.dmgType = atk.dmgType or ""
  atk.notes   = atk.notes   or ""

  showMessage("Ataque criado!")
end

function deleteAttack(node)
  if node ~= nil then
    NDB.deleteNode(node)
  end
end

function rollAttack(anyNode, node)
  local sheet = getSheetFromAny(anyNode)
  if sheet == nil or node == nil then
    showMessage("Sheet/node não encontrado (rollAttack).")
    return
  end

  local mesa = Firecast.getMesaDe(sheet)
  if mesa == nil or mesa.chat == nil then
    showMessage("Entre em uma mesa para rolar no chat.")
    return
  end

  local atkName = tostring(node.name or "Ataque")
  local bonus   = normalizeBonus(node.toHit)
  local dmg     = tostring(node.damage or "0")
  local dmgType = tostring(node.dmgType or "")

  local atkExpr = "1d20 + " .. bonus

  mesa.chat:rolarDados(Firecast.interpretarRolagem(atkExpr), atkName .. " (Ataque)", function(rolado)
    local nat = getNaturalD20(rolado)

    if nat == 1 then
      mesa.chat:enviarMensagem("💀 FALHA CRÍTICA: " .. atkName .. " (1 natural)")
      return
    end

    if nat == 20 then
      mesa.chat:enviarMensagem("🔥 CRÍTICO: " .. atkName .. " (20 natural) — dano dobrado!")
      local critExpr = doubleDice(dmg)
      mesa.chat:rolarDados(Firecast.interpretarRolagem(critExpr),
        atkName .. " (Dano CRÍTICO" .. (dmgType ~= "" and (": " .. dmgType) or "") .. ")")
      return
    end

    mesa.chat:rolarDados(Firecast.interpretarRolagem(dmg),
      atkName .. " (Dano" .. (dmgType ~= "" and (": " .. dmgType) or "") .. ")")
  end)
end