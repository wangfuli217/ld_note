
smp_setup_processor_id()
{
weak����˵��smp_setup_processor_id�ǲ�ִ�еĺ��������ں˴����нṹΪSPARCʱô����ú�����
��ˣ�ARM�ṹʱ��ִ���κβ�����
}

lockdep_init(��¼����֮��������ϵ�Ľṹ���ʼ��)
{
����CONFIG_LOCKDEP������񣬸ú���ִ�еĴ����������ͬ��
δ����CONFIG_LOCKDEP�����ÿպ�����
����CONFIG_LOCKDEPʱ�����ڵ��ԡ��ú����Լ�¼����֮��������ϵ�Ľṹ����г�ʼ����
���գ���ʼ��classhash_table[4096]��chainhash_table[16384]�

��ϵ����spin_acquire��rwlock_acquire��mutex_acquire��rwsem_acquire��lock_map_acquire�ȵȡ�

��֮��ص����ÿ���:
PROVE_LOCKING
DEBUG_LOCK_ALLOC
DEBUG_LOCKDEP
LOCK_STAT
DEBUG_LOCKING_API_SELFTESTS

<Linux �������ģ�� Lockdep ���>
http://kernel.meizu.com/linux-dead-lock-detect-lockdep.html?utm_source=tuicool&utm_medium=referral
spin_lock()->raw_spin_lock()->_raw_spin_lock()->__raw_spin_lock()->preempt_disable();->spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
           lock_acquire()->__lock_acquire()->__lock_acquire()
 ˵����__lock_acquire() �� lockdep �������ĺ��ģ�����ԭ����������������������������ġ�����������ջ���� print_xxx_bug() ������

 
}

debug_objects_early_init(���ٸ�����Ľṹ���ʼ��)
{
δ����CONFIG_DEBUG_OBJECTS�����ÿպ�����
����CONFIG_LOCKDEPʱ�����ڵ��ԡ�
struct debug_bucket���͵�obj_hash[]��������Ԫ�ص�lock��Ա������
struct debug_obj ���͵�objects_static_pool[]��������node�ǹ����ӵ�obj_poolɢ�б�

debug_obj
struct hlist_node node        ���Ӹ���ɢ�б��еĶ���
enum debug_obj_state state    ����״̬
void *object;                 ��ʵ�ʶ����ָ��
struct debug_obj_descr descr  ���ڵ��Ե��������ṹ��ָ��
}

boot_init_stack_canary(���ڷ���ջ�����������)
{
������Ӳ���ṹ��ARM��x86��MIPS�ȵ�
���ڷ���ջ�����������������ʱ����ջ�е�canaryֵ��ARM�ṹ��û��ʵ�ָù��ܡ�
}

cgroup_init_early(��ʼ���ṩ���̼��ɷ�����cgroup)
{
Ϊ��������ṩ������Դ����п��ƵĹ��ܡ�
cgroup���еĳ�ʼ����Ϊcgroup_init_early()��cgroup_init���Ρ�
��Ҫ��������ʼ��ʹ�õ���ϵͳ���Ƚ��г�ʼ����

cgroup_subsys_state�ṹ�壺�����ض�cgroup�����õ���ϵͳ���á� # cpu memory cupset freezer�ȵ�
css_set��������������cgroup�����õ���ϵͳ������Ϣ������һ�� # ����̽��й��������ڽ��̵����ݽṹ
cgroupfs_root����ʾcgroup�ļ�ϵͳ���ͼ�Ķ��˽ڵ㡣 
}

init_cgroup_root(cgroup_init_early)
{
cgroupfs_root��cgroup�Ĺ�����ʼ����
����Ϊ�������ݵ�cgroupfs_root�ṹ�����root���Լ�����cgroup���ͼ��top_cgroup�������ӣ�����ʼ����ص����ݽṹ��

init_cgroup_housekeeping()��ʼ�����ڹ������ͼ��list���������������
}

cgroup_init_subsys(cgroup_init_early)
{
����Ϊ�������ݵ���ϵͳss���г�ʼ����
}



raw_local_irq_disable(���ж�)
{
��ʽ���г�ʼ��ǰ���Ƚ��õ�ǰ������CPU��IRQ��������δ���жϴ�����������жϴ��������г�ʼ�������Ա���ر��жϣ��ú�������
raw_local_irq_disable()�Խ���IRQ��

asm volatile(
		"	cpsid i			@ arch_local_irq_disable"
		:
		:
		: "memory", "cc");
        ����CPSR��Iλ�Թر��жϡ�
}

early_boot_irqs_off()
{
CONFIG_TRACE_IRQFLAGSʱִ�С�
��ʹ��early_boot_boot_irq_enabled = 0.
�ú�����early_boot_irqs_on�ɶԳ��֡�
}

early_init_irq_lock_class()
{
CONFIG_GENERIC_HARDIRQSʱִ�С�
��ִ��ѭ����ͬʱ��ͨ��for_each_irq_desc��ȡ���ж�������irq_desc�ṹ�塣�������ʵ�irq_desc[]����
��struct irq_desc�ṹ�����������.
}

tick_init()
{
CONFIG_GENERIC_CLOCKEVENTSʱ���ã����򣬲�ִ���κβ�����

struct notifier_block {  
	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
	struct notifier_block __rcu *next;
	int priority;
};

#ԭ��֪ͨ��
struct atomic_notifier_head {
	spinlock_t lock;
	struct notifier_block __rcu *head;
};
# ���ж�������������chain�ص������������������ص�����

#������֪ͨ��
struct blocking_notifier_head {
	struct rw_semaphore rwsem;
	struct notifier_block __rcu *head;
};
# �ص������ڽ�����������ִ�У����������ص�����

#ԭʼ֪ͨ��
struct raw_notifier_head {
	struct notifier_block __rcu *head;
};
# �Իص���ע�ᡢע�����κ����ƣ�����ͬ�������������ɵ��÷�����

# SRCU֪ͨ��
struct srcu_notifier_head {
	struct mutex mutex;
	struct srcu_struct srcu;
	struct notifier_block __rcu *head;
};
# ������֪ͨ��֮һ�����кͿ�����֪ͨ����ͬ�����ơ���Ȼchain��Ƶ�����ã���������notifier block��δȫ�����
# �������ʹ��SRCU֪ͨ����Ϊ����Ҫִ������ʱ��ʼ����


__release�ж����__context__
compiler.h
#define __release(x) __context__(x, -1)

Ϊ�����__context__����Ҫ����Sparse��̬����������ߡ�
�ܹ��������û��ռ���ں˿ռ��ָ�����ʱ�����Ĵ���


}

boot_cpu_init(��CPUλͼ��ע�ᵱǰ����CPU)
{
�ں�����λͼ������ά�� ϵͳ��CPU��״̬��Ϣ�����д������cpu_possible_map��cpu_online_map��
cpu_present_map��λ��CPU1:1ӳ�䡣
cpu_possible_map:�Ƕ�ϵͳ�п�ִ���Ȳ�ε�CPU��λͼ����λͼָ�������ϵͳʱ֧�ֵ�CPU������
һ��������λ���򲻿���ӻ�ɾ����
cpu_online_map���ǽ�����������CPU��λ����Ϊ1��λͼ��
cpu_present_map��ϵͳ������CPU��λͼ������������CPU����������״̬��
}

page_address_init(����߶��ڴ�)
{
�ں�ͨ��page_addres_pool����HIGHMEM��ͨ��page_address_maps[]���й���
�߶��ڴ�������ֱ�ӽ��е�ַ�����ڴ�ҳ����ˣ�ʹ��kmap()ӳ��߶��ڴ�(ZONE_HIGHMEM)����ɢ�б�page_address_htable
���й���HIGHMEM�з�����ڴ棬���޳�ʼ���Ķ���page_address_maps��page_address_htable�Ķ�������[hmem.c]

�߶��ڴ���RAM��896MB���ϵ��ڴ�ռ䣬�����������û��ռ�����ҳ���档�߶��ڴ治��ֱ��ִ��ӳ�䣬���ԱȵͶ��ڴ�����ٶȸ�����

}

setup(������ܹ���ص�һϵ������)
{
������ܹ���ص�һϵ������,
Ϊ�����ں��������У���������ں�Ҫִ�еĴ�������Ϣ�ͻ�����Ϣ�������ں�ʱ�ҵ�����Ĵ�������Ϣ��
}

setup(setup_processor)
{
/arch/arm/kernel/head-common.S�ļ���__lookup_processor_type��ǩ�������ں������������͵Ĵ��롣
��ת��__lookup_processor_type��ǩǰ��Ҫ���ҵĴ�������CPU ID�����ڼĴ���r9�С�

��__proc_info_begin��__proc_info_end�������ں˵����д�������Ϣ������ʱ����proc_info_list�ṹ�屣�棬���Ƚ�
proc_info_list��cpu_val��CPI ID��ֵ��

ENDPROC(__look_processor_type)������include/linux/linkage.h�У�ʹ��ENDPROC()��__look_processor_type��ǩ
��Ϊ����ע�ᵽ�����б�ʹ���ܹ����ⲿ���á�

##ENTRT() ENDPROC()��
Ϊ�˴��ⲿ���û������д���ӳ������������ⲿģ�����֪���ӳ������������š�LinuxҲΪ���ṩ��
һЩ�꣬�ر����ӳ����ⲿ�������з���ֵ��Ϊ����ʾ��̬�������ߵ�Ч�����Ƽ�ʹ��ENDPROC()��

struct proc_info_list {
	unsigned int		cpu_val;
	unsigned int		cpu_mask;
	unsigned long		__cpu_mm_mmu_flags;	/* used by head.S */
	unsigned long		__cpu_io_mmu_flags;	/* used by head.S */
	unsigned long		__cpu_flush;		/* used by head.S */
	const char		*arch_name;
	const char		*elf_name;
	unsigned int		elf_hwcap;
	const char		*cpu_name;
	struct processor	*proc;
	struct cpu_tlb_fns	*tlb;
	struct cpu_user_fns	*user;
	struct cpu_cache_fns	*cache;
};

���ļ��� proc_info.h�е�proc_info_list�ṹ��
vmlimux.lds.S�м�����.proc.info.init������.proc.info.init��������д��벿����������ͳ����һ��
}

setup(setup_machine)
{
/arch/arm/kernel/head-common.S�ļ���__lookup_machine_type��ǩ�������ں��л�����Ϣ�Ĵ��롣
��ת��__lookup_machine_typeǰ���Ĵ���r1�б����Ż����ṹ�š�

��__arch_info_begin��__arch_info_end������machine_desc��Ϣ.

struct machine_desc {
	unsigned int		nr;		/* architecture number	*/
	const char		*name;		/* architecture name	*/
	unsigned long		boot_params;	/* tagged list		*/
	const char		**dt_compat;	/* array of device tree
						 * 'compatible' strings	*/

	unsigned int		nr_irqs;	/* number of IRQs */

	unsigned int		video_start;	/* start of video RAM	*/
	unsigned int		video_end;	/* end of video RAM	*/

	unsigned int		reserve_lp0 :1;	/* never has lp0	*/
	unsigned int		reserve_lp1 :1;	/* never has lp1	*/
	unsigned int		reserve_lp2 :1;	/* never has lp2	*/
	unsigned int		soft_reboot :1;	/* soft reboot		*/
	void			(*fixup)(struct machine_desc *,
					 struct tag *, char **,
					 struct meminfo *);
	void			(*reserve)(void);/* reserve mem blocks	*/
	void			(*map_io)(void);/* IO mapping function	*/
	void			(*init_early)(void);
	void			(*init_irq)(void);
	struct sys_timer	*timer;		/* system tick timer	*/
	void			(*init_machine)(void);
#ifdef CONFIG_MULTI_IRQ_HANDLER
	void			(*handle_irq)(struct pt_regs *);
#endif
};

arch/arm/kernel/setup.c             arch/arm/kernel/head-common.S
list = lookup_machine_type(nr)  ->  ENTRY(lookup_machine_type)
���գ�lookup_machine_type������ִ��__lookup_machine_type��ǩ�еĻ����룬��ñ��浱ǰ������Ϣ�Ľṹ��
machine_desc��ָ�롣

}

setup(unwind_init)
{
ջ���ݡ�
unwind��Ϣ�ж�Ӧ��������Ȩ�Ƶ��δ���
unwind��Ϣ���쳣�����б��ܡ�

�ں���ÿ����.ARM.exidx��ʼ�Ķζ������ž���ջչ��stack unwinding��Ϣ���쳣�����б��������ֵ��
�쳣�����б�ĸ����С��ͬ������ͨ��unwind_idx���ʡ�


}

setup(meminfo)
{
��ARM������meminfo�ķ�����3�֣�
1���ڻ�����fixup����������
2�����������������ATAG_MEM��ǩ�����á�
3�������ں������е�"mem=����"���á�
����������˾�ĺ��Ŀ��ܿ������ں����������á�

}

setup(parse_cmdline)
{

__early_param("initrd=", early_initrd)

#define early_param(str, fn)					\
	__setup_param(str, fn, fn, 1)
    
#define __setup_param(str, unique_id, fn, early)			\
	static const char __setup_str_##unique_id[] __initconst	\
		__aligned(1) = str; \
	static struct obs_kernel_param __setup_##unique_id	\
		__used __section(.init.setup)			\
		__attribute__((aligned((sizeof(long)))))	\
		= { __setup_str_##unique_id, fn, early }

documentation/kernel-parameters.txt
initrd   ָ����ʼ�����ڴ��̵�λ��
init     ����Init����ָ��Ҫִ�еĽ���
console  �ṩ����̨����豸��ѡ��
root     ָ�����ļ�ϵͳ
vmalloc  ǿ��ָ������vmalloc����Ĵ�С

root=/dev/mmcblk0p2 rootfstype=ext4 rw console=ttySAC2,115200        
}

setup(request_standard_resources)
{
����������ƽ̨�ұ���ͬ�����Դ������Ϣ��������״�ṹ����ͨ��/proc/iomem�鿴�˴����ɵ���Ϣ��

kernel_code��resource�ṹ������mem_res�ĵ�һ��Ԫ�أ�
kernel_data�ǵڶ���Ԫ�ء�

iomem��������proc�ļ�ϵͳ�鿴���ܺõ�iomem��ִ����������ɲ鿴Ĭ����Դ��Ϣ��
�����Կ������������õ���ӳ���IO���Դ���롣

}

setup(smp_init_cpus)
{
��ʼ�� cpu possibleλͼ
}

setup(cpu_init)
{
��ջִ�и�ARM�쳣ģʽ��
��cpu_init()��ָ��������ARM��IRQ��ABORT��SVC��UNDģʽʹ�õ�ջ�ռ䡣


struct stack {
	u32 irq[3];
	u32 abt[3];
	u32 und[3];
} ____cacheline_aligned;
}

setup(early_trap_init)
{
��ʼ���Դ����쳣
Ϊ�˵����쳣���룬��early_trap_init()�����н��������������������븴�Ƶ��쳣�������ַ��������CPU��


1. ����������
2. δ���崦����
3. Ԥȡָ����ֹ������
4. ������ֹ������
5. SWI����жϴ�����
6. IRQ������
7. FIQ Handler

}