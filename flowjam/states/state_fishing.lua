FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_FISHING = id

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



local univFishing = FLK3D.NewUniverse("UniverseFishing")
local rtFishing = FLK3D.NewRenderTarget("RTFishing", FlowJam.ScrW(), FlowJam.ScrH())

-- TODO: loka please i beg stop being lazy please work on this...

FLK3D.PushUniverse(univFishing)

	FLK3D.AddObjectToUniv("flowplane", "ocean_plane")
	FLK3D.SetObjectMat("flowplane", "background_flow")
	FLK3D.SetObjectPos("flowplane", Vector(-1, 0, 0))
	FLK3D.SetObjectAng("flowplane", Angle(0, 0, 90))
	FLK3D.SetObjectScl("flowplane", Vector(14, 1, 14))
	FLK3D.SetObjectFlag("flowplane", "VERT_SHADER", function(vpos, vuv)
		local add = LKHooks.CurTime() * 0.01
		local vX = vpos[1]
		local vY = vpos[1]

		local tmp1 = vuv[1]
		vuv[1] = vuv[2] * .5 + (math.sin((vY + add) * 32) * 0.5)
		vuv[2] = tmp1 * .5
	end)



	FLK3D.AddObjectToUniv("squidtest", "fish_long")
	FLK3D.SetObjectMat("squidtest", "fish_ball_tex")
	FLK3D.SetObjectPos("squidtest", Vector(0, 0, 0))
	FLK3D.SetObjectAng("squidtest", Angle(0, 0, 0))
	FLK3D.SetObjectScl("squidtest", Vector(1, 1, 1))
	FLK3D.SetObjectFlag("squidtest", "NO_BACKFACE_CULL", true)
FLK3D.PopUniverse()


function state.onThink(dt)
	FlowJam.FishingActionThink(dt)

	if not FlowJam.DebugCamThink(dt) then
		FLK3D.SetCamPos(Vector(-12, 0, 0))
		FLK3D.SetCamAng(Angle(0, 90, 0))
	end
end

local function renderRod()


end


local function renderCircleMinigame()
	local cX, cY = FlowJam.GetFishingActionRenderCenter()


	-- renders fishing rod
	--FLK3D.DrawTexturedRect(facX - 52, facY - 100, 128, 128, "rod_tex")




	local circleSize = 16
	--local circleSizeH = circleSize * .5
	FLK3D.DrawCircle(cX, cY, circleSize, circleSize, 24, PALETTE_12)


	local realRotProg = FlowJam.GetFishingActionRot()

	local addWidth = 12


	local stickSize = circleSize * 1.5


	local rotProg1 = realRotProg - addWidth
	local rotRads1 = math.rad(rotProg1)

	local xRot1, yRot1 = math.sin(rotRads1) * stickSize, math.cos(rotRads1) * stickSize

	local rotProg2 = realRotProg + addWidth
	local rotRads2 = math.rad(rotProg2)
	local xRot2, yRot2 = math.sin(rotRads2) * stickSize, math.cos(rotRads2) * stickSize

	FLK3D.DrawPoly({
		{cX, cY},
		{cX + xRot1, cY + yRot1},
		{cX + xRot2, cY + yRot2}
	}, COLOR_WHITE)

	local centerCircleSize = circleSize * .25
	FLK3D.DrawCircle(cX, cY, centerCircleSize, centerCircleSize, 24, PALETTE_11)

	--FLK3D.DrawLine(cX + 16, cY, cX, cY, COLOR_WHITE)
	--FLK3D.DrawPoly()
end


function state.onRender()
	FLK3D.PushUniverse(univFishing)
	FLK3D.PushRenderTarget(rtFishing)
		FLK3D.ClearHalfed(PALETTE_1, true)
		FLK3D.RenderActiveUniverse()

		renderCircleMinigame()
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


