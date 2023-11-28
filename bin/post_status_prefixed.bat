@for /f "delims=" %%a in ('utc') do @set posttime=%%a
@for /f "delims=" %%a in ('email_id "%1"') do @set id=%%a
@mysql --defaults-extra-file="C:\sensitive\sensitive\public_mysql\post_status.cnf" -e "INSERT INTO user_tiny_status(`user`, `datetime`, `value`) VALUES('%id%', '%posttime%', '%~3%~2');"