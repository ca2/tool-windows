Set FFquit = WScript.CreateObject("WScript.Shell")
WScript.Sleep 250
FFquit.AppActivate("- Mozilla Firefox")
WScript.Sleep 250
FFquit.Sendkeys "%F"
WScript.Sleep 100 
FFquit.Sendkeys "x"
WScript.Quit