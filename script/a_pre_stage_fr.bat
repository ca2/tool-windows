del /f /s /q Z:\basis_stage\time\aqua\*

svn export https://fr-ca2.io/app/stage Z:\basis_stage\time\aqua\app
svn export https://fr-ca2.io/app-cidadedecuritiba/stage Z:\basis_stage\time\aqua\app-cidadedecuritiba
svn export https://fr-ca2.io/app-core/stage Z:\basis_stage\time\aqua\app-core
svn export https://fr-ca2.io/app-frontpage/stage Z:\basis_stage\time\aqua\app-frontpage
svn export https://fr-ca2.io/app-sysutils/stage Z:\basis_stage\time\aqua\app-sysutils
svn export https://fr-ca2.io/app-veriwell/stage Z:\basis_stage\time\aqua\app-veriwell
svn export https://fr-ca2.io/ca2/stage Z:\basis_stage\time\aqua\ca2
svn export https://fr-ca2.io/main/database-dev Z:\basis_stage\time\aqua\database
svn export https://fr-ca2.io/main/stage/include Z:\basis_stage\time\aqua\include
svn export https://fr-ca2.io/nodeapp-windows/stage Z:\basis_stage\time\aqua\nodeapp-windows

del /s Z:\basis_stage\time\aqua\*.cpp
del /s Z:\basis_stage\time\aqua\*.c
del /s Z:\basis_stage\time\aqua\*.def
del /s Z:\basis_stage\time\aqua\*.vcxproj
del /s Z:\basis_stage\time\aqua\*.vcxproj.filters
del /s Z:\basis_stage\time\aqua\*.vcxproj.user
del /s Z:\basis_stage\time\aqua\*.cbp
del /s Z:\basis_stage\time\aqua\*.appxmanifest
del /s Z:\basis_stage\time\aqua\*.pfx
del /s Z:\basis_stage\time\aqua\*.expand_fileset
del /s Z:\basis_stage\time\aqua\*.tlog
del /s Z:\basis_stage\time\aqua\*.rc
del /s Z:\basis_stage\time\aqua\*.sln
del /s Z:\basis_stage\time\aqua\*.suo
del /s Z:\basis_stage\time\aqua\*.bak
del /s Z:\basis_stage\time\aqua\*.log
del /s Z:\basis_stage\time\aqua\framework.h
del /s Z:\basis_stage\time\aqua\*.v12.suo
del /s Z:\basis_stage\time\aqua\*.asm
del /s Z:\basis_stage\time\aqua\*.s
Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf Z:\basis_stage\time\aqua\time
Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf Z:\basis_stage\time\aqua\aqua
mkdir Z:\basis_stage\time\aqua\time\library
xcopy /s /i /y Z:\ca2\stage Z:\basis_stage\time\aqua\stage
xcopy /s /i /y Z:\ca2\time\library Z:\basis_stage\time\aqua\time\library
Y:\bergedge\hi5\program\GnuWin32\bin\find Z:\basis_stage\time\aqua -name *.xcodeproj -exec Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf "{}" +
Y:\bergedge\hi5\program\GnuWin32\bin\find Z:\basis_stage\time\aqua -type d -name *_iosTests -exec Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf "{}" +
Y:\bergedge\hi5\program\GnuWin32\bin\find Z:\basis_stage\time\aqua -type d -name *.tlog -exec Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf "{}" +
Y:\bergedge\hi5\program\GnuWin32\bin\find Z:\basis_stage\time\aqua -type d -name *.svn -exec Y:\bergedge\hi5\program\GnuWin32\bin\rm -rf "{}" +
