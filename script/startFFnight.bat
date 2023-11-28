set FFexec=%programfiles(x86)%\Firefox Developer Edition\firefox.exe
set ERRORLEVEL=

:: Check if that annoying Master Password prompt is open and close it
ping 1.0.0.0 -n 1 -w 2000 > nul
start ""  "%FFexec%" & exit