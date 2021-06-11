#include <stdio.h> 
#include <string.h> 
#include <errno.h> 
#include <sys/socket.h> 
#include <resolv.h> 
#include <stdlib.h> 
#include <netinet/in.h> 
#include <arpa/inet.h> 
#include <unistd.h> 
#include <openssl/ssl.h> 
#include <openssl/err.h> 

#define MAXBUF 1024 

void ShowCerts(SSL * ssl) {
  X509 * cert;
  char * line;
  cert = SSL_get_peer_certificate(ssl);
  if (cert != NULL) {
    printf("cert info:\n");
    line = X509_NAME_oneline(X509_get_subject_name(cert), 0, 0);
    printf("cert: %s\n", line);
    free(line);
    line = X509_NAME_oneline(X509_get_issuer_name(cert), 0, 0);
    printf("ca: %s\n", line);
    free(line);
    X509_free(cert);
  }  else {
    printf("no cert\n");
  }
}

int main(int argc, char * *argv){
  int sockfd, len;
  struct sockaddr_in dest;
  char buffer[MAXBUF + 1];
  SSL_CTX * ctx;
  SSL * ssl;
  
  SSL_library_init();
  OpenSSL_add_all_algorithms();
  SSL_load_error_strings();
  
  ctx = SSL_CTX_new(SSLv23_client_method());
  if (ctx == NULL) {
    ERR_print_errors_fp(stdout);
    exit(1);
  }
  
  if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    perror("Socket");
    exit(errno);
  }
  printf("socket created\n");
  
  bzero( &dest, sizeof(dest));
  dest.sin_family = AF_INET;
  
  dest.sin_port = htons(11111);
  
  if (inet_aton("127.0.0.1", (struct in_addr * ) &dest.sin_addr.s_addr) == 0) {
    perror("127.0.0.1");
    exit(errno);
  }
  printf("address created\n");
  
  if (connect(sockfd, (struct sockaddr * ) &dest, sizeof(dest)) != 0){
    perror("Connect ");
    exit(errno);
  }
  printf("server connected\n");
  
  ssl = SSL_new(ctx);
  SSL_set_fd(ssl, sockfd);
  
  if (SSL_connect(ssl) == -1) {
    ERR_print_errors_fp(stderr);
  }else {
    printf("Connected with %s encryption\n", SSL_get_cipher(ssl));
    ShowCerts(ssl);
  }
  
  bzero(buffer, MAXBUF + 1);
  
  len = SSL_read(ssl, buffer, MAXBUF);
  if (len > 0) {
    printf("receive ok:'%s',len:%d\n", buffer, len);
  }else {
    printf("receive error, code:%d,errmsg:'%s'\n", errno, strerror(errno));
    goto finish;
  }
  
  bzero(buffer, MAXBUF + 1);
  strcpy(buffer, "from client->server");
  
  len = SSL_write(ssl, buffer, strlen(buffer));
  if (len < 0) {
    printf("send '%s' error, code is %d,errmsgis'%s'\n", buffer, errno, strerror(errno));
  }else {
    printf("send '%s',len is %d \n", buffer, len);
  }
 finish:
  
  SSL_shutdown(ssl);
  SSL_free(ssl);
  close(sockfd);
  SSL_CTX_free(ctx);
  return 0;
}
