SETLOCAL EnableExtensions
chcp 65001


svn revert -R M:\stage\*


for /f %%f in ('dir /b M:\stage\') do (svn cleanup --remove-unversioned "%%f" )


svn update M:\stage\*



