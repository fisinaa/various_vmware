set ROOT=%~dp0
::path
set BIN="%ROOT%bin\rvtools.exe"
rem set ReportDir=%ROOT%Reports\
set ReportDir=Reports\
md %ReportDir%

call :REPOTER vc.local.local
call :REPOTER 
call :REPOTER 
call :REPOTER 
call :REPOTER  
call :REPOTER 
call :REPOTER 

goto :EOF

:REPOTER
  set SITE=%~1
  set ReportFile=RVToolReport.%SITE%.xlsx
  ::connection
  ::set LOGIN=odusb\username
  ::set EPWD=âàø ïàðîëü
  set SERVER=%SITE%
  ::comandlet
  ::echo %BIN% -u %LOGIN% -p %EPWD% -s %SERVER% -c ExportAll2xlsx -d %ReportDir% -f %ReportFile% > %SERVER%.cmd
  echo %BIN% -s %SERVER% -c ExportAll2xlsx -d %ReportDir% -f %ReportFile% > %SERVER%.cmd
  echo exit >> %SERVER%.cmd
  start "%SERVER%" %SERVER%.cmd
  ::del %SERVER%.cmd
goto :EOF


# Определяем корневую папку (путь к текущему скрипту)
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

# Путь к RVTools.exe
$BIN = "C:\Program Files (x86)\RobWare\RVTools\RVTools.exe"

# Директория для отчетов
$ReportDir = "$ROOT\Reports"

# Создаем папку для отчетов, если её нет
if (!(Test-Path -Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

# Список серверов vCenter
$servers = @(
    "vc.local.local",
)

# Функция для экспорта отчетов
function Export-RVToolsReport {
    param (
        [string]$Server
    )

    # Имя выходного файла
    $ReportFile = "RVToolReport.$Server.xlsx"
    $FullPath = Join-Path -Path $ReportDir -ChildPath $ReportFile

    # Формируем аргументы
    $arguments = "-passthroughAuth -s $Server -c ExportAll2xlsx -d `"$ReportDir`" -f `"$ReportFile`""

    # Логирование
    Write-Host "➡ Запуск экспорта для $Server..."
    Write-Host "Команда: `"$BIN`" $arguments"

    # Запуск RVTools
    Start-Process -FilePath $BIN -ArgumentList $arguments -NoNewWindow -Wait

    # Проверяем, создался ли файл
    Start-Sleep -Seconds 5 # Даем время на запись файла

    if (Test-Path $FullPath) {
        Write-Host "✅ Файл успешно сохранен: $FullPath"
    } else {
        Write-Host "❌ Ошибка: файл не найден после экспорта: $FullPath"
    }
}

# Запуск экспорта для каждого сервера
foreach ($server in $servers) {
    Export-RVToolsReport -Server $server
}

Write-Host "📌 Все экспорты завершены!"


"C:\Program Files (x86)\RobWare\RVTools\RVTools.exe" -passthroughAuth -s vc.local.local -c ExportAll2xlsx -d "C:\scripts\Reports" -f "RVToolReport.vc.local.local.xlsx"


# Определяем путь к RVTools.exe
$BIN = "C:\Program Files (x86)\RobWare\RVTools\RVTools.exe"

# Папка для отчетов
$ReportDir = "C:\temp\Reports"

# Список серверов vCenter
$servers = @(
    "vc.local.local",
)

# Создаем папку для отчетов, если её нет
if (!(Test-Path -Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

# Функция для запуска RVTools
function Export-RVToolsReport {
    param (
        [string]$Server
    )

    # Формируем путь к файлу
    $ReportFile = "RVToolReport.$Server.xlsx"
    $FullPath = Join-Path -Path $ReportDir -ChildPath $ReportFile

    # Формируем аргументы
    $arguments = @(
        "-passthroughAuth"
        "-s", $Server
        "-c", "ExportAll2xlsx"
        "-d", $ReportDir
        "-f", $ReportFile
    )

    # Выводим команду для отладки
    Write-Host "➡ Запуск экспорта для $Server..."
    Write-Host "`"$BIN`" $($arguments -join ' ')"

    # Запуск RVTools
    & $BIN @arguments

    # Проверяем, появился ли файл
    Start-Sleep -Seconds 5
    if (Test-Path $FullPath) {
        Write-Host "✅ Файл успешно сохранен: $FullPath"
    } else {
        Write-Host "❌ Ошибка: файл не найден после экспорта!"
    }
}

# Запуск экспорта для каждого сервера
foreach ($server in $servers) {
    Export-RVToolsReport -Server $server
}

Write-Host "📌 Все экспорты завершены!"


