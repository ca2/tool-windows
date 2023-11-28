SETLOCAL EnableExtensions
chcp 65001


set /p releasedatetime=<%__%\build\windows\build\releasedatetime.txt


title Releasing ca2 %releasedatetime% ...


xcopy "C:\stage\app\stage\metastage\*.*" "%__%\build\windows\store\%releasedatetime%\metastage" /Y /R /D /I /C /E


"C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\symstore.exe" add /f \\ca-netnode\store\windows\%releasedatetime%\*.pdb /s \\ca-netnode\symbols /t "ca2 Framework Base Applications" /v "Build %releasedatetime%" /c "Adding ca2 Framework Base Applications Build %releasedatetime%" /o


echo %releasedatetime% > %__%\build\windows\store\build.txt





