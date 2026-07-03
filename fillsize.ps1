$path = "C:\fill_disk.dat"
$size = 3TB
$buffer = New-Object byte[](1MB)
$fs = [System.IO.File]::OpenWrite($path)

$written = 0
while ($written -lt $size) {
    (New-Object System.Security.Cryptography.RNGCryptoServiceProvider).GetBytes($buffer)
    $fs.Write($buffer, 0, $buffer.Length)
    $written += $buffer.Length
    Write-Progress -Activity "Заполнение диска" -Status "$($written / 1GB) ГБ записано" -PercentComplete ($written * 100 / $size)
}

$fs.Close()
Write-Output "Файл $path создан и занимает $size байт."
