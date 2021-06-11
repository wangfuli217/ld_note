#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <asm/uaccess.h>
#include <asm/irq.h>
#include <asm/io.h>
#include <linux/device.h>

#define DEVICE_NAME "LED"

#define S5PV210_GPJ2_0_OUTP (1<<0)
#define S5PV210_GPJ2_1_OUTP (1<<4)
#define S5PV210_GPJ2_2_OUTP (1<<8)
#define S5PV210_GPJ2_3_OUTP (1<<12)

static struct class *led_class;
static struct device *led_device;
int major;

static volatile unsigned long *gpj2con = NULL;
static volatile unsigned long *gpj2dat = NULL;

/*Ӧ�ó���ִ��opnʱ�����յ��õ����������webee2_led_open*/
static int webee210_led_open(struct inode *inode, struct file *filp)
{
    printk("webee210_led_open\n");
    
    /* webee210�������LED1,LED2,LED3,LED4
    *  ��ӦGPJ2_0,GPJ2_1,GPJ2_2,GPJ2_3����
    *  ����GPJ2_0,GPJ2_1,GPJ2_2,GPJ2_3,Ϊ���
    */ 
    *gpj2con |= S5PV210_GPJ2_0_OUTP|S5PV210_GPJ2_1_OUTP|S5PV210_GPJ2_2_OUTP|S5PV210_GPJ2_3_OUTP;
    return 0;
}

/* Ӧ�ó���ִ��writeʱ�����յ������������webee210_led_write���� */
static ssize_t webee210_led_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
{
    int val;
    printk("webee210_led_write\n");
    
    if(copy_from_user(&val, buffer, count))
		return -EINVAL;
	
    if(val == 1)
    {
        /* ��� */
        *gpj2dat &= ~((1<<0) | (1<<1) | (1<<2) | (1<<3));
    }
    else
    {
        /* ��� */
        *gpj2dat |= ((1<<0) | (1<<1) | (1<<2) | (1<<3));
    }
    return 0;
}

static const struct file_operations led_fops = {
    .owner  = THIS_MODULE,
    .open   = webee210_led_open,
    .write  = webee210_led_write,
};

/* �����������ں��� */
static int __init webee210_led_init(void)
{
    /* ע���ַ��豸����һ����������Ϊ0��ʾ��ϵͳ�Զ��������豸�� */
    major = register_chrdev(0, "led_drv", &led_fops);
    
    /* ����led_drv�� */
    led_class = class_create(THIS_MODULE, "led_drv");
    
    /*��led_drv���´���/dev/LED�豸����Ӧ�ó�����豸 */
    led_device = device_create(led_class, NULL, MKDEV(major,0), NULL, DEVICE_NAME);
    
    /* �������ַӳ��Ϊ�����ַ */
    gpj2con = (volatile unsigned long*)ioremap(0xE200280, 16);
    gpj2dat = gpj2con + 1;
    return 0;
    
}

/* ��������ĳ��ں��� */
static void __exit webee210_led_exit(void)
{
    unregister_chrdev(major, "led_drv");
    device_unregister(led_device);
    class_destroy(led_class);
    iounmap(gpj2con);
}

module_init(webee210_led_init);
module_exit(webee210_led_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("webee");
MODULE_DESCRIPTION("Character drivers for leds"); 