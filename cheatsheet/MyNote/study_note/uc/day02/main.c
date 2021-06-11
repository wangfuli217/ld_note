#include "print.h"
#include<dlfcn.h>
int main(void)
{
	void *handle=dlopen("./libprint.so",RTLD_NOW);
	if(dlerror())
	{
		printf("打开共享库失败\n");
		return -1;
	}
	void (*print_e_r)(void)=dlsym(handle,"print_empty_rhombus");
	if(dlerror())
	{
		printf("没有打印空心菱形函数\n");
		return -1;
	}
	print_e_r();
	void (*print_f_r)(void)=dlsym(handle,"print_full_rhombus");
	if(dlerror())
	{
		printf("没有打印实心菱形函数\n");
		return -1;
	}
	print_f_r();
	dlclose(handle);
	//print_empty_rhombus();
	//print_full_rhombus();
	return 0;
}
