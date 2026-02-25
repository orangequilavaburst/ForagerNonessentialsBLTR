return {
    descriptions = {
        Back = {
            b_j8mod_waterproof = {
                name = "Waterproof Deck",
                text = {
                    "{C:attention}#1#{} card slot available in shop,",
                    "Non-finisher {C:attention}Boss Blinds{}",
                    "are disabled"
                }
            },
            b_j8mod_lakeside = {
                name = "Lakeside Deck",
                text = {
                    "{C:blue}+#1#{} hands every round,",
                    "{C:red}#2# discards every round,",
                    "Interest is {C:attention}doubled,",
                    "{C:red}X#3#{} base Blind size",
                }
            },
            b_j8mod_pinstripes = {
                name = "Pinstripes Deck",
                text = {
                    "Start run with",
                    "two copies of each",
                    "{C:attention}even rank{} card",
                    "and two {C:attention}Queens{} per suit"
                }
            },
            b_j8mod_doodle = {
                name = "Doodle Deck",
                text = {
                    "All face cards start as {C:attention}Wild{} cards",
                    "{C:red}Discarding{} an unenhanced card",
                    "turns it into a {C:attention}Wild{} card,",
                    "{C:red}Discarding{} a {C:attention}Wild{} card destroys it",
                }
            },
            b_j8mod_graph = {
                name = "Graph Deck",
                text = {
                    "Start run with {C:tarot,T:c_fool}#1#",
                    "All future {C:tarot}Tarot{} and {C:planet}Planet",
                    "cards in shop become {C:tarot,T:c_fool}#1#"
                }
            },
            b_j8mod_yoshi = {
                name = "Yoshi Deck",
                text = {
                    "Purchased Jokers' sell",
                    "values become {C:money}$1",
                    "and increase by {C:money}$#1#{}",
                    "at the end of round",
                }
            },
            b_j8mod_hypnotic = {
                name = "Hypnotic Deck",
                text = {
                    "{C:spectral}Spectral{} cards may",
                    "appear in the shop,",
                    "Start with {C:tarot,T:c_death}#1#{} and {C:spectral,T:c_trance}#2#{},",
                    "Only {C:attention}consumables you own{}",
                    "appear when possible",
                    "{C:red}X#3#{} base Blind size",
                }
            },
            b_j8mod_promotional = {
                name = "Promotional Deck",
                text = {
                    "{C:j8mod_fn}Forager Nonessentials{}",
                    "Jokers appear more often,",
                    "Start run with {C:attention,T:v_overstock_norm}#1#",
                    "and {C:attention,T:v_overstock_plus}#2#{}"
                }
            },
        },
        Joker = {
            j_j8mod_prophecy = {
                name = "Prophecy",
                text = {
                    "After {C:attention}#1#{} rounds,",
                    "sell this card to create",
                    "{C:attention}#3#{} random {C:spectral}Spectral{} cards",
                    "{C:inactive}(Must have room)",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
                },
            },
            j_j8mod_spell_tag = { -- alt for prophecy
                name = "Spell Tag",
                text = {
                    "After {C:attention}#1#{} rounds,",
                    "sell this card to create",
                    "{C:attention}#3#{} random {C:spectral}Spectral{} cards",
                    "{C:inactive}(Must have room)",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
                },
            },
            j_j8mod_monty_hall = {
                name = "Monty Hall",
                text = {
                    "Increases {C:attention}listed {C:green,E:1}probabilities{}",
                    "by {C:green}+#2#{} when {C:attention,E:1}failing{} a chance,",
                    "{C:attention}resets{} upon {C:attention,E:1}succeeding{} a chance",
                    "{C:inactive}(Currently {C:attention}+#1#{C:inactive})"
                },
            },
            j_j8mod_metamorphic_joker = {
                name = "Metamorphic Joker",
                text = {
                    "{C:green}#1# in #2#{} chance for",
                    "played {C:attention}#3#s{} to",
                    "become {C:attention}#4#s{}",
                },
            },
            j_j8mod_clownfish = {
                name = "Clownfish",
                text = {
                    "This Joker gains",
                    "{C:chips}+#2#{} Chips when a",
                    "{C:attention}Joker{} effect triggers",
                    "Resets at the end of round",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_j8mod_cookie_cutter = {
                name = "Cookie Cutter",
                text = {
                    "This Joker gains",
                    "{C:chips}+#2#{} Chips when a",
                    "card is {C:attention}sold{}",
                    "or {C:attention}destroyed{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_j8mod_promo_card = {
                name = "Promo Card",
                text = {
                    "{C:attention}+#1#{} choice from Booster Packs"
                },
            },
            j_j8mod_sandwich_pick = {
                name = "Sandwich Pick",
                text = {
                    "If scoring hand contains",
                    "{C:attention}#1#{} or greater cards,",
                    "add a random {C:attention}seal{}",
                    "to the {C:attention}first scoring card{}",
                    "{C:inactive}({C:attention}#2#{C:inactive} left)",
                },
            },
            j_j8mod_loco_moco = {
                name = "Loco Moco",
                text = {
                    "Every scored {C:attention}card{}",
                    "permanently gains",
                    "{C:mult}+#1#{} Mult when scored",
                    "{C:inactive}({C:attention}#2#{C:inactive} left)",
                },
            },
            j_j8mod_memento = {
                name = "Memento",
                text = {
                    "After {C:attention}#2# Antes{},",
                    "sell this card to create a",
                    "{C:spectral}#3#{} card and {C:spectral}#4#{} card",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)",
                    "{C:inactive}(Must have room)",
                },
            },
            j_j8mod_meal_ticket = {
                name = "Meal Ticket",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "create {C:attention}#1# {C:green}food-themed{C:attention} Jokers",
                    "{C:inactive}(Must have room)",
                },
            },
            j_j8mod_graffiti_artist = {
                name = "Graffiti Artist",
                text = {
                    "After defeating a {C:attention}Blind{},",
                    "{C:green}#1# in #2#{} chance to",
                    "obtain its {C:attention}Skip Tag{}",
                    "{C:inactive}#3#{C:attention}#4#{C:inactive}#5#"
                },
            },
            j_j8mod_bookmark = {
                name = "Bookmark",
                text = {
                    "Prevents most recently played",
                    "{C:attention}rank{} from getting {C:red}debuffed{}",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive})"
                },
            },
            j_j8mod_milkshake = {
                name = "Milkshake",
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips",
                    "per {C:attention}reroll{} in the shop",
                    "{C:green}#3# in #4#{} chance this card",
                    "is destroyed on {C:attention}reroll{}",
                    "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)",
                },
            },
            j_j8mod_gourmand = {
                name = "Gourmand",
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "Each {C:green}food-themed{C:attention} Joker{} held at",
                    "the end of round {C:attention}gets eaten{}",
                    "and increases payout by {C:money}$#2#{}"
                },
            },
            j_j8mod_needlepoint_joker = {
                name = "Needlepoint Joker",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "{C:attention}lose all but 1 hand",
                    "and gain {C:money}$#1#{} per hand lost",
                },
            },
            j_j8mod_bathroom_pass = {
                name = "Bathroom Pass",
                text = {
                    "Playing a {C:attention}Flush{}",
                    "{C:green}rerolls{} the {C:attention}Boss Blind{}",
                    "up to {C:attention}#2#{} times per Ante",
                    "{C:inactive}({C:attention}#1#{C:inactive} left)"
                },
            },
            j_j8mod_top_3_joker = {
                name = "Top 3 Joker",
                text = {
                    "When playing a hand with",
                    "exactly {C:attention}3{} cards",
                    "turn them into a ",
                    "{C:attention}Gold Card{}, {C:attention}Steel Card{},",
                    "and {C:attention}Bonus Card{} respectively"
                },
            },
            j_j8mod_kaleidoscope = {
                name = "Kaleidoscope",
                text = {
                    "{C:attention}#1#s{} count as {C:attention}#2#s{}"
                },
            },
            j_j8mod_b1g1f = {
                name = "Buy 1 Get 1 Free!",
                text = {
                    "Buying a {C:attention}Booster Pack{} creates a",
                    "{C:attention}free copy{} of itself in the shop"
                },
            },
            j_j8mod_assimilation_joker = {
                name = "Assimilation Joker",
                text = {
                    --[[
                    "On the {C:attention}first hand{} of a round,",
                    "add the {C:attention}ranks{} of {C:attention}all cards in hand{}",
                    "to this Joker, {C:red}destroy them{}, and transform",
                    "{C:attention}all played cards{} into the saved rank",
                    "{C:inactive}(Aces are worth +{C:attention}1{C:inactive}, face cards are worth +{C:attention}10{C:inactive})",
                    "{C:inactive}(Current rank: {C:attention}#2#{C:inactive})",
                    "{V:1}#3#{V:2}#4#{V:3}#5#"
                    ]]
                    "{C:attention}#1#s{} held in hand",
                    "after scoring convert to",
                    "the card on their {C:attention}right"
                },
            },
            j_j8mod_copied_homework = {
                name = "Copied Homework",
                text = {
                    "{C:attention}#1#s{} held in hand",
                    "after scoring convert to",
                    "the card on their {C:attention}right"
                }
            },
            j_j8mod_69_joke = {
                name = "69 Joke",
                text = {
                    "This Joker gains",
                    "{C:mult}+#4#{} Mult and {C:chips}+#3#{} Chips",
                    "on hands with a",
                    "scoring {C:attention}6{} and {C:attention}9",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips and {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_j8mod_search_history = {
                name = "Search History",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult on hands",
                    "with a scoring {C:attention}3{} and {C:attention}4{}",
                    "{C:red}Resets{} on hands with a scoring {C:attention}Ace{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive}{C:inactive} Mult)",
                },
            },
            j_j8mod_fursona = {
                name = "Fursona",
                text = {
                    "Creates a random {C:attention}Tag{} on hands",
                    "with a scoring {C:attention}6{}, {C:attention}2{}, and {C:attention}Ace{}"
                },
            },
            j_j8mod_breaker_box = {
                name = "Breaker Box",
                text = {
                    "Upgrades level of",
                    "played {C:attention}poker hand{}",
                    "{C:red}Debuffs{} all scoring ranks",
                    "until end of round"
                },
            },
            j_j8mod_monster_card = {
                name = "Monster Card",
                text = {
                    "At end of the round,",
                    "reward {C:money}$#1#{}-{C:money}#2#{} on {C:attention}Small Blinds{},",
                    "a random {C:tarot}Tarot{} or {C:planet}Planet{} card on {C:attention}Big Blinds{},",
                    "or {C:attention}#4#{}-{C:attention}#5#{} random Jokers on {C:attention}Boss Blinds{}",
                    "{C:inactive}(Must have room)",

                },
            },
            j_j8mod_crayon_box = {
                name = "Crayon Box",
                text = {
                    "Sell this card to",
                    "enhance all cards in hand",
                    "to a {C:attention}#1#{}, {C:attention}#2#{},",
                    "or {C:attention}#3#{} at random"
                },
            },
            j_j8mod_kitsune_mask = {
                name = "Kitsune Mask",
                text = {
                    "{C:green}#1# in #2#{} chance for each",
                    "played {C:attention}7{} to create a",
                    "{C:spectral}Spectral{} card when scored",
                    "Chance {C:green}doubled{} on a {C:attention}Lucky 7{}",
                    "{C:inactive}(Must have room)",
                },
            },
            j_j8mod_thrift_shop = {
                name = "Thrift Shop",
                text = {
                    "{C:green}#1# in #2#{} chance for each",
                    "shop {C:green}reroll{} to",
                    "create a random {C:attention}Tag{}",
                }
            },
            j_j8mod_marzipan_decoration = {
                name = "Marzipan Decoration",
                text = {
                    "Copies ability of {C:attention}Joker{} to the right",
                    "{C:green}#1# in #2#{} chance this card is",
                    "destroyed after being triggered",
                },
            },
            j_j8mod_modeling_clay = {
                name = "Modeling Clay",
                text = {
                    "Changes ability to a random {C:attention}Joker{}",
                    "at start of round or on {C:red}discard{}",
                }
            },
            j_j8mod_geode = {
                name = "Geode",
                text = {
                    "{C:attention}Stone Cards{} act as",
                    "a random {C:attention}Enhancement{},",
                    "changes at the start of round",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive})",
                }
            },
            j_j8mod_hypnotic_joker = {
                name = "Hypnotic Joker",
                text = {
                    "Every played {C:attention}card{}",
                    "swaps between permanently gaining",
                    "{C:chips}+#1#{} Chips or {C:mult}+#2#{} Mult when scored",
                    "{C:inactive}(Currently {V:1}#3#{C:inactive})",
                }
            },
            j_j8mod_funnybones = {
                name = "Funnybones",
                text = {
                    "{C:blue,s:1.1}+#1#{} Chips for each card in hand,",
                    "each {C:attention}Joker{}, and each {C:attention}consumable{} you have",
                    "{V:1}#2#{V:2}#3#{V:1}#4#{V:3}#5#{V:1}#6#"
                }
            },
            j_j8mod_rap_battle = {
                name = "Rap Battle",
                text = {
                    "Retrigger all played cards",
                    "if {C:attention}poker hand{} is a {C:attention}#2#{},",
                    "poker hand changes",
                    "after scoring",
                },
            },
            j_j8mod_hating_simulator = {
                name = "Hating Simulator",
                text = {
                    "On the {C:attention}first hand{} of a round,",
                    "if the played hand is",
                    "your {C:attention}most played hand,",
                    "{C:red}destroy all played cards{}"
                },
            },
            j_j8mod_weather_together = {
                name = "Weather Together",
                text = {
                    "{C:inactive,s:0.8,E:2}\"The weather...{s:1.0}",
                    "{C:inactive,s:0.8,E:2}...always sticks together.\"{s:1.0}",
                    "{C:purple}Swaps{} Chips and Mult",
                    "{C:inactive}(counted as a {C:chips}+{C:inactive}Chips/{C:mult}+{C:inactive}Mult Joker)"
                },
            },
            j_j8mod_reverse_polarity = {
                name = "Reverse Polarity",
                text = {
                    "{C:purple}Swaps{} Chips and Mult",
                    "{C:inactive}(counted as a {C:chips}+{C:inactive}Chips/{C:mult}+{C:inactive}Mult Joker)"
                },
            },
            j_j8mod_color_cafe = {
                name = "Color Cafe",
                text = {
                    "Playing cards have a",
                    "{C:green}#1# in #2#{} chance to",
                    "become {C:attention}Polychrome{} when scored"
                },
            },
            j_j8mod_makeup_palette = {
                name = "Makeup Palette",
                text = {
                    "Playing cards have a",
                    "{C:green}#1# in #2#{} chance to",
                    "become {C:attention}Polychrome{} when scored"
                },
            },
            j_j8mod_werewire = {
                name = "Werewire",
                text = {
                    "Retrigger all {C:attention}Polychrome{}",
                    "cards and Jokers"
                },
            },
            j_j8mod_pinwheel = {
                name = "Pinwheel",
                text = {
                    "Retrigger all {C:attention}Polychrome{}",
                    "cards and Jokers"
                }
            },
            j_j8mod_spindown_dice = {
                name = "Spindown Dice",
                text = {
                    "{C:inactive,s:0.8}\"-1\"{s:1.0}",
                    "Selling this {C:green}rerolls{} the {C:edition}ID{} of all visible {C:attention}Jokers{},",
                    "{C:tarot}Tarot{} cards, {C:planet}Planet{} cards, {C:spectral}Spectral{} cards,",
                    "{C:voucher}Vouchers{}, and {C:attention}Booster Packs{} by {C:attention}-1{},",
                    "Decreases {C:attention}rank{} of visible playing cards by {C:attention}1{}"
                },
            },
            j_j8mod_d100 = {
                name = "D100",
                text = {
                    "{C:inactive,s:0.8}\"REEROLLLLL!\"{s:1.0}",
                    "Selling this {C:green}rerolls{} the {C:edition}ID{} of all visible {C:attention}Jokers{},",
                    "{C:tarot}Tarot{} cards, {C:planet}Planet{} cards, {C:spectral}Spectral{} cards,",
                    "{C:voucher}Vouchers{}, and {C:attention}Booster Packs{} {C:edition}randomly{},",
                    "Changes {C:attention}rank{} of visible playing cards to a {C:edition}random rank{}"
                },
            },
            j_j8mod_mizzmanaged = {
                name = "Mizzmanaged",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "per scoring card with {C:attention}any Seal{} played,",
                    "{X:mult,C:white} X#2# {} Mult if the card is also a {C:attention}Queen",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                },
            },
            j_j8mod_iron_maiden = {
                name = "Iron Maiden",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "per scoring card with {C:attention}any Seal{} played,",
                    "{X:mult,C:white} X#2# {} Mult if the card is also a {C:attention}Queen",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                }
            },
            j_j8mod_planetary_domination = {
                name = "Planetary Domination",
                text = {
                    "This Joker gains {C:mult}+#2#{} Mult",
                    "for each {C:planet}Planet{} card sold",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                },
            },
            j_j8mod_citysweeper = {
                name = "Citysweeper",
                text = {
                    "This Joker gains {C:money}money{}",
                    "equal to the {C:attention}level{} of",
                    "each played poker hand,",
                    "resets before blind begins",
                    "{C:inactive}(Currently {C:money}+$#1#{C:inactive})",
                },
            },
            j_j8mod_strike_the_earth = {
                name = "Strike the Earth!",
                text = {
                    "Played {C:attention}Stone{} cards have",
                    "a {C:green}#1# in #2#{} chance to",
                    "give {C:money}$#3#{} when scored",
                },
            },
            j_j8mod_expansion_plans = {
                name = "Expansion Plans",
                text = {
                    "After spending {C:money}$#2#{} in the shop,",
                    "{C:red}destroy this card{} and add {C:dark_edition}Negative{}",
                    "to a random {C:attention}Joker{} you own",
                    "{C:inactive}(Currently {C:attention}$#1#{C:inactive}/$#2#)"
                },
            },
            j_j8mod_thunder_carnival = {
                name = "Thunder Carnival",
                text = {
                    "{C:attention}Debuffed{} cards become",
                    "{C:attention}#1#s{} when played"
                },
            },
            j_j8mod_magic_card = {
                name = "Magic Card",
                text = {
                    "{C:attention}+#1#{} extra cards in Booster Packs"
                },
            },
            j_j8mod_super_fighting_robot = {
                name = "Super Fighting Robot",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "when {C:attention}Boss Blind{} is defeated",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_j8mod_puzzle_swap = {
                name = "Puzzle Swap",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "{C:green}reroll{} held {C:attention}consumables{}"
                },
            },
            j_j8mod_the_world_revolving = {
                name = "THE WORLD REVOLVING",
                text = {
                    "{C:inactive,s:0.8,E:1}\"CHAOS, CHAOS!\"{s:1.0}",
                    "{X:mult,C:white} X#1# {} Mult",
                    "Reshuffles cards held in hand",
                    "back into deck after scoring"
                },
            },
            j_j8mod_sleight_of_hand = {
                name = "Sleight of Hand",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "Reshuffles cards held in hand",
                    "back into deck after scoring"
                },
            },
            j_j8mod_spider_bake_sale = {
                name = "Spider Bake Sale",
                text = {
                    "{C:inactive,s:0.8,E:2}\"Ahuhuhuhu~\"{s:1.0}",
                    "Add a {C:purple}Purple Seal{} to",
                    "a random {C:attention}playing card{} in deck",
                    "every {C:money}$#3#{} spent",
                    "{C:inactive}(Currently {C:attention}$#2#{C:inactive}/$#3#)"
                },
            },
            j_j8mod_dreambreaker = {
                name = "Dreambreaker",
                text = {
                    "Reduce Blind score",
                    "requirements by {C:red}#1#%{}"
                },
            },
            j_j8mod_marx_soul = {
                name = "Marx SOUL",
                text = {
                    "Increases rank of",
                    "scored {C:attention}Wild{} cards by {C:attention}#1#{}"
                },
            },
            j_j8mod_temmie_joker = {
                name = "Temmie Logic",
                text = {
                    "{C:attention}Selling a Joker{} reduces",
                    "all {C:attention}items on sale{} and {C:green}rerolls{}",
                    "in the Shop by {C:money}$#1#{}"
                },
            },
            j_j8mod_brown_magic = {
                name = "Brown Magic",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "create {C:attention}#1# {C:dark_edition}Negative {V:1}#2# {C:attention} Jokers",
                    "that {C:attention}perish{} after {C:attention}#3#{} rounds"
                },
            },
            j_j8mod_program_advance = {
                name = "Program Advance",
                text = {
                    "Playing a {C:attention}#1#{} also scores",
                    "cards still in hand that match",
                    "the {C:attention}suit{} of played cards"
                },
            },
            j_j8mod_colony_tile = {
                name = "Colony Tile",
                text = {
                    "{C:attention}+#2#{} hand size if played",
                    "hand contains a {C:attention}#1#{},",
                    "reset when {C:attention}Blind{} is selected",
                    "{C:inactive}(Currently {C:attention}+#3#{C:inactive} hand size)",
                },
            },
            j_j8mod_rule_of_threes = {
                name = "Rule of Threes",
                text = {
                    "{X:mult,C:white} X#2# {} Mult for each",
                    "{C:attention}#1#{} played this run",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                },
            },
            j_j8mod_cereal_box = {
                name = "Cereal Box",
                text = {
                    "When entering shop,",
                    "destroy this and add",
                    "a {C:spectral}#1#",
                    "to the shop"
                },
            },
            j_j8mod_community_resource = {
                name = "Community Resource",
                text = {
                    "Each scored {C:attention}#1#{}, {C:attention}#2#{}, {C:attention}#3#{}, {C:attention}#4#{}, and {C:attention}#5#{}",
                    "has a {C:green}#6# in #7#{} chance to",
                    "upgrade level of the",
                    "{C:red}lowest level {C:attention}poker hand"
                },
            },
            j_j8mod_j8bit = {
                name = "J8-Bit",
                text = {
                    "Scored {C:attention}Jacks{} and {C:attention}8s{} become {C:dark_edition}Negative",
                    "Retrigger all {C:attention}Negative{} cards and Jokers"
                },
            },
            j_j8mod_niri = {
                name = "Niri",
                text = {
                    --[["{C:attention}+#1#{} hand size for each {C:attention}Joker",
                    "and non-{C:dark_edition}Negative {C:attention}consumable{} you own",
                    "at the start of a Blind",
                    "{C:inactive}(Currently {C:attention}+#2#{C:inactive})",
                    "{C:inactive}(Next Blind: {C:attention}+#3#{C:inactive})"]]
                    "{C:attention}+#1#{} initial Booster Packs",
                    "and {C:attention}+#2#{} initial Vouchers",
                    "appear in shop"
                },
            },
            j_j8mod_cyber_niri = {
                name = "Cyber Niri",
                text = {
                    --[[
                    "{X:mult,C:white} X#5# {} Mult per held {C:attention}consumable",
                    "{C:attention}+#1# consumable slot for",
                    "every {C:attention}#2#{} hand size",
                    "at the start of a Blind",
                    "{C:inactive}(Currently {C:attention}+#3#{C:inactive})",
                    "{C:inactive}(Next Blind: {C:attention}+#4#{C:inactive})",
                    ]]
                    "Rerolling the shop {C:attention}rerolls",
                    "Booster Packs and Vouchers for sale"
                },
            },
            j_j8mod_cackler = {
                name = "Cackler",
                text = {
                    "Scored {C:attention}#1#s{} also",
                    "score all {C:attention}#1#s{}",
                    "still in hand"
                },
            },
            j_j8mod_maestro = {
                name = "Maestro",
                text = {
                    "Every card in the {C:attention}winning hand",
                    "{C:attention}of a round{} gains a permanent",
                    "additional {X:mult,C:white} X#1# {} Mult"
                },
            },
            j_j8mod_xUTDR_playerfriend = {
                name = "PlayerFRIEND",
                text = {
                    "Every scored {C:attention}card{}",
                    "permanently loses {C:chips}-#1#{} Chips",
                    "and gains {X:mult,C:white} X#2# {} Mult when scored",
                },
            },
            j_j8mod_xUTDR_gold_widow = {
                name = "Gold Widow",
                text = {
                    "Scoring {C:attention}#1#s{} remove their",
                    "enhancement, but gain",
                    "{C:money}#2# Seals{} after",
                    "hand is played"
                },
            },
            j_j8mod_xUTDR_mr_sunshine_and_abberant = {
                name = "Mr. Sunshine and Abberant",
                text = {
                    "{C:tarot}#1#{} always appears",
                    "in {C:tarot}#2#s{}"
                },
            },
            j_j8mod_xUTDR_goner_kid = {
                name = "Goner Kid",
                text = {
                    "{C:attention}Booster Packs{} additionally",
                    "contain a {C:spectral}Prophecy{} card"
                },
            },
            j_j8mod_xUTDR_tactical_dreemurr = {
                name = "Tactical Dreemurr",
                text = {
                    "Creates a random {C:attention}Tag{}",
                    "if played hand triggers the",
                    "{C:attention}Boss Blind{} ability",
                },
            },
            j_j8mod_xellejokers_fizz_fizzle = {
                name = "Fizz Fizzle",
                text = {
                    "+{C:attention}#1#{} to all {C:attention}retriggers{}"
                },
            },
            j_j8mod_xellejokers_girlfriend = {
                name = "Girlfriend",
                text = {
                    "Scores the {C:attention}leftmost{}",
                    "and {C:attention}rightmost{} cards",
                    "{C:attention}held in hand{} alongside",
                    "scoring hand"
                },
            },
            j_j8mod_xellejokers_lazy_worm = {
                name = "Lazy Worm",
                text = {
                    "{C:inactive,s:0.8}\"Pft\"{s:1.0}",
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "when a {C:rare}Rare{} or {C:legendary}Legendary{}",
                    "Joker is obtained",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive}{C:inactive} Mult)",
                },
            },
            j_j8mod_xellejokers_slimy_joker = {
                name = "Slimy Joker",
                text = {
                    "{C:attention}#3#s{} have a",
                    "{C:green}#1# in #2#{} chance to",
                    "turn adjacent cards into",
                    "{C:attention}#3#s{} after hand scores",
                },
            },
            j_j8mod_xellejokers_audience_participation = {
                name = "Audience Participation",
                text = {
                    "Create a random {C:attention}consumable{}",
                    "after scoring if {C:attention}#2#{} or more",
                    "{C:attention}#1#s{} are held in hand"
                },
            },
            j_j8mod_xortalab_surface_joker = {
                name = "Surface Joker",
                text = {
                    "{C:green}#1# in #2#{} chance for",
                    "played {C:attention}#3#s{} to",
                    "become {C:attention}#4#s{}",
                },
            },
            j_j8mod_xortalab_keepsake = {
                name = "Keepsake",
                text = {
                    "After {C:attention}#2# Antes{},",
                    "sell this card to create a",
                    "{C:ortalab_mythos}#3#{} card and {C:ortalab_mythos}#4#{} card",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)",
                    "{C:inactive}(Must have room)",
                },
            },
            j_j8mod_xortalab_self_insert = {
                name = "Self-Insert",
                text = {
                    "Creates a random {C:attention}Tag{} on hands",
                    "containing only {C:attention}Jacks{} and {C:attention}8s{}"
                },
            },
            j_j8mod_xortalab_receipt_printer = {
                name = "Receipt Printer",
                text = {
                    "Sell this card to",
                    "enhance all cards in hand",
                    "to a {C:attention}#1#{}, {C:attention}#2#{},",
                    "or {C:attention}#3#{} at random"
                },
            },
            j_j8mod_xortalab_boogie_joker = {
                name = "Boogie Joker",
                text = {
                    "Played {C:attention}#1#s{}",
                    "convert to the card on ",
                    "their {C:attention}left{} after scoring"
                },
            },
        },
        Other = {
            credits_j8 = {
                name = "Artist",
                text = {
                    "J8-Bit",
                    "{s:0.75,C:inactive}j8-bit.bsky.social{}"
                }
            },
            credits_fizlok = {
                name = "Artist",
                text = {
                    "Fizlok",
                    "{s:0.75,C:inactive}fizlok.bsky.social{}"
                }
            },
            credits_catachrome = {
                name = "Artist",
                text = {
                    "CataChrome",
                    "{s:0.75,C:inactive}catachrome.bsky.social{}"
                }
            },
            credits_czarkhasm = {
                name = "Artist",
                text = {
                    "czarkhasm"
                }
            },
            credits_gimmick = {
                name = "Artist",
                text = {
                    "gimmick",
                    "{s:0.75,C:inactive}gimmick.bsky.social{}"
                }
            },
            credits_thatartisan = {
                name = "Artist",
                text = {
                    "ThatArtisan",
                    "{s:0.75,C:inactive}thatartisan.bsky.social{}"
                }
            },
            credits_sharb = {
                name = "Artist",
                text = {
                    "Sharb",
                    "{s:0.75,C:inactive}firengames.com{}"
                }
            },
            credits_vjb = {
                name = "Artist",
                text = {
                    "Veejaybees",
                    "{s:0.75,C:inactive}veejaybees.bsky.social{}"
                }
            },
            credits_overgrownrobot = {
                name = "Artist",
                text = {
                    "overgrown.robot",
                    "{s:0.75,C:inactive}overgrownrobot.dev{}"
                }
            },
            credits_neognw = {
                name = "Artist",
                text = {
                    "NeoGnW",
                    "{s:0.75,C:inactive}neognw.bsky.social{}"
                }
            },
            credits_glasus = {
                name = "Artist",
                text = {
                    "Glasus",
                    "{s:0.75,C:inactive}greendogsandham.bsky.social{}"
                }
            },
            credits_mario_santos = {
                name = "Artist",
                text = {
                    "Mário Santos",
                    "{s:0.75,C:inactive}mariosantos.bsky.social{}"
                }
            },
            credits_anubis_jr = {
                name = "Artist",
                text = {
                    "Anubis Jr.",
                    "{s:0.75,C:inactive}anubis-jr.bsky.social{}"
                }
            },
            credits_igjh = {
                name = "Artist",
                text = {
                    "IGJH",
                    "{s:0.75,C:inactive}igjhspritin.bsky.social{}"
                }
            },
            credits_suplex = {
                name = "Artist",
                text = {
                    "Grizzly Suplex",
                    "{s:0.75,C:inactive}maximumcooldude.bsky.social{}"
                }
            },
            credits_submarine_screw = {
                name = "Artist",
                text = {
                    "Submarine Screw",
                    "{s:0.75,C:inactive}submarinescrew.bsky.social{}"
                }
            },
            credits_mattman = {
                name = "Screams",
                text = {
                    "Lazy Mattman",
                    "{s:0.75,X:red,C:white}@lazymattman{}"
                }
            },
            credits_placeholder = {
                name = "Artist",
                text = {
                    "Placeholder"
                }
            },
            oc_credits_j8 = {
                name = "OC Credits",
                text = {
                    "J8-Bit",
                    "{s:0.75,C:inactive}j8-bit.bsky.social{}"
                }
            },
            oc_credits_thatartisan = {
                name = "OC Credits",
                text = {
                    "ThatArtisan",
                    "{s:0.75,C:inactive}thatartisan.bsky.social{}"
                }
            },
            oc_credits_sift = {
                name = "OC Credits",
                text = {
                    "Sift",
                    "{s:0.75,C:inactive}siftmicro.bsky.social{}"
                }
            },
            oc_credits_thisisbennyk = {
                name = "OC Credits",
                text = {
                    "ThisIsBennyK",
                    "{s:0.75,C:inactive}thisisbennyk.com{}"
                }
            },
            oc_credits_elle = {
                name = "OC Credits",
                text = {
                    "ellestuff",
                    "{s:0.75,C:inactive}ellestuff.dev{}"
                }
            },
            oc_credits_ozoneserpent = {
                name = "OC Credits",
                text = {
                    "ozoneserpent",
                    "{s:0.75,C:inactive}ozoneserpent.bsky.social{}"
                }
            },
            oc_credits_jess = {
                name = "OC Credits",
                text = {
                    "Jess",
                    "{s:0.75,C:inactive}soup587.bsky.social{}"
                }
            },
            oc_credits_submarine_screw = {
                name = "Character Design Credits",
                text = {
                    "Submarine Screw",
                    "{s:0.75,C:inactive}submarinescrew.bsky.social{}"
                }
            },
            oc_pronouns_hehim = {
                name = "OC Pronouns",
                text = {
                    "he/him"
                }
            },
            oc_pronouns_sheher = {
                name = "OC Pronouns",
                text = {
                    "she/her"
                }
            },
            oc_pronouns_theythem = {
                name = "OC Pronouns",
                text = {
                    "they/them"
                }
            },
            requested_by_viomarks = {
                name = "Requested by",
                text = {
                    "Viomarks",
                    "{s:0.75,C:inactive}viomarks.bsky.social{}"
                }
            },
        }
    },
    misc = {
        dictionary = {
            j8mod_no_deltarune_spoilers = "No Deltarune Spoilers",
            j8mod_no_deltarune_spoilers_desc = {
                "Replaces references to Deltarune Chapters 3-4",
                "with other things. Enable this if you haven't",
                "played past Chapter 2 and don't want to be spoiled.",
                "Does not affect references to Undertale,",
                "Deltarune Chapters 1-2, or any cross-mod Jokers."
            },
            j8mod_furry_mode = "Original Art Direction",
            j8mod_furry_mode_desc = {
                "Some Jokers will have alternate artwork",
                "when enabled which aligns with the original",
                "art direction for said Jokers. Though none",
                "of the artwork contains nudity or any NSFW",
                "material, some players may not be comfortable",
                "with the contents of said Jokers. Not required",
                "but highly recommended to disable for streamers.",
                "Does not affect cross-mod Jokers."
            },
            j8mod_enable_crossmod_jokers = "Cross-Mod Jokers",
            j8mod_enable_crossmod_jokers_desc = {
                "Some Jokers only appear when other",
                "mods are installed. Does not require",
                "all compatible mods to be installed",
                "at the same time, and will only add the Jokers",
                "related to each mod. Requires restart for the",
                "new Jokers to appear/disappear properly."
            },
            j8mod_monty_hall_open = "Open Door!",
            j8mod_sandwiched_ex = "Sandwiched!",
            j8mod_tagged_ex = "Tagged!",
            j8mod_flushed_ex = "Flushed!",
            j8mod_ranked_ex = "Ranked!",
            j8mod_nice_ex = "Nice!",
            j8mod_pennies_ex = "Pennies!",
            j8mod_loot_ex = "Loot!",
            j8mod_treasure_ex = "Treasure!",
            j8mod_swapped_ex = "Swapped!",
            j8mod_enhanced_ex = "Enhanced!",
            j8mod_chaos_ex = "CHAOS!",
            j8mod_muffet_laugh = "Ahuhuhu~",
            j8mod_reduced_ex = "Reduced!",
            j8mod_temmie_text = "ho1!",
            j8mod_free_ex = "Free!",
            j8mod_yeah_ex = "Yeah!",
            j8mod_inactive = "inactive",
            j8mod_program_advance = "Program Advance!",
            j8mod_reroll_ex = "Reroll!",
            j8mod_activate_yuri = "ACTIVATE YURI",
            j8mod_yuri = "Yuri!",
            j8mod_activate_friend = "???",
            j8mod_friend = "!!!",
            j8mod_girlfriend = "That's how you do it!",
            j8mod_card_ex = "Card!"
        }
    },
}
