#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/interrupt.h>

static struct tasklet_struct my_tasklet;  /*定义自己的tasklet_struct变量*/

static void tasklet_handler (unsigned long data)
{
    printk(KERN_ALERT "tasklet_handler is running.\n");
}


static int __init test_init(void)
{
    tasklet_init(&my_tasklet, tasklet_handler, 0); /*挂入钩子函数tasklet_handler*/
    tasklet_schedule(&my_tasklet); /* 触发softirq的TASKLET_SOFTIRQ,在下一次运行softirq时运行这个tasklet*/ 
    return 0;

}

static void __exit test_exit(void)
{
    tasklet_kill(&my_tasklet); /*禁止该tasklet的运行*/
    printk(KERN_ALERT "test_exit running.\n");
}

MODULE_LICENSE("GPL");
module_init(test_init);
module_exit(test_exit);