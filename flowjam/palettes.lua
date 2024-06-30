FlowJam = FlowJam or {}
FLK3D.ResetPalette()

COLOR_WHITE = FLK3D.DeclareNewPaletteColour(255, 255, 255)
COLOR_BLACK = FLK3D.DeclareNewPaletteColour(24, 24, 24)

PALETTE_1  = FLK3D.DeclareNewPaletteColour(64, 96, 200)
PALETTE_2  = FLK3D.DeclareNewPaletteColour(128, 160, 240)
PALETTE_3  = FLK3D.DeclareNewPaletteColour(255, 0, 0)
PALETTE_4  = FLK3D.DeclareNewPaletteColour(0, 255, 0)
PALETTE_5  = FLK3D.DeclareNewPaletteColour(255, 255, 0)
PALETTE_6  = FLK3D.DeclareNewPaletteColour(0, 0, 255)
PALETTE_7  = FLK3D.DeclareNewPaletteColour(255, 0, 255)
PALETTE_8  = FLK3D.DeclareNewPaletteColour(0, 255, 255)
PALETTE_9  = FLK3D.DeclareNewPaletteColour(255, 255, 255)
PALETTE_10 = FLK3D.DeclareNewPaletteColour(64, 0, 0)
PALETTE_11 = FLK3D.DeclareNewPaletteColour(0, 64, 0)
PALETTE_12 = FLK3D.DeclareNewPaletteColour(64, 64, 0)
PALETTE_13 = FLK3D.DeclareNewPaletteColour(0, 0, 64)
PALETTE_14 = FLK3D.DeclareNewPaletteColour(64, 0, 64)

function FlowJam.ResetPalette()
    FLK3D.ReplacePaletteColour(COLOR_WHITE, 255, 255, 255)
    FLK3D.ReplacePaletteColour(COLOR_BLACK, 24, 24, 24)

    FLK3D.ReplacePaletteColour(PALETTE_1 , 64, 96, 200)
    FLK3D.ReplacePaletteColour(PALETTE_2 , 128, 160, 240)
    FLK3D.ReplacePaletteColour(PALETTE_3 , 255, 0, 0)
    FLK3D.ReplacePaletteColour(PALETTE_4 , 0, 255, 0)
    FLK3D.ReplacePaletteColour(PALETTE_5 , 255, 255, 0)
    FLK3D.ReplacePaletteColour(PALETTE_6 , 0, 0, 255)
    FLK3D.ReplacePaletteColour(PALETTE_7 , 255, 0, 255)
    FLK3D.ReplacePaletteColour(PALETTE_8 , 0, 255, 255)
    FLK3D.ReplacePaletteColour(PALETTE_9 , 255, 255, 255)
    FLK3D.ReplacePaletteColour(PALETTE_10, 64, 0, 0)
    FLK3D.ReplacePaletteColour(PALETTE_11, 0, 64, 0)
    FLK3D.ReplacePaletteColour(PALETTE_12, 64, 64, 0)
    FLK3D.ReplacePaletteColour(PALETTE_13, 0, 0, 64)
    FLK3D.ReplacePaletteColour(PALETTE_14, 64, 0, 64)
end


local function setPaletteFromTable(tbl)
    FLK3D.ReplacePaletteColourFloatPacked(COLOR_WHITE, tbl[1])
    FLK3D.ReplacePaletteColourFloatPacked(COLOR_BLACK, tbl[2])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_1  , tbl[3])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_2  , tbl[4])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_3  , tbl[5])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_4  , tbl[6])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_5  , tbl[7])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_6  , tbl[8])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_7  , tbl[9])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_8  , tbl[10])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_9  , tbl[11])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_10 , tbl[12])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_11 , tbl[13])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_12 , tbl[14])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_13 , tbl[15])
    FLK3D.ReplacePaletteColourFloatPacked(PALETTE_14 , tbl[16])
end

local function getPaletteColourPacked(id)
    local r, g, b = term.getPaletteColor(COLOR_WHITE)
    return {r, g, b}
end

local function getCurrPaletteTable()
    return {
        {getPaletteColourPacked(COLOR_WHITE)},
        {getPaletteColourPacked(COLOR_BLACK)},
        {getPaletteColourPacked(PALETTE_1  )},
        {getPaletteColourPacked(PALETTE_2  )},
        {getPaletteColourPacked(PALETTE_3  )},
        {getPaletteColourPacked(PALETTE_4  )},
        {getPaletteColourPacked(PALETTE_5  )},
        {getPaletteColourPacked(PALETTE_6  )},
        {getPaletteColourPacked(PALETTE_7  )},
        {getPaletteColourPacked(PALETTE_8  )},
        {getPaletteColourPacked(PALETTE_9  )},
        {getPaletteColourPacked(PALETTE_10 )},
        {getPaletteColourPacked(PALETTE_11 )},
        {getPaletteColourPacked(PALETTE_12 )},
        {getPaletteColourPacked(PALETTE_13 )},
        {getPaletteColourPacked(PALETTE_14 )},
    }
end

local paletteStack = {}
function FlowJam.PushPalette()
    local curr = getCurrPaletteTable()
    paletteStack[#paletteStack + 1] = curr
end

function FlowJam.PopPalette()
    local prev = paletteStack[#paletteStack]
    paletteStack[#paletteStack] = nil

    setPaletteFromTable(prev)
end