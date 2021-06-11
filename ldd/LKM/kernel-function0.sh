make -C ${CB_KSRC_DIR} O=${CB_KBUILD_DIR} ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- kernel_defconfig 
make -C ${CB_KSRC_DIR} O=${CB_KBUILD_DIR} ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j4 INSTALL_MOD_PATH=${CB_TARGET_DIR} uImage modules


request_module()
{
http://blog.csdn.net/liukun321/article/details/7057442
# cat /proc/sys/kernel/modprobe
# /sbin/modprobe
# 我们也可以向/proc/sys/kernel/modprobe添加新的modprobe应用程序路径,这里的/sbin/modprobe是内核默认路径.

在2.6内核中，可以使用“request_module(const char *fmt,...)函数”加载内核模块（注意：前面加载模块都是通过
    insmod和modprobe来实现的），驱动开发人员可以通过调用::
request_module(module_name);
或
request_module("char-major-%d-%d",MAJOR(dev),MINOR(dev));
来加载其他内核模块。
   在linux内核中，所有表示为__init的函数在连接的时候放在.init.text这个区段内，此外，所有的__init函数在段
.initcall.init中还保存了一份函数指针，在初始化时，内核会通过这些指针调用这些__init函数，并在初始化完成后
释放init区段(.init.text,.initcall.init等)。

>>>>>>> 浅析request_module内核驱动直接引用用户空间程序/sbin/modprobe
    在soundcore_open打开/dev/dsp节点函数中会调用到下面的:
        request_module("sound-slot-%i", unit>>4);
    函数,这表示,让linux系统的用户空间调用/sbin/modprobe函数加载名为sound-slot-0.ko模块
    #define request_module(mod...) __request_module(true, mod)
    #define request_module_nowait(mod...) __request_module(false, mod)
}

    
    
http://www.cnblogs.com/hoys/archive/2012/03/13/2395232.html
>>>>>>>  使用call_usermodehelper在Linux内核中直接运行用户空间程序(转)
系统初始化时kernel_init在内核态创建和运行应用程序以完成系统初始化.  内核刚刚启动时，只有内核态的代码，后来在init过程中，在内核态运行了一些
初始化系统的程序，才产生了工作在用户空间的进程。

static noinline int init_post(void) //从内核里发起系统调用，执行用户空间的应用程序。这些程序自动以root权限运行。
这里，内核以此运行用户空间程序，从而产生了第一个以及后续的用户空间程序。一般用户空间的init程序，会启动一个shell，供用户登录系统用。这样，
这里启动的用户空间的程序永远不会返回。也就是说，正常情况下不会到panic这一步。系统执行到这里后，Linux Kernel的初始化就完成了。

此时，中断和中断驱动的进程调度机制，调度着各个线程在各个CPU上的运行。中断处理程序不时被触发。操作系统上，一些内核线程在内核态运行，它们永远
不会进入用户态。它们也根本没有用户态的内存空间。它的线性地址空间就是共享内核的线性地址空间。一些用户进程通常在用户态运行。
有时因为系统调用而进入内核态，调用内核提供的系统调用处理函数。
       但有时，我们的内核模块或者内核线程希望能够调用用户空间的进程，就像系统启动之初init_post函数做的那样。
       如，一个驱动从内核得到了主从设备号，然后需要使用mknod命令创建相应的设备文件，以供用户调用该设备。
       如，一个内核线程想神不知鬼不觉地偷偷运行个有特权的后门程序。等等之类的需求。

BIOS：x86内核的某些部分视频帧缓冲驱动程序和APM高级电源管理等部分x86内核明确使用了BIOS服务来完成特定的功能，
     串行驱动程序等内核其他的部分隐式地取决于BIOS来初始化IO基地址和中断级别。实模式的内核代码在引导期间大量
     使用BIOS调用，完成配置系统内存映射等任务。
       
      内核的很多部分在实模式下从BIOS收集信息，而在保护模式下正常运行期间会利用收集的信息。
      1. 实模式的内核代码调用BIOS服务，将返回的信息放置在物理内存的第一页，这些由arch/x86/boot目录下的源代码完成，
         零页的完整布局见Documentation/i386/zeropage.txt
      2. 在内核转向保护模式后，但清理零页之前，获取的数据存放在内核的数据结构中，见代码/arch/x86/kernel/setup_32.c
      3. 保护模式的内核在正常操作过程中合理使用保存的信息。
      
      从2.6.23内核开始，i386引导汇编代码大部分用C重写了，2.3.23之前，代码为arch/i386/boot/setup.S而不是/arch/x86/boot/memory.c
      切花至保护模式现在发生在arch/x86/boot/pm.c而不是setup.S
      
      Bootloader也利用BIOS服务，如果阅读LILO、GRUB或SYSLINUX的源代码，会发现为了从引导设备中读取内核映像，
      要0x13号中断的频繁调用。

 BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008e400 (usable)
 BIOS-e820: 000000000008e400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
实模式下的初始化代码通过使用BIOS的int 0x15服务并执行0xe820号函数来获取系统的内存映射信息。
内存映射信息中包含了预留的和可用的内存，内核将随后使用这些信息创建其可用的内存池。
 
 
 desc()
 {
 1. 新添加代码前添加"+"; 
   删除的代码前则添加了"-"; 
   arch/your-arch/中x86代码时，your-arch对应的就是x86，为arm代码时，your-arch对应的就是arm，
   *和X作为通配符，time*.h，表示time.h,timer.h,times.h, timex.h
   -> 符号有时候会插入在命令或内核的输入之间，目的是附加注释
   pci_[map|unmap|dma_sync]_single()替代了pci_map_single() pci_unmap_sigle() pci_dma_sync_sigle() 
 
lwn.net
kerneltrap.org 

patch
cd /usr/src/linux-x.y.z/               #linux-x.y.z.tar.bz2也在/usr/src
bzip2 -dc ../x.y.z-mm2.bz2 | patch -pl #x.y.z-mm2.bz2在/usr/src

使用-E选项可以让GCC产生预编译处理源代码。预处理代码包含头文件的扩展，并减少了为扩展多层宏定义在多个嵌套的头文件间进行跳跃的
需要，下面的例子预处理drivers/char/mydrv.c并产生扩展后的输出文件mydrv.i:
gcc -E drivers/char/mydrv.c -D__KERNEL__ -Iinclude -Iinclude/asm/-x86/mach-default > mydrv.i
使用-I选项可以指定你的代码所依赖的include的路径
使用-S选项可以让GCC产生汇编列表。
下面的命令可以为drivers/char/mydrv.c产生的汇编文件mydrv.s
gcc -S drivers/char/mydrv.c -D__KERNEL__ -Iinclude -Ianother/include/path 

 }
 
 
CONFIG_CMDLINE(Linux内核强制使用自配置的cmdline)
 {
  CONFIG_CMDLINE提供配置内核命令行参数。编译内核时。
  
  开发过程中遇到一些问题，需要改cmdline。cmdline在不同的平台上有不同的改法，有的单独存在于一个分区中，有的使用的是uboot，需要在启动过程中中断启动并进行手动修改，也有的平台上使用的是uboot的变种读取配置文件获取cmdline，更甚至还有一些平台在sdcard中跑系统和在emmc中跑系统的修改cmdline的方法都不一样，或许厂家还没有考虑到用户有改cmdline的需求。
一些方法是不可用的：
1. 需要改uboot源码才可以改cmdline的不可用；
2. 需要手动中断uboot启动并手动改cmdline的不可用；

可用的方法：
1. 将cmdline放到Android固件中，烧写Android固件的同时cmdline也已经设置好，不需要再操作，这样就可以量产设备。

综上所述，如果厂家没有将cmdline放到一个单独的存储空间中且在烧写固件时就把cmdline设置好的话，目标就锁定在了kernel上，内核是第一个拿到cmdline的，也只有它主要在用，内核的配置项中有一个配置内核启动参数的选项CONFIG_CMDLINE，但是它只是一个备胎，一般情况下还是主要使用bootloader传递过来的cmdline。
1. 强制内核使用自配置的cmdline
make menuconfig 
-> Boot options 
-> Kernel command line type (***) ( ) 
Use bootloader kernel arguments if available ( ) 
Extend bootloader kernel arguments (X) Always use the default kernel command string

嵌入式设备上的引导装入程序通常经过"瘦身"，并不支持配置文件或类似的机制，因此，许多非x86体系结构提供了
CONFIG_CMDLINE这个内核配置选项，通过它，用户可以在编译内核时提供内核命令行。
 }

 uboot(uboot和linux之间的参数传递)
 {
U-boot会给Linux Kernel传递很多参数，如：串口，RAM，videofb等。而Linux kernel也会读取和处理这些参数。两者之间通过struct tag
来传递参数。U-boot把要传递给kernel的东西保存在struct tag数据结构中，启动kernel时，把这个结构体的物理地址传给kernel；
Linux kernel通过这个地址，用parse_tags分析出传递过来的参数。

本文主要以U-boot传递RAM和Linux kernel读取RAM参数为例进行说明。
1、u-boot给kernel传RAM参数
./common/cmd_bootm.c文件中（指Uboot的根目录），bootm命令对应的do_bootm函数，当分析uImage中信息发现OS是Linux时，
调用./lib_arm/bootm.c文件中的do_bootm_linux函数来启动Linux kernel。
在do_bootm_linux函数中：
void do_bootm_linux (cmd_tbl_t *cmdtp, int flag, int argc, char *argv[],\
ulong addr, ulong *len_ptr, int verify)

2、Kernel读取U-boot传递的相关参数
对于Linux Kernel，ARM平台启动时，先执行arch/arm/kernel/head.S，此文件会调用arch/arm/kernel/head- common.S和
arch/arm/mm/proc-arm920.S中的函数，并最后调用start_kernel：
其中，setup_arch函数在arch/arm/kernel/setup.c文件中实现，如下：
void __init setup_arch(char **cmdline_p)

 }
 
 setupparam(Kernel 版本号：3.4.55)
 {
一 kernel通用参数
对于这类通用参数，kernel留出单独一块data段，叫.ini.setup段。在arch/arm/kernel/vmlinux.lds中：
.init.data : {
  *(.init.data) *(.cpuinit.data) *(.meminit.data) *(.init.rodata) *(.cpuinit.rodata) *(.meminit.rodata) . = ALIGN(32); __dtb_star
 . = ALIGN(16); __setup_start = .; *(.init.setup) __setup_end = .;
  __initcall_start = .; *(.initcallearly.init) __initcall0_start = .; *(.initcall0.init) *(.initcall0s.init) __initcall1_start =
  __con_initcall_start = .; *(.con_initcall.init) __con_initcall_end = .;
  __security_initcall_start = .; *(.security_initcall.init) __security_initcall_end = .;
  . = ALIGN(4); __initramfs_start = .; *(.init.ramfs) . = ALIGN(8); *(.init.ramfs.info)
 }

可以看到init.setup段起始__setup_start和结束__setup_end。
.init.setup段中存放的就是kernel通用参数和对应处理函数的映射表。在include/linux/init.h中

可以看出宏定义__setup以及early_param定义了obs_kernel_param结构体，该结构体存放参数和对应处理函数，存放在.init.setup段中。
可以想象，如果多个文件中调用该宏定义，在链接时就会根据链接顺序将定义的obs_kernel_param放到.init.setup段中。

__setup_console_setup编译时就会链接到.init.setup段中，kernel运行时就会根据cmdline中的参数名与.init.setup段中obs_kernel_param的name对比。
匹配则调用console-setup来解析该参数，console_setup的参数就是cmdline中console的值，这是后面参数解析的大体过程了。

 }
 
 tracepoint(http://blog.csdn.net/arethe/article/details/6293505)
 {
   代码中的追踪点提供了在运行时调用探测函数的钩子。追踪点可以打开（已连接探测函数）或关闭（没有连接探测函数）。
处于关闭状态的追踪点不会引发任何效果，除了增加了一点时间开销（检查一条分支语句的条件）
和空间开销（在instrumented function[不知道如何翻译合适]的尾部增加几条函数调用的代码，在独立区域增加一个数据结构）。
如果一个追踪点被打开，那么每次追踪点被执行时都会调用连接的探测函数，而且在调用者的执行上下文中。探测函数执行结束后，
将返回到调用者（从追踪点继续执行）。
    可以在代码中的重要位置安放追踪点。它们是轻量级的钩子函数，能够传递任意个数的参数，原型可以在定义追踪点的头文件中找到。

追踪点可以用来进行系统追踪并进行性能统计。
 每个追踪点都包含2个元素：
- 追踪点定义。位于头文件中。
- 追踪点声明。位于C文件中。
使用追踪点时，需要包含头文件linux/tracepoint.h.
例如，在文件[include/trace/subsys.h]中：
#include <linux/tracepoint.h>

DECLARE_TRACE(subsys_eventname,
TP_PROTO(int firstarg, struct task_struct *p),
TP_ARGS(firstarg, p));
在文件[subsys/file.c](添加追踪声明的地方)中：
#include <trace/subsys.h>

DEFINE_TRACE(subsys_eventname);

void somefct(void)

 }
 
CONFIG_NO_HZ(无节拍内核配置)
{
2.6.21内核支持无节拍的内核，它会根据系统的负载动态触发定时器中断。
}

CONFIG_SMP(内核支持多CPU){}
CONFIG_PREEMPT(内核支持抢占){}
CONFIG_DEBUG_SPINLOCK(找出自旋锁错误){}
CONFIG_SYSCTL(/proc/sys文件系统挂载){}

http://book.51cto.com/art/200912/169070.htm
ARM嵌入式Linux系统开发详解
arch(移植)
{
20.1 Linux内核移植要点
20.2 平台相关代码结构
20.3 建立目标平台工程框架
20.3.1 加入编译菜单项
20.3.2 设置宏与代码文件的对应关系
20.3.3 测试工程框架
20.4.1 ARM处理器相关结构
20.4.2 建立machine_desc结构
20.4.3 加入处理函数
20.4.4 加入定时器结构
20.4.5 测试代码结构
20.5.1 处理器初始化
20.5.2 端口映射
20.5.3 中断处理
20.5.4 定时器处理
20.5.5 编译最终代码
}
arch(mach-xxx不同处理器, arch-xxx不同平台相关)
{
    arch目录下每个平台的代码都采用了与内核代码相同的目录结构。以arch/arm目录为例，该目录下mm、lib、kernel、boot
目录与内核目录下对应目录的功能相同。此外，还有一些以字符串mach开头的目录，对应不同处理器特定的代码。从arch目录
结构可以看出，平台相关的代码都存放到arch目录下，并且使用与内核目录相同的结构。

    移植内核到新的平台主要任务是修改arch目录下对应体系结构的代码。一般来说，已有的体系结构提供了完整的代码框架，
移植只需要按照代码框架编写对应具体硬件平台的代码即可。在编写代码过程中，需要参考硬件的设计包括图纸、引脚连线、
操作手册等。

    在arch/arm目录下有许多的子目录和文件。其中以mach字符串开头的子目录存放某种特定的ARM内核处理器相关文件，
如mach-s3c2410目录存放S3C2410、S3C2440相关的文件。另外，在mach目录下还会存放针对特定开发板硬件的代码。

    boot目录存放了ARM内核通用的启动相关的文件；kernel是与ARM处理器相关的内核代码；mm目录是与ARM处理器相关的内存
管理部分代码。以上这些目录的代码一般不需要修改，除非处理器有特殊的地方，只要是基于ARM内核的处理一般都使用相同的
内核管理代码。

    通过分析ARM处理器体系目录的结构，加入针对mini2440开发板的代码主要是修改Kconfig文件、Makeifle文件、以及向
mach-s3c2410目录加入针对特定硬件的代码。

加入编译菜单项
修改arch/arm/mach-s3c2410/Kconfig文件，在endmenu之前加入下面的内容：
    config ARCH_MINI2440     // 开发板名称宏定义  
    bool "mini2440"        // 开发板名称  
    select CPU_S3C2440     // 开发板使用的处理器类型  
    help  
        Say Y here if you are using the mini2440.    // 帮助信

设置宏与代码文件的对应关系
    在设置宏与代码文件对应关系之前，首先建立一个空的代码文件。在arch/arm/mach-s3c 2410目录下建立mach-mini2440.c文件，
用于存放与mini2440开发板相关的代码。
    建立mach-mini2440.c文件后，修改arch/arm/mach-s3c2410/Makefile文件，在文件最后加入mach-mini2440.c文件的编译信息：
    obj-$(CONFIG_ARCH_MINI2440) += mach-mini2440.o 
        
make ARCH=arm CROSS_COMPILE=arm-linux- menuconfig
Load an Alternate Configuration File菜单，进入后输入"arch/arm/ configs/s3c2410_defconfig"
进入System Types菜单项，打开S3C24XX Implementations菜单，
make ARCH=arm CROSS_COMPILE=arm-linux- bzImage
       

建立目标平台代码框架
编译的内核代码最后出现了链接错误，提示vmlinux.lds文件链接失败。 

ARM处理器相关结构
arch/arm/kernel/vmlinux.lds
ASSERT((__proc_info_end - __proc_info_begin), "missing CPU support")
    

在arch/arm目录下搜索__proc_info_begin标号：
    $ grep -nR '__proc_info_begin' *   

    machine_desc结构描述了处理器体系结构编号、物理内存大小、处理器名称、I/O处理函数、定时器处理函数等。
每种ARM核的处理器都必须实现一个machine_desc结构，内核代码会使用该结构。    
}

arch(file)
{
Kconfig   
// 选项菜单配置文件  
Kconfig.debug  Makefile   
// make使用的配置文件  
boot   
// ARM处理器通用启动代码  
common     
// ARM处理器通用函数  
configs    
// 基于ARM处理器的各种开发板配置  
kernel     
// ARM处理器内核相关代码  
lib        
// ARM处理器用到的库函数  
mach-aaec2000  mach-clps711x  mach-clps7500  mach-ebsa110  mach-epxa10db  mach-footbridge  mach-h720x  
mach-imx  mach-integrator  mach-iop3xx  mach-ixp2000       
// Intel IXP2xxx系列网络处理器  
mach-ixp4xx        
// Intel IXp4xx系列网络处理器  
mach-l7200  mach-lh7a40x  mach-omap1  mach-pxa   
// Intel PXA系列处理器  
mach-rpc  mach-s3c2410   
// 三星S3C24xx系列处理器  
mach-sa1100  mach-shark  mach-versatile  mm         
// ARM处理器内存函数相关代码  
nwfpe  oprofile  plat-omap  tools  // 编译工具  vfp
}