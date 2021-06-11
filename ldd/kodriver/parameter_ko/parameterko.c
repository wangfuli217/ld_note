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
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>

#define MAX_ARRAY 6
static int int_var = 0;
static char *str_var = "default";
static int int_array[6];
int narr;
module_param(int_var, int, 0644);
MODULE_PARM_DESC(int_var, "A integer variable");

module_param(str_var, charp, 0644);
MODULE_PARM_DESC(str_var, "A string variable");

module_param_array(int_array, int, &narr, 0644);
MODULE_PARM_DESC(int_array, "A integer array");
 
static int __init hello_init(void)
{
       int i;
       printk(KERN_ALERT "Hello, my LKM.\n");
       printk(KERN_ALERT "int_var %d.\n", int_var);
       printk(KERN_ALERT "str_var %s.\n", str_var);
       for(i = 0; i < narr; i ++){
               printk("int_array[%d] = %d\n", i, int_array[i]);
       }
       return 0;
}
static void __exit hello_exit(void)
{
       printk(KERN_ALERT "Bye, my LKM.\n");
}
module_init(hello_init);
module_exit(hello_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("ydzhang");
MODULE_DESCRIPTION("This module is a example.");
