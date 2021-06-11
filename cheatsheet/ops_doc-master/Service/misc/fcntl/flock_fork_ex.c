#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

int fd = 0;
int main() {

  int i;
  char path[]="./file.txt";
  extern int errno;
  fd=open(path,O_WRONLY|O_CREAT);
  if(fd!=-1) {
    printf("open file %s. fd:%d.\n",path, fd);
    printf("please input a number to lock the file.\n");
    scanf("%d",&i);
    printf("try lock file:%s...\n", path);

    if(flock(fd,LOCK_EX)==0) {
      printf("the file was locked.\n");
    } else { 
      printf("the file was not locked.\n");
    }

    int pid;
    if ((pid = fork()) < 0) {
      printf("fork failed\n");
      exit(0);
    } else if (pid == 0) { // child
      sleep(5);

      // if(flock(fd,LOCK_SH)==0) {
      //   printf("child add ex success\n");
      // } else { 
      //   printf("child add ex failed\n");
      // }

      if(flock(fd,LOCK_UN)==0) {
        printf("child unlock success.\n");
      } else {
        printf("child unlock fail.\n");
      }
      sleep(5);
    } else { // parent
      int pid2=wait(NULL);  
      printf("end\n");
    }

  } else {
    printf("cannot open file %s/n",path);
    printf("errno:%d\n",errno);
    printf("errMsg:%s\n",strerror(errno));
  }

  return 0;
}