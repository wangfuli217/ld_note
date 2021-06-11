#include <stdio.h>  
#include <fcntl.h>  
#include <unistd.h>  
#include <stdlib.h>  
  
//打印不能加锁的具体原因  
void why_not (struct flock* lock)  
{  
    printf ("%d进程", lock->l_pid);  
    switch (lock->l_whence)  
    {  
        case SEEK_SET:  
            printf ("在距文件头");  
            break;  
        case SEEK_CUR:  
            printf ("在距当前位置");  
            break;  
        case SEEK_END:  
            printf ("在距文件尾");  
            break;  
    }  
    printf ("%ld字节处，为%ld字节加了", lock->l_start, lock->l_len);  
    switch (lock->l_type)  
    {  
        case F_RDLCK:  
            printf ("读锁。\n");  
            break;  
        case F_WRLCK:  
            printf ("写锁。\n");  
            break;   
    }  
}  
  
int main()  
{  
    int fd = open ("data.txt", O_RDWR, 0666);  
    if (fd == -1)  
    {  
        perror ("open");  
        exit (EXIT_FAILURE);  
    }  
  
    struct flock lock;  
    lock.l_type = F_RDLCK;  
    lock.l_whence = SEEK_SET;  
    lock.l_start = 10;  
    lock.l_len = 20;  
    lock.l_pid = -1;  
    //使用函数 fcntl 测试给定文件的特定区域是否可以加锁  
    if (fcntl (fd, F_GETLK, &lock) == -1)  
    {  
        perror ("fcntl");  
        exit (EXIT_FAILURE);  
    }  
    if (lock.l_type == F_UNLCK) //判断能否加锁，在不能加锁的情况下，打印原因  
        printf ("此锁可加！\n");  
    else  
        why_not (&lock);  
  
    if (close (fd) == -1)  
    {  
        perror ("close");  
        exit (EXIT_FAILURE);  
    }  
  
    return 0;  
}  
