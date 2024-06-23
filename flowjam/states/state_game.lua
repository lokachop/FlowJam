FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_GAME = id

local univGame = FLK3D.NewUniverse("UniverseGame")
local rtGame = FLK3D.NewRenderTarget("RTGame", FlowJam.ScrW(), FlowJam.ScrH())



-- setup FLK3D Universe for game
local function setPalette()
	FLK3D.ReplacePaletteColour(PALETTE_1, 64, 96, 200) -- water1
	FLK3D.ReplacePaletteColour(PALETTE_2, 128, 160, 240) -- water2

	FLK3D.ReplacePaletteColour(PALETTE_3, 84, 88, 94) -- boat1
	FLK3D.ReplacePaletteColour(PALETTE_4, 84 * .5, 88 * .5, 94 * .5) -- boat2
	FLK3D.ReplacePaletteColour(PALETTE_5, 84, 140, 220) -- boat3, glass
	FLK3D.ReplacePaletteColour(PALETTE_6, 255, 64, 64) -- arrow
	FLK3D.ReplacePaletteColour(PALETTE_7, 255 * .5, 64, 64) -- arrow shade

	FLK3D.ReplacePaletteColour(PALETTE_13, 255, 228, 152) -- sun
	FLK3D.ReplacePaletteColour(PALETTE_14, 140 * .75, 180 * .75, 220 * .75) -- sky
end


FLK3D.PushUniverse(univGame)
	FLK3D.AddObjectToUniv("ocean", "ocean_plane")
	FLK3D.SetObjectMat("ocean", "debug")
	FLK3D.SetObjectPos("ocean", Vector(0, 0, 0))
	FLK3D.SetObjectAng("ocean", Angle(0, 0, 0))
	FLK3D.SetObjectScl("ocean", Vector(64, 1, 64))
	FLK3D.SetObjectFlag("ocean", "VERT_SHADER", function(vpos, vuv)
		local add = LKHooks.CurTime() * 0.05
		local vX = vpos[1]
		local vY = vpos[3]

		--vuv[1] = vuv[1] + math.sin((add * 2) + (vY * 4)) + add
		--vuv[2] = vuv[2] + math.cos(add * 0.5 + vX * 2) + add
	end)

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

	FlowJam.SetupBoat()
	FlowJam.SetupFishingCircle()
FLK3D.PopUniverse()



function state.onThink(dt)
	--local cTime = FlowJam.CurTime()
	--local angBoat = Angle(math.sin(cTime * 2) * 4, 25 + math.cos(cTime * 0.5) * 6, math.cos(cTime * 1.433) * 4)

	FLK3D.PushUniverse(univGame)
		--FLK3D.SetObjectAng("boat", angBoat)
		--FLK3D.SetObjectAng("boat_window", angBoat)
		FlowJam.BoatThink(dt)

		FlowJam.UpdateSceneShadows()
		FlowJam.UpdateSceneSun()
	FLK3D.PopUniverse()

	if not FlowJam.DebugCamThink(dt) then
		FlowJam.OrbCamThink(dt)
	end
end



function state.onRender()
	FLK3D.PushUniverse(univGame)
	FLK3D.PushRenderTarget(rtGame)
		FLK3D.ClearHalfed(PALETTE_14, true)
		FLK3D.RenderActiveUniverse()

		FLK3D.DrawRect(0, 0, 32, 32, COLOR_BLACK)

		FLK3D.DrawTexturedRect(0, 0, 32, 32, "cloud_tex")

		FLK3D.DrawCircle(FlowJam.ScrW() * .5, FlowJam.ScrH() * .5, 16, 16, 16, PALETTE_13)


		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end

function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)

	FlowJam.SetOrbCamOrigin(Vector(0, -1, 0))
	FlowJam.SetSong("general1")
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
end