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
	end)


	FLK3D.AddObjectToUniv("boat", "boat")
	FLK3D.SetObjectPos("boat", Vector(0, 1, 0))
	FLK3D.SetObjectAng("boat", Angle(0, 25, 0))
	FLK3D.SetObjectScl("boat", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("boat", "COL_OUTLINE", COLOR_BLACK)
	FLK3D.SetObjectFlag("boat", "DO_OUTLINE", true)
	FLK3D.SetObjectFlag("boat", "OUTLINE_SCALE", 0.3)
	FLK3D.SetObjectMat("boat", "metal_tex")

	--[[
	FLK3D.SetObjectFlag("boat", "SHADING", true)
	FLK3D.SetObjectFlag("boat", "SHADE_THRESHOLD", 0.7)
	FLK3D.SetObjectFlag("boat", "SHADING_SMOOTH", true)
	FLK3D.SetObjectFlag("boat", "COL_HIGHLIGHT", PALETTE_3)
	FLK3D.SetObjectFlag("boat", "COL_SHADE", PALETTE_4)
	]]--



	FLK3D.AddObjectToUniv("boat_window", "boat_window")
	FLK3D.SetObjectPos("boat_window", Vector(0, 1, 0))
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

		vuv[1] = vuv[1] + add
		vuv[2] = vuv[2] + add
	end)

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


function state.onThink(dt)
	local cTime = FlowJam.CurTime()
	local angBoat = Angle(math.sin(cTime * 2) * 4, 25 + math.cos(cTime * 0.5) * 6, math.cos(cTime * 1.433) * 4)

	FLK3D.PushUniverse(univMenu)
		FLK3D.SetObjectAng("boat", angBoat)
		FLK3D.SetObjectAng("boat_window", angBoat)
	FLK3D.PopUniverse()

	if not FlowJam.DebugCamThink(dt) then
		FLK3D.SetCamPos(Vector(4, -2, -1.5))
		FLK3D.SetCamAng(Angle(-3, -42, 0))
	end
end






local function renderMainMenu()
	local sw, sh = FlowJam.GetDimensions()

end


function state.onRender()
	FLK3D.PushUniverse(univMenu)
	FLK3D.PushRenderTarget(rtMenu)
		FLK3D.ClearHalfed(PALETTE_14, true)
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