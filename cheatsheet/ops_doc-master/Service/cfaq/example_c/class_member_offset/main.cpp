#include <stdio.h>


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


class A {
public:
	int* getId() { return &id; }
public:
	int id;
};


int main(int argc, char **argv)
{
	A a, *pa;
	
	int *p = a.getId();
	
	pa = container_of(p, A, id);
	printf("pa: %p %p\n", &a, pa);
	
	return 0;
}
