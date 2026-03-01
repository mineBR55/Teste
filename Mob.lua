require("firecast.lua");
require("ndb.lua");

local function num(v)
    local n = tonumber(v);
    return n or 0;
end

local function isChecked(v)
    return (v == true) or (v == "true") or (v == 1);
end

local function mod(score)
    return math.floor((num(score) - 10) / 2);
end

local function signed(n)
    n = num(n);
    if n >= 0 then
        return "+" .. tostring(n);
    else
        return tostring(n);
    end
end

local function clamp(n, a, b)
    n = num(n);
    if n < a then return a end
    if n > b then return b end
    return n
end

local function getSheetFromAny(anyNode)
    if anyNode == nil then
        return rawget(_G, "sheet");
    end

    if anyNode.nome ~= nil or anyNode.cr ~= nil or anyNode.forca ~= nil or anyNode.attacks ~= nil then
        return anyNode;
    end

    local p = anyNode;
    for i = 1, 60 do
        if p == nil then break end;
        if p.nome ~= nil or p.cr ~= nil or p.forca ~= nil or p.attacks ~= nil then
            return p;
        end
        p = p.parent;
    end

    return rawget(_G, "sheet");
end

function buildD20(bonus)
    bonus = num(bonus);
    if bonus >= 0 then
        return "1d20 + " .. tostring(bonus);
    else
        return "1d20 - " .. tostring(math.abs(bonus));
    end
end

function rollBonus(title, bonus)
    local sh = rawget(_G, "sheet");
    if sh == nil then return end
    local mesa = Firecast.getMesaDe(sh);
    if mesa ~= nil and mesa.chat ~= nil then
        mesa.chat:rolarDados(Firecast.interpretarRolagem(buildD20(bonus)), title);
    end
end

function resolveExpr(expr)
    expr = tostring(expr or "");
    local sh = rawget(_G, "sheet");
    if sh == nil then return expr end

    local pb = num(sh.prof_bonus_num);
    local map = {
        STR = num(sh.mod_forca_num),
        DEX = num(sh.mod_destreza_num),
        CON = num(sh.mod_constituicao_num),
        INT = num(sh.mod_inteligencia_num),
        WIS = num(sh.mod_sabedoria_num),
        CHA = num(sh.mod_carisma_num),
        PB  = pb
    };

    for k, v in pairs(map) do
        expr = expr:gsub("%f[%w_]" .. k .. "%f[^%w_]", tostring(v));
    end

    return expr;
end

function rollExpr(title, expr)
    local sh = rawget(_G, "sheet");
    if sh == nil then return end
    local mesa = Firecast.getMesaDe(sh);
    if mesa ~= nil and mesa.chat ~= nil then
        local resolved = resolveExpr(expr);
        mesa.chat:rolarDados(Firecast.interpretarRolagem(resolved), title .. " (" .. resolved .. ")");
    end
end

local function parseCR(v)
    local s = tostring(v or ""):gsub("%s+", "");
    if s == "" then return 0 end

    local a, b = s:match("^(%d+)%/(%d+)$");
    if a and b then
        local na, nb = tonumber(a), tonumber(b);
        if na and nb and nb ~= 0 then
            return na / nb;
        end
    end

    return tonumber(s) or 0;
end

local function pbFromCR(cr)
    if cr >= 29 then return 9 end
    if cr >= 25 then return 8 end
    if cr >= 21 then return 7 end
    if cr >= 17 then return 6 end
    if cr >= 13 then return 5 end
    if cr >= 9  then return 4 end
    if cr >= 5  then return 3 end
    return 2
end

local function forceProfIfExp(sh, profField, expField)
    if isChecked(sh[expField]) and not isChecked(sh[profField]) then
        sh[profField] = true;
    end
end

local function calcTotal(sh, baseModNum, profField, expField, miscField)
    local pb = num(sh.prof_bonus_num);
    local misc = num(sh[miscField]);
    local add = 0;

    if isChecked(sh[profField]) then add = add + pb end
    if isChecked(sh[expField])  then add = add + pb end

    return num(baseModNum) + misc + add;
end

function recalcAll()
    local sh = rawget(_G, "sheet");
    if sh == nil then return end

    local crVal = parseCR(sh.cr);
    local pb = pbFromCR(crVal);

    sh.prof_bonus_num = pb;
    sh.prof_bonus = signed(pb);

    sh.mod_forca_num = mod(sh.forca);
    sh.mod_forca = signed(sh.mod_forca_num);

    sh.mod_destreza_num = mod(sh.destreza);
    sh.mod_destreza = signed(sh.mod_destreza_num);

    sh.mod_constituicao_num = mod(sh.constituicao);
    sh.mod_constituicao = signed(sh.mod_constituicao_num);

    sh.mod_inteligencia_num = mod(sh.inteligencia);
    sh.mod_inteligencia = signed(sh.mod_inteligencia_num);

    sh.mod_sabedoria_num = mod(sh.sabedoria);
    sh.mod_sabedoria = signed(sh.mod_sabedoria_num);

    sh.mod_carisma_num = mod(sh.carisma);
    sh.mod_carisma = signed(sh.mod_carisma_num);

    forceProfIfExp(sh, "sv_str_prof", "sv_str_exp")
    sh.sv_str_total_num = calcTotal(sh, sh.mod_forca_num, "sv_str_prof", "sv_str_exp", "sv_str_misc")
    sh.sv_str_total = signed(sh.sv_str_total_num)

    forceProfIfExp(sh, "sv_dex_prof", "sv_dex_exp")
    sh.sv_dex_total_num = calcTotal(sh, sh.mod_destreza_num, "sv_dex_prof", "sv_dex_exp", "sv_dex_misc")
    sh.sv_dex_total = signed(sh.sv_dex_total_num)

    forceProfIfExp(sh, "sv_con_prof", "sv_con_exp")
    sh.sv_con_total_num = calcTotal(sh, sh.mod_constituicao_num, "sv_con_prof", "sv_con_exp", "sv_con_misc")
    sh.sv_con_total = signed(sh.sv_con_total_num)

    forceProfIfExp(sh, "sv_int_prof", "sv_int_exp")
    sh.sv_int_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sv_int_prof", "sv_int_exp", "sv_int_misc")
    sh.sv_int_total = signed(sh.sv_int_total_num)

    forceProfIfExp(sh, "sv_wis_prof", "sv_wis_exp")
    sh.sv_wis_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sv_wis_prof", "sv_wis_exp", "sv_wis_misc")
    sh.sv_wis_total = signed(sh.sv_wis_total_num)

    forceProfIfExp(sh, "sv_cha_prof", "sv_cha_exp")
    sh.sv_cha_total_num = calcTotal(sh, sh.mod_carisma_num, "sv_cha_prof", "sv_cha_exp", "sv_cha_misc")
    sh.sv_cha_total = signed(sh.sv_cha_total_num)

    forceProfIfExp(sh, "sk_initiative_prof", "sk_initiative_exp")
    sh.sk_initiative_total_num = calcTotal(sh, sh.mod_destreza_num, "sk_initiative_prof", "sk_initiative_exp", "sk_initiative_misc")
    sh.sk_initiative_total = signed(sh.sk_initiative_total_num)

    forceProfIfExp(sh, "sk_athletics_prof", "sk_athletics_exp")
    sh.sk_athletics_total_num = calcTotal(sh, sh.mod_forca_num, "sk_athletics_prof", "sk_athletics_exp", "sk_athletics_misc")
    sh.sk_athletics_total = signed(sh.sk_athletics_total_num)

    forceProfIfExp(sh, "sk_acrobatics_prof", "sk_acrobatics_exp")
    sh.sk_acrobatics_total_num = calcTotal(sh, sh.mod_destreza_num, "sk_acrobatics_prof", "sk_acrobatics_exp", "sk_acrobatics_misc")
    sh.sk_acrobatics_total = signed(sh.sk_acrobatics_total_num)

    forceProfIfExp(sh, "sk_sleight_prof", "sk_sleight_exp")
    sh.sk_sleight_total_num = calcTotal(sh, sh.mod_destreza_num, "sk_sleight_prof", "sk_sleight_exp", "sk_sleight_misc")
    sh.sk_sleight_total = signed(sh.sk_sleight_total_num)

    forceProfIfExp(sh, "sk_stealth_prof", "sk_stealth_exp")
    sh.sk_stealth_total_num = calcTotal(sh, sh.mod_destreza_num, "sk_stealth_prof", "sk_stealth_exp", "sk_stealth_misc")
    sh.sk_stealth_total = signed(sh.sk_stealth_total_num)

    forceProfIfExp(sh, "sk_arcana_prof", "sk_arcana_exp")
    sh.sk_arcana_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sk_arcana_prof", "sk_arcana_exp", "sk_arcana_misc")
    sh.sk_arcana_total = signed(sh.sk_arcana_total_num)

    forceProfIfExp(sh, "sk_history_prof", "sk_history_exp")
    sh.sk_history_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sk_history_prof", "sk_history_exp", "sk_history_misc")
    sh.sk_history_total = signed(sh.sk_history_total_num)

    forceProfIfExp(sh, "sk_investigation_prof", "sk_investigation_exp")
    sh.sk_investigation_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sk_investigation_prof", "sk_investigation_exp", "sk_investigation_misc")
    sh.sk_investigation_total = signed(sh.sk_investigation_total_num)

    forceProfIfExp(sh, "sk_nature_prof", "sk_nature_exp")
    sh.sk_nature_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sk_nature_prof", "sk_nature_exp", "sk_nature_misc")
    sh.sk_nature_total = signed(sh.sk_nature_total_num)

    forceProfIfExp(sh, "sk_religion_prof", "sk_religion_exp")
    sh.sk_religion_total_num = calcTotal(sh, sh.mod_inteligencia_num, "sk_religion_prof", "sk_religion_exp", "sk_religion_misc")
    sh.sk_religion_total = signed(sh.sk_religion_total_num)

    forceProfIfExp(sh, "sk_animal_prof", "sk_animal_exp")
    sh.sk_animal_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sk_animal_prof", "sk_animal_exp", "sk_animal_misc")
    sh.sk_animal_total = signed(sh.sk_animal_total_num)

    forceProfIfExp(sh, "sk_insight_prof", "sk_insight_exp")
    sh.sk_insight_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sk_insight_prof", "sk_insight_exp", "sk_insight_misc")
    sh.sk_insight_total = signed(sh.sk_insight_total_num)

    forceProfIfExp(sh, "sk_medicine_prof", "sk_medicine_exp")
    sh.sk_medicine_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sk_medicine_prof", "sk_medicine_exp", "sk_medicine_misc")
    sh.sk_medicine_total = signed(sh.sk_medicine_total_num)

    forceProfIfExp(sh, "sk_perception_prof", "sk_perception_exp")
    sh.sk_perception_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sk_perception_prof", "sk_perception_exp", "sk_perception_misc")
    sh.sk_perception_total = signed(sh.sk_perception_total_num)

    forceProfIfExp(sh, "sk_survival_prof", "sk_survival_exp")
    sh.sk_survival_total_num = calcTotal(sh, sh.mod_sabedoria_num, "sk_survival_prof", "sk_survival_exp", "sk_survival_misc")
    sh.sk_survival_total = signed(sh.sk_survival_total_num)

    forceProfIfExp(sh, "sk_deception_prof", "sk_deception_exp")
    sh.sk_deception_total_num = calcTotal(sh, sh.mod_carisma_num, "sk_deception_prof", "sk_deception_exp", "sk_deception_misc")
    sh.sk_deception_total = signed(sh.sk_deception_total_num)

    forceProfIfExp(sh, "sk_intimidation_prof", "sk_intimidation_exp")
    sh.sk_intimidation_total_num = calcTotal(sh, sh.mod_carisma_num, "sk_intimidation_prof", "sk_intimidation_exp", "sk_intimidation_misc")
    sh.sk_intimidation_total = signed(sh.sk_intimidation_total_num)

    forceProfIfExp(sh, "sk_performance_prof", "sk_performance_exp")
    sh.sk_performance_total_num = calcTotal(sh, sh.mod_carisma_num, "sk_performance_prof", "sk_performance_exp", "sk_performance_misc")
    sh.sk_performance_total = signed(sh.sk_performance_total_num)

    forceProfIfExp(sh, "sk_persuasion_prof", "sk_persuasion_exp")
    sh.sk_persuasion_total_num = calcTotal(sh, sh.mod_carisma_num, "sk_persuasion_prof", "sk_persuasion_exp", "sk_persuasion_misc")
    sh.sk_persuasion_total = signed(sh.sk_persuasion_total_num)

    sh.percepcao_passiva = tostring(10 + num(sh.sk_perception_total_num));

    if sh.hp_max ~= nil and sh.hp_atual ~= nil then
        local maxHP = num(sh.hp_max);
        local curHP = num(sh.hp_atual);
        if maxHP > 0 then
            sh.hp_atual = tostring(clamp(curHP, 0, maxHP));
        end
    end
end

local function normalizeBonusText(txt)
    txt = tostring(txt or ""):gsub("%s+", "");
    if txt == "" then txt = "0" end
    if txt:sub(1, 1) == "+" then
        txt = txt:sub(2);
        if txt == "" then txt = "0" end
    end
    return txt;
end

local function doubleDiceOnly(expr)
    expr = tostring(expr or ""):gsub("%s+", "");
    if expr == "" then return "0" end

    local function repl(nStr, faceStr)
        local n = tonumber(nStr);
        if n == nil or nStr == "" then n = 1 end
        return tostring(n * 2) .. "d" .. faceStr;
    end

    return expr:gsub("(%d*)d(%d+)", repl);
end

local function getNaturalD20(rolado)
    if rolado == nil or rolado.ops == nil then return nil end

    for i = 1, #rolado.ops do
        local op = rolado.ops[i];
        if op ~= nil and op.tipo == "dado"
           and tostring(op.face) == "20"
           and op.resultados ~= nil
           and #op.resultados > 0 then
            return tonumber(op.resultados[1]);
        end
    end

    return nil;
end

function deleteAttack(node)
    if node ~= nil then
        NDB.deleteNode(node);
    end
end

function rollAttack(anyNode, attackNode)
    local sh = getSheetFromAny(anyNode);
    local node = attackNode or anyNode;

    if sh == nil or node == nil then
        showMessage("Sheet/node não encontrado (rollAttack).");
        return;
    end

    local mesa = Firecast.getMesaDe(sh);
    if mesa == nil or mesa.chat == nil then
        showMessage("Entre em uma mesa para rolar no chat.");
        return;
    end

    local atkName = tostring(node.name or "Ataque");
    local bonus   = normalizeBonusText(node.toHit);
    local dmg     = tostring(node.damage or "0");
    local dmgType = tostring(node.dmgType or "");

    local atkExpr = "1d20 + " .. bonus;

    mesa.chat:rolarDados(
        Firecast.interpretarRolagem(atkExpr),
        atkName .. " (Ataque)",
        function(rolado)
            local nat = getNaturalD20(rolado);

            if nat == 1 then
                mesa.chat:enviarMensagem("💀 FALHA CRÍTICA: " .. atkName .. " (1 natural)");
                return;
            end

            if nat == 20 then
                mesa.chat:enviarMensagem("🔥 CRÍTICO: " .. atkName .. " (20 natural) — dano dobrado!");
                local critExpr = doubleDiceOnly(dmg);
                mesa.chat:rolarDados(
                    Firecast.interpretarRolagem(critExpr),
                    atkName .. " (Dano CRÍTICO" .. (dmgType ~= "" and (": " .. dmgType) or "") .. ")"
                );
                return;
            end

            mesa.chat:rolarDados(
                Firecast.interpretarRolagem(dmg),
                atkName .. " (Dano" .. (dmgType ~= "" and (": " .. dmgType) or "") .. ")"
            );
        end
    );
end

_G.__num = num;
_G.__mod = mod;
_G.__signed = signed;
_G.__clamp = clamp;
_G.recalcAll = recalcAll;
_G.rollBonus = rollBonus;
_G.rollExpr = rollExpr;
_G.rollAttack = rollAttack;
_G.deleteAttack = deleteAttack;
