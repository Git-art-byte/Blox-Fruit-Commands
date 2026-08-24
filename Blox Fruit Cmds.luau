-- CMD.luau
-- Core command logic, shared functions, and variable storage

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
-- Notification (for GUI feedback)
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

-- Expose notification to GUI
_G.Notify = notify

-- ================================
-- Fruit Mapping, Shortcuts, Travel
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
local Shortcuts = {
    ["leo"] = "Tiger", ["cdk"] = "Cursed Dual Katana", ["kab"] = "Kabucha",
    ["sc"] = "Soul Cane", ["soul"] = "Soul Cane", ["sg"] = "Skull Guitar",
}
local TravelCommands = {["1"]="TravelMain",["2"]="TravelDressrosa",["3"]="TravelZou"}

-- ================================
-- Aimbot (standard)
-- ================================
local aimbotEnabled, aimbotTarget, aimbotConnection, aimbotRadius = false, nil, nil, 300
local function findClosestPlayerScreen()
    local closest, shortestDist = nil, math.huge
    local viewportSize, center = Camera.ViewportSize, Camera.ViewportSize / 2
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local screenDist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                local worldDist = (hrp.Position - Camera.CFrame.Position).Magnitude
                if screenDist < shortestDist and worldDist <= aimbotRadius then
                    shortestDist, closest = screenDist, plr
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
    if not aimbotTarget then notify("Aimbot", "❌ No target", 5) aimbotEnabled = false return end
    notify("Aimbot", "✅ Locked " .. aimbotTarget.Name, 5)
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        if not aimbotTarget or not aimbotTarget.Character or not aimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            aimbotTarget = findClosestPlayerScreen()
            if not aimbotTarget then notify("Aimbot", "❌ Lost target", 5) aimbotEnabled = false return end
            notify("Aimbot", "✅ New target " .. aimbotTarget.Name, 5)
        end
        local hrp = aimbotTarget.Character.HumanoidRootPart
        if hrp then Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position) end
    end)
end
local function stopAimbot()
    aimbotEnabled = false; aimbotTarget = nil
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
end
_G.StartAimbot = startAimbot
_G.StopAimbot = stopAimbot

-- ================================
-- OpFun Aimbot + Attributes + Target storage
-- ================================
local opAimbotEnabled, opAimbotTarget, opAimbotConnection, opAimbotSearchString = false, nil, nil, nil
_G.OpFunTarget = nil  -- store the current opfun target player

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
    local closest, shortestDist = nil, math.huge
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local dist = (hrp.Position - myPos.Position).Magnitude
            if dist < shortestDist then shortestDist, closest = dist, plr end
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
    opAimbotSearchString = searchString or nil
    opAimbotTarget = getOpTarget()
    if not opAimbotTarget then
        notify("OpFun", opAimbotSearchString and "❌ No player '"..opAimbotSearchString.."'" or "❌ No players nearby", 5)
        opAimbotEnabled = false
        return
    end
    _G.OpFunTarget = opAimbotTarget  -- store globally
    notify("OpFun", "✅ Locked " .. opAimbotTarget.Name, 5)
    opAimbotConnection = RunService.RenderStepped:Connect(function()
        if not opAimbotEnabled then return end
        if not opAimbotTarget or not opAimbotTarget.Character or not opAimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
            opAimbotTarget = getOpTarget()
            if not opAimbotTarget then
                if not opAimbotSearchString then notify("OpFun", "❌ Lost target", 5) opAimbotEnabled = false return end
                return
            end
            _G.OpFunTarget = opAimbotTarget
            notify("OpFun", "✅ Re-acquired " .. opAimbotTarget.Name, 5)
        end
        local hrp = opAimbotTarget.Character.HumanoidRootPart
        if hrp then Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position) end
    end)
end
local function stopOpAimbot()
    opAimbotEnabled = false; opAimbotTarget = nil; _G.OpFunTarget = nil
    if opAimbotConnection then opAimbotConnection:Disconnect(); opAimbotConnection = nil end
    opAimbotSearchString = nil
end

-- OpFun Attribute loop
local opFunLoopConnection, opFunActive, opFunOriginalAttrs = nil, false, {}
local function storeOriginalAttributes()
    local char = LocalPlayer.Character
    if not char then return end
    opFunOriginalAttrs = {}
    for name, value in pairs(char:GetAttributes()) do
        if string.lower(name):find("cooldown") or name == "DashLength" or name == "DodgeBoost" or 
           name == "ObservationRange" or name == "SpeedMultiplier" or name == "SkyJumpCost" or name == "SkyJumpBoost" then
            opFunOriginalAttrs[name] = value
        end
    end
end
local function applyOpFunAttributes()
    local char = LocalPlayer.Character
    if not char then return end
    if next(opFunOriginalAttrs) == nil then storeOriginalAttributes() end
    local specific = {DashLength=250, DodgeBoost=1000, ObservationRange=10000, SpeedMultiplier=10, SkyJumpCost=0, SkyJumpBoost=6}
    for name, val in pairs(specific) do char:SetAttribute(name, val) end
    for name, _ in pairs(char:GetAttributes()) do
        if string.lower(name):find("cooldown") then char:SetAttribute(name, 0) end
    end
end
local function restoreOriginalAttributes()
    local char = LocalPlayer.Character
    if not char then return end
    for name, val in pairs(opFunOriginalAttrs) do char:SetAttribute(name, val) end
    opFunOriginalAttrs = {}
end
local function startOpFunLoop()
    if opFunLoopConnection then opFunLoopConnection:Disconnect(); opFunLoopConnection = nil end
    opFunActive = true; opFunOriginalAttrs = {}; applyOpFunAttributes()
    opFunLoopConnection = RunService.Heartbeat:Connect(function()
        if not opFunActive then return end; applyOpFunAttributes()
    end)
    notify("OpFun", "✅ Attribute loop started", 5)
end
local function stopOpFunLoopAndRestore()
    opFunActive = false; if opFunLoopConnection then opFunLoopConnection:Disconnect(); opFunLoopConnection = nil end
    restoreOriginalAttributes()
    notify("OpFun", "✅ Attributes restored", 5)
end
_G.StartOpFun = function(search)
    stopAimbot()
    if opFunActive then stopOpFunLoopAndRestore(); stopOpAimbot() end
    startOpAimbot(search)
    if opAimbotEnabled then startOpFunLoop() end
end
_G.StopOpFun = function()
    stopOpAimbot(); stopOpFunLoopAndRestore()
end

-- ================================
-- Teleport + Ice Combo
-- ================================
_G.TeleportAndIceCombo = function()
    local target = _G.OpFunTarget
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        notify("Combo", "❌ No valid OpFun target", 5)
        return
    end
    -- Teleport to target
    local myChar = LocalPlayer.Character
    if not myChar or not myChar.PrimaryPart then notify("Combo", "❌ No character", 5) return end
    local targetPos = target.Character.HumanoidRootPart.Position
    pcall(function()
        myChar:SetPrimaryPartCFrame(CFrame.new(targetPos + Vector3.new(0, 3, 0)))
    end)
    -- Execute Ice V, C, Z in sequence
    local function castIce(move)
        local args = {[1] = move, n = 1}
        pcall(function()
            workspace.Characters[LocalPlayer.Name].Humanoid:FindFirstChild(""):InvokeServer(unpack(args, 1, args.n or #args))
        end)
    end
    castIce("V")
    task.wait(0.3)
    castIce("C")
    task.wait(0.3)
    castIce("Z")
    notify("Combo", "✅ Teleported & Ice combo executed", 5)
end

-- ================================
-- Individual Commands (for GUI buttons)
-- ================================
_G.LoadItem = function(name)
    if not name or name == "" then notify("Item", "❌ Specify name", 5) return end
    local shortcut = Shortcuts[name:lower()]
    if shortcut then name = shortcut end
    for fruit, remote in pairs(FruitMapping) do
        if fruit:lower() == name:lower() then
            local s, r = pcall(function() return CommF_:InvokeServer("SwitchFruit", remote) end)
            notify("Fruit", s and "✅ "..fruit or "❌ "..tostring(r), 5)
            return
        end
    end
    local s, r = pcall(function() return CommF_:InvokeServer("LoadItem", name, nil) end)
    notify("Weapon", s and "✅ "..name or "❌ "..tostring(r), 5)
end
_G.ActivateTitle = function(name)
    if not name or name == "" then notify("Title", "❌ Specify title", 5) return end
    local s, r = pcall(function() return CommF_:InvokeServer("activateTitle", name) end)
    notify("Title", s and "✅ "..name or "❌ "..tostring(r), 5)
end
_G.TravelSea = function(sea)
    local cmd = TravelCommands[tostring(sea)]
    if not cmd then notify("Travel", "❌ Use 1,2,3", 5) return end
    local s, r = pcall(function() return CommF_:InvokeServer(cmd) end)
    notify("Travel", s and "✅ Sea "..sea or "❌ "..tostring(r), 5)
end
_G.SetTeam = function(team)
    local t = team:lower():find("pirate") and "Pirates" or "Marines"
    local s, r = pcall(function() return CommF_:InvokeServer("SetTeam", t) end)
    notify("Team", s and "✅ "..t or "❌ "..tostring(r), 5)
end

-- ================================
-- Chat Listener (still works)
-- ================================
PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if cmd == "/i" then _G.LoadItem(arg)
    elseif cmd == "/t" then _G.ActivateTitle(arg)
    elseif cmd == "/sea1" then _G.TravelSea(1)
    elseif cmd == "/sea2" then _G.TravelSea(2)
    elseif cmd == "/sea3" then _G.TravelSea(3)
    elseif cmd == "/pirate" then _G.SetTeam("Pirates")
    elseif cmd == "/marine" then _G.SetTeam("Marines")
    elseif cmd == "/aimbot" then _G.StartAimbot(tonumber(arg) or 300)
    elseif cmd == "/unaimbot" then _G.StopAimbot()
    elseif cmd == "/opfun" then _G.StartOpFun(arg)
    elseif cmd == "/unopfun" then _G.StopOpFun()
    end
end)
