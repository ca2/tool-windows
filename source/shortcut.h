#pragma once

#ifndef _WIN32
#error These shortcut executables require Windows.
#endif

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <cstdio>
#include <string>
#include <cwchar>
#include <cstring>

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

// Each invocation owns its copy; the tracked helper remains replaceable by Git.
struct shortcut_runtime
{
   std::wstring directory;
   std::wstring executable;
   ~shortcut_runtime()
   {
      if (!executable.empty()) DeleteFileW(executable.c_str());
      if (!directory.empty())
      {
         DeleteFileW((directory + L"\\ca2-trace.log").c_str());
         RemoveDirectoryW(directory.c_str());
      }
   }
};

inline bool shortcut_identical(const std::wstring & left, const std::wstring & right)
{
   HANDLE a = CreateFileW(left.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
   HANDLE b = CreateFileW(right.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
   bool equal = a != INVALID_HANDLE_VALUE && b != INVALID_HANDLE_VALUE;
   char first[8192], second[8192];
   while (equal)
   {
      DWORD x = 0, y = 0;
      equal = ReadFile(a, first, sizeof(first), &x, nullptr) && ReadFile(b, second, sizeof(second), &y, nullptr)
         && x == y && std::memcmp(first, second, x) == 0;
      if (!x) break;
   }
   if (a != INVALID_HANDLE_VALUE) CloseHandle(a);
   if (b != INVALID_HANDLE_VALUE) CloseHandle(b);
   return equal;
}

inline bool shortcut_directory(const std::wstring & path)
{
   if (CreateDirectoryW(path.c_str(), nullptr)) return true;
   if (GetLastError() != ERROR_ALREADY_EXISTS) return false;
   auto attributes = GetFileAttributesW(path.c_str());
   return attributes != INVALID_FILE_ATTRIBUTES && (attributes & FILE_ATTRIBUTE_DIRECTORY);
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

   std::wstring moduleDirectory(module, length);
   moduleDirectory.resize(moduleDirectory.find_last_of(L"\\/"));
   auto moduleArchitecture = moduleDirectory.substr(moduleDirectory.find_last_of(L"\\/") + 1);
   auto toolDirectory = moduleDirectory.substr(0, moduleDirectory.find_last_of(L"\\/"));
   toolDirectory.resize(toolDirectory.find_last_of(L"\\/"));
   std::wstring helper = toolDirectory + L"\\collection\\bin\\" + moduleArchitecture + L"\\application_build_helper.exe";

   // bin/<architecture> is five directory levels below the checkout root.
   std::wstring checkout(module, length);
   checkout.resize(checkout.find_last_of(L"\\/"));
   for (int i = 0; i < 5; ++i)
   {
      auto parent = checkout.find_last_of(L"\\/");
      if (parent == std::wstring::npos) return 1;
      checkout.resize(parent);
   }
   wchar_t overridePath[32768];
   auto overrideLength = GetEnvironmentVariableW(L"APPLICATION_BUILD_HELPER_SOURCE", overridePath, 32768);
   if (overrideLength >= 32768) return 1;
   if (overrideLength) helper.assign(overridePath, overrideLength);
   overrideLength = GetEnvironmentVariableW(L"APPLICATION_BUILD_HELPER_CHECKOUT", overridePath, 32768);
   if (overrideLength >= 32768) return 1;
   if (overrideLength) checkout.assign(overridePath, overrideLength);
   auto state = checkout + L"\\.project-root-instance";
   auto base = state + L"\\runtime";
   if (!shortcut_directory(state) || !shortcut_directory(base))
   {
      std::fprintf(stderr, "Cannot create checkout-local helper runtime directory.\n");
      return 1;
   }
   auto ignore = CreateFileW((base + L"\\.gitignore").c_str(), GENERIC_WRITE,
      FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
   if (ignore != INVALID_HANDLE_VALUE)
   {
      DWORD written = 0;
      bool ok = WriteFile(ignore, "*\r\n", 3, &written, nullptr) && written == 3;
      CloseHandle(ignore);
      if (!ok) return 1;
   }
   else if (GetLastError() != ERROR_FILE_EXISTS) return 1;
   shortcut_runtime runtime;
   for (unsigned attempt = 0; attempt < 128; ++attempt)
   {
      wchar_t name[100];
      std::swprintf(name, 100, L"\\run.%lu-%lu-%u", GetCurrentProcessId(), GetTickCount(), attempt);
      auto candidate = base + name;
      if (CreateDirectoryW(candidate.c_str(), nullptr)) { runtime.directory = candidate; break; }
      if (GetLastError() != ERROR_ALREADY_EXISTS) break;
   }
   if (runtime.directory.empty()) return 1;
   runtime.executable = runtime.directory + L"\\application_build_helper.exe";
   auto architectureStart = std::wstring(module, length).find_last_of(L"\\/");
   auto architecturePath = std::wstring(module, architectureStart);
   auto architecture = architecturePath.substr(architecturePath.find_last_of(L"\\/") + 1);
   auto prepared = state + L"\\helper\\" + architecture + L"\\application_build_helper.exe";
   auto source = shortcut_identical(helper, prepared) ? prepared : helper;
   bool copied = CopyFileW(source.c_str(), runtime.executable.c_str(), TRUE) != FALSE;
   if (!copied || !shortcut_identical(helper, runtime.executable))
      copied = CopyFileW(helper.c_str(), runtime.executable.c_str(), FALSE) != FALSE;
   if (!copied)
   {
      std::fwprintf(stderr, L"Cannot copy %ls to helper runtime (Windows error %lu).\n", helper.c_str(), GetLastError());
      return 1;
   }
   helper = runtime.executable;

   std::wstring command = shortcut_quote(helper.c_str());
   if (option) command += L" " + shortcut_quote(option);
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
