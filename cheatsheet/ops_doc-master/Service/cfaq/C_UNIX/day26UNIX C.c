关键字：c语言中的错误处理  环境表 环境表相关函数  main函数的原型

	c语言中的错误处理
	环境表的概念和使用
	内存管理技术
	
/*C语言中的错误处理*/
如：
	int main(void)
	{
		if(...)
		{
			return -1; //表示程序出错结束
		}
		return 0； //表示程序正常结束
	}

1. C语言中的错误表现形式（错了吗？）
	C语言中通过函数的返回值来表示该函数是否出错，
	返回值的一般表现形式如下：
		1. 对于返回值类型是int类型的函数，
		   并且函数的计算结果不可能是负数时，使用返回-1 表示出错
		   其他数据表示正常结束；
		2. 对于返回值类型是int类型的函数，
		   但是函数的计算结果可能是负数时，使用指针作为函数的形参类型，
		   将函数的计算结果带出去，而函数的返回值专门用于表示出错，
		   习惯上使用 0 表示正常结束，使用-1 表示出错；
		3. 对于返回值类型是指针的函数，
		   一般使用返回 NULL 表示出错，其他数据表示正常结束；
		4. 对于不考虑是否出错的函数来说，返回值类型用 void 即可；

练习：编写4个功能函数
	1.生成1～10之间的随机数并返回，如果随机数5则返回错误；
	2.比较两个int类型参数的大小并返回最大值，如果相等则返回错误；
	3.判断传入的字符串是否“error”，如果是则返回错误，否则返回“ok”；
	4.打印传入的字符串即可；

#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<string.h>

int rand_1_10(void);//随机数1-10
int max(int,int,int*);
char *error(const char*);
void print(const char*);


int main()
{
	int num=rand_1_10();
	printf("rand:%d\n",num);
	
	printf("两个数字比较大小\n");
	if(0==max(-1,-2,&num))
	{
		printf("最大值是：%d\n",num);
	}

	printf("return string:%s\n",error("error"));

	print("R3AEW");
	return 0;
}

int rand_1_10(void)
{
	srand(time(0));
	int num=rand()%10+1;
	if(5==num)
		return -1;
	return 0;
}
int max(int j,int k,int *p_temp)
{
	if(j==k)
		return -1;
	j>k?(*p_temp=j):(*p_temp=k);
	return 0;
}
char *error(const char *str)
{
	char num=strcmp(str,"error");
	if(0==num)
		return NULL;
	return "ok";
}
void print(const char *str)
{
	printf("str:%s\n",str);
}


2. 错误编号（为什么错了？）
	判断函数是否调用失败，根据函数的返回值进行判断；
	当函数一旦调用失败时，希望知道失败的原因则查看errno的值；
	errno本质就是一个int类型的全局变量，
	当库函数调用出错时，会自动设置errno的值来表示错误的原因；
	
	#include<errno.h> - 实现了对errno外部变量的声明，
	和包含其他头文件，包含errno的取值范围等信息；

/etc/passwd - 主要包含了账户的管理信息；
/etc/shadow - 主要包含了账户的密码以及管理信息；

kevin:x:1000:1000:kevin,,,:/home/kevin:/bin/bash
用户名：密码：用户编号：用户组编号：注释信息，，，：用户主目录：shell的类型


3. 错误信息（对错误编号的翻译）

 1. strerror函数
	#include<string.h>
	char *strerror(int errnum);
函数功能
	主要用于将参数指定的错误编号进行翻译，将翻译得到的字符串通过返回值返回；

//使用errno获取具体的错误信息

#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>
int main(void)
{
	printf("before errno:%d\n",errno);
	printf("strerror:%s\n",strerror(errno));
	//1打开文件etc/passwd，使用fopen
	FILE *fp=fopen("/etc/passwdu","rb");
	if(NULL==fp)
	{
		printf("打开失败\n");
		printf("after errno:%d\n",errno);
		printf("strerror:%s\n",strerror(errno));
		exit(-1);
	}
	//2关闭文件
	fclose(fp);
	return 0;
}

结果：	before errno:0
	strerror:Success
	打开失败
	after errno:2
	strerror:No such file or directory

2. perror函数（重中之重）
	#include <stdio.h>
	void perror(const char *s);
函数功能
	主要用于打印具体的错误信息，参数指向的字符串会原样打印，紧跟着冒号,空格,错误信息以及自动换行；

#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<string.h>

int main(void)
{
	perror("perror");
	//1打开文件etc/passwd，使用fopen
	FILE *fp=fopen("/etc/passwdu","rb");
	if(NULL==fp)
	{
		printf("打开失败\n");
		perror("fopen");
		exit(-1);
	}
	//2关闭文件
	fclose(fp);
	return 0;
}

结果：	perror: Success
	打开失败
	fopen: No such file or directory

3. printf函数(了解)
	printf("%m") - 打印错误信息

注意：
	不能直接使用errno的数值来作为判断函数是否出错的依据,因为errno会保留之前的错误编号，也会随时发生改变，
	因此判断函数是否出错还是依据函数的返回值，而只有明确函数已经出错的情况下，可以依据errno来获取错误的原因；


/*环境表*/
	环境表：环境变量的集合，每个进程内部都拥有一张独立的环境表信息，用于记录专属于该进程的环境信息；

采用指针数组类型

	环境表就是一个以空指针 NULL 作为结尾的字符指针数组，
	其中每个指针都指向一个格式为“变量名=变量值”的字符串，
	该指针数组的首地址保存在全局变量char** environ中，因此通过访问全局变量environ可以遍历整个环境表信息；

//遍历环境表中的所有信息
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(void)
{   
    //声明外部的全局变量
    extern char** environ;
    //指定临时变量
    char** ppv=environ;
    while(*ppv!=NULL)
    {   
        //打印字符串内容
        printf("%s\n",*ppv);
        //指向下一个字符串
        ppv++;
    }
    return 0;
}


/*环境表基本操作的相关函数*/
1. getenv函数
	#include <stdlib.h>
	char *getenv(const char *name);
函数功能：
	主要用于根据参数指定的环境变量名来查找整个环境表，查找成功时，返回该变量名所对应的变量值，查找失败时返回NULL；

#include<stdio.h>
#include<stdlib.h>

int main()
{
    //使用getenv函数来获取环境变量SHELL的数值
    char *pc=getenv("SHELL");
    if(NULL==pc)
    {   
        printf("该环境变量不存在\n");
        return -1; 
    }   
    printf("SHELL=%s\n",pc);
    return 0;
}

2. setenv函数
	#include <stdlib.h>
	int setenv(const char *name, const char *value, int overwrite);
	第一个参数：字符串形式的环境变量名
	第二个参数：字符串形式的环境变量值
	第三个参数：是否修改的标志
			非0 - 修改   
			0 - 不修改
	返回值：The setenv() function returns zero on success,or -1 on error,with errno set to indicate the cause of the error.

函数功能：
	主要用于修改/增加环境变量；

3. unsetenv函数
	#include <stdlib.h>
	int unsetenv(const char *name);
函数功能：
	主要用于从环境表中删除参数指定的环境变量，如果该环境变量不存在，则函数调用成功，环境表没有发生改变；	

4. putenv函数
	#include <stdlib.h>
	int putenv(char *string);
函数功能：
	主要用于增加/修改参数指定的环境变量，参数的格式为：name=value,
	当该变量不存在时则增加，存在时修改，成功返回0，失败返回非0；

5. clearenv函数
       	#include <stdlib.h>
	int clearenv(void);
DESCRIPTION
       The clearenv() function clears the environment of all name-value
       pairs  and  sets  the  value of the external variable environ to
       NULL.
函数功能：
	主要用于清空环境表中所有的环境变量对，并且让全局变量environ也置为空指针，成功返回0，失败返回非0；


/*main函数的原型（了解）*/
	int main(int argc,char *agrv[],char *envp[])
argc - 命令行参数的个数；
argv - 记录每个命令行参数的首地址；
envp - 记录环境表的首地址；

注意：由于历史原因，main函数中的第三个参数不一定被系统所支持，因此建议使用全局变量environ来访问环境表信息

//环境表基本操作函数的实现
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	//使用getenv函数来获取环境变量SHELL的数值
	char* pc = getenv("SHELL");
	//char* pc = getenv("SHELLL");
	if(NULL == pc)
	{
		printf("该环境变量不存在\n");
		return -1;//结束当前函数
	}
	printf("SHELL = %s\n",pc); // /bin/bash

	printf("--------------------------------\n");
	//使用setenv函数修改SHELL的值，要求不修改
	int res = setenv("SHELL","abcd",0);
	if(-1 == res)
	{
		perror("setenv"),exit(-1);
	}
	// /bin/bash
	printf("SHELL = %s\n",getenv("SHELL"));

	//使用setenv函数修改SHELL的值为abcd，要求修改
	res = setenv("SHELL","abcd",1);
	if(-1 == res)
	{
		perror("setenv"),exit(-1);
	}
	// abcd
	printf("SHELL = %s\n",getenv("SHELL"));
	
	//使用setenv函数增加MARK=xiaomage
	res = setenv("MARK","xiaomage",0);
	if(-1 == res)
	{
		perror("setenv"),exit(-1);
	}
	// xiaomage
	printf("MARK = %s\n",getenv("MARK"));

	printf("-----------------------------------\n");
	//使用unsetenv函数删除环境变量MARK
	res = unsetenv("MARK");
	if(-1 == res)
	{
		perror("unsetenv"),exit(-1);
	}
	// (null)
	printf("MARK = %s\n",getenv("MARK"));
	
	printf("----------------------------------\n");
	//使用putenv函数修改环境变量SHELL的数值
	res = putenv("SHELL=/bin/bash");
	if(0 != res)
	{
		perror("putenv"),exit(-1);
	}
	// /bin/bash
	printf("SHELL = %s\n",getenv("SHELL"));

	//使用putenv函数增加环境变量WUHUSHANGJIANG
	res = putenv("WUHUSHANGJIANG=zhangfei");
	if(0 != res)
	{
		perror("putenv"),exit(-1);
	}
	printf("WUHUSHANGJIANG = %s\n",getenv("WUHUSHANGJIANG")); // zhangfei
	
	printf("---------------------------------\n");
	//使用clearenv来清空整个环境表
	res = clearenv();
	if(0 != res)
	{
		perror("clearenv"),exit(-1);
	}
	printf("整个环境表清空完毕\n");
	
	if(NULL == getenv("PATH"))
	{
		printf("环境变量PATH已经被删除了\n");
	}
	extern char** environ;
	if(NULL == environ)
	{
		printf("整个环境表空了\n");
	}
	return 0;
}

结果：	SHELL = /bin/bash
	--------------------------------
	SHELL = /bin/bash
	SHELL = abcd
	MARK = xiaomage
	-----------------------------------
	MARK = (null)
	----------------------------------
	SHELL = /bin/bash
	WUHUSHANGJIANG = zhangfei
	---------------------------------
	整个环境表清空完毕
	环境变量PATH已经被删除了
	整个环境表空了









