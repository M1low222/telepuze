-- === NAVIGATION SYSTEM v5.0 - PART 1: CONFIGURATION ===
-- Загрузите этот файл ПЕРВЫМ!

print("=== Loading Navigation System: Part 1/4 ===")

-- Глобальная таблица для всех данных
if not _G.NAV_SYSTEM then
    _G.NAV_SYSTEM = {}
end

local NAV = _G.NAV_SYSTEM

-- Сервисы
NAV.Players = game:GetService("Players")
NAV.RunService = game:GetService("RunService")
NAV.UserInputService = game:GetService("UserInputService")
NAV.TweenService = game:GetService("TweenService")

-- Игрок
NAV.player = NAV.Players.LocalPlayer

-- Система координат точек
NAV.coordinateSystem = {
    {position = Vector3.new(284, -2, 6), name = "Точка 1", color = Color3.fromRGB(100, 200, 255)},
    {position = Vector3.new(400, -2, 5), name = "Точка 2", color = Color3.fromRGB(200, 100, 255)},
    {position = Vector3.new(541, -2, 5), name = "Точка 3", color = Color3.fromRGB(100, 255, 150)},
    {position = Vector3.new(755, -2, 5), name = "Точка 4", color = Color3.fromRGB(255, 200, 100)},
    {position = Vector3.new(1074, -2, 5), name = "Точка 5", color = Color3.fromRGB(255, 150, 100)},
    {position = Vector3.new(1555, -2, 5), name = "Точка 6", color = Color3.fromRGB(200, 100, 255)},
    {position = Vector3.new(2250, -2, 5), name = "Точка 7", color = Color3.fromRGB(100, 220, 220)},
    {position = Vector3.new(2610, -2, 5), name = "Точка 8", color = Color3.fromRGB(220, 170, 100)}
}

-- Координаты базы
NAV.basePosition = Vector3.new(112, 4, 10)

-- Настройки
NAV.currentTargetIndex = 1
NAV.flySpeed = 100
NAV.gapHeight = 5
NAV.minSpeed = 10
NAV.maxSpeed = 500
NAV.baseFlySpeed = 150

-- Флаги состояний
NAV.isNoclip = false
NAV.isGapping = false
NAV.isBaseFlying = false
NAV.isBaseFlightActive = false
NAV.originalCollision = {}

-- Ссылки на персонажа
NAV.character = nil
NAV.humanoidRootPart = nil
NAV.humanoid = nil
NAV.characterLoaded = false

-- Клавиша
NAV.currentKeybind = Enum.KeyCode.G

-- Парт для полета
NAV.baseFlightPart = nil
NAV.currentBaseFlightTween = nil
NAV.baseFlightConnection = nil

-- GUI элементы (будут созданы позже)
NAV.ScreenGui = nil
NAV.Frame = nil
NAV.TargetLabel = nil
NAV.DistanceLabel = nil
NAV.GapUpButton = nil
NAV.GapDownButton = nil
NAV.BaseButton = nil
NAV.PositionIndicator = nil
NAV.NavigationInfo = nil
NAV.SpeedSlider = nil
NAV.SpeedValueLabel = nil
NAV.SliderButton = nil
NAV.BaseStatusLabel = nil
NAV.BaseSpeedSlider = nil
NAV.BaseSpeedValueLabel = nil
NAV.KeybindButton = nil
NAV.ReloadButton = nil

-- Соединение для клавиш
NAV.keybindConnection = nil

print("✓ Configuration loaded successfully!")
print("Total points: " .. #NAV.coordinateSystem)
return NAV
