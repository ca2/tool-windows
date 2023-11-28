
hstart /noconsole "cmd /c echo "Starting to build %sln% solution. The next 8 steps can take several minutes each." | ptts"

devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "basis|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, basis Configuration, Win32 Platform, Step 9 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "cube_basis|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, cube basis Configuration, Win32 Platform, Step 10 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "cube_stage|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, cube stage Configuration, Win32 Platform, Step 11 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "stage|Win32"
hstart /noconsole "cmd /c echo "Building  %sln% solution, stage Configuration, Win32 Platform, Step 12 of 16" | ptts"


devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "basis|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, basis Configuration, x64 Platform, Step 13 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "cube_basis|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, cube basis Configuration, x64 Platform, Step 14 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "cube_stage|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, cube stage Configuration, x64 Platform, Step 15 of 16" | ptts"
devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "stage|Win32"
hstart /noconsole "cmd /c echo "Building %sln% solution, cube stage Configuration, x64 Platform, Step 15 of 16" | ptts"

echo "%sln% solution build complete!!" | ptts



