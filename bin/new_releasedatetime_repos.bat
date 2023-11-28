SETLOCAL EnableExtensions
chcp 65001


set /p releasedatetime=<%__%\share\new_tag\releasedatetime.txt
set /p releasecomma=<%__%\share\new_tag\releasecomma.txt
set /p releasedot=<%__%\share\new_tag\releasedot.txt


title Releasing ca2 %releasedatetime% ...


call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-cidadedecuritiba
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-core
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" shared/app-simple
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-veriwell
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" ca2
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" design
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" game
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" include
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" operating-system-windows
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" operating-system-linux
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" operating-system-macos
call %__%\operating-system\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" third

