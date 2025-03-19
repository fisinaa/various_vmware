set ROOT=%~dp0
::path
set BIN="%ROOT%bin\rvtools.exe"
rem set ReportDir=%ROOT%Reports\
set ReportDir=Reports\
md %ReportDir%

call :REPOTER mir-m01-vc01.alrosa.ru
call :REPOTER mir-vcs02.alrosa.ru
call :REPOTER mir-w01-vc01.alrosa.ru
call :REPOTER udcrud-w01-vc01.alrosa.ru
call :REPOTER msk-m01-vc01.alrosa.ru
call :REPOTER MSK-VCENTER01.alrosa.ru
call :REPOTER msk-w01-vc01.alrosa.ru
call :REPOTER msk-w02-vc01.alrosa.ru

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
    "mir-m01-vc01.alrosa.ru",
    "mir-vcs02.alrosa.ru",
    "mir-w01-vc01.alrosa.ru",
    "udcrud-w01-vc01.alrosa.ru",
    "msk-m01-vc01.alrosa.ru",
    "MSK-VCENTER01.alrosa.ru",
    "msk-w01-vc01.alrosa.ru",
    "msk-w02-vc01.alrosa.ru"
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


"C:\Program Files (x86)\RobWare\RVTools\RVTools.exe" -passthroughAuth -s mir-m01-vc01.alrosa.ru -c ExportAll2xlsx -d "C:\scripts\Reports" -f "RVToolReport.mir-m01-vc01.alrosa.ru.xlsx"
