#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/kernel.h>
struct timer_list stimer; //���嶨ʱ��
int timeout = 10 * HZ;

static void time_handler(unsigned long data){ //��ʱ����������ִ�иú�����ȡ������̵�pid�����Ѹý���
    struct task_struct *p = (struct task_struct *)data;//����Ϊ�������pid
    wake_up_process(p);//���ѽ���
    printk("current jiffies is %ld\n", jiffies); //��ӡ��ǰjiffies
}
static int __init timer_init(void){ //��ʱ����ʼ������

    printk("My module worked!\n");
    init_timer(&stimer);
    
    stimer.data = (unsigned long)current; //����ǰ���̵�pid��Ϊ��������
    stimer.expires = jiffies + timeout; //���õ���ʱ��
    stimer.function = time_handler;
    add_timer(&stimer);
    printk("current jiffies is %ld\n", jiffies);
    set_current_state(TASK_INTERRUPTIBLE);
    
    schedule(); //����ý���
    del_timer(&stimer); //ɾ����ʱ��
    return 0;
}

static void __exit timer_exit(void){
    printk("Unloading my module.\n");
    return;
}

module_init(timer_init);//����ģ��
module_exit(timer_exit);//ж��ģ��
MODULE_AUTHOR("fyf");
MODULE_LICENSE("GPL");