seqlock(API)
{
    ʹ��˳��������ִ�е�Ԫ�����ᱻдִ�е�Ԫ������ͬʱдִ�е�ԪҲ����Ҫ�ȴ����ж�ִ�е�Ԫ��ɶ�������Ž���д������
����дִ�е�Ԫ֮����Ȼ�ǻ���ġ������ִ�е�Ԫ�ڶ������ڼ䣬дִ�е�Ԫ�Ѿ������˲�������ô����ִ�е�Ԫ�������¶�ȡ���ݣ�
�Ա�ȷ���õ��������������ġ�

�������㣺˳������һ�����ƣ�����������Ҫ�󱻱����Ĺ�����Դ������ָ�롣��Ϊдִ�е�Ԫ����ʹ��ָ��ʧЧ������ִ�е�Ԫ�����Ҫ���ʸ�ָ�룬������Oops��

��Linux�ں��С���ִ�е�Ԫ�������˳���������
1)����ʼ
unsigned read_seqbegin(const seqlock_t *s1);
read_seqbegin_irqsave(lock, flag);[ read_seqbegin_irqsave(lock, flag)=local_irq_save() + read_seqbegin();]

2)�ض�
int read_seqretry(const seqlock_t *s1, unsigned iv);
read_seqretry_irqrestore(lock, iv, flag);[read_seqretry_irqrestore(lock, iv, flag��= read_seqretry()+ local_irq_restore();]

��ִ�е�Ԫʹ��˳������ģʽ���£�
do{
    seqnum = read_seqbegin(&seqlock_a);
    //�����������
    ������
}while(read_seqretry(&seqlock_a, seqnum));

��Linux�ں��С�дִ�е�Ԫ�������˳���������
1)���˳����
void write_seqlock(seqlock_t *s1);
int write_ tryseqlock(seqlock_t *s1);
write_seqlock_irqsave(lock, flags);[=local_irq_save() + write_seqlock()]
write_seqlock_irq(lock);[=local_irq_disable() + write_seqlock()]
write_seqlock_bh(lock);[=local_bh_disable() + write_seqlock()]

2)�ͷ�˳����
void write_sequnlock(seqlock_t *s1);
write_sequnlock_irqrestore(lock, flag);[=write_sequnlock() + local_irq_restore()]
write_sequnlock_irq(lock);[=write_sequnlock() + local_irq_enable()]
write_sequnlock_bh(lock);[write_sequnlock()+local_bh_enable()]
дִ�е�Ԫʹ��˳������ģʽ���£�
write_seqlock(&seqlock_a);
��//д��������
write_sequnlock(&seqlock_a);

}

https://www.ibm.com/developerworks/cn/linux/l-synch/part2/

    ˳����Ҳ�ǶԶ�д����һ���Ż�������˳���������߾����ᱻд��������Ҳ��˵�����߿�����д�߶Ա�˳���������Ĺ�����Դ����д����ʱ��Ȼ���Լ�������
�����صȴ�д�����д������д��Ҳ����Ҫ�ȴ����ж�����ɶ�������ȥ����д���������ǣ�д����д��֮����Ȼ�ǻ���ģ��������д���ڽ���д������
����д�߱������������ֱ��д���ͷ���˳������

��������һ�����ƣ�������Ҫ�󱻱����Ĺ�����Դ������ָ�룬��Ϊд�߿���ʹ��ָ��ʧЧ�������������Ҫ���ʸ�ָ�룬������OOPs��
��������ڶ������ڼ䣬д���Ѿ�������д��������ô�����߱������¶�ȡ���ݣ��Ա�ȷ���õ��������������ġ�
���������ڶ�дͬʱ���еĸ��ʱȽ�С������������Ƿǳ��õģ������������дͬʱ���У�������������˲����ԡ�

void write_seqlock(seqlock_t *sl);
д���ڷ��ʱ�˳����s1�����Ĺ�����Դǰ��Ҫ���øú��������˳����s1��
��ʵ�ʹ����ϵ�ͬ��spin_lock��ֻ��������һ����˳����˳��ŵļ�1�������Ա�����ܹ������Ƿ��ڶ��ڼ���д�߷��ʹ���

void write_sequnlock(seqlock_t *sl);
д���ڷ����걻˳����s1�����Ĺ�����Դ����Ҫ���øú������ͷ�˳����s1��
��ʵ�ʹ����ϵ�ͬ��spin_unlock��ֻ��������һ����˳����˳��ŵļ�1�������Ա�����ܹ������Ƿ��ڶ��ڼ���д�߷��ʹ���

д��ʹ��˳������ģʽ���£�
write_seqlock(&seqlock_a);
//д���������
��
write_sequnlock(&seqlock_a);
��ˣ���д�߶��ԣ�����ʹ����spinlock��ͬ��

int write_tryseqlock(seqlock_t *sl);
д���ڷ��ʱ�˳����s1�����Ĺ�����ԴǰҲ���Ե��øú��������˳����s1����ʵ�ʹ����ϵ�ͬ��spin_trylock��ֻ������ɹ��������
�ú���������һ����˳����˳��ŵļ�1�������Ա�����ܹ������Ƿ��ڶ��ڼ���д�߷��ʹ���

unsigned read_seqbegin(const seqlock_t *sl);
�����ڶԱ�˳����s1�����Ĺ�����Դ���з���ǰ��Ҫ���øú���������ʵ��û���κεõ������ͷ����Ŀ������ú���ֻ�Ƿ���˳����s1�ĵ�ǰ˳��š�

int read_seqretry(const seqlock_t *sl, unsigned iv);
�����ڷ����걻˳����s1�����Ĺ�����Դ����Ҫ���øú�������飬�ڶ������ڼ��Ƿ���д�߷����˸ù�����Դ��
����ǣ����߾���Ҫ���½��ж����������򣬶��߳ɹ�����˶�������

��ˣ�����ʹ��˳������ģʽ���£�

do {
   seqnum = read_seqbegin(&seqlock_a);
//�����������
...
} while (read_seqretry(&seqlock_a, seqnum));
write_seqlock_irqsave(lock, flags)

д��Ҳ�����øú������˳����lock����write_seqlock��ͬ���ǣ��ú�ͬʱ���ѱ�־�Ĵ�����ֵ���浽����flags�У�����ʧЧ�˱����жϡ�
write_seqlock_irq(lock)

д��Ҳ�����øú������˳����lock����write_seqlock��ͬ���ǣ��ú�ͬʱ��ʧЧ�˱����жϡ���write_seqlock_irqsave��ͬ���ǣ��ú겻�����־�Ĵ�����
write_seqlock_bh(lock)

д��Ҳ�����øú������˳����lock����write_seqlock��ͬ���ǣ��ú�ͬʱ��ʧЧ�˱������жϡ�

write_sequnlock_irqrestore(lock, flags)
д��Ҳ�����øú����ͷ�˳����lock����write_sequnlock��ͬ���ǣ��ú�ͬʱ���ѱ�־�Ĵ�����ֵ�ָ�Ϊ����flags��ֵ����������write_seqlock_irqsave���ʹ�á�

write_sequnlock_irq(lock)
д��Ҳ�����øú����ͷ�˳����lock����write_sequnlock��ͬ���ǣ��ú�ͬʱ��ʹ�ܱ����жϡ���������write_seqlock_irq���ʹ�á�

write_sequnlock_bh(lock)
д��Ҳ�����øú����ͷ�˳����lock����write_sequnlock��ͬ���ǣ��ú�ͬʱ��ʹ�ܱ������жϡ���������write_seqlock_bh���ʹ�á�

read_seqbegin_irqsave(lock, flags)
�����ڶԱ�˳����lock�����Ĺ�����Դ���з���ǰҲ����ʹ�øú������˳����lock�ĵ�ǰ˳��ţ���read_seqbegin��ͬ���ǣ���ͬʱ���ѱ�־�Ĵ�����ֵ���浽����flags�У�����ʧЧ�˱����жϡ�ע�⣬��������read_seqretry_irqrestore���ʹ�á�

read_seqretry_irqrestore(lock, iv, flags)
�����ڷ����걻˳����lock�����Ĺ�����Դ���з��ʺ�Ҳ����ʹ�øú�����飬�ڶ������ڼ��Ƿ���д�߷����˸ù�����Դ������ǣ����߾���Ҫ���½��ж����������򣬶��߳ɹ�����˶�����������read_seqretry��ͬ���ǣ��ú�ͬʱ���ѱ�־�Ĵ�����ֵ�ָ�Ϊ����flags��ֵ��ע�⣬��������read_seqbegin_irqsave���ʹ�á�

��ˣ�����ʹ��˳������ģʽҲ����Ϊ��

do {
   seqnum = read_seqbegin_irqsave(&seqlock_a, flags);
//�����������
...
} while (read_seqretry_irqrestore(&seqlock_a, seqnum, flags));

���ߺ�д����ʹ�õ�API�ļ����汾Ӧ�����ʹ���������������ơ�

���д���ڲ�����˳���������Ĺ�����Դʱ�Ѿ������˻����������Թ������ݵ�д��������д����д��֮���Ѿ��ǻ���ģ���������Ȼ������д��ͬʱ���ʣ���ô�����������Ҫʹ��˳�������seqcount����������Ҫspinlock��

˳�������API���£�

unsigned read_seqcount_begin(const seqcount_t *s);
�����ڶԱ�˳����������Ĺ�����Դ���ж�����ǰ��Ҫʹ�øú�������õ�ǰ��˳��š�

int read_seqcount_retry(const seqcount_t *s, unsigned iv);
�����ڷ����걻˳�����s�����Ĺ�����Դ����Ҫ���øú�������飬�ڶ������ڼ��Ƿ���д�߷����˸ù�����Դ������ǣ����߾���Ҫ���½��ж����������򣬶��߳ɹ�����˶�������

��ˣ�����ʹ��˳�������ģʽ���£�

do {
   seqnum = read_seqbegin_count(&seqcount_a);
//�����������
...
} while (read_seqretry(&seqcount_a, seqnum));
void write_seqcount_begin(seqcount_t *s);
д���ڷ��ʱ�˳����������Ĺ�����Դǰ��Ҫ���øú�������˳�������˳��ż�1���Ա�����ܹ������Ƿ��ڶ��ڼ���д�߷��ʹ���

void write_seqcount_end(seqcount_t *s);
д���ڷ����걻˳����������Ĺ�����Դ����Ҫ���øú�������˳�������˳��ż�1���Ա�����ܹ������Ƿ��ڶ��ڼ���д�߷��ʹ���
д��ʹ��˳�������ģʽΪ��
write_seqcount_begin(&seqcount_a);
//д���������
��
write_seqcount_end(&seqcount_a);

��Ҫ�ر����ѣ�˳�������ʹ�ñ���ǳ�������ֻ��ȷ���ڷ��ʹ�������ʱ�Ѿ������˻������ſ���ʹ�á�










