物理卷PV Physical Volume
卷组  VG Volume   Group
物理长度PE Physical Extent
逻辑卷LV Logical Volume
LVM()
{
Linux LVM卷管理相关命令
              物理卷      卷组        逻辑卷
Scan 查看     pvscan      vgscan      lvscan
Create创建    pvcreate    vgcreate    lvcreate
Display 显示  pvdisplay   vgdisplay   lvdisplay
Remove 还原   pvremove    vgremove    lvremove
Extend 扩展   pvextend    vgextend    lvextend
}

LVM(实例1)
{
1）  添加两块SCSI硬盘
2）  查看是否已经新增硬盘
fdisk  -l
3）  对新的磁盘进行分区，并将文件系统改为8e
fdisk  /dev/sdb
fdisk  /dev/sdc
4）  创建PV物理卷
pvcreate  /dev/sdb1
pvcreate  /dev/sdc1
5）  创建VG卷组
vgcreate  mail_store  /dev/sdb1  /dev/sdc1
6）  创建LV逻辑卷
lvcreate  -L  10G  -n  mail  mail_store
7）  在逻辑卷中创建ext3文件系统，并挂载到 /mail目录下
mkfs  -t  ext3  /dev/mail_store/mail
df   -hT
8）  扩展lv逻辑卷
lvextend   -L  +5G   -n  /dev/mail_store/mail
resize2fs    /dev/mail_store/mail
}

LVM(实例2)
{
单块硬盘创建LVM 
1.pvcreate /dev/hda /dev/hdb /dev/hdc //为三块硬盘创建pv物理卷 
2.vgcreate vgtest /dev/hda /dev/hdb /dev/hdc //创建和添加3块硬盘到vgtest卷组中 
3.lvcreate -L 10G -n lvtest vgtest //创建逻辑卷名字lvtest大小为10G空间也可以全部创建完空间PE大小 
4.mkfs.ext3 /dev/vgtest/lvtest //格式化lvtest逻辑卷 
5.mount /dev/vgtest/lvtest /mnt //临时测试挂载lvtest逻辑卷到/mnt目录下 
6.df -h //查看lvtest空间大小为10G 
7.vgextend vgtest /dev/hdd //增加vgtest空间的大小加入一块pv物理卷/dev/hdd 
8.vgdisplay -v|vgs //查看卷组的详细信息vgtest卷组 
9.lvextend -L +10G /dev/vgtest/lvtest //扩展逻辑卷lvtest的大小增加10G空间大小 
10.lvdisplay -v|lvs //查看lvtest逻辑卷详细信息 
11.resize2fs -f /dev/vgtest/lvtest //在线扩容lvtest大小 
12. echo "/dev/vgtest/lvtest  /mnt    ext3  default  0 0">>/etc/fstab //最后自动开机挂载lvtest逻辑卷 

删除LVM 
1.umount /dev/vgtest/lvtest //卸载/mnt挂载点 
2.lvremove /dev/vgtest/lvtest //删除逻辑卷lvtest提示yes卸载 
3.vgremove vgtest //卸载名字为vgtest卷组 
4.pvremove /dev/hda /dev/hdb /dev/hdc /dev/hdd //删除物理卷 
5.vi /etc/fstab  //最后删除挂载点。
}

help()
{
extendfs
扩充文件系统：
# extendfs /dev/vg00/rlvol3
lvchange
更改逻辑卷的特性：
# lvchange -t 60 /dev/vg00/lvol3
lvcreate
在卷组中创建逻辑卷：
# lvcreate -L 100 /dev/vg00
lvdisplay
显示有关逻辑卷的信息：
# lvdisplay -v /dev/vg00/lvol1
lvextend
为逻辑卷添加镜像
# lvextend -m 1 /dev/vg00/lvol3
lvextend
增加逻辑卷的大小
# lvextend -L 120 /dev/vg00/lvol3
lvlnboot
准备将逻辑卷用作根区域、交换区域或转储区域：
# lvlnboot -d /dev/vg00/lvol2
lvmerge
将拆分卷合并为一个逻辑卷：
# lvmerge /dev/vg00/lvol4b /dev/vg00/lvol4
lvreduce
减小逻辑卷的大小：
# lvreduce -L 100 /dev/vg00/lvol3
lvreduce
减小逻辑卷的镜像副本的数量：
# lvreduce -m 0 /dev/vg00/lvol3
lvremove
从卷组中删除逻辑卷：
# lvremove /dev/vg00/lvol6
lvrmboot
删除到根区域、交换区域或转储区域的逻辑卷链路：
# lvrmboot -d /dev/vg00/lvol2
lvsplit
将一个镜像逻辑卷拆分为两个逻辑卷：
# lvsplit /dev/vg00/lvol4
lvsync
同步过时的逻辑卷镜像：
# lvsync /dev/vg00/lvol1
pvchange
更改物理卷的特性：
# pvchange -a n /dev/disk/disk2
pvck
对物理卷执行一致性检查：
# pvck /dev/disk/disk47_p2
pvcreate
创建用作卷组的一部分的物理卷：
# pvcreate /dev/rdisk/disk2
pvdisplay
显示有关物理卷的信息：
# pvdisplay -v /dev/disk/disk2
pvmove
将盘区从一个物理卷移动到另一个物理卷：
# pvmove /dev/disk/disk2 /dev/disk/disk3
pvremove
从物理卷中删除 LVM 数据结构：
# pvremove /dev/rdisk/disk2
vgcfgbackup
保存卷组的 LVM 配置：
# vgcfgbackup vg00
vgcfgrestore
恢复 LVM 配置：
# vgcfgrestore -n /dev/vg00 /dev/rdisk/disk2
vgchange
打开或关闭卷组：
# vgchange -a y /dev/vg00
vgchgid
更改物理卷的卷组 ID：
# vgchgid /dev/rdisk/disk3
vgcreate
创建卷组：
# vgcreate /dev/vg01 /dev/disk/disk2 /dev/disk/disk3
vgdisplay
显示有关卷组的信息：
# vgdisplay -v /dev/vg00
vgextend
通过添加物理卷来扩充卷组：
# vgextend /dev/vg00 /dev/disk/disk2
vgexport
从系统中删除卷组：
# vgexport /dev/vg01
vgimport
向系统添加现有卷组：
# mkdir /dev/vg04
# mknod /dev/vg04/group c 640x0n0000
# vgimport -v /dev/vg04
(n 编号在所有卷组中是唯一的）。
vgmodify
修改卷组的配置参数：
# vgmodify -v -t -n -r /dev/disk/disk3
vgscan
扫描卷组的系统磁盘：
# vgscan -v
vgreduce
通过从卷组中删除一个或多个物理卷来缩小卷组：
# vgreduce /dev/vg00 /dev/disk/disk2
vgremove
从系统和磁盘中删除卷组定义：
# vgremove /dev/vg00 /dev/disk/disk2
vgsync
同步卷组中的所有镜像逻辑卷：
# vgsync vg00
}