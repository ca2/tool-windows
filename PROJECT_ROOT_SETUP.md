# Project setup and clone-local setup

These are separate operations. Portable files belong in Git; machine-local
Windows shortcuts and completion state do not.

## Creating or updating a project layout

A maintainer runs `initialize_project_root.exe` (or
`application_build_helper --initialize-project-root`) from the checkout. An
explicit checkout argument or `--root CHECKOUT` is also accepted. This copies
from the local operating_system/operating_system-windows/tool repository:

| Source | Commit-ready destination |
| --- | --- |
| shell | tool/shell (LF preserved) |
| bin/shell.exe | tool/bin/shell.exe |
| image/shell.ico | tool/image/shell.ico |

It ensures root .gitignore ends with `/shell.lnk`, `/.project-root-instance/`
and `/_project_root_instance/` rules. It also sets `/tool/shell text eol=lf` in
root .gitattributes so Windows Git checkouts preserve LF. Commit these files
when creating/updating the project's ca2 layout. This command never creates
shell.lnk or an instance completion marker, never downloads, and never
initializes submodules. It removes the obsolete root shell.exe during migration.
It leaves an existing ignored shortcut alone.

## Using a fresh clone

Initialize the required Windows tool submodule and ensure its native helper
and shortcut executables are available. Setup offers to install GitHub CLI via
WinGet if missing, then offers browser login if authentication is needed.
In Git Bash, from the project root:

```bash
./tool/shell
```

The first run automatically invokes
`operating_system/operating_system-windows/tool/bin/<architecture>/initialize_project_root_instance.exe`.
That shortcut runs `application_build_helper --initialize-project-root-instance`
against this checkout. It validates the committed portable files, ensures the
ignore rules exist, then creates root shell.lnk with these properties:

- Target: <checkout>/tool/bin/shell.exe
- Start in: <checkout>
- Blue icon: <checkout>/tool/image/shell.ico
- Relative target-resolution hint: .\tool\bin\shell.exe

The instance command does not recopy or modify portable setup assets. Only
after successful setup does it write
`.project-root-instance/initialized-root.txt`. The marker records a setup version
and the checkout's absolute Windows path. Both the marker directory and
shell.lnk are ignored by Git. Nothing here is automatically committed or staged.

Subsequent shell starts skip initialization when the marker matches and the
shortcut exists. A missing marker, missing shortcut, or moved/copied checkout
causes setup to run again. Setup failures stop the shell wrapper, return a
nonzero status, and leave first-time setup incomplete so the next run retries.
After the first successful run, shell.lnk can be opened from Explorer.

You can explicitly refresh local setup at any time:

```bash
./operating_system/operating_system-windows/tool/bin/x64/initialize_project_root_instance.exe
# or: application_build_helper --initialize-project-root-instance --root CHECKOUT
```

Use arm64 or x86 instead of x64 when appropriate. For a changed icon or other
local shortcut properties, rerun this command explicitly. After moving a
checkout, run ./tool/shell before using the old shortcut. Windows stores absolute
icon and working-directory properties; a relative target hint alone does not
make all .lnk properties portable.

If shell.lnk was tracked by an older project version, remove it from the index
without deleting the local file (`git rm --cached -- shell.lnk`) and commit that
removal. Ignore rules cannot hide an already tracked file.

## Building the tools

The helper's MSBuild deployment derives the checkout from the .vcxproj location
and copies self-contained builds into that checkout's
operating_system/operating_system-windows/tool/collection/bin/<architecture>
(Win32 uses x86). StaticMetaRelease runs a private copy of the newly built helper
to generate shortcuts separately in tool/bin/<architecture>. It no longer deploys to a user-profile store/tool directory.

To regenerate manually, run
`application_build_helper --create-shortcut-executables [--root CHECKOUT]`.
Without --root, the caller directory selects the enclosing checkout. This builds
application_build_helper.exe, initialize_project_root.exe,
initialize_project_root_instance.exe, and launch_shell.exe (alongside other
shortcut sources). Deploy each native shortcut
in tool/bin/<architecture>, with its full helper in collection/bin/<architecture>. The portable launcher is
built with ../_tool/shell/build.ps1 and shared code in
../_tool/architecure_launcher. Its routing settings are marked at the top of
shell.cpp. The blue ICO can be rebuilt using image/build_shell_icon.py (Pillow).

The launcher uses XP-era static imports and dynamically loads newer architecture
queries. Its payloads and Git for Windows must independently support the target
OS. Recent Windows/MSVC validation does not establish XP, ReactOS, or ARM64
runtime compatibility.

## Running the helper without locking tracked executables

The tracked tool/collection/bin/<architecture>/application_build_helper.exe is the
self-contained distributable, not the normal execution location.
--initialize-project-root-instance prepares a reusable copy at
.project-root-instance/helper/<architecture>/application_build_helper.exe.

Every supported entry point launches a unique private copy beneath
.project-root-instance/runtime/run.* and waits for it, preserving arguments,
working directory, standard streams, and exit status. The private copy is
removed after completion. This permits concurrent builds and lets Git replace
the distributable without colliding with a running helper.

- Git Bash: tool/bin/application_build_helper is a shell launcher. tool/shell
  puts tool/bin before tool/bin/<architecture> on PATH. pull uses this launcher.
- MSBuild: Common.props and the shared/static project property sheets call
  tool/bin/<host-architecture>/application_build_helper.exe. Shader
  custom builds use the same caller. It is built from
  source/application_build_helper.cpp using shortcut.h, with no inserted
  option: every command-line argument is forwarded. The host architecture is
  selected independently of the project's target architecture.
- The helper's shortcut-generation event directly makes an ignored private copy
  of the newly built helper and runs it with an explicit checkout. This can
  regenerate a missing caller without executing or locking the caller itself.
- Native shortcut executables: shortcut.h resolves the distributable under
  tool/collection/bin/<architecture>, finds the checkout, and makes a private runtime copy before
  CreateProcessW. It does not depend on PATH or change the caller's directory.

Before instance setup is available, launchers bootstrap by copying from the
usual tool/collection/bin/<architecture> location. They use the prepared instance copy
only when it matches the current distributable byte-for-byte; stale or missing
copies fall back to the current distributable. The first tool/shell run after
a helper update also refreshes instance setup. The template itself is never
executed, so instance setup may refresh it while other private copies run.

The existing /.project-root-instance/ rule ignores all runtime files. Older
layouts also get a self-ignoring runtime/.gitignore containing *, without
modifying tracked .gitignore immediately before pull. Launchers do not force
reset Git state or discard worktree changes.

Explicitly executing tool/collection/bin/<architecture>/application_build_helper.exe
bypasses these launchers and can still lock the tracked file. Use the shell
command, native caller, or generated shortcuts. A separately running old helper
can also block updates until it exits. The tracked native caller/shortcuts can be locked while they themselves run;
use the Bash pull wrapper when updating those binaries. This scheme specifically
unlocks the full helper.

Until the updated launchers have been pulled, bootstrap once from Git Bash at
the checkout root (select the correct architecture):

```bash
temporary=$(mktemp -d) || exit 1
cp ./operating_system/operating_system-windows/tool/collection/bin/x64/application_build_helper.exe "$temporary/application_build_helper.exe" &&
    "$temporary/application_build_helper.exe" --git-pull
result=$?
rm -f -- "$temporary/application_build_helper.exe"
rmdir -- "$temporary" 2>/dev/null || true
(exit "$result")
```

The native caller and shortcuts use XP-compatible file/process APIs. A custom DLL-dependent
helper also needs its dependencies available. XP/ReactOS and ARM64 runtime
compatibility must still be tested on those operating systems.

### Distribution versus PATH

The same filename has two deliberate roles:

| Location under the Windows tool repository | Role |
| --- | --- |
| bin/<architecture>/application_build_helper.exe | Small native caller, built from source/application_build_helper.cpp; safe to put on PATH |
| collection/bin/<architecture>/application_build_helper.exe | Full self-contained distributable; not put on PATH |

The caller explicitly resolves the collection path, so identical filenames do
not cause recursion. tool/shell adds only bin and bin/<architecture> to PATH.
The extensionless Bash launcher in bin also resolves collection explicitly.

When regenerating shortcuts, use the extensionless Bash launcher or MSBuild's
BuildShortcutExecutables target. Running the native caller while trying to
replace that very caller can still hit Windows' executable-file lock.

## Project-local integration data

Set APPLICATION_BUILD_HELPER_INTEGRATION_FOLDER to an absolute writable path
before starting the helper. For example, in Git Bash at the project root:

```bash
export APPLICATION_BUILD_HELPER_INTEGRATION_FOLDER="$(cygpath -am "$PWD/build/integration")"
application_build_helper --defer-prepare-folder "$PWD/source/app/acme" x64 Debug
```

The helper applies this setting before OS-node startup. App-data storage,
startup instance metadata and last-run metadata honor the same directory,
instead of creating %APPDATA%/integration/application_build_helper. The path
is the exact application data folder; another integration suffix is not added.
With the variable unset, existing default locations remain unchanged. This
setting does not redirect unrelated roaming preferences (such as merge-tool
preferences) or home-directory diagnostic logs.

For MSBuild/Visual Studio, define ApplicationBuildHelperIntegrationFolder, e.g.
in Directory.Build.props at the checkout root:

```xml
<Project>
  <PropertyGroup>
    <ApplicationBuildHelperIntegrationFolder>$(MSBuildThisFileDirectory)build\integration</ApplicationBuildHelperIntegrationFolder>
  </PropertyGroup>
</Project>
```

Or pass `/p:ApplicationBuildHelperIntegrationFolder=C:\project\build\integration`
on the MSBuild command line. Common.props and the shared/static property sheets
export this value only in the helper's prebuild command environment. An empty
property preserves an explicitly inherited environment variable. Use an absolute
path, especially when building projects in parallel from different directories.
Ignore `/build/integration/` (or your chosen build-data path) in the project.

## Cached GitHub write access

Instance setup also refreshes `_project_root_instance/github_write_access.txt`.
It uses local authenticated GitHub CLI (`gh auth login --hostname github.com`)
to check the root, initialized submodules recursively, and the declared URLs of
uninitialized submodules. Only confirmed writable owner/repository names are
cached, with the authenticated login recorded in a comment. No tokens are stored.
The underscore-named directory is ignored alongside .project-root-instance.

The Git commit/pull/checkout workflows use this list instead of hard-coded ca2
and cpp-port membership. A missing cache prompts initialization. Read-only
vendor boundaries are retained for automatic commit/push traversal. Refresh
instance setup after changing accounts, remotes, submodules or GitHub permissions;
pushes remain subject to the actual Git transport credentials and server rules.
GitHub CLI must be installed/authenticated for cache generation. On recent
Windows, setup offers a small WinGet installation and browser-login wizard.
Each step defaults to No; WinGet may show agreements or an elevation prompt.
Setup checks standard installation paths so a new shell is usually unnecessary.
Without WinGet, or on ReactOS/XP, follow the printed manual setup instructions.
Cache consumption and ordinary builds do not require a live permission query.
API failures return nonzero, do not overwrite the previous cache, and do not mark setup successful.
See source/console_build_tools/application_build_helper/GIT_WORKFLOWS.md in the
project source for cache format, enrollment rules, and refresh behavior.
