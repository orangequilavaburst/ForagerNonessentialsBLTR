-- ## JOKERS ##

-- Prophecy
SMODS.Joker {
    key = "prophecy",
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
	perishable_compat = false,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers-prophecy",
    pos = { x = 0, y = 0 },
	soul_pos = {
        x = 1, y = 0,
        draw = function(card, scale_mod, rotate_mod)
			G.SHADERS['j8mod_prophecy']:send("depths_texture", J8MOD.prophecy_texture)
			--G.SHADERS['j8mod_prophecy']:send("depths_dimensions", {J8MOD.prophecy_texture:getWidth(), J8MOD.prophecy_texture:getHeight()})
            card.children.floating_sprite:draw_shader('j8mod_prophecy', nil, card.ARGS.send_to_shader, nil,
                card.children.center)
        end
    },
    config = { extra = { prophecy_rounds = 0, total_rounds = 3, spectral_count = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_ethereal', set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
        return { vars = { card.ability.extra.total_rounds, card.ability.extra.prophecy_rounds, card.ability.extra.spectral_count, localize { type = 'name_text', set = 'Tag', key = 'tag_ethereal' } } }
    end,
    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.prophecy_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
            for i = 1, math.min(card.ability.extra.spectral_count, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							SMODS.add_card({ set = 'Spectral' })
							card:juice_up(0.3, 0.5)
						end
						return true
					end
				}))
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						add_tag(Tag("tag_ethereal"))
						card:juice_up(0.3, 0.5)
					end
					return true
				end
			}))
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.prophecy_rounds = card.ability.extra.prophecy_rounds + 1
            if card.ability.extra.prophecy_rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.prophecy_rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.prophecy_rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end
}

-- Monty Hall
SMODS.Joker { 
	key = "monty_hall",
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 5,
	atlas = "j8jokers",
	pos = {x = 1, y = 0},
	config = { extra = { extra_numerator = 0, extra_mod = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.extra_numerator, card.ability.extra.extra_mod } }
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator + card.ability.extra.extra_numerator
            }
        end
		if context.pseudorandom_result then
		
			if not context.result then
				return {
					message = "Open door!",
					colour = G.C.FILTER,
					func = function()
						card.ability.extra.extra_numerator = card.ability.extra.extra_numerator + card.ability.extra.extra_mod
					end
				}
			else
				return {
					message = "Reset!",
					colour = G.C.FILTER,
					func = function()
						card.ability.extra.extra_numerator = 0
					end
				}
			end
		
		end
	end
}

-- Metamorphic Joker

SMODS.Joker {
	key = "metamorphic_joker",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 2, y = 0 },
	config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_metamorphic')
        return { vars = { numerator, denominator } }
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.other_card.debuff and
			SMODS.has_enhancement(context.other_card, 'm_stone') and 
			SMODS.pseudorandom_probability(card, 'j8mod_metamorphic', 1, card.ability.extra.odds) then
			
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
							current_card:set_ability('m_glass')
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
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

-- Clownfish

SMODS.Joker {
    key = "clownfish",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 1,
    cost = 5,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 3, y = 0 },
    config = { extra = { chips = 0, chip_mod = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,
	calculate = function(self, card, context)
		if context.post_trigger and not context.blueprint and context.cardarea == G.jokers then
			--print(context.other_context)
			if not context.other_context.check_enhancement and not context.other_context.mod_probability and not context.other_context.evaluate_poker_hand and context.other_card ~= card then
				--print("It's not check enhancement!")
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.CHIPS,
					message_card = card
				}
			end
		end
		if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
		-- reset at end of round
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			return {
				message = localize('k_reset'),
				colour = G.C.CHIPS,
				message_card = card,
				func = function()
				    card.ability.extra.chips = 0
					return true
				end
			}
		end
	end
}

-- Cookie Cutter
SMODS.Joker {
    key = "cookie_cutter",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pixel_size = { h = 71 },
    pos = { x = 4, y = 0 },
    config = { extra = { chips = 0, chip_mod = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,
	calculate = function(self, card, context)
		if ((context.joker_type_destroyed and not G.CONTROLLER.locks.selling_card) or context.selling_card) and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                message_card = card
            }
		end
		if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
	end
}

-- Promo Card
SMODS.Joker {
    key = "promo_card",
    blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 5, y = 0 },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    config = { extra = { booster_mod = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.booster_mod } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.booster_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_mod
    end
}

-- Sandwich Pick
SMODS.Joker {
	key = "sandwich_pick",
    blueprint_compat = false,
    eternal_compat = false,
	perishable_compat = true,
    rarity = 2,
    cost = 6,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 6, y = 0 },
	config = { extra = { c_min = 3, s_count = 5, s_mod = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.c_min, card.ability.extra.s_count, card.ability.extra.s_mod } }
    end,
	calculate = function(self, card, context)
		if context.final_scoring_step and not context.blueprint and #context.scoring_hand >= card.ability.extra.c_min then
			local random_seal = SMODS.poll_seal {guaranteed = true}
			G.E_MANAGER:add_event(Event({
				func = function()
					context.scoring_hand[1]:set_seal(random_seal, nil, true) -- Set a seal on an existing card
					context.scoring_hand[1]:juice_up()
					if card.ability.extra.s_count - card.ability.extra.s_mod <= 0 then
						SMODS.destroy_cards(card, nil, nil, true)
						return {
							message = localize('k_eaten_ex'),
							colour = G.C.SECONDARY_SET.Enhanced,
							message_card = card
						}
					else
						-- See note about SMODS Scaling Manipulation on the wiki
						card.ability.extra.s_count = card.ability.extra.s_count - card.ability.extra.s_mod
						return {
							message = "-"..card.ability.extra.s_mod, --localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_mod } },
							colour = G.C.SECONDARY_SET.Enhanced,
							message_card = card
						}
					end
					return true
				end
			}))
			
			return {
				message = "Sandwiched!",
				colour = G.C.SECONDARY_SET.Enhanced
			}
		end
	end
	
}

-- Loco Moco
SMODS.Joker {
	key = "loco_moco",
    blueprint_compat = true,
    eternal_compat = false,
	perishable_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 7, y = 0 },
	config = { extra = { mult = 5, s_count = 25, s_mod = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.mult, card.ability.extra.s_count, card.ability.extra.s_mod } }
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
		if context.post_trigger and context.cardarea == G.jokers and context.other_card == card and not context.blueprint then
			if card.ability.extra.s_count - card.ability.extra.s_mod <= 0 then
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.MULT,
					message_card = card,
					func = function()
						SMODS.destroy_cards(card)
					end
                }
            else
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.s_count = card.ability.extra.s_count - card.ability.extra.s_mod
                return {
                    message = "-"..card.ability.extra.s_mod,
                    colour = G.C.MULT,
					message_card = card
                }
            end
		end
	end
	
}

-- Memento
SMODS.Joker {
	key = "memento",
    blueprint_compat = false,
    eternal_compat = false,
	perishable_compat = false,
    rarity = 3,
    cost = 1,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 8, y = 0 },
	config = { extra = { ante_count = 0, ante_max = 3 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.ante_count, card.ability.extra.ante_max } }
    end,
	calculate = function(self, card, context)
		if context.selling_self and (card.ability.extra.ante_count >= card.ability.extra.ante_max) and not context.blueprint then
            G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						SMODS.add_card({ key = "c_soul" })
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
						SMODS.add_card({ key = "c_black_hole" })
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
                colour = G.C.SECONDARY_SET.Spectral
            }
        end
	end
	
}

-- Meal Ticket
-- (Thanks riff-raff)
SMODS.Joker { 

	key = "meal_ticket",
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 9, y = 0 },
	config = { extra = { creates = 2 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.creates } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(card.ability.extra.creates,
                G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, jokers_to_create do
                        SMODS.add_card {
							area = G.jokers,
                            set = 'j8bit_meal_voucher' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end,

}

-- Graffiti Artist
SMODS.Joker {
    key = "graffiti_artist",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 2,
    cost = 7,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 0, y = 1 },
    config = { extra = { odds = 2 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_graffiti')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval 
		and SMODS.pseudorandom_probability(card, 'j8mod_graffiti', 1, card.ability.extra.odds) then
			-- thanks cryptid
			if G.GAME.blind:get_type() ~= "Boss" then
				play_sound("tarot1")
				add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()]))
				return {
					message = "Tagged!",
					colour = G.C.BLUE,
					message_card = card,
				}
			end
        end
    end
}

-- Bookmark
SMODS.Joker {
    key = "bookmark",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 2,
    cost = 6,
	atlas = "j8jokers",
    pos = { x = 1, y = 1 },
    discovered = true,
	unlocked = true,
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			for index, playing_card in ipairs(G.playing_cards) do
				if playing_card.ability.played_this_ante then
					SMODS.debuff_card(playing_card, 'prevent_debuff', 'j8mod_bookmark')
					SMODS.recalc_debuff(playing_card)
				end
			end
		end
		-- reset debuff at end of round
		if context.end_of_round and not context.blueprint then
			for _, playing_card in ipairs(G.playing_cards) do
				SMODS.debuff_card(playing_card, 'reset', 'j8mod_bookmark')
				SMODS.recalc_debuff(playing_card)
			end
		end
	end,
    add_to_deck = function(self, card, from_debuff)
        for index, playing_card in ipairs(G.playing_cards) do
			if playing_card.ability.played_this_ante then
				SMODS.debuff_card(playing_card, 'prevent_debuff', 'j8mod_bookmark')
				SMODS.recalc_debuff(playing_card)
			end
		end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for _, playing_card in ipairs(G.playing_cards) do
			SMODS.debuff_card(playing_card, 'reset', 'j8mod_bookmark')
			SMODS.recalc_debuff(playing_card)
		end
    end
}

-- Milkshake
SMODS.Joker {
    key = "milkshake",
    blueprint_compat = true,
    eternal_compat = false,
	perishable_compat = true,
    rarity = 2,
    cost = 6,
	atlas = "j8jokers",
    pos = { x = 2, y = 1 },
    discovered = true,
	unlocked = true,
    config = { extra = { chips = 0, chip_mod = 20, odds = 20 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_milkshake')
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod, numerator, denominator } }
    end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint then
		
			if not SMODS.pseudorandom_probability(card, 'j8mod_milkshake', 1, card.ability.extra.odds) then
			
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.CHIPS
				}
			
			else
				
				return {
					message = localize('k_drank_ex'),
					colour = G.C.CHIPS,
					message_card = card,
					func = function()
						SMODS.destroy_cards(card)
					end
				}
			
			end
		
		end
		if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
	end
}

-- Gourmand
SMODS.Joker {
    key = "gourmand",
    blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 2,
    cost = 6,
	atlas = "j8jokers",
    pos = { x = 3, y = 1 },
    discovered = true,
	unlocked = true,
    config = { extra = { dollars = 0, increase = 4 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.dollars, card.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
			local food = {}
			for i, joker in ipairs(G.jokers.cards) do
				if (joker.config.center.pools or {}).j8bit_meal_voucher and joker ~= card then
					table.insert(food, joker)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.5,
						func = function()
							SMODS.calculate_effect({
								trigger = "immediate",
								blockable = false,
								message = "$"..card.ability.extra.increase,
								colour = G.C.MONEY,
								message_card = card,
								func = function()
									joker:juice_up()
									card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
									return true
								end
								}, 
							card)
							return true
						end
					}))
				end
			end
			delay(0.5)
			if #food > 0 then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MONEY,
					message_card = card,
					func = function()
						SMODS.destroy_cards(food)
						return true
					end
				}
			end
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

-- Needlepoint Joker
SMODS.Joker {
    key = "needlepoint_joker",
    blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = false,
    rarity = 2,
    cost = 6,
	atlas = "j8jokers",
    pos = { x = 4, y = 1 },
    discovered = true,
	unlocked = true,
	config = { extra = { dollars = 4 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
					local hands_lost = G.GAME.current_round.hands_left - 1
					G.GAME.blind.hands_sub = hands_lost
                    ease_hands_played(-G.GAME.current_round.hands_left + 1, nil, true)
                    SMODS.calculate_effect(
						{
                        dollars = card.ability.extra.dollars * hands_lost
						},
					card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end
}

-- Bathroom Pass
SMODS.Joker {
	key = "bathroom_pass",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 10,
	atlas = "j8jokers",
	pos = { x = 5, y = 1},
	discovered = true,
	unlocked = true,
	config = { extra = { rerolls = 2, rerolls_max = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.rerolls, card.ability.extra.rerolls_max } }
	end,
	calculate = function(self, card, context)
		local end_of_ante = context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss
		if end_of_ante and not context.blueprint then
			card.ability.extra.rerolls = card.ability.extra.rerolls_max
			return {
				message = localize('k_reset'),
				colour = G.C.GREEN
			}
        end
		if context.before then
			if card.ability.extra.rerolls > 0 and next(context.poker_hands["Flush"]) and G.GAME.blind:get_type() ~= "Boss" then
				return {
					message = "Flushed!",
					colour = G.C.GREEN,
					func = function()
						card.ability.extra.rerolls = card.ability.extra.rerolls - 1
						G.from_boss_tag = true
						G.FUNCS.reroll_boss()
					end
				}
			end
		end
	end
	
}

-- Top 3 Joker
SMODS.Joker {
	key = "top_3_joker",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 7,
	atlas = "j8jokers",
	pos = { x = 6, y = 1},
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint and #context.full_hand == 3 then
			SMODS.calculate_effect({
				trigger = "after",
				delay = 1.0,
				message = "Ranked!",
				colour = G.C.GREEN,
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						func = function()
							context.full_hand[1]:set_ability('m_gold')
							context.full_hand[1]:juice_up()
							return true
						end
					}))
					return true
				end
				}, 
			context.full_hand[1])
			SMODS.calculate_effect({
				trigger = "after",
				delay = 1.0,
				message = "Ranked!",
				colour = G.C.GREEN,
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						func = function()
							context.full_hand[2]:set_ability('m_steel')
							context.full_hand[2]:juice_up()
							return true
						end
					}))
					return true
				end
				}, 
			context.full_hand[2])
			SMODS.calculate_effect({
				trigger = "after",
				delay = 1.0,
				message = "Ranked!",
				colour = G.C.GREEN,
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						func = function()
							context.full_hand[3]:set_ability('m_bonus')
							context.full_hand[3]:juice_up()
							return true
						end
					}))
					return true
				end
				}, 
			context.full_hand[3])
            return true
        end
	end
}

-- Kaleidoscope
SMODS.Joker {
	key = "kaleidoscope",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 1,
	cost = 4,
	atlas = "j8jokers",
	pos = { x = 7, y = 1},
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
	end,
	calculate = function(self, card, context)
		if context.evaluate_poker_hand and context.scoring_name == "Pair" and not context.blueprint then
			context.poker_hands["Pair"] = context.poker_hands["Two Pair"]
			return {
				replace_scoring_name = "Two Pair"
			}
		end
	end,
	in_pool = function(self, args)
		return G.GAME.hands["Pair"].played > 0 or G.GAME.hands["Two Pair"].played > 0
	end
}

-- Buy 1 Get 1 Free
SMODS.Joker {
    key = "b1g1f",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 10,
	atlas = "j8jokers",
    pos = { x = 5, y = 4 },
    discovered = true,
	unlocked = true,
	config = { extra = { saved_tags = {} } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "tag_charm", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_meteor", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_ethereal", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_buffoon", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_standard", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
        return {  }
    end,
	calculate = function(self, card, context)
		if context.open_booster and context.card.from_tag == nil then
			
			return {
				message = context.card.config.center.kind .. "!",
				message_card = card,
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						func = function()
							if context.card.config.center.kind == "Arcana" then
								add_tag(Tag("tag_charm"))
								--table.insert(card.ability.extra.saved_tags, "tag_charm")
							elseif context.card.config.center.kind == "Celestial" then
								add_tag(Tag("tag_meteor"))
								--table.insert(card.ability.extra.saved_tags, "tag_meteor")
							elseif context.card.config.center.kind == "Spectral" then
								add_tag(Tag("tag_ethereal"))
								--table.insert(card.ability.extra.saved_tags, "tag_ethereal")
							elseif context.card.config.center.kind == "Buffoon" then
								add_tag(Tag("tag_buffoon"))
								--table.insert(card.ability.extra.saved_tags, "tag_buffoon")
							elseif context.card.config.center.kind == "Standard" then
								add_tag(Tag("tag_standard"))
								--table.insert(card.ability.extra.saved_tags, "tag_standard")
							end
							return true
						end
					}))
					return true
				end
			}
		end
	end
}

function card_assimilation_value(card)
    if card.config.center.key == "m_stone" then
	    return 0
	end
    local value = card:get_id()
	if value == 14 then
		value = 1
	elseif value >= 11 and value <= 13 then
		value = 10
	end
	return value
end

function card_value_to_key(value)
    value = value % 13
	local key = 'Ace'
	if value + 1 == 2 then
		key = '2'
	elseif value + 1 == 3 then
		key = '3'
	elseif value + 1 == 4 then
		key = '4'
	elseif value + 1 == 5 then
		key = '5'
	elseif value + 1 == 6 then
		key = '6'
	elseif value + 1 == 7 then
		key = '7'
	elseif value + 1 == 8 then
		key = '8'
	elseif value + 1 == 9 then
		key = '9'
	elseif value + 1 == 10 then
		key = '10'
	elseif value + 1 == 11 then
		key = 'Jack'
	elseif value == 12 then
		key = 'Queen'
	elseif value == 13 then
		key = 'King'
	end
	return key
end

-- Assimilation Joker
SMODS.Joker {
    key = "assimilation_joker",
    blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 3,
    cost = 10,
	atlas = "j8jokers",
    pos = { x = 8, y = 1 },
    discovered = true,
	unlocked = true,
	config = { extra = { rank_saved = 13, rank_name = 'Ace' } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		local extra_text = {"(inactive)", "", ""}
		local colours = { G.C.UI.TEXT_INACTIVE }
		local ret_vals = {nil, nil, "", "", "", colours = { G.C.UI.TEXT_INACTIVE, G.C.FILTER, G.C.UI.TEXT_INACTIVE}}
		if G.hand and G.GAME.current_round.hands_played == 0 and G.GAME.blind.in_blind then
		    local new_value = card.ability.extra.rank_saved or 13
			for _, card in ipairs(G.hand.cards) do
			    local do_add = true
				if G.hand.highlighted and #G.hand.highlighted > 0 then
					for i=1, #G.hand.highlighted do
						if G.hand.highlighted[i] == card then
							do_add = false
							break
						end
					end
				end
			    new_value = new_value + (do_add and card_assimilation_value(card) or 0)
			end
			--extra_text = "{C:inactive}(Played hand will become {C:attention}"..localize(card_value_to_key(new_value), 'ranks').." {C:inactive})"
			extra_text[1] = "(Played cards will become "
			extra_text[2] = localize(card_value_to_key(new_value), "ranks")
			extra_text[3] = ")"
		end
		ret_vals[1] = card.ability.extra.rank_saved
		ret_vals[2] = card.ability.extra.rank_name
		ret_vals[3] = extra_text[1]
		ret_vals[4] = extra_text[2]
		ret_vals[5] = extra_text[3]
		return { vars = ret_vals  }
	end,
	calculate = function(self, card, context)
		-- juicy
		if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
		-- destroying cards
		if context.destroy_card and not context.blueprint then
			if (context.cardarea == G.hand) and G.GAME.current_round.hands_played == 0 then
				return { 
					remove = true 
				}
			end
		end
		-- adding values
		if context.before and not context.blueprint and G.GAME.current_round.hands_played == 0 then
			for i, hand_card in ipairs(G.hand.cards) do
				
				local value = card_assimilation_value(hand_card)
				SMODS.calculate_effect({
					trigger = 'after',
					message = "+"..value,
					message_card = hand_card,
					colour = G.C.UI.TEXT_DARK,
					func = function()
						card.ability.extra.rank_saved = (card.ability.extra.rank_saved + value) % 13
						card.ability.extra.rank_name = localize(card_value_to_key(card.ability.extra.rank_saved), 'ranks')
						return true
					end
				}
				, card)
				SMODS.calculate_effect({
					trigger = 'after',
					delay = 0.5,
					message = card.ability.extra.rank_name .. "!",
					message_card = card,
					colour = G.C.UI.TEXT_DARK,
				}
				, card)
			end
			return {}
		end
		if context.final_scoring_step and not context.blueprint and G.GAME.current_round.hands_played == 0 then
			return {
				trigger = 'after',
				delay = 0.5,
				message = localize('k_upgrade_ex'),
				message_card = card,
				colour = G.C.UI.TEXT_DARK,
				func = function()
					for i, played_card in ipairs(G.play.cards) do
						local percent = 0.85 + (i - 0.999) / (#G.play.cards - 0.998) * 0.3
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.5,
							blocking = true,
							func = function()
								play_sound('tarot1', percent)
								assert(SMODS.change_base(played_card, nil, card.ability.extra.rank_name))
								played_card:juice_up()
								return true
							end
						}))
					end
					return true
				end,
			}
		end
	end
}

-- 69 Joke
SMODS.Joker {
    key = "69_joke",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 0, y = 2 },
    config = { extra = { chips = 0, mult = 0, chip_mod = 9, mult_mod = 6 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.chip_mod, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
		
		if context.before and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
			local six_check = false
			local nine_check = false
			for i=1, #context.scoring_hand do
				if not context.scoring_hand[i].debuff then
					if context.scoring_hand[i]:get_id() == 6 then
						six_check = true
					elseif context.scoring_hand[i]:get_id() == 9 then
						nine_check = true
					end
				end
			end
			if six_check and nine_check then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod

				return {
					message = "Nice!",
					colour = G.C.EDITION,
					message_card = card
				}
			end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

-- Search History
SMODS.Joker {
    key = "search_history",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 9, y = 1 },
    config = { extra = { Xmult_gain = 0.34, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local reset = false
            local three_check = false
			local four_check = false
			for i=1, #context.scoring_hand do
				if not context.scoring_hand[i].debuff then
					if context.scoring_hand[i]:get_id() == 3 then
						three_check = true
					elseif context.scoring_hand[i]:get_id() == 4 then
						four_check = true
					elseif context.scoring_hand[i]:get_id() == 14 then
						reset = true
					end
				end
			end
            if reset then
                if card.ability.extra.Xmult > 1 then
                    card.ability.extra.Xmult = 1
                    return {
                        message = localize('k_reset')
                    }
                end
            elseif three_check == true and four_check == true then
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					message_card = card
				}
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

-- Fursona
SMODS.Joker {
    key = "fursona",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 1,
    cost = 5,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 1, y = 2 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		return {}
	end,
    calculate = function(self, card, context)
        if context.before then
            local ace_check = false
            local two_check = false
			local six_check = false
			for i=1, #context.scoring_hand do
				if not context.scoring_hand[i].debuff then
					if context.scoring_hand[i]:get_id() == 2 then
						two_check = true
					elseif context.scoring_hand[i]:get_id() == 6 then
						six_check = true
					elseif context.scoring_hand[i]:get_id() == 14 then
						ace_check = true
					end
				end
			end
            if ace_check and two_check and six_check then
                -- See note about SMODS Scaling Manipulation on the wikilocal tag_pool = get_current_pool('Tag')
				return {
					message = "owo",
					colour = G.C.GREEN,
					func = function()
						G.E_MANAGER:add_event(Event({
							trigger = "immediate",
							func = function()
								--- Credits to Eremel
								local tag_pool = get_current_pool('Tag')
								local selected_tag = pseudorandom_element(tag_pool, 'j8mod_fursona')
								local it = 1
								while selected_tag == 'UNAVAILABLE' do
									it = it + 1
									selected_tag = pseudorandom_element(tag_pool, 'j8mod_fursona_resample'..it)
								end
								local tag = Tag(selected_tag)
								if tag.name == "Orbital Tag" then
									local _poker_hands = {}
									for k, v in pairs(G.GAME.hands) do
										if v.visible then
											_poker_hands[#_poker_hands + 1] = k
										end
									end
									tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "j8mod_fursona_orbital_tag")
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
}

-- Breaker Box
SMODS.Joker {
	key = "breaker_box",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 11,
	atlas = "j8jokers",
	pos = { x = 2, y = 2},
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		-- level up
		if context.before then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
		-- debuff
		if context.final_scoring_step and not context.blueprint then 
			local ranks_in_hand = {}
			for _, scored_card in ipairs(context.scoring_hand) do
				if not scored_card.debuff then
					table.insert(ranks_in_hand, scored_card.base.value)
				end
			end
			if #ranks_in_hand > 0 then
				return {
					message = localize('k_debuffed'),
					message_card = card,
					colour = G.C.RED,
					func = function()
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							func = function()
								for _, playing_card in ipairs(G.playing_cards) do
									for i=1, #ranks_in_hand do
										if playing_card.base.value == ranks_in_hand[i] then
											playing_card:juice_up()
											SMODS.debuff_card(playing_card, true, 'j8mod_breakerbox')
											break
										end
									end
								end
								return true
							end
						}))
						delay(0.5)
						return true
					end
				}
			end
		end
		-- reset debuff at end of round
		if context.end_of_round and not context.blueprint then
			for _, playing_card in ipairs(G.playing_cards) do
				SMODS.debuff_card(playing_card, 'reset', 'j8mod_breakerbox')
			end
		end
	end
}

-- Monster Card
SMODS.Joker {
	key = "monster_card",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers",
	pos = { x = 3, y = 2},
	discovered = true,
	unlocked = true,
    config = { extra = { money_min = 1, money_max = 5, con_count = 1, joker_min = 1, joker_max = 2 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
        return { vars = { card.ability.extra.money_min, card.ability.extra.money_max, card.ability.extra.con_count, card.ability.extra.joker_min, card.ability.extra.joker_max } }
    end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local blind_type = G.GAME.blind:get_type()
			if blind_type == "Small" then
				local money_count = pseudorandom('j8mod_monster_card', card.ability.extra.money_min, card.ability.extra.money_max)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money_count
				return {
					message = "Pennies!",
					colour = G.C.MONEY,
					dollars = money_count,
					func = function()
						-- This is for timing purposes, this goes after the dollar modification
						-- It resets the buffer in an event after scoring
						G.E_MANAGER:add_event(Event({
							func = function()
								G.GAME.dollar_buffer = 0
								return true
							end
						}))
					end
				}
			elseif blind_type == "Big" then
				local consumable_count = math.min(card.ability.extra.con_count,
					G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
				if consumable_count == 0 then
					return {
						message = localize('k_no_room_ex'),
						colour = G.C.RED
					}
				else
					return {
						message = "Loot!",
						colour = G.C.BLUE,
						func = function()
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + consumable_count
							G.E_MANAGER:add_event(Event({
								func = function()
									local thing = "Tarot"
									for _ = 1, consumable_count do
										thing = "Tarot"
										if pseudorandom('j8mod_monster_card', 1, 2) == 1 then
											thing = "Planet"
										end
										SMODS.add_card {
											set = thing,
											soulable = false,
											key_append = 'j8mod_monster_card'
										}
										G.GAME.consumeable_buffer = 0
									end
									return true
								end
							}))
							return true
						end
					}
				end
			elseif blind_type == "Boss" then
				local joker_count = pseudorandom('j8mod_monster_card', card.ability.extra.joker_min, card.ability.extra.joker_max)
				local jokers_to_create = math.min(joker_count,
					G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
				if jokers_to_create == 0 then
					return {
						message = localize('k_no_room_ex'),
						colour = G.C.RED
					}
				else 
					return {
						message = "Treasure!",
						colour = G.C.YELLOW,
						func = function()
							G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
							G.E_MANAGER:add_event(Event({
								func = function()
									for _ = 1, jokers_to_create do
										SMODS.add_card {
											set = 'Joker',
											soulable = false,
											key_append = 'j8mod_monster_card'
										}
										G.GAME.joker_buffer = 0
									end
									return true
								end
							}))
							return true
						end
					}
				end
			end
        end
	end
}

-- Crayon Box
SMODS.Joker {
	key = "crayon_box",
	blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
	rarity = 2,
	cost = 6,
	atlas = "j8jokers",
	pos = { x = 4, y = 2},
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		return {}
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
								local enhancement = 'm_wild'
								if rng == 2 then
									enhancement = 'm_bonus'
								elseif rng == 3 then
									enhancement = 'm_mult'
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

-- Kitsune Mask
SMODS.Joker {
    key = "kitsune_mask",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    pos = { x = 6, y = 4 },
	discovered = true,
	unlocked = true,
    config = { extra = { odds = 7 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_kitsune_mask')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (context.other_card:get_id() == 7) and SMODS.pseudorandom_probability(card, 'j8mod_kitsune_mask', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Spectral',
                                        key_append = 'k_plus_spectral' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end
}

-- Thrift Shop
SMODS.Joker {
	key = "thrift_shop",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers",
	pos = { x = 7, y = 4},
	discovered = true,
	unlocked = true,
    config = { extra = { odds = 8 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_thrift_shop')
        return { vars = { numerator, denominator } }
    end,
	calculate = function(self, card, context)
	
		if context.reroll_shop and not context.blueprint then
		
			if SMODS.pseudorandom_probability(card, 'j8mod_thrift_shop', 1, card.ability.extra.odds) then
			
				return {
					message = "Awesome!",
					colour = G.C.GREEN,
					func = function()
						G.E_MANAGER:add_event(Event({
							trigger = "immediate",
							func = function()
								--- Credits to Eremel
								local tag_pool = get_current_pool('Tag')
								local selected_tag = pseudorandom_element(tag_pool, 'j8mod_thrift_shop')
								local it = 1
								while selected_tag == 'UNAVAILABLE' do
									it = it + 1
									selected_tag = pseudorandom_element(tag_pool, 'j8mod_thrift_shop_resample'..it)
								end
								local tag = Tag(selected_tag)
								if tag.name == "Orbital Tag" then
									local _poker_hands = {}
									for k, v in pairs(G.GAME.hands) do
										if v.visible then
											_poker_hands[#_poker_hands + 1] = k
										end
									end
									tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "j8mod_thrift_shop_orbital_tag")
								end
								tag:set_ability()
								add_tag(tag)
								return true
							end
						}))
						return true
					end
				}
			
			end
		
		end
	end
}

-- Marzipan Decoration
SMODS.Joker {
	key = "marzipan_decoration",
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers",
	pos = { x = 8, y = 4},
	discovered = true,
	unlocked = true,
    config = { extra = { odds = 6 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_marzipan_decoration')
		local main_end = nil
        if card.area and card.area == G.jokers then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { numerator, denominator }, main_end = main_end }
    end,
    calculate = function(self, card, context)
		 -- gros michel
		 if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'j8mod_marzipan_decoration', 1, card.ability.extra.odds) then
				return {
					message = localize('k_eaten_ex'),
					func = function()
						SMODS.destroy_cards(card)
						return true
					end
				}
			end
		end
		-- blueprint
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
        end
        return SMODS.blueprint_effect(card, other_joker, context)
    end
}

-- Modeling Clay
SMODS.Joker {
    key = "modeling_clay",
    blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 2,
    cost = 9,
	atlas = "j8jokers-clay",
    pos = { x = 0, y = 0 },
    discovered = true,
	unlocked = true,
    config = { extra = { copying_joker = "j_joker" } },
    loc_vars = function(self, info_queue, card)
		--[[
        local main_end = {
			{n = G.UIT.C, config = {align = "cm", padding = 0.0}, nodes = {
				{n = G.UIT.R, config = {align = "cm", padding = 0.0}, nodes = {
						{n = G.UIT.T, config = {text = "(Currently ", colour = G.C.UI.TEXT_INACTIVE, scale = 0.32}},
						{n = G.UIT.T, config = {text = localize { type = 'name_text', set = "Joker", key = card.ability.extra.copying_joker }, colour = G.C.FILTER, scale = 0.32}},
						{n = G.UIT.T, config = {text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.32}}
					},
				},
				}
			}
		}
		]]--
		info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.copying_joker]
		info_queue[#info_queue + 1] = { key = "credits_sharb", set = "Other" }
		return {vars = {card.ability.extra.copying_joker and localize({type = 'name_text', set = "Joker", key = card.ability.extra.copying_joker}) or 'Nothing', colours = { card.ability.extra.copying_joker and G.C.RARITY[G.P_CENTERS[card.ability.extra.copying_joker].rarity] or G.C.FILTER }}}
	end,
	draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('j8mod_normal_mapped', nil, card.ARGS.send_to_shader)
        end
    end,
	calculate = function(self, card, context)
		-- thanks, somethingcom515 !
		if (context.setting_blind or context.pre_discard) and not context.blueprint then
			card.ability.extra.copying_joker = pseudorandom_element(G.P_CENTER_POOLS.Joker, 'j8mod_modeling_clay').key
			return {
				message = localize { type = 'name_text', set = "Joker", key = card.ability.extra.copying_joker } .. "!",
				colour = G.C.RARITY[G.P_CENTERS[card.ability.extra.copying_joker].rarity]
			}
		end
		if card.ability.extra.copying_joker then
			local key = card.ability.extra.copying_joker
			G.j8mod_savedjokercards = G.j8mod_savedjokercards or {}
			G.j8mod_savedjokercards[card.sort_id] = G.j8mod_savedjokercards[card.sort_id] or {}
			if not G.j8mod_savedjokercards[card.sort_id][key] then
				local old_ability = copy_table(card.ability)
				local old_center = card.config.center
				local old_center_key = card.config.center_key
				card:set_ability(key, nil, 'quantum')
				card:update(0.016)
				G.j8mod_savedjokercards[card.sort_id][key] = SMODS.shallow_copy(card)
				G.j8mod_savedjokercards[card.sort_id][key].ability = copy_table(G.j8mod_savedjokercards[card.sort_id][key].ability)
				for i, v in ipairs({"T", "VT", "CT"}) do
					G.j8mod_savedjokercards[card.sort_id][key][v] = copy_table(G.j8mod_savedjokercards[card.sort_id][key][v])
				end
				G.j8mod_savedjokercards[card.sort_id][key].config = SMODS.shallow_copy(G.j8mod_savedjokercards[card.sort_id][key].config)
				card.ability = old_ability
				card.config.center = old_center
				card.config.center_key = old_center_key
				for i, v in ipairs({'juice_up', 'start_dissolve', 'remove', 'flip'}) do
					G.j8mod_savedjokercards[card.sort_id][key][v] = function(_, ...)
						return Card[v](card, ...)
					end
				end
			end
			return G.j8mod_savedjokercards[card.sort_id][key]:calculate_joker(context)
		end
	end,
}

-- Geode
SMODS.Joker {
	key = "geode",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 1,
	cost = 4,
	atlas = "j8jokers",
	pos = { x = 0, y = 5},
	discovered = true,
	unlocked = true,
    config = { extra = { enhancement_type = "m_stone" } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		if card.ability.extra.enhancement_type and card.ability.extra.enhancement_type ~= "m_stone" then
			info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement_type]
		end
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.enhancement_type and localize({type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement_type}) or 'Nothing' } }
    end,
	calculate = function(self, card, context)
		-- thanks, somethingcom515 !
		if context.setting_blind and not context.blueprint then
			card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'j8mod_geode').key
			local it = 0
			while (card.ability.extra.enhancement_type == "m_stone" or card.ability.extra.enhancement_type == "m_wild") do
				card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'j8mod_geode_resample'..it).key
				it = it + 1
			end
			return {
				message = localize { type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement_type } .. "!"
			}
		end
		if context.check_enhancement then
			if (context.other_card.config.center.key == "m_stone") and (context.other_card.area and context.other_card.area == G.play or context.other_card.area == G.hand) then
				if card.ability.extra.enhancement_type == "m_bonus" then
					return {
						m_bonus = true,
					}
				elseif card.ability.extra.enhancement_type == "m_mult" then
					return {
						m_mult = true,
					}
				elseif card.ability.extra.enhancement_type == "m_gold" then
					return {
						m_gold = true,
					}
				elseif card.ability.extra.enhancement_type == "m_steel" then
					return {
						m_steel = true,
					}
				elseif card.ability.extra.enhancement_type == "m_lucky" then
					return {
						m_lucky = true,
					}
				elseif card.ability.extra.enhancement_type == "m_glass" then
					return {
						m_glass = true,
					}
				end
			end
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'j8mod_geode').key
		local it = 0
		while (card.ability.extra.enhancement_type == "m_stone" or card.ability.extra.enhancement_type == "m_wild") do
			card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'j8mod_geode_resample'..it).key
			it = it + 1
		end
    end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

-- Hypnotic Joker
SMODS.Joker {
	key = "hypnotic_joker",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers-hypno",
	pos = { x = 0, y = 0},
	soul_pos = {
        x = 1, y = 0,
        draw = function(card, scale_mod, rotate_mod)
            card.children.floating_sprite:draw_shader('j8mod_spiral', nil, card.ARGS.send_to_shader, nil,
                card.children.center)
        end
    },
	discovered = true,
	unlocked = true,
    config = { extra = { chips = 1, mult = 1, adding_chips = true } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.adding_chips and "Chips" or "Mult", colours = { card.ability.extra.adding_chips and G.C.CHIPS or G.C.MULT } } }
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if card.ability.extra.adding_chips then
				context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
			else
				context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
			end
			card.ability.extra.adding_chips = not card.ability.extra.adding_chips
            return {
                message = localize('k_upgrade_ex'),
                colour = (not card.ability.extra.adding_chips) and G.C.CHIPS or G.C.MULT
            }
        end
	end
}

-- Funnybones
SMODS.Joker {
	key = "funnybones",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = false,
	rarity = 1,
	cost = 4,
	atlas = "j8jokers",
	pos = { x = 5, y = 2},
	discovered = true,
	unlocked = true,
    config = { extra = { t_chips = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		local has_self = next(SMODS.find_card(self.key))
		local ret_vals = { card.ability.extra.t_chips, "(...?)", "", "", "", "", colours = { G.C.UI.TEXT_INACTIVE, G.C.FILTER, G.C.UI.TEXT_INACTIVE} }
		if has_self then
			ret_vals[2] = "(Top card of deck is "
			ret_vals[3] = localize((G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.value or "Ace"), 'ranks')
			ret_vals[4] = " of "
			ret_vals[5] = localize(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit or 'Diamonds', 'suits_plural')
			ret_vals[6] = ")"
			ret_vals.colours[3] = G.deck and G.deck.cards[1] and G.C.SUITS[ret_vals[5]] or G.C.UI.TEXT_INACTIVE
		end
        return { vars = 
			ret_vals
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.t_chips * (#G.hand.cards + #G.jokers.cards + #G.consumeables.cards)
            }
        end
    end
}

-- Rap Battle
SMODS.Joker {
	key = "rap_battle",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 1,
	cost = 4,
	atlas = "j8jokers",
	pos = { x = 6, y = 2 },
	discovered = true,
	unlocked = true,
    config = { extra = { retriggers = 1, poker_hand = 'High Card' } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_gimmick", set = "Other" }
        return { vars = { card.ability.extra.retriggers, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.scoring_name == card.ability.extra.poker_hand then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
        if context.after and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'j8mod_rap_battle')
            return {
                message = localize('k_reset')
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'j8mod_rap_battle')
    end
}

-- Hating Simulator
SMODS.Joker {
	key = "hating_simulator",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 7,
	atlas = "j8jokers",
	pos = { x = 6, y = 2 },
	discovered = true,
	unlocked = true,
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
    end,
    calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
			return {
				message = localize("k_active_ex"),
				message_card = card
			}
        end
		if context.destroy_card and not context.blueprint then
			local _hand, _tally = nil, 0
			for _, handname in ipairs(G.handlist) do
				if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > _tally then
					_hand = handname
					_tally = G.GAME.hands[handname].played
				end
			end
			if (context.cardarea == G.play or context.cardarea == 'unscored') and G.GAME.current_round.hands_played == 0 and context.scoring_name == _hand then
				return { 
					remove = true
				}
			end
		end
    end
}

-- Weather Together
SMODS.Joker {
	key = "weather_together",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 7,
	atlas = "j8jokers",
	pos = { x = 3, y = 5 },
	discovered = true,
	unlocked = true,
    config = { extra = { rot_extra = 0.0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			--print(card.config.center.key)
			--print(card.config.center)
			--print(card.ability)
			local saved_chips = hand_chips
			local saved_mult = mult
			mult = mod_mult(saved_chips)
			hand_chips = mod_chips(saved_mult)
			G.E_MANAGER:add_event(Event({
				trigger = "ease",
				ease = "elastic",
				blocking = false,
				delay = 0.75,
				ref_table = card.config.center.config.extra,
				ref_value = "rot_extra",
				ease_to = card.config.center.config.extra.rot_extra + math.pi,
			}))
			return {
				message = "Swapped!",
				message_card = card,
				colour = G.C.PURPLE
			}
		end
	end
}

-- Color Cafe
SMODS.Joker {
	key = "color_cafe",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 11,
	atlas = "j8jokers",
	pos = { x = 7, y = 2},
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_polychrome"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_color_cafe')
        return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not (context.other_card.edition and context.other_card.edition.key == "e_polychrome") then
			if SMODS.pseudorandom_probability(card, 'j8mod_color_cafe', 1, card.ability.extra.odds) then
				local juice_card = context.other_card
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 1.0,
					blocking = false,
					func = function()
						juice_card:juice_up(0.5, 0.5)
						juice_card:set_edition("e_polychrome", true)
						return true
					end
				}))
				return {
					message = "Enhanced!",
					colour = G.C.EDITION,
					message_card = card
				}
			end
		end
	end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card.edition then
                return true
            end
        end
        return false
    end
}

-- Werewire
SMODS.Joker {
	key = "werewire",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers-werewire",
	pos = { x = 0, y = 0},
	soul_pos = {
        x = 1, y = 0,
        draw = function(card, scale_mod, rotate_mod)
            card.children.floating_sprite:draw_shader('j8mod_ww', nil, card.ARGS.send_to_shader, nil,
                card.children.center)
        end
    },
	--[[
    draw = function(self, card, layer)
        if (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('j8mod_ww', nil, card.ARGS.send_to_shader)
        end
    end,
	]]
	discovered = true,
	unlocked = true,
	config = { extra = { repetitions = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_polychrome"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.repetitions } }
	end,
	calculate = function(self, card, context)
		-- playing cards
        if context.repetition and (context.other_card.edition and context.other_card.edition.key == "e_polychrome") then
            return {
                repetitions = card.ability.extra.repetitions,
				colour = G.C.EDITION,
            }
        end
		-- jokers
		local rets = {}
		for i, joker in ipairs(G.jokers.cards) do
			if joker.edition and joker.edition.polychrome and joker ~= card then
				local ret = SMODS.blueprint_effect(card, joker, context)
				if ret then
					ret.colour = G.C.EDITION
				end
				table.insert(rets, ret)
			end
		end
		return SMODS.merge_effects(rets)
    end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, joker in ipairs(G.jokers.cards or {}) do
            if joker.edition and joker.edition == "e_polychrome" then
                return true
            end
        end
		for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card.edition and playing_card.edition == "e_polychrome" then
                return true
            end
        end
        return false
    end
}

-- D100

SMODS.Joker {

	key = "d100",
    blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 2, y = 5 },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.selling_self then
		
			local cards_to_spindown = {}
			if G.STATE == G.STATES.SHOP then
				-- get all shop cards
				for index, shop_card in ipairs(G.shop_jokers.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
				-- get all shop vouchers
				for index, shop_card in ipairs(G.shop_vouchers.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
				-- get all shop booster packs
				for index, shop_card in ipairs(G.shop_booster.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
			elseif G.STATE == G.STATES.SELECTING_HAND then
				-- get all cards in hand
				for index, card in ipairs(G.hand.cards) do
					table.insert(cards_to_spindown, card)
				end
			end
			
			-- get all jokers
			for index, joker in ipairs(G.jokers.cards) do
				if joker ~= card then
					table.insert(cards_to_spindown, joker)
				end
			end
			-- get all consumables
			for index, cn in ipairs(G.consumeables.cards) do
				table.insert(cards_to_spindown, cn)
			end
			
			-- spin them down!
			for index, sd in ipairs(cards_to_spindown) do
				local percent = 0.85 + (index - 0.999) / (#cards_to_spindown - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						sd:flip()
						play_sound('card1', percent)
						sd:juice_up(0.3, 0.3)
						return true
					end
				}))
				delay(0.1)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						spindown(sd, pseudorandom("j8mod_d100", 1, 1000))
						sd:flip()
						play_sound('tarot2', percent, 0.6)
						sd:juice_up(0.3, 0.3)
						save_run()
						return true
					end
				}))
			end
            
            return nil, true -- This is for Joker retrigger purposes
        end
	end
	
}

-- Spindown Dice

SMODS.Joker {

	key = "spindown_dice",
    blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 8, y = 2 },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.selling_self then
		
			local cards_to_spindown = {}
			if G.STATE == G.STATES.SHOP then
				-- get all shop cards
				for index, shop_card in ipairs(G.shop_jokers.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
				-- get all shop vouchers
				for index, shop_card in ipairs(G.shop_vouchers.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
				-- get all shop booster packs
				for index, shop_card in ipairs(G.shop_booster.cards) do
					table.insert(cards_to_spindown, shop_card)
				end
			elseif G.STATE == G.STATES.SELECTING_HAND then
				-- get all cards in hand
				for index, card in ipairs(G.hand.cards) do
					table.insert(cards_to_spindown, card)
				end
			end
			
			-- get all jokers
			for index, joker in ipairs(G.jokers.cards) do
				if joker ~= card then
					table.insert(cards_to_spindown, joker)
				end
			end
			-- get all consumables
			for index, cn in ipairs(G.consumeables.cards) do
				table.insert(cards_to_spindown, cn)
			end
			
			-- spin them down!
			for index, sd in ipairs(cards_to_spindown) do
				local percent = 0.85 + (index - 0.999) / (#cards_to_spindown - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						sd:flip()
						play_sound('card1', percent)
						sd:juice_up(0.3, 0.3)
						return true
					end
				}))
				delay(0.1)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						spindown(sd, -1)
						sd:flip()
						play_sound('tarot2', percent, 0.6)
						sd:juice_up(0.3, 0.3)
						save_run()
						return true
					end
				}))
			end
		
            
            return nil, true -- This is for Joker retrigger purposes
        end
	end
	
}

-- Mizzmanaged
SMODS.Joker {
    key = "mizzmanaged",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	discovered = true,
	atlas = "j8jokers-yuri",
	pos = { x = 0, y = 0},
	soul_pos = {
        x = 1, y = 0,
        draw = function(card, scale_mod, rotate_mod)
            card.children.floating_sprite:draw_shader('j8mod_yuri', nil, card.ARGS.send_to_shader, nil,
                card.children.center)
        end
    },
    config = { extra = { Xmult_gain = 0.125, Xmult_extra = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult_extra, card.ability.extra.Xmult } }
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			local amount = 0
			if context.other_card.seal then
				amount = (context.other_card:get_id() == 12 and card.ability.extra.Xmult_extra) or card.ability.extra.Xmult_gain
			end
			if amount > 0 then
				card.ability.extra.Xmult = card.ability.extra.Xmult + amount
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					message_card = card
				}
			end
		end
		if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
	end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card.seal then
                return true
            end
        end
        return false
    end
}

-- Planetary Domination
SMODS.Joker {
	key = "planetary_domination",
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	rarity = 1,
	cost = 5,
	atlas = "j8jokers",
	pos = { x = 0, y = 3},
	discovered = true,
	unlocked = true,
	config = { extra = { mult = 0, mult_inc = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_inc } }
	end,
	calculate = function(self, card, context)
		-- selling
		if context.selling_card and not context.blueprint then
			if context.card.ability.set == "Planet" then
				-- See note about SMODS Scaling Manipulation on the wiki
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_inc
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.SECONDARY_SET.Planet
				}
			end
		end
		-- scoring
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
	in_pool = function(self, args)
        for _, hand in ipairs(G.GAME.hands or {}) do
            if hand.level > 1 then
                return true
            end
        end
        return false
    end
}

-- Citysweeper
SMODS.Joker {
	key = "citysweeper",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers",
	pos = { x = 1, y = 3},
	discovered = true,
	unlocked = true,
	config = { extra = { dollars = 0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_stone"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.dollars } }
	end,
	calculate = function(self, card, context)
		-- getting money
		if context.joker_main then
			card.ability.extra.dollars = card.ability.extra.dollars + G.GAME.hands[context.scoring_name].played
            return {
				message = localize('k_upgrade_ex'),
				colour = G.C.GOLD
			}
        end
		-- reset
		if context.setting_blind and not context.blueprint then
			card.ability.extra.dollars = 0
			return {
				message = localize('k_reset'),
				colour = G.C.GOLD
			}
		end
	end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,
	in_pool = function(self, args)
        for _, hand in ipairs(G.GAME.hands or {}) do
            if hand.level > 1 then
                return true
            end
        end
        return false
    end
}

-- Strike the Earth
SMODS.Joker {
    key = "strike_the_earth",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 1,
    cost = 5,
	atlas = "j8jokers",
	pos = { x = 2, y = 3},
	discovered = true,
	unlocked = true,
    config = { extra = { odds = 2, dollars = 5 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_strike_the_earth')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            SMODS.has_enhancement(context.other_card, "m_stone") and
            SMODS.pseudorandom_probability(card, 'j8mod_strike_the_earth', 1, card.ability.extra.odds) then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, this goes after the dollar modification
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

-- Expansion Plans
SMODS.Joker {
	key = "expansion_plans",
	blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
	rarity = 3,
	cost = 10,
	atlas = "j8jokers",
	pos = { x = 3, y = 3},
	discovered = true,
	unlocked = true,
    config = { extra = { money_current = 0, money_max = 150 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'e_negative', set = 'Edition', config = { extra = 1 } }
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.money_current, card.ability.extra.money_max } }
	end,
	calculate = function(self, card, context)
		if (context.buying_card or context.open_booster) and card ~= self then
		
		    card.ability.extra.money_current = card.ability.extra.money_current + context.card.cost
			SMODS.calculate_effect({
				trigger = "after",
				delay = 0.5,
				message = localize('k_upgrade_ex'),
				colour = G.C.MONEY
				}, 
			card)
			
			if card.ability.extra.money_current >= card.ability.extra.money_max then
				SMODS.calculate_effect({
					trigger = "after",
					delay = 0.5,
					message = localize('k_upgrade_ex'),
					colour = G.C.MONEY,
					func = function()
						SMODS.destroy_cards(card)
						local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.4,
							func = function()
								local eligible_card = pseudorandom_element(editionless_jokers, 'j8mod_expansion_plans')
								if eligible_card ~= nil then
									eligible_card:set_edition({ negative = true })

									card:juice_up(0.3, 0.5)
								end
								return true
							end
						}))
						return true
					end
					}, 
				card)
				
			end
			
		end
	end,
	in_pool = function(self, args)
		return G.GAME.dollars >= 25
	end
}

-- Thunder Carnival
SMODS.Joker {
    key = "thunder_carnival",
    unlocked = false,
    blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 1,
    cost = 4,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 4, y = 3 },
    config = { extra = { enhancement = "m_wild" } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement_type]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.enhancement and localize({type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement}) or 'Wild' } }
    end,
    calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local debuffed_cards = {}
			for i, scored_card in ipairs(context.full_hand) do
				if scored_card.debuff then
					table.insert(debuffed_cards, scored_card)
				end
			end
			if #debuffed_cards > 0 then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.SECONDARY_SET.Enhanced,
					func = function()
						for i, scored_card in ipairs(debuffed_cards) do
							local percent = 0.85 + (i - 0.999) / (#G.play.cards - 0.998) * 0.3
							G.E_MANAGER:add_event(Event({
								trigger = 'immediate',
								func = function()
									play_sound('card1', percent)
									scored_card:flip()
									return true
								end
							}))
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.2,
								func = function()
									scored_card:set_ability(card.ability.extra.enhancement)
									return true
								end
							}))
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.2,
								func = function()
									play_sound('tarot2', percent)
									scored_card:flip()
									return true
								end
							}))
						end
						return true
					end
				}
			end
		end
    end
}

-- Magic Card
SMODS.Joker {
    key = "magic_card",
    blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
	unlocked = true,
    pos = { x = 5, y = 3 },
    config = { extra = { booster_mod = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.booster_mod } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + card.ability.extra.booster_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - card.ability.extra.booster_mod
    end
}

-- Super Fighting Robot
SMODS.Joker {
    key = "super_fighting_robot",
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 6, y = 3 },
    config = { extra = { Xmult_gain = 1, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

-- Puzzle Swap
SMODS.Joker {
    key = "puzzle_swap",
    blueprint_compat = false,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
	perishable_compat = true,
	eternal_compat = true,
    pos = { x = 7, y = 3 },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_czarkhasm", set = "Other" }
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
        return { }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			if #G.consumeables.cards > 0 then
				return {
				    message = "Swap!",
					message_card = card,
					colour = G.C.BLUE,
					func = function()
						for index, cn in ipairs(G.consumeables.cards) do
							local percent = 0.85 + (index - 0.999) / (#G.consumeables.cards - 0.998) * 0.3
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.1,
								func = function()
									cn:flip()
									play_sound('card1', percent)
									cn:juice_up(0.3, 0.3)
									return true
								end
							}))
							delay(0.1)
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.1,
								func = function()
									cn:set_ability(pseudorandom_element(G.P_CENTER_POOLS[cn.ability.set], "j8mod_puzzle_swap"))
									cn:flip()
									play_sound('tarot2', percent, 0.6)
									cn:juice_up(0.3, 0.3)
									save_run()
									return true
								end
							}))
						end
						return true
					end
				}
			end
        end
    end,
}

-- The World Revolving
SMODS.Joker {
    key = "the_world_revolving",
    blueprint_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
	perishable_compat = true,
	eternal_compat = true,
    pos = { x = 8, y = 3 },
    config = { extra = { Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint then
			local do_chaos = G.GAME.chips + hand_chips * mult < G.GAME.blind.chips
			if do_chaos then
				return {
					message = "CHAOS!",
					colour = G.C.PURPLE,
					func = function()
						G.FUNCS.draw_from_hand_to_deck()
						G.deck:shuffle('nr'..G.GAME.round_resets.ante)
						return true
					end
				}
			end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

-- Spider Bake Sale
SMODS.Joker {
	key = "spider_bake_sale",
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	rarity = 2,
	cost = 9,
	atlas = "j8jokers",
	pos = { x = 9, y = 3},
	discovered = true,
	unlocked = true,
    config = { extra = { seal = 'Purple', money_current = 0, money_max = 12 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.seal, card.ability.extra.money_current, card.ability.extra.money_max } }
	end,
    calculate = function(self, card, context)
        if context.buying_card and card ~= self then
		
			--print (context.card or context.booster or context.voucher)
			--print(context.card.cost .. " vs " .. card.cost)
		    card.ability.extra.money_current = card.ability.extra.money_current + context.card.cost
			SMODS.calculate_effect({
				trigger = "after",
				delay = 0.5,
				message = localize('k_upgrade_ex'),
				colour = G.C.MONEY
				}, 
			card)
			
			while(card.ability.extra.money_current >= card.ability.extra.money_max) do
				card.ability.extra.money_current = card.ability.extra.money_current - card.ability.extra.money_max
				
				local possible_cards = {}
				for index, playing_card in ipairs(G.playing_cards) do
					if not playing_card.seal then
						table.insert(possible_cards, playing_card)
					end
				end
				if #possible_cards > 0 then
					local card_to_seal = pseudorandom_element(possible_cards, 'j8mod_spider_bake_sale')
					local it = 0
					while(card_to_seal.seal) do
						card_to_seal = pseudorandom_element(possible_cards, 'j8mod_spider_bake_sale'..it)
						it = it + 1
					end
					SMODS.calculate_effect({
						trigger = "after",
						delay = 1.0,
						message = "Ahuhuhu!",
						colour = G.C.PURPLE,
						func = function()
							card_to_seal:set_seal(card.ability.extra.seal)
							card_to_seal:juice_up()
							return true
						end
						}, 
					card)
				end
			end
		
		end
    end,
}

-- Dreambreaker
SMODS.Joker {
    key = "dreambreaker",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 0, y = 4 },
    config = { extra = { blind_multiplier = 0.25 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { number_format((card.ability.extra.blind_multiplier)*100) } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
			-- Reduce blind's requirement by 50%
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips - G.GAME.blind.chips * (card.ability.extra.blind_multiplier or 1.0))
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			SMODS.juice_up_blind()
			return {
				message = "Reduced!",
				message_card = card,
				colour = G.C.UI.TEXT_DARK
			}
		end
    end,
	in_pool = function(self, args)
		return G.GAME.round_resets.ante >= 4
	end
}

-- Marx Soul
SMODS.Joker {
    key = "marx_soul",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 2,
    cost = 8,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 1, y = 4 },
    config = { extra = { rank_inc = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.rank_inc } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and
			SMODS.has_enhancement(context.other_card, 'm_wild')  then
			
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
							SMODS.modify_rank(current_card, card.ability.extra.rank_inc)
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
            if SMODS.has_enhancement(playing_card, 'm_wild') then
                return true
            end
        end
        return false
    end
}

-- #sepTemmber

SMODS.Joker {

	key = "temmie_joker",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 9, y = 4 },
	config = { extra = { price_reduction = 1 } },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.price_reduction } }
    end,
	calculate = function(self, card, context)
		if context.selling_card and G.STATE == G.STATES.SHOP then
			-- return
			return {
				trigger = "immediate",
				message = "hoI!",
				colour =  G.C.GREEN,
				message_card = card,
				func = function()
					G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - 1)
					-- jokers
					for index, shop_card in ipairs(G.shop_jokers.cards) do
						if shop_card.cost > 0 then
							local new_cost = math.max(0, shop_card.cost - card.ability.extra.price_reduction)
							local msg = "$"..new_cost
							if new_cost <= 0 then
								msg = "Free!"
							end
							SMODS.calculate_effect({
								trigger = "after",
								delay = 0.5,
								message = msg,
								colour = G.C.MONEY,
								func = function()
									shop_card.cost = new_cost
									return true
								end
								}, 
							shop_card)
						end
					end
					-- vouchers
					for index, shop_card in ipairs(G.shop_vouchers.cards) do
						if shop_card.cost > 0 then
							local new_cost = math.max(0, shop_card.cost - card.ability.extra.price_reduction)
							local msg = "$"..new_cost
							if new_cost <= 0 then
								msg = "Free!"
							end
							SMODS.calculate_effect({
								trigger = "after",
								message = msg,
								colour = G.C.MONEY,
								func = function()
									shop_card.cost = new_cost
									return true
								end
								}, 
							shop_card)
						end
					end
					-- boosters
					for index, shop_card in ipairs(G.shop_booster.cards) do
						if shop_card.cost > 0 then
							local new_cost = math.max(0, shop_card.cost - card.ability.extra.price_reduction)
							local msg = "$"..new_cost
							if new_cost <= 0 then
								msg = "Free!"
							end
							SMODS.calculate_effect({
								trigger = "after",
								message = msg,
								colour = G.C.MONEY,
								func = function()
									shop_card.cost = new_cost
									save_run()
									return true
								end
								}, 
							shop_card)
						end
					end
					return true
				end
			}
		
		end
	
	end

}

-- Brown Magic
SMODS.Joker {
    key = "brown_magic",
    blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
    rarity = 3,
    cost = 11,
	atlas = "j8jokers",
    discovered = true,
    pos = { x = 0, y = 6 },
    config = { extra = { creates = 2, rarity = "Uncommon", perish_rounds = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative', set = 'Edition', config = { extra = 1 } }
		info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {card.ability.extra.perish_rounds, card.ability.extra.perish_rounds}}
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
        return { vars = { card.ability.extra.creates, card.ability.extra.rarity, card.ability.extra.perish_rounds, colours = { card.ability.extra.rarity and G.C.RARITY[card.ability.extra.rarity] or G.C.UI.TEXT_INACTIVE } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local jokers_to_create = card.ability.extra.creates
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, jokers_to_create do
						local new_joker = pseudorandom_element(G.P_CENTER_POOLS.Joker, "j8mod_brown_magic")
						--print(new_joker.key)
						--print("Perishable: " .. tostring(new_joker.perishable_compat))
						--print("Rarity: " .. tostring(new_joker.rarity))
						local it = 0
						while (not (new_joker.perishable_compat and new_joker.rarity == get_rarity_index(card.ability.extra.rarity) or new_joker.rarity == card.ability.extra.rarity)) do
							new_joker = pseudorandom_element(G.P_CENTER_POOLS.Joker, "j8mod_brown_magic"..it)
							--print(new_joker.key)
							--print("Perishable: " .. tostring(new_joker.perishable_compat))
							--print("Rarity: " .. tostring(new_joker.rarity))
							it = it + 1
						end
                        local new_card = SMODS.add_card {
                            key = new_joker.key,
                            rarity = card.ability.extra.rarity,
							edition = "e_negative",
                            key_append = 'j8mod_brown_magic' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
						new_card:set_perishable(true)
						new_card.ability.perish_rounds = card.ability.extra.perish_rounds
						new_card.ability.perish_tally = card.ability.extra.perish_rounds
						new_card.ability.brown_magic = true
						new_card:set_cost()
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end,
}

-- J8-Bit
SMODS.Joker {

	key = "j8bit",
	atlas = "j8jokers",
    pos = { x = 2, y = 4 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 4,
    cost = 20,
	config = { extra = { repetitions = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.repetitions } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 11 or context.other_card:get_id() == 8) and
		not (context.other_card.edition and context.other_card.edition.key == "e_negative") and not context.blueprint then
			local juice_card = context.other_card
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1.0,
				blocking = false,
				func = function()
					juice_card:juice_up(0.5, 0.5)
					juice_card:set_edition("e_negative", true)
					return true
				end
			}))
			return {
				message = "Enhanced!",
				color = G.C.EDITION,
				message_card = card
			}
		end
		-- playing cards
        if context.repetition and (context.other_card.edition and context.other_card.edition.key == "e_negative") then
            return {
                repetitions = card.ability.extra.repetitions,
				colour = G.C.EDITION,
            }
        end
		-- jokers
		if context.retrigger_joker_check and (context.other_card.edition and context.other_card.edition.key == "e_negative") then
			return { repetitions = 1 }
		end
    end

}

-- Niri
SMODS.Joker {

	key = "niri",
	atlas = "j8jokers",
    pos = { x = 3, y = 4 },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 4,
    cost = 20,
	config = { extra = { inc = 1, total = 0, total_current = 0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		
		return { vars = { card.ability.extra.inc, card.ability.extra.total_current, card.ability.extra.total } }
	end,
	calculate = function(self, card, context)
		if G.jokers and G.consumeables then
			local count = #G.jokers.cards * card.ability.extra.inc
			for index, consumable in ipairs(G.consumeables.cards) do
				if not (card.edition and card.edition.key == "e_negative") then
					count = count + card.ability.extra.inc
				end
			end
			card.ability.extra.total = count
		end
		
		if context.setting_blind then
			G.hand:change_size(-card.ability.extra.total_current)
			card.ability.extra.total_current = card.ability.extra.total
			G.hand:change_size(card.ability.extra.total_current)
		end
    end,
	remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.total_current)
    end

}

-- Cyber Niri
SMODS.Joker {

	key = "cyber_niri",
	atlas = "j8jokers",
    pos = { x = 4, y = 4 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 4,
    cost = 20,
	config = { extra = { inc = 1, hand_req = 2, total = 0, total_current = 0, Xmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		
		return { vars = { card.ability.extra.inc, card.ability.extra.hand_req, card.ability.extra.total_current, card.ability.extra.total, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if G.hand then
			local count = math.floor(G.hand.config.card_limit / card.ability.extra.hand_req) * card.ability.extra.inc
			card.ability.extra.total = count
		end
		
		if context.setting_blind and not context.blueprint then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.total_current
			card.ability.extra.total_current = card.ability.extra.total
			G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.total_current
		end
		
		if context.other_consumeable then
            return {
                x_mult = card.ability.extra.Xmult,
                message_card = context.other_consumable
            }
        end
    end,
	remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.total_current
    end

}

-- Aria
SMODS.Joker {

	key = "cackler",
	atlas = "j8jokers",
    pos = { x = 4, y = 6 },
    soul_pos = { x = 4, y = 7 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 4,
    cost = 20,
	config = { extra = { rank = "Ace" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_thatartisan", set = "Other" }
		return { vars = { localize((card.ability.extra.rank or "Ace"), 'ranks') } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
		    local card_in_hand = false
			for _, v in ipairs(G.play.cards) do
				if v == context.other_card then
					card_in_hand = true
					break
				end
			end
			if context.other_card.base.value == card.ability.extra.rank and card_in_hand then
				local ctx = {
					cardarea = G.play,
					full_hand = G.play.cards,
					scoring_hand = context.scoring_hand,
					scoring_name = context.scoring_name,
					poker_hands = context.poker_hands
				}
				local cards_to_trigger = {}
				for _, v in ipairs(G.hand.cards) do
					if v:can_calculate() and v.base.value == card.ability.extra.rank then
						table.insert(cards_to_trigger, v)
					end
				end
				if #cards_to_trigger > 0 then
					return {
						message = "Yeah!",
						message_card = card,
						func = function()
							for _, v in ipairs(cards_to_trigger) do
								SMODS.score_card(v, ctx)
							end
							return true
						end
					}
				end
			end
        end
    end

}

-- Maestro
SMODS.Joker {

	key = "maestro",
	atlas = "j8jokers",
    pos = { x = 0, y = 6 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
    rarity = 4,
    cost = 20,
	config = { extra = { Xmult = 0.2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.after then
			local do_mult = G.GAME.chips + hand_chips * mult >= G.GAME.blind.chips
			if do_mult then
				local cards_to_trigger = {}
				for _, v in ipairs(G.play.cards) do
					table.insert(cards_to_trigger, v)
				end
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT,
					func = function()
						for i=1, #cards_to_trigger do
							SMODS.calculate_effect({
								trigger = "after",
								delay = 1.0,
								message = localize("k_upgrade_ex"),
								message_card = cards_to_trigger[i],
								func = function()
									cards_to_trigger[i].ability.perma_x_mult = (cards_to_trigger[i].ability.perma_x_mult or 0) + card.ability.extra.Xmult
									return true
								end
							}, card)
						end
						return true
					end
				}
			end
        end
	end

}