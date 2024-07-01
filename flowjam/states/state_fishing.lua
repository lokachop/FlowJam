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



	FLK3D.AddObjectToUniv("fishrender", "fish_long")
	FLK3D.SetObjectMat("fishrender", "fish_ball_tex")
	FLK3D.SetObjectPos("fishrender", Vector(-64, 0, 0))
	FLK3D.SetObjectAng("fishrender", Angle(0, 0, 0))
	FLK3D.SetObjectScl("fishrender", Vector(.65, .65, .65))
	FLK3D.SetObjectFlag("fishrender", "NO_BACKFACE_CULL", true)

	FLK3D.AddObjectToUniv("hookCatch", "hook")
	FLK3D.SetObjectPos("hookCatch", Vector(.1, 0, 0))
	FLK3D.SetObjectAng("hookCatch", Angle(0, 0, 0))
	FLK3D.SetObjectScl("hookCatch", Vector(1, 1, -1))
	FLK3D.SetObjectFlag("hookCatch", "NO_BACKFACE_CULL", true)
	FLK3D.SetObjectFlag("hookCatch", "COL_HIGHLIGHT", COLOR_WHITE)
	FLK3D.SetObjectFlag("hookCatch", "COL_SHADE", COLOR_WHITE)
FLK3D.PopUniverse()

local subState = 0
local SUBSTATE_HOOKING = 0
local SUBSTATE_REELING = 1
local SUBSTATE_INSPECTING = 2



local function reelThink()
	local turns = FlowJam.GetTurnCount()
	local turnsFish = FlowJam.GetFishTargetTurnCount()

	local turnsLeft = turnsFish - turns
	turnsLeft = math.max(turnsLeft, 0)
end



local fishPos = Vector(0, 0)
local fishVel = Vector(1, 0)
local nextRandom = 0


local function randomDir()
	local rDir = Vector(math.random() * 2 - 1, math.random() * 2 - 1)
	rDir:Normalize()

	return rDir
end


local function initFishHookMinigame()
	fishPos = Vector(math.random(-6, 6), math.random(-6, 6))
	fishVel = Vector(1, 0)
	nextRandom = 0
end

local function fishHookThink(dt)
	fishPos = fishPos + (fishVel * dt)

	if fishPos[1] > 6 then
		fishVel[1] = -fishVel[1]
	end

	if fishPos[1] < -6 then
		fishVel[1] = -fishVel[1]
	end

	if fishPos[2] > 6 then
		fishVel[2] = -fishVel[2]
	end

	if fishPos[2] < -6 then
		fishVel[2] = -fishVel[2]
	end

	if FlowJam.CurTime() > nextRandom then
		local awarenessDelta = FlowJam.GetFishTargetAwareness()
		awarenessDelta = math.max(awarenessDelta, .2)
		local randomDelta = .8 + (math.random() * .2)

		nextRandom = FlowJam.CurTime() + ((awarenessDelta * 16) * randomDelta)
		fishVel = randomDir() * 2
	end



	FLK3D.PushUniverse(univFishing)
		FLK3D.SetObjectPos("fishrender", Vector(0, fishPos[1], fishPos[2]))
	FLK3D.PopUniverse()
end

local function pixelMousePos()
	local mX, mY = LKHooks.GetLastMousePos()
	return mX * 2, mY * 3

end



local function hookThink(dt)
	if not LKHooks.IsMouseDown(1) then
		return
	end


	local mX, mY = LKHooks.GetLastMousePos()
	mX = mX - (FlowJam.TermW() * .5)
	mY = mY - (FlowJam.TermH() * .5)

	mX = mX / FlowJam.TermW()
	mY = mY / FlowJam.TermH()

	mX = mX * 22
	mY = mY * 22

	FLK3D.PushUniverse(univFishing)
		FLK3D.SetObjectPos("hookCatch", Vector(.1, -mY, mX))
	FLK3D.PopUniverse()


	-- attempt to hook
	local ourPos = Vector(-mY, mX, 0)
	local theirPos = fishPos


	if ourPos:Distance(theirPos) < 1 then -- we HAVE HOOKED
		subState = SUBSTATE_REELING
	end
end


local function enterInspect()
	FlowJam.SetState(STATE_INSPECT)
end


local function reelThink(dt)
	local turns = FlowJam.GetTurnCount()
	local turnsFish = FlowJam.GetFishTargetTurnCount()

	local turnsLeft = turnsFish - turns
	turnsLeft = math.max(turnsLeft, 0)


	if turnsLeft <= 0 then
		subState = SUBSTATE_INSPECTING
		enterInspect()
	end
end


function state.onThink(dt)
	if subState == SUBSTATE_HOOKING then
		fishHookThink(dt)
		hookThink(dt)
	elseif subState == SUBSTATE_REELING then
		FlowJam.FishingActionThink(dt)
		reelThink(dt)
	elseif subState == SUBSTATE_INSPECTING then
		
	end

	if not FlowJam.DebugCamThink(dt) then
		FLK3D.SetCamPos(Vector(-12, 0, 0))
		FLK3D.SetCamAng(Angle(0, 90, 0))
	end
end

local circSize = 32
local function renderCircleMinigame()
	local cX, cY = FlowJam.GetFishingActionRenderCenter()


	-- renders fishing rod
	--FLK3D.DrawTexturedRect(facX - 52, facY - 100, 128, 128, "rod_tex")

	local circleSize = circSize
	--local circleSizeH = circleSize * .5
	FLK3D.DrawCircle(cX, cY, circleSize, circleSize, 24, PALETTE_12)


	local realRotProg = FlowJam.GetFishingActionRot()

	local addWidth = 12


	local stickSize = circleSize * 1


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
end

local function renderInfoMinigame()
	local turns = FlowJam.GetTurnCount()
	local turnsFish = FlowJam.GetFishTargetTurnCount()

	local turnsLeft = turnsFish - turns
	turnsLeft = math.max(turnsLeft, 0)

	term.setBackgroundColor(COLOR_BLACK)
	term.setTextColor(COLOR_WHITE)
	term.setCursorPos(1, 1)
	term.write("Turns left; " .. turnsLeft)
end



local function renderInfoHook()
	term.setBackgroundColor(COLOR_BLACK)
	term.setTextColor(COLOR_WHITE)
	term.setCursorPos(1, 1)
	term.write("Hook the fish")

end




function state.onRender()
	FLK3D.PushUniverse(univFishing)
	FLK3D.PushRenderTarget(rtFishing)
		FLK3D.ClearHalfed(PALETTE_1, true)
		FLK3D.RenderActiveUniverse()


		if subState == SUBSTATE_HOOKING then
			FLK3D.RenderRTToScreen()
			renderInfoHook()
		elseif subState == SUBSTATE_REELING then
			renderCircleMinigame()
			FLK3D.RenderRTToScreen()
			renderInfoMinigame()
		elseif subState == SUBSTATE_INSPECTING then
		end
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end


local function setupFish()
	local fishTarget = FlowJam.GetFishTarget()

	circSize = FlowJam.GetFishTargetCircleSize()


	FLK3D.PushUniverse(univFishing)
		FLK3D.SetObjectModel("fishrender", fishTarget.mdl)
		FLK3D.SetObjectMat("fishrender", fishTarget.tex)
		FLK3D.SetObjectPos("fishrender", Vector(0, 0, 0))
	FLK3D.PopUniverse()

	subState = SUBSTATE_HOOKING
end

function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)

	setupFish()
	initFishHookMinigame()
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
end


