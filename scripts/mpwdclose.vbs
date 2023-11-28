Set MPWDclose = WScript.CreateObject("WScript.Shell")

WScript.Sleep 250
MPWDclose.AppActivate("Password Required")
WScript.Sleep 250
MPWDclose.Sendkeys "{ESC}"
WScript.Sleep 50
WScript.Quit