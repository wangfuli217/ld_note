/************************************************************************* 
> File Name: test_fcntl.c
> Author: liuxingen 
> Mail: liuxingen@nsfocus.com  
> Created Time: 2014年07月24日 星期四 21时08分32秒 
************************************************************************/  
  
#include "file_lock.h"  
  
int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len)  {  
    struct flock lock;  
  
    lock.l_type = type;  
    lock.l_start = offset;  
    lock.l_whence = whence;  
    lock.l_len = len;  
    return fcntl(fd, cmd, &lock);  
}  
  
  
/* 
* 测试锁 
* @retval: 
*          -1:error 
*          0:无锁 
*          >0:锁进程ID 
*/  
pid_t test_lock(int fd, int type, off_t offset, int whence, off_t len)  {  
    struct flock lock;  
    lock.l_type = type;  
    lock.l_start = offset;  
    lock.l_whence = whence;  
    lock.l_len = len;  
  
    if(fcntl(fd, F_GETLK, &lock) < 0)  {  
        return (pid_t)-1;  
    }  
  
    if(lock.l_type == F_UNLCK){  
        return (pid_t)0;  
    }  
    return lock.l_pid;  
}  