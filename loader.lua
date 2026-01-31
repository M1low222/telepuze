-- === NAVIGATION SYSTEM LOADER ===
-- ЭТОТ ФАЙЛ ЗАПУСКАЕТСЯ В ИСПОЛНИТЕЛЕ!
-- Просто вставьте этот код и выполните

print("=== Navigation System Loader v5.0 ===")
print("Loading system in 4 parts...")

-- Список частей (RAW ссылки на GitHub)
local partUrls = {
    "https://raw.githubusercontent.com/M1low222/telepuze/main/part1_config.lua",
    "https://raw.githubusercontent.com/M1low222/telepuze/main/part2_functions.lua", 
    "https://raw.githubusercontent.com/M1low222/telepuze/main/part3_gui.lua",
    "https://raw.githubusercontent.com/M1low222/telepuze/main/part4_main.lua"
}

-- Функция безопасной загрузки
local function loadPart(url, partNumber)
    print("Loading part " .. partNumber .. "...")
    
    local success, result = pcall(function()
        -- Загрузка по URL
        local content = game:HttpGet(url)
        local loadedFunction = loadstring(content)
        if loadedFunction then
            return loadedFunction()
        else
            error("Failed to loadstring")
        end
    end)
    
    if success then
        print("✓ Part " .. partNumber .. " loaded successfully!")
        return true
    else
        warn("✗ ERROR loading part " .. partNumber .. ": " .. tostring(result))
        return false
    end
end

-- Загружаем все части по порядку
for i, url in ipairs(partUrls) do
    local loaded = loadPart(url, i)
    if not loaded then
        warn("Failed to load part " .. i .. ". Trying to continue...")
    end
    wait(0.5) -- Задержка между частями
end

-- Проверяем, загрузилась ли система
if _G.NAV_SYSTEM then
    print("\n" .. string.rep("=", 50))
    print("🎉 NAVIGATION SYSTEM COMPLETELY LOADED!")
    print("🎮 Ready to use!")
    print("📊 Points loaded: " .. tostring(#_G.NAV_SYSTEM.coordinateSystem))
    print(string.rep("=", 50))
    
    -- Возвращаем доступ к системе
    return _G.NAV_SYSTEM
else
    warn("⚠️ Navigation system failed to load completely!")
    warn("Try loading parts manually in order:")
    warn("1. part1_config.lua")
    warn("2. part2_functions.lua")
    warn("3. part3_gui.lua")
    warn("4. part4_main.lua")
    return nil
end
