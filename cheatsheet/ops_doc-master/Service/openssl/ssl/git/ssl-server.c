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

#define CERTF "server/server-cert.pem"  
#define KEYF  "server/server-key.pem"  

#define MAXBUF 1024 

int main(int argc, char * *argv) 
{
  int sockfd, new_fd;
  socklen_t len;
  struct sockaddr_in my_addr, their_addr;
  unsigned int myport, lisnum;
  char buf[MAXBUF + 1];
  SSL_CTX * ctx;

  myport = 11111;
  lisnum = 128;
 
  SSL_library_init();
  OpenSSL_add_all_algorithms();
  SSL_load_error_strings();
  ctx = SSL_CTX_new(SSLv23_server_method());

  if (ctx == NULL){
    ERR_print_errors_fp(stdout);
    exit(1);
  }

  if (SSL_CTX_use_certificate_file(ctx, CERTF, SSL_FILETYPE_PEM) <= 0) {
    ERR_print_errors_fp(stdout);
    exit(1);
  }

  if (SSL_CTX_use_PrivateKey_file(ctx, KEYF, SSL_FILETYPE_PEM) <= 0){
    ERR_print_errors_fp(stdout);
    exit(1);
  }

  if (!SSL_CTX_check_private_key(ctx)){
    ERR_print_errors_fp(stdout);
    exit(1);
  }

  if ((sockfd = socket(PF_INET, SOCK_STREAM, 0)) == -1){
    perror("socket");
    exit(1);
  } else {
    printf("socket created\n");
  }

  bzero( &my_addr, sizeof(my_addr));
  my_addr.sin_family = PF_INET;
  my_addr.sin_port = htons(myport);
    
  if (0){
    my_addr.sin_addr.s_addr = inet_addr(argv[3]);
  } else {
    my_addr.sin_addr.s_addr = INADDR_ANY;
  }
  if (bind(sockfd, (struct sockaddr * ) &my_addr, sizeof(struct sockaddr)) == -1) {
    perror("bind");
    exit(1);
  } else{
    printf("binded\n");
  }
  
  if (listen(sockfd, lisnum) == -1){
    perror("listen");
    exit(1);
  } else {
    printf("begin listen\n");
  }
  while (1){
    SSL * ssl;
    len = sizeof(struct sockaddr);
    
    if ((new_fd = accept(sockfd, (struct sockaddr * ) & their_addr, &len)) == -1) {
      perror("accept");
      exit(errno);
    }  else {
      printf("server: got connection from %s, port %d, socket %d\n", inet_ntoa(their_addr.sin_addr), ntohs(their_addr.sin_port), new_fd);
    }
    
    ssl = SSL_new(ctx);
    SSL_set_fd(ssl, new_fd);
    
    if (SSL_accept(ssl) == -1) {
      perror("accept");
      close(new_fd);
      break;
    }
    
    bzero(buf, MAXBUF + 1);
    strcpy(buf, "server->client");
    
    len = SSL_write(ssl, buf, strlen(buf));
    if (len <= 0) {
      printf("message '%s'send failed, error code is%d,err msgis '%s'\n", buf, errno, strerror(errno));
      goto finish;
    }  else {
      printf("message '%s'send ok, and %d bytes is sent\n", buf, len);
    }
    
    bzero(buf, MAXBUF + 1);
    len = SSL_read(ssl, buf, MAXBUF);
    if (len > 0) {
      printf("receive ok:'%s',%d bytes\n", buf, len);
    } else {
      printf("receive error, code is %d, err msg is '%s'\n", errno, strerror(errno));
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
