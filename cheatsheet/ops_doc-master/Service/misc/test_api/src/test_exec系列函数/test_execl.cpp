#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    printf("entering main process---\n");
    execl("/bin/ls", "ls", "-l", NULL);
//    execl("/bin/ls", "/bin/ls", "-l", NULL);//�����溯��һ��

    //����execl����ǰ����main�滻�����������������ӡ��䲻�����
    printf("exiting main process ----\n");
    return 0;
}
