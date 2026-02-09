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
	--[[
	soul_pos = {
		x = 1, y = 0,
		draw = function(card, scale_mod, rotate_mod)
			if not J8MOD.config.no_deltarune_spoilers then
				G.SHADERS['j8mod_prophecy']:send("depths_texture", J8MOD.prophecy_texture)
				--G.SHADERS['j8mod_prophecy']:send("depths_dimensions", {J8MOD.prophecy_texture:getWidth(), J8MOD.prophecy_texture:getHeight()})
				card.children.floating_sprite:draw_shader('j8mod_prophecy', nil, card.ARGS.send_to_shader, nil,
					card.children.center)
			end
		end
	},
	]]
	config = { extra = { prophecy_rounds = 0, total_rounds = 3, spectral_count = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_spell_tag" or "j_j8mod_prophecy", vars = { card.ability.extra.total_rounds, card.ability.extra.prophecy_rounds, card.ability.extra.spectral_count, [[localize { type = 'name_text', set = 'Tag', key = 'tag_ethereal' }]] } }
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
			--[[
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
			]]
			card:shatter()
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
	end,
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			card.T.w = G.CARD_W * (31 / 71)
			card.T.h = G.CARD_H * (82 / 95)
			card.children.center.scale.x = 31
			card.children.center.scale.y = 82
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers']
		else
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers-prophecy']
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
	pos = { x = 1, y = 0 },
	config = { extra = { extra_numerator = 0, extra_mod = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
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
					message = localize("j8mod_monty_hall_open"),
					colour = G.C.FILTER,
					func = function()
						card.ability.extra.extra_numerator = card.ability.extra.extra_numerator +
							card.ability.extra.extra_mod
					end
				}
			else
				return {
					message = localize('k_reset'),
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
	config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_metamorphic')
		return { vars = { numerator, denominator, localize({ type = 'name_text', set = "Enhanced", key = 'm_stone' }) or 'Stone Card', localize({ type = 'name_text', set = "Enhanced", key = 'm_glass' }) or 'Glass Card' } }
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
	config = { extra = { chips = 0, chip_mod = 4 } },
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
	rarity = 1,
	cost = 8,
	atlas = "j8jokers",
	discovered = true,
	unlocked = true,
	pos = { x = 4, y = 0 },
	pixel_size = { w = 49, h = 72 },
	config = { extra = { chips = 0, chip_mod = 4 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
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
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.booster_mod } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra
			.booster_mod
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra
			.booster_mod
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
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.c_min, card.ability.extra.s_count, card.ability.extra.s_mod } }
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step and not context.blueprint and #context.scoring_hand >= card.ability.extra.c_min then
			local random_seal = SMODS.poll_seal { guaranteed = true }
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
							message = "-" .. card.ability.extra.s_mod, --localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_mod } },
							colour = G.C.SECONDARY_SET.Enhanced,
							message_card = card
						}
					end
					return true
				end
			}))

			return {
				message = localize("j8mod_sandwiched_ex"),
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
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.mult, card.ability.extra.s_count, card.ability.extra.s_mod } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) +
				card.ability.extra.mult
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
					message = "-" .. card.ability.extra.s_mod,
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
	pixel_size = { w = 69, h = 78 },
	config = { extra = { ante_count = 0, ante_max = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { type = 'name_text', key = "c_soul", set = 'Spectral' }
		info_queue[#info_queue + 1] = { type = 'name_text', key = "c_black_hole", set = 'Spectral' }
		info_queue[#info_queue + 1] = { key = "credits_overgrownrobot", set = "Other" }
		return { vars = { card.ability.extra.ante_count, card.ability.extra.ante_max, localize { type = 'name_text', key = "c_soul", set = 'Spectral' }, localize { type = 'name_text', key = "c_black_hole", set = 'Spectral' } } }
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

-- Graffiti Artist
SMODS.Joker {
	key = "graffiti_artist",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 1,
	cost = 6,
	atlas = "j8jokers",
	discovered = true,
	unlocked = true,
	pos = { x = 9, y = 0 },
	config = { extra = { odds = 3 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_graffiti')
		local tag_text = ""
		if G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind:get_type() ~= "Boss" then
			--print(G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()])
			info_queue[#info_queue + 1] = { key = G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()], set = 'Tag' }
			tag_text = localize { type = 'name_text', set = 'Tag', key = G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()] }
		end
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		return { vars = { numerator, denominator, string.len(tag_text) > 0 and "[" or ("[" .. localize("j8mod_inactive")), tag_text, "]" } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval
			and SMODS.pseudorandom_probability(card, 'j8mod_graffiti', 1, card.ability.extra.odds) then
			-- thanks cryptid
			if G.GAME.blind:get_type() ~= "Boss" then
				return {
					message = localize("j8mod_tagged_ex"),
					colour = G.C.BLUE,
					message_card = card,
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								play_sound("tarot1")
								add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()]))
								return true
							end
						}))
					end
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
	rarity = 1,
	cost = 5,
	atlas = "j8jokers",
	pixel_size = { w = 23, h = 95 },
	pos = { x = 0, y = 1 },
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { G.GAME.current_round.j8mod_bookmark_rank and localize((G.GAME.current_round.j8mod_bookmark_rank), 'ranks') or "None" } }
	end,
	calculate = function(self, card, context)
		if (context.setting_blind or context.after) and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					for index, playing_card in ipairs(G.playing_cards) do
						SMODS.debuff_card(playing_card, false, 'j8mod_bookmark')
						if playing_card.base.value == G.GAME.current_round.j8mod_bookmark_rank and not SMODS.has_no_rank(playing_card) then
							SMODS.debuff_card(playing_card, 'prevent_debuff', 'j8mod_bookmark')
						end
						SMODS.recalc_debuff(playing_card)
					end
					return true
				end
			}))
		end
		-- reset debuff at end of round
		if context.end_of_round and not context.blueprint then
			for _, playing_card in ipairs(G.playing_cards) do
				SMODS.debuff_card(playing_card, false, 'j8mod_bookmark')
				SMODS.recalc_debuff(playing_card)
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		for index, playing_card in ipairs(G.playing_cards) do
			if playing_card.base.value == G.GAME.current_round.j8mod_bookmark_rank and not SMODS.has_no_rank(playing_card) then
				SMODS.debuff_card(playing_card, 'prevent_debuff', 'j8mod_bookmark')
				SMODS.recalc_debuff(playing_card)
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for _, playing_card in ipairs(G.playing_cards) do
			SMODS.debuff_card(playing_card, false, 'j8mod_bookmark')
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
	pos = { x = 1, y = 1 },
	discovered = true,
	unlocked = true,
	config = { extra = { chips = 0, chip_mod = 20, odds = 25 } },
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

-- Needlepoint Joker
SMODS.Joker {
	key = "needlepoint_joker",
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = false,
	rarity = 2,
	cost = 6,
	atlas = "j8jokers",
	pos = { x = 2, y = 1 },
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
	pixel_size = { w = 51, h = 81 },
	pos = { x = 3, y = 1 },
	discovered = true,
	unlocked = true,
	config = { extra = { rerolls = 2, rerolls_max = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.rerolls, card.ability.extra.rerolls_max } }
	end,
	calculate = function(self, card, context)
		local end_of_ante = context.end_of_round and context.game_over == false and context.main_eval and
			context.beat_boss
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
					message = localize("j8mod_flushed_ex"),
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
	rarity = 3,
	cost = 10,
	atlas = "j8jokers",
	pos = { x = 4, y = 1 },
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
					message = localize("j8mod_ranked_ex"),
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
					message = localize("j8mod_ranked_ex"),
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
					message = localize("j8mod_ranked_ex"),
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
	pos = { x = 5, y = 1 },
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
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 10,
	atlas = "j8jokers",
	pixel_size = { w = 55 },
	pos = { x = 6, y = 1 },
	discovered = true,
	unlocked = true,
	config = { extra = { saved_packs = {} } },
	loc_vars = function(self, info_queue, card)
		--[[
		info_queue[#info_queue + 1] = { key = "tag_charm", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_meteor", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_ethereal", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_buffoon", set = 'Tag' }
		info_queue[#info_queue + 1] = { key = "tag_standard", set = 'Tag' }
		]]
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.open_booster and context.card.from_tag == nil and not context.card.ability.j8mod_bogo and not context.blueprint and G.shop then
			table.insert(card.ability.extra.saved_packs, context.card.config.center.key)
			--print(card.ability.extra.saved_packs)
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

-- Assimilation Joker (old)
--[[
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
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		local extra_text = { localize("j8mod_inactive"), "", "" }
		local colours = { G.C.UI.TEXT_INACTIVE }
		local ret_vals = { nil, nil, "", "", "", colours = { G.C.UI.TEXT_INACTIVE, G.C.FILTER, G.C.UI.TEXT_INACTIVE } }
		if G.hand and G.GAME.current_round.hands_played == 0 and G.GAME.blind.in_blind then
			local new_value = card.ability.extra.rank_saved or 13
			for _, card in ipairs(G.hand.cards) do
				local do_add = true
				if G.hand.highlighted and #G.hand.highlighted > 0 then
					for i = 1, #G.hand.highlighted do
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
		return { vars = ret_vals }
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
					message = "+" .. value,
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
]]

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
	config = { extra = { enhancement = "m_wild" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { key = J8MOD.config.furry_mode and "j_j8mod_assimilation_joker" or "j_j8mod_copied_homework", vars = { card.ability.extra.enhancement and localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) or 'Wild' } }
	end,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			local cards_to_trigger = {}
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.UI.TEXT_DARK,
				func = function()
					for _, v in ipairs(G.hand.cards) do
						local percent = 0.85 + (_ - 0.999) / (#G.hand.cards - 0.998) * 0.3
						if _ < #G.hand.cards and SMODS.has_enhancement(v, card.ability.extra.enhancement) then
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.1,
								func = function()
									copy_card(G.hand.cards[_ + 1], v)
									play_sound('tarot2', percent, 0.6)
									v:juice_up(0.3, 0.5)
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
			if SMODS.has_enhancement(playing_card, "m_wild") then
				return true
			end
		end
		return false
	end,
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 8, y = 1 })
		else
			card.children.center:set_sprite_pos({ x = 7, y = 1 })
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
			for i = 1, #context.scoring_hand do
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
			for i = 1, #context.scoring_hand do
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
					message = localize("j8mod_tagged_ex"),
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
									selected_tag = pseudorandom_element(tag_pool, 'j8mod_fursona_resample' .. it)
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
										"j8mod_fursona_orbital_tag")
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
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 1, y = 2 })
		else
			card.children.center:set_sprite_pos({ x = 0, y = 2 })
		end
	end
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
	pos = { x = 2, y = 2 },
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
									for i = 1, #ranks_in_hand do
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
				SMODS.debuff_card(playing_card, false, 'j8mod_breakerbox')
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
	rarity = 1,
	cost = 6,
	atlas = "j8jokers",
	pos = { x = 3, y = 2 },
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
				local money_count = pseudorandom('j8mod_monster_card', card.ability.extra.money_min,
					card.ability.extra.money_max)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money_count
				return {
					message = localize("j8mod_pennies_ex"),
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
						message = localize("j8mod_loot_ex"),
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
				local joker_count = pseudorandom('j8mod_monster_card', card.ability.extra.joker_min,
					card.ability.extra.joker_max)
				local jokers_to_create = math.min(joker_count,
					G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
				if jokers_to_create == 0 then
					return {
						message = localize('k_no_room_ex'),
						colour = G.C.RED
					}
				else
					return {
						message = localize("j8mod_treasure_ex"),
						colour = G.C.FILTER,
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
	pos = { x = 4, y = 2 },
	discovered = true,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
		info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_bonus" }), localize({ type = 'name_text', set = "Enhanced", key = "m_mult" }), localize({ type = 'name_text', set = "Enhanced", key = "m_wild" }) } }
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
	pos = { x = 5, y = 2 },
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 7 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		info_queue[#info_queue + 1] = { key = "credits_fizlok", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_kitsune_mask')
		return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and
			#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			if (context.other_card:get_id() == 7) and (SMODS.pseudorandom_probability(card, 'j8mod_kitsune_mask', SMODS.has_enhancement(context.other_card, 'm_lucky') and 2 or 1, card.ability.extra.odds)) then
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
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	atlas = "j8jokers",
	pos = { x = 6, y = 2 },
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_thrift_shop')
		return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			if SMODS.pseudorandom_probability(card, 'j8mod_thrift_shop', 1, card.ability.extra.odds) then
				return {
					message = localize("j8mod_tagged_ex"),
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
									selected_tag = pseudorandom_element(tag_pool, 'j8mod_thrift_shop_resample' .. it)
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
										"j8mod_thrift_shop_orbital_tag")
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
	pos = { x = 7, y = 2 },
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 8 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
			'j8mod_marzipan_decoration')
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
		if context.post_trigger and context.other_card == card and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'j8mod_marzipan_decoration', 1, card.ability.extra.odds) then
				return {
					message = localize('k_eaten_ex'),
					message_card = card,
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

-- this is a shorthand for all the relevant values needed from set_ability
local function reduced_set_ability(card, center)
	local new_ability = {
		name = center.name or localize { type = 'name_text', key = center.key, set = center.set } or center.key,
		effect = center.effect,
		set = center.set,
		mult = center.config.mult or 0,
		h_mult = center.config.h_mult or 0,
		h_x_mult = center.config.h_x_mult or 0,
		h_dollars = center.config.h_dollars or 0,
		p_dollars = center.config.p_dollars or 0,
		t_mult = center.config.t_mult or 0,
		t_chips = center.config.t_chips or 0,
		x_mult = center.config.Xmult or center.config.x_mult or 1,
		h_chips = center.config.h_chips or 0,
		x_chips = center.config.x_chips or 1,
		h_x_chips = center.config.h_x_chips or 1,
		h_size = center.config.h_size or 0,
		d_size = center.config.d_size or 0,
		extra = copy_table(center.config.extra) or nil,
		type = center.config.type or '',
		order = center.order or nil,
		bonus = (card.ability.bonus or 0) + (center.config.bonus or 0),
		perma_bonus = 0,
		perma_x_chips = 0,
		perma_mult = card.ability and card.ability.perma_mult or 0,
		perma_x_mult = card.ability and card.ability.perma_x_mult or 0,
		perma_h_chips = card.ability and card.ability.perma_h_chips or 0,
		perma_h_x_chips = card.ability and card.ability.perma_h_x_chips or 0,
		perma_h_mult = card.ability and card.ability.perma_h_mult or 0,
		perma_h_x_mult = card.ability and card.ability.perma_h_x_mult or 0,
		perma_p_dollars = card.ability and card.ability.perma_p_dollars or 0,
		perma_h_dollars = card.ability and card.ability.perma_h_dollars or 0,
		extra_value = card.ability.extra_value or 0,
		hands_played_at_create = G.GAME and G.GAME.hands_played or 0,
		invis_rounds = center.name == 'Invisible Joker' and 0 or nil,
		caino_xmult = center.name == 'Caino' and 1 or nil,
		yorick_discards = center.name == 'Yorick' and center.config.extra.discards,
		burnt_hand = center.name == 'Loyalty Card' and 0 or nil,
		loyalty_remaining = center.name == 'Loyalty Card' and center.config.extra.every or nil,
		csau_extra_value = 0,
		card_limit = card.ability and card.ability.card_limit or 0,
		extra_slots_used = card.ability and card.ability.extra_slots_used or 0,
	}

	card.ability = {}
	for k, v in pairs(new_ability) do
		card.ability[k] = v
	end

	for k, v in pairs(center.config) do
		if not new_ability[k] then
			if type(v) == 'table' then
				card.ability[k] = copy_table(v)
			else
				card.ability[k] = v
			end
		end
	end

	-- have to do this individually
	if center.name == 'To Do List' then
		local _poker_hands = {}
		for k, v in pairs(G.GAME.hands) do
			if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands + 1] = k end
		end

		card.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('to_do'))
	end

	card:set_cost()
end

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
	config = {
		extra = {
			target_card = nil,
			timer = 0,
			timer_max = 3
		}
	},

	add_to_deck = function(self, card, from_debuff)
		if card.ability.j8mod_modeling_key then
			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			local ret = card:add_to_deck(from_debuff)
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']
			return ret
		end
	end,

	remove_from_deck = function(self, card, from_debuff)
		if card.ability.j8mod_modeling_key then
			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			card.added_to_deck = true
			local ret = card:remove_from_deck(from_debuff)
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']
			return ret
		end
	end,

	load = function(self, card, card_table, other_card)
		if card_table.ability.j8mod_modeling_key then
			reduced_set_ability(card, G.P_CENTERS[card_table.ability.j8mod_modeling_key])
			card.ability.j8mod_modeling_key = card_table.ability.j8mod_modeling_key
		end
	end,

	calc_dollar_bonus = function(self, card)
		if card.ability.j8mod_modeling_key then
			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			local ret = card:calculate_dollar_bonus()
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']
			return ret
		end
	end,

	calculate = function(self, card, context)
		if (context.setting_blind or context.pre_discard) and not card.debuff and not context.blueprint and not context.retrigger_joker then
			local center = pseudorandom_element(G.P_CENTER_POOLS.Joker, pseudoseed('j8_modeling_clay'))
			reduced_set_ability(card, center)
			card.ability.j8mod_modeling_key = center.key
			card.config.center.atlas = 'j8jokers-clay'
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = localize { type = 'name_text', set = "Joker", key = card.ability.j8mod_modeling_key } .. "!",
				colour = G.C.RARITY[G.P_CENTERS[card.ability.j8mod_modeling_key].rarity]
			})

			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			card.added_to_deck = nil
			card:add_to_deck()
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']
		end

		if card.ability.j8mod_modeling_key then
			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			local ret, triggered = card:calculate_joker(context)
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']

			return ret, triggered or true
		end
	end,

	update = function(self, card, dt)
		if card.ability.j8mod_modeling_key then
			card.config.center = G.P_CENTERS[card.ability.j8mod_modeling_key]
			local ret = card:update(dt)
			card.config.center = G.P_CENTERS['j_j8mod_modeling_clay']
			return ret
		end
	end,

	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		if not card then
			card = self:create_fake_card()
		end

		if card.ability and card.ability.j8mod_modeling_key then
			local target = {
				type = 'descriptions',
				key = card.ability.j8mod_modeling_key,
				set = 'Joker',
				nodes = desc_nodes,
				AUT = full_UI_table,
				vars =
					specific_vars or {}
			}
			local res = {}

			info_queue[#info_queue + 1] = G.P_CENTERS['j_j8mod_modeling_clay'];
			local obj = G.P_CENTERS[card.ability.j8mod_modeling_key]
			if obj.loc_vars and type(obj.loc_vars) == 'function' then
				res = obj:loc_vars(info_queue, card) or {}
				target.vars = res.vars or target.vars
				target.key = res.key or target.key
				target.set = res.set or target.set
				target.scale = res.scale
				target.text_colour = res.text_colour
			end

			if desc_nodes == full_UI_table.main and not full_UI_table.name then
				full_UI_table.name = localize { type = 'name', set = target.set, key = self.key, nodes = full_UI_table.name, vars = {} }
			elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name then
				desc_nodes.name = localize { type = 'name_text', key = self.key, set = target.set }
			end

			if specific_vars and specific_vars.debuffed and not res.replace_debuff then
				target = { type = 'other', key = 'debuffed_default', nodes = desc_nodes, AUT = full_UI_table }
			end

			local copied_name = localize { type = 'name_text', key = card.ability.j8mod_modeling_key, set = target.set }
			local copied_rarity_color = G.C.RARITY[G.P_CENTERS[card.ability.j8mod_modeling_key].rarity];
			desc_nodes[#desc_nodes + 1] = {
				{
					n = G.UIT.R,
					config = { align = "cm", colour = copied_rarity_color, padding = 0.04, r = 0.1 },
					nodes = {
						{ n = G.UIT.T, config = { text = copied_name, colour = G.C.UI.TEXT_LIGHT, scale = 0.26 } },
					}
				}
			}
			if res.main_start then
				desc_nodes[#desc_nodes + 1] = res.main_start
			end

			localize(target)

			if res.main_end then
				desc_nodes[#desc_nodes + 1] = res.main_end
			end

			desc_nodes.background_colour = res.background_colour
			return
		end

		if card.config and card.config.center.discovered then
			-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
			full_UI_table.name = localize { type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {} }
		end

		localize { type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars and self.loc_vars(self, info_queue, card).vars or {} }
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
	pos = { x = 8, y = 2 },
	discovered = true,
	unlocked = true,
	config = { extra = { enhancement_type = "m_stone" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		if card.ability.extra.enhancement_type and card.ability.extra.enhancement_type ~= "m_stone" then
			info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement_type]
		end
		info_queue[#info_queue + 1] = { key = "credits_overgrownrobot", set = "Other" }
		return { vars = { card.ability.extra.enhancement_type and localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement_type }) or 'Nothing' } }
	end,
	calculate = function(self, card, context)
		-- thanks, somethingcom515 !
		if context.setting_blind and not context.blueprint then
			card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'j8mod_geode').key
			local it = 0
			while (card.ability.extra.enhancement_type == "m_stone" or card.ability.extra.enhancement_type == "m_wild") do
				card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced,
					'j8mod_geode_resample' .. it).key
				it = it + 1
			end
			return {
				message = localize { type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement_type } ..
					"!"
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
			card.ability.extra.enhancement_type = pseudorandom_element(G.P_CENTER_POOLS.Enhanced,
				'j8mod_geode_resample' .. it).key
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
	pos = { x = 0, y = 1 },
	--[[
	soul_pos = {
		x = 1, y = 1,
		draw = function(card, scale_mod, rotate_mod)
			card.children.floating_sprite:draw_shader('j8mod_spiral', nil, card.ARGS.send_to_shader, nil,
				card.children.center)
		end
	},
	]]
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
				context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
					card.ability.extra.chips
			else
				context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) +
					card.ability.extra.mult
			end
			card.ability.extra.adding_chips = not card.ability.extra.adding_chips
			return {
				message = localize('k_upgrade_ex'),
				colour = (not card.ability.extra.adding_chips) and G.C.CHIPS or G.C.MULT
			}
		end
	end,
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 0, y = 1 })
			--[[
			if card.children.floating_sprite then
				card.children.floating_sprite:set_sprite_pos({ x = 1, y = 1 })
			end
			]]
		else
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			--[[
			if card.children.floating_sprite then
				card.children.floating_sprite:set_sprite_pos({ x = 1, y = 0 })
			end
			]]
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
	pos = { x = 9, y = 2 },
	discovered = true,
	unlocked = true,
	config = { extra = { t_chips = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		local has_self = next(SMODS.find_card(self.key))
		local ret_vals = { card.ability.extra.t_chips, "(...?)", "", "", "", "", colours = { G.C.UI.TEXT_INACTIVE, G.C.FILTER, G.C.UI.TEXT_INACTIVE } }
		if has_self then
			ret_vals[2] = "(Top card of deck is "
			ret_vals[3] = localize((G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.value or "Ace"),
				'ranks')
			ret_vals[4] = " of "
			ret_vals[5] = localize(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit or 'Diamonds',
				'suits_plural')
			ret_vals[6] = ")"
			ret_vals.colours[3] = G.deck and G.deck.cards[1] and G.C.SUITS[ret_vals[5]] or G.C.UI.TEXT_INACTIVE
		end
		return {
			vars =
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
	pos = { x = 0, y = 3 },
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
	pos = { x = 1, y = 3 },
	pixel_size = { w = 69, h = 70 },
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
	pos = { x = 3, y = 3 },
	discovered = true,
	unlocked = true,
	config = { extra = { rot_extra = 0.0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_reverse_polarity" or "j_j8mod_weather_together" }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			--if context.post_trigger and context.cardarea == G.jokers and context.other_card ~= self and not context.blueprint then
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
				ease_to = card.config.center.config.extra.rot_extra + math.pi
			}))
			return {
				message = localize("j8mod_swapped_ex"),
				message_card = card,
				colour = G.C.PURPLE
			}
		end
	end,
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 2, y = 3 })
		else
			card.children.center:set_sprite_pos({ x = 3, y = 3 })
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
	atlas = "j8jokers-swatch",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["e_polychrome"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j8mod_color_cafe')
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_makeup_palette" or "j_j8mod_color_cafe", vars = { numerator, denominator } }
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
					message = localize("j8mod_enhanced_ex"),
					colour = G.C.EDITION,
					message_card = card
				}
			end
		end
	end,
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 4, y = 3 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers']
			--card.children.floating_sprite.states.visible = false
		else
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers-swatch']
			--card.children.floating_sprite.states.visible = true
		end
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
	pos = { x = 0, y = 0 },
	--[[
	soul_pos = {
		x = 1, y = 0,
		draw = function(card, scale_mod, rotate_mod)
			if not J8MOD.config.no_deltarune_spoilers then
				card.children.floating_sprite:draw_shader('j8mod_ww', nil, card.ARGS.send_to_shader, nil,
					card.children.center)
			end
		end
	},
	]]
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
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_pinwheel" or "j_j8mod_werewire", vars = { card.ability.extra.repetitions } }
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
	end,
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 5, y = 3 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers']
			--card.children.floating_sprite.states.visible = false
		else
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers-werewire']
			--card.children.floating_sprite.states.visible = true
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
	pos = { x = 6, y = 3 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
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
	pos = { x = 7, y = 3 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
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
	pos = { x = 0, y = 1 },
	--[[
	soul_pos = {
		x = 1, y = 1,
		draw = function(card, scale_mod, rotate_mod)
			if not J8MOD.config.no_deltarune_spoilers then
				card.children.floating_sprite:draw_shader('j8mod_yuri', nil, card.ARGS.send_to_shader, nil,
					card.children.center)
			end
		end
	},
	]]
	config = { extra = { Xmult_gain = 0.125, Xmult_extra = 0.25, Xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_iron_maiden" or "j_j8mod_mizzmanaged", vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult_extra, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			local amount = 0
			if context.other_card.seal then
				amount = (context.other_card:get_id() == 12 and card.ability.extra.Xmult_extra) or
					card.ability.extra.Xmult_gain
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
	end,
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 8, y = 3 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers']
		else
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers-yuri']
			if J8MOD.config.furry_mode then
				card.children.center:set_sprite_pos({ x = 0, y = 1 })
				--[[
				if card.children.floating_sprite then
					card.children.floating_sprite:set_sprite_pos({ x = 1, y = 1 })
				end
				]]
			else
				card.children.center:set_sprite_pos({ x = 0, y = 0 })
				--[[
				if card.children.floating_sprite then
					card.children.floating_sprite:set_sprite_pos({ x = 1, y = 0 })
				end
				]]
			end
		end
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
	pos = { x = 0, y = 4 },
	discovered = true,
	unlocked = true,
	config = { extra = { mult = 0, mult_inc = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_vjb", set = "Other" }
		if not J8MOD.config.furry_mode then
			info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		end
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
	end,
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 0, y = 4 })
		else
			card.children.center:set_sprite_pos({ x = 9, y = 3 })
		end
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
	pos = { x = 2, y = 4 },
	discovered = true,
	unlocked = true,
	config = { extra = { dollars = 0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_vjb", set = "Other" }
		if not J8MOD.config.furry_mode then
			info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		end
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
	end,
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 2, y = 4 })
		else
			card.children.center:set_sprite_pos({ x = 1, y = 4 })
		end
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
	pos = { x = 3, y = 4 },
	discovered = true,
	unlocked = true,
	config = { extra = { odds = 2, dollars = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
			'j8mod_strike_the_earth')
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
	rarity = 2,
	cost = 9,
	atlas = "j8jokers",
	pos = { x = 5, y = 4 },
	discovered = true,
	unlocked = true,
	config = { extra = { money_current = 0, money_max = 150 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'e_negative', set = 'Edition', config = { extra = 1 } }
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { card.ability.extra.money_current, card.ability.extra.money_max } }
	end,
	calculate = function(self, card, context)
		if (context.buying_card or context.buying_voucher or context.open_booster) and not context.buying_self and context.card ~= card and not context.blueprint then
			if context.card and context.card.cost > 0 then
				card.ability.extra.money_current = card.ability.extra.money_current + context.card.cost
				SMODS.calculate_effect({
						trigger = "after",
						delay = 0.5,
						message = localize('k_upgrade_ex'),
						colour = G.C.MONEY
					},
					card)
			end

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
									local eligible_card = pseudorandom_element(editionless_jokers,
										'j8mod_expansion_plans')
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
		return G.GAME.dollars >= to_big(25)
	end,
	update = function(self, card, dt)
		if J8MOD.config.furry_mode then
			card.children.center:set_sprite_pos({ x = 5, y = 4 })
		else
			card.children.center:set_sprite_pos({ x = 4, y = 4 })
		end
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
	pos = { x = 6, y = 4 },
	config = { extra = { enhancement = "m_wild" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement_type]
		info_queue[#info_queue + 1] = { key = "credits_neognw", set = "Other" }
		return { vars = { card.ability.extra.enhancement and localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) or 'Wild Card' } }
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
	pos = { x = 7, y = 4 },
	config = { extra = { booster_mod = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_neognw", set = "Other" }
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
	pos = { x = 8, y = 4 },
	config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },
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
	pos = { x = 9, y = 4 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_czarkhasm", set = "Other" }
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return {}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			if #G.consumeables.cards > 0 then
				return {
					message = localize("j8mod_swapped_ex"),
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
									cn:set_ability(pseudorandom_element(G.P_CENTER_POOLS[cn.ability.set],
										"j8mod_puzzle_swap"))
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
	atlas = "j8jokers-jevil",
	discovered = true,
	perishable_compat = true,
	eternal_compat = true,
	pos = { x = 0, y = 0 },
	config = { extra = { Xmult = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { key = J8MOD.config.no_deltarune_spoilers and "j_j8mod_sleight_of_hand" or "j_j8mod_the_world_revolving", vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			local do_chaos = G.GAME.chips + hand_chips * mult < G.GAME.blind.chips
			if do_chaos then
				return {
					message = localize("j8mod_chaos_ex"),
					colour = G.C.PURPLE,
					func = function()
						G.FUNCS.draw_from_hand_to_deck()
						G.deck:shuffle('nr' .. G.GAME.round_resets.ante)
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
	update = function(self, card, dt)
		if J8MOD.config.no_deltarune_spoilers then
			card.children.center:set_sprite_pos({ x = 0, y = 5 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers']
			--card.children.floating_sprite.states.visible = false
		else
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			card.children.center.atlas = G.ASSET_ATLAS['j8mod_j8jokers-jevil']
			--card.children.floating_sprite.states.visible = true
		end
	end
}

-- Spider Bake Sale
SMODS.Joker {
	key = "spider_bake_sale",
	blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = true,
	rarity = 2,
	cost = 9,
	atlas = "j8jokers",
	pos = { x = 1, y = 5 },
	discovered = true,
	unlocked = true,
	config = { extra = { seal = 'Purple', money_current = 0, money_max = 12 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { card.ability.extra.seal, card.ability.extra.money_current, card.ability.extra.money_max } }
	end,
	calculate = function(self, card, context)
		if (context.buying_card or context.buying_voucher or context.open_booster) and not context.buying_self and context.card ~= card and not context.blueprint then
			--print(context.card or context.booster or context.voucher)
			--print(context.card.cost .. " vs " .. card.cost)
			if context.card and context.card.cost > 0 then
				card.ability.extra.money_current = card.ability.extra.money_current + context.card.cost
				SMODS.calculate_effect({
						trigger = "after",
						delay = 0.5,
						message = localize('k_upgrade_ex'),
						colour = G.C.MONEY
					},
					card)
			end

			while (card.ability.extra.money_current >= card.ability.extra.money_max) do
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
					while (card_to_seal.seal) do
						card_to_seal = pseudorandom_element(possible_cards, 'j8mod_spider_bake_sale' .. it)
						it = it + 1
					end
					SMODS.calculate_effect({
							trigger = "after",
							delay = 1.0,
							message = localize("j8mod_muffet_laugh"),
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
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 11,
	atlas = "j8jokers",
	discovered = true,
	pos = { x = 2, y = 5 },
	config = { extra = { blind_multiplier = 0.25 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { number_format((card.ability.extra.blind_multiplier) * 100) } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			-- Reduce blind's requirement by 50%
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips -
				G.GAME.blind.chips * (card.ability.extra.blind_multiplier or 1.0))
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			SMODS.juice_up_blind()
			return {
				message = localize("j8mod_reduced_ex"),
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
	pos = { x = 3, y = 5 },
	config = { extra = { rank_inc = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		info_queue[#info_queue + 1] = { key = "credits_overgrownrobot", set = "Other" }
		return { vars = { card.ability.extra.rank_inc } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.other_card.debuff and
			SMODS.has_enhancement(context.other_card, 'm_wild') then
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

-- Program Advance
SMODS.Joker {

	key = "program_advance",
	atlas = "j8jokers-bn",
	pos = { x = 0, y = 0 },
	pixel_size = { w = 74, h = 98 },
	display_size = { w = 74, h = 98 },
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 6,
	config = { extra = { poker_hand = "Straight Flush" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_neognw", set = "Other" }
		return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands') } }
	end,
	calculate = function(self, card, context)
		if context.pre_joker and not context.blueprint and next(context.poker_hands[card.ability.extra.poker_hand]) then
			local suits_in_played_cards = {}
			for _, v in ipairs(G.play.cards) do
				suits_in_played_cards[v.base.suit] = true
				--print(v.base.suit)
			end
			local cards_to_trigger = {}
			for _, v in ipairs(G.hand.cards) do
				if v:can_calculate() and suits_in_played_cards[v.base.suit] then
					--print(v:get_id())
					table.insert(cards_to_trigger, v)
				end
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
					message = localize("j8mod_program_advance"),
					message_card = card,
					colour = G.C.BLUE,
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
	in_pool = function(self, args)
		return G.GAME.hands["Straight Flush"].played > 0
	end,
	set_ability = function(self, card, initial, delay_sprites)
		if self.discovered or card.bypass_discovery_center then
			card.T.w = G.CARD_W * (74 / 71)
			card.T.h = G.CARD_H * (98 / 95)
		end
	end,

}

-- Colony Tile
SMODS.Joker {
	key = "colony_tile",
	atlas = "j8jokers",
	pos = { x = 4, y = 5 },
	pixel_size = { w = 69, h = 69 },
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = false,
	rarity = 2,
	cost = 7,
	config = { extra = { poker_hand = "Full House", scale_amount = 1, hand_size = 0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_j8", set = "Other" }
		return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.scale_amount, card.ability.extra.hand_size } }
	end,
	calculate = function(self, card, context)
		local my_card = card
		if context.setting_blind and not context.blueprint then
			return {
				message = localize("k_reset"),
				colour = G.C.SECONDARY_SET.Planet,
				func = function()
					G.hand:change_size(-my_card.ability.extra.hand_size)
					my_card.ability.extra.hand_size = 0
					return true
				end
			}
		end
		if context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]) and not context.blueprint then
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.YELLOW,
				func = function()
					my_card.ability.extra.hand_size = my_card.ability.extra.hand_size +
						my_card.ability.extra.scale_amount
					G.hand:change_size(my_card.ability.extra.scale_amount)
					return true
				end
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size)
	end
}

-- Rule of Threes
SMODS.Joker {
	key = "rule_of_threes",
	atlas = "j8jokers",
	pos = { x = 5, y = 5 },
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	cost = 10,
	config = { extra = { poker_hand = "Three of a Kind", scale_amount = 0.3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_overgrownrobot", set = "Other" }
		return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.scale_amount, 1.0 + card.ability.extra.scale_amount * G.GAME.hands[card.ability.extra.poker_hand].played } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.hands[card.ability.extra.poker_hand].played > 0 then
			return {
				xmult = 1.0 + card.ability.extra.scale_amount * G.GAME.hands[card.ability.extra.poker_hand].played
			}
		end
	end,
	in_pool = function(self, args)
		return G.GAME.hands["Three of a Kind"].played > 0
	end
}

-- Cereal Box
SMODS.Joker {
	key = "cereal_box",
	atlas = "j8jokers",
	pos = { x = 6, y = 5 },
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	rarity = 1,
	cost = 4,
	config = { extra = { booster_type = "p_spectral_jumbo" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.booster_type .. "_1"]
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return { vars = { localize({ type = 'name_text', key = card.ability.extra.booster_type, set = 'Other' }) } }
	end,
	calculate = function(self, card, context)
		if context.starting_shop then
			SMODS.calculate_effect({
				trigger = "after",
				delay = 1.0,
				message = localize('k_eaten_ex'),
				message_card = card,
				colour = G.C.FILTER,
				func = function()
					local pack = SMODS.add_booster_to_shop(card.ability.extra.booster_type .. "_1")
					pack.states.visible = nil
					G.E_MANAGER:add_event(Event({
						func = function()
							pack:start_materialize()
							if context.blueprint_card then
								context.blueprint_card:juice_up()
							else
								card:juice_up()
							end
							save_run()
							return true
						end
					}))
					if not context.blueprint then
						G.E_MANAGER:add_event(Event({
							delay = 0.25,
							func = function()
								SMODS.destroy_cards(card, nil, nil, true)
								return true
							end
						}))
					end
					return true
				end
			}, card)
		end
	end
}

function lowest_level_poker_hand()
	local lowest_hand, lowest_level, order = "High Card", -1, 100
	for _, v in pairs(G.GAME.hands) do
		print(_ .. tostring(v))
		if G.GAME.hands[_].visible and (lowest_level < 0 or (v.level < lowest_level or v.level == lowest_level and order > v.order)) then
			lowest_level = v.level
			lowest_hand = _
			--print(lowest_hand .. "is now the lowest at level " .. tostring(lowest_level))
		end
	end
	return lowest_hand
end

-- Community Resource
SMODS.Joker {
	key = "community_resource",
	atlas = "j8jokers",
	pos = { x = 7, y = 5 },
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	cost = 8,
	config = { extra = { ranks = { 6, 7, 8, 9, 10 }, odds = 10 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
			'j8mod_community_resource')
		local rank_keys = {}
		for i = 1, #card.ability.extra.ranks do
			local key = ""
			for k, v in pairs(SMODS.Ranks) do
				if v.id == card.ability.extra.ranks[i] then
					key = v.key
					break
				end
			end
			table.insert(rank_keys, key)
		end
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {
			vars = {
				localize((rank_keys[1] or "6"), 'ranks'),
				localize((rank_keys[2] or "7"), 'ranks'),
				localize((rank_keys[3] or "8"), 'ranks'),
				localize((rank_keys[4] or "9"), 'ranks'),
				localize((rank_keys[5] or "10"), 'ranks'),
				numerator, denominator
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local is_rank = false
			for _, rank in ipairs(card.ability.extra.ranks) do
				if context.other_card:get_id() == rank then
					is_rank = true
					break
				end
			end
			if is_rank and SMODS.pseudorandom_probability(card, 'j8mod_community_resource', 1, card.ability.extra.odds) then
				return {
					level_up = true,
					level_up_hand = lowest_level_poker_hand()
				}
			end
		end
	end
}

-- J8-Bit
SMODS.Joker {

	key = "j8bit",
	atlas = "j8jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 1, y = 6 },
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
				message = localize("j8mod_enhanced_ex"),
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
	pos = { x = 2, y = 6 },
	soul_pos = { x = 3, y = 6 },
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = false,
	rarity = 4,
	cost = 20,
	config = { extra = { extra_boosters = 2, extra_vouchers = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }

		return { vars = { card.ability.extra.extra_boosters, card.ability.extra.extra_vouchers } }
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(card.ability.extra.extra_boosters)
		SMODS.change_voucher_limit(card.ability.extra.extra_vouchers)
	end,
	remove_from_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(-card.ability.extra.extra_boosters)
		SMODS.change_voucher_limit(-card.ability.extra.extra_vouchers)
	end
	--[[
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
	]]

}

-- Cyber Niri
SMODS.Joker {

	key = "cyber_niri",
	atlas = "j8jokers",
	pos = { x = 4, y = 6 },
	soul_pos = { x = 5, y = 6 },
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	rarity = 4,
	cost = 20,
	--config = { extra = { inc = 1, hand_req = 2, total = 0, total_current = 0, Xmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "credits_placeholder", set = "Other" }
		return {}
		--return { vars = { card.ability.extra.inc, card.ability.extra.hand_req, card.ability.extra.total_current, card.ability.extra.total, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint then
			local num_boosters = 2 + (G.GAME.modifiers.extra_boosters or 0)
			local num_vouchers = 1 + (G.GAME.modifiers.extra_vouchers or 0)
			for index, shop_card in ipairs(G.shop_vouchers.cards) do
				SMODS.destroy_cards(shop_card, nil, nil, true)
			end
			for index, shop_card in ipairs(G.shop_booster.cards) do
				SMODS.destroy_cards(shop_card, nil, nil, true)
			end
			for i = 1, num_vouchers do
				SMODS.add_voucher_to_shop()
			end
			for i = 1, num_boosters do
				SMODS.add_booster_to_shop()
			end
			return {
				message = localize("j8mod_reroll_ex"),
				colour = G.C.GREEN
			}
		end
	end
	--[[
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
	]]

}

-- Cackler
SMODS.Joker {

	key = "cackler",
	atlas = "j8jokers",
	pos = { x = 6, y = 6 },
	soul_pos = { x = 7, y = 6 },
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
						message = localize("j8mod_yeah_ex"),
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
	pos = { x = 8, y = 6 },
	soul_pos = { x = 9, y = 6 },
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
						for i = 1, #cards_to_trigger do
							SMODS.calculate_effect({
								trigger = "after",
								delay = 1.0,
								message = localize("k_upgrade_ex"),
								message_card = cards_to_trigger[i],
								func = function()
									cards_to_trigger[i].ability.perma_x_mult = (cards_to_trigger[i].ability.perma_x_mult or 0) +
										card.ability.extra.Xmult
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

-- This changes variables globally each round
function SMODS.current_mod.reset_game_globals(run_start)
	if run_start then
		G.GAME.current_round.j8mod_bookmark_rank = "None"
	end
end

-- ## REMOVED JOKERS ##

--[[

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
							set = 'j8mod_meal_ticket' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
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
				if (joker.config.center.pools or {}).j8mod_meal_ticket and joker ~= card then
					table.insert(food, joker)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.5,
						func = function()
							SMODS.calculate_effect({
									trigger = "immediate",
									blockable = false,
									message = "$" .. card.ability.extra.increase,
									colour = G.C.MONEY,
									message_card = card,
									func = function()
										joker:juice_up()
										card.ability.extra.dollars = card.ability.extra.dollars +
											card.ability.extra.increase
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
			for i = 1, #context.scoring_hand do
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
					message = localize("j8mod_nice_ex"),
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

-- #sepTemmber

SMODS.Joker {

	key = "temmie_joker",
	blueprint_compat = false,
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
				message = localize("j8mod_temmie_text"),
				colour = G.C.GREEN,
				message_card = card,
				func = function()
					G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - 1)
					-- jokers
					for index, shop_card in ipairs(G.shop_jokers.cards) do
						if shop_card.cost > 0 then
							local new_cost = math.max(0, shop_card.cost - card.ability.extra.price_reduction)
							local msg = "$" .. new_cost
							if new_cost <= 0 then
								msg = localize("j8mod_free_ex")
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
							local msg = "$" .. new_cost
							if new_cost <= 0 then
								msg = localize("j8mod_free_ex")
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
							local msg = "$" .. new_cost
							if new_cost <= 0 then
								msg = localize("j8mod_free_ex")
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
		info_queue[#info_queue + 1] = { key = 'perishable', set = 'Other', vars = { card.ability.extra.perish_rounds, card.ability.extra.perish_rounds } }
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
							new_joker = pseudorandom_element(G.P_CENTER_POOLS.Joker, "j8mod_brown_magic" .. it)
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

]]
