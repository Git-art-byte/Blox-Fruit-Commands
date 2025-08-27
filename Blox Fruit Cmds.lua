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
-- Weapon and Fighting Style Data
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
    ["Zweihander"]="Swords",

    ["Skull Guitar"]="Guns", ["Kabucha"]="Guns", ["Acidum Rifle"]="Guns", ["Bizarre Rifle"]="Guns",
    ["Serpent Bow"]="Guns", ["Slingshot"]="Guns", ["Musket"]="Guns", ["Flintlock"]="Guns",
    ["Refined Flintlock"]="Guns", ["Cannon"]="Guns", ["Refined Slingshot"]="Guns", ["Bazooka"]="Guns",
    ["Ice Quake"]="Guns", ["Scarlet Barrage"]="Guns", ["Ghost Rifle"]="Guns", ["Spectral Blaster"]="Guns",
    ["Necro Pistol"]="Guns", ["Phantom Shooter"]="Guns", ["Demon Blaster"]="Guns", ["Angel's Fury"]="Guns",
    ["Dragon's Breath"]="Guns"
}

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

local FruitMapping = {
    ["Rocket"]="Rocket-Rocket", ["Spin"]="Spin-Spin", ["Blade"]="Chop-Chop", ["Spring"]="Spring-Spring", 
    ["Bomb"]="Bomb-Bomb", ["Smoke"]="Smoke-Smoke", ["Spike"]="Spike-Spike", ["Flame"]="Flame-Flame", 
    ["Ice"]="Ice-Ice", ["Sand"]="Sand-Sand", ["Dark"]="Dark-Dark", ["Light"]="Light-Light", 
    ["Magma"]="Magma-Magma", ["Quake"]="Quake-Quake", ["Love"]="Love-Love", ["Portal"]="Portal-Portal",
    ["Spider"]="Spider-Spider", ["Sound"]="Sound-Sound", ["Phoenix"]="Phoenix-Phoenix", ["Rumble"]="Rumble-Rumble", 
    ["Pain"]="Pain-Pain", ["Blizzard"]="Blizzard-Blizzard", ["Gravity"]="Gravity-Gravity", ["Mammoth"]="Mammoth-Mammoth", 
    ["T-Rex"]="T-Rex-T-Rex", ["Dough"]="Dough-Dough", ["Shadow"]="Shadow-Shadow", ["Venom"]="Venom-Venom", 
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Leopard"]="Leopard-Leopard", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon"
}

local Titles = {
    ["The Unleashed"]="The Unleashed", ["Unmatched Speed"]="Unmatched Speed", ["Sea Monster"]="Sea Monster",
    ["Sacred Warrior"]="Sacred Warrior", ["The Ghoul"]="The Ghoul", ["Cyborg"]="Cyborg", ["Draco"]="Draco",
    ["The Swordsman"]="The Swordsman", ["Ultimate Shooter"]="Ultimate Shooter", ["Transcendent"]="Transcendent",
    ["King of the Sea"]="King of the Sea", ["Grand Admiral"]="Grand Admiral", ["Warden of the Prison"]="Warden of the Prison",
    ["Chief Warden"]="Chief Warden", ["Soul Reaper"]="Soul Reaper", ["The Chosen"]="The Chosen", ["Dragon Tamer"]="Dragon Tamer",
    ["Phoenix Wielder"]="Phoenix Wielder", ["Demon Slayer"]="Demon Slayer", ["Angel Hunter"]="Angel Hunter",
    ["Gravity Master"]="Gravity Master", ["Time Keeper"]="Time Keeper", ["Space Explorer"]="Space Explorer",
    ["Venomous"]="Venomous", ["Magma Lord"]="Magma Lord", ["Ice Emperor"]="Ice Emperor", ["Lightning God"]="Lightning God",
    ["Earth Shaker"]="Earth Shaker", ["Wind Walker"]="Wind Walker", ["Dark Lord"]="Dark Lord", ["Light Bringer"]="Light Bringer",
    ["Love Doctor"]="Love Doctor", ["Portal Master"]="Portal Master", ["Sound Conductor"]="Sound Conductor",
    ["Spider King"]="Spider King", ["Rumble Master"]="Rumble Master", ["Pain Inflictor"]="Pain Inflictor",
    ["Blizzard Creator"]="Blizzard Creator", ["Mammoth Rider"]="Mammoth Rider", ["T-Rex Tamer"]="T-Rex Tamer",
    ["Dough Master"]="Dough Master", ["Shadow Assassin"]="Shadow Assassin", ["Control Master"]="Control Master",
    ["Gas Manipulator"]="Gas Manipulator", ["Spirit Channeler"]="Spirit Channeler", ["Leopard Hunter"]="Leopard Hunter",
    ["Yeti Hunter"]="Yeti Hunter", ["Kitsune Tamer"]="Kitsune Tamer", ["Dragon Rider"]="Dragon Rider",
    ["Rocket Man"]="Rocket Man", ["Spin Master"]="Spin Master", ["Blade Master"]="Blade Master",
    ["Spring Master"]="Spring Master", ["Bomb Expert"]="Bomb Expert", ["Smoke Master"]="Smoke Master",
    ["Spike Expert"]="Spike Expert", ["Flame Master"]="Flame Master", ["Ice Master"]="Ice Master",
    ["Sand Master"]="Sand Master", ["Dark Master"]="Dark Master", ["Light Master"]="Light Master",
    ["Magma Master"]="Magma Master", ["Quake Master"]="Quake Master", ["Love Master"]="Love Master",
    ["Portal Expert"]="Portal Expert", ["Spider Master"]="Spider Master", ["Sound Master"]="Sound Master",
    ["Phoenix Master"]="Phoenix Master", ["Rumble Expert"]="Rumble Expert", ["Pain Master"]="Pain Master",
    ["Blizzard Master"]="Blizzard Master", ["Gravity Expert"]="Gravity Expert", ["Mammoth Master"]="Mammoth Master",
    ["T-Rex Master"]="T-Rex Master", ["Dough Expert"]="Dough Expert", ["Shadow Master"]="Shadow Master",
    ["Venom Master"]="Venom Master", ["Control Expert"]="Control Expert", ["Gas Master"]="Gas Master",
    ["Spirit Master"]="Spirit Master", ["Leopard Master"]="Leopard Master", ["Yeti Master"]="Yeti Master",
    ["Kitsune Master"]="Kitsune Master", ["Dragon Master"]="Dragon Master", ["First Sea Explorer"]="First Sea Explorer",
    ["Second Sea Explorer"]="Second Sea Explorer", ["Third Sea Explorer"]="Third Sea Explorer",
    ["All Seas Explorer"]="All Seas Explorer", ["Pirate King"]="Pirate King", ["Marine Admiral"]="Marine Admiral",
    ["Bounty Hunter"]="Bounty Hunter", ["Bounty Master"]="Bounty Master", ["Rich"]="Rich", ["Wealthy"]="Wealthy",
    ["Millionaire"]="Millionaire", ["Billionaire"]="Billionaire", ["Trillionaire"]="Trillionaire",
    ["Fruit Collector"]="Fruit Collector", ["Fruit Master"]="Fruit Master", ["Fruit Expert"]="Fruit Expert",
    ["Sword Collector"]="Sword Collector", ["Sword Master"]="Sword Master", ["Sword Expert"]="Sword Expert",
    ["Gun Collector"]="Gun Collector", ["Gun Master"]="Gun Master", ["Gun Expert"]="Gun Expert",
    ["Fighting Style Master"]="Fighting Style Master", ["Martial Arts Master"]="Martial Arts Master",
    ["Black Leg Master"]="Black Leg Master", ["Electric Master"]="Electric Master", ["Dragon Breath Master"]="Dragon Breath Master",
    ["Water Kung Fu Master"]="Water Kung Fu Master", ["Fishman Karate Master"]="Fishman Karate Master",
    ["Superhuman Master"]="Superhuman Master", ["Death Step Master"]="Death Step Master",
    ["Electric Claw Master"]="Electric Claw Master", ["Sharkman Karate Master"]="Sharkman Karate Master",
    ["Dragon Talon Master"]="Dragon Talon Master", ["Godhuman Master"]="Godhuman Master",
    ["Sanguine Art Master"]="Sanguine Art Master", ["Drunken Fist Master"]="Drunken Fist Master",
    ["Cyborg Master"]="Cyborg Master", ["Android Master"]="Android Master", ["Vampire Master"]="Vampire Master",
    ["Werewolf Master"]="Werewolf Master", ["Phoenix Style Master"]="Phoenix Style Master",
    ["Dragon Style Master"]="Dragon Style Master", ["Demon Art Master"]="Demon Art Master",
    ["Angel Technique Master"]="Angel Technique Master", ["Gravity Fist Master"]="Gravity Fist Master",
    ["Time Knuckle Master"]="Time Knuckle Master", ["Space Palm Master"]="Space Palm Master",
    ["Venom Strike Master"]="Venom Strike Master", ["Magma Punch Master"]="Magma Punch Master",
    ["Ice Fist Master"]="Ice Fist Master", ["Lightning Hand Master"]="Lightning Hand Master",
    ["Earth Shaker Master"]="Earth Shaker Master", ["Wind Cutter Master"]="Wind Cutter Master",
    ["Raid Participant"]="Raid Participant", ["Raid Master"]="Raid Master", ["Raid Expert"]="Raid Expert",
    ["Dungeon Explorer"]="Dungeon Explorer", ["Dungeon Master"]="Dungeon Master", ["Dungeon Expert"]="Dungeon Expert",
    ["Factory Worker"]="Factory Worker", ["Factory Master"]="Factory Master", ["Factory Expert"]="Factory Expert",
    ["Ship Breaker"]="Ship Breaker", ["Ship Master"]="Ship Master", ["Ship Expert"]="Ship Expert",
    ["Island Hopper"]="Island Hopper", ["Island Master"]="Island Master", ["Island Expert"]="Island Expert",
    ["Boss Slayer"]="Boss Slayer", ["Boss Master"]="Boss Master", ["Boss Expert"]="Boss Expert",
    ["Elite Hunter"]="Elite Hunter", ["Elite Master"]="Elite Master", ["Elite Expert"]="Elite Expert",
    ["Player Hunter"]="Player Hunter", ["Player Master"]="Player Master", ["Player Expert"]="Player Expert",
    ["Cake Master"]="Cake Master", ["Cake Expert"]="Cake Expert", ["Cake Collector"]="Cake Collector",
    ["Halloween Master"]="Halloween Master", ["Halloween Expert"]="Halloween Expert", ["Christmas Master"]="Christmas Master",
    ["Christmas Expert"]="Christmas Expert", ["New Year Master"]="New Year Master", ["New Year Expert"]="New Year Expert",
    ["Easter Master"]="Easter Master", ["Easter Expert"]="Easter Expert", ["Summer Master"]="Summer Master",
    ["Summer Expert"]="Summer Expert", ["Winter Master"]="Winter Master", ["Winter Expert"]="Winter Expert",
    ["Spring Master"]="Spring Master", ["Spring Expert"]="Spring Expert", ["Fall Master"]="Fall Master",
    ["Fall Expert"]="Fall Expert", ["Event Master"]="Event Master", ["Event Expert"]="Event Expert",
    ["Legendary"]="Legendary", ["Mythical"]="Mythical", ["Divine"]="Divine", ["Celestial"]="Celestial",
    ["Demonic"]="Demonic", ["Angelic"]="Angelic", ["Eternal"]="Eternal", ["Immortal"]="Immortal",
    ["Invincible"]="Invincible", ["Unstoppable"]="Unstoppable", ["Unbeatable"]="Unbeatable",
    ["Undefeated"]="Undefeated", ["Champion"]="Champion", ["Hero"]="Hero", ["Villain"]="Villain",
    ["Protector"]="Protector", ["Destroyer"]="Destroyer", ["Creator"]="Creator", ["Savior"]="Savior",
    ["Warrior"]="Warrior", ["Mage"]="Mage", ["Rogue"]="Rogue", ["Paladin"]="Paladin",
    ["Necromancer"]="Necromancer", ["Alchemist"]="Alchemist", ["Blacksmith"]="Blacksmith",
    ["Merchant"]="Merchant", ["Fisherman"]="Fisherman", ["Farmer"]="Farmer", ["Miner"]="Miner",
    ["Woodcutter"]="Woodcutter", ["Hunter"]="Hunter", ["Gatherer"]="Gatherer", ["Crafter"]="Crafter",
    ["Enchanter"]="Enchanter", ["Scholar"]="Scholar", ["Sage"]="Sage", ["Wise"]="Wise",
    ["Intelligent"]="Intelligent", ["Genius"]="Genius", ["Brilliant"]="Brilliant", ["Smart"]="Smart",
    ["Clever"]="Clever", ["Quick"]="Quick", ["Swift"]="Swift", ["Fast"]="Fast",
    ["Agile"]="Agile", ["Nimble"]="Nimble", ["Graceful"]="Graceful", ["Elegant"]="Elegant",
    ["Lucky"]="Lucky", ["Fortunate"]="Fortunate", ["Blessed"]="Blessed", ["Cursed"]="Cursed",
    ["Unlucky"]="Unlucky", ["Doomed"]="Doomed", ["Damned"]="Damned", ["Forsaken"]="Forsaken",
    ["Risen"]="Risen", ["Awakened"]="Awakened", ["Enlightened"]="Enlightened", ["Transformed"]="Transformed",
    ["Evolved"]="Evolved", ["Ascended"]="Ascended", ["Divine Being"]="Divine Being", ["God"]="God"
}

local TravelCommands = {["1"]="TravelMain", ["2"]="TravelDressrosa", ["3"]="TravelZou"}

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

local function findTitleMatch(searchName)
    searchName = searchName:lower()
    for titleName, value in pairs(Titles) do
        if titleName:lower():find(searchName) then
            return value, titleName
        end
    end
    return nil, nil
end

local function getWeapon(itemName)
    local category, exactName = findExactMatch(WeaponItems, itemName)
    if category then
        local success, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", exactName, {category})
        end)
        notify("Weapon", success and "✅ Loaded "..exactName or "❌ "..tostring(result),5)
    else
        notify("Weapon","❌ Weapon not found: "..itemName,5)
    end
end

local function getFightingStyle(styleName)
    local remoteCommand, exactName = findExactMatch(FightingStyles, styleName)
    if remoteCommand then
        local success, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)
        notify("Fighting Style", success and "✅ Got "..exactName or "❌ "..tostring(result),5)
    else
        notify("Fighting Style","❌ Not found: "..styleName,5)
    end
end

local function travelToSea(seaNumber)
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
    local titleValue, exactName = findTitleMatch(name)
    if titleValue then
        local success, result = pcall(function()
            return CommF_:InvokeServer("ActivateTitle", titleValue)
        end)
        notify("Title", success and "✅ "..exactName.." activated" or "❌ "..tostring(result),5)
    else
        notify("Title","❌ Not found: "..name,5)
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
-- Chat Commands
-- ================================
PlayerChatted:Connect(function(msg)
    local m = msg:lower()
    if m:sub(1,3)=="/g " then
        getWeapon(msg:sub(4))
    elseif m:sub(1,3)=="/f " then
        getFightingStyle(msg:sub(4))
    elseif m:sub(1,5)=="/sea1" then travelToSea("1")
    elseif m:sub(1,5)=="/sea2" then travelToSea("2")
    elseif m:sub(1,5)=="/sea3" then travelToSea("3")
    elseif m:sub(1,3)=="/e " then equipFruit(msg:sub(4))
    elseif m:sub(1,4)=="/tt " then equipTitle(msg:sub(5))
    elseif m:sub(1,7)=="/pirate" then setTeam("Pirates")
    elseif m:sub(1,6)=="/marine" then setTeam("Marines")
    elseif m:sub(1,5)=="/help" then
        notify("Help","Commands:\n/g <weapon>\n/f <style>\n/sea1-3\n/e <fruit>\n/tt <title>\n/Pirate\n/Marine",10)
    end
end)

notify("✅ Script Loaded","Type /help for commands",5)
