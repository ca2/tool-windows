SETLOCAL EnableExtensions
chcp 65001



set /p releasedatetime=<%__%\build\windows\build\releasedatetime.txt
set msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe
set solution=M:\stage\ca2\seed\windows\all64.sln
set logfile=%__%\build\windows\time\%releasedatetime%\build_log\all64.log
set basedir=M:\stage\
set timedir=M:\stage\time-%releasedatetime%\
set outdir=%__%\build\windows\store\%releasedatetime%\
set mailfolder=%__%\build\windows\time\%releasedatetime%\mail

set buildlogfolder=%__%\build\windows\time\%releasedatetime%\build_log
set buildlog=%buildlogfolder%\build.log



"%msbuild%" "%solution%" /t:Build /p:Configuration="stage";Platform=x64;BaseDir=%basedir%;TimeDir=%timedir%;OutDir=%outdir% -maxcpucount -fl -flp:logfile=%logfile%;verbosity=normal


IF %ERRORLEVEL% EQU 0 (

	set buildstatustitle=[Windows][%releasedatetime%] Build succeeded!!

	set shortstatus=Windows Build Succeeded!!

	set buildstatusprefix=😀

	set buildstatuslog=%mailfolder%\build_success.txt
	
	set recipient="production_success@ca2.email" 

	call "%__%\operating-system\tool\bin\windows_thread_store_release.bat" 2>&1 | tee -a "%buildlog%"

	set buildresulttimefile=%buildlogfolder%\build_ok_time.txt

) ELSE (

	set buildstatustitle= [Windows][%releasedatetime%] Build failed!!

	set shortstatus=Windows Build Failed!!

	set buildstatusprefix=😡
	
	set buildstatuslog=%mailfolder%\build_failed.txt

	set recipient="production_failed@ca2.email" 

	set buildresulttimefile=%buildlogfolder%\build_failed_time.txt

)

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do @set datetime=%%I
set buildresulttime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%


echo|set /P ="%buildresulttime%" > "%buildresulttimefile%" 2>&1 | tee -a "%buildlog%"


echo  %buildstatusprefix%%buildstatustitle% > %buildstatuslog%
echo. >> %buildstatuslog%
echo. >> %buildstatuslog%

echo Log: "%buildlog%" >> %buildstatuslog%

cat  %buildlog% >> %buildstatuslog%

echo Log: "%logfile%" >> %buildstatuslog%

cat  %logfile% >> %buildstatuslog%

mail -r "%recipient%" -s "%buildstatustitle%" -b "@%buildstatuslog%" 2>&1

post_status2 stage@ca2.cc "[%releasedatetime%] " "%buildstatusprefix%" " %shortstatus%" 2>&1







