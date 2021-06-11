#include "ssl.h"
int ssl_init(SSL_CTX **ctx)
{
	/* SSL 库初始化 */
	SSL_library_init();
	/* 载入所有 SSL 算法 */
	OpenSSL_add_all_algorithms();
	/* 载入所有 SSL 错误消息 */
	SSL_load_error_strings();
	/* 以 SSL V2 和 V3 标准兼容方式产生一个 SSL_CTX ，即 SSL Content Text */
	/* 也可以用 SSLv2_server_method() 或 SSLv3_server_method() 单独表示 V2 或 V3标准 */
	*ctx = SSL_CTX_new(SSLv23_server_method());
	if (NULL == *ctx) {
		perror("SSL_CTX_new");
		return -1;
	}

	return 0;
}

int ssl_load(SSL_CTX *ctx, char *certificate, char *privateKey)
{
	if (NULL == ctx || NULL == certificate || NULL == privateKey)
		return -1;
	/* 载入用户的数字证书， 此证书用来发送给客户端。 证书里包含有公钥 */
	if (SSL_CTX_use_certificate_file(ctx, certificate, SSL_FILETYPE_PEM) <= 0) {
		perror("SSL_CTX_use_certificate_file");
		return -1;
	}
	/* 载入用户私钥 */
	if (SSL_CTX_use_PrivateKey_file(ctx, privateKey, SSL_FILETYPE_PEM) <= 0) {
		perror("SSL_CTX_use_PrivateKey_file");
		return -1;
	}
	/* 检查用户私钥是否正确 */
	if (!SSL_CTX_check_private_key(ctx)) {
		perror("SSL_CTX_check_private_key");
		return -1;
	}
	return 0;
}

int createListen(int *listen_fd, char *port, char *addr)
{
	int yes = 1;
	struct sockaddr_in my_addr;
	if (NULL == listen_fd || NULL == port)
		return -1;
	/* 开启一个 socket 监听 */
	if ((*listen_fd = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
		perror("socket");
		return -1;
	}
	bzero(&my_addr, sizeof(my_addr));
	my_addr.sin_family = PF_INET;
	my_addr.sin_port = htons(atoi(port));
	if (addr)
		my_addr.sin_addr.s_addr = inet_addr(addr);
	else
		my_addr.sin_addr.s_addr = INADDR_ANY;

	if (-1 == setsockopt(*listen_fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes))) {
		perror("setsockopt");
		close(*listen_fd);
		return -1;
	}

	if (bind(*listen_fd, (struct sockaddr *)&my_addr,
	         sizeof(struct sockaddr)) < 0) {
		perror("bind");
		close(*listen_fd);
		return -1;
	}
	if (listen(*listen_fd, 3) < 0) {
		perror("listen");
		close(*listen_fd);
		return -1;
	}
	return 0;
}

int ssl_accept(SSL_CTX *ctx, int listen_fd, SSL **ssl)
{
	struct sockaddr_in their_addr;
	socklen_t len = sizeof(struct sockaddr);
	int new_fd;
	if (NULL == ctx || listen_fd < 0 || NULL == ssl)
		return -1;

	/* 等待客户端连上来 */
	bzero(&their_addr, sizeof(their_addr));
	if ((new_fd = accept(listen_fd, (struct sockaddr *)&their_addr, &len)) < 0) {
		perror("accept");
		return -1;
	} else
		printf("\ngot connection from %s, port %d, socket %d\n",
		       inet_ntoa(their_addr.sin_addr), ntohs(their_addr.sin_port), new_fd);

	/* 基于 ctx 产生一个新的 SSL */
	*ssl = SSL_new(ctx);
	/* 将连接用户的 socket 加入到 SSL */
	SSL_set_fd(*ssl, new_fd);
	/* 建立 SSL 连接 */
	if (SSL_accept(*ssl) < 0) {
		perror("accept");
		close(new_fd);
		return -1;
	}
	return new_fd;
}

int ssl_connect(SSL_CTX *ctx, int *sockfd, SSL **ssl, char *port, char *addr)
{
	struct sockaddr_in dest;

	if (NULL == ctx || NULL == sockfd || NULL == ssl || NULL == port ||
	    NULL == addr)
		return -1;

	/* 创建一个 socket 用于 tcp 通信 */
	if ((*sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		perror("Socket");
		return -1;
	}

	/* 初始化服务器端（对方）的地址和端口信息 */
	bzero(&dest, sizeof(dest));
	dest.sin_family = AF_INET;
	dest.sin_port = htons(atoi(port));
	if (inet_aton(addr, (struct in_addr *)&dest.sin_addr.s_addr) == 0) {
		perror("inet_aton");
		return -1;
	}

	/* 连接服务器 */
	if (connect(*sockfd, (struct sockaddr *)&dest, sizeof(dest)) < 0) {
		perror("Connect ");
		return -1;
	}

	/* 基于 ctx 产生一个新的 SSL */
	*ssl = SSL_new(ctx);
	SSL_set_fd(*ssl, *sockfd);
	/* 建立 SSL 连接 */
	if (SSL_connect(*ssl) < 0) {
		perror("SSL_connect");
		return -1;
	}
	return 0;
}

int ssl_close(SSL_CTX *ctx, SSL *ssl, int listen_fd, int new_fd)
{
	if (NULL == ctx || NULL == ssl || listen_fd < 0 || new_fd < 0)
		return -1;

	/* 关闭 SSL 连接 */
	SSL_shutdown(ssl);
	/* 释放 SSL */
	SSL_free(ssl);
	/* 关闭 socket（服务端专用） */
	if (new_fd)
		close(new_fd);
	/* 关闭监听的 socket */
	close(listen_fd);
	/* 释放 CTX */
	SSL_CTX_free(ctx);
	return 0;
}

int disconnect(SockList *head, int fd)
{
	if (NULL == head || fd < 0)
		return -1;

	SockList *preNode, *curNode;

	preNode = head;
	curNode = head->next;
	while (curNode) {
		if (curNode->fd == fd) {
			printf("\ndisconnect with the fd %d from %s\n", curNode->fd, curNode->ip);
			preNode->next = curNode->next;
			SSL_shutdown(curNode->ssl);
			SSL_free(curNode->ssl);
			close(fd);
			free(curNode);
			break;
		}
		preNode = preNode->next;
		curNode = curNode->next;
	}
	return 0;
}
