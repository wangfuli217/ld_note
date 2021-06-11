#include <linux/miscdevice.h>
#include <linux/gpio.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>

#define DEVICE_NAME "WEBEE210_LED"

#define S5PV210_GPJ2_0_OUTP (1<<0)
#define S5PV210_GPJ2_1_OUTP (1<<4)
#define S5PV210_GPJ2_2_OUTP (1<<8)
#define S5PV210_GPJ2_3_OUTP (1<<12)

/* ioctl的命令参数 */
#define IOCTL_GPIO_ON 1
#define IOCTL_GPIO_OFF 0

/* webee210的LED1~4对应的GPIO引脚 */
static unsigned long gpio_table[] = 
{
    S5PV210_GPJ2(0),
    S5PV210_GPJ2(1),
    S5PV210_GPJ2(2),
    S5PV210_GPJ2(3),
};

/* 将对应的GPIO引脚设置为输出 */
static unsigned int gpio_cfg_table[] =
{
    S5PV210_GPJ2_0_OUTP,
    S5PV210_GPJ2_1_OUTP,
    S5PV210_GPJ2_2_OUTP,
    S5PV210_GPJ2_3_OUTP,
};

/* 应用程序执行ioctl时，最终调用到驱动程序的webee210_led_ioctl函数 */
static long webee210_led_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    if(arg > 4)
    {
        return -EINVAL;
    }
    
    switch(cmd)
    {
        /* 当应用程序传入1时，LED被点亮 */
        case IOCTL_GPIO_ON:
            /* 设置GPIO引脚的输出电平为低电平 */
            gpio_set_value(gpio_table[arg], 0);
            return 0;
        /* 当应用程序输入0时，LED被熄灭 */
        case IOCTL_GPIO_OFF:
            /* 设置GPIO引脚的输出电平为高电平 */
            gpio_set_value(gpio_table[arg],1);
            return 0;
            
        default: 
            return -EINVAL;
     } 
}

static struct file_operations led_fops = {
    .owner  = THIS_MODULE,
    .unlocked_ioctl = webee210_led_ioctl,
    
};

static struct miscdevice misc = {
    .minor  =   MISC_DYNAMIC_MINOR,
    .name   =   DEVICE_NAME,
    .fops   =   &led_fops,    
};

/* 驱动程序的入口函数 */   
static int __init Webee210_led_init(void)  
{  
    int ret;  
    int i;  
      
    for (i = 0; i < 4; i++)  
    {  
        /* 使用gpio_direction_output函数前必须调用gpio_request */  
        gpio_request(gpio_table[i], NULL);  
          
        /* 配置GPIO管脚为输出 */  
        gpio_direction_output(gpio_table[i], gpio_cfg_table[i]);  
          
        /* 关闭所有LED，如果想初始化为点亮LED，则将第二个参数改为0 */  
        gpio_set_value(gpio_table[i],1);   
    }  
  
    /* 注册一个主设备号为10，次设备号为动态分配的混杂(字符)设备 */  
    ret = misc_register(&misc);  
  
    printk (DEVICE_NAME" initialized\n");  
  
    return ret;  
}  
  
/* 驱动程序的出口函数 */   
static void __exit Webee210_led_exit(void)  
{  
    misc_deregister(&misc);  
}  

/* 用于修饰入口/出口函数，换句话说，相当于 
 * 告诉内核驱动程序的入口/出口函数在哪里 
 */  
module_init(Webee210_led_init);  
module_exit(Webee210_led_exit);  
  
/* 该驱动支持的协议、作者、描述 */  
MODULE_LICENSE("GPL");  
MODULE_AUTHOR("webee");  
MODULE_DESCRIPTION("Character drivers for leds");  


