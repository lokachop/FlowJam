FlowJam = FlowJam or {}

local CIRCLE_RAD = 8
function FlowJam.SetupFishingCircle()
	FLK3D.AddObjectToUniv("fishing_circle", "circle")
	FLK3D.SetObjectPos("fishing_circle", Vector(0, 0, 0))
	FLK3D.SetObjectAng("fishing_circle", Angle(0, 0, 0))
	FLK3D.SetObjectScl("fishing_circle", Vector(CIRCLE_RAD, CIRCLE_RAD, CIRCLE_RAD))

	--FLK3D.SetObjectFlag("fishing_circle", "DO_OUTLINE", true)
	--FLK3D.SetObjectFlag("fishing_circle", "COL_OUTLINE", COLOR_BLACK)
	--FLK3D.SetObjectFlag("fishing_circle", "OUTLINE_SCALE", 0.2)

	FLK3D.SetObjectFlag("fishing_circle", "COL_HIGHLIGHT", PALETTE_6)
	FLK3D.SetObjectFlag("fishing_circle", "COL_SHADE", PALETTE_7)
	FLK3D.SetObjectFlag("fishing_circle", "SHADING", true)
	--FLK3D.SetObjectFlag("fishing_circle", "SHADE_DITHER", true)

	FLK3D.SetObjectFlag("fishing_circle", "PLANAR_SHADOW", true)

end



local circlePos = Vector(0, 0)
function FlowJam.GetFishingCirclePos()
	return circlePos
end

function FlowJam.UpdateSceneFishingCircle()
	FLK3D.SetObjectPos("fishing_circle", -circlePos)
end

function FlowJam.IsPlayerInFishingCircle()
	local plyPos = FlowJam.GetBoatPos()

	return FlowJam.PointInCircle(plyPos, circlePos, CIRCLE_RAD)
end


local placeAtts = 0
function FlowJam.SpawnFishingCircle()
	placeAtts = placeAtts + 1

	if placeAtts > 8 then
		print("Can't seem to find a good place for the fishing circle!")
		print("Placing in player...")
	end


	local posX = (math.random() - .5) * 1--128
	local posY = (math.random() - .5) * 1--128

	circlePos = Vector(posX, 0, posY)

	-- make sure player isnt in circle
	local inCircle = FlowJam.IsPlayerInFishingCircle()
	if inCircle and placeAtts <= 8 then
		FlowJam.SpawnFishingCircle()
	end
	placeAtts = 0 -- we all good
end






function FlowJam.FishingCircleThink(dt)
	if not FlowJam.IsPlayerInFishingCircle() then
		return
	end

	local vel = FlowJam.GetBoatVel()
	if vel:Length() > .15 then
		return
	end

	FlowJam.BeginFishing()
end


function FlowJam.GetFishingActionCenter()
	return FlowJam.ScrW() * .5, FlowJam.ScrH() * .5
end

function FlowJam.GetFishingActionRenderCenter()
	local cX, cY = FlowJam.GetFishingActionCenter()

	return cX + .1, cY + .1
end


local function pixelMousePos()
	local mX, mY = LKHooks.GetLastMousePos()
	return mX * 2, mY * 3

end

-- only allows to move valid
local rmX, rmY = 0, 0
function FlowJam.GetFishingActionMousePos()
	return rmX, rmY
end

function FlowJam.GetFishingActionRot()
	local mX, mY = FlowJam.GetFishingActionMousePos()
	local cX, cY = FlowJam.GetFishingActionCenter()

	local atan2val = math.atan2(
		cY - mY,
		mX - cX
	)


	return math.deg(atan2val or 0) + 90
end

local circSize = 24
local turnCount = 0
local prevRot = 0
function FlowJam.UpdateFishingActionMouse()
	local prX, prY = rmX, rmY

	rmX, rmY = pixelMousePos()

	local cX, cY = FlowJam.GetFishingActionCenter()
	if Vector(rmX, rmY):Distance(Vector(cX, cY)) > circSize then
		rmX = prX
		rmY = prY -- fail
		return
	end



	local rot = FlowJam.GetFishingActionRot()

	local rotMoved = rot + 90

	local diff = rotMoved - prevRot

	if diff < -270 and rotMoved < 40 then -- jump
		prevRot = rotMoved -- pass
		turnCount = turnCount + 1
		return
	end

	if diff < 0 then
		rmX = prX
		rmY = prY -- fail
		return
	end

	prevRot = rotMoved -- pass
end


function FlowJam.GetTurnCount()
	return turnCount
end

function FlowJam.FishingActionThink(dt)
	FlowJam.UpdateFishingActionMouse()
end



local fishTarget = nil
function FlowJam.GetFishTarget()
	return fishTarget
end

function FlowJam.GetFishTargetTurnCount()
	return 2--math.floor(fishTarget.resistance / 10)
end

function FlowJam.GetFishTargetCircleSize()
	return math.max(math.floor((20 - (fishTarget.resistance / 20)) * 2), 16)
end

function FlowJam.GetFishTargetAwareness()
	return (140 - fishTarget.awareness) / 140
end


function FlowJam.BeginFishing()
	rmX, rmY = FlowJam.GetFishingActionCenter()

	prevRot = 0
	turnCount = 0

	fishTarget = FlowJam.GetRandomFish()
	circSize = FlowJam.GetFishTargetCircleSize()


	FlowJam.SetState(STATE_FISHING)
end