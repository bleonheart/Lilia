local function stripAgo(timeSince)
    local agoStr = L("ago")
    local suffix = " " .. agoStr
    if timeSince:sub(-#suffix) == suffix then return timeSince:sub(1, -#suffix - 1) end
    return timeSince
end

