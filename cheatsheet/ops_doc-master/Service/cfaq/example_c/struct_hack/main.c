#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>

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

#pragma pack(1)

typedef struct {
	int a;
	char b[]; //char b[0] 也可以, 这里的char b 不算size
} StructHack_t;

typedef struct hack_s hack_t;
struct hack_s {
	int sz;
	char *b[]; //这里的b 不算size
};

typedef struct hack_2_s hack_2_t;
struct hack_2_s {
	int sz;
	int a;
	int *b[];
};
#pragma pack()

#define __NEW_HACK__(p, size) do {							\
	p = (hack_t*)malloc(sizeof *p + sizeof(char*) * size);	\
	if (p) { (p)->sz = size;} 								\
} while (0)
#define __DEL_HACK__(p) free(p);p == NULL

int main(int argc, char **argv)
{
	StructHack_t* p = (StructHack_t*)malloc(sizeof(StructHack_t) + sizeof(char) * 10);
	
	char* hack = p->b;
	
	StructHack_t* header =  hack - (((StructHack_t*)0)->b); //hack - sizeof(StructHack_t); /* 根据数组获取结构体的指针 */
	
	strcpy(p->b, "hello");
	
	printf("StructHack_t: %d\n", sizeof(StructHack_t));
	printf("B: %s\n", p->b);
	printf("P-Size: %d\n", sizeof(*p));
	printf("char[]: %zu\n", sizeof *hack);
	
	
	printf("pointer: %p\n", p);
	printf("pointer: %p\n", header);
	printf("pointer: %p\n", p->b);
	
	hack_t *phack;
	
	__NEW_HACK__(phack, 10);
	printf("hack_t: %d\n", sizeof(hack_t));
	printf("hack_t* sz %d\n", sizeof phack);
	printf("pointer: %p\n", phack);
	printf("pointer: %p\n", phack->b);
	printf("offset: %d\n", offsetof(hack_t, b)); //　ｂ的类型为指针类型，size计算入sturct ，但是这个时候offset == sizeof(struct)
	
	
	printf("hack_2_t: %d\n", sizeof(hack_2_t));
	
#ifdef _WIN32	
	system("pause");
#endif
	
	return 0;
}
