
local GAP = 8
local tekbutt = LibStub("tekKonfig-Button")
local scan = BUFFET_SCAN
BUFFET_SCAN = nil


local frame = CreateFrame("Frame", nil, UIParent)
frame.name = "Buffet"
frame:Hide()
frame:SetScript("OnShow", function()
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Buffet", "This panel allows you to quickly create the base macros for Buffet to edit.  You only need to do this once unless you delete the macros.")

	local function OnClick(self)
		if InCombatLockdown() then ChatFrame1:AddMessage("|cFF33FF99Buffet:|r Cannot create macros in combat.")
		elseif GetNumMacros() >= 18 then ChatFrame1:AddMessage("|cFF33FF99Buffet:|r All global macros in use.")
		else
			CreateMacro(self.name, 1, "", 1)
			scan()
		end
	end

	local hpbutt = tekbutt.new(frame, "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	hpbutt:SetText("Create HP")
	hpbutt.tiptext = "Generate a global macro for food, bandages, health potions and health stones."
	hpbutt.name = "AutoHP"
	hpbutt:SetScript("OnClick", OnClick)

	local mpbutt = tekbutt.new(frame, "TOPLEFT", hpbutt, "TOPRIGHT", GAP, 0)
	mpbutt:SetText("Create MP")
	mpbutt.tiptext = "Generate a global macro for water, mana potions and mana stones."
	mpbutt.name = "AutoMP"
	mpbutt:SetScript("OnClick", OnClick)

	local function Refresh(self)
		if GetMacroIndexByName("AutoHP") == 0 then hpbutt:Enable() else hpbutt:Disable() end
		if GetMacroIndexByName("AutoMP") == 0 then mpbutt:Enable() else mpbutt:Disable() end
		self:RegisterEvent("UPDATE_MACROS")
	end
	frame:SetScript("OnEvent", Refresh)
	frame:SetScript("OnShow", Refresh)
	frame:SetScript("OnHide", function(self) self:UnregisterEvent("UPDATE_MACROS") end)
	Refresh(frame)
end)

InterfaceOptions_AddCategory(frame)

LibStub("tekKonfig-AboutPanel").new("Buffet", "Buffet")
