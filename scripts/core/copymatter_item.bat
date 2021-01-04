
#svn cleanup "M:\matter\%~n1\_matter"

#svn update "M:\matter\%~n1\_matter"

mkdir "%APPDATA%\ca2\appmatter\%~n1\_matter"

xcopy "M:\matter\%~n1\_matter\*.*" "%APPDATA%\ca2\appmatter\%~n1\_matter" /Y /R /D /I /C /E
