
获得当前运行kernel的配置信息的文件：
a）/proc/config.gz （CONFIG_IKCONFIG_PROC需要置成Y）
b）/boot/config
c）/boot/config-$(uname -r)

config(make menuconfig)
{
General setup-->
<*> Kernel .config support（对应CONFIG_IKCONFIG）
[*] Enable access to .config through /proc/config.gz（对应CONFIG_IKCONFIG_PROC）
}

run(compile kernel)
{
(1)如果配置了CONFIG_IKCONFIG就要生产 configs.o 文件

(2) configs.o 文件依赖 $(obj)/config_data.h文件，隐含的生成条件是通过configs.c文件编译生成。而在configs.c文件中包含了$(obj)/config_data.h文件。

(3) $(obj)/config_data.h文件的生成依赖$(obj)/config_data.gz，并强制每次编译都重新生成$(obj)/config_data.h文件（FORCE）。这个文件的生成规则是（5）

(4)$(obj)/config_data.gz文件的生成依赖$(KCONFIG_CONFIG)（也就是内核配置文件.config），并强制每次编译都重新生成$(obj)/config_data.gz（FORCE）。这个文件的生成是通过将.config执行gzip压缩生成的。

(5)这里其实就是执行一个shell指令，将$(obj)/config_data.gz文件中的数据通过内核工具程序scripts/bin2c放入一个名为“kernel_config_data”的字符数组中，并以MAGIC_START（宏："IKCFG_ST"）开头，MAGIC_END（宏： "IKCFG_ED"）结尾。
}



get(from kernel)
{
1、在运行时通过/proc/config.gz获取：
     在控制台输入命令：cat /proc/config.gz | gzip -d > （你要保存配置的文件名）
     这个方法简单，但是也有他的局限性，首先必须配置CONFIG_IKCONFIG_PROC，其次必须在系统运行时进行获取。

2、可以直接通过编译好的内核映像：vmlinux、zImage、uImage等直接获取
     这个方法其实也非常简单，内核黑客们已经帮我们做好了提取工具了：scripts/extract-ikconfig。使用起来超简单：
     （如果是交叉编译，那就在宿主机）输入如下命令：（内核源码路径）scripts/extract-ikconfig （内核映像路径） > （你要保存配置的文件名）
     这个工具对于gz压缩方式是支持一贯不错，从2.6.37开始支持bzip2、 lzma 和 lzo压缩方式，从2.6.39开始支持 xz压缩方式。这些从内核的git log中可以看出。          

3、从内核逻辑地址空间提取：
     从上面的的生成介绍中我们可以知道，配置文件的压缩文件其实就在内核映像的只读数据段中。如果内核在运行的时候，其实数据在内核逻辑地址空间中可以找到。方法概况如下：
     （1）通过/proc/kallsyms找到“kernel_config_data”这个符号对应的内核逻辑地址
     （2）通过/dev/kmem和上面得到的逻辑地址获取数据。压缩文件数据就在："IKCFG_ST"与"IKCFG_ED"之间。
      这个步骤需要自己写一小段的C代码，可以参考devkmem的代码（《对于驱动调试有用的两个小工具（devmem2、devkmem）》）
      
}