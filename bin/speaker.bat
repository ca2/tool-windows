@echo off
set ARCH=%PROCESSOR_ARCHITECTURE%
if defined PROCESSOR_ARCHITEW6432 set ARCH=%PROCESSOR_ARCHITEW6432%

if /I "%ARCH%"=="ARM64" (
    speaker_arm64.exe %*
) else (
    speaker_x64.exe %*
)
