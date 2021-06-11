#include <stdio.h>  
#include <fcntl.h>  
#include <unistd.h>  
#include <stdlib.h>  
  
int main()  
{  
    int fd = open ("data.txt", O_RDWR | O_CREAT | O_TRUNC, 0666);  
    if (fd == -1)  
    {  
    perror ("open");  
    exit (EXIT_FAILURE);  
    }  
  
    struct flock lock;  
    lock.l_type = F_RDLCK;  //定义锁操作的类型为加读锁  
    lock.l_whence = SEEK_SET;  //定义锁区偏移起点为文件头  
    lock.l_start = 10;  //定义锁区从文件头开始计算的偏移 10 个字节  
    lock.l_len = 20;  //定义锁区字节长度为 20 个字节，即只对文件中这 20 个字节进行区域加锁。  
    lock.l_pid = -1;  //定义加锁进程标示为自动设置  
    if (fcntl (fd, F_SETLKW, &lock) == -1) //F_SETLKW 为阻塞模式，是指进程遇锁，将被阻塞直到锁被释放。  
    {  
    perror ("fcntl");  
    exit (EXIT_FAILURE);  
    }  
  
    if (close (fd) == -1)  
    {  
    perror ("close");  
    exit (EXIT_FAILURE);  
    }  
  
    return 0;  
}  