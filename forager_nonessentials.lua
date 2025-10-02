-- ## MOD SETUP ##

local j8mod_id = SMODS.current_mod.id
local j8mod_name = SMODS.current_mod.name
--print("I LOVE TASQUE MANAGER")
--print("mod id: " .. j8mod_id)

assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/decks.lua"))()
SMODS.load_file("config.lua")()

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
    quantum_enhancements = true
}

-- ## CONFIG UI ##

local my_config = SMODS.current_mod.config

-- Create config UI (Thanks, Paperback!)
SMODS.current_mod.config_tab = function()
  return {
    n = G.UIT.ROOT,
    config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
    nodes = {
      {
        n = G.UIT.R,
        config = { align = 'cm' },
        nodes = {
          {
            n = G.UIT.C,
            nodes = {
              create_toggle {
                label = "Deltarune Chapter 3/4 Spoilers",
                ref_table = my_config,
                ref_value = 'no_deltarune_spoilers'
              },
              --[[create_toggle {
                label = localize('paperback_ui_enable_blinds'),
                ref_table = PB_UTIL.config,
                ref_value = 'blinds_enabled',
              },]]--
            }
          },
        }
      },
    }
  }
end

-- ## JOKER ATLASES ##

SMODS.Atlas { 

	key = "j8jokers",
	path = "jokers-temp.png",
	px = 71,
	py = 95

}

SMODS.Atlas { 

	key = "j8decks",
	path = "decks-temp.png",
	px = 71,
	py = 95

}

-- ## POOLS ##

SMODS.ObjectType({
    key = "j8bit_meal_voucher", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "j_ice_cream",
    cards = {
        j_gros_michel = true,
        j_egg = true,
        j_ice_cream = true,
        j_cavendish = true,
        j_turtle_bean = true,
        j_diet_cola = true,
        j_popcorn = true,
        j_ramen = true,
        j_selzer = true,
		j_j8mod_sandwich_pick = true,
		j_j8mod_loco_moco = true,
		j_j8mod_milkshake = true,
		j_j8mod_marzipan_decoration = true
    },
})

SMODS.ObjectType({
    key = "j8bit_waterproof_banned_jokers", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "j_splash",
    cards = {
        j_splash = true,
        j_erosion = true,
        j_seltzer = true,
    },
})

SMODS.ObjectType({
    key = "j8bit_lakeside_banned_jokers", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "j_drunkard",
    cards = {
        j_drunkard = true,
        j_merry_andy = true,
        j_trading = true,
        j_burnt = true,
        j_yorick = true,
    },
})

SMODS.ObjectType({
    key = "j8bit_lakeside_banned_vouchers", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "v_wasteful",
    cards = {
		v_wasteful = true,
        v_recyclomancy = true,
    },
})

-- ## HOOKS ##
local align_hook = CardArea.align_cards
function CardArea:align_cards()
    align_hook(self)
    if self then
        if #self.cards > 0 and self == G.jokers then
            for k, card in ipairs(self.cards) do
                if card.config.center.key == "j_j8mod_weather_together" and card.config.center.config.extra then --condition to rotate
					card.children.center.role.r_bond = 'Weak'
					card.children.center.role.role_type = 'Major'
					local t = card.T
					card.children.center.T = setmetatable({}, {
						__index = function(_, k)
							if k == "r" then
								--return math.pi / 2.0
								return card.config.center.config.extra.rot_extra --amount to rotate by (in radians)
							end
							return t[k]
						end,
						__newindex = function(_, k, v)
							t[k] = v
						end
					})
                end
            end
        end
    end
end

local set_cost_hook = Card.set_cost 
function Card.set_cost(self)
	set_cost_hook(self)
	if self.ability.brown_magic then
		self.sell_cost = 0
	elseif self.ability.yoshi then
		self.sell_cost = 1 + self.ability.extra_value
	end
end

local ccfs = create_card_for_shop
function create_card_for_shop(area)
    local card = ccfs(area)
	if G.GAME.selected_back == "b_j8mod_graph" then
		if card.ability.set == "Tarot" or card.ability.set == "Planet" then
			card:set_ability("c_fool")
		end
	end
    return card
end

local create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    --pre
    local card = create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    --post
	if G.GAME then
		if G.GAME.selected_back.name == "b_j8mod_hypnotic" then
			local new_key = replace_with_player_consumable(card.ability.set)
			if new_key ~= nil then
				card:set_ability(new_key)
			end
		end
	end
    return card
end

-- ## GRADIENTS ##

SMODS.Gradient({
	key = 'fn',
	colours = {HEX('FDB157'), HEX('FDB157'), HEX('FD5F55'), HEX('8755bf'), HEX('8755bf'), HEX('FD5F55'),},
	cycle = 4,
	interpolation = 'linear'
})

-- ## SHADERS ##

SMODS.Shader({ key = 'ww', path = 'ww.fs' })
SMODS.Shader({ key = 'spiral', path = 'spiral.fs' })
SMODS.Shader({ key = 'yuri', path = 'yuri.fs' })

-- ## FUNCTIONS ##

-- replaces a card with a card in the player's consumables if possible; takes a set and returns the KEY
function replace_with_player_consumable(set)
	--print(set)
	local shuffled_consumeables = {}
	for i, consumeable in ipairs(G.consumeables.cards) do
		--print(consumeable.config.center.key)
		table.insert(shuffled_consumeables, consumeable)
	end
	pseudoshuffle(shuffled_consumeables, "j8mod_shuffle")
    for i, consumeable in ipairs(shuffled_consumeables) do
		--print("checking "..consumeable.config.center.key)
		if consumeable.ability.set == set then
			return consumeable.config.center.key
		end
	end
	return nil
end

-- changes the index of the card/voucher/etc
function sign(num)
	if num > 0 then
		return 1
	elseif num < 0 then
		return -1
	else
		return 0
	end
end

function get_rarity_index(rarity)
	if rarity == "Common" then
		return 1
	elseif rarity == "Uncommon" then
		return 2
	elseif rarity == "Rare" then
		return 3
	elseif rarity == "Legendary" then
		return 4
	else 
		return rarity
	end
end

function spindown(card, amount)

	local key = card.config.center.key
	local set = card.ability.set

	local index = 0
	if set == "Default" then -- playing card
		SMODS.modify_rank(card, amount)
	elseif set == "Joker" then
		--print("Joker count: " .. #G.P_CENTER_POOLS.Joker)
		for i, joker in ipairs(G.P_CENTER_POOLS.Joker) do
			--print(i .. " " .. inspectDepth(joker))
			if joker.key == key then
				index = i
				--print("Found " .. key .. " at index " .. i)
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Joker + amount - 1) % #G.P_CENTER_POOLS.Joker
		card:set_ability( G.P_CENTER_POOLS.Joker[index].key )
	elseif set == "Planet" then
		--print(G.P_CENTER_POOLS.Planet)
		for i, planet in ipairs(G.P_CENTER_POOLS.Planet) do
			if planet.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Planet + amount - 1) % #G.P_CENTER_POOLS.Planet
		card:set_ability( G.P_CENTER_POOLS.Planet[index].key )
	elseif set == "Tarot" then
		--print(G.P_CENTER_POOLS.Tarot)
		for i, tarot in ipairs(G.P_CENTER_POOLS.Tarot) do
			if tarot.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Tarot + amount - 1) % #G.P_CENTER_POOLS.Tarot
		card:set_ability( G.P_CENTER_POOLS.Tarot[index].key )
	elseif set == "Voucher" then
		--print(G.P_CENTER_POOLS.Voucher)
		for i, voucher in ipairs(G.P_CENTER_POOLS.Voucher) do
			if voucher.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Voucher + amount - 1) % #G.P_CENTER_POOLS.Voucher
		card:set_ability( G.P_CENTER_POOLS.Voucher[index].key )
	elseif set == "Spectral" then
		--print(G.P_CENTER_POOLS.Spectral)
		for i, spectral in ipairs(G.P_CENTER_POOLS.Spectral) do
			if spectral.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Spectral + amount - 1) % #G.P_CENTER_POOLS.Spectral
		card:set_ability( G.P_CENTER_POOLS.Spectral[index].key )
	end

end