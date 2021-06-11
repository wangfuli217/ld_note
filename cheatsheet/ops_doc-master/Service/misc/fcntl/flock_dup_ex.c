#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

int main() {
  int test_close = 0;
  int fd,i;
  char path[]="file.txt";
  extern int errno;
  fd = open(path,O_WRONLY|O_CREAT);
  if(fd!=-1) {
    printf("open file %s .\n",path);
    printf("please input a number to lock the file.\n");
    scanf("%d",&i);
    printf("try lock file:%s...\n", path);

    if(flock(fd,LOCK_EX)==0) {
      printf("the file was locked.\n");
    } else { 
      printf("the file was not locked.\n");
    }

    int fd1 = dup(fd);
    printf("fd:%d has dup, new fd:%d\n", fd, fd1);
    sleep(5);
    if (!test_close) {
      if(flock(fd,LOCK_UN)==0) {
        printf("unlock success\n");
      } else {
        printf("unlock fail\n");
      }
    } else {
      close(fd);
      printf("fd:%d has closed\n", fd);
    }

    sleep(5);
  } else {
    printf("cannot open file %s/n",path);
    printf("errno:%d\n",errno);
    printf("errMsg:%s\n",strerror(errno));
  }

  printf("end\n");
  return 0;
}