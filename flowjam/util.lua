FlowJam = FlowJam or {}

function FlowJam.CurTime()
    return LKHooks.CurTime()
end

local tw, th = term.getSize()
local rw, rh = tw * 2, th * 3

function FlowJam.GetDimensions()
    return rw, rh
end

function FlowJam.ScrW()
    return rw
end

function FlowJam.ScrH()
    return rh
end

function FlowJam.GetTermDimensions()
    return tw, th
end

TEXT_ALIGN_LEFT = 0
TEXT_ALIGN_CENTER = 1
TEXT_ALIGN_RIGHT = 2

TEXT_ALIGN_TOP = 3
TEXT_ALIGN_BOTTOM = 4
function FlowJam.APrint(text, x, y, col, colBG, alignX)
    local tW = #text

    local aX = x - (tW * (alignX * .5))

    term.setTextColor(col)
    term.setBackgroundColor(colBG)

    term.setCursorPos(math.floor(aX), math.floor(y))
    term.write(text)
end

-- https://community.khronos.org/t/planar-projected-shadow-matrix/49448/3
function FlowJam.GetShadowMatrix(planeOffset, planeNorm, lightDir)
    --where v is a point in space
    --d is the plane’s offset
    --n is the plane’s normal
    --l is the projection direction

    local d = planeOffset
    local n = planeNorm
    local l = lightDir

    local dotInv = 1.0 / (n[1] * l[1] + n[2] * l[2] + n[3] * l[3]);

    return Matrix(
        1.0 - n[1] * l[1] * dotInv, -n[2] * l[1] * dotInv     , -n[3] * l[1] * dotInv     , d * l[1] * dotInv,
        -n[1] * l[2] * dotInv     , 1.0 - n[2] * l[2] * dotInv, -n[3] * l[2] * dotInv     , d * l[2] * dotInv,
        -n[1] * l[3] * dotInv     , -n[2] * l[3] * dotInv     , 1.0 - n[3] * l[3] * dotInv, d * l[3] * dotInv,
        0                         , 0                         , 0                         , 1.0
    )
end


function FlowJam.PointInCircle(pos, circlePos, circleRad)
    return pos:Distance(circlePos) < circleRad
end