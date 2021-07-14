
for /d %%i in (M:\matter\*) do (

call %~dp0\copymatter_item.bat "%%i"

)
