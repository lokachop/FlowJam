FlowJam = FlowJam or {}

LKTEX.LoadPPM("ocean_tex", "textures/tex_ocean.ppm", {
	[LKTEX.ColourHash(91, 110, 225)] = PALETTE_1,
	[LKTEX.ColourHash(99, 155, 255)] = PALETTE_2,
})

LKTEX.LoadPPM("cloud_tex", "textures/tex_cloud.ppm", {
	[LKTEX.ColourHash(255, 0, 0)] = PALETTE_14, -- sky
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