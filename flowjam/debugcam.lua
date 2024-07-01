FlowJam = FlowJam or {}
FLK3D = FLK3D or {}

local function debugCamDo(dt)
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
end


local dCamEnabled = false
local keyFlag = false
function FlowJam.DebugCamThink(dt)
	return false

	--[[
	local keyDown = LKHooks.IsKeyDown(keys.p)

	if keyDown and not keyFlag then
		keyFlag = true

		dCamEnabled = not dCamEnabled
	elseif not keyDown and keyFlag then
		keyFlag = false
	end


	if dCamEnabled then
		debugCamDo(dt)
		return true
	end
	]]--
end