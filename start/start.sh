BIOS -> MBR -> 
key()
{
    事实上DOS就是在BIOS的基础上实现的。
    BIOS也提供了在保护模式下扫描PCI设备的方法，
    gcc可以编译出来各种文件类型 objdump -i
    为了保持可移植性，Linux采用了三级页表。
}

bios()
{
    加电时，寄存器CS里的值为0xffff，IP里的值为0。于是CPU从线性地址
0xffff0处开始取指令。0xffff0处是什么地方呢？
    运行cat /proc/iomem
    000f0000-000fffff : System ROM
可以看到0xffff0处是System ROM，也就是BIOS，注意这里的地址是16位实地址模式下的线性地址。

BIOS能做的事，包括开机时对设备的检测，最后去读硬盘上的第一个扇区（即引导扇区MBR）的512个字节，
把它们拷贝到地址为0x7c00处的内存中。

}

setup()
{
arch/i386/boot/setup.S  #负责从16位实地址模式跳到32位段式寻址的保护模式，然后设置eip，

                                        在x86上，保护模式有两种，32位页式寻址
的保护模式和32位段式寻址的保护模式。显然，32位页式寻址的保护模式要求系统中已经
构造好页表。从16位实地址模式直接到32位页式寻址的保护模式是很有难度的，因为你要
在16位实地址模式下构造页表。所以不妨三级跳，先从16位实地址模式跳到32位段式寻
址的保护模式，再从32位段式寻址的保护模式跳到32位页式寻址的保护模式。

arch/i386/boot/tools/build.c中看出来。build.c是用户态工具build的源代码，后者用
来把bootsect(MBR),setup(辅助程序)和vmlinux.bin(压缩过的内核)拼接成bzImage。

MBR只有512个字节，而且有64个字节来存放主分区表。这样看来，MBR
的功能就很有限了。所以，最好在setup和MBR之间再架一座桥梁。引导程序，对，用它来
引导setup再合适不过了。现有的引导程序如grub,lilo不仅功能强大，而且还提供了人机
交互的功能。再合适不过了。

1.为什么不用C写呢？
原因很简单，因为setup要尽量短小精悍，由于种种原因，它的大小不能超过63.5K.
2.如何引用变量？
在setup.S中，定义了不少全局变量。在编译生成setup文件时，链接参数
LDFLAGS_setup    := -Ttext 0x0 -s --oformat binary -e begtext
意为text段的地址为0，输出格式为binary（而不是默认的elf32-i386），入口地址begtext。

由于基本上处于16位实模式下，所以只要设置好CS等段寄存器就可以正确地寻址了。

现在我们跳到vmlinux.bin的开头(位于0x1000或者0x100000)，也就是startup_32()，执行相应代码。

3.helloworld，vmlinux，arch/i386/boot/compressed/vmlinux，setup,bootsect
的区别与联系。
这几个可执行文件都是由gcc编译生成。只是格式不一样。
其中，helloworld,vmlinux,arch/i386/boot/compressed/vmlinux都是elf32_i386
格式的可执行文件。setup，bootsect是binary格式的可执行文件，它们的区别在于
1).helloworld是普通的elf32_i386可执行文件。它的入口是_start。运行在用户态空间。
变量的地址都是32位页式寻址的保护模式的地址，在用户态空间。由shell负责装载。
2).vmlinux是未压缩的内核，它的入口是startup_32(0x100000，线性地址)，运行在内核
态空间，变量的地址是32位页式寻址的保护模式的地址，在内核态空间。由内核自解压后
启动运行。
3).arch/i386/boot/compressed/vmlinux是压缩后的内核，它的入口地址是
startup_32(0x100000，线性地址).运行在32位段式寻址的保护模式下，变量的地址是32
位段式寻址的保护模式的地址。由setup启动运行。
4).setup是装载内核的binary格式的辅助程序。它的入口地址是：begtext（偏移地址为
0。运行时需要把cs段寄存器设置为0x9020）。运行在16位实地址模式下。变量的地址等
于相对于代码段起始地址的偏移地址。由boot loader启动运行。
5).bootsect是MBR上的引导程序，也为binary格式。它的入口地址是_start()，由于装载
到0x7c00处，运行时需要把cs段寄存器设置为0x7c0。运行在16位实地址模式下。变量地
址等于相对于代码段起始地址的偏移地址。由BIOS启动运行。
问题出现了。startup_32有两个，分别在这两个文件中：
arch/i386/boot/compressed/head.S
arch/i386/kernel/head.S
那究竟执行的是哪一个呢？难道编译时不会报错么？

}

setup(run)
{
1.CPU加电，从0xffff0处，执行BIOS（可以理解为"硬件"引导BIOS）
2.BIOS执行扫描检测设备的操作，然后将MBR读到物理地址为0x7c00处。然后从MBR头部
开始执行（可以理解为BIOS引导MBR）
3.MBR上的代码跳转到引导程序，开始执行引导程序的代码，例如grub（引以理解为BIOS
引导boot loader）。
4.引导程序把内核映象(包括bootsect，setup，vmlinux)读到内存中，其中setup位于
0x90200处，如果是zImage，则vmlinux.bin位于0x10000（64K）处。如果是bzImage，则
vmlinux.bin位于0x100000（1M）处。然后执行setup（可以理解为boot loader引导
setup）
5.setup负责引导linux内核vmlinux.bin

从start开始，setup做了很多操作，例如，如果是zImage，则把它从0x10000拷贝
到0x1000，调用bios功能，查询硬件信息，然后放在内存中供将来的内核使用，然后建立
临时的idt和gdt，负责把16位实地址模式转化为32位段式寻址的保护模式。

}

compress(Linux内核启动-内核解压缩)
{
    真正的内核执行映像其实是在编译时生成arch/$(ARCH)/boot/文件夹中的Image文件（bin文件），
而zImage其实是将这个可执行文件作为数据段包含在了自身中，而zImage的代码功能就是将这个
数据（Image）正确地解压到编译时确定的位置中去，并跳到Image中运行。

这得从vmliux.bin的产生过程说起。
从内核的生成过程来看内核的链接主要有三步：
第一步是把内核的源代码编译成.o文件，然后链接，这一步，链接的是
arch/i386/kernel/head.S，生成的是vmlinux。注意的是这里的所有变量地址都是32位页
寻址方式的保护模式下的虚拟地址。通常在3G以上。
第二步，将vmlinux objcopy 成arch/i386/boot/compressed/vmlinux.bin，之后加
以压缩，最后作为数据编译成piggy.o。这时候，在编译器看来，piggy.o里根本不存在什
么startup_32。
第三步，把head.o,misc.o和piggy.o链接生成
arch/i386/boot/compressed/vmlinux，这一步，链接的是
arch/i386/boot/compressed/head.S。这时arch/i386/kernel/head.S中的startup_32被
压缩，作为一段普通的数据，而被编译器忽视了。注意这里的地址都是32位段寻址方式的
保护模式下的线性地址。
自然，在这过程中，不可能会出现startup_32重定义的问题。

内核解压完毕。位于0x100000即1M处
最后，执行一条跳转指令，执行0x100000处的代码，即startup_32()，这回是arch/i386/
kernel/head.S中的startup_32()代码
ljmp $(__BOOT_CS), $__PHYSICAL_START

}

head()
{
由于在Linux中，每个进程拥有一个页表，那么，第一个页表也应该有一个对应的进
程。通常情况下，Linux下通过fork()系统调用，复制原有进程，来产生新进程。然而第一
个进程该如何产生呢？既然不能复制，那就只能像女娲造人一样，以全局变量的方式捏造一
个出来。它就是init_thread_union。传说中的0号进程，名叫swapper。只要swapper进
程运行起来，调用start_kernel()，剩下的事就好办了。不过，现在离运行swapper进程还
差得很远。关键的一步，我们还没有为该进程设置页表。

为了保持可移植性，Linux采用了三级页表。不过x86处理器只使用两级页表。所
以，我们需要一个页目录和很多个页表（最多达1024个页表），页目录和页表的大小均为
4k。swapper的页目录的创建与该进程的创建思维类似，也是捏造一个页表，叫
swapper_pg_dir.
417 ENTRY(swapper_pg_dir)
418         .fill 1024,4,0
它的意思是从swapper_pg_dir开始，填充1024项，每项为4字节，值为0，正好是
4K一个页面。
页目录有了，接下去看页表。一个问题产生了。该映射几个页表呢？尽管一个页目录
最多能映射1024个页表，每个页表映射4M虚拟地址，所以总共可以映射4G虚拟地址空
间。但是，通常应用程序用不了这么多。最简单的想法是，够用就行。先映射用到的代码和
数据。还有一个问题：如何映射呢？运行cat /proc/$pid/maps可以看到，用户态进程的地
址映射是断断续续的，相当复杂。这是由于不同进程的用户空间相互独立。但是，由于所有
进程共享内核态代码和数据，所以映射关系可以大大简化。既然内核态虚拟地址从3G开
始，而内核代码和数据事实上是从物理地址0x100000开始，那么本着KISS原则，一切从
简，加上3G就作为对应的虚拟地址好了。由此可见，对内核态代码和数据来说：虚拟地址=
物理地址+PAGE_OFFSET(3G)
内核中有变量pg0，表示对应的页表。建立页表的过程如下：

nm vmlinux|grep pg0得c0595000。据此可以
计算总共映射了多少页（小学计算题:P）
所以映射了2个页表，映射地址从0x0~0x2000-1，大小为8M。

}