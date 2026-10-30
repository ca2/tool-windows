#pragma once

#ifndef _WIN32
#error These shortcut executables require Windows.
#endif

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <cstdio>
#include <string>

// Quote one argument according to the Windows CRT command-line rules.
inline std::wstring shortcut_quote(const wchar_t * argument)
{
   std::wstring result = L"\"";
   size_t slashes = 0;
   for (const wchar_t * p = argument; *p; ++p)
   {
      if (*p == L'\\')
      {
         ++slashes;
         continue;
      }
      result.append(*p == L'"' ? slashes * 2 + 1 : slashes, L'\\');
      result += *p;
      slashes = 0;
   }
   result.append(slashes * 2, L'\\');
   result += L'"';
   return result;
}

// Resolve the helper relative to the shortcut, independently of PATH and cwd.
inline int run_application_build_helper_shortcut(const wchar_t * option, int argc, wchar_t * argv[])
{
   wchar_t module[32768];
   DWORD length = GetModuleFileNameW(nullptr, module, 32768);
   if (!length || length == 32768)
   {
      std::fprintf(stderr, "Cannot locate shortcut executable.\n");
      return 1;
   }

   std::wstring helper(module, length);
   auto slash = helper.find_last_of(L"\\/");
   helper.resize(slash + 1);
#if defined(_M_ARM64)
   helper += L"arm64\\application_build_helper.exe";
#elif defined(_M_X64)
   helper += L"x64\\application_build_helper.exe";
#elif defined(_M_IX86)
   helper += L"win32\\application_build_helper.exe";
#else
#error Unsupported shortcut executable architecture.
#endif

   std::wstring command = shortcut_quote(helper.c_str()) + L" " + shortcut_quote(option);
   for (int i = 1; i < argc; ++i)
   {
      command += L" " + shortcut_quote(argv[i]);
   }

   STARTUPINFOW startup = {};
   startup.cb = sizeof(startup);
   startup.dwFlags = STARTF_USESTDHANDLES;
   startup.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
   startup.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
   startup.hStdError = GetStdHandle(STD_ERROR_HANDLE);
   PROCESS_INFORMATION process = {};
   if (!CreateProcessW(helper.c_str(), &command[0], nullptr, nullptr, TRUE, 0,
      nullptr, nullptr, &startup, &process))
   {
      std::fwprintf(stderr, L"Cannot start %ls (Windows error %lu).\n", helper.c_str(), GetLastError());
      return 1;
   }

   CloseHandle(process.hThread);
   DWORD exitCode = 1;
   DWORD waitResult = WaitForSingleObject(process.hProcess, INFINITE);
   bool succeeded = waitResult == WAIT_OBJECT_0 && GetExitCodeProcess(process.hProcess, &exitCode);
   DWORD error = succeeded ? ERROR_SUCCESS : GetLastError();
   CloseHandle(process.hProcess);
   if (!succeeded)
   {
      std::fprintf(stderr, "Cannot wait for application_build_helper (Windows error %lu).\n", error);
      return 1;
   }
   return static_cast<int>(exitCode);
}
