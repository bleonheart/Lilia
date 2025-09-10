# lia.websound

## Overview
The `lia.websound` library provides web sound downloading and caching functionality for Lilia. It allows downloading sound files from URLs, caching them locally, and provides overrides for sound functions to automatically handle web sounds.

## Functions

### lia.websound.download
**Purpose**: Downloads a sound file from a URL and caches it locally (Client only).

**Parameters**:
- `url` (string): Sound URL to download
- `callback` (function): Callback function called when download completes
  - `callback` parameters: `path` (string) - local file path

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Download sound with callback
lia.websound.download("https://example.com/sound.mp3", function(path)
    print("Sound downloaded to:", path)
    surface.PlaySound(path)
end)

-- Download sound for UI
lia.websound.download("https://example.com/button_click.wav", function(path)
    local button = vgui.Create("DButton")
    button.DoClick = function()
        surface.PlaySound(path)
    end
end)

-- Download with error handling
lia.websound.download("https://example.com/notification.ogg", function(path)
    if path then
        print("Successfully downloaded:", path)
        -- Play the sound
        surface.PlaySound(path)
    else
        print("Failed to download sound")
    end
end)
```

### lia.websound.register
**Purpose**: Registers a web sound for automatic downloading (Client only).

**Parameters**:
- `url` (string): Sound URL to register

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Register web sound
lia.websound.register("https://example.com/background_music.mp3")

-- Register multiple sounds
local soundURLs = {
    "https://example.com/click.wav",
    "https://example.com/hover.ogg",
    "https://example.com/error.mp3"
}

for _, url in ipairs(soundURLs) do
    lia.websound.register(url)
end

-- Register sound for later use
lia.websound.register("https://example.com/achievement.wav")
```

### lia.websound.get
**Purpose**: Gets the local path of a registered web sound (Client only).

**Parameters**:
- `url` (string): Sound URL

**Returns**: String - local file path, or nil if not downloaded

**Realm**: Client

**Example Usage**:
```lua
-- Get local path
local path = lia.websound.get("https://example.com/sound.mp3")
if path then
    print("Local path:", path)
    surface.PlaySound(path)
else
    print("Sound not downloaded yet")
end

-- Use in UI
local soundURL = "https://example.com/button_click.wav"
lia.websound.register(soundURL)

local function playButtonSound()
    local path = lia.websound.get(soundURL)
    if path then
        surface.PlaySound(path)
    end
end
```

### lia.websound.getStats
**Purpose**: Gets statistics about web sound downloads (Client only).

**Parameters**: None

**Returns**: Table with download statistics

**Realm**: Client

**Example Usage**:
```lua
-- Get download stats
local stats = lia.websound.getStats()
print("Total downloads:", stats.total)
print("Successful downloads:", stats.successful)
print("Failed downloads:", stats.failed)

-- Display stats in UI
local stats = lia.websound.getStats()
local statsText = string.format("Downloads: %d/%d", stats.successful, stats.total)
local label = vgui.Create("DLabel")
label:SetText(statsText)
```

## Overridden Functions

### sound.PlayFile
**Purpose**: Overridden PlayFile function that automatically handles web sounds (Client only).

**Parameters**:
- `path` (string): Sound file path or web sound URL

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Use web sound directly with PlayFile
sound.PlayFile("https://example.com/music.mp3", "noplay", function(sound, errorID, errorName)
    if sound then
        sound:Play()
    else
        print("Error playing sound:", errorName)
    end
end)

-- Play web sound with callback
sound.PlayFile("https://example.com/notification.wav", "noplay", function(snd)
    if snd then
        snd:SetVolume(0.5)
        snd:Play()
    end
end)
```

### sound.PlayURL
**Purpose**: Overridden PlayURL function that automatically handles web sounds (Client only).

**Parameters**:
- `url` (string): Sound URL

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Use web sound directly with PlayURL
sound.PlayURL("https://example.com/stream.mp3", "noplay", function(sound, errorID, errorName)
    if sound then
        sound:Play()
    else
        print("Error playing URL:", errorName)
    end
end)

-- Play web sound with volume control
sound.PlayURL("https://example.com/background.mp3", "noplay", function(snd)
    if snd then
        snd:SetVolume(0.3)
        snd:Play()
    end
end)
```
