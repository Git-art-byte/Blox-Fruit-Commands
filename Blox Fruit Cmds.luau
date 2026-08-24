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
    ["sg"] = "Skull Guitar",
    ["db"] = "Dark Blade",
    -- Add more as needed
}

-- ================================
-- Travel
-- ================================
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Aimbot / Camlock
-- ================================
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotConnection = nil
local aimbotRadius = 700 -- default radius

local function findClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                -- Check distance from player to center of screen
                local screenDist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                -- Check actual world distance
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
    if radius then
        aimbotRadius = radius
    end

    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end

    aimbotEnabled = true
    aimbotTarget = findClosestPlayer()

    if not aimbotTarget then
        notify("Aimbot", "❌ No target found within " .. aimbotRadius .. " studs", 5)
        aimbotEnabled = false
        return
    end

    notify("Aimbot", "✅ Locked onto " .. aimbotTarget.Name .. " (radius: " .. aimbotRadius .. ")", 5)

    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end

        -- Refresh target if current one is dead or gone
        if not aimbotTarget or not aimbotTarget.Character or not aimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            aimbotTarget = findClosestPlayer()
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
    notify("Aimbot", "✅ Aimbot disabled", 5)
end

-- ================================
-- Commands
-- ================================

local function handleItem(itemName)
    if not itemName or itemName == "" then
        notify("Item", "❌ Please specify a weapon or fruit name", 5)
        return
    end

    -- Check shortcuts first
    local shortcutName = Shortcuts[itemName:lower()]
    if shortcutName then
        itemName = shortcutName
    end

    -- Check if it's a fruit
    for name, remoteName in pairs(FruitMapping) do
        if name:lower() == itemName:lower() then
            local success, result = pcall(function()
                return CommF_:InvokeServer("SwitchFruit", remoteName)
            end)
            notify("Fruit", success and "✅ Equipped " .. name or "❌ " .. tostring(result), 5)
            return
        end
    end

    -- If not a fruit, treat as weapon (LoadItem)
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
    ["/unaimbot"] = stopAimbot,
}

PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if Commands[cmd] then
        Commands[cmd](arg)
    end
end)
