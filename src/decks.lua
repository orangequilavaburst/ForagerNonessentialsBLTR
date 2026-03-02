-- Waterproof Deck
SMODS.Back {
	unlocked = true,
	key = "waterproof",
	pos = { x = 0, y = 0 },
	atlas = "j8decks",
	config = { extra = { shop_size_extra = -1 } },
	loc_vars = function(self, info_queue, back)
		return { vars = { self.config.extra.shop_size_extra } }
	end,
	apply = function(self, back)
		change_shop_size(-1)
		for _, key in pairs(G.P_CENTER_POOLS.j8mod_waterproof_banned_jokers) do
			G.GAME.banned_keys[key.key] = true
		end
	end,
	calculate = function(self, back, context)
		if context.setting_blind and not context.blueprint and G.GAME.blind.boss and not G.GAME.blind.config.blind.boss.showdown then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.blind:disable()
							play_sound('timpani')
							delay(0.4)
							return true
						end
					}))
					return true
				end
			}))
			return nil, true -- This is for Joker retrigger purposes
		end
	end
	-- The config field already handles the functionality so it doesn't need to be implemented
	-- The following is how the implementation would be
	--[[
    apply = function(self, back)
        G.GAME.starting_params.discards = G.GAME.starting_params.discards + self.config.discards
    end
    ]]
}

-- Lakeside Deck
SMODS.Back {
	unlocked = true,
	key = "lakeside",
	pos = { x = 1, y = 0 },
	atlas = "j8decks",
	config = { hands = 2, discards = 0, ante_scaling = 0.8 },
	loc_vars = function(self, info_queue, back)
		return { vars = { self.config.hands, self.config.discards, self.config.ante_scaling } }
	end,
	calculate = function(self, back, context)
		if context.setting_blind then
			G.GAME.current_round.discards_left = 0
		end
	end,
	apply = function(self, back)
		G.GAME.interest_amount = G.GAME.interest_amount + 1
		G.GAME.starting_params.discards = self.config.discards
		for _, key in pairs(G.P_CENTER_POOLS.j8mod_lakeside_banned_jokers) do
			G.GAME.banned_keys[key.key] = true
		end
		for _, key in pairs(G.P_CENTER_POOLS.j8mod_lakeside_banned_vouchers) do
			G.GAME.banned_keys[key.key] = true
		end
	end
}

-- Pinstripes Deck
SMODS.Back {
	unlocked = true,
	key = "pinstripes",
	pos = { x = 2, y = 0 },
	atlas = "j8decks",
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in pairs(G.playing_cards) do
					if v:get_id() == 13 then
						--SMODS.destroy_cards(v, false)
						v:remove()
					elseif v:get_id() % 2 == 1 or v:get_id() > 12 then
						SMODS.modify_rank(v, 1)
					end
				end
				return true
			end
		}))
	end
}

-- Doodle Deck
SMODS.Back {
	unlocked = true,
	key = "doodle",
	pos = { x = 3, y = 0 },
	atlas = "j8decks",
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in pairs(G.playing_cards) do
					if v:is_face() then
						v:set_ability("m_wild")
					end
				end
				return true
			end
		}))
	end,
	calculate = function(self, back, context)
		if context.discard then
			if next(SMODS.get_enhancements(context.other_card)) then
				if SMODS.has_enhancement(context.other_card, "m_wild") then
					return { remove = true }
				end
			else
				return {
					func = function()
						local percent = 1.0
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.1,
							func = function()
								context.other_card:flip()
								play_sound('card1', percent)
								context.other_card:juice_up(0.3, 0.3)
								return true
							end
						}))
						delay(0.1)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.1,
							func = function()
								context.other_card:set_ability("m_wild")
								return true
							end
						}))
						delay(0.1)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.1,
							func = function()
								context.other_card:flip()
								play_sound('tarot2', percent)
								context.other_card:juice_up(0.3, 0.3)
								return true
							end
						}))
						delay(0.25)
						return true -- This is for Joker retrigger purposes
					end
				}
			end
		end
	end
}

-- Graph Deck
SMODS.Back {
	unlocked = true,
	key = "graph",
	pos = { x = 4, y = 0 },
	atlas = "j8decks",
	config = { consumables = { 'c_fool' } },
	loc_vars = function(self, info_queue, back)
		return {
			vars = { localize { type = 'name_text', key = self.config.consumables[1], set = 'Tarot' }
			}
		}
	end,
}

-- Yoshi Deck
SMODS.Back {
	unlocked = true,
	key = "yoshi",
	pos = { x = 5, y = 0 },
	atlas = "j8decks",
	config = { extra = { price = 3 } },
	loc_vars = function(self, info_queue, back)
		return { vars = { self.config.extra.price } }
	end,
	calculate = function(self, back, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			-- See note about SMODS Scaling Manipulation on the wiki
			for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
				if joker.ability.yoshi then
					SMODS.calculate_effect({
						trigger = "after",
						delay = 0.5,
						message_card = joker,
						message = localize('k_val_up'),
						colour = G.C.MONEY,
						func = function()
							joker.ability.extra_value = joker.ability.extra_value + self.config.extra.price
							joker:set_cost()
							return true
						end
					}, joker)
				end
			end
		end
		if context.card_added and context.card.ability.set == "Joker" then
			context.card.ability.yoshi = true
			context.card:set_cost()
		end
	end,
}

-- Hypnotic Deck
SMODS.Back {
	unlocked = true,
	key = "hypnotic",
	pos = { x = 6, y = 0 },
	atlas = "j8decks",
	config = { consumables = { 'c_death', 'c_trance' }, ante_scaling = 1.2 },
	loc_vars = function(self, info_queue, back)
		return {
			vars = {
				localize { type = 'name_text', key = self.config.consumables[1], set = 'Tarot' },
				localize { type = 'name_text', key = self.config.consumables[2], set = 'Spectral' },
				self.config.ante_scaling
			}
		}
	end,
}

-- Promotional Deck
SMODS.Back {
	unlocked = true,
	key = "promotional",
	pos = { x = 7, y = 0 },
	atlas = "j8decks",
	config = { vouchers = { 'v_overstock_norm', 'v_overstock_plus' } },
	loc_vars = function(self, info_queue, back)
		return {
			vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
				localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' }
			}
		}
	end
}
