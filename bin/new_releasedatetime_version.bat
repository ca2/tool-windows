SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
chcp 65001


echo|set /P ="%releasedatetimetext%" > C:\share\new_tag\releasedatetimetext.txt
echo|set /P ="%releasedatetime%" > C:\share\new_tag\releasedatetime.txt
echo|set /P ="%releasecomma%" > C:\share\new_tag\releasecomma.txt
echo|set /P ="%releasedatefolder%" > C:\share\new_tag\releasedatefolder.txt
echo|set /P ="%releasetime%" > C:\share\new_tag\releasetime.txt
echo|set /P ="%releasedot%" > C:\share\new_tag\releasedot.txt
set filename=
set projectname=


title Setting ca2 version %releasedatetime% ...
echo Setting ca2 version %releasedatetime% ...


set versionfile=M:\basis\operating-system-windows\version


sed "s/%%FILENAME%%/%filename%/g" %versionfile%.txt > %versionfile%1
sed "s/%%PROJECTNAME%%/%projectname%/g" %versionfile%1 > %versionfile%2
sed "s/%%RELEASECOMMA%%/%releasecomma%/g" %versionfile%2 > %versionfile%3
sed "s/%%RELEASEDOT%%/%releasedot%/g" %versionfile%3 > %versionfile%4
sed "s/%%RELEASEDATETIME%%/%releasedatetime%/g" %versionfile%4  > %versionfile%5


icopy %versionfile%5 %versionfile%.rc


echo %versionfile%.rc
echo .
echo .
cat %versionfile%.rc


set buildinclude="const char * pszBuild=\"%releasedatetime%\";" 

echo %buildinclude% > M:\basis\operating-system-macos\build.h



