
set operating-system=%~dp0\..\..\..\operating-system
set time_windows=%~dp0\..\..\..\time-windows

mkdir %USERPROFILE%\application\app_simple_change_grub_default_entry\time-windows\x64\basis\
xcopy %time_windows%\x64\basis\*.*  %USERPROFILE%\application\app_simple_change_grub_default_entry\time-windows\x64\basis\ /Y /R /F /I /C /E
copy "%operating-system%\tool-windows\lnk\Change GRUB default entry.lnk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\"
copy "%operating-system%\tool-windows\lnk\Change GRUB default entry.lnk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"





