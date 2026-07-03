$folderPath = "C:\Temp\GeneratedFiles"  # Папка для хранения файлов
$numberOfFiles = 150                     # Количество файлов
$minSize = 1KB                            # Минимальный размер файла
$maxSize = 10MB                           # Максимальный размер файла
$cycleDelay = 5                            # Задержка перед новым циклом (в секундах)

# Создаём папку, если её нет
if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

while ($true) {  # Бесконечный цикл
    Write-Host "Создание файлов..."

    for ($i = 1; $i -le $numberOfFiles; $i++) {
        $fileName = "$folderPath\File_$i.bin"
        $fileSize = Get-Random -Minimum $minSize -Maximum $maxSize  # Случайный размер
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)

        Write-Host "Создан файл: $fileName (Размер: $fileSize байт)"
    }

    Write-Host "Ожидание перед удалением файлов ($cycleDelay сек)..."
    Start-Sleep -Seconds $cycleDelay

    Write-Host "Удаление файлов..."
    Remove-Item "$folderPath\*" -Force

    Write-Host "Цикл завершён. Запуск нового цикла..."
}
