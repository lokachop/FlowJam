FlowJam = FlowJam or {}


local rootDir = (...):match("(.-)[^%.]+$")
function FlowJam.GetRootDirectory()
    return rootDir
end

function FlowJam.LoadFile(path)
    local loadPath = rootDir .. path
    require(loadPath)
end

FlowJam.LoadFile("util")
FlowJam.LoadFile("palettes")

FlowJam.LoadFile("loaders.load_models")
FlowJam.LoadFile("loaders.load_textures")

FlowJam.LoadFile("state_handler")
    FlowJam.LoadFile("states.state_menu")
