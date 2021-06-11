我们知道，在X86中，有I/O空间的概念，I/O空间是相对于内存空间的概念，它通过特定的指令in，out来访问。端口号标识了外设的寄存器地址。
而巧的是Arm等嵌入式控制器中并不提供I/O空间，所以我们就不考虑了，我们重点放在内存空间。

1）TLB:Translation Lookaside Buffer，即转换旁路缓存。也称快表，是转换表的cache，缓存少量的虚拟地址与物理地址的对应关系。
2）TTW:Translation Table walk，即转换表漫游。当TLB中没有缓冲对应的地址转换关系时，需要通过对内存中转换表的访问来获得
  虚拟地址和物理地址的对应关系。TTW成功后，结果应写入TLB.

linux内核空间3~4GB是还可以在分的,从低到高依次是：
物理内存映射区->隔离带->vmalloc虚拟内存分配器->隔离带->高端内存映射区->专用页面影视区->保留区。

io(API)
{
1）I/O端口操作：在Linux设备驱动中，应使用Linux内核提供的函数来访问定位于I/O空间的端口，包括一下几种：
   *读写字节端口（8位宽）
     unsigned inb(unsigned port);【读】          voi outb(unsigned char byte, unsigned port);【写】
   *读写字端口（16位宽）
     unsigned inw(unsigned port);【读】          voi outw(unsigned short word, unsigned port);【写】
   *读写长字端口（32位宽）
     unsigned inl(unsigned port);【读】          voi outl(unsigned longword, unsigned port);【写】
   *读写一串字节
     unsigned insb(unsigned port， void *addr， unsigned long count);【读】      voi outsb(unsigned port, void *addr, unsigned long count);【写】
   *读写一串字
     unsigned insw(unsigned port， void *addr，unsigned long count);【读】      voi outsb(unsigned port, void *addr, unsigned long count);【写】
   *读写一串长字
     unsigned insl(unsigned port， void * addr， unsigned long count);【读】      voi outsb(unsigned port, void *addr, unsigned long count);【写】
    说明：上述各函数中I/O端口port的类型长度依赖与具体的硬件平台，所以只是写出了unsigned
  2）I/O内存：在内核中访问I/O内存之前，需首先使用ioremap()函数将设备所处的物理地址映射到虚拟地址。
   *ioremap()原型：void *ioremap(unsigned long offset, unsigned long size);
     它返回一个特殊的虚拟地址，该地址可用来存取特定的物理地址范围。用它返回的虚拟地址应该使用iounmap()函数释放。
   *iounmap()原型：void iounmap(void *addr);
   现在，有了物理地址锁映射出来的虚拟地址后，我们就可以通过c指针来直接访问这些地址，但Linux内核也提供了一组函数来完成这中虚拟地址的读写。如下
   *读IO内存
     unsigned int ioread8(void *addr);      unsigned int ioread16(void *addr);     unsigned int ioread32(void *addr);  与之对应的较早版本是：
     unsigned readb(address);                unsigned readw(address);                 unsigned readl(address);  这些在2.6的内核中依然可以使用。
   *写IO内存
     void iowrite8(u8 value，void *addr);  void iowrite16(u16 value, void *addr);   void iowrite32(u32 value, void *addr);  与之对应的较早版本是：
     void writeb(unsigned value, address); void writew(unsigned value,address);  void writel(unsigned value,address);  2.6的内核中依然可以使用。
   *读一串IO内存                                                                          *写一串IO内存
     void ioread8_rep(void *addr， void *buf, unsigned long count);       void iowrite8_rep(void *addr， void *buf, unsigned long count);
     void ioread16_rep(void *addr， void *buf, unsigned long count);     void iowrite8_rep(void *addr， void *buf, unsigned long count);
     void ioread32_rep(void *addr， void *buf, unsigned long count);     void iowrite8_rep(void *addr， void *buf, unsigned long count);
   *复制IO内存
     void memcpy_fromio(void *dest, void *source, unsigned int count);
     void memcpy_toio(void *dest, void *source, unsigned int count);
   *设置IO内存
     void *ioport_map(unsigned long port, unsigned int count);
  3)把IO端口映射到内存空间
     void *ioport_map(unsigned long port, unsigned int count);   通过这个函数，可以把port开始的count个连续的IO端口重映射为一段“内存空间”。然后
                                                                                     就可以在其返回的地址上向访问IO内存一样访问这些端口，当不再需要这种映射时，调用：
     void ioport_unmap(void *addr);                                      来撤销这种映射
  4)IO端口申请
     struct resource *request_region(unsigned long first, unsigned long n, const char *name);
     这个函数向内核申请n个端口，这些端口从first开始，name参数为设备的名称，成功返回非NULL.一旦申请端口使用完成后，应当使用：
     void release_region(unsigned long start, unsigned long n);
  
  5)IO内存申请
    struct resource *request_mem_region(unsigned long start, unsigned long len, char *name);
    这个函数向内核申请n个内存，这些地址从first开始，name为设备的名称，成功返回非NULL,一旦申请的内存使用完成后，应当使用：
    void release_mem_region() ;          来释放归回给系统。需要说明的是这两个函数也不是必须的，但建议使用。
}
io(内存地址空间和IO地址空间)
{
1. 设备驱动程序是软件概念和硬件电路之间的一个抽象层。

1、 每种外设都通过读写寄存器进行控制。大部分外设都有几个寄存器，不管是在内存地址空间还是在IO地址空间，这些寄存器的方位地址都是连续的。
2、 在硬件层，内存区域和IO区域没有概念上的差别：它们都通过向地址总线和控制总线发送电平信号进行访问，再通过数据总线读写数据。
3、 除了x86上普遍使用的IO端口之外，和设备通信的另一种主要机制是通过使用映射到内存的寄存器或设备内存。这两种都称为IO内存
    因为寄存器和内存的差别对软件是透明的。
    
地址空间：单一的或独立的；
访问指令：特殊的CPU指令，通用的CPU指令。
1. 一些CPU制造厂商在他们的芯片中使用单一地址空间
2. 一些为外设保留了独立的地址空间，以便和内存区分开
3. 一些处理器还为IO端口的读写提供独立独立的线路，并使用特殊的CPU指令访问端口。

    数字IO端口最常见的形式是一个字节宽度的IO区域，或映射到内存，或者映射到端口。当把数字写入到输出区域时，
输出引脚上的电平信号随着写入的各位而发生响应的变化，从输入区域读取到的数据则是输入引脚各位当前的电平值。

有独立的IO端口地址和没有独立的IO端口地址（嵌入式微处理器） -- > 模拟成读写IO端口
    因为外设要和外围总线相匹配，而最流行的IO总线是基于个人计算机模型的，所以即使原本没有独立的IO地址空间的处理器，
在访问外设时也要模拟成读写IO端口。这通常由外部芯片组或CPU核心中的附加电路来实现。后一种方式只在嵌入式的微处理器中
比较常见。

    基于同样的原因，Linux在所有的计算机平台上都实现了IO端口，包括使用单一地址空间的CPU在内。端口操作的具体
实现有时依赖于属主计算机的特定型号和接口。(因为不同的型号使用不同的芯片组把总线映射到内存地址空间)。

    即使外设总线为IO端口保留了分离的地址空间，也不是所有设备都把寄存器映射到IO端口，ISA设备普遍使用IO端口，而大多数PCI
设备则把寄存器映射到某个内存地址区段。这种IO内存通常是首选方案，因为不需要特殊的处理器指令；而且CPU核心访问内存更有效率。
同时在访问内存时，编译器在寄存器分配和寻址方式的选择上也有更多的自由。
}

io(IO寄存器和常规内存)
{
------ IO寄存器和常规内存 ------
尽管硬件寄存器和内存非常相似，但程序员在访问IO寄存器的时候必须注意避免由于CPU或编译器不当的优化而改变预期的IO动作。

IO寄存器和RAM的最主要区别就是IO操作具有边界效应，而内存操作则没有：内存写操作的唯一结果就是在指定位置存储一个数值。
内存读操作则仅仅返回指定位置最后一次写入的数值。由于内存访问速度对CPU的性能至关重要，而且也没有边际效应，所以可用
多种方法进行优化，如使用高速缓存保存数值、重新排序读/写指令等。

IO寄存器 VS RAM ------ 边际效应
内存写操作的唯一结果就是在指定位置存储一个数值；内存读操作则仅仅返回指定位置最后一次写入的数值；
由于内存访问速度对CPU的性能至关重要，而且也没有边际效应。所以，可以用多种方法进行优化：高速缓存保存数值；重新排序读/写指令等等。

在对常规内存进行这些优化的时候，优化过程是透明的，而且效果良好(至少在单处理器系统上是这样)，但对IO操作来说这些优化很可能
造成致命的错误，这是因为它们受到边际效应的干扰。而这却是驱动程序访问IO寄存器的主要目的。

}

barrier()
{
void barrier(void)
    这个函数通知编译器插入一个内存屏障，但对硬件没有影响。编译后的代码会把当前CPU寄存器中的所有修改过的数值保存到
内存中，需要这些数据的时候在重新读出来。对barrier的调用可避免在屏障前后的编译器优化，但硬件能完成自己重新排序。

void rmb(void)
void read_barrier_depends(void)
void wmb(void)
void mb(void)
这些函数在编译的指令流中插入硬件内存屏障；具体的实现方法是平台相关的。rmb(读内存屏障)保证了屏障之前的读操作一定会
在后来的读操作执行之前完成。wmb保证写操作不会乱序，mb指令保证了两者都不会。这些函数都是barrier的超集。

read_barrier_depends是一个特殊的、弱一些的读屏障形式。我们知道，rmb避免屏障前后的所有读取执行被重新排序，
而read_barrier_depends仅仅阻止某些读取操作的重新排序，这些读取依赖于其他读取操作返回的数据。

void smp_rmb(void)
void smp_read_barrier_depends(void)
void smp_wmb(void)
void smp_mb(void)
仅在smp系统编译时有效。

writel(dev->registers.operation, DEV_READ);
wmb();
writel(dev->registers.control, DEV_GO);

#define set_rmb(var, value)	do { var = value; rmb(); } while (0)
#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
#define set_mb(var, value)	do { var = value; mb(); } while (0)


------ 内存屏障  http://blog.csdn.net/world_hello_100/article/details/50131497
                 https://www.kernel.org/doc/Documentation/memory-barriers.txt
				 
# define barrier() __memory_barrier()  把CPU寄存器中所有修改过的数值保存到内存中。

程序在运行时内存实际的访问顺序和程序代码编写的访问顺序不一定一致，这就是内存乱序访问。内存乱序访问行为出现的理由是为了提升程序运行时的性能。内存乱序访问主要发生在两个阶段：

    编译时，编译器优化导致内存乱序访问（指令重排）
    运行时，多 CPU 间交互引起内存乱序访问

Memory barrier 能够让 CPU 或编译器在内存访问上有序。一个 Memory barrier 之前的内存访问操作必定先于其之后的完成。Memory barrier 包括两类：

    编译器 barrier
    CPU Memory barrier

------ asm/system.h
#define mb()		do { dsb(); outer_sync(); } while (0)
#define rmb()		dsb()
#define wmb()		mb()
#define read_barrier_depends()		do { } while(0)

rmb:读内存屏障->保证了屏障之前的读操作一定会在后来的读操作执行之前完成。
wmb:保证写操作不会乱序
read_barrier_depends：弱rmb，仅仅保证读操作不会乱序。
mb ：保证rmb和wmb两个功能。


#define smp_mb()	dmb()
#define smp_rmb()	dmb()
#define smp_wmb()	dmb()
#define smp_read_barrier_depends()	do { } while(0)
在支持SMP时有效。

#define set_rmb(var, value)	do { var = value; rmb(); } while (0)
#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
#define set_mb(var, value)	do { var = value; mb(); } while (0)

}



例如： wmb
	__raw_writel((__force u32) cpu_to_be32(in_param >> 32),		  hcr + 0);
	__raw_writel((__force u32) cpu_to_be32(in_param & 0xfffffffful),  hcr + 1);
	__raw_writel((__force u32) cpu_to_be32(in_modifier),		  hcr + 2);
	__raw_writel((__force u32) cpu_to_be32(out_param >> 32),	  hcr + 3);
	__raw_writel((__force u32) cpu_to_be32(out_param & 0xfffffffful), hcr + 4);
	__raw_writel((__force u32) cpu_to_be32(token << 16),		  hcr + 5);

	/* __raw_writel may not order writes. */
	wmb();

#	__raw_writel((__force u32) cpu_to_be32((1 << HCR_GO_BIT)		|
#					       (cmd->toggle << HCR_T_BIT)	|
#					       (event ? (1 << HCR_E_BIT) : 0)	|
#					       (op_modifier << HCR_OPMOD_SHIFT) |
#					       op),			  hcr + 6);

do .... while	构造宏保证扩展后的宏可在所有上下文环境中当做一个正常的C语句来执行。

io(io端口分配)
{
------ 使用IO端口 ------ /proc/ioports 所有的io端口分配可以从获得
IO端口分配：
linux/ioport.h

驱动程序声明自己需要操作的端口。
#define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
struct resource * request_region(resource_size_t start, resource_size_t n,
				   const char *name)
我们要使用起始于start的n个端口。参数name应该是设备的名称。
NULL：分配失败
!NULL: 分配成功

#define release_region(start,n)	__release_region(&ioport_resource, (start), (n))      // 释放
#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))     // 检查
}

io(操作IO端口-一次传输一个数据)
{
asm/io.h
				   
static inline u8 inb(unsigned long addr)
static inline u16 inw(unsigned long addr)
static inline u32 inl(unsigned long addr)
static inline void outb(u8 b, unsigned long addr)
static inline void outw(u16 b, unsigned long addr)
static inline void outl(u32 b, unsigned long addr)

注意，这里没有64位的IO操作。即使在64位的体系架构上，端口地址空间也只是用最大32位的数据通路。

}


ioperm()
{
/usr/share/man/man7/capabilities.7.gz? [ynq] 
/usr/share/man/man4/console_ioctl.4.gz? [ynq] 
/usr/share/man/man4/mem.4.gz? [ynq] 
/usr/share/man/man2/unimplemented.2.gz? [ynq] 
/usr/share/man/man2/ioctl_list.2.gz? [ynq] 
/usr/share/man/man2/syscalls.2.gz? [ynq] 
/usr/share/man/man2/outb.2.gz? [ynq] 
/usr/share/man/man2/ioperm.2.gz? [ynq] 
/usr/share/man/man2/iopl.2.gz? [ynq] 

misc-progs/inp.c
misc-progs/outp.c
------ 在用户空间访问IO端口 ------<sys/io.h>
1. 编译该程序时必须带-O选项来抢之内函数的展开。
2. 必须用ioperm或iopl系统调用来获取对端口进行IO操作的权限。
   ioperm用来获取对单个端口的操作权限
   iopl用来获取对整个IO空间的操作权限
3. 必须以root身份运行该程序才能调用ioperm或iopl.或者进程的祖先进程之一已经以root省份获取对端口的访问。

如果属主平台没有ioperm或iopl系统调用，则用户空间仍可以使用/dev/port设备文件访问IO端口。


}

io(串操作-一次传输一个数据序列)
{
void insb
void outsb
void insw
void outsb
void insl
void outsl
它们直接将字节流从端口中读取或写入。因此，当端口和主机系统具有不同的字节序时，将导致不可预期的结果。
使用inw读取端口将在必要时交换字节，以便确保读入的值匹配于主机的字节序。然而，串函数不会完成这种交换。

}

io(暂停式IO--防止丢失数据)
{
暂停式IO    
inb_p
inw_p
inl_p
outb_p
outw_p
outl_p

在处理器试图从总线上快速传输数据时，某些平台会遇到问题。
当处理器时钟相比外设时钟快时就会出现问题，并且在设备板卡特别慢是表现出来。
：解决办法是在每条io指令后，如果还有其他指令，则插入一个小的延迟。

如果有设备丢失数据的情况，或为了防止丢失数据的情况，可以使用暂停式IO函数来取代通常的IO函数。

TTL 0伏 5伏 1.2伏 /dev/short0
}

读者不会在不了解底层硬件的情况下为特定的系统编写驱动程序。
ARM：端口映射到内存，支持所有函数，串操作用C语言实现。端口类型是unsigned int.
x86_64：支持本章提到的所有函数，端口号的类型是unsigned short.

x86家族之外的处理器都不为端口提供独立的地址空间，尽管使用其中几种处理器的机器带有ISA和PCI插槽
(两种总线都实现了不同的IO和内存地址空间)。

io(内存-- 映射内存的寄存器和映射设备内存)
{

    访问IO内存的方法和计算机体系架构、总线以及正在使用的设备有关，不过原理都是相同的。根据计算机平台和所使用总线的不同，
IO内存可能是、也可能不是通过页表访问的。如果访问是经由页表进行的，内核必须首先安排物理地址时期对设备驱动程序可见(这通常
意味着在进行任何IO之前必须先调用ioremap)。如果访问无需页表，那么IO内存区域就非常类似于IO端口，可以使用适当形式的函数读写
它们。
    不管访问IO内存时是否需要调用ioremap,都不鼓励直接使用指向IO内存的指针。尽管IO内存在硬件一级像普通RAM一样寻址，但是在IO
寄存器和常规内存一节中描述过的需要额外小心的内容中，我们不建议使用普通的指针。相反，使用包装函数访问IO内存，这一方面在所有
平台上都是安全的，另一方面，在可以直接对指针指向的内存区域执行操作的时候，这个函数是经过优化的。
    
    除了x86上普遍使用的IO端口之外，和设备通信的另一种主要机制是通过使用映射到内存的寄存器或设备内存。这两种都称为IO内存
因为寄存器和内存的差别对软件是透明的。
    IO内存仅仅是类似RAM的一个区域，在哪里处理是可以通过总线访问设备。这种内存有很多用途，比如存放视频数据或以太网数据包，
也可以用来实现类似IO端口的设备寄存器(也就是说，对它们的读写也存在边际效应)。    
    
    一旦调用ioremap之后，设备驱动程序即使可以访问任意的IO内存地址了，而无论IO内存地址是否直接映射到虚拟地址空间。但是记住，由
ioremap返回的地址不应直接引用，而应该使用内核提供的accesssor函数。

------ 使用内存 ------ 
根据计算机平台和所使用总线的不同：IO内存可能是、也可能不是通过页表访问的。
io内存分配和映射：

linux/ioport.h
#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
#define release_mem_region(start,n)	__release_region(&iomem_resource, (start), (n))
#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))

static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
#define ioremap_nocache ioremap
static inline void iounmap(void *addr)

------ read
#define ioread8(addr)		readb(addr)
#define ioread16(addr)		readw(addr)
#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
#define ioread32(addr)		readl(addr)
#define ioread32be(addr)	be32_to_cpu(ioread32(addr))

------ write
#define iowrite8(v, addr)	writeb((v), (addr))
#define iowrite16(v, addr)	writew((v), (addr))
#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
#define iowrite32(v, addr)	writel((v), (addr))
#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))

必须在给定的IO内存地址处读写一系列的值。
#define ioread8_rep(p, dst, count) 
#define ioread16_rep(p, dst, count) 
#define ioread32_rep(p, dst, count) 

#define iowrite8_rep(p, src, count)
#define iowrite16_rep(p, src, count) 
#define iowrite32_rep(p, src, count)

在一块IO内存上执行操作：
void memset_io(void *addr, u8 value, unsigned int count)
void memcpy_fromio(void *dest, void *source, unsigned int count)
void memcpy_ioto(void *dest, void *source, unsigned int count)

废弃接口
unsigned readb(address)
unsigned readw(address)
unsigned readl(address)
void writeb(unsigned value, address)
void writew(unsigned value, address)
void writel(unsigned value, address)

------ 像IO内存一样使用端口 ------ 

extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
extern void ioport_unmap(void __iomem *p);

}

ISA(0xA0000-0x100000 640KB-1MB)
{

}

