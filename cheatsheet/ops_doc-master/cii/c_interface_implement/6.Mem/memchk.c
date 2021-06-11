#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "except.h"
#include "mem.h"

//非常重要，在此文件中认为unsigned long == 地址大小
//1 是在计算hash值时使用该技巧，但是仍不好，hash冲突增多
//2 在计算内存对齐时0xXXXXXXX10肯定能被其0x10整除 
//可以使用对应大小的数据类型来重新定义或者配置编译器设置unsigned long == 地址大小  
//如 
#define Addr_size unsigned long long 
 
 
//描述符个数，一次多申请放在和数据混在一起，让数据的越界访问破坏描述符 
#define NDESCRIPTORS 512

//hash table的大小
#define HASHTABLESIZE 2047 //大小通常为素数 

//一次申请空间的大小，避免的多次申请，有点内存池的意思，但这里使用空闲链表维护的，认为在空闲链表上 
#define NALLOC ((4096 + sizeof (union align) - 1)/ \
	(sizeof (union align)))*(sizeof (union align))

// hash算法
// 其大小比小于HASHTABLESIZE - 1(-1数组大小不能成为数组索引，越界) 
#define hash(p, t) (((Addr_size)(p)>>3) & (HASHTABLESIZE - 1)) 

//对齐，跟标准库中malloc一样，这里的内存分配也是绝对的内存对齐，应支持所有内置类型 
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
	long long ago; 
	long double ld;
#endif
};

//异常内容 
const Except_T Mem_Failed = { "Allocation Failed" };

//hash表 
static struct descriptor {
	struct descriptor *free;
	struct descriptor *link;
	const void *ptr;
	long size;
	const char *file;
	int line;
} *htab[HASHTABLESIZE];

//空闲链表 
static struct descriptor freelist = { &freelist }; //顺带赋值feellist.free,使其成为循环链表 

//查找地址对应描述符 
static struct descriptor *find(const void *ptr) 
{
	struct descriptor *bp = htab[hash(ptr, htab)];
	while (bp && bp->ptr != ptr)
		bp = bp->link;
	return bp;
}

//free
void Mem_free(void *ptr, const char *file, int line) 
{
	if (ptr) 
	{
		struct descriptor *bp;
		//是否内存到空闲链表中以及字节对齐 
		if (((Addr_size)ptr)%(sizeof (union align)) != 0 
			 || (bp = find(ptr)) == NULL || bp->free)
		{
			if (file == NULL)
				THROW(Mem_Failed);
			else
				Except_throw(&Mem_Failed, file, line);
		} 
		bp->free = freelist.free;
		freelist.free = bp;
	}
}

//realloc，alloc-memcpy-free 
void *Mem_resize(void *ptr, long nbytes, const char *file, int line)
{
	struct descriptor *bp;
	void *newptr;
	assert(ptr);
	assert(nbytes > 0);
	
	if (((Addr_size)ptr)%(sizeof (union align)) != 0
		|| (bp = find(ptr)) == NULL || bp->free)
	{
		if (file == NULL)
			THROW(Mem_Failed);
		else
			Except_throw(&Mem_Failed, file, line);
	} 
	newptr = Mem_alloc(nbytes, file, line);
	memcpy(newptr, ptr, nbytes < bp->size ? nbytes : bp->size);
	Mem_free(ptr, file, line);
	return newptr;
}

//calloc 
void *Mem_calloc(long count, long nbytes,const char *file, int line)
{
	void *ptr;

	assert(count > 0);
	assert(nbytes > 0);
	ptr = Mem_alloc(count*nbytes, file, line);
	memset(ptr, '\0', count*nbytes);	
	return ptr;
}

//描述符申请,一次申请多个在零售，与数据去分开，只是更安全一点 
static struct descriptor *dalloc(void *ptr, long size, const char *file, int line) 
{
	static struct descriptor *avail;
	static int nleft;

	if (nleft <= 0) 
	{
		avail = malloc(NDESCRIPTORS*sizeof (*avail));
		if (avail == NULL)
			return NULL;
		nleft = NDESCRIPTORS;
	}
	avail->ptr  = ptr;
	avail->size = size;
	avail->file = file;
	avail->line = line;
	avail->free = avail->link = NULL;
	nleft--;
	return avail++;
}

//alloc，核心部分 long保证内承担int 负数 
void *Mem_alloc(long nbytes, const char *file, int line)
{
	struct descriptor *bp;
	void *ptr;
	
	assert(nbytes > 0);
	//提升到标准大小 
	nbytes = ((nbytes + sizeof (union align) - 1)/
			 (sizeof (union align)))*(sizeof (union align));
	for (bp = freelist.free; bp; bp = bp->free) 
	{	//首次最适宜算法 
		if (bp->size > nbytes) 
		{
			bp->size -= nbytes;
			ptr = (char *)bp->ptr + bp->size; //切割空闲链表块中合适大小的内存 
			if ((bp = dalloc(ptr, nbytes, file, line)) != NULL) 
			{
				unsigned int h = hash(ptr, htab);
				bp->link = htab[h];	//将此内存描述符插入到hash集合中 
				htab[h] = bp;
				return ptr;
			} 
			else
			{
				if (file == NULL)
					THROW(Mem_Failed);
				else
					Except_throw(&Mem_Failed, file, line);
			}
		}
		if (bp == &freelist) 
		{
			struct descriptor *newptr;
			
			//空闲链表为空了，申请空间和描述符 
			if ((ptr = malloc(nbytes + NALLOC)) == NULL
				|| (newptr = dalloc(ptr, nbytes + NALLOC,
					__FILE__, __LINE__)) == NULL)
			{
					THROW(Mem_Failed);
			}
			newptr->free = freelist.free;
			freelist.free = newptr;
		}
	}
	assert(0);
	return NULL;
}
