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

/*应用程序执行opn时，最终调用到驱动程序的webee2_led_open*/
static int webee210_led_open(struct inode *inode, struct file *filp)
{
    printk("webee210_led_open\n");
    
    /* webee210开发板的LED1,LED2,LED3,LED4
    *  对应GPJ2_0,GPJ2_1,GPJ2_2,GPJ2_3引脚
    *  配置GPJ2_0,GPJ2_1,GPJ2_2,GPJ2_3,为输出
    */ 
    *gpj2con |= S5PV210_GPJ2_0_OUTP|S5PV210_GPJ2_1_OUTP|S5PV210_GPJ2_2_OUTP|S5PV210_GPJ2_3_OUTP;
    return 0;
}

/* 应用程序执行write时，最终调用驱动程序的webee210_led_write函数 */
static ssize_t webee210_led_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
{
    int val;
    printk("webee210_led_write\n");
    
    if(copy_from_user(&val, buffer, count))
		return -EINVAL;
	
    if(val == 1)
    {
        /* 点灯 */
        *gpj2dat &= ~((1<<0) | (1<<1) | (1<<2) | (1<<3));
    }
    else
    {
        /* 灭灯 */
        *gpj2dat |= ((1<<0) | (1<<1) | (1<<2) | (1<<3));
    }
    return 0;
}

static const struct file_operations led_fops = {
    .owner  = THIS_MODULE,
    .open   = webee210_led_open,
    .write  = webee210_led_write,
};

/* 驱动程序的入口函数 */
static int __init webee210_led_init(void)
{
    /* 注册字符设备，第一个参数设置为0表示由系统自动分配主设备号 */
    major = register_chrdev(0, "led_drv", &led_fops);
    
    /* 创建led_drv类 */
    led_class = class_create(THIS_MODULE, "led_drv");
    
    /*在led_drv类下创建/dev/LED设备，供应用程序打开设备 */
    led_device = device_create(led_class, NULL, MKDEV(major,0), NULL, DEVICE_NAME);
    
    /* 将物理地址映射为虚拟地址 */
    gpj2con = (volatile unsigned long*)ioremap(0xE200280, 16);
    gpj2dat = gpj2con + 1;
    return 0;
    
}

/* 驱动程序的出口函数 */
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