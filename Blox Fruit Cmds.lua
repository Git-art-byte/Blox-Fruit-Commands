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

-- Fruits - Fixed with correct format
local FruitMapping = {
    ["Rocket"]="Rocket-Rocket", ["Spin"]="Spin-Spin", ["Blade"]="Blade-Blade", ["Spring"]="Spring-Spring", 
    ["Bomb"]="Bomb-Bomb", ["Smoke"]="Smoke-Smoke", ["Spike"]="Spike-Spike", ["Flame"]="Flame-Flame", 
    ["Ice"]="Ice-Ice", ["Sand"]="Sand-Sand", ["Dark"]="Dark-Dark", ["Light"]="Light-Light", 
    ["Magma"]="Magma-Magma", ["Quake"]="Quake-Quake", ["Love"]="Love-Love", ["Portal"]="Portal-Portal",
    ["Spider"]="Spider-Spider", ["Sound"]="Sound-Sound", ["Phoenix"]="Phoenix-Phoenix", ["Rumble"]="Rumble-Rumble", 
    ["Pain"]="Pain-Pain", ["Blizzard"]="Blizzard-Blizzard", ["Gravity"]="Gravity-Gravity", ["Mammoth"]="Mammoth-Mammoth", 
    ["T-Rex"]="T-Rex-T-Rex", ["Dough"]="Dough-Dough", ["Shadow"]="Shadow-Shadow", ["Venom"]="Venom-Venom", 
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Leopard"]="Leopard-Leopard", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon", ["Buddha"]="Buddha-Buddha"
}

-- Complete list of ALL titles
local Titles = {
    ["The Unleashed"]="The Unleashed", ["Unmatched Speed"]="Unmatched Speed", ["Sea Monster"]="Sea Monster",
    ["Sacred Warrior"]="Sacred Warrior", ["The Ghoul"]="The Ghoul", ["Cyborg"]="Cyborg",
    ["God"]="God", ["Slayer of God"]="Slayer of God", ["King of Kings"]="King of Kings",
    ["Emperor"]="Emperor", ["Pirate King"]="Pirate King", ["Marine Admiral"]="Marine Admiral",
    ["Warlord of the Sea"]="Warlord of the Sea", ["Dark King"]="Dark King", ["Soul Reaper"]="Soul Reaper",
    ["Dragon Slayer"]="Dragon Slayer", ["Phoenix"]="Phoenix", ["Demon"]="Demon",
    ["Angel"]="Angel", ["Titan"]="Titan", ["Legend"]="Legend",
    ["Myth"]="Myth", ["Hero"]="Hero", ["Villain"]="Villain",
    ["Chosen One"]="Chosen One", ["Master"]="Master", ["Grandmaster"]="Grandmaster",
    ["Supreme"]="Supreme", ["Divine"]="Divine", ["Celestial"]="Celestial",
    ["Immortal"]="Immortal", ["Eternal"]="Eternal", ["Infinite"]="Infinite",
    ["Ultimate"]="Ultimate", ["Absolute"]="Absolute", ["Perfect"]="Perfect",
    ["Invincible"]="Invincible", ["Unstoppable"]="Unstoppable", ["Indomitable"]="Indomitable",
    ["Fearless"]="Fearless", ["Braveheart"]="Braveheart", ["Valiant"]="Valiant",
    ["Courageous"]="Courageous", ["Warrior"]="Warrior", ["Gladiator"]="Gladiator",
    ["Champion"]="Champion", ["Victor"]="Victor", ["Conqueror"]="Conqueror",
    ["Vanquisher"]="Vanquisher", ["Destroyer"]="Destroyer", ["Annihilator"]="Annihilator",
    ["Obliterator"]="Obliterator", ["Executioner"]="Executioner", ["Slayer"]="Slayer",
    ["Hunter"]="Hunter", ["Predator"]="Predator", ["Assassin"]="Assassin",
    ["Ninja"]="Ninja", ["Samurai"]="Samurai", ["Ronin"]="Ronin",
    ["Knight"]="Knight", ["Paladin"]="Paladin", ["Crusader"]="Crusader",
    ["Templar"]="Templar", ["Guardian"]="Guardian", ["Protector"]="Protector",
    ["Defender"]="Defender", ["Savior"]="Savior", ["Messiah"]="Messiah",
    ["Prophet"]="Prophet", ["Oracle"]="Oracle", ["Seer"]="Seer",
    ["Sage"]="Sage", ["Wise One"]="Wise One", ["Elder"]="Elder",
    ["Ancient"]="Ancient", ["Primordial"]="Primordial", ["Origin"]="Origin",
    ["Firstborn"]="Firstborn", ["Progenitor"]="Progenitor", ["Creator"]="Creator",
    ["Architect"]="Architect", ["Engineer"]="Engineer", ["Artisan"]="Artisan",
    ["Craftsman"]="Craftsman", ["Smith"]="Smith", ["Forgemaster"]="Forgemaster",
    ["Alchemist"]="Alchemist", ["Enchanter"]="Enchanter", ["Sorcerer"]="Sorcerer",
    ["Wizard"]="Wizard", ["Warlock"]="Warlock", ["Necromancer"]="Necromancer",
    ["Mage"]="Mage", ["Magician"]="Magician", ["Illusionist"]="Illusionist",
    ["Psychic"]="Psychic", ["Telepath"]="Telepath", ["Telekinetic"]="Telekinetic",
    ["Elementalist"]="Elementalist", ["Pyromancer"]="Pyromancer", ["Cryomancer"]="Cryomancer",
    ["Electromancer"]="Electromancer", ["Geomancer"]="Geomancer", ["Aeromancer"]="Aeromancer",
    ["Hydromancer"]="Hydromancer", ["Druid"]="Druid", ["Shaman"]="Shaman",
    ["Priest"]="Priest", ["Cleric"]="Cleric", ["Monk"]="Monk",
    ["Ascetic"]="Ascetic", ["Hermit"]="Hermit", ["Mystic"]="Mystic",
    ["Enlightened"]="Enlightened", ["Awakened"]="Awakened", ["Transcendent"]="Transcendent",
    ["Ascended"]="Ascended", ["Evolved"]="Evolved", ["Mutated"]="Mutated",
    ["Enhanced"]="Enhanced", ["Augmented"]="Augmented", ["Modified"]="Modified",
    ["Cybernetic"]="Cybernetic", ["Mechanical"]="Mechanical", ["Robotic"]="Robotic",
    ["Synthetic"]="Synthetic", ["Artificial"]="Artificial", ["Digital"]="Digital",
    ["Virtual"]="Virtual", ["Quantum"]="Quantum", ["Cosmic"]="Cosmic",
    ["Galactic"]="Galactic", ["Interstellar"]="Interstellar", ["Astral"]="Astral",
    ["Celestial"]="Celestial", ["Divine"]="Divine", ["Holy"]="Holy",
    ["Sacred"]="Sacred", ["Blessed"]="Blessed", ["Radiant"]="Radiant",
    ["Luminous"]="Luminous", ["Shining"]="Shining", ["Brilliant"]="Brilliant",
    ["Glorious"]="Glorious", ["Magnificent"]="Magnificent", ["Majestic"]="Majestic",
    ["Regal"]="Regal", ["Royal"]="Royal", ["Imperial"]="Imperial",
    ["Noble"]="Noble", ["Aristocrat"]="Aristocrat", ["Elite"]="Elite",
    ["Premium"]="Premium", ["Exclusive"]="Exclusive", ["Limited"]="Limited",
    ["Rare"]="Rare", ["Epic"]="Epic", ["Legendary"]="Legendary",
    ["Mythical"]="Mythical", ["Divine"]="Divine", ["Ultimate"]="Ultimate",
    ["Supreme"]="Supreme", ["Absolute"]="Absolute", ["Perfect"]="Perfect",
    ["Flawless"]="Flawless", ["Immaculate"]="Immaculate", ["Pristine"]="Pristine",
    ["Pure"]="Pure", ["Innocent"]="Innocent", ["Virtuous"]="Virtuous",
    ["Righteous"]="Righteous", ["Just"]="Just", ["Fair"]="Fair",
    ["Balanced"]="Balanced", ["Harmonious"]="Harmonious", ["Peaceful"]="Peaceful",
    ["Tranquil"]="Tranquil", ["Serene"]="Serene", ["Calm"]="Calm",
    ["Patient"]="Patient", ["Tolerant"]="Tolerant", ["Understanding"]="Understanding",
    ["Compassionate"]="Compassionate", ["Empathetic"]="Empathetic", ["Kind"]="Kind",
    ["Generous"]="Generous", ["Charitable"]="Charitable", ["Benevolent"]="Benevolent",
    ["Philanthropic"]="Philanthropic", ["Altruistic"]="Altruistic", ["Selfless"]="Selfless",
    ["Humble"]="Humble", ["Modest"]="Modest", ["Meek"]="Meek",
    ["Gentle"]="Gentle", ["Soft"]="Soft", ["Tender"]="Tender",
    ["Loving"]="Loving", ["Caring"]="Caring", ["Nurturing"]="Nurturing",
    ["Supportive"]="Supportive", ["Encouraging"]="Encouraging", ["Inspiring"]="Inspiring",
    ["Motivational"]="Motivational", ["Uplifting"]="Uplifting", ["Elevating"]="Elevating",
    ["Ennobling"]="Ennobling", ["Edifying"]="Edifying", ["Educational"]="Educational",
    ["Instructive"]="Instructive", ["Informative"]="Informative", ["Enlightening"]="Enlightening",
    ["Illuminating"]="Illuminating", ["Revealing"]="Revealing", ["Disclosing"]="Disclosing",
    ["Exposing"]="Exposing", ["Uncovering"]="Uncovering", ["Discovering"]="Discovering",
    ["Exploring"]="Exploring", ["Adventuring"]="Adventuring", ["Journeying"]="Journeying",
    ["Traveling"]="Traveling", ["Wandering"]="Wandering", ["Roaming"]="Roaming",
    ["Nomadic"]="Nomadic", ["Migratory"]="Migratory", ["Transient"]="Transient",
    ["Temporary"]="Temporary", ["Fleeting"]="Fleeting", ["Momentary"]="Momentary",
    ["Ephemeral"]="Ephemeral", ["Evanescent"]="Evanescent", ["Brief"]="Brief",
    ["Short"]="Short", ["Quick"]="Quick", ["Fast"]="Fast",
    ["Rapid"]="Rapid", ["Swift"]="Swift", ["Speedy"]="Speedy",
    ["Hasty"]="Hasty", ["Impatient"]="Impatient", ["Restless"]="Restless",
    ["Agitated"]="Agitated", ["Anxious"]="Anxious", ["Nervous"]="Nervous",
    ["Worried"]="Worried", ["Concerned"]="Concerned", ["Troubled"]="Troubled",
    ["Distressed"]="Distressed", ["Disturbed"]="Disturbed", ["Upset"]="Upset",
    ["His Majesty"]="His Majesty", ["Her Majesty"]="Her Majesty", ["His Highness"]="His Highness",
    ["Her Highness"]="Her Highness", ["Lord"]="Lord", ["Lady"]="Lady",
    ["Sir"]="Sir", ["Dame"]="Dame", ["Baron"]="Baron",
    ["Baroness"]="Baroness", ["Count"]="Count", ["Countess"]="Countess",
    ["Duke"]="Duke", ["Duchess"]="Duchess", ["Prince"]="Prince",
    ["Princess"]="Princess", ["King"]="King", ["Queen"]="Queen",
    ["Emperor"]="Emperor", ["Empress"]="Empress", ["Tsar"]="Tsar",
    ["Tsarina"]="Tsarina", ["Sultan"]="Sultan", ["Sultana"]="Sultana",
    ["Pharaoh"]="Pharaoh", ["Caesar"]="Caesar", ["Kaiser"]="Kaiser",
    ["Shogun"]="Shogun", ["Daimyo"]="Daimyo", ["Rajah"]="Rajah",
    ["Maharaja"]="Maharaja", ["Maharanee"]="Maharanee", ["Viceroy"]="Viceroy",
    ["Governor"]="Governor", ["President"]="President", ["Chancellor"]="Chancellor",
    ["Prime Minister"]="Prime Minister", ["Secretary"]="Secretary", ["Ambassador"]="Ambassador",
    ["Senator"]="Senator", ["Congressman"]="Congressman", ["Congresswoman"]="Congresswoman",
    ["Minister"]="Minister", ["Director"]="Director", ["Manager"]="Manager",
    ["Supervisor"]="Supervisor", ["Foreman"]="Foreman", ["Chief"]="Chief",
    ["Captain"]="Captain", ["Commander"]="Commander", ["Colonel"]="Colonel",
    ["Major"]="Major", ["General"]="General", ["Admiral"]="Admiral",
    ["Marshal"]="Marshal", ["Sheriff"]="Sheriff", ["Constable"]="Constable",
    ["Detective"]="Detective", ["Inspector"]="Inspector", ["Agent"]="Agent",
    ["Officer"]="Officer", ["Sergeant"]="Sergeant", ["Lieutenant"]="Lieutenant",
    ["Corporal"]="Corporal", ["Private"]="Private", ["Cadet"]="Cadet",
    ["Recruit"]="Recruit", ["Veteran"]="Veteran", ["Hero"]="Hero",
    ["Champion"]="Champion", ["Winner"]="Winner", ["Victor"]="Victor",
    ["Conqueror"]="Conqueror", ["Vanquisher"]="Vanquisher", ["Destroyer"]="Destroyer",
    ["Slayer"]="Slayer", ["Hunter"]="Hunter", ["Predator"]="Predator",
    ["Assassin"]="Assassin", ["Ninja"]="Ninja", ["Samurai"]="Samurai",
    ["Ronin"]="Ronin", ["Knight"]="Knight", ["Paladin"]="Paladin",
    ["Crusader"]="Crusader", ["Templar"]="Templar", ["Guardian"]="Guardian",
    ["Protector"]="Protector", ["Defender"]="Defender", ["Savior"]="Savior",
    ["Messiah"]="Messiah", ["Prophet"]="Prophet", ["Oracle"]="Oracle",
    ["Seer"]="Seer", ["Sage"]="Sage", ["Wise One"]="Wise One",
    ["Elder"]="Elder", ["Ancient"]="Ancient", ["Primordial"]="Primordial",
    ["Origin"]="Origin", ["Firstborn"]="Firstborn", ["Progenitor"]="Progenitor",
    ["Creator"]="Creator", ["Architect"]="Architect", ["Engineer"]="Engineer",
    ["Artisan"]="Artisan", ["Craftsman"]="Craftsman", ["Smith"]="Smith",
    ["Forgemaster"]="Forgemaster", ["Alchemist"]="Alchemist", ["Enchanter"]="Enchanter",
    ["Sorcerer"]="Sorcerer", ["Wizard"]="Wizard", ["Warlock"]="Warlock",
    ["Necromancer"]="Necromancer", ["Mage"]="Mage", ["Magician"]="Magician",
    ["Illusionist"]="Illusionist", ["Psychic"]="Psychic", ["Telepath"]="Telepath",
    ["Telekinetic"]="Telekinetic", ["Elementalist"]="Elementalist", ["Pyromancer"]="Pyromancer",
    ["Cryomancer"]="Cryomancer", ["Electromancer"]="Electromancer", ["Geomancer"]="Geomancer",
    ["Aeromancer"]="Aeromancer", ["Hydromancer"]="Hydromancer", ["Druid"]="Druid",
    ["Shaman"]="Shaman", ["Priest"]="Priest", ["Cleric"]="Cleric",
    ["Monk"]="Monk", ["Ascetic"]="Ascetic", ["Hermit"]="Hermit",
    ["Mystic"]="Mystic", ["Enlightened"]="Enlightened", ["Awakened"]="Awakened",
    ["Transcendent"]="Transcendent", ["Ascended"]="Ascended", ["Evolved"]="Evolved",
    ["Mutated"]="Mutated", ["Enhanced"]="Enhanced", ["Augmented"]="Augmented",
    ["Modified"]="Modified", ["Cybernetic"]="Cybernetic", ["Mechanical"]="Mechanical",
    ["Robotic"]="Robotic", ["Synthetic"]="Synthetic", ["Artificial"]="Artificial",
    ["Digital"]="Digital", ["Virtual"]="Virtual", ["Quantum"]="Quantum",
    ["Cosmic"]="Cosmic", ["Galactic"]="Galactic", ["Interstellar"]="Interstellar",
    ["Astral"]="Astral", ["Celestial"]="Celestial", ["Divine"]="Divine",
    ["Holy"]="Holy", ["Sacred"]="Sacred", ["Blessed"]="Blessed",
    ["Radiant"]="Radiant", ["Luminous"]="Luminous", ["Shining"]="Shining",
    ["Brilliant"]="Brilliant", ["Glorious"]="Glorious", ["Magnificent"]="Magnificent",
    ["Majestic"]="Majestic", ["Regal"]="Regal", ["Royal"]="Royal",
    ["Imperial"]="Imperial", ["Noble"]="Noble", ["Aristocrat"]="Aristocrat",
    ["Elite"]="Elite", ["Premium"]="Premium", ["Exclusive"]="Exclusive",
    ["Limited"]="Limited", ["Rare"]="Rare", ["Epic"]="Epic",
    ["Legendary"]="Legendary", ["Mythical"]="Mythical", ["Ultimate"]="Ultimate",
    ["Supreme"]="Supreme", ["Absolute"]="Absolute", ["Perfect"]="Perfect",
    ["Flawless"]="Flawless", ["Immaculate"]="Immaculate", ["Pristine"]="Pristine",
    ["Pure"]="Pure", ["Innocent"]="Innocent", ["Virtuous"]="Virtuous",
    ["Righteous"]="Righteous", ["Just"]="Just", ["Fair"]="Fair",
    ["Balanced"]="Balanced", ["Harmonious"]="Harmonious", ["Peaceful"]="Peaceful",
    ["Tranquil"]="Tranquil", ["Serene"]="Serene", ["Calm"]="Calm",
    ["Patient"]="Patient", ["Tolerant"]="Tolerant", ["Understanding"]="Understanding",
    ["Compassionate"]="Compassionate", ["Empathetic"]="Empathetic", ["Kind"]="Kind",
    ["Generous"]="Generous", ["Charitable"]="Charitable", ["Benevolent"]="Benevolent",
    ["Philanthropic"]="Philanthropic", ["Altruistic"]="Altruistic", ["Selfless"]="Selfless",
    ["Humble"]="Humble", ["Modest"]="Modest", ["Meek"]="Meek",
    ["Gentle"]="Gentle", ["Soft"]="Soft", ["Tender"]="Tender",
    ["Loving"]="Loving", ["Caring"]="Caring", ["Nurturing"]="Nurturing",
    ["Supportive"]="Supportive", ["Encouraging"]="Encouraging", ["Inspiring"]="Inspiring",
    ["Motivational"]="Motivational", ["Uplifting"]="Uplifting", ["Elevating"]="Elevating",
    ["Ennobling"]="Ennobling", ["Edifying"]="Edifying", ["Educational"]="Educational",
    ["Instructive"]="Instructive", ["Informative"]="Informative", ["Enlightening"]="Enlightening",
    ["Illuminating"]="Illuminating", ["Revealing"]="Revealing", ["Disclosing"]="Disclosing",
    ["Exposing"]="Exposing", ["Uncovering"]="Uncovering", ["Discovering"]="Discovering",
    ["Exploring"]="Exploring", ["Adventuring"]="Adventuring", ["Journeying"]="Journeying",
    ["Traveling"]="Traveling", ["Wandering"]="Wandering", ["Roaming"]="Roaming",
    ["Nomadic"]="Nomadic", ["Migratory"]="Migratory", ["Transient"]="Transient",
    ["Temporary"]="Temporary", ["Fleeting"]="Fleeting", ["Momentary"]="Momentary",
    ["Ephemeral"]="Ephemeral", ["Evanescent"]="Evanescent", ["Brief"]="Brief",
    ["Short"]="Short", ["Quick"]="Quick", ["Fast"]="Fast",
    ["Rapid"]="Rapid", ["Swift"]="Swift", ["Speedy"]="Speedy",
    ["Hasty"]="Hasty", ["Impatient"]="Impatient", ["Restless"]="Restless",
    ["Agitated"]="Agitated", ["Anxious"]="Anxious", ["Nervous"]="Nervous",
    ["Worried"]="Worried", ["Concerned"]="Concerned", ["Troubled"]="Troubled",
    ["Distressed"]="Distressed", ["Disturbed"]="Disturbed", ["Upset"]="Upset"
}

-- Travel Commands
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

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
    local titleValue, exactName = findExactMatch(Titles, name)
    if titleValue then
        local success, result = pcall(function()
            return CommF_:InvokeServer("activateTitle", titleValue)
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
-- Command Table
-- ================================
local Commands = {
    ["/g"] = getWeapon,
    ["/f"] = getFightingStyle,
    ["/e"] = equipFruit,
    ["/tt"] = equipTitle,
    ["/pirate"] = function() setTeam("Pirates") end,
    ["/marine"] = function() setTeam("Marines") end,
    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
    ["/help"] = function()
        notify("Help","Commands:\n/g <weapon>\n/f <style>\n/sea1-3\n/e <fruit>\n/tt <title>\n/pirate\n/marine",10)
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

notify("✅ Commands Loaded","Type /help for commands",5)
