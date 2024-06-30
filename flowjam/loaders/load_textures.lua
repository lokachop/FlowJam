FlowJam = FlowJam or {}

LKTEX.LoadPPM("ocean_tex", "textures/tex_ocean.ppm", {
	[LKTEX.ColourHash(91, 110, 225)] = PALETTE_1,
	[LKTEX.ColourHash(99, 155, 255)] = PALETTE_2,
})

LKTEX.LoadPPM("background_flow", "textures/tex_background_flow.ppm", {
	[LKTEX.ColourHash(91, 110, 225)] = PALETTE_1,
	[LKTEX.ColourHash(99, 155, 255)] = PALETTE_2,
})

LKTEX.LoadPPM("cloud_tex", "textures/tex_cloud.ppm", {
	[LKTEX.ColourHash(255, 0, 0)] = -1, -- sky
	[LKTEX.ColourHash(255, 255, 255)] = COLOR_WHITE, -- cloud col
})


LKTEX.LoadPPM("metal_tex", "textures/tex_metal.ppm", {
	[LKTEX.ColourHash(106, 106, 106)] = PALETTE_4, -- metal2
	[LKTEX.ColourHash(151, 151, 151)] = PALETTE_3, -- metal1
})

LKTEX.LoadPPM("glass_tex", "textures/tex_glass.ppm", {
	[LKTEX.ColourHash(99, 155, 255)] = PALETTE_5, -- glass
	[LKTEX.ColourHash(255, 255, 255)] = COLOR_WHITE, -- metal2
})


LKTEX.LoadPPM("cloud_glass", "textures/tex_cloud.ppm", {
	[LKTEX.ColourHash(255, 0, 0)] = PALETTE_5, -- glass
	[LKTEX.ColourHash(255, 255, 255)] = COLOR_WHITE, -- cloud col
})

LKTEX.LoadPPM("debug", "textures/tex_debug.ppm", {
	[LKTEX.ColourHash(255, 0, 0)] = PALETTE_8,
	[LKTEX.ColourHash(0, 0, 0)] = PALETTE_9,
})




LKTEX.LoadPPM("squid_tex", "textures/tex_squid_dither.ppm", {
	[LKTEX.ColourHash(0, 0, 0)] = PALETTE_7,
	[LKTEX.ColourHash(255, 255, 255)] = PALETTE_6, -- squid1
	[LKTEX.ColourHash(172, 50, 50)] = PALETTE_5, -- squid2
	[LKTEX.ColourHash(155, 173, 183)] = COLOR_BLACK, -- squid3
})


LKTEX.LoadPPM("rod_tex", "textures/tex_fishingrod.ppm", {
	[LKTEX.ColourHash(172, 50, 50)] = -1, -- transparent

	[LKTEX.ColourHash(143, 86, 59)] = PALETTE_4, -- rod1
	[LKTEX.ColourHash(105, 106, 106)] = PALETTE_3, -- squid2
	[LKTEX.ColourHash(102, 57, 49)] = PALETTE_11, -- squid3
})


LKTEX.LoadPPM("fish_ball_tex", "textures/tex_fish_ball_dither.ppm", {
	[LKTEX.ColourHash(106, 190, 48)] = PALETTE_3, -- GREEN1
	[LKTEX.ColourHash(25, 44, 12)] = PALETTE_4, -- GREEN2
	[LKTEX.ColourHash(0, 0, 0)] = COLOR_BLACK, -- BLACK1
	[LKTEX.ColourHash(255, 0, 0)] = PALETTE_5, -- RED1
})