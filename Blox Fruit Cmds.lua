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
-- Titles (220 Titles)
-- ================================
local Titles = {
    ["The Glorious"]="The Glorious", ["Slayer of God"]="Slayer of God", ["Pirate Hunter"]="Pirate Hunter",
    ["Beast Slayer"]="Beast Slayer", ["Dragon Slayer"]="Dragon Slayer", ["The Chosen"]="The Chosen",
    ["Conqueror"]="Conqueror", ["Demon"]="Demon", ["Angel"]="Angel", ["Godspeed"]="Godspeed",
    ["The Mighty"]="The Mighty", ["The Unleashed"]="The Unleashed", ["Unmatched Speed"]="Unmatched Speed",
    ["Sea Monster"]="Sea Monster", ["Sacred Warrior"]="Sacred Warrior", ["The Ghoul"]="The Ghoul",
    ["The Cyborg"]="The Cyborg", ["Elder Wyrm"]="Elder Wyrm", ["Full Power"]="Full Power",
    ["Warrior of the Sea"]="Warrior of the Sea", ["Perfect Being"]="Perfect Being", ["Hell Hound"]="Hell Hound",
    ["War Machine"]="War Machine", ["Berserker"]="Berserker", ["Ancient Flame"]="Ancient Flame",
    ["Thunderbolt"]="Thunderbolt", ["Leviathan"]="Leviathan", ["His Majesty"]="His Majesty",
    ["Nightwalker"]="Nightwalker", ["Genesis"]="Genesis", ["Bounty Hunter"]="Bounty Hunter",
    ["Warlord of the Sea"]="Warlord of the Sea", ["Emperor of the Sea"]="Emperor of the Sea",
    ["Empress of the Sea"]="Empress of the Sea", ["Admiral"]="Admiral", ["Fleet Admiral"]="Fleet Admiral",
    ["Enlightened One"]="Enlightened One", ["Awakened One"]="Awakened One", ["Over Heaven"]="Over Heaven",
    ["Over Hell"]="Over Hell", ["Flame Fist"]="Flame Fist", ["The Ice Queen"]="The Ice Queen",
    ["The Ice King"]="The Ice King", ["The Strongest One"]="The Strongest One", ["The First Light"]="The First Light",
    ["Dark Lord"]="Dark Lord", ["The Spider"]="The Spider", ["Thunder God"]="Thunder God",
    ["The Red Dog"]="The Red Dog", ["Colossal God"]="Colossal God", ["Desert Prince"]="Desert Prince",
    ["The Phoenix"]="The Phoenix", ["Bread Chaser"]="Bread Chaser", ["Innovator"]="Innovator",
    ["Pygglor, Devourer of Worlds"]="Pygglor, Devourer of Worlds", ["Wen Lord Toad"]="Wen Lord Toad",
    ["Big News"]="Big News", ["Youtuber"]="Youtuber", ["Ace Squad"]="Ace Squad",
    ["Officially a Noob"]="Officially a Noob", ["Water Gang"]="Water Gang", ["Don Axiore Familia"]="Don Axiore Familia",
    ["Mafia Gang"]="Mafia Gang", ["Heorua Family"]="Heorua Family", ["Magic Slayer"]="Magic Slayer",
    ["Kitt Katt"]="Kitt Katt", ["Team JC"]="Team JC", ["El Combo God"]="El Combo God",
    ["Nakama Forever"]="Nakama Forever", ["Endless Fantasy"]="Endless Fantasy", ["El Krazy Editor"]="El Krazy Editor",
    ["rip_family"]="rip_family", ["red_legion"]="red_legion", ["Justice Seeker"]="Justice Seeker",
    ["Empty Vessel"]="Empty Vessel", ["The Unlucky"]="The Unlucky", ["The Vanquished"]="The Vanquished",
    ["Fallen Hero"]="Fallen Hero", ["Iron Man"]="Iron Man", ["Ultra Instinct"]="Ultra Instinct",
    ["Mad Scientist"]="Mad Scientist", ["The Professor"]="The Professor", ["The Shadow"]="The Shadow",
    ["The Vampire"]="The Vampire", ["Dracula"]="Dracula", ["The Grandfather"]="The Grandfather",
    ["Jack of All Trades"]="Jack of All Trades", ["The Undefeated One"]="The Undefeated One",
    ["Immortal Being"]="Immortal Being", ["The Mad King"]="The Mad King", ["The Mastermind"]="The Mastermind",
    ["The Dog"]="The Dog", ["Ship Destroyer"]="Ship Destroyer", ["The Explorer"]="The Explorer",
    ["The Adventurer"]="The Adventurer", ["The Mercenary"]="The Mercenary", ["The Viking"]="The Viking",
    ["The Pioneer"]="The Pioneer", ["Unbreakable Will"]="Unbreakable Will", ["Fist of Death"]="Fist of Death",
    ["God Blade"]="God Blade", ["King Sniper"]="King Sniper", ["Beyond the Sea"]="Beyond the Sea",
    ["Broken Heart"]="Broken Heart", ["The Conqueror"]="The Conqueror", ["Last Hope"]="Last Hope",
    ["The Supersonic"]="The Supersonic", ["The Flash"]="The Flash", ["The Champion"]="The Champion",
    ["Tide Warrior"]="Tide Warrior", ["The Toxic"]="The Toxic", ["Blessed One"]="Blessed One",
    ["Equal to the Heavens"]="Equal to the Heavens", ["The Rich"]="The Rich", ["Unlimited Money"]="Unlimited Money",
    ["The Richest in the World"]="The Richest in the World"
}

-- ================================
-- Helper Functions
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

local function getTitle(name)
    local _, exactName = findExactMatch(Titles, name)
    if exactName then
        local ok, res = pcall(function()
            return CommF_:InvokeServer("activateTitle", exactName)
        end)
        notify("Title", ok and "✅ "..exactName.." equipped!" or "❌ "..tostring(res), 5)
    else
        notify("Title", "❌ Not found: "..name, 5)
    end
end

local function equipFruit(name)
    if not name or name == "" then
        notify("Fruit", "Usage: /e <fruit name>", 5)
        return
    end
    local ok, res = pcall(function()
        return CommF_:InvokeServer("EquipFruit", name)
    end)
    notify("Fruit", ok and "✅ "..name.." equipped!" or "❌ "..tostring(res), 5)
end

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
    elseif m:sub(1,3) == "/t " then
        getTitle(msg:sub(4))
    elseif m:sub(1,3) == "/e " then
        equipFruit(msg:sub(4))
    elseif m:sub(1,5) == "/sea1" then
        travelToSea("1")
    elseif m:sub(1,5) == "/sea2" then
        travelToSea("2")
    elseif m:sub(1,5) == "/sea3" then
        travelToSea("3")
    elseif m:sub(1,5) == "/help" then
        notify("Help","Commands:\n/g <weapon>\n/f <style>\n/t <title>\n/e <fruit>\n/sea1 /sea2 /sea3",10)
    end
end)

notify("✅ Script Loaded","Type /help for commands",5)
