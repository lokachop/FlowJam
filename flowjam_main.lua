if not term.isColor() then
	term.clear()

	local messages = {
		"This program can't run on this machine!",
		"Please use an advanced computer!"
	}

	local tW, tH = term.getSize()

	for k, v in ipairs(messages) do
		term.setCursorPos(math.floor(tW * .5) - math.floor(#v * .5), math.floor(tH * .5) + (k - 1))
		term.write(v)
	end

	term.setCursorPos(1, tH)
	return
end


require("flk3d.flk3d")
require("lkhooks.lkhooks")
require("flowjam.flowjam")



FLK3D.ResetPalette()

COLOR_WHITE = FLK3D.DeclareNewPaletteColour(255, 255, 255)
COLOR_BLACK = FLK3D.DeclareNewPaletteColour(24, 24, 24)

COLOR_BACKGROUND = FLK3D.DeclareNewPaletteColour(160, 196, 220)


COLOR_GREEN_BR = FLK3D.DeclareNewPaletteColour(64, 220, 64)

COLOR_GREEN_DR = FLK3D.DeclareNewPaletteColour(16, 96, 16)

COLOR_TEST1 = FLK3D.DeclareNewPaletteColour(255, 255, 16)
COLOR_TEST2 = FLK3D.DeclareNewPaletteColour(255, 128, 16)
COLOR_TEST3 = FLK3D.DeclareNewPaletteColour(255,  64, 16)
COLOR_TEST4 = FLK3D.DeclareNewPaletteColour(255,   0, 16)


LKTEX.LoadPPM("test1", "textures/tex_test.ppm", {
	[LKTEX.ColourHash(106, 190, 48)] = COLOR_TEST1,
	[LKTEX.ColourHash(172, 50, 50)] = COLOR_TEST2,
	[LKTEX.ColourHash(118, 66, 138)] = COLOR_TEST3,
	[LKTEX.ColourHash(155, 173, 183)] = COLOR_TEST4,
})

COLOR_OCEAN1 = FLK3D.DeclareNewPaletteColour(16,  64, 220)
COLOR_OCEAN2 = FLK3D.DeclareNewPaletteColour(64, 128, 255)

LKTEX.LoadPPM("ocean_tex", "textures/tex_ocean.ppm", {
	[LKTEX.ColourHash(91, 110, 225)] = COLOR_OCEAN1,
	[LKTEX.ColourHash(99, 155, 255)] = COLOR_OCEAN2,
})





local univ = FLK3D.NewUniverse("FLK3D_Test1_Universe")
local rw, rh = term.getSize()
local rt = FLK3D.NewRenderTarget("FLK3D_Test1_RT", rw * 3, rh * 3)

FLK3D.BuildProjectionMatrix(rw / rh, 0.1, 64)
FLK3D.SetCamPos(Vector(0, 0, -4))







FLK3D.PushUniverse(univ)
	FLK3D.AddObjectToUniv("loka1", "lokachop_sqr")
	FLK3D.SetObjectPos("loka1", Vector(-2, 0, 0))
	FLK3D.SetObjectAng("loka1", Angle(0, 180, 0))
	FLK3D.SetObjectFlag("loka1", "SHADING", true)
	FLK3D.SetObjectFlag("loka1", "SHADING_SMOOTH", true)
	FLK3D.SetObjectFlag("loka1", "COL_HIGHLIGHT", COLOR_GREEN_BR) -- index
	FLK3D.SetObjectFlag("loka1", "COL_SHADE", COLOR_GREEN_DR)
	FLK3D.SetObjectFlag("loka1", "COL_OUTLINE", COLOR_BLACK)
	FLK3D.SetObjectFlag("loka1", "SHADE_THRESHOLD", 0.8)
	FLK3D.SetObjectFlag("loka1", "DO_OUTLINE", true)
	FLK3D.SetObjectFlag("loka1", "NORM_INVERT", false)
	FLK3D.SetObjectFlag("loka1", "NO_BACKFACE_CULL", true)



	FLK3D.AddObjectToUniv("cube1", "cube")
	FLK3D.SetObjectPos("cube1", Vector(2, 0, 0))
	FLK3D.SetObjectAng("cube1", Angle(0, 0, 0))
	FLK3D.SetObjectFlag("cube1", "COL_OUTLINE", COLOR_BLACK)
	FLK3D.SetObjectFlag("cube1", "SHADE_THRESHOLD", 0.8)
	FLK3D.SetObjectFlag("cube1", "DO_OUTLINE", true)
	FLK3D.SetObjectMat("cube1", "test1")


	FLK3D.AddObjectToUniv("ocean", "ocean_plane")
	FLK3D.SetObjectMat("ocean", "ocean_tex")
	FLK3D.SetObjectPos("ocean", Vector(0, -1, 0))
	FLK3D.SetObjectAng("ocean", Angle(0, 0, 0))
	FLK3D.SetObjectScl("ocean", Vector(64, 1, 64))
	FLK3D.SetObjectFlag("ocean", "VERT_SHADER", function(vpos, vuv)
		--error("CALLME")
		local add = LKHooks.CurTime() * 0.05
		local vX = vpos[1]
		local vY = vpos[3]

		vuv[1] = vuv[1] + math.sin((add * 2) + (vY * 4)) + add
		vuv[2] = vuv[2] + math.cos(add * 0.5 + vX * 2) + add
	end)

	-- physics
	FLK3D.SetUnivGravity(Vector(0, -100, 0))
	local PLANE_SZ = 16
	local PLANE_BLOCKS = 4
	local szDelta = PLANE_SZ / PLANE_BLOCKS

	FLK3D.AddPhysicsBodyToUniv("phys_floor")
	FLK3D.SetPhysicsBodyPos("phys_floor", Vector(0, -4, 0))
	FLK3D.SetPhysicsBodyScl("phys_floor", Vector(PLANE_SZ, 1, PLANE_SZ))
	FLK3D.SetPhysicsBodyStatic("phys_floor", true)

	--[[
	FLK3D.AddObjectToUniv("phys_floor_vis", "cube")
	FLK3D.SetObjectPosAng("phys_floor_vis", Vector(0, -4, 0), Angle(0, 0, 0))
	FLK3D.SetObjectScl("phys_floor_vis", Vector(PLANE_SZ, 1, PLANE_SZ) * .5)
	FLK3D.SetObjectFlag("phys_floor_vis", "SHADING", true)
	FLK3D.SetObjectFlag("phys_floor_vis", "SHADING_SMOOTH", false)
	]]--
FLK3D.PopUniverse()


local lastmx, lastmy = 0, 0
local mouseClickFlag = false
local function mouseThink()
	if not LKHooks.IsMouseDown(1) then
		mouseClickFlag = false
		return
	end

	local mx, my = LKHooks.GetLastMousePos()

	if not mouseClickFlag then
		lastmx = mx
		lastmy = my

		mouseClickFlag = true
	end

	local dx = mx - lastmx
	local dy = my - lastmy

	lastmx = mx
	lastmy = my

	local mxReal = dx * 8
	local myReal = -dy * 8

	FLK3D.RotateCam(Angle(myReal, mxReal, 0))
end



LKHooks.Add("Think", "Movement", function(dt)
	mouseThink()

	local dtMul = dt
	if LKHooks.IsKeyDown(keys.leftShift) then
		dtMul = dt * 4
	end

	local fow = FLK3D.CamMatrix_Rot:Forward()
	fow:Mul(dtMul)

	local rig = FLK3D.CamMatrix_Rot:Right()
	rig:Mul(dtMul)

	local up = FLK3D.CamMatrix_Rot:Up()
	up:Mul(dtMul)


	if LKHooks.IsKeyDown(keys.w) then
		FLK3D.SetCamPos(FLK3D.CamPos + fow)
	end

	if LKHooks.IsKeyDown(keys.s) then
		FLK3D.SetCamPos(FLK3D.CamPos - fow)
	end

	if LKHooks.IsKeyDown(keys.a) then
		FLK3D.SetCamPos(FLK3D.CamPos - rig)
	end

	if LKHooks.IsKeyDown(keys.d) then
		FLK3D.SetCamPos(FLK3D.CamPos + rig)
	end

	if LKHooks.IsKeyDown(keys.space) then
		FLK3D.SetCamPos(FLK3D.CamPos + up)
	end

	if LKHooks.IsKeyDown(keys.leftCtrl) then
		FLK3D.SetCamPos(FLK3D.CamPos - up)
	end

	if LKHooks.IsKeyDown(keys.left) then
		FLK3D.RotateCam(Angle(0, -128 * dt, 0))
	end

	if LKHooks.IsKeyDown(keys.right) then
		FLK3D.RotateCam(Angle(0, 128 * dt, 0))
	end

	if LKHooks.IsKeyDown(keys.up) then
		FLK3D.RotateCam(Angle(128 * dt, 0, 0))
	end

	if LKHooks.IsKeyDown(keys.down) then
		FLK3D.RotateCam(Angle(-128 * dt, 0, 0))
	end

	if LKHooks.IsKeyDown(keys.q) then
		FLK3D.RotateCam(Angle(0, 0, -128 * dt))
	end

	if LKHooks.IsKeyDown(keys.e) then
		FLK3D.RotateCam(Angle(0, 0, 128 * dt))
	end
end)


LKHooks.Add("Think", "UpdateScene", function(dt)
	local cTime = LKHooks.CurTime()

	FLK3D.PushUniverse(univ)
	FLK3D.PopUniverse()
end)


LKHooks.Add("Render", "TestRender", function()
	FLK3D.PushUniverse(univ)
	FLK3D.PushRenderTarget(rt)
		--FLK3D.ClearHalfed(COLOR_BACKGROUND, true)
		FLK3D.ClearDepth()
		FLK3D.RenderActiveUniverse()
		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end)


LKHooks.BeginProgram()