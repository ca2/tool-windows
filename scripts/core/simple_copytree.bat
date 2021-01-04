mkdir C:\core\time\Win32\
xcopy C:\simple\time-windows\Win32\*.exe C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy C:\simple\time-windows\Win32\*.dll C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy C:\simple\time-windows\Win32\*.lib C:\core\time\Win32\ /Y /R /F /I /C /E

mkdir C:\core\time\x64\
xcopy C:\simple\time-windows\x64\*.exe C:\core\time\x64\ /Y /R /F /I /C /E
xcopy C:\simple\time-windows\x64\*.dll C:\core\time\x64\ /Y /R /F /I /C /E
xcopy C:\simple\time-windows\x64\*.lib C:\core\time\x64\ /Y /R /F /I /C /E


call C:\simple\archive\tool-windows\scripts\core\simple_copymatter.bat