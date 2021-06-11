https://blog.csdn.net/changexhao/article/details/78321295 # Linux内核的整体架构简介
https://blog.csdn.net/fivedoumi/article/details/7521242   # 详解神秘Linux内核
https://www.linuxidc.com/Linux/2013-10/92120p5.htm        # 戴文的Linux内核专题
instance(){
下载并解压内核到任意目录
	~$ tar xjvf linux-3.0.4.tar.bz2
    
配置内核    
    ~/linux-3.0.4
    $sudo apt-get install libncurses5-dev
    ~/linux-3.0.4
    $sudo make menuconfig    
   
编译
   ~/linux-3.0.4$sudo make -j4
   
安装
	~/linux-3.0.4$sudo make modules_install
	~/linux-3.0.4$sudo make install
    
1.将编译内核时生成的内核镜像bzImage拷贝到/boot目录下，并将这个镜像命名为vmlinuz-3.0.4。如果使用x86的cpu，则该镜像位于arch/x86/boot/目录下（处于正在编译的内核源码下）。
2.将~/linux-3.0.4/目录下的System.map拷贝到/boot/目录下，重新命名为System.map-3.0.4。该文件中存放了内核的符号表。
3.将~/linux-3.0.4/目录下的.config拷贝到/boot/目录下，重新命名为config-3.0.4。   

创建initrd.img文件
    ~/linux-3.0.4$sudo mkinitramfs 3.0.4 -o /boot/initrd.img-3.0.4  

更新grub
最后一步则是更新grub启动菜单，使用下面的命令则可以自动更新启动菜单：
	sudo update-grub2
}

compile(安装编译总结){
标准:
make && make modules && make install && make modules_install

做一个更新的版本或者重整你的内核:
zcat /proc/config.gz >.config && make && make modules && make install && make modules_install

交叉编译:
make ARCH={TARGET-ARCHITERCTURE} CROSS_COMPILE={COMPILER};
make ARCH={TARGET-ARCHITERCTURE} CROSS_COMPILE={COMPILER} modules && make install && make modules_install
}


image(){
vmlinux：
一个非压缩的，静态链接的，可执行的，不能bootable的Linux kernel文件。是用来生成vmlinuz的中间步骤。

vmlinuz：
一个压缩的，能bootable的Linux kernel文件。vmlinuz是Linux kernel文件的历史名字，它实际上就是zImage或bzImage：

[root@Fedora boot]# file vmlinuz-4.0.4-301.fc22.x86_64
vmlinuz-4.0.4-301.fc22.x86_64: Linux kernel x86 boot executable bzImage, version 4.0.4-301.fc22.x86_64 (mockbuild@bkernel02.phx2.fedoraproject.o, RO-rootFS, swap_dev 0x5, Normal VGA
zImage：
仅适用于640k内存的Linux kernel文件。

bzImage：
Big zImage，适用于更大内存的Linux kernel文件。

总结一下，启动现代Linux系统时，实际运行的即为bzImage kernel文件。
}

mkimage(){
[uboot的绝对路径]/tools/mkimage -A arm -O linux -C gzip -a 0x20008000 -e 0x20008000 -d linux.bin.gz uImage # 这里的绝对路径是/usr/local/uboot
vmlinux linux.bin linux.bin.gz uImage(uboot制作的image)
mkimage -a -e
-a参数后是内核的运行地址，-e参数后是入口地址。

Usage: ./mkimage -l image
-l ==> list image header information
./mkimage -A arch -O os -T type -C comp -a addr -e ep -n name -d data_file[:data_file...] image
-A ==> set architecture to 'arch'
-O ==> set operating system to 'os'
-T ==> set image type to 'type'
-C ==> set compression type 'comp'
-a ==> set load address to 'addr' (hex)
-e ==> set entry point to 'ep' (hex)
-n ==> set image name to 'name'
-d ==> use image data from 'datafile'
-x ==> set XIP (execute in place)
参数说明：

-A 指定CPU的体系结构：
取值 表示的体系结构
alpha Alpha
arm A RM
x86 Intel x86
ia64 IA64
mips MIPS
mips64 MIPS 64 Bit
ppc PowerPC
s390 IBM S390
sh SuperH
sparc SPARC
sparc64 SPARC 64 Bit
m68k MC68000

-O 指定操作系统类型，可以取以下值：
openbsd、netbsd、freebsd、4_4bsd、linux、svr4、esix、solaris、irix、sco、dell、ncr、lynxos、vxworks、psos、qnx、u-boot、rtems、artos

-T 指定映象类型，可以取以下值：
standalone、kernel、ramdisk、multi、firmware、script、filesystem

-C 指定映象压缩方式，可以取以下值：
none 不压缩
gzip 用gzip的压缩方式
bzip2 用bzip2的压缩方式

-a 指定映象在内存中的加载地址，映象下载到内存中时，要按照用mkimage制作映象时，这个参数所指定的地址值来下载
-e 指定映象运行的入口点地址，这个地址就是-a参数指定的值加上0x40（因为前面有个mkimage添加的0x40个字节的头）
-n 指定映象名
-d 指定制作映象的源文件
}

make命令驱动内核Makefile的执行。Makefile包含流程控制和配置控制。
流程控制通过环境变量进行配置；配置控制通过Kconfig生成.config进行配置。

make流程控制：拷贝位置的设定；内核版本的设定；内核的构建和清除。
make配置控制：.config文件的生成 [make menuconfig; make xconfig; make config]

在scripts/kconfig/生成可执行文件。
make config;      conf       autoconfig.h
make nconfig;     nconfig    autoconfig.h
make menuconfig;  mconfig    autoconfig.h
make xconfig;     xconfig    autoconfig.h
make gconfig;     gconfig    autoconfig.h  

https://www.linuxidc.com/Linux/2013-10/92120.htm # 戴文的Linux内核专题

help(帮助说明){
    make ARCH=x86_64 defconfig
    make ARCH=x86_64 help
    make ARCH=arm help
    make CC="ccache gcc"
    make CC="ccache distcc"

    用来显示信息的工作目标：脚本常常用这些信息确定内核版本信息。
    kernelrelease: 由内建系统确定并显示当前内核版本。
    kernelversion: 根据主Makefile显示当前内核版本，和kernelrelease工作目标不同的是，
                   它并不使用任何基于配置选项或版本文件的附加信息

    
    清除 
    clean:     删除内核构建系统产生大部分文件，但是，保留内核配置，依然能够编译外部模块。
    mrproper:  删除内核构建系统产生的所有文件，包括配置文件和各种备份文件。
    distclean :恢复系统到最原始的状态，出了mrproper外，还会删除备份patch，和cscope，tag等
               执行mrproper所作的一切，并删除编辑器备份文件和补丁遗留文件。

    make M=dir clean
    
1、如果.config不存在，运行make config/menuconfig时的缺省设置由固化在各个Kconfig文件中各项目的缺省值决定。
2. 如果.config存在，运行make config/menuconfig时的缺省设置即是当前.config的设置，若对设置进行了修改,.config将被更新。
3. 在把一个老版本kernel的.config文件拷贝到一个新版本的kernel源代码文件夹后，要执行“make oldconfig”命令。它的作用是检查
   已有的.config文件和Kconfig文件的规则是否一致，如果一致，就什么都不做，否则提示用户哪些源代码中有的选项在.config文件没有。
    
    配置   %config, config, menuconfig, xconfig gconfig nconfig [启动Kconfig，以不同界面来配置内核。]
           oldconfig         使用基于当前的.config文件更新内核配置，并提示内核添加的新选项。
                             CONFIG_IKCONFIG_PROC  /proc/config.gz > .config
                             # make oldconfig的作用是备份当前.config文件为.config.old，
                             # 如若make config/menuconfig设置不当可用于恢复先前的.config
                             = 纯文本界面，但是其默认的问题是基于已有的本地配置文件。
           silentoldconfig  和oldconfig相同，但是除非有新选项否则不打印任何东西
一旦有了一个可以工作的配置，我们唯一需要做的就是根据最新版本内核添加的选项更新它。
要做到这一点，应该使用make oldconfig 和 make silentoldconfig方式。
                            = 和oldconfig相似，但是不会显示配置文件中已有的问题的回答
           olddefconfig     = 和silentoldconfig相似，但有些问题已经以它们的默认值选择。
           randconfig       使用随机生成的内核配置
           defconfig        使用所有选项的默认值生成内核配置。默认值来自于arch/$ARCH/defconfig文件，
           # arch/arm/defconfig是一个缺省的配置文件，make defconfig时会根据这个文件生成当前的.config。
                            = 这个选项将会创建一份以当前系统架构为基础的默认设置文件。
            ${PLATFORM}defconfig = 创建一份使用arch/$ARCH/configs/${PLATFORM}defconfig中的值的配置文件。
           allmodconfig     生成内核配置，将所有可能的选项构建成模块
           allyesconfig     生成所有选项全部选择是的内核配置
           allnoconfig      生成所有选项全部选择否的内核配置
randconfig、allmodconfig、allyesconfig、allnoconfig目标也使用环境变量KCONFIG_ALLCONFIG。如果这个变量指向一个文件，该文件将被用作选项值列表。
如果没有KCONFIG_ALLCONFIG变量，构建系统将检查顶级build目录中的以下文件：allmod.config,allno.config,allrandom.config,allyes.config。
如果以上任意一个文件存在，构建系统将把它作为强制使用的选项值列表。
           localmodconfig - 这个选项会根据当前已加载模块列表和系统配置来生成配置文件。
           localyesconfig - 将所有可装载模块（LKM）都编译进内核(

           make xxx_defconfig
# arch/arm/configs文件夹中有许多命名为xxx_defconfig的配置文件，如果运行make xxx_defconfig，当前.config文件会由xxx_defconfig文件生成。

    编译   all            编译vmlinux内核映像和内核模块；
	       vmlinux        编译vmlinux内核映像；不包括任何可加载模块
		   modules        编译内核模块
           
           dir/              构建指定目录及其子目录下的所有文件 
           dir/file.[o|i|s]  仅构建指定的文件
           dir/file.ko        构建所有必须的文件并将它们链接成指定模块
           
    安装   headers_install安装内核头文件/模块
		   modules_install安装内核头文件/模块
           
           make M=dir modules_install
           
    V=0    告诉构建系统以静态方式运行，仅仅显示当前正在构建的文件而不是构建文件的整条命令。本选项是构建系统的默认行为。
    V=1    此变量告诉构建系统以冗余方式运行，并显示用于构建各个文件的完整命令
    O=dir  告诉构建系统将所有文件输出到dir目录中，包括内核配置文件。
    make O=~/linux/linux-2.6.30
    C=1    使内核构建系统用sparse工具检测所有将被构建的C源文件，以防止常见编程错误
    C=2     强制使用sparse工具检测所有C源文件
    -j      多处理器并行执行
    
    源码浏览
        tags               生成代码浏览工具所需要的文件
           TAGS
           cscope   
    静态分析
          checkstack   检查并分析内核代码
          namespacecheck
          headers_check	   
    内核打包      %pkg    以不同的安装格式编译内核
    文档转换      %doc    把kernel文档转成不同格式 
    
    构架相关（以arm为例）
            bzImage  创建一个放置在arch/i386/boot/bzImage文件内的压缩内核镜像，本选项是i386架构构建时的默认工作目标
            zImage  生成压缩的内核映像
            uImage  生成压缩的u-boot可引导的内核映像
            bzdisk  创建一个软盘镜像，并写入/dev/fd0设备
            fdimage 在arch/i386/boot/fdimage创建一个可引导的软盘镜像。为使他正常工作，系统中必须安装mtools包。
            isoimage 在arch/i386/boot/image.iso创建一个可引导CD-ROM镜像，为使它正常工作，系统中必须安装syslinux包。
            install 使用发行版提供的/sbin/installkernel程序安装内核，不会安装内核模块，此操作需要使用modules_install工作目标完成。
            
    模块
make M=dir clean            Delete all automatically generated files
make M=dir modules          Make all modules in specified dir
make M=dir                  Same as 'make M=dir modules'
make M=drivers/usb/serial   #生成.ko文件，可能该目录下有多个.ko文件
make M=dir modules_install

make dir/                   编译单个目录,包括遍历子目录。
make drivers/usb/serial     #生成.o文件

make dir/file.[ois]         编译单个文件
make dir/file.ko            编译单个模块
make drivers/usb/serial/visor.ko #生成特定的模块文件

用来打包的工作目录
    rpm         首先构建内核，然后打包成可供安装的RPM包
    rpm-pkg     构建包含内核源代码的RPM源码包
    binrpm-pkg  构建包含已编译内核和模块的RPM包
    deb-pkg     构建包含已编译内核和模块的Debain格式的包
    tar-pkg     构建包含已编译内核和模块的tarball tar格式
    targz-pkg   构建包含已编译内核和模块的tarball targz格式
    tarbz2-pkg  构建包含已编译内核和模块的tarball tarbz2格式

用来生成文档的工作目录
xmldocs、psdocs、pdfdocs、htmldocs、mandocs

    
--------平台相关的变量
编译连接选项
LDFLAGS 通用$(LD)选项
LDFLAGS_MODULE 联接模块时的联接器的选项
LDFLAGS_vmlinux 联接vmlinux时的选项
OBJCOPYFLAGS objcopy flags
AFLAGS $(AS) 汇编编译器选项
CFLAGS $(CC) 编译器选项
CFLAGS_KERNEL $(CC) built-in 选项
CFLAGS_MODULE $(CC) modules选项     

make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build
make V=2 [targets] 2 => give reason for rebuild of target
make O=dir [targets] Locate all output files in "dir", including .config
make C=1 [targets] Check all c source with $CHECK (sparse by default)
make C=2 [targets] Force check of all c source with $CHECK
make -C=KERNELDIR M=dir modules 编译外部模块
make -C=KERNELDIR SUBDIRS=dir modules 同上，SUBDIRS优先级低于M

}

key(关键点)
{
	1. 生成的zImage内核的位置在arch/arm/boot目录下
	2. 内核根目录下的vmlinux映像文件是内核Makefile的默认目标。
	3. 我们可以看一下vmlinux和arch/i386/boot/compressed/vmlinux。用file命令查
		看，它们也是elf可执行文件。只是没有main函数而已.
	4. 当Kconfig系统生成.config后，Kbuild 会依据.config编译指定的目标。
	   Kconfig可以看做Kbuild执行的过程中可以打开的选项全部集合，而.config则是Kconfig选项集合的的子选项集合。
	   Kconfig分散在内核源代码的各个目录中。
	5. .config是Makefile的配置文件，是通过make *config通过工具生成的。Makefile和Kconfig显示了Makefile的所有配置开关。
	   .config是Makefile配置文件的配置开关子集。make程序驱动Makefile执行代码编译。
	6. scripts目录下的编译规则文件和其目录下的C程序在整个编译过程起着重要的作用  

key(patch)
{
Document/applying-patchs.txt

内核补丁文件用于将内核从一个特定版本升级到另一个版本：
1、稳定版内核补丁应用于主内核版本。这意味着2.6.29.5补丁只能应用于2.6.29版本内核，
   2.6.29.5内核补丁不能应用于2.6.29内核或其他的版本。
2、主内核版本补丁只能应用于上一个主内核版本。这意味着2.6.30补丁只能应用于2.6.29版本的内核
   不能应用于2.6.29.y内核版本或其他内核版本
3、增量补丁将内核从一个特定版本更新到下一个版本，这允许开发者把最新的稳定版本升级到下一个版本
而不用先降低内核，然后再升级。

例如：
ftp.kernel.org/pub/linux/v2.6/incr
2.6.29.4 -> 2.6.29.6 #需要2.6.29.4 到 2.6.29.5 和 2.6.29.4 到 2.6.29.6的补丁。

例如：
2.6.22.9 -> 2.6.23.9 #2.6.22.9先要降级到2.6.22 然后升级到2.6.23.再升级到2.6.23.9
bzcat ../patch-2.6.22.9.bz2|patch -p1 -R #使用R命令意思是取消补丁。这样我们就把22.9 降到 22
zcat ../patch-2.6.23.gz|patch -p1 #这样就升级到了2.6.23
bzcat ../patch-2.6.23.11.bz2|patch -p1 # 这样就升级到了2.6.23.11 这是现在stable的最新版。

例如：

}   
key(upgrade)
{
网络接口实例
basename `readlnk /sys/class/net/eth0/device/driver/module`
find -type f -name Makefile | xargs grep e1000
make menuconfig # /E1000

USB接口实例
ls /sys/class/tty/  | grep USB
basename `readlink /sys/class/tty/ttyUSB0/device/driver/module`
find -name -type f -name Makefile | grep xargs grep pl2303

#!/bin/bash
#
# find_all_modules.sh
#

for i in `find /sys/ -name modalias -exec cat {} \ ; ` ; do
    /sbin/modprobe --config /dev/null --show-depends $i ;
done | rev | cut -f 1 -d '/' | rev | sort -u    

PCI总线实例
lspci | grep -i ethernet
cd /sys/bus/pci/devices/ && ls
cd 0000:06:04.0
cat vendor #0x10ec
cat device #0x8139
grep -i 0x10ec include/linux/pci_ids.h
grep -i 0x8139 include/linux/pci_ids.h

grep -Rl PCI_VENDOR_ID_REALTEK *

}

}

doc(Linux内核的Makefile)
{
http://cxd2014.github.io/2015/11/11/Linux-Makefile/

doc(概述)
{
Linux的Makefile有５个部分：

Makefile 顶层Makefile文件
1. .config 内核配置文件
2. arch/$(ARCH)/Makefile 架构相关的Makefile
3. scripts/Makefile.* 所有kbuild　Makefiles文件的通用规则等
4. kbuild Makefiles 内核中有500个这样的文件
5. 顶层Makefile读取由配置内核时得到的.config文件。

    顶层Makefile负责编译两个主要文件：vmlinux（固有的内核映像）和modules（任何模块文件）。
    它通过递归进入内核源码树的子目录下构建目标。
    需要进入的子目录列表依赖于内核配置，顶层Makefile里面包含一个arch/$(ARCH)/Makefile架构下的Makefile文件。
这个架构下的Makefile提供架构相关的信息给顶层Makefile。
    每个子目录下有一个kbuild Makefile它执行从上面传递下来的命令。这个kbuild Makefile使用.config文件的信息来
构造kbuild编译built-in（内置）或modular（模块）目标所需要的文件列表。
    scripts/Makefile.*包含所有根据kbuild makefiles文件来编译内核时所需要的定义和规则等等。
}

doc(谁做什么)
{
    内核Makefile文件对于不同的人又四种不同的关系。
    
    Users编译内核的人。这些人使用例如make menuconfig或者make命令。他们通常不会阅读或者编辑任何内核Makefile文件
（和任何源码文件）。
    Normal developers开发某一特性的人如设备驱动，文件系统和网络协议。这些人需要维护他们工作的子系统的kbuild Makefile
文件。为了有效的做这些工作他们需要了解内核总体Makefile结构的知识，和kbuild公共接口的细节知识。
    Arch developers开发整个架构体系的人，例如is64或者sparc架构。架构开发者需要了解　arch Makefile和kbuild Makefiles。
    Kbuild developers开发内核构建系统本身的人，这些人需要了解所有内核Makefiles的细节。
    这个文档的目标读者是Normal developers和Arch developers。
}

doc(kbuild文件)
{
内核中的大多数Makefile文件是kbuild Makefiles它是kbuild的基础。这章介绍kbuild makefiles中使用的语法知识。
kbuild文件的首选名字是Makefile但是Kbuild也可以使用，当Makefile和Kbuild同时出现时Kbuild会被使用。

doc_kbuild(目标定义)
{
目标定义是kbuild Makefile的主要部分（核心）。定义了哪些文件被编译，哪些特殊编译选项，哪些子目录会递归进入。

最简单的kbuild makefile包含一行：

obj-y += foo.o
它告诉kbuild这个目录有一个名字为foo.o的目标，这个目标依赖foo.c或者foo.S文件被编译。 
如果foo.o将被编译为模块，使用obj-m变量因此下面的例子经常使用：

obj-$(CONFIG_FOO) += foo.o
$(CONFIG_FOO)设置为y（内置）或者m（模块）。 如果CONFIG_FOO既不是y和m,这个文件不会被编译和链接。
}

doc_kbuild(内置目标 - obj-y)
{
    kbuild Makefile通过$(obj-y)列表指定目标文件编译到vmlinux。这些列表依赖于内核配置。

    Kbuild编译所有$(obj-y)文件，然后调用$(LD) -r将这些文件打包为built-in.o文件。built-in.o稍后会被父Makefile链接到
vmlinux中。

    $(obj-y)文件的顺序是有意义的，列表中的文件允许重复：第一个实例会被链接到built-in.o中，剩下的会被忽略。

    链接顺序是有意义的，因为某些函数module_init() / __initcall在启动时会按他们出现的顺序被调用。所以要记住改变链接
顺序可能　例如：会改变SCSI控制器的检测顺序，导致磁盘被重新编号。

# #drivers/isdn/i4l/Makefile
# # Makefile for the kernel ISDN subsystem and device drivers.
# # 内核　ISDN　子系统和设备驱动的Makefile
# # Each configuration option enables a list of files.
# # 每一个配置选项使能一个列表中的文件
# obj-$(CONFIG_ISDN_I4L)         += isdn.o
# obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
}

doc_kbuild(可加载的目标 - obj-m)
{
$(obj-m)指定目标文件被编译为可加载到内核的模块。

一个模块可能由一个源文件或者几个源文件编译而成。当只有一个源文件时，kbuild makefile简单的使用$(obj-m)来编译。例如:

#drivers/isdn/i4l/Makefile
obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
注意：这个例子$(CONFIG_ISDN_PPP_BSDCOMP)的值为m

如果内核模块是由几个源文件编译而成的，你想使用上述相同的方法编译模块，但是kbuild需要知道哪些目标文件是你需要编译进模块中，所以你不得不通过设置$(<module_name>-y)变量来告诉它。例如:

#drivers/isdn/i4l/Makefile
obj-$(CONFIG_ISDN_I4L) += isdn.o
isdn-y := isdn_net_lib.o isdn_v110.o isdn_common.o
在这个例子中，模块名字是isdn.o。Kbuild会编译$(isdn-y)列出的所有目标文件然后执行$(LD) -r使这些文件生成isdn.o文件。

由于kbuild可以识别$(<module_name>-y)来合成目标，你可以使用CONFIG_符号的值来确定某些目标文件是否作为合成目标的一部分。例如:

由于kbuild可以识别$(<module_name>-y)来合成目标，你可以使用CONFIG_符号的值来确定某些目标文件是否作为合成目标的一部分。例如:

#fs/ext2/Makefile
    obj-$(CONFIG_EXT2_FS) += ext2.o
	ext2-y := balloc.o dir.o file.o ialloc.o inode.o ioctl.o \
			namei.o super.o symlink.o
    ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o xattr_user.o \
			xattr_trusted.o
在这个例子中，xattr.o, xattr_user.o 和 xattr_trusted.o只是合成目标ext2.o的一部分当$(CONFIG_EXT2_FS_XATTR)的值是y时。

注意：当然，当你编译目标到内核中去，上述语法也是可以用的。因此，如果CONFIG_EXT2_FS=y，kbuild会编译一个ext2.o文件然后链接到built-in.o文件中，正如你所期望的。
}

doc_kbuild(库文件 - lib-y)
{
obj-*列出的目标文件用于模块或者合成为特定目录下的built-in.o文件，也有可能被合成为一个库lib.a。
lib-y列出的所有文件被合成为此目录下的一个库文件。 
obj-y列出的目标文件和另外加入的文件不会被包含在库中，因为他们会在任何时候被访问。 
为了保持一致性lib-m列出的文件会包含在lib.a文件中。

注意相同的kbuild　makefile会编译文件到built-in文件中和一部分到库文件中。 因此相同的目录可能同时包含built-in.o文件和lib.a文件例如:

#arch/x86/lib/Makefile
lib-y    := delay.o
这会根据delay.o生成lib.a库文件，对于kbuild会意识到这是一个lib.a文件被编译， 这个目录会被列为libs-y。参见　6.3节。

lib-y一般仅限于使用在lib/和arch/*/lib目录中。

}

doc_kbuild(Descending down in directories)
{
一个Makefile文件只负责编译本目录下的目标，子目录下的文件归子目录下的Makefiles负责。编译系统会自动递归进入子目录并调用make，你需要知道这一点。

要做到这一点obj-y和obj-m会被使用。ext2分布在一个单独的目录中，fs/目录下的Makefile告诉kbuild使用下面规则进入子目录。例如:

#fs/Makefile
obj-$(CONFIG_EXT2_FS) += ext2/
如果CONFIG_EXT2_FS被设置为y或者m，相应的obj-变量会被设置，然后kbuild会进入ext2目录。Kbuild只是使用这些信息来决定是否需要进入此目录，然后子目录中的Makefile指定哪些需要编译为模块，哪些需要编译为built-in。

使用CONFIG_变量指定目录名字是非常好的做法，这可以使kbuild跳过那些CONFIG_选项不是y 和m的目录。
}


doc_kbuild(编译标志)
{
ccflags-y, asflags-y和ldflags-y

这三个标志只适用于被分配的kbuild makefile文件，他们用于正常递归编译时调用cc（编译器） 和ld（链接器）时。 
注意：这是以前使用的EXTRA_CFLAGS, EXTRA_AFLAGS和EXTRA_LDFLAGS三个标志，他们仍然可以使用但是过时了。

ccflags-y指定$(CC)的编译选项，例如:

# drivers/acpi/Makefile
ccflags-y := -Os
ccflags-$(CONFIG_ACPI_DEBUG) += -DACPI_DEBUG_OUTPUT
这个变量是必要的因为定层Makefile拥有$(KBUILD_CFLAGS)变量它在整个文件树中使用这个编译标志。

asflags-y指定$(AS)的编译选项，例如:

#arch/sparc/kernel/Makefile
asflags-y := -ansi
ldflags-y指定$(LD)的编译选项，例如:

#arch/cris/boot/compressed/Makefile
ldflags-y += -T $(srctree)/$(src)/decompress_$(arch-y).lds
subdir-ccflags-y,subdir-asflags-y

这两个标志和ccflags-y，asflags-y相似。不同的是subdir-前缀的变量对kbuild所在的目录以及子目录都有效。 
使用subdir-*指定的选项会被加入到那些使用在没有子目录的变量之前。例如:

subdir-ccflags-y := -Werror
CFLAGS_$@,AFLAGS_$@

CFLAGS_$@和AFLAGS_$@只应用于当前kbuild　makefile文件中 
$(CFLAGS_$@)是$(CC)针对单个文件的选项。$@代表某个目标文件。例如:

# drivers/scsi/Makefile
CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ \
		     -DGDTH_STATISTICS
这两行单独指定aha152x.o和gdth.o文件的编译选项。

$(AFLAGS_$@)应用于汇编文件，例如:

# arch/arm/kernel/Makefile
AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
AFLAGS_crunch-bits.o := -Wa,-mcpu=ep9312
AFLAGS_iwmmxt.o      := -Wa,-mcpu=iwmmxt
}

doc_kbuild(依赖跟踪)
{
Kbuild按照如下方式跟踪依赖文件：

所有必须的文件（包括 *.c 和 *.h）
CONFIG_选项应用于所有必需文件
命令行应用于编译目标
因此，如果你改变$(CC)的编译选项所有受影响的文件都会被重新编译。
}

doc_kbuild(CC支持的函数)
{
内核可以使用不同版本的$(CC)编译，每一种编译器有自己特性和选项。kbuild提供基本的检查$(CC)有效选项的功能，$(CC)通常是gcc 编译器，但是其他备用编译器也是可以的。

as-option 
as-option用于检查$(CC) – 当使用编译器编译汇编文件(*.S)时 – 支持给定选项。如果第一种选项不支持时可以指定第二种选项。例如:

#arch/sh/Makefile
cflags-y += $(call as-option,-Wa$(comma)-isa=$(isa-y),)
在上面的例子中，cflags-y会使用-Wa$(comma)-isa=$(isa-y)选项当$(CC)支持这种选项时。第二个参数是可选的，当不支持第一个参数是他会被使用。

cc-ldoption 
cc-ldoption用于检查当$(CC)链接目标文件是是否支持给定选项。如果不支持第一种选项时第二种选项会被使用。例如:

#arch/i386/kernel/Makefile
vsyscall-flags += $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
在上面的例子中，vsyscall-flags会使用-Wl$(comma)--hash-style=sysv如果$(CC)支持它，第二个参数是可选的，当不支持第一个参数是他会被使用。
}

}

doc(架构相关的Makefiles)
{
顶层Makefile在进入单个子目录前设置环境和做一些准备工作它包含通用部分，而arch/$(ARCH)/Makefile包含架构相关的kbuild设置选项。所以arch/$(ARCH)/Makefile需要设置几个变量和定义几个目标。

当kbuild运行时，遵循下面几个步骤（大概）：

配置内核=>生成.config文件
将内核版本号存放在include/linux/version.h文件中。
更新全部其他先决条件为目标做准备,其他先决条件在arch/$(ARCH)/Makefile文件中指定
递归进入所有列为init-* core* drivers-* net-* libs-*的目录编译所有目标。上述变量的值在arch/$(ARCH)/Makefile文件中被扩展
所有目标文件被链接，最终生成文件vmlinux放在源码根目录下。被列为head-y的目标第一个被链接，它是由arch/$(ARCH)/Makefile文件指定
最后架构相关的部分做任何必要的后期处理并最终生成bootimage文件。这包括建立引导记录,准备initrd映像文件等等。
}

doc(设置变量来配合编译此架构)
{

LDFLAGS –通用$(LD)选项，此标志用于所有调用连接器的地方。

#arch/s390/Makefile
LDFLAGS         := -m elf_s390
注意: ldflags-y可以用于进一步的制定，这个标志的使用见3.7章。

LDFLAGS_MODULE –$(LD)链接模块时的选项 
LDFLAGS_MODULE用于当$(LD)链接.ko模块文件时，默认选项是-r重定位输出。

LDFLAGS_vmlinux –$(LD)链接vmlinux时的选项

LDFLAGS_vmlinux指定其他选项传递给连接器链接最终的vmlinux映像，是LDFLAGS_$@的一个特例。

#arch/i386/Makefile
LDFLAGS_vmlinux := -e stext
OBJCOPYFLAGS –objcopy选项

当$(call if_changed,objcopy)用于反汇编.o文件时OBJCOPYFLAGS指定的选项会被使用。$(call if_changed,objcopy)经常用来生成vmlinux的原始二进制文件。

#arch/s390/Makefile
OBJCOPYFLAGS := -O binary

#arch/s390/boot/Makefile
$(obj)/image: vmlinux FORCE
	$(call if_changed,objcopy)
在这个例子中$(obj)/image文件是vmlinux的二进制版本。$(call if_changed,xxx)的用法将在后面说明。

KBUILD_AFLAGS –$(AS)汇编器选项

默认值见顶层Makefile文件可以针对每一种架构进行扩展或者修改例如:

#arch/sparc64/Makefile
KBUILD_AFLAGS += -m64 -mcpu=ultrasparc
KBUILD_CFLAGS –$(CC)编译器选项

默认值见顶层Makefile文件，可以针对每一种架构进行扩展或者修改，通常KBUILD_CFLAGS的值依赖于配置。例如:

#arch/i386/Makefile
cflags-$(CONFIG_M386) += -march=i386
KBUILD_CFLAGS += $(cflags-y)
很多架构Makefiles文件动态运行目标编译器来测试所支持的选项：

#arch/i386/Makefile
...
cflags-$(CONFIG_MPENTIUMII)     += $(call cc-option,\
				-march=pentium2,-march=i686)
...
# Disable unit-at-a-time mode ...
KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time)
...
第一个例子利用当配置选项被选择时展开为y这个技巧。
}

doc(List directories to visit when descending)
{

一个架构Makefile配合顶层Makefile定义变量来指定怎样编译vmlinux文件。注意模块和架构没有联系，所有模块编译都是架构无关的。

head-y, init-y, core-y, libs-y, drivers-y, net-y

$(head-y)列出最先链接到vmlinux的目标
$(libs-y)列出lib.a库文件放置的目录 
剩下的变量列出built-in.o目标文件放置的目录

$(init-y)目标会放在$(head-y)后面,剩下的以这种顺序排列： 
$(core-y), $(libs-y), $(drivers-y)和$(net-y).

顶层Makefile定义所有普通目录的值，arch/$(ARCH)/Makefile只添加架构相关的目录例如:

#arch/sparc64/Makefile
core-y += arch/sparc64/kernel/
libs-y += arch/sparc64/prom/ arch/sparc64/lib/
drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
}

}


clean_mrproper(清除)
{
	内核初始化 make distclean. make mrproper
	---------------------------------------------------------------------
    
    clean:删除大部分产生的文件，但是，依然能够编译外部模块。
    mrproper:删除所有产生的文件和配置文件
    distclean :恢复系统到最原始的状态，出了mrproper外，还会删除备份patch，cscope，tag等
}

kconfig(配置)
{
内核配置   kconfig
           make menuconfig. make gconfig. make xconfig #启动Kconfig，以不同界面来配置内核。
---------------------------------------------------------------------
		   在script/kconfig/Makefile中可以查询到xconfig、menconfig、gconfig对象；各对象会执行与之对应的二进制文件。
		   arch/$(ARCH)/configs目录，就会发现与各个SoC相符的自定义配置文件。
		   make s2c6400_defconfig 
		   
		   .config 只是构建自身内核所需的内核配置目录。 kconfig配置方式
		   y 相应的二进制文件与vmlinux连接
		   m 作为模块执行编译
		  
		   mconf通过.config配置文件生成autoconf.h头文件。可通过script/kconfig/confdata.c的conf_write_autoconf()函数得知autoconf.h的生成过程。
		   .config配置文件和include/linux/autoconf.h配置是一样。
		   .config 不仅参与文件单位的链接，还决定是否以源代码为单位执行包含。
		   内核利用以.config文件为背景生成的autoconf.h，在预处理阶段决定是否包含#ifdef语句。
		   
		   利用kconfig完成内核配置，并准备好具有自身内核配置的.config文件后，即可构建内核。

--------------------------------- [Kconfig] ------------------------------------		   
Kconfig 对应的是内核配置阶段，如你使用命令：make menuconfig，就是在使用Kconfig系统。Kconfig由以下三部分组成：

     scripts/kconfig/*					Kconfig文件解析程序
     kconfig  							各个内核源代码目录中的kconfig文件
     arch/$(ARCH)/configs/*_defconfig	各个平台的缺省配置文件
	 
当Kconfig系统生成.config后，Kbuild 会依据.config编译指定的目标。

--------------------------------- [run] ------------------------------------
scripts/kconfig/*          kconfig解析程序
kconfig                    各个内核源代码目录中配置文件
arch/$(ARCH)/defconfig     arch缺省配置文件	 

}


kbuild(构建)
{
内核构建   kbuild
           make all. make zImage. make modules
---------------------------------------------------------------------


--------------------------------- [Kbuild] ------------------------------------	
Kbuild 是内核Makefile体系重点，对应内核编译阶段，由5个部分组成：

	 顶层Makefile				根据不同的平台，对各类target分类并调用相应的规则Makefile生成目标
	 .config					内核配置文件
	 arch/$(ARCH)/Makefile		具体平台相关的Makefile
	 scripts/Makefile.*			通用规则文件，面向所有的Kbuild Makefiles，所起的作用可以从后缀名中得知。
	 各子目录下的Makefile 文件	由其上层目录的Makefile调用，执行其上层传递下来的命令

--------------------------------- [scripts] ------------------------------------
而其中scripts目录下的编译规则文件和其目录下的C程序在整个编译过程起着重要的作用。列举如下：

    Kbuild.include		共用的定义文件，被许多独立的Makefile.*规则文件和顶层Makefile包含
    Makefile.build		提供编译built-in.o, lib.a等的规则
    Makefile.lib		负责归类分析obj-y、obj-m和其中的目录subdir-ym所使用的规则
    Makefile.host		本机编译工具（hostprog-y）的编译规则
    Makefile.clean		内核源码目录清理规则
    Makefile.headerinst	内核头文件安装时使用的规则
    Makefile.modinst	内核模块安装规则
    Makefile.modpost	模块编译的第二阶段,由.o和.mod生成.ko时使用的规则	 
顶层Makefile 主要是负责完成vmlinux(内核文件)与*.ko(内核模块文件) 的编译。顶层 Makefile 读取.config 文件，并根据.config 
文件确定访问哪些子目录，并通过递归向下访问子目录的形式完成。顶层Makefile同时根据.config 文件原封不动的包含一个具体架构
的Makefile，其名字类似于 arch/$(ARCH)/Makefile。该架构Makefile 向顶层Makefile 提供其架构的特别信息。

每一个子目录都有一个Makefile 文件，用来执行从其上层目录传递下来的命令。子目录的 Makefile 也从.config 文件中提取信息，
生成内核编译所需的文件列表。
}
	 
	 
install(安装)
{
    内核安装   make install, make modules_install
    ---------------------------------------------------------------------
}	 
	 
run(make过程)
{
[include $(srctree)/scripts/Kbuild.include]
Makefile.include 定义了用于构建内核的共同变量或各种脚本。
Makefile中多数共同变量和各种脚本可以在Kbuild.include内找到。也可见于script目录内的文件

[include $(srctree)/arch/$(SRCARCH)/Makefile]
包含了各结构的Makefile。Makefile在以后构建内核的过程中负责对从属结构部分执行编译。

[arch/arm/Makefile] -> [arch/arm/boot/Makefile] -> [arch/arm/boot/compressed/Makefile]
设置KBUILD_IMAGE := zImage

cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@ <script/Makefile.lib>
对内核编译生成的$(obj)/compressed/vmlinux执行objcopy命令，生成已清除多余符号的二进制镜像。

[arch/arm/boot/compressed/Makefile]
用gzip压缩已清除符号的vmlinux文件，从而生成pigg.gz，并利用各从属结构的连接器脚本($(obj)/vmlinux.lds)执行链接。
}

create(vmlinux->bzImage)
{
    当kbuild运行时，遵循下面几个步骤（大概）：

    1. 配置内核=>生成.config文件
    2. 将内核版本号存放在include/linux/version.h文件中。
    3. 更新全部其他先决条件为目标做准备,其他先决条件在arch/$(ARCH)/Makefile文件中指定
    4. 递归进入所有列为init-* core* drivers-* net-* libs-*的目录编译所有目标。上述变量的值在arch/$(ARCH)/Makefile文件中被扩展
    5. 所有目标文件被链接，最终生成文件vmlinux放在源码根目录下。被列为head-y的目标第一个被链接，它是由arch/$(ARCH)/Makefile文件指定
    6. 最后架构相关的部分做任何必要的后期处理并最终生成bootimage文件。这包括建立引导记录,准备initrd映像文件等等。


	顶层Makefile 主要是负责完成vmlinux(内核文件)与*.ko(内核模块文件) 的编译。
	顶层 Makefile 读取.config 文件，并根据.config 文件确定访问哪些子目录，并通过递归向下访问子目录的形式完成。
	顶层Makefile同时根据.config 文件原封不动的包含一个具体架构的Makefile，其名字类似于 arch/$(ARCH)/Makefile。
	    该架构Makefile 向顶层Makefile 提供其架构的特别信息。

    每一个子目录都有一个Makefile 文件，用来执行从其上层目录传递下来的命令。
	子目录的 Makefile 也从.config 文件中提取信息，生成内核编译所需的文件列表。
	
        1. 是把内核的源代码编译成.o文件，然后链接，这一步，链接的是arch/i386/kernel/head.S，生成的是vmlinux。
    注意的是这里的所有变量地址都是32位页寻址方式的保护模式下的虚拟地址。通常在3G以上。
        2. 将vmlinux objcopy 成arch/i386/boot/compressed/vmlinux.bin，之后加以压缩，最后作为数据编译成
    piggy.o。这时候，在编译器看来，piggy.o里根本不存在什么startup_32。
        3. 把head.o,misc.o和piggy.o链接生成arch/i386/boot/compressed/vmlinux，这一步，链接的是
    arch/i386/boot/compressed/head.S。这时arch/i386/kernel/head.S中的startup_32被
    压缩，作为一段普通的数据，而被编译器忽视了。注意这里的地址都是32位段寻址方式的
    保护模式下的线性地址。
    
    
	1.先生成vmlinux.这是一个elf可执行文件
	2.然后objcopy成arch/i386/boot/compressed/vmlinux.bin，去掉了原elf文件中的一些无用的section等信息。
	3.gzip后压缩为arch/i386/boot/compressed/vmlinux.bin.gz
	4.把压缩文件作为数据段链接成arch/i386/boot/compressed/piggy.o
	5.链接：arch/i386/boot/compressed/vmlinux = head.o+misc.o+piggy.o其中head.o和misc.o是用来解压缩的。
	6.objcopy成arch/i386/boot/vmlinux.bin，去掉了原elf文件中的一些无用的section等信息。
	7.用arch/i386/boot/tools/build.c工具拼接bzImage = bootsect+setup+vmlinux.bin过程好复杂。
}

make_script(run)
{
config %config: scripts_basic outputmakefile FORCE
       $(Q)mkdir -p include/linux include/config
       $(Q)$(MAKE) $(build)=scripts/kconfig $@
调用的原因是我们指定的目标"menuconfig"匹配了"%config"。
她的依赖目标是scripts_basic 和outputmakefile，以及FORCE。也就是说在完成了这3个依赖目标后，
下面的两个命令才会执行以完成我们指定的目标"menuconfig"。

make_script(scripts_basic)
{
scripts_basic:
       $(Q)$(MAKE) $(build)=scripts/basic
他没有依赖目标，所以直接执行了以下的指令，只要将指令展开，我们就知道make做了什么操作。其中比较不好展开的是$(build)，
她的定义在scripts/Kbuild.include中： 

build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
所以展开后是：
make -f scripts/Makefile.build obj= scripts/basic

也就是make 解析执行scripts/Makefile.build文件，且参数obj= scripts/basic。而在解析执行scripts/Makefile.build文件的时候，
scripts/Makefile.build又会通过解析传入参数来包含对应文件夹下的Makefile文件（scripts/basic/Makefile），从中获得需要
编译的目标。

make_script(Makefile_host)
{
在确定这个目标以后，通过目标的类别来继续包含一些scripts/Makefile.*文件。例如scripts/basic/Makefile中内容如下：
hostprogs-y := fixdep docproc hash
always      := $(hostprogs-y)
# fixdep is needed to compile other host programs
$(addprefix $(obj)/,$(filter-out fixdep,$(always))): $(obj)/fixdep

所以scripts/Makefile.build会包含scripts/Makefile.host。相应的语句如下：

# Do not include host rules unless needed

ifneq ($(hostprogs-y)$(hostprogs-m),)
include scripts/Makefile.host
endif
}

此外scripts/Makefile.build会包含include scripts/Makefile.lib等必须的规则定义文件，在这些文件的共同作用下完成对
scripts/basic/Makefile中指定的程序编译。

由于Makefile.build的解析执行牵涉了多个Makefile.*文件，过程较为复杂，碍于篇幅无法一条一条指令的分析，兴趣的读者可以
自行分析。
}
make_script(outputmakefile)
{
make程序会调用规则：
PHONY += outputmakefile
# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.

outputmakefile:
ifneq ($(KBUILD_SRC),)
    $(Q)ln -fsn $(srctree) source
    $(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
        $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

从这里我们可以看出：outputmakefile是当KBUILD_SRC 不为空(指定O=dir，编译输出目录和源代码目录分开)时，在输出目录建立
Makefile时才执行命令的，
如果我们在源码根目录下执行make menuconfig命令时，这个目标是空的，什么都不做。
如果我们指定了O=dir时，就会执行源码目录下的scripts/mkmakefile，用于在指定的目录下产生一个Makefile，并可以在指定的
目录下开始编译。
}

make_script(FORCE)
{
FORCE
这是一个在内核Makefile中随处可见的伪目标，她的定义在顶层Makefile的最后：
PHONY += FORCE
FORCE:

 
是个完全的空目标，但是为什么要定义一个这样的空目标，并让许多目标将其作为依赖目标呢？原因如下：
正因为FORCE 是一个没有命令或者依赖目标，不可能生成相应文件的伪目标。当make执行此规则时，总会认为FORCE不存在，
必须完成这个目标，所以她是一个强制目标。也就是说：规则一旦被执行，make 就认为它的目标已经被执行并更新过了。
当她作为一个规则的依赖时，由于依赖总被认为被更新过的，因此作为依赖所在的规则中定义的命令总会被执行。
所以可以这么说：只要执行依赖包含FORCE的目标，其目标下的命令必被执行。

在make完成了以上3个目标之后，就开始执行下面的命令的，首先是
    $(Q)mkdir -p include/linux include/config
    这个很好理解，就是建立两个必须的文件夹。然后
    $(Q)$(MAKE) $(build)=scripts/kconfig $@
    这和我们上面分析的$(Q)$(MAKE) $(build)=结构相同，将其展开得到：
    make -f scripts/Makefile.build obj=scripts/kconfig menuconfig
    所以这个指令的效果是使make 解析执行scripts/Makefile.build文件，且参数obj=scripts/kconfig menuconfig。
    这样Makefile.build会包含对应文件夹下的Makefile文件（scripts/kconfig /Makefile），并完成scripts/kconfig/Makefile
    下的目标：
    menuconfig: $(obj)/mconf
            $< $(Kconfig)

这个目标的依赖条件是$(obj)/mconf，通过分析可知她其实是对应以下规则：
mconf-objs  := mconf.o zconf.tab.o $(lxdialog)
……
ifeq ($(MAKECMDGOALS),menuconfig)
    hostprogs-y += mconf
endif

也就是编译生成本机使用的mconf程序。完成依赖目标后，通过scripts/kconfig/Makefile中对Kconfig的定义可知，最后执行：
mconf arch/$(SRCARCH)/Kconfig
而对于conf和xconf等都有类似的过程，所以总结起来：当make %config 时，内核根目录的顶层Makefile会临时编译出
scripts/kconfig 中的工具程序conf/mconf/qconf 等负责对arch/$(SRCARCH)/Kconfig 文件进行解析。这个Kconfig 
又通过source标记调用各个目录下的Kconfig文件构建出一个Kconfig树，使得工具程序构建出整个内核的配置界面。
在配置结束后，工具程序就会生成我们常见的.config文件。

}

}

module(添加到内核)
{
比如你已经写好了一个针对TI 的AM33XX芯片的 LED的驱动程序，名为am33xx_led.c。
（1）       将驱动源码am33xx_led.c等文件复制到linux-X.Y.Z/drivers/char目录。
（2）       在该目录下的Kconfig文件中添加LED驱动的配置选项：
config AM33XX_LED
       bool "Support for am33xx led drivers"
       depends on  SOC_OMAPAM33XX
       default n
       ---help---
          Say Y here if you want to support for AM33XX LED drivers.
（3）     在该目录下的Makefile文件中添加对LED驱动的编译：
obj-$(CONFIG_AM33XX_LED)   +=  am33xx_led.o
这样你就可以在make menuconfig的时候看到这个配置选项，并进行配置了。
当然，上面的例子只是一个意思，对于Kconfig文件和Makefile的详细语法，请参考内核文档：
Documentation/kbuild/makefile.txt

}

		   