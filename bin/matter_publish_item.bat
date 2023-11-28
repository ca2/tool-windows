SETLOCAL enabledelayedexpansion
SETLOCAL EnableExtensions
chcp 65001


M:


set dirsource=M:\matter\%~1\appmatter


svn revert -R "%dirsource%"


svn cleanup --remove-unversioned "%dirsource%"


svn update "%dirsource%"


set dircompressed=M:\matter-compressed\%~1\appmatter\


del /f /s /q %dircompressed%* 

rem exit /b

IF NOT EXIST "%dircompressed%" mkdir "%dircompressed%"



cd "%dirsource%"


for /D %%d in (*.*) do (

if "%%d" NEQ ".svn" (

   cd "%dirsource%\%%d\"
   zip "%dircompressed%%%d.zip" -r "*"

)


)


call %__operating-system%\tool-windows\script\copy_matter_item "%~1"

