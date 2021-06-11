关键字：ls -l详解 
	常用的内存管理函数 getpagesize函数 sbrk函数 brk函数 mmap函数 
	文件管理的相关函数（重中之重） open()函数 close()函数 read()函数 
				     write函数 lseek()函数
	
	内存管理技术
	文件的管理

/*常用的内存管理函数*/
1. getpagesize函数    getpagesize - get memory page size
 	#include <unistd.h>
	int getpagesize(void);

函数功能：
	获取当前系统中一个内存页的大小并返回；

2. sbrk函数		change data segment size
 	#include <unistd.h>
	void *sbrk(intptr_t increment);

函数功能：
	主要用于根据参数的数值来调整动态内存的大小，
 具体方式: 当increment >0 时，表示申请动态内存；
		当increment =0 时，表示获取当前动态内存的末尾地址；
		当increment <0 时，表示申请释放动态内存；
	函数调用成功时会返回调整/*之前*/的末尾地址，失败返回(void*)-1;

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main()
{
	void *p1=sbrk(4);
	if((void*)-1==p1)
	{
		perror("sbrk"),exit(-1);
	}
	printf("p1=%p\n",p1);  //p1=0x9393000
	
	void *p2=sbrk(4);
	if((void*)-1==p2)
	{
		perror("sbrk"),exit(-1);
	}
	printf("p2=%p\n",p2);  //p2=0x9393004

	void  *p3=sbrk(4);
	if((void*)-1==p3)
	{
		perror("sbrk"),exit(-1);
	}
	printf("p3=%p\n",p3);  //p3=0x9393008


	void *f4=sbrk(-4);
	printf("f4=%p\n",f4);  //f4=0x939300c

	void *f5=sbrk(-4);
	printf("f5=%p\n",f5);  //f5=0x9393008
	
	void*cur=sbrk(0);
	printf("cur=%p\n",cur);  //cur=0x9393004
	return 0; 
}

结果：	p1=0x9393000
	p2=0x9393004
	p3=0x9393008
	f4=0x939300c
	f5=0x9393008
	cur=0x9393004

注意：
	1. 虽然sbrk函数既能申请动态内存又能释放动态内存，但是申请内存的操作更加方便一些；
	2. 使用sbrk函数申请比较小块的动态内存时，操作系统一次性映射1个内存页大小的地址空间，
	   当sbrk函数申请的动态内存超过1个内存页时，则操作系统会再次映射1个内存页，
	   当sbrk函数释放所有动态内存时，操作系统不会保留映射的地址空间，
	   因此和malloc()和free()函数相比，更加节省内存空间，但是效率低；


3. brk函数 	change data segment size
 	#include <unistd.h>
	int brk(void *addr);

函数功能：
	将动态内存的末尾地址调整到参数指定的位置，
 具体调整方式：
	当addr > 动态内存原来的末尾地址时，表示申请动态内存；
	当addr = 动态内存原来的末尾地址时，表示动态内存不变；
	当addr < 动态内存原来的末尾地址时，表示释放动态内存；

注意：
	虽然brk函数既能申请内存又能释放内存，但是释放内存更加方便，因此一般情况下使用sbrk函数和brk函数搭配使用，
	/*sbrk函数专门用于申请内存，brk函数专门用于释放内存*/；

#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>

int main()
{
	//使用sbrk函数获取一个有效地址
	void *pv=sbrk(0);
	if((void*)-1==pv)
	{
		perror("sbrk"),exit(-1);
	}
	printf("pv=%p\n",pv);
	//使用brk申请4个字节的动态内存
	int res =brk(pv+4);
	if(-1==res)
	{
		perror("brk"),exit(-1);
	}
	//使用sbrk函数获取当前动态内存的末尾地址
	void *cur=sbrk(0);
	printf("cur=%p\n",cur);
	//使用brk函数申请4个字节的动态内存
	res=brk(pv+8);
	cur=sbrk(0);
	printf("cur=%p\n",cur);//pv+8

	//释放完毕所有动态内存
	brk(pv);
	cur=sbrk(0);
	printf("cur=%p\n",cur);//pv
	return 0;
}

结果：	pv=0x891d000
	cur=0x891d004
	cur=0x891d008
	cur=0x891d000


4. mmap函数     map or unmap files or devices into memory
	#include <sys/mman.h>
	void *mmap(void *addr, size_t length, int prot, int flags,int fd, off_t offset);
第一个参数：指定映射的起始地址，给NULL由系统内核指定；
第二个参数：指定映射的大小；
第三个参数：指定映射的操作权限信息
       		PROT_EXEC  Pages may be executed.

      		PROT_READ  Pages may be read.

       		PROT_WRITE Pages may be written.

       		PROT_NONE  Pages may not be accessed.
第四个参数：指定映射的标志位
		MAP_SHARED - 共享的，写入映射区的数据直接反映到文件中
		MAP_PRIVATE - 私有的，写入映射区的数据不会反映到文件中
		MAP_ANONYMOUS - 表示映射到物理内存,忽略参数五和参数六
第五个参数：文件描述符，暂时给0即可；
第六个参数：文件中的偏移量，暂时给0即可；
返回值：成功返回映射区域的首地址，失败返回MAP_FAILED((void*)-1)

函数功能：
	建立文件/设备到虚拟内存之间的映射；

5. munmap函数 		map or unmap files or devices into memory
	#include <sys/mman.h>
	int munmap(void *addr, size_t length);

函数功能：
	解除参数指定的映射，第一个参数为映射区域的首地址，也就是mmap函数的返回值，第二个参数为映射区域的大小；

//建立/解除虚拟地址到真实物理内存的映射
#include<stdio.h>
#include<stdlib.h>
#include<sys/mman.h>

int main()
{
	//1.使用mmap函数建立映射
	void *pv=mmap(NULL,//由系统内核指定起始位置
		4,//映射区域大小
		PROT_READ|PROT_WRITE,//可读可写权限
		MAP_PRIVATE|MAP_ANONYMOUS,//映射物理内存
		0,//文件描述符
		0//文件中偏移量
		);
	if(MAP_FAILED==pv)
	{
		perror("mmap"),exit(-1);
	}
	printf("建立映射成功\n");
	//2.使用映射区域存放数据100，并打印
	int *pi=(int*)pv;
	*pi=100;
	printf("映射区域中的数据是：%d\n",*pi);
	//3.使用munmap函数解除映射
	int res=munmap(pv,4);
	if(-1==res)
	{
		perror("mmap"),exit(-1);
	}
	printf("解除映射成功\n");
	return 0;
}

结果：	建立映射成功
	映射区域中的数据是：100
	解除映射成功


/*内存管理函数之间的层次关系*/
标准C语言 => 使用malloc函数申请内存，使用free函数释放内存

POSIX标准 => 使用sbrk函数申请内存，使用brk函数释放内存

操作系统 => 使用mmap函数建立映射，使用munmap函数解除映射


/*文件管理*/
	在linux系统中，几乎可以把所有的一切都看作文件，包括目录，输入输出设备等；

/dev/null - 空设备文件

如：
	echo 回显命令

	echo hello
      =>输出hello字符串；

	echo hello > a.txt
      =>将输出的字符串hello写入到文件a.txt；

	cat a.txt
      =>显示a.txt内容 hello；

	echo hello > /dev/null
      =>将输出的字符串hello写入到文件/dev/null中，表示丢弃；

	cat /dev/null > a.txt
      =>表示清空文件a.txt中的内容；//把空设备写入文件

/*文件管理的相关函数（重中之重）*/
标C中的文件操作函数：
	fopen()/fclose()/fread()/fwrite()/fseek();

UC中的文件操作函数：
	open()/close()/read()/write()/lseek();

1. open()函数    open and possibly create a file or device
      	#include <sys/types.h>
      	#include <sys/stat.h>
       	#include <fcntl.h>
       	int open(const char *pathname, int flags);
       	int open(const char *pathname, int flags, mode_t mode);

       	int creat(const char *pathname, mode_t mode);

第一个参数：字符串形式的路径名，也就是路径和文件名
第二个参数：具体的操作标志
	     必须包括以下访问权限中的一个：
 		O_RDONLY.  
		O_WRONLY.   
		O_RDWR.
             除此之外，还可以按位或以下的标志：
		O_APPEND - 表示以追加的方式打开文件；
		O_CREAT - If the file does not exist it will be created;
				不存在则创建，存在只打开	
		O_EXCL - 与O_CREAT搭配使用，若不存在则创建，存在则创建失败;/*exclusion*/
		O_TRUNC - 若文件存在则清空文件中的内容;                 /*truncation*/
第三个参数：文件的权限信息
	当创建新文件时，该参数可以用于指定新文件的权限信息，如：0664；
	当打开一个已经存在的文件时，该参数可以忽略，不需要提供；
返回值：成功返回新的文件描述符，失败返回-1；

函数功能：
	打开/创建一个文件；

注意：
	 creat() is equivalent to open() with flags equal to
	O_CREAT|O_WRONLY|O_TRUNC.  （只写情况WRONLY）

/*ls -l详解*/
扩展：	ls -l brk.c
-rw-rw-r-- 1 kevin kevin 635  4月 13 11:32 brk.c

   -       rwx       rw-        r--       1       kevin    kevin    635  
文件类型 属主权限 属组权限 其他用户权限 硬链接数 属主名称 属组名称 文件大小 
	      user     group    other                用户名   同组名
	
  4月 13 11:32    brk.c
最后一个修改时间 文件名称

其中常见的文件类型有：
	- 表示普通规则文件
	d 表示目录文件
其中文件的权限信息有：
	r - 可读 4
	w - 可写 2
	x - 可执行 1
	- - 没有权限


2. close()函数 		close a file descriptor
 	#include <unistd.h>
	int close(int fd);

函数功能：
	关闭参数指定的文件描述符，以至于该描述符不再关联任何一个文件，可以被再次使用；

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main()
{
	//int fd=open("b.txt",O_RDWR|O_CREAT,0664);不存在则创建，存在只打开

	int fd=open("b.txt",O_RDWR|O_CREAT|O_TRUNC,0664);//文件存在则清空
	int fd=open("b.txt",O_RDWR|O_CREAT|O_EXCL,0664);//不存在创建，存在则创建失败
	
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开/创建文件成功\n");
	printf("O_RDWR=%d,O_CREATE=%d,O_TRUNC=%d,O_EXCL=%d\n",O_RDWR,O_CREAT,O_TRUNC,O_EXCL);
	int res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}，
	printf("成功关闭\n");
	return 0;
}

结果：	打开/创建文件成功
	O_RDWR=2,O_CREATE=64,O_TRUNC=512,O_EXCL=128
	成功关闭

3. read()函数	read from a file descriptor
       	#include <unistd.h>
	ssize_t read(int fd, void *buf, size_t count);
第一个参数：文件描述符，open函数的返回值
第二个参数：缓冲区的首地址
第三个参数：期望读取的字节数
返回值：成功返回实际读取到的字节数，0 表示读取到了文件末尾，失败返回-1；
      
函数功能：
	从指定文件中读取数据到指定的缓冲区中；

4. write函数	write to a file descriptor
       	#include <unistd.h>
	ssize_t write(int fd, const void *buf, size_t count);
第一个参数：文件描述符，open函数的返回值
第二个参数：缓冲区的首地址
第三个参数：期望写入的数据大小
返回值：成功返回实际写入的数据大小，返回0表示啥也没有写入，失败返回-1；
函数功能：
	将指定的数据内容写入到指定的文件中；

//写数据到文件
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main()
{   
    //int fd=open("c.txt",O_CREAT|O_WRONLY|O_TRUNC,0664);
    int fd = creat("c.txt",0664);
    if(-1==fd)
    {   
        perror("open"),exit(-1);
    }   
    printf("打开/创建文件成功\n");
    
    int res=write(fd,"hello",6);
    if(-1==res)
    {   
        perror("write"),exit(-1);
    }   
    printf("成功写入数据到文件中，数据大小：%d\n",res);

    res=close(fd);  
    if(-1==res)
    {   
        perror("close"),exit(-1);
    }   
    printf("成功关闭文件\n");
    return 0;
}


//读文件中的数据
#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<unistd.h>

int main()
{
    int fd=open("c.txt",O_RDONLY);
    if(-1==fd)
    {   
        perror("open"),exit(-1);
    }   
    printf("打开文件成功\n");
    char buf[6]={0};
    int res=read(fd,buf,6);
    if(-1==res)
    {   
        perror("read"),exit(-1);
    }   
    printf("数据：%s\n",buf);
    res=close(fd);
    if(-1==res)
    {   
        perror("close"),exit(-1);
    }   
    printf("成功关闭文件\n");
    return 0;
}

5. lseek()函数	reposition read/write file offset
       	#include <sys/types.h>
       	#include <unistd.h>
	off_t lseek(int fd, off_t offset, int whence);
第一个参数：文件描述符，open函数的返回值
第二个参数：偏移量
	正数 - 表示向文件末尾方向偏移
	0 - 表示不偏移
	负数 - 表示向文件开头方向偏移
第三个参数：起始位置
       SEEK_SET
              The offset is set to offset bytes.

       SEEK_CUR
              The offset is set to its current location plus offset bytes.

       SEEK_END
              The offset is set to the size of the file plus offset bytes.
	      向前向后偏移都合理
返回值：成功返回当前位置距离位置开头位置的偏移量，
	失败返回(off_t)-1;

函数功能：
	调整指定文件中的读写位置；

注意：
	当把文件的读写位置调整到SEEK_END后面的位置再写入数据时，数据也是可以写入的，只是中间有一块区域空闲，
	该现象叫做文件的空洞现象，该区域会被计算到文件的大小中，但是没有有效数据，获取内容时得到的是'\0';

扩展：
	如何获取一个文件的大小信息？
1. 使用fseek函数调整文件读写位置到末尾，使用ftell函数返回；
2. 使用lseek函数调整文件读写位置到末尾，返回值就是文件大小；

//使用lseek函数调整文件的读写位置
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	//1.打开文件a.txt，使用open函数
	// 默认读写位置是文件的开头位置
	int fd = open("a.txt",O_RDWR);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("打开文件成功\n");
	//2.调整文件的读写位置，使用lseek函数
	printf("----------------------------------\n");
	char cv;
	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'a'
	
	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'b'
	
	write(fd,"C",sizeof(char)); // 覆盖'c'

	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'd' 指向了'e'

	printf("--------------------------------\n");
	// 实现从文件开头位置向后偏移5个字节
	int len = lseek(fd,5,SEEK_SET);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	printf("len = %d\n",len); //  5
	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'f' 指向'g'

	// 实现从文件开头位置向前偏移3个字节 error
	/*
	len = lseek(fd,-3,SEEK_SET);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	printf("len = %d\n",len); // 执行不到
	*/
	printf("------------------------------\n");
	//从当前位置向后偏移3个字节
	len = lseek(fd,3,SEEK_CUR);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'j' 指向'k'

	//从当前位置向前偏移2个字节
	len = lseek(fd,-2,SEEK_CUR);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	write(fd,"I",sizeof(char)); // 覆盖'i' 指向'j'
	read(fd,&cv,sizeof(char));
	printf("cv = %c\n",cv); // 'j' 指向'k'

	printf("----------------------------------\n");
	//调整读写位置到文件末尾，打印函数返回值
	len = lseek(fd,0,SEEK_END);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	printf("len = %d\n",len); // 文件的大小 15

	//实现从文件末尾位置向前偏移1个字节
	len = lseek(fd,-1,SEEK_END);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	read(fd,&cv,sizeof(char));
	// 'a' 97  'A' 65  '0' 48  '\n' 10
	printf("cv = %c[%d]\n",cv,cv); // '\n' 10

	//实现从文件末尾位置向后偏移3个字节
	len = lseek(fd,3,SEEK_END);
	if(-1 == len)
	{
		perror("lseek"),exit(-1);
	}
	len = write(fd,"hello",5);
	if(-1 == len)
	{
		perror("write"),exit(-1);
	}

	//3.关闭文件a.txt，使用close函数
	int res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}

结果：	打开文件成功
	----------------------------------
	cv = a
	cv = b
	cv = d
	--------------------------------
	len = 5
	cv = f
	------------------------------
	cv = j
	cv = j
	----------------------------------
	len = 15
	cv = 
	[10]
	成功关闭文件


