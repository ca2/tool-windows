

IF EXIST "%2:\computer\desktop\%1\start_server.txt" (

	call "%__%\operating-system\tool\bin\start_desktop_machine.bat" %1 %2

	timeout /t 15

)

