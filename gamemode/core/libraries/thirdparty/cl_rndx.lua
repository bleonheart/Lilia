--[[
Copyright (c) 2025 Srlion (https://github.com/Srlion)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
lia.derma = lia.derma or {}
local bit_band = bit.band
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_DrawTexturedRect = surface.DrawTexturedRect
local render_CopyRenderTargetToTexture = render.CopyRenderTargetToTexture
local math_min = math.min
local math_max = math.max
local DisableClipping = DisableClipping
local SHADERS_VERSION = "1757877956"
local SHADERS_GMA = [========[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]========]
do
    local DECODED_SHADERS_GMA = util.Base64Decode(SHADERS_GMA)
    if not DECODED_SHADERS_GMA or #DECODED_SHADERS_GMA == 0 then return end
    file.Write("rndx_shaders_" .. SHADERS_VERSION .. ".gma", DECODED_SHADERS_GMA)
    game.MountGMA("data/rndx_shaders_" .. SHADERS_VERSION .. ".gma")
end

local function getShader(name)
    return SHADERS_VERSION:gsub("%.", "_") .. "_" .. name
end

local blurRt = GetRenderTargetEx("lia.derma" .. SHADERS_VERSION .. SysTime(), 1024, 1024, RT_SIZE_LITERAL, MATERIAL_RT_DEPTH_SEPARATE, bit.bor(2, 256, 4, 8), 0, IMAGE_FORMAT_BGRA8888)
local newFlag
do
    local flags_n = -1
    function newFlag()
        flags_n = flags_n + 1
        return 2 ^ flags_n
    end
end

local NO_TL, NO_TR, NO_BL, NO_BR = newFlag(), newFlag(), newFlag(), newFlag()
local SHAPE_CIRCLE, SHAPE_FIGMA, SHAPE_IOS = newFlag(), newFlag(), newFlag()
local BLUR = newFlag()
local shader_mat = [==[
screenspace_general
{
	$pixshader ""
	$vertexshader ""
	$basetexture ""
	$texture1    ""
	$texture2    ""
	$texture3    ""
	$ignorez            1
	$vertexcolor        1
	$vertextransform    1
	"<dx90"
	{
		$no_draw 1
	}
	$copyalpha                 0
	$alpha_blend_color_overlay 0
	$alpha_blend               1
	$linearwrite               1
	$linearread_basetexture    1
	$linearread_texture1       1
	$linearread_texture2       1
	$linearread_texture3       1
}
]==]
local matrixes = {}
local function createShaderMat(name, opts)
    assert(name and isstring(name), "createShaderMat: name must be a string")
    local key_values = util.KeyValuesToTable(shader_mat, false, true)
    if opts then
        for k, v in pairs(opts) do
            key_values[k] = v
        end
    end

    local mat = CreateMaterial("rndx_shaders1" .. name .. SysTime(), "screenspace_general", key_values)
    matrixes[mat] = Matrix()
    return mat
end

local roundedMat = createShaderMat("rounded", {
    ["$pixshader"] = getShader("rndx_rounded_ps30"),
    ["$vertexshader"] = getShader("rndx_vertex_vs30"),
})

local roundedTextureMat = createShaderMat("rounded_texture", {
    ["$pixshader"] = getShader("rndx_rounded_ps30"),
    ["$vertexshader"] = getShader("rndx_vertex_vs30"),
    ["$basetexture"] = "vgui/white",
})

local blurVertical = "$c0_x"
local roundedBlurMat = createShaderMat("blur_horizontal", {
    ["$pixshader"] = getShader("rndx_rounded_blur_ps30"),
    ["$vertexshader"] = getShader("rndx_vertex_vs30"),
    ["$basetexture"] = blurRt:GetName(),
    ["$texture1"] = "_rt_FullFrameFB",
})

local shadowsMat = createShaderMat("rounded_shadows", {
    ["$pixshader"] = getShader("rndx_shadows_ps30"),
    ["$vertexshader"] = getShader("rndx_vertex_vs30"),
})

local shadowsBlurMat = createShaderMat("shadows_blur_horizontal", {
    ["$pixshader"] = getShader("rndx_shadows_blur_ps30"),
    ["$vertexshader"] = getShader("rndx_vertex_vs30"),
    ["$basetexture"] = blurRt:GetName(),
    ["$texture1"] = "_rt_FullFrameFB",
})

local shapes = {
    [SHAPE_CIRCLE] = 2,
    [SHAPE_FIGMA] = 2.2,
    [SHAPE_IOS] = 4,
}

local defaultShape = SHAPE_FIGMA
local materialSetTexture = roundedMat.SetTexture
local materialSetMatrix = roundedMat.SetMatrix
local materialSetFloat = roundedMat.SetFloat
local matrixSetUnpacked = Matrix().SetUnpacked
local MAT
local X, Y, W, H
local TL, TR, BL, BR
local TEXTURE
local USING_BLUR, BLUR_INTENSITY
local COL_R, COL_G, COL_B, COL_A
local SHAPE, OUTLINE_THICKNESS
local START_ANGLE, END_ANGLE, ROTATION
local CLIP_PANEL
local SHADOW_ENABLED, SHADOW_SPREAD, SHADOW_INTENSITY
local function resetParams()
    MAT = nil
    X, Y, W, H = 0, 0, 0, 0
    TL, TR, BL, BR = 0, 0, 0, 0
    TEXTURE = nil
    USING_BLUR, BLUR_INTENSITY = false, 1.0
    COL_R, COL_G, COL_B, COL_A = 255, 255, 255, 255
    SHAPE, OUTLINE_THICKNESS = shapes[defaultShape], -1
    START_ANGLE, END_ANGLE, ROTATION = 0, 360, 0
    CLIP_PANEL = nil
    SHADOW_ENABLED, SHADOW_SPREAD, SHADOW_INTENSITY = false, 0, 0
end

do
    local HUGE = math.huge
    local function nzr(x)
        if x ~= x or x < 0 then return 0 end
        local lim = math_min(W, H)
        if x == HUGE then return lim end
        return x
    end

    local function clamp0(x)
        return x < 0 and 0 or x
    end

    function normalizeCornerRadii()
        local tl, tr, bl, br = nzr(TL), nzr(TR), nzr(BL), nzr(BR)
        local k = math_max(1, (tl + tr) / W, (bl + br) / W, (tl + bl) / H, (tr + br) / H)
        if k > 1 then
            local inv = 1 / k
            tl, tr, bl, br = tl * inv, tr * inv, bl * inv, br * inv
        end
        return clamp0(tl), clamp0(tr), clamp0(bl), clamp0(br)
    end
end

local function setupDraw()
    local tl, tr, bl, br = normalizeCornerRadii()
    local matrix = matrixes[MAT]
    matrixSetUnpacked(matrix, bl, W, OUTLINE_THICKNESS or -1, END_ANGLE, br, H, SHADOW_INTENSITY, ROTATION, tr, SHAPE, BLUR_INTENSITY or 1.0, 0, tl, TEXTURE and 1 or 0, START_ANGLE, 0)
    materialSetMatrix(MAT, "$viewprojmat", matrix)
    if COL_R then surface_SetDrawColor(COL_R, COL_G, COL_B, COL_A) end
    surface_SetMaterial(MAT)
end

local manualColor = newFlag()
local defaultDrawFlags = defaultShape
local function drawRounded(x, y, w, h, col, flags, tl, tr, bl, br, texture, thickness)
    if col and col.a == 0 then return end
    resetParams()
    if not flags then flags = defaultDrawFlags end
    local using_blur = bit_band(flags, BLUR) ~= 0
    if using_blur then return lia.derma.drawBlur(x, y, w, h, flags, tl, tr, bl, br, thickness) end
    MAT = roundedMat
    if texture then
        MAT = roundedTextureMat
        materialSetTexture(MAT, "$basetexture", texture)
        TEXTURE = texture
    end

    W, H = w, h
    TL, TR, BL, BR = bit_band(flags, NO_TL) == 0 and tl or 0, bit_band(flags, NO_TR) == 0 and tr or 0, bit_band(flags, NO_BL) == 0 and bl or 0, bit_band(flags, NO_BR) == 0 and br or 0
    SHAPE = shapes[bit_band(flags, SHAPE_CIRCLE + SHAPE_FIGMA + SHAPE_IOS)] or shapes[defaultShape]
    OUTLINE_THICKNESS = thickness
    if bit_band(flags, manualColor) ~= 0 and not col then
        COL_R = nil
    elseif col then
        COL_R, COL_G, COL_B, COL_A = col.r, col.g, col.b, col.a
    else
        COL_R, COL_G, COL_B, COL_A = 255, 255, 255, 255
    end

    setupDraw()
    return surface_DrawTexturedRectUV(x, y, w, h, -0.015625, -0.015625, 1.015625, 1.015625)
end

--[[
    Purpose:
        Draws a rounded rectangle using the shader-backed rounded renderer.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Rectangle width.
        h (number)
            Rectangle height.
        col (Color|nil)
            Draw color. Defaults to white unless manual color mode is enabled.
        flags (number|nil)
            Optional bit flags such as `lia.derma.SHAPE_IOS`, `lia.derma.BLUR`, or corner-disable flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.draw(8, 20, 20, 160, 40, Color(25, 28, 35, 240), lia.derma.SHAPE_IOS)
        ```

    Realm:
        Client
]]
function lia.derma.draw(radius, x, y, w, h, col, flags)
    return drawRounded(x, y, w, h, col, flags, radius, radius, radius, radius)
end

--[[
    Purpose:
        Draws an outlined rounded rectangle using the shader-backed rounded renderer.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Rectangle width.
        h (number)
            Rectangle height.
        col (Color|nil)
            Outline color.
        thickness (number|nil)
            Outline thickness. Defaults to 1.
        flags (number|nil)
            Optional shape and corner flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawOutlined(8, 20, 20, 160, 40, color_white, 2)
        ```

    Realm:
        Client
]]
function lia.derma.drawOutlined(radius, x, y, w, h, col, thickness, flags)
    return drawRounded(x, y, w, h, col, flags, radius, radius, radius, radius, nil, thickness or 1)
end

--[[
    Purpose:
        Draws a rounded rectangle filled with a texture.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Rectangle width.
        h (number)
            Rectangle height.
        col (Color|nil)
            Tint color for the texture.
        texture (ITexture)
            Texture used as the base texture.
        flags (number|nil)
            Optional shape and corner flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawTexture(8, x, y, w, h, color_white, material:GetTexture("$basetexture"))
        ```

    Realm:
        Client
]]
function lia.derma.drawTexture(radius, x, y, w, h, col, texture, flags)
    return drawRounded(x, y, w, h, col, flags, radius, radius, radius, radius, texture)
end

--[[
    Purpose:
        Draws a rounded rectangle from a material by using the material base texture when available.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Rectangle width.
        h (number)
            Rectangle height.
        col (Color|nil)
            Tint color for the material texture.
        mat (IMaterial)
            Material whose `$basetexture` is drawn.
        flags (number|nil)
            Optional shape and corner flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawMaterial(6, x, y, w, h, color_white, Material("vgui/gradient_down"))
        ```

    Realm:
        Client
]]
function lia.derma.drawMaterial(radius, x, y, w, h, col, mat, flags)
    local tex = mat:GetTexture("$basetexture")
    if tex then return lia.derma.drawTexture(radius, x, y, w, h, col, tex, flags) end
end

--[[
    Purpose:
        Draws a filled circle through the rounded renderer.

    Parameters:
        x (number)
            Circle center X coordinate.
        y (number)
            Circle center Y coordinate.
        radius (number)
            Circle diameter used by the renderer.
        col (Color|nil)
            Circle color.
        flags (number|nil)
            Optional flags combined with the circle shape flag.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawCircle(100, 100, 32, Color(255, 255, 255))
        ```

    Realm:
        Client
]]
function lia.derma.drawCircle(x, y, radius, col, flags)
    return lia.derma.draw(radius / 2, x - radius / 2, y - radius / 2, radius, radius, col, (flags or 0) + SHAPE_CIRCLE)
end

--[[
    Purpose:
        Draws an outlined circle through the rounded renderer.

    Parameters:
        x (number)
            Circle center X coordinate.
        y (number)
            Circle center Y coordinate.
        radius (number)
            Circle diameter used by the renderer.
        col (Color|nil)
            Outline color.
        thickness (number|nil)
            Outline thickness.
        flags (number|nil)
            Optional flags combined with the circle shape flag.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawCircleOutlined(100, 100, 32, color_white, 2)
        ```

    Realm:
        Client
]]
function lia.derma.drawCircleOutlined(x, y, radius, col, thickness, flags)
    return lia.derma.drawOutlined(radius / 2, x - radius / 2, y - radius / 2, radius, radius, col, thickness, (flags or 0) + SHAPE_CIRCLE)
end

--[[
    Purpose:
        Draws a textured circle through the rounded renderer.

    Parameters:
        x (number)
            Circle center X coordinate.
        y (number)
            Circle center Y coordinate.
        radius (number)
            Circle diameter used by the renderer.
        col (Color|nil)
            Texture tint color.
        texture (ITexture)
            Texture used as the base texture.
        flags (number|nil)
            Optional flags combined with the circle shape flag.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawCircleTexture(100, 100, 32, color_white, tex)
        ```

    Realm:
        Client
]]
function lia.derma.drawCircleTexture(x, y, radius, col, texture, flags)
    return lia.derma.drawTexture(radius / 2, x - radius / 2, y - radius / 2, radius, radius, col, texture, (flags or 0) + SHAPE_CIRCLE)
end

--[[
    Purpose:
        Draws a circular material by using the material base texture when available.

    Parameters:
        x (number)
            Circle center X coordinate.
        y (number)
            Circle center Y coordinate.
        radius (number)
            Circle diameter used by the renderer.
        col (Color|nil)
            Texture tint color.
        mat (IMaterial)
            Material whose `$basetexture` is drawn.
        flags (number|nil)
            Optional flags combined with the circle shape flag.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawCircleMaterial(100, 100, 32, color_white, Material("icon16/star.png"))
        ```

    Realm:
        Client
]]
function lia.derma.drawCircleMaterial(x, y, radius, col, mat, flags)
    return lia.derma.drawMaterial(radius / 2, x - radius / 2, y - radius / 2, radius, radius, col, mat, (flags or 0) + SHAPE_CIRCLE)
end

local useShadowsBlur = false
local function drawBlur()
    if useShadowsBlur then
        MAT = shadowsBlurMat
    else
        MAT = roundedBlurMat
    end

    COL_R, COL_G, COL_B, COL_A = 255, 255, 255, 255
    setupDraw()
    render_CopyRenderTargetToTexture(blurRt)
    materialSetFloat(MAT, blurVertical, 0)
    surface_DrawTexturedRect(X, Y, W, H)
    render_CopyRenderTargetToTexture(blurRt)
    materialSetFloat(MAT, blurVertical, 1)
    surface_DrawTexturedRect(X, Y, W, H)
end

--[[
    Purpose:
        Draws a rounded shader blur region. This lower-level renderer is used by rounded draw flags before the later panel blur helper redefines `lia.derma.drawBlur`.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Blur region width.
        h (number)
            Blur region height.
        flags (number|nil)
            Optional shape and corner flags.
        tl (number)
            Top-left radius.
        tr (number)
            Top-right radius.
        bl (number)
            Bottom-left radius.
        br (number)
            Bottom-right radius.
        thickness (number|nil)
            Optional outline thickness for the shader parameters.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawBlur(x, y, w, h, lia.derma.SHAPE_IOS, 8, 8, 8, 8)
        ```

    Realm:
        Client
]]
function lia.derma.drawBlur(x, y, w, h, flags, tl, tr, bl, br, thickness)
    resetParams()
    if not flags then flags = defaultDrawFlags end
    X, Y = x, y
    W, H = w, h
    TL, TR, BL, BR = bit_band(flags, NO_TL) == 0 and tl or 0, bit_band(flags, NO_TR) == 0 and tr or 0, bit_band(flags, NO_BL) == 0 and bl or 0, bit_band(flags, NO_BR) == 0 and br or 0
    SHAPE = shapes[bit_band(flags, SHAPE_CIRCLE + SHAPE_FIGMA + SHAPE_IOS)] or shapes[defaultShape]
    OUTLINE_THICKNESS = thickness
    drawBlur()
end

local function setupShadows()
    X = X - SHADOW_SPREAD
    Y = Y - SHADOW_SPREAD
    W = W + (SHADOW_SPREAD * 2)
    H = H + (SHADOW_SPREAD * 2)
    TL = TL + (SHADOW_SPREAD * 2)
    TR = TR + (SHADOW_SPREAD * 2)
    BL = BL + (SHADOW_SPREAD * 2)
    BR = BR + (SHADOW_SPREAD * 2)
end

local function drawShadows(r, g, b, a)
    if USING_BLUR then
        useShadowsBlur = true
        drawBlur()
        useShadowsBlur = false
    end

    MAT = shadowsMat
    if r == false then
        COL_R = nil
    else
        COL_R, COL_G, COL_B, COL_A = r, g, b, a
    end

    setupDraw()
    surface_DrawTexturedRectUV(X, Y, W, H, -0.015625, -0.015625, 1.015625, 1.015625)
end

--[[
    Purpose:
        Draws a rounded shadow with independent corner radii, spread, intensity, optional blur, and optional outline thickness.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Shadow source width.
        h (number)
            Shadow source height.
        col (Color|nil)
            Shadow color.
        flags (number|nil)
            Optional shape, blur, manual color, and corner flags.
        tl (number)
            Top-left radius.
        tr (number)
            Top-right radius.
        bl (number)
            Bottom-left radius.
        br (number)
            Bottom-right radius.
        spread (number|nil)
            Shadow spread. Defaults to 30.
        intensity (number|nil)
            Shadow intensity. Defaults to spread multiplied by 1.2.
        thickness (number|nil)
            Optional outline thickness for the shader parameters.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawShadowsEx(x, y, w, h, Color(0, 0, 0, 180), lia.derma.SHAPE_IOS, 8, 8, 8, 8, 20, 24)
        ```

    Realm:
        Client
]]
function lia.derma.drawShadowsEx(x, y, w, h, col, flags, tl, tr, bl, br, spread, intensity, thickness)
    if col and col.a == 0 then return end
    local OLD_CLIPPING_STATE = DisableClipping(true)
    resetParams()
    if not flags then flags = defaultDrawFlags end
    X, Y = x, y
    W, H = w, h
    SHADOW_SPREAD = spread or 30
    SHADOW_INTENSITY = intensity or SHADOW_SPREAD * 1.2
    TL, TR, BL, BR = bit_band(flags, NO_TL) == 0 and tl or 0, bit_band(flags, NO_TR) == 0 and tr or 0, bit_band(flags, NO_BL) == 0 and bl or 0, bit_band(flags, NO_BR) == 0 and br or 0
    SHAPE = shapes[bit_band(flags, SHAPE_CIRCLE + SHAPE_FIGMA + SHAPE_IOS)] or shapes[defaultShape]
    OUTLINE_THICKNESS = thickness
    setupShadows()
    USING_BLUR = bit_band(flags, BLUR) ~= 0
    if bit_band(flags, manualColor) == 0 then drawShadows(col and col.r or 0, col and col.g or 0, col and col.b or 0, col and col.a or 255) end
    DisableClipping(OLD_CLIPPING_STATE)
end

--[[
    Purpose:
        Draws a rounded shadow using the same radius on every corner.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Shadow source width.
        h (number)
            Shadow source height.
        col (Color|nil)
            Shadow color.
        spread (number|nil)
            Shadow spread.
        intensity (number|nil)
            Shadow intensity.
        flags (number|nil)
            Optional shape and blur flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawShadows(10, x, y, w, h, Color(0, 0, 0, 180), 20, 24)
        ```

    Realm:
        Client
]]
function lia.derma.drawShadows(radius, x, y, w, h, col, spread, intensity, flags)
    return lia.derma.drawShadowsEx(x, y, w, h, col, flags, radius, radius, radius, radius, spread, intensity)
end

--[[
    Purpose:
        Draws an outlined rounded shadow using the same radius on every corner.

    Parameters:
        radius (number)
            Corner radius applied to every corner.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Shadow source width.
        h (number)
            Shadow source height.
        col (Color|nil)
            Shadow color.
        thickness (number|nil)
            Outline thickness. Defaults to 1.
        spread (number|nil)
            Shadow spread.
        intensity (number|nil)
            Shadow intensity.
        flags (number|nil)
            Optional shape and blur flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawShadowsOutlined(10, x, y, w, h, Color(0, 0, 0, 180), 2, 20, 24)
        ```

    Realm:
        Client
]]
function lia.derma.drawShadowsOutlined(radius, x, y, w, h, col, thickness, spread, intensity, flags)
    return lia.derma.drawShadowsEx(x, y, w, h, col, flags, radius, radius, radius, radius, spread, intensity, thickness or 1)
end

lia.derma.baseFuncs = {
    Rad = function(self, rad)
        TL, TR, BL, BR = rad, rad, rad, rad
        return self
    end,
    Radii = function(self, tl, tr, bl, br)
        TL, TR, BL, BR = tl or 0, tr or 0, bl or 0, br or 0
        return self
    end,
    Texture = function(self, texture)
        TEXTURE = texture
        return self
    end,
    Material = function(self, mat)
        if mat then
            local tex = mat:GetTexture("$basetexture")
            if tex then TEXTURE = tex end
        end
        return self
    end,
    Outline = function(self, thickness)
        OUTLINE_THICKNESS = thickness
        return self
    end,
    Shape = function(self, shape)
        SHAPE = shapes[shape] or 2.2
        return self
    end,
    Color = function(self, col_or_r, g, b, a)
        if isnumber(col_or_r) then
            COL_R, COL_G, COL_B, COL_A = col_or_r, g or 255, b or 255, a or 255
        else
            COL_R, COL_G, COL_B, COL_A = col_or_r.r, col_or_r.g, col_or_r.b, col_or_r.a
        end
        return self
    end,
    Blur = function(self, intensity)
        if not intensity then intensity = 1.0 end
        intensity = math_max(intensity, 0)
        USING_BLUR, BLUR_INTENSITY = true, intensity
        return self
    end,
    Rotation = function(self, angle)
        ROTATION = math.rad(angle or 0)
        return self
    end,
    StartAngle = function(self, angle)
        START_ANGLE = angle or 0
        return self
    end,
    EndAngle = function(self, angle)
        END_ANGLE = angle or 360
        return self
    end,
    Shadow = function(self, spread, intensity)
        SHADOW_ENABLED, SHADOW_SPREAD, SHADOW_INTENSITY = true, spread or 30, intensity or (spread or 30) * 1.2
        return self
    end,
    Clip = function(self, pnl)
        CLIP_PANEL = pnl
        return self
    end,
    Flags = function(self, flags)
        flags = flags or 0
        if bit_band(flags, NO_TL) ~= 0 then TL = 0 end
        if bit_band(flags, NO_TR) ~= 0 then TR = 0 end
        if bit_band(flags, NO_BL) ~= 0 then BL = 0 end
        if bit_band(flags, NO_BR) ~= 0 then BR = 0 end
        local shape_flag = bit_band(flags, SHAPE_CIRCLE + SHAPE_FIGMA + SHAPE_IOS)
        if shape_flag ~= 0 then SHAPE = shapes[shape_flag] or shapes[defaultShape] end
        if bit_band(flags, BLUR) ~= 0 then USING_BLUR, BLUR_INTENSITY = true, 1.0 end
        if bit_band(flags, manualColor) ~= 0 then COL_R = nil end
        return self
    end,
}

lia.derma.Rect = {
    Rad = lia.derma.baseFuncs.Rad,
    Radii = lia.derma.baseFuncs.Radii,
    Texture = lia.derma.baseFuncs.Texture,
    Material = lia.derma.baseFuncs.Material,
    Outline = lia.derma.baseFuncs.Outline,
    Shape = lia.derma.baseFuncs.Shape,
    Color = lia.derma.baseFuncs.Color,
    Blur = lia.derma.baseFuncs.Blur,
    Rotation = lia.derma.baseFuncs.Rotation,
    StartAngle = lia.derma.baseFuncs.StartAngle,
    EndAngle = lia.derma.baseFuncs.EndAngle,
    Clip = lia.derma.baseFuncs.Clip,
    Shadow = lia.derma.baseFuncs.Shadow,
    Flags = lia.derma.baseFuncs.Flags,
    Draw = function()
        if not TEXTURE and not USING_BLUR and not SHADOW_ENABLED and SHAPE == shapes[defaultShape] and OUTLINE_THICKNESS == -1 and START_ANGLE == 0 and END_ANGLE == 360 and not ROTATION and not CLIP_PANEL then
            surface_SetDrawColor(COL_R, COL_G, COL_B, COL_A)
            if TL > 0 then
                draw.RoundedBox(TL, X, Y, W, H, Color(COL_R, COL_G, COL_B, COL_A))
            else
                surface_DrawTexturedRect(X, Y, W, H)
            end
            return
        end

        if START_ANGLE == END_ANGLE then return end
        local OLD_CLIPPING_STATE
        if SHADOW_ENABLED or CLIP_PANEL then OLD_CLIPPING_STATE = DisableClipping(true) end
        if CLIP_PANEL then
            local sx, sy = CLIP_PANEL:LocalToScreen(0, 0)
            local sw, sh = CLIP_PANEL:GetSize()
            render.SetScissorRect(sx, sy, sx + sw, sy + sh, true)
        end

        if SHADOW_ENABLED then
            setupShadows()
            drawShadows(COL_R, COL_G, COL_B, COL_A)
        elseif USING_BLUR then
            drawBlur()
        else
            if TEXTURE then
                MAT = roundedTextureMat
                materialSetTexture(MAT, "$basetexture", TEXTURE)
            end

            setupDraw()
            surface_DrawTexturedRectUV(X, Y, W, H, -0.015625, -0.015625, 1.015625, 1.015625)
        end

        if CLIP_PANEL then render.SetScissorRect(0, 0, 0, 0, false) end
        if SHADOW_ENABLED or CLIP_PANEL then DisableClipping(OLD_CLIPPING_STATE) end
    end,
    GetMaterial = function()
        if SHADOW_ENABLED or USING_BLUR then error("You cannot get the material of a shadowed or blurred rectangle") end
        if TEXTURE then
            MAT = roundedTextureMat
            materialSetTexture(MAT, "$basetexture", TEXTURE)
        end

        setupDraw()
        return MAT
    end,
}

lia.derma.Circle = {
    Texture = lia.derma.baseFuncs.Texture,
    Material = lia.derma.baseFuncs.Material,
    Outline = lia.derma.baseFuncs.Outline,
    Color = lia.derma.baseFuncs.Color,
    Blur = lia.derma.baseFuncs.Blur,
    Rotation = lia.derma.baseFuncs.Rotation,
    StartAngle = lia.derma.baseFuncs.StartAngle,
    EndAngle = lia.derma.baseFuncs.EndAngle,
    Clip = lia.derma.baseFuncs.Clip,
    Shadow = lia.derma.baseFuncs.Shadow,
    Flags = lia.derma.baseFuncs.Flags,
    Draw = lia.derma.Rect.Draw,
    GetMaterial = lia.derma.Rect.GetMaterial,
}

lia.derma.Types = {
    Rect = function(x, y, w, h)
        resetParams()
        MAT = roundedMat
        X, Y, W, H = x, y, w, h
        return lia.derma.Rect
    end,
    Circle = function(x, y, r)
        resetParams()
        MAT = roundedMat
        SHAPE = shapes[SHAPE_CIRCLE]
        X, Y, W, H = x - r / 2, y - r / 2, r, r
        r = r / 2
        TL, TR, BL, BR = r, r, r, r
        return lia.derma.Circle
    end
}

--[[
    Purpose:
        Creates a chainable rounded rectangle draw builder.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Rectangle width.
        h (number)
            Rectangle height.

    Returns:
        table
            A `lia.derma.Rect` builder with chainable draw configuration methods.

    Example Usage:
        ```lua
        lia.derma.rect(20, 20, 160, 40):Rad(8):Color(Color(25, 28, 35, 240)):Draw()
        ```

    Realm:
        Client
]]
function lia.derma.rect(x, y, w, h)
    return lia.derma.Types.Rect(x, y, w, h)
end

--[[
    Purpose:
        Creates a chainable circle draw builder.

    Parameters:
        x (number)
            Circle center X coordinate.
        y (number)
            Circle center Y coordinate.
        r (number)
            Circle diameter used by the renderer.

    Returns:
        table
            A `lia.derma.Circle` builder with chainable draw configuration methods.

    Example Usage:
        ```lua
        lia.derma.circle(100, 100, 32):Color(color_white):Draw()
        ```

    Realm:
        Client
]]
function lia.derma.circle(x, y, r)
    return lia.derma.Types.Circle(x, y, r)
end

lia.derma.NO_TL = NO_TL
lia.derma.NO_TR = NO_TR
lia.derma.NO_BL = NO_BL
lia.derma.NO_BR = NO_BR
lia.derma.SHAPE_CIRCLE = SHAPE_CIRCLE
lia.derma.SHAPE_FIGMA = SHAPE_FIGMA
lia.derma.SHAPE_IOS = SHAPE_IOS
lia.derma.BLUR = BLUR
lia.derma.MANUAL_COLOR = manualColor
--[[
    Purpose:
        Adds or removes a bit flag from an existing flag mask. String flag names are resolved from `lia.derma` constants when present.

    Parameters:
        flags (number)
            Existing flag mask.
        flag (number|string)
            Flag value or `lia.derma` flag name.
        bool (any)
            Truthy value adds the flag; falsey value removes it.

    Returns:
        number
            The updated flag mask.

    Example Usage:
        ```lua
        flags = lia.derma.setFlag(flags or 0, "BLUR", true)
        ```

    Realm:
        Client
]]
function lia.derma.setFlag(flags, flag, bool)
    flag = lia.derma[flag] or flag
    if tobool(bool) then
        return bit.bor(flags, flag)
    else
        return bit.band(flags, bit.bnot(flag))
    end
end

--[[
    Purpose:
        Sets the default rounded shape flag used when draw calls do not supply an explicit shape.

    Parameters:
        shape (number|nil)
            Shape flag to use by default. Defaults to `lia.derma.SHAPE_FIGMA` when nil.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.setDefaultShape(lia.derma.SHAPE_IOS)
        ```

    Realm:
        Client
]]
function lia.derma.setDefaultShape(shape)
    defaultShape = shape or SHAPE_FIGMA
    defaultDrawFlags = defaultShape
end

local RNDX = {}
local RNDX_BASE = {
    Rect = lia.derma.rect,
    Circle = nil,
    Draw = lia.derma.draw,
    DrawOutlined = lia.derma.drawOutlined,
    DrawTexture = lia.derma.drawTexture,
    DrawMaterial = lia.derma.drawMaterial,
    DrawCircle = lia.derma.drawCircle,
    DrawCircleOutlined = lia.derma.drawCircleOutlined,
    DrawCircleTexture = lia.derma.drawCircleTexture,
    DrawCircleMaterial = lia.derma.drawCircleMaterial,
    DrawBlur = lia.derma.drawBlur,
    DrawShadowsEx = lia.derma.drawShadowsEx,
    DrawShadows = lia.derma.drawShadows,
    DrawShadowsOutlined = lia.derma.drawShadowsOutlined
}

lia.rndxBase = RNDX_BASE
local RNDX_RECT = RNDX_BASE.Rect
local RNDX_CIRCLE = lia.derma.circle
RNDX_BASE.Circle = function(x, y, radius) return RNDX_CIRCLE(x, y, radius * 2) end
RNDX.Rect = RNDX_RECT
RNDX.Circle = RNDX_BASE.Circle
RNDX.Draw = RNDX_BASE.Draw
RNDX.DrawOutlined = RNDX_BASE.DrawOutlined
RNDX.DrawTexture = RNDX_BASE.DrawTexture
RNDX.DrawMaterial = RNDX_BASE.DrawMaterial
RNDX.DrawCircle = RNDX_BASE.DrawCircle
RNDX.DrawCircleOutlined = RNDX_BASE.DrawCircleOutlined
RNDX.DrawCircleTexture = RNDX_BASE.DrawCircleTexture
RNDX.DrawCircleMaterial = RNDX_BASE.DrawCircleMaterial
RNDX.DrawBlur = RNDX_BASE.DrawBlur
RNDX.DrawShadowsEx = RNDX_BASE.DrawShadowsEx
RNDX.DrawShadows = RNDX_BASE.DrawShadows
RNDX.DrawShadowsOutlined = RNDX_BASE.DrawShadowsOutlined
RNDX.NO_TL = lia.derma.NO_TL
RNDX.NO_TR = lia.derma.NO_TR
RNDX.NO_BL = lia.derma.NO_BL
RNDX.NO_BR = lia.derma.NO_BR
RNDX.SHAPE_CIRCLE = lia.derma.SHAPE_CIRCLE
RNDX.SHAPE_FIGMA = lia.derma.SHAPE_FIGMA
RNDX.SHAPE_IOS = lia.derma.SHAPE_IOS
RNDX.BLUR = lia.derma.BLUR
RNDX.MANUAL_COLOR = lia.derma.MANUAL_COLOR
RNDX.SetFlag = lia.derma.setFlag
RNDX.SetDefaultShape = lia.derma.setDefaultShape
RNDX.SetLegacyGamma = function() end
RNDX.SetDefaultBlurIntensity = function() end
RNDX.GetDefaultBlurIntensity = function() return 1.0 end
lia.rndx = RNDX
return RNDX