Each `.cpp` in this directory builds as an independent Windows console shortcut.
Include `shortcut.h` and call `run_application_build_helper_shortcut` with the
helper option and `wmain` arguments, as in `new_release_time.cpp`.

Run `application_build_helper --create-shortcut-executables` to discover MSVC
with `vswhere`, initialize its compiler environment, and compile every `.cpp`
into `../bin/<name>.exe`. Object files and build scripts go into a temporary
`application_build_helper-shortcuts/<process-id>` directory. The helper expects
this repository at `~/code/operating_system/tool`.

Alternatively, from this repository's root in an MSVC developer command prompt:

```bat
cl /nologo /O2 /MT /EHsc /std:c++17 source\new_release_time.cpp /Febin\new_release_time.exe /Fo%TEMP%\new_release_time.obj
```

The shortcut finds `bin/<architecture>/application_build_helper.exe` relative to
its own location, inherits the working directory and standard streams, forwards
extra arguments, waits for completion, and returns the helper's exit code.
It requires no framework libraries. Its direct Windows API calls exist on XP;
the MSVC runtime and generated executables have been validated on recent Windows.

The application's `StaticMetaRelease` MSBuild project builds the shortcuts after
copying the helper to `~/store/windows/<architecture>`. An ARM64 cross-build on
an x64 host only copies the helper; generate its shortcuts on the ARM64 host.

The native `bin/new_release_time.exe` replaces the old Bash wrapper. In an
already-open Git Bash session, run `hash -r` once to refresh command lookup.
