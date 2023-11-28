hstart /noconsole "cmd /c echo "Starting to clean third solution. These first 8 steps are quick." | ptts"

devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "basis|Win32"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 1 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "cube_basis|Win32"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 2 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "cube_stage|Win32"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 3 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "stage|Win32"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 4 of 8" | ptts"

devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "basis|x64"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 5 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "cube_basis|x64"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 6 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "cube_stage|x64"
hstart /noconsole "cmd /c echo "Cleaning third solution Step 7 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Clean "stage|x64"

echo "Cleaning third solution Complete!!" | ptts


hstart /noconsole "cmd /c echo "Starting to build third solution. Next 8 steps can take several minutes each." | ptts"


call lengthy 


devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "basis|Win32"
hstart /noconsole "cmd /c echo "Building third solution, basis Configuration, Win32 Platform, Step 1 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "cube_basis|Win32"
hstart /noconsole "cmd /c echo "Building third solution, cube basis Configuration, Win32 Platform, Step 2 of 8 | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "cube_stage|Win32"
hstart /noconsole "cmd /c echo "Building third solution, cube stage Configuration, Win32 Platform, Step 3 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "stage|Win32"
hstart /noconsole "cmd /c echo "Building third solution, stage Configuration, Win32 Platform, Step 4 of 8" | ptts"


devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "basis|x64"
hstart /noconsole "cmd /c echo "Building third solution, basis Configuration, x64 Platform, Step 5 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "cube_basis|x64"
hstart /noconsole "cmd /c echo "Building third solution, cube basis Configuration, x64 Platform, Step 6 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "cube_stage|x64"
hstart /noconsole "cmd /c echo "Building third solution, cube stage Configuration, x64 Platform, Step 7 of 8" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\third.sln /Build "stage|x64"


call stop_player


echo "Building third solution, stage Configuration, x64 Platform, Step 8 of 8" | ptts


hstart /noconsole "cmd /c echo "Third solution build complete!!" | ptts"


call third_finished 

