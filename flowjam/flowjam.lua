FlowJam = FlowJam or {}


local rootDir = (...):match("(.-)[^%.]+$")
function FlowJam.GetRootDirectory()
    return rootDir
end

function FlowJam.LoadFile(path)
    local loadPath = rootDir .. path
    print("> " .. loadPath)
    require(loadPath)
end

FlowJam.LoadFile("util")
FlowJam.LoadFile("palettes")
FlowJam.LoadFile("debugcam")
FlowJam.LoadFile("shadows")
FlowJam.LoadFile("sound")
FlowJam.LoadFile("orbcam")
FlowJam.LoadFile("boat")
FlowJam.LoadFile("fishing")

FlowJam.LoadFile("loaders.load_models")
FlowJam.LoadFile("loaders.load_textures")

FlowJam.LoadFile("state_handler")
    FlowJam.LoadFile("states.state_menu")
    FlowJam.LoadFile("states.state_game")
    FlowJam.LoadFile("states.state_fishing")