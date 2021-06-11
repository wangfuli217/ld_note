#include "ssl.h"

#define MAXLEN 2048

int main(int argc, char *argv[])
{
	int listen_fd, new_fd, max_fd;
	int ret, recv_len;
	SSL_CTX *ctx;
	SSL *ssl;
	fd_set readfds;
	time_t now;
	char *pos;
	char recvBuf[MAXLEN];
	SockList head, *tmpNode;
	socklen_t cli_len = sizeof(struct sockaddr);
	struct timeval timeout;
	struct sockaddr_in cli;

	if (argc != 4) {
		printf("Please set the arguments as follow:\n");
		printf("%s <port> <certificate> <privateKey>\n", argv[0]);
		return -1;
	}

	signal(SIGPIPE, SIG_IGN);

	if (ssl_init(&ctx))
		return -1;
	if (ssl_load(ctx, argv[2], argv[3]))
		return -1;
	if (createListen(&listen_fd, argv[1], NULL))
		return -1;
	bzero(&head, sizeof(head));

	while (1) {
		FD_ZERO(&readfds);
		max_fd = listen_fd;
		FD_SET(listen_fd, &readfds);
		tmpNode = head.next;
		while (tmpNode) {
			max_fd = max_fd > tmpNode->fd ? max_fd : tmpNode->fd;
			FD_SET(tmpNode->fd, &readfds);
			tmpNode = tmpNode->next;
		}
		timeout.tv_sec = 10;
		timeout.tv_usec = 0;
		ret = select(max_fd + 1, &readfds, NULL, NULL, &timeout);
		if (ret <= 0)
			continue;
		else {
			if (FD_ISSET(listen_fd, &readfds)) {
				new_fd = ssl_accept(ctx, listen_fd, &ssl);
				if (new_fd < 0)
					continue;

				tmpNode = (SockList *) malloc(sizeof(SockList));
				memset(tmpNode, 0, sizeof(SockList));
				tmpNode->fd = new_fd;
				tmpNode->ssl = ssl;
				bzero(&cli, sizeof(cli));
				getpeername(new_fd, (struct sockaddr *)&cli, &cli_len);
				strncpy(tmpNode->ip, inet_ntoa(cli.sin_addr), sizeof(tmpNode->ip));

				tmpNode->next = head.next;
				head.next = tmpNode;
			}

			tmpNode = head.next;
			while (tmpNode) {
				if (FD_ISSET(tmpNode->fd, &readfds)) {
					memset(recvBuf, 0, sizeof(recvBuf));
					recv_len = SSL_read(tmpNode->ssl, recvBuf, sizeof(recvBuf));
					if (recv_len <= 0) {
						perror("SSL_read");
						disconnect(&head, tmpNode->fd);
					} else {
						now = time(NULL);
						pos = ctime(&now);
						pos[strlen(pos) - 1] = '\0';
						printf("\n[%s] Recv Msg from Client %s, fd %d, %s\n", pos, tmpNode->ip,
						       tmpNode->fd, recvBuf);
						printf("[%s] Input the Msg you want to Response: ", pos);
						memset(recvBuf, 0, sizeof(recvBuf));
						scanf("%s", recvBuf);
						SSL_write(tmpNode->ssl, recvBuf, strlen(recvBuf));
					}
					break;
				}
				tmpNode = tmpNode->next;
			}
		}
	}

	/* 释放 CTX */
	SSL_CTX_free(ctx);
	return 0;
}
