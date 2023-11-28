SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion
chcp 65001


call new_releasedatetime_start

call matter_publish

call new_releasedatetime_commit

call new_releasedatetime_repos

copy %__%\share\new_tag\*.txt %__%\share\



