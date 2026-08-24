-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local LocalPlayer = Players.LocalPlayer
local PlayerChatted = LocalPlayer.Chatted
local Camera = workspace.CurrentCamera

-- ================================
-- Notification
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
    ["Control"]="Control-Control", ["Gas"]="Gas-Gas", ["Spirit"]="Spirit-Spirit", ["Tiger"]="Tiger-Tiger", 
    ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune", ["Dragon"]="Dragon-Dragon", ["Buddha"]="Buddha-Buddha"
}

-- ================================
-- Shortcuts for /i
-- Add any alias here : "shortcut" = "actual_name"
-- ================================
local Shortcuts = {
    ["leo"] = "Tiger",
    ["cdk"] = "Cursed Dual Katana",
    ["kab"] = "Kabucha",
    ["sc"] = "Soul Cane",
    ["soul"] = "Soul Cane",
    ["sg"] = "Skull Guitar",
    -- Add more as needed
}

-- ================================
-- Travel
-- ================================
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Aimbot (standard screen-based)
-- ================================
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotConnection = nil
local aimbotRadius = 300

local function findClosestPlayerScreen()
    local closest = nil
    local shortestDist = math.huge
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local screenDist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                local worldDist = (hrp.Position - Camera.CFrame.Position).Magnitude
                if screenDist < shortestDist and worldDist <= aimbotRadius then
                    shortestDist = screenDist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function startAimbot(radius)
    if radius then aimbotRadius = radius end
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end

    aimbotEnabled = true
    aimbotTarget = findClosestPlayerScreen()

    if not aimbotTarget then
        notify("Aimbot", "❌ No target found within " .. aimbotRadius .. " studs", 5)
        aimbotEnabled = false
        return
    end

    notify("Aimbot", "✅ Locked onto " .. aimbotTarget.Name .. " (radius: " .. aimbotRadius .. ")", 5)

    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        if not aimbotTarget or not aimbotTarget.Character or not aimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            aimbotTarget = findClosestPlayerScreen()
            if not aimbotTarget then
                notify("Aimbot", "❌ Lost target", 5)
                aimbotEnabled = false
                return
            end
            notify("Aimbot", "✅ New target: " .. aimbotTarget.Name, 5)
        end
        local hrp = aimbotTarget.Character.HumanoidRootPart
        if hrp then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
        end
    end)
end

local function stopAimbot()
    aimbotEnabled = false
    aimbotTarget = nil
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

-- ================================
-- Aimbot (distance-based for /opfun)
-- ================================
local opAimbotEnabled = false
local opAimbotTarget = nil
local opAimbotConnection = nil

local function findClosestPlayerDistance()
    local closest = nil
    local shortestDist = math.huge
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local dist = (hrp.Position - myPos.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closest = player
            end
        end
    end
    return closest
end

local function startOpAimbot()
    if opAimbotConnection then opAimbotConnection:Disconnect(); opAimbotConnection = nil end
    opAimbotEnabled = true
    opAimbotTarget = findClosestPlayerDistance()
    if not opAimbotTarget then
        notify("OpFun", "❌ No players nearby", 5)
        opAimbotEnabled = false
        return
    end
    notify("OpFun", "✅ Locked onto " .. opAimbotTarget.Name, 5)

    opAimbotConnection = RunService.RenderStepped:Connect(function()
        if not opAimbotEnabled then return end
        if not opAimbotTarget or not opAimbotTarget.Character or not opAimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            opAimbotTarget = findClosestPlayerDistance()
            if not opAimbotTarget then
                notify("OpFun", "❌ Lost target", 5)
                opAimbotEnabled = false
                return
            end
            notify("OpFun", "✅ New target: " .. opAimbotTarget.Name, 5)
        end
        local hrp = opAimbotTarget.Character.HumanoidRootPart
        if hrp then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
        end
    end)
end

local function stopOpAimbot()
    opAimbotEnabled = false
    opAimbotTarget = nil
    if opAimbotConnection then
        opAimbotConnection:Disconnect()
        opAimbotConnection = nil
    end
end

-- ================================
-- OpFun Attribute Loop
-- ================================
local opFunLoopConnection = nil
local opFunActive = false

local function applyOpFunAttributes()
    local char = LocalPlayer.Character
    if not char then return end

    -- Set specific attributes
    local specificAttrs = {
        DashLength = 250,
        DodgeBoost = 1000,
        ObservationRange = 10000,
        SpeedMultiplier = 10,
        SkyJumpCost = 0,
        SkyJumpBoost = 6,
    }
    for name, value in pairs(specificAttrs) do
        char:SetAttribute(name, value)
    end

    -- Set all attributes containing "Cooldown" to 0 (case-insensitive)
    local allAttrs = char:GetAttributes()
    for name, _ in pairs(allAttrs) do
        if string.lower(name):find("cooldown") then
            char:SetAttribute(name, 0)
        end
    end
end

local function startOpFunLoop()
    if opFunLoopConnection then
        opFunLoopConnection:Disconnect()
        opFunLoopConnection = nil
    end
    opFunActive = true
    applyOpFunAttributes() -- apply immediately
    opFunLoopConnection = RunService.Heartbeat:Connect(function()
        if not opFunActive then return end
        applyOpFunAttributes()
    end)
    notify("OpFun", "✅ Attribute loop started", 5)
end

local function stopOpFunLoop()
    opFunActive = false
    if opFunLoopConnection then
        opFunLoopConnection:Disconnect()
        opFunLoopConnection = nil
    end
    notify("OpFun", "✅ Attribute loop stopped", 5)
end

-- Respawn handler to reapply attributes on new character
LocalPlayer.CharacterAdded:Connect(function()
    if opFunActive then
        task.wait(0.5) -- wait for humanoid
        applyOpFunAttributes()
    end
end)

-- ================================
-- Commands
-- ================================

local function handleItem(itemName)
    if not itemName or itemName == "" then
        notify("Item", "❌ Please specify a weapon or fruit name", 5)
        return
    end
    local shortcutName = Shortcuts[itemName:lower()]
    if shortcutName then itemName = shortcutName end

    for name, remoteName in pairs(FruitMapping) do
        if name:lower() == itemName:lower() then
            local success, result = pcall(function()
                return CommF_:InvokeServer("SwitchFruit", remoteName)
            end)
            notify("Fruit", success and "✅ Equipped " .. name or "❌ " .. tostring(result), 5)
            return
        end
    end

    local success, result = pcall(function()
        return CommF_:InvokeServer("LoadItem", itemName, nil)
    end)
    notify("Weapon", success and "✅ Loaded " .. itemName or "❌ " .. tostring(result), 5)
end

local function equipTitle(titleName)
    if not titleName or titleName == "" then
        notify("Title", "❌ Please specify a title name", 5)
        return
    end
    local success, result = pcall(function()
        return CommF_:InvokeServer("activateTitle", titleName)
    end)
    notify("Title", success and "✅ Activated " .. titleName or "❌ " .. tostring(result), 5)
end

local function travelToSea(seaNumber)
    local command = TravelCommands[seaNumber]
    if command then
        local success, result = pcall(function()
            return CommF_:InvokeServer(command)
        end)
        notify("Travel", success and "✅ Travel to Sea "..seaNumber or "❌ "..tostring(result),5)
    else
        notify("Travel","❌ Use /sea1, /sea2, /sea3",5)
    end
end

local function setTeam(teamName)
    local team = teamName:lower():find("pirate") and "Pirates" or "Marines"
    local success, result = pcall(function()
        return CommF_:InvokeServer("SetTeam", team)
    end)
    notify("Team", success and "✅ Joined "..team or "❌ "..tostring(result),5)
end

local function handleAimbot(arg)
    if arg and arg ~= "" then
        local radius = tonumber(arg)
        if radius and radius > 0 then
            startAimbot(radius)
        else
            notify("Aimbot", "❌ Invalid radius. Using default: " .. aimbotRadius, 5)
            startAimbot(aimbotRadius)
        end
    else
        startAimbot(aimbotRadius)
    end
end

local function handleOpFun()
    -- Stop any existing aimbot (standard)
    stopAimbot()
    -- Start distance-based aimbot
    startOpAimbot()
    -- Start attribute loop
    startOpFunLoop()
    notify("OpFun", "✅ OpFun mode activated (aimbot + attribute loop)", 5)
end

local function handleUnOpFun()
    stopOpAimbot()
    stopOpFunLoop()
    notify("OpFun", "✅ OpFun mode deactivated", 5)
end

-- ================================
-- Command Table
-- ================================
local Commands = {
    ["/i"] = handleItem,
    ["/tt"] = equipTitle,
    ["/sea1"] = function() travelToSea("1") end,
    ["/sea2"] = function() travelToSea("2") end,
    ["/sea3"] = function() travelToSea("3") end,
    ["/pirate"] = function() setTeam("Pirates") end,
    ["/marine"] = function() setTeam("Marines") end,
    ["/aimbot"] = handleAimbot,
    ["/unaimbot"] = function() stopAimbot(); notify("Aimbot", "✅ Aimbot disabled", 5) end,
    ["/opfun"] = handleOpFun,
    ["/unopfun"] = handleUnOpFun,
}

PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if Commands[cmd] then
        Commands[cmd](arg)
    end
end)

notify("✅ Loaded", "Commands: /i, /tt, /aimbot, /unaimbot, /opfun, /unopfun, /sea1-3, /pirate, /marine", 5)
