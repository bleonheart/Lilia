--[[
    Bars Library

    Dynamic progress bar creation and management system for the Lilia framework.
]]
--[[
    Overview:
        The bars library provides a comprehensive system for creating and managing dynamic progress bars in the Lilia framework. It handles the creation, rendering, and lifecycle management of various types of bars including health, armor, and custom progress indicators. The library operates primarily on the client side, providing smooth animated transitions between bar values and intelligent visibility management based on value changes and user preferences. It includes built-in health and armor bars, custom action progress displays, and a flexible system for adding custom bars with priority-based ordering. The library ensures consistent visual presentation across all bar types while providing hooks for customization and integration with other framework components.
]]
local surfaceSetDrawColor, surfaceDrawRect, surfaceDrawOutlinedRect = surface.SetDrawColor, surface.DrawRect, surface.DrawOutlinedRect
lia.bar = lia.bar or {}
lia.bar.delta = lia.bar.delta or {}
lia.bar.values = lia.bar.values or {}
lia.bar.list = {}
lia.bar.counter = lia.bar.counter or 0
local function findIndexByIdentifier(identifier)
    for idx, bar in ipairs(lia.bar.list) do
        if bar.identifier == identifier then return idx end
    end
end

--[[
    Purpose:
        Retrieves a bar by its identifier from the bars list.

    When Called:
        When needing to access or modify a specific bar that was previously added.

    Parameters:
        - identifier (string): The unique identifier of the bar to retrieve.

    Returns:
        Bar object if found, nil otherwise.

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a bar by identifier
        local healthBar = lia.bar.get("health")
        if healthBar then
            print("Health bar color:", healthBar.color)
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Check if a custom bar exists and modify it
        local customBar = lia.bar.get("stamina")
        if customBar then
            customBar.color = Color(100, 200, 100)
            print("Updated stamina bar color")
        else
            print("Stamina bar not found")
        end
        ```

        High Complexity:

        ```lua
        -- High: Iterate through multiple bars and find specific ones
        local barIdentifiers = {"health", "armor", "stamina", "hunger"}
        local foundBars = {}

        for _, identifier in ipairs(barIdentifiers) do
            local bar = lia.bar.get(identifier)
            if bar then
                table.insert(foundBars, bar)
            end
        end

        print("Found", #foundBars, "bars out of", #barIdentifiers)
        ```
]]
function lia.bar.get(identifier)
    for _, bar in ipairs(lia.bar.list) do
        if bar.identifier == identifier then return bar end
    end
end

--[[
    Purpose:
        Adds a new progress bar to the bars system or updates an existing one.

    When Called:
        When creating custom progress bars for health, armor, stamina, hunger, etc., or when updating existing bars.

    Parameters:
        - getValue (function): Function that returns the current value (0-1) for the bar.
        - color (Color): The color of the bar (optional, random color if not provided).
        - priority (number): Display priority/order of the bar (optional, defaults to next available).
        - identifier (string): Unique identifier for the bar (optional, allows updating/removing specific bars).

    Returns:
        The priority number assigned to the bar.

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Add a basic health bar
        lia.bar.add(function()
            return LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
        end, Color(200, 50, 40), 1, "health")
        ```

        Medium Complexity:

        ```lua
        -- Medium: Add a stamina bar with custom priority
        lia.bar.add(function()
            return LocalPlayer():GetNWFloat("stamina", 1)
        end, Color(100, 200, 100), 2, "stamina")
        ```

        High Complexity:

        ```lua
        -- High: Add a complex bar with dynamic color and priority
        local function getHungerValue()
            local hunger = LocalPlayer():GetNWFloat("hunger", 100)
            return math.Clamp(hunger / 100, 0, 1)
        end

        local hungerColor = Color(150, 100, 50)
        local hungerPriority = 3
        local hungerID = "hunger"

        lia.bar.add(getHungerValue, hungerColor, hungerPriority, hungerID)

        -- Later update the same bar
        lia.bar.add(function()
            return math.Clamp(LocalPlayer():GetNWFloat("hunger", 100) / 100, 0, 1)
        end, Color(200, 50, 50), hungerPriority, hungerID)
        ```
]]
function lia.bar.add(getValue, color, priority, identifier)
    if identifier then
        local existingIdx = findIndexByIdentifier(identifier)
        if existingIdx then table.remove(lia.bar.list, existingIdx) end
    end

    priority = priority or #lia.bar.list + 1
    lia.bar.counter = lia.bar.counter + 1
    table.insert(lia.bar.list, {
        getValue = getValue,
        color = color or Color(math.random(150, 255), math.random(150, 255), math.random(150, 255)),
        priority = priority,
        lifeTime = 0,
        identifier = identifier,
        order = lia.bar.counter
    })
    return priority
end

--[[
    Purpose:
        Removes a bar from the bars system by its identifier.

    When Called:
        When needing to remove a specific bar that was previously added, such as when a temporary bar is no longer needed.

    Parameters:
        - identifier (string): The unique identifier of the bar to remove.

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Remove a stamina bar
        lia.bar.remove("stamina")
        ```

        Medium Complexity:

        ```lua
        -- Medium: Remove a bar if it exists
        if lia.bar.get("temporary_buff") then
            lia.bar.remove("temporary_buff")
            print("Temporary buff bar removed")
        end
        ```

        High Complexity:

        ```lua
        -- High: Remove multiple bars with validation
        local barsToRemove = {"stamina", "hunger", "thirst", "mana"}
        local removedCount = 0

        for _, identifier in ipairs(barsToRemove) do
            if lia.bar.get(identifier) then
                lia.bar.remove(identifier)
                removedCount = removedCount + 1
                print("Removed bar:", identifier)
            else
                print("Bar not found:", identifier)
            end
        end

        print("Successfully removed", removedCount, "bars")
        ```
]]
function lia.bar.remove(identifier)
    local idx = findIndexByIdentifier(identifier)
    if idx then table.remove(lia.bar.list, idx) end
end

local function PaintPanel(x, y, w, h)
    surfaceSetDrawColor(0, 0, 0, 255)
    surfaceDrawOutlinedRect(x, y, w, h)
    surfaceSetDrawColor(0, 0, 0, 150)
    surfaceDrawRect(x + 1, y + 1, w - 2, h - 2)
end

--[[
    Purpose:
        Draws a progress bar at the specified position with given dimensions and values.

    When Called:
        Internally by the bars system when rendering individual bars, or can be called directly for custom bar rendering.

    Parameters:
        - x (number): X position of the bar.
        - y (number): Y position of the bar.
        - w (number): Width of the bar.
        - h (number): Height of the bar.
        - pos (number): Current value of the bar.
        - max (number): Maximum value of the bar.
        - color (Color): Color of the filled portion of the bar.

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Draw a basic health bar
        lia.bar.drawBar(10, 10, 200, 20, 75, 100, Color(200, 50, 40))
        ```

        Medium Complexity:

        ```lua
        -- Medium: Draw a bar with calculated position
        local barX = ScrW() * 0.1
        local barY = ScrH() * 0.8
        local barWidth = ScrW() * 0.2
        local barHeight = 16

        local currentValue = LocalPlayer():Health()
        local maxValue = LocalPlayer():GetMaxHealth()

        lia.bar.drawBar(barX, barY, barWidth, barHeight, currentValue, maxValue, Color(255, 100, 100))
        ```

        High Complexity:

        ```lua
        -- High: Draw multiple bars with different calculations and colors
        local bars = {
            {name = "Health", value = LocalPlayer():Health(), max = LocalPlayer():GetMaxHealth(), color = Color(200, 50, 40)},
            {name = "Armor", value = LocalPlayer():Armor(), max = LocalPlayer():GetMaxArmor(), color = Color(30, 70, 180)},
            {name = "Stamina", value = LocalPlayer():GetNWFloat("stamina", 100), max = 100, color = Color(100, 200, 100)}
        }

        local startX = ScrW() * 0.05
        local startY = ScrH() * 0.75
        local barWidth = ScrW() * 0.25
        local barHeight = 18
        local spacing = 25

        for i, barData in ipairs(bars) do
            local yPos = startY + (i - 1) * spacing
            lia.bar.drawBar(startX, yPos, barWidth, barHeight, barData.value, barData.max, barData.color)

            -- Draw label
            draw.SimpleText(barData.name, "liaMediumFont", startX, yPos - 20, Color(240, 240, 240))
        end
        ```
]]
function lia.bar.drawBar(x, y, w, h, pos, max, color)
    pos = math.min(pos, max)
    local usable = math.max(w - 6, 0)
    local fill = usable * pos / max
    PaintPanel(x, y, w + 6, h)
    surfaceSetDrawColor(color.r, color.g, color.b)
    surfaceDrawRect(x + 3, y + 3, fill, h - 6)
end

--[[
    Purpose:
        Draws a temporary action progress bar that automatically disappears after the specified duration.

    When Called:
        When displaying temporary progress indicators for actions like lockpicking, hacking, crafting, etc.

    Parameters:
        - text (string): The text to display above the action bar.
        - duration (number): How long the action bar should be visible in seconds.

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Show a basic action bar for 3 seconds
        lia.bar.drawAction("Picking lock...", 3)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Show action bar with dynamic text
        local actionText = "Cooking " .. recipeName
        local cookTime = recipe.cookTime or 5
        lia.bar.drawAction(actionText, cookTime)
        ```

        High Complexity:

        ```lua
        -- High: Show action bar with multiple steps and callbacks
        local function startComplexAction()
            local steps = {
                {text = "Analyzing target...", duration = 2},
                {text = "Bypassing security...", duration = 3},
                {text = "Extracting data...", duration = 4},
                {text = "Cleaning traces...", duration = 1}
            }

            local currentStep = 1

            local function nextStep()
                if currentStep <= #steps then
                    local step = steps[currentStep]
                    lia.bar.drawAction(step.text, step.duration)

                    -- Schedule next step
                    timer.Simple(step.duration, function()
                        currentStep = currentStep + 1
                        nextStep()
                    end)
                else
                    print("Complex action completed!")
                end
            end

            nextStep()
        end

        startComplexAction()
        ```
]]
function lia.bar.drawAction(text, duration)
    local startTime, endTime = CurTime(), CurTime() + duration
    hook.Remove("HUDPaint", "liaBarDrawAction")
    hook.Add("HUDPaint", "liaBarDrawAction", function()
        local curTime = CurTime()
        if curTime >= endTime then
            hook.Remove("HUDPaint", "liaBarDrawAction")
            return
        end

        local frac = 1 - math.TimeFraction(startTime, endTime, curTime)
        local w, h = ScrW() * 0.35, 28
        local x, y = ScrW() * 0.5 - w * 0.5, ScrH() * 0.725 - h * 0.5
        lia.util.drawBlurAt(x, y, w, h)
        PaintPanel(x, y, w, h)
        surfaceSetDrawColor(lia.config.get("Color"))
        surfaceDrawRect(x + 4, y + 4, w * frac - 8, h - 8)
        surfaceSetDrawColor(200, 200, 200, 20)
        surface.SetMaterial(lia.util.getMaterial("vgui/gradient-d"))
        surface.DrawTexturedRect(x + 4, y + 4, w * frac - 8, h - 8)
        draw.SimpleText(text, "liaMediumFont", x + 2, y - 22, Color(20, 20, 20))
        draw.SimpleText(text, "liaMediumFont", x, y - 24, Color(240, 240, 240))
    end)
end

--[[
    Purpose:
        Renders all active progress bars in priority order, handling visibility, positioning, and smooth value transitions.

    When Called:
        Automatically called every frame by the HUDPaintBackground hook to draw all registered bars.

    Parameters:
        None

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Draw all bars (called automatically)
        lia.bar.drawAll()
        ```

        Medium Complexity:

        ```lua
        -- Medium: Force redraw all bars manually
        hook.Add("HUDPaint", "CustomBarDraw", function()
            lia.bar.drawAll()
        end)
        ```

        High Complexity:

        ```lua
        -- High: Create custom drawing logic with additional effects
        local function customDrawAll()
            -- Add custom background effects
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(0, 0, ScrW(), ScrH())

            -- Draw bars with custom positioning
            local originalDrawAll = lia.bar.drawAll
            lia.bar.drawAll = function()
                -- Custom pre-draw logic
                local barCount = #lia.bar.list
                if barCount > 0 then
                    -- Draw background panel for bars
                    surface.SetDrawColor(20, 20, 20, 150)
                    surface.DrawRect(4, 4, ScrW() * 0.35 + 4, barCount * 16 + (barCount - 1) * 2 + 4)
                end

                -- Call original draw function
                originalDrawAll()
            end

            lia.bar.drawAll()
            lia.bar.drawAll = originalDrawAll -- Restore original
        end

        -- Override the default drawing
        hook.Remove("HUDPaintBackground", "liaBarDraw")
        hook.Add("HUDPaint", "CustomBarDraw", customDrawAll)
        ```
]]
function lia.bar.drawAll()
    if hook.Run("ShouldHideBars") then return end
    table.sort(lia.bar.list, function(a, b)
        if a.priority == b.priority then return (a.order or 0) < (b.order or 0) end
        return a.priority < b.priority
    end)

    local w, h = ScrW() * 0.35, 14
    local x, y = 4, 4
    local deltas = lia.bar.delta
    local update = FrameTime() * 0.6
    local now = CurTime()
    local always = lia.option.get("BarsAlwaysVisible")
    local values = lia.bar.values
    for i, bar in ipairs(lia.bar.list) do
        local id = bar.identifier or i
        local target = bar.getValue()
        local last = values[id]
        values[id] = target
        deltas[id] = deltas[id] or target
        deltas[id] = math.Approach(deltas[id], target, update)
        local value = deltas[id]
        if last ~= nil and last ~= target then
            bar.lifeTime = now + 5
        elseif value ~= target then
            bar.lifeTime = now + 5
        end

        if always and value > 0 or bar.lifeTime >= now or bar.visible or hook.Run("ShouldBarDraw", bar) then
            lia.bar.drawBar(x, y, w, h, value, 1, bar.color)
            y = y + h + 2
        end
    end
end

lia.bar.add(function()
    local client = LocalPlayer()
    return client:Health() / client:GetMaxHealth()
end, Color(200, 50, 40), 1, "health")

lia.bar.add(function()
    local client = LocalPlayer()
    return client:Armor() / client:GetMaxArmor()
end, Color(30, 70, 180), 3, "armor")

hook.Add("HUDPaintBackground", "liaBarDraw", lia.bar.drawAll)