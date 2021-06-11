
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#ifdef HAVE_MALLOC_H
#include <malloc.h>
#endif

#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef UNIT_TESTING
extern void* _test_malloc(const size_t size, const char* file, const int line);
extern void* _test_calloc(const size_t number_of_elements, const size_t size,
                          const char* file, const int line);
extern void _test_free(void* const ptr, const char* file, const int line);

#define malloc(size) _test_malloc(size, __FILE__, __LINE__)
#define calloc(num, size) _test_calloc(num, size, __FILE__, __LINE__)
#define free(ptr) _test_free(ptr, __FILE__, __LINE__)
#endif // UNIT_TESTING

void leak_memory(void);
void buffer_overflow(void);
void buffer_underflow(void);

void leak_memory(void)
{
    int * const temporary = (int*)malloc(sizeof(int));		
    *temporary = 0; 
	//没有释放内存，造成内存泄漏。
}

void buffer_overflow(void) 
{    
    //申请了指针memory，大小为4，写成数组的形式就是memory[4];
    //有效成员是memory[0]~memory[3].
	char * const memory = (char*)malloc(sizeof(int));
    memory[sizeof(int)] = '!';   //对memory[4]进行赋值，导致溢出。
    free(memory);
}

void buffer_underflow(void)
{    
	char * const mem = (char*)malloc(sizeof(int));
	mem[-1] = '!';  //mem[0]前面的那个数据是mem[-1].访问越界，下溢
  //free(mem);      //不要释放，下溢释放会出错。
	
	/*类似
	char *p = malloc(4);
	p[-1]='a';
	free(p);
	*/
}
