关键字：
	多线程的基本概念和基本操作
	多线程的同步问题

/*多线程的基本概念和基本操作*/
基本概念
	目前主流的操作系统支持多进程，而每一个进程的内部又可以支持多线程，也就是说线程是隶属于进程内部的程序流，同一个进程中的多个线程并行处理；
	进程是重量级的，每个进程都需要独立的内存空间，因此新建进程对于资源的消耗比较大；
		而线程是轻量级的，新建线程会共享所在进程的内存资源，但是每个线程都拥有一块独立的栈区；


/*1.线程的创建*/
1. pthread_create()函数			create a new thread
       #include <pthread.h>

       int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                          void *(*start_routine) (void *), void *arg);

       Compile and link with -pthread.

	typedef  unsigned long int pthread_t (不同的操作系统中的实现可能会不同)

第一个参数：用于存放新线程的编号；

第二个参数：用于指定线程的属性，给NULL表示采用默认属性；
 
第三个参数：函数指针类型，用于指定新线程的处理函数；

第四个参数：指针类型，用于给第三个参数指向的函数传递实参；

返回值：成功返回0，失败返回具体的错误编号；

函数功能：
	主要用于在当前正在调用的进程中启动一个新线程；



/*2.线程之间的关系*/
	执行main函数的起始线程 叫做 主线程；
	使用pthread_create函数创建出来的新线程 叫做 子线程；
	当子线程创建成功后，两个线程各自独立运行，子线程执行对应的线程处理函数，主线程继续向下执行，
		两个线程之间的执行先后次序由操作系统调用算法决定；
	两个线程之间相互独立，又相互影响，当主线程结束时，会导致整个进程结束，当整个进程结束时，又会导致所有线程结束；

/*3.线程编号的获取和比较*/
1. pthread_self()函数			obtain ID of the calling thread
       #include <pthread.h>

       pthread_t pthread_self(void);

       Compile and link with -pthread.

函数功能：
	主要用于获取当前正在调用线程的编号，并通过返回值返回；

2. pthread_equal()函数			compare thread IDs	
       #include <pthread.h>

       int pthread_equal(pthread_t t1, pthread_t t2);

       Compile and link with -pthread.

函数功能：
	主要用于比较两个参数指定的线程ID是否相等，如果相等则返回非0，如果不相等则返回0；

RETURN VALUE
       If  the  two  thread  IDs  are equal, pthread_equal() returns a nonzero
       value; otherwise, it returns 0.


练习：
	使用pthread_create函数创建一个子线程，在子线程的线程处理函数中根据参数传入的半径计算周长和面积并打印出来，
	而其中存放半径的内存空间由main函数中调用sbrk函数申请，并由用户手动输入；
	vi 02circle.c 

//在线程处理函数中计算圆形的周长和面积
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<pthread.h>

void *task(void *pv)
{
	int ir=*(int*)pv;
	printf("该圆形的周长是：%lf，面积是：%lf\n",2*3.14*ir,3.14*ir*ir);
	return NULL;
}

int main()
{
	//1.申请4个字节的动态内存
	//2.提示用户输入一个整数半径
	//3.创建子线程，并传入半径信息
	//4.释放动态内存

	int *pi=(int*)sbrk(sizeof(int));
	if((int*)-1==pi)
	{
		perror("sbrk"),exit(-1);
	}
//-------------------------------------
	printf("请输入一个整数半径：\n");
	scanf("%d",pi);
//-------------------------------------
	pthread_t tid;
	int errno=pthread_create(&tid,NULL,task,(void*)pi);
	if(0!=errno)
	{
		printf("pthread_create:%s\n",strerror(errno));
		exit(-1);
	}
//----------------------------------------
	//sleep(1);
	//等待子线程结束
	errno=pthread_join(tid,NULL);
	if(0!=errno)
	{
		printf("pthread_join:%s\n",strerror(errno));
		exit(-1);
	}
	errno=brk(pi);
	if(-1==errno)
	{
		perror("brk"),exit(-1);
	}

	return 0;
}


/*4.线程的汇合和分离*/
1. pthread_join()函数			join with a terminated thread
       #include <pthread.h>

       int pthread_join(pthread_t thread, void **retval);

       Compile and link with -pthread.

第一个参数：具体的线程ID

第二个参数：用于获取线程的退出状态信息

函数功能：
	主要用于/*等待参数thread指定的线程终止*/，如果参数thread指向的线程终止了，则该函数立即返回，
		当然要求该线程必须是可汇合的/可等待的；
	如果第二个参数不为空，则该函数会将目标线程的退出状态信息拷贝到/* *retval */指向的位置中，也就是一级指针的内容；

//pthread_join函数等待线程结束，并获取退出状态信息
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<pthread.h>

void *task(void *pv)
{
	char*pc="hello";
	return pc;
}

int main()
{
	//1.创建子线程，使用pthread_create函数
	//2.等待子线程结束，并获取退出状态信息，打印

	pthread_t tid;
	int errno=pthread_create(&tid,NULL,task,NULL);
	if(0!=errno)
	{
		printf("pthread_create:%s\n",strerror(errno)),exit(-1);
	}
//------------------------------------------------
	char *ps=NULL;
	errno=pthread_join(tid,(void**)&ps);
	if(0!=errno)
	{
		printf("pthread_join:%s\n",strerror(errno)),exit(-1);
	}
	printf("主线程中：ps=%s\n",ps);
	return 0;
}

结果：主线程中：ps=hello

练习：
	使用pthread_create函数创建子线程，在线程处理函数中计算1～100之间的和并放在变量sum中，返回sum变量的地址，
		在主线程中调用pthread_join函数等待子线程结束，并获取退出状态信息，打印出来；
	vi 04join.c

//使用pthread_join函数等待子线程结束并获取退出状态
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
#include<string.h>

void *task(void *pv)
{
	int i=0;
	//static int sum=0;
	int sum=0;
	for(i=1;i<=100;i++)
	{
		sum+=i;
	}
	//return &sum;
	return (void*)sum;
}

int main()
{
	//1.创建子线程，使用pthread_create函数
	//2.等待子线程结束，并获取退出状态信息

	pthread_t tid;
	int errno=pthread_create(&tid,NULL,task,NULL);
	if(0!=errno)
	{
		printf("pthread_create:%s\n",strerror(errno)),exit(-1);	
	}
//---------------------------------------------
	//int *pi=NULL;
	//errno=pthread_join(tid,(void**)&pi);
	int res=0;
	errno=pthread_join(tid,(void**)&res);
	if(0!=errno)
	{
		printf("pthread_join:%s\n",strerror(errno)),exit(-1);
	}
	//printf("主线程中：*pi=%d\n",*pi);
	printf("主线程中：res=%d\n",res);
	return 0;
}

结果：主线程中：*pi=5050





2. pthread_detach()函数			detach a thread
       #include <pthread.h>

       int pthread_detach(pthread_t thread);

       Compile and link with -pthread.

函数功能：
	主要用于将参数指定的线程设置为分离状态的线程，
		当一个分离状态的线程终止时，它的资源会被自动释放给系统，不需要其他线程来汇合/帮助，
		也就是分离状态的线程无法被pthread_join函数所等待/汇合；

//使用pthread_detach函数分离状态
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
#include<string.h>

void *task(void *pv)
{
	int i=0;
	//static int sum=0;
	int sum=0;
	for(i=1;i<=100;i++)
	{
		sum+=i;
	}
	//return &sum;
	return (void*)sum;
}

int main()
{
	//1.创建子线程，使用pthread_create函数
	//2.等待子线程结束，并获取退出状态信息

	pthread_t tid;
	int errno=pthread_create(&tid,NULL,task,NULL);
	if(0!=errno)
	{
		printf("pthread_create:%s\n",strerror(errno)),exit(-1);	
	}
//---------------------------------------------
	//设置子线程为分离状态线程
	errno=pthread_detach(tid);
	if(0!=errno)
	{
		printf("pthread_detach:%s\n",strerror(errno)),exit(-1);
	}
//-------------------------------------------------
	//int *pi=NULL;
	//errno=pthread_join(tid,(void**)&pi);
	int res=0;
	errno=pthread_join(tid,(void**)&res);
	if(0!=errno)
	{
		printf("pthread_join:%s\n",strerror(errno)),exit(-1);
	}
	//printf("主线程中：*pi=%d\n",*pi);
	printf("主线程中：res=%d\n",res);
	return 0;
}

结果：pthread_join:Invalid argument




/*5.线程的终止和取消*/
1. pthread_exit()函数			terminate calling thread
       #include <pthread.h>

       void pthread_exit(void *retval);

       Compile and link with -pthread.

函数功能：
	主要用于终止当前正在调用的线程，并通过参数返回当前线程的退出状态信息，
		可以使用同一个进程中的其他线程调用pthread_join函数来获取该退出状态信息；

练习：vi 05exit.c文件，启动子线程，子线程的线程处理函数中负责打印1～20之间的整数，
		每隔一秒打印一次，当i的值为10时，终止当前线程，并返回i的数值，主线程负责等待并获取退出状态信息，最后打印出来

//05exit.c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<pthread.h>

void *task(void *pv)
{
	static int i=0;
	for(i=1;i<=20;i++)
	{
		if(i==10)
		{
			//终止当前线程
			pthread_exit((void*)&i);

			//终止当前进程
			//exit(0);
		}
		printf("子线程中：i=%d\n",i);
		sleep(1);
		
	}
	return NULL;
}

int main()
{
	//1.创建子线程，使用pthread_create函数
	//2.等待

	pthread_t tid;
	int errno=pthread_create(&tid,NULL,task,NULL);
	if(0!=errno)
	{
		printf("pthread_create:%s\n",strerror(errno)),exit(-1);	
	}
//--------------------------------------------
	int *pi=NULL;
	errno=pthread_join(tid,(void**)&pi);
	if(0!=errno)
	{
		printf("pthread_join:%s\n",strerror(errno)),exit(-1);
	}
	printf("主线程中：*pi=%d\n",*pi);
	return 0;
}


结果：	子线程中：i=1
	子线程中：i=2
	子线程中：i=3
	子线程中：i=4
	子线程中：i=5
	子线程中：i=6
	子线程中：i=7
	子线程中：i=8
	子线程中：i=9
	主线程中：*pi=10



2. pthread_cancel()函数			send a cancellation request to a thread
       #include <pthread.h>

       int pthread_cancel(pthread_t thread);

函数功能：
	主要用于给参数指定的线程发送取消的请求，默认情况下是可以被取消的，
		是否被取消以及何时被取消可以通过以下两个函数进行设置：


 pthread_setcancelstate, pthread_setcanceltype - set cancelability state and type

       #include <pthread.h>

       int pthread_setcancelstate(int state, int *oldstate);

第一个参数：用于指定最新的状态
	PTHREAD_CANCEL_ENABLE - 可以被取消（默认状态）
	PTHREAD_CANCEL_DISABLE - 不可被取消

第二个参数：用于带出设置之前的状态信息，给 NULL 表示不带出

函数功能：
	主要用于设置当前线程是否可以被取消

       #include <pthread.h>

       int pthread_setcanceltype(int type, int *oldtype);

第一个参数：用于指定线程的新类型
	PTHREAD_CANCEL_DEFERRED - 延迟取消（默认类型）
	PTHREAD_CANCEL_ASYNCHRONOUS - 立即取消

第二个参数：用于带出旧类型，不想带出给 NULL 即可；

函数功能：
	主要用于设置当前线程何时被取消



/*线程的同步问题*/
基本概念
	多线程之间共享所在进程的资源，当多个线程同时访问同一种共享资源时，需要相互协调，
		以避免造成数据的不一致和不完整问题，而线程之间的协调和通信就叫做线程的同步问题；


/*使用互斥量实现线程的同步*/
1. 定义互斥量
	pthread_mutex_t mutex;
2. 初始化互斥量
	pthread_mutex_init(&mutex,NULL);
3. 使用互斥量进行加锁
	pthread_mutex_lock(&mutex);
4. 访问共享资源
5. 使用互斥量进行解锁
	pthread_mutex_unlock(&mutex);
6. 如果不再使用，则删除互斥量
	pthread_mutex_destroy(&mutex);



//使用互斥量来实现线程的同步问题
#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

//自定义数组作为共享资源
char *buf[5];//指针数组
//自定义变量记录数组的下标
int pos;
//1.定义互斥量
pthread_mutex_t mutex;

void *task(void *pv)
{
	//3,使用互斥量进行加锁
	pthread_mutex_lock(&mutex);
	//4.访问共享资源
	buf[pos]=pv;
	sleep(1);
	pos++;
	//5.使用互斥量进行解锁
	pthread_mutex_unlock(&mutex);
}

int main(void)
{
	//2.初始化互斥量
	pthread_mutex_init(&mutex,NULL);
	//1.创建子线程，使用pthread_create函数
	//2.等待子线程，使用pthread_join函数

	pthread_t tid1;
	pthread_create(&tid1,NULL,task,"zhangfei");

	pthread_t tid2;
	pthread_create(&tid2,NULL,task,"guanyu");
	
	pthread_join(tid1,NULL);
	pthread_join(tid2,NULL);
	
	//打印字符指针数组中的所有字符串内容
	int i=0;
	for(i=0;i<pos;i++)
	{
		printf("%s ",buf[i]);
	}
	printf("\n");

	//6.删除互斥量
	pthread_mutex_destroy(&mutex);
	return 0;
}



/*使用信号量实现线程的同步*/	 
	信号量 - 本质就是一个计数器，用于控制同时访问同一种共享资源的进程/线程个数；
	当信号量的初始值为1时，效果等同于互斥量

#include <semaphore.h>
1. 定义信号量
	sem_t sem;
2. 初始化信号量	initialize an unnamed semaphore
	sem_init(&sem,0,信号量的初始值)

       #include <semaphore.h>

       int sem_init(sem_t *sem, int pshared, unsigned int value);

       Link with -lrt or -pthread.


3. 获取信号量，也就是信号量数值减 1	lock a semaphore
	sem_wait(&sem);
4. 访问共享资源
5. 释放信号量，也就是信号量数值加 1	unlock a semaphore
	sem_post(&sem);
6. 如果不再使用，则删除信号量		destroy an unnamed semaphore
	sem_destroy(&sem);


//使用信号量来实现线程的同步问题
#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#include<semaphore.h>

//自定义数组作为共享资源
char *buf[5];//指针数组
//自定义变量记录数组的下标
int pos;
//1.定义信号量
//pthread_mutex_t mutex;
sem_t sem;

void *task(void *pv)
{
	//3,使用互斥量进行加锁
	//pthread_mutex_lock(&mutex);
	//3.获取信号量
	sem_wait(&sem);

	//4.访问共享资源
	buf[pos]=pv;
	sleep(1);
	pos++;
	//5.使用互斥量进行解锁
	//pthread_mutex_unlock(&mutex);
	//5。释放信号量
	sem_post(&sem);
}

int main(void)
{
	//2.初始化互斥量
	//pthread_mutex_init(&mutex,NULL);
	//2,初始化信号量
	sem_init(&sem,0/*控制线程个数*/,1/*初始值*/);
	//1.创建子线程，使用pthread_create函数
	//2.等待子线程，使用pthread_join函数

	pthread_t tid1;
	pthread_create(&tid1,NULL,task,"zhangfei");

	pthread_t tid2;
	pthread_create(&tid2,NULL,task,"guanyu");
	
	pthread_join(tid1,NULL);
	pthread_join(tid2,NULL);
	
	//打印字符指针数组中的所有字符串内容
	int i=0;
	for(i=0;i<pos;i++)
	{
		printf("%s ",buf[i]);
	}
	printf("\n");

	//6.删除互斥量
	//pthread_mutex_destroy(&mutex);
	//6.删除信号量
	sem_destroy(&sem);
	return 0;
}

