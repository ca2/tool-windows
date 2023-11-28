
for /d %%i in (M:\matter\*) do (

call %__archive%\tool-windows\scripts\core\copymatter_item.bat "%%i"

)
