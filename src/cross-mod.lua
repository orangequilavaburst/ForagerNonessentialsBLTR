-- ## CROSS-MOD COMPATIBILITYlocal utdr_mod_exists = next(SMODS.find_mod("UTDR"))
if utdr_mod_exists then
    print("I LOVE TASQUE MANAGER")
end

-- ## enable yuri
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
    --[[
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            tm.T.x = yuri_x
            tm.T.y = yuri_y
            mm.T.x = yuri_x
            mm.T.y = yuri_y
            tm.VT.x = yuri_x
            tm.VT.y = yuri_y
            mm.VT.x = yuri_x
            mm.VT.y = yuri_y
            return true
        end
    }))
    ]]
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

SMODS.DrawStep {
    key = 'yuri_button',
    order = -30, -- before the Card is drawn
    func = function(card, layer)
        if card.children.j8mod_yuri_button then
            card.children.j8mod_yuri_button:draw()
        end
    end
}

-- make sure SMODS doesn't draw the button after the card is drawn
SMODS.draw_ignore_keys.j8mod_yuri_button = true

local highlight_ref = Card.highlight
function Card.highlight(self, is_highlighted)
    self.children.j8mod_yuri_button = nil
    local tm = next(SMODS.find_card("j_UTDR_tasque_manager"))
    local mm = next(SMODS.find_card("j_UTDR_missmizzle"))
    local can_yuri = tm and mm and not J8MOD.config.no_deltarune_spoilers
    if is_highlighted and self.ability.set == "Joker" and self.area == G.jokers and can_yuri and (self.config.center.key == "j_UTDR_tasque_manager" or self.config.center.key == "j_UTDR_missmizzle") then
        self.children.j8mod_yuri_button = yuri_button_ui(self)
    elseif self.children.j8mod_yuri_button then
        self.children.j8mod_yuri_button:remove()
        self.children.j8mod_yuri_button = nil
    end

    return highlight_ref(self, is_highlighted)
end
