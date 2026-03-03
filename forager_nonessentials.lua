-- ## MOD SETUP ##

J8MOD = SMODS.current_mod
local j8mod_id = J8MOD.id
local j8mod_name = J8MOD.name
--print("mod id: " .. j8mod_id)

assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/decks.lua"))()
assert(SMODS.load_file("src/cross-mod.lua"))()
assert(SMODS.load_file("config.lua"))()

J8MOD.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
	quantum_enhancements = true
}

to_big = to_big or function(x) return x end

-- ## MOD DESCRIPTION UI

SMODS.current_mod.custom_ui = function(mod_nodes)
	mod_nodes = EMPTY(mod_nodes)

	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.C,
		config = { padding = 0.1 },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm"
				},
				nodes = {
					{
						n = G.UIT.C,
						config = {
							r = 0.1,
							align = "cm",
							padding = 0.1,
							colour = SMODS.Gradients["j8mod_fn"],
						},
						nodes = {
							{
								n = G.UIT.R,
								config = {
									r = 0.5,
									align = "cm",
									padding = 0.2,
									colour = G.C.CLEAR
								},
								nodes = {
									{ n = G.UIT.T, config = { text = "Forager Nonessentials v1.0", scale = .75, colour = G.C.WHITE } }
								}
							}
						}
					}
				}
			},
			{
				n = G.UIT.R,
				config = {
					align = "cm"
				},
				nodes = {
					{
						n = G.UIT.C,
						config = { padding = 0.1 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									r = 0.1,
									align = "cm",
									minh = 3,
									padding = 0.1,
									colour = G.C.L_BLACK,
								},
								nodes = {
									{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_j8bit'), align = "cm", } } } },
									{
										n = G.UIT.C,
										config = { align = "cr", padding = 0.1 },
										nodes = {
											{
												n = G.UIT.R,
												config = { align = "cm" },
												nodes = {
													{ n = G.UIT.T, config = { text = "Created by ", scale = .4, colour = G.C.WHITE } },
													{ n = G.UIT.T, config = { text = "J8-Bit", scale = .4, colour = SMODS.Gradients["j8mod_fn"] } }
												}
											},
											{
												n = G.UIT.R,
												config = { align = "cm" },
												nodes = {
													{
														n = G.UIT.C,
														config = { align = "cm" },
														nodes = {
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "(See Credits for", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "all contributors!)", scale = .3, colour = G.C.WHITE } },
																}
															},
														}
													}
												}
											}
										}
									}
								}
							},
						}
					},
					{
						n = G.UIT.C,
						config = { padding = 0.1 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									r = 0.1,
									align = "cm",
									minh = 3,
									padding = 0.1,
									colour = G.C.L_BLACK,
								},
								nodes = {
									{
										n = G.UIT.C,
										config = { align = "cm", padding = 0.1 },
										nodes = {
											{
												n = G.UIT.R,
												config = { align = "cm" },
												nodes = {
													{
														n = G.UIT.C,
														config = { align = "cm" },
														nodes = {
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "A vanilla-adjacent", scale = .4, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "content mod", scale = .4, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "containing:", scale = .4, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- 60+ new Jokers!", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- 8 new Decks!", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Various references!", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Fancy shader effects!", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Alternate card art!", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Cross-mod content!", scale = .3, colour = G.C.WHITE } },
																}
															},
														}
													}
												}
											}
										}
									},
									{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_clownfish'), align = "cm", } } } },
								}
							}
						}
					},
					{
						n = G.UIT.C,
						config = { padding = 0.1 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									r = 0.1,
									align = "cm",
									minh = 3,
									padding = 0.1,
									colour = G.C.L_BLACK,
								},
								nodes = {
									{
										n = G.UIT.C,
										config = { align = "cm", padding = 0.1 },
										nodes = {
											{
												n = G.UIT.R,
												config = { align = "cm" },
												nodes = {
													{
														n = G.UIT.C,
														config = { align = "cm" },
														nodes = {
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "Discover extra Jokers", scale = .4, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "while using these mods:", scale = .4, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Undertale/Deltarune Mod", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- ellejokers.", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cl" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "- Ortalab", scale = .3, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "(new Jokers will appear when", scale = .25, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "their respective mod is installed", scale = .25, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "and when " .. localize("j8mod_enable_crossmod_jokers"), scale = .25, colour = G.C.WHITE } },
																}
															},
															{
																n = G.UIT.R,
																config = { align = "cm" },
																nodes = {
																	{ n = G.UIT.T, config = { text = "is enabled in Config)", scale = .25, colour = G.C.WHITE } },
																}
															},
														}
													}
												}
											}
										}
									},
								}
							}
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = {
					r = 0.1,
					align = "cm",
					minh = 3,
					padding = 0.1,
					colour = G.C.L_BLACK,
				},
				nodes = {
					{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_community_resource'), align = "cm", } } } },
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.05 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									padding = 0.1,
									colour = G.C.RED,
									emboss = 0.05,
									r = 0.1,
								},
								nodes = {
									{ n = G.UIT.T, config = { text = "Important note for players!", scale = .4, colour = G.C.WHITE, align = "cm" } },
								}
							},
							{ n = G.UIT.R, config = { align = "cl", }, nodes = { { n = G.UIT.T, config = { text = "This mod was developed over several months with the goal to", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cl", }, nodes = { { n = G.UIT.T, config = { text = "add fun, creative, interesting, and sometimes self-indulgent", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cl", }, nodes = { { n = G.UIT.T, config = { text = "content to compliment the original game of Balatro.", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cr", }, nodes = { { n = G.UIT.T, config = { text = "Please visit the Config tab to best customize your experience", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cr", }, nodes = { { n = G.UIT.T, config = { text = "with the mod, as some of the original Joker designs were", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cr", }, nodes = { { n = G.UIT.T, config = { text = "not intended with a general audience in mind. Thank you!", scale = .3, colour = G.C.WHITE } }, } },
							{ n = G.UIT.R, config = { align = "cm", }, nodes = { { n = G.UIT.T, config = { text = "Disable " .. localize("j8mod_no_deltarune_spoilers") .. " and enable " .. localize("j8mod_furry_mode") .. " for the fully intended experience.", scale = .25, colour = G.C.BLUE } }, } },
							{ n = G.UIT.R, config = { align = "cm", }, nodes = { { n = G.UIT.T, config = { text = "Recommended to turn off " .. localize("j8mod_furry_mode") .. " for streaming to a general audience.", scale = .25, colour = G.C.RED } }, } },

						}
					},
					{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_kaleidoscope'), align = "cm", } } } },
				}
			},

		}
	}
end

-- ## CONFIG UI ##

function G.FUNCS.j8mod_discover_all() -- totally not taken from kcvanilla
	--print("Discover all!")
	for index, center in pairs(G.P_CENTER_POOLS.Joker) do
		--print(tostring(index) .. " " .. center.key .. " ")
		--print((center.original_mod and center.original_mod.id or "Vanilla"))
		if center.original_mod and center.original_mod.id == j8mod_id then
			discover_card(center)
		end
	end
end

function G.FUNCS.j8mod_undiscover_all()
	--print("Undiscover all!")
	for index, center in pairs(G.P_CENTER_POOLS.Joker) do
		--print(tostring(index) .. " " .. center.key .. " ")
		--print((center.original_mod and center.original_mod.id or "Vanilla"))
		if center.original_mod and center.original_mod.id == j8mod_id then
			j8mod_undiscover(center)
		end
	end
end

function j8mod_undiscover(card)
	if G.GAME.seeded or G.GAME.challenge then
		return
	end
	card.discovered = false
	set_discover_tallies()
	G.E_MANAGER:add_event(Event({
		func = (function()
			G:save_progress()
			return true
		end)
	}))
end

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
						config = { align = "cm", padding = 0.05 },
						nodes = {
							{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_the_world_revolving'), align = "cm", } } } },
							{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_werewire'), align = "cm", } } } },
							{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_mizzmanaged'), align = "cm", } } } },
							{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_assimilation_joker'), align = "cm", } } } },
							{ n = G.UIT.C, nodes = { { n = G.UIT.O, config = { object = create_display_card('j_j8mod_expansion_plans'), align = "cm", } } } },
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
									create_toggle { col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = my_config, ref_value = "no_deltarune_spoilers" },
								}
							},
							{
								n = G.UIT.C,
								config = { align = "cl", padding = 0.2 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('j8mod_no_deltarune_spoilers'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, tooltip = { text = localize("j8mod_no_deltarune_spoilers_desc"), scale = 0.5 } } },
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
									{ n = G.UIT.T, config = { text = localize('j8mod_furry_mode'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, tooltip = { text = localize('j8mod_furry_mode_desc'), scale = 0.5 } } },
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
									create_toggle { col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = my_config, ref_value = "enable_crossmod_jokers" },
								}
							},
							{
								n = G.UIT.C,
								config = { align = "cl", padding = 0.2 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('j8mod_enable_crossmod_jokers'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, tooltip = { text = localize('j8mod_enable_crossmod_jokers_desc'), scale = 0.5 } } },
								}
							},
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.05 },
						nodes = {
							UIBox_button({
								label = { localize("j8mod_discover_all") or "Discover all" },
								button = 'j8mod_discover_all'
							}),

							UIBox_button({
								label = { localize("j8mod_undiscover_all") or "Undiscover all" },
								button = 'j8mod_undiscover_all'
							})
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
														emboss = 0.05,
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
																text = "Vibri",
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
																text = "overgrown.robot",
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
																text = "NeoGnW",
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
																text = "Glasus",
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
																text = "Anubis Jr.",
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
																text = "Mário Santos",
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
																text = "IGJH",
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
																text = "Grizzly Suplex",
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
																text = "Submarine Screw",
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
														emboss = 0.05,
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
														emboss = 0.05,
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
																text = "Vivian Giacobbi",
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
																text = "CyanSoCalico",
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
														emboss = 0.05,
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
																text = "ellestuff",
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
																text = "AgentTheVandal",
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
																text = "Nxkoo",
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
																text = "soso",
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
																text = "Jonmcbane",
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
																text = "CyanSoCalico",
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
														emboss = 0.05,
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
																text = "Vivian Giacobbi",
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
																text = "ellestuff",
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
																text = "Submarine Screw",
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
																text = "LazyMattman",
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
												}, {
												n = G.UIT.R,
												config = {
													align = "cm"
												},
												nodes = {

													{
														n = G.UIT.T,
														config = {
															align = 'cm',
															text = "Potato Patch",
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
																text = "Ortalab devs",
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
																text = "localthunk",
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

	key = "j8jokers-dlc",
	path = "jokers-dlc.png",
	px = 71,
	py = 95

}

SMODS.Atlas {
	key = "j8jokers-clownfish",
	path = "jokers-clownfish.png",
	px = 71, py = 95
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

SMODS.Atlas {
	key = "swatchlings",
	path = "swatchlings.png",
	px = 71, py = 95
}

SMODS.Atlas({
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34,
	atlas_table = "ASSET_ATLAS"
})

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
				if card.config.center.key == "j_j8mod_weather_together" and card.ability.extra then --condition to rotate
					card.children.center.role.r_bond = 'Weak'
					card.children.center.role.role_type = 'Major'
					local t = card.T
					card.children.center.T = setmetatable({}, {
						__index = function(_, k)
							if k == "r" then
								--return math.pi / 2.0
								return card.ability.extra.rot_extra --amount to rotate by (in radians)
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
		if self.ability.couponed then
			self.cost = 0
		end
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

local create_card_hook = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local forced_key = forced_key or nil
	if (G.GAME.selected_back and G.GAME.selected_back.effect and G.GAME.selected_back.effect.center and G.GAME.selected_back.effect.center.key == "b_j8mod_hypnotic"
	and G.GAME.round ~= 0 and area == G.consumeables) then
		forced_key = replace_with_player_consumable(_type)
	end
	return create_card_hook(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end
		

-- ## GRADIENTS ##

SMODS.Gradient({
	key = 'fn',
	colours = { HEX('FDB157'), HEX('FDB157'), HEX('FD5F55'), HEX('8755bf'), HEX('8755bf'), HEX('FD5F55'), },
	cycle = 4,
	interpolation = 'linear'
})

J8MOD.badge_colour = SMODS.Gradients["j8mod_fn"]

SMODS.Gradient({
	key = 'lesbian',
	colours = { HEX('D52D00'), HEX('EF7627'), HEX('FF9A56'), HEX('FFFFFF'), HEX('D162A4'), HEX('B55690'), HEX('A30262') },
	cycle = 2,
	interpolation = 'linear'
})

SMODS.Gradient({
	key = 'friend',
	colours = { HEX('FFF200'), HEX('FFAEC9') },
	cycle = 5,
	interpolation = 'trig'
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
SMODS.Shader({ key = 'jevil', path = 'jevil.fs' })
SMODS.Shader({ key = 'scroll', path = 'scroll.fs' })
SMODS.Shader({ key = 'wiggly', path = 'wiggly.fs' })

-- ## DRAW STEPS ##

SMODS.DrawStep {
	key = "decoration",
	order = 30,
	func = function(card, layer)
		if card and card.config.center.discovered or card.bypass_discovery_center then
			if card.config.center == G.P_CENTERS["j_j8mod_prophecy"] then
				if not J8MOD.config.no_deltarune_spoilers then
					card.config.j8mod_decoration = card.config.j8mod_decoration or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-prophecy',
							{ x = 1, y = 0 })
					card.config.j8mod_decoration.role.draw_major = card
					G.SHADERS['j8mod_prophecy']:send("depths_texture", J8MOD.prophecy_texture)
					--G.SHADERS['j8mod_prophecy']:send("depths_dimensions", {J8MOD.prophecy_texture:getWidth(), J8MOD.prophecy_texture:getHeight()})
					card.config.j8mod_decoration:draw_shader('j8mod_prophecy', nil, card.ARGS.send_to_shader, nil,
						card.children.center)
				else
					if card.config.j8mod_decoration then
						card.config.j8mod_decoration = nil
					end
				end
			elseif card.config.center == G.P_CENTERS["j_j8mod_hypnotic_joker"] then
				card.config.j8mod_decoration = card.config.j8mod_decoration or
					SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-hypno',
						{ x = 1, y = 0 })
				card.config.j8mod_decoration.role.draw_major = card
				card.config.j8mod_decoration:draw_shader('j8mod_spiral', nil, card.ARGS.send_to_shader, nil,
					card.children.center)
			elseif card.config.center == G.P_CENTERS["j_j8mod_werewire"] then
				if not J8MOD.config.no_deltarune_spoilers then
					card.config.j8mod_decoration = card.config.j8mod_decoration or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-werewire',
							{ x = 1, y = 0 })
					card.config.j8mod_decoration.role.draw_major = card
					card.config.j8mod_decoration:draw_shader('j8mod_ww', nil, card.ARGS.send_to_shader, nil,
						card.children.center)
				else
					if card.config.j8mod_decoration then
						card.config.j8mod_decoration = nil
					end
				end
			elseif card.config.center == G.P_CENTERS["j_j8mod_mizzmanaged"] then
				if not J8MOD.config.no_deltarune_spoilers then
					card.config.j8mod_decoration = card.config.j8mod_decoration or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-yuri',
							{ x = 1, y = J8MOD.config.furry_mode and 1 or 0 })
					card.config.j8mod_decoration.role.draw_major = card
					card.config.j8mod_decoration:draw_shader('j8mod_yuri', nil, card.ARGS.send_to_shader, nil,
						card.children.center)
				else
					if card.config.j8mod_decoration then
						card.config.j8mod_decoration = nil
					end
				end
			elseif card.config.center == G.P_CENTERS["j_j8mod_the_world_revolving"] then
				if not J8MOD.config.no_deltarune_spoilers then
					card.config.j8mod_decoration = card.config.j8mod_decoration or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-jevil',
							{ x = 1, y = 0 })
					card.config.j8mod_decoration.role.draw_major = card
					card.config.j8mod_decoration:draw_shader('j8mod_jevil', nil, card.ARGS.send_to_shader, nil,
						card.children.center)
				else
					if card.config.j8mod_decoration then
						card.config.j8mod_decoration = nil
					end
				end
			elseif card.config.center == G.P_CENTERS["j_j8mod_color_cafe"] then
				if not J8MOD.config.no_deltarune_spoilers then
					card.config.j8mod_decoration2 = card.config.j8mod_decoration2 or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h,
							'j8mod_swatchlings',
							{ x = 0, y = 0 })
					card.config.j8mod_decoration2.role.draw_major = card
					G.SHADERS['j8mod_scroll']:send("scroll_speed", { 0.125, 0.0 })
					card.config.j8mod_decoration2:draw_shader('j8mod_scroll', nil, card.ARGS.send_to_shader, nil,
						card.children.center, 0, 0)

					card.config.j8mod_decoration = card.config.j8mod_decoration or
						SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-swatch',
							{ x = 1, y = 0 })
					card.config.j8mod_decoration.role.draw_major = card
					card.config.j8mod_decoration:draw_shader(
						card.edition and (card.edition.shader or string.sub(card.edition.key, 3)) or 'dissolve', nil,
						card.edition and card.ARGS.send_to_shader or nil, nil,
						card.children.center, 0, 0)
				else
					if card.config.j8mod_decoration then
						card.config.j8mod_decoration = nil
					end
					if card.config.j8mod_decoration2 then
						card.config.j8mod_decoration2 = nil
					end
				end
			elseif card.config.center == G.P_CENTERS["j_j8mod_clownfish"] then
				card.config.j8mod_decoration2 = card.config.j8mod_decoration2 or
					SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h,
						'j8mod_j8jokers-clownfish',
						{ x = 1, y = 0 })
				card.config.j8mod_decoration2.role.draw_major = card
				card.config.j8mod_decoration2:draw_shader('j8mod_wiggly', nil, card.ARGS.send_to_shader, nil,
					card.children.center, 0, 0)

				card.config.j8mod_decoration = card.config.j8mod_decoration or
					SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, 'j8mod_j8jokers-clownfish',
						{ x = 2, y = 0 })
				card.config.j8mod_decoration.role.draw_major = card
				card.config.j8mod_decoration:draw_shader(
					card.edition and (card.edition.shader or string.sub(card.edition.key, 3)) or 'dissolve', nil,
					card.edition and card.ARGS.send_to_shader or nil, nil,
					card.children.center, 0, 0)
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' }
}

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
		--[[
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
	]]
	else
		for i, thing in ipairs(G.P_CENTER_POOLS[set]) do
			if thing.key == key then
				index = i
				break
			end
		end
		index = 1 + (index + #G.P_CENTER_POOLS[set] + amount - 1) % #G.P_CENTER_POOLS[set]
		card:set_ability(G.P_CENTER_POOLS[set][index].key)
	end
end

-- totally not taken from slimeutils. thanks elle
function create_display_card(key)
	local card = Card(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W * .75, G.CARD_H * .75, nil, G.P_CENTERS[key],
		{ bypass_discovery_center = true, bypass_discovery_ui = true })
	card.no_ui = true
	card.states.drag.can = false
	return card
end
