
smp_setup_processor_id()
{
weak属性说明smp_setup_processor_id是不执行的函数，在内核代码中结构为SPARC时么定义该函数。
因此，ARM结构时不执行任何操作。
}

lockdep_init(记录各锁之间依赖关系的结构体初始化)
{
根据CONFIG_LOCKDEP定义与否，该函数执行的代码会有所不同。
未定义CONFIG_LOCKDEP，调用空函数；
定义CONFIG_LOCKDEP时，用于调试。该函数对记录各锁之间依赖关系的结构体进行初始化。
最终，初始化classhash_table[4096]、chainhash_table[16384]项。

关系到：spin_acquire，rwlock_acquire，mutex_acquire，rwsem_acquire，lock_map_acquire等等。

与之相关的配置开关:
PROVE_LOCKING
DEBUG_LOCK_ALLOC
DEBUG_LOCKDEP
LOCK_STAT
DEBUG_LOCKING_API_SELFTESTS

<Linux 死锁检测模块 Lockdep 简介>
http://kernel.meizu.com/linux-dead-lock-detect-lockdep.html?utm_source=tuicool&utm_medium=referral
spin_lock()->raw_spin_lock()->_raw_spin_lock()->__raw_spin_lock()->preempt_disable();->spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
           lock_acquire()->__lock_acquire()->__lock_acquire()
 说明：__lock_acquire() 是 lockdep 死锁检测的核心，所有原理中描述的死锁错误都是在这里检测的。如果出错，最终会调用 print_xxx_bug() 函数。

 
}

debug_objects_early_init(跟踪各对象的结构体初始化)
{
未定义CONFIG_DEBUG_OBJECTS，调用空函数；
定义CONFIG_LOCKDEP时，用于调试。
struct debug_bucket类型的obj_hash[]数组所有元素的lock成员变量。
struct debug_obj 类型的objects_static_pool[]数组所有node城管连接到obj_pool散列表。

debug_obj
struct hlist_node node        链接跟踪散列表中的对象
enum debug_obj_state state    对象状态
void *object;                 对实际对象的指针
struct debug_obj_descr descr  用于调试的描述符结构体指针
}

boot_init_stack_canary(用于发现栈缓冲溢出攻击)
{
依赖于硬件结构：ARM，x86，MIPS等等
用于发现栈缓冲溢出攻击，启动时设置栈中的canary值。ARM结构中没有实现该功能。
}

cgroup_init_early(初始化提供进程集成方法的cgroup)
{
为进程组合提供分配资源或进行控制的功能。
cgroup进行的初始化分为cgroup_init_early()和cgroup_init两次。
需要对启动初始化使用的子系统率先进行初始化。

cgroup_subsys_state结构体：具有特定cgroup中适用的子系统设置。 # cpu memory cupset freezer等等
css_set：将进程所属的cgroup中设置的子系统设置信息集合在一起。 # 与进程进行关联。基于进程的数据结构
cgroupfs_root：显示cgroup文件系统层次图的顶端节点。 
}

init_cgroup_root(cgroup_init_early)
{
cgroupfs_root和cgroup的关联初始化，
将作为参数传递的cgroupfs_root结构体变量root和自己所属cgroup层次图的top_cgroup进行连接，并初始化相关的数据结构。

init_cgroup_housekeeping()初始化用于构建层次图的list变量、互斥变量。
}

cgroup_init_subsys(cgroup_init_early)
{
对作为参数传递的子系统ss进行初始化。
}



raw_local_irq_disable(关中断)
{
正式进行初始化前，先禁用当前启动的CPU的IRQ。由于尚未对中断代码和向量表、中断处理器进行初始化，所以必须关闭中断，该函数调用
raw_local_irq_disable()以禁用IRQ。

asm volatile(
		"	cpsid i			@ arch_local_irq_disable"
		:
		:
		: "memory", "cc");
        设置CPSR的I位以关闭中断。
}

early_boot_irqs_off()
{
CONFIG_TRACE_IRQFLAGS时执行。
仅使用early_boot_boot_irq_enabled = 0.
该函数和early_boot_irqs_on成对出现。
}

early_init_irq_lock_class()
{
CONFIG_GENERIC_HARDIRQS时执行。
在执行循环的同时，通过for_each_irq_desc宏取的中断描述符irq_desc结构体。这个宏访问的irq_desc[]数组
和struct irq_desc结构体的声明如下.
}

tick_init()
{
CONFIG_GENERIC_CLOCKEVENTS时调用，否则，不执行任何操作。

struct notifier_block {  
	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
	struct notifier_block __rcu *next;
	int priority;
};

#原子通知链
struct atomic_notifier_head {
	spinlock_t lock;
	struct notifier_block __rcu *head;
};
# 在中断上下文中运行chain回调函数，不允许阻塞回调函数

#可阻塞通知链
struct blocking_notifier_head {
	struct rw_semaphore rwsem;
	struct notifier_block __rcu *head;
};
# 回调函数在进程上下文中执行，允许阻塞回调函数

#原始通知链
struct raw_notifier_head {
	struct notifier_block __rcu *head;
};
# 对回调、注册、注销无任何限制，所有同步及保护机制由调用方运行

# SRCU通知链
struct srcu_notifier_head {
	struct mutex mutex;
	struct srcu_struct srcu;
	struct notifier_block __rcu *head;
};
# 可阻塞通知链之一，具有和可阻塞通知链相同的限制。虽然chain被频繁调用，但必须在notifier block中未全部清除
# 的情况下使用SRCU通知链，为此需要执行运行时初始化。


__release中定义的__context__
compiler.h
#define __release(x) __context__(x, -1)

为了理解__context__，需要掌握Sparse静态代码分析工具。
能够检测出将用户空间和内核空间的指针混用时发生的错误。


}

boot_cpu_init(在CPU位图中注册当前运行CPU)
{
内核中有位图，用来维护 系统内CPU的状态信息。具有代表的有cpu_possible_map、cpu_online_map、
cpu_present_map，位与CPU1:1映射。
cpu_possible_map:是对系统中可执行热插拔的CPU的位图。该位图指针对启动系统时支持的CPU数量，
一旦设置了位，则不可添加或删除。
cpu_online_map：是将联机的所有CPU的位设置为1的位图。
cpu_present_map：系统内所有CPU的位图，但并非所有CPU均处于联机状态。
}

page_address_init(管理高端内存)
{
内核通过page_addres_pool访问HIGHMEM，通过page_address_maps[]进行管理。
高端内存区域不能直接进行地址化的内存页，因此，使用kmap()映射高端内存(ZONE_HIGHMEM)，用散列表page_address_htable
另行管理HIGHMEM中分配的内存，有限初始化的对象page_address_maps和page_address_htable的定义如下[hmem.c]

高端内存是RAM中896MB以上的内存空间，该区域用于用户空间程序或页缓存。高端内存不能直接执行映射，所以比低端内存访问速度更慢。

}

setup(处理与架构相关的一系列事物)
{
处理与架构相关的一系列事物,
为了让内核正常运行，必须把握内核要执行的处理器信息和机器信息。编译内核时找到保存的处理器信息。
}

setup(setup_processor)
{
/arch/arm/kernel/head-common.S文件的__lookup_processor_type标签记述了内核中求处理器类型的代码。
跳转到__lookup_processor_type标签前，要查找的处理器的CPU ID保存在寄存器r9中。

从__proc_info_begin到__proc_info_end保存着内核的所有处理器信息。输入时利用proc_info_list结构体保存，并比较
proc_info_list的cpu_val和CPI ID的值。

ENDPROC(__look_processor_type)定义在include/linux/linkage.h中，使用ENDPROC()将__look_processor_type标签
作为函数注册到符号列表，使其能够从外部调用。

##ENTRT() ENDPROC()宏
为了从外部调用汇编代码编写的子程序，链接器和外部模块必须知道子程序名，即符号。Linux也为此提供了
一些宏，特别是子程序被外部调用且有返回值，为了显示静态分析工具的效果，推荐使用ENDPROC()宏

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

核心见： proc_info.h中的proc_info_list结构体
vmlimux.lds.S中记述了.proc.info.init节区，.proc.info.init定义的所有代码部分由链接器统合在一起。
}

setup(setup_machine)
{
/arch/arm/kernel/head-common.S文件的__lookup_machine_type标签记述了内核中机器信息的代码。
跳转到__lookup_machine_type前，寄存器r1中保存着机器结构号。

从__arch_info_begin到__arch_info_end保存了machine_desc信息.

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
最终，lookup_machine_type函数将执行__lookup_machine_type标签中的汇编代码，获得保存当前机器信息的结构体
machine_desc的指针。

}

setup(unwind_init)
{
栈回溯。
unwind信息判断应当将控制权移到何处。
unwind信息由异常处理列表保管。

内核中每个以.ARM.exidx开始的段都保存着具有栈展开stack unwinding信息的异常处理列表的项索引值。
异常处理列表的各项大小不同，必须通过unwind_idx访问。


}

setup(meminfo)
{
在ARM中设置meminfo的方法有3种：
1、在机器的fixup函数中设置
2、接收启动加载项的ATAG_MEM标签并设置。
3、利用内核命令行的"mem=参数"设置。
部分制作公司的核心可能可以在内核设置中设置。

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
initrd   指定初始虚拟内存盘的位置
init     根据Init进程指定要执行的进程
console  提供控制台输出设备及选项
root     指定根文件系统
vmalloc  强制指定可用vmalloc区域的大小

root=/dev/mmcblk0p2 rootfstype=ext4 rw console=ttySAC2,115200        
}

setup(request_standard_resources)
{
将不依赖于平台且被共同管理的源代码信息构建成树状结构。可通过/proc/iomem查看此处构成的信息。

kernel_code是resource结构体数组mem_res的第一个元素，
kernel_data是第二个元素。

iomem：可利用proc文件系统查看构架好的iomem，执行下列命令即可查看默认资源信息，
还可以看各驱动中设置的已映射的IO相关源代码。

}

setup(smp_init_cpus)
{
初始化 cpu possible位图
}

setup(cpu_init)
{
用栈执行各ARM异常模式；
在cpu_init()中指定将按照ARM的IRQ、ABORT、SVC、UND模式使用的栈空间。


struct stack {
	u32 irq[3];
	u32 abt[3];
	u32 und[3];
} ____cacheline_aligned;
}

setup(early_trap_init)
{
初始化以处理异常
为了调用异常代码，在early_trap_init()函数中将各处理器及辅助器代码复制到异常向量表基址，并设置CPU域。


1. 重启处理器
2. 未定义处理器
3. 预取指令中止处理器
4. 数据中止处理器
5. SWI软件中断处理器
6. IRQ处理器
7. FIQ Handler

}