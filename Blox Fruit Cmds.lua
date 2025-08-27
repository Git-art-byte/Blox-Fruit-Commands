-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- Notification Function
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- ================================
-- Dynamic Detection Functions
-- ================================
local function getOwnedWeapons()
    local weapons = {}
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            weapons[item.Name:lower()] = item.Name
        end
    end
    return weapons
end

local function getOwnedFightingStyles()
    local styles = {}
    for _, style in pairs(LocalPlayer:WaitForChild("FightingStyles"):GetChildren()) do
        if style:IsA("BoolValue") and style.Value == true then
            styles[style.Name:lower()] = style.Name
        end
    end
    return styles
end

local function getOwnedFruits()
    local fruits = {}
    for _, fruit in pairs(LocalPlayer:WaitForChild("Fruits"):GetChildren()) do
        if fruit:IsA("BoolValue") and fruit.Value == true then
            fruits[fruit.Name:lower()] = fruit.Name
        end
    end
    return fruits
end

local function getOwnedTitles()
    local titles = {}
    local titlesFolder = ReplicatedStorage:FindFirstChild("Titles") or LocalPlayer:FindFirstChild("Titles")
    if titlesFolder then
        for _,v in pairs(titlesFolder:GetChildren()) do
            if v:IsA("StringValue") or v:IsA("ValueBase") then
                titles[v.Name:lower()] = v.Name
            end
        end
    end
    return titles
end

local function findTitleMatch(searchName)
    searchName = searchName:lower()
    local ownedTitles = getOwnedTitles()
    for titleName, realName in pairs(ownedTitles) do
        if titleName:find(searchName) then
            return realName
        end
    end
    return nil
end

-- ================================
-- Command Functions (Dynamic)
-- ================================
local function getWeapon(name)
    local owned = getOwnedWeapons()
    name = name:lower()
    if owned[name] then
        local success, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", owned[name], {"Swords"}) -- category dynamic detection is optional
        end)
        notify("Weapon", success and "✅ Equipped "..owned[name] or "❌ "..tostring(result),5)
    else
        notify("Weapon","❌ Weapon not owned: "..name,5)
    end
end

local function getFightingStyle(name)
    local owned = getOwnedFightingStyles()
    name = name:lower()
    if owned[name] then
        local success, result = pcall(function()
            return CommF_:InvokeServer("Buy"..owned[name])
        end)
        notify("Fighting Style", success and "✅ Equipped "..owned[name] or "❌ "..tostring(result),5)
    else
        notify("Fighting Style","❌ Not owned: "..name,5)
    end
end

local function equipFruit(name)
    local owned = getOwnedFruits()
    name = name:lower()
    if owned[name] then
        local success, result = pcall(function()
            return CommF_:InvokeServer("SwitchFruit", owned[name])
        end)
        notify("Fruit", success and "✅ "..owned[name].." equipped" or "❌ "..tostring(result),5)
    else
        notify("Fruit","❌ Not owned: "..name,5)
    end
end

local function equipTitle(name)
    local exactName = findTitleMatch(name)
    if exactName then
        local success, result = pcall(function()
            return CommF_:InvokeServer("SetTitle", exactName)
        end)
        if not success then
            success, result = pcall(function()
                return CommF_:InvokeServer("EquipTitle", exactName)
            end)
        end
        notify("Title", success and "✅ "..exactName.." equipped" or "❌ "..tostring(result),5)
    else
        notify("Title","❌ Title not owned: "..name,5)
    end
end

local function travelToSea(seaNumber)
    local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}
    local command = TravelCommands[seaNumber]
    if command then
        local success, result = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        notify("Travel", success and "✅ Travel to Sea "..seaNumber or "❌ "..tostring(result),5)
    else
        notify("Travel","❌ Invalid sea number. Use /sea1, /sea2, /sea3",5)
    end
end

local function setTeam(teamName)
    local team = teamName:lower():find("pirate") and "Pirates" or "Marines"
    local success, result = pcall(function()
        return CommF_:InvokeServer("SetTeam", team)
    end)
    notify("Team", success and "✅ Joined "..team or "❌ "..tostring(result),5)
end

-- ================================
-- Command Table
-- ================================
local Commands = {
    ["/g"] = function(arg) getWeapon(arg) end,
    ["/f"] = function(arg) getFightingStyle(arg) end,
    ["/e"] = function(arg) equipFruit(arg) end,
    ["/tt"] = function(arg) equipTitle(arg) end,
    ["/pirate"] = function() setTeam("Pirates") end,
    ["/marine"] = function() setTeam("Marines") end,
    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
    ["/help"] = function()
        notify("Help",
            "Commands:\n"..
            "/g <weapon>\n"..
            "/f <style>\n"..
            "/e <fruit>\n"..
            "/tt <title>\n"..
            "/sea1-3\n"..
            "/pirate\n"..
            "/marine",10)
    end
}

-- ================================
-- Chat Listener
-- ================================
PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if Commands[cmd] then
        Commands[cmd](arg)
    end
end)

notify("✅ Dynamic Script Loaded","Type /help for commands",5)
