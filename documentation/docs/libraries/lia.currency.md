# Currency Library

This page documents the functions for working with currency and money management.

---

## Overview

The currency library (`lia.currency`) provides a system for managing in-game currency and money in the Lilia framework. It handles currency formatting, money entity spawning, and provides localized currency names and symbols. The library integrates with the configuration system to allow customizable currency symbols and names.

---

### lia.currency.get

**Purpose**

Formats a currency amount with proper symbol and singular/plural names.

**Parameters**

* `amount` (*number*): The amount of currency to format.

**Returns**

* `formattedString` (*string*): The formatted currency string.

**Realm**

Shared.

**Example Usage**

```lua
-- Format currency amount
local formatted = lia.currency.get(100)
print(formatted) -- "$100 dollars" (example)

-- Format single currency unit
local single = lia.currency.get(1)
print(single) -- "$1 dollar" (example)

-- Use in UI display
local function displayMoney(amount)
    local moneyText = lia.currency.get(amount)
    draw.SimpleText(moneyText, "DermaDefault", 100, 100, Color(255, 255, 255))
end

-- Format currency in chat
local function sendMoneyMessage(amount)
    local message = "You have " .. lia.currency.get(amount)
    chat.AddText(Color(255, 255, 0), message)
end

-- Format currency with validation
local function formatCurrencySafely(amount)
    if not isnumber(amount) or amount < 0 then
        return lia.currency.get(0)
    end
    return lia.currency.get(amount)
end

-- Format currency for different contexts
local function formatCurrencyForContext(amount, context)
    local formatted = lia.currency.get(amount)
    if context == "inventory" then
        return "Amount: " .. formatted
    elseif context == "transaction" then
        return "Total: " .. formatted
    else
        return formatted
    end
end
```

---

### lia.currency.spawn

**Purpose**

Spawns a money entity at the specified position with the given amount (server-side only).

**Parameters**

* `pos` (*Vector*): The position to spawn the money entity.
* `amount` (*number*): The amount of money for the entity.
* `angle` (*Angle*): Optional angle for the money entity.

**Returns**

* `moneyEntity` (*Entity|nil*): The spawned money entity or nil if failed.

**Realm**

Server.

**Example Usage**

```lua
-- Spawn money at a position
local money = lia.currency.spawn(Vector(0, 0, 0), 100)
if money then
    print("Money spawned successfully")
end

-- Spawn money with angle
local money = lia.currency.spawn(Vector(100, 100, 0), 50, Angle(0, 90, 0))

-- Spawn money at player position
local function spawnMoneyAtPlayer(ply, amount)
    local pos = ply:GetPos() + ply:GetForward() * 50
    return lia.currency.spawn(pos, amount)
end

-- Spawn money in a command
lia.command.add("givemoney", {
    desc = "Give money to a player",
    arguments = {
        {name = "target", type = "player"},
        {name = "amount", type = "number"}
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local target = arguments[1]
        local amount = tonumber(arguments[2])
        
        if amount and amount > 0 then
            local pos = target:GetPos() + target:GetForward() * 50
            local money = lia.currency.spawn(pos, amount)
            if money then
                client:ChatPrint("Spawned " .. lia.currency.get(amount) .. " for " .. target:Name())
            end
        end
    end
})

-- Spawn money with validation
local function spawnMoneySafely(pos, amount, angle)
    if not pos or not amount or amount <= 0 then
        print("Invalid parameters for money spawning")
        return nil
    end
    
    return lia.currency.spawn(pos, amount, angle)
end

-- Spawn money in a random location
local function spawnRandomMoney(amount, radius)
    local pos = Vector(
        math.random(-radius, radius),
        math.random(-radius, radius),
        0
    )
    return lia.currency.spawn(pos, amount)
end
```
