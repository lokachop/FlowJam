FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_MENU = id

local univMenu = FLK3D.NewUniverse("UniverseMenu")
local rtMenu = FLK3D.NewRenderTarget("RTMenu", FlowJam.ScrW(), FlowJam.ScrH())

-- setup FLK3D Universe for menu
local function setPalette()
    FLK3D.ReplacePaletteColour(PALETTE_1, 64, 96, 200) -- water1
    FLK3D.ReplacePaletteColour(PALETTE_2, 128, 160, 240) -- water2

    FLK3D.ReplacePaletteColour(PALETTE_3, 84, 88, 94) -- boat1
    FLK3D.ReplacePaletteColour(PALETTE_4, 84, 88, 94) -- boat2
    FLK3D.ReplacePaletteColour(PALETTE_5, 84, 88, 94) -- boat3

    FLK3D.ReplacePaletteColour(PALETTE_14, 140, 180, 220) -- sky
end



function state.onThink()

end

function state.onRender()

end

function state.onEnter()
    setPalette()
end

function state.onExit()

end