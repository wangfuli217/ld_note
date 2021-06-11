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

int test(void)
{
	printk("just test");
	return 0;
}

EXPORT_SYMBOL_GPL(test);
