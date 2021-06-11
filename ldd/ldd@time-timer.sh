timer(API)
{
��ʱ����ΪӲ���������ʱ���������ʱ�����ջ���Ҫ����Ӳ����ʱ������ɡ��ں���ʱ���жϷ����������ʱ���Ƿ��ڣ�
���ں�Ķ�ʱ������������Ϊ���ж��ڵװ벿ִ�С�ʵ���ϣ�ʱ���жϴ������ִ��update_process_timers������
�ú�������run_local_timers�����������������TIMER_SOFTIRQ���жϣ����е�ǰ�����ϵ��ڵ����ж�ʱ����
Linux�ں��ж����ṩ��һЩ���ڲ�����ʱ�������ݽṹ�ͺ������£�
1)timer_list:˵��ʱ������ȻҪ������ʱ���Ľṹ��
  struct timer_list{
     struct list_head entry;  //��ʱ���б�
      unsigned long expires;  //��ʱ������ʱ��
      void (*function)(unsigned long) ;//��ʱ��������
      unsigned long data;   //��Ϊ���������붨ʱ��������
      struct timer_base_s *base;
}
2)��ʼ����ʱ����void init_timer(struct timer_list *timer);���������ʼ����entry��nextΪNULL,����base��ֵ
3)���Ӷ�ʱ����void add_timer(struct timer_list *timer); �ú�������ע���ں˶�ʱ����������ʱ�����뵽�ں˶�̬��ʱ�������С�
4)ɾ����ʱ����int del_timer(struct timer_list *timer);
  ˵����del_timer_sync��del_timer��ͬ���棬��Ҫ�ڶദ����ϵͳ��ʹ�ã���������ں�ʱ��֧��SMP,del_timer_sync��del_timer�ȼ�.
5)�޸Ķ�ʱ����int mod_timer(struct timer_list *timer, unsigned long expires);
}

https://www.ibm.com/developerworks/cn/linux/l-tasklets/

��ʱ����ʵ�ֱ��������������Ҫ��ͼ���:
    ��ʱ��������뾡���ܼ�.
    ���Ӧ�����ż���Ķ�ʱ����Ŀ�������ܺõ���Ӧ.
    �󲿷ֶ�ʱ���ڼ������༸�����ڵ�ʱ, �����г���ʱ�Ķ�ʱ�����൱�ټ�.
    һ����ʱ��Ӧ����ע������ͬһ�� CPU ������.

timer(�ں˶�ʱ��˵��)
{
------ �ں˶�ʱ�� ------
1�� ���������Ҫ�ڽ�����ĳ��ʱ������ִ��ĳ��������ͬʱ�ڸ�ʱ��㵽��ǰ����������ǰ���̣������ʹ���ں˶�ʱ����
    �ں˶�ʱ����������һ�������ڽ���һ���ض���ʱ�䣨����ʱ�����գ�ִ�У��Ӷ�����ɸ�������
2�� �ں˶�ʱ���ǻ���ʱ�ӵδ�ġ�
3�� ʹ�ó�����
	1. Ӳ���޷������жϣ��ں˶�ʱ�����������Ե���ѯ�豸״̬��
	2. �ر����������߽�����ʱ��Ĺرղ�����
	3. schedule_timeout�����ں˶�ʱ��ʵ��������ȡ�
4�� ���������еĺ��������϶�������ע����������Ľ�������ִ��ʱ���С��෴������������첽�����С�
    ����ʱ������ʱ�����ȸö�ʱ���Ľ��̿��������ߣ����䴦����ִ�У�������Ѿ��˳���
5�� ��ʱ�����Խ��Լ�ע�ᵽ���Ժ��ʱ���������С���������ѯ�豸��
6�� ��ʹ�ڵ�������ϵͳ�ϣ���ʱ��Ҳ���Ǿ�̬��Ǳ��Դ�������������첽ִ�е��ص�ֱ�ӵ��µġ���ˣ��κ�ͨ����ʱ��������
    �����ݽṹ��Ӧ��Բ������ʽ��б�����
7�� �ں˶�ʱ�����������кܴ��࣬��Ϊ���ܵ�jitter�Լ���Ӳ���жϣ�������ʱ�����첽������������Ӱ�졣�ͼ�����IO�����Ķ�ʱ���Լ�������˵����
    ���磺���Ʋ��������ҵ������豸�����ʺϹ�ҵ�����µ�����ϵͳ�� ---- ����ĳ��ʵʱ���ں���չ��
	
���������� & �ж�������	
linux/timer.h ��kernel/timer.c 
1. ����������û��ռ䡣��Ϊû�н��������ģ��޷����ض��������û��ռ����������
2. currentָ����ԭ��ģʽ��û�����壬Ҳ�ǲ����õģ���Ϊ��ش���ͱ��жϵĽ���û���κι�����
3. ����ִ�����߻���ȡ�ԭ�Ӵ��벻���Ե���schedule()����wait_event��Ҳ���ܵ����κο����������ߵĺ������ź����������ȡ�

�ں˴������ͨ�����ú���in_interrupt()���ж��Լ��Ƿ����������ж������ģ�
����������������ж������ľͷ��ط���ֵ����������Ӳ���жϻ�������жϡ�

in_interrupt() & in_atomic()  asm/hardirq.h
in_interrupt() ����(���жϻ�Ӧ�ж���)
in_atomic()    ����(���Ȳ�������ʱ)  [Ӳ�����ж��������Լ�ӵ�����������κ�ʱ���]
                                     ���������κ�ʱ���:current���ã�����ֹ�����û��ռ䣬��Ϊ��ᵼ�µ��ȵķ�����
                                      Ӳ�����ж�������:current�����á�
���ܺ�ʱʹ��in_interrupt()��Ӧ�����Ƿ�������ʹ�õ���in_atomic()��
}

in_interrupt(API)
{
ͨ�����ú��� in_interrupt() �ܹ���֪�Ƿ������ж������������У���������������������ǰ���ж����������оͷ��ط��㡣
}

in_atomic(API)
{
    ͨ�����ú��� in_atomic() �ܹ���֪�����Ƿ񱻽�ֹ�������ȱ���ֹ���ط���; ���ȱ���ֹ����Ӳ��������ж���������
���κγ�����������ʱ��

    �ں�һ�����, current ��������Ч�ģ����Ƿ����û��ռ��Ǳ���ֹ�ģ���Ϊ���ܵ��µ��ȷ���. ��ʹ�� in_interrupt() ʱ��
��Ӧ�����Ƿ�������ʹ�õ��� in_atomic �����Ƕ��� <asm/hardirq.h> ��������

    �ں˶�ʱ������һ����Ҫ�������������ע���������ں���ʱ���������У���Ϊÿ�� timer_list �ṹ����������ǰ�Ӽ����
��ʱ��������ȥ����,����ܹ�������������������һ������ע�����Լ��Ķ�ʱ��һֱ������ͬһ�� CPU.

    ������һ����������ϵͳ����ʱ����һ��Ǳ�ڵ�̬Դ�������첽����ֱ�ӽ��������κα���ʱ���������ʵ����ݽṹӦ��
ͨ��ԭ�����ͻ������������������Ⲣ�����ʡ�
}

timer(API)
{
timer ����������ִ�С�
init_waitqueue_head��wait_event_interruptible��wake_up_interruptible(&data->wait);  ���ڽ�������ͬ��ִ��

#define init_timer(timer)
#define TIMER_INITIALIZER(_function, _expires, _data) // jiffies ����_expires��ֵ����ִ��_function

�ڳ�ʼ��֮�󣬿��ڵ���add_timer֮ǰ�޸����潲�������������ֶΡ�
���Ҫ�ڶ�ʱ����֮ǰ��ֹһ����ע��Ķ�ʱ�������Ե���del_timer������

void add_timer(struct timer_list *timer);
int del_timer(struct timer_list * timer);

int mod_timer(struct timer_list *timer, unsigned long expires);
int del_timer_sync(struct timer_list *timer);
static inline int timer_pending(const struct timer_list * timer)

unsigned long j = jiffies;

data = kmalloc(sizeof(*data), GFP_KERNEL);
if (!data)
        return -ENOMEM;

init_timer(&data->timer);
init_waitqueue_head (&data->wait);

/* write the first lines in the buffer */
buf2 += sprintf(buf2, "   time   delta  inirq    pid   cpu command\n");
buf2 += sprintf(buf2, "%9li  %3li     %i    %6i   %i   %s\n",
                j, 0L, in_interrupt() ? 1 : 0,
                current->pid, smp_processor_id(), current->comm);

/* fill the data for our timer function */
data->prevjiffies = j;
data->buf = buf2;
data->loops = JIT_ASYNC_LOOPS;

/* register the timer */
data->timer.data = (unsigned long)data;
data->timer.function = jit_timer_fn;
data->timer.expires = j + tdelay; /* parameter */
add_timer(&data->timer);

/* wait for the buffer to fill */
wait_event_interruptible(data->wait, !data->loops);
}

