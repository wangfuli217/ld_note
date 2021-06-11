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
/*	����pid��ֵ:��ֵ��0��ʱ�򣬱�ʾ�ó������ӳ��������ֵ��pid��ʱ��
��ʾ�����Ǹ����̵ĳ������ԣ�����Ĵ���ֻ��������ִ��*/
    if(pid) {
        int stat_val;
        pid_t child_pid;
		//						�ӽ��̵�pid ,���ص�����,Ĭ�϶���0
		//					�ܷḻ�Ĳ������ر���child
		//waitpid()--waitpid(child, &retval, 0); //�ȴ��ӽ����˳�
		// wait(&stat_val) Ĭ�ϵ����ӽ��̵ģ�
        child_pid = wait(&stat_val);

        printf("Child has finished: PID = %d\n", child_pid);
        if(WIFEXITED(stat_val))
            printf("Child exited with code %d\n", WEXITSTATUS(stat_val));
        else
            printf("Child terminated abnormally\n");
    }
/*����ĸ����̺��ӽ��̶���ִ�У�Ҳ��ӳ�˲�ͬ�ķ���ֵ
�ӽ��̽����Ժ�ķ���ֻ��37���������̵ķ���ֵ��0*/
    exit (exit_code);
}
