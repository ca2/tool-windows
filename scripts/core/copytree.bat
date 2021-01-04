mkdir C:\core\time\Win32\
xcopy C:\basis\time-windows\Win32\*.exe C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy C:\basis\time-windows\Win32\*.dll C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy C:\basis\time-windows\Win32\*.lib C:\core\time\Win32\ /Y /R /F /I /C /E

mkdir C:\core\time\x64\
xcopy C:\basis\time-windows\x64\*.exe C:\core\time\x64\ /Y /R /F /I /C /E
xcopy C:\basis\time-windows\x64\*.dll C:\core\time\x64\ /Y /R /F /I /C /E
xcopy C:\basis\time-windows\x64\*.lib C:\core\time\x64\ /Y /R /F /I /C /E


call C:\basis\archive\tool-windows\scripts\core\copymatter.bat