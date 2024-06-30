FlowJam = FlowJam or {}

local fishList = {}


function FlowJam.DeclareNewFish(name, params)
    if not name then
        error("Attempt to create invalid fish!")
    end

    if not params then
        error("Attempt to create fish \"" .. name .. "\" with no params!")
    end
    
    fishList[name] = {
        ["name"] = name,
        ["mdl"] = params.mdl or "cube", -- model
        ["tex"] = params.tex or "none", -- texture
        ["worth"] = params.worth or {1, 5}, -- a range of minimum-maximum value
        ["resistance"] = params.resistance or 5, -- how hard is it to catch
    }
end

--[[
    More on Resistance

    every 5 values is +1 rotation
    every 20 values is -1 circle radius (logarithmic, min. radii 15)
]]--