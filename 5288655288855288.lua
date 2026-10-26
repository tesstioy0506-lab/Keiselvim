--[[
    ╔══════════════════════════════════════════════════════════════════════╗
    ║           KEI SELVIM — VENYX DASHBOARD STYLE v22.0                   ║
    ║           Wide Layout • Sidebar • Card System                        ║
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
    SelectedZone = 1
}

-- =========================================================================
-- HELPER UI & WARNA VENYX
-- =========================================================================
local C = {
    BG = Color3.fromRGB(18, 18, 18), PANEL = Color3.fromRGB(24, 24, 24), CARD = Color3.fromRGB(32, 32, 32),
    TEXT = Color3.fromRGB(240, 240, 240), DIM = Color3.fromRGB(140, 140, 150),
    GREEN = Color3.fromRGB(100, 220, 150), RED = Color3.fromRGB(240, 80, 80), BORDER = Color3.fromRGB(45, 45, 45),
    ACCENT = Color3.fromRGB(110, 80, 255)
}

local function create(cls, props)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end
local function addCorner(parent, r) return create("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent }) end
local function addStroke(parent, col) return create("UIStroke", { Color = col or C.BORDER, Thickness = 1, Parent = parent }) end

-- =========================================================================
-- 🧠 FUNGSI DETEKSI & STEAL (SAMA SEPERTI SEBELUMNYA)
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
    for _, v in ipairs(obj:GetChildren()) do if v:IsA("ParticleEmitter") or v:IsA("PointLight") then return true end end
    return false
end

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
    if prompt then pcall(function() fireproximityprompt(prompt) end)
    else pcall(function() firetouchinterest(hrp, egg, 0) task.wait(0.1) firetouchinterest(hrp, egg, 1) end) end
    
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
-- 🎨 BUILD GUI (VENYX DASHBOARD STYLE)
-- =========================================================================
local function buildUI()
    local gui = create("ScreenGui", { Name = "VenyxDash", ResetOnSpawn = false, Parent = CoreGui })
    
    -- 1. MAIN FRAME (Lebar / Landscape: 700x400)
    local main = create("Frame", { Size = UDim2.new(0, 700, 0, 400), Position = UDim2.new(0.5, -350, 0.5, -200), BackgroundColor3 = C.BG, BorderSizePixel = 0, Parent = gui })
    addCorner(main, 10); addStroke(main, C.BORDER)

    -- 2. TOPBAR (Header)
    local topbar = create("Frame", { Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    addCorner(topbar, 10)
    create("TextLabel", { Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = "V KEI SELVIM  /  Dashboard", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = topbar })
    
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -35, 0, 10), BackgroundColor3 = C.RED, Text = "✕", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0, Parent = topbar })
    addCorner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- 3. SIDEBAR (KIRI)
    local sidebar = create("Frame", { Size = UDim2.new(0, 55, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    create("Frame", { Size = UDim2.new(0, 1, 1, -10), Position = UDim2.new(1, -1, 0, 5), BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = sidebar })
    
    -- Ikon Sidebar (Murni Vektor, ga pake emoji)
    local function makeIcon(y, active)
        local icnBg = create("Frame", { Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 9, 0, y), BackgroundColor3 = active and C.CARD or C.PANEL, BorderSizePixel = 0, Parent = sidebar })
        addCorner(icnBg, 8)
        if active then addStroke(icnBg, C.BORDER) end
        local ln = create("Frame", { Size = UDim2.new(0, 14, 0, 2), Position = UDim2.new(0.5, -7, 0.5, -1), BackgroundColor3 = active and C.TEXT or C.DIM, BorderSizePixel = 0, Parent = icnBg })
        addCorner(ln, 1)
    end
    makeIcon(15, true)
    makeIcon(60, false)
    makeIcon(105, false)

    -- 4. CONTENT AREA (KANAN)
    local content = create("Frame", { Size = UDim2.new(1, -80, 1, -70), Position = UDim2.new(0, 65, 0, 55), BackgroundTransparency = 1, Parent = main })

    -- Page Title
    create("TextLabel", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Dashboard", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left, Parent = content })

    -- ═══════════ CARD 1: PROFILE (KIRI ATAS) ═══════════
    local cardProfile = create("Frame", { Size = UDim2.new(0.5, -10, 0, 80), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Parent = content })
    addCorner(cardProfile, 10)
    
    local av = create("ImageLabel", { Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = cardProfile })
    addCorner(av, 25)
    task.spawn(function()
        local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
        if ok and thumb then av.Image = thumb end
    end)
    
    create("TextLabel", { Size = UDim2.new(1, -80, 0, 20), Position = UDim2.new(0, 75, 0, 15), BackgroundTransparency = 1, Text = "Welcome back", TextColor3 = C.DIM, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardProfile })
    create("TextLabel", { Size = UDim2.new(1, -80, 0, 25), Position = UDim2.new(0, 75, 0, 30), BackgroundTransparency = 1, Text = LocalPlayer.DisplayName, TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardProfile })

    -- ═══════════ CARD 2: SESSION INFO (KANAN ATAS) ═══════════
    local cardSession = create("Frame", { Size = UDim2.new(0.5, -10, 0, 80), Position = UDim2.new(0.5, 10, 0, 40), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Parent = content })
    addCorner(cardSession, 10)
    
    create("TextLabel", { Size = UDim2.new(1, -20, 0, 15), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "🕒 SESSION", TextColor3 = C.DIM, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardSession })
    
    local coordLbl = create("TextLabel", { Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = "📍 0.00, 0.00, 0.00", TextColor3 = C.TEXT, Font = Enum.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardSession })

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

    -- ═══════════ CARD 3: TOGGLES (KIRI BAWAH) ═══════════
    local cardToggles = create("Frame", { Size = UDim2.new(0.5, -10, 1, -140), Position = UDim2.new(0, 0, 0, 130), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Parent = content })
    addCorner(cardToggles, 10)
    
    create("TextLabel", { Size = UDim2.new(1, -20, 0, 15), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "⚙️ FEATURES", TextColor3 = C.DIM, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardToggles })

    -- Toggle Steal
    local btnSteal = create("TextButton", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 35), BackgroundColor3 = C.PANEL, Text = "Auto Steal: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 11, BorderSizePixel = 0, Parent = cardToggles })
    addCorner(btnSteal, 6)
    btnSteal.MouseButton1Click:Connect(function()
        State.AutoSteal = not State.AutoSteal
        btnSteal.Text = "Auto Steal: " .. (State.AutoSteal and "ON" or "OFF")
        btnSteal.BackgroundColor3 = State.AutoSteal and C.GREEN or C.PANEL
        if State.AutoSteal then startAutoSteal() end
    end)

    -- Toggle Farm
    local btnFarm = create("TextButton", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 75), BackgroundColor3 = C.PANEL, Text = "Auto Balik Zona: OFF", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 11, BorderSizePixel = 0, Parent = cardToggles })
    addCorner(btnFarm, 6)
    btnFarm.MouseButton1Click:Connect(function()
        State.AutoFarmZone = not State.AutoFarmZone
        btnFarm.Text = "Auto Balik Zona: " .. (State.AutoFarmZone and "ON" or "OFF")
        btnFarm.BackgroundColor3 = State.AutoFarmZone and C.GREEN or C.PANEL
    end)

    -- ═══════════ CARD 4: TELEPORT (KANAN BAWAH) ═══════════
    local cardTp = create("Frame", { Size = UDim2.new(0.5, -10, 1, -140), Position = UDim2.new(0.5, 10, 0, 130), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Parent = content })
    addCorner(cardTp, 10)
    
    create("TextLabel", { Size = UDim2.new(1, -20, 0, 15), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "🚀 TELEPORT MENU", TextColor3 = C.DIM, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = cardTp })

    local gridTp = create("Frame", { Size = UDim2.new(1, -20, 1, -40), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Parent = cardTp })
    create("UIGridLayout", { CellSize = UDim2.new(0.33, -5, 0, 28), CellPadding = UDim.new(0, 5), Parent = gridTp })

    -- Safe Zone Button
    local btnSafe = create("TextButton", { BackgroundColor3 = C.RED, Text = "🛡️ Safe Zone", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = gridTp })
    addCorner(btnSafe, 6)
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone) end
    end)

    -- Farm Zones Grid
    for i = 1, 9 do
        local tpBtn = create("TextButton", { BackgroundColor3 = C.PANEL, Text = "📍 Z" .. i, TextColor3 = C.TEXT, Font = Enum.Font.Gotham, TextSize = 10, BorderSizePixel = 0, Parent = gridTp })
        addCorner(tpBtn, 6)
        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(COORDS.FarmZones[i].pos) end
        end)
    end

    -- Drag Logic
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    topbar.InputChanged:Connect(function(input)
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
