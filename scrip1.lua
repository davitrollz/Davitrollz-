local ts = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
local lp = game.Players.LocalPlayer

local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("Credits: TGMANKASKE")
local Section = Window:NewSection("Boosts")


local savedPos = nil

Section:CreateButton("Boost Speed", function()

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local desiredSpeed = 48

    local function applySpeed(humanoid)
        humanoid.WalkSpeed = desiredSpeed
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= desiredSpeed then
                humanoid.WalkSpeed = desiredSpeed
            end
        end)
    end

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        applySpeed(humanoid)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end)


Section:CreateButton("Boost Jump", function()



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Força extra do pulo (ajustável)
local jumpBoostPower = 62  -- Valor maior = pulo mais forte

local boostEnabled = true

-- Função para aplicar boost no pulo
local function onJumpRequest()
    if boostEnabled and humanoid and humanoid.Parent then
        -- Checa se está no chão antes de pular
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            -- Aplica força extra no pulo
            humanoid.JumpPower = jumpBoostPower
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            -- Restaura JumpPower para o padrão depois (0.1 seg)
            delay(0.1, function()
                if humanoid then
                    humanoid.JumpPower = 50 -- padrão Roblox é 50, ajuste se necessário
                end
            end)
        end
    end
end

-- Conecta o evento de pulo (pode ser via UserInputService ou Humanoid)
UserInputService.JumpRequest:Connect(onJumpRequest)

-- Função pra ligar/desligar o boost
local function setBoostEnabled(enabled)
    boostEnabled = enabled
    if not enabled and humanoid then
        humanoid.JumpPower = 50 -- volta ao normal
    end
end

end)



Section:CreateButton("Air Jump", function()

local enabled = true -- ✅ true para ativar, false para desativar o AirJump

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Impulso vertical configurável
local jumpForce = 62

-- Controla se o jogador está no ar
local isJumping = false

-- Detecta quando pular
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not enabled then return end
	if input.KeyCode == Enum.KeyCode.Space then
		if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			-- AirJump: aplica impulso vertical manualmente (bypass)
			hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
		end
	end
end)

-- Atualiza referências após respawn
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	hrp = newChar:WaitForChild("HumanoidRootPart")
end)

end)



Section:CreateButton("Float Menu", function()


-- CONFIGURAÇÕES INICIAIS
local FLOAT_HEIGHT = 7
local FLOAT_SPEED = 25
local MIN_HEIGHT, MAX_HEIGHT = 2, 15
local MIN_SPEED, MAX_SPEED = 12, 50
local POSITION_FORCE = 25000
local VELOCITY_FORCE = 25000

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ESTADO
local floating = false
local bodyPos, bodyVel
local floatConn

-- INICIAR FLOAT
local function startFloat(char)
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	bodyPos = Instance.new("BodyPosition")
	bodyPos.Name = "TimedFloatPosition"
	bodyPos.P = 10000
	bodyPos.D = 1000
	bodyPos.MaxForce = Vector3.new(0, POSITION_FORCE, 0)
	bodyPos.Position = hrp.Position
	bodyPos.Parent = hrp

	bodyVel = Instance.new("BodyVelocity")
	bodyVel.Name = "TimedFloatVelocity"
	bodyVel.P = 1250
	bodyVel.MaxForce = Vector3.new(VELOCITY_FORCE, 0, VELOCITY_FORCE)
	bodyVel.Velocity = Vector3.zero
	bodyVel.Parent = hrp

	floatConn = RunService.Heartbeat:Connect(function()
		if not hrp or not char or not char:IsDescendantOf(workspace) then return end
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), rayParams)
		local targetY = hrp.Position.Y
		if ray then
			targetY = ray.Position.Y + FLOAT_HEIGHT
		end

		bodyPos.Position = Vector3.new(hrp.Position.X, targetY, hrp.Position.Z)

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		dir = Vector3.new(dir.X, 0, dir.Z)
		bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * FLOAT_SPEED or Vector3.zero
	end)

	humanoid.Died:Connect(function()
		stopFloat()
	end)
end

-- PARAR FLOAT
function stopFloat()
	floating = false
	if floatConn then floatConn:Disconnect() floatConn = nil end
	if bodyPos then bodyPos:Destroy() bodyPos = nil end
	if bodyVel then bodyVel:Destroy() bodyVel = nil end
	updateUI()
end

-- TOGGLE
function toggleFloat()
	floating = not floating
	if floating then
		if player.Character then
			startFloat(player.Character)
		end
	else
		stopFloat()
	end
	updateUI()
end

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatMenuUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0, 30, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.Text = "🚘 Float Settings"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Text = "Float: OFF"
toggleBtn.Parent = frame

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 6)
toggleUICorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(toggleFloat)

local draggingSlider = false

-- Sliders
local function createSlider(yPos, labelText, minVal, maxVal, initialVal, onChange)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, yPos)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText..": "..initialVal
	label.Parent = frame

	local slider = Instance.new("Frame")
	slider.Size = UDim2.new(1, -20, 0, 18)
	slider.Position = UDim2.new(0, 10, 0, yPos + 20)
	slider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	slider.BorderSizePixel = 0
	slider.ClipsDescendants = true
	slider.Parent = frame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((initialVal - minVal)/(maxVal - minVal), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	fill.BorderSizePixel = 0
	fill.Parent = slider

	local corner1 = Instance.new("UICorner")
	corner1.CornerRadius = UDim.new(0, 6)
	corner1.Parent = slider

	local corner2 = Instance.new("UICorner")
	corner2.CornerRadius = UDim.new(0, 6)
	corner2.Parent = fill

	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			frame.Draggable = false

			local moveConn
			moveConn = UserInputService.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
					local x = math.clamp(moveInput.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
					local pct = x / slider.AbsoluteSize.X
					local value = math.floor(minVal + pct * (maxVal - minVal))
					fill.Size = UDim2.new(pct, 0, 1, 0)
					label.Text = labelText..": "..value
					onChange(value)
				end
			end)

			local function endInput(inputEnded)
				if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
					frame.Draggable = true
					moveConn:Disconnect()
					UserInputService.InputEnded:Disconnect(endInput)
				end
			end

			UserInputService.InputEnded:Connect(endInput)
		end
	end)
end

createSlider(80, "Altura", MIN_HEIGHT, MAX_HEIGHT, FLOAT_HEIGHT, function(val)
	FLOAT_HEIGHT = val
end)

createSlider(130, "Velocidade", MIN_SPEED, MAX_SPEED, FLOAT_SPEED, function(val)
	FLOAT_SPEED = val
end)

-- Atualiza botão
function updateUI()
	toggleBtn.Text = floating and "Float: ON" or "Float: OFF"
	toggleBtn.BackgroundColor3 = floating and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
end

-- Keybind
local toggleKeyConn = UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		toggleFloat()
	end
end)

-- Respawn
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	task.wait(0.2)
	if floating then
		startFloat(char)
	end
end)

updateUI()



end)



Section:CreateButton("Fly Menu", function()

-- Módulos Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Variáveis principais
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart
local humanoid

local flying = false
local flySpeed = 100
local minSpeed = 10
local maxSpeed = 300

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bodyVelocity.P = 1e4

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
bodyGyro.P = 5e4

local inputStates = {
	Forward = false,
	Backward = false,
	Left = false,
	Right = false,
	Up = false,
	Down = false,
}

-- Atualiza personagem ao spawnar
local function onCharacterAdded(char)
	character = char
	rootPart = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	flying = false
	bodyVelocity.Parent = nil
	bodyGyro.Parent = nil
	if humanoid then humanoid.PlatformStand = false end
end

player.CharacterAdded:Connect(onCharacterAdded)
onCharacterAdded(character)

-- Input
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.W then inputStates.Forward = true end
	if input.KeyCode == Enum.KeyCode.S then inputStates.Backward = true end
	if input.KeyCode == Enum.KeyCode.A then inputStates.Left = true end
	if input.KeyCode == Enum.KeyCode.D then inputStates.Right = true end
	if input.KeyCode == Enum.KeyCode.Space then inputStates.Up = true end
	if input.KeyCode == Enum.KeyCode.LeftShift then inputStates.Down = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then inputStates.Forward = false end
	if input.KeyCode == Enum.KeyCode.S then inputStates.Backward = false end
	if input.KeyCode == Enum.KeyCode.A then inputStates.Left = false end
	if input.KeyCode == Enum.KeyCode.D then inputStates.Right = false end
	if input.KeyCode == Enum.KeyCode.Space then inputStates.Up = false end
	if input.KeyCode == Enum.KeyCode.LeftShift then inputStates.Down = false end
end)

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 180)
frame.Position = UDim2.new(0, 20, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fundo preto
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 1)
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(30, 140, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.Text = ".gg/esYJzYnsfC ✈️"
title.TextXAlignment = Enum.TextXAlignment.Left

-- Efeito RGB no título
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.5) % 1
	title.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -42, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 24
closeButton.BorderSizePixel = 0

closeButton.MouseButton1Click:Connect(function()
	flying = false
	bodyVelocity.Parent = nil
	bodyGyro.Parent = nil
	if humanoid then humanoid.PlatformStand = false end
	gui:Destroy()
end)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 20
statusLabel.TextColor3 = Color3.fromRGB(160, 200, 255)
statusLabel.Text = "Status: OFF"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0.9, 0, 0, 44)
toggleButton.Position = UDim2.new(0.05, 0, 0, 95)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 46, 70)
toggleButton.TextColor3 = Color3.fromRGB(140, 210, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 22
toggleButton.Text = "▶ Enable Fly"
toggleButton.BorderSizePixel = 0

local sliderBar = Instance.new("Frame", frame)
sliderBar.Size = UDim2.new(0.9, 0, 0, 22)
sliderBar.Position = UDim2.new(0.05, 0, 0, 150)
sliderBar.BackgroundColor3 = Color3.fromRGB(40, 55, 80)
sliderBar.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.new((flySpeed - minSpeed)/(maxSpeed - minSpeed), 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
sliderFill.BorderSizePixel = 0

local sliderThumb = Instance.new("ImageButton", sliderBar)
sliderThumb.Size = UDim2.new(0, 26, 0, 26)
sliderThumb.Position = sliderFill.Size
sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
sliderThumb.BackgroundTransparency = 1
sliderThumb.Image = "rbxassetid://3570695787"
sliderThumb.ImageColor3 = Color3.fromRGB(0, 170, 255)
sliderThumb.BorderSizePixel = 0

local draggingSlider = false

local function updateUI()
	statusLabel.Text = flying and ("Status: ON | Speed: " .. flySpeed) or "Status: OFF"
	toggleButton.Text = flying and "❚❚ Disable Fly" or "▶ Enable Fly"
	local ratio = (flySpeed - minSpeed) / (maxSpeed - minSpeed)
	sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
	sliderThumb.Position = UDim2.new(ratio, 0, 0.5, 0)
end

toggleButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying and rootPart then
		bodyVelocity.Parent = rootPart
		bodyGyro.Parent = rootPart
		humanoid.PlatformStand = true
	else
		bodyVelocity.Parent = nil
		bodyGyro.Parent = nil
		humanoid.PlatformStand = false
	end
	updateUI()
end)

sliderThumb.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingSlider = false
			end
		end)
	end
end)

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		local rel = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
		rel = math.clamp(rel, 0, 1)
		flySpeed = math.floor(minSpeed + rel * (maxSpeed - minSpeed))
		updateUI()
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingSlider = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local rel = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
		rel = math.clamp(rel, 0, 1)
		flySpeed = math.floor(minSpeed + rel * (maxSpeed - minSpeed))
		updateUI()
	end
end)

-- Voo com rotação 3D livre
RunService.Heartbeat:Connect(function()
	if flying and rootPart and humanoid then
		local camCF = Workspace.CurrentCamera.CFrame
		local moveVec = Vector3.zero

		if inputStates.Forward then moveVec += camCF.LookVector end
		if inputStates.Backward then moveVec -= camCF.LookVector end
		if inputStates.Left then moveVec -= camCF.RightVector end
		if inputStates.Right then moveVec += camCF.RightVector end
		if inputStates.Up then moveVec += camCF.UpVector end
		if inputStates.Down then moveVec -= camCF.UpVector end

		if moveVec.Magnitude > 0 then
			bodyVelocity.Velocity = moveVec.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.zero
		end

		bodyGyro.CFrame = camCF
	end
end)

updateUI()
end)



Section:CreateButton("Attack aura", function()



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ATTACK_DISTANCE = 11
local ATTACK_COOLDOWN = 0.5

local lastAttackTime = 0
local currentCharacter = nil
local currentHumanoid = nil
local currentBackpack = nil

-- Equipa automaticamente a primeira Tool disponível
local function equipTool()
	if not currentCharacter then return end
	if not currentCharacter:FindFirstChildOfClass("Tool") then
		local tool = currentBackpack and currentBackpack:FindFirstChildOfClass("Tool")
		if tool then
			tool.Parent = currentCharacter
		end
	end
end

-- Ativa a Tool
local function attack()
	local tool = currentCharacter and currentCharacter:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("Handle") then
		tool:Activate()
	end
end

-- Verifica o jogador mais próximo
local function getClosestTarget()
	if not currentCharacter then return nil end

	local myRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	local closest = nil
	local shortestDistance = ATTACK_DISTANCE

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local theirRoot = otherPlayer.Character.HumanoidRootPart
			local distance = (myRoot.Position - theirRoot.Position).Magnitude
			if distance <= shortestDistance then
				closest = otherPlayer
				shortestDistance = distance
			end
		end
	end

	return closest
end

-- Lógica principal de ataque
RunService.RenderStepped:Connect(function()
	if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then return end

	local now = tick()
	local target = getClosestTarget()

	if target and now - lastAttackTime >= ATTACK_COOLDOWN then
		equipTool()
		attack()
		lastAttackTime = now
	end
end)

-- Atualiza variáveis quando o personagem for recriado
local function onCharacterAdded(char)
	currentCharacter = char
	currentHumanoid = char:WaitForChild("Humanoid")
	currentBackpack = LocalPlayer:WaitForChild("Backpack")
end

-- Inicializa com personagem atual
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Se já existe personagem ao iniciar
if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end



end)


Section:CreateButton("Float Mobile", function()

local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/davitrollz/Davitrollz-/refs/heads/main/float.lua")()

--module:Teleport(game.PlaceId)

end)





local savedPos = nil
local speed = 38

local Section = Window:NewSection("Teleports")

Section:CreateButton("Save Base Position", function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPos = hrp.Position
    end
end)


Section:CreateButton("Go to Saved Position", function()



	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")

	if savedPos and hrp and humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 77 -- pulo mais alto
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

		task.wait(0.1)

		local distance = (hrp.Position - savedPos).Magnitude
		local duration = distance / speed

		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
		local cf = CFrame.new(savedPos + Vector3.new(0, 8, 0)) -- voo mais alto também
		local tween = ts:Create(hrp, tweenInfo, {CFrame = cf})
		tween:Play()
	end






end)













local Section = Window:NewSection("ESP")

Section:CreateButton("Timer ALL bases", function()

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Defina aqui o nome exato do objeto que quer monitorar
local targetName = "Main"

-- Defina aqui o nome exato do TextLabel (ou TextBox) que tem o timer dentro do objeto
local timerTextLabelName = "RemainingTime"

local espObjects = {}

local function findTimerText(obj)
    -- Busca direta pelo nome exato do TextLabel/TextBox dentro do objeto
    local candidate = obj:FindFirstChild(timerTextLabelName, true) -- true para busca recursiva
    if candidate and (candidate:IsA("TextLabel") or candidate:IsA("TextBox")) then
        if candidate.Text and #candidate.Text > 0 then
            local num = tonumber(candidate.Text:match("%d+%.?%d*"))
            if num then
                return candidate
            end
        end
    end
    return nil
end

local function createESP(obj, textSource)
    if obj:FindFirstChild("TextTimerESP") then
        return obj.TextTimerESP
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TextTimerESP"
    billboard.Adornee = obj
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, (obj.Size and obj.Size.Y or 3) + 1, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = obj

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    textLabel.TextColor3 = Color3.new(1, 1, 0)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    return billboard
end

local function removeESP(obj)
    if obj:FindFirstChild("TextTimerESP") then
        obj.TextTimerESP:Destroy()
    end
end

local function updateESP()
    for obj, _ in pairs(espObjects) do
        if not obj:IsDescendantOf(Workspace) then
            removeESP(obj)
            espObjects[obj] = nil
        else
            local textSource = findTimerText(obj)
            if not textSource then
                removeESP(obj)
                espObjects[obj] = nil
            end
        end
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == targetName then
            local textSource = findTimerText(obj)
            if textSource and not espObjects[obj] then
                createESP(obj, textSource)
                espObjects[obj] = true
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    for obj, _ in pairs(espObjects) do
        local esp = obj:FindFirstChild("TextTimerESP")
        if esp then
            local textSource = findTimerText(obj)
            local textLabel = esp:FindFirstChildOfClass("TextLabel")
            if textSource and textLabel then
                textLabel.Text = string.format("%s\n%s", obj.Name, textSource.Text)
                esp.Enabled = true
            else
                esp.Enabled = false
            end
        end
    end
end)

while true do
    updateESP()
    wait(2)
end


end)

Section:CreateButton("Name", function()

local c = workspace.CurrentCamera
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local rs = game:GetService("RunService")

local function esp(p,cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("Head")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = false 
    text.Font = 3
    text.Size = 16.16
    text.Color = Color3.new(170,170,170)

    local conection
    local conection2
    local conection3

    local function dc()
        text.Visible = false
        text:Remove()
        if conection then
            conection:Disconnect()
            conection = nil 
        end
        if conection2 then
            conection2:Disconnect()
            conection2 = nil 
        end
        if conection3 then
            conection3:Disconnect()
            conection3 = nil 
        end
    end

    conection2 = cr.AncestryChanged:Connect(function(_,parent)
        if not parent then
            dc()
        end
    end)

    conection3 = h.HealthChanged:Connect(function(v)
        if (v<=0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    conection = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
        if hrp_onscreen then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y - 27)
            text.Text = "[ "..p.Name.." ]"
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

local function p_added(p)
    if p.Character then
        esp(p,p.Character)
    end
    p.CharacterAdded:Connect(function(cr)
        esp(p,cr)
    end)
end

for i,p in next, ps:GetPlayers() do 
    if p ~= lp then
        p_added(p)
    end
end

ps.PlayerAdded:Connect(p_added)

end)

Section:CreateButton("Skeleton", function()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()


local Skeletons = {}
for _, Player in next, game.Players:GetChildren() do
    table.insert(Skeletons, Library:NewSkeleton(Player, true));
end
game.Players.PlayerAdded:Connect(function(Player)
    table.insert(Skeletons, Library:NewSkeleton(Player, true));
end)

end)

local Section = Window:NewSection("Flings")

Section:CreateButton("WalkFling", function()

loadstring(game:HttpGet("https://pastefy.app/Vf5POrA6/raw"))()

end)


local Section = Window:NewSection("Extras")

Section:CreateButton("Server Hope", function()

local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()

module:Teleport(game.PlaceId)

end)

Section:CreateButton("Rejoin", function()

local player = game.Players.LocalPlayer
local gamePlaceId = game.PlaceId
local teleportService = game:GetService("TeleportService")
teleportService:Teleport(gamePlaceId, player)

end)

local Window = Library:NewWindow("See my team")
local Section = Window:NewSection("Team")

Section:CreateButton("TGMANKASKE", function()
print("tgmankaske")

end)

Section:CreateButton("Davitrollz", function()
print("Davitrollz")

end)
