#include "func.h"
#include <stdio.h>

void func_cb_r(int x)
{
	printf(__FUNCTION__);
}

void 
func_cb(int x)
{
	printf(__FUNCTION__);
}