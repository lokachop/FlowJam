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
		--FLK3D.SetObjectAng("loka1", Angle(cTime * 64, cTime * 32, 0))
		--FLK3D.SetSunDir(FLK3D.GetCamDir())
	FLK3D.PopUniverse()

end)


local shootFlag = false
local shootID = 1
local function fireClick()
	if LKHooks.IsMouseDown(1) then
		if shootFlag then
			return
		end
		shootID = shootID + 1


		local tag = "BoxShoot" .. shootID
		FLK3D.AddPhysicsBodyToUniv(tag)
		FLK3D.SetPhysicsBodyScl(tag, Vector(1, 1, 1))
		FLK3D.SetPhysicsBodyPos(tag, -FLK3D.GetCamPos())
		FLK3D.SetPhysicsBodyVel(tag, -FLK3D.GetCamDir() * 25)
		FLK3D.SetPhysicsBodyStatic(tag, false)



		shootFlag = true
	elseif shootFlag then
		shootFlag = false
	end

end


LKHooks.Add("Think", "Physics", function(dt)
	FLK3D.PushUniverse(univ)
		FLK3D.PhysicsThink(dt)
		--fireClick()
		FLK3D.DebugRenderPhysicsObjects()
	FLK3D.PopUniverse()
end)



local shiftTable = {
	[ 1] = 1,
	[ 2] = 2,
	[ 3] = 4,
	[ 4] = 8,
	[ 5] = 16,
	[ 6] = 32,
	[ 7] = 64,
	[ 8] = 128,
	[ 9] = 256,
	[10] = 512,
	[11] = 1024,
	[12] = 2048,
	[13] = 4096,
	[14] = 8192,
	[15] = 16384,
	[16] = 32768,
}

local invShiftTable = {
	[    1] = 1,
	[    2] = 2,
	[    4] = 3,
	[    8] = 4,
	[   16] = 5,
	[   32] = 6,
	[   64] = 7,
	[  128] = 8,
	[  256] = 9,
	[  512] = 10,
	[ 1024] = 11,
	[ 2048] = 12,
	[ 4096] = 13,
	[ 8192] = 14,
	[16384] = 15,
	[32768] = 16,
}

local function math_round(x)
	return math.ceil(x + .5)
end


local gb_1_16 = 1 / 16
local gb_1_8  = 1 / 8
local gb_1_4  = 1 / 4
LKHooks.Add("Render", "TestRender", function()
	FLK3D.PushUniverse(univ)
	FLK3D.PushRenderTarget(rt)
		FLK3D.ClearHalfed(COLOR_BACKGROUND, true)
		--FLK3D.ClearDepth()
		FLK3D.RenderActiveUniverse()
		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()



	--[[
	local cPos = FLK3D.GetCamPos()
	term.setCursorPos(1, 1)
	term.write("Pos: v(" .. cPos[1] .. ", " .. cPos[2] .. ", " .. cPos[3] .. ")")

	local cDir = FLK3D.GetCamDir()
	term.setCursorPos(1, 2)
	term.write("Dir: v(" .. cDir[1] .. ", " .. cDir[2] .. ", " .. cDir[3] .. ")")

	local frameNum = LKHooks.GetFrameNumber()
	term.setCursorPos(1, 3)
	term.write("Frame: " .. frameNum)
	]]--
end)


LKHooks.BeginProgram()

--[[
		FLK3D.ApplyOpHalfed(function(getRT, index, xc, yc, w, h)
			local tl = getRT[index - w - 1] or colors.black
			local tc = getRT[index - w] or colors.black
			local tr = getRT[index - w + 1] or colors.black

			local cl = getRT[index - 1] or colors.black
			local cc = getRT[index] or colors.black
			local cr = getRT[index + 1] or colors.black

			local bl = getRT[index + w - 1] or colors.black
			local bc = getRT[index + w] or colors.black
			local br = getRT[index + w + 1] or colors.black

			tl = invShiftTable[tl] * gb_1_16
			tc = invShiftTable[tc] * gb_1_8
			tr = invShiftTable[tr] * gb_1_16

			cl = invShiftTable[cl] * gb_1_8
			cc = invShiftTable[cc] * gb_1_4
			cr = invShiftTable[cr] * gb_1_8

			bl = invShiftTable[bl] * gb_1_16
			bc = invShiftTable[bc] * gb_1_8
			br = invShiftTable[br] * gb_1_16

			--print(cc)

			average = (tl + tc + tr + cl + cc + cr + bl + bc + br)
			average = math.min(math.max(math_round(average), 0), 16)

			finalOut = shiftTable[average]
			return finalOut
		end)
]]--