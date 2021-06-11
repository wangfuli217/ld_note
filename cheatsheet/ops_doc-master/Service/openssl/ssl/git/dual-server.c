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

#define MAXBUF 1024

#define CA_FILE                "ca/ca-cert.pem"
#define SERVER_KEY             "server/server-key.pem"
#define SERVER_CERT            "server/server-cert.pem"
  
int main(int argc, char **argv){
  int sockfd, new_fd;
  int reuse = 0;
  socklen_t len;
  struct sockaddr_in my_addr, their_addr;
  unsigned int myport, lisnum;
  char buf[MAXBUF + 1];
  SSL_CTX *ctx;
  const SSL_METHOD *method;
  
  myport = 11111;
  lisnum = 128;

  SSL_library_init();
  OpenSSL_add_all_algorithms();
  SSL_load_error_strings();
  
  method = TLS_server_method();
  ctx = SSL_CTX_new(method);
  if (ctx == NULL) {
    ERR_print_errors_fp(stdout);
    exit(1);
  }
  
#if 0
  const char *cipher_list = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384";
  if (SSL_CTX_set_cipher_list(ctx, cipher_list) == 0) {
    SSL_CTX_free(ctx);
    printf("Failed to set cipher list %s", cipher_list);
  }
#endif
  
  SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, 0);
  /*加载CA FILE*/
  if (SSL_CTX_load_verify_locations(ctx, CA_FILE, 0) != 1) {
    SSL_CTX_free(ctx);
    printf("Failed to load CA file %s", CA_FILE);
  }
  /*加载服务端证书*/
  if (SSL_CTX_use_certificate_file(ctx, SERVER_CERT, SSL_FILETYPE_PEM) <= 0) {
    ERR_print_errors_fp(stdout);
    exit(1);
  }
  /*加载服务端私钥*/
  if (SSL_CTX_use_PrivateKey_file(ctx, SERVER_KEY, SSL_FILETYPE_PEM) <= 0) {
    printf("use private key fail.\n");
    ERR_print_errors_fp(stdout);
    exit(1);
  }
  /*验证私钥*/
  if (!SSL_CTX_check_private_key(ctx)) {
    ERR_print_errors_fp(stdout);
    exit(1);
  }
  //处理握手多次  
  SSL_CTX_set_mode(ctx, SSL_MODE_AUTO_RETRY); 
  
  if ((sockfd = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
    perror("socket");
    exit(1);
  } else {
    printf("socket created\n");
  }
  
  if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)) < 0){
    printf("setsockopet error\n");
    return -1;
  }
  
  bzero(&my_addr, sizeof(my_addr));
  my_addr.sin_family = PF_INET;
  my_addr.sin_port = htons(myport);
  my_addr.sin_addr.s_addr = INADDR_ANY;
  
  if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)) == -1) {
    perror("bind");
    exit(1);
  } 
  printf("Server bind success.\n");
  
  if (listen(sockfd, lisnum) == -1) {
    perror("listen");
    exit(1);
  } 
  printf("Server begin to listen\n");
  
  while (1) {
    SSL *ssl;
    len = sizeof(struct sockaddr);
    
    if ((new_fd = accept(sockfd, (struct sockaddr *) &their_addr, &len)) == -1) {
      perror("accept");
      exit(errno);
    } 
    
    printf("Server: receive a connection from %s, port %d, socket %d\n", inet_ntoa(their_addr.sin_addr), ntohs(their_addr.sin_port), new_fd);
    
    ssl = SSL_new(ctx);
    if (ssl == NULL) {
      printf("SSL_new error.\n");
    }
    
    SSL_set_fd(ssl, new_fd);
    
    if (SSL_accept(ssl) == -1) {
      perror("accept");
      ERR_print_errors_fp(stderr);  
      close(new_fd);
      printf("something error.\n");
      break;
    }
    printf("Server with %s encryption\n", SSL_get_cipher(ssl));
    
    bzero(buf, MAXBUF + 1);
    strcpy(buf, "server->client");
    len = SSL_write(ssl, buf, strlen(buf));
    if (len <= 0) {
      printf("消息'%s'发送失败！错误代码是%d，错误信息是'%s'\n", buf, errno, strerror(errno));
      goto finish;
    } else {
      printf("消息'%s'发送成功，共发送了%d个字节！\n", buf, len);
    }
    
    bzero(buf, MAXBUF + 1);
    len = SSL_read(ssl, buf, MAXBUF);
    if (len > 0) {
      printf("接收消息成功:'%s'，共%d个字节的数据\n", buf, len);
    } else {
      printf("消息接收失败！错误代码是%d，错误信息是'%s'\n", errno, strerror(errno));
    }
  finish:
    SSL_shutdown(ssl);
    SSL_free(ssl);
    close(new_fd);
  }
  
  close(sockfd);
  SSL_CTX_free(ctx);
  return 0;
}
