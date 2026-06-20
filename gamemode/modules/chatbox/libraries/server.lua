local MODULE = MODULE
local FILTER_DATA_KEY = "chatbox_filtered_words"

function MODULE:LoadData()
    local stored = lia.data.get(FILTER_DATA_KEY, {})
    local wordFilterModule = lia.module and lia.module.get and lia.module.get("wordfilter")
    if wordFilterModule == MODULE then wordFilterModule = nil end
    if wordFilterModule and istable(wordFilterModule.WordBlackList) then
        self.FilteredWords = #stored > 0 and stored or wordFilterModule.WordBlackList
    else
        self.FilteredWords = stored
    end

    self:SaveData()
end

function MODULE:SaveData()
    self.FilteredWords = self.FilteredWords or {}
    self.FilteredWords = table.Copy(self:GetFilteredWords())
    lia.data.set(FILTER_DATA_KEY, self.FilteredWords)
end

function MODULE:AddFilteredWord(word)
    word = string.Trim(tostring(word or "")):lower()
    if word == "" then return false, "invalid" end
    self.FilteredWords = table.Copy(self:GetFilteredWords())
    if table.HasValue(self.FilteredWords, word) then return false, "exists" end
    self.FilteredWords[#self.FilteredWords + 1] = word
    self:SaveData()
    return true, word
end

function MODULE:RemoveFilteredWord(word)
    word = string.Trim(tostring(word or "")):lower()
    if word == "" then return false, "invalid" end
    self.FilteredWords = table.Copy(self:GetFilteredWords())
    for index, existingWord in ipairs(self.FilteredWords) do
        if existingWord == word then
            table.remove(self.FilteredWords, index)
            self:SaveData()
            return true, word
        end
    end
    return false, "missing"
end

function MODULE:SyncFilteredWords(targets)
    local recipients = {}
    if IsValid(targets) then
        if self:CanManageFilteredWords(targets) then recipients[#recipients + 1] = targets end
    elseif istable(targets) then
        for _, client in ipairs(targets) do
            if self:CanManageFilteredWords(client) then recipients[#recipients + 1] = client end
        end
    else
        for _, client in player.Iterator() do
            if self:CanManageFilteredWords(client) then recipients[#recipients + 1] = client end
        end
    end

    if #recipients == 0 then return end
    local words = self:GetFilteredWords()
    net.Start("liaChatboxSyncFilteredWords")
    net.WriteUInt(#words, 16)
    for _, filteredWord in ipairs(words) do
        net.WriteString(filteredWord)
    end
    net.Send(recipients)
end

function MODULE:SyncFilteredWordsFromModule()
    local wordFilterModule = lia.module and lia.module.get and lia.module.get("wordfilter")
    if wordFilterModule == MODULE or not (wordFilterModule and istable(wordFilterModule.WordBlackList)) then return end
    self.FilteredWords = table.Copy(wordFilterModule.WordBlackList)
    self:SaveData()
end
