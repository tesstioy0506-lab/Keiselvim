-- Recovered source by ZeroVector
local __mv = {
    j = function(e, f, ...)
        local h = {...}
        local d = select("#", ...)
        for i = 1, d do
            e[f + i - 1] = h[i]
        end
    end,
};
(function(v4)
    local v79 = v4
    local v516 = isfile
    if v516 then
        v516 = readfile
    end
    if v516 then
        v516 = isfile("GamingSpirit_AnimePack_Key.txt")
    end
    if v516 then
        local v519 = tonumber(readfile("GamingSpirit_AnimePack_Key.txt"))
        local v623 = v519
        if v623 then
            v623 = os.time() - v519 < 0x15180
        end
        if v623 then
            v79()
            return
        end
    end
    local v80 = game:GetService("CoreGui")
    if not pcall(function()
        Instance.new("ScreenGui").Parent = v80
        return
    end) then
        v80 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    local v81
    local v575 = function(v21)
        local v54 = v21
        local v357 = game:GetService("UserInputService")
        local v55
        local v56
        local v57
        v54.InputBegan:Connect(function(v30)
            local v42 = v30
            local v318 = v42.UserInputType == Enum.UserInputType.MouseButton1
            if not v318 then
                v318 = v42.UserInputType == Enum.UserInputType.Touch
            end
            if v318 then
                v55 = true
                v56 = v42.Position
                v57 = v54.Position
                v42.Changed:Connect(function()
                    if v42.UserInputState == Enum.UserInputState.End then
                        v55 = false
                    end
                    return
                end)
            end
            return
        end)
        v357.InputChanged:Connect(function(v43)
            local v324 = v55
            if v324 then
                v324 = v43.UserInputType == Enum.UserInputType.MouseMovement
                if not v324 then
                    v324 = v43.UserInputType == Enum.UserInputType.Touch
                end
            end
            if v324 then
                local v325 = v43.Position - v56
                local v330 = v57
                local v351 = v330
                v54.Position = UDim2.new(v330.X.Scale, v351.X.Offset + v325.X, v351.Y.Scale, v351.Y.Offset + v325.Y)
            end
            return
        end)
        return
    end
    v81 = function()
        local v381, v379 = pcall(function()
            return game:HttpGet("https://pastebin.com/raw/3Yk4R5xS")
        end)
        local v383 = v381
        if v383 then
            v383 = v379
        end
        if v383 then
            v383 = v379:gsub("%s+", "")
        end
        if not v383 then
            v383 = "GamingSpiritOnTop"
        end
        return v383
    end
    local v82 = Instance.new("ScreenGui", v80)
    local v588 = Instance.new("Frame", v82)
    local v549 = 0
    v588.Size = UDim2.new(v549, 220, v549, 160)
    local v551 = 0.5
    v588.Position = UDim2.new(v551, -110, v551, -80)
    local v553 = 30
    v588.BackgroundColor3 = Color3.fromRGB(v553, v553, v553)
    v588.Active = true
    Instance.new("UICorner", v588)
    v575(v588)
    local v430 = Instance.new("TextLabel", v588)
    local v592 = 0
    v430.Size = UDim2.new(1, v592, v592, 35)
    v430.Text = "Gaming Spirit Key"
    local v531 = 1
    v430.TextColor3 = Color3.new(v531, v531, v531)
    v430.BackgroundTransparency = 1
    v430.Font = Enum.Font.GothamBold
    local v83 = Instance.new("TextBox", v588)
    local v597 = 0
    v83.Size = UDim2.new(v597, 180, v597, 35)
    v83.Position = UDim2.new(0.5, -90, 0.3, 0)
    v83.PlaceholderText = "Enter Key..."
    local v601 = 45
    v83.BackgroundColor3 = Color3.fromRGB(v601, v601, v601)
    local v603 = 1
    v83.TextColor3 = Color3.new(v603, v603, v603)
    Instance.new("UICorner", v83)
    local v546 = Instance.new("TextButton", v588)
    local v442 = 0
    v546.Size = UDim2.new(v442, 180, v442, 35)
    v546.Position = UDim2.new(0.5, -90, 0.58, 0)
    v546.Text = "Verify"
    v546.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    local v448 = 1
    local v480 = v448
    v546.TextColor3 = Color3.new(v448, v480, v480)
    Instance.new("UICorner", v546)
    local v84 = Instance.new("TextButton", v588)
    local v484 = 0
    v84.Size = UDim2.new(v484, 180, v484, 25)
    v84.Position = UDim2.new(0.5, -90, 0.83, 0)
    v84.Text = "Get Key Link"
    v84.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    local v490 = 1
    v84.TextColor3 = Color3.new(v490, v490, v490)
    Instance.new("UICorner", v84)
    v84.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://lootdest.org/s?LqaMr3vF")
            v84.Text = "Link Copied!"
        else
            v84.Text = "Clipboard not supported"
        end
        task.wait(2)
        v84.Text = "Get Key Link"
        return
    end)
    v546.MouseButton1Click:Connect(function()
        if v83.Text == v81() then
            if writefile then
                writefile("GamingSpirit_AnimePack_Key.txt", tostring(os.time()))
            end
            v82:Destroy()
            v79()
        else
            local v405 = v83
            v405.Text = ""
            v405.PlaceholderText = "WRONG KEY!"
        end
        return
    end)
    return
end)(function()
    local v1447 = game:GetService("Players")
    local v279 = game:GetService("Workspace")
    local v280 = game:GetService("ReplicatedStorage")
    local v1500 = game:GetService("CoreGui")
    local v282 = v1447.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local BASE_CFRAME = CFrame.new(1170, 71, -364) 
    _G.XYPosEnabled = false
    local isMoving = false
    local currentHoldingPack = nil

    -- FITUR PERTAHANAN (ANTI HIT, TRAP, RAGDOLL) - REAL
    _G.GodMode = true
    
    task.spawn(function()
        while task.wait(0.1) do
            if _G.GodMode then
                local char = v282.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Physics then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            -- Noclip & Anti Touch (Mop / Player Hit)
                            part.CanCollide = false
                            part.CanTouch = false
                        end
                    end
                    
                    -- Anti Trap
                    for _, obj in ipairs(v279:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local n = string.lower(obj.Name)
                            if string.find(n, "trap") or string.find(n, "spike") or string.find(n, "laser") or string.find(n, "damage") or string.find(n, "kill") then
                                obj.CanTouch = false
                                obj.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end)

    -- FUNGSI GERAK KE BASE (NO VISUAL / SERVER SYNC)
    local function goToBase(hrp)
        if isMoving then return end
        isMoving = true
        
        -- 1. Kunci fisik (Anchored)
        hrp.Anchored = true
        
        local startPos = hrp.Position
        local targetPos = BASE_CFRAME.Position
        local distance = (startPos - targetPos).Magnitude
        
        -- 2. Gerak (Teleport Jauh, ZigZag Deket)
        if distance > 1000 then
            hrp.CFrame = BASE_CFRAME
        else
            local steps = 5
            for i = 1, steps do
                local t = i / steps
                local offset = (i % 2 == 0) and Vector3.new(5, 0, 5) or Vector3.new(-5, 0, -5)
                local currentTarget = startPos:Lerp(targetPos, t) + offset
                local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(currentTarget + Vector3.new(0, 3, 0))})
                tween:Play()
                tween.Completed:Wait()
            end
            hrp.CFrame = BASE_CFRAME
        end
        
        -- 3. SERVER SYNC (Diem total 2 detik tanpa gerakan)
        -- Jangan sentuh apapun, biar server nge-sync posisi
        task.wait(2)
        
        -- 4. Lepas kunci
        hrp.Anchored = false
        task.wait(1.5)
        
        isMoving = false
    end

    -- LOOP XY POSITION (AUTO TP)
    task.spawn(function()
        while task.wait(0.2) do
            if _G.XYPosEnabled and not isMoving then
                local char = v282.Character
                if char then
                    local foundPack = nil
                    local backpack = v282:FindFirstChild("Backpack")
                    
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Tool") or (obj:IsA("Model") and string.find(string.lower(obj.Name), "pack")) then
                            foundPack = obj; break
                        end
                    end
                    
                    if not foundPack and backpack then
                        for _, obj in ipairs(backpack:GetChildren()) do
                            if obj:IsA("Tool") or (obj:IsA("Model") and string.find(string.lower(obj.Name), "pack")) then
                                foundPack = obj; break
                            end
                        end
                    end
                    
                    if foundPack and currentHoldingPack ~= foundPack then
                        currentHoldingPack = foundPack
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            goToBase(hrp)
                        end
                    end
                    
                    if not foundPack then
                        currentHoldingPack = nil
                    end
                end
            end
        end
    end)

    if v1500:FindFirstChild("SpiritualGamingAnimePackGui") then
        v1500.SpiritualGamingAnimePackGui:Destroy()
    end
    local v1318 = Instance.new("ScreenGui")
    v1318.Name = "SpiritualGamingAnimePackGui"
    v1318.ResetOnSpawn = false
    v1318.Parent = v1500
    local v283 = Instance.new("Frame")
    v283.Name = "MainFrame"
    local v1384 = 0
    v283.Size = UDim2.new(v1384, 200, v1384, 260)
    local v1386 = 0.5
    v283.Position = UDim2.new(v1386, -100, v1386, -130)
    local v1388 = 20
    local v1330 = v1388
    v283.BackgroundColor3 = Color3.fromRGB(v1388, v1330, v1330)
    v283.BorderSizePixel = 0
    local v1296 = true
    v283.Active = v1296
    v283.Draggable = v1296
    v283.Parent = v1318
    local v1298 = Instance.new("UICorner")
    v1298.CornerRadius = UDim.new(0, 6)
    v1298.Parent = v283
    local v1394 = Instance.new("TextLabel")
    local v1462 = 0
    v1394.Size = UDim2.new(v1462, 160, v1462, 30)
    local v1464 = 0
    v1394.Position = UDim2.new(v1464, 8, v1464, 5)
    v1394.BackgroundTransparency = 1
    v1394.Font = Enum.Font.LuckiestGuy
    local v1467 = 255
    v1394.TextColor3 = Color3.fromRGB(v1467, v1467, v1467)
    v1394.TextSize = 14
    v1394.TextXAlignment = Enum.TextXAlignment.Left
    v1394.Text = "STEAL AN ANIME PACK"
    v1394.Parent = v283
    local v284 = Instance.new("TextButton")
    local v1573 = 24
    local v1627 = 0
    v284.Size = UDim2.new(v1627, v1573, v1627, v1573)
    v284.Position = UDim2.new(1, -28, 0, 7)
    local v1631 = 40
    v284.BackgroundColor3 = Color3.fromRGB(v1631, v1631, v1631)
    v284.Font = Enum.Font.LuckiestGuy
    local v1634 = 255
    local v1577 = v1634
    v284.TextColor3 = Color3.fromRGB(v1634, v1577, v1577)
    v284.TextSize = 18
    v284.Text = "-"
    v284.Parent = v283
    local v1483 = Instance.new("UICorner")
    v1483.CornerRadius = UDim.new(0, 4)
    v1483.Parent = v284
    local v285 = Instance.new("TextLabel")
    v285.Size = UDim2.new(1, -16, 0, 22)
    v285.Position = UDim2.new(0, 8, 1, -26)
    v285.BackgroundTransparency = 1
    v285.Font = Enum.Font.LuckiestGuy
    local v1270 = 255
    local v1211 = v1270
    v285.TextColor3 = Color3.fromRGB(v1270, v1211, v1211)
    v285.TextSize = 13
    v285.Text = "YOUTUBE: SPIRITUAL GAMING"
    v285.Parent = v283
    local v286 = Instance.new("ScrollingFrame")
    local v1213 = 1
    v286.Size = UDim2.new(v1213, -12, v1213, -64)
    local v1215 = 0
    v286.Position = UDim2.new(v1215, 6, v1215, 35)
    v286.BackgroundTransparency = 1
    v286.BorderSizePixel = 0
    local v1217 = 0
    v286.CanvasSize = UDim2.new(v1217, v1217, v1217, v1217)
    local v1234 = Enum
    v286.AutomaticCanvasSize = v1234.AutomaticSize.Y
    v286.ScrollBarThickness = 3
    v286.Parent = v283
    local v1284 = Instance.new("UIListLayout")
    v1284.SortOrder = v1234.SortOrder.LayoutOrder
    v1284.Padding = UDim.new(0, 6)
    v1284.Parent = v286
    local v287 = false
    v284.MouseButton1Click:Connect(function()
        v287 = not v287
        local v630 = v287
        v286.Visible = not v630
        v285.Visible = not v630
        local v638 = v630
        if v638 then
            local v632 = 0
            v638 = UDim2.new(v632, 200, v632, 42)
        end
        if not v638 then
            local v634 = 0
            v638 = UDim2.new(v634, 200, v634, 260)
        end
        v283.Size = v638
        local v641 = v287
        if v641 then
            v641 = "+"
        end
        if not v641 then
            v641 = "-"
        end
        v284.Text = v641
        return
    end)
    local v288 = {}
    local v289
    local v1303 = function(v228, v229)
        local v244 = v229
        local v708 = Instance.new("Frame")
        local v670 = 0
        v708.Size = UDim2.new(1, v670, v670, 30)
        v708.BackgroundTransparency = 1
        v708.Parent = v286
        local v750 = Instance.new("TextLabel")
        local v672 = 1
        v750.Size = UDim2.new(v672, -34, v672, 0)
        local v674 = 0
        v750.Position = UDim2.new(v674, 2, v674, v674)
        v750.BackgroundTransparency = 1
        v750.Font = Enum.Font.LuckiestGuy
        local v677 = 255
        local v694 = v677
        v750.TextColor3 = Color3.fromRGB(v677, v694, v694)
        v750.TextSize = 13
        v750.TextXAlignment = Enum.TextXAlignment.Left
        v750.Text = v228
        v750.Parent = v708
        local v245 = Instance.new("TextButton")
        local v697 = 0
        local v736 = 22
        v245.Size = UDim2.new(v697, v736, v697, v736)
        v245.Position = UDim2.new(1, -24, 0.5, -11)
        local v738 = 40
        v245.BackgroundColor3 = Color3.fromRGB(220, v738, v738)
        v245.Text = ""
        v245.Parent = v708
        local v689 = Instance.new("UICorner")
        v689.CornerRadius = UDim.new(0, 4)
        v689.Parent = v245
        local v246 = false
        v245.MouseButton1Click:Connect(function()
            v246 = not v246
            local v659 = v246
            if v659 then
                local v652 = 40
                v659 = Color3.fromRGB(v652, 220, v652)
            end
            if not v659 then
                local v664 = 40
                v659 = Color3.fromRGB(220, v664, v664)
            end
            v245.BackgroundColor3 = v659
            v244(v246)
            return
        end)
        return v708
    end
    v289 = function(v247, v248)
        local v274 = v247
        if v248 then
            if v288[v274] then return end
            local v275 = true
            local v891 = {}
            v891.stop = function() v275 = false end
            v288[v274] = v891
            task.spawn(function()
                while v275 do
                    local v753 = v282.Character
                    if not v753 then v753 = v282.CharacterAdded:Wait() end
                    local v886 = v753:WaitForChild("HumanoidRootPart", 2)
                    if v886 then
                        local allPacks = {}
                        for _, obj in ipairs(v279:GetDescendants()) do
                            if obj:IsA("Model") and (string.find(string.lower(obj.Name), "pack") or string.find(string.lower(obj.Name), "anime")) then
                                if not obj:IsDescendantOf(v753) then
                                    table.insert(allPacks, obj)
                                end
                            end
                        end
                        
                        if #allPacks > 0 then
                            local v811 = allPacks[1]
                            local v859 = v811:GetPivot()
                            local targetPos = v859.Position + Vector3.new(3, 0, 0)
                            
                            v886.CFrame = CFrame.new(targetPos)
                            task.wait(0.3)
                            
                            local tahanWaktu = 3
                            local startTime = tick()
                            
                            while tick() - startTime < tahanWaktu do
                                if not v811.Parent then break end
                                local promptDitemukan = false
                                for _, vPrompt in ipairs(v811:GetDescendants()) do
                                    if vPrompt:IsA("ProximityPrompt") then
                                        pcall(function() fireproximityprompt(vPrompt) end)
                                        promptDitemukan = true
                                    end
                                end
                                if not promptDitemukan then
                                    pcall(function()
                                        local partToTouch = v811.PrimaryPart or v811:FindFirstChildWhichIsA("BasePart")
                                        if partToTouch then
                                            firetouchinterest(v886, partToTouch, 0)
                                            task.wait(0.1)
                                            firetouchinterest(v886, partToTouch, 1)
                                        end
                                    end)
                                end
                                task.wait(0.25) 
                            end
                            
                            task.wait(0.5)
                            goToBase(v886)
                            task.wait(0.5)
                        end
                    end
                    task.wait(0.5)
                end
                return
            end)
        else
            if v288[v274] then
                v288[v274].stop()
                v288[v274] = nil
            end
        end
        return
    end
    local v1349 = Instance.new("Frame")
    v1349.Name = "AutoStealContainer"
    local v1547 = 0
    v1349.Size = UDim2.new(1, v1547, v1547, 30)
    v1349.BackgroundTransparency = 1
    v1349.AutomaticSize = Enum.AutomaticSize.Y
    v1349.Parent = v286
    local v1327 = Instance.new("TextButton")
    local v1353 = 0
    v1327.Size = UDim2.new(1, v1353, v1353, 30)
    v1327.BackgroundTransparency = 1
    v1327.Font = Enum.Font.LuckiestGuy
    local v1553 = 255
    local v1355 = v1553
    v1327.TextColor3 = Color3.fromRGB(v1553, v1355, v1355)
    v1327.TextSize = 14
    v1327.TextXAlignment = Enum.TextXAlignment.Left
    v1327.Text = "AUTO STEAL"
    v1327.Parent = v1349
    local v290 = Instance.new("TextLabel")
    local v1519 = 22
    local v1358 = 0
    v290.Size = UDim2.new(v1358, v1519, v1358, v1519)
    v290.Position = UDim2.new(1, -24, 0.5, -11)
    local v1362 = 40
    v290.BackgroundColor3 = Color3.fromRGB(v1362, v1362, v1362)
    v290.Font = Enum.Font.SourceSansBold
    local v1365 = 255
    local v1523 = v1365
    v290.TextColor3 = Color3.fromRGB(v1365, v1523, v1523)
    v290.TextSize = 14
    v290.Text = "▲"
    v290.Parent = v1349
    local v1569 = Instance.new("UICorner")
    v1569.CornerRadius = UDim.new(0, 4)
    v1569.Parent = v290
    local v291 = Instance.new("Frame")
    local v1503 = 0
    v291.Size = UDim2.new(1, v1503, v1503, v1503)
    local v1429 = 0
    v291.Position = UDim2.new(v1429, v1429, v1429, 32)
    v291.BackgroundTransparency = 1
    v291.Visible = false
    local v1505 = Enum
    v291.AutomaticSize = v1505.AutomaticSize.Y
    v291.Parent = v1349
    local v1536 = Instance.new("UIListLayout")
    v1536.SortOrder = v1505.SortOrder.LayoutOrder
    v1536.Padding = UDim.new(0, 4)
    v1536.Parent = v291
    local v292 = false
    v1327.MouseButton1Click:Connect(function()
        v292 = not v292
        local v909 = v292
        v291.Visible = v909
        if v909 then
            v909 = "▼"
        end
        if not v909 then
            v909 = "▲"
        end
        v290.Text = v909
        return
    end)
    local v1511 = 1
    local v1542 = 10
    local v1307 = v1511
    if not (v1542 ~= v1542 or (v1307 > 0 and v1511 > v1542 or (v1307 <= 0 or v1307 ~= v1307) and v1511 < v1542)) then
        repeat
            local v293 = v1511
            local v1351 = Instance.new("Frame")
            local v1399 = 0
            v1351.Size = UDim2.new(1, v1399, v1399, 28)
            v1351.BackgroundTransparency = 1
            v1351.Parent = v291
            local v1188 = Instance.new("TextLabel")
            local v1401 = 1
            v1188.Size = UDim2.new(v1401, -34, v1401, 0)
            local v1403 = 0
            v1188.Position = UDim2.new(v1403, 10, v1403, v1403)
            v1188.BackgroundTransparency = 1
            v1188.Font = Enum.Font.LuckiestGuy
            local v1406 = 220
            v1188.TextColor3 = Color3.fromRGB(v1406, v1406, v1406)
            v1188.TextSize = 13
            v1188.TextXAlignment = Enum.TextXAlignment.Left
            v1188.Text = "Auto Steal All"
            v1188.Parent = v1351
            local v294 = Instance.new("TextButton")
            local v1376 = 20
            local v1609 = 0
            v294.Size = UDim2.new(v1609, v1376, v1609, v1376)
            v294.Position = UDim2.new(1, -22, 0.5, -10)
            local v1378 = 40
            v294.BackgroundColor3 = Color3.fromRGB(220, v1378, v1378)
            v294.Text = ""
            v294.Parent = v1351
            local v1419 = Instance.new("UICorner")
            v1419.CornerRadius = UDim.new(0, 4)
            v1419.Parent = v294
            local v295 = false
            v294.MouseButton1Click:Connect(function()
                v295 = not v295
                local v916 = v295
                if v916 then
                    local v924 = 40
                    v916 = Color3.fromRGB(v924, 220, v924)
                end
                if not v916 then
                    local v929 = 40
                    v916 = Color3.fromRGB(220, v929, v929)
                end
                v294.BackgroundColor3 = v916
                v289(v293, v295)
                return
            end)
            v1511 = v1511 + v1307
        until (v1307 > 0 and v1511 > v1542 or v1307 <= 0 and v1511 < v1542 or v1307 ~= v1307)
    end
    v1303("UPGRADE LUCK", function(v130)
        if v130 then
            _G.LuckRunning = true
            task.spawn(function()
                local v142 = v280:WaitForChild("Remotes"):WaitForChild("LuckMachine"):WaitForChild("Upgrade", 5)
                while true do
                    local v951 = _G.LuckRunning
                    if v951 then v951 = v142 end
                    if not v951 then break end
                    pcall(function() v142:InvokeServer("One") end)
                    task.wait(0.4)
                end
            end)
        else _G.LuckRunning = false end
    end)
    v1303("2X TRAIN", function(v143)
        if v143 then
            _G.TrainRunning = true
            task.spawn(function()
                local v1001, v999 = pcall(function() return require(v280:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Remotes")) end)
                if v1001 and v999 then
                    local v167 = v999.Get("Treadmill", "Boost")
                    local v987 = v167:Connect(function(v155)
                        if _G.TrainRunning then pcall(function() v167:Fire(v155) end) end
                    end)
                    while _G.TrainRunning do task.wait(1) end
                    if v987 then v987:Disconnect() end
                end
            end)
        else _G.TrainRunning = false end
    end)
    v1303("AUTO REBIRTH", function(v168)
        if v168 then
            _G.RebirthRunning = true
            task.spawn(function()
                local v1063, v1061 = pcall(function() return require(v280:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Remotes")) end)
                local v1065, v1059 = pcall(function() return require(v280:WaitForChild("Shared"):WaitForChild("Configs"):WaitForChild("RebirthConfig")) end)
                if v1063 and v1065 and v1061 and v1059 then
                    while _G.RebirthRunning do
                        pcall(function()
                            local v1047 = v1059
                            v1061.Get(v1047.Remote.Namespace, v1047.Remote.Request):Invoke()
                        end)
                        task.wait(1)
                    end
                end
            end)
        else _G.RebirthRunning = false end
    end)
    v1303("SELL ALL", function(v193)
        if v193 then
            _G.SellRunning = true
            task.spawn(function()
                local v219 = v280:WaitForChild("Remotes"):WaitForChild("Economy"):WaitForChild("SellItems", 5)
                while true do
                    if not _G.SellRunning then break end
                    local v220 = {}
                    local v1101 = {
                        v282:FindFirstChild("Backpack"),
                        v282:FindFirstChild("Inventory"),
                        v282:FindFirstChild("Characters"),
                        v282:FindFirstChild("Units"),
                        v282:FindFirstChild("Storage")
                    }
                    for _, v1139 in ipairs(v1101) do
                        if v1139 then
                            for _, v1118 in ipairs(v1139:GetChildren()) do
                                local v1142 = v1118:GetAttribute("PackId") or (v1118:FindFirstChild("PackId") and v1118.PackId.Value)
                                if v1142 then table.insert(v220, tostring(v1142)) end
                            end
                        end
                    end
                    if #v220 > 0 then pcall(function() v219:InvokeServer(v220) end) end
                    task.wait(0.4)
                end
            end)
        else _G.SellRunning = false end
    end)
    
    v1303("XY POSITION (Auto TP)", function(v194)
        _G.XYPosEnabled = v194
    end)
    
    return
end)
return
