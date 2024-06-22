FlowJam = FlowJam or {}
FLK3D = FLK3D or {}

local function setupPlanarShadow(obj)
	local shadowTag = obj.tag .. "_shadow"
	local shadowMdl = obj["PLANAR_SHADOW_MODEL"] or obj.mdl

	FLK3D.AddObjectToUniv(shadowTag, shadowMdl)
	FLK3D.SetObjectPos(shadowTag, obj.pos)
	FLK3D.SetObjectAng(shadowTag, obj.ang)
	FLK3D.SetObjectScl(shadowTag, obj.scl)

	FLK3D.SetObjectFlag(shadowTag, "COL_HIGHLIGHT", COLOR_BLACK)
	FLK3D.SetObjectFlag(shadowTag, "NO_BACKFACE_CULL", true)

	local shadowMatrix = FlowJam.GetShadowMatrix(0.025, Vector(0, 1, 0), FLK3D.SunDir)
	FLK3D.SetObjectFlag(shadowTag, "SHADOW_MATRIX", shadowMatrix)

end

local function getShadowTag(obj)
	return obj.tag .. "_shadow"
end


function FlowJam.UpdateSceneShadows()
	local currUniv = FLK3D.GetCurrUniverse()
	local objs = currUniv["objects"]

	for k, v in pairs(objs) do
		if not v["PLANAR_SHADOW"] then
			goto _cont
		end

		local shadowTag = getShadowTag(v)
		if not objs[shadowTag] then
			setupPlanarShadow(v)
		end

		FLK3D.SetObjectPos(shadowTag, v.pos)
		FLK3D.SetObjectAng(shadowTag, v.ang)
		FLK3D.SetObjectScl(shadowTag, v.scl)

		::_cont::
	end
end

local matrixSunRot = Matrix()

function FlowJam.UpdateSceneSun()
	local currUniv = FLK3D.GetCurrUniverse()
	local objs = currUniv["objects"]


	if not objs["the_sun_object"] then
		FLK3D.AddObjectToUniv("the_sun_object", "sun")
		FLK3D.SetObjectScl("the_sun_object", Vector(16, 16, 16))
		FLK3D.SetObjectFlag("the_sun_object", "COL_HIGHLIGHT", PALETTE_13)
	end

	--matrixSunRot:SetDirection(FLK3D.SunDir)

	local time = LKHooks.CurTime()

	FLK3D.SetObjectAng("the_sun_object", -FLK3D.SunDir:ToAngle() + Angle(90, time * 2, 0))
	FLK3D.SetObjectPos("the_sun_object", FLK3D.SunDir * 128)
end