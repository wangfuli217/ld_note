semaphore(api)
{
1)�����ź���    struct semaphore sem;

2)��ʼ���ź���   
void sema_init (struct semphore *sem, int val);    //����semΪval
void init_MUTEX(struct semaphore *sem);    //��ʼ��һ���û�������ź���sem����Ϊ1
void init_MUTEX_LOCKED(struct semaphore *sem);    //��ʼ��һ���û�������ź���sem����Ϊ0

DECLARE_MUTEX(name);     //�ú궨���ź���name����ʼ��1
DECLARE_MUTEX_LOCKED(name);    //�ú궨���ź���name����ʼ��0

3)����ź���                         //down�Ѿ������Ƽ�ʹ�á�
void down(struct semaphore *sem);    //�ú������ڻ�ȡ�ź���sem���ᵼ��˯�ߣ����ܱ��źŴ��,���Բ������ж�������ʹ�á�
int down_interruptible(struct semaphore *sem);    //�������˯��״̬�Ľ����ܱ��źŴ�ϣ��ź�Ҳ�ᵼ�¸ú������أ����Ƿ��ط�0��
int down_trylock(struct semaphore *sem);//���Ի���ź���sem������ܹ���ã��ͻ�ò�����0�����򷵻ط�0,���ᵼ�µ�����˯�ߣ��������ж�������ʹ��
һ������ʹ��

if(down_interruptible(&sem))
{
    return  -ERESTARTSYS;
}

4)�ͷ��ź���
void up(struct semaphore *sem);    //�ͷ��ź���sem�����ѵȴ���
�ź���һ��������ʹ�ã�������ʾ��
//�����ź���
DECLARE_MUTEX(mount_sem);
down(&mount_sem);//��ȡ�ź����������ٽ���
��
critical section //�ٽ���
��
up(&mount_sem);


5. down_killableֻ�ܱ�fatal�źŴ�ϣ������ź�ͨ��������ֹ���̣����down_killable���˱�֤�û����̿��Ա�ɱ����
����һ�����������̣���ֻ������ϵͳ��

}

rw_semphore(API)
{
ʹ�÷�����
1)����ͳ�ʼ����д�ź���
struct rw_semphore my_rws;    //�����д�ź���
void init_rwsem(struct rw_semaphore *sem);    //��ʼ����д�ź���
2)���ź�����ȡ
void down_read(struct rw_semaphore *sem);
int down_read_try(struct rw_semaphore *sem);
3)���ź����ͷ�
void up_read(struct rw_semaphore *sem);
4)д�ź�����ȡ
void down_write(struct rw_semaphore *sem);
int down_write_try(struct rw_semaphore *sem);
5)д�ź����ͷ�
void up_write(struct rw_semaphore *sem);
}

mutex(API)
{
ʹ�÷�����
1)���岢��ʼ��������
struct mutex my_mutex;
mutex_init(&my_mutex);
2)��ȡ������
void fastcall mutex_lock(struct mutex *lock);//�����˯�߲��ܱ����
int fastcall mutex_lock_interruptible(struct mutex *lock);//���Ա����
int fastcall mutex_lock_trylock(struct mutex *lock);//���Ի�ã���ȡ����Ҳ���ᵼ�½�������
3)�ͷŻ�����
void fastcall mutex_unlock(struct mutex *lock);
}

https://www.ibm.com/developerworks/cn/linux/l-synch/part1/

	�ź����ڴ���ʱ��Ҫ����һ����ʼֵ����ʾͬʱ�����м���������Է��ʸ��ź��������Ĺ�����Դ����ʼֵΪ1�ͱ�ɻ�������Mutex����
��ͬʱֻ����һ��������Է����ź��������Ĺ�����Դ��һ������Ҫ����ʹ�����Դ�����ȱ���õ��ź�������ȡ�ź����Ĳ��������ź�����
ֵ��1������ǰ�ź�����ֵΪ�����������޷�����ź������������������ڸ��ź����ĵȴ����еȴ����ź������ã�����ǰ�ź�����ֵΪ��
��������ʾ���Ի���ź���������������̷��ʱ����ź��������Ĺ�����Դ������������걻�ź��������Ĺ�����Դ�󣬱����ͷ��ź�����
�ͷ��ź���ͨ�����ź�����ֵ��1ʵ�֣�����ź�����ֵΪ������������������ȴ���ǰ�ź����������Ҳ�������еȴ����ź���������

1. ����init_MUTEX��DECLARE_MUTEX_LOCKED��linux3.0�Ժ�汾���ϳ��ĺ�����Ӧʹ��void sema_init(struct semaphore *sem, int val);
2. �Ƽ�ʹ��down_interruptible��Ҫ����С�ģ����������жϣ��ú����᷵�ط���ֵ���������ⲻ��ӵ�и��ź�������down_interruptible��
   ��ȷʹ����Ҫʼ�ռ�鷵��ֵ����������Ӧ����Ӧ��
3. ���С�_trylock�����������ߣ����ź����ڵ����ǲ��ɻ�ã��᷵�ط���ֵ��
semaphore()
{

1. ��̬�ᵼ�¶Թ������ݵķǿ��Ʒ��ʣ��������ķ���ģʽʱ���������Ԥ�ڵĽ����

asm/semaphore.h
struct semaphore;
    //�ź���
	void sema_init(struct semaphore *sem, int val); // �ź���  /*��ʼ������*/
	���ó�ʼ�������ź����ĳ�ֵ���������ź���sem��ֵΪval��
	
	
	// ������
	DECLARE_MUTEX(name);           # name���ź�����ʼֵΪ1  /*����һ������+��ʼ����*/
	DECLARE_MUTEX_LOCKED(name);    # name���ź�����ʼֵΪ0  /*����һ������+��ʼ����*/
	
    
	void init_MUTEX (struct semaphore *sem);        # ��ʼ��һ�����������������ź���sem��ֵ����Ϊ1�� /*����������ʼ������*/
	void init_MUTEX_LOCKED (struct semaphore *sem); # ��ʼ��һ�����������������ź���sem��ֵ����Ϊ0�� /*����������ʼ������*/
	
	// ��������  ->�Ὠ������ɱ����
	void down(struct semaphore *sem);
	���ڻ���ź���sem�����ᵼ��˯�ߣ���˲������ж������ģ�����IRQ�����ĺ�softirq�����ģ�ʹ�øú������ú�������sem��ֵ��1��
	����ź���sem��ֵ�Ǹ�����ֱ�ӷ��أ���������߽�������ֱ����������ͷŸ��ź������ܼ������С�
	
	int __must_check down_interruptible(struct semaphore *sem); #���жϲ���
	down���ᱻ�źţ�signal����ϣ���down_interruptible�ܱ��źŴ�ϣ���˸ú����з���ֵ���������������ػ��Ǳ��ź��жϣ��������0��
	��ʾ����ź����������أ�������źŴ�ϣ�����-EINTR��
	
	ʹ��down_interruptible��Ҫ����С�ģ�����������жϣ��ú����᷵�ط���ֵ���������߲���ӵ�и��ź�����
	
	ERESTARTSYS: �������ȳ���Ӧ���������κ��û��ɼ����޸ģ�������ϵͳ���ÿ���ȷ����
	EINTR:       �޷������Ѿ��������κ��û��ɼ����޸ġ�
	
	int __must_check down_trylock(struct semaphore *sem);
	��Զ�������ߣ�����ź����ڵ����ǲ��ɻ�ã�down_trylock�����̷���һ������ֵ��
	���Ż���ź���sem������ܹ����̻�ã����ͻ�ø��ź���������0�����򣬱�ʾ���ܻ���ź���sem������ֵΪ��0ֵ����ˣ������ᵼ�µ�����˯�ߣ�
	�������ж�������ʹ�á�
	
	int __must_check down_timeout(struct semaphore *sem, long jiffies);
	
	void up(struct semaphore *sem);
    �ú����ͷ��ź���sem������sem��ֵ��1�����sem��ֵΪ������������������ȴ����ź�������˻�����Щ�ȴ��ߡ�

----  ֻ������2.6�ں��� ----	

	���ں�Դ������kernel/printk.c�У�ʹ�ú�DECLARE_MUTEX������һ��������console_sem�������ڱ���console�����б�
console_drivers�Լ�ͬ��������console����ϵͳ�ķ��ʣ����ж����˺���acquire_console_sem����û�����console_sem��
������release_console_sem���ͷŻ�����console_sem�������˺���try_acquire_console_sem�������õ�������console_sem��
����������ʵ�����Ƿֱ�Ժ���down��up��down_trylock�ļ򵥰�װ����Ҫ����console_drivers�����б�ʱ����Ҫʹ��
acquire_console_sem������console_drivers�б�����������б�󣬾͵���release_console_sem�ͷ��ź���console_sem��
����console_unblank��console_device��console_stop��console_start��register_console��unregister_console����Ҫ����
console_drivers��������Ƕ�ʹ�ú�����acquire_console_sem��release_console_sem����console_drivers���б�����
}


mutex()
{
����                              ����
mutex_lock(struct mutex *)      Ϊָ����mutex�������������������˯��
mutex_unlock(struct mutex *)    Ϊָ����mutex����
mutex_trylock(struct mutex *)   ��ͼ��ȡָ����mutex������ɹ��򷵻�1������������ȡ������0
mutex_is_locked(struct mutex *) ������ѱ����ã��򷵻�1�����򷵻�0
}


	