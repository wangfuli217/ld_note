rwlock(API)
{
ʹ�÷�����1)��ʼ����д���ķ�����
               rwlock_t x;//��̬��ʼ��                                            rwlock_t x=RW_LOCK_UNLOCKED;//��̬��ʼ��
               rwlock_init(&x);
             2)������Ķ�д������
              void read_lock(rwlock_t *lock);//ʹ�øú��ö�д����������ܻ�ã�����������ֱ����øö�д��
              void read_unlock(rwlock_t *lock);//ʹ�øú����ͷŶ�д��lock
              void write_lock(rwlock_t *lock);//ʹ�øú��û�ö�д����������ܻ�ã�����������ֱ����øö�д��
              void write_unlock(rwlock_t *lock);//ʹ�øú����ͷŶ�д��lock
             3)���������е�spin_trylock(lock),��д���зֱ�Ϊ��д�ṩ�˳��Ի�ȡ�������������صĺ����������ã������������棬���򷵻ؼ٣�
              read_trylock(lock)��write_lock(lock);
             4)Ӳ�жϰ�ȫ�Ķ�д��������
             read_lock_irq(lock);//���߻�ȡ��д��������ֹ�����ж�
             read_unlock_irq(lock);//�����ͷŶ�д������ʹ�ܱ����ж�
             write_lock_irq(lock);//д�߻�ȡ��д��������ֹ�����ж�
             write_unlock_irq(lock);//д���ͷŶ�д������ʹ�ܱ����ж�
             read_lock_irqsave(lock, flags);//���߻�ȡ��д����ͬʱ�����жϱ�־������ֹ�����ж�
             read_unlock_irqrestores(lock,flags);//�����ͷŶ�д����ͬʱ�ָ��жϱ�־����ʹ�ܱ����ж�
             write_lock_irqsave(lock,flags);//д�߻�ȡ��д����ͬʱ�����жϱ�־������ֹ�����ж�
             write_unlock_irqstore(lock,flags);д���ͷŶ�д����ͬʱ�ָ��жϱ�־����ʹ�ܱ����ж�
             5)���жϰ�ȫ�Ķ�д������
             read_lock_bh(lock);//���߻�ȡ��д��������ֹ�������ж�
             read_unlock_bh(lock);//�����ͷŶ�д������ʹ�ܱ������ж�
             write_lock_bh(lock);//д�߻�ȡ��д��������ֹ�������ж�
             write_unlock_bh(lock);//д���ͷŶ�д������ʹ�ܱ������ж�
}


https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

rwlock(ibm)
{
��д��ʵ����һ������������������ѶԹ�����Դ�ķ����߻��ֳɶ��ߺ�д�ߣ�����ֻ�Թ�����Դ���ж����ʣ�д������Ҫ�Թ�����Դ����д������
��������������������ԣ�����߲����ԣ���Ϊ�ڶദ����ϵͳ�У�������ͬʱ�ж�����������ʹ�����Դ�������ܵĶ�����Ϊʵ�ʵ��߼�CPU����
д���������Եģ�һ����д��ͬʱֻ����һ��д�߻������ߣ���CPU����أ���������ͬʱ���ж�������д�ߡ�

�ڶ�д�������ڼ�Ҳ����ռʧЧ�ġ�

�����д����ǰû�ж��ߣ�Ҳû��д�ߣ���ôд�߿������̻�ö�д�����������������������ֱ��û���κ�д�߻���ߡ������д��û��д�ߣ�
��ô���߿���������øö�д����������߱������������ֱ��д���ͷŸö�д����

DEFINE_RWLOCK(x)		//��̬��ʼ��
RW_LOCK_UNLOCKED		//��̬��ʼ��һ����д����
DEFINE_RWLOCK(x)��ͬ��rwlock_t x = RW_LOCK_UNLOCKED


rwlock_init(x)			//��̬��ʼ��


read_trylock(lock)  ����������������ö�д��lock������ܹ�������ö�д�������ͻ�����������棬�����ܻ���������ؼ١������Ƿ��ܹ��������
                    �������������أ��������������
write_trylock(lock) д��������������ö�д��lock������ܹ�������ö�д�������ͻ�����������棬�����ܻ���������ؼ١������Ƿ��ܹ��������
                    �������������أ��������������

					
read_lock(lock)     ����Ҫ���ʱ���д��lock�����Ĺ�����Դ����Ҫʹ�øú����õ���д��lock������ܹ�������ã�����������ö�д�������أ�����
                    �����������ֱ����øö�д����
read_unlock(lock)	����ʹ�øú����ͷŶ�д��lock����������read_lock���ʹ�á�
write_lock(lock)    д��Ҫ����ʱ���д��lock�����Ĺ�����Դ����Ҫʹ�øú����õ���д��lock������ܹ�������ã�����������ö�д�������أ�����
                    �����������ֱ����øö�д����					
write_unlock(lock)  д��ʹ�øú����ͷŶ�д��lock����������write_lock���ʹ�á�					
					
read_lock_irqsave(lock, flags)  ����Ҳ����ʹ�øú�����ö�д������read_lock��ͬ���ǣ��ú껹ͬʱ�ѱ�־�Ĵ�����ֵ���浽�˱���flags�У�
                                ��ʧЧ�˱����жϡ�
read_unlock_irqrestore(lock, flags) ����Ҳ����ʹ�øú����ͷŶ�д������read_unlock��ͬ���ǣ��ú껹ͬʱ�ѱ�־�Ĵ�����ֵ�ָ�Ϊ����flags��ֵ��
                                    ��������read_lock_irqsave���ʹ�á�								
write_lock_irqsave(lock, flags) д�߿�����������ö�д������write_lock��ͬ���ǣ��ú껹ͬʱ�ѱ�־�Ĵ�����ֵ���浽�˱���flags�У�
                                ��ʧЧ�˱����жϡ�
write_unlock_irqrestore(lock, flags) д��Ҳ����ʹ�øú����ͷŶ�д������write_unlock��ͬ���ǣ��ú껹ͬʱ�ѱ�־�Ĵ�����ֵ�ָ�Ϊ����flags��ֵ��
                                     ��ʹ�ܱ����жϡ���������write_lock_irqsave���ʹ�á�


read_lock_irq(lock)  ����Ҳ������������ö�д������read_lock��ͬ���ǣ��ú껹ͬʱʧЧ�˱����жϡ��ú���read_lock_irqsave�Ĳ�֮ͬ���ǣ�
                     ��û�б����־�Ĵ�����
read_unlock_irq(lock) ����Ҳ����ʹ�øú����ͷŶ�д������read_unlock��ͬ���ǣ��ú껹ͬʱʹ�ܱ����жϡ���������read_lock_irq���ʹ�á�
					 
write_lock_irq(lock) д��Ҳ�������������������write_lock��ͬ���ǣ��ú껹ͬʱʧЧ�˱����жϡ��ú���write_lock_irqsave�Ĳ�֮ͬ���ǣ�
                     ��û�б����־�Ĵ�����		
write_unlock_irq(lock) д��Ҳ����ʹ�øú����ͷŶ�д������write_unlock��ͬ���ǣ��ú껹ͬʱʹ�ܱ����жϡ���������write_lock_irq���ʹ�á�

read_lock_bh(lock)   ����Ҳ������������ö�д��������read_lock��ͬ���ǣ��ú껹ͬʱʧЧ�˱��ص����жϡ�
read_unlock_bh(lock) ����Ҳ����ʹ�øú����ͷŶ�д������read_unlock��ͬ���ǣ��ú껹ͬʱʹ�ܱ������жϡ���������read_lock_bh���ʹ�á�
write_lock_bh(lock)  д��Ҳ������������ö�д������write_lock��ͬ���ǣ��ú껹ͬʱʧЧ�˱��ص����жϡ�
write_unlock_bh(lock) д��Ҳ����ʹ�øú����ͷŶ�д������write_unlock��ͬ���ǣ��ú껹ͬʱʹ�ܱ������жϡ���������write_lock_bh���ʹ�á�

}


���������ʵ�ֻ����ǣ�ÿһ���������������CPU�϶���һ�����ض���д������һ�����߽���Ҫ��ñ���CPU�Ķ���������д�߱���������CPU�ϵ�����


void br_read_lock (enum brlock_indices idx);
����ʹ�øú�������ô������idx����2.4�ں��У�Ԥ�����idx�����ֵ��������BR_GLOBALIRQ_LOCK��BR_NETPROTO_LOCK����Ȼ���û���������Լ�����Ĵ������ID ��
void br_read_unlock (enum brlock_indices idx);
����ʹ�øú����ͷŴ������idx��

void br_write_lock (enum brlock_indices idx);
д��ʹ��������ô������idx��
void br_write_unlock (enum brlock_indices idx);
д��ʹ�������ͷŴ������idx��

br_read_lock_irqsave(idx, flags)
����Ҳ����ʹ�øú�����ô������idx����br_read_lock��ͬ���ǣ��ú껹ͬʱ�ѼĴ�����ֵ���浽����flags�У�����ʧЧ�����жϡ�
br_read_lock_irq(idx)
����Ҳ����ʹ�øú�����ô������idx����br_read_lock��ͬ���ǣ��ú껹ͬʱʧЧ�����жϡ���br_read_lock_irqsave��ͬ���ǣ��ú겻�����־�Ĵ�����
br_read_lock_bh(idx)
����Ҳ����ʹ�øú�����ô������idx����br_read_lock��ͬ���ǣ��ú껹ͬʱʧЧ�������жϡ�

br_write_lock_irqsave(idx, flags)
д��Ҳ����ʹ�øú�����ô������idx����br_write_lock��ͬ���ǣ��ú껹ͬʱ�ѼĴ�����ֵ���浽����flags�У�����ʧЧ�����жϡ�
br_write_lock_irq(idx)
д��Ҳ����ʹ�øú�����ô������idx����br_write_lock��ͬ���ǣ��ú껹ͬʱʧЧ�����жϡ���br_write_lock_irqsave��ͬ���ǣ��ú겻�����־�Ĵ�����
br_write_lock_bh(idx)
д��Ҳ����ʹ�øú�����ô������idx����br_write_lock��ͬ���ǣ��ú껹ͬʱʧЧ�������жϡ�

br_read_unlock_irqrestore(idx, flags)
����Ҳʹ�øú����ͷŴ������idx������br_read_unlock��֮ͬ���ǣ��ú껹ͬʱ�ѱ���flags��ֵ�ָ�����־�Ĵ�����
br_read_unlock_irq(idx)
����Ҳʹ�øú����ͷŴ������idx������br_read_unlock��֮ͬ���ǣ��ú껹ͬʱʹ�ܱ����жϡ�
br_read_unlock_bh(idx)
����Ҳʹ�øú����ͷŴ������idx������br_read_unlock��֮ͬ���ǣ��ú껹ͬʱʹ�ܱ������жϡ�

br_write_unlock_irqrestore(idx, flags)
д��Ҳʹ�øú����ͷŴ������idx������br_write_unlock��֮ͬ���ǣ��ú껹ͬʱ�ѱ���flags��ֵ�ָ�����־�Ĵ�����
br_write_unlock_irq(idx)
д��Ҳʹ�øú����ͷŴ������idx������br_write_unlock��֮ͬ���ǣ��ú껹ͬʱʹ�ܱ����жϡ�
br_write_unlock_bh(idx)
д��Ҳʹ�øú����ͷŴ������idx������br_write_unlock��֮ͬ���ǣ��ú껹ͬʱʹ�ܱ������жϡ�

��ЩAPI��ʹ�����д����ȫһ�¡�

























					 