#ifndef __CSLUNATIC_H__
#define __CSLUNATIC_H__

#include <linux/cdev.h>
#include <linux/semaphore.h>
#include <linux/wait.h>
#include <linux/fs.h>

#define CSLUNATIC_DEVICE_NODE_NAME  "CSlunatic"
#define CSLUNATIC_DEVICE_FILE_NAME  "CSlunatic"
#define CSLUNATIC_DEVICE_PROC_NAME  "CSlunatic"
#define CSLUNATIC_DEVICE_CLASS_NAME "CSlunatic"

#define MAX_FIFO_BUF 16         //缓冲区的大小

struct CSlunatic_char_dev {    
    int val;    
    int timer_interval;
    struct semaphore sem;/*信号量*/
    struct timer_list  timer;/*定时器*/
    unsigned char buf[MAX_FIFO_BUF];   //缓冲区  
    unsigned int current_len;
    wait_queue_head_t r_wait;/*读等待队列*/
    wait_queue_head_t w_wait; /*写等待队列*/
    struct cdev dev;/*字符设备结构体*/
    struct fasync_struct *async_queue;/*异步结构体指针，用于读*/
};

#endif