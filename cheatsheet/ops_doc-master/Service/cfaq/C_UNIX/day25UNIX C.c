关键字：库文件的概念和使用 静态库 共享库  共享库的动态加载

/*库文件的概念和使用*/
	在大型项目中，如果每个功能函数都放在独立的.o文件中，则项目管理是灾难性问题，因此需要采用库文件来解决问题；
	一般来说，可以按照功能模块将若干个.o文件打包成一个或者多个库文件，编写者只需要库文件和头文件即可；

库文件主要分成两大类：静态库文件 和 共享库文件


/*静态库*/
	由若干个.o文件打包生成的.a文件；

链接静态库的本质：
	将被调用的代码指令复制到调用模块中，体现在最终的可执行文件中；

基本特性
	1. 静态库占用空间比较大，库中的代码一旦修改则必须重新链接；（调用一次就要复制一次 空间就大）
	2. 使用静态库的代码在执行可执行文件时可以脱离静态库，并且执行的效率比较高；

	注意：
		gcc/cc -static xxx.c  表示强制要求链接静态库
		ldd a.out  表示查看a.out所链接的共享库信息

静态库的生成和调用步骤
	生成步骤
		1. 编写源代码文件xxx.c，如：vi add.c
		2. 只编译不链接生成目标文件xxx.o 如：cc -c add.c
		3. 生成静态库文件
			ar -r/*插入，若存在则更新*/ lib库名.a 目标文件
			ar -r libadd.a add.o
	注意：
		其中libadd.a叫做静态库文件名；
		其中去掉lib和.a之间剩下的add叫做库名；

	调用步骤
		1. 编写测试源代码文件xxx.c,如：vi main.c
		2. 只编译不链接生成目标文件xxx.o,如：cc -c main.c
		3. 链接静态库文件，链接的方式有以下三种：
			1. 直接链接
				cc 目标文件 静态库文件名
				cc main.o libadd.a
			2. 使用编译选项进行链接(用这个)
				cc 目标文件 -l 库名 -L 库文件所在的路径 
				/* cc main.o -l add -L . */
			3. 配置环境变量LIBRARY_PATH
				export LIBRARY_PATH=$LIBRARY_PATH:.
				cc main.o -l add

/*共享库*/
	由若干个目标文件.o文件打包生成的.so文件

链接共享库和静态库最大的不同：
	链接共享库时并不需要将被调用的代码指令复制到调用模块中，
	而仅仅是将被调用的代码指令在共享库中的相对地址嵌入到调用模块中；

基本特性
	1. 共享库占用空间比较小，即使修改了库中的代码，只要接口保持不变，则不需要重新链接；
	2. 使用共享库的代码在运行时需要依赖共享库，执行效率相对比较低；
	目前主流商业开发中大多数采用共享库；

共享库的生成和调用步骤
	生成步骤
		1. 编写源代码文件xxx.c 如：vi add.c
		2. 只编译不链接生成目标文件xxx.o 
		   如：cc -c -fpic/*生成位置无关码 小模式*/ add.c
		3. 生成共享库文件
		   cc -shared/*共享的*/ 目标文件 -o lib库名.so
		   cc -shared add.o -o libadd.so

	调用步骤
		1. 编写测试源代码文件xxx.c,如：vi main.c
		2. 只编译不链接生成目标文件xxx.o,如：cc -c main.c
		3. 链接共享库文件，链接的方式有以下三种：
			1. 直接链接
				cc 目标文件 共享库文件名
				cc main.o libadd.so
			2. 使用编译选项进行链接(用这个)
				cc 目标文件 -l 库名 -L 库文件所在的路径 
				/* cc main.o -l add -L . */
			3. 配置环境变量LIBRARY_PATH
				export LIBRARY_PATH=$LIBRARY_PATH:.
				cc main.o -l add
	注意：
		在使用共享库文件时，需要配置环境变量LD_LIBRARY_PATH来解决运行时找不到库文件的问题
(a.out: error while loading shared libraries: libadd.so: cannot open shared object file: No such file or directory)
		
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

	注意：
		当静态库文件和共享库文件同时存在并且库名相同时，
		采用上述第二种或者第三种链接方式进行链接时，
		编译器会优先选择共享库进行链接，
		如果希望链接静态库则使用-static 选项进行要求；

/*共享库的动态加载*/

//programming interface to dynamic linking loader

	dlopen() - 打开/加载共享库到内存中         	dynamic linking
	dlsym() - 查找共享库中指定函数在内存中的地址
	dlclose() - 关闭/加载共享库
	dlerror() - 获取错误信息
 
#include <dlfcn.h>
 Link with -ldl  //最后编译时 cc dynamic.c -ldl

1. dlopen函数
  void *dlopen(const char *filename, int flag);
第一个参数：字符串形式的共享库文件名
第二个参数：具体的操作标志，加载方式
			RTLD_LAZY 延迟加载
			RTLD_NOW  立即加载
返回值：成功返回一个句柄（地址）信息，失败返回NULL；
函数功能：主要用于将参数filename指定的共享库文件加载到内存中；

2. dlsym函数
  void *dlsym(void *handle, const char *symbol);
第一个参数：具体的句柄信息，也就是dlopen函数的返回值
第二个参数：字符串形式的符号名，这里指函数名
返回值：成功返回函数的地址，失败返回NULL；
函数功能：主要用于查找handle指向共享库中名字为symbol的函数在内存中的地址信息；

3. dlclose函数
  int dlclose(void *handle);
函数功能：关闭/卸载参数指定的共享库，参数为dlopen函数的返回值
	  成功返回0，失败返回非0；

4. dlerror函数
  char *dlerror(void);
函数功能：用于获取调用dlopen()/dlsym()/dlclose()函数之后产生的错误信息并返回 ，如果上述函数没有产生错误，则返回NULL；

#include<stdio.h>
#include<dlfcn.h>
#include<stdlib.h>

int main()
{
	//1.打开/加载共享库文件libadd.so
	void *handle=dlopen("./add/libadd.so",RTLD_NOW);
	//2.判断是否打开失败，并打印错误信息
	if(NULL==handle)
	{
		printf("dlopen:%s\n",dlerror());
		return -1;
	}
	//3.获取共享库中函数add的地址
	//定义函数指针来接收函数的地址
	int (*p_add)(int,int);

	p_add=(int(*)(int,int))dlsym(handle,"add"); //强转成函数指针 (int(*)(int,int))
	//4.判断是否失败，并打印错误信息
	if(p_add==NULL)
	{
		printf("dlsym:%s\n",dlerror());
		return -1;
	}
	//5.调用add函数进行计算
	int res=p_add(33,66);
	printf("sum:%d\n",res);
	//6.关闭/卸载共享库文件libadd.so
	res=dlclose(handle);
	//7.判断关闭是否失败，并打印错误信息
	if(0!=res)
	{
		printf("dlclose:%s\n",dlerror());
		return -1;
	}
	return 0;
}


作业：
   (1)自定义两个函数分别打印空心菱形和实心菱形，放在同一个.c文件中，
      将该文件分别打包成静态库文件和共享库文件使用main.c文件进行调用，最后使用动态加载方式进行加载
       *                     *
      * *                   ***
     *   *                 *****
      * *                   ***
       *                     *

/*自己写的*/
//diamond.c
#include"diamond.h"
void diamond(void)
{
	int i=0,j=0,k=0;
	for(i=1;i<=3;i++)
	{
		for(j=3;j>i;j--)	
			printf(" ");
		for(k=0;k<i+i-1;k++)
			printf("*");
		printf("\n");
	}
	for(i=1;i<3;i++)
	{
		for(j=0;j<i;j++)
			printf(" ");
		for(k=3;k>=i+i-1;k--)
			printf("*");
		printf("\n");
	}
}	
void hollow_diamond(void)
{
	int i=0,j=0,k=0;
	for(i=1;i<=3;i++)
	{
		for(j=3;j>i;j--)
			printf(" ");
		for(k=0;k<i+i-1;k++)
		{
			if(k>0 && k<i+i-2)
			{
				printf(" ");
				continue;
			}
			printf("*");
		}
		printf("\n");
	}
	for(i=1;i<3;i++)
	{
		for(j=0;j<i;j++)
			printf(" ");
		for(k=3;k>=i+i-1;k--)
		{	
			if(k<3 && k>i+i-1)
			{
				printf(" ");
				continue;
			}
			printf("*");
		}
		printf("\n");
	}
}

//diamond_dynamic.c
/*动态加载*/
#include<stdio.h>
#include<stdlib.h>
#include<dlfcn.h>

int main(void)
{
	//1打开共享库文件
	//2判断是否打开成功
	//3查找函数内存信息 声明函数指针
	//4判断是否查找成功
	//5调用函数实现功能
	//6关闭共享库文件 
	//7判断是否关闭成功
	void *handle=dlopen("./libdiamond.so",RTLD_NOW);
	if(NULL==handle)
	{
		printf("dlopen:%s\n",dlerror());
		return -1;
	}
	void(*p_diamond)(void);
	void(*p_hollow_diamond)(void);
	p_diamond=dlsym(handle,"diamond");//本来就是void型的 就不再强转成void
	p_hollow_diamond=dlsym(handle,"hollow_diamond");
	if(NULL==p_diamond|| NULL==p_hollow_diamond)
	{
		printf("dlsym:%s\n",dlerror());
		return -1;
	}
	p_hollow_diamond();
	printf("-----------------\n");
	p_diamond();
	int res=dlclose(handle);
	if(res!=0)
	{
		printf("dlclose:%s\n",dlerror());
		return -1;
	}
	return 0;
}



