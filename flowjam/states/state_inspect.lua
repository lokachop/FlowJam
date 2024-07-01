FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_INSPECT = id

local function setPalette()
	FLK3D.ReplacePaletteColour(PALETTE_1, 64 * .75, 96 * .75, 200 * .75) -- water1
	FLK3D.ReplacePaletteColour(PALETTE_2, 128 * .75, 160 * .75, 240 * .75) -- water2

	FLK3D.ReplacePaletteColour(PALETTE_3, 106, 190, 48) -- FISH1
	FLK3D.ReplacePaletteColour(PALETTE_4, 25, 44, 12) -- FISH2


	--[[
	FLK3D.ReplacePaletteColour(PALETTE_5, 84, 140, 220) -- boat3, glass
	FLK3D.ReplacePaletteColour(PALETTE_6, 255, 64, 64) -- arrow
	FLK3D.ReplacePaletteColour(PALETTE_7, 255 * .5, 64, 64) -- arrow shade
	]]--

	FLK3D.ReplacePaletteColour(PALETTE_5, 80, 120, 180) -- squid1
	FLK3D.ReplacePaletteColour(PALETTE_6, 180, 80, 60) -- squid2
	FLK3D.ReplacePaletteColour(PALETTE_7, 100, 140, 220) -- squid3


	FLK3D.ReplacePaletteColour(PALETTE_11, 96 * .65, 86 * .55, 76 * .45) -- fishCircl2
	FLK3D.ReplacePaletteColour(PALETTE_12, 96, 86, 76) -- fishCircl1

	FLK3D.ReplacePaletteColour(PALETTE_13, 255, 228, 152) -- sun
	FLK3D.ReplacePaletteColour(PALETTE_14, 140 * .75, 180 * .75, 220 * .75) -- sky
end



local univInspect = FLK3D.NewUniverse("UniverseInspect")
local rtInspect = FLK3D.NewRenderTarget("RTInspect", FlowJam.ScrW(), FlowJam.ScrH())

FLK3D.PushUniverse(univInspect)
	FLK3D.AddObjectToUniv("fishinspect", "fish_long")
	FLK3D.SetObjectMat("fishinspect", "fish_ball_tex")
	FLK3D.SetObjectPos("fishinspect", Vector(0, 0, 0))
	FLK3D.SetObjectAng("fishinspect", Angle(0, 0, 0))
	FLK3D.SetObjectScl("fishinspect", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("fishinspect", "NO_BACKFACE_CULL", true)
FLK3D.PopUniverse()




function state.onThink(dt)
	if not FlowJam.DebugCamThink(dt) then
		FLK3D.SetCamPos(Vector(-12, .1, .1))
		FLK3D.SetCamAng(Angle(0, 90, 0))
	end
end



local function renderFishInfo()
	local fishTarget = FlowJam.GetFishTarget()

	FlowJam.APrint(fishTarget.fancyName, FlowJam.TermW() * .5, 1, COLOR_WHITE, COLOR_BLACK, TEXT_ALIGN_CENTER)

	local descCount = #fishTarget.desc
	for i = 1, descCount do
		local descVal = fishTarget.desc[i]


		FlowJam.APrint(descVal, FlowJam.TermW() * .5, FlowJam.TermH() - descCount + i - 2, COLOR_WHITE, COLOR_BLACK, TEXT_ALIGN_CENTER)
	end
end


local function renderCompute()
	for i = 1, 2 do
		FLK3D.PushUniverse(univInspect)
		FLK3D.PushRenderTarget(rtInspect)
			FLK3D.ClearHalfed(PALETTE_1, true)
			FLK3D.RenderActiveUniverse()
		FLK3D.PopRenderTarget()
		FLK3D.PopUniverse()
	end

	FLK3D.PushUniverse(univInspect)
	FLK3D.PushRenderTarget(rtInspect)
		FLK3D.RenderRTToScreen()
		renderFishInfo()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end


function state.onRender()
end


local function setupFish()
	local fishTarget = FlowJam.GetFishTarget()

	FLK3D.PushUniverse(univInspect)
		FLK3D.SetObjectModel("fishinspect", fishTarget.mdl)
		FLK3D.SetObjectMat("fishinspect", fishTarget.tex)
	FLK3D.PopUniverse()
end

function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)

	setupFish()
	renderCompute()
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
end


