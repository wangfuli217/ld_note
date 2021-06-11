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

/* ioctl��������� */
#define IOCTL_GPIO_ON 1
#define IOCTL_GPIO_OFF 0

/* webee210��LED1~4��Ӧ��GPIO���� */
static unsigned long gpio_table[] = 
{
    S5PV210_GPJ2(0),
    S5PV210_GPJ2(1),
    S5PV210_GPJ2(2),
    S5PV210_GPJ2(3),
};

/* ����Ӧ��GPIO��������Ϊ��� */
static unsigned int gpio_cfg_table[] =
{
    S5PV210_GPJ2_0_OUTP,
    S5PV210_GPJ2_1_OUTP,
    S5PV210_GPJ2_2_OUTP,
    S5PV210_GPJ2_3_OUTP,
};

/* Ӧ�ó���ִ��ioctlʱ�����յ��õ����������webee210_led_ioctl���� */
static long webee210_led_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    if(arg > 4)
    {
        return -EINVAL;
    }
    
    switch(cmd)
    {
        /* ��Ӧ�ó�����1ʱ��LED������ */
        case IOCTL_GPIO_ON:
            /* ����GPIO���ŵ������ƽΪ�͵�ƽ */
            gpio_set_value(gpio_table[arg], 0);
            return 0;
        /* ��Ӧ�ó�������0ʱ��LED��Ϩ�� */
        case IOCTL_GPIO_OFF:
            /* ����GPIO���ŵ������ƽΪ�ߵ�ƽ */
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

/* �����������ں��� */   
static int __init Webee210_led_init(void)  
{  
    int ret;  
    int i;  
      
    for (i = 0; i < 4; i++)  
    {  
        /* ʹ��gpio_direction_output����ǰ�������gpio_request */  
        gpio_request(gpio_table[i], NULL);  
          
        /* ����GPIO�ܽ�Ϊ��� */  
        gpio_direction_output(gpio_table[i], gpio_cfg_table[i]);  
          
        /* �ر�����LED��������ʼ��Ϊ����LED���򽫵ڶ���������Ϊ0 */  
        gpio_set_value(gpio_table[i],1);   
    }  
  
    /* ע��һ�����豸��Ϊ10�����豸��Ϊ��̬����Ļ���(�ַ�)�豸 */  
    ret = misc_register(&misc);  
  
    printk (DEVICE_NAME" initialized\n");  
  
    return ret;  
}  
  
/* ��������ĳ��ں��� */   
static void __exit Webee210_led_exit(void)  
{  
    misc_deregister(&misc);  
}  

/* �����������/���ں��������仰˵���൱�� 
 * �����ں�������������/���ں��������� 
 */  
module_init(Webee210_led_init);  
module_exit(Webee210_led_exit);  
  
/* ������֧�ֵ�Э�顢���ߡ����� */  
MODULE_LICENSE("GPL");  
MODULE_AUTHOR("webee");  
MODULE_DESCRIPTION("Character drivers for leds");  


