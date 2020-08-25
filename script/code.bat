

%HOMEDRIVE%


IF NOT EXIST %HOMEPATH%\__archive\archive (
mkdir %HOMEPATH%\__archive\archive
)


IF NOT EXIST %HOMEPATH%\__archive\basis (
mkdir %HOMEPATH%\__archive\basis
)


svn checkout https://ca2.io/app/basis %HOMEPATH%\__archive\basis\app
svn checkout https://ca2.io/shared/app-simple/basis %HOMEPATH%\__archive\basis\app-simple
svn checkout https://ca2.io/include/basis %HOMEPATH%\__archive\basis\include
svn checkout https://ca2.io/platform-windows/basis %HOMEPATH%\__archive\basis\platform-windows
svn checkout https://ca2.io/third/basis %HOMEPATH%\__archive\basis\third


svn checkout https://ca2.io/shared/platform-windows/basis %HOMEPATH%\__archive\archive\platform-windows
svn checkout https://ca2.io/shared/storage-windows/basis %HOMEPATH%\__archive\archive\storage-windows
svn checkout https://ca2.io/shared/tool-windows %HOMEPATH%\__archive\archive\tool-windows



