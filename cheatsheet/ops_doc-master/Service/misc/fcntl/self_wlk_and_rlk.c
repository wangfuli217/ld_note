#include "lock_header.h"

int main(){   
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);
    
    cout<<"self call try writew_lock"<<endl; 
    writew_lock(fd); 
    cout<<"self called writew_lock"<<endl; 
    
    // writew_lock(fd);  // override previous writew_lock; not waiting
    // readw_lock(fd);   // override previous writew_lock; not waiting
    cout<<"self call lock_test(F_WRLCK)"<<endl; 
    cout<<lock_test(fd, F_WRLCK, SEEK_SET, 0, 0)<<endl; 
    cout<<"self call lock_test(F_RDLCK)"<<endl;     
    cout<<lock_test(fd, F_RDLCK, SEEK_SET, 0, 0)<<endl;  
    
    cout<<"self call unlock"<<endl; 
    unlock(fd);         // process exit; lock release; close fd
  
    return 0;  
}  
/* 如果一个进程对一个文件区间已经有了一把锁，后来该进程又试图在同一文件区间再加一把锁，那么新锁将会覆盖老锁 */