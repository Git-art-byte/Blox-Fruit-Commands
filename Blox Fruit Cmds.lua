local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage.Remotes.CommF_

local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- ALL WEAPONS (Swords + Guns) - WITH EXACT NAMES
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
    ["Skull Guitar"] = "Guns", -- FIXED: Changed from "Soul Guitar" to "Skull Guitar"
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

-- ALL FIGHTING STYLES
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

-- Function to find exact match (case-insensitive search, returns exact name)
local function findExactMatch(table, searchName)
    searchName = searchName:lower()
    for itemName, value in pairs(table) do
        if itemName:lower() == searchName then
            return value, itemName
        end
    end
    return nil, nil
end

-- Function to get weapon
local function getWeapon(itemName)
    local category, exactName = findExactMatch(WeaponItems, itemName)
    
    if category then
        print("Loading: " .. exactName .. " (" .. category .. ")")
        
        local success, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, {category})
        end)

        if success then
            print("✅ Success!")
        else
            print("❌ Error: " .. tostring(result))
        end
    else
        print("❌ Weapon not found: " .. itemName)
    end
end

-- Function to get fighting style
local function getFightingStyle(styleName)
    local remoteCommand, exactName = findExactMatch(FightingStyles, styleName)
    
    if remoteCommand then
        print("Getting: " .. exactName .. " -> " .. remoteCommand)
        
        local success, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)

        if success then
            print("✅ Success!")
        else
            print("❌ Error: " .. tostring(result))
        end
    else
        print("❌ Fighting style not found: " .. styleName)
    end
end

-- Connect chat commands
PlayerChatted:Connect(function(message)
    local command = message:lower()

    if command:sub(1, 3) == "/g " then
        local itemName = message:sub(4)
        getWeapon(itemName)
        
    elseif command:sub(1, 3) == "/f " then
        local styleName = message:sub(4)
        getFightingStyle(styleName)
    end
end)

print("✅ All weapons and fighting styles loaded!")
print("WEAPONS: /g <weaponname>")
print("FIGHTING STYLES: /f <stylename>")
print("Examples:")
print("/g Skull Guitar")  -- FIXED: Changed from Soul Guitar to Skull Guitar
print("/g Cursed Dual Katana")
print("/g Kabucha")
print("/f Godhuman")
print("/f Electric Claw")
print("/f Death Step")
