#include <stdio.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdlib.h>

void test()
{
    int i;
    scanf("%d",i);//ÕýÈ·Ð´·¨&i
    printf("%d\n", i);
}

int main(void) {
    test();
    return 0;
}
