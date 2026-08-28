-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================
-- ESP (smaller, cleaner)
-- ================================
local espEnabled = true
local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 160, 0, 44) -- smaller size
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.Parent = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.4
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    frame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = frame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = ""
    infoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.Parent = frame

    espObjects[player] = {
        Billboard = billboard,
        Frame = frame,
        NameLabel = nameLabel,
        InfoLabel = infoLabel,
    }
end

local function updateESP()
    for player, data in pairs(espObjects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if data.Billboard then data.Billboard:Destroy() end
            espObjects[player] = nil
        else
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            data.Billboard.Adornee = hrp

            local health = humanoid and math.floor(humanoid.Health) or 0
            local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
            local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0

            data.InfoLabel.Text = "❤️ " .. health .. "/" .. maxHealth .. "  |  " .. dist .. "s"
        end
    end
end

local function refreshESP()
    for player in pairs(espObjects) do
        if espObjects[player] and espObjects[player].Billboard then
            espObjects[player].Billboard:Destroy()
        end
    end
    espObjects = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if player ~= LocalPlayer then
            refreshESP()
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        if espObjects[player].Billboard then
            espObjects[player].Billboard:Destroy()
        end
        espObjects[player] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    refreshESP()
end)

-- ================================
-- Aimbot
-- ================================
local aimbotEnabled = false
local aimbotConnection = nil
local selectedTarget = nil  -- Player object or nil for closest

local function findClosestPlayer()
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

local function getTarget()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        return selectedTarget
    end
    return findClosestPlayer()
end

local function startAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end

    aimbotEnabled = true
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
        end
    end)
end

local function stopAimbot()
    aimbotEnabled = false
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

-- ================================
-- Stylish Draggable GUI
-- ================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 170)
mainFrame.Position = UDim2.new(0.5, -100, 0.8, -85)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Outer glow
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 6, 1, 6)
glow.Position = UDim2.new(-0.03, 0, -0.03, 0)
glow.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
glow.BackgroundTransparency = 0.6
glow.BorderSizePixel = 0
glow.Parent = mainFrame
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 14)
glowCorner.Parent = glow

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title bar with gradient
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ AIMBOT"
titleLabel.TextColor3 = Color3.new(0.8, 0.9, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Toggle button with neon style
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 80, 0, 32)
toggleBtn.Position = UDim2.new(0.5, -40, 0, 40)
toggleBtn.BackgroundColor3 = Color3.new(0.15, 0.4, 0.15)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Dropdown toggle (open/close)
local dropdownToggle = Instance.new("TextButton")
dropdownToggle.Size = UDim2.new(0, 80, 0, 32)
dropdownToggle.Position = UDim2.new(0.5, -40, 0, 82)
dropdownToggle.BackgroundColor3 = Color3.new(0.15, 0.2, 0.3)
dropdownToggle.Text = "▼ Select"
dropdownToggle.TextColor3 = Color3.new(1, 1, 1)
dropdownToggle.TextScaled = true
dropdownToggle.Font = Enum.Font.SourceSansBold
dropdownToggle.Parent = mainFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 8)
dropdownCorner.Parent = dropdownToggle

-- Dropdown list
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -10, 0, 0)
dropdownFrame.Position = UDim2.new(0, 5, 0, 124)
dropdownFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
dropdownFrame.BackgroundTransparency = 0.15
dropdownFrame.Visible = false
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = mainFrame

local dropdownCorner2 = Instance.new("UICorner")
dropdownCorner2.CornerRadius = UDim.new(0, 8)
dropdownCorner2.Parent = dropdownFrame

local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(1, 0, 1, 0)
dropdownList.BackgroundTransparency = 1
dropdownList.ScrollBarThickness = 4
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
dropdownList.Parent = dropdownFrame

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
dropdownLayout.Padding = UDim.new(0, 2)
dropdownLayout.Parent = dropdownList

-- Dropdown state
local dropdownOpen = false

-- Update dropdown list
local function updateDropdown()
    -- Clear old buttons
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- "None" option (deselect)
    local noneBtn = Instance.new("TextButton")
    noneBtn.Size = UDim2.new(1, 0, 0, 28)
    noneBtn.BackgroundColor3 = (selectedTarget == nil) and Color3.new(0.25, 0.35, 0.45) or Color3.new(0.15, 0.15, 0.2)
    noneBtn.Text = "None (closest)"
    noneBtn.TextColor3 = Color3.new(1, 1, 1)
    noneBtn.TextScaled = true
    noneBtn.Font = Enum.Font.SourceSans
    noneBtn.Parent = dropdownList

    local noneCorner = Instance.new("UICorner")
    noneCorner.CornerRadius = UDim.new(0, 5)
    noneCorner.Parent = noneBtn

    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        if aimbotEnabled then
            stopAimbot()
            startAimbot()
        end
        updateDropdown()
        dropdownToggle.Text = "▼ Select"
        dropdownOpen = false
        dropdownFrame.Visible = false
        dropdownToggle.Text = "▼ Select"
    end)

    -- Player buttons
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.BackgroundColor3 = (selectedTarget == player) and Color3.new(0.2, 0.5, 0.3) or Color3.new(0.15, 0.15, 0.2)
            btn.Text = player.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextScaled = true
            btn.Font = Enum.Font.SourceSans
            btn.Parent = dropdownList

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                selectedTarget = player
                if aimbotEnabled then
                    stopAimbot()
                    startAimbot()
                end
                updateDropdown()
                dropdownToggle.Text = "▼ " .. player.Name
                dropdownOpen = false
                dropdownFrame.Visible = false
                dropdownToggle.Text = "▼ " .. player.Name
            end)
        end
    end

    -- Adjust dropdown frame height based on content
    local count = dropdownList:GetChildren()
    local totalHeight = #count * 30 + 10
    dropdownFrame.Size = UDim2.new(1, -10, 0, math.min(totalHeight, 160))
end

-- Dropdown toggle click
dropdownToggle.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownFrame.Visible = dropdownOpen
    if dropdownOpen then
        updateDropdown()
        dropdownToggle.Text = "▲ " .. (selectedTarget and selectedTarget.Name or "Select")
    else
        dropdownToggle.Text = "▼ " .. (selectedTarget and selectedTarget.Name or "Select")
    end
end)

-- Aimbot toggle
toggleBtn.MouseButton1Click:Connect(function()
    if aimbotEnabled then
        stopAimbot()
        toggleBtn.BackgroundColor3 = Color3.new(0.4, 0.15, 0.15)
        toggleBtn.Text = "OFF"
    else
        startAimbot()
        toggleBtn.BackgroundColor3 = Color3.new(0.15, 0.5, 0.15)
        toggleBtn.Text = "ON"
    end
end)

-- ================================
-- Main update loop
-- ================================
RunService.Heartbeat:Connect(function()
    updateESP()
    if dropdownOpen then
        updateDropdown()
    end
end)

-- Initial ESP refresh
task.wait(1)
refreshESP()

-- ================================
-- Handle new players
-- ================================
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        refreshESP()
        if dropdownOpen then
            updateDropdown()
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    refreshESP()
end)
