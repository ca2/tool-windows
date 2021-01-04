
svn cleanup "C:\simple\source\%~n1\_matter"

svn update "C:\simple\source\%~n1\_matter"

mkdir "%APPDATA%\ca2\appmatter\%~n1\_matter"

xcopy ""C:\simple\source%~n1\_matter\*.*" "%APPDATA%\ca2\appmatter\%~n1\_matter" /Y /R /D /I /C /E
