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