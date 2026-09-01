lia = lia or {
    util = {},
    gui = {},
    meta = {},
    loader = {}
}

GM.Name = "Lilia"
GM.version = 7.612
GM.Author = "Samael"
GM.Website = "https://discord.gg/esCRH5ckbQ"
include("core/libraries/loader.lua")
local hints = {"Annoy1", "Annoy2", "OpeningMenu", "OpeningContext", "ContextClick", "PhysgunFreeze", "PhysgunUnfreeze", "PhysgunUse", "VehicleView", "ColorRoom", "EditingSpawnlists", "EditingSpawnlistsSave"}
for _, hint in ipairs(hints) do
    hook.Run("SuppressHint", hint)
end

function lia.error(msg)
    MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. "Error" .. "] ")
    MsgC(Color(255, 0, 0), tostring(msg), "\n")
end

function lia.warning(msg)
    MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. "Warning" .. "] ")
    MsgC(Color(255, 255, 0), tostring(msg), "\n")
end

function lia.information(msg)
    MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. "Information" .. "] ")
    MsgC(Color(83, 143, 239), tostring(msg), "\n")
end

function lia.bootstrap(section, msg)
    if lia.isReloading and section ~= "HotReload" then return end
    MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. "Bootstrap" .. "] ")
    MsgC(Color(0, 255, 0), "[" .. section .. "] ")
    MsgC(Color(255, 255, 255), tostring(msg), "\n")
end

function lia.debug(...)
    if not lia.DevMode then return end
    local args = {...}
    local prefixColor = Color(83, 143, 239)
    local debugColor = Color(255, 184, 77)
    local sectionColor = Color(0, 255, 0)
    local textColor = Color(220, 220, 220)
    local detailColor = Color(151, 211, 255)
    local separatorColor = Color(120, 120, 120)
    local boolColors = {
        ["true"] = Color(110, 255, 140),
        ["false"] = Color(255, 120, 120)
    }

    local function writeValue(value)
        local text = tostring(value)
        MsgC(boolColors[text] or textColor, text)
    end

    local function isKeyToken(value)
        local text = tostring(value)
        return text:sub(-1) == "=" and #text > 1
    end

    MsgC(prefixColor, "[Lilia] ", debugColor, "[" .. "Debug" .. "] ")
    local index = 1
    if isstring(args[1]) and args[1]:match("^%b[]$") then
        MsgC(sectionColor, args[1], " ")
        index = 2
    end

    if args[index] ~= nil then
        writeValue(args[index])
        index = index + 1
    end

    while index <= #args do
        MsgC(separatorColor, " | ")
        if args[index + 1] ~= nil and isKeyToken(args[index]) then
            MsgC(detailColor, tostring(args[index]))
            writeValue(args[index + 1])
            index = index + 2
        else
            writeValue(args[index])
            index = index + 1
        end
    end

    MsgC(textColor, "\n")
end
