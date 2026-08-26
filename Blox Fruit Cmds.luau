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
-- ================================
local Shortcuts = {
    ["leo"] = "Tiger",
    ["cdk"] = "Cursed Dual Katana",
    ["kab"] = "Kabucha",
    ["sc"] = "Soul Cane",
    ["soul"] = "Soul Cane",
    ["sg"] = "Skull Guitar",
}

-- ================================
-- Travel
-- ================================
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Aimbot (standard screen-based with optional specific target)
-- ================================
local aimbotEnabled = false
local aimbotConnection = nil
local aimbotRadius = 300
local aimbotTargetRef = nil
local aimbotTargetIdentifier = nil

local function findDummy(identifier)
    identifier = identifier:lower()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, model in ipairs(enemies:GetChildren()) do
        if model:IsA("Model") and model.Name:lower():find(identifier) then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hrp then return hrp end
        end
    end
    return nil
end

local function findPlayer(identifier)
    identifier = identifier:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():find(identifier, 1, true) or plr.DisplayName:lower():find(identifier, 1, true) then
                return plr
            end
        end
    end
    return nil
end

local function resolveTarget(identifier)
    if not identifier or identifier == "" then return nil end
    local lower = identifier:lower()
    if lower:find("dummy") then
        local hrp = findDummy(lower)
        if hrp then return { type = "dummy", object = hrp } end
    end
    local plr = findPlayer(identifier)
    if plr then return { type = "player", object = plr } end
    return nil
end

local function getTargetPosition()
    if not aimbotTargetRef then return nil end
    if aimbotTargetRef.type == "player" then
        local plr = aimbotTargetRef.object
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            return plr.Character.HumanoidRootPart
        end
    elseif aimbotTargetRef.type == "dummy" then
        local part = aimbotTargetRef.object
        if part and part.Parent then
            return part
        end
    end
    return nil
end

local function refreshTarget()
    if not aimbotTargetIdentifier then return nil end
    local resolved = resolveTarget(aimbotTargetIdentifier)
    if resolved then
        aimbotTargetRef = resolved
        return true
    end
    return false
end

local function startAimbot(param)
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end

    local isNumber = tonumber(param)
    if isNumber then
        aimbotRadius = math.max(isNumber, 1)
        aimbotTargetIdentifier = nil
        aimbotTargetRef = nil
        aimbotEnabled = true
        notify("Aimbot", "✅ Radius set to " .. aimbotRadius, 5)
    else
        local resolved = resolveTarget(param)
        if not resolved then
            notify("Aimbot", "❌ No target found for '" .. param .. "'", 5)
            return
        end
        aimbotTargetIdentifier = param
        aimbotTargetRef = resolved
        aimbotRadius = 999999
        aimbotEnabled = true
        notify("Aimbot", "✅ Locked onto " .. (resolved.type == "player" and resolved.object.Name or "Dummy"), 5)
    end

    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end

        local targetPart = nil
        if aimbotTargetRef then
            targetPart = getTargetPosition()
            if not targetPart then
                if refreshTarget() then
                    targetPart = getTargetPosition()
                end
                if not targetPart then
                    if aimbotTargetRef and aimbotTargetRef.type == "dummy" then
                        notify("Aimbot", "❌ Dummy lost", 5)
                        stopAimbot()
                        return
                    end
                    return
                end
            end
        else
            local closest = findClosestPlayerScreen()
            if closest then
                targetPart = closest.Character and closest.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end)
end

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

local function stopAimbot()
    aimbotEnabled = false
    aimbotTargetRef = nil
    aimbotTargetIdentifier = nil
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
local opAimbotSearchString = nil

local function findPlayerByString(search)
    if not search or search == "" then return nil end
    local lower = search:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():find(lower, 1, true) or plr.DisplayName:lower():find(lower, 1, true) then
                return plr
            end
        end
    end
    return nil
end

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

local function getOpTarget()
    if opAimbotSearchString and opAimbotSearchString ~= "" then
        return findPlayerByString(opAimbotSearchString)
    else
        return findClosestPlayerDistance()
    end
end

local function startOpAimbot(searchString)
    if opAimbotConnection then opAimbotConnection:Disconnect(); opAimbotConnection = nil end
    opAimbotEnabled = true
    opAimbotSearchString = searchString and searchString ~= "" and searchString or nil
    opAimbotTarget = getOpTarget()

    if not opAimbotTarget then
        if opAimbotSearchString then
            notify("OpFun", "❌ No player found matching '" .. opAimbotSearchString .. "'", 5)
        else
            notify("OpFun", "❌ No players nearby", 5)
        end
        opAimbotEnabled = false
        return
    end

    notify("OpFun", "✅ Locked onto " .. opAimbotTarget.Name, 5)

    opAimbotConnection = RunService.RenderStepped:Connect(function()
        if not opAimbotEnabled then return end
        if not opAimbotTarget or not opAimbotTarget.Character or not opAimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            opAimbotTarget = getOpTarget()
            if not opAimbotTarget then
                if opAimbotSearchString then
                    return
                else
                    notify("OpFun", "❌ Lost target", 5)
                    opAimbotEnabled = false
                    return
                end
            else
                notify("OpFun", "✅ Re-acquired " .. opAimbotTarget.Name, 5)
            end
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
    opAimbotSearchString = nil
end

-- ================================
-- OpFun Attribute Loop + Restoration (FIXED)
-- ================================
local opFunLoopConnection = nil
local opFunActive = false
local opFunOriginalAttrs = {}
local opFunCurrentChar = nil

local function storeOriginalAttributes()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Store which character we're saving attributes from
    opFunCurrentChar = char
    
    opFunOriginalAttrs = {}
    local allAttrs = char:GetAttributes()
    for name, value in pairs(allAttrs) do
        if string.lower(name):find("cooldown") or 
           name == "DashLength" or name == "DodgeBoost" or 
           name == "ObservationRange" or name == "SpeedMultiplier" or 
           name == "SkyJumpCost" or name == "SkyJumpBoost" then
            opFunOriginalAttrs[name] = value
        end
    end
    -- Also store cooldowns that might not exist yet but will be created
    -- Just to be safe
end

local function applyOpFunAttributes()
    local char = LocalPlayer.Character
    if not char then return end

    -- If we don't have stored attributes or character changed, store fresh
    if next(opFunOriginalAttrs) == nil or opFunCurrentChar ~= char then
        storeOriginalAttributes()
    end

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

    local allAttrs = char:GetAttributes()
    for name, _ in pairs(allAttrs) do
        if string.lower(name):find("cooldown") then
            char:SetAttribute(name, 0)
        end
    end
end

local function restoreOriginalAttributes()
    local char = LocalPlayer.Character
    if not char then 
        -- If no character, clear stored attrs so we'll re-store next time
        opFunOriginalAttrs = {}
        return 
    end
    
    -- If we have stored attributes, restore them
    if next(opFunOriginalAttrs) ~= nil then
        for name, value in pairs(opFunOriginalAttrs) do
            pcall(function()
                char:SetAttribute(name, value)
            end)
        end
    else
        -- If no stored attributes, try to reset to defaults
        notify("OpFun", "⚠️ No stored attributes to restore, resetting to defaults", 5)
        -- Reset cooldowns to 0 and specific attrs to defaults
        local specificAttrs = {
            DashLength = 16,
            DodgeBoost = 0,
            ObservationRange = 300,
            SpeedMultiplier = 1,
            SkyJumpCost = 500,
            SkyJumpBoost = 3,
        }
        for name, value in pairs(specificAttrs) do
            pcall(function()
                char:SetAttribute(name, value)
            end)
        end
        -- Reset all cooldowns to 0
        local allAttrs = char:GetAttributes()
        for name, _ in pairs(allAttrs) do
            if string.lower(name):find("cooldown") then
                pcall(function()
                    char:SetAttribute(name, 0)
                end)
            end
        end
    end
    
    opFunOriginalAttrs = {}
    opFunCurrentChar = nil
end

local function startOpFunLoop()
    if opFunLoopConnection then
        opFunLoopConnection:Disconnect()
        opFunLoopConnection = nil
    end
    opFunActive = true
    opFunOriginalAttrs = {}
    opFunCurrentChar = nil
    applyOpFunAttributes()
    opFunLoopConnection = RunService.Heartbeat:Connect(function()
        if not opFunActive then return end
        applyOpFunAttributes()
    end)
    notify("OpFun", "✅ Attribute loop started", 5)
end

local function stopOpFunLoopAndRestore()
    opFunActive = false
    if opFunLoopConnection then
        opFunLoopConnection:Disconnect()
        opFunLoopConnection = nil
    end
    
    -- Restore with a small delay to ensure character is loaded
    task.wait(0.1)
    restoreOriginalAttributes()
    
    -- Double-check restore after another short delay
    task.wait(0.2)
    if next(opFunOriginalAttrs) ~= nil then
        -- If attributes are still stored, they weren't restored properly
        restoreOriginalAttributes()
    end
    
    notify("OpFun", "✅ Attributes restored to original values", 5)
end

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    if opFunActive then
        task.wait(0.5) -- wait for humanoid to load
        -- Store fresh attributes from the new character
        opFunOriginalAttrs = {}
        opFunCurrentChar = nil
        applyOpFunAttributes()
    else
        -- If opfun is not active but we have stored attributes, clear them
        opFunOriginalAttrs = {}
        opFunCurrentChar = nil
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
            startAimbot(arg)
        end
    else
        startAimbot(aimbotRadius)
    end
end

local function handleOpFun(arg)
    -- Stop any existing aimbots
    stopAimbot()
    if opFunActive then
        stopOpFunLoopAndRestore()
        stopOpAimbot()
    end

    local searchString = arg and arg ~= "" and arg or nil
    startOpAimbot(searchString)
    if opAimbotEnabled then
        startOpFunLoop()
        if searchString then
            notify("OpFun", "✅ OpFun mode activated (target: " .. searchString .. ")", 5)
        else
            notify("OpFun", "✅ OpFun mode activated (closest player)", 5)
        end
    end
end

local function handleUnOpFun()
    stopOpAimbot()
    stopOpFunLoopAndRestore()
    notify("OpFun", "✅ OpFun mode deactivated – attributes restored", 5)
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

notify("✅ Loaded", "Commands: /i, /tt, /aimbot [radius|target], /unaimbot, /opfun [target], /unopfun, /sea1-3, /pirate, /marine", 5)
