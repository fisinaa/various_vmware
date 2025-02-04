$folderPath = "C:\Temp\LoadTest"   # Папка для тестирования
$numberOfFiles = 1000               # Количество файлов в итерации
$minSize = 1MB                      # Минимальный размер файла
$maxSize = 50MB                     # Максимальный размер файла
$iterations = 10                     # Количество циклов теста (0 = бесконечно)
$readPercentage = 50                 # % файлов, которые будут читаться (имитация нагрузки)
$writeDelay = 0                      # Задержка между записями (в секундах)
$readDelay = 0                       # Задержка между чтениями (в секундах)

# Создаём папку, если её нет
if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

$cycle = 0
while ($iterations -eq 0 -or $cycle -lt $iterations) {
    Write-Host "🔄 Начало цикла $($cycle + 1)..."

    # 1️⃣ Генерация и запись файлов
    Write-Host "📂 Генерация файлов..."
    for ($i = 1; $i -le $numberOfFiles; $i++) {
        $fileName = "$folderPath\File_$i.bin"
        $fileSize = Get-Random -Minimum $minSize -Maximum $maxSize
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)

        Write-Host "✅ Файл создан: $fileName (Размер: $fileSize байт)"
        Start-Sleep -Seconds $writeDelay  # Задержка между записями (имитация нагрузки)
    }

    # 2️⃣ Чтение случайных файлов
    Write-Host "📖 Чтение файлов..."
    $files = Get-ChildItem -Path $folderPath -Filter "*.bin"
    $readCount = [math]::Round($files.Count * $readPercentage / 100)

    foreach ($file in ($files | Get-Random -Count $readCount)) {
        $content = [System.IO.File]::ReadAllBytes($file.FullName)
        Write-Host "📖 Прочитан файл: $($file.Name), Размер: $($content.Length) байт"
        Start-Sleep -Seconds $readDelay  # Задержка между чтениями
    }

    # 3️⃣ Удаление файлов
    Write-Host "🗑️ Удаление файлов..."
    Remove-Item "$folderPath\*" -Force
    Write-Host "🧹 Очистка завершена."

    $cycle++
    Write-Host "🔄 Завершён цикл $cycle. Ожидание 5 сек перед новым циклом..."
    Start-Sleep -Seconds 5
}
