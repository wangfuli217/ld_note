#include "lock_header.h"

int main()  {  
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  
  
    if (fork() == 0)  {  
        int fd_1 = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE); 
        
        cout<<"child try get readw_lock..."<<endl; 
        readw_lock(fd_1);  
        cout<<"child got readw_lock, block parent writew_lock..."<<endl;  
  
        sleep(5);  
  
        close(fd_1);  
        cout<<"close the file descriptor..."<<endl;  
        
        sleep(2); 
        exit(0);  
    }  
  
    sleep(1);  
    
    cout<<"parent try get writew_lock..."<<endl; 
    writew_lock(fd);  
    cout<<"parent got writew_lock..."<<endl;  
    unlock(fd); 
  
    return 0;  
}  