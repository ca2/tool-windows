

del "%__%\build\%1\build\start_server.txt"


call "%__%\operating-system\tool\bin\show_build_machine.bat" %1 %2


vmrun -T ws start "%2:\computer\build\%1\%1.vmx" nogui


call "%__%\operating-system\tool\bin\show_build_machine.bat" %1 %2



