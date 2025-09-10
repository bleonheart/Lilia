# Currency Library

This page documents the functions for working with currency system and money management.

---

## Overview

The currency library (`lia.currency`) provides a simple currency system for the Lilia framework. It handles currency formatting, display, and money entity spawning. The library integrates with the configuration system to provide customizable currency symbols and names.

---

### lia.currency.get

**Purpose**

Formats a currency amount with proper symbol and singular/plural naming.

**Parameters**

* `amount` (*number*): The amount to format.

**Returns**

* `formatted` (*string*): The formatted currency string.

**Realm**

Shared.

**Example Usage**

```lua
-- Format currency amount
local formatted = lia.currency.get(100)
print(formatted) -- "$100 dollars" (or configured symbol/name)

-- Format single unit
local formatted = lia.currency.get(1)
print(formatted) -- "$1 dollar" (singular form)

-- Format multiple units
local formatted = lia.currency.get(500)
print(formatted) -- "$500 dollars" (plural form)

-- Use in UI display
local function drawMoney(amount)
    local formatted = lia.currency.get(amount)
    draw.SimpleText(formatted, "DermaDefault", 10, 10, Color(255, 255, 255))
end

-- Use in chat messages
local function sendMoneyMessage(amount)
    local formatted = lia.currency.get(amount)
    chat.AddText(Color(255, 255, 0), "You received " .. formatted)
end

-- Format with validation
local function safeFormat(amount)
    if isnumber(amount) and amount >= 0 then
        return lia.currency.get(amount)
    else
        return lia.currency.get(0)
    end
end
```

---

### lia.currency.spawn

**Purpose**

Spawns a money entity at the specified position with the given amount.

**Parameters**

* `pos` (*Vector*): The position to spawn the money entity.
* `amount` (*number*): The amount of money the entity should contain.
* `angle` (*Angle*): Optional angle for the money entity.

**Returns**

* `money` (*Entity|nil*): The spawned money entity or nil if failed.

**Realm**

Server.

**Example Usage**

```lua
-- Spawn money at position
local money = lia.currency.spawn(Vector(0, 0, 0), 100)
if IsValid(money) then
    print("Money spawned successfully")
end

-- Spawn money with angle
local money = lia.currency.spawn(Vector(100, 100, 0), 500, Angle(0, 45, 0))
if IsValid(money) then
    print("Money spawned with rotation")
end

-- Spawn money at player position
local function dropMoney(ply, amount)
    local pos = ply:GetPos() + ply:GetForward() * 50
    local money = lia.currency.spawn(pos, amount)
    if IsValid(money) then
        ply:ChatPrint("Dropped " .. lia.currency.get(amount))
    end
end

-- Spawn money with validation
local function safeSpawnMoney(pos, amount)
    if not pos or not amount or amount < 0 then
        print("Invalid parameters for money spawn")
        return nil
    end
    
    return lia.currency.spawn(pos, amount)
end

-- Spawn money in command
lia.command.add("spawnmoney", {
    arguments = {
        {name = "amount", type = "number"}
    },
    onRun = function(client, arguments)
        local amount = arguments[1]
        local pos = client:GetPos() + client:GetForward() * 100
        
        local money = lia.currency.spawn(pos, amount)
        if IsValid(money) then
            client:ChatPrint("Spawned " .. lia.currency.get(amount))
        else
            client:ChatPrint("Failed to spawn money")
        end
    end
})
```