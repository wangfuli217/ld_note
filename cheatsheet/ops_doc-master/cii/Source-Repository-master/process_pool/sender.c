#include <stdio.h>
#include "debug.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <sys/un.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	int sockfd = socket(AF_UNIX, SOCK_STREAM, 0); // 
	if(-1 == sockfd)
		errsys("socket");

	struct sockaddr_un serveraddr = {0};
	serveraddr.sun_family = AF_UNIX;
	strcpy(serveraddr.sun_path, "./9020");
	int len = sizeof serveraddr;

	if(-1 == connect(sockfd, (struct sockaddr*)&serveraddr, len))
		errsys("connect");
#if 0
	struct iovec {                    /* Scatter/gather array items */
               void  *iov_base;              /* Starting address */
               size_t iov_len;               /* Number of bytes to transfer */
           };

           struct msghdr {
               void         *msg_name;       /* optional address */
               socklen_t     msg_namelen;    /* size of address */
               struct iovec *msg_iov;        /* scatter/gather array */
               size_t        msg_iovlen;     /* # elements in msg_iov */
               void         *msg_control;    /* ancillary data, see below */
               size_t        msg_controllen; /* ancillary data buffer len */
               int           msg_flags;      /* flags on received message */
           };

	struct cmsghdr {
               socklen_t     cmsg_len;     /* data byte count, including hdr */
               int           cmsg_level;   /* originating protocol */
               int           cmsg_type;    /* protocol-specific type */
           /* followed by
               unsigned char cmsg_data[]; */
           };
	
#endif
	struct iovec v = {"", 1};

	struct cmsghdr *cmsg = malloc(CMSG_SPACE(sizeof(int)));
	cmsg->cmsg_len = CMSG_SPACE(sizeof(int));
	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_RIGHTS;
	*(&cmsg->cmsg_type+1) = STDOUT_FILENO;

	struct msghdr msg = {0};
	msg.msg_name = NULL;
	msg.msg_namelen = 0;
	msg.msg_iov = &v;
	msg.msg_iovlen = 1;
	msg.msg_control = cmsg;
	msg.msg_controllen = CMSG_SPACE(sizeof(int));	

	
	if(-1 == sendmsg(sockfd, &msg, 0) )
		errsys("sendmsg");

}

