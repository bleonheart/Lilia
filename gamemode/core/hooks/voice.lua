local TalkRanges = {
    ["Whispering"] = 120,
    ["Talking"] = 300,
    ["Yelling"] = 600,
}

if SERVER then
    function GM:PlayerCanHearPlayersVoice(listener, speaker)
        if not IsValid(listener) and IsValid(speaker) or listener == speaker then return false, false end
        if speaker:getNetVar("IsDeadRestricted", false) then return false, false end
        if speaker:getNetVar("liaGagged", false) then return false, false end
        if speaker:getLiliaData("VoiceBan", false) then return false, false end
        if not lia.config.get("IsVoiceEnabled", true) then return false, false end
        local voiceType = speaker:getNetVar("VoiceType", "Talking")
        local range = TalkRanges[voiceType] or TalkRanges["Talking"]
        local distanceSqr = listener:GetPos():DistToSqr(speaker:GetPos())
        local canHear = distanceSqr <= range * range
        return canHear, canHear
    end
else
    function GM:PostDrawOpaqueRenderables()
        if not lia.option.get("voiceRange", false) then return end
        local client = LocalPlayer()
        if not (IsValid(client) and client:IsSpeaking() and client:getChar()) then return end
        local vt = client:getNetVar("VoiceType", "Talking")
        local radius = TalkRanges[vt] or TalkRanges.Talking
        local segments = 36
        local pos = client:GetPos() + Vector(0, 0, 2)
        local color = Color(0, 150, 255)
        render.SetColorMaterial()
        for i = 0, segments - 1 do
            local startAng = math.rad(i / segments * 360)
            local endAng = math.rad((i + 1) / segments * 360)
            local startPos = pos + Vector(math.cos(startAng), math.sin(startAng), 0) * radius
            local endPos = pos + Vector(math.cos(endAng), math.sin(endAng), 0) * radius
            render.DrawLine(startPos, endPos, color, false)
        end
    end
end