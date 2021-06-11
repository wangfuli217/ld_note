#include <linux/init.h>
#include <linux/module.h>
#include <linux/sem.h>
#include <linux/sched.h>
MODULE_LICENSE ("Dual BSD/GPL");

struct semaphore sem_producer;	/*"生产需求证",在产品没有被消费的时候不能再进行生产 */
struct semaphore sem_consumer;	/*"消费证"，在有产品的时候(可以获得该锁)才可以消费 */
char product[10];		/*"产品"存放地 */
int exit_flags;			/*生产线开启标志 */
int producer (void *product);	/*生产者 */
int consumer (void *product);	/*消费者 */

static int
procon_init (void)
{
  printk (KERN_INFO "show producer and consumer\n");
  init_MUTEX (&sem_producer);	/*购买"生产需求证"，并且准许生产 */
  init_MUTEX_LOCKED (&sem_consumer);	/*购买"消费证"，但不可消费 */
  exit_flags = 0;		/*生产线可以开工 */
  kernel_thread (producer, product, CLONE_KERNEL);	/*启动生产者 */
  kernel_thread (consumer, product, CLONE_KERNEL);	/*启动消费者 */
  return 0;
}

static void
procon_exit (void)
{
  printk (KERN_INFO "exit producer and consumer\n");
}

/*
* 生产者，负责生产十个产品
*/
int
producer (void *p)
{
  char *product = (char *) p;
  int i;
  for (i = 0; i < 1000; i++)
    {				/*总共生产十个产品 */
/* 查看"生产需求证"，如果产品已经被消费，
* 则准许生产。否则在此等待直到需要生产
*/
      down (&sem_producer);
      snprintf (product, 10, "product-%d", i);	/*生产产品 */
      printk (KERN_INFO "producer produce %s\n", product);	/*生产者提示已经生产 */
      up (&sem_consumer);	/*为消费者发放"消费证" */
    }
  exit_flags = 1;		/*生产完毕，关闭生产线 */
  return 0;
}

/*
* 消费者，如果有产品，则消费产品
*/
int
consumer (void *p)
{
  char *product = (char *) p;
  for (;;)
    {
      if (exit_flags)		/*如果生产工厂已经关闭，则停止消费 */
        break;
/*获取"消费证"，如果有产品，则可以获取，
*进行消费。否则等待直到有产品。
*/
      down (&sem_consumer);
      printk (KERN_INFO "consumer consume %s\n", product);	/*消费者提示获得了产品 */
      memset (product, '\0',10);	/*消费产品 */
      up (&sem_producer);	/*向生产者提出生产需求 */
    }
  return 0;
}

module_init (procon_init);
module_exit (procon_exit);
MODULE_AUTHOR ("Niu Tao");
MODULE_DESCRIPTION ("producer and consumer Module");
MODULE_ALIAS ("a simplest module");
