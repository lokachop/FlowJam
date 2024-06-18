FLK3D = FLK3D or {}
FLK3D.RTRegistry = FLK3D.RTRegistry or {}

function FLK3D.NewRenderTarget(tag, w, h)
    if not tag then
        error("Attempt to make a renderTarget without a tag!")
    end

    if not w or not h then
        error("Dimensions for rendertarget \"" .. tag .. "\" not specified!")
    end



    FLK3D.RTRegistry[tag] = {}
    FLK3D.RTRegistry[tag]._params = {
        w = w,
        h = h,
    }

    FLK3D.RTRegistry[tag]._depth = {}


    for i = 0, (w * h) - 1 do
        FLK3D.RTRegistry[tag]._depth[i] = math.huge
        FLK3D.RTRegistry[tag][i] = colors.black
    end

    return FLK3D.RTRegistry[tag]
end

FLK3D.BaseRT = FLK3D.NewRenderTarget("flk3d_base_rt", 512, 512)

local currRT = FLK3D.BaseRT
FLK3D.RTStack = FLK3D.RTStack or {}


function FLK3D.PushRenderTarget(rt)
    FLK3D.RTStack[#FLK3D.RTStack + 1] = currRT
    currRT = rt
end

function FLK3D.PopRenderTarget()
    currRT = FLK3D.RTStack[#FLK3D.RTStack] or FLK3D.BaseRT
    FLK3D.RTStack[#FLK3D.RTStack] = nil
end

function FLK3D.GetCurrRT()
    return currRT
end

function FLK3D.Clear(col, depth)
    depth = depth or true
    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w, rtParams.h


    local dbuff = rt._depth
    for i = 0, (rtW * rtH) - 1 do
        rt[i] = col

        if depth then
            dbuff[i] = math.huge
        end
    end
end

local renderHalf = FLK3D.RENDER_HALF
function FLK3D.ClearHalfed(col, depth)
    depth = depth or true

    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w, rtParams.h

    local dbuff = rt._depth

    local rtFrame = rt._frame or 0

    for i = 0, (rtW * rtH) - 1 do
        if renderHalf then
            local xc = i % rtW
            local yc = math.floor(i / rtW)
            if ((xc + yc) + rtFrame) % 2 == 0 then
                goto _contClear
            end
        end


        rt[i] = col

        if depth then
            dbuff[i] = math.huge
        end

        ::_contClear::
    end
end

function FLK3D.ClearDepth()
    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w, rtParams.h

    local dbuff = rt._depth

    for i = 0, (rtW * rtH) - 1 do
        dbuff[i] = math.huge
    end
end

function FLK3D.GetPixel(x, y)
    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w

    local dbuff = rt._depth

    local getInd = x + y * rtW
    return rt[getInd], dbuff[getInd]
end


function FLK3D.ApplyOp(op)
    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w, rtParams.h

    local newConstructedBuff = {}

    for i = 0, (rtW * rtH) - 1 do
        local xc = i % rtW
        local yc = math.floor(i / rtW)

        newConstructedBuff[i] = op(rt, i, xc, yc)
    end

    for i = 0, (rtW * rtH) - 1 do
        rt[i] = newConstructedBuff[i]
    end
end

function FLK3D.ApplyOpHalfed(op)
    local rt = FLK3D.GetCurrRT()
    local rtParams = rt._params
    local rtW, rtH = rtParams.w, rtParams.h
    local rtFrame = rt._frame or 0

    local newConstructedBuff = {}

    for i = 0, (rtW * rtH) - 1 do
        local xc = i % rtW
        local yc = math.floor(i / rtW)

        if ((xc + yc) + (rtFrame - 1)) % 2 == 0 then
            goto _contOp
        end

        newConstructedBuff[i] = op(rt, i, xc, yc, rtW, rtH)
        ::_contOp::
    end

    for i = 0, (rtW * rtH) - 1 do
        rt[i] = newConstructedBuff[i] or rt[i]
    end
end