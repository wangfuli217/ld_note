中断共享的相关点：中断共享即是多个设备共享一根硬件中断线的情况。Linux2.6内核支持中断共享，使用方法如下：
*共享中断的多个设备在申请中断时都应该使用SA_SHIRQ标志，而且一个设备以SA_SHIRQ申请某中断成功的前提是之前该中断的所有设备也都以SA_SHIRQ标志申请该终端
*尽管内核模块可访问的全局地址都可以作为request_irq(….,void *dev_id)的最后一个参数dev_id,但是设备结构体指针是可传入的最佳参数。
*在中断带来时，所有共享此中断的中断处理程序都会被执行，在中断处理程序顶半部中，应迅速根据硬件寄存器中的信息比照传入的dev_id参数判断是否是被设备的中断，如果不是，应迅速返回

irq(中断整体框架)
{
1. 系统启动阶段，取决于内核的配置，内核会通过数组或基数树分配好足够多的irq_desc结构；
2. 根据不同的体系结构，初始化中断相关的硬件，尤其是中断控制器；
3. 为每个必要irq的irq_desc结构填充默认的字段，例如irq编号，irq_chip指针，根据不同的中断类型配置流控handler；
4. 设备驱动程序在初始化阶段，利用request_threaded_irq() api申请中断服务，两个重要的参数是handler和thread_fn；
5. 当设备触发一个中断后，cpu会进入事先设定好的中断入口，它属于底层体系相关的代码，它通过中断控制器获得irq编号，
   在对irq_data结构中的某些字段进行处理后，会将控制权传递到中断流控层（通过irq_desc->handle_irq）；
6. 中断流控处理代码在作出必要的流控处理后，通过irq_desc->action链表，取出驱动程序申请中断时注册的handler
   和thread_fn，根据它们的赋值情况，或者只是调用handler回调，或者启动一个线程执行thread_fn，又或者两者都执行；
7. 至此，中断最终由驱动程序进行了响应和处理。
}

irq(初始化)
{
1	首先，在setup_arch函数中，early_trap_init被调用，其中完成了第1节所说的中断向量的拷贝和重定位工作。
2	然后，start_kernel发出early_irq_init调用，early_irq_init属于与硬件和平台无关的通用逻辑层，它完成irq_desc结构
    的内存申请，为它们其中某些字段填充默认值，完成后调用体系相关的arch_early_irq_init函数完成进一步的初始化工作，
    不过ARM体系没有实现arch_early_irq_init。
3	接着，start_kernel发出init_IRQ调用，它会直接调用所属板子machine_desc结构体中的init_irq回调。machine_desc通常
    在板子的特定代码中，使用MACHINE_START和MACHINE_END宏进行定义。
4	machine_desc->init_irq()完成对中断控制器的初始化，为每个irq_desc结构安装合适的流控handler，为每个irq_desc结构
    安装irq_chip指针，使他指向正确的中断控制器所对应的irq_chip结构的实例，同时，如果该平台中的中断线有多路复用
    （多个中断公用一个irq中断线）的情况，还应该初始化irq_desc中相应的字段和标志，以便实现中断控制器的级联。
}

irq(中断控制器)
{
1. 对各个irq的优先级进行控制；
2. 向CPU发出中断请求后，提供某种机制让CPU获得实际的中断源（irq编号）；
3. 控制各个irq的电气触发条件，例如边缘触发或者是电平触发；
4. 使能（enable）或者屏蔽（mask）某一个irq；
5. 提供嵌套中断请求的能力；
6. 提供清除中断请求的机制（ack）；
7. 有些控制器还需要CPU在处理完irq后对控制器发出eoi指令（end of interrupt）；
8. 在smp系统中，控制各个irq与cpu之间的亲缘关系（affinity）；

}


irq(ARM的异常向量表)
{
arm的异常和复位向量表有两种选择，一种是低端向量，向量地址位于0x00000000，另一种是高端向量，向量地址位于0xffff0000，Linux选择使用高端向量模式，也就是说，当异常发生时，CPU会把PC指针自动跳转到始于0xffff0000开始的某一个地址上：

ARM的异常向量表 地址 	异常种类
FFFF0000 	复位
FFFF0004 	未定义指令
FFFF0008 	软中断（swi）
FFFF000C 	Prefetch abort
FFFF0010 	Data abort
FFFF0014 	保留
FFFF0018 	IRQ
FFFF001C 	FIQ

中断向量表在arch/arm/kernel/entry_armv.S中定义
}

file()
{
arch/xxx/mach-xxx/include/irqs.h
kernel/irq/irqdesc.c
include/linux/irq.h
kernel/irq/settings.h
kernel/irq/chip.c  #通用中断子系统把几种常用的流控类型进行了抽象，并为它们实现了相应的标准函数，

CONFIG_SPARSE_IRQ

struct irq_data
struct irq_desc

/proc/interrupts：文件
/proc/irq：子目录

arch/arm/
arch/arm/kernel/entry_armv.S #中断向量表在
arch/arm/kernel/traps.c      #系统启动阶段，位于arch/arm/kernel/traps.c中的early_trap_init()被调用：
arch/arm/include/asm/entry_macro_multi.S #arch_irq_handler_default

arch/xxx/mach-xxx # 机器级别的中断控制器级联
/arch/arm/plat-s5p/irq-eint.c # 机器级别的中断控制器级联 s5p_init_irq_eint 函数实现级联

与通用中断子系统相关的初始化由start_kernel()函数发起，

[中断控制器接口和Linux标准接口进行关联]
irq_chip实例注册到irq_desc.irq_data.chip字段中，这样各个irq和中断控制器就进行了关联，只要知道irq编号，
即可得到对应到irq_desc结构，进而可以通过chip指针访问中断控制器。

[中断处理流程]

irq_handler(arch_irq_handler_default) #arch/arm/kernel/entry-armv.S
arch_irq_handler_default(asm_do_IRQ)  #arch/arm/include/asm/entry_macro_multi.S
asm_do_IRQ -> handle_IRQ -> generic_handle_irq -> generic_handle_irq_desc -> desc->handle_irq(irq, desc);

早期的内核版本中，几乎所有的中断都是由__do_IRQ函数进行处理，                         
}

irq_chip(struct) {
	const char	*name;
name  中断控制器的名字，会出现在 /proc/interrupts中。
	unsigned int	(*irq_startup)(struct irq_data *data);
irq_startup  第一次开启一个irq时使用。
	void		(*irq_shutdown)(struct irq_data *data);
irq_shutdown  与irq_starup相对应。
	void		(*irq_enable)(struct irq_data *data);
irq_enable  使能该irq，通常是直接调用irq_unmask()。
	void		(*irq_disable)(struct irq_data *data);
    irq_disable  禁止该irq，通常是直接调用irq_mask，严格意义上，他俩其实代表不同的意义，disable表示中断控制器根本
 就不响应该irq，而mask时，中断控制器可能响应该irq，只是不通知CPU，这时，该irq处于pending状态。类似的区别也适用于
 enable和unmask。
	void		(*irq_ack)(struct irq_data *data);
irq_ack  用于CPU对该irq的回应，通常表示cpu希望要清除该irq的pending状态，准备接受下一个irq请求。 
	void		(*irq_mask)(struct irq_data *data);
irq_mask  屏蔽该irq。
    void		(*irq_unmask)(struct irq_data *data);
    irq_unmask  取消屏蔽该irq。
	void		(*irq_mask_ack)(struct irq_data *data);
irq_mask_ack  相当于irq_mask + irq_ack。
	void		(*irq_eoi)(struct irq_data *data);
irq_eoi  有些中断控制器需要在cpu处理完该irq后发出eoi信号，该回调就是用于这个目的。
	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
irq_set_affinity  用于设置该irq和cpu之间的亲缘关系，就是通知中断控制器，该irq发生时，那些cpu有权响应该irq。
当然，中断控制器会在软件的配合下，最终只会让一个cpu处理本次请求。
	int		(*irq_retrigger)(struct irq_data *data);
	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
irq_set_type  设置irq的电气触发条件，例如IRQ_TYPE_LEVEL_HIGH或IRQ_TYPE_EDGE_RISING。
	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
irq_set_wake  通知电源管理子系统，该irq是否可以用作系统的唤醒源。
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
irq  该结构所对应的IRQ编号。
	unsigned long		hwirq;
hwirq  硬件irq编号，它不同于上面的irq；
	unsigned int		node;
node  通常用于hwirq和irq之间的映射操作；
	unsigned int		state_use_accessors;
state_use_accessors  硬件封装层需要使用的状态信息，不要直接访问该字段，
内核定义了一组函数用于访问该字段：irqd_xxxx()，参见include/linux/irq.h。
	struct irq_chip		*chip;
chip  指向该irq所属的中断控制器的irq_chip结构指针
	struct irq_domain	*domain;
	void			*handler_data;
 handler_data  每个irq的私有数据指针，该字段由硬件封转层使用，例如用作底层硬件的多路复用中断。
	void			*chip_data;
chip_data  中断控制器的私有数据，该字段由硬件封转层使用。
	struct msi_desc		*msi_desc;
msi_desc  用于PCIe总线的MSI或MSI-X中断机制。 
#ifdef CONFIG_SMP
	cpumask_var_t		affinity;
affinity  记录该irq与cpu之间的亲缘关系，它其实是一个bit-mask，每一个bit代表一个cpu，
置位后代表该cpu可能处理该irq。
#endif
};


irq_desc(struct) {
	struct irq_data		irq_data;
irq_data  这个内嵌结构在2.6.37版本引入，之前的内核版本的做法是直接把这个结构中的字段直接放置在
irq_desc结构体中，然后在调用硬件封装层的chip->xxx()回调中传入IRQ编号作为参数，但是底层的函数
经常需要访问->handler_data，->chip_data，->msi_desc等字段，这需要利用irq_to_desc(irq)来获得
irq_desc结构的指针，然后才能访问上述字段，者带来了性能的降低，尤其在配置为sparse irq的系统中
更是如此，因为这意味着基数树的搜索操作。为了解决这一问题，内核开发者把几个低层函数需要使用的
字段单独封装为一个结构，调用时的参数则改为传入该结构的指针。实现同样的目的，那为什么不直接传入
irq_desc结构指针？因为这会破坏层次的封装性，我们不希望低层代码可以看到不应该看到的部分，仅此而已。
    
	unsigned int __percpu	*kstat_irqs;
kstat_irqs  用于irq的一些统计信息，这些统计信息可以从proc文件系统中查询。 
    
	irq_flow_handler_t	handle_irq;
#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
	irq_preflow_handler_t	preflow_handler;
#endif
	struct irqaction	*action;	/* IRQ action list */
action  中断响应链表，当一个irq被触发时，内核会遍历该链表，调用action结构中的回调handler或者激活其中
的中断线程，之所以实现为一个链表，是为了实现中断的共享，多个设备共享同一个irq，这在外围设备中是普遍
存在的。
    
	unsigned int		status_use_accessors;
status_use_accessors  记录该irq的状态信息，内核提供了一系列irq_settings_xxx的辅助函数访问该字段，
详细请查看kernel/irq/settings.h
    
	unsigned int		depth;		/* nested irq disables */
depth  用于管理enable_irq()/disable_irq()这两个API的嵌套深度管理，每次enable_irq时该值减去1，
每次disable_irq时该值加1，只有depth==0时才真正向硬件封装层发出关闭irq的调用，只有depth==1时才
会向硬件封装层发出打开irq的调用。disable的嵌套次数可以比enable的次数多，此时depth的值大于1，
随着enable的不断调用，当depth的值为1时，在向硬件封装层发出打开irq的调用后，depth减去1后，
此时depth为0，此时处于一个平衡状态，我们只能调用disable_irq，如果此时enable_irq被调用，
内核会报告一个irq失衡的警告，提醒驱动程序的开发人员检查自己的代码。

	unsigned int		wake_depth;	/* nested wake enables */
	unsigned int		irq_count;	/* For detecting broken IRQs */

	raw_spinlock_t		lock;
 lock  用于保护irq_desc结构本身的自旋锁。
 
	struct cpumask		*percpu_enabled;
#ifdef CONFIG_SMP
	const struct cpumask	*affinity_hint;
affinity_hit  用于提示用户空间，作为优化irq和cpu之间的亲缘关系的依据。
	struct irq_affinity_notify *affinity_notify;
#ifdef CONFIG_GENERIC_PENDING_IRQ
	cpumask_var_t		pending_mask;
pending_mask  用于调整irq在各个cpu之间的平衡。
#endif
#endif
	wait_queue_head_t       wait_for_threads;
wait_for_threads  用于synchronize_irq()，等待该irq所有线程完成。
	const char		*name;
} ____cacheline_internodealigned_in_smp;

chip_kernel()
{
    根据设备使用的中断控制器的类型，体系架构的底层的开发只要实现上述接口中的各个回调函数，然后把它们填充到
irq_chip结构的实例中，最终把该irq_chip实例注册到irq_desc.irq_data.chip字段中，这样各个irq和中断控制器就进行
了关联，只要知道irq编号，即可得到对应到irq_desc结构，进而可以通过chip指针访问中断控制器。
}

irq(API)
{
1）设备申请中断
int request_irq(unsigned int irq,  //irq是要申请的中断号
                    void (*handler)(int irq, void *dev_id, struct pt_regs * *regs),//回调函数，中断发生时，系统会调用该函数，
                    unsigned long irqflags,
                    const char *devname,
                    void *dev_id);
其中irqflags是中断处理的属性，若设置为SA_INTERRUPT,则表示中断处理程序是快速处理程序，它被调用时屏蔽所有中断。若设置为SA_SHIRQ,则表示多个设备共享中断，dev_id在中断共享时会用到，一般设置为这个设备的设备结构体或者NULL.
该函数返回0表示成功，返回-INVAL表示中断号无效或处理函数指针为NULL,返回EBUSY表示中断已经被占用且不能共享。

第一个参数irq: 表示要分配的中断号。对于一些设备(系统时钟或键盘)它的值是预先固定的，而对于大多数设备来说，这个值是动态确定的。




2）释放中断
free_irq(unsigned int irq, void *dev_id);
3)使能和屏蔽中断
void disable_irq(int irq);   //这个会立即返回
void disable_irq_nosync(int irq);//等待目前的中断处理完成再返回。
void enable_irq(int irq);
上述三个函数作用于可编程中断处理器，因此对系统内所有的CPU都生效。
void local_irq_save(unsigned long flags);//会将目前的中断状态保留在flags中
void local_irq_disable(void);//直接中断
这两个将屏蔽本CPU内的所有中断。对应的上边两个中断的方法如下
void local_irq_restore(unsigned long flags);
void local_irq_enable(void);

}

初始化软件中断，软件中断与硬件中断区别就是中断发生时，软件中断是使用线程来监视中断信号，而硬件中断是使用CPU硬件来监视中断。

1、 中断处理例程可在驱动程序初始化时或者设备第一次打开时安装。
     虽然在模块的初始化函数中安装中断处理例程看起来是个好主意，但实际上并非如此。因为中断信号线的数量非常有限，我们不能肆意浪费。
	 计算机通常有的设备被中断信号线多的多。
2、 调用request_irq的正确位置应该是在设备第一次打开、硬件被告知产生中断之前。
    调用free_irq 的位置是最后一次关闭设备、硬件被告知不用在中断处理器之后。
	 -- 必须为每个设备维护一个打开计数，我们才能知道什么时候可以禁用中断。
	 
------ irq ------

static inline int request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
	    const char *name, void *dev)
irq		 中断号
handler 要安装的中断处理函数指针
flags   与中断管理有关的位掩码
         SA_INTERRUPT: 标明这是一个快速的中断处理例程，快速中断例程运行在中断的禁用状态下。
		 SA_SHIRQ:     中断可以在设备之间共享
		 SA_SAMPLE_RANDOM:产生的中断能对/dev/random和/dev/urandom设备使用的熵池有贡献。
		 
name    传递给request_irq的字符串 /proc/interrupts
dev_id	 用于共享的中断信号线。它是唯一的标识符，在中断信号线空闲时可以使用它，驱动程序也可以使用它指向驱动程序自己的私有数据区。
        在没有强制使用共享方式时，dev_id可以被设置为NULL，总之用它来指向设备的数据结构是一个比较好的思路。
		
返回值 0 成功 负数：失败 -EBUSY 表示已经有另一个驱动程序占用了你要申请的中断信号线。		
		
a.快速中断
	快速中断(fast interrup)的中断处理程序运行时间非常短，所以当前被打断的活动暂停时间也很短。快速中断特点是，屏蔽当前运行中断处理程序CPU
	的其他中断，这样中断处理程序的执行就不会被别的中断打断。要将中断申请注册为快速中断，需在申请中断资源时将中断类型标志flags设为
	SA_INTERRUPT。
b.慢速中断
	慢速中断(slow interrupt)的中断处理程序在执行期间可以被别的中断打断。慢速中断处理程序执行的时间场(相对快速中断而言),所以占用CPU的时间也长。
	中断处理程序的执行通常可以暂停所有别的活动。不同的中断在几个CPU上可以同时运行，单某个中断的处理程序一次只能在一个CPU上执行
	如果你想查看当前CPU是否在中断活动中，则可以调用内核的API

in_irq()  //include/asm/hardirq.h
		
void free_irq(unsigned int, void *);

proc(interrupts)
{
------ proc接口------
1、当硬件的中断到达处理器时，一个内部计数递增，这为检查设备是否按预期工作提供了一种方法。产生的中断报告显示在文件/proc/interrupts中。
2、Linux内核通常会在第一个CPU上处理中断，以便最大化缓存的本地性。
3、可编程控制器信息，注册了中断处理例程的设备名称。

/proc/interrupts
中断号             处理中断的CPU      处理中断的可编程中断控制器信息   注册了中断处理例程的设备名称   驱动程序注册该irq时使用的名字

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




/proc/stat 记录了一些系统活动的底层统计信息。包括从系统启动开始接收到的中断数量。
intr 92271660 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 220895 0 329859 0 0 0 0 0 0 0 832 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 9 1 87 0 0 1 0 6 0 0 0 0 0 22945972 0 0 0 0 0 0 1599 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 18060150 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

92271660:所有中断总数
后面的代表每个IRQ对应的中断

interrupts文件不依赖体系结构，stat则是依赖的，字段的数量依赖于内之下的硬件。
x86体系结构定义了224个中断



------- 自动检测IRQ号 ------
驱动程序初始化时，最迫切的问题之一就是如何决定设备将要使用哪些IRQ信号线。驱动程序需要这个信息以便正确地安装处理例程，尽管程序员
可以要求用户在装载时指定中断号，但这不是一个好习惯，因为大部分时间用户不知道这个中断号，或者是因为用户没有配置跳线，或者是因为
设备是无跳线的。因此，中断号的自动检测对驱动程序可用性来说是一个基本要求。

自动检测IRQ号依赖于一些设备拥有的默认特性。

驱动程序可以通过从设备的某个IO端口或者PCI配置空间中读出一个状态字来获得中断号。
自动检测IRQ号只是意味着探测设备，而不需要额外的工作来探测中断。

{内核帮助下的探测}
linux/interrupt.h
unsigned long probe_irq_on(void)
返回一个未分配中断的位掩码。驱动成必须保存返回的位掩码，并且将它传递给后面的probe_irq_off函数，驱动程序要安排设备产生至少一次中断。

int probe_irq_off(unsigned long)
在请求设备产生中断之后，驱动程序调用这个函数，并将前面long probe_irq_on返回的位掩码作为参数传递给它。probe_irq_off返回probe_irq_on
之后发生的中断编号。如果没有中断发生，就返回0；如果产生了多次中断，就返回一个负值。

在调用probe_irq_on之后启用设备上的中断，并在调用probe_irq_off之前禁用中断。此外要记住，在probe_irq_off之后，需要处理设备上待处理的中断。

------- DIY探测 ------
探索所有中断号



------- x86平台上中断处理的内幕 ------
arch/i386/kernel/irq.c         do_IRQ() 做的第一件事是应答中断，这样中断控制器就可以继续处理其他的事情了。然后该函数对于给定的IRQ号，
                               获得一个自旋锁，这样就阻止了任何其他的CPU处理这个IRQ。接着清除几个状态位，容纳后寻找这个特定的IRQ
							   的处理例程。如果没有处理例程，就什么也不做；自旋锁被释放，处理任何待处理的软件中断，最后do_IRQ返回。
							   
							   通常，如果设备有一个已注册的处理例程并且发生了中断，则函数handle_IRQ_event会被调用以便实际调用处理例程。
							   如果处理例程是慢速类型，将重新启用硬件中断，并调用处理例程。然后只是做一些清理工作，接着运行软件中断，最后
							   返回到常规工作中。
arch/i386/kernel/apic.c        
arch/i386/kernel/entry.S       最底层的中断处理代码
arch/i386/kernel/i8259.c       
include/asm-i386/hw_irq.h      


------- 实现中断处理例程 ------
中断处理例程和内核定时器的限制是一样的。

中断处理例程的功能就是：将有关中断接收的信息反馈给设备，并根据正在服务的中断的不同含义对数据进行响应的读或写。

中断处理例程的一个典型任务就是：如果中断通知所等待的事件已经发生，比如新的数据到达，就会唤醒在该设备上休眠的进行。

------- 处理例程的参数和返回值 ------
irq：    如果存在任何可以打印到日志的消息时，中断号是很有用的。
dev_id:  是一种客户数据类型(即驱动程序可用的私有数据)
regs:    保存了处理器进入中断代码之前的处理器上下文快照。可别用来监视和调试。

返回值：IRQ_HANDLED:处理例程发现其他设备的确需要处理 IRQ_NONE； 
        IRQ_RETVAL(handled):如果要处理该中断，则handled应该取非零值。返回值将被内核使用，以便检测并抑制假的中断
		如果设备无法告诉我们是否被真正中断，则应返回IRQ_HANDLED

------- 禁用中断 ------
void disable_irq(int irq);         禁用中断，还会等待正在执行的中断处理例程完成。
void disable_irq_nosync(int irq);  禁用中断，立刻返回。
void enable_irq(int irq);
调用这些函数中的任何一个都会更新可编程中断控制器中指定中断的掩码，因而就可以在所有的处理器上禁用或者启用IRQ。
如果disable_irq被调成功两次，那么在IRQ真正重新启用前，需要调用两次enable_irq();

禁用所有的中断：

void local_irq_save(unsigned long flags)
void local_irq_disable(void)
void local_irq_restore(unsigned long flags)
void local_irq_enable(void);

(1) 硬中断的开关
简单禁止和激活当前处理器上的本地中断：
local_irq_disable();
local_irq_enable();
保存本地中断系统状态下的禁止和激活：
unsigned long flags;
local_irq_save(flags);
local_irq_restore(flags);

(2) 软中断的开关
禁止下半部，如softirq、tasklet和workqueue等：
local_bh_disable();
local_bh_enable();
需要注意的是，禁止下半部时仍然可以被硬中断抢占。

(3) 判断中断状态
#define in_interrupt() (irq_count()) // 是否处于中断状态(硬中断或软中断)
#define in_irq() (hardirq_count()) // 是否处于硬中断
#define in_softirq() (softirq_count()) // 是否处于软中断


顶半部--- 中断处理例程
底半部--- 一个被顶半部调度，并在稍后更安全的时间内执行的例程。  -- 唤醒进程，启动的另外的IO操作。顶半部继续处理中断处理例程流。

底半部处理例程执行时，所有的中断都是打开的 -- 这就是馊味的在更安全的时间内运行。

共享处理的驱动程序需要小心使用enable_irq和disable_irq

如果与驱动程序管理的硬件之间的数据传输因为某种原因被延迟的话，驱动程序作者就应该实现缓冲。数据缓冲区有助于将数据的传送和数据的接收
与系统调用write和read分离开来，从而提高系统的整体性能。

一个好的的缓冲机制需要采用中断驱动的IO，这种模式下，一个输入缓冲区在中断时间内被填充，并由读取该设备的进程取走缓冲区内的数据；
一个输出缓冲区由写入设备的进程填充，并在中断时间内取走数据。一个中断驱动输出的例子是/dev/shortint的实现。

要正确进行中断驱动的数据传输，则要求硬件应该能按照下面的语义来产生中断：
1. 对于输入来说，当新的数据已经达到并且处理准备好接收它时，设备就中断处理器。实际执行的动作取决于设备使用的IO端口、内存映射、还是DMA
2. 对于输出来说，当设备准备好接收新数据或者对成功的数据传送进行应答时，就要发送中断。内存映射和具有DMA能力的设备，通常通过产生中断
   来通知系统它们对缓冲区的处理已经结束。
   
   
atomic(原子上下文)
{
内核的一个基本原则就是：在中断或者说原子上下文中，内核不能访问用户空间，而且内核是不能睡眠的。也就是说在这种情况下，内核是不能调用有可能引起睡眠的任何函数。一般来讲原子上下文指的是在中断或软中断中，以及在持有自旋锁的时候。内核提供了四个宏来判断是否处于这几种情况里：

#define in_irq()     (hardirq_count()) //在处理硬中断中
#define in_softirq()     (softirq_count()) //在处理软中断中
#define in_interrupt()   (irq_count()) //在处理硬中断或软中断中
#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != 0) //包含以上所有情况

这四个宏所访问的count都是thread_info->preempt_count。这个变量其实是一个位掩码。最低8位表示抢占计数，通常由spin_lock/spin_unlock修改，或程序员强制修改，同时表明内核容许的最大抢占深度是256。
8－15位表示软中断计数，通常由local_bh_disable/local_bh_enable修改，同时表明内核容许的最大软中断深度是256。
位16－27是硬中断计数，通常由enter_irq/exit_irq修改，同时表明内核容许的最大硬中断深度是4096。
第28位是PREEMPT_ACTIVE标志。用代码表示就是：

PREEMPT_MASK: 0x000000ff
SOFTIRQ_MASK: 0x0000ff00
HARDIRQ_MASK: 0x0fff0000

凡是上面4个宏返回1得到地方都是原子上下文，是不容许内核访问用户空间，不容许内核睡眠的，不容许调用任何可能引起睡眠
的函数。而且代表thread_info->preempt_count不是0，这就告诉内核，在这里面抢占被禁用。

但是，对于in_atomic()来说，在启用抢占的情况下，它工作的很好，可以告诉内核目前是否持有自旋锁，是否禁用抢占等。但是，
在没有启用抢占的情况下，spin_lock根本不修改preempt_count，所以即使内核调用了spin_lock，持有了自旋锁，in_atomic()
仍然会返回0，错误的告诉内核目前在非原子上下文中。所以凡是依赖in_atomic()来判断是否在原子上下文的代码，在禁抢占的
情况下都是有问题的。

}



