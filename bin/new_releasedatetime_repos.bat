SETLOCAL EnableExtensions
chcp 65001


set /p releasedatetime=<%__%\share\new_tag\releasedatetime.txt
set /p releasecomma=<%__%\share\new_tag\releasecomma.txt
set /p releasedot=<%__%\share\new_tag\releasedot.txt


title Releasing ca2 %releasedatetime% ...


call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-cidadedecuritiba
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-core
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" shared/app-simple
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" app-veriwell
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" ca2
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" design
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" game
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" include
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" platform-windows
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" platform-linux
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" platform-macos
call %__%\archive\tool\bin\new_releasedatetime_repos_item %releasedatetime% "%releasecomma%" "%releasedot%" third

