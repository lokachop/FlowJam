FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_MENU = id

local univMenu = FLK3D.NewUniverse("UniverseMenu")
local rtMenu = FLK3D.NewRenderTarget("RTMenu", FlowJam.ScrW(), FlowJam.ScrH())

-- setup FLK3D Universe for menu
local function setPalette()
	FLK3D.ReplacePaletteColour(PALETTE_1, 64, 96, 200) -- water1
	FLK3D.ReplacePaletteColour(PALETTE_2, 128, 160, 240) -- water2

	FLK3D.ReplacePaletteColour(PALETTE_3, 84, 88, 94) -- boat1
	FLK3D.ReplacePaletteColour(PALETTE_4, 84 * .5, 88 * .5, 94 * .5) -- boat2
	FLK3D.ReplacePaletteColour(PALETTE_5, 84, 140, 220) -- boat3, glass


	FLK3D.ReplacePaletteColour(PALETTE_12, 255, 140, 32) -- selected option
	FLK3D.ReplacePaletteColour(PALETTE_13, 255, 228, 152) -- sun
	FLK3D.ReplacePaletteColour(PALETTE_14, 140 * .75, 180 * .75, 220 * .75) -- sky
end

FLK3D.PushUniverse(univMenu)
	FLK3D.AddObjectToUniv("ocean", "ocean_plane")
	FLK3D.SetObjectMat("ocean", "ocean_tex")
	FLK3D.SetObjectPos("ocean", Vector(0, 0, 0))
	FLK3D.SetObjectAng("ocean", Angle(0, 0, 0))
	FLK3D.SetObjectScl("ocean", Vector(64, 1, 64))
	FLK3D.SetObjectFlag("ocean", "VERT_SHADER", function(vpos, vuv)
		local add = LKHooks.CurTime() * 0.05
		local vX = vpos[1]
		local vY = vpos[3]

		vuv[1] = vuv[1] + math.sin((add * 2) + (vY * 4)) + add
		vuv[2] = vuv[2] + math.cos(add * 0.5 + vX * 2) + add

		-- curv world
		--local dist = vpos:DistToSqr(Vector(0, 0, 0))
		--vpos[2] = vpos[2] - (dist * 24)
	end)


	FLK3D.AddObjectToUniv("boat", "boat")
	FLK3D.SetObjectPos("boat", Vector(0, 0.3, 0))
	FLK3D.SetObjectAng("boat", Angle(0, 25, 0))
	FLK3D.SetObjectScl("boat", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("boat", "COL_OUTLINE", COLOR_BLACK)
	FLK3D.SetObjectFlag("boat", "DO_OUTLINE", false)
	FLK3D.SetObjectFlag("boat", "OUTLINE_SCALE", 0.3)
	--FLK3D.SetObjectMat("boat", "metal_tex")
	FLK3D.SetObjectFlag("boat", "PLANAR_SHADOW", true)
	FLK3D.SetObjectFlag("boat", "PLANAR_SHADOW_MODEL", "boat_singlemesh")

	FLK3D.SetObjectFlag("boat", "SHADING", true)
	FLK3D.SetObjectFlag("boat", "SHADING_SMOOTH", false)
	FLK3D.SetObjectFlag("boat", "SHADE_THRESHOLD", 0.6)
	FLK3D.SetObjectFlag("boat", "COL_HIGHLIGHT", PALETTE_3)
	FLK3D.SetObjectFlag("boat", "COL_SHADE", PALETTE_4)


	FLK3D.AddObjectToUniv("boat_window", "boat_window")
	FLK3D.SetObjectPos("boat_window", Vector(0, 0.3, 0))
	FLK3D.SetObjectAng("boat_window", Angle(0, 25, 0))
	FLK3D.SetObjectScl("boat_window", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("boat_window", "COL_OUTLINE", PALETTE_5)
	FLK3D.SetObjectFlag("boat_window", "DO_OUTLINE", true)
	FLK3D.SetObjectFlag("boat_window", "OUTLINE_SCALE", 0.3)
	FLK3D.SetObjectMat("boat_window", "glass_tex")


	FLK3D.AddObjectToUniv("clouds", "cloud_plane")
	FLK3D.SetObjectMat("clouds", "cloud_tex")
	FLK3D.SetObjectPos("clouds", Vector(0, 8, 0))
	FLK3D.SetObjectAng("clouds", Angle(180, 0, 0))
	FLK3D.SetObjectScl("clouds", Vector(128, 1, 128))
	FLK3D.SetObjectFlag("clouds", "VERT_SHADER", function(vpos, vuv)
		local add = LKHooks.CurTime() * 0.05

		vuv[1] = vuv[1] * .5 + add
		vuv[2] = vuv[2] * .5 + add
	end)


	--[[
	FLK3D.AddObjectToUniv("the_sun_object", "cube")
	FLK3D.SetObjectScl("the_sun_object", Vector(1, 1, 1))
	FLK3D.SetObjectFlag("the_sun_object", "COL_HIGHLIGHT", PALETTE_13)
	FLK3D.SetObjectPos("the_sun_object", Vector(0, 5, 0))
	FLK3D.SetObjectAng("the_sun_object", Angle(0, 0, 0))
	FLK3D.SetObjectFlag("the_sun_object", "NO_BACKFACE_CULL", true)
	]]--


	--[[
	FLK3D.AddObjectToUniv("cloud1", "cloud_lq")
	FLK3D.SetObjectPos("cloud1", Vector(16, 12, -16))
	FLK3D.SetObjectAng("cloud1", Angle(0, -45, 0))
	FLK3D.SetObjectScl("cloud1", Vector(2, 2, 2))

	FLK3D.AddObjectToUniv("cloud2", "cloud_lq")
	FLK3D.SetObjectPos("cloud2", Vector(32, 8, -14))
	FLK3D.SetObjectAng("cloud2", Angle(0, -15, 0))
	FLK3D.SetObjectScl("cloud2", Vector(2, 2, 2))
	]]--
FLK3D.PopUniverse()


local selectedButton = 0
local buttonCount = 2

local keyFlag = false
local function mainMenuButtonThink()
	local keyMoveUp = LKHooks.IsKeyDown(keys.w) or LKHooks.IsKeyDown(keys.up)
	local keyMoveDown = LKHooks.IsKeyDown(keys.s) or LKHooks.IsKeyDown(keys.down)


	if keyFlag and not (keyMoveUp or keyMoveDown) then
		keyFlag = false
	end

	if keyFlag then
		return
	end

	if keyMoveUp then
		selectedButton = selectedButton - 1
		keyFlag = true
	end

	if keyMoveDown then
		selectedButton = selectedButton + 1
		keyFlag = true
	end

	if selectedButton < 0 then
		selectedButton = buttonCount
	elseif selectedButton > buttonCount then
		selectedButton = 0
	end
end


local function buttonPressThink()
	if not (LKHooks.IsKeyDown(keys.space) or LKHooks.IsKeyDown(keys.enter)) then
		return
	end

	-- this IS BAD
	if selectedButton == 0 then -- Play
		FlowJam.SetState(STATE_GAME)
	elseif selectedButton == 1 then -- Credits
		FlowJam.SetState(STATE_CREDITS)
	else -- Quit
		FLK3D.ResetPalette()
		LKHooks.ExitProgram()
		term.setBackgroundColor(colors.black)
		term.clear()

		local sw, sh = FlowJam.GetTermDimensions()


		FlowJam.APrint("--==Aquatic Tide==--", sw * .5, 1, colors.white, colors.black, TEXT_ALIGN_CENTER)

		local textNames = "A game by Lokachop & Lefton"
		local tWNames = #textNames
		term.setCursorPos(math.floor(sw * .5 - tWNames * .5), 2)
		term.write("A game by ")

		term.setTextColor(colors.lime)
		term.write("Lokachop")

		term.setTextColor(colors.white)
		term.write(" & ")

		term.setTextColor(colors.orange)
		term.write("Lefton")

		term.setTextColor(colors.white)

		FlowJam.APrint("Coded for PineJam 2024", sw * .5, 3, colors.white, colors.black, TEXT_ALIGN_CENTER)
		FlowJam.APrint("Thanks for playing!", sw * .5, 4, colors.white, colors.black, TEXT_ALIGN_CENTER)

		term.setCursorPos(1, 5)
	end
end


function state.onThink(dt)
	local cTime = FlowJam.CurTime()
	local angBoat = Angle(math.sin(cTime * 2) * 4, 25 + math.cos(cTime * 0.5) * 6, math.cos(cTime * 1.433) * 4)

	FLK3D.PushUniverse(univMenu)
		FLK3D.SetObjectAng("boat", angBoat)
		FLK3D.SetObjectAng("boat_window", angBoat)

		FlowJam.UpdateSceneShadows()
		FlowJam.UpdateSceneSun()
	FLK3D.PopUniverse()

	if not FlowJam.DebugCamThink(dt) then
		FLK3D.SetCamPos(Vector(3.5, -1.5, 4))
		FLK3D.SetCamAng(Angle(-12, -140, 0))
	end

	mainMenuButtonThink()
	buttonPressThink()
end



local function renderMainMenu()
	local sw, sh = FlowJam.GetTermDimensions()

	local logoX, logoY = 1, sh * .2
	FlowJam.APrint("=========================", logoX, logoY - 1, COLOR_WHITE, COLOR_BLACK, TEXT_ALIGN_LEFT)
	FlowJam.APrint("======Aquatic Tide=======", logoX, logoY, COLOR_WHITE, COLOR_BLACK, TEXT_ALIGN_LEFT)
	FlowJam.APrint("=========================", logoX, logoY + 1, COLOR_WHITE, COLOR_BLACK, TEXT_ALIGN_LEFT)

	local colOptionPlay = selectedButton == 0 and PALETTE_12 or COLOR_BLACK
	FlowJam.APrint("[Play]", 1, sh * .4, COLOR_WHITE, colOptionPlay, TEXT_ALIGN_LEFT)

	local colOptionCredits = selectedButton == 1 and PALETTE_12 or COLOR_BLACK
	FlowJam.APrint("[Credits]", 1, sh * .5, COLOR_WHITE, colOptionCredits, TEXT_ALIGN_LEFT)

	local colOptionExit = selectedButton == 2 and PALETTE_12 or COLOR_BLACK
	FlowJam.APrint("[Exit]", 1, sh * .6, COLOR_WHITE, colOptionExit, TEXT_ALIGN_LEFT)
end

local dtFrameSkip = 1 / 60
local nextFrame = 0
function state.onRender()
	-- limit to 60fps on mainmenu
	local cTime = FlowJam.CurTime()
	if cTime < nextFrame then
		return
	end
	nextFrame = cTime + dtFrameSkip

	FLK3D.PushUniverse(univMenu)
	FLK3D.PushRenderTarget(rtMenu)
		FLK3D.ClearHalfed(PALETTE_14, true)
		FLK3D.RenderActiveUniverse()
		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()

	renderMainMenu()
end

function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)

	FlowJam.SetSong("menu1")
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
end