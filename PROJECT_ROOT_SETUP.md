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

It ensures root .gitignore ends with `/shell.lnk` and
`/.project-root-instance/` rules. Commit those portable files and ignore rules
when creating/updating the project's ca2 layout. This command never creates
shell.lnk or an instance completion marker, never downloads, and never
initializes submodules. It removes the obsolete root shell.exe during migration.
It leaves an existing ignored shortcut alone.

## Using a fresh clone

Initialize the required Windows tool submodule and ensure its native helper
and shortcut executables are available. In Git Bash, from the project root:

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

Build application_build_helper, then run
`application_build_helper --create-shortcut-executables`. This builds
initialize_project_root.exe, initialize_project_root_instance.exe, and
launch_shell.exe (alongside other shortcut sources). Deploy each native shortcut
with its matching helper in tool/bin/<architecture>. The portable launcher is
built with ../_tool/shell/build.ps1 and shared code in
../_tool/architecure_launcher. Its routing settings are marked at the top of
shell.cpp. The blue ICO can be rebuilt using image/build_shell_icon.py (Pillow).

The launcher uses XP-era static imports and dynamically loads newer architecture
queries. Its payloads and Git for Windows must independently support the target
OS. Recent Windows/MSVC validation does not establish XP, ReactOS, or ARM64
runtime compatibility.
