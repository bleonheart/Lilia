DeriveGamemode("sandbox")
include("shared.lua")
concommand.Add("lia_check_fonts", function()
    local fonts = {"resource/fonts/specialelite.ttf", "resource/fonts/montserrat-bold.ttf", "resource/fonts/montserrat-medium.ttf", "resource/fonts/montserrat-regular.ttf"}
    print("========== Lilia Font Check ==========")
    for _, v in ipairs(fonts) do
        local exists = file.Exists(v, "GAME")
        if exists then
            local size = file.Size(v, "GAME")
            print(string.format("[FOUND] %s (%s bytes)", v, size))
        else
            print(string.format("[MISSING] %s", v))
        end
    end

    print("======================================")
end)

local function GetModelCandidates(model)
    local candidates = {model}
    if string.StartWith(model, "download/") then candidates[#candidates + 1] = string.sub(model, 10) end
    return candidates
end

local function FindModelSource(model)
    local candidates = GetModelCandidates(model)
    for _, addon in ipairs(engine.GetAddons()) do
        if not addon.mounted then continue end
        for _, path in ipairs(candidates) do
            if file.Exists(path, addon.title) then
                return {
                    type = "workshop",
                    title = addon.title,
                    wsid = addon.wsid,
                    file = addon.file,
                    path = path
                }
            end
        end
    end

    for _, path in ipairs(candidates) do
        if file.Exists(path, "DOWNLOAD") then
            return {
                type = "download",
                path = path
            }
        end
    end

    for _, path in ipairs(candidates) do
        if file.Exists(path, "MOD") then
            return {
                type = "garrysmod",
                path = path
            }
        end
    end

    for _, path in ipairs(candidates) do
        if file.Exists(path, "WORKSHOP") then
            return {
                type = "workshop_unknown",
                path = path
            }
        end
    end

    for _, path in ipairs(candidates) do
        if file.Exists(path, "GAME") then
            return {
                type = "mounted",
                path = path
            }
        end
    end
    return nil
end

concommand.Add("modelpack", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then
        print("[ModelPack] Invalid player.")
        return
    end

    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) then
        print("[ModelPack] You are not looking at a valid entity.")
        return
    end

    local model = ent:GetModel()
    if not model or model == "" then
        print("[ModelPack] This entity does not have a model.")
        return
    end

    print("[ModelPack] Entity: " .. tostring(ent))
    print("[ModelPack] Class: " .. ent:GetClass())
    print("[ModelPack] Model: " .. model)
    local source = FindModelSource(model)
    if not source then
        print("[ModelPack] Source could not be determined.")
        return
    end

    if source.type == "workshop" then
        print("[ModelPack] Source: Workshop addon")
        print("[ModelPack] Addon: " .. source.title)
        print("[ModelPack] Workshop ID: " .. source.wsid)
        print("[ModelPack] GMA: " .. source.file)
        print("[ModelPack] Internal path: " .. source.path)
        print("[ModelPack] Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. source.wsid)
        return
    end

    if source.type == "download" then
        print("[ModelPack] Source: Downloaded server content / FastDL")
        print("[ModelPack] Path: download/" .. source.path)
        return
    end

    if source.type == "garrysmod" then
        print("[ModelPack] Source: Garry's Mod files")
        print("[ModelPack] Path: " .. source.path)
        return
    end

    if source.type == "workshop_unknown" then
        print("[ModelPack] Source: Workshop content")
        print("[ModelPack] Could not determine the individual addon.")
        print("[ModelPack] Path: " .. source.path)
        return
    end

    print("[ModelPack] Source: Mounted game/content")
    print("[ModelPack] Path: " .. source.path)
end)