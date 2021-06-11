#include <linux/init.h>  
#include <linux/module.h>  
MODULE_LICENSE("Dual BSD/GPL");  

// moduleparam.h �ж��� module_param��Ҫ�������������������ơ����͡��Լ�����sysfs�����ķ���������룻
static char *whom = "world";
static int howmany = 1;
module_param(howmany, int, S_IRUGO);
module_param(whom, charp, S_IRUGO);

// ֧������ bool invbool charp int long short uint ulong ushort
//���飺   module_param(name, type, num, perm)

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