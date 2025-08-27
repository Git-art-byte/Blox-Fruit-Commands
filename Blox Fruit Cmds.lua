local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage.Remotes.CommF_

local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted

-- Weapon items for /g command
local WeaponItems = {
    -- Swords
    ["dark blade"] = {"Swords"},
    ["saber"] = {"Swords"},
    ["shisui"] = {"Swords"},
    ["saddi"] = {"Swords"},
    ["wando"] = {"Swords"},
    ["yama"] = {"Swords"},
    ["buddy sword"] = {"Swords"},
    ["canvander"] = {"Swords"},
    ["spikey trident"] = {"Swords"},
    ["hallow scythe"] = {"Swords"},
    ["dragon trident"] = {"Swords"},
    ["pipe"] = {"Swords"},
    ["dual headed blade"] = {"Swords"},
    ["triple katana"] = {"Swords"},
    ["soul cane"] = {"Swords"},
    ["koko"] = {"Swords"},
    ["jitte"] = {"Swords"},
    ["dual heated blade"] = {"Swords"},
    ["gravity cane"] = {"Swords"},
    ["cursed dual katana"] = {"Swords"},
    ["cdk"] = {"Swords"},
    ["true triple katana"] = {"Swords"},
    ["ttk"] = {"Swords"},
    ["tushita"] = {"Swords"},
    ["yoru"] = {"Swords"},
    ["midnight blade"] = {"Swords"},
    ["rengoku"] = {"Swords"},
    
    -- Guns
    ["kabucha"] = {"Guns"},
    ["skull guitar"] = {"Guns"},
    ["acidum rifle"] = {"Guns"},
    ["bizarre rifle"] = {"Guns"},
    ["slingshot"] = {"Guns"},
    ["musket"] = {"Guns"},
    ["flintlock"] = {"Guns"},
    ["refined flintlock"] = {"Guns"},
    ["cannon"] = {"Guns"},
    ["refined slingshot"] = {"Guns"},
    ["bazooka"] = {"Guns"},
    ["serpent bow"] = {"Guns"},
}

-- Fighting styles for /f command
local FightingStyles = {
    ["electro"] = "BuyElectro",
    ["electric"] = "BuyElectro",
    ["dragon breath"] = "BuyDragonBreath",
    ["dragonbreath"] = "BuyDragonBreath",
    ["dark step"] = "BuyBlackLeg",
    ["black leg"] = "BuyBlackLeg",
    ["water kung fu"] = "BuyWaterKungfu",
    ["waterkungfu"] = "BuyWaterKungfu",
    ["superhuman"] = "BuySuperhuman",
    ["death step"] = "BuyDeathStep",
    ["deathstep"] = "BuyDeathStep",
    ["sharkman karate"] = "BuySharkmanKarate",
    ["sharkmankarate"] = "BuySharkmanKarate",
    ["electric claw"] = "BuyElectricClaw",
    ["electricclaw"] = "BuyElectricClaw",
    ["dragon talon"] = "BuyDragonTalon",
    ["dragontalon"] = "BuyDragonTalon",
    ["godhuman"] = "BuyGodhuman",
    ["sanguine art"] = "BuySanguineArt",
    ["sanguineart"] = "BuySanguineArt",
    ["blood style"] = "BuySanguineArt",
    ["bloodstyle"] = "BuySanguineArt",
    ["combat"] = "BuyCombat",
    ["fishman karate"] = "BuyFishmanKarate",
    ["fishmankarate"] = "BuyFishmanKarate",
    ["martial arts"] = "BuyMartialArts",
    ["martialarts"] = "BuyMartialArts"
}

-- Permanent fruits for /e command
local PermanentFruits = {
    ["leopard"] = "Leopard-Leopard",
    ["leo"] = "Leopard-Leopard",
    ["dragon"] = "Dragon-Dragon",
    ["dough"] = "Dough-Dough",
    ["dark"] = "Dark-Dark",
    ["light"] = "Light-Light",
    ["quake"] = "Quake-Quake",
    ["rumble"] = "Rumble-Rumble",
    ["buddha"] = "Buddha-Buddha",
    ["shadow"] = "Shadow-Shadow",
    ["blizzard"] = "Blizzard-Blizzard",
    ["control"] = "Control-Control",
    ["gravity"] = "Gravity-Gravity",
    ["venom"] = "Venom-Venom",
    ["spider"] = "Spider-Spider",
    ["phoenix"] = "Phoenix-Phoenix",
    ["ice"] = "Ice-Ice",
    ["sand"] = "Sand-Sand",
    ["flame"] = "Flame-Flame",
    ["falcon"] = "Falcon-Falcon",
    ["rubber"] = "Rubber-Rubber",
    ["barrier"] = "Barrier-Barrier",
    ["smoke"] = "Smoke-Smoke",
    ["spin"] = "Spin-Spin",
    ["chop"] = "Chop-Chop",
    ["spring"] = "Spring-Spring",
    ["bomb"] = "Bomb-Bomb",
    ["kilogram"] = "Kilogram-Kilogram",
    ["revive"] = "Revive-Revive",
    ["diamond"] = "Diamond-Diamond",
    ["love"] = "Love-Love",
    ["magnet"] = "Magnet-Magnet",
    ["door"] = "Door-Door",
    ["human"] = "Human-Human",
    ["ghost"] = "Ghost-Ghost",
    ["bird: falcon"] = "Bird: Falcon-Bird: Falcon"
}

-- Function for weapons (/g command)
local function getWeapon(itemName)
    local itemKey = itemName:lower()
    
    if WeaponItems[itemKey] then
        local category = WeaponItems[itemKey][1]
        print("Loading weapon: " .. itemName .. " (" .. category .. ")")
        
        local success, result = pcall(function()
            return CommF_:InvokeServer("LoadItem", itemName, {category})
        end)

        if success then
            print("✅ Weapon loaded! Return: " .. tostring(result))
        else
            print("❌ Error: " .. tostring(result))
        end
    else
        print("❌ Weapon not found: " .. itemName)
    end
end

-- Function for fighting styles (/f command)
local function getFightingStyle(styleName)
    local styleKey = styleName:lower()
    
    if FightingStyles[styleKey] then
        local remoteCommand = FightingStyles[styleKey]
        print("Getting fighting style: " .. styleName .. " -> " .. remoteCommand)
        
        local success, result = pcall(function()
            return CommF_:InvokeServer(remoteCommand)
        end)

        if success then
            print("✅ Style acquired! Return: " .. tostring(result))
        else
            print("❌ Error: " .. tostring(result))
        end
    else
        print("❌ Fighting style not found: " .. styleName)
    end
end

-- Function for permanent fruits (/e command)
local function getPermanentFruit(fruitName)
    local fruitKey = fruitName:lower()
    
    if PermanentFruits[fruitKey] then
        local fruitCode = PermanentFruits[fruitKey]
        print("Switching to permanent fruit: " .. fruitName .. " -> " .. fruitCode)
        
        local success, result = pcall(function()
            return CommF_:InvokeServer("SwitchFruit", fruitCode)
        end)

        if success then
            print("✅ Fruit switched! Return: " .. tostring(result))
        else
            print("❌ Error: " .. tostring(result))
        end
    else
        print("❌ Permanent fruit not found: " .. fruitName)
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
        
    elseif command:sub(1, 3) == "/e " then
        local fruitName = message:sub(4)
        getPermanentFruit(fruitName)
    end
end)

print("Chat commands loaded!")
print("WEAPONS: /g <weaponname>")
print("FIGHTING STYLES: /f <stylename>")
print("PERMANENT FRUITS: /e <fruitname>")
print("Examples:")
print("/g cdk")
print("/g soul guitar")
print("/f electric claw")
print("/f superhuman")
print("/e leopard")
print("/e dough")
print("/e dragon")
