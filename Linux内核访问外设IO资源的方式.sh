Linux内核访问外设I/O资源的方式

    我们知道默认外设I/O资源是不在Linux内核空间中的（如sram或硬件接口寄存器等），若需要访问该外设I/O资源，必须先将其地址
映射到内核空间中来，然后才能在内核空间中访问它。
Linux内核访问外设I/O内存资源的方式有两种：动态映射(ioremap)和静态映射(map_desc)。

ioremap(动态映射)
{
一、动态映射(ioremap)方式
    动态映射方式是大家使用了比较多的，也比较简单。即直接通过内核提供的ioremap函数动态创建一段外设I/O内存资源到内核
虚拟地址的映射表，从而可以在内核空间中访问这段I/O资源。
ioremap宏定义在asm/io.h内：
#define ioremap(cookie,size)           __ioremap(cookie,size,0)

__ioremap函数原型为(arm/mm/ioremap.c)：
void __iomem * __ioremap(unsigned long phys_addr, size_t size, unsigned long flags);
phys_addr：要映射的起始的IO地址
size：     要映射的空间的大小
flags：    要映射的IO空间和权限有关的标志
该函数返回映射后的内核虚拟地址(3G-4G). 接着便可以通过读写该返回的内核虚拟地址去访问之这段I/O内存资源。

举一个简单的例子: (取自s3c2410的iis音频驱动)
比如我们要访问s3c2410平台上的I2S寄存器, 查看datasheet知道IIS物理地址为0x55000000，我们把它定义为宏S3C2410_PA_IIS，如下：
#define S3C2410_PA_IIS    (0x55000000)
若要在内核空间(iis驱动)中访问这段I/O寄存器(IIS)资源需要先建立到内核地址空间的映射:
our_card->regs = ioremap(S3C2410_PA_IIS, 0x100);
#   if (our_card->regs == NULL) {
#            err = -ENXIO;
#            goto exit_err;
#   }
创建好了之后，我们就可以通过readl(our_card->regs )或writel(value, our_card->regs)等IO接口函数去访问它。

}

machine_desc(系统体系架构相关部分-- mach-xxx.c 文件中)
{  [machine_desc结构描述与处理器相关的代码]

machine_desc结构体通过MACHINE_START宏来初始化，在代码中，通过在start_kernel->setup_arch中调用setup_machine_fdt来获取。

/* 在文件：arch/arm/include/asm/mach/arch.h */  
struct machine_desc                         结构体          arch.h
MACHINE_START(MA, "myboard")                结构体初始化    mach-xxx.c
start_kernel->setup_arch->setup_machine_fdt 结构体调用      devtree.c

在移植BSP的时候需要填充 machine_desc 结构体，其中有两个字段 phys_io 和 io_pg_offst，

DEFINE(MACHINFO_PHYSIO, offsetof(struct machine_desc, phys_io));
DEFINE(MACHINFO_PGOFFIO, offsetof(struct machine_desc, io_pg_offst));

其余各个成员函数在setup_arch()中被赋值到内核结构体，在不同时期被调用：
1. .init_machine 在 arch/arm/kernel/setup.c 中被 customize_machine 调用，放在 arch_initcall() 段里面，会自动按顺序被调用。
2. .init_irq在start_kernel() --> init_IRQ() --> init_arch_irq()中被调用
3. .map_io 在 setup_arch() --> paging_init() --> devicemaps_init()中被调用
4. .timer是定义系统时钟，定义TIMER4为系统时钟，在arch/arm/plat-s3c/time.c中体现。在start_kernel() --> time_init()中被调用。
5. .boot_params是bootloader向内核传递的参数的位置，这要和bootloader中参数的定义要一致。

}

iotable_init()
{
 iotable_init一般只映射基础的组件，需要在内核启动时候的先初始化的寄存器，其余的寄存器在驱动中通过ioremap进行映射。
 这里映射了GPIO、IRQ、MEMCTRL、UART寄存器，即把S3C24XX_PA_XX映射到S3C24XX_VA_XX。

    /* minimal IO mapping */  
    #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }  
    static struct map_desc s3c_iodesc[] __initdata = {  
        IODESC_ENT(GPIO),  
        IODESC_ENT(IRQ),  
        IODESC_ENT(MEMCTRL),  
        IODESC_ENT(UART)  
    };
    http://blog.csdn.net/huangbin0709/article/details/52728313
    
    
}

map_desc(静态映射)
{
    通常来说，BSP需要提供芯片级驱动，并要为板级驱动提供一些服务，在为具体芯片移植linux内核时，通常都会建立芯片级外设I/O内存
物理地址到虚拟地址的静态映射，这通常是通过板文件中的MACHINE_START宏中的map_io函数来实现的，map_io函数中通常通过调用。
    iotable_init函数来建立页映射关系，如：iotable_init(s3c_iodesc, ARRAY_SIZE(s3c_iodesc));这种静态映射关系通常通过map_desc
结构体来描述，map_desc结构定义如下：

struct map_desc {                         cpu.h
    unsigned long virtual;
    unsigned long physical;
    unsigned long length;
    unsigned int type;
};
cpu.h 和 io.h
#define MT_DEVICE        0              IODESC_ENT(x)   ioremap_nocache(cookie,size)  ioremap(cookie,size)
#define MT_DEVICE_NONSHARED    1
#define MT_DEVICE_CACHED    2          ioremap_cached(cookie,size)
#define MT_DEVICE_WC        3          ioremap_wc(cookie,size)

二、静态映射(map_desc)方式
下面重点介绍静态映射方式即通过map_desc结构体静态创建I/O资源映射表。

    内核提供了在系统启动时通过map_desc结构体静态创建I/O资源到内核地址空间的线性映射表(即page table)的方式，这种映射表是
一种一一映射的关系。程序员可以自己定义该I/O内存资源映射后的虚拟地址。创建好了静态映射表，在内核或驱动中访问该I/O资源时
则无需再进行ioreamp动态映射，可以直接通过映射后的I/O虚拟地址去访问它。

下面详细分析这种机制的原理并举例说明如何通过这种静态映射的方式访问外设I/O内存资源。

    内核提供了一个重要的结构体struct machine_desc ,这个结构体在内核移植中起到相当重要的作用,内核通过machine_desc结构体来控制
系统体系架构相关部分的初始化。
    machine_desc结构体的成员包含了体系架构相关部分的几个最重要的初始化函数，包括map_io, init_irq, init_machine以及phys_io, 
timer成员等。

machine_desc结构体定义如下：
    machine_desc结构描述了处理器体系结构编号、物理内存大小、处理器名称、I/O处理函数、定时器处理函数等。每种ARM核的处理器
都必须实现一个machine_desc结构，内核代码会使用该结构。
struct machine_desc {
    /*
     * Note! The first four elements are used
     * by assembler code in head-armv.S
     */
    unsigned int        nr;             /* architecture number    */                 处理器编号，自动生成  
    unsigned int        phys_io;        /* start of physical io    */                物理端口起始地址
    unsigned int        io_pg_offst;    /* byte offset for io page tabe entry */     IO页表的偏移字节的地址（MMU页表）
    const char        *name;            /* architecture name    */                   处理器名称 
    unsigned long        boot_params;   /* tagged list        */                     启动参数存放地址
    unsigned int        video_start;    /* start of video RAM    */                  视频设备存储器起始地址
    unsigned int        video_end;      /* end of video RAM    */                    视频设备存储器结束地址
    unsigned int        reserve_lp0 :1;    /* never has lp0    */
    unsigned int        reserve_lp1 :1;    /* never has lp1    */
    unsigned int        reserve_lp2 :1;    /* never has lp2    */
    unsigned int        soft_reboot :1;    /* soft reboot        */                 是否软启动 
    void            (*fixup)(struct machine_desc *,
                     struct tag *, char **,
                     struct meminfo *);
    void            (*map_io)(void);/* IO mapping function    */                     I/O端口内存映射函数
    void            (*init_irq)(void);                                               中断初始化函数
    struct sys_timer    *timer;        /* system tick timer    */                    定时器
    void            (*init_machine)(void);                                           初始化函数
};

这里的map_io成员即内核提供给用户的创建外设I/O资源到内核虚拟地址静态映射表的接口函数。Map_io成员函数会在系统初始化过程中被调用,流程如下：
Start_kernel -> setup_arch() --> paging_init() --> devicemaps_init()中被调用

Machine_desc结构体通过MACHINE_START宏来初始化。
注：MACHINE_START的使用及各个成员函数的调用过程请参考


MACHINE_START(SMDK2410, "SMDK2410") /* @TODO: request a new identifier and switch
                 * to SMDK2410 */
    /* Maintainer: Jonas Dietsche */
    .phys_io    = S3C2410_PA_UART,
    .io_pg_offst    = (((u32)S3C24XX_VA_UART) >> 18) & 0xfffc,
    .boot_params    = S3C2410_SDRAM_PA + 0x100,
    .map_io        = smdk2410_map_io,                   I/O端口映射初始化函数
    .init_irq    = s3c24xx_init_irq,                    中断初始化函数
    .init_machine    = smdk2410_init,                   处理器初始化函数
    .timer        = &s3c24xx_timer,
MACHINE_END

[s3c24xx_timer]
struct sys_timer {
    void            (*init)(void);             	// 定时器初始化函数 
    void            (*suspend)(void);          
    void            (*resume)(void);            // 恢复定时器
#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
    unsigned long        (*offset)(void);       // 读取定时器延时
#endif
};

如上,map_io被初始化为smdk2410_map_io。smdk2410_map_io即我们自己定义的创建静态I/O映射表的函数。在Porting内核到
新开发板时，这个函数需要我们自己实现。

(注：这个函数通常情况下可以实现得很简单，只要直接调用iotable_init创建映射表就行了，我们的板子内核就是。不过s3c2410平台
     这个函数实现得稍微有点复杂，主要是因为它将要创建IO映射表的资源分为了三个部分(smdk2410_iodesc, s3c_iodesc以及
     s3c2410_iodesc)在不同阶段分别创建。这里我们取其中一个部分进行分析，不影响对整个概念的理解。)
S3c2410平台的smdk2410_map_io函数最终会调用到s3c2410_map_io函数。
流程如下：s3c2410_map_io -> s3c24xx_init_io -> s3c2410_map_io

下面分析一下s3c2410_map_io函数：
void __init s3c2410_map_io(struct map_desc *mach_desc, int mach_size)
{
    /* register our io-tables */
    iotable_init(s3c2410_iodesc, ARRAY_SIZE(s3c2410_iodesc));
    ……
}

iotable_init内核提供，定义如下：
/*
* Create the architecture specific mappings
*/
void __init iotable_init(struct map_desc *io_desc, int nr)
{
    int i;
    for (i = 0; i  nr; i++)
        create_mapping(io_desc + i);
}

由上知道，s3c2410_map_io最终调用iotable_init建立映射表。

iotable_init函数的参数有两个：一个是map_desc类型的结构体，另一个是该结构体的数量nr。这里最关键的就是struct map_desc。
map_desc结构体定义如下：  

create_mapping函数就是通过map_desc提供的信息创建线性映射表的。
这样的话我们就知道了创建I/O映射表的大致流程为：只要定义相应I/O资源的map_desc结构体，并将该结构体传给iotable_init函数执行，就可以创建相应的I/O资源到内核虚拟地址空间的映射表了。

我们来看看s3c2410是怎么定义map_desc结构体的(即上面s3c2410_map_io函数内的s3c2410_iodesc)。
/* arch/arm/mach-s3c2410/s3c2410.c */
static struct map_desc s3c2410_iodesc[] __initdata = {
    IODESC_ENT(USBHOST),
    IODESC_ENT(CLKPWR),
    IODESC_ENT(LCD),
    IODESC_ENT(TIMER),
    IODESC_ENT(ADC),
    IODESC_ENT(WATCHDOG),
};

IODESC_ENT宏如下：
#define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }

展开后等价于：
static struct map_desc s3c2410_iodesc[] __initdata = {
    {
        .virtual    =     (unsigned long)S3C24XX_VA_ LCD),
        .pfn        =     __phys_to_pfn(S3C24XX_PA_ LCD),
        .length    =    S3C24XX_SZ_ LCD,
        .type    =     MT_DEVICE
    },
    ……
};

S3C24XX_PA_ LCD和S3C24XX_VA_ LCD为定义在map.h内的LCD寄存器的物理地址和虚拟地址。在这里map_desc 结构体的virtual成员被初始化为S3C24XX_VA_ LCD，pfn成员值通过__phys_to_pfn内核函数计算，只需要传递给它该I/O资源的物理地址就行。Length为映射资源的大小。MT_DEVICE为I/O类型，通常定义为MT_DEVICE。
这里最重要的即virtual 成员的值S3C24XX_VA_ LCD，这个值即该I/O资源映射后的内核虚拟地址，创建映射表成功后，便可以在内核或驱动中直接通过该虚拟地址访问这个I/O资源。

S3C24XX_VA_ LCD以及S3C24XX_PA_ LCD定义如下：
/* include/asm-arm/arch-s3c2410/map.h */
/* LCD controller */
#define S3C24XX_VA_LCD          S3C2410_ADDR(0x00600000)   //LCD映射后的虚拟地址
#define S3C2410_PA_LCD           (0x4D000000)    //LCD寄存器物理地址
#define S3C24XX_SZ_LCD           SZ_1M        //LCD寄存器大小

S3C2410_ADDR 定义如下：
#define S3C2410_ADDR(x)        ((void __iomem *)0xF0000000 + (x))
这里就是一种线性偏移关系，即s3c2410创建的I/O静态映射表会被映射到0xF0000000之后。(这个线性偏移值可以改，也可以你自己在virtual成员里手动定义一个值，只要不和其他IO资源映射地址冲突,但最好是在0XF0000000之后。)

(注：其实这里S3C2410_ADDR的线性偏移只是s3c2410平台的一种做法，很多其他ARM平台采用了通用的IO_ADDRESS宏来计算物理地址到虚拟地址之前的偏移。
IO_ADDRESS宏定义如下：
/* include/asm/arch-versatile/hardware.h */
/* macro to get at IO space when running virtually */
#define IO_ADDRESS(x)            (((x) & 0x0fffffff) + (((x) >> 4) & 0x0f000000) + 0xf0000000) )

s3c2410_iodesc这个映射表建立成功后，我们在内核中便可以直接通过S3C24XX_VA_ LCD访问LCD的寄存器资源。
如：S3c2410 lcd驱动的probe函数内
/* Stop the video and unset ENVID if set */
info->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
lcdcon1 = readl(S3C2410_LCDCON1); //read映射后的寄存器虚拟地址
writel(lcdcon1 & ~S3C2410_LCDCON1_ENVID, S3C2410_LCDCON1); //write映射后的虚拟地址

S3C2410_LCDCON1寄存器地址为相对于S3C24XX_VA_LCD偏移的一个地址，定义如下：
/* include/asm/arch-s3c2410/regs-lcd.h */
#define S3C2410_LCDREG(x) ((x) + S3C24XX_VA_LCD)
/* LCD control registers */
#define S3C2410_LCDCON1        S3C2410_LCDREG(0x00)

到此，我们知道了通过map_desc结构体创建I/O内存资源静态映射表的原理了。总结一下发现其实过程很简单，一通过定义map_desc结构体创建静态映射表，二在内核中通过创建映射后虚拟地址访问该IO资源。


}


instance(I/O静态映射方式应用实例)
{
I/O静态映射方式通常是用在寄存器资源的映射上，这样在编写内核代码或驱动时就不需要再进行ioremap，直接使用映射后的内核虚拟地址访问。同样的IO资源只需要在内核初始化过程中映射一次，以后就可以一直使用。

寄存器资源映射的例子上面讲原理时已经介绍得很清楚了，这里我举一个SRAM的实例介绍如何应用这种I/O静态映射方式。当然原理和操作过程同寄存器资源是一样的，可以把SRAM看成是大号的I/O寄存器资源。

比如我的板子在0x30000000位置有一块64KB大小的SRAM。我们现在需要通过静态映射的方式去访问该SRAM。我们要做的事内容包括修改kernel代码，添加SRAM资源相应的map_desc结构，创建sram到内核地址空间的静态映射表。写一个Sram Module,在Sram Module 内直接通过静态映射后的内核虚拟地址访问该sram。

第一步：创建SRAM静态映射表
在我板子的map_des结构体数组(xxx_io_desc）内添加SRAM资源相应的map_desc。如下：
static struct map_desc xxx_io_desc[] __initdata = {
    …………
    {
        .virtual    = IO_ADDRESS(XXX _UART2_BASE),
        .pfn        = __phys_to_pfn(XXX _UART2_BASE),
        .length        = SZ_4K,
        .type        = MT_DEVICE
    },{
        .virtual    = IO_ADDRESS(XXX_SRAM_BASE),
        .pfn        = __phys_to_pfn(XXX_SRAM_BASE),
        .length        = SZ_4K,
        .type        = MT_DEVICE
    },
};

宏XXX_SRAM_BASE为我板子上SRAM的物理地址,定义为0x30000000。我的kernel是通过IO_ADDRESS的方式计算内核虚拟地址的，这点和之前介绍的S3c2410有点不一样。不过原理都是相同的，为一个线性偏移, 范围在0xF0000000之后。

第二步：写个SRAM Module,在Module中通过映射后的虚拟地址直接访问该SRAM资源
SRAM Module代码如下：
/* Sram Testing Module */
……
# static void sram_test(void)
# {
#     void * sram_p;
#     char str[] = "Hello,sram!\n";
#    
#     sram_p = (void *)IO_ADDRESS (XXX_SRAM_BASE); /* 通过IO_ADDRESS宏得到SRAM映射后的虚拟地址 */
#     memcpy(sram_p, str, sizeof(str));    //将 str字符数组拷贝到sram内
#     printk(sram_p);
#     printk("\n");
# }
# static int __init sram_init(void)
# {
#     struct resource * ret;
#    
#     printk("Request SRAM mem region ............\n");
#     ret = request_mem_region(SRAM_BASE, SRAM_SIZE, "SRAM Region");
#    
#     if (ret ==NULL) {
#         printk("Request SRAM mem region failed!\n");
#         return -1;
#     }
#    
#     sram_test();
#     return 0;
# }
# static void __exit sram_exit(void)
# {
#     release_mem_region(SRAM_BASE, SRAM_SIZE);   
#    
#     printk("Release SRAM mem region success!\n");
#     printk("SRAM is closed\n");
# }
# module_init(sram_init);
# module_exit(sram_exit);

在开发板上运行结果如下：
/ # insmod bin/sram.ko
Request SRAM mem region ............
Hello,sram!      &szlig; 这句即打印的SRAM内的字符串
/ # rmmod sram
Release SRAM mem region success!
SRAM is close

实验发现可以通过映射后的地址正常访问SRAM。

最后，这里举SRAM作为例子的还有一个原因是通过静态映射方式访问SRAM的话，我们可以预先知道SRAM映射后的内核虚拟地址（通过IOADDRESS计算）。这样的话就可以尝试在SRAM上做点文章。比如写个内存分配的MODULE管理SRAM或者其他方式，将一些critical的数据放在SRAM内运行，这样可以提高一些复杂程序的运行效率(SRAM速度比SDRAM快多了)，比如音视频的编解码过程中用到的较大的buffer等。

}

exynos4_init_irq(中断初始化)
{
Setup_arch
    init_arch_irq =mdesc->init_irq;
    system_timer =mdesc->timer;
    init_machine =mdesc->init_machine;
    
void __init init_IRQ(void)//在start_kernel()中调用
    init_arch_irq()
    
1.中断个数
start_kernel->early_irq_init->arch_probe_nr_irqs函数中nr_irqs = arch_nr_irqs ? arch_nr_irqs : NR_IRQS;设置全局nr_irqs变量
2.中断初始化函数
start_kernel->init_IRQ->init_arch_irq() 

}

smdk4x12_map_io(I/O端口内存映射函数)
{
setup_arch-> paging_init ->devicemaps_init
                                            |------ mdesc->map_io();
}

smdk4x12_machine_init(初始化函数)
{
    static void (*init_machine)(void)__initdata;
    static int __init customize_machine(void)  -> init_machine();
        arch_initcall(customize_machine);
        
在do_basic_setup()
      |-------do_initcalls()中调用
      
    platform_add_devices(smdk4x12_devices, ARRAY_SIZE(smdk4x12_devices)); 设备驱动初始化
}

void __init time_init(void)//在start_kernel()中调用，初始化时钟
{
       system_timer->init();
}

__initdata(){
__init和__initdata定义在include/linux/init.h：

/* These macros are used to mark some functions or 
 * initialized data (doesn't apply to uninitialized data)
 * as `initialization' functions. The kernel can take this
 * as hint that the function is used only during the initialization
 * phase and free up used memory resources after
 *
 * Usage:
 * For functions:
 * 
 * You should add __init immediately before the function name, like:
 *
 * static void __init initme(int x, int y)
 * {
 *    extern int z; z = x * y;
 * }
 *
 * If the function has a prototype somewhere, you can also add
 * __init between closing brace of the prototype and semicolon:
 *
 * extern int initialize_foobar_device(int, int, int) __init;
 *
 * For initialized data:
 * You should insert __initdata between the variable name and equal
 * sign followed by value, e.g.:
 *
 * static int init_variable __initdata = 0;
 * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
 *
 * Do not forget to initialize data not at file scope, i.e. within a function,
 * as gcc otherwise puts the data into the bss section and not into the init
 * section.
 * 
 * Also note, that this data cannot be "const".
 */

/* These are for everybody (although not all archs will actually
   discard it in modules) */
#define __init      __section(.init.text) __cold notrace
#define __initdata  __section(.init.data)
#define __initconst __constsection(.init.rodata)
__init修饰函数时表明函数只在kernel初始化阶段使用（函数放在.init.text区），在初始化完成后，这些函数所占用的内存就可以回收利用。举例如下：

static int __init parse_dmar_table(void)
{
    ....
}
__initdata作用类似于__init，只不过它修饰变量，并且存放在.init.data区。


}
