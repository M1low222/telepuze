-- === NAVIGATION SYSTEM v5.0 - PART 4: INITIALIZATION ===
-- Загрузите ПОСЛЕ всех частей (1 → 2 → 3 → 4)!

print("=== Loading Navigation System: Part 4/4 ===")

-- Проверяем загрузку всех частей
if not _G.NAV_SYSTEM then
    error("CRITICAL ERROR: Part 1 not loaded!")
    return
end

if not _G.NAV_SYSTEM.createGUI then
    error("CRITICAL ERROR: Part 3 not loaded! Please load parts in correct order")
    return
end

local NAV = _G.NAV_SYSTEM

-- Функция настройки горячих клавиш
function NAV.setupKeybinds()
    if NAV.keybindConnection then
        NAV.keybindConnection:Disconnect()
    end
    
    NAV.keybindConnection = NAV.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == NAV.currentKeybind then
                NAV.flyToBase()
            end
        end
    end)
end

-- ============ ОСНОВНОЙ ЗАПУСК ============

print("=== INITIALIZING NAVIGATION SYSTEM ===")

-- Ждем немного перед запуском
task.wait(1)

-- Создаем GUI
print("Creating GUI...")
NAV.createGUI()

-- Настраиваем горячие клавиши
print("Setting up keybinds...")
NAV.setupKeybinds()

-- Инициализируем первого персонажа
print("Loading initial character...")
task.wait(1)

if NAV.player.Character then
    NAV.loadCharacter(NAV.player.Character)
else
    print("Waiting for first character to spawn...")
    NAV.player.CharacterAdded:Wait()
    NAV.loadCharacter(NAV.player.Character)
end

-- Отслеживаем загрузку нового персонажа
NAV.player.CharacterAdded:Connect(function(newCharacter)
    print("==================================")
    print("НОВЫЙ ПЕРСОНАЖ ЗАГРУЖЕН")
    print("==================================")
    
    task.wait(0.5)
    NAV.loadCharacter(newCharacter)
end)

-- Отслеживаем удаление персонажа
NAV.player.CharacterRemoving:Connect(function(oldCharacter)
    print("==================================")
    print("ПЕРСОНАЖ УДАЛЕН")
    print("==================================")
    
    if NAV.isBaseFlightActive then
        NAV.stopBaseFlight()
    end
    
    NAV.character = nil
    NAV.humanoidRootPart = nil
    NAV.humanoid = nil
    NAV.characterLoaded = false
    
    NAV.updateGUI()
end)

-- Запускаем обновление GUI в реальном времени
NAV.RunService.Heartbeat:Connect(function()
    NAV.updateGUI()
    
    if NAV.isBaseFlightActive and NAV.baseFlightPart and NAV.baseFlightPart.Parent then
        NAV.updateBaseFlightPlatform()
    end
end)

-- Финальное сообщение
print("\n" .. string.rep("=", 50))
print("НАВИГАЦИОННАЯ СИСТЕМА v5.0 УСПЕШНО ЗАГРУЖЕНА!")
print(string.rep("=", 50))
print("Всего точек: " .. #NAV.coordinateSystem)
print("Точка базы: X:112 Y:4 Z:10")
print("Горячая клавиша GO BASE: G")
print("Перезагрузка скрипта: кнопка ↻")
print("Закрыть GUI: кнопка ×")
print(string.rep("=", 50))
print("Управление:")
print("  → СЛЕДУЮЩАЯ - телепортация вперед по точкам")
print("  ← ПРЕДЫДУЩАЯ - телепортация назад по точкам")
print("  GO BASE - полет на базу")
print(string.rep("=", 50))

-- Возвращаем ссылку на систему для доступа извне
return NAV
