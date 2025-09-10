# lia.time

## Overview
The `lia.time` library provides time-related utility functions for Lilia, including time formatting, date parsing, and time calculations.

## Functions

### lia.time.TimeSince
**Purpose**: Calculates the time elapsed since a given timestamp (Shared).

**Parameters**:
- `strTime` (string|number): Time string or timestamp

**Returns**: String describing time elapsed

**Realm**: Shared

**Example Usage**:
```lua
-- Calculate time since timestamp
local timeAgo = lia.time.TimeSince(1640995200) -- Unix timestamp
print("Time since:", timeAgo) -- "2 hours ago"

-- Calculate time since date string
local timeAgo = lia.time.TimeSince("2023-01-01")
print("Time since:", timeAgo) -- "30 days ago"

-- Use in UI
local lastLogin = player:getData("lastLogin", 0)
local timeSince = lia.time.TimeSince(lastLogin)
local label = vgui.Create("DLabel")
label:SetText("Last login: " .. timeSince)
```

### lia.time.toNumber
**Purpose**: Converts a time string to a table of time components (Shared).

**Parameters**:
- `str` (string): Time string in format "YYYY-MM-DD HH:MM:SS" (optional, defaults to current time)

**Returns**: Table with year, month, day, hour, min, sec

**Realm**: Shared

**Example Usage**:
```lua
-- Convert current time
local timeData = lia.time.toNumber()
print("Year:", timeData.year)
print("Month:", timeData.month)
print("Day:", timeData.day)

-- Convert specific time string
local timeData = lia.time.toNumber("2023-12-25 15:30:45")
print("Christmas 2023 at 3:30 PM")

-- Use in calculations
local timeData = lia.time.toNumber("2023-01-01 00:00:00")
local currentTime = lia.time.toNumber()
local daysSince = currentTime.day - timeData.day
print("Days since New Year:", daysSince)
```

### lia.time.GetDate
**Purpose**: Gets a formatted date string (Shared).

**Parameters**: None

**Returns**: String with formatted date

**Realm**: Shared

**Example Usage**:
```lua
-- Get current date
local date = lia.time.GetDate()
print("Current date:", date) -- "Monday, 25 December 2023, 15:30:45"

-- Use in UI
local dateLabel = vgui.Create("DLabel")
dateLabel:SetText(lia.time.GetDate())
dateLabel:SetFont("liaMediumFont")

-- Use in logs
lia.log.add("System", "info", "Server started at " .. lia.time.GetDate())
```

### lia.time.formatDHM
**Purpose**: Formats seconds into days, hours, and minutes (Shared).

**Parameters**:
- `seconds` (number): Number of seconds to format

**Returns**: String with formatted time

**Realm**: Shared

**Example Usage**:
```lua
-- Format seconds
local formatted = lia.time.formatDHM(90061) -- 1 day, 1 hour, 1 minute
print("Formatted time:", formatted) -- "1 day, 1 hour, 1 minute"

-- Format different amounts
local time1 = lia.time.formatDHM(3600) -- 1 hour
local time2 = lia.time.formatDHM(86400) -- 1 day
local time3 = lia.time.formatDHM(3661) -- 1 hour, 1 minute

-- Use in UI
local cooldown = 7200 -- 2 hours
local cooldownText = lia.time.formatDHM(cooldown)
local label = vgui.Create("DLabel")
label:SetText("Cooldown: " .. cooldownText)
```

### lia.time.GetHour
**Purpose**: Gets the current hour in 12 or 24 hour format (Shared).

**Parameters**: None

**Returns**: String with current hour

**Realm**: Shared

**Example Usage**:
```lua
-- Get current hour
local hour = lia.time.GetHour()
print("Current hour:", hour) -- "3 PM" or "15"

-- Use in time-based logic
local hour = lia.time.GetHour()
if tonumber(hour) >= 18 then
    print("It's evening time")
end

-- Use in UI
local hourLabel = vgui.Create("DLabel")
hourLabel:SetText("Current time: " .. lia.time.GetHour())
```
