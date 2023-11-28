set FFexec=%programfiles(x86)%\Mozilla Firefox\firefox.exe
set ERRORLEVEL=

::Optional Restart Firefox - ping is just a sneaky way of getting sleep functionality
::Uncomment REM to activate
ping 1.0.0.0 -n 1 -w 2000 > nul
start ""  "%FFexec%" & exit