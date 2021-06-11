out()
{
1、 《Linux系统移植》：一个经典的Linux移植文档，共有95页的PDF文档，内容十分详细，里面有根文件系统的创建，还多地方都有下载（有的网站称之为《Linux系统全线移植文档》等等），很值得参考。在这里感谢文档的作者们。

2、 《构建嵌入式Linux系统》必看！里面对文件系统的构建讲的挺细。

3、 《Filesystem Hierarchy Standard》Linux文件系统的标准规范。我只看到英文的。

http://www.jinbuguo.com/lfs/lfs62/index.html
}

create(创建根文件系统的基本目录结构。)
{

我把这个过程做成了shell脚本(文件名为mkroot) ，很方便！ 

#! /bin/sh
    echo "creatint rootfs dir......"
    mkdir rootfs
    cd rootfs

    echo "making dir : bin dev etc lib proc sbin sys usr"
    mkdir bin dev etc lib proc sbin sys usr #必备的8个目录
    mkdir usr/bin usr/lib usr/sbin lib/modules


# Don't use mknod ,unless you run this Script as root !
# mknod -m 600 dev/console c 5 1
# mknod -m 666 dev/null c 1 3

 

    echo "making dir : mnt tmp var"
    mkdir mnt tmp var
    chmod 1777 tmp
    mkdir mnt/etc mnt/jffs2 mnt/yaffs mnt/data mnt/temp
    mkdir var/lib var/lock var/log var/run var/tmp 
    chmod 1777 var/tmp

 

    echo "making dir : home root boot"
    mkdir home root boot

    echo "done"

在你想要建立根文件系统的地方，运行：
[tekkamanninja@Tekkaman-Ninja nfs]$ ./mkroot
creatint rootfs dir......
making dir : bin dev etc lib proc sbin sys usr
making dir : mnt tmp var
making dir : home root boot
done
[tekkamanninja@Tekkaman-Ninja nfs]$ cd rootfs/dev/
[tekkamanninja@Tekkaman-Ninja dev]$ su
口令：
[root@Tekkaman-Ninja dev]# mknod -m 600 console c 5 1;mknod -m 666 null c 1 3;exit
exit
[tekkamanninja@Tekkaman-Ninja dev]$
}

create(配置、编译和安装Busybox-1.9.1)
{
[tekkamanninja@Tekkaman-Ninja source]$ tar -xjvf busybox-1.9.1.tar.bz2

修改Makefile文件：
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ pwd
/home/tekkamanninja/working/source/busybox-1.9.1
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ kwrite Makefile


......(第151-154行)
#SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
#                 -e s/arm.*/arm/ -e s/sa110/arm/ \
#                 -e s/s390x/s390/ -e s/parisc64/parisc/ \
#                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/ )
......(第174行附近)
#ARCH        ?= $(SUBARCH)
#CROSS_COMPILE    ?=
ARCH         = arm
CROSS_COMPILE = /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ make menuconfig


>>> 在原有的基础上修改如下：
Busybox Settings --->
      Installation Options --->
           [*] Do not use /usr
           (/home/tekkamanninja/working/nfs/rootfs) BusyBox installation prefix
        Busybox Library Tuning  --->
           [*] Support for /etc/networks
           [*]   Additional editing keys     
           [*]   vi-style line editing commands   
           (15)  History size  
           [*]   History saving  
           [*]   Tab completion 
           [*]     Username completion  
           [*]   Fancy shell prompts

Login/Password Management Utilities  --->选项全部N掉，后面单独使用TinyLogin。（因为集成的好像不是很好用，我自己的经验是这样）
Linux Module Utilities  ---> 
      [N] Support version 2.2.x to 2.4.x Linux kernels
Shells  --->
      ---   Ash Shell Options 下的选项全选

      
      make
      make install
      
>>> 我是动态编译所以查看一下需要的动态库
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d busybox

Dynamic section at offset 0xac014 contains 22 entries:
  Tag Type Name/Value
 0x00000001 (NEEDED) Shared library: [libcrypt.so.1]
 0x00000001 (NEEDED) Shared library: [libm.so.6]
 0x00000001 (NEEDED) Shared library: [libc.so.6]
 
}

create(修改和创建必要的文件)
{
$ cp -a examples/bootfloppy/etc/* /home/tekkamanninja/working/nfs/rootfs/etc/

$ cd ../../nfs/rootfs/etc/


create(增加为SHELL导入全局变量的文件/etc/profile)
{
    # /etc/profile: system-wide .profile file for the Bourne shells
    echo
    
    echo "Processing /etc/profile... "
    # no-op
    
    
    # Set search library path
    echo "Set search library path in /etc/profile"
    export LD_LIBRARY_PATH=/lib:/usr/lib 
    
    # Set user path
    echo "Set user path in /etc/profile"
    PATH=/bin:/sbin:/usr/bin:/usr/sbin
    export PATH 
    
    # Set PS1
    #注意：ash 除了SHELL变量外，支持\u、\h、\W、\$、\!、\n、\w 、\nnn（ASCII字符对应的八进制数）
    #以及\e[xx;xxm (彩色特效)等等！
    #而且前面还要多加一个 '\'！
    
    echo "Set PS1 in /etc/profile"
    
    export PS1="\\e[05;32m[$USER@\\w\\a]\\$\\e[00;34m"
    
    echo "Done"
    
    echo
}

create(增加初始化文件)
{
### inittab
::sysinit:/etc/init.d/rcS
::respawn:-/bin/login
::restart:/sbin/init

::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
::shutdown:/sbin/swapoff -a

### fstab
proc /proc proc defaults 0 0
none /tmp ramfs defaults 0 0
mdev /dev ramfs defaults 0 0
sysfs /sys sysfs defaults 0 0

}

create(增加初始化脚本)
{
### init.d/rcS

#! /bin/sh
echo "----------mount all"
/bin/mount -a


echo "----------Starting mdev......"
/bin/echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s


echo "*********************************************************"
echo " Tekkaman Ninja 2440 Rootfs(nfs) 2008.2 "
echo " Love Linux ! ! @@ Love Ke Ke ! ! "
echo "********************************************************"
}

create(删除备份文件)
[tekkamanninja@Tekkaman-Ninja etc]$ rm *~ init.d/*~

create(为mdev创建配置文件)
[tekkamanninja@Tekkaman-Ninja etc]$ vi mdev.conf

创建一个mdev.conf文件，内容可有可无。
}


create(为使用用户登录功能移植TinyLogin)
{
为使用用户登录功能移植TinyLogin
1、下载
从http://tinylogin.busybox.net/ 下载tinylogin-snapshot.tar.bz2，并解压.
[tekkamanninja@Tekkaman-Ninja source]$ tar -xjvf tinylogin-snapshot.tar.bz2

 

2、修改tinyLogin的Makefile
[tekkamanninja@Tekkaman-Ninja source]$ cd tinylogin
[tekkamanninja@Tekkaman-Ninja tinylogin]$ kwrite Makefile

指明tinyLogin使用自己的算法来处理用户密码

USE_SYSTEM_PWD_GRP = false
......
CROSS =/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-
CC = $(CROSS)gcc
AR = $(CROSS)ar
STRIPTOOL = $(CROSS)strip

3、 编译并安装 

[tekkamanninja@Tekkaman-Ninja tinylogin]$ make PREFIX=/home/tekkamanninja/working/nfs/rootfs install

[root@Tekkaman-Ninja tinylogin]# make PREFIX=/home/tekkamanninja/working/nfs/rootfs install

[root@Tekkaman-Ninja tinylogin]# exit

}

我是动态编译所以查看一下需要的动态库

[tekkamanninja@Tekkaman-Ninja tinylogin]$ /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d tinylogin

创建创建帐号及密码文件:

[tekkamanninja@Tekkaman-Ninja tinylogin]$ cd ../../nfs/rootfs/etc/
[tekkamanninja@Tekkaman-Ninja etc]$ su
口令：
[root@Tekkaman-Ninja etc]# cp /etc/passwd . ;cp /etc/shadow . ;cp /etc/group .
[root@Tekkaman-Ninja etc]# kwrite passwd
root:x:0:0:root:/root:/bin/sh
[root@Tekkaman-Ninja etc]# kwrite group

root:x:0:root
[root@Tekkaman-Ninja etc]# kwrite shadow
root:$1$N8K8eEQe$.XkJo3xcsjOE6vo1jW9Nk/:13923:0:99999:7:::

拷贝必需的动态库文件

[tekkamanninja@Tekkaman-Ninja lib]$ cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/ld* .
cp: 略过目录 "/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/ldscripts"
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libc-2.3.2.so .;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libc.so.6 .
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libm-* . ;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libm.s* .
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libcrypt-* . ;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libcrypt.s* .
