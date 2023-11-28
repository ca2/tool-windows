SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
chcp 65001

set datetimeparam=%~1
set datetime=%datetimeparam:~0,4%%datetimeparam:~5,2%%datetimeparam:~8,2%%datetimeparam:~11,2%%datetimeparam:~14,2%%datetimeparam:~17,2%
rem for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do @set datetime=%%I
set releasedatetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%-%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
echo %releasedatetime%
set releasedatetimetext=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%
echo %releasedatetimetext%
set monthday=%datetime:~4,2%%datetime:~6,2%
echo %monthday%
set /a monthday=10000%monthday% %% 10000
echo %monthday%
set hourminute=%datetime:~8,2%%datetime:~10,2%
echo %hourminute%
set /a hourminute=10000%hourminute% %% 10000
echo %hourminute%
set releasecomma=%datetime:~0,4%, %monthday%, %hourminute%, %datetime:~12,2%
echo %releasecomma%
set releasedot=%datetime:~0,4%.%monthday%.%hourminute%.%datetime:~12,2%
echo %releasedot%
set releasedatefolder=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2%
echo %releasedatefolder%
set releasetime=%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
echo %releasedatefolder%


mkdir C:\share\new_tag


echo|set /P ="%releasedatetimetext%" > C:\share\new_tag\releasedatetimetext.txt
echo|set /P ="%releasedatetime%" > C:\share\new_tag\releasedatetime.txt
echo|set /P ="%releasecomma%" > C:\share\new_tag\releasecomma.txt
echo|set /P ="%releasedatefolder%" > C:\share\new_tag\releasedatefolder.txt
echo|set /P ="%releasetime%" > C:\share\new_tag\releasetime.txt
echo|set /P ="%releasedot%" > C:\share\new_tag\releasedot.txt


call matter_publish


call new_releasedatetime_version

call new_releasedatetime_repos

copy C:\share\new_tag\*.txt C:\share\



