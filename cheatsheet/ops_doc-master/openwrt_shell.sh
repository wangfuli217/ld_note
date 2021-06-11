opkg list -> files
    /usr/lib/opkg/info/        # 安装opkg包路径
    包括内核模块的control和list，动态库的control和list，以及应用程序和工具的control和list
    ----------------  应用程序版本，依赖，源代码，版权，所在节，维护者，架构，安装大小和简要描述，以及包含哪些可执行和配置文件
    应用程序的control Version Depends Source License Section Maintainer Architecture Installed-Size Description
    应用程序的list    该opkg中包含那些文件
    应用程序的conffiles 配置文件
    
kernel
    /lib/modules/3.18.20/      # 内核模块路径
    /etc/modules.d/            # 内核安装模块的配置信息

/lib/upgrade/keep.d/ (sysupgrade - add_uci_conffiles)
    系统升级的时候，需要保存的文件 # 还包括opkg list-changed-conffiles指定的文件
    base-files            ppp
    base-files-essential  uhttpd

/overlay 和 /overlay/upper (sysupgrade - add_overlayfiles)
    用于存储修改过的配置文件

/lib/upgrade (sysupgrade - 升级过程中需要的脚本文件)
/tmp/sysupgrade.tgz        压缩输出文件
/tmp/sysupgrade.conffiles  压缩配置文件
    
-------     挂载点         分区类型         挂载说明
/           overlayfs                                                ls /
            /rom        只读类型文件系统    通常为rootfs分区         ls /rom
            /overlay    可写类型文件系统    通常为rootfs_data分区    ls /overlay/upper
    
jsonfilter # 对json字符串进行解析，获得对应内容，该命令见于脚本/lib/functions/network.sh 脚本各个函数中。
-i file   从文件输入   # 指定输入源
-s source 字符串       # 指定输入源
-e value  值
-t type   类型
-F separator           # 指定分隔符
-l limit
-q fclose(stderr)

mount_root        # 在/tmp/overlay下创建overlay文件系统，再把此文件系统迁移到/overlay目录下
                  # 具体例子见：openwrt_overlayfs.txt文档
                  # 见/lib/functions/preinit.sh
link -> https://www.brobwind.com/archives/419
    第一次开机时进入failsafe模式时，/dev/mtd3前4个字节为0xde 0xad 0xc0 0xde：
    root@(none):/# hexdump -n 16 -v -e '16/1 "%02x ""\n"' /dev/mtd3
    de ad c0 de ff ff ff ff ff ff ff ff ff ff ff ff
    
    而执行mount_root时，会使用tmpfs做overlay:
    root@(none):/# mount_root
    [   89.120000] mount_root: jffs2 not ready yet, using temporary tmpfs overlay

    第一开机时如果不进入failsafe模式，最开始也会使用tmpfs做overlay, 之后会去格式化/dev/mtdblock3成JFFS2文件系统，
    再使用这个分区做overlay (在执行/etc/rc.d/S90done时做的？):
    
    往/dev/mtd?设备中写数据(在failsafe模式下操作)：
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtd3 19 85 20 03 00 00 00 0c 
        root@(none):/# echo -e '\xde\xad\xc0\xde' | dd of=/dev/mtd3 bs=1 count=4 co 
        nv=notrunc 4+0 
        records in 4+0 
        records out 
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtd3 
        de ad c0 de 00 00 00 0c
    再看看这个，往/dev/mtdblock?设备中写入数据(在failsafe模式下操作)：
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtdblock3
        19 85 20 03 00 00 00 0c
        root@(none):/# echo -e '\xde\xad\xc0\xde' | dd of=/dev/mtdblock3 bs=1 count=4 co
        nv=notrunc
        4+0 records in
        4+0 records out
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtdblock3
        de ad c0 de 00 00 00 0c
    往/dev/mtdblock3中写入0xdeadc0de之后，再去挂载会怎样：
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtdblock3
        de ad c0 de 00 00 00 0c
        root@(none):/# mount -t jffs2 /dev/mtdblock3 /overlay/
        [  624.440000] jffs2_scan_eraseblock(): End of filesystem marker found at 0x0
        [  624.450000] jffs2_build_filesystem(): unlocking the mtd device... done.
        [  624.460000] jffs2_build_filesystem(): erasing all blocks after the end marker... done.
        [  660.390000] jffs2: notice: (372) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
        root@(none):/# hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtdblock3
        19 85 20 03 00 00 00 0c
# OpenWrt中说这叫trick (https://wiki.openwrt.org/doc/techref/filesystems), 由kernel来完成JFFS2文件系统的格式化。
    在挂载了/dev/mtdblock3后，做jffs2reset会怎样（只是去删除文件）
    root@(none):/# touch /overlay/abc
    root@(none):/# ls -l /overlay/
    -rw-r--r--    1 root     root             0 Jan  1 00:24 abc
    root@(none):/# jffs2reset -y
    [ 1470.580000] jffs2reset: /dev/mtdblock3 is mounted as /overlay, only erasing files
    root@(none):/# ls -l /overlay/
    root@(none):/#
    
mount_root ram    # pivot_root,移动根文件系统到/tmp/root
mount_root stop   # 环境变量SHUTDOWN的值，未设置和设置为0，返回-1
mount_root done   # 0x4f575254 FS_SNAPSHOT      mount_snapshot(data);
                  # 0xdeadc0de FS_DEADCODE      ramoverlay();          系统在preinit过程中，文件系统没有准备好，使用tmpfs
                  # 0x1985     FS_JFFS2         mount_overlay(data);   加载overlayfs
                  # 0xffffffff FS_JFFS2         mount_overlay(data);   加载overlayfs
                  # FS_NONE                     ramoverlay();          使用ramfs

                  # hexdump -n 16 -v -e '16/1 "%02x ""\n"' /dev/mtd3   用来分析上面的内容。
                  # hexdump -s 0x00 -n 8 -v -e '8/1 "%02x ""\n"' /dev/mtdblock3
jffs2reset # jffs2reset 是fstools里的工具。做的工作有：
    在/proc/mtd里找到名为"rootfs_data"的分区, 假如找到的是mtd5，则/dev/mtd5就是该块设备的节点。
    在/proc/mounts里找到/dev/mtd5的挂载点。
    如果该设备已挂载(假设挂载在/overlay)，则遍历该目录，删除所有的文件和目录。unlink
    如果设备没挂载，则擦除该设备。mtd.c: ioctl(p->fd, MEMERASE, &eiu)
    jffs2reset -y
    
pivot_root: 改变root文件系统 # pivot_root为系统调用
    用法：pivot_root new_root put_old
    描述：pivot_root把当前进程的root文件系统放到put_old目录，而使new_root成为新的root文件系统。
    从127.0.0.1:/home/qianjiang/nfsroot挂载新的文件系统并且运行init
    a. 拷贝sh,ls至nfsroot/bin，以及相关的共享库至nfsroot/lib
    b. 在nfsroot下面建立目录old_root
    c. mount -o ro 127.0.0.1:/home/qianjiang/nfsroot /mnt
    d. cd /mnt
    e. pivot_root . old_root
    这个时候，会发现比如"ls /"显示的是nfsroot下面的文件；"ls old_root"显示的是之前文件系统root下面的文件。
chroot vs pivot_root
    pivot_root和chroot的主要区别是，pivot_root主要是把整个系统切换到一个新的root目录，而移除对之前root文件系统
    的依赖，这样你就能够umount原先的root文件系统。而chroot是针对某个进程，而系统的其它部分依旧运行于老的root目录。

man 8 pivot_root
    Change the root file system to /dev/hda1 from an interactive shell:
    mount /dev/hda1 /new-root
    cd /new-root
    pivot_root . old-root
    exec chroot . sh <dev/console >dev/console 2>&1
    umount /old-root
    
    Mount the new root file system over NFS from 10.0.0.1:/my_root and run init:
    
    ifconfig lo 127.0.0.1 up   # for portmap
    # configure Ethernet or such
    portmap   # for lockd (implicitly started by mount)
    mount -o ro 10.0.0.1:/my_root /mnt
    killall portmap   # portmap keeps old root busy
    cd /mnt
    pivot_root . old_root
    exec chroot . sh -c ’umount /old_root; exec /sbin/init’ \
         <dev/console >dev/console 2>&1
   
# /lib/functions/led.sh  当前路由器很多功能不支持， 
# 很多选项不支持，不进行进一步测试。回来测试一下youren 3G路由器板。

mount tmpfs /mnt/tmpfs -t tmpfs # tmpfs没有意义，

mtd 和 硬盘RAM差异
    1. 硬盘RAM可以rewritable，mtd必须先erase，然后rewritable。 被称为erase-blocks
    2. 硬盘RAM可以rewritable次数基本没限制，mtd的rewritable重写次数有限制。

    3. 分区表（target/linux/ramips/dts/MPRA2.dts）
    
reload_config # /var/run/config.md5
    一般配置文件文件改变是通过MD5值来判断的，/sbin/reload_config,内容如下
    #!/bin/sh
    MD5FILE=/var/run/config.md5
    [ -f $MD5FILE ] && {
        for c in `md5sum -c $MD5FILE 2>/dev/null| grep FAILED | cut -d: -f1`; do
        ubus call service event "{ \"type\": \"config.change\", \"data\": { \"package\": \"$(basename $c)\" }}"
        done
    }
    md5sum /etc/config/* > $MD5FILE
就是调用procd注册的service event事件， 例如网页修改配置后，会通过rpcd调用/sbin/reload_config

patch-dtb
    dts的概念是linux kernel中的，跟openwrt的关系不大。只是恰好在学习openwrt的时候碰到了这个东西，所以记录在openwrt名下。
    patch-dtb
    openwrt对arch/mips/kernel/head.S文件打了补丁，在其中加入了以下几行：
        .ascii  "OWRTDTB:"
        EXPORT(__image_dtb)
        .fill   0x4000
        __REF
    在代码中预留了16KB的空间用于存放dtb数据，以"OWRTDTB:"为标志。
    patch-dtb源码位于openwrt/tools/patch-image/src/patch-dtb.c，执行命令为：patch-dtb vmlinux-mt7620a MT7620A.dtb
    patch-dtb在vmlinux的前16KB空间中中查找"OWRTDTB:"字符串，找到之后，把预留的16KB空间清0, 并把dtb数据复制到该处。
    parse in kernel
    start_kernel()
    -> setup_arch()
        -> arch_mem_init()
            -> plat_mem_setup()
            -> __dt_setup_arch(&__image_dtb);
                -> early_init_dt_scan()
            -> device_tree_init()
    initial_boot_params = __image_dtb;
    __image_dtb 定义于arch/mips/kernel/head.S中，是dtb区域的起始地址。


http://www.cnblogs.com/lagujw/p/4226424.html
    
    
http://so.csdn.net/so/search/s.do?q=openwrt&t=blog
    
http://blog.csdn.net/cy_cai/article/details/40649201 # 内核

https://github.com/openosom/openosom.github.io/tree/master/md/wiki
https://github.com/YingkitTse/zlevoclient_openwrt/tree/trunk/wiki
https://github.com/bluecliff/wifi-cat/wiki/OpenWRT%E7%BC%96%E8%AF%91%E8%BF%9B%E9%98%B6