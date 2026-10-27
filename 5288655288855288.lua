--[[
    ╔══════════════════════════════════════════════════════════════════════╗
    ║           KEI SELVIM — MINI SAFE ZONE UI v24.0                       ║
    ║           Anti Nutupin Layar • Safe Zone Baru • Anti Bug             ║
    ╚══════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- =========================================================================
-- ⚙️ KONFIGURASI KOORDINAT
-- =========================================================================
local COORDS = {
    -- Koordinat Safe Zone Baru
    SafeZone = Vector3.new(6.34, 4.48, 83.33),
    
    -- Zona Farm (Bebas diubah/ditambah)
    FarmZones = {
        { name = "Zona 1", pos = Vector3.new(708.38, 71.53, -334.12) },
        { name = "Zona 2", pos = Vector3.new(858.88, 71.53, -410.04) },
        { name = "Zona 3", pos = Vector3.new(1039.63, 71.53, -347.66) },
        { name = "Zona 4", pos = Vector3.new(1294.86, 71.53, -408.31) },
        { name = "Zona 5", pos = Vector3.new(1608.88, 71.53, -352.23) },
        { name = "Zona 6", pos = Vector3.new(1997.18, 71.53, -380.27) },
        { name = "Zona 7", pos = Vector3.new(2398.09, 71.53, -370.36) },
        { name = "Zona 8", pos = Vector3.new(2833.26, 71.53, -382.73) },
        { name = "Zona 9", pos = Vector3.new(3504.75, 71.53, -400.05) },
    }
}

local CONFIG = {
    GoodKeywords = {"secret", "eternal", "divine", "mythic", "legendary"},
    StealDelay = 0.4
}

local State = {
    AutoSteal = false,
    AutoFarmZone = false,
    IsProcessing = false,
    ActiveEggs = {},
    SelectedZone = 1,
    IsHoldingEgg = false
}

-- =========================================================================
-- HELPER UI
-- =========================================================================
local C = {
    BG = Color3.fromRGB(20, 20, 24), PANEL = Color3.fromRGB(28, 28, 34), BOX = Color3.fromRGB(18, 18, 20),
    TEXT = Color3.fromRGB(240, 240, 240), DIM = Color3.fromRGB(150, 150, 160),
    GREEN = Color3.fromRGB(100, 220, 150), RED = Color3.fromRGB(240, 80, 80), BORDER = Color3.fromRGB(50, 50, 60),
    ACCENT = Color3.fromRGB(150, 80, 240)
}

local function create(cls, props)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end
local function addCorner(parent, r) return create("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = parent }) end
local function addStroke(parent, col) return create("UIStroke", { Color = col or C.BORDER, Thickness = 1, Parent = parent }) end

-- =========================================================================
-- 🧠 FUNGSI DETEKSI
-- =========================================================================
local function isBestEgg(obj)
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
    local lowerName = string.lower(obj.Name)
    for _, k in ipairs(CONFIG.GoodKeywords) do if string.find(lowerName, k) then return true end end
    
    local rarity = obj:GetAttribute("Rarity") or obj:GetAttribute("RarityName")
    if rarity then
        local lowerRarity = string.lower(tostring(rarity))
        for _, k in ipairs(CONFIG.GoodKeywords) do if string.find(lowerRarity, k) then return true end end
    end
    
    if obj:FindFirstChildOfClass("PointLight") or obj:FindFirstChildOfClass("Highlight") then return true end
    for _, v in ipairs(obj:GetChildren()) do
        if v:IsA("ParticleEmitter") or v:IsA("PointLight") then return true end
    end
    return false
end

-- =========================================================================
-- 🏃‍♂️ FUNGSI EKSEKUSI
-- =========================================================================
local function processEgg(egg)
    if State.IsProcessing then return end
    State.IsProcessing = true
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then State.IsProcessing = false return end
    local hrp = char.HumanoidRootPart
    local oldPos = hrp.CFrame
    
    print("[🔥 BEST EGG] Ditemukan: " .. egg.Name)
    
    -- 1. Teleport ke telur
    hrp.CFrame = CFrame.new(egg.Position + Vector3.new(0, 2, 0))
    task.wait(0.2)
    
    -- 2. Ambil
    local prompt = egg:FindFirstChildOfClass("ProximityPrompt") or egg:FindFirstChild("ProximityPrompt", true)
    if prompt then
        pcall(function() fireproximityprompt(prompt) end)
    else
        pcall(function()
            firetouchinterest(hrp, egg, 0)
            task.wait(0.1)
            firetouchinterest(hrp, egg, 1)
        end)
    end
    task.wait(0.2)
    
    -- 3. Klaim di Safe Zone Baru
    hrp.CFrame = CFrame.new(COORDS.SafeZone)
    print("[🛡️] Klaim di Safe Zone Baru.")
    task.wait(0.8)
    
    -- 4. Balik ke posisi
    if State.AutoFarmZone then
        local targetZone = COORDS.FarmZones[State.SelectedZone]
        if targetZone then hrp.CFrame = CFrame.new(targetZone.pos) else hrp.CFrame = oldPos end
    else
        hrp.CFrame = oldPos
    end
    
    task.wait(0.3)
    State.IsProcessing = false
end

local function startAutoSteal()
    task.spawn(function()
        while State.AutoSteal do
            if not State.IsProcessing then
                local bestEgg = nil
                local closestDist = 5000
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local myPos = char.HumanoidRootPart.Position
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if isBestEgg(obj) then
                            local dist = (obj.Position - myPos).Magnitude
                            if dist < closestDist then bestEgg = obj; closestDist = dist end
                        end
                    end
                end
                if bestEgg then processEgg(bestEgg) end
            end
            task.wait(CONFIG.StealDelay)
        end
    end)
end

-- =========================================================================
-- 🎨 BUILD GUI (MINI & ANTI NUTUPIN LAYAR)
-- =========================================================================
local function buildUI()
    local gui = create("ScreenGui", { Name = "MiniUI", ResetOnSpawn = false, Parent = CoreGui })
    
    -- UI Kecil (Lebar 320, Tinggi 130) posisi di kiri bawah
    local main = create("Frame", { Size = UDim2.new(0, 320, 0, 130), Position = UDim2.new(0, 20, 1, -150), BackgroundColor3 = C.BG, BorderSizePixel = 0, Parent = gui })
    addCorner(main, 8); addStroke(main, C.BORDER)

    -- Header
    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    addCorner(header, 8)
    create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "KEI SELVIM — MINI", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -22, 0, 3), BackgroundColor3 = C.RED, Text = "✕", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = header })
    addCorner(closeBtn, 4)
    
    local floatBtn = create("TextButton", { Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0, 20, 1, -60), BackgroundColor3 = C.ACCENT, Text = "K", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0, Visible = false, Parent = gui })
    addCorner(floatBtn, 17)

    closeBtn.MouseButton1Click:Connect(function() main.Visible = false; floatBtn.Visible = true end)
    floatBtn.MouseButton1Click:Connect(function() main.Visible = true; floatBtn.Visible = false end)

    -- ═══════════ ISI UI (KIRI: TOGGLE, KANAN: TELEPORT) ═══════════
    
    -- Kiri: Auto Steal & Farm
    local btnSteal = create("TextButton", { Size = UDim2.new(0, 140, 0, 24), Position = UDim2.new(0, 10, 0, 35), BackgroundColor3 = C.BOX, Text = "Auto Steal: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = main })
    addCorner(btnSteal, 4); addStroke(btnSteal, C.BORDER)
    btnSteal.MouseButton1Click:Connect(function()
        State.AutoSteal = not State.AutoSteal
        btnSteal.Text = "Auto Steal: " .. (State.AutoSteal and "ON" or "OFF")
        btnSteal.BackgroundColor3 = State.AutoSteal and C.GREEN or C.BOX
        if State.AutoSteal then startAutoSteal() end
    end)

    local btnFarm = create("TextButton", { Size = UDim2.new(0, 140, 0, 24), Position = UDim2.new(0, 10, 0, 65), BackgroundColor3 = C.BOX, Text = "Auto Farm: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = main })
    addCorner(btnFarm, 4); addStroke(btnFarm, C.BORDER)
    btnFarm.MouseButton1Click:Connect(function()
        State.AutoFarmZone = not State.AutoFarmZone
        btnFarm.Text = "Auto Farm: " .. (State.AutoFarmZone and "ON" or "OFF")
        btnFarm.BackgroundColor3 = State.AutoFarmZone and C.GREEN or C.BOX
    end)

    -- Kanan: Tombol Teleport Safe Zone (Baru)
    local btnSafe = create("TextButton", { Size = UDim2.new(0, 150, 0, 54), Position = UDim2.new(0, 160, 0, 35), BackgroundColor3 = C.RED, Text = "🛡️ Teleport\nSafe Zone", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 11, BorderSizePixel = 0, Parent = main })
    addCorner(btnSafe, 6); addStroke(btnSafe, C.RED)
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then 
            char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone) 
        end
    end)

    -- Footer (Zona Selector Mini)
    local zonaContainer = create("Frame", { Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 100), BackgroundTransparency = 1, Parent = main })
    create("UIGridLayout", { CellSize = UDim2.new(0, 30, 0, 18), CellPadding = UDim2.new(0, 3, 0, 0), Parent = zonaContainer })
    for i = 1, 9 do
        local zBtn = create("TextButton", { BackgroundColor3 = (i == 1) and C.ACCENT or C.BOX, Text = tostring(i), TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = zonaContainer })
        addCorner(zBtn, 3)
        zBtn.MouseButton1Click:Connect(function()
            State.SelectedZone = i
            for _, child in ipairs(zonaContainer:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3 = C.BOX end end
            zBtn.BackgroundColor3 = C.ACCENT
        end)
    end

    -- Drag Logic
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- =========================================================================
-- 🔥 AUTO SAFE ZONE KALAU PEGANG TELUR
-- =========================================================================
task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char then
            local isHolding = false
            for _, obj in ipairs(char:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) then
                    local n = string.lower(obj.Name)
                    if string.find(n, "egg") or string.find(n, "telur") then
                        isHolding = true
                        break
                    end
                end
            end
            
            if isHolding and not State.IsHoldingEgg then
                State.IsHoldingEgg = true
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(COORDS.SafeZone)
                    task.wait(1)
                    State.IsHoldingEgg = false
                end
            elseif not isHolding then
                State.IsHoldingEgg = false
            end
        end
    end
end)

-- =========================================================================
-- EVENT LISTENER
-- =========================================================================
Workspace.DescendantAdded:Connect(function(obj)
    if State.IsProcessing or not State.AutoSteal then return end
    if isBestEgg(obj) then
        if not State.ActiveEggs[obj] then
            State.ActiveEggs[obj] = true
            task.spawn(function()
                processEgg(obj)
                State.ActiveEggs[obj] = nil
            end)
        end
    end
end)

task.wait(1)
local success, err = pcall(buildUI)
if not success then warn("[UI Error] " .. tostring(err)) end
