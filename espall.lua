-- Универсальная система управления ESP скриптами с отключением по F1
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Список всех ESP скриптов
local ESP_SCRIPTS = {}

-- Функция для уничтожения ESP через удаление папок в CoreGui
local function destroyESPFolders()
    local foldersToRemove = {
        "Submarine_ESP",
        "Boat_ESP",
        "AC130_ESP",
        "Drone_ESP",
        "Helicopter_ESP",
        "Plane_ESP",
        "Hovercraft_ESP",
        "Vehicle_ESP",
        "Tank_ESP"
    }
    
    for _, folderName in ipairs(foldersToRemove) do
        local folder = CoreGui:FindFirstChild(folderName)
        if folder then
            folder:Destroy()
            print("🗑️ Удалена папка: " .. folderName)
        end
    end
end

-- Функция для загрузки ESP скрипта
local function loadESPScript(url, scriptName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        ESP_SCRIPTS[scriptName] = {
            module = result,
            active = true,
            url = url
        }
        print("✅ " .. scriptName .. " загружен")
        return true
    else
        warn("❌ Не удалось загрузить " .. scriptName .. ":", result)
        return false
    end
end

-- Загружаем все ESP скрипты
print("=== ЗАГРУЗКА ESP СКРИПТОВ ===")

local scriptsToLoad = {
    {"https://raw.githubusercontent.com/nazarkus/submarine-esp/refs/heads/main/submarineesp.lua", "Submarine ESP"},
    {"https://raw.githubusercontent.com/nazarkus/plane-esp/refs/heads/main/planeesp.lua", "Plane ESP"},
    {"https://raw.githubusercontent.com/nazarkus/heli-esp/refs/heads/main/heli%20esp.lua", "Helicopter ESP"},
    {"https://raw.githubusercontent.com/nazarkus/droneesp/refs/heads/main/droneesp.lua", "Drone ESP"},
    {"https://raw.githubusercontent.com/nazarkus/ac130esp/refs/heads/main/ac130esp.lua", "AC130 ESP"},
    {"https://raw.githubusercontent.com/nazarkus/boatesp/refs/heads/main/boatesp.lua", "Boat ESP"},
    {"https://raw.githubusercontent.com/nazarkus/hovercraftesp/refs/heads/main/hovercraftesp.lua", "Hovercraft ESP"},
    {"https://raw.githubusercontent.com/nazarkus/vehicleesp/refs/heads/main/vehicleesp.lua", "Vehicle ESP"},
    {"https://raw.githubusercontent.com/nazarkus/tankesp/refs/heads/main/tankesp.lua", "Tank ESP"}
}

for _, scriptData in ipairs(scriptsToLoad) do
    loadESPScript(scriptData[1], scriptData[2])
end

print("=== ВСЕ ESP СКРИПТЫ ЗАГРУЖЕНЫ ===")
print("Нажмите F1 для остановки ВСЕХ ESP")

-- Бинд на F1 для остановки всех ESP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        print("🛑 Останавливаю ВСЕ ESP скрипты...")
        
        -- 1. Удаляем все ESP папки из CoreGui
        destroyESPFolders()
        
        -- 2. Очищаем список скриптов
        ESP_SCRIPTS = {}
        
        -- 3. Принудительный сбор мусора (опционально)
        task.wait(0.1)
        game:GetService("RunService"):PostSimulationWait()
        
        print("✅ Все ESP скрипты остановлены")
    end
end)

-- Автоматическая остановка при выходе из игры
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        destroyESPFolders()
    end
end)
