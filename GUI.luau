loadstring(game:HttpGet("https://raw.githubusercontent.com/Git-art-byte/Blox-Fruit-Commands/refs/heads/main/Blox%20Fruit%20Cmds.luau"))()

------------
GUI
------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ClosestPlayerTP"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 100)
frame.Position = UDim2.new(0.5, -90, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Closest Player TP"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 45)
button.Position = UDim2.new(0, 10, 0, 45)
button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
button.Text = "TELEPORT"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Find closest player
local function getClosestPlayer()
	local character = LocalPlayer.Character
	if not character then return nil end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	local closest = nil
	local shortestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")

			if targetRoot then
				local distance = (root.Position - targetRoot.Position).Magnitude

				if distance < shortestDistance then
					shortestDistance = distance
					closest = player
				end
			end
		end
	end

	return closest
end

button.Activated:Connect(function()
	local target = getClosestPlayer()

	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		local myRoot = LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if targetRoot and myRoot then
			myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)

-- Mobile + PC draggable
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
