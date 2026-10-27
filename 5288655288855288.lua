-- [[ KEI SELVIM - FIXED BUTTON PANEL ]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local COORDS = {
    SafeZone = Vector3.new(6.34, 4.48, 83.33),
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

local function create(cls, props)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function buildUI()
    local gui = create("ScreenGui", { Name = "PanelUI", ResetOnSpawn = false, Parent = CoreGui })
    
    -- Frame Utama Kecil (320x150)
    local main = create("Frame", { Size = UDim2.new(0, 320, 0, 150), Position = UDim2.new(0.5, -160, 0.5, -75), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BorderSizePixel = 0, Parent = gui })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })

    -- Header
    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Color3.fromRGB(28, 28, 34), BorderSizePixel = 0, Parent = main })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = header })
    create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "KEI SELVIM", TextColor3 = Color3.fromRGB(240, 240, 240), Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    
    -- Tombol Close
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -22, 0, 3), BackgroundColor3 = Color3.fromRGB(240, 80, 80), Text = "✕", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 9, BorderSizePixel = 0, Parent = header })
    create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- ═══════════ TOMBOL SAFE ZONE ═══════════
    local btnSafe = create("TextButton", { 
        Size = UDim2.new(1, -20, 0, 35), 
        Position = UDim2.new(0, 10, 0, 35), 
        BackgroundColor3 = Color3.fromRGB(240, 80, 80), 
        Text = "TELEPORT KE SAFE ZONE", 
        TextColor3 = Color3.fromRGB(255, 255, 255), 
        Font = Enum.Font.GothamBold, 
        TextSize = 12, 
        BorderSizePixel = 0, 
        Parent = main 
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btnSafe })
    
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then 
            char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone) 
        end
    end)

    -- ═══════════ TOMBOL ZONA 1-9 ═══════════
    local tpContainer = create("Frame", { 
        Size = UDim2.new(1, -20, 0, 80), 
        Position = UDim2.new(0, 10, 0, 80), 
        BackgroundTransparency = 1, 
        Parent = main 
    })
    create("UIGridLayout", { CellSize = UDim2.new(0.33, -4, 0, 22), CellPadding = UDim2.new(0, 4, 0, 4), Parent = tpContainer })

    for i, zone in ipairs(COORDS.FarmZones) do
        local tpBtn = create("TextButton", { BackgroundColor3 = Color3.fromRGB(28, 28, 34), Text = "Z" .. i, TextColor3 = Color3.fromRGB(240, 240, 240), Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = tpContainer })
        create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = tpBtn })
        
        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then 
                char.HumanoidRootPart.CFrame = CFrame.new(zone.pos) 
            end
        end)
    end

    -- Drag
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

task.wait(1)
local success, err = pcall(buildUI)
if not success then warn("[UI Error] " .. tostring(err)) end
