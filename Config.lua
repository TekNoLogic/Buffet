
local EDGEGAP, GAP = 16, 8
local tekbutt = LibStub("tekKonfig-Button")


local frame = CreateFrame("Frame", nil, UIParent)
frame.name = "Buffet"
frame:Hide()
frame:SetScript("OnShow", function()
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Buffet", "This panel allows you to quickly create the base macros for Buffet to edit.  You can also set the macro text to be used.")

	local function OnClick(self)
		if InCombatLockdown() then Buffet:Print("Cannot create macros in combat.")
		elseif GetNumMacros() >= 18 then Buffet:Print("All global macros in use.")
		else
			CreateMacro(self.name, 1, "", 1)
			Buffet:Scan()
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

	local macrolabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	macrolabel:SetText("Macro")
	macrolabel:SetPoint("TOPLEFT", hpbutt, "BOTTOMLEFT", 5, -GAP)

	local editbox = CreateFrame("EditBox", nil, frame)
	editbox:SetPoint("TOP", macrolabel, "BOTTOM", 0, -5)
	editbox:SetPoint("LEFT", EDGEGAP/3, 0)
	editbox:SetPoint("BOTTOMRIGHT", -EDGEGAP/3, EDGEGAP/3)
	editbox:SetFontObject(GameFontHighlight)
	editbox:SetTextInsets(8,8,8,8)
	editbox:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	editbox:SetBackdropColor(.1,.1,.1,.3)
	editbox:SetMultiLine(true)
	editbox:SetAutoFocus(false)
	editbox:SetText(Buffet.db.macro)
	editbox:SetScript("OnEditFocusLost", function()
		local newmacro = editbox:GetText()
		if not newmacro:find("%%MACRO%%") then
			Buffet:Print('Macro text must contain the string "%MACRO%".')
		else
			Buffet.db.macro = newmacro
			Buffet:BAG_UPDATE()
		end
	end)
	editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
	editbox.tiptext = 'Customize the macro text.  Must include the string "%MACRO%", which is replaced with the items to be used.  This setting is saved on a per-char basis.'
	editbox:SetScript("OnEnter", mpbutt:GetScript("OnEnter"))
	editbox:SetScript("OnLeave", mpbutt:GetScript("OnLeave"))

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
