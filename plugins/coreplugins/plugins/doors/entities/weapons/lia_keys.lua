AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Keys"
    SWEP.Slot = 0
    SWEP.SlotPos = 2
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = "Cheesenot"
SWEP.Instructions = "Primary Fire: Lock Entities & Drag Players\nSecondary Fire: Unlock"
SWEP.Purpose = "Hitting things and knocking on doors."
SWEP.Drop = false
SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.ViewTranslation = 4
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = 0.75
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = ""
SWEP.UseHands = false
SWEP.LowerAngles = Angle(0, 5, -14)
SWEP.LowerAngles2 = Angle(0, 5, -22)
SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true
SWEP.HoldType = "normal"

function SWEP:PreDrawViewModel(viewModel, weapon, client)
    local hands = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(client:GetModel()))
    if hands and hands.model then end --viewModel:SetModel(hands.model) --viewModel:SetSkin(hands.skin) --viewModel:SetBodyGroups(hands.body)
end

ACT_VM_FISTS_DRAW = 3
ACT_VM_FISTS_HOLSTER = 2

function SWEP:Deploy()
    if not IsValid(self:GetOwner()) then return end
    local viewModel = self:GetOwner():GetViewModel()
    if IsValid(viewModel) then end --viewModel:SetPlaybackRate(1) --viewModel:ResetSequence(ACT_VM_FISTS_DRAW)

    return true
end

function SWEP:Holster()
    if not IsValid(self:GetOwner()) then return end
    local viewModel = self:GetOwner():GetViewModel()

    if IsValid(viewModel) then
        viewModel:SetPlaybackRate(1)
        viewModel:ResetSequence(ACT_VM_FISTS_HOLSTER)
    end

    return true
end

function SWEP:Precache()
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    local time = lia.config.get("doorLockTime", 1)
    local time2 = math.max(time, 1)
    self:SetNextPrimaryFire(CurTime() + time2)
    self:SetNextSecondaryFire(CurTime() + time2)
    if not IsFirstTimePredicted() then return end
    if CLIENT then return end
    local data = {}
    data.start = self:GetOwner():GetShootPos()
    data.endpos = data.start + self:GetOwner():GetAimVector() * 96
    data.filter = self:GetOwner()
    local entity = util.TraceLine(data).Entity

    --[[
		Locks the entity if the contiditon fits:
			1. The entity is door and client has access to the door.
			2. The entity is vehicle and the "owner" variable is same as client's character ID.
	--]]
    if IsValid(entity) and ((entity:isDoor() and (entity:checkDoorAccess(self:GetOwner()) or self:GetOwner():IsAdmin())) or (entity:IsVehicle() and ((entity.CPPIGetOwner and entity:CPPIGetOwner() == self:GetOwner()) or (entity.GetCreator and entity:GetCreator() == self:GetOwner())))) then
        self:GetOwner():setAction("@locking", time, function()
            if SERVER then
                self:toggleLock(entity, true)
            end
        end)

        return
    end
end

function SWEP:toggleLock(door, state)
    if IsValid(self:GetOwner()) and self:GetOwner():GetPos():Distance(door:GetPos()) > 96 then return end

    if door:isDoor() then
        local partner = door:getDoorPartner()

        if state then
            if IsValid(partner) then
                partner:Fire("lock")
            end

            door:Fire("lock")
            self:GetOwner():EmitSound("doors/door_latch3.wav")
        else
            if IsValid(partner) then
                partner:Fire("unlock")
            end

            door:Fire("unlock")
            self:GetOwner():EmitSound("doors/door_latch1.wav")
        end
    elseif door:IsVehicle() then
        if state then
            door:Fire("lock")

            if door.IsSimfphyscar then
                door.IsLocked = true
            end

            self:GetOwner():EmitSound("doors/door_latch3.wav")
        else
            door:Fire("unlock")

            if door.IsSimfphyscar then
                door.IsLocked = nil
            end

            self:GetOwner():EmitSound("doors/door_latch1.wav")
        end
    end
end

function SWEP:SecondaryAttack()
    local time = lia.config.get("doorLockTime", 1)
    local time2 = math.max(time, 1)
    self:SetNextPrimaryFire(CurTime() + time2)
    self:SetNextSecondaryFire(CurTime() + time2)
    if not IsFirstTimePredicted() then return end
    if CLIENT then return end
    local data = {}
    data.start = self:GetOwner():GetShootPos()
    data.endpos = data.start + self:GetOwner():GetAimVector() * 96
    data.filter = self:GetOwner()
    local entity = util.TraceLine(data).Entity

    --[[
		Unlocks the entity if the contiditon fits:
			1. The entity is door and client has access to the door.
			2. The entity is vehicle and the "owner" variable is same as client's character ID.
	]]
    if IsValid(entity) and ((entity:isDoor() and (entity:checkDoorAccess(self:GetOwner()) or self:GetOwner():IsAdmin())) or (entity:IsVehicle() and ((entity.CPPIGetOwner and entity:CPPIGetOwner() == self:GetOwner()) or (entity.GetCreator and entity:GetCreator() == self:GetOwner())))) then
        self:GetOwner():setAction("@unlocking", time, function()
            self:toggleLock(entity, false)
        end)

        return
    end
end