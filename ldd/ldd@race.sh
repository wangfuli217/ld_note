
����          ����                         Ӧ�ó���
spinlock        ʹ��æ�ȷ��������̲�����    (1)���ڶദ�����乲������
                                            (2)�ڿ���ռ���ں��߳��ﹲ������
                                            (3)�������ʺ��ڱ���ʱ��ǳ��̵���������������κ�������ʹ�ã������ж�������
�ź���         ����ʽ�ȴ������̹���         (1)�ʺ��ڹ���������ʱ��̳������
                                            (2)ֻ�����ڽ���������
ԭ�Ӳ���       ���ݵ�ԭ�ӷ���               (1)����򵥵��������ͣ����ͣ�������
                                            (2)�ʺϸ�Ч�ʵĳ���
rwlock          �����������                (1)����ͬʱ��������Դ����ֻ����һ��д
                                            (2)��������д����д����ͬʱ
˳����         һ���������ƣ����ڷ��ʼ���   (1)����ͬʱ��������Դ����ֻ����һ��д
                                            (2)д�����ڶ�����д����ͬʱ
RCU            ͨ����������������           (1)�Զ�ռ��Ҫ�ĳ����ṩ������
                                            (2)�����ʲ��ػ�ȡ��������ִ��ԭ�Ӳ������ֹ�ж�
�ر��ж�        ͨ����ֹ�жϵ��ֶΣ��ų����������ϵĲ������ᵼ���ж��ӳ�
                                            (1)�ж����������̹�������
                                            (2)����жϹ�������
                                            (3)�ٽ���һ��ܶ�


���������ź���
����                                ����ļ�������

�Ϳ�������                          ����ʹ��������
��������                            ����ʹ��������
���ڼ���                            ����ʹ���ź���
�ж��������м���                    ʹ��������
����������Ҫ˯�ߡ�����              ʹ���ź���


http://blog.csdn.net/zhangskd/article/details/21992933

(1) Ӳ�ж�
����ϵͳ����������(����������Ӳ��)�Զ������ġ���Ҫ������֪ͨ����ϵͳϵͳ����״̬�ı仯�����統�����յ����ݰ�
��ʱ�򣬾ͻᷢ��һ���жϡ�����ͨ����˵���ж�ָ����Ӳ�ж�(hardirq)��
 
(2) ���ж�
Ϊ������ʵʱϵͳ��Ҫ���жϴ���Ӧ����Խ��Խ�á�linuxΪ��ʵ������ص㣬���жϷ�����ʱ��Ӳ�жϴ�����Щ��ʱ��
�Ϳ�����ɵĹ�����������Щ�����¼��Ƚϳ��Ĺ������ŵ��ж�֮������ɣ�Ҳ�������ж�(softirq)����ɡ�
 
(3) �ж�Ƕ��
Linux��Ӳ�ж��ǿ���Ƕ�׵ģ�����û�����ȼ��ĸ��Ҳ����˵�κ�һ���µ��ж϶����Դ������ִ�е��жϣ���ͬ���ж�
���⡣���жϲ���Ƕ�ף�����ͬ���͵����жϿ����ڲ�ͬCPU�ϲ���ִ�С�
 
(4) ���ж�ָ��
int�����ж�ָ�
�ж����������жϺź��жϴ�������ַ�Ķ�Ӧ��
int n - �������ж�n����Ӧ���жϴ������ĵ�ַΪ���ж��������ַ + 4 * n��
 
(5)Ӳ�жϺ����жϵ�����
���ж���ִ���ж�ָ������ģ���Ӳ�ж��������������ġ�
Ӳ�жϵ��жϺ������жϿ������ṩ�ģ����жϵ��жϺ���ָ��ֱ��ָ��������ʹ���жϿ�������
Ӳ�ж��ǿ����εģ����жϲ������Ρ�
Ӳ�жϴ������Ҫȷ�����ܿ��ٵ����������������ִ��ʱ�Ų���ȴ��ϳ�ʱ�䣬��Ϊ�ϰ벿��
���жϴ���Ӳ�ж�δ��ɵĹ�������һ���ƺ�ִ�еĻ��ƣ������°벿�� 
��ʼ������жϣ�����ж���Ӳ���ж���������жϷ���ʱ������ж���ʹ���߳��������ж��źţ���Ӳ���ж���ʹ��CPUӲ���������жϡ�

���ж���һ�龲̬������°벿�ӿڣ����������д�������ͬʱִ�У���ʹ����������ͬҲ���ԡ�
��һ�����жϲ�����ռ��һ�����жϣ�Ψһ������ռ���жϵ���Ӳ�жϡ�

����
-------------------------------------------------------------------------------
(1) Ӳ�жϵĿ���
�򵥽�ֹ�ͼ��ǰ�������ϵı����жϣ�
local_irq_disable();
local_irq_enable();
���汾���ж�ϵͳ״̬�µĽ�ֹ�ͼ��
unsigned long flags;
local_irq_save(flags);
local_irq_restore(flags);
 
(2) ���жϵĿ���
��ֹ�°벿����softirq��tasklet��workqueue�ȣ�
local_bh_disable();
local_bh_enable();
��Ҫע����ǣ���ֹ�°벿ʱ��Ȼ���Ա�Ӳ�ж���ռ��
 
(3) �ж��ж�״̬
#define in_interrupt() (irq_count()) // �Ƿ����ж�״̬(Ӳ�жϻ����ж�)
#define in_irq() (hardirq_count()) // �Ƿ���Ӳ�ж�
#define in_softirq() (softirq_count()) // �Ƿ������ж�

irq(�ж����ε��ص�){
����Linuxϵͳ���첽IO�����̵��ȵȺܶ���Ҫ�������������жϣ��������ж��ڼ����е��жϳ����޷��õ�����
��˳�ʱ��������Ǻ�Σ�յģ��п���������ݶ�ʧ����ϵͳ���������Ҫ���������ж�֮�󣬵�ǰ���ں�ִ��·��
Ӧ�����ִ�����ٽ����ڵĴ���

�ж�����ֻ�ܽ�ֹ��CPU�ڵ��жϣ���˲����ܽ����CPU�����ľ�̬�����Ե���ʹ���ж����β�����һ��ֵ���Ƽ�
�ķ�������һ������������ʹ�á�
}


irq(�ж�����)
{
���б�һ���ж�����(���Ա�֤����ִ�е��ں�ִ��·�������жϴ��������ռ,����Linux�ں˵Ľ��̵��ȶ������ж���ʵ�֣��ں���ռ����֮��ľ�̬�Ͳ�������)
    ʹ�÷���:   local_irq_disable()  //�����ж�    ˵����local_irq_disable()��local_irq_enable()��ֻ�ܽ�ֹ��ʹ�ܱ�CPU�ڵ��ж�
                 ��.                                                �����ܽ��SMP��CPU�����ľ�����
                 critical section  //�ٽ���
                 ��.
                 local_irq_enable()  //���ж� 
    ��local_irq_disable()��ͬ��local_irq_save(flags)���˽��н�ֹ�жϲ������⣬����֤ĿǰCPU���ж�λ��Ϣ��local_irq_restore(flags)�����෴�Ĳ�����
    ��������: ����Linuxϵͳ���첽I/O,���̵��ȵȺܶ���Ҫ�������������жϣ��������ж��ڼ����е��ж϶��޷�������˳�ʱ�������ж��Ǻ�Σ�յģ��п�����
                �����ݶ�ʧ����ϵͳ������
}

atomic(ԭ�Ӳ����ص�){
ԭ�Ӳ������ŵ���ϵͳ�Ŀ���С�ҶԸ��ٻ����Ӱ��С��ȱ���ǲ��������и�����Ҫ��Ĵ��룬ԭ�Ӳ���ͨ������ʵ����Դ�����ü�����
}

atomic(ԭ����������)
{
���б����ԭ�Ӳ����� ��Ϊ����ԭ�Ӻ�λԭ�Ӳ����� 
    ʹ�÷���һ������ԭ�Ӳ���
            1)����ԭ�ӱ�����ֵ
              void atomic_set(atomic_t *v, int i);//����ԭ�ӱ�����ֵΪi
              atomic_t v = ATOMIC_INIT(0);//����ԭ�ӱ���v����ʼ��Ϊ0
             2)��ȡԭ�ӱ�����ֵ
              atomic_read(atomic_t *v);//����ԭ�ӱ�����ֵ
            3)ԭ�ӱ�����/��
              void atomic_add(int i,atomic_t *v);  //ԭ�ӱ�������i
              void atomic_sub(int i,atomic_t *v);  //ԭ�ӱ�������i
            4)ԭ�ӱ�������/�Լ�
              void atomic_inc(atomic_t *v);  //ԭ�ӱ�����1
              void atomic_dec(atomic_t *v);  //ԭ�ӱ�����1
            5)����������
            int atomic_inc_and_test(atomic_t *v);//��Щ������ԭ�ӱ���ִ������,�Լ�,������������Ƿ�Ϊ0,�Ƿ���true,���򷵻�false
            int atomic_dec_and_test(atomic_t *v);
            int atomic_sub_and_test(int i, atomic_t *v);
            6)����������
            int atomic_add_return(int i,atomic_t *v);  //��Щ������ԭ�ӱ������ж�Ӧ�������������µ�ֵ��
            int atomic_sub_return(int i, atomic_t *v);
            int atomic_inc_return(atomic *v);
            int atomic_dec_return(atomic_t *v);
}

atomic(ԭ��λ�����ص�){
ԭ��λ�������ŵ���ϵͳ�Ŀ���С�ҶԸ��ٻ����Ӱ��С��ȱ���ǲ��������и�����Ҫ��Ĵ��룬ԭ��λ����ͨ������ʵ����Դ�����ü�����
}
atomic(ԭ��λ����)
{
   ʹ�÷�����:λԭ�Ӳ�����
            1)����λ
            void set_bit(nr, void *addr);  //����addr��ַ�ĵ�nrλ����ν����λ����λдΪ1
            2)���λ
            void clear_bit(nr,void *addr);  //���addr��ַ�ĵ�nrλ����ν���λ����λдΪ0
            3)�ı�λ
            void change_bit(nr,void *addr);  //��addr��ַ�ĵ�nrλ����
            4)����λ
            void test_bit(nr, void  *addr);  //����addr��ַ�ĵ�nrλ
            5)���Բ�����λ
            int test_and_set_bit(nr, void *addr);
            int test_and_clear_bit(nr, void *addr);
            int test_and_change_bit(nr, void *addr);

            static atomic_t ato_avi = ATOMIC_INIT(1); //����ԭ�ӱ���
            static int ato_open(struct inode *inode, struct file *filp)  
            {
              ...
              if (!atomic_dec_and_test(&ato_avi))
              {
                atomic_inc(&ato_avi);
                return = - EBUSY;  //�Ѿ���
                }
              ..
              return 0;  //�Ѿ���
              }
            static int ato_release(struct inode *inode, struct file *filp)
            {
              atomic_inc(&ato_avi);
              return 0;
            }
}

spinlock(�������ص�){
һ�������õ�������ʹ�����������߳��ڵȴ������¿���ʱ�������ر��˷Ѵ�������ʱ�䣬������Ϊ�����������ص㡣
������������Ӧ�ñ���ʱ����С��������ʹ���������ĳ��ԣ��ڶ�ʱ���ڽ���������������

�����Բ�������ķ�ʽ������������ã��������߳����ߣ���������¿���ʱ�ٻ������������������Ͳ���ѭ���ȴ���
����ȥִ���������롣��Ҳ�����һ���Ŀ���----�������Ե��������л�����ʹ�úܶ�Ĵ��롣��ˣ�������������
ʱ�����С����������������л��ĺ�ʱ��

�����������ڼ�����ռʧЧ�ģ����ź����Ͷ�д�ź��������ڼ��ǿ��Ա���ռ�ġ�������ֻ�����ں˿���ռ��SMP������²�������Ҫ��
�ڵ�CPU�Ҳ�����ռ���ں��£������������в������ǿղ�����

1. �����������ڣ�����֮�侺�������̺�Ӳ�ж�֮�侺�������̺����ж�֮�侺�������жϺ�Ӳ�ж�֮�侺����
2. ����������˯�ߣ�����������

}

spinlock(�����ص�)
{
spin_unlock_bh��
1. ����������Ĺ�����Դֻ�ڽ��������ķ��ʺ����ж������ķ��ʣ���ô���ڽ��������ķ��ʹ�����Դʱ�����ܱ����жϴ�ϣ�
   �Ӷ����ܽ������ж����������Ա������Ĺ�����Դ���ʣ���˶�������������Թ�����Դ�ķ��ʱ���ʹ��spin_lock_bh��
   spin_unlock_bh��������
2. ��Ȼʹ��spin_lock_irq��spin_unlock_irq�Լ�spin_lock_irqsave��spin_unlock_irqrestoreҲ���ԣ�����ʧЧ��
   ����Ӳ�жϣ�ʧЧӲ�ж���ʽ��ҲʧЧ�����жϡ�����ʹ��spin_lock_bh��spin_unlock_bh����ǡ���ģ��������������졣
3. ����������Ĺ�����Դֻ�ڽ��������ĺ�tasklet��timer�����ķ��ʣ���ôӦ��ʹ�������������ͬ�Ļ�ú��ͷ����ĺ꣬
   ��Ϊtasklet��timer�������ж�ʵ�ֵġ�   

���ٻ���ֵ������ tasklet��timer
4. ����������Ĺ�����Դֻ��һ��tasklet��timer�����ķ��ʣ���ô����Ҫ�κ���������������Ϊͬһ��tasklet��timerֻ��
   ��һ��CPU�����У���ʹ����SMP������Ҳ����ˡ�ʵ����tasklet�ڵ���tasklet_schedule�������Ҫ������ʱ�Ѿ��Ѹ�tasklet
   �󶨵���ǰCPU�����ͬһ��tasklet��������ͬʱ������CPU�����С�
5. timerҲ�����䱻ʹ��add_timer��ӵ�timer������ʱ�Ѿ����ﶨ����ǰCPU������ͬһ��timer������������������CPU�ϡ�
   ��Ȼͬһ��tasklet������ʵ��ͬʱ������ͬһ��CPU�͸��������ˡ�
   
spin_lock:
6. ����������Ĺ�����Դֻ����������tasklet��timer�����ķ��ʣ���ô�Թ�����Դ�ķ��ʽ���Ҫ��spin_lock��spin_unlock��������
   ����ʹ��_bh�汾����Ϊ��tasklet��timer����ʱ��������������tasklet��timer�ڵ�ǰCPU�����С�
7. ����������Ĺ�����Դֻ��һ�����жϣ�tasklet��timer���⣩�����ķ��ʣ���ô���������Դ��Ҫ��spin_lock��spin_unlock��������
   ��Ϊͬ�������жϿ���ͬʱ�ڲ�ͬ��CPU�����С�
8. ����������Ĺ�����Դ�������������ж������ķ��ʣ���ô���������Դ��Ȼ����Ҫ��spin_lock��spin_unlock��������
   ��ͬ�����ж��ܹ�ͬʱ�ڲ�ͬ��CPU�����С�

spin_lock_irq
9. ����������Ĺ�����Դ�����жϣ�����tasklet��timer������������ĺ�Ӳ�ж������ķ��ʣ���ô�����жϻ���������ķ����ڼ䣬
   ���ܱ�Ӳ�жϴ�ϣ��Ӷ�����Ӳ�ж������ĶԹ�����Դ���з��ʣ���ˣ��ڽ��̻����ж���������Ҫʹ��spin_lock_irq��spin_unlock_irq
   �������Թ�����Դ�ķ��ʡ�

10. �����жϴ�������ʹ��ʲô�汾������������������ֻ��һ���жϴ��������ʸù�����Դ����ô���жϴ������н���Ҫ
    spin_lock��spin_unlock�������Թ�����Դ�ķ��ʾͿ����ˡ�   
    
11. ��Ϊ��ִ���жϴ������ڼ䣬�����ܱ�ͬһCPU�ϵ����жϻ���̴�ϡ���������в�ͬ���жϴ��������ʸù�����Դ����ô��Ҫ
    ���жϴ�������ʹ��spin_lock_irq��spin_unlock_irq�������Թ�����Դ�ķ��ʡ�
    
������ʹ��spin_lock_irq��spin_unlock_irq������£���ȫ������spin_lock_irqsave��spin_unlock_irqrestoreȡ�����Ǿ���Ӧ��ʹ��
    ��һ��Ҳ��Ҫ������������������ȷ���ڶԹ�����Դ����ǰ�ж���ʹ�ܵģ���ôʹ��spin_lock_irq����һЩ��
    
������Ϊ����spin_lock_irqsaveҪ��һЩ����������㲻��ȷ���Ƿ��ж�ʹ�ܣ���ôʹ��spin_lock_irqsave��spin_unlock_irqrestore���ã�
    ��Ϊ�����ָ����ʹ�����Դǰ���жϱ�־������ֱ��ʹ���жϡ�
    
}

spinlock()
{
1. ��ʼ��
spinlock_t x;         ��ʼ��������x��
spin_lock_init(x);       
                         
DEFINE_SPINLOCK(x);      
SPIN_LOCK_UNLOCKED; 

DEFINE_SPINLOCK(x)��ͬ��spinlock_t x = SPIN_LOCK_UNLOCKED spin_is_locked(x)

2. ��ȡ������
spin_lock(lock);
spin_trylock(lock);
spin_lock_irqsave(lock, flag);
spin_trylock_irqsave(lock,flag);
spin_lock_irq(lock);
spin_trylock_irq(lock);
spin_lock_bh(lock);      ���������ķ��ʺ����ж�������
spin_trylock_bh(lock);   ���������ķ��ʺ����ж�������
spin_is_lockd(lock);
spin_can_lockd(lock);

3. �ͷ�������
spin_unlock(lock);
spin_unlock_irqrestore(lock, flag);
spin_unlock_irq(lock);
spin_unlock_bh(lock);
spin_unlock_wait(lock);
}

rwlock(��д�������ص�){
��ʹ��Linux��д������ʱ��Ҫ���ǵ�һ���������������չ˶����չ�дҪ��һ�㡣������������ʱ��д����Ϊ�˻������ֻ��
�ȴ������Ƕ�ִ�е�Ԫȴ���Լ����ɹ���ռ����������������дִ�е�Ԫ�����ж�ִ�е�Ԫ�ͷ���֮ǰ�޷�����������ԣ�����
��ִ�е�Ԫ�ض���ʹ�����дִ�е�Ԫ���ڼ���״̬��
}

rwlock(��д������)
{
1. ��ʼ��
rwlock_t my_rwlock = RW_LOCK_UNLOCKED;
rwlock_t my_rwlock;
rwlock_init(&my_rwlock);

2. ������
read_lock(&my_rwlock)
read_lock_irq(&my_rwlock)
read_lock_irqsave(&my_rwlock,flag);
3. ������
read_unlock(&my_rwlock)
read_unlock_irq(&my_rwlock)
read_unlock_irqsave(&my_rwlock,flag);
4. д����
write_lock(&my_rwlock)
write_lock_irq(&my_rwlock)
write_lock_irqsave(&my_rwlock,flag);
5. д����
write_unlock(&my_rwlock)
write_unlock_irq(&my_rwlock)
write_unlock_irqsave(&my_rwlock,flag);

}

seqlock(˳�����ص�){
�����ִ�е�Ԫ�ڶ������ڼ䣬дִ�е�Ԫ�Ѿ�������д��������ô��������Ԫ�������¶�ȡ���ݣ�ȷ���õ��������������ġ�
�������Ĺ�����Դ���ܺ���ָ�룬��Ϊдִ�е�Ԫ����ʹָ��ʵЧ������ִ�е�Ԫ�����Ҫ���ʸ�ָ�룬�����´���
}

seqlock(˳����)
{
1. ��ʼ��
DEFINE_SEQLOCK(seqlock);
seqlock_init(&seqlock);
2. ��ִ�е�Ԫ���
read_seqbegin(&seqlock);
read_seqretry(&seqlock);
3. дִ�е�Ԫ���
write_seqlock(&seqlock);
write_sequnlock(&seqlock);
write_tryseqlock(&seqlock);

}

RCU(��ȡ-����-�����ص�){
    RCU��ԭ����Ƕ�ȡ-����-���£����ڱ�RCU�����Ĺ������ݽṹ����ִ�е�Ԫ����Ҫ����κ����Ϳ��Է��ʣ�
��дִ�е�Ԫ�ڷ���ʱ���ȸ���һ��������Ȼ��Ը��������޸ģ����ʹ��һ���ص��������ʵ���ʱ����
ָ��ԭ�����ݵ�ָ������ָ���µı��޸ĵ����ݡ�

RCU�ص㣺
RCU��һ�ָĽ��Ķ�д����������ִ�е�Ԫû���κ�ͬ����������дִ�е�Ԫ��ͬ������ȡ����дִ�е�Ԫ���ͬ�����ơ�
��ִ�е�Ԫ����Ҫ������ʹ��ԭ��ָ������ڳ�alpha��������мܹ���Ҳ����Ҫ�ڴ�դ����˲��ᵼ����������
�ڴ��ӳ��Լ���ˮ��ͣ�͵ȵȡ���Ϊ����Ҫ������������ʹ��ʹ�ø���ݡ�

RCU���ŵ��Ǽ���������ִ�е�Ԫͬʱ���ʱ����������ݣ�Ҳ��������ִ�е�Ԫ�Ͷ��дִ�е�Ԫͬʱ���ʱ����������ݡ�
��RCU���������д����������Ϊ���д�Ƚ϶�ʱ���Զ�ִ�е�Ԫ��������߲����ֲ�дִ�е�Ԫ���µ���ʧ��

ʹ��RCUʱ��д������Ԫ��Ҫ�ӳ����ݽṹ���ͷţ����Ʊ��޸ĵ����ݽṹ��������ʹ��ĳ��������ͬ����������дִ�е�Ԫ���޸Ĳ�����
}

RCU(��ȡ-����-����)
{
rcu_read_lock()
rcu_read_unlock()
synchronize_rcu()    �ú�����RCUд�˵��ã���������д����ִ�е�Ԫ��ֱ������grace period��дִ�е�Ԫ�ſ��Լ�����һ������
                     ����ж��RCUд�˵��øú��������ǽ���һ��grace period֮��ȫ�������ѣ���֤����CPU���������������е�
                     �����ٽ�����
synchronize_sched()  �ú������ڵȴ�����CPU�����ڿ���ռ״̬�����ܱ�֤�������е��жϴ�����������ϣ������ܱ�֤��������
                     ��softirq������ϡ�
void fastcall call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
�ú�����RCUд�˵��ã�������ʹд������Ԫ����������������жϴ������Ļ����ж�ʹ�ã��ú������Ѻ���func�ҽӵ�RCU�ص��������ϣ�Ȼ���������ء�
static inline void list_add_rcu(struct list_head *new, struct list_head *head)
�ú�����������new���뵽RCU����������head�Ŀ�ͷ���ڴ�դ��֤������������²����������֮ǰ���������������ָ����޸Ķ�
���ж�ִ�е�Ԫ�ǿɼ��ġ�
static inline void list_add_tail_rcu(struct list_head *new, struct list_head *head)
static inline void list_del_rcu(struct list_head *entry)                  
static inline void list_replace_rcu(struct list_head *entry) 
          
}

mutex(�ź������ص�){
�����ź����ᵼ��˯�ߣ����Բ��������ж������ġ�����ʹ��down()����˯�ߵĽ��в��ܱ��źŴ�ϡ��ź�����������
���ִ�е�Ԫ���и��ź�������������ֻ�������һ��������С�
}

mutex(�ź���)
{
1. ��ʼ��
DECLARE_MUTEX(sem);

struct semaphore *sem;
sema_init(sem, val);
init_MUTEX(sem);
init_MUTEX_LOCKED(sem);

2. ����ź���
void down(struct semaphore *sem);
int down_interruptible(struct semaphore *sem)��
int down_killable(struct semaphore *sem);
int down_trylock(struct semaphore *sem);

3. �ͷ��ź���
void up(struct semaphore *sem);

}

completion(������ص�){
�������һ�ֱ��ź������õ�ͬ�����ƣ����ü򵥵ķ����������������ͬ����һ��ִ�е�Ԫ�ȴ���һ��ִ�е�Ԫִ����ĳ�¡�
}
completion()
{
1. ��ʼ��
DELCLARE_COMPLETION(my_completion);

2. �ȴ������
void wait_for_completion(struct completion *c);

3. ���������
void complete(struct completion *c)��
void complete_all(struct completion *c);


}

rw_semaphore(��д�ź����ص�)
{

}
rw_semaphore(��д�ź���)
{
1. ����ͳ�ʼ����д�ź���
DELCLARE_RWSEM(rwsem);

struct rw_semaphore rwsem;
init_rwsem(&rwsem);

2. ���ź�����ȡ���ͷ�

void down_read(struct rw_semaphore *rwsem)��
int down_read_trylock(struct rw_semaphore *rwsem);
void up_read(struct rw_semaphore *rwsem);

3. д�ź�����ȡ���ͷ�
void down_write(struct rw_semaphore *rwsem);
int down_write_trylock(struct rw_semaphore *rwsem);
void up_write(struct rw_semaphore *rwsem);
}

BKL(ȫ���������ص�){

BLK��һ��ȫ������������������ʵ�ִ�Linux�����SMP���ɵ�ϸ���Ȼ��ơ�

����BLK��������Ȼ����˯�ߡ�BLK��һ�ֵݹ������������ڽ��������ģ�BLK�ѳ�Ϊ�ں���չ�Ե��ϰ���
���ں��в�����ʹ��BLK����ʵ�ϣ��´����в���ʹ��BLK��������������Ȼ�ڲ����ں˴��������á�
}
BKL(ȫ��������)
{

lock_kernel()
unlock_kernel()
kernel_locked()

}