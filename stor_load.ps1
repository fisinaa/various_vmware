$folderPath = "C:\Temp\StorageTest"   # Папка для теста
$smallFiles = 500                     # Количество маленьких файлов (4КБ – 64КБ)
$mediumFiles = 200                     # Количество средних файлов (1МБ – 50МБ)
$largeFiles = 50                       # Количество крупных файлов (100МБ – 1ГБ)
$iterations = 10                        # Количество циклов теста (0 = бесконечно)
$readPercentage = 50                    # % файлов, которые будут читаться
$writeDelay = 0                         # Задержка между записями (в секундах)
$readDelay = 0                          # Задержка между чтениями (в секундах)
$deleteAfterCycle = $true               # Удалять файлы после каждого цикла

# Создаём папку, если её нет
if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

$cycle = 0
while ($iterations -eq 0 -or $cycle -lt $iterations) {
    Write-Host "🔄 Начало цикла $($cycle + 1)..."

    # 1️⃣ Генерация маленьких файлов (нагрузка на IOPS)
    Write-Host "📂 Генерация маленьких файлов (4КБ – 64КБ)..."
    $startWrite = Get-Date
    $totalWriteSize = 0

    for ($i = 1; $i -le $smallFiles; $i++) {
        $fileName = "$folderPath\Small_$i.bin"
        $fileSize = Get-Random -Minimum 4KB -Maximum 64KB
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)
        $totalWriteSize += $fileSize
    }

    # 2️⃣ Генерация средних файлов (нагрузка на метаоперации)
    Write-Host "📂 Генерация средних файлов (1МБ – 50МБ)..."
    for ($i = 1; $i -le $mediumFiles; $i++) {
        $fileName = "$folderPath\Medium_$i.bin"
        $fileSize = Get-Random -Minimum 1MB -Maximum 50MB
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)
        $totalWriteSize += $fileSize
    }

    # 3️⃣ Генерация крупных файлов (нагрузка на пропускную способность)
    Write-Host "📂 Генерация крупных файлов (100МБ – 1ГБ)..."
    for ($i = 1; $i -le $largeFiles; $i++) {
        $fileName = "$folderPath\Large_$i.bin"
        $fileSize = Get-Random -Minimum 100MB -Maximum 1GB
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)
        $totalWriteSize += $fileSize
    }

    $endWrite = Get-Date
    $writeDuration = ($endWrite - $startWrite).TotalSeconds
    $writeSpeed = if ($writeDuration -gt 0) { [math]::Round(($totalWriteSize / 1MB) / $writeDuration, 2) } else { 0 }
    Write-Host "🚀 Скорость записи: $writeSpeed MB/s"

    # 4️⃣ Чтение случайных файлов (нагрузка на кеш и диск)
    Write-Host "📖 Чтение файлов..."
    $startRead = Get-Date
    $totalReadSize = 0

    $files = Get-ChildItem -Path $folderPath -Filter "*.bin"
    $readCount = [math]::Round($files.Count * $readPercentage / 100)

    foreach ($file in ($files | Get-Random -Count $readCount)) {
        $content = [System.IO.File]::ReadAllBytes($file.FullName)
        $totalReadSize += $content.Length
        Start-Sleep -Seconds $readDelay
    }

    $endRead = Get-Date
    $readDuration = ($endRead - $startRead).TotalSeconds
    $readSpeed = if ($readDuration -gt 0) { [math]::Round(($totalReadSize / 1MB) / $readDuration, 2) } else { 0 }
    Write-Host "📊 Скорость чтения: $readSpeed MB/s"

    # 5️⃣ Удаление файлов (если включено)
    if ($deleteAfterCycle) {
        Write-Host "🗑️ Удаление файлов..."
        $startDelete = Get-Date

        Remove-Item "$folderPath\*" -Force

        $endDelete = Get-Date
        $deleteDuration = ($endDelete - $startDelete).TotalSeconds
        Write-Host "🧹 Удаление завершено за $deleteDuration сек."
    }

    $cycle++
    Write-Host "🔄 Завершён цикл $cycle. Ожидание 5 сек перед новым циклом..."
    Start-Sleep -Seconds 5
}
