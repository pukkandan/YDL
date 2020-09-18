:: Works only on Windows 10
::------------------------- CODES ---------------------
:: _ = Background
:: x = Dimmer color
:: r,g,b,c,y,m,w,k = Red, Green, Blue, Cyan, Yellow, Magenta, White, blacK
:: 0  = Reset
:: _0 = EndLine
:: nl = NewLine
::=====================================================

@echo off

set tf.nl=^


:: The empty lines above are important
set tf.nl=^^^%tf.nl%%tf.nl%^%tf.nl%%tf.nl%

::=====================================================
call :setESC

set tf.0=%tf.ESC%[0m
set "tf._0=%tf.0% "

set tf.xb=%tf.ESC%[1m
set tf.xu=%tf.ESC%[4m
set tf.xi=%tf.ESC%[7m

set tf.xb=%tf.ESC%[90m
set tf.xr=%tf.ESC%[31m
set tf.xg=%tf.ESC%[32m
set tf.xy=%tf.ESC%[33m
set tf.xb=%tf.ESC%[34m
set tf.xm=%tf.ESC%[35m
set tf.xc=%tf.ESC%[36m
set tf.xw=%tf.ESC%[37m

set tf.b=%tf.ESC%[30m
set tf.r=%tf.ESC%[91m
set tf.g=%tf.ESC%[92m
set tf.y=%tf.ESC%[93m
set tf.b=%tf.ESC%[94m
set tf.m=%tf.ESC%[95m
set tf.c=%tf.ESC%[96m
set tf.w=%tf.ESC%[97m

set tf._k=%tf.ESC%[100m
set tf._xr=%tf.ESC%[41m
set tf._xg=%tf.ESC%[42m
set tf._xy=%tf.ESC%[43m
set tf._xb=%tf.ESC%[44m
set tf._xm=%tf.ESC%[45m
set tf._xc=%tf.ESC%[46m
set tf._xw=%tf.ESC%[47m

set tf._k_str=%tf.ESC%[40m
set tf._r=%tf.ESC%[101m
set tf._g=%tf.ESC%[102m
set tf._y=%tf.ESC%[103m
set tf._b=%tf.ESC%[104m
set tf._m=%tf.ESC%[105m
set tf._c=%tf.ESC%[106m
set tf._w=%tf.ESC%[107m

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set tf.ESC=%%b
  exit /B 0
)
exit /B 0

::Eg:
echo.%tf.r%red text %tf._xb%in blue bg %tf.0%and finally reset


