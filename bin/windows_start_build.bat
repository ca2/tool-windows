SETLOCAL EnableExtensions
chcp 65001


IF NOT EXIST "%__%\build\windows\build" mkdir "%__%\build\windows\build"


IF NOT EXIST "%__%\build\windows\build_log" mkdir "%__%\build\windows\build_log"


IF NOT EXIST "%__%\build\windows\store" mkdir "%__%\build\windows\store"


copy /Y "%__%\share\releasedatetime.txt" %__%\build\windows\build\releasedatetime.txt


copy /Y "%__%\share\releasedot.txt" %__%\build\windows\build\releasedot.txt


copy /Y "%__%\share\releasecomma.txt" %__%\build\windows\build\releasecomma.txt


copy /Y "%__%\share\releasedatetime.txt" %__%\build\windows\build\build_started.txt


set /p releasedatetime=<%__%\build\windows\build\releasedatetime.txt


set /p releasedot=<%__%\build\windows\build\releasedot.txt


set buildlogfolder=%__%\build\windows\time\%releasedatetime%\build_log


mkdir "%buildlogfolder%"


set buildstartedtimefile=%buildlogfolder%\build_started_time.txt


for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do @set datetime=%%I
set buildstartedtime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%


echo|set /P ="%buildstartedtime%" > "%buildstartedtimefile%"


set buildlog=%buildlogfolder%\build.log


set mailfolder=%__%\build\windows\time\%releasedatetime%\mail


mkdir "%mailfolder%"


set buildstatustitle=[Windows][%releasedatetime%] Build started!!


set buildstatusprefix=🥁


echo %buildstatusprefix%%buildstatustitle% > %mailfolder%\build_start.txt


mail -r "production@ca2.email" -s "%buildstatustitle%" -b "@%mailfolder%\build_start.txt"


call post_status2 stage@ca2.cc "[%releasedatetime%] " "%buildstatusprefix%" " Windows Build Started!!"


echo "[%releasedatetime%] " "%buildstatusprefix%" " Windows Build Started!!" > "%buildlog%"


call "%__%\operating-system\tool\bin\windows_update_stage.bat" 2>&1 | tee -a "%buildlog%"


echo. | tee -a "%buildlog%"
echo. | tee -a "%buildlog%"
echo "See %buildlog%" | tee -a "%buildlog%"
echo. | tee -a "%buildlog%"
echo. | tee -a "%buildlog%"


call "%__%\operating-system\tool\bin\windows_build_all64.bat"



