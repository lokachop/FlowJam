FlowJam = FlowJam or {}

function FlowJam.SetupBoat()
	FLK3D.AddObjectToUniv("boat", "boat")
	FLK3D.SetObjectPos("boat", Vector(0, 0.5, 0))
	FLK3D.SetObjectAng("boat", Angle(0, 0, 0))
	FLK3D.SetObjectScl("boat", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("boat", "COL_OUTLINE", COLOR_BLACK)
	FLK3D.SetObjectFlag("boat", "DO_OUTLINE", true)
	FLK3D.SetObjectFlag("boat", "OUTLINE_SCALE", 0.2)
	FLK3D.SetObjectFlag("boat", "SHADING", true)
	FLK3D.SetObjectFlag("boat", "SHADING_SMOOTH", false)
	FLK3D.SetObjectFlag("boat", "SHADE_THRESHOLD", 0.6)
	FLK3D.SetObjectFlag("boat", "COL_HIGHLIGHT", PALETTE_3)
	FLK3D.SetObjectFlag("boat", "COL_SHADE", PALETTE_4)
	--FLK3D.SetObjectFlag("boat", "SHADE_DITHER", true)

	FLK3D.SetObjectFlag("boat", "PLANAR_SHADOW", true)
	FLK3D.SetObjectFlag("boat", "PLANAR_SHADOW_MODEL", "boat_singlemesh")

	FLK3D.AddObjectToUniv("boat_window", "boat_window")
	FLK3D.SetObjectPos("boat_window", Vector(0, 0.5, 0))
	FLK3D.SetObjectAng("boat_window", Angle(0, 0, 0))
	FLK3D.SetObjectScl("boat_window", Vector(2, 2, 2))
	FLK3D.SetObjectFlag("boat_window", "COL_OUTLINE", PALETTE_5)
	FLK3D.SetObjectFlag("boat_window", "DO_OUTLINE", true)
	FLK3D.SetObjectFlag("boat_window", "OUTLINE_SCALE", 0.3)
	FLK3D.SetObjectMat("boat_window", "glass_tex")



	FLK3D.AddObjectToUniv("boat_arrow", "arrow")
	FLK3D.SetObjectPos("boat_arrow", Vector(0, 3, 0))
	FLK3D.SetObjectAng("boat_arrow", Angle(0, 0, 0))
	FLK3D.SetObjectScl("boat_arrow", Vector(.25, .25, .25))
	FLK3D.SetObjectFlag("boat_arrow", "COL_HIGHLIGHT", PALETTE_6)
	FLK3D.SetObjectFlag("boat_arrow", "COL_SHADE", PALETTE_7)
	FLK3D.SetObjectFlag("boat_arrow", "SHADING", true)
	--FLK3D.SetObjectFlag("boat_arrow", "SHADE_DITHER", true)

	FLK3D.SetObjectFlag("boat_arrow", "PLANAR_SHADOW", true)

	FLK3D.AddObjectToUniv("boat_arrow_outline", "arrow_outline")
	FLK3D.SetObjectPos("boat_arrow_outline", Vector(0, 3, 0))
	FLK3D.SetObjectAng("boat_arrow_outline", Angle(0, 0, 0))
	FLK3D.SetObjectScl("boat_arrow_outline", Vector(.25, .25, .25))
	FLK3D.SetObjectFlag("boat_arrow_outline", "COL_HIGHLIGHT", COLOR_BLACK)

end

local boatPos = Vector(0, 0.5, 0)
local boatVel = Vector(0, 0, 0)
local boatRot = 0
local boatAngVel = 0

function FlowJam.GetBoatRot()
	return boatRot
end

local function sign(x)
	return x < 0 and -1 or 1
end

local function moveTowards(a, b, delta)
	if math.abs(a - b) <= delta then
		return b
	end

	return a + (sign(b - a) * delta)
end

local function getBoatForwardDir()
	local angRads = math.rad(boatRot)

	return Vector(math.cos(angRads), 0, math.sin(angRads))
end

local function getBoatRightDir()
	local angRads = math.rad(boatRot)

	return Vector(math.cos(angRads), 0, math.sin(angRads))
end


local function length2D(x, y)
	return math.sqrt(x * x + y * y)
end

local function moveTowards2D(ax, ay, bx, by, delta)
	local dx = bx - ax
	local dy = by - ay

	local len = length2D(dx, dy)

	if (len <= delta) or len == 0 then
		return bx, by
	end

	return ax + (dx / len) * delta, ay + (dy / len) * delta
end


local _slowMul = 1.25
local _velMul = .01
local _velCap = 2

local _rotSlowMul = 4
local _rotVelMul = 128
local function moveBoat(dt)
	local fw = getBoatForwardDir() * _velMul
	local ri = getBoatRightDir() * _velMul

	local velLen = boatVel:Length()

	-- slow first
	boatAngVel = moveTowards(boatAngVel, 0, dt * _rotSlowMul * math.abs(boatAngVel))


	local slowedX, slowedY = moveTowards2D(boatVel[1], boatVel[3], 0, 0, dt * _slowMul * velLen)
	boatVel[1] = slowedX
	boatVel[3] = slowedY

	--boatVel[1] = math.min(math.max(slowedX, -_velCap), _velCap)
	--boatVel[3] = math.min(math.max(slowedY, -_velCap), _velCap)

	if LKHooks.IsKeyDown(keys.w) then
		boatVel = boatVel + fw
	end

	if LKHooks.IsKeyDown(keys.s) then
		boatVel = boatVel - fw
	end

	if LKHooks.IsKeyDown(keys.a) then
		boatAngVel = boatAngVel + _rotVelMul * dt
	end

	if LKHooks.IsKeyDown(keys.d) then
		boatAngVel = boatAngVel - _rotVelMul * dt
	end

	boatRot = boatRot + boatAngVel * dt
	boatRot = boatRot % 360

	boatPos = boatPos + boatVel * dt
end



local function updateBoat(dt)
	if boatPos[1] > 64 then
		boatPos[1] = 64
	end
	if boatPos[1] < -64 then
		boatPos[1] = -64
	end


	if boatPos[3] > 64 then
		boatPos[3] = 64
	end
	if boatPos[3] < -64 then
		boatPos[3] = -64
	end




	local wiggleInten = (boatVel:Length() * 0.25) + .25
	wiggleInten = math.min(wiggleInten, 2)

	local cTime = FlowJam.CurTime()
	local angBoat = Vector(math.sin(cTime * 2) * 4, math.cos(cTime * 0.5) * 6, math.cos(cTime * 1.433) * 4) * wiggleInten
	angBoat[2] = angBoat[2] + boatRot

	FLK3D.SetObjectAng("boat", angBoat)
	FLK3D.SetObjectAng("boat_window", angBoat)

	local boatPosFix = boatPos:Copy()
	boatPosFix = -boatPosFix
	boatPosFix[2] = 0.5

	FLK3D.SetObjectPos("boat", boatPosFix)
	FLK3D.SetObjectPos("boat_window", boatPosFix)

	local camOriginPos = boatPos:Copy()
	camOriginPos[2] = -1

	FlowJam.SetOrbCamOrigin(camOriginPos)
end


function FlowJam.GetBoatPos()
	return boatPos
end

function FlowJam.GetVisBoatPos()
	return -boatPos
end

function FlowJam.GetBoatVel()
	return boatVel
end


local function updateArrow(dt)
	local arrowPosFix = boatPos:Copy()
	arrowPosFix = -arrowPosFix
	arrowPosFix[2] = 2.5

	FLK3D.SetObjectPos("boat_arrow", arrowPosFix)
	FLK3D.SetObjectPos("boat_arrow_outline", arrowPosFix)

	local circlePos = FlowJam.GetFishingCirclePos():Copy()
	circlePos[1] = -circlePos[1]

	local boatPosCalc = -boatPos:Copy()
	boatPosCalc[3] = -boatPosCalc[3]

	local diff = boatPosCalc - circlePos
	diff:Normalize()


	local arrowAng = diff:ToAngle()
	local realArrowAng = Angle(0, arrowAng[2], arrowAng[3])

	FLK3D.SetObjectAng("boat_arrow", realArrowAng)
	FLK3D.SetObjectAng("boat_arrow_outline", realArrowAng)
end

function FlowJam.BoatThink(dt)
	moveBoat(dt)
	updateBoat(dt)
	updateArrow(dt)
end