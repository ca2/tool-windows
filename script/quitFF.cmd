set FFexec=%programfiles(x86)%\Mozilla Firefox\firefox.exe
set ERRORLEVEL=

:: Check if that annoying Master Password prompt is open and close it
tasklist /FI "WINDOWTITLE eq Password Required" 2>NUL | find /I /N firefox.exe">NUL
IF "%ERRORLEVEL%"=="0" MPWDclose.vbs

FFQuit.vbs

::Optional Restart Firefox - ping is just a sneaky way of getting sleep functionality
::Uncomment REM to activate
REM ping 1.0.0.0 -n 1 -w 2000 > nul
REM start ""  "%FFexec%" & exit