#include <stdio.h>

struct array_s {
	int i;
	int id[2];
	char name[2];
};

static inline void
__init_struct(struct array_s* a, int value, const char* name) 
{
	if (a) {
		a->i = value;
		for (int idx = 0; idx < sizeof(a->id) / sizeof(int); idx++) {
			a->id[idx] = value;
		}
		strcpy(a->name, name);
	}
}

static inline void
__ptr_struct(struct array_s* a) 
{
	printf("I: %d ", a->i);
	for (int idx = 0; idx < sizeof(a->id) / sizeof(int); idx++) {
		printf("id[%d]: %d ", idx, a->id[idx]);
	}
	printf("name: %s", a->name);
	printf("\n");
}

int main(int argc, char **argv)
{
	struct array_s a = {0}, b = {0};
	
	__init_struct(&a, 10, "a");
	__init_struct(&b, 20, "b");
	
	a = b;
	
	__ptr_struct(&a);
	__ptr_struct(&b);
	
	return 0;
}
