-- Optimized Counter Blox Script: Aimbot (Silent/Fix), Triggerbot (Chams Color Activation), Enhanced ESP/Visuals, Improved HUD (Bomb Timer), Grenade Prediction
-- Inspired by top scripts: Silent Aim, ESP Boxes/Tracers, Bhop, Kill All from GitHub/Rscripts
-- LocalScript for Xeno v1.2.50U

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Injection Notification
local function showNotification(message, color)
    local gui = Instance.new("ScreenGui")
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0, 50)
    frame.BackgroundColor3 = color or Color3.fromRGB(0, 255, 0)
    frame.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = frame
    task.wait(3)
    gui:Destroy()
end

pcall(function()
    showNotification("Скрипт успешно загружен для Counter Blox!", Color3.fromRGB(0, 255, 0))
end)

-- GUI Setup (Movable Config)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChamsConfig"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 500)
Frame.Position = UDim2.new(0.5, -125, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Text = "Counter Blox Config"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

-- Inputs (Chams) - Expanded for more visuals
local FillColorLabel = Instance.new("TextLabel")
FillColorLabel.Text = "Fill Color (R,G,B)"
FillColorLabel.Size = UDim2.new(1, 0, 0, 20)
FillColorLabel.Position = UDim2.new(0, 0, 0, 30)
FillColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FillColorLabel.Parent = Frame

local FillColorInput = Instance.new("TextBox")
FillColorInput.Size = UDim2.new(1, 0, 0, 20)
FillColorInput.Position = UDim2.new(0, 0, 0, 50)
FillColorInput.Text = "255,0,0"
FillColorInput.Parent = Frame

local OutlineColorLabel = Instance.new("TextLabel")
OutlineColorLabel.Text = "Outline Color (R,G,B)"
OutlineColorLabel.Size = UDim2.new(1, 0, 0, 20)
OutlineColorLabel.Position = UDim2.new(0, 0, 0, 70)
OutlineColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutlineColorLabel.Parent = Frame

local OutlineColorInput = Instance.new("TextBox")
OutlineColorInput.Size = UDim2.new(1, 0, 0, 20)
OutlineColorInput.Position = UDim2.new(0, 0, 0, 90)
OutlineColorInput.Text = "0,255,0"
OutlineColorInput.Parent = Frame

local FillTransLabel = Instance.new("TextLabel")
FillTransLabel.Text = "Fill Transparency (0-1)"
FillTransLabel.Size = UDim2.new(1, 0, 0, 20)
FillTransLabel.Position = UDim2.new(0, 0, 0, 110)
FillTransLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FillTransLabel.Parent = Frame

local FillTransInput = Instance.new("TextBox")
FillTransInput.Size = UDim2.new(1, 0, 0, 20)
FillTransInput.Position = UDim2.new(0, 0, 0, 130)
FillTransInput.Text = "0.5"
FillTransInput.Parent = Frame

local OutlineTransLabel = Instance.new("TextLabel")
OutlineTransLabel.Text = "Outline Transparency (0-1)"
OutlineTransLabel.Size = UDim2.new(1, 0, 0, 20)
OutlineTransLabel.Position = UDim2.new(0, 0, 0, 150)
OutlineTransLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutlineTransLabel.Parent = Frame

local OutlineTransInput = Instance.new("TextBox")
OutlineTransInput.Size = UDim2.new(1, 0, 0, 20)
OutlineTransInput.Position = UDim2.new(0, 0, 0, 170)
OutlineTransInput.Text = "0"
OutlineTransInput.Parent = Frame

-- Toggles (Expanded)
local BunnyhopToggle = Instance.new("TextButton")
BunnyhopToggle.Text = "Bunnyhop: Off (F1)"
BunnyhopToggle.Size = UDim2.new(1, 0, 0, 30)
BunnyhopToggle.Position = UDim2.new(0, 0, 0, 190)
BunnyhopToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BunnyhopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BunnyhopToggle.Parent = Frame
local bhEnabled = false

BunnyhopToggle.MouseButton1Click:Connect(function()
    bhEnabled = not bhEnabled
    BunnyhopToggle.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off") .. " (F1)"
    UpdateHUD()
end)

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Text = "Silent Aimbot: Off (F2)"
AimbotToggle.Size = UDim2.new(1, 0, 0, 30)
AimbotToggle.Position = UDim2.new(0, 0, 0, 220)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Parent = Frame
local aimbotEnabled = false

AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotToggle.Text = "Silent Aimbot: " .. (aimbotEnabled and "On" or "Off") .. " (F2)"
    UpdateHUD()
end)

local VisibleCheckToggle = Instance.new("TextButton")
VisibleCheckToggle.Text = "Visible Check: On"
VisibleCheckToggle.Size = UDim2.new(1, 0, 0, 20)
VisibleCheckToggle.Position = UDim2.new(0, 0, 0, 250)
VisibleCheckToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
VisibleCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
VisibleCheckToggle.Parent = Frame
local visibleCheck = true

VisibleCheckToggle.MouseButton1Click:Connect(function()
    visibleCheck = not visibleCheck
    VisibleCheckToggle.Text = "Visible Check: " .. (visibleCheck and "On" or "Off")
end)

local FireCheckToggle = Instance.new("TextButton")
FireCheckToggle.Text = "Fire Check: On"
FireCheckToggle.Size = UDim2.new(1, 0, 0, 20)
FireCheckToggle.Position = UDim2.new(0, 0, 0, 270)
FireCheckToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FireCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FireCheckToggle.Parent = Frame
local fireCheck = true

FireCheckToggle.MouseButton1Click:Connect(function()
    fireCheck = not fireCheck
    FireCheckToggle.Text = "Fire Check: " .. (fireCheck and "On" or "Off")
end)

local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Text = "Smooth Factor (0-1)"
SmoothLabel.Size = UDim2.new(1, 0, 0, 20)
SmoothLabel.Position = UDim2.new(0, 0, 0, 290)
SmoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothLabel.Parent = Frame

local SmoothInput = Instance.new("TextBox")
SmoothInput.Size = UDim2.new(1, 0, 0, 20)
SmoothInput.Position = UDim2.new(0, 0, 0, 310)
SmoothInput.Text = "0.5"
SmoothInput.Parent = Frame

local SmoothCheckToggle = Instance.new("TextButton")
SmoothCheckToggle.Text = "Smooth: On"
SmoothCheckToggle.Size = UDim2.new(1, 0, 0, 20)
SmoothCheckToggle.Position = UDim2.new(0, 0, 0, 330)
SmoothCheckToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SmoothCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothCheckToggle.Parent = Frame
local smoothEnabled = true

SmoothCheckToggle.MouseButton1Click:Connect(function()
    smoothEnabled = not smoothEnabled
    SmoothCheckToggle.Text = "Smooth: " .. (smoothEnabled and "On" or "Off")
end)

local TriggerbotToggle = Instance.new("TextButton")
TriggerbotToggle.Text = "Triggerbot (Chams Color): Off (F3)"
TriggerbotToggle.Size = UDim2.new(1, 0, 0, 30)
TriggerbotToggle.Position = UDim2.new(0, 0, 0, 350)
TriggerbotToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TriggerbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerbotToggle.Parent = Frame
local triggerbotEnabled = false

TriggerbotToggle.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    TriggerbotToggle.Text = "Triggerbot (Chams Color): " .. (triggerbotEnabled and "On" or "Off") .. " (F3)"
    UpdateHUD()
end)

local ESPToggle = Instance.new("TextButton")
ESPToggle.Text = "ESP (Boxes/Tracers): Off (F4)"
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Position = UDim2.new(0, 0, 0, 380)
ESPToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = Frame
local espEnabled = false

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP (Boxes/Tracers): " .. (espEnabled and "On" or "Off") .. " (F4)"
    UpdateHUD()
end)

local BombToggle = Instance.new("TextButton")
BombToggle.Text = "Bomb Info: Off (F5)"
BombToggle.Size = UDim2.new(1, 0, 0, 30)
BombToggle.Position = UDim2.new(0, 0, 0, 410)
BombToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BombToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BombToggle.Parent = Frame
local bombEnabled = false

BombToggle.MouseButton1Click:Connect(function()
    bombEnabled = not bombEnabled
    BombToggle.Text = "Bomb Info: " .. (bombEnabled and "On" or "Off") .. " (F5)"
    UpdateHUD()
end)

local GrenadeToggle = Instance.new("TextButton")
GrenadeToggle.Text = "Grenade Prediction: Off (F6)"
GrenadeToggle.Size = UDim2.new(1, 0, 0, 30)
GrenadeToggle.Position = UDim2.new(0, 0, 0, 440)
GrenadeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GrenadeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GrenadeToggle.Parent = Frame
local grenadeEnabled = false

GrenadeToggle.MouseButton1Click:Connect(function()
    grenadeEnabled = not grenadeEnabled
    GrenadeToggle.Text = "Grenade Prediction: " .. (grenadeEnabled and "On" or "Off") .. " (F6)"
    UpdateHUD()
end)

local ApplyButton = Instance.new("TextButton")
ApplyButton.Text = "Apply Chams"
ApplyButton.Size = UDim2.new(1, 0, 0, 30)
ApplyButton.Position = UDim2.new(0, 0, 0, 470)
ApplyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- Chams Settings
local chamsSettings = {
    FillColor = Color3.fromRGB(255, 0, 0),
    OutlineColor = Color3.fromRGB(0, 255, 0),
    FillTransparency = 0.5,
    OutlineTransparency = 0
}

local function parseColor(text)
    local r, g, b = text:match("(%d+),(%d+),(%d+)")
    r, g, b = tonumber(r), tonumber(g), tonumber(b)
    if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
        return Color3.fromRGB(r, g, b)
    end
    return Color3.fromRGB(255, 0, 0)
end

local function parseTransparency(text)
    local num = tonumber(text)
    if num and num >= 0 and num <= 1 then
        return num
    end
    return 0.5
end

local function addChams(char)
    if char and char ~= LocalPlayer.Character and char:FindFirstChild("Humanoid") then
        local highlight = char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = chamsSettings.FillColor
        highlight.OutlineColor = chamsSettings.OutlineColor
        highlight.FillTransparency = chamsSettings.FillTransparency
        highlight.OutlineTransparency = chamsSettings.OutlineTransparency
        highlight.Parent = char
    end
end

local function updateAllChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            addChams(player.Character)
        end
    end
end

ApplyButton.MouseButton1Click:Connect(function()
    chamsSettings.FillColor = parseColor(FillColorInput.Text)
    chamsSettings.OutlineColor = parseColor(OutlineColorInput.Text)
    chamsSettings.FillTransparency = parseTransparency(FillTransInput.Text)
    chamsSettings.OutlineTransparency = parseTransparency(OutlineTransInput.Text)
    updateAllChams()
end)

-- Player Handling for Respawn
local respawnDebounce = {}
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.defer(addChams, char)
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if not respawnDebounce[player] then
                        respawnDebounce[player] = true
                        task.wait(6)
                        if player.Character then addChams(player.Character) end
                        respawnDebounce[player] = false
                    end
                end)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateAllChams()
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then addChams(player.Character) end
        player.CharacterAdded:Connect(addChams)
    end
end

-- Bunnyhop (Inspired from Bhop scripts)
RunService.Heartbeat:Connect(function()
    if bhEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid.Jump = true
        end
    end
end)

-- Silent Aimbot Fix for Counter Blox (Target Head/UpperTorso, Velocity Prediction)
local function isVisible(target)
    if not visibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or result.Instance:IsDescendantOf(target.Parent)
end

local function canFire()
    if not fireCheck then return true end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool ~= nil and tool:FindFirstChild("Fire")  -- Counter Blox gun check
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 and player.Team ~= LocalPlayer.Team then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mouseDist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if mouseDist < dist and mouseDist < 200 and isVisible(head) then
                    dist = mouseDist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and canFire() then
        local target = getClosestEnemy()
        if target then
            local smoothFactor = smoothEnabled and (tonumber(SmoothInput.Text) or 0.5) + math.random(-0.1, 0.1) or 1
            local predictPos = target.Position + target.AssemblyLinearVelocity * (LocalPlayer.Character.Head.Position - target.Position).Magnitude / 1000  -- Velocity prediction for bullets
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.lookAt(currentCFrame.Position, predictPos)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, smoothFactor)
        end
    end
end)

-- Triggerbot (Activated by Chams Color - Raycast check if hit has Highlight with matching FillColor)
local lastTrigger = 0
RunService.Heartbeat:Connect(function()
    if triggerbotEnabled and canFire() and tick() - lastTrigger > 0.1 then
        local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
        if result and result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") then
            local highlight = result.Instance.Parent:FindFirstChildOfClass("Highlight")
            if highlight and highlight.FillColor == chamsSettings.FillColor then  -- Activate on chams color
                mouse1press()
                task.wait(0.05 + math.random(0, 0.05))
                mouse1release()
                lastTrigger = tick()
            end
        end
    end
end)

-- Enhanced ESP (Boxes, Tracers, Names, Health) - Inspired from Rscripts ESP
local espDrawings = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local char = player.Character
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 255, 255)

    local nameLabel = Drawing.new("Text")
    nameLabel.Text = player.Name
    nameLabel.Size = 16
    nameLabel.Color = Color3.fromRGB(255, 255, 255)

    local healthLabel = Drawing.new("Text")
    healthLabel.Size = 16
    healthLabel.Color = Color3.fromRGB(0, 255, 0)

    espDrawings[player] = {box = box, tracer = tracer, name = nameLabel, health = healthLabel}
end

local function updateESP()
    for player, drawings in pairs(espDrawings) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local root = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local headPos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
            local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

            if onScreen then
                drawings.box.Visible = true
                drawings.box.Size = Vector2.new(2000 / headPos.Z, footPos.Y - headPos.Y)
                drawings.box.Position = Vector2.new(headPos.X - drawings.box.Size.X / 2, headPos.Y)

                drawings.tracer.Visible = true
                drawings.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                drawings.tracer.To = Vector2.new(headPos.X, headPos.Y)

                drawings.name.Visible = true
                drawings.name.Position = Vector2.new(headPos.X, headPos.Y - 20)

                drawings.health.Visible = true
                drawings.health.Text = tostring(math.floor(humanoid.Health))
                drawings.health.Position = Vector2.new(headPos.X, headPos.Y - 40)
            else
                drawings.box.Visible = false
                drawings.tracer.Visible = false
                drawings.name.Visible = false
                drawings.health.Visible = false
            end
        else
            drawings.box.Visible = false
            drawings.tracer.Visible = false
            drawings.name.Visible = false
            drawings.health.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    addESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    addESP(player)
end

-- Improved HUD (Bomb Timer, Grenade Pred, etc.)
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "HUD"
HudGui.ResetOnSpawn = false
HudGui.Parent = LocalPlayer.PlayerGui

local HudFrame = Instance.new("Frame")
HudFrame.Size = UDim2.new(0, 200, 0, 150)
HudFrame.Position = UDim2.new(1, -210, 0, 10)
HudFrame.BackgroundTransparency = 0.3
HudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HudFrame.Parent = HudGui

local HudTitle = Instance.new("TextLabel")
HudTitle.Text = "Counter Blox HUD"
HudTitle.Size = UDim2.new(1, 0, 0, 20)
HudTitle.BackgroundTransparency = 1
HudTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HudTitle.Parent = HudFrame

local BhStatus = Instance.new("TextLabel")
BhStatus.Size = UDim2.new(1, 0, 0, 20)
BhStatus.Position = UDim2.new(0, 0, 0, 20)
BhStatus.BackgroundTransparency = 1
BhStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
BhStatus.Parent = HudFrame

local AimStatus = Instance.new("TextLabel")
AimStatus.Size = UDim2.new(1, 0, 0, 20)
AimStatus.Position = UDim2.new(0, 0, 0, 40)
AimStatus.BackgroundTransparency = 1
AimStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AimStatus.Parent = HudFrame

local TrigStatus = Instance.new("TextLabel")
TrigStatus.Size = UDim2.new(1, 0, 0, 20)
TrigStatus.Position = UDim2.new(0, 0, 0, 60)
TrigStatus.BackgroundTransparency = 1
TrigStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
TrigStatus.Parent = HudFrame

local ESPStatus = Instance.new("TextLabel")
ESPStatus.Size = UDim2.new(1, 0, 0, 20)
ESPStatus.Position = UDim2.new(0, 0, 0, 80)
ESPStatus.BackgroundTransparency = 1
ESPStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPStatus.Parent = HudFrame

local BombStatus = Instance.new("TextLabel")
BombStatus.Size = UDim2.new(1, 0, 0, 20)
BombStatus.Position = UDim2.new(0, 0, 0, 100)
BombStatus.BackgroundTransparency = 1
BombStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
BombStatus.Parent = HudFrame

local GrenadeStatus = Instance.new("TextLabel")
GrenadeStatus.Size = UDim2.new(1, 0, 0, 20)
GrenadeStatus.Position = UDim2.new(0, 0, 0, 120)
GrenadeStatus.BackgroundTransparency = 1
GrenadeStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
GrenadeStatus.Parent = HudFrame

local function UpdateHUD()
    BhStatus.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off")
    AimStatus.Text = "Silent Aimbot: " .. (aimbotEnabled and "On" or "Off")
    TrigStatus.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off")
    ESPStatus.Text = "ESP: " .. (espEnabled and "On" or "Off")
    BombStatus.Text = "Bomb Info: " .. (bombEnabled and "On" or "Off")
    GrenadeStatus.Text = "Grenade Pred: " .. (grenadeEnabled and "On" or "Off")
end
UpdateHUD()

-- Bomb Info (Timer/Location - From ReplicatedStorage.wkspc.Status)
RunService.RenderStepped:Connect(function()
    if bombEnabled then
        local wkspc = ReplicatedStorage:FindFirstChild("wkspc")
        if wkspc then
            local status = wkspc:FindFirstChild("Status")
            if status then
                local bombTimer = status:FindFirstChild("RoundTime") or status:FindFirstChild("BombTime")  -- Adapt to game values
                if bombTimer then
                    BombStatus.Text = "Bomb Timer: " .. bombTimer.Value .. "s"
                else
                    BombStatus.Text = "Bomb: Not Planted"
                end
            end
        end
    end
end)

-- Grenade Prediction (Draw Trajectory Line - Simulate Physics)
local grenadeLines = {}
RunService.RenderStepped:Connect(function()
    if grenadeEnabled then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "Grenade" or obj.Name == "Flashbang" or obj.Name == "Smoke" then  -- Counter Blox grenade names
                local velocity = obj.AssemblyLinearVelocity
                local position = obj.Position
                local gravity = Vector3.new(0, -workspace.Gravity, 0)
                local line = Drawing.new("Line")
                line.Color = Color3.fromRGB(255, 255, 0)
                line.Thickness = 2
                line.Visible = true
                line.From = Camera:WorldToViewportPoint(position)
                local predPos = position
                for i = 1, 50 do  -- Predict 50 steps
                    predPos = predPos + velocity / 60 + gravity / (60 * 60) / 2
                    velocity = velocity + gravity / 60
                    local screenPos = Camera:WorldToViewportPoint(predPos)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                end
                table.insert(grenadeLines, line)
                task.wait(0.1)
                line:Remove()
            end
        end
    end
end)

-- Keybinds (Expanded)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    elseif input.KeyCode == Enum.KeyCode.F1 then
        bhEnabled = not bhEnabled
        BunnyhopToggle.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off") .. " (F1)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        aimbotEnabled = not aimbotEnabled
        AimbotToggle.Text = "Silent Aimbot: " .. (aimbotEnabled and "On" or "Off") .. " (F2)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        triggerbotEnabled = not triggerbotEnabled
        TriggerbotToggle.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off") .. " (F3)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        espEnabled = not espEnabled
        ESPToggle.Text = "ESP: " .. (espEnabled and "On" or "Off") .. " (F4)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        bombEnabled = not bombEnabled
        BombToggle.Text = "Bomb Info: " .. (bombEnabled and "On" or "Off") .. " (F5)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        grenadeEnabled = not grenadeEnabled
        GrenadeToggle.Text = "Grenade Pred: " .. (grenadeEnabled and "On" or "Off") .. " (F6)"
        UpdateHUD()
    end
end)

-- Initial Chams Apply
local success, err = pcall(updateAllChams)
if not success then
    showNotification("Ошибка инициализации чамсов!", Color3.fromRGB(255, 0, 0))
end
UpdateHUD()
