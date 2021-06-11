�ȴ��������ں������ż�����Ҫ�����ã���Ϊ�첽����������ʵ�ּ򵥶���ǿ��

waitqueue(API)
{
1) wait_queue_head_t my_queue;    //����ȴ�����ͷ
2) init_waitqueue_head(&my_queue);    //��ʼ������ͷ
   ��������ϱ����������鷳������ֱ��ʹ��DECLARE_WAIT_QUEUE_HEAD(name)

   ����ͳ�ʼ���Ŀ�ݷ�ʽ: DECLARE_WAIT_QUEUE_HEAD(my_queue);   
   
3) DECLARE_WAITQUEUE(name,tsk);    //���岢��ʼ��һ����Ϊname�ĵȴ�����(wait_queue_t);

3.1) init_waitqueue_entry��DEFINE_WAIT�� ��ʼ��wait_queue_tʵ��
        ���˽�����������ӵ��������У��ں��ṩ��������׼���������ڳ�ʼ��һ����̬�����wait_queue_tʵ����
    �ֱ�Ϊinit_waitqueue_entry�ͺ�DEFINE_WAIT��

4) void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);         δ���ý���״̬
   void fastcall remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);      ����add_wait_queue�ȴ���
    ���ڽ��ȴ�����wait��ӵ��ȴ�����ͷָ��ĵȴ����������С�                       
                                                                                   
    void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);     �����˽��̵�״̬
    //�����ǵĵȴ����������ӵ������У������ý��̵�״̬��
    void finish_wait(wait_queue_head_t *queue, wait_queue_t *wait);                �͵�������ʱ��
�����remove_wait_queue��
1. finish_wait�����õ�ǰ����״̬ΪTASK_RUNNING��
2. finish_wait���жϵȴ����е�ǰ�Ƿ�Ϊ�գ��Խ���ɾ��������  
    
5)  �ȴ��¼�
    wait_event(queue, conditon);
    wait_event_interruptible(queue, condition);//���Ա��źŴ��
    wait_event_timeout(queue, condition, timeout);
    wait_event_interruptible_timeout(queue, condition, timeout);//���ܱ��źŴ��
    queue:��Ϊ�ȴ�����ͷ�ĵȴ����б�����
    conditon���������㣬��������
    timeout��conditon��ȣ��и������ȼ��� ��jiffyΪ��λ

6)  void wake_up(wait_queue_head_t *queue);
    void wake_up_interruptible(wait_queue_head_t *queue);
    ���������ỽ����queue��Ϊ�ȴ�����ͷ�����еȴ��������������ڸõȴ�����ͷ�ĵȴ����ж�Ӧ�Ľ��̡�
     wake_up()               <--->    wait_event()
                                      wait_event_timeout()
     wake_up_interruptible() <--->    wait_event_interruptible()  
                                      wait_event_interruptible_timeout()
     wake_up()���Ի��Ѵ���TASK_INTERRUPTIBLE��TASK_UNINTERRUPTIBLE�Ľ���
     wake_up_interruptble()ֻ�ܻ��Ѵ���TASK_INTERRUPTIBLE�Ľ��̡�

7)  sleep_on(wait_queue_head_t *q);
    interruptible_sleep_on(wait_queue_head_t *q);
     
    sleep_on�����ǰ�Ŀǰ���̵�״̬�ó�TASK_UNINTERRUPTIBLE,������һ���ȴ����У�֮������������ȴ�����ͷq��
ֱ����Դ���ã�q�����ĵȴ����б����ѡ�interruptible_sleep_on������һ���ģ� ֻ�������ѽ���״̬��ΪTASK_INTERRUPTIBLE.
    ���������������������ȣ����岢��ʼ���ȴ����У��ѽ��̵�״̬�ó�TASK_UNINTERRUPTIBLE��TASK_INTERRUPTIBLE��
�����Դ�������ӵ��ȴ�����ͷ��
    sleep_on()               <--->   wake_up()
    interruptible_sleep_on() <--->   wake_up_interruptible()

    Ȼ��ͨ��schedule(����CPU,������������ִ�С���󣬵����̱������ط����ѣ����ȴ������Ƴ��ȴ�����ͷ��
    ��Linux�ں��У�ʹ��set_current_state()��__add_wait_queue()������ʵ��Ŀǰ����״̬�ĸı䣬ֱ��ʹ��current->state = TASK_UNINTERRUPTIBLE

���Ƶ����Ҳ�ǿ��Եġ�
}

waitqueue(����)
{
------ ���� ------
1. ��Զ��Ҫ��ԭ���������н������ߡ�
   ��ִ�ж������ʱ���������κεĲ������ʣ�����ζ�ţ���������˵�����ǵ�������������ӵ����������seqlock����RCU��ʱ���ߡ�
2. ��������Ѿ���ֹ���жϣ�Ҳ�������ߡ�
3. ��ӵ���ź���ʱ�����ǺϷ��ģ����Ǳ�����ϸ���ӵ���ź���ʱ���ߵĴ��롣 
   ���������ӵ���ź���ʱ���ߣ��κ������ȴ����ź������߳�Ҳ���ߣ�����κ�ӵ���ź��������ߵĴ������̣ܶ����һ�Ҫȷ�����ź����������������ջỽ�������Լ����Ǹ����̡�

1. �����Ǳ�����ʱ��������Զ�޷�֪�������˶೤ʱ����������ڼ䶼��������Щ���顣
   ����ͨ��Ҳ�޷�֪���Ƿ�������������ͬһ�¼������ߣ�������̿��ܻ�������֮ǰ�����Ѳ������ǵȴ�����Դ���ߡ�
   ���������ǶԻ���֮���״̬�������κμٶ�����˱�������ȷ�����ǵȴ�����������Ϊ�档

2. ��������֪���������˻��������ط��������ǣ�������̲������ߡ�

DECLARE_WAITQUEUE(name, tsk) 	//��̬����

wait_queue_head_t q��
init_waitqueue_head(&q)��		//��̬����
}

waitqueue(���߻���˵��){
---- ���߻���˵�� ----
1�� ����������ʱ�������ڴ�ĳ������δ����Ϊ�档Ҳ������һ�����߽��̱�����ʱ���������ٴμ�������ȴ���������ȷΪ�档
     Linux�ں�����򵥵����߷�ʽʱ��Ϊwait_enent�ĺꡣ
2�� ����wait_event����������ǰ��Ҫ�Ըñ��ʽ������ֵ��
3�� ������Ϊ��֮ǰ�����лᱣ�����ߡ�ע�⣺���������ܻᱻ�����ֵ����˶Ըñ��ʽ����ֵ���ܴ����κθ����á�
4�� ��ʵ���У�Լ����������ʹ��wait_eventʱʹ��wake_up������ʹ��wait_event_interruptibleʱʹ��wake_up_interruptilbe��

5�� TASK_RUNNIG��ʾ���̿����У����ܽ��̲���һ�����κθ���ʱ�䶼������ĳ�ش������ϡ�
    TASK_INTERRUPTIBLE:���ź��ж�����
	TASK_UNINTERRUPTIBLE�������ź��ж�����
	
	ͨ��void set_current_state(int new_state); ���� 
	current->state = TASK_INTERRUPTIBLE ���ý��̴������ߡ��÷����ı��˽���״̬��������δʹ�����ó�(schedule())��������
	
}

waitqueue(interface)
{
---- ������ ----
#define wait_event(wq, condition) 	
#define wait_event_interruptible(wq, condition)	  -ERESTARTSYS(����ֵ�������ʾ���߱�ĳ���ź��ж�)
#define wait_event_timeout(wq, condition, timeout)	
#define wait_event_interruptible_timeout(wq, condition, timeout) -ERESTARTSYS
wq���ȴ�����ͷ  ֵ����
condition���������ʽ Ϊ�滽�ѣ�Ϊ������
timeout����jiffy��ʾ��

����ֵ������ֵ�� �����ʾ���߱�ĳ���ź��жϡ� ���ʾ�����ѡ�  
        condition�����·��أ���������ʱ�䵽��ʱ�����᷵��0ֵ��������condition�����ֵ��
---- �򵥻��� ----		
void wake_up(wait_queue_head_t *queue);                 ���ѵȴ��ڸ���queue�ϵ����н��̡�
void wake_up_interruptilbe(wait_queue_head_t *queue);	ֻ�ỽ����Щִ�п��ж����ߵĽ��̡�


---- �߼����� ----	
void set_current_state(int new_state); ��
current->state = TASK_INTERRUPTIBLE
if(condtion)
	schedule();  ## timeo = schedule_timeout(timeo);

---- �ֹ����� ----	
DEFINE_WAIT(my_wait);	//��������ʼ��һ���ȴ��������  ��̬����
wait_queue_t my_wait;	//��������ʼ��һ���ȴ��������  ��̬����
init_wait(&my_wait);
	
void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);  //�����ǵĵȴ����������ӵ������У������ý��̵�״̬��
q��wait�ֱ��ǵȴ�����ͷ�ͽ�����ڡ�
state�ǽ��̵���״̬��TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE
�ڵ��� prepare_to_wait ֮�󣬽��̼��̵���schedule();��Ȼ����֮ǰ��Ӧȷ�����б�Ҫ�ȴ���
һ��schedule()���أ��͵�������ʱ���ˡ��������Ҳ��ͨ����������⺯����ɣ�
void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);

��scull��pipe.c�ļ��ж�������д������  ����ȽϹ̻�!!!! 
	

---- ��ռ�ȴ� ----
��ռ�ȴ� VS ���ߵȴ�
1. �ȴ��������������WQ_FLAG_EXCLUSIVE��־ʱ����ᱻ��ӵ��ȴ����е�β������û�������־����ڱ���ӵ�ͷ����
2. ��ĳ���ȴ������ϵ���wake_upʱ�������ڻ��ѵ�һ������WQ_FLAG_EXCLUSIVE��־�Ľ���֮��ֹͣ�����������̡�
���ս���ǣ�ִ�ж�ռ�ȴ��Ľ���ÿ��ֻ�ỽ������һ��(��ĳ������ķ�ʽ)���Ӷ��������"�����Ⱥ"���⣬���ǣ��ں�ÿ����Ȼ�ỽ�����зǶ�ռ�ȴ��Ľ��̡�

��ռ�ȴ�ʹ��������
1. ��ĳ����Դ�������ؾ�����
2. ����ĳ�����̾����������ĵ�����Դ��

void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state); ���滻prepare_to_wait
ע�⣬ʹ��wait_event��������޷�ִ�ж�ռ�ȴ���

---- �߼����� ----
int default_wake_function(wait_queue_t *wait, 
	unsigned mode, int flags, void *key); #����������Ϊ������״̬����������ý��̾��и��ߵ����ȼ������ִ��һ���������л��Ա��л����ý��̡�

	
#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL) 
���Ѷ��������зǶ�ռ�ȴ��Ľ��̣��Լ�������ռ�ȴ���(�������)��
#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
ֻ�ỽ��nr���ȴ����̣�������ֻ��һ����ע�⣺����0�������������еĵȴ����̣������ǻ����κ�һ����
#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
ȫ������
#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)

#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
���Ѷ��������зǶ�ռ�ȴ��Ľ��̣��Լ�������ռ�ȴ���(�������)�����������ж����ߵ���Щ���̡�
#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
ֻ�ỽ��nr����ռ�ȴ����̣�������ֻ��һ����ע�⣺����0�������������еĶ�ռ�ȴ����̣������ǻ����κ�һ����
#define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
ȫ������
#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
ͨ���������ѵĽ��̿��ܻ���ռ��ǰ�Ľ��̣�����wake_up����ǰ�����ȵ��������ϡ����仰˵����wake_up�ĵ��ÿ��ܲ���ԭ�ӵġ�
�������wake_up�Ľ���������ԭ��������(����ӵ��������������һ���жϴ�������)�У������µ��ȾͲ��ᷢ�͡�ͨ������һ���ʵ��ı�����

���鲻Ҫ���ã�
extern void sleep_on(wait_queue_head_t *q);
extern long sleep_on_timeout(wait_queue_head_t *q,
				      signed long timeout);
extern void interruptible_sleep_on(wait_queue_head_t *q);
extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
					   signed long timeout);
sleep_onû���ṩ�Ծ�̬���κα����������ڴ���������߼�sleep_on��������֮�䣬����һ�����ڣ��������ڼ���ֵĻ��ѽ��ᱻ��ʧ��Ϊ�ˣ�����
sleep_on�Ĵ��������ǲ���ȫ��
}

instance(˯�ߵȴ�ĳ����������  ����Ϊ��ʱ˯��)
{
˯�߷�ʽ��wait_event, wait_event_interruptible
            ���ѷ�ʽ��wake_up (����ʱҪ��������Ƿ�Ϊ�棬�����Ϊ�������˯�ߣ�����ǰһ��Ҫ��������Ϊ��)
}

instance(�ֹ����߷�ʽһ ��������ʼ��һ���ȴ�������)
{
1)��������ʼ��һ���ȴ�������
    DEFINE_WAIT(my_wait) <==> wait_queue_t my_wait; init_wait(&my_wait);
2)���ȴ���������ӵ��ȴ�����ͷ�У������ý��̵�״̬
    prepare_to_wait(wait_queue_head_t *queue, wait_queue_t *wait, int state)
3)����schedule()�������ں˵��ȱ�Ľ�������
4)schedule���أ���ɺ���������
    finish_wait()
}

instance(�ֹ����߷�ʽһ ��������ʼ��һ���ȴ�������)
{
3. �ֹ����߷�ʽ����

1)��������ʼ��һ���ȴ������
    DEFINE_WAIT(my_wait) <==> wait_queue_t my_wait; init_wait(&my_wait);
2)���ȴ���������ӵ��ȴ�����ͷ�У�
    add_wait_queue
3)���ý���״̬
    __set_current_status(TASK_INTERRUPTIBLE);
4) schedule()
5)���ȴ�������ӵȴ��������Ƴ�
    remove_wait_queue()
    
��ʵ���������߷�ʽ�൱�ڰ��ֹ����߷�ʽһ�еĵڶ���prepare_to_wait����������ˣ���prepare_to_wait <====>add_wait_queue + __set_current_status����������һ���ġ�               
}

instance(sleep_on)
{
4. �ϰ汾��˯�ߺ���sleep_on(wait_queue_head_t *queue)��
    ����ǰ���������������ڸ����ĵȴ������ϣ������޳�ʹ�������������Ϊ���Ծ�̬û���κα������ơ�
}

html(http://guojing.me/linux-kernel-architecture/posts/wait-queue/)
{

------  ���ݽṹ  ------
------ wait_queue_head_t
ÿ���ȴ����ж���һ�����е�ͷ�����ǿ��Կ����ȴ����еĴ��룺
<linux/wait.h>

struct __wait_queue_head {
    spinlock_t lock;
    struct list_head task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

��Ϊ�ȴ�����Ҳ�������жϵ�ʱ���޸ģ��ڲ�������֮ǰ������һ����������task_list��һ��˫��������ʵ��˫�������ó���ʾ�Ľṹ�����Ƕ��У�

------ __wait_queue - init_waitqueue_entry & ��DEFINE_WAIT
<linux/wait.h>

struct __wait_queue {
    unsigned int flags;
#define WQ_FLAG_EXCLUSIVE   0x01
    void *private;
    wait_queue_func_t func;
    struct list_head task_list;
};

���ǿ��Կ�������__wait_queue�еĸ����ֶΣ����ֶ��������£�

�ֶ� 		˵��
flags 		ΪWQ_FLAG_EXCUSIVE��Ϊ0��WQ_FLAG_EXCUSIVE��ʾ�ȴ�������Ҫ����ռ�ػ���
private 	��һ��ָ�룬ָ��ȴ����̵�task_structʵ����������������Ͽ���ָ�������˽������
func 		�ȴ����ѽ���
task_list 	����һ������Ԫ�أ����ڽ�wait_queue_tʵ����ֹ���ȴ�������

Ϊ��ʹ��ǰ������һ���ȴ�������˯�ߣ���Ҫ����wait_event���������̽���˯�ߣ�������Ȩ�ͷŸ����������ں�ͨ����������豸�����������ݵ������
���������������Ϊ���䲻���������ͣ����ڴ��ڼ���û������������������Խ��̾Ϳ��Խ���˯�ߣ���CPUʱ�佻��ϵͳ�е��������̡�

���ں��е���һ�������磬���Կ��豸�����ݵ���󣬱������wake_up���������ѵȴ������е�˯�߽��̡���ʹ��wait_event�ý���˯�ߺ󣬱���ȷ����
�ں˵���һ��һ����һ����Ӧ��wake_up���ã����Ǳ���ģ�����˯�ߵĽ�����Զ�޷�������


------  ����˯��  ------  add_wait_queue & prepare_to_wait & DEFINE_WAIT_FUNC[autoremove_wake_function]
                  ------  sleep_on & wait_event_interruptible & wait_event_interruptible_timeout & wait_event_timeout
add_wait_queue�������ڽ�һ���������ӵ��ȴ����У������������Ҫ������������ڻ��������֮�󣬽�����ί�и�__add_wait_queue��
<linux/wait.h>

static inline void __add_wait_queue(
    wait_queue_head_t *head,
    wait_queue_t *new)
{
    list_add(&new->task_list, &head->task_list);
}

�ڽ��½���ͳ�Ƶ��ȴ����е�ʱ�򣬳���ʹ��list_add������û�������Ĺ���Ҫ�����ں˻��ṩ��add_wait_queue_exclusive������
���Ĺ�����ʽ�����������ͬ�����ǽ����̲��뵽�����β��������������ΪWQ_EXCLUSIVE��־��

�ý����ڵȴ������Ͻ���˯�ߵ���һ�ַ�����prepare_to_wait������������л���Ҫ���̵�״̬���������£�
<kernel/wait.c>
void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
{
    unsigned long flags;
    /* ��������ӵ��ȴ����е�β��
     * ����ʵ��ȷ���ڻ�Ϸ������͵Ķ�����
     * ���Ȼ������е���ͨ����
     * Ȼ��ſ��ǵ����ں˶�ջ���̵�����
     */
    wait->flags &= ~WQ_FLAG_EXCLUSIVE;
    // ����һ��������
    spin_lock_irqsave(&q->lock, flags);
    if (list_empty(&wait->task_list))
        // ��ӵ�������
        __add_wait_queue(q, wait);
    set_current_state(state);
    // ����һ��������
    spin_unlock_irqrestore(&q->lock, flags);
}
EXPORT_SYMBOL(prepare_to_wait);


���˽�����������ӵ��������У��ں��ṩ��������׼���������ڳ�ʼ��һ����̬�����wait_queue_tʵ�����ֱ�Ϊinit_waitqueue_entry�ͺ�DEFINE_WAIT��
<linux/wait.h>

static inline void init_waitqueue_entry(
    wait_queue_t *q,
    struct task_struct *p)
{
    q->flags = 0;
    q->private = p;
    q->func = default_wake_function;
}

default_wake_functionֻ��һ�����в���ת����ǰ�ˣ�Ȼ��ʹ��try_to_wake_up���������ѽ��̡�

��DEFINE_WAIT����wait_queue_t�ľ�̬ʵ����
<linux/wait.h>

#define DEFINE_WAIT_FUNC(name, function)
    wait_queue_t name = {
        .private    = current,
        .func       = function,
        .task_list  = LIST_HEAD_INIT((name).task_list),
    }

#define DEFINE_WAIT(name) \
    DEFINE_WAIT_FUNC(name, autoremove_wake_function)

������autoremove_wake_function�����ѽ��̣����������������default_waike_function�������ȴ����дӵȴ�����ɾ����
add_wait_queueͨ����ֱ��ʹ�ã����Ǹ�����ʹ��wait_event������һ���꣬�������£�

<linux/wait.h>
#define wait_event(wq, condition)
do {
    if (condition)
        break;
    __wait_event(wq, condition);
} while (0)

�����ȴ�һ����������ȷ����������Ƿ����㣬��������Ѿ����㣬�Ϳ�������ֹͣ������Ϊû��ʲô���Լ����ȴ����ˣ�Ȼ�󽫹�������__wait_event��

<linux/wait.h>
#define __wait_event(wq, condition)
do {
    DEFINE_WAIT(__wait);
    for (;;) {
        prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);
        if (condition)
            break;
        schedule();
    }
    finish_wait(&wq, &__wait);
} while (0)

ʹ��DEFINE_WAIT�����ȴ����еĳ�Ա֮����������һ������ѭ����ʹ��prepare_to_waitʹ�����ڵȴ�������˯�ߡ�ÿ�ν��̱�����ʱ��
�ں˶�����ָ���������Ƿ����㣬����������㣬���˳�����ѭ�������򽫿���Ȩ�����������������ٴ�˯�ߡ�

����������ʱ��finish_wait������״̬���û�TASK_RUNNING�����ӵȴ����е������Ƴ���Ӧ�


����wait_event֮�⣬�ں˻������������������������Խ���ǰ�������ڵȴ������У�ʵ�ֵ�ͬ��sleep_on��

<linux/wait.h>
#define wait_event_interruptible(
    wq, condition)
({
    int __ret = 0;
    if (!(condition))
        __wait_event_interruptible(
            wq, condition, __ret
        );
    __ret;
})

wait_event_interruptibleʹ�õĽ���״̬ΪTASK_INTERRUPTIBLE�����˯�߽��̿���ͨ�������źŶ����ѡ�
<linux/wait.h>

#define wait_event_interruptible_timeout(
    wq, condition, timeout)
({
    long __ret = timeout;
    if (!(condition))
        __wait_event_interruptible_timeout(
            wq, condition, __ret
        );
    __ret;
})

wait_event_interruptible_timeout�ý���˯�ߣ�������ͨ�������źŻ��ѣ���ע����һ����ʱ���ơ�
<linux/wait.h>

#define wait_event_timeout(wq, condition, timeout)
({
    long __ret = timeout;
    if (!(condition))
        __wait_event_timeout(
            wq, condition, __ret
        );
    __ret;
})

wait_event_timeout�ȴ�����ָ����������������ȴ�ʱ�䳬����ָ���ĳ�ʱ���ƣ���ô��ֹͣ�����ֹ����Զ˯�ߵ������


------  ���ѽ���  ------  wake_up_poll &  wake_up_locked_poll & wake_up_interruptible_poll & wake_up_interruptible_sync_poll

���ѽ��̵Ĺ��̱Ƚϼ򵥣��ں˶�����һЩ�еĺ��û����ѽ��̡�
<linux/wait.h>

#define wake_up_poll(x, m)
    __wake_up(x, TASK_NORMAL, 1, (void *) (m))

#define wake_up_locked_poll(x, m)
    __wake_up_locked_key((x), TASK_NORMAL, (void *) (m))

#define wake_up_interruptible_poll(x, m)
    __wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))

#define wake_up_interruptible_sync_poll(x, m)
    __wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))

�ڻ�����û������ȴ������ײ�����֮��_wake_up������ί�и�_wake_up_common���������£�
<linux/wait.h>

static void __wake_up_common(
    wait_queue_head_t *q, unsigned int mode,
    int nr_exclusive, int wake_flags, void *key)
{
    wait_queue_t *curr, *next;
    // ����ɨ������ֱ��û�и�����Ҫ���ѵĽ���
    list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
        unsigned flags = curr->flags;

        if (curr->func(curr, mode, wake_flags, key) &&
                (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
                /* ��黽�ѽ��̵���Ŀ�Ƿ�ﵽ��nr_exclusive
                 * ������ν�ľ�Ⱥ����
                 * ������������ڵȴ���ռ����ĳһ��Դ
                 * ��ôͬʱ�������еĵȽ���ʱû�������
                 * ��Ϊ�������е�һ������֮��
                 * �����Ľ��̶����ٴν���˯��
                 */
            break;
    }
}

q����ѡ���ȴ����У���modeָ�����̵�״̬�����ڿ��ƻ��ѽ��̵�������nr_exclusive��ʾ��Ҫ���ѵ�������WQ_FLAG_EXCLUSIVE��־�Ľ��̵���Ŀ��
�������ע�Ϳ��Կ���nr_exclusive�Ƿǳ����õģ�������ֱ�ʾ��黽�ѽ��̵���Ŀ�Ƿ�ﵽ��nr_exclusive���Ӷ�������ν�ľ�Ⱥ�����⡣

��Ⱥ�����ǣ�����Ҫ���ѽ��̵�ʱ�򣬲���Ҫ�����еȴ�ĳһ��Դ�Ľ���ȫ�����ѣ���Ϊ����ȫ�����ѣ�Ҳֻ����һ��������Ҫ���ѣ��������Ľ��̶�Ҫ�ٴ�
����˯�ߣ����Ƿǳ��˷���Դ�ģ�����Ҫ˵ÿ�ν��̻��Ѷ���������������⡣

��������˵���еĽ��̶�����ͬʱ�����ѣ���������ڵȴ������ݴ����������ô���ѵȴ������е����н����ǿ��еģ���Ϊ�⼸�����̵����ݿ���ͬʱ
��ȡ�����ᱻ���š�
}

