�жϹ������ص㣺�жϹ����Ƕ���豸����һ��Ӳ���ж��ߵ������Linux2.6�ں�֧���жϹ���ʹ�÷������£�
*�����жϵĶ���豸�������ж�ʱ��Ӧ��ʹ��SA_SHIRQ��־������һ���豸��SA_SHIRQ����ĳ�жϳɹ���ǰ����֮ǰ���жϵ������豸Ҳ����SA_SHIRQ��־������ն�
*�����ں�ģ��ɷ��ʵ�ȫ�ֵ�ַ��������Ϊrequest_irq(��.,void *dev_id)�����һ������dev_id,�����豸�ṹ��ָ���ǿɴ������Ѳ�����
*���жϴ���ʱ�����й�����жϵ��жϴ�����򶼻ᱻִ�У����жϴ�����򶥰벿�У�ӦѸ�ٸ���Ӳ���Ĵ����е���Ϣ���մ����dev_id�����ж��Ƿ��Ǳ��豸���жϣ�������ǣ�ӦѸ�ٷ���

irq(�ж�������)
{
1. ϵͳ�����׶Σ�ȡ�����ں˵����ã��ں˻�ͨ������������������㹻���irq_desc�ṹ��
2. ���ݲ�ͬ����ϵ�ṹ����ʼ���ж���ص�Ӳ�����������жϿ�������
3. Ϊÿ����Ҫirq��irq_desc�ṹ���Ĭ�ϵ��ֶΣ�����irq��ţ�irq_chipָ�룬���ݲ�ͬ���ж�������������handler��
4. �豸���������ڳ�ʼ���׶Σ�����request_threaded_irq() api�����жϷ���������Ҫ�Ĳ�����handler��thread_fn��
5. ���豸����һ���жϺ�cpu����������趨�õ��ж���ڣ������ڵײ���ϵ��صĴ��룬��ͨ���жϿ��������irq��ţ�
   �ڶ�irq_data�ṹ�е�ĳЩ�ֶν��д���󣬻Ὣ����Ȩ���ݵ��ж����ز㣨ͨ��irq_desc->handle_irq����
6. �ж����ش��������������Ҫ�����ش����ͨ��irq_desc->action����ȡ���������������ж�ʱע���handler
   ��thread_fn���������ǵĸ�ֵ���������ֻ�ǵ���handler�ص�����������һ���߳�ִ��thread_fn���ֻ������߶�ִ�У�
7. ���ˣ��ж����������������������Ӧ�ʹ���
}

irq(��ʼ��)
{
1	���ȣ���setup_arch�����У�early_trap_init�����ã���������˵�1����˵���ж������Ŀ������ض�λ������
2	Ȼ��start_kernel����early_irq_init���ã�early_irq_init������Ӳ����ƽ̨�޹ص�ͨ���߼��㣬�����irq_desc�ṹ
    ���ڴ����룬Ϊ��������ĳЩ�ֶ����Ĭ��ֵ����ɺ������ϵ��ص�arch_early_irq_init������ɽ�һ���ĳ�ʼ��������
    ����ARM��ϵû��ʵ��arch_early_irq_init��
3	���ţ�start_kernel����init_IRQ���ã�����ֱ�ӵ�����������machine_desc�ṹ���е�init_irq�ص���machine_descͨ��
    �ڰ��ӵ��ض������У�ʹ��MACHINE_START��MACHINE_END����ж��塣
4	machine_desc->init_irq()��ɶ��жϿ������ĳ�ʼ����Ϊÿ��irq_desc�ṹ��װ���ʵ�����handler��Ϊÿ��irq_desc�ṹ
    ��װirq_chipָ�룬ʹ��ָ����ȷ���жϿ���������Ӧ��irq_chip�ṹ��ʵ����ͬʱ�������ƽ̨�е��ж����ж�·����
    ������жϹ���һ��irq�ж��ߣ����������Ӧ�ó�ʼ��irq_desc����Ӧ���ֶκͱ�־���Ա�ʵ���жϿ������ļ�����
}

irq(�жϿ�����)
{
1. �Ը���irq�����ȼ����п��ƣ�
2. ��CPU�����ж�������ṩĳ�ֻ�����CPU���ʵ�ʵ��ж�Դ��irq��ţ���
3. ���Ƹ���irq�ĵ������������������Ե���������ǵ�ƽ������
4. ʹ�ܣ�enable���������Σ�mask��ĳһ��irq��
5. �ṩǶ���ж������������
6. �ṩ����ж�����Ļ��ƣ�ack����
7. ��Щ����������ҪCPU�ڴ�����irq��Կ���������eoiָ�end of interrupt����
8. ��smpϵͳ�У����Ƹ���irq��cpu֮�����Ե��ϵ��affinity����

}


irq(ARM���쳣������)
{
arm���쳣�͸�λ������������ѡ��һ���ǵͶ�������������ַλ��0x00000000����һ���Ǹ߶�������������ַλ��0xffff0000��Linuxѡ��ʹ�ø߶�����ģʽ��Ҳ����˵�����쳣����ʱ��CPU���PCָ���Զ���ת��ʼ��0xffff0000��ʼ��ĳһ����ַ�ϣ�

ARM���쳣������ ��ַ 	�쳣����
FFFF0000 	��λ
FFFF0004 	δ����ָ��
FFFF0008 	���жϣ�swi��
FFFF000C 	Prefetch abort
FFFF0010 	Data abort
FFFF0014 	����
FFFF0018 	IRQ
FFFF001C 	FIQ

�ж���������arch/arm/kernel/entry_armv.S�ж���
}

file()
{
arch/xxx/mach-xxx/include/irqs.h
kernel/irq/irqdesc.c
include/linux/irq.h
kernel/irq/settings.h
kernel/irq/chip.c  #ͨ���ж���ϵͳ�Ѽ��ֳ��õ��������ͽ����˳��󣬲�Ϊ����ʵ������Ӧ�ı�׼������

CONFIG_SPARSE_IRQ

struct irq_data
struct irq_desc

/proc/interrupts���ļ�
/proc/irq����Ŀ¼

arch/arm/
arch/arm/kernel/entry_armv.S #�ж���������
arch/arm/kernel/traps.c      #ϵͳ�����׶Σ�λ��arch/arm/kernel/traps.c�е�early_trap_init()�����ã�
arch/arm/include/asm/entry_macro_multi.S #arch_irq_handler_default

arch/xxx/mach-xxx # ����������жϿ���������
/arch/arm/plat-s5p/irq-eint.c # ����������жϿ��������� s5p_init_irq_eint ����ʵ�ּ���

��ͨ���ж���ϵͳ��صĳ�ʼ����start_kernel()��������

[�жϿ������ӿں�Linux��׼�ӿڽ��й���]
irq_chipʵ��ע�ᵽirq_desc.irq_data.chip�ֶ��У���������irq���жϿ������ͽ����˹�����ֻҪ֪��irq��ţ�
���ɵõ���Ӧ��irq_desc�ṹ����������ͨ��chipָ������жϿ�������

[�жϴ�������]

irq_handler(arch_irq_handler_default) #arch/arm/kernel/entry-armv.S
arch_irq_handler_default(asm_do_IRQ)  #arch/arm/include/asm/entry_macro_multi.S
asm_do_IRQ -> handle_IRQ -> generic_handle_irq -> generic_handle_irq_desc -> desc->handle_irq(irq, desc);

���ڵ��ں˰汾�У��������е��ж϶�����__do_IRQ�������д���                         
}

irq_chip(struct) {
	const char	*name;
name  �жϿ����������֣�������� /proc/interrupts�С�
	unsigned int	(*irq_startup)(struct irq_data *data);
irq_startup  ��һ�ο���һ��irqʱʹ�á�
	void		(*irq_shutdown)(struct irq_data *data);
irq_shutdown  ��irq_starup���Ӧ��
	void		(*irq_enable)(struct irq_data *data);
irq_enable  ʹ�ܸ�irq��ͨ����ֱ�ӵ���irq_unmask()��
	void		(*irq_disable)(struct irq_data *data);
    irq_disable  ��ֹ��irq��ͨ����ֱ�ӵ���irq_mask���ϸ������ϣ�������ʵ����ͬ�����壬disable��ʾ�жϿ���������
 �Ͳ���Ӧ��irq����maskʱ���жϿ�����������Ӧ��irq��ֻ�ǲ�֪ͨCPU����ʱ����irq����pending״̬�����Ƶ�����Ҳ������
 enable��unmask��
	void		(*irq_ack)(struct irq_data *data);
irq_ack  ����CPU�Ը�irq�Ļ�Ӧ��ͨ����ʾcpuϣ��Ҫ�����irq��pending״̬��׼��������һ��irq���� 
	void		(*irq_mask)(struct irq_data *data);
irq_mask  ���θ�irq��
    void		(*irq_unmask)(struct irq_data *data);
    irq_unmask  ȡ�����θ�irq��
	void		(*irq_mask_ack)(struct irq_data *data);
irq_mask_ack  �൱��irq_mask + irq_ack��
	void		(*irq_eoi)(struct irq_data *data);
irq_eoi  ��Щ�жϿ�������Ҫ��cpu�������irq�󷢳�eoi�źţ��ûص������������Ŀ�ġ�
	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
irq_set_affinity  �������ø�irq��cpu֮�����Ե��ϵ������֪ͨ�жϿ���������irq����ʱ����Щcpu��Ȩ��Ӧ��irq��
��Ȼ���жϿ������������������£�����ֻ����һ��cpu����������
	int		(*irq_retrigger)(struct irq_data *data);
	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
irq_set_type  ����irq�ĵ�����������������IRQ_TYPE_LEVEL_HIGH��IRQ_TYPE_EDGE_RISING��
	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
irq_set_wake  ֪ͨ��Դ������ϵͳ����irq�Ƿ��������ϵͳ�Ļ���Դ��
	void		(*irq_bus_lock)(struct irq_data *data);
	void		(*irq_bus_sync_unlock)(struct irq_data *data);

	void		(*irq_cpu_online)(struct irq_data *data);
	void		(*irq_cpu_offline)(struct irq_data *data);

	void		(*irq_suspend)(struct irq_data *data);
	void		(*irq_resume)(struct irq_data *data);
	void		(*irq_pm_shutdown)(struct irq_data *data);

	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);

	unsigned long	flags;

	/* Currently used only by UML, might disappear one day.*/
#ifdef CONFIG_IRQ_RELEASE_METHOD
	void		(*release)(unsigned int irq, void *dev_id);
#endif
};

irq_data(struct) {
	unsigned int		irq;
irq  �ýṹ����Ӧ��IRQ��š�
	unsigned long		hwirq;
hwirq  Ӳ��irq��ţ�����ͬ�������irq��
	unsigned int		node;
node  ͨ������hwirq��irq֮���ӳ�������
	unsigned int		state_use_accessors;
state_use_accessors  Ӳ����װ����Ҫʹ�õ�״̬��Ϣ����Ҫֱ�ӷ��ʸ��ֶΣ�
�ں˶�����һ�麯�����ڷ��ʸ��ֶΣ�irqd_xxxx()���μ�include/linux/irq.h��
	struct irq_chip		*chip;
chip  ָ���irq�������жϿ�������irq_chip�ṹָ��
	struct irq_domain	*domain;
	void			*handler_data;
 handler_data  ÿ��irq��˽������ָ�룬���ֶ���Ӳ����ת��ʹ�ã����������ײ�Ӳ���Ķ�·�����жϡ�
	void			*chip_data;
chip_data  �жϿ�������˽�����ݣ����ֶ���Ӳ����ת��ʹ�á�
	struct msi_desc		*msi_desc;
msi_desc  ����PCIe���ߵ�MSI��MSI-X�жϻ��ơ� 
#ifdef CONFIG_SMP
	cpumask_var_t		affinity;
affinity  ��¼��irq��cpu֮�����Ե��ϵ������ʵ��һ��bit-mask��ÿһ��bit����һ��cpu��
��λ������cpu���ܴ����irq��
#endif
};


irq_desc(struct) {
	struct irq_data		irq_data;
irq_data  �����Ƕ�ṹ��2.6.37�汾���룬֮ǰ���ں˰汾��������ֱ�Ӱ�����ṹ�е��ֶ�ֱ�ӷ�����
irq_desc�ṹ���У�Ȼ���ڵ���Ӳ����װ���chip->xxx()�ص��д���IRQ�����Ϊ���������ǵײ�ĺ���
������Ҫ����->handler_data��->chip_data��->msi_desc���ֶΣ�����Ҫ����irq_to_desc(irq)�����
irq_desc�ṹ��ָ�룬Ȼ����ܷ��������ֶΣ��ߴ��������ܵĽ��ͣ�����������Ϊsparse irq��ϵͳ��
������ˣ���Ϊ����ζ�Ż�����������������Ϊ�˽����һ���⣬�ں˿����߰Ѽ����Ͳ㺯����Ҫʹ�õ�
�ֶε�����װΪһ���ṹ������ʱ�Ĳ������Ϊ����ýṹ��ָ�롣ʵ��ͬ����Ŀ�ģ���Ϊʲô��ֱ�Ӵ���
irq_desc�ṹָ�룿��Ϊ����ƻ���εķ�װ�ԣ����ǲ�ϣ���Ͳ������Կ�����Ӧ�ÿ����Ĳ��֣����˶��ѡ�
    
	unsigned int __percpu	*kstat_irqs;
kstat_irqs  ����irq��һЩͳ����Ϣ����Щͳ����Ϣ���Դ�proc�ļ�ϵͳ�в�ѯ�� 
    
	irq_flow_handler_t	handle_irq;
#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
	irq_preflow_handler_t	preflow_handler;
#endif
	struct irqaction	*action;	/* IRQ action list */
action  �ж���Ӧ������һ��irq������ʱ���ں˻��������������action�ṹ�еĻص�handler���߼�������
���ж��̣߳�֮����ʵ��Ϊһ��������Ϊ��ʵ���жϵĹ�������豸����ͬһ��irq��������Χ�豸�����ձ�
���ڵġ�
    
	unsigned int		status_use_accessors;
status_use_accessors  ��¼��irq��״̬��Ϣ���ں��ṩ��һϵ��irq_settings_xxx�ĸ����������ʸ��ֶΣ�
��ϸ��鿴kernel/irq/settings.h
    
	unsigned int		depth;		/* nested irq disables */
depth  ���ڹ���enable_irq()/disable_irq()������API��Ƕ����ȹ���ÿ��enable_irqʱ��ֵ��ȥ1��
ÿ��disable_irqʱ��ֵ��1��ֻ��depth==0ʱ��������Ӳ����װ�㷢���ر�irq�ĵ��ã�ֻ��depth==1ʱ��
����Ӳ����װ�㷢����irq�ĵ��á�disable��Ƕ�״������Ա�enable�Ĵ����࣬��ʱdepth��ֵ����1��
����enable�Ĳ��ϵ��ã���depth��ֵΪ1ʱ������Ӳ����װ�㷢����irq�ĵ��ú�depth��ȥ1��
��ʱdepthΪ0����ʱ����һ��ƽ��״̬������ֻ�ܵ���disable_irq�������ʱenable_irq�����ã�
�ں˻ᱨ��һ��irqʧ��ľ��棬������������Ŀ�����Ա����Լ��Ĵ��롣

	unsigned int		wake_depth;	/* nested wake enables */
	unsigned int		irq_count;	/* For detecting broken IRQs */

	raw_spinlock_t		lock;
 lock  ���ڱ���irq_desc�ṹ�������������
 
	struct cpumask		*percpu_enabled;
#ifdef CONFIG_SMP
	const struct cpumask	*affinity_hint;
affinity_hit  ������ʾ�û��ռ䣬��Ϊ�Ż�irq��cpu֮�����Ե��ϵ�����ݡ�
	struct irq_affinity_notify *affinity_notify;
#ifdef CONFIG_GENERIC_PENDING_IRQ
	cpumask_var_t		pending_mask;
pending_mask  ���ڵ���irq�ڸ���cpu֮���ƽ�⡣
#endif
#endif
	wait_queue_head_t       wait_for_threads;
wait_for_threads  ����synchronize_irq()���ȴ���irq�����߳���ɡ�
	const char		*name;
} ____cacheline_internodealigned_in_smp;

chip_kernel()
{
    �����豸ʹ�õ��жϿ����������ͣ���ϵ�ܹ��ĵײ�Ŀ���ֻҪʵ�������ӿ��еĸ����ص�������Ȼ���������䵽
irq_chip�ṹ��ʵ���У����հѸ�irq_chipʵ��ע�ᵽirq_desc.irq_data.chip�ֶ��У���������irq���жϿ������ͽ���
�˹�����ֻҪ֪��irq��ţ����ɵõ���Ӧ��irq_desc�ṹ����������ͨ��chipָ������жϿ�������
}

irq(API)
{
1���豸�����ж�
int request_irq(unsigned int irq,  //irq��Ҫ������жϺ�
                    void (*handler)(int irq, void *dev_id, struct pt_regs * *regs),//�ص��������жϷ���ʱ��ϵͳ����øú�����
                    unsigned long irqflags,
                    const char *devname,
                    void *dev_id);
����irqflags���жϴ�������ԣ�������ΪSA_INTERRUPT,���ʾ�жϴ�������ǿ��ٴ��������������ʱ���������жϡ�������ΪSA_SHIRQ,���ʾ����豸�����жϣ�dev_id���жϹ���ʱ���õ���һ������Ϊ����豸���豸�ṹ�����NULL.
�ú�������0��ʾ�ɹ�������-INVAL��ʾ�жϺ���Ч������ָ��ΪNULL,����EBUSY��ʾ�ж��Ѿ���ռ���Ҳ��ܹ���

��һ������irq: ��ʾҪ������жϺš�����һЩ�豸(ϵͳʱ�ӻ����)����ֵ��Ԥ�ȹ̶��ģ������ڴ�����豸��˵�����ֵ�Ƕ�̬ȷ���ġ�




2���ͷ��ж�
free_irq(unsigned int irq, void *dev_id);
3)ʹ�ܺ������ж�
void disable_irq(int irq);   //�������������
void disable_irq_nosync(int irq);//�ȴ�Ŀǰ���жϴ�������ٷ��ء�
void enable_irq(int irq);
�����������������ڿɱ���жϴ���������˶�ϵͳ�����е�CPU����Ч��
void local_irq_save(unsigned long flags);//�ὫĿǰ���ж�״̬������flags��
void local_irq_disable(void);//ֱ���ж�
�����������α�CPU�ڵ������жϡ���Ӧ���ϱ������жϵķ�������
void local_irq_restore(unsigned long flags);
void local_irq_enable(void);

}

��ʼ������жϣ�����ж���Ӳ���ж���������жϷ���ʱ������ж���ʹ���߳��������ж��źţ���Ӳ���ж���ʹ��CPUӲ���������жϡ�

1�� �жϴ������̿������������ʼ��ʱ�����豸��һ�δ�ʱ��װ��
     ��Ȼ��ģ��ĳ�ʼ�������а�װ�жϴ������̿������Ǹ������⣬��ʵ���ϲ�����ˡ���Ϊ�ж��ź��ߵ������ǳ����ޣ����ǲ��������˷ѡ�
	 �����ͨ���е��豸���ж��ź��߶�Ķࡣ
2�� ����request_irq����ȷλ��Ӧ�������豸��һ�δ򿪡�Ӳ������֪�����ж�֮ǰ��
    ����free_irq ��λ�������һ�ιر��豸��Ӳ������֪�������жϴ�����֮��
	 -- ����Ϊÿ���豸ά��һ���򿪼��������ǲ���֪��ʲôʱ����Խ����жϡ�
	 
------ irq ------

static inline int request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
	    const char *name, void *dev)
irq		 �жϺ�
handler Ҫ��װ���жϴ�����ָ��
flags   ���жϹ����йص�λ����
         SA_INTERRUPT: ��������һ�����ٵ��жϴ������̣������ж������������жϵĽ���״̬�¡�
		 SA_SHIRQ:     �жϿ������豸֮�乲��
		 SA_SAMPLE_RANDOM:�������ж��ܶ�/dev/random��/dev/urandom�豸ʹ�õ��س��й��ס�
		 
name    ���ݸ�request_irq���ַ��� /proc/interrupts
dev_id	 ���ڹ�����ж��ź��ߡ�����Ψһ�ı�ʶ�������ж��ź��߿���ʱ����ʹ��������������Ҳ����ʹ����ָ�����������Լ���˽����������
        ��û��ǿ��ʹ�ù���ʽʱ��dev_id���Ա�����ΪNULL����֮������ָ���豸�����ݽṹ��һ���ȽϺõ�˼·��
		
����ֵ 0 �ɹ� ������ʧ�� -EBUSY ��ʾ�Ѿ�����һ����������ռ������Ҫ������ж��ź��ߡ�		
		
a.�����ж�
	�����ж�(fast interrup)���жϴ����������ʱ��ǳ��̣����Ե�ǰ����ϵĻ��ͣʱ��Ҳ�̡ܶ������ж��ص��ǣ����ε�ǰ�����жϴ������CPU
	�������жϣ������жϴ�������ִ�оͲ��ᱻ����жϴ�ϡ�Ҫ���ж�����ע��Ϊ�����жϣ����������ж���Դʱ���ж����ͱ�־flags��Ϊ
	SA_INTERRUPT��
b.�����ж�
	�����ж�(slow interrupt)���жϴ��������ִ���ڼ���Ա�����жϴ�ϡ������жϴ������ִ�е�ʱ�䳡(��Կ����ж϶���),����ռ��CPU��ʱ��Ҳ����
	�жϴ�������ִ��ͨ��������ͣ���б�Ļ����ͬ���ж��ڼ���CPU�Ͽ���ͬʱ���У���ĳ���жϵĴ������һ��ֻ����һ��CPU��ִ��
	�������鿴��ǰCPU�Ƿ����жϻ�У�����Ե����ں˵�API

in_irq()  //include/asm/hardirq.h
		
void free_irq(unsigned int, void *);

proc(interrupts)
{
------ proc�ӿ�------
1����Ӳ�����жϵ��ﴦ����ʱ��һ���ڲ�������������Ϊ����豸�Ƿ�Ԥ�ڹ����ṩ��һ�ַ������������жϱ�����ʾ���ļ�/proc/interrupts�С�
2��Linux�ں�ͨ�����ڵ�һ��CPU�ϴ����жϣ��Ա���󻯻���ı����ԡ�
3���ɱ�̿�������Ϣ��ע�����жϴ������̵��豸���ơ�

/proc/interrupts
�жϺ�             �����жϵ�CPU      �����жϵĿɱ���жϿ�������Ϣ   ע�����жϴ������̵��豸����   ��������ע���irqʱʹ�õ�����

           CPU0       CPU2       CPU3  irq_alloc_generic_chip[s3c-uart]
 16:     220681          0          0  s3c-uart  s5pv210-uart
 18:     329537          0          0  s3c-uart  s5pv210-uart
 24:          0          0          0  s3c-uart  s5pv210-uart
 26:        832          0          0  s3c-uart  s5pv210-uart
 98:          0          0          0       GIC  s3c-pl330.0
 99:          0          0          0       GIC  s3c-pl330.1
100:          0          0          0       GIC  s3c-pl330.2
107:          0          0          0       GIC  s3c2410-wdt
108:          0          0          0       GIC  s3c2410-rtc                                                alarm
121:          9          0          0       GIC  mct_comp_irq
122:          1          0          0       GIC  s3c2440-i2c.0
123:         87          0          0       GIC  s3c2440-i2c.1
124:          0          0          0       GIC  s3c2440-i2c.2
125:          0          0          0       GIC  s3c2440-i2c.3
126:          1          0          0       GIC  s3c2440-i2c.4
127:          0          0          0       GIC  s3c2440-i2c.5
128:          6          0          0       GIC  s3c2440-i2c.6
129:          0          0          0       GIC  s3c2440-i2c.7
134:   22923996          0          0       GIC  ehci_hcd:usb1, ohci_hcd:usb2
135:          0          0          0       GIC  s3c-udc
139:          0          0          0       GIC  mmc1
140:          0          0          0       GIC  mmc2
141:       1569          0          0       GIC  dw-mci
155:          0          0          0       GIC  s5p-mixer
157:          0          0          0       GIC  s3c2440-hdmiphy-i2c
158:          0          0          0       GIC  s5p-mfc
173:          0          0          0       GIC  samsung-keypad
236:          0          0          0  COMBINER  s5p-sysmmu.12
237:          0          0          0  COMBINER  s5p-sysmmu.14
238:          0          0          0  COMBINER  s5p-sysmmu.13
275:          0          0          0  COMBINER  exynos4412-adc
281:          0          0          0  COMBINER  s3cfb
352:          0          0          0  exynos-eint  gpio_keys
355:          0          0          0  exynos-eint  ft5x0x_ts
357:   18038354          0          0  exynos-eint  eth0
380:          1          0          0  exynos-eint  DEVICE_DETECT
381:          0          0          0  exynos-eint  HOST_DETECT
383:          1          0          0  exynos-eint  hdmi
IPI0:          0          0          0          0  Timer broadcast interrupts
IPI1:      78801       1430       2457       5642  Rescheduling interrupts
IPI2:         12          6        616        611  Function call interrupts
IPI3:         10          1        260        481  Single function call interrupts
IPI4:          0          0          0          0  CPU stop interrupts
IPI5:          0          0          0          0  CPU backtrace
LOC:   47062652        791     692755    2814147  Local timer interrupts
}




/proc/stat ��¼��һЩϵͳ��ĵײ�ͳ����Ϣ��������ϵͳ������ʼ���յ����ж�������
intr 92271660 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 220895 0 329859 0 0 0 0 0 0 0 832 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 9 1 87 0 0 1 0 6 0 0 0 0 0 22945972 0 0 0 0 0 0 1599 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 18060150 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

92271660:�����ж�����
����Ĵ���ÿ��IRQ��Ӧ���ж�

interrupts�ļ���������ϵ�ṹ��stat���������ģ��ֶε�������������֮�µ�Ӳ����
x86��ϵ�ṹ������224���ж�



------- �Զ����IRQ�� ------
���������ʼ��ʱ�������е�����֮һ������ξ����豸��Ҫʹ����ЩIRQ�ź��ߡ�����������Ҫ�����Ϣ�Ա���ȷ�ذ�װ�������̣����ܳ���Ա
����Ҫ���û���װ��ʱָ���жϺţ����ⲻ��һ����ϰ�ߣ���Ϊ�󲿷�ʱ���û���֪������жϺţ���������Ϊ�û�û���������ߣ���������Ϊ
�豸�������ߵġ���ˣ��жϺŵ��Զ��������������������˵��һ������Ҫ��

�Զ����IRQ��������һЩ�豸ӵ�е�Ĭ�����ԡ�

�����������ͨ�����豸��ĳ��IO�˿ڻ���PCI���ÿռ��ж���һ��״̬��������жϺš�
�Զ����IRQ��ֻ����ζ��̽���豸��������Ҫ����Ĺ�����̽���жϡ�

{�ں˰����µ�̽��}
linux/interrupt.h
unsigned long probe_irq_on(void)
����һ��δ�����жϵ�λ���롣�����ɱ��뱣�淵�ص�λ���룬���ҽ������ݸ������probe_irq_off��������������Ҫ�����豸��������һ���жϡ�

int probe_irq_off(unsigned long)
�������豸�����ж�֮��������������������������ǰ��long probe_irq_on���ص�λ������Ϊ�������ݸ�����probe_irq_off����probe_irq_on
֮�������жϱ�š����û���жϷ������ͷ���0����������˶���жϣ��ͷ���һ����ֵ��

�ڵ���probe_irq_on֮�������豸�ϵ��жϣ����ڵ���probe_irq_off֮ǰ�����жϡ�����Ҫ��ס����probe_irq_off֮����Ҫ�����豸�ϴ�������жϡ�

------- DIY̽�� ------
̽�������жϺ�



------- x86ƽ̨���жϴ������Ļ ------
arch/i386/kernel/irq.c         do_IRQ() ���ĵ�һ������Ӧ���жϣ������жϿ������Ϳ��Լ������������������ˡ�Ȼ��ú������ڸ�����IRQ�ţ�
                               ���һ������������������ֹ���κ�������CPU�������IRQ�������������״̬λ�����ɺ�Ѱ������ض���IRQ
							   �Ĵ������̡����û�д������̣���ʲôҲ���������������ͷţ������κδ����������жϣ����do_IRQ���ء�
							   
							   ͨ��������豸��һ����ע��Ĵ������̲��ҷ������жϣ�����handle_IRQ_event�ᱻ�����Ա�ʵ�ʵ��ô������̡�
							   ��������������������ͣ�����������Ӳ���жϣ������ô������̡�Ȼ��ֻ����һЩ��������������������жϣ����
							   ���ص����湤���С�
arch/i386/kernel/apic.c        
arch/i386/kernel/entry.S       ��ײ���жϴ������
arch/i386/kernel/i8259.c       
include/asm-i386/hw_irq.h      


------- ʵ���жϴ������� ------
�жϴ������̺��ں˶�ʱ����������һ���ġ�

�жϴ������̵Ĺ��ܾ��ǣ����й��жϽ��յ���Ϣ�������豸�����������ڷ�����жϵĲ�ͬ��������ݽ�����Ӧ�Ķ���д��

�жϴ������̵�һ������������ǣ�����ж�֪ͨ���ȴ����¼��Ѿ������������µ����ݵ���ͻỽ���ڸ��豸�����ߵĽ��С�

------- �������̵Ĳ����ͷ���ֵ ------
irq��    ��������κο��Դ�ӡ����־����Ϣʱ���жϺ��Ǻ����õġ�
dev_id:  ��һ�ֿͻ���������(������������õ�˽������)
regs:    �����˴����������жϴ���֮ǰ�Ĵ����������Ŀ��ա��ɱ��������Ӻ͵��ԡ�

����ֵ��IRQ_HANDLED:�������̷��������豸��ȷ��Ҫ���� IRQ_NONE�� 
        IRQ_RETVAL(handled):���Ҫ������жϣ���handledӦ��ȡ����ֵ������ֵ�����ں�ʹ�ã��Ա��Ⲣ���Ƽٵ��ж�
		����豸�޷����������Ƿ������жϣ���Ӧ����IRQ_HANDLED

------- �����ж� ------
void disable_irq(int irq);         �����жϣ�����ȴ�����ִ�е��жϴ���������ɡ�
void disable_irq_nosync(int irq);  �����жϣ����̷��ء�
void enable_irq(int irq);
������Щ�����е��κ�һ��������¿ɱ���жϿ�������ָ���жϵ����룬����Ϳ��������еĴ������Ͻ��û�������IRQ��
���disable_irq�����ɹ����Σ���ô��IRQ������������ǰ����Ҫ��������enable_irq();

�������е��жϣ�

void local_irq_save(unsigned long flags)
void local_irq_disable(void)
void local_irq_restore(unsigned long flags)
void local_irq_enable(void);

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


���벿--- �жϴ�������
�װ벿--- һ�������벿���ȣ������Ժ����ȫ��ʱ����ִ�е����̡�  -- ���ѽ��̣������������IO���������벿���������жϴ�����������

�װ벿��������ִ��ʱ�����е��ж϶��Ǵ򿪵� -- �������ζ���ڸ���ȫ��ʱ�������С�

�����������������ҪС��ʹ��enable_irq��disable_irq

�����������������Ӳ��֮������ݴ�����Ϊĳ��ԭ���ӳٵĻ��������������߾�Ӧ��ʵ�ֻ��塣���ݻ����������ڽ����ݵĴ��ͺ����ݵĽ���
��ϵͳ����write��read���뿪�����Ӷ����ϵͳ���������ܡ�

һ���õĵĻ��������Ҫ�����ж�������IO������ģʽ�£�һ�����뻺�������ж�ʱ���ڱ���䣬���ɶ�ȡ���豸�Ľ���ȡ�߻������ڵ����ݣ�
һ�������������д���豸�Ľ�����䣬�����ж�ʱ����ȡ�����ݡ�һ���ж����������������/dev/shortint��ʵ�֡�

Ҫ��ȷ�����ж����������ݴ��䣬��Ҫ��Ӳ��Ӧ���ܰ�������������������жϣ�
1. ����������˵�����µ������Ѿ��ﵽ���Ҵ���׼���ý�����ʱ���豸���жϴ�������ʵ��ִ�еĶ���ȡ�����豸ʹ�õ�IO�˿ڡ��ڴ�ӳ�䡢����DMA
2. ���������˵�����豸׼���ý��������ݻ��߶Գɹ������ݴ��ͽ���Ӧ��ʱ����Ҫ�����жϡ��ڴ�ӳ��;���DMA�������豸��ͨ��ͨ�������ж�
   ��֪ͨϵͳ���ǶԻ������Ĵ����Ѿ�������
   
   
atomic(ԭ��������)
{
�ں˵�һ������ԭ����ǣ����жϻ���˵ԭ���������У��ں˲��ܷ����û��ռ䣬�����ں��ǲ���˯�ߵġ�Ҳ����˵����������£��ں��ǲ��ܵ����п�������˯�ߵ��κκ�����һ������ԭ��������ָ�������жϻ����ж��У��Լ��ڳ�����������ʱ���ں��ṩ���ĸ������ж��Ƿ����⼸������

#define in_irq()     (hardirq_count()) //�ڴ���Ӳ�ж���
#define in_softirq()     (softirq_count()) //�ڴ������ж���
#define in_interrupt()   (irq_count()) //�ڴ���Ӳ�жϻ����ж���
#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != 0) //���������������

���ĸ��������ʵ�count����thread_info->preempt_count�����������ʵ��һ��λ���롣���8λ��ʾ��ռ������ͨ����spin_lock/spin_unlock�޸ģ������Աǿ���޸ģ�ͬʱ�����ں�����������ռ�����256��
8��15λ��ʾ���жϼ�����ͨ����local_bh_disable/local_bh_enable�޸ģ�ͬʱ�����ں������������ж������256��
λ16��27��Ӳ�жϼ�����ͨ����enter_irq/exit_irq�޸ģ�ͬʱ�����ں���������Ӳ�ж������4096��
��28λ��PREEMPT_ACTIVE��־���ô����ʾ���ǣ�

PREEMPT_MASK: 0x000000ff
SOFTIRQ_MASK: 0x0000ff00
HARDIRQ_MASK: 0x0fff0000

��������4���귵��1�õ��ط�����ԭ�������ģ��ǲ������ں˷����û��ռ䣬�������ں�˯�ߵģ�����������κο�������˯��
�ĺ��������Ҵ���thread_info->preempt_count����0����͸����ںˣ�����������ռ�����á�

���ǣ�����in_atomic()��˵����������ռ������£��������ĺܺã����Ը����ں�Ŀǰ�Ƿ�������������Ƿ������ռ�ȡ����ǣ�
��û��������ռ������£�spin_lock�������޸�preempt_count�����Լ�ʹ�ں˵�����spin_lock����������������in_atomic()
��Ȼ�᷵��0������ĸ����ں�Ŀǰ�ڷ�ԭ���������С����Է�������in_atomic()���ж��Ƿ���ԭ�������ĵĴ��룬�ڽ���ռ��
����¶���������ġ�

}



