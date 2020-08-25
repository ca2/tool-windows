

:loop

IF EXIST "%__%\share\ubuntu\build\start_server.txt" call "%__%\archive\tool\bin\ubuntu_start_server.bat"

timeout /t 2

goto loop


