local locale = GetLocale()
local translation = L[locale] or L["enUS"]
local DB = { enabled = true , debugMode = false }
--
local AddonName = "RaidBossEmoteWhisperDisabler"
local AddonPath = "Interface/AddOns/" .. AddonName
local EventsName = {
    emote = "RAID_BOSS_EMOTE",
    whisper = "RAID_BOSS_WHISPER",
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg)
    if event == "ADDON_LOADED" and AddonName == arg then
        DB = RaidBossEmoteWhisperDisablerDB or DB
        ToggleState(DB.enabled)
        RegisterSettings()
    end
end)

function ToggleState(enable)
    -- RAID_BOSS_EMOTE
    if enable then
        RaidBossEmoteFrame:UnregisterEvent(EventsName.emote)
        if DB.debugMode then
            print(EventsName.emote .. " " .. translation.StateDisabled)
        end
    else
        RaidBossEmoteFrame:RegisterEvent(EventsName.emote)
        if DB.debugMode then
            print(EventsName.emote .. " " .. translation.StateEnabled)
        end
    end

    -- RAID_BOSS_WHISPER
    if enable then
        RaidBossEmoteFrame:RegisterEvent(EventsName.whisper)
        if DB.debugMode then
            print(EventsName.whisper .. " " .. translation.StateDisabled)
        end
    else
        RaidBossEmoteFrame:UnregisterEvent(EventsName.whisper)
        if DB.debugMode then
            print(EventsName.whisper .. " " .. translation.StateEnabled)
        end
    end
end

function RegisterSettings()
    -- Panel
    local panel = CreateFrame("Frame", "RaidBossEmoteWhisperDisablerPanel")
    panel:Hide()

    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("RaidBoss Emote/Whisper Disabler")

    -- Description
    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetText(translation.Description)

    -- Illustration
    local texture = panel:CreateTexture(nil, "ARTWORK")
    texture:SetTexture(AddonPath .. "/Media/message_event.tga")
    texture:SetSize(518, 67)
    texture:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -16)

    -- Enable
    local enableCheckbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", texture, "BOTTOMLEFT", 0, -16)
    enableCheckbox.Text:SetText(translation.enableCheckboxText)
    enableCheckbox:SetChecked(DB.enabled)

    enableCheckbox:SetScript("OnClick", function(self)
        DB.enabled = self:GetChecked()
        ToggleState(DB.enabled)
    end)

    -- DebugMode
    local debugModeCheckbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    debugModeCheckbox:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -16)
    debugModeCheckbox.Text:SetText(translation.debugModeCheckboxText)
    debugModeCheckbox:SetChecked(DB.debugMode)

    debugModeCheckbox:SetScript("OnClick", function(self)
        DB.debugMode = self:GetChecked()
    end)

    -- Addon Icon
    local icon = panel:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(AddonPath .. "/Media/icon.tga")
    icon:SetSize(37, 48)
    icon:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -30, -30)

    -- Register into Blizzard menu settings
    local category = Settings.RegisterCanvasLayoutCategory(panel, AddonName)
    category.ID = AddonName
    Settings.RegisterAddOnCategory(category)
end
