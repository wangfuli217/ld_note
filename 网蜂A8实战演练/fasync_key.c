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
    int irq;        /* �жϺ� */  
    int pin;        /* GPIO���� */  
    int key_val;    /* ������ʼֵ */  
    char *name;     /* ���� */  
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
  
/* ��ֵ: ����ʱ, 0x01, 0x02, 0x03, 0x04,0x05,0x06,0x07,0x08 */    
/* ��ֵ: �ɿ�ʱ, 0x81, 0x82, 0x83, 0x84,0x85,0x86,0x87,0x88 */    
static unsigned char key_val;    
  
/* �ж��¼���־, �жϷ����������1��irq_key_read������0 */  
static volatile int ev_press = 0;  
  
static struct fasync_struct *button_fasync;  
  
/* �жϴ����� */  
static irqreturn_t key_interrupt(int irq, void *dev_id)  
{  
    struct button_irq_desc *button_irqs = (struct button_irq_desc *)dev_id;  
    unsigned int pinval;  
  
    pinval = gpio_get_value(button_irqs->pin);  
    if (pinval)   
    {         
        /* �ɿ� */      
        key_val = 0x80 | button_irqs->key_val;     
    }     
    else      
    {         
        /* ���� */          
        key_val = button_irqs->key_val;  
    }  
      
    ev_press = 1;  
  
     /* �������ߵĽ��� */  
    wake_up_interruptible(&button_waitq);  
  
    /* ��kill_fasync��������Ӧ�ó��������ݿɶ���   
     * button_fasync�ṹ��������˷���˭(PIDָ��)  
     * SIGIO  : ��ʾҪ���͵��ź�����  
     * POLL_IN: ��ʾ���͵�ԭ��(�����ݿɶ���)  
     */    
    kill_fasync(&button_fasync, SIGIO, POLL_IN);  
      
    return IRQ_RETVAL(IRQ_HANDLED);  
}  
  
static int irq_key_open(struct inode *inode, struct file *file)  
{  
    int i;  
    int err = 0;  
      
    /* ʹ��request_irq����ע���ж� */  
    for (i = 0; i < sizeof(button_irqs)/sizeof(button_irqs[0]); i++)  
    {  
        err = request_irq(button_irqs[i].irq, key_interrupt, IRQF_TRIGGER_FALLING|IRQF_TRIGGER_RISING,   
                          button_irqs[i].name, (void *)&button_irqs[i]);  
    }  
    /* ע���ж�ʧ�ܴ��� */  
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
  
    /* ���û�а�������, ���ߣ�����������ִ��copy_to_user 
     * ev_press = 0ʱ�����̻����ߣ����а�������ʱ�� 
     * ����밴���жϴ����������潫ev_press = 1�� 
     * Ȼ���ѽ��̣�Ȼ������ִ��copy_to_user�����������ܡ� 
     */  
    wait_event_interruptible(button_waitq, ev_press);  
      
    /* ����а�������, ���ؼ�ֵ��Ӧ�ó��� */  
    copy_to_user(buf, &key_val, 1);  
    ev_press = 0;  
      
    return 1;  
}  
  
static int irq_key_close(struct inode *inode, struct file *file)  
{  
    int i;  
  
    /* ע���ж� */  
    for (i = 0; i < sizeof(button_irqs)/sizeof(button_irqs[0]); i++)  
    {  
        free_irq(button_irqs[i].irq, (void *)&button_irqs[i]);  
    }  
  
    return 0;  
}  
  
static unsigned irq_key_poll(struct file *file, poll_table *wait)  
{  
    unsigned int mask = 0;  
  
    /* �ú�����ֻ�ǽ����̹���button_waitq�����ϣ��������������� */   
    poll_wait(file, &button_waitq, wait);   
  
    /* ��û�а�������ʱ����������밴���жϴ���������ʱev_press = 0   
     * ����������ʱ���ͻ���밴���жϴ���������ʱev_press������Ϊ1  
     */    
    if (ev_press)  
        mask |= POLLIN | POLLRDNORM;    /* POLLIN��ʾ�����ݿɶ� */  
  
    /* ����а�������ʱ��mask |= POLLIN | POLLRDNORM,����mask = 0 */   
    return mask;  
}  
  
/* ��Ӧ�ó��������fcntl(fd, F_SETFL, Oflags | FASYNC);   
 * �����ջ����������fasync����������������irq_key_fasync  
 * irq_key_fasync�����ֻ���õ�������fasync_helper����  
 * fasync_helper�����������ǳ�ʼ��/�ͷ�fasync_struct�ṹ��  
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
    /* ע��һ���ַ��豸 */  
    major = register_chrdev(0, "key_drv", &irq_key_fops);  
  
    /* �ɹ�������󣬿���/sys/class/Ŀ¼���ҵ�key_drv�� */  
    irq_key_class = class_create(THIS_MODULE, "key_drv");  
  
    /* ��key_drv���´���/dev/IRQ_KEY �豸����Ӧ�ó�����豸*/  
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