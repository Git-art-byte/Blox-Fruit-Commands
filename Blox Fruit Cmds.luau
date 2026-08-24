-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- ================================
-- Notification
-- ================================
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
-- Fruit Mapping (for /i)
-- ================================
local FruitMapping = {
    ["Rocket"]="Rocket-Rocket", ["Spin"]="Spin-Spin", ["Blade"]="Blade-Blade", ["Spring"]="Spring-Spring", 
    ["Bomb"]="Bomb-Bomb", ["Smoke"]="Smoke-Smoke", ["Spike"]="Spike-Spike", ["Flame"]="Flame-Flame", 
    ["Ice"]="Ice-Ice", ["Sand"]="Sand-Sand", ["Dark"]="Dark-Dark", ["Light"]="Light-Light", 
    ["Magma"]="Magma-Magma", ["Quake"]="Quake-Quake", ["Love"]="Love-Love", ["Portal"]="Portal-Portal",
    ["Spider"]="Spider-Spider", ["Sound"]="Sound-Sound", ["Phoenix"]="Phoenix-Phoenix", ["Rumble"]="Rumble-Rumble", 
    ["Pain"]="Pain-Pain", ["Blizzard"]="Blizzard-Blizzard", ["Gravity"]="Gravity-Gravity", ["Mammoth"]="Mammoth-Mammoth", 
    ["T-Rex"]="T-Rex-T-Rex", ["Dough"]="Dough-Dough", ["Shadow"]="Shadow-Shadow", ["Venom"]="Venom-Venom", 
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Tiger"]="Tiger-Tiger", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon", ["Buddha"]="Buddha-Buddha"
}

-- ================================
-- Shortcuts for /i
-- Add any alias here : "shortcut" = "actual_name"
-- ================================
local Shortcuts = {
    ["leo" or "Leo"] = "Tiger",   -- because Tiger used to be called Leopard
    ["cdk" or "Cdk"] = "Cursed Dual Katana",
    ["kab" or "Kab"] = "Kabucha",
    ["sc" or "Sc"] = "Soul Cane",
    ["sg" or "soul" or "Soul" or "Sg"] = "Skull Guitar",
    -- Add more as needed
}

-- ================================
-- Travel
-- ================================
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Commands
-- ================================

local function handleItem(itemName)
    if not itemName or itemName == "" then
        notify("Item", "❌ Please specify a weapon or fruit name", 5)
        return
    end

    -- Check shortcuts first
    local shortcutName = Shortcuts[itemName:lower()]
    if shortcutName then
        itemName = shortcutName
    end

    -- Check if it's a fruit
    for name, remoteName in pairs(FruitMapping) do
        if name:lower() == itemName:lower() then
            local success, result = pcall(function()
                return CommF_:InvokeServer("SwitchFruit", remoteName)
            end)
            notify("Fruit", success and "✅ Equipped " .. name or "❌ " .. tostring(result), 5)
            return
        end
    end

    -- If not a fruit, treat as weapon (LoadItem)
    local success, result = pcall(function()
        return CommF_:InvokeServer("LoadItem", itemName, nil)
    end)
    notify("Weapon", success and "✅ Loaded " .. itemName or "❌ " .. tostring(result), 5)
end

local function equipTitle(titleName)
    if not titleName or titleName == "" then
        notify("Title", "❌ Please specify a title name", 5)
        return
    end
    local success, result = pcall(function()
        return CommF_:InvokeServer("activateTitle", titleName)
    end)
    notify("Title", success and "✅ Activated " .. titleName or "❌ " .. tostring(result), 5)
end

local function travelToSea(seaNumber)
    local command = TravelCommands[seaNumber]
    if command then
        local success, result = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        notify("Travel", success and "✅ Travel to Sea "..seaNumber or "❌ "..tostring(result),5)
    else
        notify("Travel","❌ Use /sea1, /sea2, /sea3",5)
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
    ["/i"] = handleItem,
    ["/tt"] = equipTitle,
    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
    ["/pirate"] = function() setTeam("Pirates") end,
    ["/marine"] = function() setTeam("Marines") end,
}

PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if Commands[cmd] then
        Commands[cmd](arg)
    end
end)
