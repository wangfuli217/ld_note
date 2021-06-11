#include <stdio.h>
#include <stdio.h>
#include "debug.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <sys/un.h>
#include <unistd.h>

int main()
{
	int listenfd = socket(AF_UNIX, SOCK_STREAM, 0);
	if(-1 == listenfd)
		errsys("socket");

	struct sockaddr_un myaddr = {0};
	myaddr.sun_family = AF_UNIX;
	strcpy(myaddr.sun_path, "./9020");
	int len = sizeof myaddr;

	if(-1 == bind(listenfd, (struct sockaddr*)&myaddr, len))
		errsys("bind");

	if(-1 == listen(listenfd, 10))
		errsys("listen");

	int sockfd = accept(listenfd, NULL, &len);
	if(-1 == sockfd)
		errsys("accept");
	

	char c;
	struct iovec v = {&c, 1}; 
//	struct iovec v = {"", 1}; 

        struct cmsghdr *cmsg = malloc(CMSG_SPACE(sizeof(int)));
        cmsg->cmsg_len = CMSG_SPACE(sizeof(int));
        cmsg->cmsg_level = SOL_SOCKET;
        cmsg->cmsg_type = SCM_RIGHTS;

        struct msghdr msg = {0};
        msg.msg_name = NULL;
        msg.msg_namelen = 0;
        msg.msg_iov = &v; 
        msg.msg_iovlen = 1;
        msg.msg_control = cmsg;
        msg.msg_controllen = CMSG_SPACE(sizeof(int)); 

	if(-1 == recvmsg(sockfd, &msg, 0))
		errsys("sockfd");

	int fd = *(&cmsg->cmsg_type+1);

	printf("fd = %d\n", fd);
	write(fd, "hello", 5);

	close(listenfd);
	close(sockfd);
}
