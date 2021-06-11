关键字：内存管理技术 程序和进程 进程中的内存区域划分 
	常量字符串不同存放形式的比较（重点） 虚拟内存管理技术
	段错误的由来  使用malloc函数申请动态内存->内存页

内存管理技术
/*程序和进程*/
	程序 - 存放在磁盘/硬盘上的可执行文件；
	进程 - 运行在内存中的程序；
	同一个程序可以同时对应多个进程；

/*进程中的内存区域划分*/
如：
	int num；	//全局变量 默认初始值为0 BSS段(bss)
	int main(void)
	{
		int num; //局部变量 默认初始值为随机数  栈区(stack)
		return 0;
	}

1. 代码区(text)
	该区域存放具体的功能代码，函数指针指向该区域；
2. 只读常量区(text)
	该区域存放常量字符串，const 修饰的已经初始化的全局变量和静态局部变量，以及字面值；
3. 全局区/数据区(data)
	该区域存放没有 const 修饰的已经初始化的全局变量和静态局部变量；
4. BSS段(data)
	该区域存放没有 const 修饰也没有初始化的全局变量和静态局部变量；
	该区域会在main函数执行之前自动清零；
5. 堆区(heap)
	该区域由函数malloc()/calloc()/realloc()/free()函数操作的内存区域；
	该区域由程序员手动申请 手动释放；
6. 栈区(stack)
	该区域存放非静态的局部变量(包括函数的形参)；
	该区域由操作系统自动管理；


//进程中内存区域划分
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int i1=10;//全局区
int i2=20;
int i3;	  //BSS段
const int i4=40; //只读常量区

void fa(int i5) //栈区
{
	int i6=60; //栈区
	static int i7=70; //全局区
	const int i8=80; //栈区

	//p1指向堆区 p1本身在栈区
	int *p1=(int*)malloc(sizeof(int));
	int *p2=(int*)malloc(sizeof(int));
	
	//str指向只读常量区 str本身在栈区
	char *str="hello";
	
	//strs指向栈区 strs本身在栈区
	char strs[]="hello";

	printf("只读常量区：&i4=%p\n",&i4);
	printf("只读常量区：str=%p\n",str);
	printf("---------------------------\n");
	printf("全局区：&i1=%p\n",&i1);
	printf("全局区：&i2=%p\n",&i2);
	printf("全局区：&i7=%p\n",&i7);
	printf("---------------------------\n");
	printf("BSS段：&i3=%p\n",&i3);
	printf("---------------------------\n");
	printf("堆区：p1=%p\n",p1);
	printf("堆区：p2=%p\n",p2);
	printf("---------------------------\n");
	printf("栈区：&i5=%p\n",&i5);
	printf("栈区：&i6=%p\n",&i6);
	printf("栈区：&i8=%p\n",&i8);
	printf("栈区：strs=%p\n",strs);
}

int main()
{
	printf("代码区:fa=%p\n",fa);
	printf("---------------------------\n");
	fa(10);
	return 0;
}

结果：	代码区:fa=0x8048494
	---------------------------
	只读常量区：&i4=0x8048730
	只读常量区：str=0x8048734
	---------------------------
	全局区：&i1=0x804a020
	全局区：&i2=0x804a024
	全局区：&i7=0x804a028
	---------------------------
	BSS段：&i3=0x804a034
	---------------------------
	堆区：p1=0x8b66008
	堆区：p2=0x8b66018
	---------------------------
	栈区：&i5=0xbfb4b9e0
	栈区：&i6=0xbfb4b9b0
	栈区：&i8=0xbfb4b9b4
	栈区：strs=0xbfb4b9c6



综上所述：
	进程中的内存区域按照地址从小到大依次排列的结果：
	代码区，只读常量区，全局区/数据区，BSS段，堆区，栈区；
	一般来说，其中堆区的内存地址按照从小到大依次进行分配，栈区的内存地址按照从大到小依次分配，以避免区域的重叠；


/*常量字符串不同存放形式的比较（重点）*/
对于记录常量字符串的字符指针来说，指针指向的内容不可以改变，但指针指向可以改变。
对于记录常量字符串的数组来说，指针指向的内容可以改变，但是指针的指向不可以改变。

对于指向一块动态内存的指针来说，指针指向的内容和指针的值都可以改变；

//常量字符串不同存放形式的比较
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
	//pc指向只读常量区 pc本身在栈区
	//pc存的其实是h的地址
	char *pc="hello";
	
	//将字符串复制一份到连续存储空间中
	//ps指向栈区 ps本身在栈区 代表第一个元素的地址
	char ps[6]="hello";

	printf("pc=%p,&pc=%p\n",pc,&pc);  //pc=0x80486b0,&pc=0xbff48f2c
	printf("ps=%p,&ps=%p\n",ps,&ps);  //ps=0xbff48f36,&ps=0xbff48f36

	//试图改变指针的指向
	pc="1234";//ok
	//ps="1234";//error

	//试图改变指针指向的内容
	//strcpy(pc,"GOOD");//error
	strcpy(ps,"GOOD");//ok

	printf("--------------------\n");
	//pc指向堆区 pc本身在栈区
	pc=(char*)malloc(sizeof(char)*10);
	//试图改变pc指针指向的内容
	strcpy(pc,"world");
	printf("pc=%s\n",pc);//pc=world

	//指定临时指针指向了动态内存
	char *pt=pc;
	//试图改变pc指针的指向	
	pc="world2";
	printf("pc=%s\n",pc);//world2
	free(pt);
	pt=NULL;

	return 0;
}

结果：	pc=0x80486b0,&pc=0xbff48f2c
	ps=0xbff48f36,&ps=0xbff48f36
	--------------------
	pc=world
	pc=world2


/*虚拟内存管理技术*/
	在linux系统中采用虚拟内存管理技术来进行内存空间的管理，
		即：每个进程都可以拥有0～4G-1的内存地址空间（虚拟的，并不是真实存在的），由操作系统负责建立虚拟地址到真实物理内存/文件的映射，
		因此，不同进程中的地址空间看起来是一样的，但是所对应的真实物理内存/文件是不一样的；
	其中0～3G-1之间的地址空间 叫做用户空间；
	3G～4G-1之间的地址空间叫做内核空间；
	而用户程序一般都运行在用户空间中，不能直接访问内核空间，
	不过内核提供了一些函数用于访问内核空间；

内存地址的基本单位是字节，而内存映射的基本单位是内存页，目前主流的操作系统中一个内存页的大小是4kb（4096个字节）
	1Tb=1024Gb
	1Gb=1024Mb
	1Mb=1024Kb
	1kb=1024byte(字节)
	1byte=8bit(二进制位)

/*段错误的由来*/
1. 试图去操作没有操作权限的内存空间时可能会引起段错误；
   如：试图修改只读常量区中的数据时会引起段错误；
2. 试图使用没有经过映射的虚拟地址时可能会引起段错误；
   如：指定任意地址区访问里面的内容时会引起段错误

/*使用malloc函数申请动态内存*/
1. 使用malloc函数申请动态内存时的注意事项
	使用malloc函数申请动态内存时，除了申请参数指定的动态内存空间之外，还可能申请额外的12个字节（一般原则）用于保存该动态内存块的管理信息，如：大小，是否空闲等信息；
	因此，使用malloc函数申请的动态内存时，切记不要进行越界访问，因为越界访问可能会破坏内存块的管理信息，从而导致段错误的结果；

2. 使用malloc函数申请动态内存时的一般性原则
	当使用malloc函数申请比较小块的动态内存时，操作系统一般会一次性映射33个内存页的地址空间，从而提高效率；
	#include<unistd.h>
	#include<sys/types.h>
	getpid() - 主要用于获取当前进程的进程号；

	cat /proc/进程号/maps - 表示查看指定进程的内存映射情况；
	查看的最终结果是6列：地址范围，权限信息，偏移量，设备编号，i节点编号，进程名称以及路径信息；
	其中重点关注：heap

3. 使用free函数释放动态内存的一般原则
	使用free函数释放多少则从映射的总量中减去多少，当所有的动态内存全部释放完毕后，操作系统依然会保留33个内存页，用以提高效率；


练习：使用C语言中的错误表现形式编写以下两个功能函数：
a.实现计算参数指定文件的大小，并通过返回值返回，如果参数指定的文件打开失败，则返回错误；	file_size()
b.实现比较两个参数字符串的大小并返回最大值，如果相等则返回错误；
		string_compare()

//自己写的
#include<stdio.h>
#include<stdlib.h>

int main(int agrc,char *agrv[])
{
	FILE *p_file=fopen(agrv[1],"rb");
	if(p_file==NULL)
	{
		printf("文件打开失败\n");
		exit(-1);
	}
	fseek(p_file,0,SEEK_END);
	printf("文件大小：%ld\n",ftell(p_file));
	fclose(p_file);
	p_file=NULL;
	return 0;
}

//老师写的
//使用C语言中的错误表现形式编写以下函数
#include <stdio.h>
#include <string.h>

//获取参数指定文件名的大小
int file_size(const char* name)
{
	//1.打开文件，使用fopen函数
	FILE* fp = fopen(name,"rb");
	if(NULL == fp)
	{
		return -1;
	}
	//2.调整文件读写位置到文件末尾，使用fseek函数
	fseek(fp,0,SEEK_END);
	//3.返回文件的大小，使用ftell函数
	return ftell(fp);
}

const char* string_compare(const char* pc1,const char* pc2)
{
	int res = strcmp(pc1,pc2);
	if(0 == res)
	{	
		return NULL;
	}
	else if(res > 0)
	{
		return pc1;
	}
	else
	{
		return pc2;
	}
}

int main(void)
{
	int res = file_size("a.out");
	printf("文件的大小是：%d\n",res);
	printf("最大的字符串是：%s\n",string_compare("hello","world")); // world
	return 0;
}




