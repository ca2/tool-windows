

:loop

IF EXIST "%__%\build\macos\build\start_server.txt" call "%__%\operating-system\tool\bin\macos_start_server.bat"

timeout /t 2

goto loop


