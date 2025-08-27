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
-- Hard-Coded Data Tables
-- ================================

-- Weapons
local WeaponItems = {
    ["Dark Blade"]="Swords", ["Cursed Dual Katana"]="Swords", ["True Triple Katana"]="Swords",
    ["Yama"]="Swords", ["Tushita"]="Swords", ["Shark Anchor"]="Swords", ["Hallow Scythe"]="Swords",
    ["Rengoku"]="Swords", ["Saber"]="Swords", ["Pole"]="Swords", ["Dual-Headed Blade"]="Swords",
    ["Trident"]="Swords", ["Pipe"]="Swords", ["Dual Katana"]="Swords", ["Triple Katana"]="Swords",
    ["Iron Mace"]="Swords", ["Double Flintlock"]="Swords", ["Bisento"]="Swords", ["Soul Cane"]="Swords",
    ["Jitte"]="Swords", ["Hueco Mundo"]="Swords", ["Hollow Blade"]="Swords", ["Yoru"]="Swords",
    ["Shisui"]="Swords", ["Saddi"]="Swords", ["Wando"]="Swords", ["Buddy Sword"]="Swords",
    ["Canvander"]="Swords", ["Spikey Trident"]="Swords", ["Dragon Trident"]="Swords",
    ["Gravity Cane"]="Swords", ["Koko"]="Swords", ["Midnight Blade"]="Swords", ["Longsword"]="Swords",
    ["Fox Lamp"]="Swords", ["God's Chalice"]="Swords", ["Saw"]="Swords", ["Gyffin's Claw"]="Swords",
    ["Cursed Kazashi"]="Swords", ["Neo Triple Katana"]="Swords", ["Magnetized Triple Katana"]="Swords",
    ["Magnetized Blades"]="Swords", ["Sunken Sword"]="Swords", ["Sunken Essence"]="Swords",
    ["Mythril Sword"]="Swords", ["Mythril Dagger"]="Swords", ["Mythril Hammer"]="Swords",
    ["Obsidian Sword"]="Swords", ["Obsidian Dagger"]="Swords", ["Obsidian Hammer"]="Swords",
    ["Eternal Nightstick"]="Swords", ["Heaven's Censer"]="Swords", ["Hell's Incinerator"]="Swords",
    ["Zweihander"]="Swords", ["Skull Guitar"]="Guns", ["Kabucha"]="Guns", ["Acidum Rifle"]="Guns",
    ["Bizarre Rifle"]="Guns", ["Serpent Bow"]="Guns", ["Slingshot"]="Guns", ["Musket"]="Guns",
    ["Flintlock"]="Guns", ["Refined Flintlock"]="Guns", ["Cannon"]="Guns", ["Refined Slingshot"]="Guns",
    ["Bazooka"]="Guns", ["Ice Quake"]="Guns", ["Scarlet Barrage"]="Guns", ["Ghost Rifle"]="Guns",
    ["Spectral Blaster"]="Guns", ["Necro Pistol"]="Guns", ["Phantom Shooter"]="Guns",
    ["Demon Blaster"]="Guns", ["Angel's Fury"]="Guns", ["Dragon's Breath"]="Guns"
}

-- Fighting Styles
local FightingStyles = {
    ["Godhuman"]="BuyGodhuman", ["Superhuman"]="BuySuperhuman", ["Death Step"]="BuyDeathStep",
    ["Electric Claw"]="BuyElectricClaw", ["Dragon Talon"]="BuyDragonTalon", ["Sharkman Karate"]="BuySharkmanKarate",
    ["Electric"]="BuyElectro", ["Dragon Breath"]="BuyDragonBreath", ["Dark Step"]="BuyBlackLeg",
    ["Water Kung Fu"]="BuyWaterKungfu", ["Sanguine Art"]="BuySanguineArt", ["Blood Style"]="BuySanguineArt",
    ["Combat"]="BuyCombat", ["Fishman Karate"]="BuyFishmanKarate", ["Martial Arts"]="BuyMartialArts",
    ["Black Leg"]="BuyBlackLeg", ["Drunken Fist"]="BuyDrunkenFist", ["Cyborg Style"]="BuyCyborg",
    ["Android Technique"]="BuyAndroid", ["Vampire Brawl"]="BuyVampire", ["Werewolf Fury"]="BuyWerewolf",
    ["Phoenix Style"]="BuyPhoenixStyle", ["Dragon Style"]="BuyDragonStyle", ["Demon Art"]="BuyDemonArt",
    ["Angel Technique"]="BuyAngelTechnique", ["Gravity Fist"]="BuyGravityFist", ["Time Knuckle"]="BuyTimeKnuckle",
    ["Space Palm"]="BuySpacePalm", ["Venom Strike"]="BuyVenomStrike", ["Magma Punch"]="BuyMagmaPunch",
    ["Ice Fist"]="BuyIceFist", ["Lightning Hand"]="BuyLightningHand", ["Earth Shaker"]="BuyEarthShaker",
    ["Wind Cutter"]="BuyWindCutter"
}

-- Fruits
local FruitMapping = {
    ["Rocket"]="Rocket-Rocket", ["Spin"]="Spin-Spin", ["Blade"]="Chop-Chop", ["Spring"]="Spring-Spring", 
    ["Bomb"]="Bomb-Bomb", ["Smoke"]="Smoke-Smoke", ["Spike"]="Spike-Spike", ["Flame"]="Flame-Flame", 
    ["Ice"]="Ice-Ice", ["Sand"]="Sand-Sand", ["Dark"]="Dark-Dark", ["Light"]="Light-Light", 
    ["Magma"]="Magma-Magma", ["Quake"]="Quake-Quake", ["Love"]="Love-Love", ["Portal"]="Portal-Portal",
    ["Spider"]="Spider-Spider", ["Sound"]="Sound-Sound", ["Phoenix"]="Phoenix-Phoenix", ["Rumble"]="Rumble-Rumble", 
    ["Pain"]="Pain-Pain", ["Blizzard"]="Blizzard-Blizzard", ["Gravity"]="Gravity-Gravity", ["Mammoth"]="Mammoth-Mammoth", 
    ["T-Rex"]="T-Rex-T-Rex", ["Dough"]="Dough-Dough", ["Shadow"]="Shadow-Shadow", ["Venom"]="Venom-Venom", 
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Leopard"]="Leopard-Leopard", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon", ["Buddha"]="Human-Human: Buddha"
}

-- ================================
-- Dynamic Titles (even in hard-coded version)
-- ================================
local function getOwnedTitles()
    local titlesFolder = ReplicatedStorage:FindFirstChild("Titles") or LocalPlayer:FindFirstChild("Titles")
    local owned = {}
    if titlesFolder then
        for _,v in pairs(titlesFolder:GetChildren()) do
            if v:IsA("StringValue") or v:IsA("ValueBase") then
                owned[v.Name:lower()] = v.Name
            end
        end
    end
    return owned
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
-- Helper Functions
-- ================================
local function findExactMatch(tbl, searchName)
    searchName = searchName:lower()
    for itemName, value in pairs(tbl) do
        if itemName:lower():find(searchName) then
            return value, itemName
        end
    end
    return nil, nil
end

-- Command Functions
local function getWeapon(name)
    local category, exactName = findExactMatch(WeaponItems, name)
    if category then
        local success, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, {category})
        end)
        notify("Weapon", success and "✅ Loaded "..exactName or "❌ "..tostring(result),5)
    else
        notify("Weapon","❌ Weapon not found: "..name,5)
    end
end

local function getFightingStyle(name)
    local remoteCommand, exactName = findExactMatch(FightingStyles, name)
    if remoteCommand then
        local success, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)
        notify("Fighting Style", success and "✅ Got "..exactName or "❌ "..tostring(result),5)
    else
        notify("Fighting Style","❌ Not found: "..name,5)
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

local function equipFruit(name)
    local fruitName, exactName = findExactMatch(FruitMapping, name)
    if fruitName then
        local success, result = pcall(function()
            return CommF_:InvokeServer("SwitchFruit", fruitName)
        end)
        notify("Fruit", success and "✅ "..exactName.." equipped" or "❌ "..tostring(result),5)
    else
        notify("Fruit","❌ Not found: "..name,5)
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
        notify("Title","❌ Title not found or not owned: "..name,5)
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

notify("✅ Hard-Coded Script Loaded","Type /help for commands",5)
