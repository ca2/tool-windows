Set FFstart = WScript.CreateObject("WScript.Shell")
WScript.Sleep 250
If Not FFstart.AppActivate("- Firefox Developer Edition") then
FFstart.Exec "C:\bergedge\lemon\windows\scripts\startFFnight.bat"
End If
