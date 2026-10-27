--[[
    ╔══════════════════════════════════════════════════════════════════════╗
    ║           KEI SELVIM — TELEPORT PANEL FIX v26.0                      ║
    ║           Tombol Safe Zone & Zona 1-9 • Kecil • Anti Hilang          ║
    ╚══════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- =========================================================================
-- ⚙️ KONFIGURASI KOORDINAT
-- =========================================================================
local COORDS = {
    -- Koordinat Safe Zone Baru
    SafeZone = Vector3.new(6.34, 4.48, 83.33),
    
    -- Zona Farm
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

-- =========================================================================
-- HELPER UI
-- =========================================================================
local C = {
    BG = Color3.fromRGB(20, 20, 24), PANEL = Color3.fromRGB(28, 28, 34), BOX = Color3.fromRGB(18, 18, 20),
    TEXT = Color3.fromRGB(240, 240, 240), DIM = Color3.fromRGB(150, 150, 160),
    RED = Color3.fromRGB(240, 80, 80), BORDER = Color3.fromRGB(50, 50, 60),
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
-- 🎨 BUILD GUI
-- =========================================================================
local function buildUI()
    local gui = create("ScreenGui", { Name = "TeleportPanelUI", ResetOnSpawn = false, Parent = CoreGui })
    
    -- Frame Utama (Lebar 320, Tinggi 220)
    local main = create("Frame", { Size = UDim2.new(0, 320, 0, 220), Position = UDim2.new(0.5, -160, 0.5, -110), BackgroundColor3 = C.BG, BorderSizePixel = 0, Parent = gui })
    addCorner(main, 8); addStroke(main, C.BORDER)

    -- Header
    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    addCorner(header, 8)
    create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "KEI SELVIM — TELEPORT", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    
    -- Tombol Close
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -22, 0, 3), BackgroundColor3 = C.RED, Text = "✕", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = header })
    addCorner(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- ═══════════ TOMBOL SAFE ZONE (FIX 100% MUNCUL) ═══════════
    local btnSafe = create("TextButton", { 
        Size = UDim2.new(1, -20, 0, 35), 
        Position = UDim2.new(0, 10, 0, 35), 
        BackgroundColor3 = C.RED, 
        Text = "🛡️ TELEPORT KE SAFE ZONE", 
        TextColor3 = C.TEXT, 
        Font = Enum.Font.GothamBold, 
        TextSize = 12, 
        BorderSizePixel = 0, 
        Parent = main 
    })
    addCorner(btnSafe, 6); addStroke(btnSafe, C.RED)
    
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then 
            char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone) 
        end
    end)

    -- ═══════════ TOMBOL ZONA 1-9 (GRID) ═══════════
    create("TextLabel", { 
        Size = UDim2.new(1, -20, 0, 15), 
        Position = UDim2.new(0, 10, 0, 80), 
        BackgroundTransparency = 1, 
        Text = "Teleport Zona:", 
        TextColor3 = C.DIM, 
        Font = Enum.Font.Gotham, 
        TextSize = 10, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Parent = main 
    })

    local tpContainer = create("Frame", { 
        Size = UDim2.new(1, -20, 0, 100), 
        Position = UDim2.new(0, 10, 0, 100), 
        BackgroundTransparency = 1, 
        Parent = main 
    })
    
    -- Grid 3x3 rapi
    create("UIGridLayout", { 
        CellSize = UDim2.new(0.33, -5, 0, 28), 
        CellPadding = UDim2.new(0, 5, 0, 5), 
        Parent = tpContainer 
    })

    for i, zone in ipairs(COORDS.FarmZones) do
        local tpBtn = create("TextButton", { 
            BackgroundColor3 = C.PANEL, 
            Text = "📍 " .. zone.name, 
            TextColor3 = C.TEXT, 
            Font = Enum.Font.Gotham, 
            TextSize = 10, 
            BorderSizePixel = 0, 
            Parent = tpContainer 
        })
        addCorner(tpBtn, 4); addStroke(tpBtn, C.BORDER)
        
        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then 
                char.HumanoidRootPart.CFrame = CFrame.new(zone.pos) 
            end
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
-- JALANKAN
-- =========================================================================
task.wait(1)
local success, err = pcall(buildUI)
if not success then warn("[UI Error] " .. tostring(err)) end
