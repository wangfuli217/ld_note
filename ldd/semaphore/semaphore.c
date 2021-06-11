#include <linux/init.h>
#include <linux/module.h>
#include <linux/sem.h>
#include <linux/sched.h>
MODULE_LICENSE ("Dual BSD/GPL");

struct semaphore sem_producer;	/*"��������֤",�ڲ�Ʒû�б����ѵ�ʱ�����ٽ������� */
struct semaphore sem_consumer;	/*"����֤"�����в�Ʒ��ʱ��(���Ի�ø���)�ſ������� */
char product[10];		/*"��Ʒ"��ŵ� */
int exit_flags;			/*�����߿�����־ */
int producer (void *product);	/*������ */
int consumer (void *product);	/*������ */

static int
procon_init (void)
{
  printk (KERN_INFO "show producer and consumer\n");
  init_MUTEX (&sem_producer);	/*����"��������֤"������׼������ */
  init_MUTEX_LOCKED (&sem_consumer);	/*����"����֤"������������ */
  exit_flags = 0;		/*�����߿��Կ��� */
  kernel_thread (producer, product, CLONE_KERNEL);	/*���������� */
  kernel_thread (consumer, product, CLONE_KERNEL);	/*���������� */
  return 0;
}

static void
procon_exit (void)
{
  printk (KERN_INFO "exit producer and consumer\n");
}

/*
* �����ߣ���������ʮ����Ʒ
*/
int
producer (void *p)
{
  char *product = (char *) p;
  int i;
  for (i = 0; i < 1000; i++)
    {				/*�ܹ�����ʮ����Ʒ */
/* �鿴"��������֤"�������Ʒ�Ѿ������ѣ�
* ��׼�������������ڴ˵ȴ�ֱ����Ҫ����
*/
      down (&sem_producer);
      snprintf (product, 10, "product-%d", i);	/*������Ʒ */
      printk (KERN_INFO "producer produce %s\n", product);	/*��������ʾ�Ѿ����� */
      up (&sem_consumer);	/*Ϊ�����߷���"����֤" */
    }
  exit_flags = 1;		/*������ϣ��ر������� */
  return 0;
}

/*
* �����ߣ�����в�Ʒ�������Ѳ�Ʒ
*/
int
consumer (void *p)
{
  char *product = (char *) p;
  for (;;)
    {
      if (exit_flags)		/*������������Ѿ��رգ���ֹͣ���� */
        break;
/*��ȡ"����֤"������в�Ʒ������Ի�ȡ��
*�������ѡ�����ȴ�ֱ���в�Ʒ��
*/
      down (&sem_consumer);
      printk (KERN_INFO "consumer consume %s\n", product);	/*��������ʾ����˲�Ʒ */
      memset (product, '\0',10);	/*���Ѳ�Ʒ */
      up (&sem_producer);	/*������������������� */
    }
  return 0;
}

module_init (procon_init);
module_exit (procon_exit);
MODULE_AUTHOR ("Niu Tao");
MODULE_DESCRIPTION ("producer and consumer Module");
MODULE_ALIAS ("a simplest module");
