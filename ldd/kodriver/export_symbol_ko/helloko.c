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

MODULE_LICENSE("GPL");
extern int test(void);

static int __init hello_init(void) {
        printk(KERN_ALERT "Hello world!\n");
        test();
        return 0;
}

static void __exit hello_exit(void) {
        printk(KERN_ALERT "Goodbye!\n");
}

module_init(hello_init); 
module_exit(hello_exit);
MODULE_AUTHOR("blaider");
MODULE_DESCRIPTION("hello");
