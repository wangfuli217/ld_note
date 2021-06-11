#include <stdio.h>
#include <string.h>
#include <stdlib.h>


struct array_s {
	int 	i;
	int 	id[2];
	char 	*name;
public:
	array_s& operator = (const array_s& rh)
	{
		printf("%s\n", __PRETTY_FUNCTION__);
		i = rh.i;
		for (int idx = 0; idx < sizeof(id) / sizeof(int); idx++) {
			id[idx] = rh.id[idx];
		}
		strcpy(name, rh.name);
		
		return *this;
	}
	
//	array_s():i(0), name(NULL)
//	{
//		for (int idx = 0; idx < sizeof(id) / sizeof(int); idx++) {
//			id[idx] = 0;
//		}
//		
//	}
//	
//	array_s(const array_s& rh)
//	{
//		printf("%s\n", __PRETTY_FUNCTION__);
//		i = rh.i;
//		for (int idx = 0; idx < sizeof(id) / sizeof(int); idx++) {
//			id[idx] = rh.id[idx];
//		}
//		strcpy(name, rh.name);		
//	}
};

static inline void
__init_struct(struct array_s* a, int value, const char* name) 
{
	if (a) {
		a->i = value;
		for (int idx = 0; idx < sizeof(a->id) / sizeof(int); idx++) {
			a->id[idx] = value;
		}
		a->name = (char*)malloc(sizeof(char) * 2);
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
	printf("name: %p ", a->name);
	printf("name: %s ", a->name);
	printf("\n");
}

int main(int argc, char **argv)
{
	struct array_s a, b;
	
	__init_struct(&a, 10, "a");
	__ptr_struct(&a);
	__init_struct(&b, 20, "b");
	__ptr_struct(&b);
	
	a = b;
	
	__ptr_struct(&a);
	__ptr_struct(&b);
	
	return 0;
}

