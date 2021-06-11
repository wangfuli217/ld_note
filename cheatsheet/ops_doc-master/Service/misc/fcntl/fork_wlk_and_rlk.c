#include "lock_header.h"

int main()  {
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  
    cout<<"parent call try writew_lock "<<endl;
    writew_lock(fd);   // child can't F_WRLCK|F_RDLCK
    cout<<"parent called writew_lock, block children writew_lock"<<endl;
    // readw_lock(fd); // child can't F_WRLCK; child can F_RDLCK
    
    if (fork() == 0)  {  
        cout<<lock_test(fd, F_WRLCK, SEEK_SET, 0, 0)<<endl;  
        cout<<lock_test(fd, F_RDLCK, SEEK_SET, 0, 0)<<endl;  
        cout<<"child call try writew_lock waiting for parent call unlock"<<endl;
        writew_lock(fd);  // waiting for parent unlock or exit
        cout<<"child called writew_lock continue calling exit"<<endl;
        exit(0);  
    }  
    cout<<"parent call sleep, block children writew_lock"<<endl; 
    sleep(3);  
    cout<<"parent call unlock, resume children writew_lock"<<endl; 
    unlock(fd);  

    return 0;  
}  
/* 不同进程不能对已加写锁的同一文件区间，获得加锁权限 writew_lock */
/* 不同进程能对已加读锁的同一文件区间，能获得读加锁权限^不能获得写锁权限 readw_lock */
/* 加锁时，该进程必须对该文件有相应的文件访问权限，即加读锁，该文件必须是读打开，加写锁时，该文件必须是写打开 */