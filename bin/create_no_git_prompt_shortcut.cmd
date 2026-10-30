@echo off
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0create_no_git_prompt_shortcut.ps1" %*
exit /b %errorlevel%
