@echo off
setlocal

for /f "tokens=4-5 delims=. " %%i in ('ver') do set "WINVER=%%i"
if ["%WINVER%"]==["10"] call "terminal-format.cmd"

:start
set "retry_err=1"

echo.
echo.
echo.%tf.y%^> %date% %time%%tf.0%
echo.
echo.RUNNING: %tf.c%%*%tf.0%
echo.

call %* && set "retry_err=0"

if ["%retry_err%"]==["1"] echo.%tf.y%%tf._xr%ERROR, Retrying...%tf._0%
echo|set /p="%tf.b%---------------------------------------------------%tf.xy%"

if ["%retry_err%"]==["1"] (
	timeout 10
	goto :start
)

echo.%tf.b%DONE%tf.0%
echo.

pause
exit /b