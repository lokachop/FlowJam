FlowJam = FlowJam or {}

local fishList = {}
local fishListFastRandom = {}


function FlowJam.GetFishList()
    return fishList
end

function FlowJam.GetRandomFish()
    return fishList[fishListFastRandom[math.random(1, #fishListFastRandom)]]
end

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

    fishListFastRandom[#fishListFastRandom + 1] = name
end

--[[
    More on Resistance

    every 10 values is +1 rotation
    every 20 values is -1 circle radius (logarithmic, min. radii 16)
    -- Thi si s loka from the future ^
    all of that is messed up and WRONG but no TIME
]]--

FlowJam.DeclareNewFish("squid", {
    ["fancyName"] = "Harlitan",
    ["desc"] = {"A strange squid unique to Fleyprang", "", "Highly sought after thanks to its red ink", "and special skin properties"},
    ["mdl"] = "squid",
    ["tex"] = "squid_tex",
    ["worth"] = {240, 400},
    ["resistance"] = 400,
    ["awareness"] = 100,
})

FlowJam.DeclareNewFish("fish_generic", {
    ["fancyName"] = "Plimblar",
    ["desc"] = {"A somewhat common fish on Fleyprang", "", "Despised by LokaCorp due to", "its use as an activist symbol"},
    ["mdl"] = "fish_simple",
    ["tex"] = "fish_ball_tex",
    ["worth"] = {20, 80},
    ["resistance"] = 150,
    ["awareness"] = 50,
})

FlowJam.DeclareNewFish("fish_elongated", {
    ["fancyName"] = "Fluther",
    ["desc"] = {"A strange elongated fish with good water dynamics", "", "Considered a delicacy on stations", "Although banned from shipments"},
    ["mdl"] = "fish_long",
    ["tex"] = "fish_ball_tex",
    ["worth"] = {60, 120},
    ["resistance"] = 220,
    ["awareness"] = 140,
})

FlowJam.DeclareNewFish("fish_sphere", {
    ["fancyName"] = "Bingal",
    ["desc"] = {"A small spherical-shaped fish", "", "Harvested due to its space-resistant blood", "which is compatible with humans"},
    ["mdl"] = "fish_ball",
    ["tex"] = "fish_ball_tex",
    ["worth"] = {150, 230},
    ["resistance"] = 300,
    ["awareness"] = 75,
})
