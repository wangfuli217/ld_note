#include "lock_header.h"

int main()  
{  
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  
    cout<<"parent try get readw_lock..."<<endl; 
    readw_lock(fd);  
    cout<<"parent got readw_lock..."<<endl; 
    
    //child  1  
    if (fork() == 0)  
    {  
        cout<<"child 1 try to get write lock..."<<endl;  
        writew_lock(fd);  
        cout<<"child 1 get write lock..."<<endl;  
  
        unlock(fd);  
        cout<<"child 1 release write lock..."<<endl;  
  
        exit(0);  
    }  
  
    //child 2  
    if (fork() == 0)  
    {  
        sleep(3);  
  
        cout<<"child 2 try to get read lock..."<<endl;  
        readw_lock(fd);  
        cout<<"child 2 get read lock..."<<endl;  
  
        unlock(fd);  
        cout<<"child 2 release read lock..."<<endl;  
        exit(0);  
    }  
  
    sleep(10);  
    unlock(fd);  
  
    return 0;  
}  
/*
测试1：父进程获得对文件的读锁，然后子进程1请求加写锁，随即进入睡眠，然后子进程2请求读锁，看进程2是否能够获得读锁。
可知在有写入进程等待的情况下，对于读出进程的请求，系统会一直给予的。那么这也就可能导致写入进程饿死的局面。
 */