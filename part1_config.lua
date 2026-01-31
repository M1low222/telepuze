-- === NAVIGATION SYSTEM v5.0 - PART 1: CONFIGURATION ===
-- Загрузите этот файл ПЕРВЫМ!

print("=== Loading Navigation System: Part 1/4 ===")

-- Глобальная таблица для обмена данными между частями
if not _G.NAV_SYSTEM then
    _G.NAV_SYSTEM = {}
end

-- Сервисы
_G.NAV_SYSTEM.Players = game:GetService("Players")
_G.NAV_SYSTEM.RunService = game:GetService("RunService")
_G.NAV_SYSTEM.UserInputService = game:GetService("UserInputService")
_G.NAV_SYSTEM.TweenService = game:GetService("TweenService")

-- Игрок
_G.NAV_SYSTEM.player = _G.NAV_SYSTEM.Players.LocalPlayer

-- Система координат точек
_G.NAV_SYSTEM.coordinateSystem = {
    {
        position = Vector3.new(284, -2, 6),
        name = "Точка 1",
        color = Color3.fromRGB(100, 200, 255)
    },
    {
        position = Vector3.new(400, -2, 5),
        name = "Точка 2",
        color = Color3.fromRGB(200, 100, 255)
    },
    {
        position = Vector3.new(541, -2, 5),
        name = "Точка 3",
        color = Color3.fromRGB(100, 255, 150)
    },
    {
        position = Vector3.new(755, -2, 5),
        name = "Точка 4",
        color = Color3.fromRGB(255, 200, 100)
    },
    {
        position = Vector3.new(1074, -2, 5),
        name = "Точка 5",
        color = Color3.fromRGB(255, 150, 100)
    },
    {
        position = Vector3.new(1555, -2, 5),
        name = "Точка 6",
        color = Color3.fromRGB(200, 100, 255)
    },
    {
        position = Vector3.new(2250, -2, 5),
        name = "Точка 7",
        color = Color3.fromRGB(100, 220, 220)
    },
    {
        position = Vector3.new(2610, -2, 5),
        name = "Точка 8",
        color = Color3.fromRGB(220, 170, 100)
    }
}

-- Координаты базы
_G.NAV_SYSTEM.basePosition = Vector3.new(112, 4, 10)

-- Настройки
_G.NAV_SYSTEM.currentTargetIndex = 1
_G.NAV_SYSTEM.flySpeed = 100
_G.NAV_SYSTEM.gapHeight = 5
_G.NAV_SYSTEM.minSpeed = 10
_G.NAV_SYSTEM.maxSpeed = 500
_G.NAV_SYSTEM.baseFlySpeed = 150

-- Флаги состояний
_G.NAV_SYSTEM.isNoclip = false
_G.NAV_SYSTEM.isGapping = false
_G.NAV_SYSTEM.isBaseFlying = false
_G.NAV_SYSTEM.isBaseFlightActive = false
_G.NAV_SYSTEM.originalCollision = {}

-- Ссылки на персонажа
_G.NAV_SYSTEM.character = nil
_G.NAV_SYSTEM.humanoidRootPart = nil
_G.NAV_SYSTEM.humanoid = nil
_G.NAV_SYSTEM.characterLoaded = false

-- Клавиша
_G.NAV_SYSTEM.currentKeybind = Enum.KeyCode.G

-- Парт для полета
_G.NAV_SYSTEM.baseFlightPart = nil
_G.NAV_SYSTEM.currentBaseFlightTween = nil
_G.NAV_SYSTEM.baseFlightConnection = nil

-- GUI элементы
_G.NAV_SYSTEM.ScreenGui = nil
_G.NAV_SYSTEM.Frame = nil
_G.NAV_SYSTEM.TargetLabel = nil
_G.NAV_SYSTEM.DistanceLabel = nil
_G.NAV_SYSTEM.GapUpButton = nil
_G.NAV_SYSTEM.GapDownButton = nil
_G.NAV_SYSTEM.BaseButton = nil
_G.NAV_SYSTEM.PositionIndicator = nil
_G.NAV_SYSTEM.NavigationInfo = nil
_G.NAV_SYSTEM.SpeedSlider = nil
_G.NAV_SYSTEM.SpeedValueLabel = nil
_G.NAV_SYSTEM.SliderButton = nil
_G.NAV_SYSTEM.BaseStatusLabel = nil
_G.NAV_SYSTEM.BaseSpeedSlider = nil
_G.NAV_SYSTEM.BaseSpeedValueLabel = nil
_G.NAV_SYSTEM.KeybindButton = nil
_G.NAV_SYSTEM.ReloadButton = nil

-- Функции (будут загружены в Part 2)
_G.NAV_SYSTEM.isCharacterValid = nil
_G.NAV_SYSTEM.restartScript = nil
_G.NAV_SYSTEM.createBaseFlightPlatform = nil
_G.NAV_SYSTEM.updateBaseFlightPlatform = nil
_G.NAV_SYSTEM.setNoclip = nil
_G.NAV_SYSTEM.findNearestPoint = nil
_G.NAV_SYSTEM.getCurrentPointIndex = nil
_G.NAV_SYSTEM.getCurrentTarget = nil
_G.NAV_SYSTEM.stopBaseFlight = nil
_G.NAV_SYSTEM.flyToBase = nil
_G.NAV_SYSTEM.updateBaseSpeedDisplay = nil
_G.NAV_SYSTEM.setKeybind = nil
_G.NAV_SYSTEM.updateGUI = nil
_G.NAV_SYSTEM.smoothTeleportToTarget = nil
_G.NAV_SYSTEM.gapUp = nil
_G.NAV_SYSTEM.gapDown = nil
_G.NAV_SYSTEM.loadCharacter = nil
_G.NAV_SYSTEM.createGUI = nil
_G.NAV_SYSTEM.setupKeybinds = nil

print("✓ Configuration loaded successfully!")
print("Total points: " .. #_G.NAV_SYSTEM.coordinateSystem)
return true
