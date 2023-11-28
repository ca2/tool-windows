SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
chcp 65001


set /p releasedatetimetext=<%__%\share\new_tag\releasedatetimetext.txt
set /p releasedatetime=<%__%\share\new_tag\releasedatetime.txt
set /p releasecomma=<%__%\share\new_tag\releasecomma.txt
set /p releasedatefolder=<%__%\share\new_tag\releasedatefolder.txt
set /p releasetime=<%__%\share\new_tag\releasetime.txt
set /p releasedot=<%__%\share\new_tag\releasedot.txt
set filename=
set projectname=


title Setting ca2 version %releasedatetime% ...
echo Setting ca2 version %releasedatetime% ...


set versionfile=M:\basis\operating-system-windows\version


sed "s/%%FILENAME%%/%filename%/g" %versionfile%.txt > %versionfile%1.txt
sed "s/%%PROJECTNAME%%/%projectname%/g" %versionfile%1.txt > %versionfile%2.txt
sed "s/%%RELEASECOMMA%%/%releasecomma%/g" %versionfile%2.txt > %versionfile%3.txt
sed "s/%%RELEASEDOT%%/%releasedot%/g" %versionfile%3.txt > %versionfile%4.txt
sed "s/%%RELEASEDATETIME%%/%releasedatetime%/g" %versionfile%4.txt  > %versionfile%5.txt


icopy %versionfile%5.txt %versionfile%.rc


echo %versionfile%.rc
echo .
echo .
cat %versionfile%.rc


set buildinclude=const char * pszBuild="%releasedatetime%";

echo %buildinclude% > M:\basis\operating-system-macos\build.h

echo %buildinclude% > M:\basis\operating-system-linux\build.h

echo %buildinclude% > M:\basis\operating-system-windows\build.h

