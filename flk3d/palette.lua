FLK3D = FLK3D or {}

local lastIndex = 0
function FLK3D.DeclareNewPaletteColour(r, g, b)
	lastIndex = lastIndex + 1
	local ccIndex = bit32.lshift(1, lastIndex - 1)

	if ccIndex > 32768 then
		error("Attempt to create palette colour past max colour limit, REDUCE COLOURS /!\\")
	end


	term.setPaletteColor(ccIndex, r / 255, g / 255, b / 255)
	return ccIndex
end

function FLK3D.ReplacePaletteColour(index, r, g, b)
	term.setPaletteColor(index, r / 255, g / 255, b / 255)
end

local stockColours = {
	[    1] = {240, 240, 240},
	[    2] = {242, 178,  51},
	[    4] = {229, 127, 216},
	[    8] = {153, 178, 242},
	[   16] = {222, 222, 108},
	[   32] = {127, 204,  25},
	[   64] = {242, 178, 204},
	[  128] = { 76,  76,  76},
	[  256] = {153, 153, 153},
	[  512] = { 76, 153, 178},
	[ 1024] = {178, 102, 229},
	[ 2048] = { 51, 102, 204},
	[ 4096] = {127, 102,  76},
	[ 8192] = { 87, 166,  78},
	[16384] = {204,  76,  76},
	[32768] = { 17,  17,  17},
}

function FLK3D.ResetPalette()
	for k, v in pairs(stockColours) do
		term.setPaletteColor(k, v[1] / 255, v[2] / 255, v[3] / 255)
	end
end