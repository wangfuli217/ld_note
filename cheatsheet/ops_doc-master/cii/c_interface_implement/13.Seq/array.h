#ifndef ARRAY_INCLUDED
#define ARRAY_INCLUDED

typedef struct  Array_t *Array;

struct Array_t 
{
	int  length;//�洢��Ԫ����Ŀ 
	int  size;  //һ���洢��Ԫ�Ĵ�С 
	char *array;//�ڴ��������ʼ��ַ 
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
