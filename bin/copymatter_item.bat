
cd "M:\matter\%~n1"

git fetch origin

mkdir "%APPDATA%\ca2\appmatter\%~n1\_matter"

xcopy "M:\matter\%~n1\_matter\*.*" "%APPDATA%\ca2\appmatter\%~n1\_matter" /Y /R /D /I /C /E
