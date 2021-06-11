#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    printf("entering main process---\n");
    execl("/bin/ls", "ls", "-l", NULL);
//    execl("/bin/ls", "/bin/ls", "-l", NULL);//和上面函数一样

    //利用execl将当前进程main替换掉，所有最后那条打印语句不会输出
    printf("exiting main process ----\n");
    return 0;
}
