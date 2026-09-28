--## New fusion code

J8MOD.Fusions = {

}

J8MOD.Fusion_Ingredients = {

}

J8MOD.add_fusion = function(fusion_key, joker_ingredient_keys, joker_result_key, button_text_loc_key,
                            fusion_loc_key, button_colour, needs_deltarune)
    -- add listing for fusion
    local true_fusion_key = SMODS.current_mod.prefix .. "_" .. fusion_key
    local button_func_key = J8MOD.prefix .. "_fusion_button_" .. fusion_key
    J8MOD.Fusions[true_fusion_key] = {
        joker_ingredient_keys = joker_ingredient_keys,
        joker_result_key = joker_result_key,
        button_text_loc_key = button_text_loc_key,
        fusion_loc_key = fusion_loc_key,
        button_colour = button_colour,
        button_func_key = button_func_key,
        needs_deltarune = needs_deltarune,
    }
    -- setup function for drawing
    G.FUNCS[button_func_key .. "_click"] = J8MOD.make_fusion_button_click_function(J8MOD.Fusions[true_fusion_key])
    --print(button_func_key .. "_click : " .. tostring(G.FUNCS[button_func_key .. "_click"]))
    G.FUNCS[button_func_key .. "_func"] = J8MOD.make_fusion_button_function(J8MOD.Fusions[true_fusion_key])
    --print(button_func_key .. "_func : " .. tostring(G.FUNCS[button_func_key .. "_func"]))
    -- add ingredients to fusion ingredients for easy lookup
    for _, ingredient in ipairs(joker_ingredient_keys) do
        if J8MOD.Fusion_Ingredients[ingredient] then
            table.insert(J8MOD.Fusion_Ingredients[ingredient], true_fusion_key)
        else
            J8MOD.Fusion_Ingredients[ingredient] = { true_fusion_key }
        end
    end
end

J8MOD.make_fusion_button_function = function(fusion_table)
    local thunk = function(e)
        local card = e.config.ref_table -- access the card this button was on (unused here, but you can access it)
        -- In vanilla, this is generally used to define when the button can be used, for example:
        local can_use = true            -- can be any condition you want
        -- Removes the button when the card can't be used, otherwise makes it use the previously defined button click
        e.config.button = can_use and (fusion_table.button_func_key .. "_click") or nil
        -- Changes the color of the button depending on whether it can be used or not
        e.config.colour = can_use and fusion_table.button_colour or G.C.UI.BACKGROUND_INACTIVE
    end
    return thunk
end

J8MOD.make_fusion_button_click_function = function(fusion_table)
    local thunk = function(e)
        local card = e.config.ref_table -- access the card this button was on

        local ingredient_cards = {}
        local editions = {}
        for i, joker_key in ipairs(fusion_table.joker_ingredient_keys) do
            local ingredient_joker = SMODS.find_card(joker_key)[1]
            table.insert(ingredient_cards, ingredient_joker)
            if ingredient_joker.edition then
                table.insert(editions, ingredient_joker.edition)
            end
        end


        local mid_x = G.ROOM.T.w / 2.0 - G.ROOM.T.x
        local mid_y = G.ROOM.T.h / 2.0 - G.ROOM.T.y
        --[[
        for i, c in ipairs(ingredient_cards) do
            mid_x = mid_x + c.T.x
            mid_y = mid_y + c.T.y
        end
        mid_x = mid_x / #ingredient_cards
        mid_y = mid_y / #ingredient_cards
        ]]
        local fusion_card = nil
        local fusion_sparkles = nil

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                for i, c in ipairs(ingredient_cards) do
                    c.area:remove_card(c)
                    c.states.collide.can = false
                end
                fusion_sparkles = Particles(1, 1, 0, 0, {
                    timer = 0.015,
                    scale = 0.25,
                    initialize = true,
                    lifespan = 1.0,
                    speed = 0.5,
                    padding = -1,
                    attach = G.ROOM_ATTACH,
                    colours = { fusion_table.button_colour, lighten(fusion_table.button_colour, 0.2) },
                    fill = true
                })
                fusion_sparkles.fade_alpha = 1
                fusion_sparkles:fade(1, 0)
                return true
            end
        }))
        local did_block = true
        for i, c in ipairs(ingredient_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                delay = 0.5,
                ease = 'quad',
                blockable = did_block,
                ref_table = c.T,
                ref_value = "x",
                ease_to = mid_x,
            }))
            if did_block then
                did_block = false
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                delay = 0.5,
                ease = 'quad',
                blockable = did_block,
                ref_table = c.T,
                ref_value = "y",
                ease_to = mid_y,
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                for i, c in ipairs(ingredient_cards) do
                    c:remove()
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('timpani')
                fusion_card = SMODS.create_card { key = fusion_table.joker_result_key, edition = #editions > 0 and pseudorandom_element(editions, "j8mod_fusion_edition") or nil, no_edition = #editions <= 0 }
                fusion_card.T.x = mid_x
                fusion_card.T.y = mid_y
                fusion_card.VT.x = mid_x
                fusion_card.VT.y = mid_y
                fusion_card.states.collide.can = false
                fusion_card:juice_up(0.5, 0.5)

                attention_text({
                    text = localize(fusion_table.fusion_loc_key),
                    scale = 1.0,
                    hold = 1.5,
                    major = fusion_card,
                    backdrop_colour = fusion_table.button_colour,
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
                G.jokers:emplace(fusion_card)
                fusion_card.states.collide.can = true
                fusion_sparkles:remove()
                return true
            end
        }))
    end
    return thunk
end

J8MOD.make_fusion_button_ui = function(card, fusion_table)
    --print("Making UI!")
    --print(fusion_table.button_func_key .. "_click : " .. tostring(G.FUNCS[fusion_table.button_func_key .. "click"]))
    --print(fusion_table.button_func_key .. "_func : " .. tostring(G.FUNCS[fusion_table.button_func_key .. "func"]))
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
                        colour = fusion_table.button_colour,                 -- color of the button background
                        button = (fusion_table.button_func_key .. "_click"), -- function in G.FUNCS that will run when this button is clicked
                        func = (fusion_table.button_func_key .. "_func"),    -- function in G.FUNCS that will run every frame this button exists (optional)
                        ref_table = card,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = localize(fusion_table.button_text_loc_key),
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

SMODS.DrawStep {
    key = 'fusion_button',
    order = -30, -- before the Card is drawn
    func = function(card, layer)
        if card.children.j8mod_fusion_button then
            card.children.j8mod_fusion_button:draw()
        end
    end
}

SMODS.draw_ignore_keys.j8mod_fusion_button = true

local highlight_ref = Card.highlight
function Card.highlight(self, is_highlighted)
    self.children.j8mod_fusion_button = nil

    if is_highlighted and self.ability.set == "Joker" and self.area == G.jokers and J8MOD.Fusion_Ingredients[self.config.center.key] then
        --print("In ingredients!")
        --print(J8MOD.Fusion_Ingredients[self.config.center.key])
        for i, f in ipairs(J8MOD.Fusion_Ingredients[self.config.center.key]) do
            if J8MOD.Fusions[f] and (J8MOD.Fusions[f].needs_deltarune or not J8MOD.config.no_deltarune_spoilers) then
                local card_check = true
                for j, key in ipairs(J8MOD.Fusions[f].joker_ingredient_keys) do
                    if #SMODS.find_card(key) <= 0 then
                        --print(f .. ": Couldn't find " .. key .. "...")
                        card_check = false
                        break
                    else
                        --print(f .. ": Found " .. key .. "!")
                    end
                end
                if card_check then
                    --print("Making fusion button for " .. self.config.center.key)
                    self.children.j8mod_fusion_button = J8MOD.make_fusion_button_ui(self, J8MOD.Fusions[f])
                    break
                end
            end
        end
    elseif self.children.j8mod_fusion_button then
        self.children.j8mod_fusion_button:remove()
        self.children.j8mod_fusion_button = nil
    end

    return highlight_ref(self, is_highlighted)
end

--## OLD MANUAL FUSION CODE ## --

--[[
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
]]
