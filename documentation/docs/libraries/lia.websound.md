# WebSound Library

This page explains how remote sounds are downloaded and cached.

---

## Overview

The web-sound library downloads remote audio files and stores them inside
`data/lilia/sounds/<IP>/<Gamemode>/`. Each server therefore keeps its own
collection of downloaded sounds. The library overrides `sound.PlayFile` and
`sound.PlayURL` so HTTP(S) URLs may be passed directly—the file is downloaded,
cached and then played. Subsequent calls using the same URL will reuse the
previously saved file and you may also pass the cached name to
`sound.PlayFile`.

---

### lia.websound.register

**Purpose**

Downloads a sound from the given URL and saves it in the web-sound cache. If the
file already exists locally the callback fires immediately with the cached
filename. On HTTP failure the callback receives `nil` and an error string.

**Parameters**

* `name` (*string*): Unique file name including extension.
* `url` (*string*): HTTP address of the sound file.
* `callback` (*function | nil*): Called as `callback(path, fromCache, err)` where
  `path` is the local file path relative to `DATA/`, `fromCache` is `true` if
  loaded from disk and `err` is an error string on failure.

**Realm**

`Client`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Download a sound and play it when ready
lia.websound.register("alert.mp3", "https://example.com/alert.mp3", function(path)
    if path then
        sound.PlayFile(path, "", function(chan) if chan then chan:Play() end end)
    end
end)
```

---

### lia.websound.get

**Purpose**

Returns the file path cached with `lia.websound.register`. If the file is
missing `nil` is returned. Both `sound.PlayFile` and `sound.PlayURL` call this
internally when a cached name or matching URL is supplied.

**Parameters**

* `name` (*string*): File name used during registration.

**Realm**

`Client`

**Returns**

* *string | nil*: Local data path or `nil` if not found.

**Example Usage**

```lua
-- Retrieve a cached sound and play it
local path = lia.websound.get("alert.mp3")
if path then
    sound.PlayFile(path, "", function(chan) if chan then chan:Play() end end)
end

-- Play directly from the web
sound.PlayFile("https://example.com/alert.mp3", "", function(chan)
    if chan then chan:Play() end
end)
```

---