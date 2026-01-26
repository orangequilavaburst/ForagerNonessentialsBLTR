-- ## MOD SETUP ##

J8MOD = SMODS.current_mod
local j8mod_id = J8MOD.id
local j8mod_name = J8MOD.name
--print("I LOVE TASQUE MANAGER")
--print("mod id: " .. j8mod_id)

assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/decks.lua"))()
SMODS.load_file("config.lua")()

J8MOD.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
	quantum_enhancements = true
}

-- ## CONFIG UI ##

local my_config = J8MOD.config

-- Create config UI (Thanks, Paperback!)
J8MOD.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = 'cm' },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							{
								n = G.UIT.C,
								config = { align = "cl", padding = -0.25 },
								nodes = {
									create_toggle { col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = my_config, ref_value = "no_deltarune_spoilers" },
								}
							},
							{
								n = G.UIT.C,
								config = { align = "cl", padding = 0.2 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('j8mod_no_deltarune_spoilers'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, tooltip = { text = localize("j8mod_no_deltarune_spoilers_desc") } } },
								}
							},
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							{
								n = G.UIT.C,
								config = { align = "cl", padding = -0.25 },
								nodes = {
									create_toggle { col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = my_config, ref_value = "furry_mode" },
								}
							},
							{
								n = G.UIT.C,
								config = { align = "cl", padding = 0.2 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('j8mod_furry_mode'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, tooltip = { text = localize('j8mod_furry_mode_desc') } } },
								}
							},
						}
					},
				}
			},
		}
	}
end

SMODS.current_mod.extra_tabs = function()
	return {
		{
			label = "Credits",
			tab_definition_function = function()
				return {
					n = G.UIT.ROOT,
					config = {
						r = 0.1,
						align = "tm",
						padding = 0.2,
						colour = G.C.BLACK
					},
					nodes = {
						{
							n = G.UIT.C,
							config = {
								padding = 0.05,
								align = "tm",
								minh = 2
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										padding = 0.05,
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												align = 'cm',
												text = "Credits",
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												padding = 0.05
											}
										},
									}
								},
								{
									n = G.UIT.R,
									config = {
										padding = 0.125,
										align = "cm"
									},
									nodes = {
										{
											n = G.UIT.C,
											config = {
												align = 'tm',
												r = 0.1,
												colour = G.C.TEXT_DARK,
												outline = 1,
												outline_colour = G.C.TEXT_LIGHT,
												emboss = 0.1,
												padding = 0.05,
												minw = 2,
												minh = 2
											},
											nodes = {
												{
													n = G.UIT.R,
													config = {
														align = "cm",
														colour = G.C.RED,
														r = 0.05,
														emboss = 0.1,
														padding = 0.1
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Artists",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.325,
																padding = 0.25
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "J8-Bit",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "fizlok",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "gimmick",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "czarkhasm",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Sharb",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Veejaybees",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "ThatArtisan",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "BlueberryGrizzly",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "CataChrome",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
											}
										},
										{
											n = G.UIT.C,
											config = {
												align = 'tm',
												r = 0.1,
												colour = G.C.TEXT_DARK,
												outline = 1,
												outline_colour = G.C.TEXT_LIGHT,
												emboss = 0.1,
												padding = 0.05,
												minw = 2,
												minh = 2
											},
											nodes = {
												{
													n = G.UIT.R,
													config = {
														align = "cm",
														colour = G.C.MONEY,
														r = 0.05,
														emboss = 0.1,
														padding = 0.1
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Designers",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.325,
																padding = 0.25
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "J8-Bit",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "FluffiestTail",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "slyck",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "ThatArtisan",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
											}
										},
										{
											n = G.UIT.C,
											config = {
												align = 'tm',
												r = 0.1,
												colour = G.C.TEXT_DARK,
												outline = 1,
												outline_colour = G.C.TEXT_LIGHT,
												emboss = 0.1,
												padding = 0.05,
												minw = 2,
												minh = 2
											},
											nodes = {
												{
													n = G.UIT.R,
													config = {
														align = "cm",
														colour = G.C.GREEN,
														r = 0.05,
														emboss = 0.1,
														padding = 0.1
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Programmers",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.325,
																padding = 0.25
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {
														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "J8-Bit",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
											}
										},
										{
											n = G.UIT.C,
											config = {
												align = 'tm',
												r = 0.1,
												colour = G.C.TEXT_DARK,
												outline = 1,
												outline_colour = G.C.TEXT_LIGHT,
												emboss = 0.1,
												padding = 0.05,
												minw = 2,
												minh = 2
											},
											nodes = {
												{
													n = G.UIT.R,
													config = {
														align = "cm",
														colour = G.C.BLUE,
														r = 0.05,
														emboss = 0.1,
														padding = 0.1
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Playtesters",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.325,
																padding = 0.25
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "FluffiestTail",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "ajb03",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "twilightparasite",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "vlep",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "fizlok",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "czarkhasm",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Laxidaze3",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "AxolotlDreams",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "ThatArtisan",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "puppy_parade",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Megazed101",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "oozywoozy12",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "vybes.",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Catsoulz",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Steven Bills",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
											}
										},
										{
											n = G.UIT.C,
											config = {
												align = 'tm',
												r = 0.1,
												colour = G.C.TEXT_DARK,
												outline = 1,
												outline_colour = G.C.TEXT_LIGHT,
												emboss = 0.1,
												padding = 0.05,
												minw = 2,
												minh = 2
											},
											nodes = {
												{
													n = G.UIT.R,
													config = {
														align = "cm",
														colour = G.C.PURPLE,
														r = 0.05,
														emboss = 0.1,
														padding = 0.1
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Special Thanks",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.325,
																padding = 0.25
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "ThisIsBennyK",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "FluffiestTail",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Catsoulz",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Jaylung",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Emiridian",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Darkwitt",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Ghost12Salt",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "somethingcom515",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "metanite64",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "borb43",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "nh6574",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "thewintercomet",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "TheOneGoofAli",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Viomarks",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Dr. Spectred",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Roffle",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Bean",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Holiday Matsuri",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "The Balatro Discord",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Steammodded devs",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "VanillaRemade devs",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Paperback devs",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
												{
													n = G.UIT.R,
													config = {
														align = "cm"
													},
													nodes = {

														{
															n = G.UIT.T,
															config = {
																align = 'cm',
																text = "Cryptid devs",
																colour = G.C.UI.TEXT_LIGHT,
																scale = 0.25,
																padding = 0.05
															}
														},
													}
												},
											}
										},
									}
								}
							}
						}
					}
				}
			end
		}
	}
end

-- ## JOKER ATLASES ##

SMODS.Atlas {

	key = "j8jokers",
	path = "jokers.png",
	px = 71,
	py = 95

}

SMODS.Atlas {
	key = "j8jokers-werewire",
	path = "jokers-werewire.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-hypno",
	path = "jokers-hypno.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-yuri",
	path = "jokers-yuri.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-clay",
	path = "jokers-clay.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-prophecy",
	path = "jokers-prophecy.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-jevil",
	path = "jokers-jevil.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-swatch",
	path = "jokers-swatch.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = "j8jokers-bn",
	path = "jokers-bn.png",
	px = 74, py = 98
}

SMODS.Atlas {

	key = "j8decks",
	path = "decks-temp.png",
	px = 71,
	py = 95

}

-- ## POOLS ##

-- no longer doing this
--[[
SMODS.ObjectType({
	key = "j8mod_meal_ticket", -- The prefix is not added automatically so it's recommended to add it yourself
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
]]

SMODS.ObjectType({
	key = "j8mod_waterproof_banned_jokers", -- The prefix is not added automatically so it's recommended to add it yourself
	default = "j_splash",
	cards = {
		j_splash = true,
		j_erosion = true,
		j_seltzer = true,
	},
})

SMODS.ObjectType({
	key = "j8mod_lakeside_banned_jokers", -- The prefix is not added automatically so it's recommended to add it yourself
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
	key = "j8mod_lakeside_banned_vouchers", -- The prefix is not added automatically so it's recommended to add it yourself
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
	--if self.ability.brown_magic then
	--#self.sell_cost = 0
	if self.ability.yoshi then
		self.sell_cost = 1 + self.ability.extra_value
	end
end

local card_score_hook = SMODS.score_card
function SMODS.score_card(card, context)
	local g = card_score_hook(card, context)
	if not SMODS.has_no_rank(card) and context.cardarea == G.play then
		--print(card.base.value)
		G.GAME.current_round.j8mod_bookmark_rank = card.base.value
	end
	return g
end

local end_consumeable_hook = G.FUNCS.end_consumeable
function G.FUNCS.end_consumeable(e, delayfac)
	local g = end_consumeable_hook(e, delayfac)
	if G.jokers and G.jokers.cards then
		--print('test! :D ')
		for _, bogo in ipairs(SMODS.find_card("j_j8mod_b1g1f")) do -- For each copy of Buy 1 Get 1 Free
			--print("bogo #" .. tostring(_))
			if (G.shop) then
				--print(bogo.ability.extra.saved_packs)
				while #bogo.ability.extra.saved_packs > 0 do
					local new_booster = bogo.ability.extra.saved_packs[1]
					--print(new_booster)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						func = function()
							local pack = SMODS.add_booster_to_shop(new_booster) --(context.card.config.center.key)
							pack.states.visible = nil
							pack.ability.j8mod_bogo = true
							pack.cost = 0
							G.E_MANAGER:add_event(Event({
								delay = 1.0,
								trigger = "after",
								func = function()
									pack:start_materialize()
									bogo:juice_up()
									save_run()
									return true
								end
							}))
							return true
						end
					}))
					table.remove(bogo.ability.extra.saved_packs, 1)
				end
			end
		end
	end
	return g
end

--[[

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
		elseif G.GAME.selected_back == "b_j8mod_graph" then
			if (card.ability.set == "Tarot" or card.ability.set == "Planet") and (area == G.shop_jokers or area == G.consumeables) then
				card:set_ability("c_fool")
			end
		end
	end
    return card
end

]]

local cardarea_emplace_hook = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
	local ret = cardarea_emplace_hook(self, card, location, stay_flipped)

	if (G.GAME.selected_back and G.GAME.selected_back.effect and G.GAME.selected_back.effect.center and G.GAME.selected_back.effect.center.key == "b_j8mod_hypnotic") then
		--print("on hypnotic deck")
		if self ~= G.jokers then
			local new_key = replace_with_player_consumable(card.ability.set)
			if new_key ~= nil then
				--print("replacing " .. card.ability.set .. " with " .. new_key)
				card:set_ability(new_key)
			end
		end
	elseif (G.GAME.selected_back and G.GAME.selected_back.effect and G.GAME.selected_back.effect.center and G.GAME.selected_back.effect.center.key == "b_j8mod_graph") then
		--print("on graph deck")
		if (card.ability.set == "Tarot" or card.ability.set == "Planet") and (self == G.shop_jokers) then
			--print("replacing " .. card.ability.set .. " with The Fool")
			card:set_ability("c_fool")
		end
	end

	return ret
end

-- ## GRADIENTS ##

SMODS.Gradient({
	key = 'fn',
	colours = { HEX('FDB157'), HEX('FDB157'), HEX('FD5F55'), HEX('8755bf'), HEX('8755bf'), HEX('FD5F55'), },
	cycle = 4,
	interpolation = 'linear'
})

-- ## SHADERS ##

J8MOD.load_custom_image = function(filename)
	local full_path = (J8MOD.path .. "assets/extra_images/" .. filename)
	local file_data = assert(NFS.newFileData(full_path), ("Failed to create file_data"))
	local tempimagedata = assert(love.image.newImageData(file_data), ("Failed to create tempimagedata"))
	return (assert(love.graphics.newImage(tempimagedata), ("Failed to create return image")))
end

J8MOD.prophecy_texture = J8MOD.load_custom_image("depths.png")

SMODS.Shader({ key = 'ww', path = 'ww.fs' })
SMODS.Shader({ key = 'spiral', path = 'spiral.fs' })
SMODS.Shader({ key = 'yuri', path = 'yuri.fs' })
SMODS.Shader({ key = 'normal_mapped', path = 'normal_mapped.fs' })
SMODS.Shader({ key = 'prophecy', path = 'prophecy.fs' })

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
		card:set_ability(G.P_CENTER_POOLS.Joker[index].key)
	elseif set == "Planet" then
		--print(G.P_CENTER_POOLS.Planet)
		for i, planet in ipairs(G.P_CENTER_POOLS.Planet) do
			if planet.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Planet + amount - 1) % #G.P_CENTER_POOLS.Planet
		card:set_ability(G.P_CENTER_POOLS.Planet[index].key)
	elseif set == "Tarot" then
		--print(G.P_CENTER_POOLS.Tarot)
		for i, tarot in ipairs(G.P_CENTER_POOLS.Tarot) do
			if tarot.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Tarot + amount - 1) % #G.P_CENTER_POOLS.Tarot
		card:set_ability(G.P_CENTER_POOLS.Tarot[index].key)
	elseif set == "Voucher" then
		--print(G.P_CENTER_POOLS.Voucher)
		for i, voucher in ipairs(G.P_CENTER_POOLS.Voucher) do
			if voucher.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Voucher + amount - 1) % #G.P_CENTER_POOLS.Voucher
		card:set_ability(G.P_CENTER_POOLS.Voucher[index].key)
	elseif set == "Spectral" then
		--print(G.P_CENTER_POOLS.Spectral)
		for i, spectral in ipairs(G.P_CENTER_POOLS.Spectral) do
			if spectral.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS.Spectral + amount - 1) % #G.P_CENTER_POOLS.Spectral
		card:set_ability(G.P_CENTER_POOLS.Spectral[index].key)
	end
end
