local performanceConfig = {
    ["server"] = {
        ["convars"] = {
            net_maxfilesize = 64, -- Max file size (KB) clients can upload/download via net messages
            sv_kickerrornum = 0, -- Disable kicking players for Lua errors (0 = never kick)
            sv_allowupload = 0, -- Disallow clients from uploading custom sprays/files to the server
            sv_allowdownload = 0, -- Disallow clients from downloading files directly from the server (use FastDL instead)
            sv_allowcslua = 0, -- Prevent clients from running arbitrary clientside Lua
            gmod_physiterations = 4, -- Physics solver iterations per tick; lower = cheaper, less accurate
            sbox_noclip = 0, -- Disable sandbox noclip (no effect in RP but prevents abuse if sbox hooks fire)
            sv_maxrate = 30000, -- Max bytes/sec the server sends to a single client
            sv_minrate = 5000, -- Min bytes/sec the server sends to a single client
            sv_maxcmdrate = 66, -- Max client command packets per second the server accepts
            sv_maxupdaterate = 66, -- Max server update packets per second sent to clients
            sv_mincmdrate = 30 -- Min client command packets per second the server accepts
        },
        ["hooks"] = {
            OnEntityCreated = {
                "WidgetInit" -- Removes the default widget initialisation that runs on every entity spawn
            },
            Think = {
                "DOFThink", -- Removes default DOF and schedule-checker think hooks (replaced by Lilia's own)
                "CheckSchedules"
            },
            PlayerTick = {
                "TickWidgets" -- Removes the default per-player widget tick
            },
            PlayerInitialSpawn = {
                "PlayerAuthSpawn", -- Removes Steam auth spawn handler and the hint tooltip system
                "HintSystem_PlayerInitialSpawn"
            },
            LoadGModSave = {
                "LoadGModSave" -- Prevents GMod save files from being loaded (not needed in RP)
            },
            PlayerSpawn = {
                "HintSystem_PlayerSpawn" -- Removes the hint system hook that fires when a player spawns
            }
        }
    },
    ["client"] = {
        ["convars"] = {
            mat_bumpmap = 0, -- Disable bump/normal maps on materials (saves GPU shader cost)
            rate = 1048576, -- Max bytes/sec the client accepts from the server (set high to avoid throttling)
            cl_updaterate = 66, -- How many server state updates per second the client requests
            r_drawmodeldecals = 1, -- Draw decals on models (bullet holes, blood, etc.)
            cl_cmdrate = 66, -- How many command packets per second the client sends to the server
            cl_interp = 0.01364, -- Interpolation interval; lower = less visual lag at the cost of smoothness
            cl_interp_ratio = 2, -- Multiplier on cl_interp; 2 = safe buffer for packet loss
            r_shadows = 1, -- Enable real-time blob/projected shadows (overridden by player option)
            r_dynamic = 0, -- Disable dynamic lights (muzzle flashes, explosions) — big perf gain
            r_eyemove = 0, -- Disable eye-tracking/movement animation on NPCs/players
            r_flex = 0, -- Disable facial flex animations (lip sync, expressions)
            r_drawflecks = 0, -- Disable impact spark/debris particle flecks
            r_drawdetailprops = 0, -- Disable small ground-level detail props (grass, pebbles)
            r_shadowrendertotexture = 0, -- Disable rendering shadows to a texture (more expensive shadow mode)
            r_shadowmaxrendered = 0, -- Max shadows rendered per frame (0 = effectively none when texture shadows off)
            r_fastzreject = -1, -- Auto-detect fast Z-reject optimisation (skips hidden pixel shading)
            cl_phys_props_enable = 0, -- Disable clientside physics props simulation
            cl_phys_props_max = 0, -- Max clientside physics props allowed (0 = none)
            cl_threaded_bone_setup = 1, -- Set up model bones on a worker thread instead of the main thread
            props_break_max_pieces = 0, -- Max gibs spawned when a prop breaks (0 = no gibs)
            r_lod = 0, -- Global LOD bias; 0 = use default distance-based LOD switching
            cl_lagcompensation = 1, -- Enable lag compensation so server rewinds player positions on shots
            violence_agibs = 0, -- Disable alien/antlion gib models on death
            violence_hgibs = 0, -- Disable human gib models on death
            cl_show_splashes = 0, -- Disable water splash particles
            cl_ejectbrass = 0, -- Disable shell casing ejection particles from weapons
            cl_detailfade = 800, -- Distance (units) at which detail props begin fading out
            cl_smooth = 0, -- Disable client-side smoothing of view origin after prediction errors
            cl_detaildist = 0, -- Distance (units) beyond which detail props are not drawn (0 = none drawn)
            cl_drawmonitors = 0, -- Disable in-world monitor/screen entities rendering
            r_spray_lifetime = 1, -- How many map loads a player spray decal persists (1 = current session only)
            mat_antialias = 0, -- Disable MSAA anti-aliasing (overridden by player option)
            mat_envmapsize = 0, -- Size of environment/cubemap reflection textures (0 = smallest)
            mat_envmaptgasize = 0, -- Size of TGA-based environment map textures (0 = smallest)
            mat_hdr_level = 0, -- HDR mode: 0 = off, 1 = bloom only, 2 = full HDR (overridden by player option)
            mat_motion_blur_enabled = 0, -- Disable motion blur post-process effect (overridden by player option)
            mat_reduceparticles = 1, -- Halve the number of particles spawned by all particle systems
            r_waterdrawreflection = 0, -- Disable water surface reflections (overridden by player option)
            r_threaded_particles = 1, -- Simulate particles on a worker thread
            r_queued_ropes = 1, -- Build rope meshes on a worker thread
            threadpool_affinity = 64, -- Bitmask controlling which CPU cores the threadpool can use (64 = flexible)
            mat_queue_mode = 2, -- Material system queue mode: 2 = multi-threaded render queue
            studio_queue_mode = 1, -- Process model studio render calls in a queued/threaded manner
            gmod_mcore_test = 1, -- Enable GMod's experimental multi-core rendering optimisations
            mem_max_heapsize_dedicated = 131072, -- Max heap memory (KB) for the dedicated-server allocator (~128 MB)
            mem_min_heapsize = 131072, -- Min heap memory (KB) reserved at startup (~128 MB)
            mat_powersavingsmode = 0, -- Disable power-saving mode (which throttles GPU frame rate)
            cl_timeout = 3600, -- Seconds before the client times out if it receives no server data (1 hour)
            cl_smoothtime = 0.05, -- Duration (seconds) over which view-origin smoothing is applied
            cl_localnetworkbackdoor = 1, -- Use a faster loopback path when the client and server share the same machine
            ai_expression_optimization = 1, -- Skip expensive NPC facial expression updates when not visible
            filesystem_max_stdio_read = 64, -- Max file size (MB) the stdio filesystem layer will read at once
            in_usekeyboardsampletime = 1, -- Sample keyboard input at a fixed interval for consistent input timing
            r_radiosity = 4, -- Radiosity / ambient cube quality level (4 = full quality, lower = cheaper)
            mat_framebuffercopyoverlaysize = 0, -- Size of the framebuffer copy used by overlay effects (0 = minimal)
            mat_managedtextures = 0, -- Disable Direct3D managed textures (lets the driver handle VRAM eviction)
            fast_fogvolume = 1, -- Use a cheaper fog volume calculation method
            filesystem_unbuffered_io = 0 -- Use buffered I/O for filesystem reads (0 = buffered, better for many small reads)
        },
        ["hooks"] = {
            RenderScreenspaceEffects = {
                "RenderBloom", -- Removes all default post-process effects (bloom, bokeh DOF, colour overlays, sharpen, sobel, stereoscopy, sunbeams, texturize, toy-town)
                "RenderBokeh",
                "RenderSharpen",
                "RenderSobel",
                "RenderStereoscopy",
                "RenderSunbeams",
                "RenderTexturize",
                "RenderToyTown"
            },
            PreDrawHalos = {
                "PropertiesHover" -- Removes the hover-highlight halo drawn around props when using the Properties tool
            },
            RenderScene = {
                "RenderSuperDoF", -- Removes Super DOF and stereoscopic 3D scene renders
                "RenderStereoscopy"
            },
            PreRender = {
                "PreRenderFlameBlend", -- Removes pre-render setup for flame and frame-blend effects
                "PreRenderFrameBlend"
            },
            PostRender = {
                "RenderFrameBlend" -- Removes the frame-blend motion-blur post-render pass
            },
            PostDrawEffects = {
                "RenderWidgets", -- Removes default widget and halo rendering after the world is drawn
                "RenderHalos"
            },
            GUIMousePressed = {
                "SuperDOFMouseDown", -- Removes Super DOF mouse-down handlers
                "SuperDOFMouseUp"
            },
            GUIMouseReleased = {
                "SuperDOFMouseUp" -- Removes Super DOF mouse-release handler
            },
            PreventScreenClicks = {
                "SuperDOFPreventClicks" -- Removes Super DOF click-blocking (it would eat clicks while active)
            },
            Think = {
                "DOFThink", -- Removes default DOF think and schedule-checker (replaced by Lilia's own)
                "CheckSchedules"
            },
            PlayerTick = {
                "TickWidgets" -- Removes the default per-player widget tick
            },
            PlayerBindPress = {
                "PlayerOptionInput" -- Removes the default bind-press handler used by sandbox player options
            },
            NeedsDepthPass = {
                "NeedsDepthPassBokeh", -- Removes depth-pass requests made by bokeh DOF (depth texture is no longer needed)
                "NeedsDepthPass_Bokeh"
            },
            OnGamemodeLoaded = {
                "CreateMenuBar" -- Removes creation of the sandbox menu bar (not used in RP)
            },
            StartChat = {
                "StartChatIndicator" -- Removes the chat-open indicator hook
            },
            FinishChat = {
                "EndChatIndicator" -- Removes the chat-close indicator hook
            },
            OnEntityCreated = {
                "WidgetInit" -- Removes the default widget initialisation that runs on every entity spawn
            }
        }
    }
}

if SERVER then
    hook.Add("PropBreak", "liaPerformancePropBreak", function(_, entity) if IsValid(entity) and IsValid(entity:GetPhysicsObject()) then constraint.RemoveAll(entity) end end)
else
    local col = Color(115, 148, 248)

    local function ClearLuaMemory()
        local before = collectgarbage("count")
        collectgarbage("collect")
        local after = collectgarbage("count")
        local freed = math.Round((before - after) / 1024)
        local now = math.Round(after / 1024)
        if freed > 0 then
            MsgC(col, "[LuaGC] Freed " .. freed .. " MB — now using " .. now .. " MB.\n")
        end
    end

    concommand.Add("luamemory", function()
        local before = collectgarbage("count")
        collectgarbage("collect")
        local after = collectgarbage("count")
        local freed = math.Round((before - after) / 1024)
        local now = math.Round(after / 1024)
        MsgC(col, "[LuaGC] Freed " .. freed .. " MB — now using " .. now .. " MB.\n")
    end)

    timer.Create("lua_gc", 30, 0, ClearLuaMemory) -- Run every 30 seconds
end

local function ApplyConvars()
    for name, value in pairs(SERVER and performanceConfig.server.convars or performanceConfig.client.convars) do
        RunConsoleCommand(name, value)
    end
end

local function RemoveBadHooks()
    local hooks = SERVER and performanceConfig.server.hooks or performanceConfig.client.hooks
    for hookName, hookList in pairs(hooks) do
        if isstring(hookName) and istable(hookList) then
            for _, id in ipairs(hookList) do
                if isstring(id) then hook.Remove(hookName, id) end
            end
        end
    end
end

hook.Add("InitializedModules", "liaPerformanceInitializedModules", function()
    local options = {
        shadows = "r_shadows",
        dynamicLighting = "r_dynamic",
        eyeMovement = "r_eyemove",
        facialExpressions = "r_flex",
        antiAliasing = "mat_antialias",
        hdrLighting = "mat_hdr_level",
        motionBlur = "mat_motion_blur_enabled",
        waterReflections = "r_waterdrawreflection",
        gameMonitors = "cl_drawmonitors",
        alienGibs = "violence_agibs",
        humanGibs = "violence_hgibs",
        waterSplashes = "cl_show_splashes",
        shellEjection = "cl_ejectbrass",
        modelDecals = "r_drawmodeldecals",
        multiplayerDecals = "mp_decals",
        detailFadeDistance = "cl_detailfade",
        detailDistance = "cl_detaildist",
        networkSmoothing = "cl_smooth",
        smoothingTime = "cl_smoothtime"
    }

    local voiceIconsValue = lia.config.get("voiceIcons", false)
    RunConsoleCommand("mp_show_voice_icons", voiceIconsValue and 1 or 0)
    if lia.config.get("mouthMoveAnimation", true) then
        hook.Add("MouthMoveAnimation", "Optimization", function() return nil end)
    else
        hook.Remove("MouthMoveAnimation", "Optimization")
    end

    if lia.config.get("grabEarAnimation", true) then
        hook.Add("GrabEarAnimation", "Optimization", function() return nil end)
    else
        hook.Remove("GrabEarAnimation", "Optimization")
    end

    ApplyConvars()
    RemoveBadHooks()
    if SERVER then
        for name, value in pairs(performanceConfig.server.convars) do
            RunConsoleCommand(name, value)
        end

        hook.Remove("Think", "CheckSchedules")
        hook.Remove("LoadGModSave", "LoadGModSave")
    else
        for optionName, convar in pairs(options) do
            local value = lia.config.get(optionName, nil)
            if value ~= nil then
                if isbool(value) then
                    RunConsoleCommand(convar, value and "1" or "0")
                else
                    RunConsoleCommand(convar, tostring(value))
                end
            end
        end
    end

    scripted_ents.GetStored("base_gmodentity").t.Think = nil
end)