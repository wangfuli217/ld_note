关键字： 使用管道实现进程间的通信		mkfifo()pipe()
	使用共享内存实现进程间的通信	ftok()shmget()shmat()shmdt()shmctl()
	使用消息队列实现进程间的通信	ftok()msgget()msgsnd()msgrcv()msgctl()

	使用信号量集实现进程间的通信

/*进程间的通信技术*/
基本概念
	两个进程之间的信息交互

常用的进程间通信技术
1. 文件
2. 信号
3. 管道（了解）
4. 共享内存
5. 消息队列（重点）
6. 信号量集
7. 网络（重点）
... ...
其中 4 5 6 三种通信方式统称为 XSI IPC通信方式
（X/open System Interface Inter-Process Communication）


/*使用管道实现进程间的通信*/
基本概念
	管道本质上就是文件，只是一种比较特殊的文件
	管道分为两种：有名管道 和 无名管道
	有名管道 - 可以用于任意两个进程间的通信；
	无名管道 - 只能用于父子进程之间的通信；

//使用有名管道实现进程间的通信
	使用mkfifo命令/函数来创建有名管道
如：
	touch a.txt
     => 创建普通文件a.txt
     
	ls -l a.txt
     => 查看文件的详细信息，文件的类型是 - ，表示普通文件

	echo hello > a.txt
     => 将数据hello写入到文件a.txt，结果是可以写入

 	cat a.txt
     => 查看文件中的内容，为hello，并且文件大小也改变了

	mkfifo a.pipe
     => 创建管道文件a.pipe

	ls -l a.pipe
     => 文件的类型是 P，表示管道文件，并且拥有黑色阴影 （黑色阴影表示这个文件不可用）
	
	echo hello > a.pipe
     => 写入数据到hello到文件a.pipe中，写入是阻塞的，写不进去
	另起终端执行命令：cat a.pipe
     => 此时读取到内容hello，另外一个终端的阻塞解除

注意：
	管道的特殊性就在于仅仅作为进程间通信的媒介，但是管道本身并不会存在任何数据；

1. mkfifo()函数		make a FIFO special file (a named pipe)
       #include <sys/types.h>
       #include <sys/stat.h>

       int mkfifo(const char *pathname, mode_t mode);

第一个参数：字符串形式的路径名
第二个参数：具体的权限信息，如：0664

函数功能：
	用于创建一个指定有名管道文件；


//使用有名管道实现进程间的通信 写操作
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main()
{
	//1.打开管道文件，使用open函数
	int fd =open("b.pipe",O_WRONLY);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}

	//2.分别写入1-100之间的数据到管道文件中
	int i=0;
	for(i=1;i<=100;i++)
	{
		int res=write(fd,&i,sizeof(int));
		if(-1==res)
		{
			perror("write"),exit(-1);
		}
	}
	printf("写入数据成功\n");

	//3.关闭管道文件，使用close函数
	int res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	return 0;
}



//使用有名管道读有名管道 读操作
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>

int main()
{
	int fd=open("b.pipe",O_RDONLY);
	if(-1==fd)
	{
		perror("open"),exit(-1);
	}

	int i=0;
	for(i=1;i<=100;i++) 
	{
		int temp=0;
		int res=read(fd,&temp,sizeof(int));
		if(-1==res)
		{
			perror("read"),exit(-1);
		}
		printf("%d ",temp);
	}
	printf("\n");
	printf("读取完毕\n");

	int res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}

	return 0;
}





//使用无名管道实现进程间的通信
pipe()函数			create pipe
       #include <unistd.h>

       int pipe(int pipefd[2]);

函数功能：
	用于创建无名管道，提供一个单向的数据通道实现进程间的通信，通过参数带出两个文件描述符，
	其中pipefd[0]代表管道的读端，其中pipefd[1]代表管道的写端；


//使用无名管道实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main()
{
	int pipefd[2];
	//1.创建无名管道，使用pipe函数
	int res =pipe(pipefd);
	if(-1==res)
	{
		perror("pipe"),exit(-1);
	}
	printf("创建无名管道成功\n");
	//2.创建子进程，使用fork函数
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}

	//3.子进程开始执行，写入1～100之间的整数
	if(0==pid)
	{
		printf("子进程%d开始执行\n",getpid());
		printf("子1\n");
		printf("子2\n");
		printf("子3\n");
		//先关闭子进程的读端
		close(pipefd[0]);
		//使用循环将1-100之间的整数写入
		int i=0;
		for(i=1;i<=100;i++)
		{
			write(pipefd[1],&i,sizeof(int));
		}
		//关闭写端
		close(pipefd[1]);
		printf("子进程结束\n");
		//终止子进程
		exit(0);
	
	}

	//4. 父进程开始执行，读取管道中的数据打印
	printf("父进程%d开始执行\n",getpid());
	printf("父1\n");
	printf("父2\n");
	printf("父3\n");
	close(pipefd[1]);//关闭写端
	int i =0;
	printf("父进程中读取到的数据有：");
	for(i=1;i<=100;i++)
	{
		int temp=0;
		read(pipefd[0],&temp,sizeof(int));
		printf("%d ",temp);
	}
	printf("\n");
	//关闭读端
	close(pipefd[0]);
	printf("父进程结束\n");
	exit(0);
	return 0;
}




结果：
创建无名管道成功
父进程7047开始执行
父1
父2
父3
子进程7048开始执行
子1
子2
子3
子进程结束
父进程中读取到的数据有：1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 
父进程结束



/*使用共享内存实现进程间的通信*/
基本概念
	共享内存本质就是一块由系统内核维护的内存空间，而该内存空间可以共享在两个进程之间，两个进程通过读写该内存区域从而实现通信；
   最快的IPC通信方式；	


//通信模型
1. 获取key值，使用ftok函数；
2. 创建/获取共享内存，使用shmget函数；
3. 挂接共享内存，使用shmat函数；（建立通道）
4. 使用共享内存；
5. 脱接共享内存，使用shmdt函数；（删除通道）
6. 如果不再使用，则删除共享内存，使用shmctl函数；


相关函数解析
1. ftok()函数	convert a pathname and a project identifier to a System V IPC key
       #include <sys/types.h>
       #include <sys/ipc.h>

       key_t ftok(const char *pathname, int proj_id);

第一个参数：字符串形式的路径名，要求文件存在并且可以访问；
第二个参数：项目的编号，要求非0，只取低8位二进制位
返回值：成功返回key_t类型的key值，失败返回-1；

函数功能：
	根据参数的指定来生成一个key值，便于后续函数使用

注意：
	使用相同的路径名和相同的项目编号时，最终生成的key值也相同


2. shmget()函数		allocates a shared memory segment
       #include <sys/ipc.h>
       #include <sys/shm.h>

       int shmget(key_t key, size_t size, int shmflg);

第一个参数：key值，ftok函数的返回值

第二个参数：具体的共享内存大小
	0 - 获取已经存在的共享内存

第三个参数：具体的操作标志
	IPC_CREAT - 如果不存在则创建，存在则打开 
	IPC_EXCL - 与IPC_CREAT搭配使用，如果存在则创建失败
	0 - 获取已经存在的共享内存

返回值：成功返回共享内存的ID，失败返回-1；

函数功能：
	用于创建/获取一个指定的共享内存；

注意：
	当使用该函数创建新的共享内存时，需要在第三个参数中指定该共享内存的权限信息，如：0664，指定的方式为按位或运算；


3. shmat()函数	//attaches		shared memory operations	
       #include <sys/types.h>
       #include <sys/shm.h>

       void *shmat(int shmid, const void *shmaddr, int shmflg);

第一个参数：共享内存的ID，shmget函数的返回值

第二个参数：具体的挂接地址，给 NULL 则由系统选择位置

第三个参数：挂接的标志，默认给0即可

返回值：成功返回挂接的起始地址，失败返回(void*)-1;

函数功能：
	将shmid指向的共享内存挂接到当前进程的地址空间中


4. shmdt()函数 //detaches			shared memory operations  
       #include <sys/types.h>
       #include <sys/shm.h>

       int shmdt(const void *shmaddr);	

函数功能：
	脱接参数指定的共享内存，参数为shmat函数的返回值


5. shmctl()函数 	shared memory control	
       #include <sys/ipc.h>
       #include <sys/shm.h>

       int shmctl(int shmid, int cmd, struct shmid_ds *buf);
第一个参数：共享内存的ID，shmget函数的返回值

第二个参数：具体的操作命令
   	IPC_RMID - 删除共享内存，此时第三个参数给NULL即可

第三个参数：结构体指针

函数功能：
   主要用于对指定的共享内存段执行指定的操作；





常用的基本命令
	ipcs -m   		表示查看当前系统中存在的共享内存段； -m指memory
	ipcrm -m 共享内存的ID	表示删除指定的共享内存；


//使用共享内存实现进程间的通信
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <signal.h>

//定义全局变量记录共享内存的编号
int shmid;

void fa(int signo)
{
	printf("正在删除共享内存，请稍后...\n");
	sleep(3);
	//调用shmctl函数实现真正的删除
	int res = shmctl(shmid,IPC_RMID,NULL);
	if(-1 == res)
	{
		perror("shmctl"),exit(-1);
	}
	printf("删除共享内存成功\n");
	exit(0); //终止当前进程
	//练习：vi 03shmB.c文件，打印共享内存中的数据
}

int main(void)
{
	//1.获取key值，使用ftok函数
	key_t key = ftok(".",100);
	if(-1 == key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key = %#x\n",key); 
	//2.创建共享内存，使用shmget函数
	shmid = shmget(key,4/*大小*/,IPC_CREAT|IPC_EXCL|0664);
	if(-1 == shmid)
	{
		perror("shmget"),exit(-1);
	}
	printf("shmid = %d\n",shmid);
	//3.挂接共享内存，使用shmat函数
	void* pv = shmat(shmid,NULL,0);
	if((void*)-1 == pv)
	{
		perror("shmat"),exit(-1);
	}
	printf("挂接共享内存成功\n");
	//4.使用共享内存
	//*(int*)pv = 200;
	int* pi = pv;
	*pi = 200;
	//5.脱接共享内存，使用shmdt函数
	int res = shmdt(pv);
	if(-1 == res)
	{
		perror("shmdt"),exit(-1);
	}
	printf("脱接共享内存成功\n");
	//6.如果不再使用，则删除共享内存
	printf("删除共享内存请按ctrl+c...\n");
	if(SIG_ERR == signal(SIGINT,fa))
	{
		perror("signal"),exit(-1);
	}
	while(1);
	return 0;
}





练习：vi shmB.c 文件  打印共享内存中的数据

//使用共享内存实现进程间的通信
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int main(void)
{
	//1.获取key值，使用ftok函数
	key_t key = ftok(".",100);
	if(-1 == key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key = %#x\n",key);
	//2.获取共享内存，使用shmget函数
	int shmid = shmget(key,0,0);
	if(-1 == shmid)
	{
		perror("shmget"),exit(-1);
	}
	printf("shmid = %d\n",shmid);
	//3.挂接共享内存，使用shmat函数
	void* pv = shmat(shmid,NULL,0);
	if((void*)-1 == pv)
	{
		perror("shmat"),exit(-1);
	}
	printf("挂接共享内存成功\n");
	//4.访问共享内存，打印数据
	int* pi = pv;
	printf("共享内存中的数据是：%d\n",*pi);// 200
	//5.脱接共享内存，使用shmdt函数
	int res = shmdt(pv);
	if(-1 == res)
	{
		perror("shmdt"),exit(-1);
	}
	printf("脱接共享内存成功\n");
	return 0;
}






/*使用消息队列实现进程间的通信*（重点）*/
基本概念
	将通信的数据打包成消息，使用两个不同的进程分别发送消息到消息队列中 和 接收消息队列中的消息，从而实现通信；


/*通信的模型*/
1. 获取key值，使用ftok函数；
2. 创建/获取消息队列，使用msgget函数；
3. 发送消息到消息队列中/接收消息队列中的消息，使用msgsnd/msgrcv函数；
4. 如果不再使用，删除消息队列，使用msgctl函数；


/*相关函数的解析*/
1. msgget()函数			get a message queue identifier
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/msg.h>

       int msgget(key_t key, int msgflg);

第一个参数：key值，ftok函数的返回值
第二个参数：具体的操作标志
	IPC_CREAT - 如果不存在则创建，存在则打开
	IPC_EXCL - 与IPC_CREAT搭配使用，如果存在则创建失败
	0 - 获取已经存在的消息队列
	当创建新的消息队列时，需要在第二个参数中指定权限信息，如：0664，指定方式为按位或运算；

返回值：成功返回消息队列的ID，失败返回-1；

函数功能：
	创建/获取消息队列；

注意：
	当创建新的消息队列时，需要在第二个参数中指定权限信息，如：0664，指定方式为按位或运算；


2. msgsnd()函数	send		message operations
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/msg.h>

       int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg);

第一个参数：消息队列的ID，msgget函数的返回值

第二个参数：消息的起始地址，该指针指向的消息格式如下:

           struct msgbuf {
               long mtype;       /* message type, must be > 0 */  //消息的类型
               char mtext[1];    /* message data */  //消息的内容，可以选择其他数据类型
	// The  mtext  field is an array (or other structure)
           };


第三个参数：消息的大小
	该参数的大小仅仅包括/*消息内容的大小*/，不包括消息类型的大小

第四个参数：发送的标志，默认给0即可，表示发送不出去时阻塞
	IPC_NOWAIT - 表示发送不出去时，不会产生阻塞

函数功能：
	向指定的消息队列中发送指定的消息；



3. msgrcv()函数  receive		message operations
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/msg.h>

       ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg);

第一个参数：消息队列的ID，msgget函数的返回值

第二个参数：存放消息的缓冲区首地址

第三个参数：期望接收的消息大小

第四个参数：期望接收的消息类型
	0 - 表示始终读取消息队列中的第一个消息；	
       >0 - 表示始终读取消息队列中第一个类型为msgtyp的消息；
       <0 - 表示读取消息队列中第一个类型<=msgtyp绝对值的消息，其中最小类型的消息优先读取；

第五个参数：具体的接受标志，默认给0即可

返回值：成功返回实际读取的数据大小，失败返回-1；

函数功能：
	从指定的消息队列中接收消息，并放在指定的缓冲区中



4 msgctl()函数			message control operations
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/msg.h>

       int msgctl(int msqid, int cmd, struct msqid_ds *buf);

第一个参数：消息队列的ID，msgget函数的返回值

第二个参数：具体的操作命令
	IPC_RMID - 删除消息队列，此时第三个参数给 NULL 即可

第三个参数：结构体指针

函数功能：
	操作参数指定的消息队列；



常用的基本命令
	ipcs -q  		表示查看系统中已经存在的消息队列
	ipcrm -q 消息队列的ID	表示删除指定的消息队列


//使用消息队列实现进程间的通信  写消息进队列
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/msg.h>
#include<signal.h>

//定义消息的数据类型
typedef struct{
	long mtype;//消息的类型
	char buf[20];//消息的内容
}Msg;

int msqid;

void fa(int signo)
{
	printf("正在删除消息队列，请稍后...\n");
	sleep(3);
	int res=msgctl(msqid,IPC_RMID,NULL);
	if(-1==res)
	{
		perror("msgctl"),exit(-1);
	}
	printf("删除消息队列成功\n");
	exit(0);
}

int main()
{
	//1.获取key值，使用ftok函数
	//2.创建消息队列，使用msgget函数
	//3.准备消息，发送到消息队列中，用msgsnd函数
	//4.如果不再使用，则删除消息队列

	key_t key=ftok(".",150);
	if(-1==key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key=%#x\n",key);
//---------------------------------------------
	msqid=msgget(key,IPC_CREAT|IPC_EXCL|0664);
	if(-1==msqid)
	{
		perror("msgget"),exit(-1);
	}
	printf("misqid=%d\n",msqid);
//------------------------------------------------------
	Msg msg1={1,"hello"};
	Msg msg2={2,"world"};
	int res=msgsnd(msqid,&msg2,sizeof(msg2.buf),0);
	if(-1==res)
	{
		perror("msgsnd"),exit(-1);
	}
	printf("发送类型为2的消息成功\n");
	res=msgsnd(msqid,&msg1,sizeof(msg1.buf),0);
	if(-1==res)
	{
		perror("msgsnd"),exit(-1);
	}
	printf("发送类型为1的消息成功\n");
//-----------------------------------------------------------
	printf("删除消息队列请按ctrl+c...\n");
	if(SIG_ERR==signal(2,fa))
	{
		perror("signal"),exit(-1);
	}
	while(1);
	return 0;
}


//使用消息队列进行进程间的通信  读队列里的消息
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/msg.h>

//定义消息的数据类型
typedef struct{
	long mtype;//消息类型
	char buf[20];//消息大小
}Msg;

int main()
{
	//1.获取key值，使用ftok函数
	//2.获取消息队列的ID,使用msgget函数
	//3.接收消息队列中第一个消息，使用msgrcv函数

	key_t key=ftok(".",150);
	if(-1==key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key=%d\n",key);
//----------------------------------------
	int msqid=msgget(key,0);
	if(-1==msqid)
	{
		perror("msgget"),exit(-1);
	}
	printf("msqid=%d\n",msqid);
//-----------------------------------------
	Msg msg={};

	//始终读取消息队列中的第一个消息
	//int sizeq=msgrcv(msqid,&msg,sizeof(msg.buf),0,0);

	//始终接收类型为1的消息

	//int sizeq=msgrcv(msqid,&msg,sizeof(msg.buf),1,0);
	//接收类型为<=2的消息，最小的消息优先接收

	int sizeq=msgrcv(msqid,&msg,sizeof(msg.buf),-2,0);
	if(-1==sizeq)
	{
		perror("msgrcv"),exit(-1);
	}
	printf("实际读取的数据大小为：%d\n",sizeq);
	printf("数据内容：%s\n",msg.buf);

	
	return 0;
}

