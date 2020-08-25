SETLOCAL EnableDelayedExpansion

for /f "Tokens=* Delims=" %%x in (C:\archive\prompt.txt) do set text=!Build!%%x

echo %text%

call lib_say "%text%"