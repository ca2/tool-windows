Each `.cpp` in this directory builds as an independent Windows console shortcut.
Include `shortcut.h` and call `run_application_build_helper_shortcut` with the
helper option and `wmain` arguments, as in `new_release_time.cpp`.

Run `application_build_helper --create-shortcut-executables` to discover MSVC
with `vswhere`, initialize its compiler environment, and compile every `.cpp`
into `../bin/<architecture>/<name>.exe`. Object files and build scripts go into a temporary
`application_build_helper-shortcuts/<process-id>` directory. The helper expects
this repository at `~/code/operating_system/tool`.

Alternatively, from this repository's root in an MSVC developer command prompt:

```bat
cl /nologo /O2 /MT /EHsc /std:c++17 source\new_release_time.cpp /Febin\x64\new_release_time.exe /Fo%TEMP%\new_release_time.obj
```

The shortcut finds `application_build_helper.exe` beside its own executable in
`bin/<architecture>`, inherits the working directory and standard streams, forwards
extra arguments, waits for completion, and returns the helper's exit code.
It requires no framework libraries. Its direct Windows API calls exist on XP;
the MSVC runtime and generated executables have been validated on recent Windows.

The application's `StaticMetaRelease` MSBuild project builds the shortcuts after
copying the helper to `~/store/windows/<architecture>`. An ARM64 cross-build on
an x64 host only copies the helper; generate its shortcuts on the ARM64 host.

The native `bin/<architecture>/new_release_time.exe` replaces the old Bash wrapper. In an
already-open Git Bash session, run `hash -r` once to refresh command lookup.

Project setup and clone-local setup are separate. See
[PROJECT_ROOT_SETUP.md](../PROJECT_ROOT_SETUP.md) for the full workflow.

- `initialize_project_root.exe [CHECKOUT | --root CHECKOUT]` prepares portable
  tool/shell, tool/bin/shell.exe, tool/image/shell.ico, and .gitignore rules for
  a maintainer to commit. It does not create shell.lnk or instance state.
- `initialize_project_root_instance.exe [CHECKOUT | --root CHECKOUT]` creates
  the ignored root shell.lnk and records success in the ignored
  .project-root-instance/initialized-root.txt file for this checkout path.
- A new clone's first `./tool/shell` run from Git Bash invokes instance setup
  automatically. Later runs skip it unless state/shortcut is missing or the
  checkout has moved. Failures stop the wrapper and can be retried.

The installed `tool/bin/shell.exe` is a CRT-free x86 bootstrap built from
`../_tool/shell/shell.cpp`. It includes reusable code from
`../_tool/architecure_launcher/launcher.h` and embeds only these relative settings:

```text
folder=operating_system/operating_system-windows/tool/bin executable=launch_shell.exe
```

It resolves the checkout from its own location, detects the native architecture,
and launches `bin/<architecture>/launch_shell.exe` in that checkout. It has no
machine-specific path internally. Run ./tool/shell after moving a checkout to refresh its local .lnk properties.
Arguments are forwarded to launch_shell, which invokes the helper's `--shell`.
The helper executable must be beside launch_shell in the architecture directory.
`source/launch_shell.cpp` replaces the former `source/shell.cpp` helper shortcut.

Run `../_tool/shell/build.ps1` to build/deploy the portable root launcher, and
`../_tool/architecure_launcher/build.ps1` for the generic architecture launcher.
The former embeds its routing settings; the generic version accepts
`folder=PATH executable=NAME [-- ARGUMENTS]` on the command line. Both wait for
the child and return its exit code. The bootstrap's XP imports do not make its
payloads or Git for Windows compatible with XP/ReactOS automatically.

The wrapper `shell` originated from ca2/windows-simple/tool/shell. Both the
repository copy and root copy delegate to `windows_shell` in this tool repository,
which retains the existing environment setup. `--shell` opens Git Bash with
`--no-cd -c "exec bash ./tool/shell"` and checks root `tool/shell` and the local
`windows_shell`. Helper checkout resolution uses the caller directory or an
explicit checkout, independently of the helper installation directory.
