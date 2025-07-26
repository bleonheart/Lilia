local GM = GM or GAMEMODE
function GM:OnCharVarChanged(character, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for _, v in pairs(lia.char.varHooks[varName]) do
            v(character, oldVar, newVar)
        end
    end
end

if SERVER then
    function GM:PlayerShouldTakeDamage(client)
        return client:getChar() ~= nil
    end

    function GM:CanDrive()
        return false
    end

    function GM:PlayerDeathThink()
        return false
    end

    function GM:PlayerSpray()
        return true
    end

    function GM:PlayerDeathSound()
        return true
    end

    function GM:CanPlayerSuicide()
        return false
    end

    function GM:AllowPlayerPickup()
        return false
    end
else
    function GM:HUDDrawTargetID()
        return false
    end

    function GM:HUDDrawPickupHistory()
        return false
    end

    function GM:HUDAmmoPickedUp()
        return false
    end

    function GM:DrawDeathNotice()
        return false
    end
end