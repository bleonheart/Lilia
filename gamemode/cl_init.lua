DeriveGamemode("sandbox")
include("shared.lua")
if CLIENT then
    concommand.Add("lia_check_fonts", function()
        local fonts = {"resource/fonts/specialelite.ttf", "resource/fonts/montserrat-bold.ttf", "resource/fonts/montserrat-medium.ttf", "resource/fonts/montserrat-regular.ttf"}
        print("========== Lilia Font Check ==========")
        for _, v in ipairs(fonts) do
            local exists = file.Exists(v, "GAME")
            if exists then
                local size = file.Size(v, "GAME")
                print(string.format("[FOUND] %s (%s bytes)", v, size))
            else
                print(string.format("[MISSING] %s", v))
            end
        end

        print("======================================")
    end)
end