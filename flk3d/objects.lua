FLK3D = FLK3D or {}

function FLK3D.AddObjectToUniv(name, mdl)
	local univ = FLK3D.GetCurrUniverse()

	local mat_scl = Matrix()
	local mat_rot = Matrix()
	local mat_pos = Matrix()
	mat_scl:SetScale(Vector(1, 1, 1))

	univ["objects"][name] = {
		tag = name,
		mdl = mdl,
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0),
		scl = Vector(1, 1, 1),
		col = {1, 1, 1},
		mat = "none",
		mat_scl = mat_scl,
		mat_rot = mat_rot,
		mat_pos = mat_pos,
	}
end

function FLK3D.SetObjectPos(name, pos)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].pos = pos or Vector(0, 0, 0)

	univ["objects"][name].mat_pos:SetTranslation(pos)
end

function FLK3D.SetObjectAng(name, ang)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].ang = ang or Angle(0, 0, 0)

	univ["objects"][name].mat_rot:SetAngles(ang)
end

function FLK3D.SetObjectPosAng(name, pos, ang)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].pos = pos or Vector(0, 0, 0)
	univ["objects"][name].ang = ang or Angle(0, 0, 0)

	univ["objects"][name].mat_pos:SetTranslation(pos)
	univ["objects"][name].mat_rot:SetAngles(ang)
end

function FLK3D.SetObjectScl(name, scl)
	local univ = FLK3D.GetCurrUniverse()
	
	univ["objects"][name].scl = scl or Vector(0, 0, 0)
	univ["objects"][name].mat_scl:SetScale(scl)
end

function FLK3D.SetObjectCol(name, col)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].col = col and {col[1], col[2], col[3]} or {1, 1, 1}
end

function FLK3D.SetObjectMat(name, mat)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].mat = mat or "none"
end

function FLK3D.SetObjectMatrixRot(name, mat_rot)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].mat_rot:CopyRotation(mat_rot or Matrix())
end

function FLK3D.SetObjectFlag(name, flag, value)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name][flag] = value
end

function FLK3D.SetObjectModel(name, mdl)
	local univ = FLK3D.GetCurrUniverse()

	univ["objects"][name].mdl = mdl or "cube"
end