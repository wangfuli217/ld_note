#include <stdio.h>

__attribute__((weak))
void show_me()
{ 
	printf("%s:%s", __FILE__, __func__);
}