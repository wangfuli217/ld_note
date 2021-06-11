关键字：
	使用信号量集实现进程间的通信  ftok()semget()semctl()semop()
	综合小项目

/*使用信号量集实现进程间的通信*/
基本概念
	信号量：本质是一种计数器，主要用于控制同时访问同一个共享资源的进程/线程个数；

	信号量集：本质是信号量的集合，主要用于控制多种共享资源分别被同时访问的进程/线程个数;

信号量的工作方式
1. 初始化信号量为最大值；
2. 如果有进程申请到了一个共享资源，则信号量的数值减1；
3. 当信号量的数值为0时，申请共享资源的进程进入阻塞状态；
4. 如果有进程释放了一个共享资源，则信号量的数值加1；
5. 当信号量的数值>0时，等待申请共享资源的进程可以继续抢占共享资源，抢不到共享资源的进程继续阻塞；


/*使用信号量集实现进程间通信的模型*/
1. 获取key值，使用ftok函数；
2. 创建/获取信号量集，使用semget函数；
3. 初始化信号量集，使用semctl函数；
4. 操作信号量集控制进程/线程的个数，使用semop函数；
5. 如果不再使用，则删除信号量集，使用semctl函数；

/*相关函数的解析*/
1. semget()函数			get a semaphore set identifier
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/sem.h>

       int semget(key_t key, int nsems, int semflg);

第一个参数：key值，ftok函数的返回值；

第二个参数：信号量集的大小，也就是信号量的个数；

第三个参数：具体的操作标志
	IPC_CREAT - 如果不存在则创建，存在则打开
	IPC_EXCL - 与IPC_CREAT搭配使用，若存在则创建失败
	0 - 获取已经存在的信号量集
	指定权限信息，如：0664，指定方式为按位或

返回值：成功返回信号量集的ID，失败返回-1

函数功能：
	用于创建/获取信号量集；

注意：
	当创建新的信号量集时，需要指定权限信息，如：0664，指定方式为按位或在第三个参数中


2. semctl()函数			semaphore control operations
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/sem.h>

       int semctl(int semid, int semnum, int cmd, ...);

第一个参数：信号量集的ID，semget函数的返回值

第二个参数：信号量集的下标，从0开始

第三个参数：具体的操作命令
	IPC_RMID - 删除整个信号量集，忽略参数semnum，不需要第四个参数
	SETVAL - 使用第四个参数的值来初始化下标为semnum的信号量（初始化一个信号量）

第四个参数：可变长参数，是否需要取决于cmd

函数功能：
	用于对指定的信号量集执行指定的操作；


3. semop()函数			semaphore operations
       #include <sys/types.h>
       #include <sys/ipc.h>
       #include <sys/sem.h>

       int semop(int semid, struct sembuf *sops, unsigned nsops);

第一个参数：信号量集的ID，semget函数的返回值

第二个参数：结构体指针，可以指向结构体变量，也可以指向数组

	struct sembuf{
	   unsigned short sem_num;  /* semaphore number */	//信号量集的下标
           short          sem_op;   /* semaphore operation */	//具体操作，正数增加 负数减少 0不变
           short          sem_flg;  /* operation flags */	//操作的标志，默认给0
	}

第三个参数：当结构体指针指向数组时，该参数表示数组元素个数

函数功能：
	用于操作指定的信号量；


常用的基本命令
	ipcs -s  		表示查看系统中已经存在的信号量集
	ipcs -a  		表示查看系统中所有的ipc结构，包括共享内存，消息队列，信号量集
	ipcrm -s 信号量集的ID	表示删除指定的信号量集

//semA.c
//使用信号量集实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/sem.h>
#include<signal.h>

int semid;

void fa(int signo)
{
	printf("正在准备删除信号量集，请稍后...\n");
	sleep(3);
	int res=semctl(semid,0,IPC_RMID);
	if(-1==res)
	{
		perror("semctl"),exit(-1);
	}
	printf("成功删除信号量集\n");
	exit(0);
}

int main()
{
	//1.获取key值，使用ftok函数
	//2.创建信号量集，使用semget函数
	//3.初始化信号量集，使用semctl函数
	//4.如果不再使用，则删除信号量集，使用semctl函数

	key_t key=ftok(".",200);
	if(-1==key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key=%#x\n",key);
//-----------------------------
	semid=semget(key,1/*信号量集的大小*/,IPC_CREAT|IPC_EXCL|0664);
	if(-1==semid)
	{
		perror("semget"),exit(-1);
	}
//------------------------------
	int res=semctl(semid,0/*信号量集的下标*/,SETVAL,5/*信号量初始值*/);
	if(-1==res)
	{
		perror("semctl"),exit(-1);
	}
	printf("初始化信号量集成功\n");
//---------------------------------
	printf("删除信号量集请按ctrl+c...\n");
	if(SIG_ERR==signal(2,fa))
	{
		perror("signal"),exit(-1);
	}
	while(1);
	return 0;
}


//semB.c
//使用信号量集实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/sem.h>

int main()
{
	//1.获取key值，使用ftok函数
	//2.获取信号量集，使用semget函数
	//3.操作信号量集控制进程个数，使用semop函数

	key_t key=ftok(".",200);
	if(-1==key)
	{
		perror("ftok"),exit(-1);
	}
	printf("key=%#x\n",key);
//-----------------------------------
	int semid=semget(key,0,0);
	if(-1==semid)
	{
		perror("semget"),exit(-1);
	}
	printf("semid=%d\n",semid);
//------------------------------------
	int i=0;
	for(i=0;i<10;i++)
	{
		//创建子进程，调用fork函数
		pid_t pid=fork();
		if(-1==pid)
		{
			perror("fork"),exit(-1);
		}
		//子进程模拟抢占资源的过程
		if(0==pid)
		{	
			//准备结构体变量初始化
			struct sembuf buf={};
			buf.sem_num=0;//信号量集的下标
			buf.sem_op=-1;//信号量数值减1
			buf.sem_flg=0;//操作的标志
		
			//信号量的数值减1，使用semop函数
			int res=semop(semid,&buf,1/*结构体变量的个数*/);
			if(-1==res)
			{
				perror("semop"),exit(-1);
			}
			printf("进程%d申请共享资源成功\n",getpid());
	
			//模拟占用共享资源20秒
			sleep(20);
		
			//模拟释放共享资源
			buf.sem_op=1;
			res=semop(semid,&buf,1);
			if(-1==res)
			{
				perror("semop"),exit(-1);
			}
			printf("释放共享资源\n");\
			
			//终止子进程
			exit(0);
		}
	}
	return 0;
}


结果：
key=0xc80820c9
semid=131072
[tarena@~/UNIX/sig]$进程5872申请共享资源成功
进程5873申请共享资源成功
进程5871申请共享资源成功
进程5874申请共享资源成功
进程5875申请共享资源成功
释放共享资源
释放共享资源
释放共享资源
释放共享资源
释放共享资源
进程5870申请共享资源成功
进程5869申请共享资源成功
进程5868申请共享资源成功
进程5867申请共享资源成功
进程5866申请共享资源成功
释放共享资源
释放共享资源
释放共享资源
释放共享资源
释放共享资源



/*综合小项目*/
项目的名称
	银行账户管理系统（模拟ATM）

项目的功能
	开户，销户，存款，取款，查询，转账

项目的架构
	采用C（Client）/S（Server）架构进行设计

客户端：
	提供界面让用户选择具体的业务，将用户选择的业务编号发送给服务器进行处理，等待服务器的处理结果并显示给客户；	

服务端：
	根据客户端传来的业务编号，通过访问数据库的方式进行处理，并将最终的处理结果发送给客户端即可；

项目的设计和分析
	1. 如何实现客户端和服务器之间的通信？
		采用两个消息队列实现进程间的通信：
			消息队列一：客户端 => 服务器
			消息队列二：服务器 => 客户段

	2. 如何区分不同的业务编号？
		采用消息类型来区分不同的业务编号，需要8种类型：
			6种业务编号 + 成功 + 失败 

	3. 如何设计账户和消息的类型？
		账户信息：账户，账户名称，账户密码，余额；
		采用结构体类型来设计账户和消息的数据类型
		使用账户信息的结构体变量作为消息的数据内容；

	4. 以开户为例分析项目的执行流程
		客户端：
			1. 绘制字符界面，供用户选择具体的业务编号；
			   => printf函数打印即可
			2. 根据用户的选择，进入不同的业务分支进行处理
			   => 使用scanf函数接收用户的输入
			   => 使用switch-case结构进入不同的分支
			3. 提示用户输入开户的信息，不需要输入账号信息
			   => 使用结构体变量来保存用户的输入
			4. 打包用户输入的信息到消息的结构体变量中，发送给服务器
			   => 设置消息的类型为1，代表开户业务
			   => 使用msgsnd函数将消息发送到消息队列一中
			5. 接收消息队列二中的消息，并显示处理结果
			   => 使用msgrcv函数接收消息
			   => 如果消息的类型为7，则表示处理成功
			   => 如果消息的类型为8，则表示处理失败
		服务器：
			1. 创建两个消息队列，作为服务区的初始化工作
			   => 使用ftok函数生成key值
			   => 使用msgget函数创建
			2. 接收客户端发来的消息，根据业务编号进行处理；
		   	   => 使用msgrcv函数接收消息队列一中的消息
			   => 判断消息类型是否为1，若是则表示开户业务
			3. 自动生成一个帐号，补充完整账户信息；
			   => 调用generator_id函数自动生成帐号
			4. 保存账户信息到文件中，并判断是否保存成功
			   => 每个账户信息都保存在一个独立的文件中 
			   => 采用帐号作为文件名来确保唯一性，使用sprintf函数
			5. 根据处理结果修改消息的类型，并发给客户端
			   => 如果处理成功，则修改消息的类型为 7
			   => 如果处理失败，则修改消息的类型为 8
			   => 使用msgsnd函数将消息发送到消息队列二中
			6. 要求服务器不断的运行，直到按下ctrl+c才能关闭服务器
			   => 使用无限循环保证服务器不停的工作
			   => 使用signal函数对信号SIGINT进行自定义处理
			   => 通过信号处理机制来删除两个消息队列，使用msgctl函数

项目的要求
	1. 要求采用多函数多文件的方式编码，并支持Makefile文件
	2. 要求实现开户功能即可，实现所有功能

项目的提示
 vi bank.h - 编写结构体的定义等公共代码
 vi client.c - 编写客户端的功能代码，打印界面的函数等
 vi server.c - 编写服务器的功能代码，创建消息队列的函数等
 vi dao.c - 编写自动生成帐号的函数代码等



全局变量 extern int msqid;

typedef struct{
	char name[20];//账户名称
	int pw;//账户密码 
	float balance; //余额
}usr_print;

生成ID 将ID号作为文件名 打开 将用户输入的信息 输入到文件中



void client_screen(void) - 屏幕显示函数
void client_choose(void) - 选择操作选项
void open_an_account(void);- 开户
cancel()


