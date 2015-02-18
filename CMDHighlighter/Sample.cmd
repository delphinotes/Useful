@echo off
rem Syntax Higlighting

call :factorial %1
echo %RESULT%
exit /b

rem Search Match, Text Block
rem Function to calculate the factorial
rem Input:
rem         %1
rem Output:
rem         %RESULT%
:factorial
  if %1 LEQ 1 (
      set RESULT=1
      exit /b
  )
  set /a PARAM=%1 - 1
  call :factorial %PARAM%
  set /a RESULT=%1 * %RESULT%
exit /b