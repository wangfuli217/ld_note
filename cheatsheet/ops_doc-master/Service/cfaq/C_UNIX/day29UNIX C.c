关键字：标C和UC文件操作函数    效率            文件描述符的工作原理-> dup/dup2函数


/*标C和UC文件操作函数的比较*/
	标C的文件操作函数执行效率高于UC的文件操作函数，因为标C的文件操作函数内部提供了输入输出缓冲区，
		当数据积累到一定数量之后才去访问内核，才会将数据写入到文件中；
	可以使用命令time来获取程序的执行时间；
   time a.out的执行结果如下：
      real	0m0.073s   => 真实时间(关注)
      user	0m0.052s   => 用户态时间
      sys	0m0.020s   => 内核态时间
可以通过自定义缓冲区的方式来提高效率，但并不是缓冲区越大则效率越高；

练习：
   分别使用标C和UC的文件操作函数编写以下代码：
   a. vi 04fwrite.c文件，将[1 ~ 1000000]之间的每一个整数写入到文件num.dat中；
   b. vi 05write.c文件，将[1 ~ 1000000]之间的每一个整数写入到文件num2.dat中；

//使用标C文件操作函数写入 1 ~ 100万之间的整数
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    //1.打开/创建文件num.dat，使用fopen函数
    FILE* fp = fopen("num.dat","wb");
    if(NULL == fp) 
    {   
        perror("fopen"),exit(-1);
    }   
    printf("打开/创建文件成功\n");
    //2.循环写入1 ~ 100万之间的整数，用fwrite函数
    int i = 0;
    for(i = 1; i <= 1000000; i++)
    {   
        fwrite(&i,sizeof(int),1,fp);
    }   
    printf("写入数据成功\n");
    //3.关闭文件num.dat，使用fclose函数
    int res = fclose(fp);
    if(EOF == res)
    {   
        perror("fclose"),exit(-1);
    }   
    printf("成功关闭文件\n");
    return 0;
}

//使用UC文件操作函数写入 1 ~ 100万之间的整数
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
    //1.打开/创建文件num2.dat，使用open函数
    int fd = open("num2.dat",O_WRONLY|O_CREAT|O_TRUNC,0664);
    if(-1 == fd) 
    {   
        perror("open"),exit(-1);
    }   
    printf("打开/创建文件成功\n");
    //2.循环写入1 ~ 100万之间的数据，用write函数
    int i = 0;
    for(i = 1; i <= 1000000; i++)
    {   
        write(fd,&i,sizeof(int));
    }   
    printf("写入数据成功\n");
    //3.关闭文件num2.dat，使用close函数
    int res = close(fd);
    if(-1 == res)
    {   
        perror("close"),exit(-1);
    }   
    printf("成功关闭文件\n");
    return 0;
}

//使用UC文件操作函数写入 1 ~ 100万之间的整数，使用了自定义buf缓冲区 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	//1.打开/创建文件num2.dat，使用open函数
	int fd = open("num2.dat",O_WRONLY|O_CREAT|O_TRUNC,0664);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件成功\n");
	//自定义缓冲区来提高效率
	int buf[10000];
	int pos = 0;
	//2.循环写入1 ~ 100万之间的数据，用write函数
	int i = 0;
	for(i = 1; i <= 1000000; i++)
	{
		buf[pos++] = i;
		if(10000 == pos)
		{
			write(fd,buf,sizeof(buf));
			pos = 0;
		}
	}
	printf("写入数据成功\n");
	//3.关闭文件num2.dat，使用close函数
	int res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}

/*文件描述符的工作原理*/
	文件描述符本质上就是一个整数，可以代表一个打开的文件。
	但是文件的管理信息并不是存放在文件描述符中，而是存放在文件表等数据结构中，
	使用open函数打开文件时，操作系统会将文件的相关信息加载到文件表等数据结构中，
	但是出于安全和效率等因素的考虑，文件表等数据结构不适合直接操作，
	而是给文件表等结构指定一个编号，使用编号来操作文件，该编号就是文件描述符；

	在每个进程的内部都有一张文件描述符总表，
	当有新的文件描述符需求时，会从文件描述符总表中查找最小的未被使用的文件描述返回，
	文件描述符虽然是int类型，但是本质上是非负整数，
	也就是从0开始，其中 0 1 2 已经被系统占用，分别代表标准输入，标准输出以及标准错误，stdin stdout stderr
	因此一般从 3 开始使用，文件描述符的最大值可以到OPEN_MAX(当前环境是1024)；

	使用close函数关闭文件时，本质上就是将文件描述符和文件表等数据结构的对应关系从文件描述符总表中移除，
	不一定会删除文件表等数据结构，只有当文件表没有和任何其他文件描述符对应时（也就是一个文件表可以同时对应多个文件描述符），
	才会删除文件表等数据结构，close函数也不会改变文件描述符本身的整数值，只是让该文件描述符无法代表一个文件而已；


1. dup/dup2函数       duplicate a file descriptor
    #include <unistd.h>
	int dup(int oldfd);

函数功能：
	实现对参数oldfd的复制，从文件描述符总表中查找最小的未被使用的文件描述符作为oldfd的副本，成功返回新的文件描述符，失败返回-1；
	
	#include <unistd.h>
	int dup2(int oldfd, int newfd);

函数功能：
	实现oldfd到newfd的复制，如果文件描述符newfd已经被其他文件占用，则先关闭再复制，成功返回新的文件描述符，失败返回-1；

注意：
	复制文件描述符的本质就是复制文件描述所对应的文件表地址信息，
		使得多个文件描述符可以对应同一个文件，因此无论使用哪个文件描述符都可以访问文件；

//使用dup函数实现文件描述符的复制
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	//1.打开/创建文件b.txt，使用open函数
	int fd = open("b.txt",O_RDWR|O_CREAT|O_TRUNC,0664);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件成功，fd = %d\n",fd);// 3
	//2.复制文件描述符，使用dup函数
	// int fd2 = fd;
	int fd2 = dup(fd);
	if(-1 == fd2)
	{
		perror("dup"),exit(-1);
	}
	printf("fd = %d,fd2 = %d\n",fd,fd2); //3 4

	//分别使用两个文件描述符写入数据，数据不会覆盖
	write(fd,"A",sizeof(char)); // 写入到b.txt中
	write(fd2,"a",sizeof(char));// 写入到b.txt中

	//3.关闭文件b.txt，使用close函数
	int res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}

	//使用fd2写入数据‘1’
	write(fd2,"1",sizeof(char));

	//关闭文件描述符fd2
	res = close(fd2);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}

	printf("成功关闭文件\n");
	return 0;
}

//使用dup2函数实现文件描述符的复制
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	//1.打开/创建文件b.txt，使用open函数
	int fd = open("b.txt",O_WRONLY|O_CREAT|O_TRUNC,0664);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件b.txt成功\n");
	//2.打开/创建文件d.txt，使用open函数
	int fd2 = open("d.txt",O_WRONLY|O_CREAT|O_TRUNC,0664);
	if(-1 == fd2)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件d.txt成功\n");
	printf("fd = %d,fd2 = %d\n",fd,fd2); // 3 4
	//3.复制文件描述符，使用dup2函数
	int fd3 = dup2(fd,fd2);
	if(-1 == fd3)
	{
		perror("dup2"),exit(-1);
	}
	printf("fd = %d,fd2 = %d,fd3 = %d\n",fd,fd2,fd3);  // 3 4 4
	
	//写入数据到各个文件描述符中 数据不会覆盖
	write(fd,"A",sizeof(char)); // 写入到b.txt
	write(fd2,"a",sizeof(char));// 写入到b.txt
	write(fd3,"1",sizeof(char));// 写入到b.txt

	//4.关闭文件，使用close函数
	int res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	res = close(fd2);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}

作业：
	1.vi write_emp.c文件，要求定义一个员工类型的结构体变量，并且进行初始化，将该员工信息写入到文件emp.dat中，
	  员工信息有 员工编号，姓名，薪水
	2.vi read_emp.c 读取emp.dat中信息并打印
	3.查询fcntl函数

//自己写
//write_emp.c
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/stat.h>
#include<sys/types.h>

typedef struct{
	int num;
	char name[10];
	float salary;
}hum;

int main()
{
	hum h={0};
	int fd=open("emp.dat",O_RDWR|O_CREAT|O_TRUNC,0664);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("成功打开文件\n");
	printf("输入员工编号：");
	scanf("%d",&h.num);
	scanf("%*[^\n]");
	scanf("%*c");
	write(fd,&h.num,sizeof(int));

	printf("输入员工姓名：");
	fgets(h.name,9,stdin);
	write(fd,&h.name,sizeof(char)*10);

	printf("输入员工薪水：");
	scanf("%g",&h.salary);
	scanf("%*[^\n]");
	scanf("%*c");
	write(fd,&h.salary,sizeof(float));


	int res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
}

//read_emp.c
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

typedef struct{
	int num;
	char name[10];
	float salary;
}hum;

int main()
{
	hum h1={0};
	int fd=open("emp.dat",O_RDONLY);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("成功打开文件\n");
	
	read(fd,&h1.num,sizeof(int));
	read(fd,&h1.name,sizeof(char)*10);
	read(fd,&h1.salary,sizeof(float));
	printf("员工编号：%d\n",h1.num);
	printf("员工姓名：%s\n",h1.name);
	printf("员工薪水：%g\n",h1.salary);

	

	int res=close(fd);
	if(-1==fd)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}


//T写的
直接初始化赋值 没价值
 	Emp emp={1001,"zhangfei",3000}



