#include "lock_header.h"

//file_process_lock_next  
int main()  {  
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  

    cout<<"file_process_lock_next wait file_process_lock_prev..."<<endl; 
    writew_lock(fd);  
    cout<<"file_process_lock_next got writew_lock..."<<endl;  
    unlock(fd);  
  
    return 0;  
}  
/* 当关闭文件描述符时，与该文件描述符有关的锁都被释放，同样通过dup拷贝得到的文件描述符也会导致这种情况 */