1. ��ζ���ʱ����αȽ�ʱ��
2. ��λ�õ�ǰʱ��
3. ��ν������ӳ�ָ����һ��ʱ��
4. ��ε����첽������ָ����ʱ��֮��ִ�С�

��ʼ������жϣ�����ж���Ӳ���ж���������жϷ���ʱ������ж���ʹ���߳��������ж��źţ���Ӳ���ж���ʹ��CPUӲ���������жϡ�

https://www.ibm.com/developerworks/cn/linux/l-cn-cncrrc-mngd-wkq/
�ں����ṩ�����������ṩ�ӳ�ִ�У���
1. �жϵ��°벿������ӳ��ж��������еĲ��ֹ�����
2. ��ʱ����ָ���ӳ�һ��ʱ���ִ��ĳ������
3. ���������������ڽ��������Ļ������ӳ�ִ�еȡ�
����֮�⣬
4. �ں��л������ݳ��ֹ����������� (slow work mechanism)��
5. �����첽�������� (asynchronous function calls) 
6. �Լ�����˽��ʵ�ֵ��̳߳ص�

jiffies(������, timeval_to_jiffies, jiffies_to_timeval, timespec_to_jiffies, jiffies_to_timespec)
{


##  �ں�ͨ����ʱ���ж�������ʱ������   �жϡ�

ʱ���ж���ϵͳ��ʱӲ���������Եļ��������  ������ں˸���HZ��ֵ�趨��HZ��һ������ϵ�ṹ�йصĳ�����������linux/param.h����
���ļ�������ĳ����ƽ̨��ص��ļ��С�����ʵӲ�����ѷ�����linux�ں�Դ����Ϊ�����ƽ̨�����Ĭ��HZֵ��Χ��50~1200���������������HZֵʱ24.

ĳЩ�ڲ������ʵ�ֽ���������HZȡ12~1525֮�������� linux/timex.h ��RFC-1589

ÿ��ʱ���жϷ���ʱ���ں��ڲ���������ֵ������1�������������ֵ��ϵͳ����ʱ����ʼ��Ϊ0����ˣ�����ֵ�����ϴβ���ϵͳ����������ʱ�ӵδ�����
64λ�ã���Ϊjuffues_64.���������򿪷���ͨ�����ʵ���jiffies����������unsigned long�͵ı�����Ҫô��jiffies_64��ͬ��Ҫô������jiffies_64�ĵ�32λ��

CONFIG_HZ
CONFIG_NO_HZ

------ jiffies������ ------
�ü������Ͷ�ȡ�������Ĺ��ߺ���������Linux/jiffies.h�У�����ͨ��ֻ��Ҫ����linux/sched.h�ļ������߾��Զ�����jiffies.h��
jiffies��jiffies_64��������ֻ��������

unsigned long j, stamp_l, stamp_half, stamp_n;
j = jiffies;                 ��ȡ��ǰֵ
stamp_1 = j + HZ;            δ����1��
stamp_half = j + HZ/2;       ����
stamp_n = j + HZ*n/1000;     n ����

32λƽ̨�ϣ�HZ����1000����Լ50��������Ż����һ�Ρ�

#define time_after(a,b)       a��b�����򷵻��� a > b
#define time_before(a,b)      a��b��ǰ���򷵻��� b > a
#define time_after_eq(a,b)    a��b�������ȣ��򷵻��� a >= b
#define time_before_eq(a,b)   a��b��ǰ����ȣ��򷵻��� b >= a

struct timeval �� struct timespec
unsigned long timeval_to_jiffies(const struct timeval *value);
void jiffies_to_timeval(const unsigned long jiffies,
			       struct timeval *value);
				   
unsigned long timespec_to_jiffies(const struct timespec *value);
void jiffies_to_timespec(const unsigned long jiffies,
				struct timespec *value);
				
jiffies �� jiffies_64 ## vmlinux*.lds* �ļ����ֽ�������
u64 get_jiffies_64(void)
{
	unsigned long seq;
	u64 ret;

	do {
		seq = read_seqbegin(&xtime_lock);
		ret = jiffies_64;
	} while (read_seqretry(&xtime_lock, seq));
	return ret;
}

ע�⣺ʵ�ʵ�ʱ��Ƶ�ʶ��û��ռ�������������ȫ���ɼ��ġ����û��ռ�������param.hʱ��HZʼ�ձ���չΪ100����ÿ��������û��ռ�ļ�����ֵ
��������Ӧ��װ������һ˵������Ӧ��clock(3),times(2)�Լ������κ���غ��������û������������֪����ʱ���жϵ�ȷ��HZֵ��ֻ��ͨ��/proc/interrupts
��á����磺��ͨ��/proc/interrupts��õļ���ֵ����/proc/uptime�ļ������ϵͳ����ʱ�䣬���ɻ���ں˵�ȷ��ֵ��

}

get_cycles(�������ض��ļĴ���)
{
------ �������ض��ļĴ��� ------	 ARMû
TSC(timestamp counter ʱ���������)
asm/msr.h x86 rdtsc(low32, high32)
              rdtsc1(low32)
			  rdtscll(var64)
��CPU��װ
#include <linux/timex.h>
cycles_t get_cycles(void);
��û��ʱ�����ڼ�������ƽ̨�����Ƿ���0.cycles_t��������װ���ȡֵ�ĺ��ʵ��޷������͡�

��SMPϵͳ�У����ǲ����ڶ�������ڼ䱣��ͬ����Ϊ��ȷ�����һ�µ�ֵ��������ҪΪ��ѯ�ü������Ĵ����ֹ��ռ��

    rdtsc(low32,high32);/*ԭ�ӵض�ȡ 64-λTSC ֵ�� 2 �� 32-λ ����*/ 
    rdtscl(low32);/*��ȡTSC�ĵ�32λ��һ�� 32-λ ����*/ 
    rdtscll(var64);/*�� 64-λTSC ֵ��һ�� long long ����*/ 
    /*����Ĵ����в�����ָ�������ִ��ʱ��:*/ 
    unsigned long ini, end; 
    rdtscl(ini); 
    rdtscl(end); 
    printk("time lapse: %li\n", end - ini);
}

do_gettimeofday(��ȡ��ǰʱ��, mktime, timeval, timespec)
{
------ ��ȡ��ǰʱ�� ------
�ں�һ��ͨ��jiffiesֵ����ȡ��ǰʱ�䡣

ʹ��jiffiesֵ������ʱ�����ڴ����������Ѿ��㹻�ˣ��������Ҫ�������̵�ʱ����ֻ��ʹ�ô������ض��ļĴ����ˡ�
jiffies �� ǽ��ʱ��
extern unsigned long mktime(const unsigned int year, const unsigned int mon,
			    const unsigned int day, const unsigned int hour,
			    const unsigned int min, const unsigned int sec);
���΢�뼶��
void do_gettimeofday(struct timeval *tv);

xtime����  ����
struct timespec current_kernel_time(void);

/proc/currenttime�ļ���
}

cpu_relax(cpu_relax, schedule)
{
------ �ӳٲ��� ------
����ʱ��æ�ȴ�(���Ƽ�)
æ�ȴ� while(time_before(jiffies, j1))
		cpu_relax();
        
�ó�������
�ó�CPU while(time_before(jiffies, j1))
		schedule();
		
��ʱ�� �����������ʹ�õȴ��������ȴ�������һЩ�¼���������ͬʱϣ�����ض�ʱ��������У������ʹ�ã�
#define wait_event_timeout(wq, condition, timeout)			
#define wait_event_interruptible_timeout(wq, condition, timeout)
timeout��Ҫ�ȴ���ʱ��ֵ�����Ǿ���ʱ��ֵ��

set_current_state(TASK_INTERRUPTIBLE)
signed long schedule_timeout(signed long timeout);
}

schedule_timeout()
{
schedule_timeout����������
1. ����timer
2. Schedule

������ѵ�ǰ�Ľ��̵�״̬��TASK_RUNNING��ΪTASK_INTERRUPTIBLE��TASK_UNINTERRUPTIBLE����TASK_KILLABLE
������__schedule()�У���������task��runqueue���Ƴ�ȥ����ô��ϵͳ���е��ȵ�ʱ�����������Ȼ�ᱻ���Ƚ�����
�����Ƽ�����
Schedule_timeout_interruptible
Schedule_timeout_uninterruptible
Schedule_timeout_killable
�⼸�����������ڵ���schedule_timeout֮ǰ����set_current_state�����ѽ��̵�״̬����Ϊ��TASK_RUNNING��״̬��
����msleep���ǵ���schedule_timeout_uninterruptible��
}

schedule()
{
    ���������һ�������Ѿõ���ʶ����
    һ�����̵�ʱ��Ƭ����֮�󣬵��ٴη���ʱ���ж�ʱ�ں˻����schedule()�����е��ȣ��ѵ�ǰ�Ľ���������
�г�CPU������ѡ������һ�������л��������С���һֱ��Ϊschedule()��������ʱ���жϴ������б����õġ�
��ʵ���ǣ�������������Ļ�����ô�ڵ�һ�������ĵ������֮��ʱ���жϿ��ܾ�Ҫ��mute���ˣ�ϵͳ�Ӵ�ʧȥ
"����"��

��֮ǰ��������ǻ����������㿼�ǣ�
    1. ��ʱ���жϷ���ʱ����½��̵�ʱ��Ƭ������CFS��������˵�����Ǹ��½��̵���������ʱ��virtual run-time����
���������ʱ����Ϣ֮����������schedule()˳����£����Ⱦ�Ӧ�������ʱ��������
    2. �жϷ���֮�󣬣���arm�ܹ�Ϊ����ϵͳ���IRQģʽѸ���л���SVCģʽ�������ڴ˺���жϴ�������У��ж���
�رյģ�ֻ�����л���USRģʽ�����л�����IRQģʽ��ʱ���Ż��ٰ��жϴ򿪡�������жϴ������е���
schedule()����������ж��޷��ٴδ򿪵����⣬��Ϊ�������Ҫ�л���USRģʽ�ģ���ʱʱ���ж�Ҳ�����л�����
���´򿪵ġ�

������û��ע�⵽һ�����⣬����ARM�жϿ�����(VIC)��mask/unmask�������ڽ����ж���Ӧ����֮ǰ����Ҫ�ȶ���Ӧ���ж�
������룬�������ڴ��������ж�mask��������Ӧ����ٰ���unmask�����������ж��ܹ�������������δ�����
kernel/irq/chip.c�У������Ǿ��򻯵�ʾ�����룩��

void handle_level_irq(unsigned int irq, struct irq_desc *desc)
{
 ......
 mask_ack_irq(desc, irq);
 ......
 action_ret = handle_IRQ_event(irq, action);
 ......
 unmask_irq(desc, irq);
 ......
}

ע���жϵ�mask/unmask��enable/disable��������εĸ��enable/disable�Ƕ������ж϶��ԣ����disable�Ļ��κ��ж�
�����ᷢ������mask/unmask�Ƕ�һ���ض����ж϶��Եģ�mask֮��ָ�����жϲ����ٷ����ˣ�������Ӱ���������жϡ�
    ���ԣ�����������ƣ����ж���Ӧ�����У�ֻ�ܸ��½��̵�ʱ��Ƭ��ȴ�����Խ��е��ȡ����һ����������handle_IRQ_event()
���������schedule()�������ͻ������л����������̣�SVCģʽ���ں�̬������������unmask_irq()ִ�в�����ʱ���жϾ���
Ҳû�л���򿪡��л�����һ������֮����Ϊû��ʱ���жϣ�ϵͳҲ��ʧȥ��������
��ȷ�ķ��������жϴ����Ҫ����ʱ����schedule()��
    ���жϴ���Ļ�������(arm�ܹ�����Ҫ��__irq_usr)����Ҫ���жϴ�����̶����֮�󣬻��ܵ�ret_to_user��׼�������û�
ģʽ����ʱ�ͻ�����̵�thread_info�ṹ���Ƿ����С�_TIF_NEED_RESCHED����־������ǵĻ���˵����Ҫ���н��̵��ȣ�
��ʱ�ٵ��ú���schedule()�������ʱ����ϣ��жϿ���������Ӧ��λ�Ѿ���unmask����������ֻҪ���жϼ��ɡ�

�����ᵽ�Ļ�����Ƚ���ɢ������Ͳ����ˣ������ļ�arch/arm/kernel/entry-armv.S��entry-common.S�С�

}


ndelay(����ʱ�� æ�ȴ� ndelay, udelay, mdelay)
{
����ʱ�� æ�ȴ�
void ndelay(unsigned long x)      ����
void udelay(unsigned long x)      ΢��
void mdelay(unsigned int msecs);  ����
}

msleep(�еȴ�, msleep, msleep_interruptible, ssleep)
{
�еȴ���
void msleep(unsigned int msecs);
unsigned long msleep_interruptible(unsigned int msecs);
static inline void ssleep(unsigned int seconds)
}

instance(delay)
{
����1��
while (time_before(jiffies, j1))
                cpu_relax();

����2��
while (time_before(jiffies, j1)) {
    schedule();
}

����3��
wait_event_interruptible_timeout(wait, 0, delay);  

����4��
set_current_state(TASK_INTERRUPTIBLE);
schedule_timeout (delay);


}

------ ���� bottom half��ʵ�ַ�ʽ softirqs, tasklets, workqueue ------

------ Ӳ�ж� & ���ж� & �ź� ------
"Ӳ�ж����ⲿ�豸��CPU���ж�"��
"���ж�ͨ����Ӳ�жϷ��������ں˵��ж�"��
"�ź��������ںˣ����������̣���ĳ�����̵��ж�"
��ʼ������жϣ�����ж���Ӳ���ж���������жϷ���ʱ������ж���ʹ���߳��������ж��źţ���Ӳ���ж���ʹ��CPUӲ���������жϡ�

------ Tasklet ------
1.Tasklet �ɱ�hi-schedule��һ��schedule��hi-scheduleһ����һ��shedule�����У�
   2.ͬһ��Tasklet��ͬʱ��hi-schedule��һ��schedule;
   3.ͬһ��Tasklet����ͬʱhi-schedule��Σ���ͬ��ֻhi-sheduleһ�Σ���Ϊ����taskletδ����ʱ��hi-sheduleͬһtasklet�����壬����ǰһ��tasklet;
   4.����һ��shedule, ͬ�ϡ�
   5.��ͬ��tasklet�����Ⱥ�shedule˳�����У����ǲ������С�
 6.Tasklet������ʱ�䣺
         a.�����ж���schedule tasklet, �жϽ������������У�
         b.��CPUæ���ڲ��ڴ˴��жϺ��������У�
         c.�����ж���shedule tasklet;
         d.�����Ӳ�ж������У�
         e.��ϵͳ�����з��أ�������process��ʱ��
         f.���쳣�з���;
         g.���Գ�����ȡ���ksoftirqd����ʱ����ʱCPU�У�
 7.Taskelet��hi-schedule ʹ��softirq 0, һ��schedule��softirq 30��
 8.Tasklet������ʱ����������һ��time tick ʱ������Ϊ������ж�һ��������ʹ�ܵ�softirq, �治���ж��б��ܻ�shedule��softirq����һ���жϺ�һ���ᱻ���á���

  ���ϣ� Tasklet �ܱ�֤������ʱ����(1000/HZ)ms,һ����10ms��Tasklet��CPU�л��жϺ󱻵���.
  
 ------ softirq & tasklet & wrokqueue  ------
softirq��tasklet���������жϣ�tasklet��softirq������ʵ�֣�

ʲô�����ʹ�ù������У�ʲô�����ʹ��tasklet��
����ƺ�ִ�е�������Ҫ˯�ߣ���ô��ѡ�������С�
����ƺ�ִ�е�������Ҫ˯�ߣ���ô��ѡ��tasklet�����⣬
�����Ҫ��һ���������µ��ȵ�ʵ����ִ������°벿����ҲӦ��ʹ�ù������С�
����Ψһ���ڽ������������е��°벿ʵ�ֵĻ��ƣ�Ҳֻ�����ſ���˯�ߡ�
����ζ������Ҫ��ô������ڴ�ʱ������Ҫ��ȡ�ź���ʱ������Ҫִ������ʽ��I/O����ʱ��������ǳ����á�
�������Ҫ��һ���ں��߳����ƺ�ִ�й�������ô�Ϳ���ʹ��tasklet��  

------- Ϊʲôsoftirq/tasklet�������ж�������? ------
#### 
������ksoftirqd�����ں��߳���
�����Ҹо�softirq/taskletӦ����ʱ�������������ں��̵߳��������С�
���ǣ�LKD ����˵softirq/tasklet�������ж������ģ��ν⣿
####

����ksoftirqd������֪���ˣ�            asmlinkage void do_softirq(void)       
ksoftirqd()                            {
    do_softirq()                           __u32 pending;
        local_irq_save()                   unsigned long flags;
        __do_softirq                       
        local_irq_restore                  if (in_interrupt())
                                               return;
��ʱsoftirqִ���ǹ����жϵ�            
                                           local_irq_save(flags);
                                           
                                           pending = local_softirq_pending();      
                                       
                                           if (pending)
                                               __do_softirq();
                                       
                                           local_irq_restore(flags);
                                       }
                                       ������Ĵ�����Կ�������� in_interrupt()Ϊtrue��then return
                                        ���ԣ���ʱ��Ӧ���ǽ��������ġ�
��__do_softirq()��ִ��softirqǰ����2��������
1. __local_bh_disable��ֹ�°벿�жϣ�ʵ�����ǽ�ֹ����ռ
2. local_irq_enable()ʹ��Ӳ���ж�

�����ִ��softirqʱ�����ж������ģ���Ϊ��ֹ����ռ������ֻ��Ӳ���ж�ISR�ܹ���ϵ�ǰ��softirq�������������ں�·���ǲ��ܹ������ִ�еģ���
�����ڽ�ֹ����ռ�����Դ�ʱ�ǲ��ܵ��ȵģ���ֹ��ռ�����޷���������Ľ��̣�����������û���ȵĺ��������֪����ʲô���⣩��									   

��ϵͳ���ع��أ���һ��ѭ���д��������жϴ�������10����ʱ��һЩ����Ӧ�����ж��������д�������飬�ͱ�ת�Ƶ��ں��еĽ��������Ĵ����ˣ�
��do_softirq�лỽ����Ӧ��daemon���̴���













