local suskey = "hs9gG4x77kL@bE+zP2"
local captchaSite = "https://direct-link.net/1371454/rgJYZAyWUNCj"
local scriptLink = "https://raw.githubusercontent.com/davitrollz/Davitrollz-/refs/heads/main/steal%20a%20brainrot%20base.lua"

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyGui"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
mainFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.TextColor3 = Color3.fromRGB(255, 148, 148)
closeButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.MouseButton1Click:Connect(function() gui:Destroy() end)

local getKeyButton = Instance.new("TextButton", mainFrame)
getKeyButton.Text = "Get Key"
getKeyButton.Font = Enum.Font.SourceSansSemibold
getKeyButton.TextSize = 28
getKeyButton.TextColor3 = Color3.new(1, 1, 1)
getKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
getKeyButton.Size = UDim2.new(0, 150, 0, 50)
getKeyButton.Position = UDim2.new(0.1, 0, 0, 60)
getKeyButton.MouseButton1Click:Connect(function()
	setclipboard(captchaSite)
	game.StarterGui:SetCore("SendNotification", {
		Title = "Link copied",
		Text = "The CAPTCHA site link was copied to your clipboard",
		Duration = 5
	})
end)

local keyBox = Instance.new("TextBox", mainFrame)
keyBox.PlaceholderText = "Paste your key here"
keyBox.Font = Enum.Font.SourceSansSemibold
keyBox.TextSize = 24
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyBox.Size = UDim2.new(0, 200, 0, 40)
keyBox.Position = UDim2.new(0.55, 0, 0, 65)

local checkKeyButton = Instance.new("TextButton", mainFrame)
checkKeyButton.Text = "Check Key"
checkKeyButton.Font = Enum.Font.SourceSansSemibold
checkKeyButton.TextSize = 24
checkKeyButton.TextColor3 = Color3.new(1, 1, 1)
checkKeyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
checkKeyButton.Size = UDim2.new(0, 150, 0, 40)
checkKeyButton.Position = UDim2.new(0.5, -75, 0, 120)

checkKeyButton.MouseButton1Click:Connect(function()
	if keyBox.Text == suskey then
		game.StarterGui:SetCore("SendNotification", {
			Title = "Correct Key",
			Text = "Access Granted!",
			Duration = 5
		})
		gui:Destroy()
		pcall(function()
			loadstring(game:HttpGet(scriptLink))()
		end)
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "Wrong Key",
			Text = "Please check your key and try again.",
			Duration = 5
		})
	end
end)
