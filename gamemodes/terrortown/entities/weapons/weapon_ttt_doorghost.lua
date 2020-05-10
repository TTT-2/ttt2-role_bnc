if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/gui/ttt/icon_doorghost.vmt")
end

local sounds = {
	empty = Sound("Weapon_SMG1.Empty"),
	laugh1 = Sound("vo/npc/Barney/ba_laugh01.wav"),
	laugh2 = Sound("vo/ravenholm/madlaugh02.wav")
}

SWEP.Base = "weapon_tttbase"

if CLIENT then
	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "weapon_doorghost_name",
		desc = "weapon_doorghost_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_doorghost"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "pistol"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.5

SWEP.Charge = 0
SWEP.Timer = -1

function SWEP:GetEntity()
	local owner = self:GetOwner()

	local trace = owner:GetEyeTrace(MASK_SHOT_HULL)
	local distance = trace.StartPos:Distance(trace.HitPos)
	local ent = trace.Entity

	if not IsValid(ent) or not ent:IsDoor() or not ent:PlayerCanOpenDoor() or distance > 100 then
		owner:EmitSound(sounds["empty"])

		return
	end

	return ent
end

local function RegisterGhost(ent, owner)
	timer.Create("bouncer_doorghost_" .. ent:EntIndex(), math.random(1, 12), 1, function()
		if not IsValid(ent) then return end

		ent:ToggleDoor(owner)

		RegisterGhost(ent, owner)
	end)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local owner = self:GetOwner()
	local ent = self:GetEntity()

	if not IsValid(ent) then return end

	if not door.IsValidNormal(ent:GetClass()) then
		LANG.Msg(owner, "door_not_lockable", nil, MSG_MSTACK_WARN)

		owner:EmitSound(sounds["empty"])

		return
	end

	if ent:GetNWBool("haunted_door", false) then
		LANG.Msg(owner, "door_already_haunted", nil, MSG_MSTACK_WARN)

		return
	end

	if ent:IsDoorLocked() then
		LANG.Msg(owner, "door_is_locked", nil, MSG_MSTACK_WARN)

		owner:EmitSound(sounds["empty"])

		return
	end

	ent:SetNWBool("haunted_door", true)

	RegisterGhost(ent, owner)

	ent:EmitSound(sounds["laugh1"])
	ent:EmitSound(sounds["laugh2"])
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	local ent = self:GetEntity()

	if not IsValid(ent) then return end

	if not ent:GetNWBool("haunted_door", false) then
		LANG.Msg(owner, "door_not_haunted", nil, MSG_MSTACK_WARN)

		return
	end

	ent:SetNWBool("haunted_door", false)
	timer.Remove("bouncer_doorghost_" .. ent:EntIndex())
end

if SERVER then
	hook.Add("PreCleanupMap", "doorghost_pre_map_cleanup", function()
		local doorTable = door.GetAll()

		for i = 1, #doorTable do
			local doorEntity = doorTable[i]

			if not doorEntity:GetNWBool("haunted_door", false) then continue end

			timer.Remove("bouncer_doorghost_" .. doorEntity:EntIndex())
		end
	end)
end

if CLIENT then
	hook.Add("TTTRenderEntityInfo", "ttt2_defi_display_info", function(tData)
		local ent = tData:GetEntity()
		local client = LocalPlayer()

		if client:GetSubRole() ~= ROLE_BOUNCER then return end

		if not ent:GetNWBool("haunted_door", false) then return end

		tData:AddDescriptionLine(
			LANG.TryTranslation("door_is_haunted")
		)
	end)
end
