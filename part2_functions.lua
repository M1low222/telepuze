-- === NAVIGATION SYSTEM v5.0 - PART 2: FUNCTIONS ===
-- Загрузите ПОСЛЕ Part 1!

print("=== Loading Navigation System: Part 2/4 ===")

-- Проверяем, загружена ли конфигурация
if not _G.NAV_SYSTEM then
    error("ERROR: Part 1 not loaded! Please load part1_config.lua first")
    return
end

local NAV = _G.NAV_SYSTEM

-- 1. Проверка персонажа
function NAV.isCharacterValid()
    if not NAV.character or not NAV.character.Parent then
        return false
    end
    
    if not NAV.humanoidRootPart or not NAV.humanoidRootPart.Parent then
        return false
    end
    
    if not NAV.humanoid or not NAV.humanoid.Parent then
        return false
    end
    
    return true
end

-- 2. Рестарт скрипта
function NAV.restartScript()
    print("=== ПЕРЕЗАГРУЗКА СКРИПТА ===")
    
    if NAV.isBaseFlightActive and NAV.currentBaseFlightTween then
        NAV.currentBaseFlightTween:Cancel()
        NAV.isBaseFlightActive = false
    end
    
    if NAV.baseFlightPart and NAV.baseFlightPart.Parent then
        NAV.baseFlightPart:Destroy()
        NAV.baseFlightPart = nil
    end
    
    if NAV.baseFlightConnection then
        NAV.baseFlightConnection:Disconnect()
        NAV.baseFlightConnection = nil
    end
    
    if NAV.ScreenGui and NAV.ScreenGui.Parent then
        NAV.ScreenGui:Destroy()
        NAV.ScreenGui = nil
    end
    
    NAV.character = nil
    NAV.humanoidRootPart = nil
    NAV.humanoid = nil
    NAV.characterLoaded = false
    NAV.isNoclip = false
    NAV.isGapping = false
    NAV.isBaseFlying = false
    NAV.isBaseFlightActive = false
    NAV.currentBaseFlightTween = nil
    NAV.currentTargetIndex = 1
    NAV.flySpeed = 100
    NAV.baseFlySpeed = 150
    
    task.wait(0.5)
    print("Перезагрузка завершена!")
end

-- 3. Создание платформы
function NAV.createBaseFlightPlatform()
    if not NAV.isCharacterValid() then 
        print("Персонаж не валиден для создания платформы")
        return nil
    end
    
    if NAV.baseFlightPart and NAV.baseFlightPart.Parent then
        NAV.baseFlightPart:Destroy()
        NAV.baseFlightPart = nil
    end
    
    NAV.baseFlightPart = Instance.new("Part")
    NAV.baseFlightPart.Name = "BaseFlightPlatform"
    NAV.baseFlightPart.Size = Vector3.new(15, 1, 15)
    NAV.baseFlightPart.Position = NAV.humanoidRootPart.Position - Vector3.new(0, 3.5, 0)
    NAV.baseFlightPart.Anchored = true
    NAV.baseFlightPart.CanCollide = false
    NAV.baseFlightPart.Transparency = 0.3
    NAV.baseFlightPart.Color = Color3.fromRGB(0, 150, 255)
    NAV.baseFlightPart.Material = Enum.Material.Neon
    
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 20
    pointLight.Color = Color3.fromRGB(0, 150, 255)
    pointLight.Parent = NAV.baseFlightPart
    
    NAV.baseFlightPart.Parent = workspace
    return NAV.baseFlightPart
end

-- 4. Обновление платформы
function NAV.updateBaseFlightPlatform()
    if not NAV.baseFlightPart or not NAV.baseFlightPart.Parent then return end
    if not NAV.isCharacterValid() then return end
    NAV.baseFlightPart.Position = NAV.humanoidRootPart.Position - Vector3.new(0, 3.5, 0)
end

-- 5. Noclip
function NAV.setNoclip(state)
    if not NAV.isCharacterValid() then
        print("Не могу установить noclip: персонаж не валиден")
        return
    end
    
    if state then
        NAV.originalCollision = {}
        for _, part in pairs(NAV.character:GetDescendants()) do
            if part:IsA("BasePart") then
                NAV.originalCollision[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        NAV.isNoclip = true
        print("Noclip ВКЛЮЧЕН")
    else
        for part, canCollide in pairs(NAV.originalCollision) do
            if part and part.Parent then
                pcall(function()
                    part.CanCollide = canCollide
                end)
            end
        end
        NAV.isNoclip = false
        NAV.originalCollision = {}
        print("Noclip ВЫКЛЮЧЕН")
    end
end

-- 6. Найти ближайшую точку
function NAV.findNearestPoint()
    if not NAV.isCharacterValid() then
        return 1
    end
    
    local playerPos = NAV.humanoidRootPart.Position
    local nearestIndex = 1
    local nearestDistance = math.huge
    
    for i, point in ipairs(NAV.coordinateSystem) do
        local distance = (playerPos - point.position).Magnitude
        if distance < nearestDistance then
            nearestDistance = distance
            nearestIndex = i
        end
    end
    
    return nearestIndex
end

-- 7. Получить текущую точку
function NAV.getCurrentPointIndex()
    if not NAV.isCharacterValid() then
        return nil
    end
    
    local playerPos = NAV.humanoidRootPart.Position
    local threshold = 15
    
    for i, point in ipairs(NAV.coordinateSystem) do
        local distance = (playerPos - point.position).Magnitude
        if distance <= threshold then
            return i
        end
    end
    
    return nil
end

-- 8. Получить текущую цель
function NAV.getCurrentTarget()
    return NAV.coordinateSystem[NAV.currentTargetIndex]
end

-- 9. Остановить полет на базу
function NAV.stopBaseFlight()
    if not NAV.isBaseFlightActive then
        return
    end
    
    print("=== ОСТАНОВКА ПОЛЕТА НА БАЗУ ===")
    
    if NAV.currentBaseFlightTween then
        NAV.currentBaseFlightTween:Cancel()
        NAV.currentBaseFlightTween = nil
    end
    
    if NAV.baseFlightConnection then
        NAV.baseFlightConnection:Disconnect()
        NAV.baseFlightConnection = nil
    end
    
    NAV.isBaseFlightActive = false
    NAV.isBaseFlying = false
    
    if NAV.baseFlightPart and NAV.baseFlightPart.Parent then
        NAV.baseFlightPart:Destroy()
        NAV.baseFlightPart = nil
    end
    
    NAV.setNoclip(false)
    
    if NAV.BaseButton then
        NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        NAV.BaseButton.Text = "GO BASE"
    end
    
    if NAV.BaseStatusLabel then
        NAV.BaseStatusLabel.Text = "Полет остановлен"
        NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    end
    
    print("Полет остановлен")
end

-- 10. Полетеить на базу
function NAV.flyToBase()
    print("=== НАЖАТА КНОПКА GO BASE ===")
    
    if NAV.isBaseFlightActive then
        NAV.stopBaseFlight()
        return
    end
    
    if not NAV.isCharacterValid() then
        print("Не могу лететь на базу: персонаж не валиден")
        if NAV.PositionIndicator then
            NAV.PositionIndicator.Text = "ПЕРСОНАЖ НЕ ЗАГРУЖЕН"
            NAV.PositionIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    print("=== ЗАПУСК ПОЛЕТА НА БАЗУ ===")
    
    NAV.setNoclip(true)
    NAV.createBaseFlightPlatform()
    
    local startPosition = NAV.humanoidRootPart.Position
    local direction = (NAV.basePosition - startPosition)
    local distance = direction.Magnitude
    
    if distance < 5 then
        print("Уже на базе!")
        if NAV.BaseStatusLabel then
            NAV.BaseStatusLabel.Text = "✓ УЖЕ НА БАЗЕ!"
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        return
    end
    
    NAV.isBaseFlightActive = true
    NAV.isBaseFlying = true
    
    if NAV.BaseButton then
        NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        NAV.BaseButton.Text = "СТОП ПОЛЕТ"
    end
    
    if NAV.BaseStatusLabel then
        NAV.BaseStatusLabel.Text = "Полет на базу..."
        NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
    
    local travelTime = distance / NAV.baseFlySpeed
    
    local tweenInfo = TweenInfo.new(
        travelTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local goal = {CFrame = CFrame.new(NAV.basePosition)}
    NAV.currentBaseFlightTween = NAV.TweenService:Create(NAV.humanoidRootPart, tweenInfo, goal)
    NAV.currentBaseFlightTween:Play()
    
    NAV.baseFlightConnection = NAV.RunService.Heartbeat:Connect(function()
        if not NAV.isBaseFlightActive or not NAV.isCharacterValid() then
            if NAV.baseFlightConnection then
                NAV.baseFlightConnection:Disconnect()
                NAV.baseFlightConnection = nil
            end
            return
        end
        
        NAV.updateBaseFlightPlatform()
        
        if NAV.BaseStatusLabel then
            local currentPos = NAV.humanoidRootPart.Position
            local remaining = (NAV.basePosition - currentPos).Magnitude
            NAV.BaseStatusLabel.Text = string.format("Полет... Осталось: %dм", math.floor(remaining))
        end
    end)
    
    NAV.currentBaseFlightTween.Completed:Connect(function()
        if not NAV.isBaseFlightActive then return end
        
        print("=== ДОСТИГНУТА БАЗА! ===")
        
        if NAV.baseFlightPart and NAV.baseFlightPart.Parent then
            NAV.baseFlightPart:Destroy()
            NAV.baseFlightPart = nil
        end
        
        NAV.isBaseFlightActive = false
        NAV.isBaseFlying = false
        NAV.setNoclip(false)
        
        if NAV.BaseStatusLabel then
            NAV.BaseStatusLabel.Text = "✓ БАЗА ДОСТИГНУТА!"
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        if NAV.BaseButton then
            NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            NAV.BaseButton.Text = "GO BASE"
        end
        
        task.wait(2)
        
        if NAV.BaseStatusLabel then
            NAV.BaseStatusLabel.Text = "База: X:112 Y:4 Z:10"
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
        end
    end)
    
    print("=== ПОЛЕТ ЗАПУЩЕН ===")
end

-- 11. Обновить отображение скорости
function NAV.updateBaseSpeedDisplay()
    if NAV.BaseSpeedValueLabel then
        NAV.BaseSpeedValueLabel.Text = string.format("Скорость полета: %d", NAV.baseFlySpeed)
    end
    
    if NAV.BaseSpeedSlider then
        local SliderFill = NAV.BaseSpeedSlider:FindFirstChild("SliderFill")
        local SliderButton = NAV.BaseSpeedSlider:FindFirstChild("SliderButton")
        
        if SliderFill and SliderButton then
            local percent = (NAV.baseFlySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -12.5, 0.5, -12.5)
        end
    end
end

-- 12. Установить клавишу
function NAV.setKeybind(key)
    NAV.currentKeybind = key
    
    if NAV.KeybindButton then
        NAV.KeybindButton.Text = string.format("ГОРЯЧАЯ КЛАВИША: %s", tostring(key):gsub("Enum.KeyCode.", ""))
    end
    
    print("Установлена горячая клавиша:", tostring(key))
end

-- 13. Обновить GUI
function NAV.updateGUI()
    if NAV.PositionIndicator then
        if NAV.isCharacterValid() then
            local currentPoint = NAV.getCurrentPointIndex()
            if currentPoint then
                NAV.PositionIndicator.Text = string.format("На точке %d/%d", currentPoint, #NAV.coordinateSystem)
                NAV.PositionIndicator.TextColor3 = NAV.coordinateSystem[currentPoint].color
            else
                NAV.PositionIndicator.Text = "Между точками"
                NAV.PositionIndicator.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        else
            NAV.PositionIndicator.Text = "ПЕРСОНАЖ НЕ ЗАГРУЖЕН"
            NAV.PositionIndicator.TextColor3 = Color3.fromRGB(255, 150, 150)
        end
    end
    
    if NAV.TargetLabel then
        if NAV.isCharacterValid() then
            local target = NAV.getCurrentTarget()
            local currentPoint = NAV.getCurrentPointIndex()
            
            if currentPoint then
                NAV.TargetLabel.Text = string.format("Точка %d/%d → Точка %d", 
                    currentPoint, #NAV.coordinateSystem, NAV.currentTargetIndex)
            else
                NAV.TargetLabel.Text = string.format("→ Точка %d/%d", NAV.currentTargetIndex, #NAV.coordinateSystem)
            end
            
            NAV.TargetLabel.TextColor3 = target.color
        else
            NAV.TargetLabel.Text = "Ожидание персонажа..."
            NAV.TargetLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        end
    end
    
    if NAV.NavigationInfo then
        if NAV.isCharacterValid() then
            local currentPoint = NAV.getCurrentPointIndex()
            if currentPoint then
                if currentPoint == NAV.currentTargetIndex then
                    NAV.NavigationInfo.Text = "✓ На целевой точке"
                    NAV.NavigationInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    local distanceToTarget = NAV.currentTargetIndex - currentPoint
                    if distanceToTarget > 0 then
                        NAV.NavigationInfo.Text = string.format("Впереди на %d точки", distanceToTarget)
                        NAV.NavigationInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
                    else
                        NAV.NavigationInfo.Text = string.format("Позади на %d точки", math.abs(distanceToTarget))
                        NAV.NavigationInfo.TextColor3 = Color3.fromRGB(255, 150, 100)
                    end
                end
            else
                NAV.NavigationInfo.Text = "Между точками"
                NAV.NavigationInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        else
            NAV.NavigationInfo.Text = "Персонаж не загружен"
            NAV.NavigationInfo.TextColor3 = Color3.fromRGB(255, 150, 150)
        end
    end
    
    if NAV.DistanceLabel then
        if NAV.isCharacterValid() then
            local target = NAV.getCurrentTarget()
            local distance = (NAV.humanoidRootPart.Position - target.position).Magnitude
            NAV.DistanceLabel.Text = string.format("Дистанция: %.1f м", distance)
            
            if distance <= 15 then
                NAV.DistanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                NAV.DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        else
            NAV.DistanceLabel.Text = "Дистанция: -"
            NAV.DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    if NAV.SpeedValueLabel then
        NAV.SpeedValueLabel.Text = string.format("Скорость телепортации: %d", NAV.flySpeed)
    end
    
    NAV.updateBaseSpeedDisplay()
    
    if NAV.SpeedSlider then
        local percent = (NAV.flySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed)
        local SliderFill = NAV.SpeedSlider:FindFirstChild("SliderFill")
        local SliderButton = NAV.SpeedSlider:FindFirstChild("SliderButton")
        
        if SliderFill then
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
        
        if SliderButton then
            SliderButton.Position = UDim2.new(percent, -12.5, 0.5, -12.5)
        end
    end
    
    if NAV.BaseButton then
        if NAV.isBaseFlightActive then
            NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            NAV.BaseButton.Text = "СТОП ПОЛЕТ"
        else
            NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            NAV.BaseButton.Text = "GO BASE"
        end
    end
    
    if NAV.BaseStatusLabel then
        if NAV.isBaseFlightActive then
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        elseif not NAV.isCharacterValid() then
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        else
            NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
        end
    end
end

-- 14. Плавная телепортация
function NAV.smoothTeleportToTarget(targetPosition)
    if not NAV.isCharacterValid() then
        print("Не могу телепортировать: персонаж не валиден")
        return false
    end
    
    local wasNoclip = NAV.isNoclip
    
    if not wasNoclip then
        NAV.setNoclip(true)
    end
    
    local distance = (NAV.humanoidRootPart.Position - targetPosition).Magnitude
    local travelTime = math.min(distance / NAV.flySpeed, 5)
    
    local tweenInfo = TweenInfo.new(
        travelTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local goal = {CFrame = CFrame.new(targetPosition)}
    local tween = NAV.TweenService:Create(NAV.humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
    
    if not wasNoclip then
        task.wait(0.3)
        NAV.setNoclip(false)
    end
    
    return true
end

-- 15. Gap Up
function NAV.gapUp()
    if NAV.isGapping then 
        print("Телепортация уже идет!")
        return 
    end
    
    if NAV.isBaseFlightActive then
        print("Сначала остановите полет на базу!")
        return
    end
    
    if not NAV.isCharacterValid() then
        print("Не могу телепортировать: персонаж не валиден")
        if NAV.PositionIndicator then
            NAV.PositionIndicator.Text = "ПЕРСОНАЖ НЕ ЗАГРУЖЕН"
            NAV.PositionIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    NAV.isGapping = true
    print("=== ЗАПУСК GAP UP ===")
    
    local currentPoint = NAV.getCurrentPointIndex()
    print("Текущая точка:", currentPoint or "между точками")
    
    if currentPoint then
        if currentPoint < #NAV.coordinateSystem then
            NAV.currentTargetIndex = currentPoint + 1
        else
            NAV.currentTargetIndex = 1
        end
    else
        local nearestIndex = NAV.findNearestPoint()
        if nearestIndex < #NAV.coordinateSystem then
            NAV.currentTargetIndex = nearestIndex + 1
        else
            NAV.currentTargetIndex = 1
        end
    end
    
    print("Новая целевая точка:", NAV.currentTargetIndex)
    local target = NAV.getCurrentTarget()
    print("Целевая позиция:", target.position)
    
    NAV.setNoclip(true)
    
    local currentPosition = NAV.humanoidRootPart.Position
    local elevatedPosition = Vector3.new(
        currentPosition.X,
        currentPosition.Y + NAV.gapHeight,
        currentPosition.Z
    )
    
    print("Поднимаем на " .. NAV.gapHeight .. " метров...")
    
    local liftTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local liftGoal = {CFrame = CFrame.new(elevatedPosition)}
    local liftTween = NAV.TweenService:Create(NAV.humanoidRootPart, liftTweenInfo, liftGoal)
    liftTween:Play()
    liftTween.Completed:Wait()
    
    local success = NAV.smoothTeleportToTarget(target.position)
    NAV.updateGUI()
    
    if success then
        task.wait(0.3)
        NAV.setNoclip(false)
    end
    
    NAV.isGapping = false
    print("=== GAP UP ЗАВЕРШЕН ===")
end

-- 16. Gap Down
function NAV.gapDown()
    if NAV.isGapping then 
        print("Телепортация уже идет!")
        return 
    end
    
    if NAV.isBaseFlightActive then
        print("Сначала остановите полет на базу!")
        return
    end
    
    if not NAV.isCharacterValid() then
        print("Не могу телепортировать: персонаж не валиден")
        if NAV.PositionIndicator then
            NAV.PositionIndicator.Text = "ПЕРСОНАЖ НЕ ЗАГРУЖЕН"
            NAV.PositionIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    NAV.isGapping = true
    print("=== ЗАПУСК GAP DOWN ===")
    
    local currentPoint = NAV.getCurrentPointIndex()
    print("Текущая точка:", currentPoint or "между точками")
    
    if currentPoint then
        if currentPoint > 1 then
            NAV.currentTargetIndex = currentPoint - 1
        else
            NAV.currentTargetIndex = #NAV.coordinateSystem
        end
    else
        local nearestIndex = NAV.findNearestPoint()
        if nearestIndex > 1 then
            NAV.currentTargetIndex = nearestIndex - 1
        else
            NAV.currentTargetIndex = #NAV.coordinateSystem
        end
    end
    
    print("Новая целевая точка:", NAV.currentTargetIndex)
    local target = NAV.getCurrentTarget()
    print("Целевая позиция:", target.position)
    
    NAV.setNoclip(true)
    
    local currentPosition = NAV.humanoidRootPart.Position
    local loweredPosition = Vector3.new(
        currentPosition.X,
        currentPosition.Y - NAV.gapHeight,
        currentPosition.Z
    )
    
    print("Опускаем на " .. NAV.gapHeight .. " метров...")
    
    local lowerTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local lowerGoal = {CFrame = CFrame.new(loweredPosition)}
    local lowerTween = NAV.TweenService:Create(NAV.humanoidRootPart, lowerTweenInfo, lowerGoal)
    lowerTween:Play()
    lowerTween.Completed:Wait()
    
    local success = NAV.smoothTeleportToTarget(target.position)
    NAV.updateGUI()
    
    if success then
        task.wait(0.3)
        NAV.setNoclip(false)
    end
    
    NAV.isGapping = false
    print("=== GAP DOWN ЗАВЕРШЕН ===")
end

-- 17. Загрузить персонажа
function NAV.loadCharacter(newCharacter)
    print("Загрузка нового персонажа...")
    
    task.wait(0.5)
    
    if not newCharacter or not newCharacter.Parent then
        print("Ошибка: персонаж не существует")
        NAV.characterLoaded = false
        NAV.updateGUI()
        return
    end
    
    local hrp = newCharacter:FindFirstChild("HumanoidRootPart")
    local hum = newCharacter:FindFirstChild("Humanoid")
    
    if not hrp or not hum then
        task.wait(0.5)
        hrp = newCharacter:WaitForChild("HumanoidRootPart", 1)
        hum = newCharacter:WaitForChild("Humanoid", 1)
        
        if not hrp or not hum then
            print("Ошибка: так и не найдены части персонажа")
            NAV.characterLoaded = false
            NAV.updateGUI()
            return
        end
    end
    
    NAV.character = newCharacter
    NAV.humanoidRootPart = hrp
    NAV.humanoid = hum
    NAV.characterLoaded = true
    
    print("Персонаж успешно загружен!")
    NAV.currentTargetIndex = NAV.findNearestPoint()
    print("Ближайшая точка:", NAV.currentTargetIndex)
    NAV.updateGUI()
end

print("✓ Functions loaded successfully!")
return NAV
