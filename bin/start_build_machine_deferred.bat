

IF EXIST "%__%\build\%1\build\start_server.txt" (

	call "%__%\operating-system\tool\bin\start_build_machine.bat" %1 %2

	timeout /t 15

)

