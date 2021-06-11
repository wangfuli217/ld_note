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
#include <linux/version.h>

MODULE_LICENSE("GPL");
static int __init hello_init(void) {
        printk(KERN_ALERT "Hello world!\n");
        printk("LINUX_VERSION_CODE:%x\n",LINUX_VERSION_CODE);
        printk("KERNEL_VERSION(2,6,27):%x\n",KERNEL_VERSION(2,6,27));
        return 0;
}

static void __exit hello_exit(void) {
        printk(KERN_ALERT "Goodbye!\n");
}

module_init(hello_init); 
module_exit(hello_exit);
MODULE_AUTHOR("blaider");
MODULE_DESCRIPTION("hello");
