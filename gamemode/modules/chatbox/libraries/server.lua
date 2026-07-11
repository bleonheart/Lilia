local MODULE = MODULE
local LEGACY_FILTERED_WORDS_KEY = "chatbox_filtered_words"

local function debugFilteredWords(stage, words, extra)
    local serializedWords = util and util.TableToJSON(words or {}, false) or tostring(words)
    print(string.format("[Lilia Chat Filter] %s | words=%s%s", stage, tostring(serializedWords), extra and (" | " .. tostring(extra)) or ""))
end

local function normalizeFilteredWord(word)
    word = string.Trim(tostring(word or "")):lower()
    if word == "" then return nil end
    return word
end

local function buildNormalizedWordList(words)
    local normalized = {}
    local lookup = {}
    for _, word in ipairs(words or {}) do
        local cleaned = normalizeFilteredWord(word)
        if cleaned and not lookup[cleaned] then
            lookup[cleaned] = true
            normalized[#normalized + 1] = cleaned
        end
    end

    table.sort(normalized)
    return normalized
end

function MODULE:CanManageFilteredWords(client)
    local hasPrivilege = IsValid(client) and client:hasPrivilege("manageChatFilter") or false
    lia.debug("[Permissions]", "Permission Check for function MODULE:CanManageFilteredWords", "isValidPlayer=", tostring(IsValid(client)), "hasPrivilege(manageChatFilter)=", tostring(hasPrivilege), "finalResult=", tostring(hasPrivilege))
    return hasPrivilege
end

function MODULE:GetFilteredWords()
    self.FilteredWords = buildNormalizedWordList(self.FilteredWords or {})
    debugFilteredWords("GetFilteredWords", self.FilteredWords)
    return self.FilteredWords
end

function MODULE:LoadData()
    local storedWords = self:getData({})
    debugFilteredWords("LoadData module data raw", storedWords)
    if not istable(storedWords) or table.IsEmpty(storedWords) then
        storedWords = lia.data.get(LEGACY_FILTERED_WORDS_KEY, {})
        debugFilteredWords("LoadData legacy data raw", storedWords)
    end

    self.FilteredWords = buildNormalizedWordList(storedWords)
    debugFilteredWords("LoadData normalized", self.FilteredWords)
    self:setData(self.FilteredWords, true, true)
    debugFilteredWords("LoadData persisted normalized", self.FilteredWords, "scope=global ignoreMap=true")
end

function MODULE:InitializedModules()
    if not SERVER or not lia.reloadInProgress then return end
    print("[Lilia Chat Filter] InitializedModules during hotreload, restoring filtered words from saved data")
    self:LoadData()
    timer.Simple(0, function()
        if not MODULE then return end
        debugFilteredWords("InitializedModules post-reload sync", MODULE.FilteredWords)
        MODULE:SyncFilteredWords()
    end)
end

function MODULE:PlayerLoadedCharacter(client)
    if not self:CanManageFilteredWords(client) then return end
    debugFilteredWords("PlayerLoadedCharacter sync", self.FilteredWords, IsValid(client) and ("client=" .. client:Name()) or "client=nil")
    self:SyncFilteredWords(client)
end

function MODULE:SaveData()
    self.FilteredWords = buildNormalizedWordList(self.FilteredWords or {})
    debugFilteredWords("SaveData before persist", self.FilteredWords)
    self:setData(self.FilteredWords, true, true)
    debugFilteredWords("SaveData after persist", self.FilteredWords, "scope=global ignoreMap=true")
end

function MODULE:AddFilteredWord(word)
    print(string.format("[Lilia Chat Filter] AddFilteredWord requested | raw=%q", tostring(word)))
    word = normalizeFilteredWord(word)
    if not word then return false, "invalid" end
    self.FilteredWords = buildNormalizedWordList(self:GetFilteredWords())
    if table.HasValue(self.FilteredWords, word) then return false, "exists" end
    self.FilteredWords[#self.FilteredWords + 1] = word
    debugFilteredWords("AddFilteredWord appended", self.FilteredWords, "added=" .. word)
    self:SaveData()
    return true, word
end

function MODULE:RemoveFilteredWord(word)
    print(string.format("[Lilia Chat Filter] RemoveFilteredWord requested | raw=%q", tostring(word)))
    word = normalizeFilteredWord(word)
    if not word then return false, "invalid" end
    self.FilteredWords = buildNormalizedWordList(self:GetFilteredWords())
    for index, existingWord in ipairs(self.FilteredWords) do
        if existingWord == word then
            table.remove(self.FilteredWords, index)
            debugFilteredWords("RemoveFilteredWord removed", self.FilteredWords, "removed=" .. word)
            self:SaveData()
            return true, word
        end
    end

    debugFilteredWords("RemoveFilteredWord missing", self.FilteredWords, "requested=" .. tostring(word))
    return false, "missing"
end

function MODULE:SyncFilteredWords(targets)
    local recipients = {}
    if IsValid(targets) then
        if hook.Run("CanManageFilteredWords", targets) then recipients[#recipients + 1] = targets end
    elseif istable(targets) then
        for _, client in ipairs(targets) do
            if hook.Run("CanManageFilteredWords", client) then recipients[#recipients + 1] = client end
        end
    else
        for _, client in player.Iterator() do
            if hook.Run("CanManageFilteredWords", client) then recipients[#recipients + 1] = client end
        end
    end

    if #recipients == 0 then return end
    local words = self:GetFilteredWords()
    local recipientNames = {}
    for _, client in ipairs(recipients) do
        recipientNames[#recipientNames + 1] = IsValid(client) and client:Name() or "invalid"
    end
    debugFilteredWords("SyncFilteredWords", words, "recipients=" .. table.concat(recipientNames, ", "))
    net.Start("liaChatboxSyncFilteredWords")
    net.WriteUInt(#words, 16)
    for _, filteredWord in ipairs(words) do
        net.WriteString(filteredWord)
    end

    net.Send(recipients)
end
