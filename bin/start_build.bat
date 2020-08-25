

IF "%1" == "macos" (

call macos_start_build.bat

) ELSE IF "%1" == "windows" (

call windows_start_build.bat

) ELSE (

call linux_start_build.bat %1

)


