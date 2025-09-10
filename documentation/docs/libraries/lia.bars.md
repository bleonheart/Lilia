# Bars Library

This page documents the functions for working with HUD bars and progress indicators.

---

## Overview

The bars library (`lia.bar`) provides a system for creating and managing HUD bars that display various character statistics and progress indicators. It handles bar creation, removal, drawing, and animation with smooth transitions. The library is commonly used for health bars, armor bars, and other visual indicators that show character status.

---

### lia.bar.get

**Purpose**

Retrieves a bar object by its identifier.

**Parameters**

* `identifier` (*string*): The unique identifier of the bar to retrieve.

**Returns**

* `bar` (*table*): The bar object if found, nil otherwise.

**Realm**

Client.

**Example Usage**

```lua
-- Get a specific bar by identifier
local healthBar = lia.bar.get("health")
if healthBar then
    print("Health bar found with color: " .. tostring(healthBar.color))
end

-- Check if a bar exists before modifying it
local customBar = lia.bar.get("myCustomBar")
if customBar then
    customBar.visible = true
end
```

---

### lia.bar.add

**Purpose**

Adds a new bar to the HUD with specified properties.

**Parameters**

* `getValue` (*function*): A function that returns the current value (0-1) for the bar.
* `color` (*Color*, *optional*): The color of the bar. If not provided, a random color is generated.
* `priority` (*number*, *optional*): The drawing priority of the bar. Lower numbers draw first.
* `identifier` (*string*, *optional*): A unique identifier for the bar. If provided and a bar with this ID exists, it will be replaced.

**Returns**

* `priority` (*number*): The priority assigned to the bar.

**Realm**

Client.

**Example Usage**

```lua
-- Add a simple health bar
lia.bar.add(function()
    local client = LocalPlayer()
    return client:Health() / client:GetMaxHealth()
end, Color(200, 50, 40), 1, "health")

-- Add a custom stamina bar
lia.bar.add(function()
    local char = LocalPlayer():getChar()
    if not char then return 0 end
    return char:getAttrib("stamina", 0) / 100
end, Color(50, 200, 50), 2, "stamina")

-- Add a bar without identifier (will be auto-assigned)
lia.bar.add(function()
    return 0.75 -- 75% full
end, Color(255, 255, 0), 5)

-- Add a bar with custom properties
local barPriority = lia.bar.add(function()
    local char = LocalPlayer():getChar()
    if not char then return 0 end
    return char:getAttrib("hunger", 0) / 100
end, Color(255, 165, 0), 3, "hunger")
print("Hunger bar added with priority: " .. barPriority)
```

---

### lia.bar.remove

**Purpose**

Removes a bar from the HUD by its identifier.

**Parameters**

* `identifier` (*string*): The unique identifier of the bar to remove.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Remove a specific bar
lia.bar.remove("stamina")

-- Remove a custom bar
lia.bar.remove("myCustomBar")

-- Conditionally remove bars
if not LocalPlayer():getChar() then
    lia.bar.remove("hunger")
    lia.bar.remove("thirst")
end
```

---

### lia.bar.drawBar

**Purpose**

Draws a single bar at the specified position with given properties.

**Parameters**

* `x` (*number*): The x-coordinate for the bar.
* `y` (*number*): The y-coordinate for the bar.
* `w` (*number*): The width of the bar.
* `h` (*number*): The height of the bar.
* `pos` (*number*): The current position/value of the bar (0-1).
* `max` (*number*): The maximum value of the bar (usually 1).
* `color` (*Color*): The color of the bar.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Draw a custom bar manually
local barX, barY = 100, 100
local barW, barH = 200, 20
local currentValue = 0.75
local maxValue = 1
local barColor = Color(255, 0, 0)

lia.bar.drawBar(barX, barY, barW, barH, currentValue, maxValue, barColor)

-- Draw a bar in a custom HUD element
hook.Add("HUDPaint", "CustomBarDraw", function()
    local char = LocalPlayer():getChar()
    if char then
        local hunger = char:getAttrib("hunger", 0) / 100
        lia.bar.drawBar(10, 10, 150, 15, hunger, 1, Color(255, 165, 0))
    end
end)
```

---

### lia.bar.drawAction

**Purpose**

Draws a temporary action bar that shows progress for a specific action over time.

**Parameters**

* `text` (*string*): The text to display above the action bar.
* `duration` (*number*): The duration in seconds for the action bar to complete.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Show a progress bar for an action
lia.bar.drawAction("Crafting item...", 5.0)

-- Show a progress bar for a skill check
lia.bar.drawAction("Lockpicking...", 3.5)

-- Show a progress bar for a medical action
lia.bar.drawAction("Applying bandage...", 2.0)

-- Use in a hook for player actions
hook.Add("PlayerStartAction", "ShowActionBar", function(ply, action, duration)
    if ply == LocalPlayer() then
        lia.bar.drawAction(action, duration)
    end
end)
```

---

### lia.bar.drawAll

**Purpose**

Draws all registered bars in their priority order. This function is automatically called by the HUD system.

**Parameters**

* `nil`

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Manually draw all bars (usually not needed as it's automatic)
lia.bar.drawAll()

-- Override the default bar drawing behavior
hook.Add("HUDPaintBackground", "CustomBarDraw", function()
    -- Custom logic before drawing bars
    if not hook.Run("ShouldHideBars") then
        lia.bar.drawAll()
    end
end)

-- Add custom bar drawing conditions
hook.Add("ShouldBarDraw", "CustomBarConditions", function(bar)
    if bar.identifier == "stamina" then
        local char = LocalPlayer():getChar()
        return char and char:getAttrib("stamina", 0) < 100
    end
    return true
end)
```