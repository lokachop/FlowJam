FlowJam = FlowJam or {}
FLK3D = FLK3D or {}

local function setupPlanarShadow(obj)

end


function FlowJam.UpdateSceneShadows()
    local currUniv = FLK3D.GetCurrUniverse()

    for k, v in pairs(currUniv["objects"]) do
        if not v["PLANAR_SHADOW"] then
            goto _cont
        end


        ::_cont::
    end
end