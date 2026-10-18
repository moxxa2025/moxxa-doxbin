-- ==========================================
-- MOXXA DOXBIN V2 | ROBLOX ARSENAL FPS HUB
-- Created by: Moxxa
-- Fitur: Headshot Aimbot, ESP, Ghost, Fly
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local CONFIG = {
    ESP = false,
    Aimbot = false,
    SpeedHack = false,
    GhostMode = false,
    FlyHack = false,
    SpeedValue = 50,
    AimbotFOV = 150,        -- Radius lock (semakin gede, semakin jauh jangkauannya)
    AimbotSmoothness = 0.25, -- 0.1 = Cepat (Snap), 0.5 = Lambat (Smooth/Aman)
}

-- HAPUS GUI LAMA
if CoreGui:FindFirstChild("MoxxaDoxbin") then
    CoreGui.MoxxaDoxbin:Destroy()
end

-- UI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoxxaDoxbin"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- LOGO LU
local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(0.6, 0, 0.25, 0)
LogoImage.Position = UDim2.new(0.2, 0, 0.02, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://13240888543" -- GANTI PAKE ID LOGO LU
LogoImage.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.Position = UDim2.new(0, 0, 0.28, 0)
Title.BackgroundTransparency = 1
Title.Text = "MOXXA DOXBIN V2"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

-- SCROLLING FRAME
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
ScrollingFrame.Position = UDim2.new(0.05, 0, 0.38, 0)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

local function CreateToggle(name, func)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Text = name .. " [OFF]"
    Button.Parent = ScrollingFrame

    Button.MouseButton1Click:Connect(function()
        if Button.Text:find("OFF") then
            Button.Text = name .. " [ON]"
            Button.TextColor3 = Color3.fromRGB(0, 255, 0)
            func(true)
        else
            Button.Text = name .. " [OFF]"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            func(false)
        end
    end)
end

-- ==========================================
-- FITUR: ESP & HIGHLIGHT
-- ==========================================
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("MoxxaESP")
            if CONFIG.ESP then
                if not highlight then
                    local hl = Instance.new("Highlight")
                    hl.Name = "MoxxaESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = char
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end
CreateToggle("ESP / Wallhack", function(state)
    CONFIG.ESP = state
    UpdateESP()
end)

-- ==========================================
-- FITUR: AIMBOT HEADSHOT LOCK
-- ==========================================
local function GetClosestHead()
    local closestHead = nil
    local shortestDist = CONFIG.AimbotFOV
    local camera = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    -- Hitung jarak mouse ke kepala musuh
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestHead = head
                    end
                end
            end
        end
    end
    return closestHead
end

local aimbotConnection
CreateToggle("Aimbot (Head Lock)", function(state)
    CONFIG.Aimbot = state
    if state then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if CONFIG.Aimbot then
                local targetHead = GetClosestHead()
                if targetHead then
                    -- Smooth Lock ke Kepala
                    local currentCFrame = workspace.CurrentCamera.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, targetHead.Position)
                    workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, CONFIG.AimbotSmoothness)
                end
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() end
    end
end)

-- ==========================================
-- FITUR: SPEED & GHOST & FLY
-- ==========================================
CreateToggle("Speed Hack", function(state)
    CONFIG.SpeedHack = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and CONFIG.SpeedValue or 16
    end
end)

CreateToggle("Ghost Mode", function(state)
    CONFIG.GhostMode = state
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = state and 0.7 or 0
                v.CanCollide = not state
            end
        end
    end
end)

local flyConnection
CreateToggle("Fly Hack", function(state)
    CONFIG.FlyHack = state
    if state then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "MoxxaFly"
            bodyVelocity.MaxForce = Vector3.new(1,1,1) * math.huge
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = char.HumanoidRootPart
            
            flyConnection = RunService.RenderStepped:Connect(function()
                local moveDir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
                bodyVelocity.Velocity = moveDir * 50
            end)
        end
    else
        if flyConnection then flyConnection:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local fly = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
            if fly then fly:Destroy() end
        end
    end
end)

-- CLOSE BTN
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("MOXXA DOXBIN V2 Loaded. Bypass Virtualization Active (Simulated).")
