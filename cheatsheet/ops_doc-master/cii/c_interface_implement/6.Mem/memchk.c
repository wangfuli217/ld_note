#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "except.h"
#include "mem.h"

//�ǳ���Ҫ���ڴ��ļ�����Ϊunsigned long == ��ַ��С
//1 ���ڼ���hashֵʱʹ�øü��ɣ������Բ��ã�hash��ͻ����
//2 �ڼ����ڴ����ʱ0xXXXXXXX10�϶��ܱ���0x10���� 
//����ʹ�ö�Ӧ��С���������������¶���������ñ���������unsigned long == ��ַ��С  
//�� 
#define Addr_size unsigned long long 
 
 
//������������һ�ζ�������ں����ݻ���һ�������ݵ�Խ������ƻ������� 
#define NDESCRIPTORS 512

//hash table�Ĵ�С
#define HASHTABLESIZE 2047 //��Сͨ��Ϊ���� 

//һ������ռ�Ĵ�С������Ķ�����룬�е��ڴ�ص���˼��������ʹ�ÿ�������ά���ģ���Ϊ�ڿ��������� 
#define NALLOC ((4096 + sizeof (union align) - 1)/ \
	(sizeof (union align)))*(sizeof (union align))

// hash�㷨
// ���С��С��HASHTABLESIZE - 1(-1�����С���ܳ�Ϊ����������Խ��) 
#define hash(p, t) (((Addr_size)(p)>>3) & (HASHTABLESIZE - 1)) 

//���룬����׼����mallocһ����������ڴ����Ҳ�Ǿ��Ե��ڴ���룬Ӧ֧�������������� 
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

//�쳣���� 
const Except_T Mem_Failed = { "Allocation Failed" };

//hash�� 
static struct descriptor {
	struct descriptor *free;
	struct descriptor *link;
	const void *ptr;
	long size;
	const char *file;
	int line;
} *htab[HASHTABLESIZE];

//�������� 
static struct descriptor freelist = { &freelist }; //˳����ֵfeellist.free,ʹ���Ϊѭ������ 

//���ҵ�ַ��Ӧ������ 
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
		//�Ƿ��ڴ浽�����������Լ��ֽڶ��� 
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

//realloc��alloc-memcpy-free 
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

//����������,һ�������������ۣ�������ȥ�ֿ���ֻ�Ǹ���ȫһ�� 
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

//alloc�����Ĳ��� long��֤�ڳе�int ���� 
void *Mem_alloc(long nbytes, const char *file, int line)
{
	struct descriptor *bp;
	void *ptr;
	
	assert(nbytes > 0);
	//��������׼��С 
	nbytes = ((nbytes + sizeof (union align) - 1)/
			 (sizeof (union align)))*(sizeof (union align));
	for (bp = freelist.free; bp; bp = bp->free) 
	{	//�״��������㷨 
		if (bp->size > nbytes) 
		{
			bp->size -= nbytes;
			ptr = (char *)bp->ptr + bp->size; //�и����������к��ʴ�С���ڴ� 
			if ((bp = dalloc(ptr, nbytes, file, line)) != NULL) 
			{
				unsigned int h = hash(ptr, htab);
				bp->link = htab[h];	//�����ڴ����������뵽hash������ 
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
			
			//��������Ϊ���ˣ�����ռ�������� 
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
