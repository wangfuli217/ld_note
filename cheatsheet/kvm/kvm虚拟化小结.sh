kvm(KVM虚拟机动态增加网卡){
[root@KVM  ~]#virsh attach-interface 361way --type bridge --source cloudbr0
[root@KVM  ~]#virsh domiflist 361way  查看vnet6为新增的网卡
Interface  Type       Source     Model       MAC
-------------------------------------------------------
vnet2      bridge     br2        virtio      52:54:00:06:12:f4
vnet6      bridge     br1        -           52:54:00:8d:d4:df
361way为我guest主机名
    以上命令修改即时生效，但不会改动虚拟机XML文件，即重启机器后，新增的网卡还会消失。
如果想要保存，可以通过导出xml文件 ，并编辑原xml文件为新文件的内容就OK 了。
virsh dumpxml 361way >new361.xml

[root@ipvs01 network-scripts]# cp ifcfg-eth0 ifcfg-eth1
[root@ipvs01 network-scripts]# vim ifcfg-eth1
DEVICE="eth1" #改为eth1
BOOTPROTO="static"
#HWADDR="52:54:00:06:12:f4" #mac注释掉或者改为上面domiflist中的值
IPADDR="192.168.122.45"  #修改为新IP
IPV6INIT="yes"
MTU="1500"
NETMASK="255.255.255.0"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"

-------------------------------------------------------------------------------

virsh domiflist domain # 列出虚拟机的所有网口  

virsh domif-setlink domain vnet0 down  # 关闭某个网口
virsh domif-setlink domain vnet0 up    # 打开某个网口
virsh domif-getlink domain vnet1       # 获取某个网口状态
virsh autostart domain                 # 设置虚拟机自启动

# man virsh /attach-interface; man qemu /Network options
attach-interface domain-id type source [--target target] [--mac mac] [--script script] [--model model] [--persistent]
       [--inbound average,peak,burst] [--outbound average,peak,burst]
       
virsh attach-interface domain --type bridge --source br1 --model virtio  # 下次启动生效
virsh attach-interface domain --type bridge --source br1 --model virtio  # 立即生效
virsh detach-interface domain --type bridge --mac 52:54:10:f5:c5:6c      # 下次启动生效
virsh detach-interface domain --type bridge --mac 52:54:10:f5:c5:6c      # 立即生效
}

kvm(KVM虚拟机动态增加硬盘){
要添加的LV卷/dev/vg01/lv_add01
[root@KVM  ~]#virsh attach-disk 361way /dev/vg01/lv_add01 vdc
virsh dumpxml 361way  >kvm_361way.xml 

同样，ISO文件也可以disk的方式增加：
[root@KVM qemu]# virsh attach-disk 361way /root/tasks/win2003.iso vdd
Disk attached successfully
即时生效，成功后到361way中查看
[root@KVM_ipvs01 ~]# mount /dev/vdd /mnt/
[root@KVM_ipvs01 ~]# cd /mnt/
[root@KVM_ipvs01 mnt]# ll
total 3520
-r-xr-xr-x 1 root root     112 Mar  7  2007 autorun.inf
-r-xr-xr-x 1 root root  322730 Mar  7  2007 bootfont.bin
dr-xr-xr-x 1 root root  267478 Mar  7  2007 i386
dr-xr-xr-x 1 root root     184 Mar  7  2007 printers

virsh domblklist domain  # 列出所有的块设备
}

kvm(raw磁盘镜像的挂载:offset偏移计算法){
该方法的思路为找出分区开始的开始位置，使用mount命令的offset参数偏移掉前面不需要的，即可得到真正的分区。
其具体步骤如下：
1. 用"fdisk -lu my.img"查询image信息；
---------------------------------------
[root@localhost file]# fdisk -lu /file/centos.img
You must set cylinders.
You can do this from the extra functions menu.
Disk /file/centos.img: 0 MB, 0 bytes
255 heads, 63 sectors/track, 0 cylinders, total 0 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0001905c
           Device Boot      Start         End      Blocks   Id  System
/file/centos.img1   *        2048     1026047      512000   83  Linux
Partition 1 does not end on cylinder boundary.
/file/centos.img2         1026048    62914559    30944256   8e  Linux LVM
Partition 2 has different physical/logical endings:
     phys=(1023, 254, 63) logical=(3916, 63, 51)
从上面不难看出，centos.img文件有两个分区。

2. 计算image内分区开始的地方（计算offset），用从N号sector（扇区）开始，则offset=N*M 
（M为一个sector的大小，一般为512）
---------------------------------------
[root@localhost file]# echo $((2048*512))
1048576
[root@localhost file]#  echo $((1026048*512))
525336576
[root@localhost file]# 
这两个值是上面fdisk 查看的分区start的位置 。

3. 使用mount命令挂载为loop设备
---------------------------------------
[root@localhost file]# mount -o loop,offset=1048576 centos.img  /mnt/
[root@localhost file]# ls /mnt/
config-2.6.32-279.el6.x86_64  efi  grub  initramfs-2.6.32-279.el6.x86_64.img  lost+found  symvers-2.6.32-279.el6.x86_64.gz  System.map-2.6.32-279.el6.x86_64  vmlinuz-2.6.32-279.el6.x86_64
[root@localhost file]# umount /mnt
[root@localhost file]# mount -o loop,offset=525336576  /file/centos.img  /mnt
mount: unknown filesystem type 'LVM2_member'
注：普通分区可以正常挂载，LVM分区需要再特殊处理，后面会单独列出。
}


kvm(raw磁盘镜像的挂载:kpartx分区映射法){
[root@localhost file]# kpartx -av centos.img
---------------------------------------
add map loop2p1 (253:4): 0 1024000 linear /dev/loop2 2048
add map loop2p2 (253:5): 0 61888512 linear /dev/loop2 1026048
[root@localhost file]# mount /dev/mapper/loop2p1 /mnt/
[root@localhost file]# ls /mnt/
config-2.6.32-279.el6.x86_64  initramfs-2.6.32-279.el6.x86_64.img  System.map-2.6.32-279.el6.x86_64
efi                           lost+found                           vmlinuz-2.6.32-279.el6.x86_64
grub                          symvers-2.6.32-279.el6.x86_64.gz

---------------------------------------
[root@localhost file]# umount /mnt/
[root@localhost file]# kpartx -d centos.img
loop deleted : /dev/loop2
}

kvm(raw磁盘镜像的挂载:LVM分区的处理){
LVM分区的处理
---------------------------------------
[root@localhost file]# fdisk -lu centos.img
You must set cylinders.
You can do this from the extra functions menu.
Disk centos.img: 0 MB, 0 bytes
255 heads, 63 sectors/track, 0 cylinders, total 0 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0001905c
     Device Boot      Start         End      Blocks   Id  System
centos.img1   *        2048     1026047      512000   83  Linux
Partition 1 does not end on cylinder boundary.
centos.img2         1026048    62914559    30944256   8e  Linux LVM
Partition 2 has different physical/logical endings:
     phys=(1023, 254, 63) logical=(3916, 63, 51)
[root@localhost file]# echo $((1026048*512))
525336576
[root@localhost file]# losetup /dev/lo
log    loop0  loop1  loop2  loop3  loop4  loop5  loop6  loop7
[root@localhost file]# losetup /dev/loop0 centos.img -o 525336576
losetup: /dev/loop0: device is busy
[root@localhost file]# losetup /dev/loop centos.img -o 525336576
loop0  loop1  loop2  loop3  loop4  loop5  loop6  loop7
[root@localhost file]# losetup /dev/loop1 centos.img -o 525336576
losetup: /dev/loop1: device is busy
[root@localhost file]# losetup /dev/loop3 centos.img -o 525336576
[root@localhost file]# pvscan
  PV /dev/mapper/loop0p2   VG VolGroup   lvm2 [29.51 GiB / 0    free]
  Total: 1 [29.51 GiB] / in use: 1 [29.51 GiB] / in no VG: 0 [0   ]
[root@localhost file]# vgchange -ay VolGroup
  2 logical volume(s) in volume group "VolGroup" now active
[root@localhost file]# lvs
  LV      VG       Attr       LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
  lv_root VolGroup -wi-a----- 27.54g
  lv_swap VolGroup -wi-a-----  1.97g
[root@localhost file]# mount /dev/VolGroup/lv_root /mnt/
[root@localhost file]# ls /mnt/
bin   dev  home  lib64       media  opt   root  selinux  sys  usr
boot  etc  lib   lost+found  mnt    proc  sbin  srv      tmp  var
[root@localhost file]# cat /mnt/etc/sysconfig/network-scripts/
ifcfg-eth0              ifdown-post             ifup-eth                ifup-routes
ifcfg-lo                ifdown-ppp              ifup-ippp               ifup-sit
ifdown                  ifdown-routes           ifup-ipv6               ifup-tunnel
ifdown-bnep             ifdown-sit              ifup-isdn               ifup-wireless
ifdown-eth              ifdown-tunnel           ifup-plip               init.ipv6-global
ifdown-ippp             ifup                    ifup-plusb              net.hotplug
ifdown-ipv6             ifup-aliases            ifup-post               network-functions
ifdown-isdn             ifup-bnep               ifup-ppp                network-functions-ipv6
[root@localhost file]# cat /mnt/etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
HWADDR="52:54:00:3C:FB:2A"
NM_CONTROLLED="yes"
ONBOOT="no"
TYPE="Ethernet"
UUID="68b2bc1a-3b8b-4bb9-9796-b049197a1489"
[root@localhost file]# cat /etc/sysconfig/network-scripts/ifcfg-
ifcfg-br0   ifcfg-em1   ifcfg-em2   ifcfg-lo    ifcfg-p1p1  ifcfg-p1p2

上例中，最后几步，是通过查看配置文件区确实是否是某台KVM主机。挂载使用完成后，可以通过下面的方法进行卸载和删除
---------------------------------------
[root@localhost file]# umount /mnt/
[root@localhost file]# vgchange -an VolGroup
  0 logical volume(s) in volume group "VolGroup" now active
[root@localhost file]# losetup  -d /dev/l
log    loop0  loop1  loop2  loop3  loop4  loop5  loop6  loop7  lp0    lp1    lp2    lp3
[root@localhost file]# losetup  -d /dev/lo
log    loop0  loop1  loop2  loop3  loop4  loop5  loop6  loop7
[root@localhost file]# losetup  -d /dev/loop3
}

kvm(raw磁盘镜像的挂载:windows img分区的挂载){
[root@localhost file]# kpartx -av win7.img
---------------------------------------
add map loop2p1 (253:4): 0 204800 linear /dev/loop2 2048
add map loop2p2 (253:5): 0 62705664 linear /dev/loop2 206848
[root@localhost file]# mount /dev/mapper/loop2p2 /mnt/
mount: unknown filesystem type 'ntfs'
报错提示已说明的非常明白，未知的分区类型ntfs，此时需要通过安装软件使系统支持ntfs分区的识别和支持。需要的软件是ntfs-3g，安装前需要先安装依赖包fuse

[root@localhost file]# yum -y install fuse
---------------------------------------
接着这安装ntfs-3g，需要注意的是sourceforge上也有该包，不过不是最新的，建议去其官网tuxera.com上去下载。具体安装和挂载过程如下：

[root@localhost file]# wget http://tuxera.com/opensource/ntfs-3g_ntfsprogs-2014.2.15.tgz
[root@localhost file]# tar zxvf ntfs-3g_ntfsprogs-2014.2.15.tgz
[root@localhost file]# cd ntfs-3g_ntfsprogs-2014.2.15
[root@localhost ntfs-3g_ntfsprogs-2014.2.15]#./configure
[root@localhost ntfs-3g_ntfsprogs-2014.2.15]#make && make install
[root@localhost ntfs-3g_ntfsprogs-2014.2.15]# mount -t ntfs-3g /dev/mapper/loop2p2 /mnt/
The disk contains an unclean file system (0, 0).
The file system was not safely closed on Windows. Fixing.
[root@localhost ntfs-3g_ntfsprogs-2014.2.15]# ls /mnt/
Documents and Settings  PerfLogs     Program Files        Recovery      System Volume Information  Windows
pagefile.sys            ProgramData  Program Files (x86)  $Recycle.Bin  Users
此处具体可以参考archlinux官方wiki、 ntfs-3g官方下载说明页面 ，使用完成后，可以通过下面的方法卸载挂载和loop占用：

---------------------------------------
[root@localhost file]# umount /mnt/
[root@localhost file]# kpartx -dv /dev/loop2
del devmap : loop2p2
del devmap : loop2p1
[root@localhost file]# losetup -d /dev/loop2

}

kvm(qcow2格式下的镜像挂载){
首先可以尝试使用挂载raw镜像文件的方式处理下qcow2:
---------------------------------------
[root@localhost file]# qemu-img convert -f raw -O qcow2 centos.img centos.qcow2
[root@localhost file]# kpartx -av centos.qcow2
不会有任何信息输出
进行到第二步的时候，发现没有任何信息输出，而在raw镜像下会有分区和loop挂载关系的输出，由此可以确定，
raw的方式不适用qcow2镜像格式。
---------------------------------------
qcow2格式的镜像可以通过先转换成raw的格式进行处理，也可以通过libguestfs-tools工具处理，还可以使用qemu-nbd
直接挂载。就速度上而言qemu-nbd的速度肯定是最快的。不过由于centos/redhat原生内核和rpm源里并不含有对nbd模块
的支持及qemu-nbd（在fedora中包含在qemu-common包里）工具，所以想要支持需要编译重新编译内核并安装qemu-nbd包 。
如果仅仅是出于测试的目的，建议还是使用fedora去测试 。

通过make menuconfig的方式进行编译内核的话，可以依次选择：”Device Drivers –> Block devices –> 
Network block device support” 。也可以按下面的方式直接编译：
---------------------------------------
yum install kernel-devel kernel-headers
cd /tmp
wget http://vault.centos.org/6.3/updates/Source/SPackages/kernel-2.6.32-279.22.1.el6.src.rpm
rpm -ivh /kernel-2.6.32-279.22.1.el6.src.rpm
cd ~/rpmbuild/SOURCES
tar jxf linux-2.6.32-220.4.2.el6.tar.bz2 -C /usr/src/kernels/
cd /usr/src/kernels
mv $(uname -r) $(uname -r)-old
mv linux-2.6.32-220.4.2.el6 $(uname -r)
cd $(uname -r)
make mrproper
cp ../$(uname -r)-old/Module.symvers .
cp /boot/config-$(uname -r) ./.config
make oldconfig
make prepare
make scripts
make CONFIG_BLK_DEV_NBD=m M=drivers/block
cp drivers/block/nbd.ko /lib/modules/$(uname -r)/kernel/drivers/block/
depmod -a
编辑完成后，可以去http://sourceforge.net/projects/nbd/ 获取nbd包并安装。安装完成后，可以通过下面的方式进行挂载：

---------------------------------------
[root@localhost ndb]# qemu-nbd -c /dev/nbd0 centos.qcow2
[root@localhost ndb]# ll /dev/nbd0*
[root@localhost ndb]# mount /dev/nbd0p1 /mnt/
[root@localhost ndb]# cd /mnt/
[root@localhost mnt]# ls
bin   cgroup  etc   lib    lost+found  misc  net  proc  sbin     srv  tmp  var
boot  dev     home  lib64  media       mnt   opt  root  selinux  sys  usr
使用完成后，可以通过下面的操作卸载设备：

[root@localhost ndb]# umount /mnt/
[root@localhost ndb]# qemu-nbd -d /dev/nbd0
/dev/nbd0 disconnected
参考页面：http://jamyy.dyndns.org/blog/2012/02/3582.html 

---------------------------------------
注：在centos/redhat下增加对nbd的支持过程中，在安装nbd包时，可能会遇到与yum安装的qemu包有冲突等情况，
所以不建议在生产环境下重新编译内核增加对qcow2的挂载 。如有需要，可以尝试使用转换成raw格式或使用
libguestfs-tools工具包处理 。

}


kvm(libguestfs-tools:Linux){
libguestfs 是一组 Linux 下的 C 语言的 API ，用来访问虚拟机的磁盘映像文件。其项目主页是http://libguestfs.org/，
该工具包内包含的工具有virt-cat、virt-df、virt-ls、virt-copy-in、virt-copy-out、virt-edit、guestfs、guestmount、
virt-list-filesystems、virt-list-partitions等工具，具体用法也可以参看官网。该工具可以在不启动KVM guest主机的
情况下，直接查看guest主机内的文内容，也可以直接向img镜像中写入文件和复制文件到外面的物理机，当然其也可以像
mount一样，支持挂载操作。
一、libguestfs-tools的安装
-------------------------------------------------------------------------------
由于在rpm源里直接有该包，所以可以直接通过yum进行安装：
#yum -y install libguestfs-tools

二、linux下的使用
-------------------------------------------------------------------------------
[root@localhost file]# virt-df centos.img
Filesystem                           1K-blocks       Used  Available  Use%
centos.img:/dev/sda1                    495844      31950     438294    7%
centos.img:/dev/VolGroup/lv_root      28423176     721504   26257832    3%
[root@localhost file]# virt-ls centos.img /
.autofsck
bin
boot
dev
etc
home
lib
lib64
lost+found
media
mnt
opt
proc
root
sbin
selinux
srv
sys
tmp
usr
va

复制文件操作：
---------------------------------------
[root@localhost file]# virt-copy-out -d centos.img  /etc/passwd /tmp
libguestfs: error: no libvirt domain called 'centos.img': Domain not found: no domain with matching name 'centos.img'

注意这里有报错，报错原因是因为-d参数后面跟的是主机domain，不是镜像文件名。更改为domain后的操作步骤如下：
[root@localhost file]# virsh list --all
 Id    Name                           State
----------------------------------------------------
 4     ppd_win7                       running
 14    ppd_win2008                    running
 -     ppd_centos                     shut off
[root@localhost file]# virt-copy-out -d ppd_centos /etc/passwd /tmp/
[root@localhost file]# cat /tmp/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
gopher:x:13:30:gopher:/var/gopher:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
vcsa:x:69:69:virtual console memory owner:/dev:/sbin/nologin
saslauth:x:499:76:"Saslauthd user":/var/empty/saslauth:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin

查看分区相关信息：
---------------------------------------
[root@localhost file]# virt-filesystems  -d ppd_centos
/dev/sda1
/dev/VolGroup/lv_root
[root@localhost file]# virt-list-filesystems  -d ppd_centos
Unknown option: d
Usage:
     virt-list-filesystems [--options] domname
     virt-list-filesystems [--options] disk.img [disk.img ...]
[root@localhost file]# virt-list-filesystems  /file/centos.img
/dev/VolGroup/lv_root
/dev/sda1
[root@localhost file]# virt-list-partitions  /file/centos.img
/dev/sda1
/dev/sda2

需要注意的是，有的命令后面用的是domain，有的用的是img文件名。
---------------------------------------
guestmount 分区挂载
[root@localhost ~]# guestmount -a /file/centos.qcow2  -m /dev/sda2  --rw /mnt
libguestfs: error: mount_options: /dev/sda2 on / (options: ''): mount: unknown filesystem type 'LVM2_member'
guestmount: '/dev/sda2' could not be mounted.
guestmount: Did you mean to mount one of these filesystems?
guestmount:     /dev/sda1 (ext4)
guestmount:     /dev/VolGroup/lv_root (ext4)
guestmount:     /dev/VolGroup/lv_swap (swap)
[root@localhost ~]# guestmount -a /file/centos.qcow2  -m /dev/VolGroup/lv_root  --rw /mnt
fuse: mountpoint is not empty
fuse: if you are sure this is safe, use the 'nonempty' mount option
libguestfs: error: fuse_mount: /mnt: Resource temporarily unavailable
[root@localhost ~]# ls /mnt/
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  sbin  selinux  srv  sys  tmp  usr  var
[root@localhost ~]# umount /mnt/
[root@localhost ~]# guestmount -a /file/centos.qcow2  -m /dev/VolGroup/lv_root  --rw /mnt
[root@localhost ~]# ls /mnt/
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  sbin  selinux  srv  sys  tmp  usr  var
[root@localhost ~]# umount /mnt/

}
kvm(libguestfs-tools:Windows){
三、windows系统下的使用

[root@localhost opt]# virt-ls -a /file/win7.img c:
virt-ls: no operating system was found on this disk
If using guestfish '-i' option, remove this option and instead
use the commands 'run' followed by 'list-filesystems'.
You can then mount filesystems you want by hand using the
'mount' or 'mount-ro' command.
If using guestmount '-i', remove this option and choose the
filesystem(s) you want to see by manually adding '-m' option(s).
Use 'virt-filesystems' to see what filesystems are available.
If using other virt tools, this disk image wo not work
with these tools.  Use the guestfish equivalent commands
(see the virt tool manual page).
RHEL 6 notice
-------------
libguestfs will return this error for Microsoft Windows guests if the
separate 'libguestfs-winsupport' package is not installed. If the
guest is running Microsoft Windows, please try again after installing
'libguestfs-winsupport'.
需要注意的是，上面的用法中，有两个错误的地方，一处是linux查看C分区，后面不能直接跟C：，而应该换用/  ；第二个错误是由于没有安装libguestfs-winsupport 。该工具也可以看接通过yum安装 。安装完该包后，再进行查看：

[root@localhost opt]# virt-ls -a /file/win7.img /
$Recycle.Bin
Documents and Settings
PerfLogs
Program Files
Program Files (x86)
ProgramData
Recovery
System Volume Information
Users
Windows
pagefile.sys
利用guestmount进行挂载

[root@localhost ~]# guestmount -a /file/win7.img  -m /dev/sda2  --rw /mnt
[root@localhost ~]# ls /mnt/
Documents and Settings  pagefile.sys  PerfLogs  ProgramData  Program Files  Program Files (x86)  Recovery  $Recycle.Bin  System Volume Information  Users  Windows
}

kvm(nat上网){
KVM安装完成后，有两连网络配置连接模式 —— 一种是nat上网方式（virbr0网卡连接），一种是bridge（br0、br1等方式连接）
方式。由于虚拟机安装后，一般我们都会配置一个连接virbr0的一个nat网卡用于共享上网，所以这里主要说下通过宿主机的
iptables配置实现192.168.122.X网段的KVM虚拟机在配置完成后可以直接上网操作。

1、开启路由转发
---------------------------------------
打开/etc/sysctl.conf文件，找到ip_forward项，将其改为如下：
net.ipv4.ip_forward = 1

2、更改iptables配置如下：
---------------------------------------
[root@localhost qemu]# cat /etc/sysconfig/iptables
*nat
:PREROUTING ACCEPT [193:185421]
:POSTROUTING ACCEPT [177:10242]
:OUTPUT ACCEPT [4:320]
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
COMMIT
# Completed on Tue Jul  9 11:23:56 2013
# Generated by iptables-save v1.4.7 on Tue Jul  9 11:23:56 2013
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [549:80184]
-A INPUT -i virbr0 -p udp -m udp --dport 53 -j ACCEPT
-A INPUT -i virbr0 -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -i virbr0 -p udp -m udp --dport 67 -j ACCEPT
-A INPUT -i virbr0 -p tcp -m tcp --dport 67 -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -d 192.168.122.0/24 -i br1 -j ACCEPT
-A FORWARD -d 192.168.122.0/24 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -s 192.168.122.0/24 -i virbr0 -j ACCEPT
-A FORWARD -i virbr0 -o virbr0 -j ACCEPT
-A FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
# Completed on Tue Jul  9 11:23:56 2013
# Generated by iptables-save v1.4.7 on Tue Jul  9 11:23:56 2013
*mangle
:PREROUTING ACCEPT [56905:10171652]
:INPUT ACCEPT [553:43971]
:FORWARD ACCEPT [56352:10127681]
:OUTPUT ACCEPT [549:80184]
:POSTROUTING ACCEPT [56901:10207865]
-A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
COMMIT
# Completed on Tue Jul  9 11:23:56 2013
# Generated by iptables-save v1.4.7 on Tue Jul  9 11:23:56 2013

更改完iptables的配置后，重启iptabls服务加载生效。

---------------------------------------
最后这里也顺带提下bridge桥接模式的配置，启用桥模式只需要在虚拟机的相应的xml文件中，将虚拟机对应的网卡配置更改为如下即可：
 <interface type='bridge'>
      <mac address='52:54:00:f9:bd:b8'/>
      <source bridge='br0'/>
其中br0为宿主主机物理网口(如eth0) bridge的接口。

如果不需要nat方式的virbr0网口，也可以通过下面的方式删除（不推荐删除）：
---------------------------------------
# virsh net-destroy default
# virsh net-undefine default
# service libvirtd restart

各网络接口桥接对应关系也可以通过下面的命令查看：
---------------------------------------
[root@localhost qemu]# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.c81f66bbe018       no              em1
virbr0          8000.52540081c656       yes             virbr0-nic
                                                        vnet0
                                                        vnet
}

<serial type='pty'>
  <source path='/dev/pts/7'/>
  <target port='0'/>
  <alias name='serial0'/>
</serial>
<console type='pty' tty='/dev/pts/7'>
  <source path='/dev/pts/7'/>
  <target type='serial' port='0'/>
  <alias name='serial0'/>
</console>
    
kvm(KVM客户机添加virsh console支持){
如果KVM下的linux是通过过vnc graphics方式安装的话，如果想在终端下通过virsh console进行管理连接时，
发现敲任何键都没有反应，即不支持。而能不能通过修改配置文件达到像console安装或KS安装的效果 ? 
---------------------------------------
答案是肯定的。具体操作步骤为编辑/etc/grub.conf文件在kernel内核行添加console=ttyS0然后重启机器即可。
---------------------------------------
这里面要注意的是：1、ttyS后面提零，不是大写的欧 。2、该修改在centos环境下测试通过。如果在其他系统下，
如果修改此处不生效的话，可以尝试修改几下两处
---------------------------------------
echo "ttyS0" >> /etc/securetty
在/etc/inittab中添加agetty:

S0:12345:respawn:/sbin/agetty ttyS0 115200
修改完成后并重启机器即可。

2014-6-17后记:

在后来guest主机换成ubuntu时,使用上面的方法时,发现某些相应的文件找不到,找到的一些改也重启也没用.从网上后来专门针对ubnutu使用kVM console连接的方法,在ubuntu的官方站点上找到了方法:

#sudo editor /etc/init/ttyS0.conf
Add the configuration:
# ttyS0 - getty
#
# This service maintains a getty on ttyS0 from the point the system is
# started until it is shut down again.
start on stopped rc RUNLEVEL=[2345]
stop on runlevel [!2345]
respawn
exec /sbin/getty -L 115200 ttyS0 xterm
如果不想重启直接通过virsh console ubuntu-guest 进行连接 ，可以通过下面的命令启动ttyS0 

#sudo start ttyS0
通过echo $TERM查看目前的终端类型，也可以通过下面的方法更改默认的终端类型 

#export TERM=screen

}


kvm(宿主机CPU特性查看){
# virsh nodeinfo
CPU model: x86_64
CPU(s): 32
CPU frequency: 1200 MHz
CPU socket(s): 1
Core(s) per socket: 8
Thread(s) per core: 2
NUMA cell(s): 2
Memory size: 132119080 KiB

使用virsh capabilities可以查看物理机CPU的详细信息，包括物理CPU个数，每个CPU的核数，是否开了超线程。
# virsh capabilities
<capabilities>
  <host>
    <uuid>36353332-3030-3643-5534-3235445a564a</uuid>
    <cpu>
      <arch>x86_64</arch>
      <model>SandyBridge</model>
      <vendor>Intel</vendor>
      <topology sockets='1' cores='8' threads='2'/>
      <feature name='erms'/>
      <feature name='smep'/>
     ...
    </cpu>
    <power_management>
      <suspend_disk/>
    </power_management>
    <migration_features>
      <live/>
      <uri_transports>
        <uri_transport>tcp</uri_transport>
      </uri_transports>
    </migration_features>
    <topology>
      <cells num='2'>
        <cell id='0'>
          <cpus num='16'>
            <cpu id='0' socket_id='0' core_id='0' siblings='0,16'/>
         ...
            <cpu id='23' socket_id='0' core_id='7' siblings='7,23'/>
          </cpus>
        </cell>
        <cell id='1'>
          <cpus num='16'>
            <cpu id='8' socket_id='1' core_id='0' siblings='8,24'/>
           ...
            <cpu id='31' socket_id='1' core_id='7' siblings='15,31'/>
          </cpus>
        </cell>
      </cells>
    </topology>
    <secmodel>
      <model>none</model>
      <doi>0</doi>
    </secmodel>
    <secmodel>
      <model>dac</model>
      <doi>0</doi>
    </secmodel>
  </host>
...
</capabilities>

使用virsh freecell命令查看可以当前空闲内存:

# virsh  freecell --all
    0:     787288 KiB
    1:     94192 KiB
--------------------
Total: 881480 KiB
此处有暂时没搞清为什么是两个值－－莫非后面一个是swap的？以下是我台机上看到的情况，只有一个值：

[root@361way ~]# virsh freecell --all
    0:   13283648 KiB
--------------------
Total:   13283648 KiB
物理CPU的特性也可以通过/proc/cpuinfo查看

# cat /proc/cpuinfo
rocessor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 62
model name : Intel(R) Xeon(R) CPU E5-2640 v2 @ 2.00GHz
stepping : 4
cpu MHz : 1200.000
cache size : 20480 KB
physical id : 0
siblings : 16
core id : 0
cpu cores : 8
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips : 3990.67
clflush size : 64
cache_alignment : 64
address sizes : 46 bits physical, 48 bits virtual
power management:
...
综合上面的信息，我们可以得出以下信息：

1) 物理CPU为 E5-2640V2，为8核2颗，开启了超线程，在物理机系统上可以看到32个CPU；
2) 物理机内存为128G
}

kvm(虚拟机CPU使用情况查看){
可以使用virsh vcpuinfo命令查看虚拟机vcpu和物理CPU的对应关系

# virsh  vcpuinfo 21
VCPU: 0
CPU: 25
State: running
CPU time: 10393.0s
CPU Affinity: --------yyyyyyyy--------yyyyyyyy
VCPU: 1
CPU: 8
State: running
CPU time: 7221.2s
CPU Affinity: --------yyyyyyyy--------yyyyyyyy
...
可以看到vcpu0被调度到物理机CPU25上，目前是使用状态，使用时间是10393.0s

CPU Affinity: --------yyyyyyyy--------yyyyyyyy
yyyyyyy表示可以使用的物理CPU内部的逻辑核，可以看到这台虚拟机可以在8-15，
24-31这些cpu之间调度，为什么不能使用0-7，16-23这些CPU呢，是因为系统的自动numa平衡服务在发生作用，一个虚拟机默认只能使用同
一颗物理CPU内部的逻辑核。

需要注意的是，上面的21是虚拟机的名称，如下是我在家里的测试机上的结果：

[root@361way ~]# virsh list
 Id    Name                           State
----------------------------------------------------
 2     rserver                        running
 3     rhce                           running
 4     centos                         running
[root@361way ~]# virsh  vcpuinfo rserver
VCPU:           0
CPU:            1
State:          running
CPU time:       10.5s
CPU Affinity:   yyyyyyyy
VCPU:           1
CPU:            0
State:          running
CPU time:       5.3s
CPU Affinity:   yyyyyyyy
使用emulatorpin可以查看虚拟机可以使用那些物理逻辑CPU

# virsh emulatorpin 21
emulator: CPU Affinity
----------------------------------
       *: 0-31
可以看到0-31我们都可以使用，意味这我们也可以强制将CPU调度到任何CPU上。
}

kvm(在线pinning虚拟机的cpu){
强制让虚拟机只能在26-31这些cpu之间调度

# virsh  emulatorpin 21 26-31 --live
查看结果

# virsh  emulatorpin 21
emulator: CPU Affinity
----------------------------------
       *: 26-31
查看vcpu info

# virsh  vcpuinfo 21
VCPU: 0
CPU: 28
State: running
CPU time: 10510.5s
CPU Affinity: --------------------------yyyyyy
VCPU: 1
CPU: 28
State: running
CPU time: 7289.7s
CPU Affinity: --------------------------yyyyyy
...
查看xml文件

virsh # dumpxml 21
<domain type='kvm' id='21'>
  <name>cacti-230</name>
  <uuid>23a6455c-5cd1-20cd-ecfe-2ba89be72c41</uuid>
  <memory unit='KiB'>4194304</memory>
  <currentMemory unit='KiB'>4194304</currentMemory>
  <vcpu placement='static'>4</vcpu>
  <cputune>
    <emulatorpin cpuset='26-31'/>
  </cputune>
我们也可以强制vcpu和物理机cpu一对一的绑定

强制vcpu 0和物理机cpu 28绑定

强制vcpu 1和物理机cpu 29绑定

强制vcpu 2和物理机cpu 30绑定

强制vcpu 3和物理机cpu 31绑定

virsh  vcpupin 21 0 28
virsh  vcpupin 21 1 29
virsh  vcpupin 21 2 30
virsh  vcpupin 21 3 31
查看xml文件，生效了

virsh # dumpxml 21
<domain type='kvm' id='21'>
  <name>cacti-230</name>
  <uuid>23a6455c-5cd1-20cd-ecfe-2ba89be72c41</uuid>
  <memory unit='KiB'>4194304</memory>
  <currentMemory unit='KiB'>4194304</currentMemory>
  <vcpu placement='static'>4</vcpu>
  <cputune>
    <vcpupin vcpu='0' cpuset='28'/>
    <vcpupin vcpu='1' cpuset='29'/>
    <vcpupin vcpu='2' cpuset='30'/>
    <vcpupin vcpu='3' cpuset='31'/>
    <emulatorpin cpuset='26-31'/>
  </cputune>
是vcpuino命令查看，可以看到配置生效了

# virsh  vcpuinfo 22
VCPU: 0
CPU: 28
State: running
CPU time: 1.8s
CPU Affinity: ----------------------------y---
VCPU: 1
CPU: 29
State: running
CPU time: 0.0s
CPU Affinity: -----------------------------y--
...
}

kvm(virt-install与qcow2 preallocation){
而成功的重点在于创建qcow2镜像时，选择preallocation＝metadata选项 。

一、qemu-img创建镜像文件
-------------------------------------------------------------------------------
创建raw格式镜像文件（默认创建的是该格式）
yang@yang-acer:/opt/test$ sudo qemu-img create /opt/img/test-raw.img 1G
Formatting '/opt/img/test-raw.img', fmt=raw size=1073741824 

创建普通的qcow2格式镜像文件
yang@yang-acer:/opt/test$ sudo qemu-img create -f qcow2  /opt/img/test.qcow2 1G
Formatting '/opt/img/test.qcow2', fmt=qcow2 size=1073741824 encryption=off cluster_size=65536 lazy_refcounts=off

创建 预分配 元数据选项 的qcow2格式镜像文件
yang@yang-acer:/opt/test$ sudo qemu-img create -f qcow2 -o preallocation=metadata /opt/img/test-metadata.qcow2 1G
Formatting '/opt/img/test-metadata.qcow2', fmt=qcow2 size=1073741824 encryption=off cluster_size=65536 preallocation='metadata' lazy_refcounts=off

二、3种镜像文件的比较
-------------------------------------------------------------------------------
面我们以三种方式创建了三个镜像文件，下面通过ls -l 、stat、qemu-img info、du四种方式查看下各自的不同：
ls -l 给出的结果
---------------------------------------
yang@yang-acer:/opt/img$ ll
-rw-r--r-- 1 root         root  1074135040  5月 23 15:52 test-metadata.qcow2
-rw-r--r-- 1 root         root      197120  5月 23 15:52 test.qcow2
-rw-r--r-- 1 root         root  1073741824  5月 23 15:52 test-raw.img
ls -l 给出的结果看出，预分配元数据的 qcow2格式的镜像文件和 raw格式的镜像文件占用的大小接近，
基本上都是1G ，而普通格式的qcow2镜像文件占用的大小只有190K左右 。

stat 给出的结果
---------------------------------------
yang@yang-acer:/opt/img$ stat test-metadata.qcow2
  文件："test-metadata.qcow2"
  大小：1074135040      块：664        IO 块：4096   普通文件
设备：808h/2056d        Inode：530343      硬链接：1
权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
最近访问：2014-05-23 15:52:36.179523406 +0800
最近更改：2014-05-23 15:52:36.179523406 +0800
最近改动：2014-05-23 15:52:36.179523406 +0800
创建时间：-
yang@yang-acer:/opt/img$ stat test-raw.img
  文件："test-raw.img"
  大小：1073741824      块：0          IO 块：4096   普通文件
设备：808h/2056d        Inode：530341      硬链接：1
权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
最近访问：2014-05-23 15:52:17.915523541 +0800
最近更改：2014-05-23 15:52:17.915523541 +0800
最近改动：2014-05-23 15:52:17.915523541 +0800
创建时间：-
yang@yang-acer:/opt/img$ stat test.qcow2
  文件："test.qcow2"
  大小：197120          块：392        IO 块：4096   普通文件
设备：808h/2056d        Inode：530342      硬链接：1
权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
最近访问：2014-05-23 15:52:27.943523467 +0800
最近更改：2014-05-23 15:52:27.943523467 +0800
最近改动：2014-05-23 15:52:27.943523467 +0800
创建时间：-
stat 给出的结果更为详细，其中文件大小情况和ls -l 的结果一致。

qemu-img info给出的结果
---------------------------------------
yang@yang-acer:/opt/img$ qemu-img info test-metadata.qcow2
image: test-metadata.qcow2
file format: qcow2
virtual size: 1.0G (1073741824 bytes)
disk size: 332K
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
yang@yang-acer:/opt/img$ qemu-img info test-raw.img
image: test-raw.img
file format: raw
virtual size: 1.0G (1073741824 bytes)
disk size: 0
yang@yang-acer:/opt/img$ qemu-img info test.qcow2
image: test.qcow2
file format: qcow2
virtual size: 1.0G (1073741824 bytes)
disk size: 196K
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
qemu-img info给出的结果里面有两个我关以的指标，一个是virtual size 一个是disk size 。
其中前者是qemu-img create时后面参数值的大小，三者都是1G ；后者的结果经对比和du file -sh的结果一致 。

du的结果：
---------------------------------------
yang@yang-acer:/opt/img$du test-metadata.qcow2  -sh
332K    test-metadata.qcow2
yang@yang-acer:/opt/img$du test-raw.img   -sh
0    test-raw.img
yang@yang-acer:/opt/img$du test.qcow2    -sh
196K    test.qcow2
根据上面的结果来推测，创建预分配元数据的qcow2格式的镜像应该是参照了 原始的raw镜像文件的一些特点
做的一部分加快读写的优化 ，原理同raw一样，提前以空数据的方式将空间占用，而不是像普通的qcow2格式，
按需递增占用 。而以上无论是raw格式还是qcow2预分配元数据的方式都不会直接将1G的空间完全占用，
对宿主机的i节点占用上也没有影响，这个可以通过各文件创建和删除后df -hl和df -i 的结果来测试 。

三、文件写后的镜像对比
-------------------------------------------------------------------------------
上面的测试结果是空文件下的对比 ，在镜像上按默认方式装完相同的系统后，我再次对三者进行了比对 。
test-raw.img ：原始的raw镜像，并在其上安装centos 6系统
test-centos.qcow2：为test-raw.img ，通过qemu-img convert -f raw -O qcow2 test-raw.img  test-centos.qcow2 命令转化后的img镜像
centos.img：预分配元数据的qcow2格式的img，并在其上面安装centos6系统

ls -l 的结果：
---------------------------------------
yang@yang-acer:/opt$ ll
-rw-r--r--  1 root         root 21478375424  5月 23 18:03 centos.img
-rw-r--r--  1 root         root  2004942848  5月 23 18:25 test-centos.qcow2
-rw-r--r--  1 root         root 21474836480  5月 23 18:12 test-raw.img
同安装系统之前的结果一样，预分配元数据的 qcow2格式的镜像文件和 raw格式的镜像文件占用的大小接近 ，test-centos.qcow2 的ls -l 的大小和实际du的结果相同。由于stat的大小和ls -l 的大小一致，这里不再列出 。

qemu-img info的结果：
---------------------------------------
yang@yang-acer:/opt$ qemu-img  info test-centos.qcow2
image: test-centos.qcow2
file format: qcow2
virtual size: 20G (21474836480 bytes)
disk size: 1.9G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
yang@yang-acer:/opt$ qemu-img  info test-raw.img
image: test-raw.img
file format: raw
virtual size: 20G (21474836480 bytes)
disk size: 2.3G
yang@yang-acer:/opt$ qemu-img  info centos.img
image: centos.img
file format: qcow2
virtual size: 20G (21474836480 bytes)
disk size: 2.3G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false
这里给出了实际占用大小和创建前大小，同样安装完系统后，预分配元数据的 qcow2格式的镜像文件和 raw格式的镜像文件占用的大小接近。

du的结果
---------------------------------------
yang@yang-acer:/opt$ du test-centos.qcow2 -sh
1.9G    test-centos.qcow2
yang@yang-acer:/opt$ du test-raw.img  -sh
2.3G    test-raw.img
yang@yang-acer:/opt$ du centos.img -sh
2.4G    centos.img

四、总结
以上测试结果，有利于理解以下两方面的优点：
1、利用预分配，可以直接一步完成KVM guest主机qcow2镜像格式主机的安装 ，而不需要像之前装完再转换 。
2、利用预分配，可以加速qcow2格式下的KVM guest主机的读写速度 （虽然这里的测试结果不涉及到具体的速度测试，说起来有点牵强） 。
有兴趣的话，可以将在上面第三步的基础上再做下性能测试来验证上面的预分配对性能的影响 。
}

kvm(ubuntu下kvm的安装){
1、kvm 相关软件安装
---------------------------------------
sudo apt-get install qemu-kvm libvirt-bin virt-manager bridge-utils
2、桥接网络配置
---------------------------------------
sudo vim /etc/network/interfaces 编辑配置文件，修改IP网络信息如下：

auto lo
iface lo inet loopback
auto eth0
iface eth0 inet manual
auto br0
iface br0 inet static
address 192.168.10.130
network 192.168.10.0
netmask 255.255.255.0
broadcast 192.168.10.255
gateway 192.168.10.1
dns-nameservers 8.8.8.8
bridge_ports eth0
bridge_stp off
bridge_fd 0
bridge_maxwait 0
以上IP根据自己实际需要修改，如果网络环境是DHCP获取（生产环境下很少会这样用，这也也提下），可以代码修改为如下：

auto lo
iface lo inet loopback
auto eth0
iface eth0 inet manual
auto br0
iface br0 inet dhcp
bridge_ports eth0
bridge_stp off
bridge_fd 0
最后：sudo /etc/init.d/networking restart重新启动网络服务便可 。

3、路由转发
---------------------------------------
nat网络里会用到路由转发，不过我发现ubuntu下安装完KVM ，其默认开启路由转发功能，如果没有通过sysctl命令修改即可。

yang@yang-acer:/opt$ sudo sysctl -a|grep 'net.ipv4.ip_forward'
net.ipv4.ip_forward = 1
4、qemu.conf与iptables
---------------------------------------
编辑/etc/libvirt/qemu.conf文件，取消vnc_listen = "0.0.0.0"的注释，开启VNC功能，并sudo /etc/init.d/libvirt-bin restart加载新的配置 ，如果开启了防火墙，还需要通过下面的指令开启端口：

sudo iptables -A INPUT  -m tcp -p tcp --dport 5910  -j ACCEPT
注：ubuntu上iptables不像centos上，也可以使用ufw防火墙配置策略 。

5、guest主机的安装
---------------------------------------
创建镜像文件并查看文件信息：

sudo qemu-img create -f qcow2 -o preallocation=metadata centos.img 20G
qemu-img info centos.img 
配合VNC进行guest主机系统安装：
sudo virt-install --name centos --ram=1024 --arch=x86_64 --vcpus=1 --os-variant=rhel6 --disk 
path=/opt/centos.img,bus=virtio,cache=none,format=qcow2  --network bridge=br0,model=virtio  
--graphics vnc,password=361way,port=5913 --cdrom=/opt/CentOS-6.5-x86_64-LiveCD.iso
}

kvm(自建KVM模板){
https://yq.aliyun.com/ziliao/78141
http://www.361way.com/create-new-kvm-guest-from-template/3253.html
http://www.361way.com/create-kvm-template-etc/3264.html
}

