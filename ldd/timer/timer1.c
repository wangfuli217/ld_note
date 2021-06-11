#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <inux/kernel.h>

struct timer_list stimer; //定义定时器
static void time_handler(unsigned long data){ //定时器处理函数
    mod_timer(&stimer, jiffies + HZ);
    printk("current jiffies is %ld\n", jiffies);
}
static int __init timer_init(void){ //定时器初始化过程
    printk("My module worked!\n");
    init_timer(&stimer);
    stimer.data = 0;
    stimer.expires = jiffies + HZ; //设置到期时间
    stimer.function = time_handler;
    add_timer(&stimer);
    
    return 0;
}
static void __exit timer_exit(void){
    printk("Unloading my module.\n");
    del_timer(&stimer);//删除定时器
    return;
}
module_init(timer_init);//加载模块
module_exit(timer_exit);//卸载模块

MODULE_AUTHOR("fyf");
MODULE_LICENSE("GPL");