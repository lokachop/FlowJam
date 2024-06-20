FlowJam = FlowJam or {}

function FlowJam.CurTime()
    return LKHooks.CurTime()
end

local tw, th = term.getSize()
local rw, rh = tw * 3, th * 3

function FlowJam.GetDimensions()
    return rw, rh
end

function FlowJam.ScrW()
    return rw
end

function FlowJam.ScrH()
    return rh
end

TEXT_ALIGN_LEFT = 0
TEXT_ALIGN_CENTER = 1
TEXT_ALIGN_RIGHT = 2

TEXT_ALIGN_TOP = 3
TEXT_ALIGN_BOTTOM = 4
function FlowJam.APrint(text, x, y, alignX, alignY)
    local tW = #text

    local aX = x + (tW * alignX)
end