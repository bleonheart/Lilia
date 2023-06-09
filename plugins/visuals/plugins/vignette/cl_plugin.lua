local vignette = lia.util.getMaterial("lilia/gui/vignette.png")
local vignetteAlphaGoal = 0
local vignetteAlphaDelta = 0
local hasVignetteMaterial = vignette ~= "___error"
local mathApproach = math.Approach

timer.Create("liaVignetteChecker", 1, 0, function()
    local client = LocalPlayer()

    if IsValid(client) then
        local data = {}
        data.start = client:GetPos()
        data.endpos = data.start + Vector(0, 0, 768)
        data.filter = client
        local trace = util.TraceLine(data)

        if trace and trace.Hit then
            vignetteAlphaGoal = 80
        else
            vignetteAlphaGoal = 0
        end
    end
end)

function PLUGIN:HUDPaintBackground()
    local frameTime = FrameTime()
    local scrW, scrH = ScrW(), ScrH()

    if hasVignetteMaterial and lia.config.get("vignette") then
        vignetteAlphaDelta = mathApproach(vignetteAlphaDelta, vignetteAlphaGoal, frameTime * 30)
        surface.SetDrawColor(0, 0, 0, 175 + vignetteAlphaDelta)
        surface.SetMaterial(vignette)
        surface.DrawTexturedRect(0, 0, scrW, scrH)
    end
end