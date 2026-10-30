[CmdletBinding()]
param([string]$GitRoot)

$ErrorActionPreference = 'Stop'

# Recreate the shortcuts after cloning this tool repository on another machine:
#   create_no_git_prompt_shortcut.cmd
# For a nonstandard Git installation:
#   create_no_git_prompt_shortcut.cmd -GitRoot "D:\Apps\Git"

if (!$GitRoot) {
    $candidates = @(
        (Join-Path $env:ProgramFiles 'Git'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Git')
    )
    $gitCommand = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($gitCommand) {
        $parent = Split-Path $gitCommand.Source -Parent
        while ($parent) {
            $candidates += $parent
            $parent = Split-Path $parent -Parent
        }
    }
    $GitRoot = $candidates | Where-Object {
        Test-Path -LiteralPath (Join-Path $_ 'usr\bin\mintty.exe')
    } | Select-Object -First 1
}
if (!$GitRoot) {
    throw 'Git for Windows was not found. Specify -GitRoot with its installation directory.'
}

$mintty = Join-Path $GitRoot 'usr\bin\mintty.exe'
$icon = Join-Path $GitRoot 'git-bash.exe'
$promptScript = Join-Path $PSScriptRoot 'no_git_prompt'
foreach ($path in @($mintty, $icon, $promptScript)) {
    if (!(Test-Path -LiteralPath $path)) { throw "Required file not found: $path" }
}

function ConvertTo-WindowsArgument([string]$Value) {
    # Escape quotes and the backslashes immediately preceding quotes or the end.
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
}

$posixPromptScript = $promptScript.Replace('\', '/')
if ($posixPromptScript -match '^([A-Za-z]):(.*)$') {
    $posixPromptScript = '/' + $Matches[1].ToLowerInvariant() + $Matches[2]
}
$quotedPromptScript = "'" + $posixPromptScript.Replace("'", "'\''") + "'"
$shellCommand = "source $quotedPromptScript && exec /usr/bin/bash --noprofile --norc -i"
$appId = 'ca2.GitBash.NoGitPrompt'
$appName = 'Git Bash (no Git prompt)'
$options = @('--nodaemon', '-o', "AppID=$appId", '-o', "AppName=$appName", '-i', "$icon,0")
$command = @('--exec', '/usr/bin/env', 'MSYSTEM=MINGW64', '/usr/bin/bash', '--login', '-i', '-c', $shellCommand)
$relaunch = (@($mintty) + $options + $command | ForEach-Object { ConvertTo-WindowsArgument $_ }) -join ' '
$arguments = ($options + @('-o', "AppLaunchCmd=$relaunch", '--store-taskbar-properties') + $command |
    ForEach-Object { ConvertTo-WindowsArgument $_ }) -join ' '

# Match the shortcut's AppUserModelID to the mintty window's identity, so the
# pinned icon groups with this window and relaunches the same configuration.
if (!('Ca2ShortcutProperties' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;

public static class Ca2ShortcutProperties {
    [StructLayout(LayoutKind.Sequential)]
    public struct PropertyKey { public Guid format; public uint id; }

    [StructLayout(LayoutKind.Explicit, Size = 24)]
    public struct PropVariant {
        [FieldOffset(0)] public ushort type;
        [FieldOffset(8)] public IntPtr text;
    }

    [ComImport, Guid("886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IPropertyStore {
        [PreserveSig] int GetCount(out uint count);
        [PreserveSig] int GetAt(uint index, out PropertyKey key);
        [PreserveSig] int GetValue(ref PropertyKey key, out PropVariant value);
        [PreserveSig] int SetValue(ref PropertyKey key, ref PropVariant value);
        [PreserveSig] int Commit();
    }

    public static void SetAppId(string path, string id) {
        object link = Activator.CreateInstance(Type.GetTypeFromCLSID(new Guid("00021401-0000-0000-C000-000000000046")));
        IntPtr text = IntPtr.Zero;
        try {
            var file = (IPersistFile)link;
            file.Load(path, 2);
            var store = (IPropertyStore)link;
            var key = new PropertyKey { format = new Guid("9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3"), id = 5 };
            text = Marshal.StringToCoTaskMemUni(id);
            var value = new PropVariant { type = 31, text = text };
            Marshal.ThrowExceptionForHR(store.SetValue(ref key, ref value));
            Marshal.ThrowExceptionForHR(store.Commit());
            file.Save(path, true);
        } finally {
            if (text != IntPtr.Zero) Marshal.FreeCoTaskMem(text);
            Marshal.FinalReleaseComObject(link);
        }
    }
}
'@
}

$programs = [Environment]::GetFolderPath('Programs')
$paths = @(
    (Join-Path $PSScriptRoot 'no_git_prompt.lnk'),
    (Join-Path $programs "$appName.lnk")
)
$wsh = New-Object -ComObject WScript.Shell
foreach ($path in $paths) {
    $shortcut = $wsh.CreateShortcut($path)
    $shortcut.TargetPath = $mintty
    $shortcut.Arguments = $arguments
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.IconLocation = "$icon,0"
    $shortcut.Description = 'Git Bash with a fast prompt, without Git lookups or a leading blank line.'
    $shortcut.Save()
    [Ca2ShortcutProperties]::SetAppId($path, $appId)
    Write-Output "Created: $path"
}
Write-Output 'Open the shortcut, then right-click its taskbar icon and choose Pin to taskbar.'
