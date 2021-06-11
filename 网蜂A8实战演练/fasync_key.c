/* 
 * Name:fasync_key.c 
 * Copyright (C) 2014 Webee.JY  (2483053468@qq.com) 
 * 
 * This program is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License version 2 as 
 * published by the Free Software Foundation. 
 */  
#include <linux/device.h>  
#include <linux/interrupt.h>  
#include <linux/module.h>  
#include <linux/kernel.h>  
#include <linux/fs.h>  
#include <linux/init.h>  
#include <linux/irq.h>  
#include <asm/uaccess.h>  
#include <asm/irq.h>  
#include <asm/io.h>  
#include <linux/gpio.h>  
#include <linux/sched.h>  
#include <linux/poll.h>  
#include <linux/fcntl.h>   
  
#define DEVICE_NAME "IRQ_KEY"  
  
struct button_irq_desc {  
    int irq;        /* 中断号 */  
    int pin;        /* GPIO引脚 */  
    int key_val;    /* 按键初始值 */  
    char *name;     /* 名字 */  
};  
  
static struct button_irq_desc button_irqs [] = {  
    {IRQ_EINT(16), S5PV210_GPH2(0), 0x01, "S1"}, /* S1 */  
    {IRQ_EINT(17), S5PV210_GPH2(1), 0x02, "S2"}, /* S2 */  
    {IRQ_EINT(18), S5PV210_GPH2(2), 0x03, "S3"}, /* S3 */  
    {IRQ_EINT(19), S5PV210_GPH2(3), 0x04, "S4"}, /* S4 */  
      
    {IRQ_EINT(24), S5PV210_GPH3(0), 0x05, "S5"}, /* S5 */  
    {IRQ_EINT(25), S5PV210_GPH3(1), 0x06, "S6"}, /* S6 */  
    {IRQ_EINT(26), S5PV210_GPH3(2), 0x07, "S7"}, /* S7 */  
    {IRQ_EINT(27), S5PV210_GPH3(3), 0x08, "S8"}, /* S8 */  
};  
  
static DECLARE_WAIT_QUEUE_HEAD(button_waitq);  
static struct class *irq_key_class;  
  
/* 键值: 按下时, 0x01, 0x02, 0x03, 0x04,0x05,0x06,0x07,0x08 */    
/* 键值: 松开时, 0x81, 0x82, 0x83, 0x84,0x85,0x86,0x87,0x88 */    
static unsigned char key_val;    
  
/* 中断事件标志, 中断服务程序将它置1，irq_key_read将它清0 */  
static volatile int ev_press = 0;  
  
static struct fasync_struct *button_fasync;  
  
/* 中断处理函数 */  
static irqreturn_t key_interrupt(int irq, void *dev_id)  
{  
    struct button_irq_desc *button_irqs = (struct button_irq_desc *)dev_id;  
    unsigned int pinval;  
  
    pinval = gpio_get_value(button_irqs->pin);  
    if (pinval)   
    {         
        /* 松开 */      
        key_val = 0x80 | button_irqs->key_val;     
    }     
    else      
    {         
        /* 按下 */          
        key_val = button_irqs->key_val;  
    }  
      
    ev_press = 1;  
  
     /* 唤醒休眠的进程 */  
    wake_up_interruptible(&button_waitq);  
  
    /* 用kill_fasync函数告诉应用程序，有数据可读了   
     * button_fasync结构体里包含了发给谁(PID指定)  
     * SIGIO  : 表示要发送的信号类型  
     * POLL_IN: 表示发送的原因(有数据可读了)  
     */    
    kill_fasync(&button_fasync, SIGIO, POLL_IN);  
      
    return IRQ_RETVAL(IRQ_HANDLED);  
}  
  
static int irq_key_open(struct inode *inode, struct file *file)  
{  
    int i;  
    int err = 0;  
      
    /* 使用request_irq函数注册中断 */  
    for (i = 0; i < sizeof(button_irqs)/sizeof(button_irqs[0]); i++)  
    {  
        err = request_irq(button_irqs[i].irq, key_interrupt, IRQF_TRIGGER_FALLING|IRQF_TRIGGER_RISING,   
                          button_irqs[i].name, (void *)&button_irqs[i]);  
    }  
    /* 注册中断失败处理 */  
    if (err)  
    {  
        i--;  
        for (; i >= 0; i--)  
        {  
            disable_irq(button_irqs[i].irq);  
            free_irq(button_irqs[i].irq, (void *)&button_irqs[i]);  
        }  
        return -EBUSY;  
    }  
    return 0;  
}  
  
static ssize_t irq_key_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)  
{  
    if (count != 1)       
        return -EINVAL;  
  
    /* 如果没有按键动作, 休眠，即不会马上执行copy_to_user 
     * ev_press = 0时，进程会休眠，当有按键动作时， 
     * 会进入按键中断处理函数，里面将ev_press = 1， 
     * 然后唤醒进程，然后马上执行copy_to_user，继续往下跑。 
     */  
    wait_event_interruptible(button_waitq, ev_press);  
      
    /* 如果有按键动作, 返回键值给应用程序 */  
    copy_to_user(buf, &key_val, 1);  
    ev_press = 0;  
      
    return 1;  
}  
  
static int irq_key_close(struct inode *inode, struct file *file)  
{  
    int i;  
  
    /* 注销中断 */  
    for (i = 0; i < sizeof(button_irqs)/sizeof(button_irqs[0]); i++)  
    {  
        free_irq(button_irqs[i].irq, (void *)&button_irqs[i]);  
    }  
  
    return 0;  
}  
  
static unsigned irq_key_poll(struct file *file, poll_table *wait)  
{  
    unsigned int mask = 0;  
  
    /* 该函数，只是将进程挂在button_waitq队列上，而不是立即休眠 */   
    poll_wait(file, &button_waitq, wait);   
  
    /* 当没有按键按下时，即不会进入按键中断处理函数，此时ev_press = 0   
     * 当按键按下时，就会进入按键中断处理函数，此时ev_press被设置为1  
     */    
    if (ev_press)  
        mask |= POLLIN | POLLRDNORM;    /* POLLIN表示有数据可读 */  
  
    /* 如果有按键按下时，mask |= POLLIN | POLLRDNORM,否则mask = 0 */   
    return mask;  
}  
  
/* 当应用程序调用了fcntl(fd, F_SETFL, Oflags | FASYNC);   
 * 则最终会调用驱动的fasync函数，在这里则是irq_key_fasync  
 * irq_key_fasync最终又会调用到驱动的fasync_helper函数  
 * fasync_helper函数的作用是初始化/释放fasync_struct结构体  
 */    
static int irq_key_fasync(int fd, struct file *filp, int on)    
{    
    return fasync_helper(fd, filp, on, &button_fasync);    
}    
  
static struct file_operations irq_key_fops = {  
    .owner   =  THIS_MODULE,      
    .open    =  irq_key_open,       
    .read    =  irq_key_read,        
    .release =  irq_key_close,     
    .poll    =  irq_key_poll,  
    .fasync  =  irq_key_fasync,   
};  
  
int major;  
static int __init Irq_key_init(void)  
{  
    /* 注册一个字符设备 */  
    major = register_chrdev(0, "key_drv", &irq_key_fops);  
  
    /* 成功创建类后，可在/sys/class/目录下找到key_drv类 */  
    irq_key_class = class_create(THIS_MODULE, "key_drv");  
  
    /* 在key_drv类下创建/dev/IRQ_KEY 设备，供应用程序打开设备*/  
    device_create(irq_key_class, NULL, MKDEV(major, 0), NULL, DEVICE_NAME);   
  
    return 0;  
}  
  
static void Irq_key_exit(void)  
{  
    unregister_chrdev(major, "key_drv");  
    device_destroy(irq_key_class, MKDEV(major, 0));  
    class_destroy(irq_key_class);  
}  
  
  
module_init(Irq_key_init);  
  
module_exit(Irq_key_exit);  
  
MODULE_LICENSE("GPL");  
MODULE_AUTHOR("webee");  
MODULE_DESCRIPTION("Character drivers for irq key");