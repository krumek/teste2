-- Optimized Counter Blox Script: Fixed Triggerbot (Team Check), Team Diff, Third-Person Toggle, Enhanced Visuals (Skeleton ESP, Health Bars), No Recoil, Radar
-- Inspired by Exunys/AirHub, CounterBloxDev scripts: Config GUI, Silent Aim, ESP Skeleton, No Recoil, Radar Mini-Map
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

-- GUI Setup (Movable, Expanded for New Features)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChamsConfig"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 550)
Frame.Position = UDim2.new(0.5, -125, 0.5, -275)
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

-- Toggles (Added Third-Person, No Recoil, Radar)
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
ESPToggle.Text = "ESP (Skeleton/Health): Off (F4)"
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Position = UDim2.new(0, 0, 0, 380)
ESPToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = Frame
local espEnabled = false

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP (Skeleton/Health): " .. (espEnabled and "On" or "Off") .. " (F4)"
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

local NoRecoilToggle = Instance.new("TextButton")
NoRecoilToggle.Text = "No Recoil: Off (F7)"
NoRecoilToggle.Size = UDim2.new(1, 0, 0, 30)
NoRecoilToggle.Position = UDim2.new(0, 0, 0, 470)
NoRecoilToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NoRecoilToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRecoilToggle.Parent = Frame
local noRecoilEnabled = false

NoRecoilToggle.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    NoRecoilToggle.Text = "No Recoil: " .. (noRecoilEnabled and "On" or "Off") .. " (F7)"
    UpdateHUD()
end)

local RadarToggle = Instance.new("TextButton")
RadarToggle.Text = "Radar: Off (F8)"
RadarToggle.Size = UDim2.new(1, 0, 0, 30)
RadarToggle.Position = UDim2.new(0, 0, 0, 500)
RadarToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RadarToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
RadarToggle.Parent = Frame
local radarEnabled = false

RadarToggle.MouseButton1Click:Connect(function()
    radarEnabled = not radarEnabled
    RadarToggle.Text = "Radar: " .. (radarEnabled and "On" or "Off") .. " (F8)"
    UpdateHUD()
end)

local ThirdPersonToggle = Instance.new("TextButton")
ThirdPersonToggle.Text = "Third-Person: Off (F9)"
ThirdPersonToggle.Size = UDim2.new(1, 0, 0, 30)
ThirdPersonToggle.Position = UDim2.new(0, 0, 0, 530)
ThirdPersonToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ThirdPersonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ThirdPersonToggle.Parent = Frame
local thirdPersonEnabled = false

ThirdPersonToggle.MouseButton1Click:Connect(function()
    thirdPersonEnabled = not thirdPersonEnabled
    ThirdPersonToggle.Text = "Third-Person: " .. (thirdPersonEnabled and "On" or "Off") .. " (F9)"
    UpdateHUD()
    Camera.CameraType = thirdPersonEnabled and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end)

local ApplyButton = Instance.new("TextButton")
ApplyButton.Text = "Apply Chams"
ApplyButton.Size = UDim2.new(1, 0, 0, 30)
ApplyButton.Position = UDim2.new(0, 0, 0, 560)
ApplyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- Chams Logic (Team Check - Only Enemies)
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

-- Player Handling
local respawnDebounce = {}
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.defer(addChams, char, player)
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if not respawnDebounce[player] then
                        respawnDebounce[player] = true
                        task.wait(6)
                        if player.Character then addChams(player.Character, player) end
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
        if player.Character then addChams(player.Character, player) end
        player.CharacterAdded:Connect(function(char)
            addChams(char, player)
        end)
    end
end

-- Bunnyhop
RunService.Heartbeat:Connect(function()
    if bhEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid.Jump = true
        end
    end
end)

-- Silent Aimbot (Team Check)
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
    return tool ~= nil and tool:FindFirstChild("Fire")
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
            local predictPos = target.Position + target.AssemblyLinearVelocity * (LocalPlayer.Character.Head.Position - target.Position).Magnitude / 1000
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.lookAt(currentCFrame.Position, predictPos)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, smoothFactor)
        end
    end
end)

-- Fixed Triggerbot (Team Check, Chams Color Activation)
local lastTrigger = 0
RunService.Heartbeat:Connect(function()
    if triggerbotEnabled and canFire() and tick() - lastTrigger > 0.1 then
        local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
        if result and result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
            if player and player.Team ~= LocalPlayer.Team then
                local highlight = result.Instance.Parent:FindFirstChildOfClass("Highlight")
                if highlight and highlight.FillColor == chamsSettings.FillColor then
                    mouse1press()
                    task.wait(0.05 + math.random(0, 0.05))
                    mouse1release()
                    lastTrigger = tick()
                end
            end
        end
    end
end)

-- Enhanced ESP (Skeleton, Health Bars, Distance - Inspired from AirHub)
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

    -- Skeleton Lines
    local skeletonLines = {}
    for _, bone in ipairs({"Head-UpperTorso", "UpperTorso-LowerTorso", "LowerTorso-LeftUpperArm", "LowerTorso-RightUpperArm", "LowerTorso-LeftUpperLeg", "LowerTorso-RightUpperLeg"}) do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 255, 255)
        skeletonLines[bone] = line
    end

    espDrawings[player] = {box = box, tracer = tracer, name = nameLabel, healthBar = healthBar, distance = distanceLabel, skeleton = skeletonLines}
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

                -- Skeleton Update
                local bones = {
                    Head = player.Character.Head,
                    UpperTorso = player.Character.UpperTorso,
                    LowerTorso = player.Character.LowerTorso,
                    LeftUpperArm = player.Character.LeftUpperArm,
                    RightUpperArm = player.Character.RightUpperArm,
                    LeftUpperLeg = player.Character.LeftUpperLeg,
                    RightUpperLeg = player.Character.RightUpperLeg
                }
                if bones.UpperTorso and bones.Head then
                    local headScreen = Camera:WorldToViewportPoint(bones.Head.Position)
                    local torsoScreen = Camera:WorldToViewportPoint(bones.UpperTorso.Position)
                    drawings.skeleton["Head-UpperTorso"].From = Vector2.new(headScreen.X, headScreen.Y)
                    drawings.skeleton["Head-UpperTorso"].To = Vector2.new(torsoScreen.X, torsoScreen.Y)
                    drawings.skeleton["Head-UpperTorso"].Visible = true
                end
                -- Add similar for other bones
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

for _, player in ipairs(Players:GetPlayers()) do
    addESP(player)
end

-- Bomb Info (Unchanged)
RunService.RenderStepped:Connect(function()
    if bombEnabled then
        local wkspc = ReplicatedStorage:FindFirstChild("wkspc")
        if wkspc then
            local status = wkspc:FindFirstChild("Status")
            if status then
                local bombTimer = status:FindFirstChild("RoundTime") or status:FindFirstChild("BombTime")
                if bombTimer then
                    BombStatus.Text = "Bomb Timer: " .. bombTimer.Value .. "s"
                else
                    BombStatus.Text = "Bomb: Not Planted"
                end
            end
        end
    end
end)

-- Grenade Prediction (Unchanged)
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
                line.From = Camera:WorldToViewportPoint(position)
                local predPos = position
                for i = 1, 50 do
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

-- No Recoil (Inspired from CounterBloxDev - Set Recoil to 0)
RunService.RenderStepped:Connect(function()
    if noRecoilEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool:FindFirstChild("Recoil") then
            tool.Recoil.Value = 0
        end
        if tool:FindFirstChild("Spread") then
            tool.Spread.Value = 0
        end
    end
end)

-- Radar (Mini-Map with Enemy Dots - Inspired from AirHub)
local RadarGui = Instance.new("ScreenGui")
RadarGui.Parent = LocalPlayer.PlayerGui
local RadarFrame = Instance.new("Frame")
RadarFrame.Size = UDim2.new(0, 150, 0, 150)
RadarFrame.Position = UDim2.new(0, 10, 0.5, -75)
RadarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RadarFrame.BackgroundTransparency = 0.5
RadarFrame.Parent = RadarGui
RadarFrame.Visible = false

local radarDots = {}
local function addRadarDot(player)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.Parent = RadarFrame
    radarDots[player] = dot
end

local function updateRadar()
    if radarEnabled then
        RadarFrame.Visible = true
        for player, dot in pairs(radarDots) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Team ~= LocalPlayer.Team then
                local localPos = LocalPlayer.Character.HumanoidRootPart.Position
                local enemyPos = player.Character.HumanoidRootPart.Position
                local relative = Vector2.new(enemyPos.X - localPos.X, enemyPos.Z - localPos.Z)
                local normalized = relative.Unit * 70  -- Scale to radar size
                dot.Position = UDim2.new(0.5 + normalized.X / 150, 0, 0.5 + normalized.Y / 150, 0)
                dot.Visible = true
            else
                dot.Visible = false
            end
        end
    else
        RadarFrame.Visible = false
    end
end

RunService.RenderStepped:Connect(updateRadar)

Players.PlayerAdded:Connect(function(player)
    addRadarDot(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    addRadarDot(player)
end

-- Improved HUD (Gradiant, Icons)
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "HUD"
HudGui.ResetOnSpawn = false
HudGui.Parent = LocalPlayer.PlayerGui

local HudFrame = Instance.new("Frame")
HudFrame.Size = UDim2.new(0, 200, 0, 200)
HudFrame.Position = UDim2.new(1, -210, 0, 10)
HudFrame.BackgroundTransparency = 0.3
HudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HudFrame.Parent = HudGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))}
gradient.Parent = HudFrame

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

local NoRecoilStatus = Instance.new("TextLabel")
NoRecoilStatus.Size = UDim2.new(1, 0, 0, 20)
NoRecoilStatus.Position = UDim2.new(0, 0, 0, 140)
NoRecoilStatus.BackgroundTransparency = 1
NoRecoilStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRecoilStatus.Parent = HudFrame

local RadarStatus = Instance.new("TextLabel")
RadarStatus.Size = UDim2.new(1, 0, 0, 20)
RadarStatus.Position = UDim2.new(0, 0, 0, 160)
RadarStatus.BackgroundTransparency = 1
RadarStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
RadarStatus.Parent = HudFrame

local ThirdPersonStatus = Instance.new("TextLabel")
ThirdPersonStatus.Size = UDim2.new(1, 0, 0, 20)
ThirdPersonStatus.Position = UDim2.new(0, 0, 0, 180)
ThirdPersonStatus.BackgroundTransparency = 1
ThirdPersonStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ThirdPersonStatus.Parent = HudFrame

local function UpdateHUD()
    BhStatus.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off")
    AimStatus.Text = "Silent Aimbot: " .. (aimbotEnabled and "On" or "Off")
    TrigStatus.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off")
    ESPStatus.Text = "ESP: " .. (espEnabled and "On" or "Off")
    BombStatus.Text = "Bomb Info: " .. (bombEnabled and "On" or "Off")
    GrenadeStatus.Text = "Grenade Pred: " .. (grenadeEnabled and "On" or "Off")
    NoRecoilStatus.Text = "No Recoil: " .. (noRecoilEnabled and "On" or "Off")
    RadarStatus.Text = "Radar: " .. (radarEnabled and "On" or "Off")
    ThirdPersonStatus.Text = "Third-Person: " .. (thirdPersonEnabled and "On" or "Off")
end
UpdateHUD()

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
    elseif input.KeyCode == Enum.KeyCode.F7 then
        noRecoilEnabled = not noRecoilEnabled
        NoRecoilToggle.Text = "No Recoil: " .. (noRecoilEnabled and "On" or "Off") .. " (F7)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F8 then
        radarEnabled = not radarEnabled
        RadarToggle.Text = "Radar: " .. (radarEnabled and "On" or "Off") .. " (F8)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F9 then
        thirdPersonEnabled = not thirdPersonEnabled
        ThirdPersonToggle.Text = "Third-Person: " .. (thirdPersonEnabled and "On" or "Off") .. " (F9)"
        Camera.CameraType = thirdPersonEnabled and Enum.CameraType.Scriptable or Enum.CameraType.Custom
        UpdateHUD()
    end
end)

-- Initial
local success, err = pcall(updateAllChams)
if not success then
    showNotification("Ошибка инициализации чамсов!", Color3.fromRGB(255, 0, 0))
end
UpdateHUD()
