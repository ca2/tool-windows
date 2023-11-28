SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
chcp 65001

set releasedatetime=%~1
set releasecomma=%~2
set releasedot=%~3
set repos=%~4

@set urlstageoperating-system=https://repos.ca2.cc/%repos%/tags/stage-%releasedatetime%/
@set urlstage=https://repos.ca2.cc/%repos%/stage/
@set urlbasis=https://repos.ca2.cc/%repos%/basis/

echo %releasedatetime% > C:\basis\%repos%\releasedatetime.txt
echo %releasecomma% > C:\basis\%repos%\releasecomma.txt
echo %releasedot% > C:\basis\%repos%\releasedot.txt

svn -m "<3tbs %releasedatetime%" commit M:\basis\%repos%

svn del -m "new stage-%~1 release - deleting old stage" "%urlstage%"
svn copy -m "new stage-%~1 release - creating new stage" "%urlbasis%" "%urlstage%"
svn copy -m "new stage-%~1 release - creating stage operating-system" "%urlstage%" "%urlstageoperating-system%"








