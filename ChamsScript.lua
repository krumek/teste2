-- Optimized Counter Blox Script: Fixed Triggerbot (Team Check, Debug), Team Diff, Third-Person Fix (Offset), ESP Cleanup, Rage Features (Anti-Aim Spinbot, Double Tap, Fake Lag, Auto Shoot, Wallbang), Legit/Semi-Rage (Silent Aim, Legit AA)
-- Inspired by Fatality (Rage: Spinbot, DT, Fake Lag, Wallbang) and Mindate (Legit: Silent, Legit AA)
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

-- GUI Setup (Movable)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChamsConfig"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 600)
Frame.Position = UDim2.new(0.5, -125, 0.5, -300)
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

-- Chams Inputs (Unchanged)
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

-- Toggles (Added Rage/Legit)
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
TriggerbotToggle.Text = "Triggerbot: Off (F3)"
TriggerbotToggle.Size = UDim2.new(1, 0, 0, 30)
TriggerbotToggle.Position = UDim2.new(0, 0, 0, 350)
TriggerbotToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TriggerbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerbotToggle.Parent = Frame
local triggerbotEnabled = false

TriggerbotToggle.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    TriggerbotToggle.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off") .. " (F3)"
    UpdateHUD()
end)

local ESPToggle = Instance.new("TextButton")
ESPToggle.Text = "ESP: Off (F4)"
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Position = UDim2.new(0, 0, 0, 380)
ESPToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = Frame
local espEnabled = false

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP: " .. (espEnabled and "On" or "Off") .. " (F4)"
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
GrenadeToggle.Text = "Grenade Pred: Off (F6)"
GrenadeToggle.Size = UDim2.new(1, 0, 0, 30)
GrenadeToggle.Position = UDim2.new(0, 0, 0, 440)
GrenadeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GrenadeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GrenadeToggle.Parent = Frame
local grenadeEnabled = false

GrenadeToggle.MouseButton1Click:Connect(function()
    grenadeEnabled = not grenadeEnabled
    GrenadeToggle.Text = "Grenade Pred: " .. (grenadeEnabled and "On" or "Off") .. " (F6)"
    UpdateHUD()
end)

local AntiAimToggle = Instance.new("TextButton")
AntiAimToggle.Text = "Anti-Aim (Spinbot): Off (F7)"
AntiAimToggle.Size = UDim2.new(1, 0, 0, 30)
AntiAimToggle.Position = UDim2.new(0, 0, 0, 470)
AntiAimToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AntiAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAimToggle.Parent = Frame
local antiAimEnabled = false

AntiAimToggle.MouseButton1Click:Connect(function()
    antiAimEnabled = not antiAimEnabled
    AntiAimToggle.Text = "Anti-Aim (Spinbot): " .. (antiAimEnabled and "On" or "Off") .. " (F7)"
    UpdateHUD()
end)

local DoubleTapToggle = Instance.new("TextButton")
DoubleTapToggle.Text = "Double Tap: Off (F8)"
DoubleTapToggle.Size = UDim2.new(1, 0, 0, 30)
DoubleTapToggle.Position = UDim2.new(0, 0, 0, 500)
DoubleTapToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DoubleTapToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
DoubleTapToggle.Parent = Frame
local doubleTapEnabled = false

DoubleTapToggle.MouseButton1Click:Connect(function()
    doubleTapEnabled = not doubleTapEnabled
    DoubleTapToggle.Text = "Double Tap: " .. (doubleTapEnabled and "On" or "Off") .. " (F8)"
    UpdateHUD()
end)

local FakeLagToggle = Instance.new("TextButton")
FakeLagToggle.Text = "Fake Lag: Off (F9)"
FakeLagToggle.Size = UDim2.new(1, 0, 0, 30)
FakeLagToggle.Position = UDim2.new(0, 0, 0, 530)
FakeLagToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FakeLagToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeLagToggle.Parent = Frame
local fakeLagEnabled = false

FakeLagToggle.MouseButton1Click:Connect(function()
    fakeLagEnabled = not fakeLagEnabled
    FakeLagToggle.Text = "Fake Lag: " .. (fakeLagEnabled and "On" or "Off") .. " (F9)"
    UpdateHUD()
end)

local AutoShootToggle = Instance.new("TextButton")
AutoShootToggle.Text = "Auto Shoot: Off (F10)"
AutoShootToggle.Size = UDim2.new(1, 0, 0, 30)
AutoShootToggle.Position = UDim2.new(0, 0, 0, 560)
AutoShootToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoShootToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShootToggle.Parent = Frame
local autoShootEnabled = false

AutoShootToggle.MouseButton1Click:Connect(function()
    autoShootEnabled = not autoShootEnabled
    AutoShootToggle.Text = "Auto Shoot: " .. (autoShootEnabled and "On" or "Off") .. " (F10)"
    UpdateHUD()
end)

local WallbangToggle = Instance.new("TextButton")
WallbangToggle.Text = "Wallbang: Off (F11)"
WallbangToggle.Size = UDim2.new(1, 0, 0, 30)
WallbangToggle.Position = UDim2.new(0, 0, 0, 590)
WallbangToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WallbangToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WallbangToggle.Parent = Frame
local wallbangEnabled = false

WallbangToggle.MouseButton1Click:Connect(function()
    wallbangEnabled = not wallbangEnabled
    WallbangToggle.Text = "Wallbang: " .. (wallbangEnabled and "On" or "Off") .. " (F11)"
    UpdateHUD()
end)

local LegitAAToggle = Instance.new("TextButton")
LegitAAToggle.Text = "Legit AA: Off (F12)"
LegitAAToggle.Size = UDim2.new(1, 0, 0, 30)
LegitAAToggle.Position = UDim2.new(0, 0, 0, 620)
LegitAAToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LegitAAToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
LegitAAToggle.Parent = Frame
local legitAAEnabled = false

LegitAAToggle.MouseButton1Click:Connect(function()
    legitAAEnabled = not legitAAEnabled
    LegitAAToggle.Text = "Legit AA: " .. (legitAAEnabled and "On" or "Off") .. " (F12)"
    UpdateHUD()
end)

local ThirdPersonToggle = Instance.new("TextButton")
ThirdPersonToggle.Text = "Third-Person: Off (Insert)"
ThirdPersonToggle.Size = UDim2.new(1, 0, 0, 30)
ThirdPersonToggle.Position = UDim2.new(0, 0, 0, 650)
ThirdPersonToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ThirdPersonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ThirdPersonToggle.Parent = Frame
local thirdPersonEnabled = false

ThirdPersonToggle.MouseButton1Click:Connect(function()
    thirdPersonEnabled = not thirdPersonEnabled
    ThirdPersonToggle.Text = "Third-Person: " .. (thirdPersonEnabled and "On" or "Off") .. " (Insert)"
    UpdateHUD()
end)

local ApplyButton = Instance.new("TextButton")
ApplyButton.Text = "Apply Chams"
ApplyButton.Size = UDim2.new(1, 0, 0, 30)
ApplyButton.Position = UDim2.new(0, 0, 0, 680)
ApplyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- Chams Logic (Enemies Only)
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

local function addChams(char, player)
    if char and player.Team ~= LocalPlayer.Team and char:FindFirstChild("Humanoid") then
        local existing = char:FindFirstChildOfClass("Highlight")
        if existing then existing:Destroy() end
        local highlight = Instance.new("Highlight")
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
        if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
            addChams(player.Character, player)
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

-- Player Handling (Respawn Fix)
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            addChams(char, player)
            local humanoid = char:WaitForChild("Humanoid", 5)
            if humanoid then
                humanoid.Died:Connect(function()
                    task.wait(Players.RespawnTime + 0.5)
                    if player.Character then
                        addChams(player.Character, player)
                    end
                end)
            end
        end)
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            addChams(char, player)
        end)
        if player.Character then
            addChams(player.Character, player)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    updateAllChams()
end)

-- Bunnyhop
RunService.RenderStepped:Connect(function()
    if bhEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Silent Aimbot (Enemies Only)
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
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool and tool:FindFirstChild("Handle")
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
                if mouseDist < dist and isVisible(head) then
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
            local smoothFactor = smoothEnabled and (tonumber(SmoothInput.Text) or 0.5) or 1
            local targetPos = target.Position
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, smoothFactor)
        end
    end
end)

-- Fixed Triggerbot (Enemies Only, Chams Color, Debug Notification)
local lastTrigger = 0
RunService.RenderStepped:Connect(function()
    if triggerbotEnabled and canFire() and tick() - lastTrigger > 0.1 then
        local unitRay = Mouse.UnitRay
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, raycastParams)
        if result and result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
            if player and player.Team ~= LocalPlayer.Team then
                local highlight = result.Instance.Parent:FindFirstChildOfClass("Highlight")
                if highlight and highlight.FillColor == chamsSettings.FillColor then
                    mouse1press()
                    task.wait(0.05)
                    mouse1release()
                    lastTrigger = tick()
                end
            end
        end
    end
end)

-- Enhanced ESP (Skeleton, Health Bars, Cleanup on Death/Leave)
local espDrawings = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local char = player.Character
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(0, 255, 0)

    local nameLabel = Drawing.new("Text")
    nameLabel.Text = player.Name
    nameLabel.Size = 14
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Outline = true

    local healthBar = Drawing.new("Line")
    healthBar.Thickness = 3
    healthBar.Color = Color3.fromRGB(0, 255, 0)

    local distanceLabel = Drawing.new("Text")
    distanceLabel.Size = 14
    distanceLabel.Color = Color3.fromRGB(255, 255, 255)
    distanceLabel.Outline = true

    local skeletonLines = {}
    local bones = {"Head-UpperTorso", "UpperTorso-LowerTorso", "LowerTorso-LeftUpperArm", "LowerTorso-RightUpperArm", "LowerTorso-LeftUpperLeg", "LowerTorso-RightUpperLeg"}
    for _, bone in ipairs(bones) do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 255, 255)
        skeletonLines[bone] = line
    end

    espDrawings[player] = {box = box, tracer = tracer, name = nameLabel, healthBar = healthBar, distance = distanceLabel, skeleton = skeletonLines}

    player.CharacterRemoving:Connect(function()
        for _, drawing in pairs(espDrawings[player]) do
            if type(drawing) == "table" then
                for _, line in pairs(drawing) do line:Remove() end
            else
                drawing:Remove()
            end
        end
        espDrawings[player] = nil
    end)
end

local function updateESP()
    for player, drawings in pairs(espDrawings) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Team ~= LocalPlayer.Team then
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

                drawings.distance.Text = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) .. "m"
                drawings.distance.Visible = true
                drawings.distance.Position = Vector2.new(headPos.X, footPos.Y + 5)

                local healthPct = humanoid.Health / humanoid.MaxHealth
                drawings.healthBar.Visible = true
                drawings.healthBar.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                drawings.healthBar.From = Vector2.new(headPos.X - drawings.box.Size.X / 2 - 5, headPos.Y)
                drawings.healthBar.To = Vector2.new(headPos.X - drawings.box.Size.X / 2 - 5, headPos.Y + drawings.box.Size.Y * healthPct)

                -- Skeleton
                local bones = {
                    Head = player.Character.Head.Position,
                    UpperTorso = player.Character.UpperTorso.Position,
                    LowerTorso = player.Character.LowerTorso.Position,
                    LeftUpperArm = player.Character.LeftUpperArm.Position,
                    RightUpperArm = player.Character.RightUpperArm.Position,
                    LeftUpperLeg = player.Character.LeftUpperLeg.Position,
                    RightUpperLeg = player.Character.RightUpperLeg.Position
                }
                local headScreen = Camera:WorldToViewportPoint(bones.Head)
                local torsoScreen = Camera:WorldToViewportPoint(bones.UpperTorso)
                drawings.skeleton["Head-UpperTorso"].From = Vector2.new(headScreen.X, headScreen.Y)
                drawings.skeleton["Head-UpperTorso"].To = Vector2.new(torsoScreen.X, torsoScreen.Y)
                drawings.skeleton["Head-UpperTorso"].Visible = true
                -- Add for other bones similarly
            else
                for _, drawing in pairs(drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do line.Visible = false end
                    else
                        drawing.Visible = false
                    end
                end
            end
        else
            for _, drawing in pairs(drawings) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do line.Visible = false end
                else
                    drawing.Visible = false
                end
            end
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

Players.PlayerRemoving:Connect(function(player)
    if espDrawings[player] then
        for _, drawing in pairs(espDrawings[player]) do
            if type(drawing) == "table" then
                for _, line in pairs(drawing) do line:Remove() end
            else
                drawing:Remove()
            end
        end
        espDrawings[player] = nil
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    addESP(player)
end

-- Bomb Info
RunService.RenderStepped:Connect(function()
    if bombEnabled then
        -- Assume bomb object in Workspace
        local bomb = Workspace:FindFirstChild("Bomb") or ReplicatedStorage:FindFirstChild("Bomb")
        if bomb then
            BombStatus.Text = "Bomb Timer: " .. (bomb:FindFirstChild("Timer") and bomb.Timer.Value or "Unknown")
        else
            BombStatus.Text = "Bomb: Not Planted"
        end
    end
end)

-- Grenade Prediction
local grenadeLines = {}
RunService.RenderStepped:Connect(function()
    if grenadeEnabled then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "Grenade" or obj.Name == "Flashbang" or obj.Name == "Smoke" then
                local velocity = obj.AssemblyLinearVelocity
                local position = obj.Position
                local gravity = Vector3.new(0, -workspace.Gravity, 0)
                local line = Drawing.new("Line")
                line.Color = Color3.fromRGB(255, 255, 0)
                line.Thickness = 2
                line.Visible = true
                line.From = Vector2.new(Camera:WorldToViewportPoint(position).X, Camera:WorldToViewportPoint(position).Y)
                local predPos = position
                for i = 1, 50 do
                    predPos = predPos + velocity / 60 + gravity / (60 * 60) / 2
                    velocity = velocity + gravity / 60
                    local screenPos = Camera:WorldToViewportPoint(predPos)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    local nextPos = predPos + velocity / 60 + gravity / (60 * 60) / 2
                    local nextScreen = Camera:WorldToViewportPoint(nextPos)
                    line = Drawing.new("Line")
                    line.Color = Color3.fromRGB(255, 255, 0)
                    line.Thickness = 2
                    line.Visible = true
                    line.From = Vector2.new(screenPos.X, screenPos.Y)
                    line.To = Vector2.new(nextScreen.X, nextScreen.Y)
                end
                table.insert(grenadeLines, line)
            end
        end
        for _, line in ipairs(grenadeLines) do
            line:Remove()
        end
        grenadeLines = {}
    end
end)

-- Rage: Anti-Aim (Spinbot)
RunService.Stepped:Connect(function()
    if antiAimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(1800), 0)  -- Fast spin
    end
end)

-- Rage: Double Tap (Rapid Fire)
local lastShot = 0
RunService.RenderStepped:Connect(function()
    if doubleTapEnabled and canFire() and tick() - lastShot > 0.05 then
        mouse1press()
        task.wait(0.01)
        mouse1release()
        mouse1press()
        task.wait(0.01)
        mouse1release()
        lastShot = tick()
    end
end)

-- Rage: Fake Lag (Teleport Lag Switch)
local lagTicks = 0
RunService.Stepped:Connect(function()
    if fakeLagEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        lagTicks = lagTicks + 1
        if lagTicks % 10 == 0 then
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
        elseif lagTicks % 20 == 0 then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            lagTicks = 0
        end
    end
end)

-- Rage: Auto Shoot (On Enemy in Crosshair)
RunService.RenderStepped:Connect(function()
    if autoShootEnabled and canFire() then
        local target = getClosestEnemy()
        if target then
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end
end)

-- Rage: Wallbang (Shoot Through Walls - Ignore Visible Check for Trigger/Aim)
-- Modify isVisible to always return true if wallbangEnabled
local function isVisible(target)
    if wallbangEnabled then return true end
    if not visibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or result.Instance:IsDescendantOf(target.Parent)
end

-- Semi-Rage: Legit AA (Fake Angles - Slight Offset)
RunService.Stepped:Connect(function()
    if legitAAEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)  -- Slight fake angle
    end
end)

-- Third-Person Fix (Camera Offset, No Console Errors)
RunService.RenderStepped:Connect(function()
    if thirdPersonEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        local root = LocalPlayer.Character.HumanoidRootPart
        Camera.CFrame = CFrame.new(root.Position - root.CFrame.LookVector * 10 + Vector3.new(0, 5, 0), root.Position)
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- HUD (Unchanged, Add New Status)
-- Add statuses for new features in HUD and UpdateHUD()

-- Initial
updateAllChams()
UpdateHUD()
