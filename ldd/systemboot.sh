systemboot()
{
1. 实模式的入口函数_start()：在header.S中，这里会进入总所周知的main函数，它复制bootloader的各个参数，执行基本硬件设置，解析命令行参数。
2. 保护模式的入口函数startup_32()：在compressed/header_32.S中，这里会解压bzImage内核镜像，加载vmlinux内核文件。
3. 内核入口函数startup_32():在kernel/header_32.S中，这就是所谓的进程0，它会进入体系结构无关的start_kernel()函数，
   即Linux内核启动函数。start_kernel()会做大量的内核初始化操作，解析内核启动的命令行参数，并启动一个内核线程来完成
   内核模块初始化的过程，然后进入空循环。
4. 内核模块初始化的入口函数kernel_init():在init/main.c中，这里会启动内核模块、创建基于内存的rootfs、加载initramfs文件或
   cpio-initrd,并启动一个内核线程来运行其中的/init脚本，完成真正的根文件系统的挂载。
5. 根文件系统挂在脚本/init:这里会挂载根文件系统、运行/sbin/init,从而启动进程1.
6. init进程的系统初始化过程：执行相关脚本，以完成系统初始化，例如键盘、字体、装载模块，设置网络等等，最后运行登录程序，出现登录界面。


1. CPU上电
2. 从CS:IP=FFFF:0000入口出载入BIOS
3. 载入GRUB到0x07C00处(通过中断0x19)
4. 载入内核镜像vmlinux
5. 实模式入口函数(head.o偏512处)arch/x86/boot/header.S:_start()
6. 实模式main函数:arch/x86/boot/main.c:main()
                  arch/x86/boot/pm.c:go_to_protected_mode()
                  arch/x86/boot/pmjump.S:protected_mode_jump()
7. 保护模式入口函数(0x100000处)：
                  arch/x86/boot/compressed/head_32.S:startup_32()
                  arch/x86/kernel/head_32.S:startup_32()
                  arch/x86/kernel/head_32.c:i386_start_kernel()
8. Linux内核启动函数(体系结构无关)：
                  init/main.c:start_kernel()
9. 创建内存rootfs: fs/dcache.c vfs_caches_init()
                   fs/namespace.c:mnt_init()
10. 内核初始化函数：init/main.c:reset_init()
                    init/main.c:kernel_init()
11. 载入RAM磁盘：  init/initramfs.c:populate_rootfs()
11.1 cpio-initrd -> /init -> 运行/init脚本： init/main.c:init_post()
                                             init/main.c:run_init_process()

11.2 image-initrd -> /init/do_mounts.c:prepare_namespace() -> /linuxrc
12. 检查并挂载procfs,sysfs,/proc/mounts
          读取/proc/cmdline
          启动udev:udevd-daemon
13. 从/etc/fstab挂载硬盘各分区挂载真正根文件系统启动用户空间的/sbin/init         
}

sysmodule()
{
在Linux中，对模块进行加载有两种方法，一种是手动加载，另一种是自动加载。前者使用insmod或modprobe命令实现；
后者通过内核线程kmod来实现，而kmod通过调用modprobe来实现模块的加载。
模块卸载比较简单。同样模块卸载也有两种方式，一种是用户使用rmmod命令完成卸载，另一种通过kerneld或kmod自动卸载。

用户空间的工具udev利用了sysfs提供的信息来实现所有devfs的功能，不同的是udev运行在用户空间，devfs运行在内核空间。
而且udev不存在devfs哪些先天的缺陷。

udev分为3个计划：
namedev为设备命名子系统，为发现的设备提供默认的命名规则，
libsysfs是访问sysfs文件系统并从中获取设备信息的标准接口。
udev是namedev和libsysfs连接的桥梁，利用获取的信息完成设备节点文件的创建和删除策略。


}
systemboot(史前时代：BIOS)
{
计算机在上电那一刻几乎是毫无用处的，此时，RAM中包含的全部是随机数据。

    在开始启动时，一个特殊的硬件电路在CPU的一个引脚上产生一个RESET逻辑值，在RESET产生之后，就把处理器的一些寄存器设置成固定的值，
并执行在物理地址0xFFFFFFF0处找到的代码(Younger注：该代码我称之为BIOS代码)。硬件会把这个地址映射到某个只读、持久的存储芯片中，
该芯片被称为ROM(即：Read-Only Memory)。

    Linux一旦进入实模式,就不再使用BIOS，而是linux本身为计算机上的每个硬件设备提供各自的设备驱动程序。实际上，因为BIOS过程必须在
实模式下运行，而内核在保护模式下运行，所以即使在二者之间共享函数是有益的，也不能共享。

    BIOS是采用实模式寻址的，因为在上电启动时，计算机只能寻址这么大的地址空间（请参阅实模式与保护模式的区别）。实模式地址由一个
segment段和一个offset偏移量组成。相应的物理地址样计算方法：segment＊16 + offset。此时，CPU寻址电路不需要全局描述表(GDT)、
局部描述表(LDT)和页表(PT)。显然，对GDT,LDT和PT进行初始化的代码必须在实模式下运行。

那么在BIOS阶段，都是做了哪些工作哪？.BIOS启动过程实际上执行一下4个操作:
1. 上电自检：对计算机硬件执行一系列的测试，用来检测现在都有什么设备以及这些设备是否正常工作，这个阶段通常称为POST(上电自检)。这个阶段中，会显示一些信息，如BIOS版本号等。
2. 初始化硬件设备：这个阶段在现代基于PCI的体系机构中相当重要，因为它可以保证所有的硬件设备操作不会引起IRQ线与I/O端口的冲突。在本阶段的最后，会显示系统中所安装的所有PCI设备的一个列表。(实际上，由BIOS扫描的一系列设备数据都会被内存引用，尤其是在PCI扫描的过程，一般只是对 BIOS扫描结果后的一种确认，而内核也一般不需要过多地重新扫描PCI资源)。
3. 搜索一个操作系统来启动：实际上，根据BIOS的设置，这个过程可能要试图访问系统中的软盘，硬盘和CDROM等设备的第一个扇区。
4. 装载代码(引导程序)：只要找到一个有效的设备,就把第一个扇区的内容拷贝到RAM中从物理地址0x00007c00(X86)或0x00008000（ARM）开始的位置,然后跳转到这个地址处,开始执行刚才转载进来的代码。

head-y          := arch/arm/kernel/head$(MMUEXT).o arch/arm/kernel/init_task.o
textofs-y       := 0x00008000
}

systemboot(远古时代：BootLoader)
{
    引导装入程序（Bootloader）是BIOS将操作系统内核映像装载到RAM中执行的第一个程序。
    
    软盘启动与磁盘启动过程稍有不同，仅此处仅仅分析磁盘启动方式。
    
    从硬盘启动时，硬盘的第一个扇区MBR（Master Boot Record）中包含分区表和一小段程序，这段小程序用来装载被启动的操作系统所在分区的
第一个扇区的内容。针对Linux系统，第一个扇区中存放的是bootloader，可以允许用户选择要启动的操作系统。
    
    从磁盘启动linux内核，Bootloader通被BIOS加载到RAM的0x00008000处开始执行。

Bootloader的主要执行过程：
1. 初始化 RAM：因为 Linux 内核一般都会在 RAM 中运行，所以在调用 Linux 内核之前 bootloader 必须设置和初始化 RAM，为调用 Linux内核做好准备。初始化 RAM 的任务包括设置CPU 的控制寄存器参数，以便能正常使用 RAM 以及检测RAM 大小等。
2. 初始化串口：串口在 Linux 的启动过程中有着非常重要的作用，它是 Linux内核和用户交互的方式之一。Linux 在启动过程中可以将信息通过串口输出，这样便可清楚的了解 Linux 的启动过程。虽然它并不是 Bootloader 必须要完成的工作，但是通过串口输出信息是调试Bootloader 和Linux 内核的强有力的工具，所以一般的 Bootloader 都会在执行过程中初始化一个串口做为调试端口。
3．检测处理器类型：Bootloader在调用 Linux内核前必须检测系统的处理器类型，并将其保存到某个常量中提供给 Linux 内核。Linux 内核在启动过程中会根据该处理器类型调用相应的初始化程序
4. 设置 Linux启动参数：Bootloader在执行过程中必须设置和初始化 Linux 的内核启动参数。
5. 调用 Linux内核映像：Bootloader完成的最后一项工作便是调用 Linux内核。如果 Linux 内核存放在 Flash 中，并且可直接在上面运行（该 Flash 指 Nor Flash），那么可直接跳转到内核中去执行。但由于在 Flash 中执行代码会有种种限制，而且速度也远不及RAM 快，所以一般的嵌入式系统都是将 Linux内核拷贝到 RAM 中，然后跳转到 RAM 中去执行，不论哪种情况，在跳到 Linux 内核执行之前 CPU的寄存器必须满足以下条件：r0＝0，r1＝处理器类型，r2＝标记列表在 RAM中的地址。
}

systemboot(内核启动 - 原始时代：加载内核)
{
    在 bootloader将 Linux 内核映像拷贝到 RAM 以后，可以通过下例代码启动 Linux 内核： 
    
    call_linux(0, machine_type, kernel_params_base)。 
    
    其中，machine_tpye 是 bootloader检测出来的处理器类型， kernel_params_base 是启动参 数在 RAM 的地址。通过这种方式将 Linux 启动
 需要的参数从 bootloader传递到内核。 
    
    Linux 内核有两种映像：一种是非压缩内核，叫 Image，另一种是它的压缩版本，叫 zImage。
    
    根据内核映像的不同，Linux 内核的启动在开始阶段也有所不同。zImage 是 Image 经过压缩形成的，所以它的大小比 Image 小。但为了能
使用 zImage，必须在它的开头加上解压缩的代码，将 zImage 解压缩之后才能执行，因此它的执行速度比 Image 要慢。但考虑 到嵌入式系统的
存储空容量一般比较小，采用 zImage 可以占用较少的存储空间，因此牺牲一点性能上的代价也是值得的。所以一般的嵌入式系统均采用压缩内核
的方式。

    对于 ARM 系列处理器来说，zImage 的入口程序即为 arch/arm/boot/compressed/head.S。 它依次完成以下工作：开启 MMU 和Cache，调用
decompress_kernel()解压内核，最后通过 调用 call_kernel()进入非压缩内核 Image 的启动。下面将具体分析在此之后 Linux 内核的启
动过程。

}

systemboot(内核启动 -  封建时代：Linux内核入口)
{
    Linux 非压缩内核的入口位于文件/arch/arm/kernel/head-armv.S 中的 stext 段。该段的基 地址就是压缩内核解压后的跳转地址。
如果系统中加载的内核是非压缩的 Image，那么 bootloader将内核从 Flash中拷贝到 RAM 后将直接跳到该地址处，从而启动 Linux 内核。 
不同体系结构的 Linux 系统的入口文件是不同的，而且因为该文件与具体体系结构有 关，所以一般均用汇编语言编写[3] 。对基于 ARM 
处理的 Linux 系统来说，该文件就是 head-armv.S。该程序通过查找处理器内核类型和处理器类型调用相应的初始化函数，再建立页表，
最后跳转到 start_kernel()函数开始内核的初始化工作。 
    
    检测处理器内核类型是在汇编子函数__lookup_processor_type中完成的。通过以下代码 可实现对它的调用： bl __lookup_processor_type。 
__lookup_processor_type调用结束返回原程序时，会将返回结果保存到寄存器中。其中 r8保存了页表的标志位，r9 保存了处理器的 ID 号，
r10 保存了与处理器相关的 stru proc_info_list 结构地址。 检测处理器类型是在汇编子函数 __lookup_architecture_type 中完成的。
与 __lookup_processor_type类似，它通过代码：“bl __lookup_processor_type”来实现对它的调 用。该函数返回时，会将返回结构保存在
 r5、r6 和 r7 三个寄存器中。其中 r5 保存了 RAM 的起始基地址，r6 保存了 I/O基地址，r7 保存了 I/O的页表偏移地址。 
    
    当检测处理器内核和处理器类型结束后，将调用__create_page_tables 子函数来建立页 表，它所要做的工作就是将RAM 基地址开始的 4M 
空间的物理地址映射到 0xC0000000 开 始的虚拟地址处。当所有的初始化结束之后，使用如下代码来跳到C程序的入口函数 start_kernel()处，
开始之后的内核初始化工作：
    b SYMBOL_NAME(start_kernel)
}

systemboot(内核启动 -  近代：start_kernel函数)
{
start_kernel是所有 Linux 平台进入系统内核初始化后的入口函数，它主要完成剩余的与 硬件平台相关的初始化工作，在进行一系列与内核相关的初始化后，调用第一个用户进程－ init 进程并等待用户进程的执行，这样整个 Linux 内核便启动完毕。该函数所做的具体工作 
有[4][5] ： 

1) 调用 setup_arch()函数进行与体系结构相关的第一个初始化工作； 对不同的体系结构来说该函数有不同的定义。对于 ARM 平台而言，
   该函数定义在 arch/arm/kernel/Setup.c。它首先通过检测出来的处理器类型进行处理器内核的初始化，然后 通过 bootmem_init()函数
   根据系统定义的 meminfo 结构进行内存结构的初始化，最后调用 paging_init()开启MMU，创建内核页表，映射所有的物理内存和 IO空间。 
2) 创建异常向量表和初始化中断处理函数； 
3) 初始化系统核心进程调度器和时钟中断处理机制；
4) 初始化串口控制台（serial-console）； 
ARM-Linux 在初始化过程中一般都会初始化一个串口做为内核的控制台，这样内核在 启动过程中就可以通过串口输出信息以便开发者或用户了解系统的启动进程。 
5) 创建和初始化系统 cache，为各种内存调用机制提供缓存，包括;动态内存分配，虚拟文 件系统（VirtualFile System）及页缓存。 
6) 初始化内存管理，检测内存大小及被内核占用的内存情况；
7) 初始化系统的进程间通信机制（IPC）； 
当以上所有的初始化工作结束后，start_kernel()函数会调用 rest_init()函数来进行最后的 

    初始化，包括创建系统的第一个进程－init 进程来结束内核的启动。Init 进程首先进行一系列的硬件初始化，然后通过命令行传递过来的参数
挂载根文件系统。最后 init 进程会执行用户传递过来的“init＝”启动参数执行用户指定的命令，或者执行以下几个进程之一： 

execve("/sbin/init",argv_init,envp_init); 
execve("/etc/init",argv_init,envp_init); 
execve("/bin/init",argv_init,envp_init); 
execve("/bin/sh",argv_init,envp_init)。 

当所有的初始化工作结束后，cpu_idle()函数会被调用来使系统处于闲置（idle）状态并等待用户程序的执行。至此，整个 Linux 内核启动完毕。
}