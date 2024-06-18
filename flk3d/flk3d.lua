FLK3D = FLK3D or {}
FLK3D.Version = "0.3CC"
FLK3D.Debug = true

FLK3D.DO_PERSP_CORRECT_COLOUR   = true
FLK3D.DO_PERSP_CORRECT_TEXTURE  = true

FLK3D.TEXINTERP_MODE = 0 -- 0 = nearest, 1 = bayer, 2 = random
FLK3D.WIREFRAME = false
FLK3D.RENDER_HALF = true
FLK3D.VIEWPOS_SHADING = true

local rootDir = (...):match("(.-)[^%.]+$")
function FLK3D.GetRootDirectory()
    return rootDir
end



function FLK3D.LoadFile(path)
    local loadPath = rootDir .. path
    print("-> " .. loadPath)
    require(loadPath)
end

FLK3D.LoadFile("libs.lmat") -- make sure to load lmat first
FLK3D.LoadFile("libs.lvec")
FLK3D.LoadFile("libs.lang")
FLK3D.LoadFile("libs.lktex")
FLK3D.LoadFile("libs.lknoise")

FLK3D.SunDir = Vector(1, 2, 4):GetNormalized()

function FLK3D.SetSunDir(vec)
    FLK3D.SunDir = vec:GetNormalized()
end



FLK3D.LoadFile("universes")
FLK3D.LoadFile("rendertargets")
FLK3D.LoadFile("models")
FLK3D.LoadFile("basemodels")
FLK3D.LoadFile("objects")
FLK3D.LoadFile("palette")



FLK3D.LoadFile("camera")
FLK3D.LoadFile("raster")
FLK3D.LoadFile("pipeline")

FLK3D.LoadFile("render_cc")

FLK3D.LoadFile("physics")