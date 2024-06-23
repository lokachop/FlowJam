FLK3D = FLK3D or {}

--[[
    FLK3D.Raster_SetPositions(px1, py1, px2, py2, px3, py3)
    FLK3D.Raster_SetShadeValue(col_s1, col_s2, col_s3)
    FLK3D.Raster_SetDepthTested(true)
    FLK3D.Raster_SetW(v1_w, v2_w, v3_w)
    FLK3D.Raster_SetColourParams(obj["COL_HIGHLIGHT"] or 1, obj["COL_SHADE"] or 2, obj["SHADE_THRESHOLD"] or 0.5)
    FLK3D.Raster_SetShadeDither(shadeDither and true or false)
    FLK3D.Raster_SetTextured(false)
    FLK3D.Raster_SetTextured(true)
    FLK3D.Raster_SetUVs(tu1, tv1, tu2, tv2, tu3, tv3)
    FLK3D.Raster_SetTextureData(textureData)
    FLK3D.RenderTriangleParams()
]]--

function FLK3D.DrawRect(x, y, w, h, col)
    -- pre setup
    FLK3D.Raster_SetColourParams(col, col, 0.5)
    FLK3D.Raster_SetDepthTested(false)
    FLK3D.Raster_SetTextured(false)
    FLK3D.Raster_SetRenderHalfDisable(true)

    FLK3D.Raster_SetPositions(x, y, x + w, y, x + w, y + h)
    FLK3D.RenderTriangleParams()


    FLK3D.Raster_SetPositions(x + w, y + h, x, y + h, x, y)
    FLK3D.RenderTriangleParams()

    FLK3D.Raster_SetRenderHalfDisable(false)
end


local texList = LKTEX.Textures
function FLK3D.DrawTexturedRect(x, y, w, h, tex)
    local textureData = texList[tex]
    if not textureData then
        return
    end

    -- pre setup
    --FLK3D.Raster_SetColourParams(col, col, 0.5)
    FLK3D.Raster_SetRenderHalfDisable(true)

    FLK3D.Raster_SetDepthTested(false)
    FLK3D.Raster_SetTextured(true)
    FLK3D.Raster_SetTextureData(textureData)
    FLK3D.Raster_SetW(1, 1, 1)


    FLK3D.Raster_SetPositions(x, y, x + w, y, x + w, y + h)
    FLK3D.Raster_SetUVs(0, 0, 1, 0, 1, 1)
    FLK3D.RenderTriangleParams()


    FLK3D.Raster_SetPositions(x + w, y + h, x, y + h, x, y)
    FLK3D.Raster_SetUVs(1, 1, 0, 1, 0, 0)
    FLK3D.RenderTriangleParams()

    FLK3D.Raster_SetRenderHalfDisable(false)
end



function FLK3D.DrawPoly(poly, col)
    if #poly < 3 then
        return
    end

    FLK3D.Raster_SetColourParams(col, col, 0.5)
    FLK3D.Raster_SetDepthTested(false)
    FLK3D.Raster_SetTextured(false)
    FLK3D.Raster_SetRenderHalfDisable(true)

    local x1, y1 = poly[1][1], poly[1][2]
    local x2, y2 = poly[2][1], poly[2][2]

    for i = 3, #poly do
        local currPoly = poly[i]

        local x3, y3 = currPoly[1], currPoly[2]

        FLK3D.Raster_SetPositions(x1, y1, x2, y2, x3, y3)
        FLK3D.RenderTriangleParams()

        x2 = x3
        y2 = y3
    end

    FLK3D.Raster_SetRenderHalfDisable(false)
end

function FLK3D.DrawTexturedPoly(poly, tex)
    if #poly < 3 then
        return
    end

    local textureData = texList[tex]
    if not textureData then
        return
    end

    FLK3D.Raster_SetRenderHalfDisable(true)

    FLK3D.Raster_SetDepthTested(false)
    FLK3D.Raster_SetTextured(true)
    FLK3D.Raster_SetTextureData(textureData)
    FLK3D.Raster_SetW(1, 1, 1)


    local x1, y1 = poly[1][1], poly[1][2]
    local u1, v1 = poly[1][3], poly[1][4]

    local x2, y2 = poly[2][1], poly[2][2]
    local u2, v2 = poly[1][3], poly[1][4]

    for i = 3, #poly do
        local currPoly = poly[i]

        local x3, y3 = currPoly[1], currPoly[2]
        local u3, v3 = currPoly[3], currPoly[4]

        FLK3D.Raster_SetPositions(x1, y1, x2, y2, x3, y3)
        FLK3D.Raster_SetUVs(u1, v1, u2, v2, u3, v3)
        FLK3D.RenderTriangleParams()

        x2 = x3
        y2 = y3

        u2 = u3
        v2 = v3
    end

    FLK3D.Raster_SetRenderHalfDisable(false)
end

function FLK3D.DrawCircle(x, y, sx, sy, itr, col)
    local poly = {}

    for i = 0, (itr) do
        local delta = (i / itr) * (math.pi * 2)

        poly[#poly + 1] = {
            x + math.cos(delta) * sx,
            y + math.sin(delta) * sy
    }
    end
    FLK3D.DrawPoly(poly, col)
end