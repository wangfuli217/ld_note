#include <stdio.h>
#include <stdlib.h>
#include <new>
#include <stddef.h>

#define GE_NEW(type)                new(__FILE__, __LINE__, __FUNCTION__) type
#define GE_DELETE(ptr)              delete ptr
#define GE_NEW_ARRAY(type, count)   new(__FILE__, __LINE__, __FUNCTION__) type[count]
#define GE_DELETE_ARRAY(ptr)        delete[] ptr




/* 重载全局new delete operator */

/* 重载 全局的必须是全局函数不能是static */ 
void* 
operator new(size_t size, const char* fileName, int lineNum, const char* funcName)
{
    printf("%s:%s:%d %u\n", fileName, funcName, lineNum, size);
	
	return malloc(size);
}

void* 
operator new(size_t size, const std::nothrow_t& t, const char* fileName, int lineNum, const char* funcName) throw()
{
    printf("nothrow %s:%s:%d %u\n", fileName, funcName, lineNum, size);
	
	return malloc(size);	
}

void* 
operator new[](size_t size, const char* fileName, int lineNum, const char* funcName)
{
	printf("%s:%s:%d %u\n", fileName, funcName, lineNum, size);
	
	return malloc(size);
}

void
operator delete(void* ptr)
{
    printf("func: %s\n", __FUNCTION__);
	
	//::operator delete(ptr);
	free(ptr);
}

void 
operator delete[](void* ptr)
{
	printf("func: %s\n", __FUNCTION__);
	free(ptr);
}

//#define new new(__FILE__, __LINE__, __FUNCTION__) /* 另一种方式 */


class A
{
public:
	void show() { printf("is a\n");}
};

int 
main(int argc, char **argv)
{
	void* p = new(__FILE__, __LINE__, __FUNCTION__) int;
	
	//int* p = new(std::nothrow, __FILE__, __LINE__, __FUNCTION__) int;
	
	//int* p = new int;
	
	//*p = 99;
	
	GE_DELETE(p);
	
	int* pa = new (__FILE__, __LINE__, __FUNCTION__)int[10];
	
	GE_DELETE_ARRAY(pa);
	
	A* a = GE_NEW(A);//new A;
	
	a->show();
	
//	void* v = malloc(sizeof(A));
//	
//	A* aa = new (v)A;
//	
//	a->show();

	GE_DELETE(a);
	
	system("pause");

	return 0;
}
