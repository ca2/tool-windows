#include "shortcut.h"

// Forward every argument; unlike the named shortcuts, no option is inserted.
int wmain(int argc, wchar_t * argv[])
{
   return run_application_build_helper_shortcut(nullptr, argc, argv);
}
