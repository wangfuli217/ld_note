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

#define MAX_FIFO_BUF 16         //�������Ĵ�С

struct CSlunatic_char_dev {    
    int val;    
    int timer_interval;
    struct semaphore sem;/*�ź���*/
    struct timer_list  timer;/*��ʱ��*/
    unsigned char buf[MAX_FIFO_BUF];   //������  
    unsigned int current_len;
    wait_queue_head_t r_wait;/*���ȴ�����*/
    wait_queue_head_t w_wait; /*д�ȴ�����*/
    struct cdev dev;/*�ַ��豸�ṹ��*/
    struct fasync_struct *async_queue;/*�첽�ṹ��ָ�룬���ڶ�*/
};

#endif