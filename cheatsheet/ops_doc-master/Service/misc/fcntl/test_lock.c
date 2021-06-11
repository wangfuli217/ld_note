/************************************************************************* 
  > File Name: test_fcntl.c
  > Author: liuxingen 
  > Mail: liuxingen@nsfocus.com  
  > Created Time: 2014年07月24日 星期四 21时08分32秒 
 ************************************************************************/  


#include "test_fcntl.h"  
int rflag = 0, wflag = 0, tflag = 0;  

void file_lock(int fd)  {  
    pid_t pid;  

    if(wflag && write_lock(fd, 0, SEEK_SET, 1) != -1){      //独占写锁  
        fprintf(stderr, "write_lock success.\n");  
    }else if(wflag){  
        fprintf(stderr, "write_lock error:%s\n", strerror(errno));  
    }  


    if(rflag && read_lock(fd, 0, SEEK_SET, 1) != -1){       //共享读锁  
        fprintf(stderr, "read_lock success.\n");  
    }else if(rflag){  
        fprintf(stderr, "read_lock error:%s\n", strerror(errno));  
    }  


    if(tflag && (pid = is_writelock(fd, 0, SEEK_SET, 1)) > 0){           //测试写锁  
        fprintf(stderr, "cannot add write lock(PID %d have add write or read lock on it)\n", pid);  
    }else if(tflag && pid == 0){  
        fprintf(stderr, "can add write lock\n");  
    }  


    if(tflag && (pid = is_readlock(fd, 0, SEEK_SET, 1)) > 0){        //测试读锁  
        fprintf(stderr, "cannot add read lock(PID %d have add write lock on it)\n", pid);  
    }else if(pid == 0) {  
        fprintf(stderr, "can add read lock\n");  
    }   
}  


int main(int argc, char *argv[]){  
    int fd, opt;  
    while((opt = getopt(argc, argv, "rwt")) != -1){  
        switch(opt){  
        case 'r':  
            rflag = 1;      //read lock  
            break;  
        case 'w':  
            wflag = 1;      //write lock  
            break;  
        case 't':  
            tflag = 1;      //test lock  
            break;  
        default:  
            fprintf(stderr, "Usage: %s -r -w -t\n", argv[0]);  
            return 1;  
        }  
    }  
    if((fd = open("/tmp/file_lock", O_RDWR | O_CREAT, S_IRWXU)) == -1){  
        fprintf(stderr, "creat error:%s\n", strerror(errno));  
        return 1;  
    }  
    file_lock(fd);  
    sleep(15);
    close(fd);  
    return 0;  
}  
