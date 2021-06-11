#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include "pthread.h"
#include <openssl/rsa.h>
#include <openssl/crypto.h>
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

#define CERTF "server/server-cert.pem"  
#define KEYF  "server/server-key.pem"  
#define CAFILE  "ca/ca-cert.pem"  
#define SOCKET int
#define SOCKET_ERROR -1
  
pthread_mutex_t  mlock=PTHREAD_MUTEX_INITIALIZER;  
static pthread_mutex_t *lock_cs;  
static long *lock_count;  
#define CHK_NULL(x) if ((x)==NULL) { printf("null\n"); }  
#define CHK_ERR(err,s) if ((err)==-1) { printf(" -1 \n"); }  
#define CHK_SSL(err) if ((err)==-1) {  printf(" -1 \n");}  

int verify_callback_server(int ok, X509_STORE_CTX *ctx)  
{  
  printf("verify_callback_server \n");  
  return ok;  
}  
  
int SSL_CTX_use_PrivateKey_file_pass(SSL_CTX *ctx,char *filename,char *pass){  
  EVP_PKEY  *pkey=NULL;  
  BIO       *key=NULL;  

  key=BIO_new(BIO_s_file());  
  BIO_read_filename(key,filename);  
  pkey=PEM_read_bio_PrivateKey(key,NULL,NULL,pass);  
  if(pkey==NULL){  
    printf("PEM_read_bio_PrivateKey err");  
    return -1;  
  }  
  
  if (SSL_CTX_use_PrivateKey(ctx,pkey) <= 0) {  
    printf("SSL_CTX_use_PrivateKey err\n");
    return -1;  
  }
  
  BIO_free(key);  
  return 1;  
} 
  
static int s_server_verify=SSL_VERIFY_NONE;  
void * thread_main(void *arg){   
  SOCKET s;
  SOCKET AcceptSocket;  
  struct sockaddr_in  service;  
  int    err;  
  size_t client_len;         
  SSL_CTX *ctx;
  SSL *ssl;
  X509 *client_cert;  
  char *str;
  char buf[1024];
  SSL_METHOD *method;  
  
  ssl=(SSL *)arg;
  s=SSL_get_fd(ssl);
  err = SSL_accept(ssl);
  if(err<0){
    printf("ssl accerr\n");
    //return;
  }
  printf("SSL connection using %s\n", SSL_get_cipher (ssl));
  client_cert = SSL_get_peer_certificate (ssl);
  if (client_cert != NULL){
    printf ("Client certificate:\n");
    str = X509_NAME_oneline (X509_get_subject_name (client_cert), 0, 0);
    CHK_NULL(str);
    printf ("\t subject: %s\n", str);  
    OPENSSL_free(str);  
    str = X509_NAME_oneline (X509_get_issuer_name  (  client_cert), 0, 0);
    CHK_NULL(str);
    printf ("\t issuer: %s\n", str);  
    OPENSSL_free (str);  
    X509_free (client_cert);  
  }else  
    printf ("Client does not have certificate.\n");
  
  while(1) {
    memset(buf,0,1024);
    err = SSL_read(ssl, buf, sizeof(buf) - 1);
    if(err<0){
      printf("ssl read err\n");  
      //closesocket(s);  
      close(s);  
      //return;  
    }else if(err>0){
      printf("server get : %s\n",buf);
#if 1
      buf[err] = '\0';
      err = SSL_write(ssl, buf, strlen(buf));
      CHK_SSL(err);
#endif  
    }else{
      printf("some client is gone...\n");  
      break;  
    }  
  }  
  SSL_free (ssl);  
  //closesocket(s);  
  close(s);  
} 
  
pthread_t pthreads_thread_id(void){  
  pthread_t ret;
  ret=pthread_self();
  return(ret);
}  
  
void pthreads_locking_callback(int mode, int type, char *file, int line) { 
  if (mode & CRYPTO_LOCK) {  
      pthread_mutex_lock(&(lock_cs[type]));  
      lock_count[type]++;  
  }else {  
    pthread_mutex_unlock(&(lock_cs[type]));  
  }  
}
  
int main (){
  int err;                
  int i;
  SOCKET s;
  SOCKET AcceptSocket;
  struct sockaddr_in  service;
  pthread_t pid;
  size_t  client_len;  
  SSL_CTX *ctx;  
  SSL *ssl;  
  X509 *client_cert;  
  char *str;  
  char buf[1024];  
  const SSL_METHOD     *method;  
  
  SSL_load_error_strings();
  SSLeay_add_ssl_algorithms();
  method = TLS_server_method();
  ctx = SSL_CTX_new (method);
  if (!ctx){
    ERR_print_errors_fp(stderr);  
    exit(2);  
  }  

  if ((!SSL_CTX_load_verify_locations(ctx,CAFILE,NULL))||(!SSL_CTX_set_default_verify_paths(ctx))){  
    printf("err\n");  
    exit(1);  
  }

  if (SSL_CTX_use_certificate_file(ctx, CERTF, SSL_FILETYPE_PEM) <= 0){
           ERR_print_errors_fp(stderr);
           exit(3);
  }

  if (SSL_CTX_use_PrivateKey_file_pass(ctx,KEYF,"robot") <= 0){  
    ERR_print_errors_fp(stderr);
    exit(4);
  }

  if (!SSL_CTX_check_private_key(ctx)){  
    fprintf(stderr,"Private key does not match the certificate public key\n");
    exit(5);
  }
  
  s_server_verify=SSL_VERIFY_PEER|SSL_VERIFY_FAIL_IF_NO_PEER_CERT|  
                                SSL_VERIFY_CLIENT_ONCE;  
  SSL_CTX_set_verify(ctx,s_server_verify,verify_callback_server);  
  SSL_CTX_set_client_CA_list(ctx,SSL_load_client_CA_file(CAFILE));  
  
  s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);  
  if(s<0) return -1;  

  service.sin_family = AF_INET;  
  service.sin_addr.s_addr = inet_addr("127.0.0.1");  
  service.sin_port = htons(11111);  
  //if (bind( s, (SOCKADDR*) &service, sizeof(service)) == SOCKET_ERROR)  
  if (bind( s, (struct sockaddr *) &service, sizeof(service)) == SOCKET_ERROR){
    printf("bind() failed.\n");
    // closesocket(s);
    close(s);
    return -1;
  }
  if (listen( s, 1 ) == SOCKET_ERROR)
    printf("Error listening on socket.\n");

  printf("recv .....\n");
  lock_cs=OPENSSL_malloc(CRYPTO_num_locks() * sizeof(pthread_mutex_t));
  lock_count=OPENSSL_malloc(CRYPTO_num_locks() * sizeof(long));
  for (i=0; i<CRYPTO_num_locks(); i++){
      lock_count[i]=0;  
      pthread_mutex_init(&(lock_cs[i]),NULL);  
    }
  CRYPTO_set_id_callback((unsigned long (*)())pthreads_thread_id);
  CRYPTO_set_locking_callback((void (*)())pthreads_locking_callback);
  while(1){
    struct timeval tv;  
    fd_set fdset;  
    tv.tv_sec = 1;  
    tv.tv_usec = 0;  
    FD_ZERO(&fdset);  
    FD_SET(s, &fdset);  
    select(s+1, &fdset, NULL, NULL, (struct timeval *)&tv);  
    if(FD_ISSET(s, &fdset)){  
      AcceptSocket=accept(s, NULL,NULL);
      ssl = SSL_new(ctx);
      CHK_NULL(ssl);
      err=SSL_set_fd(ssl, AcceptSocket);
      if(err>0){
	err=pthread_create(&pid, NULL, &thread_main, (void *)ssl);
	pthread_detach(pid);
      }else
	continue;
    }
  }

  SSL_CTX_free(ctx);
  return 0;
}
