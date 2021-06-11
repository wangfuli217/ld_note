#ifndef _MEM_H_
#define _MEM_H_
#include "except.h"

extern const Except_T Mem_Failed;

//malloc
extern void *Mem_alloc (long nbytes,
	const char *file, int line);

//calloc
extern void *Mem_calloc(long count, long nbytes,
	const char *file, int line);
	
//free
extern void Mem_free(void *ptr,
	const char *file, int line);

//realloc
extern void *Mem_resize(void *ptr, long nbytes,
	const char *file, int line);
	
//malloc	
#define ALLOC(nbytes) \
	Mem_alloc((nbytes), __FILE__, __LINE__)

//calloc	
#define CALLOC(count, nbytes) \
	Mem_calloc((count), (nbytes), __FILE__, __LINE__)

//new	
#define  NEW(p) ((p) = ALLOC((long)sizeof *(p)))	//long���ͺ���Ĭ�ϵ�int�����Ǵ��˸��������룬��Ϊ�ϴ������ 

//new����� 
#define NEW0(p) ((p) = CALLOC(1, (long)sizeof *(p)))

//free 
#define FREE(ptr) ((void)(Mem_free((ptr), \
	__FILE__, __LINE__),(ptr) = 0))

//realloc	
#define RESIZE(ptr, nbytes) ((ptr) = Mem_resize((ptr), \
	(nbytes), __FILE__, __LINE__))
	
#endif


