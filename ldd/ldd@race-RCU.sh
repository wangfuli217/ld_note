
rcu(API)
{
���ڱ�RCU�����Ĺ������ݽṹ�����߲���Ҫ����κ����Ϳ��Է���������д���ڷ�����ʱ���ȱ���һ��������Ȼ��Ը��������޸ģ�
Ȼ��Ը��������޸ģ����ʹ��һ���ص�(callback)�������ʵ���ʱ����ԭ�����ݵ�ָ������ָ���µı��޸ĵ����ݡ����ʱ������
�������ø����ݵ�CPU���˳��Թ������ݵĲ���ʱ��
1����������                           2)��������                     ʹ��RCU���ж���ģʽ���£�
rcu_read_lock();                      rcu_read_unlock();             rcu_read_lock()
rcu_read_lock_bh();                   rcu_read_unlock_bh();            ��//���ٽ���
                                                                     rcu_read_unlock()

3)��RCU��ص�д�ߺ���������
struct rcu_head{
     struct rcu_head *next;//��һ��RCU
     void (*func)(struct rcu_head *head);//��þ���������Ĵ�����
}��

synchronize_rcu(void);//�������ߣ�ֱ�����еĶ����Ѿ���ɶ����ٽ�����д�߲ſ��Լ�����һ������
synchronize_sched();//�ȴ�����CPU�����ڿ���ռ״̬����֤�����ж�(���������ж�)�������
void call_rcu(struct rcu_head *head, void (*func)(void *arg),void arg);//������д�ߣ��������ж������Ļ����ж�ʹ�ã�
ʹ��synchronize_rcu��д������������:
DEFINE_SPINLOCK(foo_spinlock);
Int a_new;
spin_lock(&foo_spinlock);
//a_new = a;
//write a_new;
synchronize_rcu();
//a=a_new;
spin_unlock(&foo_spinlock);
//ʹ��call_rcu��д������������:
struct protectRcu
{
    int protect;
    struct rcu_head rcu;
};

struct protectRcu *global_pr;
//һ�������ͷ��ϵ�����
void callback_function(struct rcu_head *r)
{
    struct protectRcu *t;
    t=container_of(r, struct protectRcu, rcu);
    kfree(t);
}

void write_process()
{
    struct protectRcu *t, *old;
    t = kmalloc (sizeof(*t),GFP_KERNEL);//��������
    spin_lock(&foo_spinlock);
    t->protect = xx;
    old= global_pr;
    global_pr=t;//�ø����滻
    spin_unlock(&foo_spinlock);
    call_rcu(old->rcu, callback_function);
}

}


https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

RCU(Read-Copy Update)������˼����Ƕ�-�����޸ģ����ǻ�����ԭ�������ġ����ڱ�RCU�����Ĺ������ݽṹ�����߲���Ҫ����κ����Ϳ��Է�������
��д���ڷ�����ʱ���ȿ���һ��������Ȼ��Ը��������޸ģ����ʹ��һ���ص���callback���������ʵ���ʱ����ָ��ԭ�����ݵ�ָ������ָ���µı�
�޸ĵ����ݡ����ʱ�������������ø����ݵ�CPU���˳��Թ������ݵĲ�����

RCUҲ�Ƕ�д���ĸ����ܰ汾���������ȴ���������и��õ���չ�Ժ����ܡ� RCU������������ͬʱ���ʱ����������ݣ������������ߺͶ��д��
ͬʱ���ʱ����������ݣ�ע�⣺�Ƿ�����ж��д�߲��з���ȡ����д��֮��ʹ�õ�ͬ�����ƣ�������û���κ�ͬ����������д�ߵ�ͬ��������ȡ����
ʹ�õ�д�߼�ͬ�����ơ���RCU���������д������Ϊ���д�Ƚ϶�ʱ���Զ��ߵ�������߲����ֲ�д�ߵ��µ���ʧ��

rcu_read_lock()			//�����ڶ�ȡ��RCU�����Ĺ�������ʱʹ�øú����������������ٽ�����
rcu_read_unlock()		//�ú�����rcu_read_lock���ʹ�ã����Ա�Ƕ����˳������ٽ�����

synchronize_rcu()		//�ú�����RCUд�˵��ã���������д�ߣ�ֱ������grace period�󣬼����еĶ����Ѿ���ɶ����ٽ�����д�߲ſ��Լ���
                        //��һ������������ж��RCUд�˵��øú��������ǽ���һ��grace period֮��ȫ�������ѡ�

synchronize_sched()		//�ú������ڵȴ�����CPU�����ڿ���ռ״̬�����ܱ�֤�������е��жϴ�����������ϣ������ܱ�֤�������е�softirq������ϡ�
                        //ע�⣬synchronize_rcuֻ��֤����CPU���������������еĶ����ٽ�����

void fastcall call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu)) 
struct rcu_head { 
	struct rcu_head *next; 
	void (*func)(struct rcu_head *head); 
};							
����call_rcuҲ��RCUд�˵��ã�������ʹд������������������ж������Ļ�softirqʹ�á��ú������Ѻ���func�ҽӵ�RCU�ص��������ϣ�Ȼ���������ء�
һ�����е�CPU���Ѿ���ɶ��ٽ����������ú��������������ͷ�ɾ���Ľ������ڱ�Ӧ�õ����ݡ�����head���ڼ�¼�ص�����func��һ��ýṹ����Ϊ��RCU
���������ݽṹ��һ���ֶΣ��Ա�ʡȥ����Ϊ�ýṹ�����ڴ�Ĳ�������Ҫָ�����ǣ�����synchronize_rcu��ʵ��ʵ����ʹ�ú���call_rcu��

void fastcall call_rcu_bh(struct rcu_head *head,
                                void (*func)(struct rcu_head *rcu))
����call_ruc_bh���ܼ�����call_rcu��ȫ��ͬ��Ψһ����������softirq�����Ҳ��������һ��quiescent state��������д��ʹ���˸ú�����
�ڽ��������ĵĶ��˱���ʹ��rcu_read_lock_bh��

#define rcu_dereference(p)     ({ \
                                typeof(p) _________p1 = p; \
                                smp_read_barrier_depends(); \
                                (_________p1); \
                                })
�ú�������RCU�����ٽ������һ��RCU������ָ�룬��ָ��������Ժ�ȫ�����ã��ڴ�դֻ��alpha�ܹ��ϲ�ʹ�á�
������ЩAPI��RCU�����������������RCU�汾����Ϊ����RCU���Թ������ݵĲ������뱣֤�ܹ���û��ʹ��ͬ�����ƵĶ��߿����������ڴ�դ�Ƿǳ���Ҫ�ġ�

static inline void list_add_rcu(struct list_head *new, struct list_head *head)
�ú�����������new���뵽RCU����������head�Ŀ�ͷ��ʹ���ڴ�դ��֤������������²����������֮ǰ���������������ָ����޸Ķ����ж����ǿɼ��ġ�

static inline void list_add_tail_rcu(struct list_head *new,
                                        struct list_head *head)
�ú���������list_add_rcu���������µ�������new��ӵ���RCU�����������ĩβ��

static inline void list_del_rcu(struct list_head *entry)
�ú�����RCU����������������ָ����������entry�����Ұ�entry��prevָ������ΪLIST_POISON2�����ǲ�û�а�entry��nextָ������ΪLIST_POISON1����Ϊ��ָ�������Ȼ�ڱ��������ڱ���������

static inline void list_replace_rcu(struct list_head *old, struct list_head *new)
�ú�����RCU����ӵĺ������������ڷ�RCU�汾����ʹ���µ�������newȡ���ɵ�������old���ڴ�դ��֤�������µ�������֮ǰ����������ָ������������ж��߿ɼ���

list_for_each_rcu(pos, head)
�ú����ڱ�����RCU����������head��ֻҪ�ڶ����ٽ���ʹ�øú��������Ϳ��԰�ȫ�غ�����_rcu���������������list_add_rcu���������С�

list_for_each_safe_rcu(pos, n, head)
�ú�������list_for_each_rcu������֮ͬ������������ȫ��ɾ����ǰ������pos��

list_for_each_entry_rcu(pos, head, member)
�ú�������list_for_each_rcu����֮ͬ�����������ڱ���ָ�����͵����ݽṹ������ǰ������posΪһ����struct list_head�ṹ���ض������ݽṹ��

list_for_each_continue_rcu(pos, head)
�ú��������˳���֮�����������RCU����������head��

static inline void hlist_del_rcu(struct hlist_node *n)
������RCU�����Ĺ�ϣ����������������n��������n��ppreָ��ΪLIST_POISON2������û������nextΪLIST_POISON1,��Ϊ��ָ����ܱ�����ʹ�����ڱ�������

static inline void hlist_add_head_rcu(struct hlist_node *n,
                                        struct hlist_head *h)
�ú������ڰ�������n���뵽��RCU�����Ĺ�ϣ����Ŀ�ͷ����ͬʱ������߶Ըù�ϣ����ı������ڴ�դȷ����������������֮ǰ������ָ�����������ж��߿ɼ���

hlist_for_each_rcu(pos, head)
�ú����ڱ�����RCU�����Ĺ�ϣ����head��ֻҪ�ڶ����ٽ���ʹ�øú��������Ϳ��԰�ȫ�غ�����_rcu��ϣ���������������hlist_add_rcu���������С�

hlist_for_each_entry_rcu(tpos, pos, head, member)
������hlist_for_each_rcu����֮ͬ�����������ڱ���ָ�����͵����ݽṹ��ϣ������ǰ������posΪһ����struct list_head�ṹ���ض������ݽṹ��

����RCU����ϸ��ԭ��ʵ�ֻ����Լ�Ӧ����ο�����ר�����RCU�����һƪ����,"Linux 2.6�ں����µ�������--RCU(Read-Copy Update)"��




	