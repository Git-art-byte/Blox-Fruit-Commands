-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local CommF_ = ReplicatedStorage.Remotes.CommF_
local CommE_ = ReplicatedStorage.Remotes.CommE
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
-- Fighting Styles
-- ================================
local FightingStyles = {
    ["Godhuman"] = "BuyGodhuman",
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
-- OpFun Attribute Loop + Restoration
-- ================================
local opFunLoopConnection = nil
local opFunActive = false
local opFunOriginalAttrs = {}

local function storeOriginalAttributes()
    local char = LocalPlayer.Character
    if not char then return end
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
end

local function applyOpFunAttributes()
    local char = LocalPlayer.Character
    if not char then return end
    if next(opFunOriginalAttrs) == nil then
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
    if not char then return end
    for name, value in pairs(opFunOriginalAttrs) do
        char:SetAttribute(name, value)
    end
    opFunOriginalAttrs = {}
end

local function startOpFunLoop()
    if opFunLoopConnection then
        opFunLoopConnection:Disconnect()
        opFunLoopConnection = nil
    end
    opFunActive = true
    opFunOriginalAttrs = {}
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
    restoreOriginalAttributes()
    notify("OpFun", "✅ Attributes restored to original values", 5)
end

LocalPlayer.CharacterAdded:Connect(function()
    if opFunActive then
        task.wait(0.5)
        opFunOriginalAttrs = {}
        applyOpFunAttributes()
    elseif next(opFunOriginalAttrs) ~= nil then
        restoreOriginalAttributes()
    end
end)

-- ================================
-- ACB (Auto Combo Buster) - Fixed
-- ================================
local acbRunning = false
local acbLoopThread = nil
local acbTarget = nil

-- Helper: equip fruit using the correct method
local function equipFruit(name)
    for fruit, remote in pairs(FruitMapping) do
        if fruit:lower() == name:lower() then
            pcall(function()
                CommF_:InvokeServer("SwitchFruit", remote)
            end)
            return true
        end
    end
    return false
end

-- Helper: equip fighting style
local function equipFightingStyle(name)
    local remote = FightingStyles[name]
    if remote then
        pcall(function()
            CommF_:InvokeServer(remote)
        end)
        return true
    end
    return false
end

-- Helper: use a move (using the method from your original code)
local function useMove(moveName)
    local args = { [1] = moveName, n = 1 }
    pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Find the first tool in Humanoid that has InvokeServer capability
            for _, child in ipairs(humanoid:GetChildren()) do
                if child:IsA("Tool") and child:FindFirstChild("RemoteEvent") then
                    child:FindFirstChild("RemoteEvent"):FireServer(moveName)
                    return
                end
            end
        end
        -- Fallback: use the method from your original code
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local children = humanoid:GetChildren()
                if children[11] then
                    children[11]:InvokeServer(unpack(args, 1, args.n or #args))
                end
            end
        end
    end)
end

-- Helper: activate ability
local function activateAbility()
    pcall(function()
        local args = { [1] = "ActivateAbility", n = 1 }
        CommE_:FireServer(unpack(args, 1, args.n or #args))
    end)
end

-- Helper: teleport to target
local function teleportToTarget()
    if not acbTarget or not acbTarget.Character then return end
    local hrp = acbTarget.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myChar = LocalPlayer.Character
    if not myChar or not myChar.PrimaryPart then return end
    pcall(function()
        myChar:SetPrimaryPartCFrame(CFrame.new(hrp.Position + Vector3.new(0, 3, 0)))
    end)
end

-- Helper: check if target is alive
local function isTargetAlive()
    if not acbTarget or not acbTarget.Character then return false end
    local humanoid = acbTarget.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    return true
end

-- Main ACB function
local function startACB(targetIdentifier)
    if acbRunning then
        notify("ACB", "❌ Already running! Use /unacb to stop.", 5)
        return
    end

    -- Resolve target
    local resolved = resolveTarget(targetIdentifier)
    if not resolved or resolved.type == "dummy" then
        notify("ACB", "❌ Invalid target (player only)", 5)
        return
    end
    acbTarget = resolved.object
    
    if not isTargetAlive() then
        notify("ACB", "❌ Target not found or dead", 5)
        return
    end

    -- Enable aimbot on that target
    startAimbot(targetIdentifier)
    if not aimbotEnabled then
        notify("ACB", "❌ Failed to lock aimbot", 5)
        return
    end

    acbRunning = true
    notify("ACB", "✅ Combo started on " .. acbTarget.Name, 5)

    acbLoopThread = task.spawn(function()
        while acbRunning do
            -- Check if target is alive
            if not isTargetAlive() then
                notify("ACB", "✅ Target dead – stopping combo", 5)
                stopACB()
                break
            end

            -- Teleport to target
            teleportToTarget()

            -- Ensure Ice is equipped
            local hasIce = LocalPlayer.Backpack:FindFirstChild("Ice-Ice") or LocalPlayer.Character:FindFirstChild("Ice-Ice")
            if not hasIce then
                equipFruit("Ice")
                task.wait(0.5)
            end

            -- Spam Ice V (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("V")
                task.wait(0.2)
            end

            -- Spam Ice C (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("C")
                task.wait(0.2)
            end

            -- Spam Ice Z (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("Z")
                task.wait(0.2)
            end

            -- Activate ability
            activateAbility()
            task.wait(0.3)

            -- Equip Godhuman
            local hasGodhuman = LocalPlayer.Backpack:FindFirstChild("Godhuman") or LocalPlayer.Character:FindFirstChild("Godhuman")
            if not hasGodhuman then
                equipFightingStyle("Godhuman")
                task.wait(0.5)
            end

            -- Spam Godhuman X (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("X")
                task.wait(0.2)
            end

            -- Spam Godhuman C (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("C")
                task.wait(0.2)
            end

            -- Spam Godhuman Z (3 times)
            for i = 1, 3 do
                if not acbRunning then break end
                useMove("Z")
                task.wait(0.2)
            end

            -- Small delay before repeating
            task.wait(0.3)
        end
    end)
end

local function stopACB()
    acbRunning = false
    if acbLoopThread then
        task.cancel(acbLoopThread)
        acbLoopThread = nil
    end
    acbTarget = nil
    stopAimbot()
    notify("ACB", "✅ Combo stopped", 5)
end

================================
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

local function handleACB(arg)
    if not arg or arg == "" then
        notify("ACB", "❌ Please specify a target", 5)
        return
    end
    startACB(arg)
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
    ["/acb"] = handleACB,
    ["/unacb"] = function() stopACB(); notify("ACB", "✅ ACB stopped", 5) end,
}

PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if Commands[cmd] then
        Commands[cmd](arg)
    end
end)

notify("✅ Loaded", "Commands: /i, /tt, /aimbot [radius|target], /unaimbot, /opfun [target], /unopfun, /acb <target>, /unacb, /sea1-3, /pirate, /marine", 5)
