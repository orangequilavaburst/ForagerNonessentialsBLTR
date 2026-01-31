-- ## CROSS-MOD COMPATIBILITY
local utdr_mod_exists = next(SMODS.find_mod("UTDR"))
local elle_mod_exists = next(SMODS.find_mod("ellejokers"))
local ortalab_mod_exists = next(SMODS.find_mod("ortalab"))

-- ## JOKERS

if utdr_mod_exists and J8MOD.config.enable_crossmod_jokers then
    -- PlayerFRIEND
    SMODS.Joker {
        key = "xUTDR_playerfriend",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 3,
        cost = 11,
        atlas = "j8jokers-dlc",
        pos = { x = 0, y = 0 },
        discovered = true,
        unlocked = true,
        config = { extra = { chips = -2, xmult = 0.05 } },
        dependencies = { "UTDR" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
            return { vars = { math.abs(card.ability.extra.chips), card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.base.nominal + (context.other_card.ability.perma_bonus or 0) > 0 then
                    context.other_card.ability.perma_bonus = math.max((context.other_card.ability.perma_bonus or 0) +
                        card.ability.extra.chips, -context.other_card.base.nominal)
                    context.other_card.ability.perma_x_mult = (context.other_card.ability.perma_x_mult or 0) +
                        card.ability.extra.xmult
                end
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT
                }
            end
        end,
        in_pool = function(self, args) -- just never fucking show up
            return false
        end
    }

    -- Gold Widow
    SMODS.Joker {
        key = "xUTDR_gold_widow",
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 1,
        cost = 6,
        atlas = "j8jokers-dlc",
        pos = { x = 1, y = 0 },
        discovered = true,
        unlocked = true,
        enhancement_gate = 'm_gold',
        config = { extra = { enhancement = 'm_gold', seal = 'Gold' } },
        dependencies = { "UTDR" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }), card.ability.extra.seal } }
        end,
        calculate = function(self, card, context)
            if context.after and not context.blueprint then
                local gold_cards = 0
                for _, scored_card in ipairs(context.scoring_hand) do
                    if SMODS.has_enhancement(scored_card, card.ability.extra.enhancement) then
                        gold_cards = gold_cards + 1
                        scored_card.vampired = true
                        scored_card:set_ability('c_base', nil, true)
                        scored_card:set_seal(card.ability.extra.seal)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                scored_card.vampired = nil
                                return true
                            end
                        }))
                    end
                end
                if gold_cards > 0 then
                    return {
                        message = localize('k_gold'),
                        colour = G.C.MONEY
                    }
                end
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_glass'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, "m_gold") then
                    return true
                end
            end
            return false
        end,
    }

    -- Mr. Sunshine and Abberant
    SMODS.Joker {
        key = "xUTDR_mr_sunshine_and_abberant",
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 1,
        cost = 5,
        atlas = "j8jokers-dlc",
        pos = { x = 2, y = 0 },
        discovered = true,
        unlocked = true,
        dependencies = { "UTDR" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS["c_strength"]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { localize { type = 'name_text', key = "c_strength", set = 'Tarot' }, localize { type = 'name_text', key = "p_arcana_normal", set = 'Other' } } }
        end,
    }

    -- Goner Kid
    SMODS.Joker {
        key = "xUTDR_goner_kid",
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 3,
        cost = 11,
        atlas = "j8jokers-dlc",
        pos = { x = 3, y = 0 },
        discovered = true,
        unlocked = true,
        dependencies = { "UTDR" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return {}
        end,
        calculate = function(self, card, context)
            if context.open_booster and not context.blueprint then
                if not context.card.draw_cards then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()

                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                end
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + 1
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - 1
        end
    }

    -- Tactical Dreemurr
    SMODS.Joker {
        key = "xUTDR_tactical_dreemurr",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 3,
        cost = 11,
        atlas = "j8jokers-dlc",
        pos = { x = 4, y = 0 },
        discovered = true,
        unlocked = true,
        dependencies = { "UTDR" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return {}
        end,
        calculate = function(self, card, context)
            if context.debuffed_hand or context.joker_main then
                if G.GAME.blind.triggered then
                    return {
                        message = localize("j8mod_tagged_ex"),
                        colour = G.C.GREEN,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = "immediate",
                                func = function()
                                    --- Credits to Eremel
                                    local tag_pool = get_current_pool('Tag')
                                    local selected_tag = pseudorandom_element(tag_pool, 'j8mod_tactical_dreemurr')
                                    local it = 1
                                    while selected_tag == 'UNAVAILABLE' do
                                        it = it + 1
                                        selected_tag = pseudorandom_element(tag_pool,
                                            'j8mod_tactical_dreemurr_resample' .. it)
                                    end
                                    local tag = Tag(selected_tag)
                                    if tag.name == "Orbital Tag" then
                                        local _poker_hands = {}
                                        for k, v in pairs(G.GAME.hands) do
                                            if v.visible then
                                                _poker_hands[#_poker_hands + 1] = k
                                            end
                                        end
                                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands,
                                            "j8mod_tactical_dreemurr_orbital_tag")
                                    end
                                    tag:set_ability()
                                    add_tag(tag)
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end,
        check_for_unlock = function(self, args)
            return args.type == 'round_win' and G.GAME.current_round.hands_played == 1 and
                G.GAME.current_round.discards_left == G.GAME.round_resets.discards and
                G.GAME.blind.boss
        end
    }


    -- Booster Pack ownership

    for key, prototype in pairs(G.P_CENTERS) do
        if prototype.set == "Booster" then
            local ref = prototype.create_card
            SMODS.Booster:take_ownership(key, {
                create_card = function(self, card, i)
                    if next(SMODS.find_card("j_j8mod_xUTDR_mr_sunshine_and_abberant")) and self.kind and self.kind == "Arcana" and i == 1 then
                        return {
                            set = "Tarot",
                            key = "c_strength",
                            area = G.pack_cards,
                            skip_materialize = true,
                        }
                    elseif next(SMODS.find_card("j_j8mod_xUTDR_goner_kid")) and i == prototype.config.extra + (G.GAME.modifiers.booster_size_mod or 0) then
                        return {
                            set = "Spectral",
                            area = G.pack_cards,
                            skip_materialize = true,
                            soulable = true,
                            key_append =
                            "ar2"
                        }
                    end
                    return ref(self, card, i)
                end
            }, true)
        end
    end
end

if elle_mod_exists and J8MOD.config.enable_crossmod_jokers then
    -- Fizz Fizzle

    SMODS.Joker {
        key = "xellejokers_fizz_fizzle",
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 3,
        cost = 11,
        atlas = "j8jokers-dlc",
        pos = { x = 0, y = 1 },
        discovered = true,
        unlocked = true,
        dependencies = { "ellejokers" },
        config = { extra = { extra_reps = 1 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { card.ability.extra.extra_reps } }
        end
    }

    local oldevalcard = eval_card
    function eval_card(card, context)
        if not card then return end
        local g, post = oldevalcard(card, context)
        if not card:can_calculate(context.ignore_debuff, context.remove_playing_cards or context.joker_type_destroyed) then
            return
                g, post
        end
        for k, v in pairs(g) do
            if type(v) == 'table' and v.repetitions and type(v.repetitions) == 'number' and next(SMODS.find_card("j_j8mod_xellejokers_fizz_fizzle")) then
                v.repetitions = v.repetitions + #SMODS.find_card("j_j8mod_xellejokers_fizz_fizzle")
            end
        end
        return g, post
    end

    -- Girlfriend

    SMODS.Joker {
        key = "xellejokers_girlfriend",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 1,
        cost = 6,
        atlas = "j8jokers-dlc",
        pos = { x = 1, y = 1 },
        discovered = true,
        unlocked = true,
        dependencies = { "ellejokers" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = {} }
        end,
        calculate = function(self, card, context)
            if context.pre_joker and not context.blueprint then
                local cards_to_trigger = {}
                if #G.hand.cards > 0 then
                    table.insert(cards_to_trigger, G.hand.cards[1])
                    table.insert(cards_to_trigger, G.hand.cards[#G.hand.cards])
                end
                if #cards_to_trigger > 0 then
                    local ctx = {
                        cardarea = G.play,
                        full_hand = G.play.cards,
                        scoring_hand = context.scoring_hand,
                        scoring_name = context.scoring_name,
                        poker_hands = context.poker_hands
                    }
                    SMODS.calculate_effect({
                        trigger = "after",
                        delay = 0.5,
                        message = localize("j8mod_girlfriend"),
                        message_card = card,
                        colour = G.C.RED,
                        func = function()
                            delay(0.5)
                            for _, v in ipairs(cards_to_trigger) do
                                SMODS.score_card(v, ctx)
                            end
                            return true
                        end
                    }, card)
                end
            end
        end,
    }

    -- Lazy Worm

    SMODS.Joker {
        key = "xellejokers_lazy_worm",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 2,
        cost = 9,
        atlas = "j8jokers-dlc",
        pos = { x = 2, y = 1 },
        discovered = true,
        unlocked = true,
        dependencies = { "ellejokers" },
        config = { extra = { xmult_inc = 0.5, xmult = 1 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { card.ability.extra.xmult_inc, card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.card_added and not context.blueprint then
                if context.card.ability.set == "Joker" and (context.card:is_rarity(3) or context.card:is_rarity(4)) then
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_inc
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        message_card = card
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    -- Slimy Joker

    SMODS.Joker {
        key = "xellejokers_slimy_joker",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 2,
        cost = 9,
        atlas = "j8jokers-dlc",
        pos = { x = 3, y = 1 },
        discovered = true,
        unlocked = true,
        dependencies = { "ellejokers" },
        config = { extra = { odds = 4, enhancement = "m_elle_slime" } },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
                'xellejokers_slimy_joker')
            info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { numerator, denominator, localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) } }
        end,
        calculate = function(self, card, context)
            if context.after and not context.blueprint then
                -- find all cards next to slime cards
                local indices_to_trigger = {}
                for i, playing_card in ipairs(G.play.cards) do
                    if SMODS.has_enhancement(playing_card, card.ability.extra.enhancement) then
                        local check = 0
                        for index = -1, 1, 2 do
                            check = i + index
                            if check >= 1 and check <= #G.play.cards then
                                if not SMODS.has_enhancement(G.play.cards[check], card.ability.extra.enhancement) then
                                    table.insert(indices_to_trigger, check)
                                end
                            end
                        end
                    end
                end
                -- filter duplicates
                local hash = {}
                for _, v in ipairs(indices_to_trigger) do
                    hash[v] = true
                end
                local res = {} -- transform keys back into values
                for k, _ in pairs(hash) do
                    res[#res + 1] = k
                    --print(k)
                end
                indices_to_trigger = res
                -- convert to slime cards
                -- send message
                local do_message = false
                for i = 1, #indices_to_trigger do
                    local percent = 0.85 + (i - 0.999) / (#G.play.cards - 0.998) * 0.3
                    if SMODS.pseudorandom_probability(card, 'j8mod_xelle_slimy_joker', 1, card.ability.extra.odds) then
                        do_message = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.25,
                            func = function()
                                G.play.cards[indices_to_trigger[i]]:set_ability(card.ability.extra
                                    .enhancement)
                                play_sound('tarot2', percent, 0.6)
                                G.play.cards[indices_to_trigger[i]]:juice_up(0.3, 0.5)
                                return true
                            end
                        }))
                    end
                end
                if do_message then
                    return {
                        message = localize("k_upgrade_ex"),
                        colour = G.C.FILTER
                    }
                end
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_ellejokers_slime') then
                    return true
                end
            end
            return false
        end
    }

    -- Audience Participation

    SMODS.Joker {
        key = "xellejokers_audience_participation",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 1,
        cost = 4,
        atlas = "j8jokers-dlc",
        pos = { x = 4, y = 1 },
        discovered = true,
        unlocked = true,
        dependencies = { "ellejokers" },
        config = { extra = { enhancement = "m_elle_jess", cards_needed = 2 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) } }
        end,
        calculate = function(self, card, context)
            if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local enhanced = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if SMODS.has_enhancement(playing_card, card.ability.extra.enhancement) then
                        enhanced = enhanced + 1
                    end
                end
                if enhanced >= card.ability.extra.cards_needed then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    card.ability.extra.can_create = false
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            local sets = { "Tarot", "Planet", "Spectral" }
                            if ortalab_mod_exists then
                                table.insert(sets, "ortalab_loteria")
                                table.insert(sets, "ortalab_zodiac")
                                table.insert(sets, "ortalab_mythos")
                            end
                            SMODS.add_card {
                                set = pseudorandom_element(sets, 'j8mod_xellejokers_audience_participation'),
                                soulable = false,
                                key_append = 'j8mod_xellejokers_audience_participation' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('j8mod_card_ex'),
                        colour = G.ARGS.LOC_COLOURS['elle']
                    }
                end
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_ellejokers_jess') then
                    return true
                end
            end
            return false
        end
    }
end

if ortalab_mod_exists and J8MOD.config.enable_crossmod_jokers then
    -- Surface Joker

    SMODS.Joker {
        key = "xortalab_surface_joker",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 2,
        cost = 8,
        atlas = "j8jokers-dlc",
        pos = { x = 0, y = 2 },
        discovered = true,
        unlocked = true,
        dependencies = { "ortalab" },
        config = { extra = { odds = 2 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_ortalab_ore
            info_queue[#info_queue + 1] = G.P_CENTERS.m_ortalab_sand
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
                'j8mod_xortalab_surface')
            return { vars = { numerator, denominator, localize({ type = 'name_text', set = "Enhanced", key = 'm_ortalab_ore' }) or 'Ore Card', localize({ type = 'name_text', set = "Enhanced", key = 'm_ortalab_sand' }) or 'Sand Card' } }
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and not context.other_card.debuff and
                SMODS.has_enhancement(context.other_card, 'm_ortalab_ore') and
                SMODS.pseudorandom_probability(card, 'j8mod_xortalab_surface', 1, card.ability.extra.odds) then
                local current_card = context.other_card
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.SECONDARY_SET.Enhanced,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                current_card:flip()
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                current_card:set_ability('m_ortalab_sand')
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                current_card:flip()
                                return true
                            end
                        }))
                    end
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_ortalab_ore') then
                    return true
                end
            end
            return false
        end
    }

    -- Keepsake

    SMODS.Joker {
        key = "xortalab_keepsake",
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 3,
        cost = 1,
        atlas = "j8jokers-dlc",
        pos = { x = 1, y = 2 },
        pixel_size = { w = 37, h = 49 },
        discovered = true,
        unlocked = true,
        dependencies = { "ortalab" },
        config = { extra = { ante_count = 0, ante_max = 3 } },
        loc_vars = function(self, info_queue, card)
            --info_queue[#info_queue + 1] = G.P_CENTERS["c_ortalab_corpus"]
            --info_queue[#info_queue + 1] = G.P_CENTERS["c_ortalab_ophiuchus"]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { card.ability.extra.ante_count, card.ability.extra.ante_max, localize { type = 'name_text', key = "c_ortalab_corpus", set = 'ortalab_mythos' }, localize { type = 'name_text', key = "c_ortalab_ophiuchus", set = 'ortalab_mythos' } } }
        end,
        calculate = function(self, card, context)
            if context.selling_self and (card.ability.extra.ante_count >= card.ability.extra.ante_max) and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            SMODS.add_card({ key = "c_ortalab_corpus" })
                            card:juice_up(0.3, 0.5)
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            SMODS.add_card({ key = "c_ortalab_ophiuchus" })
                            card:juice_up(0.3, 0.5)
                        end
                        return true
                    end
                }))
            end
            if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
                card.ability.extra.ante_count = card.ability.extra.ante_count + 1
                if card.ability.extra.ante_count >= card.ability.extra.ante_max then
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(card, eval, true)
                end
                return {
                    message = (card.ability.extra.ante_count < card.ability.extra.ante_max) and
                        (card.ability.extra.ante_count .. '/' .. card.ability.extra.ante_max) or
                        localize('k_active_ex'),
                    colour = G.ARGS.LOC_COLOURS['ortalab_mythos']
                }
            end
        end

    }

    -- Self-Insert

    SMODS.Joker {
        key = "xortalab_self_insert",
        blueprint_compat = true,
        perishable_compat = true,
        eternal_compat = true,
        rarity = 1,
        cost = 5,
        atlas = "j8jokers-dlc",
        pos = { x = 2, y = 2 },
        discovered = true,
        unlocked = true,
        dependencies = { "ortalab" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return {}
        end,
        calculate = function(self, card, context)
            if context.before then
                local eight_check = false
                local jack_check = false
                local rank_check = true
                for i = 1, #G.play.cards do
                    if not G.play.cards[i].debuff then
                        if G.play.cards[i]:get_id() == 8 then
                            eight_check = true
                        elseif G.play.cards[i]:get_id() == 11 then
                            jack_check = true
                        else
                            rank_check = false
                        end
                    end
                end
                if eight_check and jack_check and rank_check then
                    -- See note about SMODS Scaling Manipulation on the wikilocal tag_pool = get_current_pool('Tag')
                    return {
                        message = localize("j8mod_tagged_ex"),
                        colour = G.C.GREEN,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = "immediate",
                                func = function()
                                    --- Credits to Eremel
                                    local tag_pool = get_current_pool('Tag')
                                    local selected_tag = pseudorandom_element(tag_pool, 'j8mod_xortalab_self_insert')
                                    local it = 1
                                    while selected_tag == 'UNAVAILABLE' do
                                        it = it + 1
                                        selected_tag = pseudorandom_element(tag_pool, 'j8mod_xortalab_self_insert' .. it)
                                    end
                                    local tag = Tag(selected_tag)
                                    if tag.name == "Orbital Tag" then
                                        local _poker_hands = {}
                                        for k, v in pairs(G.GAME.hands) do
                                            if v.visible then
                                                _poker_hands[#_poker_hands + 1] = k
                                            end
                                        end
                                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands,
                                            "j8mod_xortalab_self_insert_orbital_tag")
                                    end
                                    tag:set_ability()
                                    add_tag(tag)
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    }

    -- Receipt Printer

    SMODS.Joker {
        key = "xortalab_receipt_printer",
        blueprint_compat = false,
        perishable_compat = false,
        eternal_compat = false,
        rarity = 2,
        cost = 6,
        atlas = "j8jokers-dlc",
        pos = { x = 3, y = 2 },
        discovered = true,
        unlocked = true,
        dependencies = { "ortalab" },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_ortalab_post
            info_queue[#info_queue + 1] = G.P_CENTERS.m_ortalab_bent
            info_queue[#info_queue + 1] = G.P_CENTERS.m_ortalab_index
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_ortalab_post" }), localize({ type = 'name_text', set = "Enhanced", key = "m_ortalab_bent" }), localize({ type = 'name_text', set = "Enhanced", key = "m_ortalab_index" }) } }
        end,
        calculate = function(self, card, context)
            if context.selling_self and not context.blueprint then
                return {
                    func = function()
                        for i, playing_card in ipairs(G.hand.cards) do
                            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                            G.E_MANAGER:add_event(Event({
                                trigger = "after",
                                delay = 0.2,
                                func = function()
                                    playing_card:flip()
                                    play_sound('card1', percent)
                                    playing_card:juice_up(0.3, 0.3)
                                    return true
                                end
                            }))
                        end
                        delay(0.2)
                        for i, playing_card in ipairs(G.hand.cards) do
                            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                            G.E_MANAGER:add_event(Event({
                                trigger = "after",
                                delay = 0.1,
                                func = function()
                                    local rng = pseudorandom('crayon_box', 1, 3)
                                    local enhancement = 'm_ortalab_post'
                                    if rng == 2 then
                                        enhancement = 'm_ortalab_bent'
                                    elseif rng == 3 then
                                        enhancement = 'm_ortalab_index'
                                    end
                                    playing_card:set_ability(enhancement)
                                    return true
                                end
                            }))
                        end
                        for i, playing_card in ipairs(G.hand.cards) do
                            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                            G.E_MANAGER:add_event(Event({
                                trigger = "after",
                                delay = 0.2,
                                func = function()
                                    playing_card:flip()
                                    play_sound('tarot2', percent)
                                    playing_card:juice_up(0.3, 0.3)
                                    return true
                                end
                            }))
                        end
                        delay(0.5)
                        return true -- This is for Joker retrigger purposes
                    end
                }
            end
        end
    }

    -- Boogie Joker

    SMODS.Joker {
        key = "xortalab_boogie_joker",
        blueprint_compat = false,
        perishable_compat = false,
        eternal_compat = false,
        rarity = 3,
        cost = 10,
        atlas = "j8jokers-dlc",
        pos = { x = 4, y = 2 },
        discovered = true,
        unlocked = true,
        dependencies = { "ortalab" },
        config = { extra = { enhancement = "m_ortalab_iou" } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
            info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
            return { vars = { card.ability.extra.enhancement and localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) or 'Cosmic Card' } }
        end,
        calculate = function(self, card, context)
            if context.after and not context.blueprint then
                local cards_to_trigger = {}
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.UI.TEXT_DARK,
                    func = function()
                        for _, v in ipairs(G.play.cards) do
                            local percent = 0.85 + (_ - 0.999) / (#G.hand.cards - 0.998) * 0.3
                            if _ > 1 and SMODS.has_enhancement(v, card.ability.extra.enhancement) then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.1,
                                    func = function()
                                        copy_card(v, G.play.cards[_ - 1])
                                        play_sound('tarot2', percent, 0.6)
                                        G.play.cards[_ - 1]:juice_up(0.3, 0.5)
                                        return true
                                    end
                                }))
                            end
                        end
                        delay(0.5)
                        return true
                    end
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, "m_ortalab_iou") then
                    return true
                end
            end
            return false
        end,
    }
end

-- ## JOKER BUTTONS

local function yuri_button_ui(card)
    return UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = 'cm',
                        padding = 0.15,
                        r = 0.08,
                        hover = true,
                        shadow = true,
                        colour = SMODS.Gradients["j8mod_lesbian"], -- color of the button background
                        button = 'j8mod_yuri_button_click',        -- function in G.FUNCS that will run when this button is clicked
                        func = 'j8mod_yuri_button_func',           -- function in G.FUNCS that will run every frame this button exists (optional)
                        ref_table = card,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('j8mod_activate_yuri'),
                                        colour = G.C.UI.TEXT_LIGHT, -- color of the button text
                                        scale = 0.4,
                                    }
                                },
                                {
                                    n = G.UIT.B,
                                    config = {
                                        w = 0.1,
                                        h = 0.4
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        config = {
            align = 'cl', -- position relative to the card, meaning "center left". Follow the SMODS UI guide for more alignment options
            major = card,
            parent = card,
            offset = { x = 0.2, y = 0 } -- depends on the alignment you want, without an offset the button will look as if floating next to the card, instead of behind it
        }
    }
end

local function friend_button_ui(card)
    return UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = 'cm',
                        padding = 0.15,
                        r = 0.08,
                        hover = true,
                        shadow = true,
                        colour = SMODS.Gradients["j8mod_friend"], -- color of the button background
                        button = 'j8mod_friend_button_click',     -- function in G.FUNCS that will run when this button is clicked
                        func = 'j8mod_friend_button_func',        -- function in G.FUNCS that will run every frame this button exists (optional)
                        ref_table = card,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('j8mod_activate_friend'),
                                        colour = G.C.UI.TEXT_LIGHT, -- color of the button text
                                        scale = 0.4,
                                    }
                                },
                                {
                                    n = G.UIT.B,
                                    config = {
                                        w = 0.1,
                                        h = 0.4
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        config = {
            align = 'cl', -- position relative to the card, meaning "center left". Follow the SMODS UI guide for more alignment options
            major = card,
            parent = card,
            offset = { x = 0.2, y = 0 } -- depends on the alignment you want, without an offset the button will look as if floating next to the card, instead of behind it
        }
    }
end

-- Will be called whenever the button is clicked
G.FUNCS.j8mod_yuri_button_click = function(e)
    local card = e.config.ref_table -- access the card this button was on


    local tm = SMODS.find_card("j_UTDR_tasque_manager")[1]
    local mm = SMODS.find_card("j_UTDR_missmizzle")[1]
    local edition = nil
    if card.config.center.key == "j_UTDR_tasque_manager" then
        tm = card
        edition = card.edition
    elseif card.config.center.key == "j_UTDR_missmizzle" then
        mm = card
        edition = card.edition
    end

    local yuri_x = (tm.T.x + mm.T.x) / 2.0
    local yuri_y = (tm.T.y + mm.T.y) / 2.0 -- G.ROOM.T.h / 2.0 - G.ROOM.T.y / 2.0
    local yuri_card = nil
    local yuri_sparkles = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            --print(tostring(yuri_x) .. " " .. tostring(yuri_y))
            tm.area:remove_card(tm)
            mm.area:remove_card(mm)
            tm.states.collide.can = false
            mm.states.collide.can = false
            yuri_sparkles = Particles(1, 1, 0, 0, {
                timer = 0.015,
                scale = 0.25,
                initialize = true,
                lifespan = 1.0,
                speed = 0.5,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = { SMODS.Gradients["j8mod_lesbian"], lighten(SMODS.Gradients["j8mod_lesbian"], 0.2) },
                fill = true
            })
            yuri_sparkles.fade_alpha = 1
            yuri_sparkles:fade(1, 0)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        ref_table = tm.T,
        ref_value = "x",
        ease_to = yuri_x,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = tm.T,
        ref_value = "y",
        ease_to = yuri_y,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = mm.T,
        ref_value = "x",
        ease_to = yuri_x,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = mm.T,
        ref_value = "y",
        ease_to = yuri_y,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.5,
        func = function()
            tm:remove()
            mm:remove()
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            play_sound('timpani')
            yuri_card = SMODS.create_card { key = "j_j8mod_mizzmanaged", edition = edition }
            yuri_card.T.x = yuri_x
            yuri_card.T.y = yuri_y
            yuri_card.VT.x = yuri_x
            yuri_card.VT.y = yuri_y
            yuri_card.states.collide.can = false
            yuri_card:juice_up(0.5, 0.5)

            attention_text({
                text = localize('j8mod_yuri'),
                scale = 1.0,
                hold = 1.5,
                major = yuri_card,
                backdrop_colour = SMODS.Gradients["j8mod_lesbian"],
                align = 'cm',
                offset = { x = 0, y = 0.0 },
                silent = false
            })
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 2.0,
        func = function()
            G.jokers:emplace(yuri_card)
            yuri_card.states.collide.can = true
            yuri_sparkles:remove()
            return true
        end
    }))
end

G.FUNCS.j8mod_friend_button_click = function(e)
    local card = e.config.ref_table -- access the card this button was on


    local tm = SMODS.find_card("j_UTDR_FRIEND")[1]
    local mm = SMODS.find_card("j_UTDR_vessel")[1]
    local edition = nil
    if card.config.center.key == "j_UTDR_FRIEND" then
        tm = card
        edition = card.edition
    elseif card.config.center.key == "j_UTDR_vessel" then
        mm = card
        edition = card.edition
    end

    local friend_x = (tm.T.x + mm.T.x) / 2.0
    local friend_y = (tm.T.y + mm.T.y) / 2.0 -- G.ROOM.T.h / 2.0 - G.ROOM.T.y / 2.0
    local friend_card = nil
    local friend_sparkles = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            --print(tostring(friend_x) .. " " .. tostring(friend_y))
            tm.area:remove_card(tm)
            mm.area:remove_card(mm)
            tm.states.collide.can = false
            mm.states.collide.can = false
            friend_sparkles = Particles(1, 1, 0, 0, {
                timer = 0.015,
                scale = 0.25,
                initialize = true,
                lifespan = 1.0,
                speed = 0.5,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = { SMODS.Gradients["j8mod_friend"], lighten(SMODS.Gradients["j8mod_friend"], 0.2) },
                fill = true
            })
            friend_sparkles.fade_alpha = 1
            friend_sparkles:fade(1, 0)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        ref_table = tm.T,
        ref_value = "x",
        ease_to = friend_x,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = tm.T,
        ref_value = "y",
        ease_to = friend_y,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = mm.T,
        ref_value = "x",
        ease_to = friend_x,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        delay = 0.5,
        ease = 'quad',
        blockable = false,
        ref_table = mm.T,
        ref_value = "y",
        ease_to = friend_y,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.5,
        func = function()
            tm:remove()
            mm:remove()
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            play_sound('timpani')
            friend_card = SMODS.create_card { key = "j_j8mod_xUTDR_playerfriend", edition = edition }
            friend_card.T.x = friend_x
            friend_card.T.y = friend_y
            friend_card.VT.x = friend_x
            friend_card.VT.y = friend_y
            friend_card.states.collide.can = false
            friend_card:juice_up(0.5, 0.5)

            attention_text({
                text = localize('j8mod_friend'),
                scale = 1.0,
                hold = 1.5,
                major = friend_card,
                backdrop_colour = SMODS.Gradients["j8mod_friend"],
                align = 'cm',
                offset = { x = 0, y = 0.0 },
                silent = false
            })
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 2.0,
        func = function()
            G.jokers:emplace(friend_card)
            friend_card.states.collide.can = true
            friend_sparkles:remove()
            return true
        end
    }))
end

-- Will run every frame while the button exists
G.FUNCS.j8mod_yuri_button_func = function(e)
    local card = e.config.ref_table -- access the card this button was on (unused here, but you can access it)

    -- In vanilla, this is generally used to define when the button can be used, for example:
    local can_use = true -- can be any condition you want

    -- Removes the button when the card can't be used, otherwise makes it use the previously defined button click
    e.config.button = can_use and 'j8mod_yuri_button_click' or nil
    -- Changes the color of the button depending on whether it can be used or not
    e.config.colour = can_use and SMODS.Gradients["j8mod_lesbian"] or G.C.UI.BACKGROUND_INACTIVE
end

G.FUNCS.j8mod_friend_button_func = function(e)
    local card = e.config.ref_table -- access the card this button was on (unused here, but you can access it)

    -- In vanilla, this is generally used to define when the button can be used, for example:
    local can_use = true -- can be any condition you want

    -- Removes the button when the card can't be used, otherwise makes it use the previously defined button click
    e.config.button = can_use and 'j8mod_friend_button_click' or nil
    -- Changes the color of the button depending on whether it can be used or not
    e.config.colour = can_use and SMODS.Gradients["j8mod_friend"] or G.C.UI.BACKGROUND_INACTIVE
end

SMODS.DrawStep {
    key = 'yuri_button',
    order = -30, -- before the Card is drawn
    func = function(card, layer)
        if card.children.j8mod_yuri_button then
            card.children.j8mod_yuri_button:draw()
        end
    end
}

SMODS.DrawStep {
    key = 'friend_button',
    order = -30, -- before the Card is drawn
    func = function(card, layer)
        if card.children.j8mod_friend_button then
            card.children.j8mod_friend_button:draw()
        end
    end
}

-- make sure SMODS doesn't draw the button after the card is drawn
SMODS.draw_ignore_keys.j8mod_yuri_button = true
SMODS.draw_ignore_keys.j8mod_friend_button = true

local highlight_ref = Card.highlight
function Card.highlight(self, is_highlighted)
    self.children.j8mod_yuri_button = nil
    self.children.j8mod_friend_button = nil

    local tm = next(SMODS.find_card("j_UTDR_tasque_manager"))
    local mm = next(SMODS.find_card("j_UTDR_missmizzle"))
    local v = next(SMODS.find_card("j_UTDR_vessel"))
    local f = next(SMODS.find_card("j_UTDR_FRIEND"))

    local can_yuri = tm and mm and not J8MOD.config.no_deltarune_spoilers
    if is_highlighted and self.ability.set == "Joker" and self.area == G.jokers and can_yuri and (self.config.center.key == "j_UTDR_tasque_manager" or self.config.center.key == "j_UTDR_missmizzle") then
        self.children.j8mod_yuri_button = yuri_button_ui(self)
    elseif self.children.j8mod_yuri_button then
        self.children.j8mod_yuri_button:remove()
        self.children.j8mod_yuri_button = nil
    end

    local can_friend = v and f
    if is_highlighted and self.ability.set == "Joker" and self.area == G.jokers and can_friend and (self.config.center.key == "j_UTDR_vessel" or self.config.center.key == "j_UTDR_FRIEND") then
        self.children.j8mod_friend_button = friend_button_ui(self)
    elseif self.children.j8mod_friend_button then
        self.children.j8mod_friend_button:remove()
        self.children.j8mod_friend_button = nil
    end

    return highlight_ref(self, is_highlighted)
end
