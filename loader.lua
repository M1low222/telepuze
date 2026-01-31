-- === NAVIGATION SYSTEM LOADER ===
-- ЭТОТ ФАЙЛ ЗАПУСКАЕТСЯ В ИСПОЛНИТЕЛЕ!
-- Просто вставьте этот код и выполните

print("=== Navigation System Loader ===")
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
        local content = game:HttpGet(url, true)
        return loadstring(content)()
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
    if not loadPart(url, i) then
        error("Failed to load part " .. i .. ". Stopping.")
        return
    end
    wait(0.3) -- Небольшая задержка между частями
end

print("\n" .. string.rep("=", 50))
print("🎉 NAVIGATION SYSTEM COMPLETELY LOADED!")
print("🎮 Ready to use!")
print(string.rep("=", 50))

-- Возвращаем доступ к системе если нужно
return _G.NAV_SYSTEM
