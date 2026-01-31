-- === NAVIGATION SYSTEM v5.0 - PART 3: GUI CREATION ===
-- Загрузите ПОСЛЕ Part 1 и Part 2!

print("=== Loading Navigation System: Part 3/4 ===")

-- Проверяем, загружены ли предыдущие части
if not _G.NAV_SYSTEM then
    error("ERROR: Part 1 not loaded! Please load in order: 1 → 2 → 3 → 4")
    return
end

if not _G.NAV_SYSTEM.isCharacterValid then
    error("ERROR: Part 2 not loaded! Please load parts in correct order")
    return
end

local NAV = _G.NAV_SYSTEM

-- Функция создания GUI
function NAV.createGUI()
    print("Creating GUI...")
    
    -- Удаляем старое GUI если существует
    if NAV.ScreenGui and NAV.ScreenGui.Parent then
        NAV.ScreenGui:Destroy()
        NAV.ScreenGui = nil
    end
    
    NAV.ScreenGui = Instance.new("ScreenGui")
    NAV.ScreenGui.Name = "NavigationGUI"
    NAV.ScreenGui.Parent = NAV.player:WaitForChild("PlayerGui")
    NAV.ScreenGui.ResetOnSpawn = false

    -- Основной фрейм
    NAV.Frame = Instance.new("Frame")
    NAV.Frame.Name = "MainFrame"
    NAV.Frame.Size = UDim2.new(0, 400, 0, 480)
    NAV.Frame.Position = UDim2.new(0, 10, 0, 10)
    NAV.Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NAV.Frame.BackgroundTransparency = 0.2
    NAV.Frame.BorderSizePixel = 2
    NAV.Frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    NAV.Frame.Parent = NAV.ScreenGui

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BackgroundTransparency = 0.5
    Title.Text = "NAVIGATION v5.0"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = NAV.Frame

    -- Индикатор позиции
    NAV.PositionIndicator = Instance.new("TextLabel")
    NAV.PositionIndicator.Name = "PositionIndicator"
    NAV.PositionIndicator.Size = UDim2.new(0.9, 0, 0, 25)
    NAV.PositionIndicator.Position = UDim2.new(0.05, 0, 0.1, 0)
    NAV.PositionIndicator.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    NAV.PositionIndicator.BackgroundTransparency = 0.5
    NAV.PositionIndicator.Text = "Определение позиции..."
    NAV.PositionIndicator.TextColor3 = Color3.fromRGB(200, 200, 255)
    NAV.PositionIndicator.TextSize = 14
    NAV.PositionIndicator.Font = Enum.Font.GothamMedium
    NAV.PositionIndicator.TextXAlignment = Enum.TextXAlignment.Center
    NAV.PositionIndicator.Parent = NAV.Frame

    local PosCorner = Instance.new("UICorner")
    PosCorner.CornerRadius = UDim.new(0, 6)
    PosCorner.Parent = NAV.PositionIndicator

    -- Кнопка Gap Up
    NAV.GapUpButton = Instance.new("TextButton")
    NAV.GapUpButton.Name = "GapUpButton"
    NAV.GapUpButton.Size = UDim2.new(0.8, 0, 0, 35)
    NAV.GapUpButton.Position = UDim2.new(0.1, 0, 0.18, 0)
    NAV.GapUpButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    NAV.GapUpButton.BackgroundTransparency = 0.2
    NAV.GapUpButton.BorderSizePixel = 0
    NAV.GapUpButton.Text = "→ СЛЕДУЮЩАЯ"
    NAV.GapUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NAV.GapUpButton.TextSize = 14
    NAV.GapUpButton.Font = Enum.Font.GothamBold
    NAV.GapUpButton.Parent = NAV.Frame

    local GapUpCorner = Instance.new("UICorner")
    GapUpCorner.CornerRadius = UDim.new(0, 8)
    GapUpCorner.Parent = NAV.GapUpButton

    local GapUpStroke = Instance.new("UIStroke")
    GapUpStroke.Color = Color3.fromRGB(100, 255, 100)
    GapUpStroke.Thickness = 2
    GapUpStroke.Parent = NAV.GapUpButton

    -- Кнопка Gap Down
    NAV.GapDownButton = Instance.new("TextButton")
    NAV.GapDownButton.Name = "GapDownButton"
    NAV.GapDownButton.Size = UDim2.new(0.8, 0, 0, 35)
    NAV.GapDownButton.Position = UDim2.new(0.1, 0, 0.26, 0)
    NAV.GapDownButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    NAV.GapDownButton.BackgroundTransparency = 0.2
    NAV.GapDownButton.BorderSizePixel = 0
    NAV.GapDownButton.Text = "← ПРЕДЫДУЩАЯ"
    NAV.GapDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NAV.GapDownButton.TextSize = 14
    NAV.GapDownButton.Font = Enum.Font.GothamBold
    NAV.GapDownButton.Parent = NAV.Frame

    local GapDownCorner = Instance.new("UICorner")
    GapDownCorner.CornerRadius = UDim.new(0, 8)
    GapDownCorner.Parent = NAV.GapDownButton

    local GapDownStroke = Instance.new("UIStroke")
    GapDownStroke.Color = Color3.fromRGB(255, 100, 100)
    GapDownStroke.Thickness = 2
    GapDownStroke.Parent = NAV.GapDownButton

    -- Кнопка GO BASE
    NAV.BaseButton = Instance.new("TextButton")
    NAV.BaseButton.Name = "BaseButton"
    NAV.BaseButton.Size = UDim2.new(0.8, 0, 0, 40)
    NAV.BaseButton.Position = UDim2.new(0.1, 0, 0.36, 0)
    NAV.BaseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    NAV.BaseButton.BackgroundTransparency = 0.2
    NAV.BaseButton.BorderSizePixel = 0
    NAV.BaseButton.Text = "GO BASE"
    NAV.BaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NAV.BaseButton.TextSize = 16
    NAV.BaseButton.Font = Enum.Font.GothamBold
    NAV.BaseButton.Parent = NAV.Frame

    local BaseCorner = Instance.new("UICorner")
    BaseCorner.CornerRadius = UDim.new(0, 8)
    BaseCorner.Parent = NAV.BaseButton

    local BaseStroke = Instance.new("UIStroke")
    BaseStroke.Color = Color3.fromRGB(150, 150, 255)
    BaseStroke.Thickness = 2
    BaseStroke.Parent = NAV.BaseButton

    -- Статус базы
    NAV.BaseStatusLabel = Instance.new("TextLabel")
    NAV.BaseStatusLabel.Name = "BaseStatusLabel"
    NAV.BaseStatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
    NAV.BaseStatusLabel.Position = UDim2.new(0.1, 0, 0.46, 0)
    NAV.BaseStatusLabel.BackgroundTransparency = 1
    NAV.BaseStatusLabel.Text = "База: X:112 Y:4 Z:10"
    NAV.BaseStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
    NAV.BaseStatusLabel.TextSize = 14
    NAV.BaseStatusLabel.Font = Enum.Font.GothamMedium
    NAV.BaseStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    NAV.BaseStatusLabel.Parent = NAV.Frame

    -- Настройка скорости телепортации
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Name = "SpeedFrame"
    SpeedFrame.Size = UDim2.new(0.9, 0, 0, 60)
    SpeedFrame.Position = UDim2.new(0.05, 0, 0.54, 0)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SpeedFrame.BackgroundTransparency = 0.3
    SpeedFrame.BorderSizePixel = 0
    SpeedFrame.Parent = NAV.Frame

    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.CornerRadius = UDim.new(0, 8)
    SpeedCorner.Parent = SpeedFrame

    local SpeedTitle = Instance.new("TextLabel")
    SpeedTitle.Name = "SpeedTitle"
    SpeedTitle.Size = UDim2.new(1, 0, 0, 20)
    SpeedTitle.Position = UDim2.new(0, 0, 0, 0)
    SpeedTitle.BackgroundTransparency = 1
    SpeedTitle.Text = "СКОРОСТЬ ТЕЛЕПОРТАЦИИ"
    SpeedTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    SpeedTitle.TextSize = 14
    SpeedTitle.Font = Enum.Font.GothamMedium
    SpeedTitle.TextXAlignment = Enum.TextXAlignment.Center
    SpeedTitle.Parent = SpeedFrame

    NAV.SpeedValueLabel = Instance.new("TextLabel")
    NAV.SpeedValueLabel.Name = "SpeedValueLabel"
    NAV.SpeedValueLabel.Size = UDim2.new(1, 0, 0, 20)
    NAV.SpeedValueLabel.Position = UDim2.new(0, 0, 0.35, 0)
    NAV.SpeedValueLabel.BackgroundTransparency = 1
    NAV.SpeedValueLabel.Text = "Скорость телепортации: " .. NAV.flySpeed
    NAV.SpeedValueLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
    NAV.SpeedValueLabel.TextSize = 14
    NAV.SpeedValueLabel.Font = Enum.Font.GothamBold
    NAV.SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    NAV.SpeedValueLabel.Parent = SpeedFrame

    -- Слайдер скорости телепортации
    NAV.SpeedSlider = Instance.new("Frame")
    NAV.SpeedSlider.Name = "SpeedSlider"
    NAV.SpeedSlider.Size = UDim2.new(0.85, 0, 0, 15)
    NAV.SpeedSlider.Position = UDim2.new(0.075, 0, 0.7, 0)
    NAV.SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    NAV.SpeedSlider.BorderSizePixel = 0
    NAV.SpeedSlider.Parent = SpeedFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = NAV.SpeedSlider

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((NAV.flySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 255, 200)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = NAV.SpeedSlider

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 10)
    FillCorner.Parent = SliderFill

    NAV.SliderButton = Instance.new("TextButton")
    NAV.SliderButton.Name = "SliderButton"
    NAV.SliderButton.Size = UDim2.new(0, 25, 0, 25)
    NAV.SliderButton.Position = UDim2.new((NAV.flySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed), -12.5, 0.5, -12.5)
    NAV.SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NAV.SliderButton.Text = ""
    NAV.SliderButton.AutoButtonColor = false
    NAV.SliderButton.Parent = NAV.SpeedSlider

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = NAV.SliderButton

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(200, 200, 200)
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = NAV.SliderButton

    -- Настройка скорости полета на базу
    local BaseSpeedFrame = Instance.new("Frame")
    BaseSpeedFrame.Name = "BaseSpeedFrame"
    BaseSpeedFrame.Size = UDim2.new(0.9, 0, 0, 60)
    BaseSpeedFrame.Position = UDim2.new(0.05, 0, 0.68, 0)
    BaseSpeedFrame.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
    BaseSpeedFrame.BackgroundTransparency = 0.3
    BaseSpeedFrame.BorderSizePixel = 0
    BaseSpeedFrame.Parent = NAV.Frame

    local BaseSpeedCorner = Instance.new("UICorner")
    BaseSpeedCorner.CornerRadius = UDim.new(0, 8)
    BaseSpeedCorner.Parent = BaseSpeedFrame

    local BaseSpeedTitle = Instance.new("TextLabel")
    BaseSpeedTitle.Name = "BaseSpeedTitle"
    BaseSpeedTitle.Size = UDim2.new(1, 0, 0, 20)
    BaseSpeedTitle.Position = UDim2.new(0, 0, 0, 0)
    BaseSpeedTitle.BackgroundTransparency = 1
    BaseSpeedTitle.Text = "СКОРОСТЬ ПОЛЕТА НА БАЗУ"
    BaseSpeedTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    BaseSpeedTitle.TextSize = 14
    BaseSpeedTitle.Font = Enum.Font.GothamMedium
    BaseSpeedTitle.TextXAlignment = Enum.TextXAlignment.Center
    BaseSpeedTitle.Parent = BaseSpeedFrame

    NAV.BaseSpeedValueLabel = Instance.new("TextLabel")
    NAV.BaseSpeedValueLabel.Name = "BaseSpeedValueLabel"
    NAV.BaseSpeedValueLabel.Size = UDim2.new(1, 0, 0, 20)
    NAV.BaseSpeedValueLabel.Position = UDim2.new(0, 0, 0.35, 0)
    NAV.BaseSpeedValueLabel.BackgroundTransparency = 1
    NAV.BaseSpeedValueLabel.Text = "Скорость полета: " .. NAV.baseFlySpeed
    NAV.BaseSpeedValueLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    NAV.BaseSpeedValueLabel.TextSize = 14
    NAV.BaseSpeedValueLabel.Font = Enum.Font.GothamBold
    NAV.BaseSpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    NAV.BaseSpeedValueLabel.Parent = BaseSpeedFrame

    -- Слайдер скорости полета на базу
    NAV.BaseSpeedSlider = Instance.new("Frame")
    NAV.BaseSpeedSlider.Name = "BaseSpeedSlider"
    NAV.BaseSpeedSlider.Size = UDim2.new(0.85, 0, 0, 15)
    NAV.BaseSpeedSlider.Position = UDim2.new(0.075, 0, 0.7, 0)
    NAV.BaseSpeedSlider.BackgroundColor3 = Color3.fromRGB(70, 60, 80)
    NAV.BaseSpeedSlider.BorderSizePixel = 0
    NAV.BaseSpeedSlider.Parent = BaseSpeedFrame

    local BaseSliderCorner = Instance.new("UICorner")
    BaseSliderCorner.CornerRadius = UDim.new(0, 10)
    BaseSliderCorner.Parent = NAV.BaseSpeedSlider

    local BaseSliderFill = Instance.new("Frame")
    BaseSliderFill.Name = "SliderFill"
    BaseSliderFill.Size = UDim2.new((NAV.baseFlySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed), 0, 1, 0)
    BaseSliderFill.Position = UDim2.new(0, 0, 0, 0)
    BaseSliderFill.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    BaseSliderFill.BorderSizePixel = 0
    BaseSliderFill.Parent = NAV.BaseSpeedSlider

    local BaseFillCorner = Instance.new("UICorner")
    BaseFillCorner.CornerRadius = UDim.new(0, 10)
    BaseFillCorner.Parent = BaseSliderFill

    local BaseSliderButton = Instance.new("TextButton")
    BaseSliderButton.Name = "SliderButton"
    BaseSliderButton.Size = UDim2.new(0, 25, 0, 25)
    BaseSliderButton.Position = UDim2.new((NAV.baseFlySpeed - NAV.minSpeed) / (NAV.maxSpeed - NAV.minSpeed), -12.5, 0.5, -12.5)
    BaseSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BaseSliderButton.Text = ""
    BaseSliderButton.AutoButtonColor = false
    BaseSliderButton.Parent = NAV.BaseSpeedSlider

    local BaseButtonCorner = Instance.new("UICorner")
    BaseButtonCorner.CornerRadius = UDim.new(0, 12)
    BaseButtonCorner.Parent = BaseSliderButton

    local BaseButtonStroke = Instance.new("UIStroke")
    BaseButtonStroke.Color = Color3.fromRGB(200, 200, 200)
    BaseButtonStroke.Thickness = 2
    BaseButtonStroke.Parent = BaseSliderButton

    -- Кнопка горячей клавиши
    NAV.KeybindButton = Instance.new("TextButton")
    NAV.KeybindButton.Name = "KeybindButton"
    NAV.KeybindButton.Size = UDim2.new(0.8, 0, 0, 30)
    NAV.KeybindButton.Position = UDim2.new(0.1, 0, 0.84, 0)
    NAV.KeybindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    NAV.KeybindButton.BackgroundTransparency = 0.3
    NAV.KeybindButton.BorderSizePixel = 0
    NAV.KeybindButton.Text = "ГОРЯЧАЯ КЛАВИША: G"
    NAV.KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    NAV.KeybindButton.TextSize = 13
    NAV.KeybindButton.Font = Enum.Font.GothamMedium
    NAV.KeybindButton.Parent = NAV.Frame

    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 6)
    KeybindCorner.Parent = NAV.KeybindButton

    -- Индикатор цели
    NAV.TargetLabel = Instance.new("TextLabel")
    NAV.TargetLabel.Name = "TargetLabel"
    NAV.TargetLabel.Size = UDim2.new(0.9, 0, 0, 25)
    NAV.TargetLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
    NAV.TargetLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    NAV.TargetLabel.BackgroundTransparency = 0.5
    NAV.TargetLabel.Text = "Цель: загрузка..."
    NAV.TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    NAV.TargetLabel.TextSize = 14
    NAV.TargetLabel.Font = Enum.Font.GothamMedium
    NAV.TargetLabel.TextXAlignment = Enum.TextXAlignment.Center
    NAV.TargetLabel.Parent = NAV.Frame

    local TargetCorner = Instance.new("UICorner")
    TargetCorner.CornerRadius = UDim.new(0, 6)
    TargetCorner.Parent = NAV.TargetLabel

    -- Информация о навигации
    NAV.NavigationInfo = Instance.new("TextLabel")
    NAV.NavigationInfo.Name = "NavigationInfo"
    NAV.NavigationInfo.Size = UDim2.new(0.9, 0, 0, 25)
    NAV.NavigationInfo.Position = UDim2.new(0.05, 0, 0.96, 0)
    NAV.NavigationInfo.BackgroundColor3 = Color3.fromRGB(40, 30, 40)
    NAV.NavigationInfo.BackgroundTransparency = 0.5
    NAV.NavigationInfo.Text = "Определение маршрута..."
    NAV.NavigationInfo.TextColor3 = Color3.fromRGB(200, 200, 255)
    NAV.NavigationInfo.TextSize = 12
    NAV.NavigationInfo.Font = Enum.Font.Gotham
    NAV.NavigationInfo.TextXAlignment = Enum.TextXAlignment.Center
    NAV.NavigationInfo.Parent = NAV.Frame

    local NavCorner = Instance.new("UICorner")
    NavCorner.CornerRadius = UDim.new(0, 6)
    NavCorner.Parent = NAV.NavigationInfo

    -- Индикатор расстояния
    NAV.DistanceLabel = Instance.new("TextLabel")
    NAV.DistanceLabel.Name = "DistanceLabel"
    NAV.DistanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
    NAV.DistanceLabel.Position = UDim2.new(0.05, 0, 1.02, 0)
    NAV.DistanceLabel.BackgroundTransparency = 1
    NAV.DistanceLabel.Text = "Дистанция: -"
    NAV.DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    NAV.DistanceLabel.TextSize = 12
    NAV.DistanceLabel.Font = Enum.Font.Gotham
    NAV.DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    NAV.DistanceLabel.Parent = NAV.Frame

    -- Кнопка перезагрузки
    NAV.ReloadButton = Instance.new("TextButton")
    NAV.ReloadButton.Name = "ReloadButton"
    NAV.ReloadButton.Size = UDim2.new(0, 25, 0, 25)
    NAV.ReloadButton.Position = UDim2.new(1, -60, 0, 5)
    NAV.ReloadButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    NAV.ReloadButton.Text = "↻"
    NAV.ReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NAV.ReloadButton.TextSize = 18
    NAV.ReloadButton.Font = Enum.Font.GothamBold
    NAV.ReloadButton.Parent = NAV.Frame

    local ReloadCorner = Instance.new("UICorner")
    ReloadCorner.CornerRadius = UDim.new(0, 12)
    ReloadCorner.Parent = NAV.ReloadButton

    -- Кнопка закрытия
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = NAV.Frame

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseButton

    -- ============ ОБРАБОТЧИКИ КНОПОК ============
    
    NAV.GapUpButton.MouseButton1Click:Connect(function()
        if not NAV.isGapping then
            NAV.gapUp()
        end
    end)

    NAV.GapDownButton.MouseButton1Click:Connect(function()
        if not NAV.isGapping then
            NAV.gapDown()
        end
    end)

    NAV.BaseButton.MouseButton1Click:Connect(function()
        print("Нажата кнопка GO BASE")
        NAV.flyToBase()
    end)

    NAV.KeybindButton.MouseButton1Click:Connect(function()
        NAV.KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        NAV.KeybindButton.Text = "НАЖМИТЕ КЛАВИШУ..."
        
        local connection
        connection = NAV.UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                NAV.setKeybind(input.KeyCode)
                connection:Disconnect()
            end
        end)
        
        task.delay(5, function()
            if connection then
                connection:Disconnect()
                NAV.updateGUI()
            end
        end)
    end)

    NAV.ReloadButton.MouseButton1Click:Connect(function()
        NAV.restartScript()
    end)

    CloseButton.MouseButton1Click:Connect(function()
        if NAV.isBaseFlightActive then
            NAV.stopBaseFlight()
            task.wait(0.5)
        end
        
        NAV.ScreenGui:Destroy()
        NAV.ScreenGui = nil
    end)

    -- ============ СЛАЙДЕРЫ ============
    
    -- Обработка слайдера скорости телепортации
    local isDraggingSpeed = false
    
    local function updateSpeedFromMouse()
        if not isDraggingSpeed then return end
        
        local mouse = NAV.UserInputService:GetMouseLocation()
        local sliderAbsPos = NAV.SpeedSlider.AbsolutePosition
        local sliderAbsSize = NAV.SpeedSlider.AbsoluteSize
        
        local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        NAV.flySpeed = math.floor(NAV.minSpeed + relativeX * (NAV.maxSpeed - NAV.minSpeed))
        NAV.updateGUI()
    end
    
    -- Клик по области слайдера скорости телепортации
    local speedSliderClickArea = Instance.new("TextButton")
    speedSliderClickArea.Name = "SliderClickArea"
    speedSliderClickArea.Size = UDim2.new(1, 0, 1, 0)
    speedSliderClickArea.Position = UDim2.new(0, 0, 0, 0)
    speedSliderClickArea.BackgroundTransparency = 1
    speedSliderClickArea.Text = ""
    speedSliderClickArea.AutoButtonColor = false
    speedSliderClickArea.Parent = NAV.SpeedSlider
    
    speedSliderClickArea.MouseButton1Down:Connect(function()
        isDraggingSpeed = true
        NAV.SliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        updateSpeedFromMouse()
    end)
    
    NAV.SliderButton.MouseButton1Down:Connect(function()
        isDraggingSpeed = true
        NAV.SliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    end)
    
    -- Обработка слайдера скорости полета на базу
    local isDraggingBaseSpeed = false
    
    local function updateBaseSpeedFromMouse()
        if not isDraggingBaseSpeed then return end
        
        local mouse = NAV.UserInputService:GetMouseLocation()
        local sliderAbsPos = NAV.BaseSpeedSlider.AbsolutePosition
        local sliderAbsSize = NAV.BaseSpeedSlider.AbsoluteSize
        
        local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        NAV.baseFlySpeed = math.floor(NAV.minSpeed + relativeX * (NAV.maxSpeed - NAV.minSpeed))
        NAV.updateBaseSpeedDisplay()
    end
    
    -- Клик по области слайдера скорости полета на базу
    local baseSpeedSliderClickArea = Instance.new("TextButton")
    baseSpeedSliderClickArea.Name = "SliderClickArea"
    baseSpeedSliderClickArea.Size = UDim2.new(1, 0, 1, 0)
    baseSpeedSliderClickArea.Position = UDim2.new(0, 0, 0, 0)
    baseSpeedSliderClickArea.BackgroundTransparency = 1
    baseSpeedSliderClickArea.Text = ""
    baseSpeedSliderClickArea.AutoButtonColor = false
    baseSpeedSliderClickArea.Parent = NAV.BaseSpeedSlider
    
    baseSpeedSliderClickArea.MouseButton1Down:Connect(function()
        isDraggingBaseSpeed = true
        BaseSliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        updateBaseSpeedFromMouse()
    end)
    
    BaseSliderButton.MouseButton1Down:Connect(function()
        isDraggingBaseSpeed = true
        BaseSliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    end)
    
    -- Отслеживание мыши для обоих слайдеров
    NAV.UserInputService.InputChanged:Connect(function(input)
        if isDraggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSpeedFromMouse()
        end
        
        if isDraggingBaseSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateBaseSpeedFromMouse()
        end
    end)
    
    NAV.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isDraggingSpeed then
                isDraggingSpeed = false
                NAV.SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            if isDraggingBaseSpeed then
                isDraggingBaseSpeed = false
                BaseSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end)

    -- ============ ПЕРЕТАСКИВАНИЕ GUI ============
    
    local dragging = false
    local dragInput, dragStart, startPos

    NAV.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = NAV.Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    NAV.Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    NAV.UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            NAV.Frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    print("✓ GUI created successfully!")
    NAV.updateGUI()
end

print("✓ GUI functions loaded successfully!")
return true
