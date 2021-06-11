//共享库文件的动态加载
#include<stdio.h>
#include<dlfcn.h>

int main(void)
{
	//打开共离库文件
	void *handle=dlopen("./shared/libadd.so",RTLD_LAZY);
	//判断是否出错
	if(dlerror())
	{
		printf("打开共享库失败\n");
		return -1;
	}
	//获取共享库中函数的地址
	int (*add)(int,int)=dlsym(handle,"add");
	//判断是否出错
	if(dlerror())
	{
		printf("库中没有%s函数\n","add");
		return -1;
	}
	//使用共享库中函数
	printf("35+98=%d\n",add(35,98));
	//关闭共享库文件
	dlclose(handle);
	if(dlerror())
	{
		printf("关闭共享库失败\n");
		return -1;
	}
	return 0;
}
