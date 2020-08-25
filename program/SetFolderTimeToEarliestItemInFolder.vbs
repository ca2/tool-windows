' This VBScript source finds the earliest (modified) timestamp of all the files
' in a directory and then uses TouchCmd to set the directory timestamp to that value.
'
' Usage:
'	cscript SetFolderToEarliestFile.vbs DirectoryPath [r]
'       The optional "r" parameter makes the script recursive
' e.g.
'	cscript SetFolderToEarliestFile.vbs "c:\my directory name"
'
' Copyright JD Design 2005-2013

Dim fso
set fso = CreateObject( "Scripting.FileSystemObject" )

'1'st parameter is a directory path
Dim dirname
dirname = WScript.Arguments(0)

'2'nd parameter is a flag to indicate recursive operation
Dim bRecurse
bRecurse = true

if WScript.Arguments.Count >=2 Then
    Dim Param2
    Param2 = WScript.Arguments(1)
    if Param2 = "r" then
        bRecurse = true
    else
        Wscript.Echo "Unexpected parameter: " & Param2
    end if
end if


Dim fold
set fold = fso.GetFolder( dirname )
DoThisFolder fold, bRecurse
Stop

Sub DoThisFolder( fold, RecurseFlag )

    if RecurseFlag = true then
        For Each Subfolder in fold.SubFolders
'            Wscript.Echo Subfolder.Path
            DoThisFolder Subfolder, RecurseFlag
        Next
    end if

	'Get the earliest date of any files
    dim EarliestDate
    Dim CurDate

    Dim file
    for each file in fold.Files
    '	WScript.Echo file.Name

        'If a file's timestamp doesn't exist, accessing it may cause a runtime error, so avoid it
	    on error resume next
	    Err.clear()
				
        CurDate = file.DateLastModified
        '	WScript.Echo CurDate
        if Err.Number = 0 and ( IsEmpty(EarliestDate) or (CurDate < EarliestDate) ) then
            EarliestDate = CurDate
        end if
        
        On Error Goto 0
    next

    'Get the earliest date of any sub-folders
    For Each Subfolder in fold.SubFolders
        
        'If a folder's timestamp doesn't exist, accessing it may cause a runtime error, so avoid it
	    on error resume next
	    Err.clear()
				
        CurDate = Subfolder.DateLastModified
        '	WScript.Echo CurDate
        if Err.Number = 0 and ( IsEmpty(EarliestDate) or (CurDate < EarliestDate) ) then
            EarliestDate = CurDate
        end if
        
        On Error Goto 0
    Next

    if not IsEmpty( EarliestDate ) Then
    '	WScript.Echo "Earliest file time in " & fold.Path & " is: " & EarliestDate

        'Execute TouchCmd to touch the folder
        Dim WshShell
        Set WshShell = WScript.CreateObject("WScript.Shell")

        dim progname
        'Add quotes around the path to TouchCmd
        progname = chr(34) & WshShell.ExpandEnvironmentStrings("%programfiles%\JD Design\TouchPro\TouchCmd.exe") & chr(34)
    '	WScript.Echo "progname: " & progname
    
        dim params
        params = "/D" & DateValue(EarliestDate)
        params = params & " /T" & TimeValue(EarliestDate)
        params = params & " /M /O " & chr(34) & fold.Path & "\" & chr(34)
        progname = progname & " " & params
'	        Wscript.echo progname
'           'Wscript.Sleep 2000
        WshShell.Run progname, 0, true

        'Set oExec = WshShell.Exec( progname )
        'Do While oExec.Status = 0
        '     WScript.Sleep 100
        'Loop
    else
        Wscript.echo "Unable to get the earliest file or folder in: " & fold.Path
    end if

End Sub