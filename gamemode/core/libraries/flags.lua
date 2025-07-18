﻿lia.flag = lia.flag or {}
lia.flag.list = lia.flag.list or {}
function lia.flag.add(flag, desc, callback)
    if lia.flag.list[flag] then return end
    lia.flag.list[flag] = {
        desc = desc,
        callback = callback
    }
end

if SERVER then
    function lia.flag.onSpawn(client)
        if client:getChar() then
            local flags = client:getChar():getFlags()
            for i = 1, #flags do
                local flag = flags:sub(i, i)
                local info = lia.flag.list[flag]
                if info and info.callback then info.callback(client, true) end
            end
        end
    end
end

lia.flag.add("C", L("flagSpawnVehicles"))
lia.flag.add("z", L("flagSpawnSweps"))
lia.flag.add("E", L("flagSpawnSents"))
lia.flag.add("L", L("flagSpawnEffects"))
lia.flag.add("r", L("flagSpawnRagdolls"))
lia.flag.add("e", L("flagSpawnProps"))
lia.flag.add("n", L("flagSpawnNpcs"))
lia.flag.add("Z", L("flagInviteToYourFaction"))
lia.flag.add("X", L("flagInviteToYourClass"))
lia.flag.add("p", L("flagPhysgun"), function(client, isGiven)
    if isGiven then
        client:Give("weapon_physgun")
        client:SelectWeapon("weapon_physgun")
    else
        client:StripWeapon("weapon_physgun")
    end
end)

lia.flag.add("t", L("flagToolgun"), function(client, isGiven)
    if isGiven then
        client:Give("gmod_tool")
        client:SelectWeapon("gmod_tool")
    else
        client:StripWeapon("gmod_tool")
    end
end)

hook.Add("CreateInformationButtons", "liaInformationFlags", function(pages)
    local client = LocalPlayer()
    table.insert(pages, {
        name = L("flags"),
        drawFunc = function(panel)
            local searchEntry = vgui.Create("DTextEntry", panel)
            searchEntry:Dock(TOP)
            searchEntry:SetTall(30)
            searchEntry:SetPlaceholderText(L("searchFlags"))
            local scroll = vgui.Create("DScrollPanel", panel)
            scroll:Dock(FILL)
            local canvas = scroll:GetCanvas()
            local function refresh()
                canvas:Clear()
                local filter = searchEntry:GetValue():lower()
                for flagName, flagData in SortedPairs(lia.flag.list) do
                    if isnumber(flagName) then continue end
                    local nameLower = flagName:lower()
                    local descLower = (flagData.desc or ""):lower()
                    if filter ~= "" and not (nameLower:find(filter, 1, true) or descLower:find(filter, 1, true)) then continue end
                    local hasDesc = flagData.desc and flagData.desc ~= ""
                    local height = hasDesc and 80 or 40
                    local flagPanel = vgui.Create("DPanel", canvas)
                    flagPanel:Dock(TOP)
                    flagPanel:DockMargin(10, 5, 10, 0)
                    flagPanel:SetTall(height)
                    flagPanel.Paint = function(pnl, w, h)
                        local hasFlag = client:getChar():hasFlags(flagName)
                        derma.SkinHook("Paint", "Panel", pnl, w, h)
                        draw.SimpleText(L("flagLabel", flagName), "liaMediumFont", 20, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local icon = hasFlag and "checkboxfilled.png" or "checkboxfilled_crossed.png"
                        lia.util.drawTexture(icon, color_white, w - 42, h * 0.5 - 16, 32, 32)
                        if hasDesc then draw.SimpleText(flagData.desc, "liaSmallFont", 20, 45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end
                    end
                end

                canvas:InvalidateLayout(true)
                canvas:SizeToChildren(false, true)
            end

            searchEntry.OnTextChanged = refresh
            refresh()
        end
    })
end)
