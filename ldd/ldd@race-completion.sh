
init_completion(API)
{
ʹ�÷���:
1)���������
struct completion my_completion;
2)��ʼ��
init_completion(&my_completion); //Ҫ�Ǿ����������鷳,���ٸ��������꼴�����ֳ�ʼ��
DECLARE_COMPLETION(my_completion);

3)�ȴ������
void wait_for_completion(structcompletion *c);   //�ȴ�һ��completion������
wait_for_completion_interruptible(struct completion *c); //���жϵ�wait_for_completion
unsigned long wait_for_completion_timeout(struct completion *x,unsigned long timeout);  //����ʱ�����wait_for_completion
4)���������
void complete(struct completion *c);   //ֻ����һ���ȴ���ִ�е�Ԫ��
void complete_all(struct completion *c);   //�������еȴ�����������ִ�е�Ԫ

NORET_TYPE void complete_and_exit(struct completion *comp, long code)
}

http://guojing.me/linux-kernel-architecture/posts/completion/


�������completion�����ƻ��ڵȴ����У��ں�����������Ƶȴ�ĳһ�����������������ֻ���ʹ�õö��Ƚ�Ƶ������Ҫ�����豸����������
                    ��������ź�����Щ���ƣ���������ǻ��ڵȴ�����ʵ�ֵġ�

����ֻ����Ȥ������Ľӿڡ��ڳ����������������ߣ�һ���ڵȴ�ĳ��������ɣ�����һ���ڲ������ʱ����������
ʵ���ϣ����Ѿ����򻯹��ˡ�
ʵ���ϣ�������������Ŀ�Ľ��̵ȴ�������ɣ�Ϊ��ʾ���̵ȴ��ļ�����ɵġ�ĳ���������ں�ʹ����complietion���ݽṹ���������£�
<kernel/completion.h>

struct completion {
    unsigned int done;
    wait_queue_head_t wait;
};

���ǿ��Կ���wait������һ��wait_queue_head_t�ṹ�壬�ǵȴ����������ͷ��
            done��һ����������ÿ�ε���completionʱ���ü������ͼ�1������done����0ʱ��wait_forϵ�к����Ż�ʹ���ý��̽���˯�ߡ�
            ʵ���ϣ�����ζ�Ž�������ȴ��Ѿ���ɵ��¼���
����wait_queue_head_t�Ѿ��ڵȴ������м�¼���ˣ��������£�
<linux/wait.h>

struct __wait_queue_head {
    spinlock_t lock;
    struct list_head task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

init_completion()�������ڳ�ʼ��һ����̬�����completionʵ������DECLARE_COMPLETION���������������ݽṹ�ľ�̬ʵ����init_completion()�����������£�

<kernel/completion.h>

static inline void init_completion(struct completion *x)
{
    x->done = 0;
    init_waitqueue_head(&x->wait);
}

����������п��Կ�������ʼ��������Ὣdone�ֶγ�ʼ��Ϊ0�����ҳ�ʼ��wait�������̿�����wait_for_completion��ӵ��ȴ����У����������еȴ���
���Զ�ռ˯��״ֱ̬�������ں˵�ĳЩ���ִ�����Щ��������Ҫһ��completion


----------------------------------------------------------------------------------------

completion()
{
linux/completion.h
struct completion;

����������
    �ں˱���г�����һ��ģʽ�ǣ��ڵ�ǰ�߳�֮���ʼ��ĳ�����Ȼ��ȴ��û�Ľ��������������ǣ�
    ����һ���µ��ں��̻߳����µ��û��ռ���̡���һ�����н��̵�ĳ�����󡢻���ĳ�����͵�Ӳ��������
    ���ģʽ�� 
    struct semaphore sem;
    init_MUTEX_LOCKED(&sem);
    start_external_task(&sem);
    dowm(&sem);
    ���ⲿ��������乤��ʱ��������up(&sem);
    ���ź������������������������ù��ߣ���ͨ����ʹ���У���ͼ����ĳ���ź����Ĵ���ᷢ�ָ��źż������ǿ��ã�
    �����������Ը��źŵ����ؾ����������ܵ�Ӱ�졣

����������
completion����һ���������Ļ��ƣ�������һ���̸߳�����һ���߳�ĳ�������Ѿ���ɡ�
һ��completionͨ����һ�������豸��Ҳ����˵����ֻ�ᱻʹ��һ��Ȼ��ͱ�������
�����ϸ����completion�ṹҲ���Ա��ظ�ʹ�á�INIT_COMPLETION���ٶ�һ��completion���г�ʼ����
completion���Ƶ���ʹ����ģ���˳�ʱ���ں��߳���ֹ��������ԭ���У�ĳЩ����������ڲ�������һ���ڲ��߳���while(1)ѭ������ɣ�
���ں�׼�������ģ��ʱ��exit��������߸��߳��˳����ȴ�completion��Ϊ��ʵ�����Ŀ�ģ��ں˰����˿����������̵߳�һ�����⺯��
void complete_and_exit(struct completion *comp, long code)

��̬����
DECLARE_COMPLETION(work)   ����completion������+��ʼ����
��̬����
struct completion x;       ��̬����completion �ṹ��
void init_completion(struct completion *x)  ��̬��ʼ��completion


void wait_for_completion(struct completion *x);  �ȴ�completion
Ҫ�ȴ�completion���������ϴ��á��ú���ִ��һ�����жϵĵȴ���������������wait_for_completion��û���˻���ɸ�����
�򽫲���һ����ɱ���Ľ��̡�

int wait_for_completion_interruptible(struct completion *x);
int wait_for_completion_killable(struct completion *x);
unsigned long wait_for_completion_timeout(struct completion *x,unsigned long timeout);
long wait_for_completion_interruptible_timeout(struct completion *x, unsigned long timeout);
long wait_for_completion_killable_timeout(struct completion *x, unsigned long timeout);
bool try_wait_for_completion(struct completion *x);
bool completion_done(struct completion *x);

ͨ�������ڵȴ��¼������ʱ���ڲ����ж�״̬�������ʹ��wait_for_completion_interruptible���Ըı���һ���ã�
������̱��жϣ���������-ERESTARTSYS�����򷵻�0.

wait_for_completion_timeout�ȴ�һ������¼����ͣ����ṩ�˳�ʱ�����ã�����ȴ�ʱ�䳬������һ���ã���ȡ���ȴ����������ڷ�ֹ���޵ȴ�ĳһʱ�䣬
����ڳ�ʱ֮����Ѿ���ɣ������ͷ���ʣ��ʱ�䣬����ͷ���0��
wait_for_completion_interruptible_timeout��ǰ���ֵĽ���塣

���������ں˵���һ���ִ���֮�󣬱������complete����complete_all�����ѵȴ��Ľ��̡���Ϊÿ�ε���ֻ�ܴ�������ĵȴ������Ƴ�һ�����̣�
��n���ȴ�������˵��������ú���n�Ρ���һ���棬complete_all�ỽ�����еȴ�����ɵĽ��̡�

void complete(struct completion *);
void complete_all(struct completion *);
ʵ�ʵ�completion�¼���ͨ����������ĺ���֮һ��������
�������������Ƿ��ж���߳��ڵȴ���ͬ��completion�¼���������ͬ��
completeֻ�ỽ��һ���ȴ��̣߳�
complete_all���������еȴ��̡߳�

NORET_TYPE void complete_and_exit(struct completion *comp, long code)
/*���δʹ��completion_all��completion���ظ�ʹ�ã��������ʹ�����º������³�ʼ��completion*/
INIT_COMPLETION(struct completion c);/*�������³�ʼ��completion*/
}
