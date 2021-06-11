#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>

int main(int argc,char *argv[])
{
    int c_fd = 0;
    struct sockaddr_un s_addr;
    int s_len = sizeof(struct sockaddr_un);

    bzero(&s_addr,sizeof(s_addr));

    s_addr.sun_family = AF_UNIX;
    strcpy(s_addr.sun_path,"./u_socket");

    c_fd = socket(AF_UNIX,SOCK_DGRAM,0);
    if(c_fd < 0)
    {
        perror("socket error");
        exit(-1);
    }

    while(1)
    {
        static int counter = 0;
        char send_buf[20] = "";
        counter++;
        sprintf(send_buf,"Counter is %d",counter);

        sendto(c_fd,send_buf,strlen(send_buf),0,(struct sockaddr*)&s_addr,s_len);

        printf("Send: %s\n",send_buf);
        sleep(1);
    }
    return 0;
}
