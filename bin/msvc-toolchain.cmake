# Minimal MSVC toolchain for Ninja

set(CMAKE_SYSTEM_NAME Windows)

# Tell CMake to use MSVC toolchain
set(CMAKE_C_COMPILER cl)
set(CMAKE_CXX_COMPILER cl)

# Use dynamic runtime (same as default MSVC builds)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")

# Optional: avoid try-run issues
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


