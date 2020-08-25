
svn cleanup "M:\matter\%~n1\appmatter"

svn update "M:\matter\%~n1\appmatter"

mkdir "%APPDATA%\ca2\appmatter\%~n1\appmatter"

xcopy "M:\matter\%~n1\appmatter\*.*" "%APPDATA%\ca2\appmatter\%~n1\appmatter" /Y /R /D /I /C /E
