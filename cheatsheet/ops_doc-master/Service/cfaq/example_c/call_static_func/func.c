#include <stdio.h>

static void 
__show_version()
{
	printf(__func__);
}

void (*version_cb)() = __show_version;
