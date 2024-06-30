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
        ["fancyName"] = params.fancyName or "Evil Fish",
        ["desc"] = params.desc or {"Will Kill You", "Quite literally"},
        ["mdl"] = params.mdl or "cube", -- model
        ["tex"] = params.tex or "none", -- texture
        ["worth"] = params.worth or {1, 5}, -- a range of minimum-maximum value
        ["resistance"] = params.resistance or 5, -- how hard is it to catch
        ["awareness"] = params.awareness or 5, -- how aware it is (harder to hook)
    }
end

--[[
    More on Resistance

    every 5 values is +1 rotation
    every 20 values is -1 circle radius (logarithmic, min. radii 16)
]]--

FlowJam.DeclareNewFish("squid", {
    ["fancyName"] = "Squid",
    ["desc"] = {"A strange squid unique to the Fleyprang ocean", "Highly sought after thanks to its red ink."},
    ["mdl"] = "squid",
    ["tex"] = "squid_tex",
    ["worth"] = {240, 400},
    ["resistance"] = 400,
    ["awareness"] = 100,
})

FlowJam.DeclareNewFish("fish_generic", {
    ["fancyName"] = "Plimblar",
    ["desc"] = {"A somewhat common fish on the Fleyprang ocean", "Despised by LokaCorp due to its use as an activist symbol."},
    ["mdl"] = "squid",
    ["tex"] = "squid_tex",
    ["worth"] = {20, 80},
    ["resistance"] = 150,
    ["awareness"] = 50,
})

FlowJam.DeclareNewFish("fish_elongated", {
    ["fancyName"] = "Fluther",
    ["desc"] = {"A strange elongated fish with good water dynamics", "Considered a delicacy on stations, Although banned from shipments."},
    ["mdl"] = "squid",
    ["tex"] = "squid_tex",
    ["worth"] = {60, 120},
    ["resistance"] = 220,
    ["awareness"] = 140,
})

FlowJam.DeclareNewFish("fish_sphere", {
    ["fancyName"] = "Bingal",
    ["desc"] = {"A small green spherical-shaped fish", "Harvested due to its space-resistant blood compatible with humans."},
    ["mdl"] = "squid",
    ["tex"] = "squid_tex",
    ["worth"] = {240, 400},
    ["resistance"] = 400,
    ["awareness"] = 100,
})