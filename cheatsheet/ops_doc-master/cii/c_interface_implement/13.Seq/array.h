#ifndef ARRAY_INCLUDED
#define ARRAY_INCLUDED

typedef struct  Array_t *Array;

struct Array_t 
{
	int  length;//存储单元的数目 
	int  size;  //一个存储单元的大小 
	char *array;//内存区域的起始地址 
};


extern Array    Array_new (int length, int size);
extern void 	Array_free(Array *array);
extern int 		Array_length(Array array);
extern int 		Array_size  (Array array);
extern void 	*Array_get(Array array, int i);
extern void 	*Array_put(Array array, int i, void *elem);
extern void 	Array_resize(Array array, int length);
extern Array    Array_copy  (Array array, int length);
extern Array    Array_reshape  (Array array, int length);
extern void 	ArrayRep_init(Array array, int length,
							int size, void *ary);
#endif
