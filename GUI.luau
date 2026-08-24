-- ================================
-- COMBINED SCRIPT: CMD + GUI
-- ================================

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
-- Notification (shared)
-- ================================
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 5 })
    end)
end
_G.Notify = notify

-- ================================
-- Data tables
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
-- Standard Aimbot
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
-- OpFun (Aimbot + Attributes + Target storage)
-- ================================
local opAimbotEnabled, opAimbotTarget, opAimbotConnection, opAimbotSearchString = false, nil, nil, nil
_G.OpFunTarget = nil

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
    _G.OpFunTarget = opAimbotTarget
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

-- Attribute loop
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
    local myChar = LocalPlayer.Character
    if not myChar or not myChar.PrimaryPart then notify("Combo", "❌ No character", 5) return end
    local targetPos = target.Character.HumanoidRootPart.Position
    pcall(function()
        myChar:SetPrimaryPartCFrame(CFrame.new(targetPos + Vector3.new(0, 3, 0)))
    end)
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
-- Individual command functions for GUI
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
-- Chat Listener (still active)
-- ================================
PlayerChatted:Connect(function(msg)
    local split = msg:split(" ")
    local cmd = split[1]:lower()
    local arg = table.concat(split, " ", 2)
    if cmd == "/i" then _G.LoadItem(arg)
    elseif cmd == "/tt" then _G.ActivateTitle(arg)
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

-- ================================
-- ================================
-- GUI CREATION (draggable, mobile-friendly)
-- ================================
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 500)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Shadow
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 4, 0, 4)
shadow.Position = mainFrame.Position + UDim2.new(0, -2, 0, -2)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.4
shadow.BorderSizePixel = 0
shadow.Parent = ScreenGui
shadow.ZIndex = 0
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadow
shadow:GetPropertyChangedSignal("Size"):Connect(function()
    shadow.Size = mainFrame.Size + UDim2.new(0, 4, 0, 4)
end)
mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = mainFrame.Position + UDim2.new(0, -2, 0, -2)
end)

-- Title Bar (draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Admin Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag logic
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

-- Tabs
local tabs = {"Items", "Travel", "Aimbot", "OpFun", "Utility"}
local tabButtons = {}
local currentTab = nil
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
    btn.BackgroundTransparency = 0.8
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    btn.Name = name
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        if currentTab then
            tabButtons[currentTab].BackgroundTransparency = 0.8
            tabButtons[currentTab].TextColor3 = Color3.fromRGB(200,200,200)
        end
        currentTab = name
        btn.BackgroundTransparency = 0.4
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        for _, child in ipairs(contentFrame:GetChildren()) do child:Destroy() end
        BuildTab(name)
    end)
end
tabButtons["Items"].BackgroundTransparency = 0.4
tabButtons["Items"].TextColor3 = Color3.fromRGB(255,255,255)
currentTab = "Items"
BuildTab("Items")

-- Build functions
function BuildTab(tabName)
    if tabName == "Items" then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.BackgroundTransparency = 1
        label.Text = "Enter weapon or fruit:"
        label.TextColor3 = Color3.fromRGB(220,220,220)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame

        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, -130, 0, 35)
        input.Position = UDim2.new(0, 10, 0, 40)
        input.BackgroundColor3 = Color3.fromRGB(60,60,80)
        input.BorderSizePixel = 0
        input.TextColor3 = Color3.fromRGB(255,255,255)
        input.TextSize = 14
        input.Font = Enum.Font.Gotham
        input.PlaceholderText = "e.g., Dark Blade, Buddha"
        input.ClearTextOnFocus = false
        input.Parent = contentFrame
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = input

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 80, 0, 35)
        loadBtn.Position = UDim2.new(1, -90, 0, 40)
        loadBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        loadBtn.Text = "Load"
        loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
        loadBtn.TextSize = 14
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.BorderSizePixel = 0
        loadBtn.Parent = contentFrame
        local loadCorner = Instance.new("UICorner")
        loadCorner.CornerRadius = UDim.new(0, 6)
        loadCorner.Parent = loadBtn
        loadBtn.MouseButton1Click:Connect(function()
            _G.LoadItem(input.Text)
        end)

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 25)
        titleLabel.Position = UDim2.new(0, 10, 0, 90)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "Enter title:"
        titleLabel.TextColor3 = Color3.fromRGB(220,220,220)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.Gotham
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = contentFrame

        local titleInput = Instance.new("TextBox")
        titleInput.Size = UDim2.new(1, -130, 0, 35)
        titleInput.Position = UDim2.new(0, 10, 0, 120)
        titleInput.BackgroundColor3 = Color3.fromRGB(60,60,80)
        titleInput.BorderSizePixel = 0
        titleInput.TextColor3 = Color3.fromRGB(255,255,255)
        titleInput.TextSize = 14
        titleInput.Font = Enum.Font.Gotham
        titleInput.PlaceholderText = "e.g., Sea Monster"
        titleInput.ClearTextOnFocus = false
        titleInput.Parent = contentFrame
        local titleCorner2 = Instance.new("UICorner")
        titleCorner2.CornerRadius = UDim.new(0, 6)
        titleCorner2.Parent = titleInput

        local titleBtn = Instance.new("TextButton")
        titleBtn.Size = UDim2.new(0, 80, 0, 35)
        titleBtn.Position = UDim2.new(1, -90, 0, 120)
        titleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        titleBtn.Text = "Activate"
        titleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        titleBtn.TextSize = 14
        titleBtn.Font = Enum.Font.GothamBold
        titleBtn.BorderSizePixel = 0
        titleBtn.Parent = contentFrame
        local titleCorner3 = Instance.new("UICorner")
        titleCorner3.CornerRadius = UDim.new(0, 6)
        titleCorner3.Parent = titleBtn
        titleBtn.MouseButton1Click:Connect(function()
            _G.ActivateTitle(titleInput.Text)
        end)

    elseif tabName == "Travel" then
        local y = 20
        local seas = {{"Sea 1",1},{"Sea 2",2},{"Sea 3",3}}
        for _, data in ipairs(seas) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.8, 0, 0, 45)
            btn.Position = UDim2.new(0.1, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
            btn.Text = data[1]
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextSize = 16
            btn.Font = Enum.Font.GothamBold
            btn.BorderSizePixel = 0
            btn.Parent = contentFrame
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                _G.TravelSea(data[2])
            end)
            y = y + 55
        end
        local teamY = y + 10
        local pirateBtn = Instance.new("TextButton")
        pirateBtn.Size = UDim2.new(0.35, 0, 0, 45)
        pirateBtn.Position = UDim2.new(0.1, 0, 0, teamY)
        pirateBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        pirateBtn.Text = "Pirate"
        pirateBtn.TextColor3 = Color3.fromRGB(255,255,255)
        pirateBtn.TextSize = 16
        pirateBtn.Font = Enum.Font.GothamBold
        pirateBtn.BorderSizePixel = 0
        pirateBtn.Parent = contentFrame
        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(0, 8)
        pCorner.Parent = pirateBtn
        pirateBtn.MouseButton1Click:Connect(function() _G.SetTeam("Pirates") end)

        local marineBtn = Instance.new("TextButton")
        marineBtn.Size = UDim2.new(0.35, 0, 0, 45)
        marineBtn.Position = UDim2.new(0.55, 0, 0, teamY)
        marineBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
        marineBtn.Text = "Marine"
        marineBtn.TextColor3 = Color3.fromRGB(255,255,255)
        marineBtn.TextSize = 16
        marineBtn.Font = Enum.Font.GothamBold
        marineBtn.BorderSizePixel = 0
        marineBtn.Parent = contentFrame
        local mCorner = Instance.new("UICorner")
        mCorner.CornerRadius = UDim.new(0, 8)
        mCorner.Parent = marineBtn
        marineBtn.MouseButton1Click:Connect(function() _G.SetTeam("Marines") end)

    elseif tabName == "Aimbot" then
        local y = 20
        local aimOn = Instance.new("TextButton")
        aimOn.Size = UDim2.new(0.8, 0, 0, 45)
        aimOn.Position = UDim2.new(0.1, 0, 0, y)
        aimOn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
        aimOn.Text = "Enable Aimbot (300 studs)"
        aimOn.TextColor3 = Color3.fromRGB(255,255,255)
        aimOn.TextSize = 16
        aimOn.Font = Enum.Font.GothamBold
        aimOn.BorderSizePixel = 0
        aimOn.Parent = contentFrame
        local onCorner = Instance.new("UICorner")
        onCorner.CornerRadius = UDim.new(0, 8)
        onCorner.Parent = aimOn
        aimOn.MouseButton1Click:Connect(function() _G.StartAimbot(300) end)

        y = y + 60
        local aimOff = Instance.new("TextButton")
        aimOff.Size = UDim2.new(0.8, 0, 0, 45)
        aimOff.Position = UDim2.new(0.1, 0, 0, y)
        aimOff.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        aimOff.Text = "Disable Aimbot"
        aimOff.TextColor3 = Color3.fromRGB(255,255,255)
        aimOff.TextSize = 16
        aimOff.Font = Enum.Font.GothamBold
        aimOff.BorderSizePixel = 0
        aimOff.Parent = contentFrame
        local offCorner = Instance.new("UICorner")
        offCorner.CornerRadius = UDim.new(0, 8)
        offCorner.Parent = aimOff
        aimOff.MouseButton1Click:Connect(function() _G.StopAimbot() end)

    elseif tabName == "OpFun" then
        local y = 20
        local targetLabel = Instance.new("TextLabel")
        targetLabel.Size = UDim2.new(1, -20, 0, 25)
        targetLabel.Position = UDim2.new(0, 10, 0, y)
        targetLabel.BackgroundTransparency = 1
        targetLabel.Text = "Target (optional):"
        targetLabel.TextColor3 = Color3.fromRGB(220,220,220)
        targetLabel.TextSize = 14
        targetLabel.Font = Enum.Font.Gotham
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.Parent = contentFrame
        y = y + 30

        local targetInput = Instance.new("TextBox")
        targetInput.Size = UDim2.new(1, -130, 0, 35)
        targetInput.Position = UDim2.new(0, 10, 0, y)
        targetInput.BackgroundColor3 = Color3.fromRGB(60,60,80)
        targetInput.BorderSizePixel = 0
        targetInput.TextColor3 = Color3.fromRGB(255,255,255)
        targetInput.TextSize = 14
        targetInput.Font = Enum.Font.Gotham
        targetInput.PlaceholderText = "Leave empty for closest"
        targetInput.ClearTextOnFocus = false
        targetInput.Parent = contentFrame
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = targetInput
        y = y + 45

        local opOn = Instance.new("TextButton")
        opOn.Size = UDim2.new(0.8, 0, 0, 45)
        opOn.Position = UDim2.new(0.1, 0, 0, y)
        opOn.BackgroundColor3 = Color3.fromRGB(180, 130, 30)
        opOn.Text = "Enable OpFun"
        opOn.TextColor3 = Color3.fromRGB(255,255,255)
        opOn.TextSize = 16
        opOn.Font = Enum.Font.GothamBold
        opOn.BorderSizePixel = 0
        opOn.Parent = contentFrame
        local onCorner = Instance.new("UICorner")
        onCorner.CornerRadius = UDim.new(0, 8)
        onCorner.Parent = opOn
        opOn.MouseButton1Click:Connect(function()
            _G.StartOpFun(targetInput.Text)
        end)
        y = y + 55

        local opOff = Instance.new("TextButton")
        opOff.Size = UDim2.new(0.8, 0, 0, 45)
        opOff.Position = UDim2.new(0.1, 0, 0, y)
        opOff.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        opOff.Text = "Disable OpFun"
        opOff.TextColor3 = Color3.fromRGB(255,255,255)
        opOff.TextSize = 16
        opOff.Font = Enum.Font.GothamBold
        opOff.BorderSizePixel = 0
        opOff.Parent = contentFrame
        local offCorner = Instance.new("UICorner")
        offCorner.CornerRadius = UDim.new(0, 8)
        offCorner.Parent = opOff
        opOff.MouseButton1Click:Connect(function() _G.StopOpFun() end)

        y = y + 60
        local comboBtn = Instance.new("TextButton")
        comboBtn.Size = UDim2.new(0.8, 0, 0, 50)
        comboBtn.Position = UDim2.new(0.1, 0, 0, y)
        comboBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 200)
        comboBtn.Text = "⚡ Teleport & Ice Combo"
        comboBtn.TextColor3 = Color3.fromRGB(255,255,255)
        comboBtn.TextSize = 16
        comboBtn.Font = Enum.Font.GothamBold
        comboBtn.BorderSizePixel = 0
        comboBtn.Parent = contentFrame
        local comboCorner = Instance.new("UICorner")
        comboCorner.CornerRadius = UDim.new(0, 8)
        comboCorner.Parent = comboBtn
        comboBtn.MouseButton1Click:Connect(function()
            _G.TeleportAndIceCombo()
        end)

    elseif tabName == "Utility" then
        local y = 20
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 50)
        label.Position = UDim2.new(0, 10, 0, y)
        label.BackgroundTransparency = 1
        label.Text = "Extra utilities can be added here."
        label.TextColor3 = Color3.fromRGB(200,200,200)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextWrapped = true
        label.Parent = contentFrame
    end
end

notify("Admin Panel", "✅ GUI loaded – drag the title bar to move", 5)
