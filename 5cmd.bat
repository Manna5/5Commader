@echo off
mode 80,25
if not "%1"=="" cd %1
path %path%;%cd%
setlocal EnableDelayedExpansion
:refresh
set cowcmd_theme=%207F0
set cowcmd_theme=%cowcmd_theme:~0,4%
title 5Commander - %cd%
color %cowcmd_theme:~0,2%
set count=0
for /f %%i in ('dir /b') do (
 set /a count=count+1
 set files[!count!]=%%i
)
cls
set nfiles=%count%
set count=1
set endrow=4
set rowcount=1
:display
if %count% gtr %nfiles% goto end_display
set file=!files[%count%]!
if not "%file%"=="%file:~0,16%" (
 set file=%file:~0,14%..
)
set file=%file%                
set file=%file:~0,16%
set /p "x=%file%" <nul
if %endrow% lss 1 (
 set endrow=5
 set /a rowcount=rowcount+1
)
set /a endrow=endrow-1
set /a count=count+1
goto display
:end_display
set /a space=21-rowcount
for /l %%i in (1 1 %space%) do echo.
echo.
set /p "x=--------------------------------------------------------------------------------" <nul
echo 1=Refresh 2=Read 3=RenMove 4=Copy 5=Delete 6=ChDir 7=MkDir 8=UpDir 9=Run 0=Exit
choice /c 0123456789 >nul
if errorlevel 10 goto run
if errorlevel 9 goto updir
if errorlevel 8 goto mkdir
if errorlevel 7 goto chdir
if errorlevel 6 goto delete
if errorlevel 5 goto copy
if errorlevel 4 goto renmov
if errorlevel 3 goto read
if errorlevel 2 goto refresh
endlocal
exit

:read
set /p read=Read file: 
if not exist "%read%" goto refresh
cls
color %cowcmd_theme:~2,2%
title 5Commander - %read%
type %read%
pause >nul
goto refresh

:renmov
set /p old=Old name: 
set /p new=New name: 
move %old% %new%
goto refresh

:copy
set /p src=Source: 
set /p dst=Destination: 
copy %src% %dst%
goto refresh

:delete
set /p del=Delete file: 
del /q %del%
cmd /c "rd %del%"
goto refresh

:chdir
set /p chdir=Go to: 
if /i "%chdir:~0,2%"=="A:" A:
if /i "%chdir:~0,2%"=="B:" B:
if /i "%chdir:~0,2%"=="C:" C:
if /i "%chdir:~0,2%"=="D:" D:
if /i "%chdir:~0,2%"=="E:" E:
if /i "%chdir:~0,2%"=="F:" F:
cd %chdir%
goto refresh

:mkdir
set /p mkdir=Make directory: 
md %mkdir%
goto refresh

:updir
cd ..
goto refresh

:run
set /p "run=Run: "
cls
title 5Commander - %cd% - %run%
color %cowcmd_theme:~2,2%
call %run%
set retval=%ERRORLEVEL%
set /p "x=--------------------------------------------------------------------------------" <nul
echo Return value is %retval%. Press any key to back to directory view.
pause >nul
goto refresh