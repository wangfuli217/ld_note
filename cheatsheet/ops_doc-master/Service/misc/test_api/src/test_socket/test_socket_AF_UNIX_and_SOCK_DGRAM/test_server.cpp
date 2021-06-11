#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

int main(int argc ,char *argv[])
{
    int s_fd = 0;
    struct sockaddr_un s_addr;
    int s_len = sizeof(struct sockaddr_un);

    unlink("./u_socket");

    s_addr.sun_family = AF_UNIX;
    strcpy(s_addr.sun_path,"./u_socket");

    s_fd = socket(AF_UNIX,SOCK_DGRAM,0);
    if(s_fd < 0 )
    {
        perror("socket error");
        exit(-1);
    }

    if(bind(s_fd,(struct sockaddr *)&s_addr,s_len) < 0)
    {
        perror("bind error");
        close(s_fd);
        exit(-1);
    }
    printf("Bind is ok\n");

    while(1)
    {
        char recv_buf[20] = "";
        recvfrom(s_fd,recv_buf,sizeof(recv_buf),0,(struct sockaddr*)&s_addr,&s_len);
        printf("Recv: %s\n",recv_buf);
    }
    return 0;

}
