Each `.cpp` in this directory builds as an independent Windows console shortcut.
Include `shortcut.h` and call `run_application_build_helper_shortcut` with the
helper option and `wmain` arguments, as in `new_release_time.cpp`.

Run `application_build_helper --create-shortcut-executables` to discover MSVC
with `vswhere`, initialize its compiler environment, and compile every `.cpp`
into `../bin/<architecture>/<name>.exe`. Object files and build scripts go into a temporary
`application_build_helper-shortcuts/<process-id>` directory. Sources come from
the target checkout's operating_system/operating_system-windows/tool/source.
Pass `[CHECKOUT | --root CHECKOUT]` after --create-shortcut-executables to select
it explicitly, or run from anywhere inside that checkout. Outputs use the
helper/compiler target architecture (Win32 maps to x86), not the host architecture.

Alternatively, from this repository's root in an MSVC developer command prompt:

```bat
cl /nologo /O2 /MT /EHsc /std:c++17 source\new_release_time.cpp /Febin\x64\new_release_time.exe /Fo%TEMP%\new_release_time.obj
```

The shortcut finds the full distributable in collection/bin/<architecture>, then
launches a private copy in the checkout's ignored .project-root-instance/runtime.
It prefers the instance-prepared helper template when current, and bootstraps
from the distributable otherwise. It inherits cwd/streams, forwards arguments,
waits, cleans up, and returns the helper's exit code. See PROJECT_ROOT_SETUP.md
for the shell and MSBuild launchers and first-instance setup.
It requires no framework libraries. Its direct Windows API calls exist on XP;
the MSVC runtime and generated executables have been validated on recent Windows.

The MSBuild project derives the checkout from its own .vcxproj location, creates
operating_system/operating_system-windows/tool/collection/bin/<architecture>,
and deploys the full helper there for StaticMetaRelease and StaticMetaDebug (also StaticRelease
on x64/ARM64). It does not deploy to a user-profile tool/store directory.
StaticMetaRelease then runs that deployed helper with an explicit checkout to
build shortcuts separately in tool/bin/<architecture>. Incremental output tracking uses
that architecture directory too. An ARM64 cross-build on an x64 host only copies
the helper; generate its shortcuts on the ARM64 host.

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
The full helper must be in collection/bin/<architecture>; launch_shell and the
small generic caller stay in bin/<architecture>.
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

`application_build_helper.cpp` builds the general-purpose intermediate
caller in bin/<architecture>/application_build_helper.exe. It forwards
all arguments without adding an option; the other shortcut sources insert their
specific option. Common.props and the shared/static property sheets select the
host-architecture caller through ApplicationBuildHelperCaller.props. The caller
replaces the former application_build_helper.cmd entry point. It accepts optional
APPLICATION_BUILD_HELPER_SOURCE and APPLICATION_BUILD_HELPER_CHECKOUT environment
overrides for explicitly selecting a distributable/check-out; otherwise both
are resolved relative to the caller executable. All execution still occurs in
private ignored runtime directories.

Manual regeneration should use the Bash command (bin/application_build_helper)
or the MSBuild BuildShortcutExecutables bootstrap target: a native caller cannot
wait for its own executable to be overwritten. Normal build events invoke the
caller; shortcut generation uses a direct private helper copy instead.
