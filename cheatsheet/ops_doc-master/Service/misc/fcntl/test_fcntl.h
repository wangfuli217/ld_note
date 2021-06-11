/************************************************************************* 
    > File Name: test_fcntl.h
    > Author: liuxingen 
    > Mail: liuxingen@nsfocus.com  
    > Created Time: 2014年08月02日 星期六 21时39分07秒 
 ************************************************************************/  
#include<stdio.h>  
#include<stdlib.h>  
#include<sys/types.h>  
#include<fcntl.h>  
#include<unistd.h>  
#include<string.h>  
#include<errno.h>  
  
pid_t test_lock(int fd, int type, off_t offset, int whence, off_t len);  
int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len);  
  
#define read_lock(fd, offset, whence, len) \  
        lock_reg(fd, F_SETLK, F_RDLCK, offset, whence, len)  
  
#define readw_lock(fd, offset, whence, len)\  
        lock_reg(fd, F_SETLKW, F_RDLCK, offset, whence, len)  
  
#define write_lock(fd, offset, whence, len)\  
        lock_reg(fd, F_SETLK, F_WRLCK, offset, whence, len)  
  
#define writew_lock(fd, offset, whence, len)\  
        lock_reg(fd, F_SETLKW, F_WRLCK, offset, whence, len)  
  
#define un_lock(fd, offset, whence, len)\  
        lock_reg(fd, F_SETLK, F_UNLCK, offset, whence, len)  
  
#define is_readlock(fd, offset, whence, len)\  
        test_lock(fd, F_RDLCK, offset, whence, len)  
  
#define is_writelock(fd, offset, whence, len)\  
        test_lock(fd, F_WRLCK, offset, whence, len)  