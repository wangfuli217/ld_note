关键字：进程的管理：fork  _exit()/_Exit()  exit()  atexit()/on_exit  wait()/waitpid()
			vfork()  exec系列函数  execl()  system()
 

3. 进程的创建
 1. fork函数 create a child process
       	#include <unistd.h>
	pid_t fork(void);

函数功能：
	/*复制*/当前正在调用进程的方式来启动一个新进程，而其中新启动的进程叫做子进程，原来的进程叫做父进程，
		函数调用成功时/*父进程返回子进程的进程号，子进程返回0*/，函数调用失败时直接返回-1，没有子进程被创建；

注意：
	父,子进程的执行次序由操作系统的调度算法决定；

（1）父子进程的执行关系
	1. 对于fork函数之前的代码，父进程执行一次；
	2. 对于fork函数之后的代码，父子进程各自执行一次；
	3. fork函数的返回值由父子进程各自返回一次；

（2）父子进程之间的关系
	1. 父进程启动了子进程，父子进程同时启动，如果子进程先于父进程结束，则会给父进程发送信号，由父进程负责回收子进程资源；
	2. 如果父进程先于子进程结束，则子进程变成孤儿进程，子进程会变更父进程（一般重新设定init(1)为新的父进程），
		init进程收养了孤儿进程，所以init叫做孤儿院；
	3. 如果子进程先于父进程结束，但是父进程由于各种原因没有接收到子进程发来的信号，也就是没有回收子进程的资源，
		但是子进程已经结束了，因此子进程变成了僵尸进程；


//使用fork函数创建子进程  孤儿进程
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main()
{
	printf("main函数开始执行\n");
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	printf("main函数结束%d\n",pid);

	if(0==pid)
	{
		printf("我是子进程，我的进程号是：%d,我的父进程是：%d\n",getpid(),getppid());
		sleep(3);
		printf("我是子进程，我的进程号是：%d,我的父进程是：%d\n",getpid(),getppid());
	}
	else//父进程
	{
		sleep(1);
		printf("我是父进程，我的进程号：%d,我的子进程是：%d\n",getpid(),pid);
	}
	return 0;
}
结果：	main函数开始执行
	main函数结束6018
	main函数结束0
	我是子进程，我的进程号是：6018,我的父进程是：6017
	我是父进程，我的进程号：6017,我的子进程是：6018
	[tarena@~/UNIX]$我是子进程，我的进程号是：6018,我的父进程是：1


//使用fork函数创建子进程  不加sleep的后果
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main()
{
	printf("main函数开始执行\n");
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	printf("main函数结束%d\n",pid);

	if(0==pid)
	{
		printf("我是子进程，我的进程号是：%d,我的父进程是：%d\n",getpid(),getppid());
	}
	else//父进程
	{
、		//sleep(1);
		printf("我是父进程，我的进程号：%d,我的子进程是：%d\n",getpid(),pid);
	}
	return 0;
}

结果：	main函数开始执行
	main函数结束6084
	我是父进程，我的进程号：6083,我的子进程是：6084
	main函数结束0
	我是子进程，我的进程号是：6084,我的父进程是：1



（3）父子进程的复制(内存)关系
	使用fork函数创建子进程后，子进程会/*复制父进程中除了代码区之外的其他内存区域*/，而代码区和父进程共享；
	使用fork函数创建子进程后，子进程会复制父进程中的文件描述符总表，但是不会复制文件表结构，
		使得/*父子进程中的文件描述符对应同一个文件表结构*/；


////观察父子进程之间的内存关系
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/types.h>

int i1=1;//全局变量 全局区

int main()
{
	int i2=1;//局部变量 栈区
	//pc指向堆区 pc本身在栈区
	char *pc=(char*)malloc(sizeof(char)*10);
	strcpy(pc,"hello");

	//使用fork函数创建子进程
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	//子进程
	if(0==pid)
	{
		i1=2;
		i2=2;
		strcpy(pc,"world");
		printf("子进程中:i1=%d,i2=%d,pc=%s\n",i1,i2,pc);
		exit(0);
	}
	//下面代码肯定由父进程进行
	sleep(1);
	printf("父进程中：i1=%d,i2=%d,pc=%s\n",i1,i2,pc);
	return 0;
}

结果：	子进程中:i1=2,i2=2,pc=world
	父进程中：i1=1,i2=1,pc=hello


练习：
	使用open函数创建一个文件a.txt,使用fork函数创建子进程，分别使用父进程和子进程向文件a.txt中分别写入数据“hello”和“world”，最后关闭文件；

//没有深刻的理解 复制 的含义 以及复制后带来的结果    共享代码区
////观察父子进程之间对文件描述符的处理
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	//1.创建/打开文件a.txt，使用open函数
	int fd = open("a.txt",O_WRONLY|O_CREAT|O_TRUNC,0664);
	if(-1 == fd)
	{
		perror("open"),exit(-1);
	}
	printf("创建/打开文件成功\n");
	//2.创建子进程，使用fork函数
	pid_t pid = fork();
	if(-1 == pid)
	{
		perror("fork"),exit(-1);
	}
	//3.分别使用父子进程向文件中写入数据
	// 子进程
	if(0 == pid)
	{
		int res = write(fd,"world",5);
		if(-1 == res)
		{
			perror("write"),exit(-1);
		}
		res = close(fd);
		if(-1 == res)
		{
			perror("write"),exit(-1);
		}
		exit(0); //终止子进程
	}
	//父进程
	sleep(1);
	int res = write(fd,"hello",5);
	if(-1 == res)
	{
		perror("write"),exit(-1);
	}
	//4.关闭文件a.txt，使用close函数
	res = close(fd);
	if(-1 == res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭文件\n");
	return 0;
}

结果:文件内容：worldhello  (注意文件指针)  

		/*父子进程中的文件描述符对应同一个文件表结构*/





（4）扩展
	1. 如何创建3个进程一共4个进程？
		fork();
		fork();
	  4个进程：1个父进程 + 2个子进程 + 1个孙子进程
		//一个父进程 一个子进程 -> 一个子进程 一个孙子进程

	2. 如果创建2个进程一个共3个进程？
		pid = fork();
		if(pid>0)
		{
			fork();//只让父进程再调用fork函数
		}	
	  3个进程：1个父进程 + 2个子进程
	
	3. 俗称“fork炸弹”
	  while(1)
	  {
		fork();
	  }

/*进程的终止*/
1. 正常终止进程的方式
	1. 执行main函数中的return语句；
	2. 调用exit()函数进行终止；
	3. 调用 _exit()和 _Exit()函数进行终止；//立即终止“immediately”
	4. 最后一个线程返回；
	5. 最后一个线程调用了pthread_exit()函数；

2. 非正常终止进程的方式
	1. 采用信号终止进程的执行；
	2. 最后一个线程被其他线程取消；


终止进程相关函数的解析
1. _exit()函数		terminate the calling process //终止当前正在调用的进程
       	#include <unistd.h>

       	void _exit(int status); => uc函数

       	#include <stdlib.h>

       	void _Exit(int status); => 标C函数

函数功能：
	用于立即终止当前正在调用的进程，关闭所有属于当前进程的打开的文件描述符；
		让该进程的所有子进程变更父进程为init进程；给父进程发送SIGCHLD信号让父进程帮其进行善后工作
	参数status的数值被返回给当前进程的父进程作为当前进程的退出状态信息，
		如果父进程收集该状态信息，则需要调用wait系列函数进行收集；
	函数_Exit()和函数_exit()之间是等价关系；
	
2. exit()函数		cause normal process termination //终止正常的进程
       	#include <stdlib.h>

       	void exit(int status);

函数功能：
	用于引起正常进程的终止，参数status & 0377 之后的结果返回给父进程作为该进程的退出状态信息，父进程可以使用wait系列的函数进行获取；
	该函数会自动调用所有由atexit()和on_exit()函数注册过的函数，该用法主要用于进行善后处理；
	EXIT_SUCCESS and EXIT_FAILURE 作为函数exit的实参可以表示正常结束和非正常结束程序的含义，但本质上就是 0 和 -1 ；

	
3. atexit()函数 register a function to be called at normal process termination 
			//注册一个函数用于进程正常终止时调用	
       	#include <stdlib.h>

       	int atexit(void (*function)(void));   //该形参里的函数会在调用它的函数正常结束时register

函数功能：
	主要用于注册（register）参数指定的函数，该注册（register）的函数会在正常进程终止时被调用，而正常进程终止的方式有：调用exit()函数 和 执行main函数中的return；
	成功返回0，失败返回非0；

//使用exit等函数实现进程的终止
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

//准备一个注册函数
void show(void)
{
    printf("所有的善后工作可以交给我来处理\n");
}

int main()
{
    //使用atexit函数注册一个函数  注册并不是调用
    int res=atexit(show);
    if(0!=res)
    {   
        perror("atexit"),exit(-1);
    }   
    printf("main函数开始执行\n");
    //_exit(0);//立即终止进程//善后也会终止
    //_Exit(0);//立即终止进程//善后也会终止
    //exit(0);//善后不会终止
    printf("main函数结束\n");
    return 0;
}

结果：	main函数开始执行
	main函数结束
	所有的善后工作可以交给我来处理


4. on_exit()函数	register a function to be called at normal process termination	
       	#include <stdlib.h>

       	int on_exit(void (*function)(int , void *), void *arg);
	
	//参数arg指针会传给参数function函数里的void*
	
on_exit需要类型‘void (*)(int,  void *)’

//例子在结尾


/*进程的等待*/
1. wait()函数			wait for process to change state //等待进程的状态改变
       	#include <sys/types.h>
       	#include <sys/wait.h>

       	pid_t wait(int *status);

函数功能：
	主要用于挂起当前正在执行的进程直到有一个子进程终止为止；
	当参数status不为空时，则将获取到的退出状态信息存放到该参数指定的int类型存储空间中，为了正确地解析退出状态信息需要借助以下的宏定义：
		WIFEXITED(*status) - 当子进程正常终止时返回真，而子进程正常终止的方式有：调用exit()/调用_eixt()/执行了main中return语句；

       	WIFEXITED(status)
              returns  true if the child terminated normally, that is, by calling
              exit(3) or _exit(2), or by returning from main().

		

		WEXITSTATUS(*status) - 返回子进程的退出状态信息；

       WEXITSTATUS(status)
              returns the exit status of the child.  This consists of  the  least
              significant  8 bits of the status argument that the child specified
              in a call to exit(3) or _exit(2) or as the argument  for  a  return
              statement  in main().  
	      This macro should only be employed if WIFEXITED returned true.
	
	成功返回终止子进程的进程号，失败返回-1；


//使用wait函数等待子进程结束并获取退出状态信息
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void)
{
	//1.创建子进程，使用fork函数
	pid_t pid = fork();
	if(-1 == pid)
	{
		perror("fork"),exit(-1);
	}
	//2.子进程开始执行，20秒后终止
	if(0 == pid)
	{
		printf("子进程%d开始执行\n",getpid());
		sleep(20);
		printf("子进程结束\n");
		exit(100);
	}
	//3.父进程开始等待，并获取子进程的退出状态信息
	printf("父进程开始等待...\n");
	int status = 0;
	int res = wait(&status);
	if(-1 == res)
	{
		perror("wait"),exit(-1);
	}
	// *(&status)  =  status;
	if(WIFEXITED(status))
	{
		printf("父进程等待结束，终止的子进程是：%d,该子进程的退出状态信息是：%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}

结果：	父进程开始等待...
	子进程8186开始执行
	子进程结束
	父进程等待结束，终止的子进程是：8186,该子进程的退出状态信息是:100


2. waitpid()函数	wait for process to change state
       	#include <sys/types.h>
       	#include <sys/wait.h>

	pid_t waitpid(pid_t pid, int *status, int options);

第一个参数：进程的编号(等待哪一个进程)
	<-1 表示等待任意一个进程组ID为pid绝对值的子进程（了解）
	       < -1   meaning wait for any child process whose process group ID is  equal
              to the absolute value of pid.
	 -1 表示等待任意一个子进程(重点)
	  0 表示等待任意一个进程组ID为当前正在调用进程ID的子进程(了解)
	 >0 表示等待进程号为pid的子进程(重点)
第二个参数：指针变量，用于获取子进程的退出状态信息
第三个参数：等待的方式，默认给0即可，表示阻塞的效果
	WNOHANG - 如果没有子进程退出则立即返回，不会等待
返回值:	如果使用阻塞的方式，成功返回子进程的进程号；
	如果使用非阻塞的方式成功返回0；
	无论使用何种方式只要失败都返回-1；

函数功能：
	用于等待参数指定的进程，并获取退出状态信息；

注意：
	The call wait(&status) is equivalent to:

           waitpid(-1, &status, 0);

//使用waitpid
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

int main()
{
	//1.创建两个子进程，使用fork函数
	pid_t pid1,pid2;
	pid1=fork();
	if(-1==pid1)
	{
		perror("fork"),exit(-1);
	}
	if(pid1>0)
	{
		pid2=fork();
		if(-1==pid2)
		{
			perror("fork"),exit(-1);
		}
	}
	//printf("到底是否有三个进程？？？\n");
	//2.子进程一开始执行，10秒后终止
	if(0==pid1)
	{
		printf("子进程一%d开始执行\n",getpid());
		sleep(10);
		printf("子进程一结束\n");
		exit(100);
	}
	//3.子进程二开始执行，20秒后终止
	if(0==pid2)
	{
		printf("子进程二%d开始执行\n",getpid());
		sleep(20);
		printf("子进程二结束\n");
		exit(200);
	}
	//4.父进程等待子进程结束，并获取退出状态信息
	printf("父进程开始等待...\n");
	int status=0;
	//等待任意一个子进程结束，相当于wait函数
	int res=waitpid(-1,&status,0);
	if(-1==res)
	{
		perror("waitpid"),exit(-1);
	}
	if(WIFEXITED(status))
	{
		printf("父进程等待结束，终止的子进程是：%d,退出状态信息是：%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}

结果：	父进程开始等待...
	子进程一8684开始执行
	子进程二8685开始执行
	子进程一结束
	父进程等待结束，终止的子进程是：8684,退出状态信息是：100
	[tarena@~/UNIX]$子进程二结束


//int res=waitpid(pid1,&status,0);
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

int main()
{
	//1.创建两个子进程，使用fork函数
	pid_t pid1,pid2;
	pid1=fork();
	if(-1==pid1)
	{
		perror("fork"),exit(-1);
	}
	if(pid1>0)
	{
		pid2=fork();
		if(-1==pid2)
		{
			perror("fork"),exit(-1);
		}
	}
	//printf("到底是否有三个进程？？？\n");
	//2.子进程一开始执行，10秒后终止
	if(0==pid1)
	{
		printf("子进程一%d开始执行\n",getpid());
		sleep(10);
		printf("子进程一结束\n");
		exit(100);
	}
	//3.子进程二开始执行，20秒后终止
	if(0==pid2)
	{
		printf("子进程二%d开始执行\n",getpid());
		sleep(20);
		printf("子进程二结束\n");
		exit(200);
	}
	//4.父进程等待子进程结束，并获取退出状态信息
	printf("父进程开始等待...\n");
	int status=0;

	//等待任意一个子进程结束，相当于wait函数
	//int res=waitpid(-1,&status,0);
	
	//表示等待进程号为pid1的子进程，子进程一
	int res=waitpid(pid1,&status,0);

	if(-1==res)
	{
		perror("waitpid"),exit(-1);
	}
	if(WIFEXITED(status))
	{
		printf("父进程等待结束，终止的子进程是：%d,退出状态信息是：%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}

结果：	父进程开始等待...
	子进程一8740开始执行
	子进程二8741开始执行
	子进程一结束
	父进程等待结束，终止的子进程是：8740,退出状态信息是：100
	[tarena@~/UNIX]$子进程二结束


//int res=waitpid(pid2,&status,0);
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

int main()
{
	//1.创建两个子进程，使用fork函数
	pid_t pid1,pid2;
	pid1=fork();
	if(-1==pid1)
	{
		perror("fork"),exit(-1);
	}
	if(pid1>0)
	{
		pid2=fork();
		if(-1==pid2)
		{
			perror("fork"),exit(-1);
		}
	}
	//printf("到底是否有三个进程？？？\n");
	//2.子进程一开始执行，10秒后终止
	if(0==pid1)
	{
		printf("子进程一%d开始执行\n",getpid());
		sleep(10);
		printf("子进程一结束\n");
		exit(100);
	}
	//3.子进程二开始执行，20秒后终止
	if(0==pid2)
	{
		printf("子进程二%d开始执行\n",getpid());
		sleep(20);
		printf("子进程二结束\n");
		exit(200);
	}
	//4.父进程等待子进程结束，并获取退出状态信息
	printf("父进程开始等待...\n");
	int status=0;

	//等待任意一个子进程结束，相当于wait函数
	//int res=waitpid(-1,&status,0);
	
	//表示等待进程号为pid2的子进程，子进程二
	int res=waitpid(pid2,&status,0);

	if(-1==res)
	{
		perror("waitpid"),exit(-1);
	}
	if(WIFEXITED(status))
	{
		printf("父进程等待结束，终止的子进程是：%d,退出状态信息是：%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}

结果：	父进程开始等待...
	子进程一8772开始执行
	子进程二8773开始执行
	子进程一结束
	子进程二结束
	父进程等待结束，终止的子进程是：8773,退出状态信息是：200


/*进程管理的其他函数*/
1. vfork函数		create a child process and block parent
       	#include <sys/types.h>
       	#include <unistd.h>

       	pid_t vfork(void);

函数功能：
	用于创建当前正在调用进程的子进程，有关详细情况以及返回值和错误信息参考fork函数；
	
	该函数创建子进程时不会复制父进程中的内存空间，而是/*直接占用*/导致父进程被挂起，
		直到子进程终止或者调用exec系列函数为止，
		而子进程终止的方式不可以是：从当前函数返回 以及 调用exit()函数，而/*应该调用_exit()函数来终止*/；
	The child must not return from the current function or call exit(3), 
      but may call _exit(2).
	vfork函数保证了子进程先执行；

	
//使用vfork函数创建子进程
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main()
{
	int num=100;//局部变量 栈区
	//1.创建子进程，使用vfork函数
	pid_t pid=vfork();
	if(-1==pid)
	{
		perror("vfork"),exit(-1);
	}
	//2.子进程开始执行
	if(0==pid)
	{
		num=200;
		printf("子进程%d开始执行，num=%d\n",getpid(),num);
		sleep(20);
		printf("子进程结束\n");
		_exit(0);
	}
	//3.父进程开始执行
	printf("父进程%d开始执行,num=%d\n",getpid(),num);
	printf("父进程结束\n");
	return 0;
}

结果：	子进程3065开始执行，num=200
	子进程结束
	父进程3064开始执行,num=200
	父进程结束


2. exec系列函数
	execl, execlp, execle, execv, execvp, execvpe - execute a file
       #include <unistd.h>				 执行

       extern char **environ;

       int execl(const char *path, const char *arg, ...);
       int execlp(const char *file, const char *arg, ...);
       int execle(const char *path, const char *arg,
                  ..., char * const envp[]);
       int execv(const char *path, char *const argv[]);
       int execvp(const char *file, char *const argv[]);
       int execvpe(const char *file, char *const argv[],
                  char *const envp[]);

execl()函数
	int execl(const char *path, const char *arg, ...);
第一个参数：字符串形式的路径名；
第二个参数：字符串形式的参数，一般指定具体的执行方式；
第三个参数：可变长参数，最后使用NULL作为结尾标志；
返回值：只有出错的时候才有返回值，并且返回-1；

函数功能：
	用于执行参数指定的文件，类似于跳转的功能；

注意：
	vfork函数本身没有太大的实际意义，一般与exec系列的函数搭配使用，该用法主要用于子进程需要与父进程完全不同的代码段配合中，
		其中vfork函数专门用于创建子进程，exec系列函数专门用于执行全新的代码段；
	fork函数虽然也可以和exec系列函数搭配使用，但fork函数创建的子进程会复制父进程中的内存区域，因此会影响效率；

//使用execl函数创建子进程
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main()
{
	//1.创建子进程，使用vfork函数
	pid_t pid=vfork();
	if(-1==pid)
	{
		perror("vfork"),exit(-1);
	}
	//2.子进程开始执行
	if(0==pid)
	{
		printf("子进程%d开始执行\n",getpid());
		sleep(20);
		printf("子进程即将跳出去执行\n");
		//调用execl函数进行跳转
		int res=execl("/bin/ls","ls"，"-l",NULL);
		if(-1==res)
		{
			perror("execl"),_exit(-1);
		}
		printf("子进程结束\n");
		//_exit(0);
	}
	
	{
	//3.父进程开始执行
	printf("父进程%d开始执行\n",getpid());
	printf("父进程结束\n");
	}
	return 0;
}

结果：	w@w:~$ vi 1.c
	w@w:~$ cc 1.c
	w@w:~$ ./a.out 
	子进程25410开始执行
	子进程即将跳出去执行
	父进程25409开始执行
	父进程结束
	w@w:~$ 总用量 60
	-rw-rw-r-- 1 w w  800 2月  22 09:51 1.c
	-rwxrwxr-x 1 w w 7624 2月  22 09:51 a.out
	-rw-r--r-- 1 w w 8980 2月  21 19:10 examples.desktop
	drwxrwxrwx 3 w w 4096 2月  21 12:04 vim配置和插件
	drwxr-xr-x 2 w w 4096 2月  21 19:17 公共的
	drwxr-xr-x 2 w w 4096 2月  21 19:17 模板
	drwxr-xr-x 2 w w 4096 2月  21 19:17 视频
	drwxr-xr-x 2 w w 4096 2月  21 19:17 图片
	drwxr-xr-x 2 w w 4096 2月  21 19:17 文档
	drwxr-xr-x 2 w w 4096 2月  21 19:17 下载
	drwxr-xr-x 2 w w 4096 2月  21 19:17 音乐
	drwxr-xr-x 2 w w 4096 2月  21 11:29 桌面


3. system()函数	execute a shell command
       	#include <stdlib.h>

       	int system(const char *command);

函数功能：
	用于执行参数指定的shell命令，成功返回命令的状态信息，失败返回-1；

//使用system函数执行具体的shell命令
#include<stdio.h>
#include<stdlib.h>

int main()
{
    int res=system("pwd");
    if(-1==res)
    {   
        perror("system"),exit(-1);
    }   
    printf("shell命令完毕\n");
    return 0;
}

结果：	/home/tarena/UNIX
	shell命令完毕

作业：
	使用fork函数创建子进程，在子进程中申请一个int类型大小的动态内存，提示用户输入半径，
		根据用户的输入计算周长并打印，要求当子进程终止时自动释放动态内存，父进程等待子进程结束，
		并获取退出状态信息，打印出来；

//自己写的
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

void free_int(int s/*tatus*/,void *p)
{
//	printf("diao%p\n",p);
	free(p);
	p=NULL;
	printf("%d\n",s/*tatus*/);
}

int main()
{
	//1.创建子进程
	//2.申请动态内存，提示输入，计算周长
	//3.写子函数on_exit
	//4.父进程等待 状态信息 status
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	if(pid==0)
	{
		int *m=(int*)malloc(sizeof(int));
	//	printf("zhu%p\n",m);
		char *arg="free success";
		on_exit(free_int,(void*)m);
		if(m==NULL)
		{
			perror("malloc"),exit(-1);
		}
		printf("输入半径：\n");
		scanf("%d",m);
		printf("圆的周长为：%lg\n",2*3.14*(*m));
		exit(99);
		m=NULL;
	}
	int s/*tatus*/=0;
	int res=waitpid(pid,&s/*tatus*/,0);
	if(-1==res)
	{
		perror("waitpid"),exit(-1);
	}
	if(WIFEXITED(s/*tatus*/))
	{
		printf("父进程等待结束，终止的子进程是：%d,退出状态信息：%d\n",res,WEXITSTATUS(s/*tatus*/));
	}
	return 0;
}


结果：	输入半径：
	10
	圆的周长为：62.8
	99
	父进程等待结束，终止的子进程是：10122,退出状态信息：99

//老师写的
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

void fa(int status,void *pv)
{
	printf("status=%d\n",status);
	printf("释放动态内存\n");
	sleep(3);
	//调用brk函数释放动态内存
	int res=brk(pv);
	if(-1==res)
	{
		perror("brk"),exit(-1);
	}
	printf("释放动态内存完毕\n");
}


int main()
{
	//1.创建子进程，使用fork函数
	pid_t pid=fork();
	if(-1==pid)
	{
		perror("fork"),exit(-1);
	}
	//2.子进程开始执行，申请动态内存
	if(0==pid)
	{
		printf("子进程%d开始执行\n",getpid());
		int *pi=(int*)sbrk(sizeof(int));
		if((int*)-1==pi)
		{
			perror("sbrk"),exit(-1);
		}
		printf("输入半径：");
		scanf("%d",pi);
		printf("周长：%lf\n",2*3.14*(*pi));

		//调用on_exit()函数实现注册
		int res =on_exit(fa,(void*)pi);
		if(0!=res)
		{
			perror("on_exit"),exit(-1);
		}
		exit(100);
	}
	//3.父进程等待子进程结束，并获取退出状态信息
	printf("父进程开始等待...\n");
	int status=0;
	int res=wait(&status);
	if(-1==res)
	{
		perror("wait"),exit(-1);
	}
	if(WIFEXITED(status))
	{
		printf("父进程等待结束，终止的子进程是：%d,该子进程的退出状态信息是：%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}


结果：	父进程开始等待...
	子进程2834开始执行
	输入半径：10
	周长：62.800000
	status=100
	释放动态内存
	释放动态内存完毕
	父进程等待结束，终止的子进程是：2834,该子进程的退出状态信息是：100


