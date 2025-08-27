-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- ================================
-- Notification Function
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
-- Weapons
-- ================================
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

-- ================================
-- Fighting Styles
-- ================================
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

-- ================================
-- Titles
-- ================================
local Titles = {
    ["Unmatched Speed"]="Unmatched Speed",
    ["The Glorious"]="The Glorious",
    ["Slayer of God"]="Slayer of God"
    -- add more titles here
}

-- ================================
-- Permanent Fruit Friendly Names
-- ================================
local FruitMapping = {
    ["Rubber"] = "Gomu-Gomu",
    ["Flame"] = "Mera-Mera",
    ["Ice"] = "Hie-Hie",
    ["Light"] = "Pika-Pika",
    ["Dark"] = "Yami-Yami",
    ["Buddha"] = "Buddha-Buddha",
    ["Sand"] = "Suna-Suna",
    ["String"] = "Ito-Ito",
    ["Chop"] = "Bara-Bara",
    ["Spike"] = "Toge-Toge"
    -- add more friendly names here
}

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

-- Weapon
local function getWeapon(name)
    local category, exactName = findExactMatch(WeaponItems, name)
    if category then
        notify("Weapon", "Loading "..exactName.." ("..category..")", 5)
        local ok, res = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, {category})
        end)
        notify("Weapon", ok and "✅ Loaded!" or "❌ "..tostring(res), 5)
    else
        notify("Weapon", "❌ Not found: "..name, 5)
    end
end

-- Fighting Style
local function getFightingStyle(name)
    local command, exactName = findExactMatch(FightingStyles, name)
    if command then
        notify("Fighting Style", "Getting "..exactName, 5)
        local ok, res = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        notify("Fighting Style", ok and "✅ Loaded!" or "❌ "..tostring(res), 5)
    else
        notify("Fighting Style", "❌ Not found: "..name, 5)
    end
end

-- Title
local function getTitle(name)
    if not name or name == "" then
        notify("Title", "Usage: /tt <title name>", 5)
        return
    end
    local match, exactName = findExactMatch(Titles, name)
    if match then
        local ok, res = pcall(function()
            return CommF_:InvokeServer("activateTitle", exactName)
        end)
        notify("Title", ok and "✅ "..exactName.." equipped!" or "❌ "..tostring(res), 5)
    else
        notify("Title", "❌ Not found: "..name, 5)
    end
end

-- Permanent Fruit
local function equipFruit(name)
    if not name or name == "" then
        notify("Fruit", "Usage: /e <fruit name>", 5)
        return
    end
    local fruitName = FruitMapping[name]
    if fruitName then
        local ok, res = pcall(function()
            return CommF_:InvokeServer("SwitchFruit", fruitName)
        end)
        notify("Fruit", ok and "✅ "..fruitName.." equipped!" or "❌ "..tostring(res), 5)
    else
        notify("Fruit", "❌ Fruit not found: "..name, 5)
    end
end

-- Travel
local function travelToSea(num)
    local commands = {["1"]="TravelMain", ["2"]="TravelDressrosa", ["3"]="TravelZou"}
    local cmd = commands[num]
    if cmd then
        local ok, res = pcall(function() return CommF_:InvokeServer(cmd) end)
        notify("Travel", ok and "✅ Travel success!" or "❌ "..tostring(res), 5)
    else
        notify("Travel", "❌ Invalid sea number", 5)
    end
end

-- ================================
-- Chat Commands
-- ================================
PlayerChatted:Connect(function(msg)
    local m = msg:lower()
    if m:sub(1,3) == "/g " then
        getWeapon(msg:sub(4))
    elseif m:sub(1,3) == "/f " then
        getFightingStyle(msg:sub(4))
    elseif m:sub(1,4) == "/tt " then
        getTitle(msg:sub(5))
    elseif m:sub(1,3) == "/e " then
        equipFruit(msg:sub(4))
    elseif m:sub(1,7) == "/pirate" then
        local ok, res = pcall(function()
            return CommF_:InvokeServer("SetTeam","Pirates")
        end)
        notify("Team", ok and "✅ Joined Pirates!" or "❌ "..tostring(res), 5)
    elseif m:sub(1,6) == "/marine" then
        local ok, res = pcall(function()
            return CommF_:InvokeServer("SetTeam","Marines")
        end)
        notify("Team", ok and "✅ Joined Marines!" or "❌ "..tostring(res), 5)
    elseif m:sub(1,5) == "/sea1" then
        travelToSea("1")
    elseif m:sub(1,5) == "/sea2" then
        travelToSea("2")
    elseif m:sub(1,5) == "/sea3" then
        travelToSea("3")
    elseif m:sub(1,5) == "/help" then
        notify("Help","Commands:\n/g <weapon>\n/f <style>\n/tt <title>\n/e <fruit>\n/Pirate\n/Marine\n/sea1 /sea2 /sea3",10)
    end
end)

notify("✅ Script Loaded","Type /help for commands",5)
