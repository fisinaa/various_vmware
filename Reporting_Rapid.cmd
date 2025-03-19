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
  ::set EPWD=ваш пароль
  set SERVER=%SITE%
  ::comandlet
  ::echo %BIN% -u %LOGIN% -p %EPWD% -s %SERVER% -c ExportAll2xlsx -d %ReportDir% -f %ReportFile% > %SERVER%.cmd
  echo %BIN% -s %SERVER% -c ExportAll2xlsx -d %ReportDir% -f %ReportFile% > %SERVER%.cmd
  echo exit >> %SERVER%.cmd
  start "%SERVER%" %SERVER%.cmd
  ::del %SERVER%.cmd
goto :EOF
