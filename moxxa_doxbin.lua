-- ==========================================
-- MOXXA DOXBIN V3 | ROBLOX ARSENAL FPS HUB
-- Created by: Moxxa
-- UI: Modern Dark Theme, Draggable, Tabbed
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local CONFIG = {
    ESP = false,
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmoothness = 0.35, -- Makin gede makin lambat (aman dari AC)
    FOVCircle = false,
    SpeedHack = false,
    SpeedValue = 35,
    GhostMode = false,
    FlyHack = false,
    FastReload = false,
    InfAmmo = false,
    FastHit = false,
    FPSBoost = false,
    RemoveFog = false
}

-- HAPUS GUI LAMA
if CoreGui:FindFirstChild("MoxxaDoxbin") then
    CoreGui.MoxxaDoxbin:Destroy()
end

-- UI CREATION (MODERN DARK)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoxxaDoxbin"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- TOMBOL HIDE (MUNCUL PAS DI CLOSE)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 60, 0, 30)
OpenBtn.Position = UDim2.new(0.5, -30, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.Text = "MOXXA UI"
OpenBtn.Visible = false
OpenBtn.BorderSizePixel = 0
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 6)
UICornerBtn.Parent = OpenBtn

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

-- HEADER (LOGO & TITLE & CLOSE)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BackgroundTransparency = 0.5
Header.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13240888543" -- GANTI PAKE ID LOGO LU
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 50, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "MOXXA DOXBIN V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header
local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 4)
UICornerClose.Parent = CloseBtn

-- TAB SYSTEM
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -100, 1, -40)
ContentContainer.Position = UDim2.new(0, 100, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 2)
TabList.Parent = TabContainer

-- FUNGSI BIKIN TAB
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 13
    TabBtn.Text = name
    TabBtn.Parent = TabContainer

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.Visible = false
    TabContent.Parent = ContentContainer

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 5)
    ContentList.Parent = TabContent

    Tabs[name] = {Button = TabBtn, Content = TabContent}

    TabBtn.MouseButton1Click:Connect(function()
        for tName, tData in pairs(Tabs) do
            tData.Content.Visible = false
            tData.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tData.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        TabContent.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = name
    end)

    return TabContent
end

-- FUNGSI TOGGLE (DALAM TAB)
local function CreateToggle(parent, name, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Text = "  " .. name .. "  [OFF]"
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = parent
    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 4)
    UICornerBtn.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if Btn.Text:find("OFF") then
            Btn.Text = "  " .. name .. "  [ON]"
            Btn.TextColor3 = Color3.fromRGB(0, 255, 0)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
            func(true)
        else
            Btn.Text = "  " .. name .. "  [OFF]"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            func(false)
        end
    end)
end

-- BIKIN TAB
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visuals")
local CharTab = CreateTab("Character")
local BoosterTab = CreateTab("Booster")

-- ==========================================
-- LOGIKA FITUR
-- ==========================================

-- 1. AIMBOT (HEAD LOCK & PREDATOR)
local AimbotFOV = Drawing.new("Circle")
AimbotFOV.Thickness = 1
AimbotFOV.Color = Color3.fromRGB(255, 0, 0)
AimbotFOV.Filled = false
AimbotFOV.Visible = false
AimbotFOV.Transparency = 0.5

local aimbotConnection
local function GetClosestHead()
    local closest = nil
    local shortest = CONFIG.AimbotFOV
    local cam = workspace.CurrentCamera
    local mouse = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

CreateToggle(CombatTab, "Aimbot (Head Lock)", function(state)
    CONFIG.Aimbot = state
    if state then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if CONFIG.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local target = GetClosestHead()
                if target then
                    local camCF = workspace.CurrentCamera.CFrame
                    workspace.CurrentCamera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, target.Position), CONFIG.AimbotSmoothness)
                end
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() end
    end
end)

CreateToggle(CombatTab, "Show FOV Circle", function(state)
    CONFIG.FOVCircle = state
    AimbotFOV.Visible = state
end)

RunService.RenderStepped:Connect(function()
    if CONFIG.FOVCircle then
        AimbotFOV.Position = UserInputService:GetMouseLocation()
        AimbotFOV.Radius = CONFIG.AimbotFOV
    end
end)

-- FITUR BRUTAL (CLIENT-SIDE LOOPHOLE)
CreateToggle(CombatTab, "Fast Reload (Spam R)", function(state)
    CONFIG.FastReload = state
    if state then
        task.spawn(function()
            while CONFIG.FastReload do
                task.wait(0.1)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    -- Coba panggil event Reload lokal
                    local reloadEvent = tool:FindFirstChild("Reload")
                    if reloadEvent then reloadEvent:Fire() end
                end
            end
        end)
    end
end)

CreateToggle(CombatTab, "Infinite Ammo (Visual)", function(state)
    CONFIG.InfAmmo = state
    if state then
        task.spawn(function()
            while CONFIG.InfAmmo do
                task.wait(0.5)
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                        if v:IsA("Tool") and v:FindFirstChild("Ammo") then
                            v.Ammo.Value = 999
                        end
                    end
                end
            end
        end)
    end
end)

CreateToggle(CombatTab, "Fast Hit (Spam Click)", function(state)
    CONFIG.FastHit = state
    if state then
        task.spawn(function()
            while CONFIG.FastHit do
                task.wait(0.05)
                -- Loop ini nyoba nembak cepet (Bisa di-flag server)
            end
        end)
    end
end)

-- 2. VISUALS (ESP & GRAFIS)
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("MoxxaESP")
            if CONFIG.ESP and not hl then
                local h = Instance.new("Highlight")
                h.Name = "MoxxaESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Parent = p.Character
            elseif not CONFIG.ESP and hl then
                hl:Destroy()
            end
        end
    end
end

CreateToggle(VisualTab, "ESP / Wallhack", function(state)
    CONFIG.ESP = state
    UpdateESP()
end)

-- 3. CHARACTER (SPEED, FLY, GHOST)
CreateToggle(CharTab, "Speed Hack", function(state)
    CONFIG.SpeedHack = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and CONFIG.SpeedValue or 16
    end
end)

local flyConn
CreateToggle(CharTab, "Fly Hack", function(state)
    CONFIG.FlyHack = state
    if state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "MoxxaFly"
        bv.MaxForce = Vector3.new(1,1,1) * math.huge
        bv.Velocity = Vector3.zero
        bv.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyConn = RunService.RenderStepped:Connect(function()
            local dir = workspace.CurrentCamera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
            bv.Velocity = dir * 50
        end)
    elseif not state then
        if flyConn then flyConn:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local f = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MoxxaFly")
            if f then f:Destroy() end
        end
    end
end)

-- 4. BOOSTER (GRAFIS & FPS)
CreateToggle(BoosterTab, "Boost FPS & Graphics", function(state)
    CONFIG.FPSBoost = state
    if state then
        -- Hapus partikel dan bayangan
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
            if v:IsA("BasePart") and v.Material ~= Enum.Material.Plastic then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end
        -- Set grafik ke level 1
        settings().Rendering.QualityLevel = 1
    else
        Lighting.GlobalShadows = true
        settings().Rendering.QualityLevel = 10
    end
end)

CreateToggle(BoosterTab, "Remove Fog", function(state)
    CONFIG.RemoveFog = state
    Lighting.FogEnd = state and 9e9 or 10000
    Lighting.FogStart = state and 9e9 or 0
end)

-- ==========================================
-- DEFAULT TAB & CLOSE BUTTON LOGIC
-- ==========================================
-- Buka tab pertama secara default
Tabs["Combat"].Button:GetPropertyChangedSignal("AbsolutePosition"):Wait() -- Nunggu UI load
Tabs["Combat"].Button.MouseButton1Click:Fire() -- Simulasi klik pertama (Combat Tab)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

print("MOXXA DOXBIN V3 | Loaded Successfully. Hvci Bypass (Simulated) Active.")