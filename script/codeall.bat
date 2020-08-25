

%HOMEDRIVE%


IF NOT EXIST %HOMEPATH%\__archive\sensitive (
mkdir %HOMEPATH%\__archive\sensitive
)


IF NOT EXIST %HOMEPATH%\__archive\archive (
mkdir %HOMEPATH%\__archive\archive
)


IF NOT EXIST %HOMEPATH%\__archive\basis (
mkdir %HOMEPATH%\__archive\basis
)

svn checkout https://ca2.io/internal/sensitive %HOMEPATH%\__archive\sensitive\sensitive

svn checkout https://ca2.io/app/basis %HOMEPATH%\__archive\basis\app
svn checkout https://ca2.io/app-cidadedecuritiba/basis %HOMEPATH%\__archive\basis\app-cidadedecuritiba
svn checkout https://ca2.io/app-core/basis %HOMEPATH%\__archive\basis\app-core
svn checkout https://ca2.io/shared/app-simple/basis %HOMEPATH%\__archive\basis\app-simple
svn checkout https://ca2.io/app-veriwell/basis %HOMEPATH%\__archive\basis\app-veriwell
svn checkout https://ca2.io/ca2/basis %HOMEPATH%\__archive\basis\ca2
svn checkout https://ca2.io/design/basis %HOMEPATH%\__archive\basis\design
svn checkout https://ca2.io/game/basis %HOMEPATH%\__archive\basis\game
svn checkout https://ca2.io/include/basis %HOMEPATH%\__archive\basis\include
svn checkout https://ca2.io/platform-windows/basis %HOMEPATH%\__archive\basis\platform-windows
svn checkout https://ca2.io/platform-android/basis %HOMEPATH%\__archive\basis\platform-android
svn checkout https://ca2.io/platform-uwp/basis %HOMEPATH%\__archive\basis\platform-uwp
svn checkout https://ca2.io/third/basis %HOMEPATH%\__archive\basis\third


svn checkout https://ca2.io/shared/platform-windows/basis %HOMEPATH%\__archive\archive\platform-windows
svn checkout https://ca2.io/shared/storage-windows/basis %HOMEPATH%\__archive\archive\storage-windows
svn checkout https://ca2.io/shared/tool-windows %HOMEPATH%\__archive\archive\tool-windows

svn checkout https://ca2.io/shared/platform-android/basis %HOMEPATH%\__archive\archive\platform-android
svn checkout https://ca2.io/shared/storage-android/basis %HOMEPATH%\__archive\archive\storage-android
svn checkout https://ca2.io/shared/tool-android %HOMEPATH%\__archive\archive\tool-android

svn checkout https://ca2.io/shared/platform-uwp/basis %HOMEPATH%\__archive\archive\platform-uwp
svn checkout https://ca2.io/shared/storage-uwp/basis %HOMEPATH%\__archive\archive\storage-uwp
svn checkout https://ca2.io/shared/tool-uwp %HOMEPATH%\__archive\archive\tool-uwp


