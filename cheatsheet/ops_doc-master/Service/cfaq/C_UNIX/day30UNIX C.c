关键字：文件管理
	fcntl函数    manipulate file descriptor
	文件锁 读写操作附加锁
	access函数    check real user's permissions for a file  '
	stat/fstat函数（重点）	 get file status
	ctime函数    localtime函数
	

1. fcntl函数		manipulate file descriptor
    #include <unistd.h>
    #include <fcntl.h>
	int fcntl(int fd, int cmd, ... /* arg */ );
第一个参数：文件描述符,open函数的返回值
第二个参数：具体的操作命令
第三个参数：可变长参数，是否需要取决于cmd
	如果实现文件锁的功能，则需要一个指向以下结构体的指针：
           struct flock {
               ...
               short l_type;    /* Type of lock:  锁的类型 读锁 写锁 解锁
				   F_RDLCK,F_WRLCK, F_UNLCK */
               short l_whence;  /* How to interpret l_start:  加锁的起始位置
                                   SEEK_SET, SEEK_CUR, SEEK_END */
               off_t l_start;   /* Starting offset for lock */  相对于起始位置的偏移量
               off_t l_len;     /* Number of bytes to lock */	加锁的长度，单位字节
               pid_t l_pid;     /* PID of process blocking our lock  加锁的进程号
                                   (F_GETLK only) */
               ...
           };

返回值：
	F_DUPFD - 成功返回新的文件描述符; F_DUPFD            The new descriptor.
	F_GETFD - 成功返回文件描述符的标志值; F_GETFD  Value of file descriptor flags.
	F_GETFL - 成功返回文件的状态标志值; F_GETFL  Value of file status flags.
	其他命令成功返回0，所有命令失败均返回-1； All other commands -> Zero.

函数功能：
	用于操作文件描述符，具体方法如下(int cmd 取值)：
	1. 复制文件描述符 Duplicating a file descriptor
	   F_DUPFD - 查找最小的>=arg的描述符作为fd的副本，
		     与dup2不同的地方在于：若arg已经被其他文件占用，则不会关闭，而是查找>arg的描述符进行复制；
	
	2. 操作文件描述符的标志 File descriptor flags
	   F_GETFD/F_SETFD - 获取/设置文件描述符的标志
	
	3. 操作文件的状态标志 File status flags
	   F_GETFL/F_SETFL - 获取/设置文件的状态标志

	4. 实现建议锁/文件锁的功能（重点） Advisory locking
	   F_GETLK, F_SETLK and F_SETLKW - 实现加锁/解锁功能
	   F_GETLK, F_SETLK and F_SETLKW are used to acquire,  release,  and  test  for the existence of record locks


/*使用fcntl函数实现文件锁的功能*/
1. 文件锁的由来
	当多个进程在同一个时刻向同一个文件中的同一块区域写入不同数据时，可能会造成文件数据的交错和混乱文件，
		理论上多个进程读文件可以同时进行，但是只要有一个进程执行写操作，那么多个进程就不同时进行，
		为了实现该效果，需要借助文件锁机制；

	文件锁本质就是读写锁，一把读锁和一把写锁，其中读锁是共享锁，允许其他进程加读锁但不允许加写锁；
		而写锁是互斥锁，不允许其他进程加读锁和写锁；

2. 使用F_SETLK作为函数第二个实参的用法
	当锁的类型是F_RDLCK F_WRLCK时，实现加锁的功能
	当锁的类型是F_UNLCK时，实现解锁的功能
	无论实现加锁还是解锁，具体的锁信息由第三个参数指定；


              Acquire  a lock (when l_type is F_RDLCK or F_WRLCK) or release a
              lock (when l_type is F_UNLCK) on  the  bytes  specified  by  the
              l_whence,  l_start,  and l_len fields of lock.  If a conflicting
              lock is held by another process, this call returns -1  and  sets
              errno to EACCES or EAGAIN


	当文件被加写锁时，依然是可以写入数据到文件中，由此可见，文件锁并不能真正锁定对文件的读写操作，
		只能锁定其他的锁，也就是导致第二次加锁失败（两个读锁除外） => 君子协定

	如何通过文件锁实现对文件读写操作的控制呢？
解决方法：在读写操作的时候，附带加锁操作，根据能否进行加锁成功决定是否读写操作；
	  加锁成功说明其他进程没有在写这个文件
	  加锁失败说明其他进程正在写这个文件，已经加了写锁

//附带加锁的写操作代码
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	//1.打开文件 使用open
	//2.准备一把锁
	//3.加锁 fcntl
	//4.写hello到a txt
	//5关闭文件，使用close
	int fd=open("a.txt",O_WRONLY);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");
	
	struct flock lock;
	lock.l_type=F_WRLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=0;
	lock.l_len=5;
	lock.l_pid=-1;
	int res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
	{
		printf("文件已被加锁，无法执行写操作\n");
	}
	else
	{
		char data[5]="hello";
		res=write(fd,data,5);
		if(res==-1)
		{
			perror("write"),exit(-1);
		}
		printf("写入成功\n");
	}
	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("关闭文件成功\n");
	return 0;
}


//使用fcntl()函数实现加锁 读锁
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	//1.打开文件a.txt，使用open函数
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");

	//2.准备一把锁，进行初始化
	struct flock lock;
	lock.l_type=F_RDLCK;//读锁
	lock.l_whence=SEEK_SET;//文件开头位置
	lock.l_start=0;//不偏移
	lock.l_len=10;//锁定10个字节数
	lock.l_pid=-1;//暂时不使用
	//3.使用fcntl函数进行加锁
	int res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
	{
		perror("fcntl"),exit(-1);
	}
	printf("加锁成功,开始使用文件...\n");
	//4.模拟占用文件20秒
	sleep(20);
	printf("使用文件结束，即将关闭文件...\n");
	//5.关闭a.txt，使用close函数
	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}


//使用fcntl()函数实现加锁 写锁
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	//1打开文件
	//2准备锁结构体参数
	//3加锁
	//4占用5秒
	//5关闭文件
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");
	
	struct flock lock;
	lock.l_type=F_WRLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=2;	//第三个字节开始，指针就要置到第二个后面
	lock.l_len=15;
	lock.l_pid=-1;
	int res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
	{
		perror("fcntl"),exit(-1);
	}
	printf("加锁成功\n");

	sleep(5);

	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("关闭文件成功\n");
	return 0;
}


//使用fcntl()函数实现解锁
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	//1.打开文件a.txt，使用open函数
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");

	//2.准备一把锁，进行初始化
	struct flock lock;
	lock.l_type=F_RDLCK;//读锁
	lock.l_whence=SEEK_SET;//文件开头位置
	lock.l_start=0;//不偏移
	lock.l_len=10;//锁定10个字节数
	lock.l_pid=-1;//暂时不使用
	//3.使用fcntl函数进行加锁
	int res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
	{
		perror("fcntl"),exit(-1);
	}
	printf("加锁成功,开始使用文件...\n");
	//4.模拟占用文件20秒
	sleep(20);
	printf("使用文件结束，即将解锁...\n");

	//5.修改锁的类型实现解锁的效果
	lock.l_type=F_UNLCK;
	res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
	{
		perror("fcntl"),exit(-1);
	}
	printf("解锁成功，20秒后关闭文件\n");
	
	sleep(20);
	printf("开始关闭文件\n");

	//6.关闭a.txt，使用close函数
	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}


 释放锁的方式：
	1. 将锁的类型改为F_UNLCK，重新使用fcntl函数进行设置即可；
	2. 使用close函数关闭文件描述符时，与该描述符有关的文件锁全部被释放；
	3. 进程结束时会自动释放所有与该进程相关的文件锁；


3. 使用F_SETLKW作为函数第二个实参的用法   F_SETLK   W - wait
	该参数的用法与F_SETLK相似，所不同的是当文件中已经存在一把冲突的锁时，并不会返回加锁失败，而是一直等待直到文件上的冲突锁被释放为止；

              As for F_SETLK, but if a conflicting lock is held
              on  the  file,  then  wait  for  that  lock to be
              released.  If a signal is caught  while  waiting,
              then  the call is interrupted and (after the sig‐
              nal handler  has  returned)  returns  immediately
              (with return value -1 and errno set to EINTR; see
              signal(7)).


4. 使用F_GETLK作为函数第二个实参的用法
	如果第三个参数描述的锁信息可以加到文件上，则fcntl函数不会去加锁，而是将锁的类型改为F_UNLCK,其他成员保持不变；
	如果第三个参数描述的锁信息不可以加到文件上，则fcntl函数会获取文件上已经存在的锁信息，并用这些信息覆盖第三个参数原来描述的锁信息；

              On input to this call, lock describes a  lock  we
              would  like  to  place  on the file.  If the lock
              could be placed, fcntl() does not actually  place
              it,  but  returns  F_UNLCK in the l_type field of
              lock and leaves the other fields of the structure
              unchanged.   If  one  or  more incompatible locks
              would  prevent  this  lock  being  placed,   then
              fcntl()  returns details about one of these locks
              in  the  l_type,  l_whence,  l_start,  and  l_len
              fields  of  lock  and sets l_pid to be the PID of
              the process holding that lock.


1.3 access函数	check real user's permissions for a file    '
	#include <unistd.h>
	int access(const char *pathname, int mode);
第一个参数：字符串形式的文件路径名
第二个参数：具体的操作模式
	F_OK - 判断文件是否存在（重点）
	R_OK - 判断文件是否可读
	W_OK - 判断文件是否可写
	X_OK - 判断文件是否可执行
返回值：成功0 失败-1

函数功能：
	判断文件的存在性以及是否拥有相应的权限；

//使用access函数判断文件存在性和获取相应的权限
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main()
{
    //判断文件是否存在
    if(0==access("a.txt",F_OK))
    {   
        printf("该文件存在\n");
    }   
    //判断文件是否可读
    if(0==access("a.txt",R_OK))
    {   
        printf("该文件可读\n");
    }   
    //判断文件是否可写
    if(0==access("a.txt",W_OK))
    {   
        printf("该文件可写\n");
    }   
    //判断文件是否可执行
    if(0==access("a.txt",X_OK))
    {   
        printf("该文件可执行\n");
    }   
    return 0;
}

结果：	该文件存在
	该文件可读
	该文件可写


1.4 stat/fstat函数（重点）	 get file status
       	#include <sys/types.h>
       	#include <sys/stat.h>
       	#include <unistd.h>
       	int stat(const char *path, struct stat *buf);
       	int fstat(int fd, struct stat *buf);

第一个参数：字符串形式的文件路径名/文件描述符
第二个参数：结构体指针，准备结构体变量取地址作为实参
结构类型如下：
	struct stat {
               dev_t     st_dev;     /* ID of device containing file */
               ino_t     st_ino;     /* inode number */
               mode_t    st_mode;    /* protection */			文件的类型和权限
               nlink_t   st_nlink;   /* number of hard links */
               uid_t     st_uid;     /* user ID of owner */
               gid_t     st_gid;     /* group ID of owner */
               dev_t     st_rdev;    /* device ID (if special file) */
               off_t     st_size;    /* total size, in bytes */重点	总大小,单位：字节
		// typedef long int  off_t 
               blksize_t st_blksize; /* blocksize for file system I/O */
               blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
               time_t    st_atime;   /* time of last access */
               time_t    st_mtime;   /* time of last modification */	最后一次修改时间
		// typedef long int  time_t 
               time_t    st_ctime;   /* time of last status change */
           };


函数功能：
	用于获取指定的文件状态信息，通过第二个参数带出来；

//使用stat函数获取文件的状态信息
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
    //准备结构体变量
    struct stat st={};
    //调用stat函数获取文件a.txt的状态信息
    int res=stat("a.txt",&st);
    if(-1==res)
    {   
        perror("stat"),exit(-1);
    }   
    printf("st.st_mode=%o,st.st_size=%ld,st.st_mtime=%ld\n",st.st_mode,st.st_size,st.st_mtime);
    return 0;                   // typedef long int  off_t      
}

结果：st.st_mode=100664,st.st_size=24,st.st_mtime=1460702413


1.5 ctime函数
 	#include <time.h>
	char *ctime(const time_t *timep);
=>用于将参数指定的整数时间转换为字符串类型时间并返回

	struct tm *localtime(const time_t *timep);
=>用于将参数指定的整数时间转换为结构体指针类型的时间
其中结构体类型如下：
           struct tm {
               int tm_sec;         /* seconds */
               int tm_min;         /* minutes */
               int tm_hour;        /* hours */
               int tm_mday;        /* day of the month */ The number of months since January, in the range 0 to 11.（+1）
               int tm_mon;         /* month */
               int tm_year;        /* year */		The number of years since 1900.（+1900）
               int tm_wday;        /* day of the week */
               int tm_yday;        /* day in the year */
               int tm_isdst;       /* daylight saving time */
           };

//使用stat函数获取文件的状态信息
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<time.h>

int main()
{
	//准备结构体变量
	struct stat st={};
	//调用stat函数获取文件a.txt的状态信息
	int res=stat("a.txt",&st);
	if(-1==res)
	{
		perror("stat"),exit(-1);
	}
	printf("st.st_mode=%o,st.st_size=%ld,st.st_mtime=%ld\n",st.st_mode,st.st_size,st.st_mtime);
	
	if(S_ISREG(st.st_mode))
	{
		printf("普通文件\n");
	}
	if(S_ISDIR(st.st_mode))
	{
		printf("目录文件\n");
	}

/*     The  following  POSIX macros are defined to check the file type using
       the st_mode field:

	   S_ISREG(m)  is it a regular file? (常规文件)

           S_ISDIR(m)  directory?

           S_ISCHR(m)  character device?

           S_ISBLK(m)  block device?

           S_ISFIFO(m) FIFO (named pipe)?

           S_ISLNK(m)  symbolic link? (Not in POSIX.1-1996.)

           S_ISSOCK(m) socket? (Not in POSIX.1-1996.)
*/
	printf("文件的权限是：%o\n",st.st_mode&0777);
	printf("文件的大小是：%ld\n",st.st_size);
	printf("文件最后一次修改时间：%s",ctime(&st.st_mtime));

	struct tm *pt=localtime(&st.st_mtime);
	printf("文件最后修改时间：%d-%d-%d %02d:%02d:%02d\n",pt->tm_year+1900,pt->tm_mon+1,pt->tm_mday,pt->tm_hour,pt->tm_min,pt->tm_sec);
	return 0;
}

结果：	st.st_mode=100664,st.st_size=24,st.st_mtime=1460702413
	普通文件
	文件的权限是：664
	文件的大小是：24
	文件最后一次修改时间：Fri Apr 15 14:40:13 2016
	文件最后修改时间：2016-4-15 14:40:13

获取一个指定文件大小的方式有三种（重点）
1. 使用fseek函数调整文件读写位置到末尾，使用ftell函数
2. 使用lseek函数调整文件读写位置到末尾，返回值就是大小
3. 使用stat/fstat函数获取文件信息，结构体中st_size就是文件的大小信息；

作业：1. 自定义函数generator_id,实现每次执行程序时都可以不断地打印一个自动增长的整数值；
	a.out 100000
	a.out 100001
	a.out 100002
	... ...

//自己写的    之前用的字符数组 麻烦  改用int 正好   不要想的那么复杂 
//文件除了文本文件是用字符写入的可以直接cat 其他文件都是二进制文件 cat是乱码
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	int fd=open("id.txt",O_RDWR|O_CREAT,0664);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}

	int num=0;
	int res=read(fd,&num,4);
	if(res==0)
	{
		num=100000;
		write(fd,&num,4);
		printf("%d\n",num);
	}
	else
	{
		lseek(fd,0,SEEK_SET);
		num++;
		write(fd,&num,4);
		printf("%d\n",num);
	}
/*	char buf[6]={0};
	int res=read(fd,buf,6);
	if(res==0)
	{
		write(fd,"100000",6);
		printf("100000");
	}
	else
	{
		lseek(fd,0,SEEK_SET);
		res=buf[5]+1;
		if(res==':')
		{
			buf[5]='0';
			buf[4]=buf[4]+1;
			//if(buf[4]=='0')
		}
		else
		{
			buf[5]=res;
		}
		write(fd,buf,6);
	}

	printf("%s\n",buf);
*/
	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	return 0;
}


