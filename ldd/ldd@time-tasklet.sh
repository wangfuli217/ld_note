1)tasklet��ʹ�ñȽϼ򵥣����£�
void my_tasklet_function(unsigned long); //����һ��������
DECLARE_TASKLET(my_tasklet, my_tasklet_function, data); //������һ������my_tasklet��tasklet�������봦�����󶨣����������Ϊdata
����Ҫ����tasklet��ʱ������һ��tasklet_schedule()��������ʹϵͳ���ʵ���ʱ����е������У�tasklet_schedule(&my_tasklet);


timer VS tasklet
1�� ���ǲ���Ҫ��tasklet��ĳ������ʱ��ִ�С�ϣ���ں�ѡ��ĳ������ʱ����ִ�и����ĺ�����
2�� ʹ��tasklet����������ֻ��ϣ���ں�ѡ��ĳ������ʱ����ִ�и����ĺ�����  ----- �����ж�һ��ʹ��
3�� ֻҪCPUæ������ĳ�����̣�tasklet�ͻ�����һ����ʱ�δ����У��������CPU���У�����������С�
    �ں�Ϊÿ��CPU�ṩ��һ��ksoftirq�ں��̣߳���������"����ж�"�������̡�

softirq VS tasklet
softirq��tasklet���������жϣ�tasklet��softirq������ʵ�֣�
    1.softirq��������Ҫ����д�ɿ�����ģ���Ϊ���cpu����ͬʱִ��ͬһ��softirq��������Ϊ�˷�ֹ���ݳ��ֲ�һ���ԣ�
����softirq�Ĵ��������뱻��д�ɿ����롣����͵ľ���Ҫ��softirq����������spinlock����һЩ������Դ��

    2.��tasklet���Ʊ���ͱ�֤��tasklet����������ͬʱ�����cpu���ȵ�����Ϊ��tasklet_schedule()�У��ͱ�֤�˶��cpu
������ͬʱ���ȵ�ͬһ��tasklet������������tasklet�Ͳ��ñ�д�ɿ�����Ĵ������������ʹ�������kernel�����Ա
�ĸ�����

https://www.ibm.com/developerworks/cn/linux/l-tasklets/
1��tasklet�Ĺ����������жϣ���������̬���ɿ��ӳٺ�����
    �����������������ӳٵ��ж�������֮�⣬�����ں˴��������ġ�
2�����ж����Ϊ���� 32 �����ж���Ŀ��ʸ���� ����֧��һϵ�е�����ж����ԡ� ��ǰ��ֻ�� 9 ��ʸ�����������жϣ� 
tasklet(desc)
{
����֮һ�� TASKLET_SOFTIRQ���μ� ./include/linux/interrupt.h���� ��Ȼ���жϻ��������ں��У��Ƽ�����tasklet�͹������У�
�����Ƿ����µ����ж�ʸ����

1�� ��ͬ��taskletһ����λ���ӳٷ������������в���ͨ�õ��ӳٻ��ƣ� 
2�� �������еĴ���������ܹ����ߣ�����taskletģʽ���޷�ʵ�֣��� 
3�� �������п����б�tasklet���ߵ�ʱ�ӣ���Ϊ�����ӳ��ṩ���ܸ��ḻ�� API�� 
��ǰ���ӳٹ���ͨ�� keventd �������Ŷ���ʵ�֣� �����������ں˹����߳� events/X ������

��������ʹ��tasklet����
	���������ڳ�ʼ��ʱ��ͨ������task_init����һ��tasklet��Ȼ����ú���tasklet_schedule�����tasklet ���� 
tasklet_vec�����ͷ���������Ѻ�̨�߳�ksoftirqd������̨�߳�ksoftirqd���е���__do_softirqʱ����ִ����
�ж�������softirq_vec���жϺ�TASKLET_SOFTIRQ��Ӧ��tasklet_action������Ȼ��tasklet_action����tasklet_vec����
����ÿ��tasklet�ĺ���������жϲ�����
}

tasklet(interface)
{
------ tasklet ------  �δ��� �� jiffies
static struct softirq_action softirq_vec[NR_SOFTIRQS];

enum {
    HI_SOFTIRQ = 0, /* ���ȼ��ߵ�tasklets */
    TIMER_SOFTIRQ, /* ��ʱ�����°벿 */
    NET_TX_SOFTIRQ, /* �����������ݰ� */
    NET_RX_SOFTIRQ, /* �����������ݰ� */
    BLOCK_SOFTIRQ, /* BLOCKװ�� */
    BLOCK_IOPOLL_SOFTIRQ,
    TASKLET_SOFTIRQ, /* �������ȼ���tasklets */
    SCHED_SOFTIRQ, /* ���ȳ��� */
    HRTIMER_SOFTIRQ, /* �߷ֱ��ʶ�ʱ�� */
    RCU_SOFTIRQ, /* RCU���� */
    NR_SOFTIRQS /* 10 */
};


struct tasklet_hrtimer {
	struct hrtimer		timer;
	struct tasklet_struct	tasklet;
	enum hrtimer_restart	(*function)(struct hrtimer *);
};
extern void tasklet_init(struct tasklet_struct *t,
			 void (*func)(unsigned long), unsigned long data);
#define DECLARE_TASKLET(name, func, data)
#define DECLARE_TASKLET_DISABLED(name, func, data) 

1. һ��tasklet�����Ժ󱻽�ֹ�����������ã�ֻ�����õĴ����ͽ��õĴ�����ͬʱ��tasklet�Żᱻִ�С�
2. �Ͷ�ʱ�����ƣ�tasklet����ע���Լ�����
3. tasklet�ɱ���������ͨ�������ȼ�������ȼ�ִ�С������ȼ���tasklet��������ִ�С�
4. ���ϵͳ���ɲ��أ���tasklet�������õ�ִ�У���ʼ�ղ���������һ����ʱ���δ�
5. һ��tasklet���Ժ�����tasklet���������������������ϸ��д���ģ�Ҳ����˵��
   ͬһ��tasklet��Զ�����ڶ����������ͬʱ���С���Ȼ�����Ѿ�ָ����taskletʱ���ڵ����Լ���ͬһCPU�����С�
   
static inline void tasklet_disable(struct tasklet_struct *t)  #���ܽ���æ�ȴ�
��ָֹ����tasklet����tasklet��Ȼ������tasklet_schedule()���ȣ�����ִ�б��Ƴ٣�ֱ��tasklet���������á�
���tasklet��ǰ�������У��ú��������æ�ȴ�ֱ��tasklet�˳�Ϊֹ��
�ڵ���tasklet_disable֮�����ǿ���ȷ�Ÿ�tasklet������ϵͳ���κεط����С�

static inline void tasklet_disable_nosync(struct tasklet_struct *t) #�������æ�ȴ�
���ú�������ʱ��ָ����tasklet������������CPU�����С�

static inline void tasklet_enable(struct tasklet_struct *t)
����һ����ǰ�����õ�tasklet��
�����tasklet�Ѿ������ȣ����ܿ�ͻ����С�

static inline void tasklet_schedule(struct tasklet_struct *t)
����ָ����tasklet��
����ڻ�����л���֮ǰ��ĳ��tasklet���ٴε��ȣ����taskletֻ������һ�Ρ�
��������ڸ�tasklet����ʱ�����ȣ��ͻ�����ɺ��ٴ����С�
��������ȷ�����ڴ����¼�ʱ�����������¼�Ҳ�ᱻ���ղ�ע�⵽��������ΪҲ����tasklet���µ�������

static inline void tasklet_hi_schedule(struct tasklet_struct *t)  �Ը����ȼ�ִ��
������жϴ�����������ʱ�������ڴ�����������ж�֮ǰ��������ȼ���tasklet��
����״̬�£�ֻ�о߱����ӳ���Ҫ���������ʹ����������������ɱ�������������жϴ�����������Ķ����ӳ١�

extern void tasklet_kill(struct tasklet_struct *t);   --- tasklet���������У� ���ң���������ȸ�taskletӦ�����У�����ȵ��������꣬Ȼ���� kill ���̡߳�
ȷ��ָ����tasklet���ᱻ�ٴε������С�
���豸Ҫ���رջ���ģ��Ҫ���Ƴ�ʱ������ͨ���������������
���tasklet�ڱ�����ִ�У��ú�����ȴ�ֱ�����˳���

void tasklet_kill_immediate( struct tasklet_struct *, unsigned int cpu );
 tasklet_kill_immediate ֻ��ָ���� CPU ���� dead ״̬ʱ�����á�
}

tasklet(template)
{

void xxx_do_tasklet(unsigned long);
DECLARE_TASKLET(xxx_tasklet,xxx_do_tasklet,0);
void xxx_do_tasklet(unsigned long)
{
����
}

irqreturn_t xxx_interrupt(int irq,void *dev_id,struct pt_regs *regs)
{
      ����
      tasklet_schedule(&xxx_tasklet);
      ����
}

int _init xxx_init(void)
{
      ����
      result=request_irq(xxx_irq,xxx_interrupt,SA_INTERRUPT,��xxx��,NULL)
      ����
}

void _exit xxx_exit(void)
{
      ����
      free_irq(xxx_irq,xxx_irq_interrupt);
      ����
}

}