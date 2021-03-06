#include<linux/init.h>
#include<linux/module.h>
#include<linux/sched.h>
#include<linux/sem.h>
MODULE_LICENSE ("Dual BSD/GPL");

struct completion my_completion1;
struct completion my_completion2;	//定义了两个完成量

int thread_dirver (void *);
int thread_saleman (void *);

int
thread_driver(void *p)		//司机线程
{
  printk (KERN_ALERT "DRIVER:I AM WAITING FOR SALEMAN CLOSED THE DOOR\n");
  wait_for_completion (&my_completion1);	//等待完成量completion1

  printk (KERN_ALERT "DRIVER:OK , LET’S GO!NOW~\n");
  printk (KERN_ALERT "DRIVER:ARRIVE THE STATION.STOPED CAR!\n");
  complete (&my_completion2);	//唤醒完成量completion2

  return 0;
}

int
thread_saleman (void *p)	//售票员线程
{
  printk (KERN_ALERT "SALEMAN:THE DOOR IS CLOSED!\n");
  complete (&my_completion1);	//唤醒完成量completion1

  printk (KERN_ALERT "SALEMAN:YOU CAN GO NOW！\n");
  wait_for_completion (&my_completion2);	//等待完成量completion2

  printk (KERN_ALERT "SALEMAN:OK,THE DOOR BE OPENED!\n");
  return 0;
}

static int
hello_init (void)
{
  printk (KERN_ALERT "\nHello everybody~\n");
  init_completion (&my_completion1);
  init_completion (&my_completion2);	//初始化完成量

  kernel_thread (thread_driver, NULL, CLONE_KERNEL);
  kernel_thread (thread_saleman, NULL, CLONE_KERNEL);	//创建了两个内核线程，

  return 0;
}

static void
hello_exit (void)
{
  printk (KERN_ALERT "Goodbye everybody~\n");
}

module_init (hello_init);
module_exit (hello_exit);
MODULE_AUTHOR ("CHEN");
MODULE_DESCRIPTION ("A simple completion Module");
