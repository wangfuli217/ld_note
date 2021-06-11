#include <linux/init.h>  
#include <linux/module.h>  
MODULE_LICENSE("Dual BSD/GPL");  

// moduleparam.h 中定义 module_param需要三个参数：变量的名称、类型、以及用于sysfs入口项的访问许可掩码；
static char *whom = "world";
static int howmany = 1;
module_param(howmany, int, S_IRUGO);
module_param(whom, charp, S_IRUGO);

// 支持类型 bool invbool charp int long short uint ulong ushort
//数组：   module_param(name, type, num, perm)

static int hello_init(void)  
{  
        printk(KERN_ALERT "Hello, world/n");  
        return 0;  
}  
static void hello_exit(void)  
{  
        printk(KERN_ALERT "Goodbye, cruel world/n");  
}  
module_init(hello_init);  
module_exit(hello_exit);