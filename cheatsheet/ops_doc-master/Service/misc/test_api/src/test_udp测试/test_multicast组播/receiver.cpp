#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>

#define HELLO_PORT  12345
#define HELLO_GROUP1 "225.0.0.37"
#define HELLO_GROUP2 "225.0.0.38"
#define MSGBUFSIZE 256

int create_server(const char * group, int port)
{
    struct sockaddr_in addr;
    int fd, nbytes,addrlen;
    struct ip_mreq mreq;
    char msgbuf[MSGBUFSIZE];

    u_int yes=1; /*** MODIFICATION TO ORIGINAL */

    /* create what looks like an ordinary UDP socket */
    if ((fd=socket(AF_INET,SOCK_DGRAM,0)) < 0)
    {
        perror("socket");
        exit(1);
    }


    /**** MODIFICATION TO ORIGINAL */
    /* allow multiple sockets to use the same PORT number */
    if (setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(yes)) < 0)
    {
        perror("Reusing ADDR failed");
        exit(1);
    }
    /*** END OF MODIFICATION TO ORIGINAL */

    /* set up destination address */
    memset(&addr,0,sizeof(addr));
    addr.sin_family=AF_INET;
    addr.sin_addr.s_addr=htonl(INADDR_ANY); /* N.B.: differs from sender */
    addr.sin_port=htons(port);

    /* bind to receive address */
    if (bind(fd,(struct sockaddr *) &addr,sizeof(addr)) < 0)
    {
        perror("bind");
        exit(1);
    }

    /* use setsockopt() to request that the kernel join a multicast group */
    mreq.imr_multiaddr.s_addr=inet_addr(group);
    mreq.imr_interface.s_addr=htonl(INADDR_ANY);

    /* route add -net 225.0.0.37 netmask 255.255.255.255 eth0 */
    if (setsockopt(fd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq)) < 0)
    {
        perror("setsockopt");
        exit(1);
    }

    /* now just enter a read-print loop */
    while (1)
    {
        addrlen=sizeof(addr);
        if ((nbytes=recvfrom(fd,msgbuf,MSGBUFSIZE,0, (struct sockaddr *) &addr,(socklen_t*)&addrlen)) < 0)
        {
            perror("recvfrom");
            exit(1);
        }
        puts(msgbuf);
    }
}

int main(int argc, char *argv[])
{
    pid_t pid;

    pid = fork();
    if (pid < 0)
    {
        perror("fork()");
        return 0;
    }

    if (pid == 0)
    {
        create_server(HELLO_GROUP1, HELLO_PORT);
    }
    else
    {
        create_server(HELLO_GROUP2, HELLO_PORT);
    }

    return 0;
}
