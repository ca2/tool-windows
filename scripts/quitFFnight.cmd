REM set FFexec=%programfiles(x86)%\Firefox Developer Edition\firefox.exe
REM set ERRORLEVEL=

REM Check if that annoying Master Password prompt is open and close it
REM tasklist /FI "WINDOWTITLE eq Password Required" 2>NUL | find /I /N firefox.exe">NUL
REM IF "%ERRORLEVEL%"=="0" MPWDclose.vbs

ff_night_quit.vbs


