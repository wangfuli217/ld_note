#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
typedef struct _SockList {
	int fd;
	SSL *ssl;
	char ip[16];
	struct _SockList *next;
} SockList;
int ssl_init(SSL_CTX **ctx);
int ssl_load(SSL_CTX *ctx, char *certificate, char *privateKey);
int ssl_accept(SSL_CTX *ctx, int sockfd, SSL **ssl);
int ssl_connect(SSL_CTX *ctx, int *sockfd, SSL **ssl, char *port, char *addr);
int ssl_close(SSL_CTX *ctx, SSL *ssl, int sockfd, int new_fd);
int disconnect(SockList *head, int fd);
int createListen(int *listen_fd, char *port, char *addr);
