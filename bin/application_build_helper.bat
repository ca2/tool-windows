@echo off
set ARCH=%PROCESSOR_ARCHITECTURE%
if defined PROCESSOR_ARCHITEW6432 set ARCH=%PROCESSOR_ARCHITEW6432%

if /I "%ARCH%"=="ARM64" (
    application_build_helper_arm64.exe %*
) else (
    application_build_helper_x64.exe %*
)
