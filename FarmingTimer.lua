local ADDON_NAME, FT = ...
FT = FT or {}
_G.FarmingTimer = FT

FT.addonName = ADDON_NAME

local DEFAULTS = {
    version = 1,
    items = {},
    frame = { point = "CENTER", x = 0, y = 0 },
    visible = true,
    minimap = { hide = false, minimapPos = 220 },
}

local function copyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = dst[k] or {}
            copyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

function FT:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff4ade80FarmingTimer:|r " .. tostring(msg))
end

function FT:InitDB()
    FarmingTimerDB = FarmingTimerDB or {}
    FarmingTimerAccountDB = FarmingTimerAccountDB or {}
    copyDefaults(FarmingTimerDB, DEFAULTS)
    self.db = FarmingTimerDB
    self.accountDb = FarmingTimerAccountDB
end

function FT:ResolveItemID(value)
    if not value or value == "" then
        return nil
    end
    if type(value) == "number" then
        return value
    end
    if type(value) == "string" then
        local num = tonumber(value)
        if num then
            return num
        end
        if C_Item and C_Item.GetItemInfoInstant then
            return select(1, C_Item.GetItemInfoInstant(value))
        end
        if GetItemInfoInstant then
            return select(1, GetItemInfoInstant(value))
        end
    end
    return nil
end

function FT:FormatElapsed(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    if seconds >= 3600 then
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d", m, s)
end

function FT:IsValidItem(item)
    if not item then
        return false
    end
    local itemID = tonumber(item.itemID)
    local target = tonumber(item.target)
    return itemID and itemID > 0 and target and target > 0
end

function FT:GetValidCount()
    local count = 0
    for _, item in ipairs(self.db.items) do
        if self:IsValidItem(item) then
            count = count + 1
        end
    end
    return count
end

function FT:StartRun()
    if self.running and not self.paused then
        return
    end
    if self.running and self.paused then
        self:ResumeRun()
        return
    end

    if self:GetValidCount() == 0 then
        self:Print("Please add at least one item with a target amount.")
        return
    end

    self.baseline = {}
    for i, item in ipairs(self.db.items) do
        if self:IsValidItem(item) then
            local itemID = tonumber(item.itemID)
            self.baseline[i] = GetItemCount(itemID, false)
        else
            self.baseline[i] = 0
        end
    end

    self.running = true
    self.paused = false
    self.startTime = GetTime()
    self.elapsed = 0

    self:StartTicker()
    self:RefreshProgress()
    if self.UpdateControls then
        self:UpdateControls()
    end
end

function FT:PauseRun()
    if not self.running or self.paused then
        return
    end
    if self.startTime then
        self.elapsed = (self.elapsed or 0) + (GetTime() - self.startTime)
    end
    self.startTime = nil
    self.paused = true
    self:StopTicker()
    self:UpdateTimer()
    if self.UpdateControls then
        self:UpdateControls()
    end
end

function FT:ResumeRun()
    if not self.running or not self.paused then
        return
    end
    self.paused = false
    self.startTime = GetTime()
    self:StartTicker()
    self:UpdateTimer()
    if self.UpdateControls then
        self:UpdateControls()
    end
end

function FT:StopRun()
    if not self.running then
        return
    end

    if self.startTime then
        self.elapsed = (self.elapsed or 0) + (GetTime() - self.startTime)
    end

    self.running = false
    self.paused = false
    self.startTime = nil
    self:StopTicker()
    self:UpdateTimer()

    if self.UpdateControls then
        self:UpdateControls()
    end
end

function FT:ResetRun()
    self:StopRun()
    self.elapsed = 0
    self.paused = false
    self.baseline = {}
    for _, item in ipairs(self.db.items) do
        item.current = 0
    end
    self:RefreshProgress()
end

function FT:CompleteRun()
    if SOUNDKIT and SOUNDKIT.IG_QUEST_LIST_COMPLETE then
        PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE)
    else
        PlaySound(12867)
    end
    self:StopRun()
end

function FT:StartTicker()
    self:StopTicker()
    self.timerTicker = C_Timer.NewTicker(0.2, function()
        self:UpdateTimer()
    end)
end

function FT:StopTicker()
    if self.timerTicker then
        self.timerTicker:Cancel()
        self.timerTicker = nil
    end
end

function FT:UpdateTimer()
    local elapsed = self.elapsed or 0
    if self.running and self.startTime then
        elapsed = elapsed + (GetTime() - self.startTime)
    end
    if self.SetTimerText then
        self:SetTimerText(self:FormatElapsed(elapsed))
    end
end

function FT:RefreshProgress()
    local completed = 0
    local valid = 0

    for i, item in ipairs(self.db.items) do
        local current = 0
        if self:IsValidItem(item) then
            valid = valid + 1
            local itemID = tonumber(item.itemID)
            local base = self.baseline and self.baseline[i] or 0
            if self.running then
                current = GetItemCount(itemID, false) - base
            else
                current = 0
            end
            if current >= tonumber(item.target) then
                completed = completed + 1
            end
        end
        item.current = current
    end

    if self.UpdateRows then
        self:UpdateRows()
    end
    if self.UpdateSummary then
        self:UpdateSummary(completed, valid)
    end

    if self.running and not self.paused and valid > 0 and completed == valid then
        self:CompleteRun()
    end
end

function FT:RegisterSlash()
    if self.slashRegistered then
        return
    end
    self.slashRegistered = true
    SLASH_FARMINGTIMER1 = "/ft"
    SLASH_FARMINGTIMER2 = "/farmingtimer"
    SlashCmdList["FARMINGTIMER"] = function()
        self:ToggleFrame()
    end
end

function FT:ToggleFrame()
    if not self.frame then
        return
    end
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self.frame:Show()
    end
end

function FT:ShowFrame()
    if self.frame then
        self.frame:Show()
    end
end

function FT:HideFrame()
    if self.frame then
        self.frame:Hide()
    end
end

function FT:InitLDB()
    if not LibStub then
        return
    end

    local LDB = LibStub("LibDataBroker-1.1", true)
    local DBIcon = LibStub("LibDBIcon-1.0", true)
    if not LDB or not DBIcon then
        return
    end

    self.ldb = LDB:NewDataObject("FarmingTimer", {
        type = "launcher",
        text = "FarmingTimer",
        icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
    })

    self.ldb.OnClick = function(_, button)
        if button == "LeftButton" then
            self:ToggleFrame()
        end
    end

    self.ldb.OnTooltipShow = function(tooltip)
        tooltip:AddLine("FarmingTimer")
        tooltip:AddLine("Left-click to toggle")
        tooltip:AddLine("/ft")
    end

    self.db.minimap = self.db.minimap or { hide = false, minimapPos = 220 }
    DBIcon:Register("FarmingTimer", self.ldb, self.db.minimap)
    self.dbicon = DBIcon
end

function FT:UpdateMinimapVisibility()
    if not self.dbicon then
        return
    end
    if self.db.minimap.hide then
        self.dbicon:Hide("FarmingTimer")
    else
        self.dbicon:Show("FarmingTimer")
    end
end

function FT:ADDON_LOADED(addonName)
    if addonName ~= ADDON_NAME then
        return
    end
    self:InitDB()
    self:InitLDB()
end

function FT:PLAYER_LOGIN()
    if self.InitUI then
        self:InitUI()
    end
    if self.InitOptions then
        self:InitOptions()
    end
    self:RegisterSlash()
    self:UpdateMinimapVisibility()
    self:UpdateTimer()
end

function FT:BAG_UPDATE_DELAYED()
    if self.running then
        self:RefreshProgress()
    end
end

function FT:ITEM_DATA_LOAD_RESULT()
    if self.UpdateRows then
        self:UpdateRows()
    end
end

FT.eventFrame = CreateFrame("Frame")
FT.eventFrame:SetScript("OnEvent", function(_, event, ...)
    if FT[event] then
        FT[event](FT, ...)
    end
end)
FT.eventFrame:RegisterEvent("ADDON_LOADED")
FT.eventFrame:RegisterEvent("PLAYER_LOGIN")
FT.eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
FT.eventFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
