@echo off
setlocal

:start
set retry_err=1

echo.
echo.^> %date% %time%
echo.RUNNING:
echo.%*
echo.

call %* && set retry_err=0

if ["%retry_err%"]==["1"] echo.ERROR, Retrying...
echo.---------------------------------------------------
echo.

if %retry_err%==1 goto :start

pause
exit /b