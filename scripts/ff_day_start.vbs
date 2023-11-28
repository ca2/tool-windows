Set FFstart = WScript.CreateObject("WScript.Shell")
WScript.Sleep 250
If Not FFstart.AppActivate("- Mozilla Firefox") then
FFstart.Exec "C:\bergedge\lemon\windows\scripts\startFFday.bat"
End If
