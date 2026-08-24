-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

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
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Tiger" or "Leo"]="Tiger-Tiger", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon", ["Buddha"]="Buddha-Buddha"
}

-- ================================
-- Travel commands
-- ================================
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Speed Loop (RELIABLE)
-- ================================
local speedLoopActive = false
local speedLoopThread = nil
local targetSpeed = nil

local function stopSpeedLoop()
    speedLoopActive = false
    if speedLoopThread then
        task.cancel(speedLoopThread)
        speedLoopThread = nil
    end
end

local function startSpeedLoop(speed)
    stopSpeedLoop() -- kill old loop
    targetSpeed = speed
    speedLoopActive = true
    
    -- Spawn a persistent loop
    speedLoopThread = task.spawn(function()
        while speedLoopActive do
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = targetSpeed
                end
            end
            task.wait(0.1) -- adjust if needed
        end
    end)
end

-- Also re-apply speed when character respawns
LocalPlayer.CharacterAdded:Connect(function(char)
    if speedLoopActive and targetSpeed ~= nil then
        task.wait(0.5) -- wait for humanoid to load
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = targetSpeed
        end
    end
end)

-- ================================
-- Command Functions
-- ================================

-- /i : weapon OR fruit
local function handleItem(itemName)
    if not itemName or itemName == "" then
        notify("Item", "❌ Please specify a weapon or fruit name", 5)
        return
    end

    local fruitKey = itemName:lower()
    for name, remoteName in pairs(FruitMapping) do
        if name:lower() == fruitKey then
            local success, result = pcall(function()
                return CommF_:InvokeServer("SwitchFruit", remoteName)
            end)
            if success then
                notify("Fruit", "✅ Equipped " .. name, 5)
            else
                notify("Fruit", "❌ " .. tostring(result), 5)
            end
            return
        end
    end

    -- Weapon fallback
    local success, result = pcall(function()
        return CommF_:InvokeServer("LoadItem", itemName, nil)
    end)
    if success then
        notify("Weapon", "✅ Loaded " .. itemName, 5)
    else
        notify("Weapon", "❌ " .. tostring(result), 5)
    end
end

-- /tt : title
local function equipTitle(titleName)
    if not titleName or titleName == "" then
        notify("Title", "❌ Please specify a title name", 5)
        return
    end
    local success, result = pcall(function()
        return CommF_:InvokeServer("activateTitle", titleName)
    end)
    if success then
        notify("Title", "✅ Activated " .. titleName, 5)
    else
        notify("Title", "❌ " .. tostring(result), 5)
    end
end

-- Travel
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

-- Team
local function setTeam(teamName)
    local team = teamName:lower():find("pirate") and "Pirates" or "Marines"
    local success, result = pcall(function()
        return CommF_:InvokeServer("SetTeam", team)
    end)
    notify("Team", success and "✅ Joined "..team or "❌ "..tostring(result),5)
end

-- /speed : start the loop
local function setSpeedLoop(arg)
    if not arg or arg == "" then
        notify("Speed", "❌ Please specify a number", 5)
        return
    end
    local speed = tonumber(arg)
    if not speed then
        notify("Speed", "❌ Invalid number: " .. arg, 5)
        return
    end

    startSpeedLoop(speed)
    notify("Speed", "✅ Speed loop started at " .. speed .. " (runs forever)", 5)
end

-- ================================
-- Command Table
-- ================================
local Commands = {
    ["/i"] = handleItem,
    ["/tt"] = equipTitle,
    ["/speed"] = setSpeedLoop,
    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
    ["/pirate"] = function() setTeam("Pirates") end,
    ["/marine"] = function() setTeam("Marines") end,
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
