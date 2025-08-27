local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage.Remotes.CommF_

local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- ================================
-- ALL WEAPONS (Swords + Guns) - EXACT NAMES
-- ================================
local WeaponItems = {
    -- Swords
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
-- ALL FIGHTING STYLES - EXACT NAMES
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
        print("Loading: " .. exactName .. " (" .. category .. ")")
        local ok, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, { category })
        end)
        print(ok and "✅ Success!" or "❌ Error: " .. tostring(result))
    else
        print("❌ Weapon not found: " .. itemName)
    end
end

local function getFightingStyle(styleName)
    local remoteCommand, exactName = findExactMatch(FightingStyles, styleName)
    if remoteCommand then
        print("Getting: " .. exactName .. " -> " .. remoteCommand)
        local ok, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)
        print(ok and "✅ Success!" or "❌ Error: " .. tostring(result))
    else
        print("❌ Fighting style not found: " .. styleName)
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
        print("Traveling to Sea " .. seaNumber .. " -> " .. command)
        local ok, result = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        print(ok and "✅ Travel successful!" or "❌ Travel error: " .. tostring(result))
    else
        print("❌ Invalid sea number. Use /sea1, /sea2, or /sea3")
    end
end

-- ================================
-- COMMANDS TABLE
-- (keys include the space for arg-taking commands)
-- ================================
local Commands = {
    ["/g "] = function(original, lower)
        local itemName = original:sub(#"/g " + 1)
        if itemName == "" then
            print("Usage: /g <weapon name>")
            return
        end
        getWeapon(itemName)
    end,

    ["/f "] = function(original, lower)
        local styleName = original:sub(#"/f " + 1)
        if styleName == "" then
            print("Usage: /f <style name>")
            return
        end
        getFightingStyle(styleName)
    end,

    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
}

-- ================================
-- CHAT LISTENER
-- ================================
PlayerChatted:Connect(function(message)
    local lowerMessage = message:lower()
    for prefix, handler in pairs(Commands) do
        if lowerMessage:sub(1, #prefix) == prefix then
            handler(message, lowerMessage)
            return
        end
    end
end)

-- ================================
-- PRINT HELP
-- ================================
print("✅ All commands loaded!")
print("WEAPONS: /g <weaponname>")
print("FIGHTING STYLES: /f <stylename>")
print("TRAVEL: /sea1, /sea2, /sea3")
print("Examples:")
print("/g Skull Guitar")
print("/f Godhuman")
print("/sea1 - Travel to First Sea")
print("/sea2 - Travel to Second Sea")
print("/sea3 - Travel to Third Sea")
