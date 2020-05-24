if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_bnc.vmt")
end

ROLE.Base = "ttt_role_base"

function ROLE:PreInitialize()
	self.color = Color(95, 210, 110, 255)

	self.abbr = "bnc"
	self.surviveBonus = 0
	self.scoreKillsMultiplier = 1
	self.scoreTeamKillsMultiplier = -16
	self.preventFindCredits = false
	self.preventKillCredits = false
	self.preventTraitorAloneCredits = false

	self.defaultTeam = TEAM_INNOCENT

	self.conVarData = {
		pct = 0.17,
		maximum = 1,
		minPlayers = 6,
		credits = 0,
		shopFallback = SHOP_FALLBACK_NONE,
		togglable = true,
		traitorButton = 0,
		random = 50
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then
	local function IsBouncerCrouching(ply)
		if ply:GetSubRole() ~= ROLE_BOUNCER then
			return false
		end

		if not ply:GetInternalVariable("m_fIsWalking") then
			return false
		end

		return true
	end

	local function StoreInventoryToTable(ply, tbl)
		if not tbl then return end

		--tbl.items = table.Copy(ply:GetEquipmentItems())

		-- reset inventory
		tbl.inv = {}

		-- save inventory
		for _, v in pairs(ply:GetWeapons()) do
			tbl.inv[#tbl.inv + 1] = {
				cls = WEPS.GetClass(v),
				clip1 = v:Clip1(),
				clip2 = v:Clip2()
			}
		end

		tbl.wep = WEPS.GetClass(ply:GetActiveWeapon())

		-- clear inventory
		ply:StripWeapons()
	end

	local function LoadInventoryFromTable(ply, tbl)
		if not tbl then return end

		if tbl.inv then
			for i = 1, #tbl.inv do
				local wepTbl = tbl.inv[i]

				if not wepTbl.cls then continue end

				local wep = ply:Give(wepTbl.cls)

				if not IsValid(wep) then continue end

				wep:SetClip1(wepTbl.clip1 or 0)
				wep:SetClip2(wepTbl.clip2 or 0)
			end
		end

		if tbl.wep then
			ply:SelectWeapon(tbl.wep)
		end

		-- reset tables
		tbl.inv = nil
		tbl.wep = nil
	end

	local function EnableBouncer(ply)
		ply:DrawWorldModel(false)
		ply:SetBloodColor(DONT_BLEED)
		ply:DrawShadow(false)
		ply:Flashlight(false)
		ply:AllowFlashlight(false)
		ply:SetFOV(0, 0.2)
		ply:SetNoDraw(true)
		ply:SetNWBool("disguised", true)

		ply.bouncerDefaultInventory = ply.bouncerDefaultInventory or {}

		StoreInventoryToTable(ply, ply.bouncerDefaultInventory)

		if not ply.bouncerSpecialInventory then
			ply:GiveEquipmentWeapon("weapon_ttt_doorlocker")
			ply:GiveEquipmentWeapon("weapon_ttt_doorghost")
			ply:GiveEquipmentWeapon("weapon_ttt_binoculars")

			ply:GetWeapon("weapon_ttt_doorlocker"):SetClip1(15)

			ply.bouncerSpecialInventory = {}
		end

		LoadInventoryFromTable(ply, ply.bouncerSpecialInventory)

		ply:GetWeapon("weapon_ttt_doorlocker").AllowDrop = false
		ply:GetWeapon("weapon_ttt_binoculars").AllowDrop = false
	end

	local function DisableBouncer(ply)
		ply:DrawWorldModel(true)
		ply:SetBloodColor(BLOOD_COLOR_RED)
		ply:DrawShadow(true)
		ply:AllowFlashlight(true)
		ply:SetNoDraw(false)
		ply:SetNWBool("disguised", false)

		StoreInventoryToTable(ply, ply.bouncerSpecialInventory)
		LoadInventoryFromTable(ply, ply.bouncerDefaultInventory)
	end

	local nextThink = 0

	hook.Add("Think", "ttt2_role_bouncer_think", function()
		if nextThink > CurTime() then return end

		nextThink = CurTime() + 0.15

		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			local isCrouching = IsBouncerCrouching(ply)

			if isCrouching == ply.bouncerIsCrouching then continue end

			if isCrouching then
				ply.bouncerIsCrouching = true

				EnableBouncer(ply)
			else
				ply.bouncerIsCrouching = false

				DisableBouncer(ply)
			end
		end
	end)

	local allowedWeapons = {
		["weapon_ttt_doorlocker"] = true,
		["weapon_ttt_doorghost"] = true,
		["weapon_ttt_binoculars"] = true
	}

	hook.Add("PlayerCanPickupWeapon", "ttt2_role_bouncer_pickup", function(ply, wep)
		if IsBouncerCrouching(ply) and not allowedWeapons[wep:GetClass()] then
			return false
		end
	end)
end
