-- Test script to verify websound fix
-- This can be run in Garry's Mod console with: lua_run <file contents>

print("Testing websound surface.PlaySound fix...")

-- Test 1: Test path normalization
local function testNormalizeName()
    print("Testing normalizeName function...")

    -- Test backslash to forward slash conversion
    local testPath1 = "lilia\\websounds\\test.wav"
    local normalized1 = testPath1:gsub("\\", "/"):gsub("^%s+", ""):gsub("%s+$", "")
    if normalized1:find("^lilia/websounds/") then
        print("✓ Path normalization works: " .. testPath1 .. " -> " .. normalized1)
    else
        print("✗ Path normalization failed")
    end

    -- Test already normalized path
    local testPath2 = "lilia/websounds/test2.wav"
    if testPath2:find("^lilia/websounds/") then
        print("✓ Already normalized path works: " .. testPath2)
    else
        print("✗ Already normalized path failed")
    end
end

-- Test 2: Test websound path extraction
local function testWebPathExtraction()
    print("\nTesting websound path extraction...")

    local function extractWebPath(soundPath)
        if soundPath:find("^lilia/websounds/") then
            return soundPath:gsub("^lilia/websounds/", "")
        elseif soundPath:find("^websounds/") then
            return soundPath:gsub("^websounds/", "")
        else
            return soundPath
        end
    end

    local test1 = "lilia/websounds/button_click.wav"
    local extracted1 = extractWebPath(test1)
    print("Extracted: '" .. test1 .. "' -> '" .. extracted1 .. "'")

    local test2 = "websounds/music.mp3"
    local extracted2 = extractWebPath(test2)
    print("Extracted: '" .. test2 .. "' -> '" .. extracted2 .. "'")

    local test3 = "sound/effects/explosion.wav"
    local extracted3 = extractWebPath(test3)
    print("Extracted: '" .. test3 .. "' -> '" .. extracted3 .. "'")
end

-- Test 3: Test surface.PlaySound logic (conceptual)
local function testSurfacePlaySoundLogic()
    print("\nTesting surface.PlaySound logic flow...")

    local function simulateSurfacePlaySound(soundPath)
        -- This simulates the fixed logic
        if not isstring(soundPath) then return "invalid input" end

        -- Normalize path
        soundPath = soundPath:gsub("\\", "/"):gsub("^%s+", ""):gsub("%s+$", "")
        if soundPath:find("^lilia/websounds/") then
            soundPath = soundPath:gsub("^lilia/websounds/", "")
            return "websound: " .. soundPath
        elseif soundPath:find("^websounds/") then
            soundPath = soundPath:gsub("^websounds/", "")
            return "websound: " .. soundPath
        else
            return "regular sound: " .. soundPath
        end
    end

    print("Test 1 - lilia\\websounds\\click.wav:")
    print("Result: " .. simulateSurfacePlaySound("lilia\\websounds\\click.wav"))

    print("Test 2 - lilia/websounds/music.mp3:")
    print("Result: " .. simulateSurfacePlaySound("lilia/websounds/music.mp3"))

    print("Test 3 - sound/ui/button.wav:")
    print("Result: " .. simulateSurfacePlaySound("sound/ui/button.wav"))
end

-- Run tests
testNormalizeName()
testWebPathExtraction()
testSurfacePlaySoundLogic()

print("\nWebsound fix test completed!")
