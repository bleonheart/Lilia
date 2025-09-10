# lia.webimage

## Overview
The `lia.webimage` library provides web image downloading and caching functionality for Lilia. It allows downloading images from URLs, caching them locally, and provides overrides for Material and DImage functions to automatically handle web images.

## Functions

### lia.webimage.download
**Purpose**: Downloads an image from a URL and caches it locally (Client only).

**Parameters**:
- `url` (string): Image URL to download
- `callback` (function): Callback function called when download completes
  - `callback` parameters: `path` (string) - local file path

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Download image with callback
lia.webimage.download("https://example.com/image.png", function(path)
    print("Image downloaded to:", path)
    local mat = Material(path)
    -- Use the material
end)

-- Download image for UI
lia.webimage.download("https://example.com/avatar.jpg", function(path)
    local avatar = vgui.Create("DImage")
    avatar:SetImage(path)
    avatar:SetSize(64, 64)
end)

-- Download with error handling
lia.webimage.download("https://example.com/logo.png", function(path)
    if path then
        print("Successfully downloaded:", path)
    else
        print("Failed to download image")
    end
end)
```

### lia.webimage.register
**Purpose**: Registers a web image for automatic downloading (Client only).

**Parameters**:
- `url` (string): Image URL to register

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Register web image
lia.webimage.register("https://example.com/background.jpg")

-- Register multiple images
local imageURLs = {
    "https://example.com/logo.png",
    "https://example.com/icon.jpg",
    "https://example.com/banner.gif"
}

for _, url in ipairs(imageURLs) do
    lia.webimage.register(url)
end

-- Register image for later use
lia.webimage.register("https://example.com/player_avatar.png")
```

### lia.webimage.get
**Purpose**: Gets the local path of a registered web image (Client only).

**Parameters**:
- `url` (string): Image URL

**Returns**: String - local file path, or nil if not downloaded

**Realm**: Client

**Example Usage**:
```lua
-- Get local path
local path = lia.webimage.get("https://example.com/image.png")
if path then
    print("Local path:", path)
    local mat = Material(path)
else
    print("Image not downloaded yet")
end

-- Use in UI
local imageURL = "https://example.com/logo.png"
lia.webimage.register(imageURL)

local function createImage()
    local path = lia.webimage.get(imageURL)
    if path then
        local img = vgui.Create("DImage")
        img:SetImage(path)
        return img
    end
    return nil
end
```

### lia.webimage.getStats
**Purpose**: Gets statistics about web image downloads (Client only).

**Parameters**: None

**Returns**: Table with download statistics

**Realm**: Client

**Example Usage**:
```lua
-- Get download stats
local stats = lia.webimage.getStats()
print("Total downloads:", stats.total)
print("Successful downloads:", stats.successful)
print("Failed downloads:", stats.failed)

-- Display stats in UI
local stats = lia.webimage.getStats()
local statsText = string.format("Downloads: %d/%d", stats.successful, stats.total)
local label = vgui.Create("DLabel")
label:SetText(statsText)
```

## Overridden Functions

### Material
**Purpose**: Overridden Material function that automatically handles web images (Client only).

**Parameters**:
- `path` (string): Material path or web image URL

**Returns**: Material object

**Realm**: Client

**Example Usage**:
```lua
-- Use web image directly with Material
local mat = Material("https://example.com/texture.png")
-- Automatically downloads and caches the image

-- Use in rendering
local mat = Material("https://example.com/background.jpg")
surface.SetMaterial(mat)
surface.DrawTexturedRect(0, 0, 512, 512)

-- Use in UI
local mat = Material("https://example.com/icon.png")
local icon = vgui.Create("DImage")
icon:SetMaterial(mat)
```

### DImage:SetImage
**Purpose**: Overridden SetImage method that automatically handles web images (Client only).

**Parameters**:
- `path` (string): Image path or web image URL

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Use web image directly with DImage
local img = vgui.Create("DImage")
img:SetImage("https://example.com/avatar.jpg")
img:SetSize(64, 64)

-- Use in panel
local panel = vgui.Create("DPanel")
local img = vgui.Create("DImage", panel)
img:SetImage("https://example.com/logo.png")
img:SetPos(10, 10)
img:SetSize(100, 50)
```
