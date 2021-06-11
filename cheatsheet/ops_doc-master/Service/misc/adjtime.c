#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/time.h>
#include <errno.h>
#define DIS(tv) if ( tv != NULL ) printf(" %ld - %ld ",((struct timeval*)tv)->tv_sec, ((struct timeval*)tv)->tv_usec); \
  else printf("NULL - NULL");

void call(struct timeval *para1, struct timeval *para2){
  printf("[INFO] CALL_FUNCTION with : "); DIS(para1); DIS(para2); printf("\n");
  
  if ( adjtime(para1, para2) != 0 )
    {
      printf("[ERROR] failure to adjtime [%s]\n",strerror(errno));
      
    }
  else
    {
      printf("[INFO] success to adjtime : " ); DIS(para1); DIS(para2); printf("\n");
    }
}

void
test (){
  struct timeval delta;
  struct timeval  olddelta;
  
  call(NULL, &olddelta);
  
  delta.tv_sec=200;
  delta.tv_usec=0;
  call(&delta,&olddelta);
}    


int main (void){
  test();
  return 0;
}