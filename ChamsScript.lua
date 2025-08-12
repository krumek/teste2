-- Optimized Chams, GUI, Binds, Aimbot, Triggerbot, HUD for Xeno v1.2.50U with Injection Notification
-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Notify successful injection
pcall(function()
    showNotification("Скрипт успешно загружен!", Color3.fromRGB(0, 255, 0))
end)

-- GUI (Movable, Hidden start)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChamsConfig"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 400)
Frame.Position = UDim2.new(0.5, -100, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Text = "Chams Config"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

-- Inputs (Chams)
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

-- Toggles
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
AimbotToggle.Text = "Aimbot: Off (F2)"
AimbotToggle.Size = UDim2.new(1, 0, 0, 30)
AimbotToggle.Position = UDim2.new(0, 0, 0, 220)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Parent = Frame
local aimbotEnabled = false

AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "On" or "Off") .. " (F2)"
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

local ApplyButton = Instance.new("TextButton")
ApplyButton.Text = "Apply Chams"
ApplyButton.Size = UDim2.new(1, 0, 0, 30)
ApplyButton.Position = UDim2.new(0, 0, 0, 380)
ApplyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- HUD
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "HUD"
HudGui.ResetOnSpawn = false
HudGui.Parent = LocalPlayer.PlayerGui

local HudFrame = Instance.new("Frame")
HudFrame.Size = UDim2.new(0, 150, 0, 100)
HudFrame.Position = UDim2.new(1, -160, 0, 10)
HudFrame.BackgroundTransparency = 0.5
HudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HudFrame.Parent = HudGui

local HudTitle = Instance.new("TextLabel")
HudTitle.Text = "HUD"
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

local function UpdateHUD()
    BhStatus.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off")
    AimStatus.Text = "Aimbot: " .. (aimbotEnabled and "On" or "Off")
    TrigStatus.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off")
end
UpdateHUD()

-- Chams Logic
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
    local success, err = pcall(function()
        chamsSettings.FillColor = parseColor(FillColorInput.Text)
        chamsSettings.OutlineColor = parseColor(OutlineColorInput.Text)
        chamsSettings.FillTransparency = parseTransparency(FillTransInput.Text)
        chamsSettings.OutlineTransparency = parseTransparency(OutlineTransInput.Text)
        updateAllChams()
    end)
    if not success then
        showNotification("Ошибка применения настроек!", Color3.fromRGB(255, 0, 0))
    end
end)

-- Player Handling
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

-- Bunnyhop
RunService.Heartbeat:Connect(function()
    if bhEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid.Jump = true
        end
    end
end)

-- Aimbot Logic
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
    return tool ~= nil
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 then
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
        local success, err = pcall(function()
            local target = getClosestEnemy()
            if target then
                local smoothFactor = smoothEnabled and (tonumber(SmoothInput.Text) or 0.5) + math.random(-0.1, 0.1) or 1
                local targetPos = target.Position + target.Velocity * 0.1
                local currentCFrame = Camera.CFrame
                local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
                Camera.CFrame = currentCFrame:Lerp(newCFrame, smoothFactor)
            end
        end)
        if not success then
            showNotification("Ошибка в аимботе!", Color3.fromRGB(255, 0, 0))
        end
    end
end)

-- Triggerbot
local lastTrigger = 0
RunService.Heartbeat:Connect(function()
    if triggerbotEnabled and canFire() and tick() - lastTrigger > 0.1 then
        local success, err = pcall(function()
            local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
            if result and result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") and result.Instance.Parent:FindFirstChildOfClass("Highlight") then
                mouse1press()
                task.wait(0.05 + math.random(0, 0.05))
                mouse1release()
                lastTrigger = tick()
            end
        end)
        if not success then
            showNotification("Ошибка в триггерботе!", Color3.fromRGB(255, 0, 0))
        end
    end
end)

-- Keybinds
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
        AimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "On" or "Off") .. " (F2)"
        UpdateHUD()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        triggerbotEnabled = not triggerbotEnabled
        TriggerbotToggle.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off") .. " (F3)"
        UpdateHUD()
    end
end)

-- Initial
local success, err = pcall(updateAllChams)
if not success then
    showNotification("Ошибка инициализации чамсов!", Color3.fromRGB(255, 0, 0))
end
UpdateHUD()
