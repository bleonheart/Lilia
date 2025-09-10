# lia.util

## Overview
The `lia.util` library provides comprehensive utility functions for Lilia, including player finding, entity management, UI creation, and various helper functions. It serves as a central collection of useful utilities for the gamemode.

## Functions

### lia.util.FindPlayersInBox
**Purpose**: Finds all players within a specified bounding box.

**Parameters**:
- `mins` (Vector): Minimum corner of the bounding box
- `maxs` (Vector): Maximum corner of the bounding box

**Returns**: Array of player entities

**Realm**: Server

**Example Usage**:
```lua
-- Find players in a specific area
local mins = Vector(-100, -100, 0)
local maxs = Vector(100, 100, 200)
local players = lia.util.FindPlayersInBox(mins, maxs)
print("Found", #players, "players in area")

-- Check if any players are in a zone
local zonePlayers = lia.util.FindPlayersInBox(Vector(-50, -50, 0), Vector(50, 50, 100))
if #zonePlayers > 0 then
    print("Players detected in zone")
end
```

### lia.util.getBySteamID
**Purpose**: Gets a player by their Steam ID.

**Parameters**:
- `steamID` (string): Steam ID of the player

**Returns**: Player entity or nil

**Realm**: Server

**Example Usage**:
```lua
-- Get player by Steam ID
local player = lia.util.getBySteamID("STEAM_0:1:12345678")
if IsValid(player) then
    print("Found player:", player:Name())
else
    print("Player not found")
end

-- Get player by Steam ID 64
local player = lia.util.getBySteamID("76561198000000000")
if IsValid(player) then
    print("Found player:", player:Name())
end
```

### lia.util.FindPlayersInSphere
**Purpose**: Finds all players within a specified radius of a point.

**Parameters**:
- `origin` (Vector): Center point
- `radius` (number): Search radius

**Returns**: Array of player entities

**Realm**: Server

**Example Usage**:
```lua
-- Find players within 100 units
local players = lia.util.FindPlayersInSphere(Vector(0, 0, 0), 100)
print("Found", #players, "players within 100 units")

-- Find players near a specific entity
local entity = ents.FindByClass("prop_physics")[1]
if IsValid(entity) then
    local nearbyPlayers = lia.util.FindPlayersInSphere(entity:GetPos(), 200)
    print("Players near entity:", #nearbyPlayers)
end
```

### lia.util.findPlayer
**Purpose**: Finds a player using various identifier formats.

**Parameters**:
- `client` (Player): Client making the request
- `identifier` (string): Player identifier (name, Steam ID, etc.)

**Returns**: Player entity or nil

**Realm**: Server

**Example Usage**:
```lua
-- Find player by name
local player = lia.util.findPlayer(client, "John")
if IsValid(player) then
    print("Found player:", player:Name())
end

-- Find player by Steam ID
local player = lia.util.findPlayer(client, "STEAM_0:1:12345678")
if IsValid(player) then
    print("Found player:", player:Name())
end

-- Find player by Steam ID 64
local player = lia.util.findPlayer(client, "76561198000000000")
if IsValid(player) then
    print("Found player:", player:Name())
end

-- Find player by looking at them
local player = lia.util.findPlayer(client, "@")
if IsValid(player) then
    print("Found player:", player:Name())
end
```

### lia.util.findPlayerItems
**Purpose**: Finds all items created by a specific player.

**Parameters**:
- `client` (Player): Player to search for

**Returns**: Array of item entities

**Realm**: Server

**Example Usage**:
```lua
-- Find all items created by player
local items = lia.util.findPlayerItems(client)
print("Player has", #items, "items")

-- Clean up player items
local items = lia.util.findPlayerItems(client)
for _, item in ipairs(items) do
    if IsValid(item) then
        item:Remove()
    end
end
```

### lia.util.findPlayerItemsByClass
**Purpose**: Finds all items of a specific class created by a player.

**Parameters**:
- `client` (Player): Player to search for
- `class` (string): Item class name

**Returns**: Array of item entities

**Realm**: Server

**Example Usage**:
```lua
-- Find all pistols created by player
local pistols = lia.util.findPlayerItemsByClass(client, "weapon_pistol")
print("Player has", #pistols, "pistols")

-- Find all custom items
local customItems = lia.util.findPlayerItemsByClass(client, "custom_item")
print("Player has", #customItems, "custom items")
```

### lia.util.findPlayerEntities
**Purpose**: Finds all entities created by a specific player.

**Parameters**:
- `client` (Player): Player to search for
- `class` (string): Entity class name (optional)

**Returns**: Array of entities

**Realm**: Server

**Example Usage**:
```lua
-- Find all entities created by player
local entities = lia.util.findPlayerEntities(client)
print("Player has", #entities, "entities")

-- Find all props created by player
local props = lia.util.findPlayerEntities(client, "prop_physics")
print("Player has", #props, "props")
```

### lia.util.stringMatches
**Purpose**: Checks if two strings match using various comparison methods.

**Parameters**:
- `a` (string): First string
- `b` (string): Second string

**Returns**: Boolean indicating if strings match

**Realm**: Shared

**Example Usage**:
```lua
-- Check if strings match
local matches = lia.util.stringMatches("John", "john")
print("Strings match:", matches) -- true

-- Check if string contains substring
local matches = lia.util.stringMatches("John Doe", "Doe")
print("String contains:", matches) -- true

-- Case-insensitive comparison
local matches = lia.util.stringMatches("HELLO", "hello")
print("Case-insensitive match:", matches) -- true
```

### lia.util.getAdmins
**Purpose**: Gets all online staff members.

**Parameters**: None

**Returns**: Array of staff player entities

**Realm**: Server

**Example Usage**:
```lua
-- Get all online staff
local staff = lia.util.getAdmins()
print("Online staff:", #staff)

-- Notify all staff
local staff = lia.util.getAdmins()
for _, admin in ipairs(staff) do
    admin:ChatPrint("Admin notification")
end
```

### lia.util.findPlayerBySteamID64
**Purpose**: Finds a player by their Steam ID 64.

**Parameters**:
- `SteamID64` (string): Steam ID 64

**Returns**: Player entity or nil

**Realm**: Server

**Example Usage**:
```lua
-- Find player by Steam ID 64
local player = lia.util.findPlayerBySteamID64("76561198000000000")
if IsValid(player) then
    print("Found player:", player:Name())
end
```

### lia.util.findPlayerBySteamID
**Purpose**: Finds a player by their Steam ID.

**Parameters**:
- `SteamID` (string): Steam ID

**Returns**: Player entity or nil

**Realm**: Server

**Example Usage**:
```lua
-- Find player by Steam ID
local player = lia.util.findPlayerBySteamID("STEAM_0:1:12345678")
if IsValid(player) then
    print("Found player:", player:Name())
end
```

### lia.util.canFit
**Purpose**: Checks if an entity can fit at a specific position.

**Parameters**:
- `pos` (Vector): Position to check
- `mins` (Vector): Minimum bounds (optional)
- `maxs` (Vector): Maximum bounds (optional)
- `filter` (Entity): Entity to filter out of trace (optional)

**Returns**: Boolean indicating if entity can fit

**Realm**: Server

**Example Usage**:
```lua
-- Check if entity can fit at position
local canFit = lia.util.canFit(Vector(0, 0, 0))
print("Can fit:", canFit)

-- Check with custom bounds
local canFit = lia.util.canFit(Vector(100, 100, 50), Vector(-16, -16, 0), Vector(16, 16, 32))
print("Can fit with custom bounds:", canFit)

-- Check with filter
local canFit = lia.util.canFit(Vector(0, 0, 0), Vector(-16, -16, 0), Vector(16, 16, 32), player)
print("Can fit with filter:", canFit)
```

### lia.util.playerInRadius
**Purpose**: Finds all players within a specified radius of a position.

**Parameters**:
- `pos` (Vector): Center position
- `dist` (number): Search radius

**Returns**: Array of player entities

**Realm**: Server

**Example Usage**:
```lua
-- Find players within 200 units
local players = lia.util.playerInRadius(Vector(0, 0, 0), 200)
print("Players in radius:", #players)

-- Find players near explosion
local explosionPos = Vector(100, 100, 50)
local affectedPlayers = lia.util.playerInRadius(explosionPos, 300)
print("Players affected by explosion:", #affectedPlayers)
```

### lia.util.formatStringNamed
**Purpose**: Formats a string using named placeholders.

**Parameters**:
- `format` (string): Format string with {placeholder} syntax
- `...` (any): Arguments or table of values

**Returns**: Formatted string

**Realm**: Shared

**Example Usage**:
```lua
-- Format with table
local result = lia.util.formatStringNamed("Hello {name}, you have {money} money", {
    name = "John",
    money = 1000
})
print(result) -- "Hello John, you have 1000 money"

-- Format with array
local result = lia.util.formatStringNamed("Player {1} has {2} items", "John", 5)
print(result) -- "Player John has 5 items"
```

### lia.util.getMaterial
**Purpose**: Gets a cached material by path.

**Parameters**:
- `materialPath` (string): Path to the material
- `materialParameters` (string): Material parameters (optional)

**Returns**: Material object

**Realm**: Client

**Example Usage**:
```lua
-- Get material
local material = lia.util.getMaterial("materials/icon16/world.png")
if material then
    print("Material loaded:", material:GetName())
end

-- Get material with parameters
local material = lia.util.getMaterial("materials/effects/water", "unlitgeneric")
if material then
    print("Material with parameters loaded")
end
```

### lia.util.findFaction
**Purpose**: Finds a faction by name or unique ID.

**Parameters**:
- `client` (Player): Client making the request
- `name` (string): Faction name or unique ID

**Returns**: Faction data table or nil

**Realm**: Server

**Example Usage**:
```lua
-- Find faction by name
local faction = lia.util.findFaction(client, "Police")
if faction then
    print("Found faction:", faction.name)
end

-- Find faction by unique ID
local faction = lia.util.findFaction(client, "police")
if faction then
    print("Found faction:", faction.name)
end
```

### lia.util.SendTableUI
**Purpose**: Sends a table UI to a client (Server only).

**Parameters**:
- `client` (Player): Target client
- `title` (string): Table title
- `columns` (table): Column definitions
- `data` (table): Table data
- `options` (table): Table options (optional)
- `characterID` (number): Character ID (optional)

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Send table UI to client
lia.util.SendTableUI(client, "Player List", {
    {name = "Name", field = "name", width = 200},
    {name = "Level", field = "level", width = 100},
    {name = "Money", field = "money", width = 150}
}, {
    {name = "John", level = 5, money = 1000},
    {name = "Jane", level = 3, money = 500}
}, {
    {name = "Edit", net = "EditPlayer"}
}, 123)
```

### lia.util.findEmptySpace
**Purpose**: Finds empty spaces around an entity.

**Parameters**:
- `entity` (Entity): Entity to search around
- `filter` (Entity): Entity to filter out of trace (optional)
- `spacing` (number): Spacing between positions (optional)
- `size` (number): Search size (optional)
- `height` (number): Height to check (optional)
- `tolerance` (number): Tolerance for trace (optional)

**Returns**: Array of empty positions

**Realm**: Server

**Example Usage**:
```lua
-- Find empty spaces around entity
local emptySpaces = lia.util.findEmptySpace(entity)
print("Found", #emptySpaces, "empty spaces")

-- Find empty spaces with custom parameters
local emptySpaces = lia.util.findEmptySpace(entity, player, 64, 5, 72, 10)
print("Found", #emptySpaces, "empty spaces with custom parameters")
```

### lia.util.ShadowText
**Purpose**: Draws text with a shadow effect (Client only).

**Parameters**:
- `text` (string): Text to draw
- `font` (string): Font to use
- `x` (number): X position
- `y` (number): Y position
- `colortext` (Color): Text color
- `colorshadow` (Color): Shadow color
- `dist` (number): Shadow distance
- `xalign` (number): X alignment (optional)
- `yalign` (number): Y alignment (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw shadow text
lia.util.ShadowText("Hello World", "liaBigFont", 100, 100, 
    Color(255, 255, 255), Color(0, 0, 0), 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

-- Draw centered shadow text
lia.util.ShadowText("Centered Text", "liaMediumFont", ScrW()/2, ScrH()/2,
    Color(255, 255, 255), Color(0, 0, 0), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
```

### lia.util.DrawTextOutlined
**Purpose**: Draws text with an outline effect (Client only).

**Parameters**:
- `text` (string): Text to draw
- `font` (string): Font to use
- `x` (number): X position
- `y` (number): Y position
- `colour` (Color): Text color
- `xalign` (number): X alignment (optional)
- `outlinewidth` (number): Outline width (optional)
- `outlinecolour` (Color): Outline color (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw outlined text
lia.util.DrawTextOutlined("Outlined Text", "liaBigFont", 100, 100,
    Color(255, 255, 255), TEXT_ALIGN_LEFT, 2, Color(0, 0, 0))

-- Draw centered outlined text
lia.util.DrawTextOutlined("Centered Outlined", "liaMediumFont", ScrW()/2, ScrH()/2,
    Color(255, 255, 255), TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
```

### lia.util.DrawTip
**Purpose**: Draws a tooltip with a pointer (Client only).

**Parameters**:
- `x` (number): X position
- `y` (number): Y position
- `w` (number): Width
- `h` (number): Height
- `text` (string): Tooltip text
- `font` (string): Font to use
- `textCol` (Color): Text color
- `outlineCol` (Color): Outline color

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw tooltip
lia.util.DrawTip(100, 100, 200, 50, "This is a tooltip", "liaSmallFont",
    Color(255, 255, 255), Color(0, 0, 0))

-- Draw tooltip with custom colors
lia.util.DrawTip(200, 200, 150, 40, "Custom tooltip", "liaMediumFont",
    Color(255, 255, 0), Color(255, 0, 0))
```

### lia.util.drawText
**Purpose**: Draws text with shadow effect (Client only).

**Parameters**:
- `text` (string): Text to draw
- `x` (number): X position
- `y` (number): Y position
- `color` (Color): Text color (optional)
- `alignX` (number): X alignment (optional)
- `alignY` (number): Y alignment (optional)
- `font` (string): Font to use (optional)
- `alpha` (number): Alpha value (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw text with default settings
lia.util.drawText("Hello World", 100, 100)

-- Draw text with custom settings
lia.util.drawText("Custom Text", 200, 200, Color(255, 0, 0), 
    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "liaBigFont", 200)

-- Draw centered text
lia.util.drawText("Centered Text", ScrW()/2, ScrH()/2, Color(255, 255, 255),
    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
```

### lia.util.drawTexture
**Purpose**: Draws a texture at specified position (Client only).

**Parameters**:
- `material` (string): Material path
- `color` (Color): Color to draw with (optional)
- `x` (number): X position
- `y` (number): Y position
- `w` (number): Width
- `h` (number): Height

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw texture
lia.util.drawTexture("materials/icon16/world.png", Color(255, 255, 255), 100, 100, 32, 32)

-- Draw texture with custom color
lia.util.drawTexture("materials/effects/water", Color(0, 100, 255, 128), 200, 200, 64, 64)
```

### lia.util.skinFunc
**Purpose**: Calls a skin function on a panel (Client only).

**Parameters**:
- `name` (string): Skin function name
- `panel` (Panel): Panel to apply skin to
- `a` (any): First parameter
- `b` (any): Second parameter
- `c` (any): Third parameter
- `d` (any): Fourth parameter
- `e` (any): Fifth parameter
- `f` (any): Sixth parameter
- `g` (any): Seventh parameter

**Returns**: Result of skin function

**Realm**: Client

**Example Usage**:
```lua
-- Call skin function
local result = lia.util.skinFunc("Paint", panel, w, h)

-- Call skin function with parameters
local result = lia.util.skinFunc("PaintButton", button, w, h, color, text)
```

### lia.util.wrapText
**Purpose**: Wraps text to fit within specified width (Client only).

**Parameters**:
- `text` (string): Text to wrap
- `width` (number): Maximum width
- `font` (string): Font to use (optional)

**Returns**: 
- `lines` (table): Array of wrapped lines
- `maxWidth` (number): Maximum width of lines

**Realm**: Client

**Example Usage**:
```lua
-- Wrap text
local lines, maxWidth = lia.util.wrapText("This is a long text that needs to be wrapped", 200)
print("Wrapped into", #lines, "lines")
print("Max width:", maxWidth)

-- Wrap text with custom font
local lines, maxWidth = lia.util.wrapText("Long text", 300, "liaBigFont")
```

### lia.util.drawBlur
**Purpose**: Draws a blur effect on a panel (Client only).

**Parameters**:
- `panel` (Panel): Panel to blur
- `amount` (number): Blur amount (optional)
- `passes` (number): Number of blur passes (optional)
- `alpha` (number): Alpha value (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw blur effect
lia.util.drawBlur(panel, 5, 0.2, 255)

-- Draw heavy blur
lia.util.drawBlur(panel, 10, 0.5, 200)
```

### lia.util.drawBlackBlur
**Purpose**: Draws a black blur effect on a panel (Client only).

**Parameters**:
- `panel` (Panel): Panel to blur
- `amount` (number): Blur amount (optional)
- `passes` (number): Number of blur passes (optional)
- `alpha` (number): Alpha value (optional)
- `darkAlpha` (number): Dark overlay alpha (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw black blur effect
lia.util.drawBlackBlur(panel, 6, 5, 255, 220)

-- Draw heavy black blur
lia.util.drawBlackBlur(panel, 10, 8, 200, 180)
```

### lia.util.drawBlurAt
**Purpose**: Draws a blur effect at specific coordinates (Client only).

**Parameters**:
- `x` (number): X position
- `y` (number): Y position
- `w` (number): Width
- `h` (number): Height
- `amount` (number): Blur amount (optional)
- `passes` (number): Number of blur passes (optional)
- `alpha` (number): Alpha value (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Draw blur at specific position
lia.util.drawBlurAt(100, 100, 200, 100, 5, 0.2, 255)

-- Draw blur covering entire screen
lia.util.drawBlurAt(0, 0, ScrW(), ScrH(), 10, 0.5, 200)
```

### lia.util.requestArguments
**Purpose**: Creates a UI for requesting arguments from the user (Client only).

**Parameters**:
- `title` (string): Window title
- `argTypes` (table): Argument type definitions
- `onSubmit` (function): Callback when form is submitted
- `defaults` (table): Default values (optional)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Request arguments
lia.util.requestArguments("Enter Details", {
    name = "string",
    age = "number",
    isActive = "boolean"
}, function(success, result)
    if success then
        print("Name:", result.name)
        print("Age:", result.age)
        print("Active:", result.isActive)
    end
end, {
    name = "Default Name",
    age = 25,
    isActive = true
})
```

### lia.util.CreateTableUI
**Purpose**: Creates a table UI for displaying data (Client only).

**Parameters**:
- `title` (string): Table title
- `columns` (table): Column definitions
- `data` (table): Table data
- `options` (table): Table options (optional)
- `charID` (number): Character ID (optional)

**Returns**: 
- `frame` (Panel): Table frame
- `listView` (Panel): List view panel

**Realm**: Client

**Example Usage**:
```lua
-- Create table UI
local frame, listView = lia.util.CreateTableUI("Player List", {
    {name = "Name", field = "name", width = 200},
    {name = "Level", field = "level", width = 100},
    {name = "Money", field = "money", width = 150}
}, {
    {name = "John", level = 5, money = 1000},
    {name = "Jane", level = 3, money = 500}
}, {
    {name = "Edit", net = "EditPlayer"}
}, 123)
```

### lia.util.openOptionsMenu
**Purpose**: Opens an options menu (Client only).

**Parameters**:
- `title` (string): Menu title
- `options` (table): Menu options

**Returns**: Menu frame

**Realm**: Client

**Example Usage**:
```lua
-- Open options menu
lia.util.openOptionsMenu("Player Options", {
    {name = "Edit", callback = function() print("Edit clicked") end},
    {name = "Delete", callback = function() print("Delete clicked") end},
    {name = "Close", callback = function() print("Close clicked") end}
})

-- Open options menu with table format
lia.util.openOptionsMenu("Actions", {
    Edit = function() print("Edit action") end,
    Delete = function() print("Delete action") end,
    Close = function() print("Close action") end
})
```