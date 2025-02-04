$folderPath = "C:\Temp\GeneratedFiles"  # ����� ��� �������� ������
$numberOfFiles = 150                     # ���������� ������
$minSize = 1KB                            # ����������� ������ �����
$maxSize = 10MB                           # ������������ ������ �����
$cycleDelay = 5                            # �������� ����� ����� ������ (� ��������)

# ������ �����, ���� � ���
if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

while ($true) {  # ����������� ����
    Write-Host "�������� ������..."

    for ($i = 1; $i -le $numberOfFiles; $i++) {
        $fileName = "$folderPath\File_$i.bin"
        $fileSize = Get-Random -Minimum $minSize -Maximum $maxSize  # ��������� ������
        $randomData = New-Object byte[] $fileSize
        (New-Object System.Random).NextBytes($randomData)
        [System.IO.File]::WriteAllBytes($fileName, $randomData)

        Write-Host "������ ����: $fileName (������: $fileSize ����)"
    }

    Write-Host "�������� ����� ��������� ������ ($cycleDelay ���)..."
    Start-Sleep -Seconds $cycleDelay

    Write-Host "�������� ������..."
    Remove-Item "$folderPath\*" -Force

    Write-Host "���� ��������. ������ ������ �����..."
}
