#include "lock_header.h"

int main() { 
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  
    cout<<"parent call try writew_lock "<<endl;
    writew_lock(fd);  
    cout<<"parent called writew_lock, block children writew_lock"<<endl;
  
    if (fork() == 0)  {  
        cout<<lock_test(fd, F_WRLCK, SEEK_SET, 0, 0)<<endl;  
        cout<<lock_test(fd, F_RDLCK, SEEK_SET, 0, 0)<<endl;  
  
        exit(0);  
    }  
  
    sleep(3);  
    unlock(fd);  
  
    return 0;  
}
