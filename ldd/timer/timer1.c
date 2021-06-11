#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <inux/kernel.h>

struct timer_list stimer; //���嶨ʱ��
static void time_handler(unsigned long data){ //��ʱ��������
    mod_timer(&stimer, jiffies + HZ);
    printk("current jiffies is %ld\n", jiffies);
}
static int __init timer_init(void){ //��ʱ����ʼ������
    printk("My module worked!\n");
    init_timer(&stimer);
    stimer.data = 0;
    stimer.expires = jiffies + HZ; //���õ���ʱ��
    stimer.function = time_handler;
    add_timer(&stimer);
    
    return 0;
}
static void __exit timer_exit(void){
    printk("Unloading my module.\n");
    del_timer(&stimer);//ɾ����ʱ��
    return;
}
module_init(timer_init);//����ģ��
module_exit(timer_exit);//ж��ģ��

MODULE_AUTHOR("fyf");
MODULE_LICENSE("GPL");