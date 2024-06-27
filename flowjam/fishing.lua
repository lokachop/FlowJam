FlowJam = FlowJam or {}

function FlowJam.SetupFishingCircle()
	FLK3D.AddObjectToUniv("fishing_circle", "circle")
	FLK3D.SetObjectPos("fishing_circle", Vector(0, 0, 0))
	FLK3D.SetObjectAng("fishing_circle", Angle(0, 0, 0))
	FLK3D.SetObjectScl("fishing_circle", Vector(8, 8, 8))

	--FLK3D.SetObjectFlag("fishing_circle", "DO_OUTLINE", true)
	--FLK3D.SetObjectFlag("fishing_circle", "COL_OUTLINE", COLOR_BLACK)
	--FLK3D.SetObjectFlag("fishing_circle", "OUTLINE_SCALE", 0.2)

	FLK3D.SetObjectFlag("fishing_circle", "COL_HIGHLIGHT", PALETTE_6)
	FLK3D.SetObjectFlag("fishing_circle", "COL_SHADE", PALETTE_7)
	FLK3D.SetObjectFlag("fishing_circle", "SHADING", true)
	--FLK3D.SetObjectFlag("fishing_circle", "SHADE_DITHER", true)

	FLK3D.SetObjectFlag("fishing_circle", "PLANAR_SHADOW", true)

end

function FlowJam.SpawnFishingCircle()
	local posX = (math.random() - .5) * 8
	local posY = (math.random() - .5) * 8
end

function FlowJam.GetFishingCirclePos()
	return Vector(0, 0, 0)
end


function FlowJam.FishingCircleThink(dt)

end


function FlowJam.BeginFishing()
	

end