------ hello.c ------
(1) moudle.h 包含了大量加载模块需要的函数和符号的定义.
(2) init.h 来指定你的初始化和清理函数
(3) MODULE_LICENSE("GPL");指定代码使用哪个许可
       内核认识的特定许可有, 
            "GPL"( 适用 GNU 通用公共许可的任何版本 ), 
            "GPL v2"( 只适用 GPL 版本 2 ), 
            "GPL and additional rights", 
            "Dual BSD/GPL", 
            "Dual MPL/GPL", 
            "Proprietary".
(4) 除此之外还可以包含模块的其他描述性定义
      MODULE_AUTHOR ( 声明谁编写了模块 ), 
      MODULE_DESCRIPION( 一个人可读的关于模块做什么的声明 ), 
      MODULE_VERSION ( 一个代码修订版本号)，
      MODULE_ALIAS ( 模块为人所知的另一个名子 ), 
      MODULE_DEVICE_TABLE ( 来告知用户空间, 模块支持那些设备).
(5) static int hello_init(void)
         初始化函数应当声明成静态的，
      static void hello_exit(void) 
           清理函数, 它注销接口, 在模块被去除之前返回所有资源给系统
(6) module_init(hello_init);
       这个宏定义增加了特别的段到模块目标代码中, 表明在哪里找到模块的初始化函数. 没有这个定义, 你的初始化函数不会被调用.
       module_exit(hello_exit);
(7)printk
        在 Linux 内核中定义并且对模块可用; 它与标准 C 库函数 printf 的行为相似. 内核需要它自己的打印函数, 因为它靠自己运行
(8)字串 KERN_ALERT 是消息的优先级，因为使用缺省优先级的消息可能不会在任何有用的地方显示

------ makefile ------
(1)obj-m := hello.o
        表明有一个模块要从目标文件 hello.o 建立. 在从目标文件建立后结果模块命名为 hello.ko。

(2)KERNELDR := /usr/src/linux-2.6.26
        用来定位内核源码目录

(3)PWD := $(shell pwd)
       获得当前目录路径

(4)M=$(PWD) M= 选项
        使 makefile 在试图建立模块目标前, 回到你的模块源码目录

(5)$(MAKE) -C $(KERNELDR) M=$(PWD) modules
        这个命令开始是改变它的目录到用 -C 选项提供的目录下( 就是说, 你的内核源码目录 ). 它在那里会发现内核的顶层 makefile. 这个 M= 选项使 makefile 在试图建立模块目标前, 回到你的模块源码目录. 这个目标, 依次地, 是指在 obj-m 变量中发现的模块列表, 在我们的例子里设成了 module.o.
(
6)$(MAKE) -C $(KERNELDR) M=$(PWD) modules_install
        用于模块的安装

(7）rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions
    用于make clean清除上次编译生成的文件

------ insmod rmmod lsmod vermagic.o ------
1. insmod
     加载模块的代码段和数据段到内核，并且调用模块的初始化函数来启动所有东西.
2. rmmod
     如果内核认为模块还在用( 就是说, 一个程序仍然有一个打开文件对应模块输出的设备 ), 或者内核被配置成不允许模块去除, 模块去除会失败.
3. lsmod 
    生成一个内核中当前加载的模块的列表. lsmod 通过读取 /proc/modules 虚拟文件工作. 当前加载的模块的信息也可在位于 /sys/module 的 sysfs 虚拟文件系统找到.

4. 前面的屏幕输出是来自一个字符控制台; 如果你从一个终端模拟器或者在窗口系统中运行 insmod 和 rmmod, 你不会在你的屏幕上看到任何东西. 消息进入了其中一个系统日志文件中, 例如 /var/log/messages (实际文件名子随 Linux 发布而变化).
5. vermagic.o目标文件：
    当加载一个模块时，内核为模块检查特定处理器的配置选项，确定它们匹配运行的内核。如果模块用不同选项编译，则不会加载。出现下面内容：