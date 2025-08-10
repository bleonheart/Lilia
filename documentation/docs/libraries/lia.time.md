# Time Library

This page lists time- and date-utilities.

---

## Overview

The time library formats dates and converts relative times using Lua's built-in `os.date` and `os.time` functions. It provides helpers for phrases such as "time since."

---

### lia.time.TimeSince

**Purpose**

Returns a localized string describing how long ago a given time occurred (for example, "5 minutes ago").

**Parameters**

* `strTime` (*number | string*): Time to measure from.

  * Numbers are UNIX timestamps.

  * Strings are parsed with `lia.time.ParseTime` and must yield `year`, `month`, and `day`. The time-of-day is ignored (set to midnight).

**Realm**

`Shared`

**Returns**

* *string*: Localized "time since" string. The difference is truncated to seconds, minutes, hours or days (`<60`, `<3600`, `<86400`, `>=86400`).

**Example Usage**

```lua
-- Greet joining players with the time since they last logged in
hook.Add("PlayerInitialSpawn", "welcomeLastSeen", function(ply)
    local key  = "lastLogin_" .. ply:SteamID64()
    local last = lia.data.get(key, nil)

    if last then
        ply:ChatPrint(("Welcome back! You last joined %s."):format(lia.time.TimeSince(last)))
    else
        ply:ChatPrint("Welcome for the first time!")
    end

    lia.data.set(key, os.time(), true)
end)
```

**Edge Cases**

* Returns `L("invalidDate")` if the string cannot be parsed.
* Returns `L("invalidInput")` for non-number, non-string inputs.
* Future dates produce negative values in the returned string.

---

### lia.time.toNumber

**Purpose**

Parses a timestamp string (`YYYY-MM-DD HH:MM:SS`) into its numeric components. If no argument is given, uses the current time via `os.date("%Y-%m-%d %H:%M:%S", os.time())`.

**Parameters**

* `str` (*string*): Timestamp string. *Optional*.

**Realm**

`Shared`

**Returns**

* *table*: `{ year, month, day, hour, min, sec }` — keys are numbers. No validation is performed on the input string; malformed strings yield `nil` fields.

**Example Usage**

```lua
-- Schedule an event for 1 April 2025 12:30
local tInfo     = lia.time.toNumber("2025-04-01 12:30:00")
local timestamp = os.time(tInfo)
local delay     = timestamp - os.time()

if delay > 0 then
    timer.Simple(delay, function()
        print("It is now April 1st 2025, 12:30 PM!")
    end)
end
```

---

### lia.time.GetDate

**Purpose**

Returns the full current date/time using the `AmericanTimeStamps` config (defaults to `false`):

* **Enabled**: `"Weekday, Month DD, YYYY, HH:MM:SSam/pm"` (12-hour clock, localized `am`/`pm` suffix)

* **Disabled**: `"Weekday, DD Month YYYY, HH:MM:SS"` (24-hour clock)

**Parameters**

* *None*

**Realm**

`Shared`

**Returns**

* *string*: Formatted current date/time with localized weekday and month names.

**Example Usage**

```lua
-- Announce the current server date every hour
timer.Create("ServerTimeAnnounce", 3600, 0, function()
    local text = lia.time.GetDate()
    for _, ply in player.Iterator() do
        ply:ChatPrint("Server time: " .. text)
    end
end)
```

---

### lia.time.formatDHM

**Purpose**

Formats a number of seconds into a localized string describing days, hours, and minutes.

**Parameters**

* `seconds` (*number*): Seconds to convert. Negative or `nil` values are treated as `0`.

**Realm**

`Shared`

**Returns**

* *string*: Localized "X days Y hours Z minutes" string. Remaining seconds are discarded.

**Example Usage**

```lua
-- Display a ban length
print(lia.time.formatDHM(90061)) -- "1 days 1 hours 1 minutes"
```

---

### lia.time.GetHour

**Purpose**

Returns the current hour formatted by `AmericanTimeStamps`:

* **Enabled** → string in the format `"Ham"`/`"Hpm"` (e.g. `"3pm"`, midnight is `"12am"`)

* **Disabled** → integer `0–23` (24-hour clock)

**Parameters**

* *None*

**Realm**

`Shared`

**Returns**

* *string | number*: Hour with suffix (`"am"`/`"pm"`) or 24-hour integer.

**Example Usage**

```lua
-- Toggle an NPC shop by hour
timer.Create("CheckShopHours", 60, 0, function()
    local hour = lia.time.GetHour() -- could be "3pm" or 15
    local hNum = tonumber(hour)
        or tonumber(hour:sub(1, -3)) % 12 + (hour:sub(-2) == "pm" and 12 or 0) -- convert if am/pm
    npc:SetNWBool("ShopOpen", hNum >= 9 and hNum < 17)
end)
```

---

### CurTime Synchronisation

**Purpose**

Keeps `CurTime()` on clients aligned with the server's `CurTime()`.

**Server Behaviour**

* A timer `CurTimeSync` runs every 30 seconds and broadcasts the current `CurTime()` via the network message `"CurTimeSync"`.

**Client Behaviour**

* On `InitPostEntity`, a net receiver for `"CurTime-Sync"` stores the difference between the client's `CurTime()` and the server's value.
* The global `CurTime()` function is overridden to subtract this offset, effectively returning server time.

**Edge Cases**

* The server sends `"CurTimeSync"` but the client listens for `"CurTime-Sync"`; without matching identifiers the synchronisation will not occur.

---
