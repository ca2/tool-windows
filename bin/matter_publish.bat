

M:


cd M:\matter


dir /a:d /b > %__%\archive\tool\bin\matter_list.txt


set lines=%__%\archive\tool\bin\matter_list.txt


SETLOCAL enabledelayedexpansion


for /F "tokens=* delims=" %%a in ('Type "%lines%"') do (
	
	call %__%\archive\tool\bin\matter_publish_item %%a

)
