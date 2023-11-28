SETLOCAL EnableDelayedExpansion

for /f "Tokens=* Delims=" %%x in (C:\operating-system\prompt.txt) do set text=!Build!%%x

echo %text%

call lib_say "%text%"