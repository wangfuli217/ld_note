#include "lock_header.h"

//file_process_lock_prev 
int main()  {  
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  
    
    cout<<"file_process_lock_prev call writew_lock..."<<endl; 
    writew_lock(fd);  
    cout<<"file_process_lock_prev continue call sleep, block file_process_lock_next writew_lock"<<endl;  
    
    sleep(10); // block file_process_lock_next process continue; wait for 10 second
  
    cout<<"file_process_lock_prev exit, resume file_process_lock_next... "<<endl;  
    return 0;  
}
/* 当关闭文件描述符时，与该文件描述符有关的锁都被释放，同样通过dup拷贝得到的文件描述符也会导致这种情况 */
  
