


call lengthy


hstart /noconsole "cmd /c echo "Starting to build smoke tests solutions." | ptts"


rmdir C:\basis\time-windows /s /q


call build_solution __hello
call build_solution app
call build_solution simple
call build_solution form
call build_solution complex
call build_solution basic
call build_solution audio
call build_solution core
call build_solution multimedia
call build_solution design
call build_solution foundation
call build_solution arcade
call build_solution core_games


call third_finished