cd "C:\bergedge\lemon\windows\scripts"

copy "C:\Program Files\Adobe\Adobe Dreamweaver CC 2017\configuration\Extensions.txt" .\Extensions_backup.txt
copy "C:\Program Files (x86)\Adobe\Adobe Dreamweaver CC 2017\configuration\DocumentTypes\MMDocumentTypes.xml" .\MMDocumentTypes_backup.xml
copy  "%APPDATA%\Adobe\Dreamweaver CC 2017\en_US\Configuration\Extensions.txt" .\Extensions_appdata.txt
copy  "%APPDATA%\Adobe\Dreamweaver CC 2017\en_US\Configuration\DocumentTypes\MMDocumentTypes.xml" .\MMDocumentTypes_appdata.txt

copy .\Extensions.txt "C:\Program Files\Adobe\Adobe Dreamweaver CC 2017\configuration\Extensions.txt"
copy .\MMDocumentTypes.xml "C:\Program Files\Adobe\Adobe Dreamweaver CC 2017\configuration\DocumentTypes\MMDocumentTypes.xml"
copy .\MMDocumentTypes.xml "%APPDATA%\Adobe\Dreamweaver CC 2017\en_US\Configuration\DocumentTypes\MMDocumentTypes.txt"