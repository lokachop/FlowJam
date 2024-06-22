FlowJam = FlowJam or {}
FLK3D = FLK3D or {}

local o_Origin = Vector(0, 0, 0)
local o_Azimuth = 2.5
local o_Polar = -.25
local o_Dist = 5

function FlowJam.SetOrbCamOrigin(pos)
	o_Origin = pos
end

local _2PI = math.pi * 2
local _PIHALF = math.pi * .5

local min_floor = 0.1
local max_floor = -_PIHALF + .05

local zoomMul = 1
local minZoom = 3
local maxZoom = 8

local rotMul = 2
function FlowJam.OrbCamThink(dt)
	if LKHooks.IsKeyDown(keys.right) then
		--print("left")
		o_Azimuth = (o_Azimuth + rotMul * dt) % _2PI
	elseif LKHooks.IsKeyDown(keys.left) then
		--print("right")
		o_Azimuth = (o_Azimuth - rotMul * dt) % _2PI
	end

	if LKHooks.IsKeyDown(keys.down) then
		--print("up")
		o_Polar = (o_Polar + rotMul * dt)
	elseif LKHooks.IsKeyDown(keys.up) then
		--print("down")
		o_Polar = (o_Polar - rotMul * dt)
	end

	if LKHooks.IsKeyDown(keys.i) then
		--print("zoom in")
		o_Dist = math.min(math.max(o_Dist - zoomMul * dt, minZoom), maxZoom)
	elseif LKHooks.IsKeyDown(keys.k) then
		--print("zoom out")
		o_Dist = math.min(math.max(o_Dist + zoomMul * dt, minZoom), maxZoom)
	end


	if o_Polar >= min_floor then
		o_Polar = min_floor
	end
	if o_Polar <= max_floor then
		o_Polar = max_floor
	end


	local nonTranslatedPos = Vector(
		o_Dist * (math.cos(o_Polar) * math.cos(o_Azimuth)),
		o_Dist *  math.sin(o_Polar),
		o_Dist * (math.cos(o_Polar) * math.sin(o_Azimuth))
	)

	local angRot = Angle(0, FlowJam.GetBoatRot(), 0)
	nonTranslatedPos:Rotate(angRot)

	local newCamPos = o_Origin + nonTranslatedPos

	--[[
	local newCamPos = Vector(
		o_Origin[1] + (o_Dist * (math.cos(o_Polar) * math.cos(o_Azimuth))),
		o_Origin[2] + (o_Dist *  math.sin(o_Polar)),
		o_Origin[3] + (o_Dist * (math.cos(o_Polar) * math.sin(o_Azimuth)))
	)
	]]--
	local newCamDir = o_Origin - newCamPos
	newCamDir:Normalize()



	local camAng = newCamDir:ToAngle()
	--camAng = camAng - angRot

	--print(newCamPos)

	FLK3D.SetCamAng(Angle(camAng[1], camAng[2], camAng[3]))
	FLK3D.SetCamPos(newCamPos)
end