#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "except.h"
#include "arena.h"

#define THRESHOLD 10 //���п�����ķ�ֵ 

//�������� 
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

//�ڴ�������ͷ(����ͷ) 
union header 
{   //union�Ĵ洢�ռ��ȿ����ĳ�Ա���ĸ�ռ�Ŀռ����
	//�䳤����������Ա��Ԫ���ȱȽ�,���������������
	//����union��ռ�洢�ռ��Ϊ���������ֶε����������Ӷ�ʵ�ֶ��� 
	struct Arena_T a;
	union  align   b;  //��ȻΪb�������� 
};



const Except_T Arena_Failed = {"Arena Allocation Failed"}; //�쳣���� 
static struct Arena_T *freeChunks; //�����ڴ������ 
static int nfree;				   //�����ڴ����Ŀ 

//����һ���ڴ��������
struct Arena_T* Arena_new(void)
{
	struct Arena_T *arena = malloc(sizeof (*arena));
	if (arena == NULL)
		THROW(Arena_Failed);
	arena->prev = NULL;
	arena->limit = arena->avail = NULL;
	return arena;
} 

//����ڴ���Լ��ڴ�������� 
void Arena_dispose(struct Arena_T **ap)
{
	assert(ap && *ap);
	Arena_free(*ap);
	free(*ap);
	*ap = NULL;
} 

//���ڴ���л���ڴ� 
void* Arena_alloc (struct Arena_T *arena, long nbytes,
					  	  const char *file, int line)
{
	//�Ѿ�������ʱ���� 
	assert(arena);
	assert(nbytes > 0); 

	//����������䳤�����϶���߽�
	nbytes = ((nbytes + sizeof (union align) - 1)/
			  (sizeof (union align)))*(sizeof (union align));
	while(nbytes > (arena->limit - arena->avail)) //ѭ������Ϊ���������п����ڴ����ܲ���������
	{											  //��ʵһ������ 
		//����һ���µ��ڴ�� 
		struct Arena_T *ptr;
		char 		   *limit;
		
		//ptrָ���µ��ڴ��(���Կ��п����������µ��ڴ��)
		if((ptr = freeChunks) != NULL)  //�п����������п����ڴ�� 
		{
			freeChunks = freeChunks->prev;
			nfree--;
			limit = ptr->limit; 
		}
		else							//�µ��ڴ��
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
		arena->avail = (char *)((union header *)ptr + 1); //�Թ�ͷ
		arena->limit = limit;
		arena->prev  = ptr; 
			
	}
	arena->avail += nbytes;
	return arena->avail - nbytes;
}

//���ڴ���л���ڴ�	
void* Arena_calloc(struct Arena_T * arena, long count,long nbytes,
						  const char *file, int line)
{
	void *ptr;
	assert(count > 0);
	ptr = Arena_alloc(arena, count*nbytes, file, line);
	memset(ptr, '\0', count*nbytes);
	return ptr;	
}

//�ͷ��ڴ�� 
void  Arena_free(struct Arena_T* arena)
{
	assert(arena);
	while (arena->prev) 
	{
		struct Arena_T tmp = *(arena->prev); //����ǰһ���ڴ��ָ�� 
		if (nfree < THRESHOLD) //�ڴ�ؿ��п�ĸ��� 
		{
			arena->prev->prev = freeChunks;  //�����п���뵽���������� 
			freeChunks = arena->prev;
			nfree++;
			freeChunks->limit = arena->limit;
		}
		else
			free(arena->prev);	//�ͷŸ��ڴ�� 
		*arena = tmp;
	}
	assert(arena->limit == NULL);
	assert(arena->avail == NULL);
} 


