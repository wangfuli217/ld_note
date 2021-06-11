raid(软件RAID和硬件RAID)
{
    软件去实现的RAID功能，所以它配置灵活、管理方便。同时使用软件RAID，还可以实现将几个物理磁盘合并成一个更大的
虚拟设备，从而达到性能改进和数据冗余的目的。
    基于硬件的RAID解决方案比基于软件RAID技术在使用性能和服务性能上稍胜一筹，具体表现在检测和修复多位错误的能力、
错误磁盘自动检测和阵列重建等方面。
}
raid(类别简介)
{
一般常用的RAID阶层，分别是RAID 0、RAID1、RAID 2、RAID 3、RAID 4以及RAID 5，再加上二合一型 RAID 0+1或称RAID 10。我们先把这些RAID级别的优、缺点做个比较：

RAID   级别         相对优点                相对缺点                        功能                          功能               盘数
RAID    0           存取速度最快            没有容错                        完全无备份和纠错，差错功能     无冗余            2
RAID    1           完全容错                成本高                          一比一备份                     1:1冗余           2
RAID    2           带海明码校验，          数据冗余多，速度慢              可以纠错                       单独parity盘      3
RAID    3           写入性能最好            没有多任务功能                  只能查错不能纠错               单独parity盘      3
RAID    4           具备多任务及容错功能    Parity 磁盘驱动器造成性能瓶颈   集中存储纠错信息               单独parity盘      3
RAID    5           具备多任务及容错功能    写入时有overhead                分散存储纠错信息               交错parity盘      3
RAID    0+1/RAID 10 速度快、完全容错        成本高                                                         1:1冗余 + 无冗余  4

RAID级别	 冗余和数据恢复能力 	        读性能	 写性能 	 硬盘利用率 
 RAID 0 	 无冗余。数据损坏后不能恢复。  	 高 	 高 	 
             硬盘利用率100%。  
 RAID 1 	 全冗余，当chunk故障时，可以使用对应镜像chunk进行恢复。  	 较高 	 较低 	 
             硬盘利用率1/n（n代表RAID 1成员盘的总数）。  
 RAID 3 	 较高，chunk组中的一个chunk作为校验块。任意一块数据chunk故障都可以通过校验chunk进行恢复。如果出现两个及以上chunk故障，则整个RAID级别故障。  	                  高 	 低 	
             4Da+1Pb：硬盘利用率80%。
             2D+1P：硬盘利用率66.67%。
             8D+1P：硬盘利用率88.89%。  
 RAID 5 	 较高，校验数据分散在不同的chunk上，每个chunk组中的校验数据占用一个chunk的空间，允许任意一个数据chunk故障。如果出现两个及以上chunk故障，则整个RAID级别故障。  	 较高 	 较高 	 
             4D+1P：硬盘利用率80%。
             8D+1P：硬盘利用率88.89%。
 RAID 6 	 较高，两组校验数据分散在不同的chunk上，每个chunk组中的校验数据占用两个chunk的空间，允许任意两个chunk故障。如果出现三个及以上chunk故障，则整个RAID级别故障。     中 	 中 	
            4D+2P：硬盘利用率66.67%。
            8D+2P: 硬盘利用率80%。
 RAID 10 	 高，允许多个chunk故障。当某个chunk故障时，可以使用对应的镜像chunk进行恢复。如果存储相同数据的chunk和镜像chunk同时故障，则整个RAID级别故障。 	                 较高 	 较高 	 
             硬盘利用率50%。 
 RAID 50 	 较高，每个RAID 5子组中的校验数据分散在不同的chunk上，每个RAID 5子组中只允许一个chunk失效。如果某个RAID 5子组中有2个及以上chunk同时失效，则整个RAID级别故障。  	 较高 	 较高 	
4D+2P: 硬盘利用率66.67%。
8D+2P: 硬盘利用率80%。
16D+2P：硬盘利用率88.89%。  
a：“D”指数据块。 
b：“P”指校验块。  

RAID级别 	应用场景 
RAID 0 	适用于视频处理、图像处理和出版等需要高吞吐率应用的场合。  
RAID 1 	适用于会计报表、工资报表、金融和其他需要非常高可靠性的场合。
RAID 3 	实际的业务应用中一般不采用RAID 3。  
RAID 5 	适用于顺序业务较多的场合，例如，视频点播业务和视频监控业务。  
RAID 6 	适用于顺序业务较多的场合，例如，视频点播业务和视频监控业务。 
RAID 10 	从读写性能上看，RAID 10适用于随机业务场景，例如数据库应用等；从安全性上看，RAID 10适用于银行和金融等领域。  
RAID 50 	适用于金融和数据库等对大文件类型有需求且对数据的安全性要求比较高的场合。  


0. 无冗余。数据损坏后不能恢复。 读性能：高 写性能：高
   硬盘利用率100%。RAID 0的速度是最快的。
1. 全冗余，当chunk故障时，可以使用对应镜像chunk进行恢复。所有RAID级别中最低的。读性能：较高  写性能：低
   通常的RAID功能由软件实现，而这样的实现方法在服务器负载比较重的时候会大大影响服务器效率。
2. 将数据条块化分布于不同的硬盘上，条块单位为位或字节。然而RAID 2使用一定的编码技术来提供错误检查及恢复。
   这种编码技术需要多个磁盘存放检查及恢复信息，使得RAID 2技术实施更复杂。因此，在商业环境中很少使用。
   要利用海明码，必须要付出数 据冗余的代价。输出数据的速率与驱动器组中速度最慢的相等。
3. 较高，chunk组中的一个chunk作为校验块。任意一块数据chunk故障都可以通过校验chunk进行恢复。如果出现两个及以上chunk故障，则整个RAID级别故障。 读性能：高 写性能：低 
   RAID 3 是将数据先做XOR 运算，产生Parity Data后，在将数据和Parity Data 以并行存取模式写入成员磁盘驱动器中，因此具备并行存取模式的优点和缺点。
   RAID 3 以其优越的写入性能，特别适合用在大型、连续性档案写入为主的应用，例如绘图、影像、视讯编辑、多媒体、数据仓储、高速数据撷取等等。
   以目前的Caching 技术，都可以将之取代，因此一般认为RAID 3的应用，将逐渐淡出市场。
4. 如果一个驱动器出现故障，那么可以使用校验信息来重建所有数据。如果两个驱动器出现故障，那么所有数据都将丢失。
   由于使用单一专属的Parity Disk 来存放Parity Data，因此在写入时，就会造成很大的瓶颈。因此，RAID 4并没有被广泛地应用。
5. 较高，校验数据分散在不同的chunk上，每个chunk组中的校验数据占用一个chunk的空间，允许任意一个数据chunk故障。如果出现两个及以上chunk故障，则整个RAID级别故障。 读性能：较高  写性能：较高
   RAID 5 可能是最有用的 RAID 模式。RAID 5可以用在三块或更多的磁盘上，并使用0块或更多的备用磁盘。就像 RAID 4一样，得到的 RAID5 设备的大小是（N－1）*S。
   基本上来说，多人多任务的环境，存取频繁，数据量不是很大的应用，都适合选用RAID 5 架构，
   例如企业档案服务器、WEB 服务器、在线交易系统、电子商务等应用，都是数据量小，存取频繁的应用。
1+0：高，允许多个chunk故障。当某个chunk故障时，可以使用对应的镜像chunk进行恢复。如果存储相同数据的chunk和镜像chunk同时故障，则整个RAID级别故障。 读性能：较高  写性能：较高
    RAID 0+1/RAID 10，综合了RAID 0 和 RAID 1的优点，适合用在速度需求高，又要完全容错，当然经费也很多的应用。 RAID 0和RAID 1的原理很简单，合起来之后还是很简单，
}

raid(RAID条切“striped”的存取模式;)
{
在使用数据条切Data Stripping 的RAID 系统之中，对成员磁盘驱动器的存取方式，可分为两种：

并行存取Paralleled Access
独立存取Independent Access

RAID 2和RAID 3 是采取并行存取模式。
RAID 0、RAID 4、RAID 5及RAID 6则是采用独立存取模式。
}

raid(平行存取模式)
{
并行存取模式支持里，是把所有磁盘驱动器的主轴马达作精密的控制，使每个磁盘的位置都彼此同步，然后对每一个磁盘驱动器作
一个很短的I/O数据传送，如此一来，从主机来的每一个I/O 指令，都平均分布到每一个磁盘驱动器。

为了达到并行存取的功能，RAID 中的每一个磁盘驱动器，都必须具备几乎完全相同的规格：转速必须一样；磁头搜寻速度Access 
Time必须相同；Buffer 或Cache的容量和存取速度要一致；CPU处理指令的速度要相同；I/O Channel 的速度也要一样。总而言之，
要利用并行存取模式，RAID 中所有的成员磁盘驱动器，应该使用同一厂牌，相同型号的磁盘驱动器。

假设RAID***有四部相同规格的磁盘驱动器，分别为磁盘驱动器A、B、C和D，我们在把时间轴略分为T0、T1、T2、T3和T4：

T0： RAID控制器将第一笔数据传送到A的Buffer，磁盘驱动器B、C和D的Buffer都是空的，在等待中
T1： RAID控制器将第二笔数据传送到B的Buffer，A开始把Buffer中的数据写入扇区，磁盘驱动器C和D的Buffer都是空的，在等待中
T2： RAID控制器将第三笔数据传送到C的Buffer，B开始把Buffer中的数据写入扇区，A已经完成写入动作，磁盘驱动器D和A的Buffer都是空的，在等待中
T3： RAID控制器将第四笔数据传送到D的Buffer，C开始把Buffer中的数据写入扇区，B已经完成写入动作，磁盘驱动器A和B的Buffer都是空的，在等待中
T4： RAID控制器将第五笔数据传送到A的Buffer，D开始把Buffer中的数据写入扇区，C已经完成写入动作，磁盘驱动器B和C的Buffer都是空的，在等待中

如此一直循环，一直到把从主机来的这个I/O 指令处理完毕，RAID控制器才会受处理下一个I/O 指令。重点是在任何一个
磁盘驱动器准备好把数据写入扇区时，该目的扇区必须刚刚好转到磁头下。同时RAID控制器每依次传给一个磁盘驱动器的
数据长度，也必须刚刚好，配合磁盘驱动器的转速，否则一旦发生 miss，RAID 性能就大打折扣。

因此特别适合应用在大型、数据连续的档案存取应用，例如：
影像、视讯档案服务器
数据仓储系统
多媒体数据库
电子图书馆
印前或底片输出档案服务器
其它大型且连续性档案服务器

}

raid(独立存取模式)
{
    相对于并行存取模式，独立存取模式并不对成员磁盘驱动器作同步转动控制，其对每个磁盘驱动器的存取，都是独立且没有
顺序和时间间格的限制，同时每笔传输的 数据量都比较大。因此，独立存取模式可以尽量地利用overlapping 多任务、Tagged 
Command Queuing等等高阶功能，来" 隐藏"上述磁盘驱动器的机械时间延迟Seek 和Rotational Latency。

由于独立存取模式可以做overlapping 多任务，而且可以同时处理来自多个主机不同的I/O Requests，在多主机环境如Clustering，
更可发挥最大的性能。

独立存取RAID的最佳应用;
由于独立存取模式可以同时接受多个I/O Requests，因此特别适合应用在数据存取频繁、每笔数据量较小的系统。例如：
在线交易系统或电子商务应用
多使用者数据库
ERM及MRP 系统
小文件之文件服务器
}

raid(6)
{
RAID 6是由一些大型企业提出来的私有RAID级别标准，它的全称叫“Independent Data disks with two independent distributed 
parity schemes(带有两个独立分布式校验方案的 独立数据磁盘)”。这种RAID级别是在RAID 5的基础上发展而成，因此它的工作模式
与RAID 5有异曲同工之妙，不同的是RAID 5将校验码写入到一个驱动器里面，而RAID 6将校验码写入到两个驱动器里面，这样就增强
了磁盘的容错能力，同时RAID 6阵列中允许出现故障的磁盘也就达到了两个，但相应的阵列磁盘数量最少也要4个。

}

raid(7)
{
RAID 7全称叫“Optimized Asynchrony for High I/O Rates as well as High Data Transfer Rates(最优化的异步高I/O速率和高
数据传输率)”，它与以前我们见到RAID级别具有明显的区别。RAID 7完全可以理解为一个独立存储计算机，它自身带有操作系统和
管理工具，完全可以独立运行。
}

raid(5E)
{
RAID 5E是由IBM公 司提出的一种私有RAID级别，没有成为国际标准。这种RAID级别也是从RAID 5的基础上发展而来的，它与RAID 5
不同的地方是将数据校验信息平均分布在每一个磁盘中，并且每个磁盘都要预留一定的空间，这部分空间没有进行条带化(条带是
指数据为了保存在RAID中， 被划分成的最小单元。
}

raid(5EE)
{
RAID 5EE也是由IBM公司提出的一种私有RAID级别，它也没有成为国际标准。RAID 5EE的工作原理与RAID 5E基本相同，它也是在
每个磁盘中预留一部分空间作为分布的热备盘，当一个硬盘出现故障时，这个磁盘上的数据将被压缩到分布的热备盘中，达到数据
的保护作 用。不过与RAID 5E不同的是RAID 5EE内增加了一些优化技术，使RAID 5EE的工作效率更高，压缩数据的速度也更快。
RAID 5EE允许两个磁盘出错，最少需要4个磁盘实现。

}

raid(RAID ADG)
{
RAID ADG相当于双RAID 5技术，是HP提出来的一种RAID技术。这种技术部署了2个奇偶校验集，并提供了2个硬盘的容量存储这些
奇偶校验信息，能同时允许2块硬盘出现故障，有效提升了磁盘内数据的可靠性。不过这种技术会严重影响系统速度，所以并没
有得到推广。
}

raid(RAID DP)
{
RAID DP也属于一种私有的RAID标准，它实际上也就是双RAID 3技术，所谓双RAID 3技术主要是说在同一磁盘阵列中组建两个独立的
不同算法的校验磁盘，在单校验磁盘下工作原理与RAID 3一样，但增加了一个校验盘之后，则使整个磁盘阵列的安全性得到提高，
并且它的性能比RAID 3和RAID 5都要好。
}

mdadm()
{
1. 假设我有4块硬盘,(没有条件的朋友可以用虚拟机设置出4块硬盘出来).分别为/dev/sda  /dev/sdb  /dev/sdc  /dev/sdd.首先做的就是分区了.
2. 其它分区照这样做全部分出一个区出来.下面是总分区信息:
# [root@localhost /]# fdisk -l
# Disk /dev/sda: 1073 MB, 1073741824 bytes
# 255 heads, 63 sectors/track, 130 cylinders
# Units = cylinders of 16065 * 512 = 8225280 bytes
# 
#    Device Boot      Start         End      Blocks   Id  System
# /dev/sda1               1         130     1044193+  83  Linux
# 
# Disk /dev/sdb: 1073 MB, 1073741824 bytes
# 255 heads, 63 sectors/track, 130 cylinders
# Units = cylinders of 16065 * 512 = 8225280 bytes
# 
#    Device Boot      Start         End      Blocks   Id  System
# /dev/sdb1               1         130     1044193+  83  Linux
# 
# Disk /dev/sdc: 1073 MB, 1073741824 bytes
# 255 heads, 63 sectors/track, 130 cylinders
# Units = cylinders of 16065 * 512 = 8225280 bytes
# 
#    Device Boot      Start         End      Blocks   Id  System
# /dev/sdc1               1         130     1044193+  83  Linux
# 
# Disk /dev/sdd: 1073 MB, 1073741824 bytes
# 255 heads, 63 sectors/track, 130 cylinders
# Units = cylinders of 16065 * 512 = 8225280 bytes
# 
#    Device Boot      Start         End      Blocks   Id  System
# /dev/sdd1               1         130     1044193+  83  Linux

3. 下一步就是创建RAID了.
mdadm --create /dev/md0 --level=5 --raid-devices=3 --spare-devices=1 /dev/sd[a-d]1  
#意思是创建RAID设备名为md0, 级别为RAID 5
mdadm: array /dev/md0 started.    使用3个设备建立RAID,空余一个做备用.

4. OK,初步建立了RAID了,我们看下具体情况吧.
# [root@localhost ~]# mdadm --detail /dev/md0
# /dev/md0:
#         Version : 00.90.01
#   Creation Time : Fri Aug  3 13:53:34 2007
#      Raid Level : raid5
#      Array Size : 2088192 (2039.25 MiB 2138.31 MB)
#     Device Size : 1044096 (1019.63 MiB 1069.15 MB)
#    Raid Devices : 3
#   Total Devices : 4
# Preferred Minor : 0
#     Persistence : Superblock is persistent
# 
#     Update Time : Fri Aug  3 13:54:02 2007
#           State : clean
#  Active Devices : 3
# Working Devices : 4
#  Failed Devices : 0
#   Spare Devices : 1
# 
#          Layout : left-symmetric
#      Chunk Size : 64K
# 
#     Number   Major   Minor   RaidDevice State
#        0       8        1        0      active sync   /dev/sda1
#        1       8       17        1      active sync   /dev/sdb1
#        2       8       33        2      active sync   /dev/sdc1
#        3       8       49       -1      spare   /dev/sdd1
#            UUID : e62a8ca6:2033f8a1:f333e527:78b0278a
#          Events : 0.2

5. 让RAID开机启动.配置RIAD配置文件吧.默认名字为mdadm.conf,这个文件默认是不存在的,要自己建立.该配置文件存在的主要作用
是系统启动的时候能够自动加载软RAID，同时也方便日后管理.

说明下,mdadm.conf文件主要由以下部分组成:DEVICES选项制定组成RAID所有设备, ARRAY选项指定阵列的设备名、RAID级别、阵列
中活动设备的数目以及设备的UUID号.

root@localhost ~]# mdadm --detail --scan > /etc/mdadm.conf
[root@localhost ~]# cat /etc/mdadm.conf
ARRAY /dev/md0 level=raid5 num-devices=3 UUID=e62a8ca6:2033f8a1:f333e527:78b0278a
   devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1

#默认格式是不正确的,需要做以下方式的修改:
[root@localhost ~]# vi /etc/mdadm.conf
[root@localhost ~]# cat /etc/mdadm.conf

devices /dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
ARRAY /dev/md0 level=raid5 num-devices=3 UUID=e62a8ca6:2033f8a1:f333e527:78b0278a

6. 将/dev/md0创建文件系统,
# [root@localhost ~]# mkfs.ext3 /dev/md0
# mke2fs 1.35 (28-Feb-2004)
# Filesystem label=
# OS type: Linux
# Block size=4096 (log=2)
# Fragment size=4096 (log=2)
# 261120 inodes, 522048 blocks
# 26102 blocks (5.00%) reserved for the super user
# First data block=0
# Maximum filesystem blocks=536870912
# 16 block groups
# 32768 blocks per group, 32768 fragments per group
# 16320 inodes per group
# Superblock backups stored on blocks:
#         32768, 98304, 163840, 229376, 294912
# 
# Writing inode tables: done
# Creating journal (8192 blocks): done
# Writing superblocks and filesystem accounting information: done
# 
# This filesystem will be automatically checked every 21 mounts or
# 180 days, whichever comes first.  Use tune2fs -c or -i to override.内容

7. 挂载/dev/md0到系统中去,我们实验是否可用:
# [root@localhost ~]# cd /
# [root@localhost /]# mkdir mdadm
# [root@localhost /]# mount /dev/md0 /mdadm/
# [root@localhost /]# cd /mdadm/
# [root@localhost mdadm]# ls
# lost+found
# [root@localhost mdadm]# cp /etc/services .
# [root@localhost mdadm]# ls
# lost+found  services

8. 好了,如果其中某个硬盘坏了会怎么样呢?系统会自动停止这块硬盘的工作,然后让后备的那块硬盘顶上去工作.我们可以实验下.
# [root@localhost mdadm]# mdadm /dev/md0 --fail /dev/sdc1
# mdadm: set /dev/sdc1 faulty in /dev/md0
# [root@localhost mdadm]# cat /proc/mdstat
# Personalities : [raid5]
# md0 : active raid5 sdc1[3](F) sdd1[2] sdb1[1] sda1[0] # F标签以为此盘为fail.
#       2088192 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
# 
# unused devices: <none>

9. 如果我要移除一块坏的硬盘或添加一块硬盘呢?
#删除一块硬盘

[root@localhost mdadm]# mdadm /dev/md0 --remove /dev/sdc1
mdadm: hot removed /dev/sdc1
[root@localhost mdadm]# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sdd1[2] sdb1[1] sda1[0]
      2088192 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

#增加一块硬盘

[root@localhost mdadm]# mdadm /dev/md0 --add /dev/sdc1
mdadm: hot added /dev/sdc1
[root@localhost mdadm]# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sdc1[3] sdd1[2] sdb1[1] sda1[0]
      2088192 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
}

mdadm()
{
目前MD支持linear,multipath,raid0(stripping),raid1(mirror),raid4,raid5,raid6,raid10等不同的冗余级别和组成方式,
当然也能支持多个RAID阵列的层叠组成raid1+0,raid5+1等类型的阵列.
RHEL5已经将MD驱动模块直接编译到内核中,我们可以在机器启动后通过cat /proc/mdstat看内核是否已经加载MD驱动或者
cat /proc/devices是否有md块设备.

[root@server ~]# cat /proc/mdstat
        Personalities :
        unused devices: <none>
        [root@server ~]# cat /proc/devices | grep md
          1 ramdisk
          9 md
        254 mdp
在Linux系统中用户层以前使用raidtool工具集来管理MD设备,目前广泛使用mdadm软件来管理MD设备,而且该软件都会集成在Linux的发布版中.mdadm主要有7种使用模式,分别如下:
        --assemble       -A: 将原来属于一个阵列的每个块设备组装为阵列
        --build          -B: 构建没有元数据块的阵列
        --create         -C: 构建一个新阵列,与build的不同之处在于每个设备具有元数据块
        --manage           : 管理已经存储阵列中的设备,比如增加热备磁盘或者删除磁盘
        --misc             : 报告或者修改阵列中相关设备的信息,比如查询阵列或者设备的状态信息
        --monitor        -F: 监控一个或多个阵列,上报指定的事件
        --grow           -G: 改变阵列中每个设备被使用的容量或阵列中的设备的数目
在RHEL5中可以直接使用YUM来安装mdadm软件包,也可以从安装光盘上找到该软件包用RPM安装.
        [root@server ~]# mdadm --version
        mdadm - v2.6.4 - 19th October 2007
安装好后,就可以开始今天的试验了.     
}
mdadm(1.准备源盘)
{
我们先在虚拟机下虚拟9块SCSI硬盘.
        RAID0:  sdb    sdc
        RAID1:  sdd    sde    sdf
        RAID5:  sdg    sdh    sdi    sdj
新建一文件answer,内容如下:
        n
        p
        1

        t
        FD
        w
然后执行如下操作:
        [root@server ~]# for i in b c d e f g h i j; do fdisk /dev/sd$i < answer; done
        [root@server ~]# fdisk -l | grep 'Linux raid autodetect'
        /dev/sdb1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdc1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdd1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sde1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdf1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdg1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdh1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdi1               1        1044     8385898+  fd  Linux raid autodetect
        /dev/sdj1               1        1044     8385898+  fd  Linux raid autodetect
以上操作确保把每个盘分区,再设置为FD的磁盘.
}

mdadm(创建新的阵列)
{
用sdb1,sdc1创建RAID0
        mdadm --create /dev/md0 --level=0 --chunk=32 --raid-devices=2 /dev/sd[bc]1
        选项解释:
                --level=,-l:指定raid的级别,可选的值为0,1,4,5,6,linear,multipath和synonyms
                --chunk=,-c:指定条带数据块的大小,以K为单位.默认为64K,条带单元的大小配置对不同负载的阵列读写性能有很大影响
                --raid-devices=,-n:指定活动磁盘的数量
        以上命令也可写作:mdadm -C /dev/md0 -l0 -c32 -n2 /dev/sdb[bc]1
用sdd1,sde1,sdf1创建RAID1
        mdadm --create /dev/md1 --level=1 --raid-devices=2 --spare-devices=1 /dev/sd[d-f]1
        选项解释:
                --spare-devices=,-x:表示阵列中热备盘的个数,一旦阵列中的某个磁盘失效,MD内核驱动程序自动用将热备磁盘加入到阵列,然后重构丢失磁盘上的数据到热备磁盘上.
        以上命令也可写作:mdadm -C /dev/md1 -l1 -n2 -x1 /dev/sd[d-f]1
用sdg1,sdh1,sdi1,sdj1创建RAID5
        mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/sd[g-i]1 --spare-devices=1 /dev/sdj1
        以上命令也可写作:mdadm -C /dev/md2 -l5 -n3 /dev/sd[g-i]1 -x1 /dev/sdj1
此外还可以参考如下命令,创建一个RAID1+0设备
        mdadm -C /dev/md0 -l1 -n2 /dev/sd[bc]1
        mdadm -C /dev/md1 -l1 -n2 /dev/sd[de]1
        mdadm -C /dev/md2 -l1 -n2 /dev/sd[fg]1
        mdadm -C /dev/md3 -l0 -n3 /dev/md[0-2]
当RAID1/4/5/6/10等创建成功后,需要计算每个条带的校验和信息并写入到相应磁盘上,使用cat /proc/mdstat信息查询RAID阵列当前状态,重构的速度和预期的完成时间.
        [root@server ~]# cat /proc/mdstat
        Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
        md2 : active raid5 sdi1[4] sdj1[3](S) sdh1[1] sdg1[0]
              16771584 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
              [>....................]  recovery =  1.9% (167760/8385792) finish=9.7min speed=13980K/sec
        
        md1 : active raid1 sdf1[2](S) sde1[1] sdd1[0]
              8385792 blocks [2/2] [UU]
        
        md0 : active raid0 sdc1[1] sdb1[0]
              16771584 blocks 32k chunks
        
        unused devices: <none>
}
 
mdadm(管理阵列)
{
mdadm可以在manage模式下,对阵列进行管理.最常用的操作是标识损坏的磁盘,增加热备磁盘,以及从阵列中移走失效的磁盘等等.
使用--fail(或者其缩写-f)指定磁盘损坏.
        [root@server ~]# cat /proc/mdstat
        Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
        md2 : active raid5 sdj1[3](S) sdi1[2] sdh1[1] sdg1[0]
              16771584 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
        [root@server ~]# mdadm /dev/md2 --fail /dev/sdh1
       mdadm: set /dev/sdh1 faulty in /dev/md2
       [root@server ~]# cat /proc/mdstat
       Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
       md2 : active raid5 sdj1[3] sdi1[2] sdh1[4](F) sdg1[0]
             16771584 blocks level 5, 64k chunk, algorithm 2 [3/2] [U_U]
             [>....................]  recovery =  0.8% (74172/8385792) finish=7.4min speed=18543K/sec
第一次查看状态时,sdj1是热备盘,当我们指定sdh1损坏后,系统自动将数据重构到热备盘sdj1上,在重构过程中,状态是U_U.
用--remove命令可以将损坏的磁盘移走.
         [root@server ~]# mdadm /dev/md2 --remove /dev/sdh1
         mdadm: hot removed /dev/sdh1
此时查看状态时,已经只有三个盘了,没有备用的热备盘.
         [root@server ~]# cat /proc/mdstat
         Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
         md2 : active raid5 sdj1[1] sdi1[2] sdg1[0]
               16771584 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
当我们的损坏的磁盘经过处理后,可以将其添加到阵列中作热备盘.
用--add命令可以添加热备盘.
         [root@server ~]# mdadm /dev/md2 --add /dev/sdh1
         mdadm: added /dev/sdh1
         [root@server ~]# cat /proc/mdstat
         Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
         md2 : active raid5 sdh1[3](S) sdj1[1] sdi1[2] sdg1[0]
               16771584 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
此外还可以用--grow命令增加可用的活动磁盘.
         [root@server ~]#mdadm --grow /dev/md0 --raid-disks=4
}

 
mdadm(使用阵列)
{
新建三个挂载点:
        [root@server ]# mkdir /mnt/MD0
        [root@server ]# mkdir /mnt/MD1
        [root@server ]# mkdir /mnt/MD2
对RAID设备做文件系统格式化:
        [root@server ]# mkfs.ext3 /dev/md0
        [root@server ]# mkfs.ext3 /dev/md1
        [root@server ]# mkfs.ext3 /dev/md2
挂载:
        [root@server ]# mount /dev/md0 /mnt/MD0
        [root@server ]# mount /dev/md1 /mnt/MD1
        [root@server ]# mount /dev/md2 /mnt/MD2
查看效果:
        [root@server ]# df -h
        ......
        /dev/md0               16G  173M   15G   2% /mnt/MD0
        /dev/md1              7.9G  147M  7.4G   2% /mnt/MD1
        /dev/md2               16G  173M   15G   2% /mnt/MD2
现在我们就可以正常使用RAID设备了.
当我们要停止RAID设备时,需要先将其卸载:
        [root@server ~]# umount /mnt/MD0
然后再用如下命令停止设备:
        [root@server ~]# mdadm --stop /dev/md0
        mdadm: stopped /dev/md0
此时再用命令查看发现,已经没有md0了.
        [root@server ~]# cat /proc/mdstat | grep md0
如果需要再次使用则需要将其"组装起来",由于先前曾创建过,mdadm的assemble模式可检查底层设备的元数据信息,然后再组装为活跃的阵列.
        [root@server ~]# mdadm --assemble /dev/md0 /dev/sd[bc]1
        mdadm: /dev/md0 has been started with 2 drives.
        [root@server ~]# cat /proc/mdstat  | grep md0
        md0 : active raid0 sdb1[0] sdc1[1]
这样就又可以重新挂载使用了.
}

mdadm(阵列的元数据应用)
{
Build模式可以用来创建没有元数据的RAID0/1设备,不能创建RAID4/5/6/10等带有冗余级别的MD设备,而create模式建立的RAID设备都是带有元数据的.以使用命令--examine(-E)来检测当前的块设备上是否有阵列的元数据信息.
        [root@server ~]# mdadm -E /dev/sdh1
        /dev/sdh1:
                  Magic : a92b4efc
                Version : 00.90.00
                   UUID : cea9dd57:59f61370:00969939:2ef303d5
          Creation Time : Sun May 17 12:15:50 2009
             Raid Level : raid5
          Used Dev Size : 8385792 (8.00 GiB 8.59 GB)
             Array Size : 16771584 (15.99 GiB 17.17 GB)
           Raid Devices : 3
          Total Devices : 4
        Preferred Minor : 2
        
            Update Time : Sun May 17 13:07:43 2009
                  State : clean
         Active Devices : 3
        Working Devices : 4
         Failed Devices : 0
          Spare Devices : 1
               Checksum : 95f50002 - correct
                 Events : 0.2
        
                 Layout : left-symmetric
             Chunk Size : 64K
        
              Number   Major   Minor   RaidDevice State
        this     1       8      113        1      active sync   /dev/sdh1
        
           0     0       8       97        0      active sync   /dev/sdg1
           1     1       8      113        1      active sync   /dev/sdh1
           2     2       8      129        2      active sync   /dev/sdi1
           3     3       8      145        3      spare   /dev/sdj1
从以上信息可以看到sdg1,sdh1,sdi1和sdj1共同组成了一个raid5设备,sdj1做备份盘,该设备创建于2009 12:15:50,条带数据块大小采用了默认值64k.此外还有一个重要的数据那就是UUID,它是阵列的唯一标识,组成同一阵列的相关磁盘上的UUID是相同的.
可以用以下命令来将具有相同元数据的磁盘重先组装成RAID.
        [root@server ~]# mdadm --assemble -v --uuid=cea9dd57:59f61370:00969939:2ef303d5 /dev/md2 /dev/sd[b-j]1
        mdadm: looking for devices for /dev/md2
        mdadm: /dev/sdb1 has wrong uuid.            --1--
        mdadm: /dev/sdc1 has wrong uuid.
        mdadm: cannot open device /dev/sdd1: Device or resource busy    --2--
        mdadm: /dev/sdd1 has wrong uuid.
        mdadm: cannot open device /dev/sde1: Device or resource busy
        mdadm: /dev/sde1 has wrong uuid.
        mdadm: cannot open device /dev/sdf1: Device or resource busy
        mdadm: /dev/sdf1 has wrong uuid.
        mdadm: /dev/sdg1 is identified as a member of /dev/md2, slot 0.
        mdadm: /dev/sdh1 is identified as a member of /dev/md2, slot 1.
        mdadm: /dev/sdi1 is identified as a member of /dev/md2, slot 2.
        mdadm: /dev/sdj1 is identified as a member of /dev/md2, slot 3.
        mdadm: added /dev/sdh1 to /dev/md2 as 1
        mdadm: added /dev/sdi1 to /dev/md2 as 2
        mdadm: added /dev/sdj1 to /dev/md2 as 3
        mdadm: added /dev/sdg1 to /dev/md2 as 0
        mdadm: /dev/md2 has been started with 3 drives and 1 spare.
--1--,/dev/sdb1与我们命令中的UUID不匹配.
--2--,/dev/sdd1正忙,无法获取到相关UUID.
}

mdadm(RAID的配置文件)
{
在RHEL5的rc.sysinit配置文件中,有这样一段代码:
        if [ -f /etc/mdadm.conf ]; then
            /sbin/mdadm -A -s
        fi 
即:如果RAID的配置文件mdadm.conf存在,则调用mdadm检查配置文件里的选项,然后启动RAID阵列.
所以我们如果要让软RAID的配置在机器下次启动时自动生效的话,得把配置写进配置文件/etc/mdadm.conf,可用下面的命令来完成.
        [root@server ~]# echo DEVICE /dev/sd[b-j]1 > /etc/mdadm.conf
        [root@server ~]# mdadm --detail --scan >> /etc/mdadm.conf
        [root@server ~]# cat /etc/mdadm.conf
        DEVICE /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
        ARRAY /dev/md0 level=raid0 num-devices=2 UUID=8d4ebb05:b74a1b15:de9a89ee:b2b3a642
        ARRAY /dev/md1 level=raid1 num-devices=2 spares=1 UUID=fa205b5a:0bb04eff:279165d9:b39ba52d
        ARRAY /dev/md2 level=raid5 num-devices=3 spares=1 UUID=cea9dd57:59f61370:00969939:2ef303d5
这样我们在下次启动时,RAID就会自动生效了.
}