#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>

int main(void)
{
    pid_t pid;
    char *message;
    int n;
    int exit_code;

    printf("fork program starting\n");
    pid = fork();
    switch(pid) 
    {
    case -1:
        exit(1);
    case 0:
        message = "This is the child";
        n = 5;
        exit_code = 37;
        break;
    default:
        message = "This is the parent";
        n = 10;
        exit_code = 0;
        break;
    }

    for(; n > 0; n--) 
	{
        puts(message);
        sleep(1);
    }

/*  This section of the program waits for the child process to finish.  */
/*	由于pid的值:当值是0的时候，表示该程序是子程序，如果该值是pid的时候
表示程序是父进程的程序，所以，下面的代码只有主进成执行*/
    if(pid) {
        int stat_val;
        pid_t child_pid;
		//						子进程的pid ,返回的数据,默认都是0
		//					很丰富的参数，特别是child
		//waitpid()--waitpid(child, &retval, 0); //等待子进程退出
		// wait(&stat_val) 默认的是子进程的，
        child_pid = wait(&stat_val);

        printf("Child has finished: PID = %d\n", child_pid);
        if(WIFEXITED(stat_val))
            printf("Child exited with code %d\n", WEXITSTATUS(stat_val));
        else
            printf("Child terminated abnormally\n");
    }
/*下面的父进程和子进程都会执行，也反映了不同的返回值
子进程结束以后的返回只是37，而父进程的返回值是0*/
    exit (exit_code);
}
