--[[
	lktex.lua
	
	lokachop's texture library
	licensed under the MIT license (refer to LICENSE)
]]--

LKTEX = LKTEX or {}
LKTEX.Textures = LKTEX.Textures or {}

-- for cc
local _COMPUTERCRAFT = true

local function readByte(fileObject)
	if _COMPUTERCRAFT then
		return fileObject.read()
	else
		return string.byte(fileObject:read(1))
	end
end

local string_byte = string.byte
local bit_band = bit32.band
local function readTripleBytes(fileObject)
	if _COMPUTERCRAFT then
		return fileObject.read(), fileObject.read(), fileObject.read()
	else
		local rv = fileObject:read(3)
		local v1 = bit_band(string_byte(rv, 1), 0xFF)
		local v2 = bit_band(string_byte(rv, 2), 0xFF)
		local v3 = bit_band(string_byte(rv, 3), 0xFF)

		return v1, v2, v3
	end
end

local function closeFile(fileObject)
	if _COMPUTERCRAFT then
		fileObject.close()
	else
		fileObject:close()
	end
end


local rootClear = FLK3D.GetRootDirectory()
rootClear = string.sub(rootClear, 1, #rootClear - 1)
rootClear = rootClear .. "/"
local function getRealPath(filePath)
	local realPath = shell.resolve(rootClear .. filePath)
	return realPath
end

local function readAndGetFileObject(path)
	if _COMPUTERCRAFT then
		local f = fs.open(FLK3D.DataPath .. "/" .. path, "rb")
		return f
	else
		local f = love.filesystem.newFile(path)
		f:open("r")
		return f
	end
end

local function readString(fileObject)
	-- read the 0A (10)
	local readCont = readByte(fileObject)
	if readCont ~= 10 then
		return "nostring :("
	end

	local buff = {}
	for i = 1, 4096 do -- read long strings
		readCont = readByte(fileObject)
		if readCont == 10 then
			break
		end

		buff[#buff + 1] = string.char(readCont)
	end

	return table.concat(buff, "")
end

local function readUntil(fileObject, stopNum, prev)
	local readCont
	local buff = {}
	if prev ~= nil then
		buff[#buff + 1] = prev
	end

	for i = 1, 2048 do -- read big nums
		readCont = readByte(fileObject)
		if readCont == stopNum then
			break
		end

		buff[#buff + 1] = string.char(readCont)
	end
	return table.concat(buff, "")
end

local hashConcat = {}
hashConcat[1] = "r_"
hashConcat[3] = "g_"
hashConcat[5] = "b_"

function LKTEX.ColourHash(r, g, b)
	hashConcat[2] = r
	hashConcat[4] = g
	hashConcat[6] = b
	return table.concat(hashConcat, "")
end





-- ppm files are header + raw data which is EZ
function LKTEX.LoadPPM(name, path, colourConverts)
	local data = {}

	print("---LKTEX-PPMLoad---")
	print("Loading texture at \"" .. path .. "\"")


	local fObj = readAndGetFileObject(path)
	local readCont = readByte(fObj)
	if readCont ~= 80 then
		closeFile(fObj)
		error("PPM Decode error! (header no match!) [" .. readCont .. "]")
		return
	end

	readCont = readByte(fObj)
	if readCont ~= 54 then
		closeFile(fObj)
		error("PPM Decode error! (header no match!) [" .. readCont .. "]")
		return
	end
	readCont = readByte(fObj)
	-- string, read until next 10

	local isComment = nil
	if readCont == 10 then
		isComment = readByte(fObj)
		if isComment == 35 then -- 35 == #
			local fComm = readUntil(fObj, 10)
			print("Comment; \"" .. fComm .. "\"")
			isComment = nil
		end
	end
	--print(isComment)
	-- read the width and height
	local w = tonumber(readUntil(fObj, 32, isComment))
	local h = tonumber(readUntil(fObj, 10))

	local cDepth = tonumber(readUntil(fObj, 10))
	--print("Texture is " .. w .. "x" .. h .. " with a coldepth of " .. cDepth)
	--error("help")

	local pixToRead = w * h
	for i = 0, (pixToRead - 1) do
		--local r = readByte(fObj)
		--local g = readByte(fObj)
		--local b = readByte(fObj)

		local r, g, b = readTripleBytes(fObj)
		local hash = LKTEX.ColourHash(r, g, b)

		data[i] = colourConverts[hash] or 1
	end

	data.data = {w, h}

	closeFile(fObj)
	LKTEX.Textures[name] = data
end

function LKTEX.GetTexture(name)
	local tex = LKTEX.Textures[name]
	if not tex then
		return LKTEX.Textures["none"]
	end

	return tex
end

function LKTEX.GenerateEmpty(name, w, h, col)
	local data = {}
	data.data = {w, h}

	for i = 0, ((w * h) - 1) do
		data[i] = col or 1
	end
	LKTEX.Textures[name] = data
end

function LKTEX.GenerateFunc(name, w, h, func)
	local data = {}
	data.data = {w, h}

	for i = 0, ((w * h) - 1) do
		local xc = i % w
		local yc = math.floor(i / w)
		local fine, dataFunc = pcall(func, xc, yc)
		if not fine then
			print("TextureInit error!;" .. dataFunc)
			dataFunc = 1
		end

		data[i] = dataFunc
	end
	LKTEX.Textures[name] = data
end

function LKTEX.Generate(name, w, h, func)
	if func then
		LKTEX.GenerateFunc(name, w, h, func)
	else
		LKTEX.GenerateEmpty(name, w, h, 1)
	end
end


function LKTEX.ClearTexture(name, data)
	for i = 0, ((w * h) - 1) do
		LKTEX.Textures[name][i] = data
	end
end

LKTEX.GenerateEmpty("any", 16, 16, 1)