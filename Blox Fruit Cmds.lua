local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- ================================
-- NOTIFICATION FUNCTION
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
-- WEAPONS
-- ================================
local WeaponItems = {
    ["Dark Blade"] = "Swords",
    ["Cursed Dual Katana"] = "Swords",
    ["True Triple Katana"] = "Swords",
    ["Yama"] = "Swords",
    ["Tushita"] = "Swords",
    ["Shark Anchor"] = "Swords",
    ["Hallow Scythe"] = "Swords",
    ["Rengoku"] = "Swords",
    ["Saber"] = "Swords",
    ["Pole"] = "Swords",
    ["Dual-Headed Blade"] = "Swords",
    ["Trident"] = "Swords",
    ["Pipe"] = "Swords",
    ["Dual Katana"] = "Swords",
    ["Triple Katana"] = "Swords",
    ["Iron Mace"] = "Swords",
    ["Double Flintlock"] = "Swords",
    ["Bisento"] = "Swords",
    ["Soul Cane"] = "Swords",
    ["Jitte"] = "Swords",
    ["Hueco Mundo"] = "Swords",
    ["Hollow Blade"] = "Swords",
    ["Yoru"] = "Swords",
    ["Shisui"] = "Swords",
    ["Saddi"] = "Swords",
    ["Wando"] = "Swords",
    ["Buddy Sword"] = "Swords",
    ["Canvander"] = "Swords",
    ["Spikey Trident"] = "Swords",
    ["Dragon Trident"] = "Swords",
    ["Gravity Cane"] = "Swords",
    ["Koko"] = "Swords",
    ["Midnight Blade"] = "Swords",
    ["Longsword"] = "Swords",
    ["Fox Lamp"] = "Swords",
    ["God's Chalice"] = "Swords",
    ["Saw"] = "Swords",
    ["Gyffin's Claw"] = "Swords",
    ["Cursed Kazashi"] = "Swords",
    ["Neo Triple Katana"] = "Swords",
    ["Magnetized Triple Katana"] = "Swords",
    ["Magnetized Blades"] = "Swords",
    ["Sunken Sword"] = "Swords",
    ["Sunken Essence"] = "Swords",
    ["Mythril Sword"] = "Swords",
    ["Mythril Dagger"] = "Swords",
    ["Mythril Hammer"] = "Swords",
    ["Obsidian Sword"] = "Swords",
    ["Obsidian Dagger"] = "Swords",
    ["Obsidian Hammer"] = "Swords",
    ["Eternal Nightstick"] = "Swords",
    ["Heaven's Censer"] = "Swords",
    ["Hell's Incinerator"] = "Swords",
    ["Zweihander"] = "Swords",

    -- Guns
    ["Skull Guitar"] = "Guns",
    ["Kabucha"] = "Guns",
    ["Acidum Rifle"] = "Guns",
    ["Bizarre Rifle"] = "Guns",
    ["Serpent Bow"] = "Guns",
    ["Slingshot"] = "Guns",
    ["Musket"] = "Guns",
    ["Flintlock"] = "Guns",
    ["Refined Flintlock"] = "Guns",
    ["Cannon"] = "Guns",
    ["Refined Slingshot"] = "Guns",
    ["Bazooka"] = "Guns",
    ["Ice Quake"] = "Guns",
    ["Scarlet Barrage"] = "Guns",
    ["Ghost Rifle"] = "Guns",
    ["Spectral Blaster"] = "Guns",
    ["Necro Pistol"] = "Guns",
    ["Phantom Shooter"] = "Guns",
    ["Demon Blaster"] = "Guns",
    ["Angel's Fury"] = "Guns",
    ["Dragon's Breath"] = "Guns",
}

-- ================================
-- FIGHTING STYLES
-- ================================
local FightingStyles = {
    ["Godhuman"] = "BuyGodhuman",
    ["Superhuman"] = "BuySuperhuman",
    ["Death Step"] = "BuyDeathStep",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Electric"] = "BuyElectro",
    ["Dragon Breath"] = "BuyDragonBreath",
    ["Dark Step"] = "BuyBlackLeg",
    ["Water Kung Fu"] = "BuyWaterKungfu",
    ["Sanguine Art"] = "BuySanguineArt",
    ["Blood Style"] = "BuySanguineArt",
    ["Combat"] = "BuyCombat",
    ["Fishman Karate"] = "BuyFishmanKarate",
    ["Martial Arts"] = "BuyMartialArts",
    ["Black Leg"] = "BuyBlackLeg",
    ["Drunken Fist"] = "BuyDrunkenFist",
    ["Cyborg Style"] = "BuyCyborg",
    ["Android Technique"] = "BuyAndroid",
    ["Vampire Brawl"] = "BuyVampire",
    ["Werewolf Fury"] = "BuyWerewolf",
    ["Phoenix Style"] = "BuyPhoenixStyle",
    ["Dragon Style"] = "BuyDragonStyle",
    ["Demon Art"] = "BuyDemonArt",
    ["Angel Technique"] = "BuyAngelTechnique",
    ["Gravity Fist"] = "BuyGravityFist",
    ["Time Knuckle"] = "BuyTimeKnuckle",
    ["Space Palm"] = "BuySpacePalm",
    ["Venom Strike"] = "BuyVenomStrike",
    ["Magma Punch"] = "BuyMagmaPunch",
    ["Ice Fist"] = "BuyIceFist",
    ["Lightning Hand"] = "BuyLightningHand",
    ["Earth Shaker"] = "BuyEarthShaker",
    ["Wind Cutter"] = "BuyWindCutter",
}

-- ================================
-- Helpers
-- ================================
local function findExactMatch(tbl, searchName)
    searchName = searchName:lower()
    for itemName, value in pairs(tbl) do
        if itemName:lower() == searchName then
            return value, itemName
        end
    end
    return nil, nil
end

local function getWeapon(itemName)
    local category, exactName = findExactMatch(WeaponItems, itemName)
    if category then
        notify("Weapon", "Loading " .. exactName .. " (" .. category .. ")", 5)
        local ok, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, { category })
        end)
        notify("Weapon", ok and "✅ Success!" or "❌ Error: " .. tostring(result), 5)
    else
        notify("Weapon", "❌ Not found: " .. itemName, 5)
    end
end

local function getFightingStyle(styleName)
    local remoteCommand, exactName = findExactMatch(FightingStyles, styleName)
    if remoteCommand then
        notify("Fighting Style", "Getting " .. exactName, 5)
        local ok, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)
        notify("Fighting Style", ok and "✅ Success!" or "❌ Error: " .. tostring(result), 5)
    else
        notify("Fighting Style", "❌ Not found: " .. styleName, 5)
    end
end

local function travelToSea(seaNumber)
    local travelCommands = {
        ["1"] = "TravelMain",
        ["2"] = "TravelDressrosa",
        ["3"] = "TravelZou",
    }
    local command = travelCommands[seaNumber]
    if command then
        notify("Travel", "Going to Sea " .. seaNumber, 5)
        local ok, result = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        notify("Travel", ok and "✅ Success!" or "❌ Error: " .. tostring(result), 5)
    else
        notify("Travel", "❌ Invalid sea number", 5)
    end
end

local function activateTitle(titleName)
    if not titleName or titleName == "" then
        notify("Title", "Usage: /t <title name>", 5)
        return
    end
    notify("Title", "Activating " .. titleName, 5)
    local ok, result = pcall(function()
        return CommF_:InvokeServer("activateTitle", titleName)
    end)
    notify("Title", ok and "✅ Activated!" or "❌ Error: " .. tostring(result), 5)
end

-- ================================
-- COMMANDS TABLE
-- ================================
local Commands = {
    ["/g "] = function(original)
        local itemName = original:sub(#"/g " + 1):gsub("^%s+", "")
        getWeapon(itemName)
    end,

    ["/f "] = function(original)
        local styleName = original:sub(#"/f " + 1):gsub("^%s+", "")
        getFightingStyle(styleName)
    end,

    ["/t "] = function(original)
        local titleName = original:sub(#"/t " + 1):gsub("^%s+", "")
        activateTitle(titleName)
    end,

    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,

    ["/help"] = function()
        notify("HELP", "Commands:\n/g <weapon>\n/f <style>\n/t <title>\n/sea1 /sea2 /sea3", 10)
    end,
}

-- ================================
-- CHAT LISTENER
-- ================================
PlayerChatted:Connect(function(message)
    local lowerMessage = message:lower()
    for prefix, handler in pairs(Commands) do
        if lowerMessage:sub(1, #prefix) == prefix:lower() then
            handler(message)
            return
        end
    end
end)

notify("✅ Loaded!", "Type /help for commands", 8)
