FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_FISHING = id

local function setPalette()
	FLK3D.ReplacePaletteColour(PALETTE_1, 64 * .75, 96 * .75, 200 * .75) -- water1
	FLK3D.ReplacePaletteColour(PALETTE_2, 128 * .75, 160 * .75, 240 * .75) -- water2

	FLK3D.ReplacePaletteColour(PALETTE_3, 84, 88, 94) -- boat1
	FLK3D.ReplacePaletteColour(PALETTE_4, 84 * .5, 88 * .5, 94 * .5) -- boat2
	FLK3D.ReplacePaletteColour(PALETTE_5, 84, 140, 220) -- boat3, glass
	FLK3D.ReplacePaletteColour(PALETTE_6, 255, 64, 64) -- arrow
	FLK3D.ReplacePaletteColour(PALETTE_7, 255 * .5, 64, 64) -- arrow shade

	FLK3D.ReplacePaletteColour(PALETTE_13, 255, 228, 152) -- sun
	FLK3D.ReplacePaletteColour(PALETTE_14, 140 * .75, 180 * .75, 220 * .75) -- sky
end



local univFishing = FLK3D.NewUniverse("UniverseFishing")
local rtFishing = FLK3D.NewRenderTarget("RTFishing", FlowJam.ScrW(), FlowJam.ScrH())

-- TODO: loka please i beg stop being lazy please work on this...

FLK3D.PushUniverse(univFishing)


FLK3D.PopUniverse()


function state.onThink(dt)

end


function state.onRender()
	FLK3D.PushUniverse(univFishing)
	FLK3D.PushRenderTarget(rtFishing)
		FLK3D.ClearHalfed(PALETTE_1, true)
		FLK3D.RenderActiveUniverse()

		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end


function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
end