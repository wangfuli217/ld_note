int one_func(), two_func();
int red_func(), blue_func();

struct { char *name; int (*funcptr)(); } symtab[] = {
	"one_func",	one_func,
	"two_func",	two_func,
	"red_func",	red_func,
	"blue_func",	blue_func,
};

#include <stddef.h>
int (*findfunc(char *name))()
{
	int i;

	for(i = 0; i < sizeof(symtab) / sizeof(symtab[0]); i++) {
		if(strcmp(name, symtab[i].name) == 0)
			return symtab[i].funcptr;
		}

	return NULL;
}

...

	char *funcname = "one_func";
	int (*funcp)() = findfunc(funcname);
	if(funcp != NULL)
		(*funcp)();