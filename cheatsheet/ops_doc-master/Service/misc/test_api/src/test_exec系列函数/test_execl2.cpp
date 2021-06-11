#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char ** argv) {

    if (argc == 1)//首次进入这里
    {
        printf("[father] entering main process---\n");
        pid_t pid;
        pid = fork();
        if (pid < 0)
        {
            perror("Error fork():");
            return -1;
        }
        else if(pid == 0)
        {
            printf("[child] the child pid = %d\n", getpid());
            return execl("./test_execl2", "test_execl2", "1", NULL);
        }
        else
        {
            printf("[father] the child pid = %d\n", pid);
            printf("[father] the farther pid = %d\n", getpid());
            printf("[father] exiting main process ----\n");
        }
    }
    else//execl调用进入这里
    {
        printf("[execl] entering process---\n");
        printf("[execl] pid = %d\n", getpid());
        sleep(1);
        printf("[execl] exiting process ----\n");
        return -1;
    }

    return 0;
}
