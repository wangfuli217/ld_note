关键字：manual gcc    头文件的详细组成

/* man 各章节 */
1 - commands
2 - system calls
3 - library calls
4 - special files
5 - file formats and convertions
6 - games for linux
7 - macro packages and conventions
8 - system management commands
9 - 其他

1是普通的命令

2是系统调用,如open,write之类的(通过这个，至少可以很方便的查到调用这个函数，需要加什么头文件)

3是库函数,如printf,fread

4是特殊文件,也就是/dev下的各种设备文件

5是指文件的格式,比如passwd, 就会说明这个文件中各个字段的含义

6是给游戏留的,由各个游戏自己定义

7是附件还有一些变量,比如向 environ这种全局变量在这里就有说明

8是系统管理用的命令,这些命令只能由root使用,如ifconfig


UC课程内容简介
	1. Unix/Linux系统的概述以及编程基础；
	2. Unix/Linux系统下的内存管理技术；
	3. Unix/Linux系统下的文件管理以及目录操作；
	4. Unix/Linux系统下的进程管理技术；
	5. Uinx/Linux系统下的信号处理技术；
	6. Uinx/Linux系统下的进程间通信技术；
	7. Uinx/Linux系统下的网络编程技术；
	8. Uinx/Linux系统下的多线程开发技术；

/* Unix和Linux系统的简介 */
Unix系统简介
	Unix系统诞生于1970年，具有支持多用户多任务以及多种处理器的特性；
Linux系统简介
	Linux系统是一款自由免费开放源代码的类Unix操作系统
	当前环境：ubuntu12.04 32位的操作系统
	ubuntu系统每半年发布一个新版本，分别是 4月 和 10月

/* gcc编译器的使用 */
基本概念
	gcc原名叫做 GNU C Compiler(编译器)，支持对C语言的编译链接
	后来对编译器进行了扩展，支持了更多的编程语言，如C++等等，改名为GNU Compiler Colection(集合)；

基本功能
	目前主流的编程基本上都是使用高级语言进行，如C语言，
	但是高级语言编写的程序无法被计算机直接执行，
	需要先翻译成汇编语言，再翻译成机器指令，最后被计算机执行；
	
	为了实现高级语言代码到机器指令的翻译，则需要使用gcc编译器进行编译链接，而生成的过程分四步
	1. 预处理/预编译
		主要用于实现头文件的扩展以及宏替换； 
		（.i 文件）cc -E 01hello.c -o 01hello.i
	2. 编译
		主要用于将高级语言代码翻译成汇编语言，得到汇编文件； 
		（.s 文件）cc -S 01hello.i
	3. 汇编
		主要用于将汇编语言翻译成机器语言指令，得到目标文件；
		（.o 文件）cc -c 01hello.s
	4. 链接
		主要用于将目标文件和库文件进行链接，得到可执行文件；
		（ a.out ）cc 01hello.o
					cc 01hello.o -o hello  //得到hello可执行文件

常用的编译选项
	1. 熟练掌握的选项
		gcc/cc -E 预处理，默认输出到屏幕，可以使用-o来指定输入文件(xxx.i)
		gcc/cc -S 编译，将高级语言文件翻译成汇编语言文件(xxx.s)
		gcc/cc -c 汇编，将汇编语言文件翻译成机器语言文件(xxx.o)
		gcc/cc 编译链接，默认生成a.out的可执行文件
	2. 熟悉的选项
		gcc/cc -std    指定执行的C标准(C89 C99)
		gcc/cc -v      查看gcc的版本信息
		gcc/cc -Wall   尽可能显示所有警告信息
		gcc/cc -Werror 将警告当作错误来处理
	3. 了解的选项
		gcc/cc -g 生成调试信息，可以生成GDB调试
		gcc/cc -x 显示指定源代码的编程语言
		gcc/cc -O 对代码进行优化处理
	4. 扩展的选项
		man 命令/函数/gcc  -查看相关命令/函数/gcc编译器

常见的编程相关的文件后缀
	.h 头文件
	.c 源文件
	.i 预处理文件
	.s 汇编文件
	.o 目标文件(机器语言指令)

	.a 静态库文件
	.so 共享库文件

多文件结构的编程
	多文件结构的主要组成
		.h 头文件 主要存放结构体定义，函数声明等
		.c 源文件 主要存放函数的定义等
		.a 静态库文件 主要对功能函数的打包
		.so 共享库文件 主要对功能函数的打包

/*头文件的详细组成（重点）*/
	1. 头文件的卫士
		#ifndef _XXX_H
		#define _XXX_H
		... ...
		#endif //_XXX_H
	2. 包含其他头文件
		#include<stdio.h>
		... ...
	3. 进行宏定义
		#define PI 3.14
	4. 进行结构体的定义以及对数据类型起别名
		typedef struct node{
			int data;
			struct node *next;
		}Node;

		typedef struct
		{
			Enum_Camera_Open_Type type; // 拍摄类型，照片or视频
    		Enum_DevState state; 		// 拍摄状态， busy，free， succ, fail,
    		uint record;				//记录时间
    		char run;					//摄像头是否运行
    		char media_name[50];
		}Struct_Camera_Typedef;
		
		Struct_Camera_Typedef Camera = {JPG,Camera_free,0,0,{0}};
		
	5. 外部变量和函数的声明
		extern int num;
		void show(void);

作业：创建目录circle 在circle目录中编写以下3个文件
	circle.h  声明计算圆形周长和面积的函数，函数名分别为circle_length 和 circle_area;
	circle.c  定义圆形周长和面积函数
	main.c 调用周长 面积函数 半径由用户手动输入
预习
	常用预处理指令
	环境变量的概念和使用
	库文件的概念和使用
	

