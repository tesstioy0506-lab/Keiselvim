--[[
    ╔══════════════════════════════════════════════════════════════════════╗
    ║           KEI SELVIM — FORCED LANDSCAPE UI v22.0                     ║
    ║           Auto Safe Zone on Hold • Minimize to Floating Button       ║
    ╚══════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- =========================================================================
-- ⚙️ KONFIGURASI KOORDINAT
-- =========================================================================
local COORDS = {
    SafeZone = Vector3.new(638.21, 71.67, -385.08),
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
    LastPos = Vector3.zero,
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
    hrp.CFrame = CFrame.new(egg.Position + Vector3.new(0, 2, 0))
    task.wait(0.2)
    
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
    task.wait(0.1)
    
    hrp.CFrame = CFrame.new(COORDS.SafeZone)
    task.wait(0.8)
    
    if State.AutoFarmZone then
        local targetZone = COORDS.FarmZones[State.SelectedZone]
        if targetZone then hrp.CFrame = CFrame.new(targetZone.pos) else hrp.CFrame = oldPos end
    else
        hrp.CFrame = oldPos
    end
    State.IsProcessing = false
end

local function startAutoSteal()
    task.spawn(function()
        while State.AutoSteal do
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
            task.wait(CONFIG.StealDelay)
        end
    end)
end

-- =========================================================================
-- 🎨 BUILD GUI (FORCED LANDSCAPE - 3 COLUMNS)
-- =========================================================================
local function buildUI()
    local gui = create("ScreenGui", { Name = "LandscapeUI", ResetOnSpawn = false, Parent = CoreGui })
    
    -- FRAME UTAMA (Miring)
    local main = create("Frame", { Size = UDim2.new(0, 520, 0, 180), Position = UDim2.new(0.5, -260, 0.5, -90), BackgroundColor3 = C.BG, BorderSizePixel = 0, Parent = gui })
    addCorner(main, 8); addStroke(main, C.BORDER)

    -- Header
    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    addCorner(header, 8)
    create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "KEI SELVIM — LANDSCAPE", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    
    -- Tombol X (Minimize)
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -22, 0, 3), BackgroundColor3 = C.RED, Text = "✕", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = header })
    addCorner(closeBtn, 4)
    
    -- Floating Button (Disembunyiin dulu)
    local floatBtn = create("TextButton", { Size = UDim2.new(0, 45, 0, 45), Position = UDim2.new(0, 20, 0, 100), BackgroundColor3 = C.ACCENT, Text = "K", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 18, BorderSizePixel = 0, Visible = false, Parent = gui })
    addCorner(floatBtn, 22)

    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        floatBtn.Visible = true
    end)
    
    floatBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        floatBtn.Visible = false
    end)

    -- ═══════════ KOLOM 1 (KIRI: KOORDINAT & TOGGLE) ═══════════
    local col1 = create("Frame", { Size = UDim2.new(0.33, -10, 1, -35), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Parent = main })
    
    -- Coord Box
    local coordBox = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = C.BOX, BorderSizePixel = 0, Parent = col1 })
    addCorner(coordBox, 4); addStroke(coordBox, C.BORDER)
    local coordLbl = create("TextLabel", { Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 4, 0, 0), BackgroundTransparency = 1, Text = "📍 0, 0, 0", TextColor3 = C.DIM, Font = Enum.Font.Code, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = coordBox })

    task.spawn(function()
        while gui.Parent do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                coordLbl.Text = string.format("📍 %.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
            end
            task.wait(0.2)
        end
    end)

    -- Toggle Steal
    local btnSteal = create("TextButton", { Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 38), BackgroundColor3 = C.BOX, Text = "Auto Steal: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = col1 })
    addCorner(btnSteal, 4); addStroke(btnSteal, C.BORDER)
    btnSteal.MouseButton1Click:Connect(function()
        State.AutoSteal = not State.AutoSteal
        btnSteal.Text = "Auto Steal: " .. (State.AutoSteal and "ON" or "OFF")
        btnSteal.BackgroundColor3 = State.AutoSteal and C.GREEN or C.BOX
        if State.AutoSteal then startAutoSteal() end
    end)

    -- Toggle Farm
    local btnFarm = create("TextButton", { Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 68), BackgroundColor3 = C.BOX, Text = "Auto Farm: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = col1 })
    addCorner(btnFarm, 4); addStroke(btnFarm, C.BORDER)
    btnFarm.MouseButton1Click:Connect(function()
        State.AutoFarmZone = not State.AutoFarmZone
        btnFarm.Text = "Auto Farm: " .. (State.AutoFarmZone and "ON" or "OFF")
        btnFarm.BackgroundColor3 = State.AutoFarmZone and C.GREEN or C.BOX
    end)

    -- ═══════════ KOLOM 2 (TENGAH: ZONA SELECTOR) ═══════════
    local col2 = create("Frame", { Size = UDim2.new(0.33, -10, 1, -35), Position = UDim2.new(0.33, 5, 0, 30), BackgroundTransparency = 1, Parent = main })
    
    create("TextLabel", { Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = "Target Auto Farm:", TextColor3 = C.DIM, Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = col2 })
    
    local zonaContainer = create("Frame", { Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Parent = col2 })
    create("UIGridLayout", { CellSize = UDim2.new(0.11, -1, 0, 18), CellPadding = UDim.new(0, 1), Parent = zonaContainer })
    
    for i = 1, 9 do
        local zBtn = create("TextButton", { BackgroundColor3 = (i == 1) and C.ACCENT or C.BOX, Text = tostring(i), TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = zonaContainer })
        addCorner(zBtn, 3); addStroke(zBtn, C.BORDER)
        zBtn.MouseButton1Click:Connect(function()
            State.SelectedZone = i
            for _, child in ipairs(zonaContainer:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3 = C.BOX end end
            zBtn.BackgroundColor3 = C.ACCENT
        end)
    end

    -- ═══════════ KOLOM 3 (KANAN: TELEPORT) ═══════════
    local col3 = create("Frame", { Size = UDim2.new(0.34, -10, 1, -35), Position = UDim2.new(0.66, 5, 0, 30), BackgroundTransparency = 1, Parent = main })

    create("TextLabel", { Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = "Menu Teleport Cepat:", TextColor3 = C.DIM, Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = col3 })

    -- Tombol Safe Zone
    local btnSafe = create("TextButton", { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = C.RED, Text = "🛡️ Safe Zone", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = col3 })
    addCorner(btnSafe, 4)
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone) end
    end)

    -- Tombol Zona (Grid 3x3)
    local tpContainer = create("Frame", { Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0, 48), BackgroundTransparency = 1, Parent = col3 })
    create("UIGridLayout", { CellSize = UDim2.new(0.33, -2, 0, 22), CellPadding = UDim.new(0, 2), Parent = tpContainer })

    for i, zone in ipairs(COORDS.FarmZones) do
        local tpBtn = create("TextButton", { BackgroundColor3 = C.PANEL, Text = "📍 Z" .. i, TextColor3 = C.TEXT, Font = Enum.Font.Gotham, TextSize = 9, BorderSizePixel = 0, Parent = tpContainer })
        addCorner(tpBtn, 4); addStroke(tpBtn, C.BORDER)
        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(zone.pos) end
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
-- 🔥 FITUR BARU: AUTO SAFE ZONE KALAU PEGANG TELUR
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
                print("[🛡️] Telur terdeteksi di tangan! Teleport ke Safe Zone...")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(COORDS.SafeZone)
                    task.wait(1) -- Tunggu bentar buat klaim
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
