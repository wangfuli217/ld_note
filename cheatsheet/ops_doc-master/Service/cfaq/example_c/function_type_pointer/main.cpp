#include <stdio.h>
#include <stdlib.h>

void
show()
{

}

int main(int argc, char **argv)
{
	typedef void (*pFUNC)();  //定义函数指针类型
	void (*ptr)();			  //定义函数指针
	
	typedef void (*pArray_t[2])(); //声明一个函数指针数组类型成员为2个
	void (*pArray[2])();    	   /* 声明一个函数指针数组变量 */
	
	typedef void FUNC();     //定义函数类型
	
	pFUNC temp[2];
	
	FUNC func;
	
	ptr = show;
	
	printf("FUNC_P: %p\n", show);
	printf("FUNC_P: %p\n", &show);
	printf("FUNC_P: %p\n", ptr);
	printf("FUNC_P: %p\n", *ptr);
	
	ptr();
	
	system("pause");
	
	return 0;
}
