
call stop_player

timeout /t 2

call lengthy


set STEP_COUNT=13


hstart /noconsole "cmd /c echo "Starting to build smoke tests solutions. Next %STEP_COUNT% steps are quite lengthy." | ptts"


call build_solution_x64_basis __hello
hstart /noconsole "cmd /c echo "Step 1 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis app
hstart /noconsole "cmd /c echo "Step 2 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis simple
hstart /noconsole "cmd /c echo "Step 3 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis form
hstart /noconsole "cmd /c echo "Step 4 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis complex
hstart /noconsole "cmd /c echo "Step 5 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis basic
hstart /noconsole "cmd /c echo "Step 6 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis audio
hstart /noconsole "cmd /c echo "Step 7 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis core
hstart /noconsole "cmd /c echo "Step 8 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis multimedia
hstart /noconsole "cmd /c echo "Step 9 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis design
hstart /noconsole "cmd /c echo "Step 10 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis foundation
hstart /noconsole "cmd /c echo "Step 11 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis arcade
hstart /noconsole "cmd /c echo "Step 12 of %STEP_COUNT%" | ptts"
call build_solution_x64_basis core_games
hstart /noconsole "cmd /c echo "Step 13 of %STEP_COUNT%" | ptts"


call third_finished