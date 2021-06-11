#include <stdio.h>

#include <stddef.h>

typedef struct tagHuman
{
	int age;
	int height;
}Human;


/**********************************************************/
#ifndef offsetof
#define offsetof(type, member) \
	(size_t)&(((type *)0)->member)
#endif

#ifndef container_of
#define container_of(ptr, type, member)  \
	({\
		const typeof(((type *)0)->member) * __mptr = (ptr);\
		(type *)((char *)__mptr - offsetof(type, member)); \
	})
#endif
/**********************************************************/

int main(int argc, char **argv)
{
	Human *p = malloc(sizeof(Human));
	
	Human* pp = NULL;
	
	p->age = 10;
	p->height = 99;
	
	int* page = &(p->height);
	
	pp = container_of(page, Human, height);
	
	printf("Age: %d\n", pp->age);
	
	return 0;
}
