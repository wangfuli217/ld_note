flash.layout # https://wiki.openwrt.org/doc/techref/flash.layout

OverlayFS(){
    overlayfs是目前使用比较广泛的层次文件系统，实现简单，性能较好. 
可以充分利用不同或则相同overlay文件系统的page cache，具有
    上下合并
    同名遮盖
    写时拷贝
lsmod  | grep over # modprobe overlay
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/overlayfs.txt
root/Documentation/filesystems/overlayfs.txt
https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt
}
tmpfs(根据文件存储量动态变化){
http://lxr.free-electrons.com/source/Documentation/filesystems/tmpfs.txt
mount tmpfs /mnt/tmpfs -t tmpfs              # 不限制大小
mount tmpfs /dev/shm -t tmpfs -o size=32m    #   限制大小32m
mount -t tmpfs -o size=10G,nr_inodes=10k,mode=700 tmpfs /mytmpfs   # 更多配置
/dev/shm uses tmpfs
/tmp

}

SquashFS(只读压缩文件系统){
http://lxr.free-electrons.com/source/Documentation/filesystems/squashfs.txt
https://www.ibm.com/developerworks/cn/linux/1306_qinzl_squashfs/
    mksquashfs:创建 Squash 压缩文件系统
使用 Squash 压缩文件系统构所使用的主要命令：
    mknod:创建 Squash 压缩文件系统
    losetup:设置并控制 Loop 设备
    chroot:改变根目录
    dmsetup:低水平逻辑卷管理
}

jffs2(闪存日志型文件系统第2版){
    管理在MTD设备上实现的日志型文件系统。与其他的存储设备存储方案相比，JFFS2并不准备提供让
传统文件系统也可以使用此类设备的转换层。它只会直接在MTD设备上实现日志结构的文件系统。
JFFS2会在安装的时候，扫描MTD设备的日志内容，并在RAM中重新建立文件系统结构本身。
}

UBIFS(无序区块镜像文件系统){
    用于固态存储设备上，并与LogFS相互竞争，作为JFFS2的后继文件系统之一。
    专门为了解决MTD（Memory Technology Device）设备所遇到的瓶颈。由于Nand Flash容量的暴涨，
YAFFS等皆无法操控大的Nand Flash空间。UBIFS通过子系统UBI处理与MTD device之间的动作。与JFFS2
一样，UBIFS 建构于MTD device 之上，因而与一般的block device不兼容。
    UBIFS在设计与性能上均较YAFFS2、JFFS2更适合MLC NAND FLASH。
}

ext2(){
Ext2/3/4 is used on x86, x86-64 and for some arch with SD-card rootfs
}

mini_fo(老版本openwrt，被overlayfs替代){}

openwrt(SquashFS JFFS2->overlayfs){
1. 内核从一个没有文件系统的分区中启动，扫描mtd的rootfs，获得SquashFS，然后执行 /etc/preinit.
2. /etc/preinit 运行/sbin/mount_root
3. mount_root 加载 JFFS2分区，与SquashFS 分区一起构建一个虚拟的根文件系统。
4. /sbin/init 
}

mtd(mtd是字符设备，mtdblock是块设备){
cd /tmp 
wget http://www.example.org/original_firmware.bin 
mtd -r write /tmp/original_firmware.bin firmware  # 
mtd -r write linux.trx linux                      # 


Usage: mtd [<options> ...] <command> [<arguments> ...] <device>[:<device>...]
unlock <dev>            unlock the device
refresh <dev>           refresh mtd partition
erase <dev>             erase all data on device
write <imagefile>|-     write <imagefile> (use - for stdin) to device
jffs2write <file>       append <file> to the jffs2 partition on the device
fixtrx <dev>            fix the checksum in a trx header on first boot

/dev/mtd/* 或者 /dev/mtd* 这两种表示方式一般表示的是字符设备
/dev/mtdblock/* 或者 /dev/mtdblock* 这两种是块设备的表示方式
mount 的一般都是块设备貌似dd只对字符设备进行操作
}

mtd(使用mtd和sysupgrade刷机、备份恢复系统配置){
cat /proc/mtd  
dev:    size   erasesize  name  
mtd0: 00020000 00020000 "CFE"  
mtd1: 000dff00 00020000 "kernel"  
mtd2: 00ee0000 00020000 "rootfs"  
mtd3: 00840000 00020000 "rootfs_data"  
mtd4: 00020000 00020000 "nvram"  
mtd5: 00fc0000 00020000 "linux" 

第一层包括 mtd1-u-boot, mtd2-firmware, mtd3-nvram, mtd4-art。其中uboot的第二层包括u-boot和u-boot-env 。 
而firmware的第二层又包括kernel 和rootfs。 
rootfs的第三层又包括 rootfs和rootfs_data两个分区， 
其中原始的rootfs的文件系统是只读文件系统SquashFS， 而rootfs_data是可写文件系统JFFS2。
在第二层和第三层之间，OpenWRT采用了Overlay技术的overlayfs文件系统，
将原始rootfs和rootfs_data合并成一个逻辑分区，挂载在/，对于系统可见的就这个逻辑的分区。
而真实的原始rootfs是挂载在/rom下，rootfs_data挂载在/overlay下，

备份系统CFE：
dd if=/dev/mtd0 of=/mnt/cfe.bin

备份恢复Openwrt系统配置：
#备份自定义系统信息，包括新安装软件
dd if=/dev/mtd3 of=/mnt/overlay.bin
#恢复备份设置
mtd -r write /mnt/overlay.bin rootfs_data
#仅备份系统配置
sysupgrade -b /mnt/back.tar.gz
#恢复系统配置
sysupgrade -f /mnt/back.tar.gz


恢复Openwrt系统默认设置：
#删除/overlay分区所有文件，重启即恢复默认设置
rm -rf /overlay/* && reboot
#使用mtd清除/overlay分区信息后重启即恢复默认设置
mtd -r erase rootfs_data


刷新系统：
#使用mtd更新系统
mtd -r write openwrt.bin linux
#使用sysupgrade更新系统，推荐。
sysupgrade openwrt.bin

}

sysupgrade(){
sysupgrade [<升级选项>...] 
sysupgrade [-q] [-i] <备份选项>
----
升级选项：
----
-d 重启前等待 delay 秒
-f 从 .tar.gz (文件或链接) 中恢复配置文件
-i 交互模式
-c 保留 /etc 中所有修改过的文件
-n 重刷固件时不保留配置文件
-T | --test 校验固件 config .tar.gz，但不真正烧写
-F | --force 即使固件校验失败也强制烧写
-q 较少的输出信息
-v 详细的输出信息
-h 显示帮助信息

----
备份选项：
----
-b | --create-backup 
把sysupgrade.conf 里描述的文件打包成.tar.gz 作为备份，不做烧写动作
-r | --restore-backup 
从-b 命令创建的 .tar.gz 文件里恢复配置，不做烧写动作
-l | --list-backup
列出 -b 命令将备份的文件列表，但不创建备份文件

#　更新openwrt.bin固件
sysupgrade openwrt.bin

#　强制更新openwrt.bin固件
sysupgrade会检查支持板子的固件头信息，如果一个model没有在sysupgrade的支持列表里，使用-F来忽略检查失败，强制烧写。
sysupgrade -F openwrt.bin

#　更新后不保存之前的配置
sysupgrade烧写时默认会备份配置文件，在烧写后把配置文件覆盖到新系统中。-n参数指定不做这个动作。
sysupgrade -n openwrt.bin

#　备份配置文件到/tmp/backup.tgz　/etc/目录下的文件
sysupgrade -b /tmp/backup.tgz

#　恢复之前备份的/tmp/backup.tgz  /etc/目录下的文件
sysupgrade -r /tmp/backup.tgz

#　列出会被备份的文件             /etc/目录下被备份的文件
sysupgrade -l
列出的文件会在-b备份时或系统升级时被保存。


rootfs_type = "overlayfs" ，执行第一个逻辑
run_ramfs, 在/tmp/root下安装一个临时ramdisk，最后再执行do_upgrade
do_upgrade -> platform_do_upgrade -> get_image "$1" | mtd -j "$CONF_TAR" write - "firmware"
mtd工具在写入时，会把$CONF_TAR文件整合进入jffs2分区，可以看到打印信息：
----
Appending jffs2 data from /tmp/sysupgrade.tgz to firmware...
----
}

fstab(){
https://wiki.openwrt.org/doc/uci/fstab
config 'mount'
	option 'device' '/dev/sda1'
	option 'options' 'rw,sync'
	option 'enabled_fsck' '0'
	option 'enabled' '1'
	option 'target' '/mnt/share'
}

USB(https://wiki.openwrt.org/doc/howto/usb.storage){
kmod-usb-storage
kmod-fs-<file_system>
     kmod-fs-ext4
     kmod-fs-hfs
     kmod-fs-hfsplus
     kmod-fs-msdos, 
     kmod-fs-ntfs, 
     kmod-fs-reiserfs 
     kmod-fs-xfs
kmod-usb-storage-extras #  SmartMedia card readers
block-mount             #  
kmod-scsi-core          #  

opkg install e2fsprogs  # ext2/ext3/ext4 filesystems like mkfs.ext3, mkfs.ext4, fsck 

-------------------------------------------------------------------------------ext4
opkg update
opkg install kmod-usb-storage kmod-fs-ext4
opkg install block-mount
mkswap /dev/sda1
swapon /dev/sda1
mkdir -p /mnt/share
mount -t ext4 /dev/sda2 /mnt/share -o rw,sync
mount /dev/sda2 /mnt/share
------------------------------------------------------------------------------- fat
opkg update
opkg install kmod-usb-storage kmod-fs-ext4 kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1
mkdir -p /mnt/usb
mount -t vfat /dev/sda1 /mnt/usb

}

https://en.code-bude.net/2013/02/16/how-to-increase-storage-on-tp-link-wr703n-with-extroot/
extroot(利用block-extroot，让你的openwrt运行在USB设备上){
#更新包列表
opkg update
#添加USB驱动支持
opkg install kmod-usb-storage kmod-usb-ohci kmod-usb2 kmod-usb-uhci
#添加从USB启动的工具软件
opkg install block-mount block-hotplug block-extroot
#添加EXT3文件系统支持
opkg install kmod-fs-ext3
#添加EXT4文件系统支持
opkg kmod-fs-ext4
#挂载根目录到/tmp/cproot
mkdir -p /tmp/cproot
mount --bind / /tmp/cproot
#挂载sda1到/mnt
mount /dev/sda1 /mnt
#复制flash所有文件到usb
tar -C /tmp/cproot -cvf - . | tar -C /mnt -xf -
#卸载/根目录
umount /tmp/cproot

vi /etc/config/fstab
#old
option target /home
option enabled 0
 
#new
option target /
option enabled 1

reboot
}
