#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "except.h"
#include "arena.h"

#define THRESHOLD 10 //空闲块链表的阀值 

//对齐联合 
union align {
#ifdef MAXALIGN
	char pad[MAXALIGN];
#else
	int i;
	long l;
	long *lp;
	void *p;
	void (*fp)(void);
	float f;
	double d;
	long double ld;
#endif
};

//内存块的描述头(对齐头) 
union header 
{   //union的存储空间先看它的成员中哪个占的空间最大
	//其长度与其他成员的元长度比较,如果可以整除即可
	//所以union所占存储空间必为其他所有字段的整数倍，从而实现对齐 
	struct Arena_T a;
	union  align   b;  //必然为b的整数倍 
};



const Except_T Arena_Failed = {"Arena Allocation Failed"}; //异常内容 
static struct Arena_T *freeChunks; //空闲内存块链表 
static int nfree;				   //空闲内存块数目 

//创建一个内存池描述符
struct Arena_T* Arena_new(void)
{
	struct Arena_T *arena = malloc(sizeof (*arena));
	if (arena == NULL)
		THROW(Arena_Failed);
	arena->prev = NULL;
	arena->limit = arena->avail = NULL;
	return arena;
} 

//清除内存池以及内存池描述符 
void Arena_dispose(struct Arena_T **ap)
{
	assert(ap && *ap);
	Arena_free(*ap);
	free(*ap);
	*ap = NULL;
} 

//从内存池中获得内存 
void* Arena_alloc (struct Arena_T *arena, long nbytes,
					  	  const char *file, int line)
{
	//已经查运行时错误 
	assert(arena);
	assert(nbytes > 0); 

	//提升请求分配长度向上对齐边界
	nbytes = ((nbytes + sizeof (union align) - 1)/
			  (sizeof (union align)))*(sizeof (union align));
	while(nbytes > (arena->limit - arena->avail)) //循环是因为空闲链表中空闲内存块可能不满足条件
	{											  //其实一般满足 
		//创建一个新的内存块 
		struct Arena_T *ptr;
		char 		   *limit;
		
		//ptr指向新的内存块(来自空闲块链表，或者新的内存块)
		if((ptr = freeChunks) != NULL)  //有空闲链表中有空闲内存块 
		{
			freeChunks = freeChunks->prev;
			nfree--;
			limit = ptr->limit; 
		}
		else							//新的内存块
		{
			long m = sizeof (union header) + nbytes + 10*1024;
			ptr = malloc(m);
			if (ptr == NULL)
			{
				if(file == NULL)
					THROW(Arena_Failed);
				else
					Except_throw(&Arena_Failed,file,line);	
			}	
			limit = (char*)ptr + m;	
		}
		*ptr =  *arena; 
		arena->avail = (char *)((union header *)ptr + 1); //略过头
		arena->limit = limit;
		arena->prev  = ptr; 
			
	}
	arena->avail += nbytes;
	return arena->avail - nbytes;
}

//从内存池中获得内存	
void* Arena_calloc(struct Arena_T * arena, long count,long nbytes,
						  const char *file, int line)
{
	void *ptr;
	assert(count > 0);
	ptr = Arena_alloc(arena, count*nbytes, file, line);
	memset(ptr, '\0', count*nbytes);
	return ptr;	
}

//释放内存池 
void  Arena_free(struct Arena_T* arena)
{
	assert(arena);
	while (arena->prev) 
	{
		struct Arena_T tmp = *(arena->prev); //保存前一个内存块指针 
		if (nfree < THRESHOLD) //内存池空闲块的个数 
		{
			arena->prev->prev = freeChunks;  //将空闲块插入到空闲链表中 
			freeChunks = arena->prev;
			nfree++;
			freeChunks->limit = arena->limit;
		}
		else
			free(arena->prev);	//释放该内存块 
		*arena = tmp;
	}
	assert(arena->limit == NULL);
	assert(arena->avail == NULL);
} 


