out()
{
1�� ��Linuxϵͳ��ֲ����һ�������Linux��ֲ�ĵ�������95ҳ��PDF�ĵ�������ʮ����ϸ�������и��ļ�ϵͳ�Ĵ���������ط��������أ��е���վ��֮Ϊ��Linuxϵͳȫ����ֲ�ĵ����ȵȣ�����ֵ�òο����������л�ĵ��������ǡ�

2�� ������Ƕ��ʽLinuxϵͳ���ؿ���������ļ�ϵͳ�Ĺ�������ͦϸ��

3�� ��Filesystem Hierarchy Standard��Linux�ļ�ϵͳ�ı�׼�淶����ֻ����Ӣ�ĵġ�

http://www.jinbuguo.com/lfs/lfs62/index.html
}

create(�������ļ�ϵͳ�Ļ���Ŀ¼�ṹ��)
{

�Ұ��������������shell�ű�(�ļ���Ϊmkroot) ���ܷ��㣡 

#! /bin/sh
    echo "creatint rootfs dir......"
    mkdir rootfs
    cd rootfs

    echo "making dir : bin dev etc lib proc sbin sys usr"
    mkdir bin dev etc lib proc sbin sys usr #�ر���8��Ŀ¼
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

������Ҫ�������ļ�ϵͳ�ĵط������У�
[tekkamanninja@Tekkaman-Ninja nfs]$ ./mkroot
creatint rootfs dir......
making dir : bin dev etc lib proc sbin sys usr
making dir : mnt tmp var
making dir : home root boot
done
[tekkamanninja@Tekkaman-Ninja nfs]$ cd rootfs/dev/
[tekkamanninja@Tekkaman-Ninja dev]$ su
���
[root@Tekkaman-Ninja dev]# mknod -m 600 console c 5 1;mknod -m 666 null c 1 3;exit
exit
[tekkamanninja@Tekkaman-Ninja dev]$
}

create(���á�����Ͱ�װBusybox-1.9.1)
{
[tekkamanninja@Tekkaman-Ninja source]$ tar -xjvf busybox-1.9.1.tar.bz2

�޸�Makefile�ļ���
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ pwd
/home/tekkamanninja/working/source/busybox-1.9.1
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ kwrite Makefile


......(��151-154��)
#SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
#                 -e s/arm.*/arm/ -e s/sa110/arm/ \
#                 -e s/s390x/s390/ -e s/parisc64/parisc/ \
#                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/ )
......(��174�и���)
#ARCH        ?= $(SUBARCH)
#CROSS_COMPILE    ?=
ARCH         = arm
CROSS_COMPILE = /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ make menuconfig


>>> ��ԭ�еĻ������޸����£�
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

Login/Password Management Utilities  --->ѡ��ȫ��N�������浥��ʹ��TinyLogin������Ϊ���ɵĺ����Ǻܺ��ã����Լ��ľ�����������
Linux Module Utilities  ---> 
      [N] Support version 2.2.x to 2.4.x Linux kernels
Shells  --->
      ---   Ash Shell Options �µ�ѡ��ȫѡ

      
      make
      make install
      
>>> ���Ƕ�̬�������Բ鿴һ����Ҫ�Ķ�̬��
[tekkamanninja@Tekkaman-Ninja busybox-1.9.1]$ /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d busybox

Dynamic section at offset 0xac014 contains 22 entries:
  Tag Type Name/Value
 0x00000001 (NEEDED) Shared library: [libcrypt.so.1]
 0x00000001 (NEEDED) Shared library: [libm.so.6]
 0x00000001 (NEEDED) Shared library: [libc.so.6]
 
}

create(�޸ĺʹ�����Ҫ���ļ�)
{
$ cp -a examples/bootfloppy/etc/* /home/tekkamanninja/working/nfs/rootfs/etc/

$ cd ../../nfs/rootfs/etc/


create(����ΪSHELL����ȫ�ֱ������ļ�/etc/profile)
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
    #ע�⣺ash ����SHELL�����⣬֧��\u��\h��\W��\$��\!��\n��\w ��\nnn��ASCII�ַ���Ӧ�İ˽�������
    #�Լ�\e[xx;xxm (��ɫ��Ч)�ȵȣ�
    #����ǰ�滹Ҫ���һ�� '\'��
    
    echo "Set PS1 in /etc/profile"
    
    export PS1="\\e[05;32m[$USER@\\w\\a]\\$\\e[00;34m"
    
    echo "Done"
    
    echo
}

create(���ӳ�ʼ���ļ�)
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

create(���ӳ�ʼ���ű�)
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

create(ɾ�������ļ�)
[tekkamanninja@Tekkaman-Ninja etc]$ rm *~ init.d/*~

create(Ϊmdev���������ļ�)
[tekkamanninja@Tekkaman-Ninja etc]$ vi mdev.conf

����һ��mdev.conf�ļ������ݿ��п��ޡ�
}


create(Ϊʹ���û���¼������ֲTinyLogin)
{
Ϊʹ���û���¼������ֲTinyLogin
1������
��http://tinylogin.busybox.net/ ����tinylogin-snapshot.tar.bz2������ѹ.
[tekkamanninja@Tekkaman-Ninja source]$ tar -xjvf tinylogin-snapshot.tar.bz2

 

2���޸�tinyLogin��Makefile
[tekkamanninja@Tekkaman-Ninja source]$ cd tinylogin
[tekkamanninja@Tekkaman-Ninja tinylogin]$ kwrite Makefile

ָ��tinyLoginʹ���Լ����㷨�������û�����

USE_SYSTEM_PWD_GRP = false
......
CROSS =/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-
CC = $(CROSS)gcc
AR = $(CROSS)ar
STRIPTOOL = $(CROSS)strip

3�� ���벢��װ 

[tekkamanninja@Tekkaman-Ninja tinylogin]$ make PREFIX=/home/tekkamanninja/working/nfs/rootfs install

[root@Tekkaman-Ninja tinylogin]# make PREFIX=/home/tekkamanninja/working/nfs/rootfs install

[root@Tekkaman-Ninja tinylogin]# exit

}

���Ƕ�̬�������Բ鿴һ����Ҫ�Ķ�̬��

[tekkamanninja@Tekkaman-Ninja tinylogin]$ /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d tinylogin

���������ʺż������ļ�:

[tekkamanninja@Tekkaman-Ninja tinylogin]$ cd ../../nfs/rootfs/etc/
[tekkamanninja@Tekkaman-Ninja etc]$ su
���
[root@Tekkaman-Ninja etc]# cp /etc/passwd . ;cp /etc/shadow . ;cp /etc/group .
[root@Tekkaman-Ninja etc]# kwrite passwd
root:x:0:0:root:/root:/bin/sh
[root@Tekkaman-Ninja etc]# kwrite group

root:x:0:root
[root@Tekkaman-Ninja etc]# kwrite shadow
root:$1$N8K8eEQe$.XkJo3xcsjOE6vo1jW9Nk/:13923:0:99999:7:::

��������Ķ�̬���ļ�

[tekkamanninja@Tekkaman-Ninja lib]$ cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/ld* .
cp: �Թ�Ŀ¼ "/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/ldscripts"
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libc-2.3.2.so .;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libc.so.6 .
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libm-* . ;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libm.s* .
[tekkamanninja@Tekkaman-Ninja lib]$ cp /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libcrypt-* . ;cp -d /home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/arm-9tdmi-linux-gnu/lib/libcrypt.s* .
