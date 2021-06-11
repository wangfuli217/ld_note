Linux 内核引导参数简介
内核文档 Documentation/kernel-parameters.txt

param(概述){
    内核引导参数大体上可以分为两类：一类与设备无关，另一类与设备有关。与设备有关的引导参数多如牛毛，
需要阅读内核中的相应驱动程序源码以获取其能够接受的引导参数。
    大多数参数是通过”__setup(... , ...)“函数设置的，少部分是通过”early_param(... , ...)“函数设置的，
逗号前的部分就是引导参数的名称，后面的部分就是处理这些参数的函数名。
grep -r '\b__setup *(' *
grep -r '\bearly_param *(' *

正确：ether=9,0x300,0xd0000,0xd4000,eth0  root=/dev/sda2
错误：ether = 9, 0x300, 0xd0000, 0xd4000, eth0  root = /dev/sda2

在内核运行起来之后，可以通过 cat /proc/cmdline 命令查看当初使用的引导参数以及相应的值。
}

param(内核模块){
    对于模块而言，引导参数只能用于直接编译到核心中的模块，格式是”模块名.参数=值“，比如
”usbcore.blinkenlights=1“。动态加载的模块则可以在modprobe 命令行上指定相应的参数值，
比如”modprobe usbcore blinkenlights=1“。

    可以使用”modinfo -p ${modulename}“命令显示可加载模块的所有可用参数。已经加载到内核中的
模块会在/sys/module/${modulename}/parameters/中显示出其参数，并且某些参数的值还可以在运行时
通过”echo -n ${value} > /sys/module/${modulename}/parameters/${parm}“进行修改。

}

param(内核如何处理引导参数){
绝大部分的内核引导参数的格式如下(每个参数的值列表中最多只能有十项)：
name[=value_1][,value_2]...[,value_10]

    如果”name“不能被识别并且满足”name=value“的格式，那么将被解译为一个环境变量(比如”TERM=linux“
或”BOOT_IMAGE=vmlinuz.bak“)，否则将被原封不动的传递给init程序(比如”single”)。

    内核可以接受的参数个数没有限制，但是整个命令行的总长度(参数/值/空格全部包含在内)却是有限制的，
定义在 include/asm/setup.h 中的 COMMAND_LINE_SIZE 宏中(对于X86_64而言是2048)。
}