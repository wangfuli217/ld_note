#include <stdio.h>
#include "def.h"

static void
_handler_show();

void
f_create(func_struct_t* f)
{
	if (f) {
		f->cb = _handler_show;
	}
}


/* only this file  */
static void
_handler_show() 
{
	printf("hellow world\n");
}