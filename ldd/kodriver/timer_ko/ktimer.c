/*
 * =====================================================================================
 *
 *       Filename:  helloko.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月29日 21时52分10秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include "linux/init.h"
#include "linux/kernel.h"
#include "linux/module.h"
#include <linux/timer.h>
#include <linux/jiffies.h>

MODULE_LICENSE("GPL");
struct timer_list firmware_down_timer;
#define FIRMWARE_DOWN_TIMEOUT 2
static void firmware_down_timer_func(unsigned long data)
{
	printk("%s:timer\n",__func__);
    mod_timer(&firmware_down_timer, jiffies + FIRMWARE_DOWN_TIMEOUT*HZ);
}
static int __init hello_init(void) {
        printk(KERN_ALERT "Hello world!/n");
        setup_timer(&firmware_down_timer, firmware_down_timer_func, (unsigned long)0);
        firmware_down_timer.expires = jiffies + FIRMWARE_DOWN_TIMEOUT * HZ;
        add_timer(&firmware_down_timer);
        return 0;
}

static void __exit hello_exit(void) {
	del_timer(&firmware_down_timer);
        printk(KERN_ALERT "Goodbye!/n");
}

module_init(hello_init); 
module_exit(hello_exit);
MODULE_AUTHOR("blaider");
MODULE_DESCRIPTION("hello");
