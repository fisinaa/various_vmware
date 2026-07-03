# Папка для хранения файлов (измените путь, если нужно)
$folder = "C:\fill_disk"
New-Item -ItemType Directory -Path $folder -Force | Out-Null

# Общий размер, который нужно заполнить (3 ТБ)
$totalSize = 3TB

# Минимальный и максимальный размер файла
$minSize = 100MB
$maxSize = 50GB

# Текущий заполненный объём
$currentSize = 0
$fileIndex = 1

Write-Output "Заполнение диска случайными файлами..."

while ($currentSize -lt $totalSize) {
    # Генерируем случайный размер файла в диапазоне
    $fileSize = Get-Random -Minimum $minSize -Maximum $maxSize

    # Проверяем, не превысит ли этот файл 3 ТБ
    if ($currentSize + $fileSize -gt $totalSize) {
        $fileSize = $totalSize - $currentSize
    }

    $filePath = "$folder\file_$fileIndex.dat"
    Write-Output "Создаётся файл: $filePath (размер: $fileSize байт)"

    # Создаём файл с заданным размером
    $fs = [System.IO.File]::Create($filePath)
    $fs.SetLength($fileSize)
    $fs.Close()

    $currentSize += $fileSize
    $fileIndex++

    Write-Output "Файл $filePath создан. Заполнено: $($currentSize / 1GB) ГБ / 3 ТБ"
}

Write-Output "Заполнение диска завершено!"
