
set sln=%1

hstart /noconsole "cmd /c echo "Starting to build %sln% solution, x64, basis" | ptts"

devenv C:\basis\operating-system\operating-system-windows\_seed\%sln%.sln /Build "basis|x64"
hstart /noconsole "cmd /c echo "Building %sln% solution, basis Configuration, x64 Platform" | ptts"





