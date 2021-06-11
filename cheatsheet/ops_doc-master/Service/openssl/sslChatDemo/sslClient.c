#include "ssl.h"

#define MAXLEN 2048

int main(int argc, char *argv[])
{
	int sockfd;
	int len;
	SSL_CTX *ctx = NULL;
	SSL *ssl = NULL;
	char buf[MAXLEN];
	time_t now;
	char *pos;

	if (argc != 3) {
		printf("Please set the arguments as follow:\n");
		printf("%s <serverIP> <port>\n", argv[0]);
		return -1;
	}

	SSL_library_init();
	OpenSSL_add_all_algorithms();
	SSL_load_error_strings();
	ctx = SSL_CTX_new(SSLv23_client_method());
	if (ctx == NULL) {
		ERR_print_errors_fp(stdout);
		return -1;
	}
	if (ssl_connect(ctx, &sockfd, &ssl, argv[2], argv[1]))
		return -1;

	now = time(NULL);
	pos = ctime(&now);
	pos[strlen(pos) - 1] = '\0';

	while (1) {
		bzero(buf, sizeof(buf));
		printf("[%s] Input the Msg send to Server: ", pos);
		scanf("%s", buf);
		len = SSL_write(ssl, buf, strlen(buf));
		if (len <= 0) {
			ERR_print_errors_fp(stderr);
			printf("Disconnect with the Server!\n");
			return -1;
		}
		bzero(buf, sizeof(buf));
		len = SSL_read(ssl, buf, sizeof(buf));
		if (len <= 0) {
			ERR_print_errors_fp(stderr);
			printf("Disconnect with the Server!\n");
			return -1;
		}

		now = time(NULL);
		pos = ctime(&now);
		pos[strlen(pos) - 1] = '\0';
		printf("\n[%s] Recv Msg from Server: %s\n", pos, buf);
	}

	return 0;
}
