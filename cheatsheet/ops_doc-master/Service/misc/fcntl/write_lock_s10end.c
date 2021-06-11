#include <stdio.h>  
#include <fcntl.h>  
#include <unistd.h>  
#include <stdlib.h>  
#include <errno.h>  
  
int main()  
{  
    int fd = open ("data.txt", O_RDWR | O_CREAT | O_TRUNC, 0666);  
    if (fd == -1)  
    {  
        perror ("open");  
        exit (EXIT_FAILURE);  
    }  
  
    struct flock lock;  
    lock.l_type = F_WRLCK;  //定义锁操作的类型为加写锁  
    lock.l_whence = SEEK_CUR;  //定义锁区偏移起点为文件当前位置  
    lock.l_start = 10;  //定义锁区从文件头开始计算的偏移 10 个字节  
    lock.l_len = 0;  //定义锁区字节长度到文件结尾，即仅文件开头的 10 个字节不加锁  
    lock.l_pid = -1;  //定义加锁进程标识为自动设置  
    if (fcntl (fd, F_SETLK, &lock) == -1)  //F_SETLK 为非阻塞模式，是指进程遇锁，立即以错误返回，并设错误码为EAGAIN  
    {  
        if (errno != EAGAIN)  
        {  
            perror ("fcntl");  
            exit (EXIT_FAILURE);  
        }  
        printf ("暂时不能加锁，稍后再试...\n");  
    }  
  
    if (close (fd) == -1)  
    {  
        perror ("close");  
        exit (EXIT_FAILURE);  
    }  
  
    return 0;  
}  