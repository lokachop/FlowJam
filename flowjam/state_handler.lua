FlowJam = FlowJam or {}
FlowJam.States = FlowJam.States or {}

FlowJam.CurrState = -99
function FlowJam.GetStateParameters(state)
    return FlowJam.States[state]
end

local lastID = 0
function FlowJam.NewState()
    lastID = lastID + 1

    FlowJam.States[lastID] = {}
    return lastID, FlowJam.States[lastID]
end

function FlowJam.StateThink(dt)
    local currParams = FlowJam.GetStateParameters(FlowJam.CurrState)
    if currParams and currParams.onThink then
        currParams.onThink(dt)
    end
end

function FlowJam.StateRender()
    local currParams = FlowJam.GetStateParameters(FlowJam.CurrState)
    if currParams and currParams.onRender then
        currParams.onRender()
    end
end


function FlowJam.SetState(new)
    local prevParams = FlowJam.GetStateParameters(FlowJam.CurrState)
    if prevParams and prevParams.onExit then
        prevParams.onExit(new)
    end

    FlowJam.CurrState = new
    local currParams = FlowJam.GetStateParameters(FlowJam.CurrState)
    if currParams and currParams.onEnter then
        currParams.onEnter(new)
    end
end