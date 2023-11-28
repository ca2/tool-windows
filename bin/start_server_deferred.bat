

:loop

call "%__%\operating-system\tool\bin\start_build_machine_deferred.bat" ubuntu C

call "%__%\operating-system\tool\bin\start_build_machine_deferred.bat" manjaro C

call "%__%\operating-system\tool\bin\start_build_machine_deferred.bat" fedora C

call "%__%\operating-system\tool\bin\start_build_machine_deferred.bat" opensuse M

call "%__%\operating-system\tool\bin\start_build_machine_deferred.bat" macos M

call "%__%\operating-system\tool\bin\start_desktop_machine_deferred.bat" windows M

call "%__%\operating-system\tool\bin\run_main_ido_deferred.bat"

timeout /t 2

goto loop


