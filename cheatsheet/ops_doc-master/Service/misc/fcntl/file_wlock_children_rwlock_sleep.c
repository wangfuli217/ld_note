#include "lock_header.h"

int main()  {   
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE); 
    
    cout<<"parent try get writew_lock..."<<endl; 
    writew_lock(fd);  
    cout<<"parent got writew_lock..."<<endl; 
    //child  1  
    if (fork() == 0)  {  
        cout<<"child 1 try to get write lock..."<<endl;  
        writew_lock(fd);  
        cout<<"child 1 get write lock..."<<endl;  
  
        unlock(fd);  
        cout<<"child 1 release write lock..."<<endl;  
  
        exit(0);  
    }  
  
    //child 2  
    if (fork() == 0)  {  
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