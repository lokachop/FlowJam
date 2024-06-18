LKHooks = LKHooks or {}
-- Handler to separate think / render thread on ComputerCraft
-- Practically a carbon copy of the example from https://pine3d.cc/docs/guide/4_baseGame

local hooks = {}
function LKHooks.Add(call, tag, func)
    if not hooks[call] then
        hooks[call] = {}
    end

    hooks[call][tag] = func
end


local doKill = false
function LKHooks.ExitProgram()
    doKill = true
end

local frameNum = 0
function LKHooks.GetFrameNumber()
    return frameNum
end

local curTime = 0
function LKHooks.CurTime()
    return curTime
end


local function executeThinkHooks()
    local lastTime = os.clock()


    while true do
        if doKill then
            break
        end


        local currTime = os.clock()
        local dt = currTime - lastTime
        lastTime = currTime

        curTime = curTime + dt


        if hooks["Think"] then
            for k, v in pairs(hooks["Think"]) do
                pcall(v, dt)
            end
        end

        os.queueEvent("ThinkHooks")
        os.pullEventRaw("ThinkHooks")
    end
end

local function executeRenderHooks()
    -- No DeltaTime for Render, want it to be as fast as possible!
    while true do
        if doKill then
            break
        end

        frameNum = frameNum + 1
        if hooks["Render"] then
            for k, v in pairs(hooks["Render"]) do
                pcall(v, dt)
            end
        end

        os.queueEvent("RenderHooks")
        os.pullEventRaw("RenderHooks")
    end
end

local keyStates = {}
local mouseStates = {}
function LKHooks.IsKeyDown(key)
    return keyStates[key]
end

function LKHooks.IsMouseDown(button)
    return mouseStates[button]
end

local mx, my = 0, 0
function LKHooks.GetLastMousePos()
    return mx, my
end



local function executeEventHooks()
    while true do
        if doKill then
            break
        end

        local event, key, x, y = os.pullEvent()

        if event == "key" then
            keyStates[key] = true
        elseif event == "key_up" then
            keyStates[key] = nil
        elseif event == "mouse_click" then
            mouseStates[key] = true
            mx = x
            my = y
        elseif event == "mouse_up" then
            mouseStates[key] = nil
        elseif event == "mouse_drag" then
            mx = x
            my = y
        end
    end
end


function LKHooks.BeginProgram()
    while true do
        if doKill then
            break
        end

        parallel.waitForAny(executeThinkHooks, executeRenderHooks, executeEventHooks)
    end
end