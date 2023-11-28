

set time_windows=%~dp0\..\..\..\time-windows

mkdir C:\core\time\Win32\
xcopy %time_windows%\Win32\*.exe C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy %time_windows%\Win32\*.dll C:\core\time\Win32\ /Y /R /F /I /C /E
xcopy %time_windows%\Win32\*.lib C:\core\time\Win32\ /Y /R /F /I /C /E


mkdir C:\core\time\x64\
xcopy %time_windows%\x64\*.exe C:\core\time\x64\ /Y /R /F /I /C /E
xcopy %time_windows%\x64\*.dll C:\core\time\x64\ /Y /R /F /I /C /E
xcopy %time_windows%\x64\*.lib C:\core\time\x64\ /Y /R /F /I /C /E


call %~dp0\copymatter.bat



