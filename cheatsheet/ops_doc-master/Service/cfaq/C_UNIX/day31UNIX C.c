关键字:	文件管理：chmod/fchmod truncate/ftruncate  umask    mmap/munmap
	目录管理：opendir/readdir/closedir
	进程管理

/*文件管理*/
1.1 chmod/fchmod函数 change permissions of a file
       	#include <sys/stat.h>
	int chmod(const char *path, mode_t mode);
	int fchmod(int fd, mode_t mode);
第一个参数：字符串形式的文件路径名/文件描述符
第二个参数：具体的新权限，如：0664

函数功能：
	修改指定文件的指定权限；


1.2 truncate/ftruncate函数（重点）	truncate a file to a specified length
       	#include <unistd.h>
       	#include <sys/types.h>
       	int truncate(const char *path, off_t length);
       	int ftruncate(int fd, off_t length);
第一个参数：字符串形式的文件路径/文件描述符
第二个参数：具体的新长度

函数功能：
	修改指定文件的指定大小；

注意：
	当文件变小时，后面的多余数据会丢失；
	当文件变大时，扩展出来的内容读取到的就是'\0',而文件读写位置的偏移量不会改变；

       If  the  file  previously  was larger than this size, the extra data is
       lost.  If the file previously was shorter,  it  is  extended,  and  the
       extended part reads as null bytes ('\0').

       The file offset is not changed.

练习：
	使用echo hello > a.txt的方式创建文件a.txt 
	vi chmod_truncate.c文件，使用stat函数获取文件a.txt的权限和大小信息并打印，
	然后使用chmod和truncate函数修改文件的权限和大小为 0600和100，最后使用stat函数获取并打印

//修改文件的大小以及权限信息
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(void)
{
	struct stat st = {};
	//1.使用stat函数获取文件a.txt信息，并打印
	int res = stat("a.txt",&st);
	if(-1 == res)
	{
		perror("stat"),exit(-1);
	}
	printf("文件的权限是：%o,文件的大小是：%ld\n",st.st_mode&0777,st.st_size);
	//2.修改文件的权限和大小信息
	res = chmod("a.txt",0600);
	if(-1 == res)
	{
		perror("chmod"),exit(-1);
	}
	printf("修改文件的权限成功\n");
	res = truncate("a.txt",100);
	if(-1 == res)
	{
		perror("truncate"),exit(-1);
	}
	printf("修改文件的大小成功\n");
	//3.使用stat函数获取修改后信息，并打印
	res = stat("a.txt",&st);
	if(-1 == res)
	{
		perror("stat"),exit(-1);
	}
	printf("修改之后的文件权限是：%o，文件大小是：%ld\n",st.st_mode&0777,st.st_size);
	return 0;
}



1.3 umask函数	set file mode creation mask
       	#include <sys/types.h>
       	#include <sys/stat.h>
       	mode_t umask(mode_t mask);
函数功能：
	设置文件在创建时屏蔽的权限为：参数指定的权限值，
	返回之前的旧的屏蔽权限；
	在创建之前设置屏蔽权限，创建之后再设置是无效的；

//使用umask函数设置文件创建时屏蔽的权限
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	// 八进制的 002 就是当前系统默认屏蔽的权限
	// 使用umask函数设置新的权限屏蔽字
	// 练习：查询mmap和munmap函数
	mode_t old = umask(0055);
	printf("old = %o\n",old); // 2
	//1.创建文件b.txt，使用open函数
	int fd = open("b.txt",O_RDWR|O_CREAT|O_EXCL,0777);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("创建文件成功\n");		//b.txt 0722
	
	//调用umask函数恢复系统默认的权限屏蔽
	umask(old);	//无效的 创建之后无法修改

	//2.关闭文件b.txt，使用close函数
	int res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}



1.4 mmap/munmap函数	map or unmap files or devices into memory
       	#include <sys/mman.h>
       	void *mmap(void *addr, size_t length, int prot, int flags,int fd, off_t offset)；
       	int munmap(void *addr, size_t length);

通过建立文件到虚拟地址的映射，可以将对文件的读写操作转换为对内存地址的读写操作，
	只需要简单的赋值操作就可以将数据写入到文件中，因此又多了一种读写文件的方式

       The prot argument describes the desired memory protection of  the  map‐
       ping  (and  must  not  conflict with the open mode of the file).  It is
       either PROT_NONE or the bitwise OR of one  or  more  of  the  following
       flags:

       PROT_EXEC  Pages may be executed.

       PROT_READ  Pages may be read.

       PROT_WRITE Pages may be written.

       PROT_NONE  Pages may not be accessed.

int prot 和 文件打开（open）的flag参数保持一致

//使用mmap函数建立文件到虚拟地址的映射
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

//定义员工的数据类型
typedef struct
{
	int id;//员工编号
	char name[20];//员工姓名
	double salary;//员工薪水	
}Emp;

int main(void)
{
	//1.打开/创建文件emp.dat，使用open函数
	int fd = open("emp.dat",O_RDWR|O_CREAT|O_TRUNC,0664);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件成功\n");
	//2.修改文件的大小为3个员工信息的大小
	int res = ftruncate(fd,3*sizeof(Emp));
	if(-1 == res)
	{
		perror("ftruncate"),exit(-1);
	}
	printf("修改文件的大小成功\n");
	//3.建立文件到虚拟地址的映射，使用mmap函数
	void* pv = mmap(NULL,3*sizeof(Emp),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
	if(MAP_FAILED == pv)
	{
		perror("mmap"),exit(-1);
	}
	printf("建立虚拟地址到文件的映射成功\n");
	//4.使用虚拟地址存放员工信息
	Emp* pe = pv;
	pe[0].id = 1001;
	strcpy(pe[0].name,"zhangfei");
	pe[0].salary = 3000;

	pe[1].id = 1002;
	strcpy(pe[1].name,"guanyu");
	pe[1].salary = 3500;

	pe[2].id = 1003;
	strcpy(pe[2].name,"liubei");
	pe[2].salary = 4000;
	//5.解除映射，使用munmap函数
	res = munmap(pv,3*sizeof(Emp));
	if(-1 == res)
	{
		perror("munmap"),exit(-1);
	}
	printf("解除映射成功\n");
	//6.关闭文件，使用close函数
	res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	//练习：vi 03mmapB.c文件，通过映射的方式将文件emp.dat中的3个员工信息打印出来
	return 0;
}



//使用映射的机制打印文件中的员工信息
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

//定义员工的数据类型
typedef struct
{
	int id;
	char name[20];
	double salary;
}Emp;

int main(void)
{
	//1.打开文件emp.dat，使用open函数
	int fd = open("emp.dat",O_RDONLY);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");
	//2.建立虚拟地址到文件的映射，使用mmap函数
	void* pv = mmap(NULL,3*sizeof(Emp),PROT_READ,MAP_SHARED,fd,0);
	if(MAP_FAILED == pv)
	{
		perror("mmap"),exit(-1);
	}
	printf("建立虚拟地址到文件的映射成功\n");
	//3.根据虚拟地址打印文件中的信息
	Emp* pe = pv;
	int i = 0;
	for(i = 0; i < 3; i++)
	{
		printf("%d,%s,%lf\n",pe[i].id,pe[i].name,pe[i].salary);
	}
	//4.解除映射，使用munmap函数
	int res = munmap(pv,3*sizeof(Emp));
	if(-1 == res)
	{
		perror("munmap"),exit(-1);
	}
	printf("解除映射成功\n");
	//5.关闭文件emp.dat，使用close函数
	res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}





1.5 其他函数
	link() - 用于建立硬链接  man第2节
		make a new name for a file
       		#include <unistd.h>

		int link(const char *oldpath, const char *newpath);

	unlink() - 用于删除硬链接  man第2节
		delete a name and possibly the file it refers to
		#include <unistd.h>

       		int unlink(const char *pathname);

	rename() - 用于重命名文件  man第2节
		change the name or location of a file
       		#include <stdio.h>

		int rename(const char *oldpath, const char *newpath);

	remove() - 用于删除文件  man第3节
		remove a file or directory
	       	#include <stdio.h>

       		int remove(const char *pathname);
	


/*目录管理*/
常用的基本操作函数
1. opendir函数	open a directory  
	#include <sys/types.h>
       	#include <dirent.h>
       	DIR *opendir(const char *name);
       	DIR *fdopendir(int fd);

函数功能：
	打开参数指定的目录，成功返回有效的目录指针，失败返回 NULL；

2. readdir函数	read a directory
       	#include <dirent.h>
	struct dirent *readdir(DIR *dirp);

DESCRIPTION
       The readdir() function returns a pointer to a dirent structure representing the next directory entry in the directory stream pointed to by dirp.  
       It returns NULL on reaching the end of  the directory stream or if an error occurred.


函数功能：
	读取参数指定的目录内容，参数为opendir函数的返回值，读取成功时/*返回一个*/有效的结构体指针，失败返回 NULL；

           struct dirent {
               ino_t          d_ino;       /* inode number */
               off_t          d_off;       /* offset to the next dirent */
               unsigned short d_reclen;    /* length of this record */
               unsigned char  d_type;      /* type of file; not supported	文件的类型
                                              by all file system types */
               char           d_name[256]; /* filename */			文件的名称
           };



3. closedir函数	 close a directory	
		#include <sys/types.h>
		#include <dirent.h>
	int closedir(DIR *dirp);

函数功能：
	关闭参数指定的目录，参数为opendir函数的返回值；

//读取目录中的所有内容并打印
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

int main(void)
{
	//1.打开目录code，使用opendir函数
	DIR* dir = opendir("../code");
	if(NULL == dir)
	{
		perror("opendir"),exit(-1);
	}
	printf("打开目录成功\n");
	//2.循环读取目录中的内容，使用readdir函数
	struct dirent* ent = readdir(dir);
	//while((ent = readdir(dir)) != NULL)
	//while(ent = readdir(dir))
	while(ent != NULL)
	{
		// 类型为4 表示目录文件
		// 类型为8 表示普通文件
		printf("%d,%s\n",ent->d_type,ent->d_name);
		//读取下一个
		ent = readdir(dir);
	}
	//3.关闭目录code，使用closedir函数
	int res = closedir(dir);
	if(-1 == res)
	{
		perror("closedir"),exit(-1);
	}
	printf("成功关闭目录\n");
	return 0;
}





4. 其他函数
	mkdir() - 创建目录的函数  man第2节
		create a directory
       		#include <sys/stat.h>
       		#include <sys/types.h>

		int mkdir(const char *pathname, mode_t mode);

	rmdir() - 删除目录的函数  man第2节
		delete a directory
       		#include <unistd.h>

       		int rmdir(const char *pathname);

	chdir() - 切换目录的函数  man第2节
		change working directory
       		#include <unistd.h>       
		int chdir(const char *path);

       		int fchdir(int fd);

	getcwd() - 获取当前工作目录所在的绝对路径信息  man第2节
		Get current working directory
       		#include <unistd.h>

       		char *getcwd(char *buf, size_t size);

       		char *getwd(char *buf);

       		char *get_current_dir_name(void);


/*进程的管理*/
1. 基本概念和基本命令
	程序 - 存放在磁盘上的可执行文件；
 	进程 - 运行在内存中的程序；
	同一个程序可以同时对应多个进程；

	//ps - 表示查看当前终端启动的进程信息；
ps命令的执行结果如下：
	PID - 进程的标号（重点）
	TTY - 终端的次要装置号码
	TIME - 消耗CPU的时间
	CMD - 进程的名称（重点）
  PID TTY          TIME CMD
 3373 pts/0    00:00:00 bash
 5390 pts/0    00:00:00 ps

	//ps -aux - 表示查看所有包括其他使用者的进程信息；
	//ps -aux | more - 表分屏显示所有的进程信息；

[tarena@~/UNIX]$ps -aux | more

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   3660  2096 ?        Ss   08:31   0:00 /sbin/init
root         2  0.0  0.0      0     0 ?        S    08:31   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S    08:31   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   08:31   0:00 [kworker/0:0H]


USER - 用户名称
PID - 进程的编号
%CPU - 占用CPU的百分比
%MEM - 占用内存的百分比
VSZ - 虚拟内存的大小
RSS - 物理内存的大小
TTY - 终端的次要装置号码
STAT - 进程的状态信息
START - 进程的启动时间
TIME - 消耗CPU的时间
COMMAND - 进程的名称	

其中进程的主要状态如下：
	S 休眠状态，为了减轻CPU的压力
	s 进程的领导者。下面拥有子进程
	Z 僵尸进程，已经结束但资源没有回收的进程
	R 正在进行的进程
	O 可以运行的进程
	T 挂起的进程
	< 优先级比较高的进程
	N 优先级比较低的进程


	//ps -ef - 表示以全格式的方式显示进程信息；
	//ps -ef | more - 表示以分屏显示信息；

UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 08:31 ?        00:00:00 /sbin/init
root         2     0  0 08:31 ?        00:00:00 [kthreadd]
root         3     2  0 08:31 ?        00:00:01 [ksoftirqd/0]
root         5     2  0 08:31 ?        00:00:00 [kworker/0:0H]
root         7     2  0 08:31 ?        00:00:00 [migration/0]
root         8     2  0 08:31 ?        00:00:00 [rcu_bh]
root         9     2  0 08:31 ?        00:00:05 [rcu_sched]
root        10     2  0 08:31 ?        00:00:00 [watchdog/0]
root        11     2  0 08:31 ?        00:00:00 [watchdog/1]
root        12     2  0 08:31 ?        00:00:00 [migration/1]

ps -ef | more的执行结果如下：
UID - 用户的ID
PID - 进程的编号
PPID - 父进程的标号
C - 占用CPU的百分比
STIME - 启动时间
TTY - 终端的次要装置号码
TIME - 销耗CPU的时间
CMD - 进程的名称


	目前主流的操作系统都支持多进程，如果进程A启动了进程B，那么进程A就叫做进程B的父进程，进程B就是进程A的子进程；
	当前系统中进程0（系统内部的进程）负责启动进程1（init）和进程2，其他所有进程都是直接/间接由进程1/进程2启动起来的，从而构成了逻辑结构中的树形结构；
	进程号的数据类型虽然是int类型，但是本质上是从0开始，作为进程的唯一标识，操作系统采用延迟重用的策略进行进程号的管理，从而保证在任意时刻进程号都是唯一的；

	
	//kill -9 进程号 - 表示杀死指定的进程


2. 各种ID的获取
	getpid() - 获取当前进程的编号，返回值类型是pid_t
	getppid() - 获取当前进程父进程的编号，返回值类型是pid_t	      //parent
       	 #include <sys/types.h>
       	 #include <unistd.h>
       	 pid_t getpid(void);
         pid_t getppid(void);
	
	getuid() - 获取当前用户的编号，返回值类型是uid_t     //user
         #include <unistd.h>
         #include <sys/types.h>
         uid_t getuid(void);

	getgid() - 获取当前用户所在用户组的编号,返回值类型你是gid_t     //group
         #include <unistd.h>
         #include <sys/types.h>
         gid_t getgid(void);

注意：
	pid_t   int 
	uid_t	unsigned int
	gid_t	unsigned int

  79 __extension__ typedef __u_quad_t __dev_t;
  80 __extension__ typedef unsigned int __uid_t;
  81 __extension__ typedef unsigned int __gid_t;
  82 __extension__ typedef unsigned long int __ino_t;
  83 __extension__ typedef __u_quad_t __ino64_t;
  84 __extension__ typedef unsigned int __mode_t;
  85 __extension__ typedef unsigned int __nlink_t;
  86 __extension__ typedef long int __off_t;
  87 __extension__ typedef __quad_t __off64_t;
  88 __extension__ typedef int __pid_t;
  89 __extension__ typedef struct { int __val[2]; } __fsid_t;
  90 __extension__ typedef long int __clock_t;
  91 __extension__ typedef unsigned long int __rlim_t;
  92 __extension__ typedef __u_quad_t __rlim64_t;
  93 __extension__ typedef unsigned int __id_t;
  94 __extension__ typedef long int __time_t;
  95 __extension__ typedef unsigned int __useconds_t;
  96 __extension__ typedef long int __suseconds_t;


////各种ID的获取并打印
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main(void)
{
	printf("pid = %d\n",getpid());
	printf("ppid = %d\n",getppid());
	printf("uid = %d\n",getuid());
	printf("gid = %d\n",getgid());
	return 0;
}

结果：	pid=6427
	ppid=3373
	uid=1000
	gid=1000




作业：
   编程实现打印目录中的所有内容，要求子目录中的内容也要打印
参考代码如下 vi 06dir.c:
   void print(char* path)
   {
      // ... ...
   }
   int main(void)
   {
      print("../../day02/code");
      return 0;
   }

//自己写的
//读取目录中的所有内容并打印
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

struct dirent* ent;
void *print(char *path)
{
	
	//1.打开目录code，使用opendir函数
	DIR* dir = opendir(path);
	if(NULL == dir)
	{
		perror("opendir"),exit(-1);
	}
	printf("打开目录成功\n");
	//2.循环读取目录中的内容，使用readdir函数
	//struct dirent* ent = readdir(dir);
	//while((ent = readdir(dir)) != NULL)
	while(ent = readdir(dir))
	//while(ent != NULL)
	{
		printf("%d,%s\n",ent->d_type,ent->d_name);
		if((ent->d_type == 4) && (ent->d_name[0] != '.'))
		{
			printf("%s\n",ent->d_name);
			//sprintf就可以实现跨目录
			//char buf[100]={0};
			//sprintf(buf,"%s/%s",path,ent->d_name);
				print(ent->d_name);	
		}
	}
	//3.关闭目录code，使用closedir函数
	int res = closedir(dir);
	if(-1 == res)
	{
		perror("closedir"),exit(-1);
	}
	printf("成功关闭目录\n");

}
int main(void)
{
	print("./data");
	return 0;
}


//老师写的
//打印目录 和其中子目录内容
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>
#include<dirent.h>

void print(char *path)
{
	//1.打开目录,使用opendir函数
	//2.循环读取目录中的内容
	//2.1如果读取到的是目录，则先打印再递归
	//2.2如果读取的是文件，则直接打印即可
	//3.关闭目录,使用closedir函数
	DIR *dir=opendir(path);
	if(NULL==dir)
	{
		return;//结束当前函数
	}
	struct dirent *ent;
	while(ent=readdir(dir))
	{
		if(ent->d_type==4)
		{
			printf("[%s]\n",ent->d_name);
			if(!strcmp(ent->d_name,".") || !strcmp(ent->d_name,".."))
			{
				continue;
			}
			//拼接子目录的路径信息
			char buf[100]={0};
			sprintf(buf,"%s/%s",path,ent->d_name);
			//进行递归打印
			print(buf);
		}
		if(8==ent->d_type)
		{
			printf("%s\n",ent->d_name);
		}
	}
	int res=closedir(dir);
	if(-1==res)
	{
		return;
	}
}

int main()
{
	print("../data");
	return 0;
}




