manul(linux是如何组成的)
{
答：linux是由用户空间和内核空间组成的
为什么要划分用户空间和内核空间？
答：有关CPU体系结构，各处理器可以有多种模式，而LInux这样的划分是考虑到系统的
安全性，比如X86可以有4种模式RING0~RING3  RING0特权模式给LINUX内核空间RING3给用户空间
linux内核是如何组成的？
答：linux内核由SCI（System Call Interface）系统调用接口、PM（Process Management）进程管理、MM（Memory Management）内存管理、Arch、
VFS（Virtual File Systerm）虚拟文件系统、NS（Network Stack）网络协议栈、DD（Device Drivers） 设备驱动

}

manul(linux 内核源代码)
{
linux内核源代码是如何组成或目录结构？
答：   arc目录    存放一些与CPU体系结构相关的代码  其中第个CPU子目录以分解boot,mm,kerner等子目录
block目录    部分块设备驱动代码
crypto目录    加密、压缩、CRC校验算法
documentation    内核文档
drivers        设备驱动
fs        存放各种文件系统的实现代码
include        内核所需要的头文件。与平台无关的头文件入在include/linux子目录下，与平台相关的头文件则放在相应的子目录中
init        内核初始化代码
ipc        进程间通信的实现代码
kernel        Linux大多数关键的核心功能者是在这个目录实现（程序调度，进程控制，模块化）
lib        库文件代码
mm        与平台无关的内存管理，与平台相关的放在相应的arch/CPU目录    net        各种网络协议的实现代码，注意而不是驱动
samples     内核编程的范例
scripts        配置内核的脚本
security    SElinux的模块
sound        音频设备的驱动程序
usr        cpip命令实现程序
virt        内核虚拟机
}

manul(内核配置与编译)
{

一、清除
make clean    删除编译文件但保留配置文件
make mrproper    删除所有编译文件和配置文件
make distclean    删除编译文件、配置文件包括backup备份和patch补丁 
二、内核配置方式
make config    基于文本模式的交互式配置
make menuconfig    基于文本模式的菜单配置
make oldconfig    使用已有的配置文件（.config）,但配置时会询问新增的配置选项
make xconfig    图形化配置

三、make menuconfig一些说明或技巧
在括号中按“y”表示编译进内核，按“m”编译为模块，按“n”不选择，也可以按空格键进行选择
注意：内核编译时，编译进内核的“y”，和编译成模块的“m”是分步编译的

四、快速配置相应体系结构的内核配置
我们可以    到arch/$cpu/configs目录下copy相应的处理器型号的配置文件到内核源目录下替换.config文件

五、编译内核
1.
————————————————————————————
make zImage   注：zImage只能编译小于512k的内核
make bzImage
同样我们也可以编译时获取编译信息，可使用
make zImage V=1
make bzImage V=1
编译好的内核位于    arch/$cpu/boot/目录下
————————————————————————————


以上是编译内核make menuconfig时先“m”选项的编译  接下来到编译“y”模块，也就是编译模块
2.
make modules    编译内核模块
make modules_install    安装内核模块 ------>这个选项作用是将编译好的内核模块从内核源代码目录copy至/lib/modules下

六、制作init ramdisk
mkinitrd initrd-$version $version
/****  mkinitrd initrd-$(可改)version $version(不可改，因为这version是寻找/lib/modules/下相应的目录来制作)  ****/

七、内核安装
复制内核到相关目录下再作grub引导也就可以了
1.cp arch/$cpu/boot/bzImage /boot/vmlinux-$version
2.cp $initrd /boot/
3.修改引导器/etc/grub.conf(lio.conf)正确引导即可

}

manul(hello)
{
#incldue <linux/init.h>
#include <linux/module.h>

static int hello_init(void)
{
printk(KERN_WARNING"Hello,world!\n");
return 0;
}

static void hello_exit(void)
{
printk(KERN_INFO"Good,world!\n");
}

module_init(hello_init);
module_exit(hello_exit);

___________hello,world!范例___________________
一、必需模块函数
1.加载函数    module_init(hello_init);    通过module_init宏来指定
2.卸载函数    module_exit(hello_exit);    通过module_exit宏来指定

编译模块多使用makefile

二、可选模块函数
1.MODULE_LICENSE("*******");     许可证申明
2.MODULE_AUTHOR("********");    作者申明
3.MODELE_DESCRIPTION("***");    模块描述
4.MODULE_VERSION("V1.0");    模块版本
5.MODULE_ALIAS("*********");    模块别名
6.MODULE_DEVICE_TABLE 告诉用户空间，模块所支持的设备

三、模块参数
通过宏module_param指定模块参数，模块参数用于在加载模块时传递参数模块
module_param(neme,type,perm);
name是模块参数名称
type是参数类型  type常见值：boot、int、charp(字符串型)
perm是参数访问权限 perm常见值：S_IRUGO、S_IWUSR
S_IRUGO:任何用户都对sys/module中出现的参数具有读权限
S_IWUSR:允许root用户修改/sys/module中出现的参数
/*****——————范例————————*******/
int a = 3;
char *st;
module_param(a,int,S_IRUGO);
module_param(st,charp,S_IRUGO);

/*********————结束——————**********/

/**********----makefile范例----*************/

ifneq    ($(KERNELRELFASE),)

obj-m    :=    hello.o    //这里m值多用 obj-(CONFIG_**)代替

else

KDIR    :=    /lib/modules/$version/build
all:
make -C $(KDIR) M=$(PWD) modules
clean:
rm -f *.ko *.o *.mod.o *.mod.c *.symyers
endif

/*****这里可以扩展多文件makefile 多个obj-m***********end***************/


/******模块参数*****/
#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("GPL");

static char *name = "Junroc Jinx";
static int age = 30;

module_param(arg,int,S_IRUGO);
module_param(name,charp,S_IRUGO);

static int hello init(void)
{
printk(KERN_EMERG"Name:%s\n",name);
printk(KERN_EMERG"Age:%d\n",age);
return 0;
}

static void hello_exit(void)
{
printk(KERN_INFA"Module Exit\n");
}

moduleJ_init(hello_init);
module_exit(hello_exit);
/****************/


----------------------------------------------------------------------------
}

manual(kallsyms)
{
/proc/kallsyms 文档记录了内核中所有导出的符号的名字与地址
什么是导出？
答：导出就是把模块依赖的符号导进内核，以便供给其它模块调用
为什么导出？
答：不导出依赖关系就解决不了，导入就失败

符号导出使用说明：
EXPORT_SYMBOL(符号名)
EXPORT_SYMBOL_GPL(符号名)
其中EXPORT_SYMBOL_GPL只能用于包含GPL许可证的模块

system.map包含kernel image的符号表。/proc/kallsyms则包含kernel image和所有动态加载模块的符号表。
如果一个函数被编译器内联（inline）或者优化掉了，则它在/proc/kallsyms有可能找不到。


模块版本不匹配问题的解决：
1、使用 modprobe --force-modversion    强行插入
2、确保编译内核模块时，所依赖的内核代码版本等同于当前正在运行的内核   uname -r
----------------------------------------------------------------------
printk内核打印：
printk允许根据严重程度，通过附加不同的“优先级”来对消息分类
在<linux/kernel.h>定义了8种记录级别。按照优先级递减分别是：
KERN_EMERG    "<0>"    用于紧急消息，常常崩溃前的消息
KERN_ALERT    "<1>"    需要立刻行动的消息
KERN_CRIT    "<2>"    严重情况
KERN_ERR    "<3>"    错误情况
KERN_WARNING    "<4>"    有问题的警告
KERN_NOTICE    "<5>"    正常情况，但是仍然值得注意
KERN_INFO    "<6>"    信息型消息
KERN_DEBUG    "<7>"    用于调试消息

没有指定优先级的printk默认使用
DEFAULT_MESSAGE_LOGLEVEL优先级    它是一个在kernel/printk.c中定义的整数

控制优先级的配置：
/proc/sys/kernel/printk(可以查看或修改)

/*******符号symbol各模块依赖范例*****/
}

manual(hello.c)
{
--------/********hello.c*********/----
#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Junroc Jinx");
MODULE_DESCRIPTION("hello,world module! ");
MODULE_ALIAS("A simple modle test");

extern int add_integar(int a,int b);
extern int sub_integar(int a,int b);

static int __init hello_init()
{
int res = add_integar(1,2);
return 0;
}

static void __exit hello_exit()
{
int res = sub_integar(2,1);
}

module_init(hello_init);
module_exit(hello_exit);

/******hello.c****end**********/

/********start*****calculate.c******/
#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");

int add_integar(int a,int b)
{
return a+b;
}

int sub_integar(int a,int b)
{
return a-b;
}

static int __init sym_init()
{
return 0;
}
static void __exit sym_exit()
{

}

module_init(sym_init);
module_exit(sym_exit);

//EXPORT_SYMBOL(add_integar);
//EXPORT_SYMBOL(sub_integar);

/***********end*****calculte.c****/
}

manual(初始化和关闭)
{
初始化和关闭(清除)可以使用__init 和 __exit标记。
标记过的函数将被放到特殊的ELF段。被标记__exit的函数只能在模块被卸载或系统关闭时被调用，其他任何用法都是错误的。
如果一个模块未定义清除函数，则内核不允许卸载该模块。
错误情况下的goto的仔细使用可避免大量复杂的、高度缩进的“结构化”逻辑。内核经常使用goto来处理错误。
}
