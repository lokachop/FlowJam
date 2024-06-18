FLK3D = FLK3D or {}

local rootClear = FLK3D.GetRootDirectory()
rootClear = string.sub(rootClear, 1, #rootClear - 1)
rootClear = rootClear .. "/"
local function readFile(filePath)
	local realPath = shell.resolve(rootClear .. filePath)

	local fPtr = fs.open(realPath, "r")
	if not fPtr then
		error("Could not read file \"" .. realPath .. "\"")
		return
	end

	local cont = fPtr.readAll()
	fPtr.close()

	return cont
end

local function loadModelFromOBJ(name, path)
	local objData = readFile(path)
	if not objData then
		return
	end

	FLK3D.DeclareModelOBJ(name, objData)
end

loadModelFromOBJ("cube", "models/cubenuv.obj")
loadModelFromOBJ("lokachop_sqr", "models/lokachopsqr.obj")
loadModelFromOBJ("ocean_plane", "models/ocean_plane.obj")