				业精于勤,荒于嬉;行成于思,毁于随

shell支持三种通配符"*","?","[...]"

Ctrl+Alt+BackSpace				重启X Window
startx							启动图形接口


fsck  参数	装置名称   检查与修正硬盘错误
-t	fsck可以检查好几种不现的filesystem,而fsck只是一支综合程序而已
	个别的filesystem的检验程序都在/sbin底下,可以使用 ls -l /sbin/fsck*检验看看
	指定文件系统名称
-A	依据/etc/fstab的内容,将所有装置都扫描一次(通常开机过程中就会执行此一指令)
-a	自动修复检查到的有问题的扇区,所以不用一直按y
-r	一定要主使用者决定是否需要修复,与上一个-a刚好相反
-y	与-a类似,但某些filesystem仅支持-y
-C	可以在检验的过程中,使用一个长条图来显示进度
-f	强制检查,强制进入细部检查

runlevel    查看当前系统运行级别,第一个n显示是前一个运行级别,后一个是当前的运行级别
0： 关机
1： 单用户
2： 无网络的多用户
3： 命令行模式
4： 未用
5： GUI(图形桌面 模式)
6： 重启
init 数字	切换运行级别

shutdown	参数 	[时间] [警告信息]         //时间参数必须加入,否则会进入单人维护模式,reboot,halt,poweroff
-t sec:-t后面加秒数,即过几秒关机的意思
-k	  :不要真的关机,只是发送警告信息
-r	  :在将系统的服务停掉后重启
-h	  :在将系统的服务停掉后关机
-n	  :不经过init程序,直接以shutdown的功能关机
-f	  :关机并开机之后,强制略过fsck的磁盘检查
-F	  :系统重新开机之后,强制进行fsck的磁盘检查
-c	  :取消已经在进行的shutdown指令内容

chgrp  群组	档案或目录
-R	递归,连同目录下所有档案,目录
chown  用户	档案或目录
-R  递归
chmod  权限	档案或目录
-R  递归

档案种类
-				正规档案,二进制文件(binary),纯文字文件(ASCII),数据格式文件(data)
d(directory)	目录
b(block)		区块设备,就是一些存储数据,以提供系统存取的接口设备,硬盘就是
c(character)	字符设备档,亦即是一些串行端口的接口设备,如键盘、鼠标
l(link)			连结档,亦即是Windows下的快捷方式
s(socket)		资料接口文件,这种类型的档案通常被用在网络上的数据承接,在/var/run这个目录中可以看到这种档案
p(FIFO,pipe)	数据输送文件,主要的目的在解决多个程序同时存取一个档案所造成的错误问题

inode记录的内容
	档案的拥有者与群组
	档案的存取模式
	档案的类型
	档案建立或状态改变的时间,最近一次读取的时间,最近修改的时候
	档案容量
	档案特性旗标,如SetUID
	档案真正内容的指向
	档案的indoe并不记录文件名,文件名记录在目录的Block中
	...
	针对目录,记录该目录的相关属性,并指向分配到的那块Block,而Block则是记录在这个目录下的相关连的档案(或目录)的关连性
	
	当我们要读取一个档案的内容时,我们的 Linux 会先由根目录 / 取得该档案的上层目录所在 inode , 再由该目录所记录的档案关连性 (在该目录所属的 block 区域) 取得该档案的 inode , 最后在经由 inode 内提供的 block 指向,而取得最终的档案内容
	
	Hard Link 只是在目录下新增一个档案的关连数据而已,只是在目录的block区域内新增了一条记录,可能并不会占用inode与block,不能跨fileSystem,不能link目录(因为硬链接目录必须对目录下所有内容都要建立硬链接,并且,如果需要在链接的目录下新增档案时,连带的原目录也得建立硬链接,造成环境复杂度太大)
	Symbolic Link	就是在建立一个独立的档案,这个档案会让数据的读取指向他link的档案内容,一定会占用inode与block
	
dumpe2fs 参数  /dev/sda1	显示磁盘inode table,block group等信息

df	参数  目录或文件名		显示磁盘分区容量和类型,挂载点
-a	列出所有的档案系统,包括系统特有的/proc等档案系统
-k	以KBytes的容量显示各档案系统
-m	以MBytes
-h	以人们较易阅读的GBytes,MBytes,KBytes等格式自行显示
-H	以M=1000K取代M=1024的进位方式
-T	连同该partition的filesystem名称(例如ext3)也列出
-i	不用硬盘容量,而以inode的数量来显示

LVM(Logical Volume Manger)		逻辑卷管理
LVM中基本的概念：PV  VG LV 就是物理卷，卷组，逻辑卷。
PV(Physical volume)： 就是物理设备构成，可以是一个分区，也可以是一个硬盘。
VG(Volume group)：是一个逻辑容器概念，同时包含了PV和LV。PV的数量和大小决定了一个卷组，也就是VG的最终可用物理空间的容量。
LV(Logical volume)：是逻辑概念，LV最为类似之前的分区，为什么？它可以格式化成为文件系统给您来使用。
PE(Physical extent): 硬盘可供指派给逻辑卷的最小单位,通常为4MB
只不过您发现一个问题。之前你是这么用的：分区--> 文件系统现在变成了：分区-->PV--VG---LV--文件系统

pvcreate  /dev/设备			将设备或分区格式化为物理卷
pvdisplay					显示pv详细信息,pvs查看当前pv信息
vgcreate	卷组名  /dev/设备名...	将设备加入到卷组
vgscan						显示系统中存在的lvm卷组
vgextend	卷组名	/dev/设备名		将新的PV加入到一个vg中
vgreduce					将一个pv从指定卷组中删除
vgdisplay					显示vg详细信息,vgs查看当前vg信息
lvcreate					基于vg创建lv逻辑卷
	-n	名称				指定逻辑卷名称
	-L	size				指定逻辑卷大小,单位为“kKmMgGtT”；
lvextend	逻辑卷名 /dev/设备名 扩充逻辑卷大小,也可以指定大小扩充
lvreduce					减小逻辑卷大小,必须卸载掉逻辑卷才可进行,缩小逻辑卷必须先缩小文件系统,可以使用resize2fs 命令
resize2fs 	逻辑卷名		更新文件系统,后面接的名称是虚拟的lv名称,不是实际的sda,sdb这种名称,只支持ext2,ext3,ext4文件系统,增大和缩小都可以
xfs_growfs	逻辑卷名		xfs文件系统使用此命令更新,不是使用resize2fs,只支持xfs,只支持扩大
lvdisplay					显示lv详细信息,lvs查看当前lv信息
lvremove	名称			删除逻辑卷
vgremove	名称			删除卷组
pvremove	名称			删除物理卷

du	参数  目录或文件名
-a	列出所有的档案与目录容量,因为预设仅统计目录底下的档案量而已
-h	以人们较易读的容量格式(G/M)显示
-s	列出总量而已,而不列出每个各别的目录战胜容量
-k	以KBytes列出容量显示
-m	以MBytes

ln  参数  来源文件  目标文件(注意,2个文件都使用绝对路径,防止出现符号链接过多的错误)
-s	如果ln不加任何参数就进行连结,那就是hard link,-s就是symbolic link
-f	如果目标文件存在时,就主动的将目标文件直接移除后再建立

fdisk  参数	 装置名称    分割磁盘
-l	输出后面接的装置所有的partition内容,若仅有fdisk -l时,则系统会把整个系统内能够搜寻到的装置的partition均列出来

parted	用于对磁盘(或RAID磁盘)进行分区及管理，与fdisk分区工具相比，支持2TB以上的磁盘分区，并且允许调整分区的大小

partprobe	将磁盘分区表变化信息通知内核，请求操作系统重新加载分区表。
-d 不更新内核
-s 显示磁盘分区汇总信息
-h 显示帮助信息
-v 显示版本信息

mke2fs  参数  装置名称
-b	可以设定每个block的大小,目前支持1024,2048,4096 bytes三种
-i	多少容量给一个inode
-c	检查磁盘错误,仅下达一次-c时,会进行快速读取测试
	如果下达再次-c -c时,会进行读取测试,会很慢
-L	可以接表头名称(Label)
-j	本来mke2fs建立的是EXT2,加上-J后会主动加入journal而成为EXT3

mkfs	make fileSystem		在特定的分区建立文件系统
例:	mkfs.ext4 /dev/sda1
	mkswap    /dev/sda2		建立swap分区,swapon /dev/sda2开启swap分区

mount	参数  装置名称代号  挂载点
-a	依照/etc/fstab的内容将所有相关的磁盘都挂上来
-n	一般来说,当我们挂载档案系统到Linux上头时,Linux会主动将目前的partition与filesystem还有对应的挂载点,都记录到/etc/mtab档案中,不过有些时刻(例如不正常关机导致一些问题,而进入单人维护模式)系统
-L	取表头名称,可以用来挂载
-t	指定挂载的系统类型(如ext3,ext2),例: mount -o nolock,rw,soft,timeo=30,retry=3,vers=3 -t nfs 10.112.69.106:/home/hells/armDisk /home/panwenjian/remoteDisk  如果挂载不上,可以使用-o vers=3,表示指定使用nfs版本3
mount -t cifs -o username=panwenjian //10.16.137.15/daofengpk1 /home/hells/daofengpk1		挂载windows共享目录
--bind	将某个目录挂到另一个目录下面
-o	额外参数
	async/sync		异步/同步
	auto/noauto		开机是否自动挂载
	rw/ro			只写/只读
	exec/noexec		限制在此档案系统内是否可以进行[执行]的工作
	user/nouser		是否允许使用者使用mount指令来挂载
	suid/nosuid		该档案系统是否允许suid存在
	usrquota		是否支持硬盘配额模式
	grpquota		是否支持群组硬盘配额模式
	defaults		同时具有rw,suid,dev,exec,auto,nouser,async等参数
umount	装置或挂载点	卸载
/etc/fstab			开机时按照这个文件里的内容可以自动挂载
/etc/mtab /proc/mounts	实际filesystem的挂载记录
partition id为82的是swap文件,mkswap /dev/sd[a-d][1-16],再启动,swapon /dev/sd[a-d][1-16]   swapoff 关闭虚拟内存

chroot  目录		将指定的目录作为根目录来运行

nfs服务		
	portmap在centos6以后改名为rpcbind
exportfs 
	-a				全部mount或者umount /etc/exports中的内容
	-r				重新mount /etc/exports中分享出来的目录
	-u				umount目录
	-v				在export的时候,将详细的信息输出到屏幕上
	
nfsstat				列出nfs客户端和服务端的工作状态
-s					仅列出服务端
-c					仅列出客户端
-n					仅列出nfs状态,默认显示客户端和服务端
-2					仅列出nfs版本2的状态
-3					仅列出nfs版本3的状态
-4					仅列出nfs版本4的状态
-m					打印已加载的nfs文件系统状态,用在客户端
-r					仅打印rpc状态


showmount			显示关于 NFS 服务器文件系统挂载的信息
-a					以host:dir这样的格式来显示客户机名和挂载点目录
-d					仅显示被客户挂载的目录名
-e					ip 显示NFS服务器的输出清单(要扫描某一台主机的导出信息时,可以使用此命令,也可以在nfs服务器上查看)
-h					显示帮助信息
-v					显示版本信息

e2label	 装置名称  新的label名称

tune2fs  参数	装置代号
-j	将ext2的filesystem转换为ext3的档案系统
-l	类似dumpe2fs -h的功能～将superblock内的数据读出来
-L	类似e2label的功能,可以修改filesystem的Label

hdparm	参数	装置名称
-d	-d1启用dma模式
	-d0关闭dma模式

cd		变换目录
cd -	回到前一个目录
pwd		显示目前的目录
-P	显示确实的路径,而非连续的路径
mkdir	建立一个新的目录
-m	设定档案的权限,不需要看预设权限(umask)
-p	直接将所需要的目录递归建立起来
rmdir	删除一个空的目录
-p	连同上层[空的]目录一起删除
ls	参数	目录名称
-a	全部的档案,连同隐藏档
-A	全部的档案,但不包括.与..这两个目录
-d	仅列出目录本身,而不是列出目录内的档案数据
-f	直接列出结果,而不进行排序(ls预设会以档名排序)
-F	根据档案、目录等信息,给予附加数据结构,如
	*	可执行档
	/	代表目录
	＝	代表socket档案
-h	将档案容量以人较易阅读的方式列出来
-i	列出inode位置,而非列出档案属性
-l	长数据串行出,包含档案的属性等数据
-n	列出UID与GID而非使用者与群组名称
-r	将排序结果反射输出
-R	连同子目录内容一起列出来
-S	以档案容量大小排序
-t	依时间排序
--color=never	不要依据档案特性给予颜色显示
--color=auto	让系统自行依据设定来判断是否给予颜色显示
--color=always	显示颜色
--full-time		以完整时间模式(包含年、月、日、时、分)输出
--time={atime,ctime}	输出access时间或改变权限属性时间(ctime),而非内容改变时间

cp	参数  来源档  目的档	拷贝档案或目录
-a	相当于-pdr的意思
-d	若来源文件为连结文件的属性,则复制连结文件属性而非档案本身
-f	为强制的意思,若有重复或其它疑问,不会询问使用者,而强制复制
-i	若目的档已经存在时,在覆盖时会先询问是否真的动作
-l	进行硬式连结(hard link)的连结档建立,而非复制档案本身
-p	连同档案的属性一起复制进去,而非使用预设属性
-r	递归持续复制,用于目录的复制行为
-s	复制成为符号连结文件(symbolic link)
-u	若目的档比来源档旧才更新

rm	参数  档案或目录	删除档案或目录
-f	强制
-i	互动模式,询问是否动作
-r	递归删除

mv	参数  来源	目的		移动档案或目录,或更名
-f	强制
-i	若目标档案已经存在时,就会询问是否覆盖
-u	若目标档案已经存在时,且来源比较新,才会更新(update)

basename  路径
取得最后的名字
dirname	  路径
取得除最后的名字外的其他

cat		由第一行开始显示档案内容
-A	相当于-vET
-E	将结尾的断行字符$显示出来
-n	打印行号
-T	将tab键以^I显示出来
-v	列出一些看不出来的特殊字符
tac		由最后一行开始显示
nl		显示的时候,顺道输出行号
-b	指定行号指定的方式,主要有两种
	-b a 表示不论是否为空行,也同样列出行号
	-b t 如果有空行,空的那一行不要列出行号
-n	列出行号表示的方法,主要有三种
	-n ln 行号在屏幕的最左方显示
	-n rn 行号在自己字段的最右方显示,且不加0
	-n rz 行号在自己字段的最右方显示,且加0
-w	行号字段的占用的位数
more	一页一页的显示档案内容
less	与more类似,但是比more更好,可以往前翻页
head -n	只看头几行
tail -n	只看尾几行  -f  实时更新读取的文件,常用来看日志
od		以二进制的方式读取档案内容
-t	后面可以接各种类型
	a	利用预设的字符来输出
	c	使用ASCII字符来输出
	d[size]	利用十进制来输出,每个占用size bytes
	f[size]	利用浮点数
	o[size]	利用八进制
	x[size]	利用十六进制

touch	修改档案时间与建置新档
-a	仅修订access time
-c	仅修改时间,而不建立档案
-d	后面可以接日期,也可以使用--date="日期或时间"
-m	仅修改mtime
-t	后面可以接时间,格式为[YYMMDDhhmm]
touch  {1..5}.sh	可以建立5个文件,1.sh..5.sh

umask	目前使用者在建立档案或目录时候的属性默认值,设置的是权限的补码  若想永久有效,必须去修改~/.bashrc或/etc/bashrc
-S	以r,w,x显示
直接接数字就可以更改预设权限(创建文件是以666形式减去补码,创建目录则是777减去补码)

chattr	参数  档案或目录名称	设定档案隐藏属性
+	增加某一个特殊参数,其他原本存在参数则不动
-	移除某一个特殊参数,其它原本存在参数则不动
=	设定一定,且仅有反而接的参数
A	当设定了A这个属性后,这个档案(或目录)的存取时间atime将不可被修改
S	这个功能有点类似sync的功能!就是会将数据同步写入磁盘当中,可以有效的避免数据流失
a	当设定a之后,这个档案只能增加数据,而不能删除,只有root才能设定这个属性	
c	这个属性设定之后,将会自动的将此档案压缩,在读取的时候将会自动解压缩,但是在存储的时候会先压缩再存储(对大档案很有用)
d	当dump(备份)程序被执行的时候,设定d属性将可使该档案(或目录)不具有dump功能
i	可以让一个档案(不能被删除、改名、设定连续也无法写入或新增资料),对于系统安全性有相当大的帮助
j	当使用ext3这个档案系统格式时,设定j属性将会使档案在写入时先记录在jouranl中!但是当filesystem设定参数为data=journalled时,由于系统已经设定了日志,所以这个属性无效
s	当档案设定了s参数时,他将会被完全的移除出这个硬盘
u	与s相反,当使用u来设定档案时,则数据内容其实还存在硬盘中,可以使用undeletion
lsattr	参数  档案或目录名称
-a	将隐藏文件的属性也显示出来
-R	连同子目录的数据也一并列出来

档案的特殊权限,分别是4,2,1的权限,例 chmod 2770 最前面的2代表了SGID的权限
SUID Set UID		仅可以用在binary file,不能够用在批次档,让一般使用者在执行某些程序的时候,能够暂时的具有该程序拥有者的权限 s
SGID Set GID		若用在binary file上,则不论使用者是谁,在执行该程序时,他的有效群组将会变成该程序的群组所有人,若设定在目录上,则在该目录内所建立的档案或目录的group会变成此A目录的group s
SBIT Sticky Bit	    目前只针对目录有效,对于档案已经没有效果了,在具有SBit的目录下,使用者若在该目录下具有w及x的权限,则当使用者在该目录下建立档案或目录时,只有档案拥有者与root才有权力删除 t

file	档案	查阅档案的类型

who		显示已经登录的用户,还有ip等

whoami	显示当前有效用户

which  参数	command  寻找执行档     在PATH中查找
-a	将所有可以找到的指令均列出,而不止第一个被找到的指令

whereis	参数	档案或目录名  寻找特定档案		在PATH中查找
-b	只找binary的档案
-m	只找在说明文件manual路径下的档案
-s	只找source来源档案
-u	没有说明档的档案

locate	档案或目录名	在数据库中查找  updatedb 更新数据库

find  路径 参数 要查找的文件或目录名	
	-atime n:n为数字,意义在n天之前的[一天之内]被access过的档案 +1表示1天以前,-1表示1天以内,不带加减表示正好n天,time默认是天
	-ctime n:被change过状态的档案,-cmin 分钟,是在写入文件、更改所有者、权限或链接设置时随Inode的内容更改而更改的时间。因此对于文件，mtime发生改变，ctime也会随之改变。
	-mtime n:被modefication过的档案
	-new file:file为一个存在的档案,意思是说,只要档案比file还要新,就会被列出来
	-uid n:n为数字,这个数字是使用者的账号ID,亦即UID,这个UID是记录在/etc/passwd里的
	-gid n:
	-user name:账号名称
	-group name:群组名称
	-nouser:寻找档案的拥有者不存在/etc/passwd的人
	-nogroup:寻找档案的拥有群组不存在/etc/group的档案
	-name file:搜寻名称为filename的档案
	-size [+-]SIZE:搜寻比SIZE还要大(+)或小(-)的档案,c代表byte
	-type TYPE:搜寻档案的类型为TYPE的,类型主要有:一般正规档案(f),装置档案(b,c),目录(d),连结档(l),socket(s),及FIFO(p)等属性
	-perm mode:搜寻档案属性[刚好等于]mode的档案,四位数的属性
	-perm -mode:搜寻档案属性[必须要全部囊括mode的属性]的档案
	-perm +mode:搜寻档案属性[包含任一mode的属性]
	-exec command:command为其它指令,-exec后面可再接额外的指令来处理搜寻到的结果
	-print 将结果打印到屏幕,这个动作是预设的
	-newer	file :比file新的文件就列出
	-path	"pattern" :匹配完整文件名,包括./
	-path 	"pattern"  -prune :除掉某个目录

xargs 	管道实现的是将前面的stdout作为后面的stdin,但有些命令不接受管道的传递方式,如ls,有时,希望传递是参数,直接用管道无法传递到命令的参数位,这时需要xargs,xargs实现的是将管道传输过来的stdin进行处理后传递到命令的参数位上
		也就是说,xargs实现了2个行为,处理管道传输过来的stdin;将处理后的传递到正确的参数位上
		会将所有空格,制表符,换行符替换为空格
		处理顺序: 先分割,再分批,然后传递到参数位
分割:
	独立的xargs
	-d		-d与-o可以配合起来使用,指定分割符,是单个字符, xargs -0是xargs -d的一种,等价于xargs -d'\0'
		替换：将接收stdin的所有的标记意义的符号替换为\n，替换完成后所有的符号(空格、制表符、分行符)变成字面意义上的普通符号，即文本意义的符号。
		分段：根据-d指定的分隔符进行分段并用空格分开每段，由于分段前所有符号都是普通字面意义上的符号，所以有的分段中可能包含了空格、制表符、分行符。也就是说除了-d导致的分段空格，其余所有的符号都是分段中的一部分。
		输出：最后根据指定的分批选项来输出。这里需要注意，分段前后有特殊符号时会完全按照符号输出。
	-o
分批:
	从逻辑上来说是-n与-L,但当指定了传递阶段选项-i后,会忽略-n与-L
	-n		num		按空格分段,不管是文本意义上的还是标记意义上的,也就是说,如"ont Imag"的文件名会被分为2个
	-L/-i  	num		按段划批,文本意义的符号不被处理,如"ont Img"的文件就不会被分为2个文件名
	
	-p		交互询问式,每次输入y或Y才会执行
	-t		每次执行前会打印命令(是在stderror上)
传递:
	-i		如果不使用-i,则默认是将分割后处理后的结果整体传递到命令的最尾部,但有时需要传递多个位置,使用xargs -i与大括号{}作为替换号,传递的时候看到{}就将被结果替换
	-I		和-i一样,只是-i默认使用大括号作为替换符,-I则可以指定其他符号,必须用引号括起来,如xargs -I {} cp ../tmp/{}  tmp
	
  
compress  参数	档案或目录  .Z
-d(uncompress)	解压缩 
-r  可以连同目录下的档案也同时给予压缩
-c	将压缩数据输出成为到屏幕
gzip,zcat	参数	档名	zcat:可以将压缩档案的内容读出来 .gz  .z
-c	将压缩的数据输出到屏幕上,可透过数据流重导向来处理
-d	解压缩
-t	可以用来检验一个压缩档的一致性,看看档案有无错误
-r	递归压缩
-#  压缩等级,-1最快,但是压缩比最差,-9最慢,但是压缩比最好,预设是6
bzip2,bzcat  参数  档名   .bz2 .bz  .tbz  .tbz2
-c	将压缩的过程产生的数据输出到屏幕上
-d	解压缩的参数
-z	压缩的参数
-#	同上
unzip	-d	解压
xz	参数  档名	.xz
	-d	解压缩
	-z	压缩
tar  参数	档案与目录(不能打包超过8G的文件,pax可以)
-C  改变工作目录
-c	建立一个压缩档案
-x  解开一个压缩档案
-t	查看tarfile里面的档案
-z	是否同时具有gzip的属性
-j	是否同时具有bzip2的属性
-J	是否同时具有xz的属性
-v	压缩的过程中显示档案
-f	使用档名
-p	使用原档案的原来属性
-P	可使用绝对路径来压缩
-N	比后面接的日期(yyyy/mm/dd)还要新的才会被打包进新建的档案中
--exclude	文件或目录名	压缩时不加这个档案
--strip-components N		去队N层顶层目录
 
unrar		解压rar文件格式
	x		解压缩,x前面不用添加-

dd	if=输入		of=输出		bs=block_size	 count=number			转换和拷贝文件
if	也可以是装置
of	也可以是装置
bs	规划的一个block的大小,如果没有设定时,预设是512bytes
count  多少个bs的意思

dos2unix [-kn]	file [newfile]
unix2dow [-kn]	file [nesfile]
-k	保留该档案原本的mtime格式
-n	保留原本的旧档,将转换后的内容输出到新档案

/etc/shells		记录系统可以用的shell

type [-tpa] name
:	不加任何参数时,则type会显示出那个name是外部指令还是bash内建的指令
-t	当加入-t参数时,type会将name以底下这些字眼显示出他的意义
	file : 外部指令
	alias: 该指令为命令别名设定的名称
	builtin: 该指令为bash内建指令
-P  如果后面接的name为指令时,会显示完整文件名(外部指令)或显示为内建指令
-a	会将由PATH变量定义的路径中,将所有含有name的指令都列出来,包括alias

echo 显示变量内容,变量名称前加$,双引号内的特殊字符可以保有变量特性,单绰号内的特殊字符仅为一般字符,\跳脱字符,也可${变量名}
 -e	 可以对转义字符做出解释,否则仅当一般字符处理
 -n	 不输出行尾的换行符

unset 变量名称  取消变量
$RANDOM 随机数变量
$	本shell的pid
?	上个指令的回传码	用$?可显示,成功返回0,失败返回非0
export 变量	将自定义变量转换成环境变量
set命令用法(使用echo $-可查看set设定的flag)
-a 　标示已修改的变量,以供输出至环境变量。
-b 　使被中止的后台程序立刻回报执行状态。
-C 　转向所产生的文件无法覆盖已存在的文件。
-d 　Shell预设会用杂凑表记忆使用过的指令,以加速指令的执行。使用-d参数可取消。
-e 　若指令传回值不等于0,则立即退出shell。
-f　 　取消使用通配符。
-h 　自动记录函数的所在位置。
-H Shell 　可利用"!"加<指令编号>的方式来执行history中记录的指令。
-k 　指令所给的参数都会被视为此指令的环境变量。
-l 　记录for循环的变量名称。
-m 　使用监视模式。
-n 　只读取指令,而不实际执行。
-p 　启动优先顺序模式。
-P 　启动-P参数后,执行指令时,会以实际的文件或目录来取代符号连接。
-t 　执行完随后的指令,即退出shell。
-u 　当执行时使用到未定义过的变量,则显示错误信息。
-v 　显示shell所读取的输入值。
-x 　执行指令后,会先显示该指令及所下的参数。
+<参数> 　取消某个set曾启动的参数。

set 用来显示本地变量
env 用来显示环境变量
export 用来显示和设置环境变量

set命令显示当前shell的变量,包括当前用户的变量;
env命令显示当前用户的变量;
export命令显示当前导出成用户变量的shell变量。

ulimit  [-SHacdflmnpstuv]  配额	限制使用者的某些系统资源,永久修改可以修改/etc/security/limits.conf
-H	hard limit,严格的设定,必定不能超过设定的值
-S	soft limit,警告的设定,可以超过这个设定值,但是会有警告讯息,并且,还是无法超过hard limit
-a	列出所有的限制额度
-c	可建立的最大核心档案容量,unlimited表示不限制
-d	程序数据可使用的最大容量
-f	些shell可以建立的最大档案容量,单位为kbytes
-l	可用于锁定的内存量
-p	可用以管线处理的数量
-t	可使用的最大CPU时间(单位为秒)
-u	单一使用者可以使用的最大程序数量
-n	每个进程可以同时打开的最大文件数,如http服务器并发数可以看这个

alias ls='ls -l'	设定命令别名
unlias ls			取消命令别名

history [n]
n	数字,意思是列出最近n笔命令的意思
-c	将目前的shell中的所有history内容全部删除
-a	将目前新增的history指令新增入histfiles中,若没有histfiles,则预设写入~/.bash_history
-r	将histfiles的内容读到目前这个shell的history记忆中
-w	将目前的history记忆内容写入histfiles中
!number	执行第几笔指令
!!		执行上一个指令

/etc/issue	终端机登机的提示信息
\d	本地端时间的日期
\l	显示第几个终端接口
\m	显示硬件的等级(i386/i486/i586...)
\n	显示主机的网络名称
\o	显示domain name
\r  操作系统的版本(相当于uname -r)
\t	显示本地端时间的时间
\s	操作系统的名称
\v	操作系统的版本
/etc/issue.net	显示给telnet登录的提示信息
/etc/motd	里面的字符会在登录时显示在终端上,如果想要让大家都知道,可以写在这个文件里

/etc/profile	设定了几个重要的变量,例如PATH USER MAIL HOSTNAME等等,这个档案也规划出/etc/profile.d及/etc/inputrc这两个目录与档案
/etc/bashrc	这个档案规划出umask的功能,也同时规划出提示字符的内容(PS1)
/etc/profile.d/*.sh  是一个目录,里面针对bash及C_shell规划了一些数据
/etc/man.config	规范了使用man的时候,man page的路径去哪里寻找

/etc/profile,~/.bash_profile,~/.bash_login,~/.profile
这三个档案通常只要一个就够了,一般预设是以~/.bash_profile的档名存在,这个档案可以定义个人化的路径(PATH)与环境变量等,bash启动时,会先去读取~/.bash_profile,找不到时,就去读取~/.bash_login,然后才是~/.profile

~/.bashrc	个人化设定值一般写在这,这个档案每次执行shell script的时候都会被重新使用一遍,所以是最完整的,而上面的~/.bash_profile则只有在登入的时候会被读取一次

~/.bash_history	历史命令记录的档案

～/.bash_logout	这个档案记录了当我注销后bash后,系统再帮我做完什么动作后才离开

export PS1='[\u@\h \W]\$'
	\d     ：可显示出『星期 月 日』的日期格式，如："Mon Feb 2"
 	\H    ：完整的主机名。举例来说，鸟哥的练习机为『www.vbird.tsai』
 	\h    ：仅取主机名在第一个小数点之前的名字，如鸟哥主机则为『www』后面省略
 	\t     ：显示时间，为 24 小时格式的『HH:MM:SS』
 	\T    ：显示时间，为 12 小时格式的『HH:MM:SS』
 	\A    ：显示时间，为 24 小时格式的『HH:MM』
 	\@  ：显示时间，为 12 小时格式的『am/pm』样式
 	\u    ：目前使用者的账号名称，如『root』；
 	\v    ：BASH 的版本信息，如鸟哥的测试主板本为 3.2.25(1)，仅取『3.2』显示
 	\w   ：完整的工作目录名称，由根目录写起的目录名称。但家目录会以 ~ 取代；
 	\W  ：利用 basename 凼数取得工作目录名称，所以仅会列出最后一个目录名。
 	\#   ：下达的第几个指令。
 	\$   ：提示字符，如果是 root 时，提示字符为 # ，否则就是 $ 啰～

hostname		查看当前主机名
hostnamectl		允许查看或修改与主机名相关的配置
	静态(static)的主机名:			也称内核主机名,是系统在启动时从/etc/hostname初始化的主机名
	瞬态的(transient)的主机名:		是系统在运行时临时分配的主机名,例如通过dhcp或mDNS服务器分配
	灵活的(pretty)的主机名:			静态和瞬态主机名都遵从作为互联网名同样的命名规则,灵活主机名则允许使用自由形式(包括特殊,空白字符)
	set-hostname <host-name> 		同时修改3个名字

source 或小数点 文件名可以立即加载设定文件

stty -a		列出所有终端设置	
eof		end of file 结束输入的意思
erase	向后删除字符
intr	送出一个interrupt(中断)的讯号给目前正在run的程序
kill	删除在目前指令列上的所有文字
quit	送出五个quit的讯号给目前正在run的程序
start	在某个程序停止后,重新启动他的output
stop	停止目前屏幕的输出
susp	送出一个terminal stop的讯号给正在run的程序
^?		代表backspace键
stty SETTING CHAR   SETTING为上面列出的种种,CHAR为快捷键,例
stty erase ^h	改为用ctrl+h来删除
stty -echo     关闭回显
stty echo	   打开回显



# 标准输入(stdin)			代码为0,使用<或<<    <简单来说就是将原本需要由键盘输入的数据,经由档案来读入,<<代表结束的输入字符 例cat > catfile <<eof输入eof结束
标准输出(stdout)		代码为1,使用>或>>
标准错误输出(stderr)	代码为2,使用2>或2>>       /dev/null	类似一个垃圾桶,任何东西放入这个档案就会消失不见
要将标准输出与标准错误输出写入同一个文件  2>&1	而不能用 2>同一个文件

&&		代表前一个命令没有错误就执行下一个命令
||		代表前一个命令有错误才执行下一个命令
|		管线命令,仅能处理前一个命令传来的正确的信息,也就是stdout

cut -d '分隔字符' -f number1,number2    以行为处理单位,取出一行的部分,默认是用tab作分隔符,若要用空格,使用-d ' '
cut -c num1-num2	取出第num1和num2间的字符
-d 后面接分隔字符,与-f一起使用
-f	依据-d的分隔字符将一段信息分割成数段,用-f取出第几段的意思
-n	不将多字节字符拆开
-c	以字符的单位取出固定字符区间
-b	提取哪个字节

grep -acinv '搜寻字符串' filename
	-q  安静,不向标准输出写任何东西,如果找到任何匹配的内容就立即以0即出,即使检测到了错误
	-w  只选择含有能组成完整的词的匹配行,判断方法是匹配的字符串必须是一行的开始,或者是在一个不可能是词的组成的字符之后,与此相似,它必须是一行的结束,或者是在一个不可能是词的组成的字符之前,词的组成是字母,数字,下划线
	-o	只将匹配到的部分显示出来,而非整一行
	-a	将binary档案以text档案的方式搜寻数据
	-c	计算找到'搜寻字符串'的次数
	-i	忽略大小写的不同,所以大小写视为相同
	-n	顺便输出行号
	-v	反向选择,亦即显示出没有'搜寻字符串'内容的那一行
	-l  只显示匹配的文件名
	-L	只显示不匹配文件内容的文件名
	-F  将搜寻字符串里的所有内容都当做正常字符来搜索,而非正则表达式
	-A	显示后几行		--after-context
	-B  显示前几行		--before-context
	-C  显示上下几行	--context
	-R	递归搜索
grep 指令后不跟任何参数,则表示要使用 "BREs" (basic regular expression)
grep 指令后跟 "-E" 参数,则表示要使用 "EREs" (extended regular expression)
grep 指令后跟 "-P" 参数,则表示要使用 "PREs"  (perl regular expression)	

rename [ -v ] [ -s ] perexpr perlexpr [ files ]
第一个参数：被替换掉的字符串
第二个参数：替换成的字符串
第三个参数：匹配要替换的文件模式
-v 	不真正地替换,只是预览要被替换的文件名
-s	在符号链接上执行

ack  '搜寻字符串'  filename				默认是递归搜索的
-w			搜索单词
--cpp		只搜索c++文件,可推导出--java,--python等
-Q			搜录字符串原样搜取,不当作正则表达式的特殊字符等
 --ignore-dir=downloads			忽略downloads目录

sort  -fbMnrtuk  file or stdin
	-f	忽略大小写的差异,例如A与a视为编码相同
	-b	忽略最前面的空格符部分
	-M	以月份的名字来排序,例如JAN,DEC等等的排序方法
	-n	使用纯数字进行排序(预设是以文字开型态来排序的
	-r	反向排序
	-u	就是uniq,相同的数据中,仅出现一行代表
	-t	分隔符,预设是tab键
	-k	以那个区间(field)来进行排序的意思
	-o  文件名   输出到指定文件

uniq  -ic	排序完成后,对重复资料仅列出一个显示
	-i	忽略大小写字符的不同
	-c	进行计算

wc -lwm
	-l	仅列出行
	-w	仅列出多少字(英文单字)
	-m	多少字符

tee	-a file		双向重导向
	-a	以累加的方式将数据加入file中
	如	last | tee last.list 屏幕上也会有一份显示

tr  -ds  SET1   可以用来删除一段讯息当中的文字,默认是替换
	-d	删除讯息当中的SET1这个字符串
	-s	取代掉重复的字符

col -x
	-x	将tab键转换成对等的空格键
expand  -t file
	-t 后面可以接数字,一般来说,一个tab按键可以用8个空格键取代。我们可以自定义一个tab按键代表多少个字符

join	-ti12  file1 file2
	-t	join预设以空格符分隔数据,并且对比第一个字段的数据,如果两个档案相同,刚将两笔数据联成一行,且第一个字段放在第一个
	-i	忽略大小写
	-1	代表第一个档案要用那个字段来分析的意思
	-2	代表第二个档案要用那个字段来分析的意思

paste	-d file1 file2
	-d	后面可以接分隔字符,预设是以tab来分隔的
	-	如果file部分写成-,表示来自standard input

split -bl file PREFIX 将一个大档案分割成几个小档案
	-b	后面可以接欲分割的档案大小,可加单位,例如b,k,m等
	-l	以行数来进行分割

seq	 [-fsw] first last	产生某个数到另外一个数之间的所有整数
	-f --format=格式		使用printf样式的格式
	-s --separator=字符串	使用指定字符串分隔数字(默认使用: \n)
	-w --equal-width		在列前添加0使得宽度相同
	
正则表达法(grep支持 basic)
[]	[]里不论有几个字符,都代表一个
^	在[]里代表非,在[]外代表行首
$	行尾
.	代表绝对有一个任意字符
*	代表重复0个或多个前面的字符,o*代表的是空字符或1个o以上的字符
\{\} 限定连续字符范围,在延伸正则表达式中不需要加'\',如'o\{2\}',重复2个o
						'o\{2,5\}',重复2-5个o
						'o\{2,\}',重复2个以上o
在正规表达式中使用 \( 和 \) 符号括起正规表达式,即可在后面使用\1、\2 等变量来访问 \( 和 \) 中的内容。
						
延伸正则表示法(egrep支持 extended)
+	重复一个或一个以上的前一个字符
?	零个或一个的前一个字符
|	用或的方式找出数个字符串
()	找出群组字符串
	例(xyz)代表包括xyz三个的字符串
{}	限定连续字符范围

perl regular 
零宽度表明匹配的是一个位置,而非表达式        在vi里是通过\@替换了括号实现
(?= 子表达式) 		零宽度正预测先行断言		例子：[a-z]*(？=ing)可以匹配cooking和singing中的“cook”与“sing”
(?<= 子表达式)  	零宽度正回顾后发断言		例子：(?<=abc).*可以匹配abcdefgabc中的defgabc而不是abcdefg
(?! 子表达式)		零宽度负预测先行			例子:(Java)(?!(hello)):匹配java字符串,但是后面不能跟hello
(?<! 子表达式)		零宽度负预测后发			例子:(?<!(java))(hello)匹配hello字符串但是前面不能有java

(?<Word>\w+)		指定组名,后引用使用\k<Word>引用,也可以写成(?'Word'\w+)
(?:exp)				不捕获匹配文件,即不给分组编号
(?#comment)			不对正则表达式产生任何影响,用于提供注释

正则表达式一般是贪婪匹配,例a.*b匹配尽可能多的,aabab会全部匹配,a.*?b会懒惰匹配,尽可能少的,即匹配aab和ab
在限定符(量词)后面加了?即懒惰匹配


\b 
匹配一个单词边界,也就是指单词和空格间的位置(即正则表达式的“匹配”有两种概念,一种是匹配字符,一种是匹配位置,这里的\b就是匹配位置的)例如,“er\b”可以匹配“never”中的“er”,但不能匹配“verb”中的“er”,与vi中的\<,\>一样
\B
匹配非单词边界。“er\B”能匹配“verb”中的“er”,但不能匹配“never”中的“er”。
\cx
匹配由x指明的控制字符。例如,\cM匹配一个Control-M或回车符。x的值必须为A-Z或a-z之一。否则,将c视为一个原义的“c”字符。
\d
匹配一个数字字符。等价于[0-9]。
\D
匹配一个非数字字符。等价于[^0-9]。
\f
匹配一个换页符。等价于\x0c和\cL。
\n
匹配一个换行符。等价于\x0a和\cJ。
\r
匹配一个回车符。等价于\x0d和\cM。
\s
匹配任何不可见字符,包括空格、制表符、换页符等等。等价于[ \f\n\r\t\v]。
\S
匹配任何可见字符。等价于[^ \f\n\r\t\v]。
\t
匹配一个制表符。等价于\x09和\cI。
\v
匹配一个垂直制表符。等价于\x0b和\cK。
\w
匹配包括下划线的任何单词字符。类似但不等价于“[A-Za-z0-9_]”,例如可以匹配俄文字母,这里的"单词"字符使用Unicode字符集。
\W
匹配任何非单词字符。等价于“[^A-Za-z0-9_]”。
\xn
匹配n,其中n为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如,“\x41”匹配“A”。“\x041”则等价于“\x04&1”。正则表达式中可以使用ASCII编码。
\num
匹配num,其中num是一个正整数。对所获取的匹配的引用。例如,“(.)\1”匹配两个连续的相同字符。
\n
标识一个八进制转义值或一个向后引用。如果\n之前至少n个获取的子表达式,则n为向后引用。否则,如果n为八进制数字(0-7),则n为一个八进制转义值。
\nm
标识一个八进制转义值或一个向后引用。如果\nm之前至少有nm个获得子表达式,则nm为向后引用。如果\nm之前至少有n个获取,则n为一个后跟文字m的向后引用。如果前面的条件都不满足,若n和m均为八进制数字(0-7),则\nm将匹配八进制转义值nm。
\nml
如果n为八进制数字(0-7),且m和l均为八进制数字(0-7),则匹配八进制转义值nml。
\un
匹配n,其中n是一个用四个十六进制数字表示的Unicode字符。例如,\u00A9匹配版权符号(&copy;)。
\p{P}
小写 p 是 property 的意思,表示 Unicode 属性,用于 Unicode 正表达式的前缀。中括号内的“P”表示Unicode 字符集七个字符属性之一：标点字符。
其他六个属性：
L：字母；
M：标记符号(一般不会单独出现)；
Z：分隔符(比如空格、换行等)；
S：符号(比如数学符号、货币符号等)；
N：数字(比如阿拉伯数字、罗马数字等)；
C：其他字符。
*注：此语法部分语言不支持,例：javascript。
< >	匹配词(word)的开始(<)和结束(>)。例如正则表达式<the>能够匹配字符串"for the wise"中的"the",但是不能匹配字符串"otherwise"中的"the"。注意：这个元字符不是所有的软件都支持的。
( )	将( 和 ) 之间的表达式定义为“组”(group),并且将匹配这个表达式的字符保存到一个临时区域(一个正则表达式中最多可以保存9个),它们可以用 \1 到\9 的符号来引用。

printf '打印格式' 实际内容	
\a	警告声音输出
\b	退格键
\f	清除屏幕
\n	输出新的一行
\r  亦即Enter按键
\t  水平的tab键
\v	垂直的tab键
\xNN	NN为两位数的数字,可以转换数字成为字符
关于C程序语言内,常见的格式
%ns
%ni
%N.nf

sed  -nefr  动作 (支持BRES,ERES -r)   在sed中引用shell变量sed '' 改为sed ""即可,不支持非懒惰匹配
-i	直接在原文件上操作
-n	使用安静模式,在一般sed的用法中,所有来自STDIN的数据一般都会被列出到屏幕上,但如果加上-n参数后,则只有经过sed特殊处理的那一行(或者动作)才会被列出来
-e	直接在指令列模式上进行sed的动作编辑
-f	直接将sed的动作写在一个档案内,-f filename刚可以执行filename内的sed动作
-r	sed的动作支持的是延伸型正规表示法的语法(预设是基础正规表示语法)
动作说明
	[n1[,n2]]function
	n1,n2不见得会存在,一般代表选择进行动作的行数,如需要在10到20行进行动作,则[10,20[动作行为]]
	function有以下行为 
	a	新增,a的后面可以接字符串,而这些字符串会在新的一行出现(目前的下一行),\可以接多行
	c	取代,c的后面可以接字符串,这些字符串可以取代n1,n2之间的行
	d	删除,因为是删除啊,所以d后面通常不接任何东西
	i	插入,i的后面可以接字符串,而这些字符串会在新的一行出现(目前的上一行)
	p	打印,亦即将某个选择的数据印出,通常p会与参数sed -n一起运作
	s	取代,可以直接进行取代的工作,通常这个s的动作可以搭配正规表示法,例如1,20s/old/new/g就是
	鲜为人知的是:可以在结尾指定数字,只是第n个匹配出现才要被取代:
sed ‘s/Tom/Lisy/2’ < Test.txt   仅匹配第二个Tom
sed 's#10#100#g' example-----不论什么字符,紧跟着s命令的都被认为是新的分隔符,所以,“#”在这里是分隔符,代替了默认的“/”分隔符。表示把所有10替换成100。
	sed指令中 &  表示前面搜索的字符串,可以在替换时使用
sed中使用变量的方法
1.eval sed ’s/$a/$b/’ filename
2.sed "s/$a/$b/" filename
3.sed ’s/’$a’/’$b’/’ filename 
4.sed s/$a/$b/ filename

args	将上一个命令的结果按照小块分段分别传入下一个命令

awk	'条件类型1{动作1}  条件类型2{动作2}...'	filename	处理每一行的字段内的数据,预设的字段分隔符为"空格键"或“[tab]键”(支持ERES),awk中支持c语法
	例last | awk '/pattern/{print $1 "\t" $3}',$1代表第一列,$0代表一行
-F 指定分隔符,可以-F[],指定多个分隔符
-v 定义变量,例vaa="${arr[*]}",arr为shell变量
awk处理流程
	1.读入第一行,并将第一行的资料填入$0,$1,$2...等变量中
	2.依据"条件类型"的限制,判断是否需要进行后面的动作
	3.做完所有的动作与条件类型
	4.若还有后续的行的数据,则重复上面1~3的步骤
awk内建变量
	NF   每一行($0)拥有的字段总数
	NR	 目前awk所处理的是第几行数据
	FS	 目前的分隔字符,预设是空格键
	当改变FS时第一行不会处理,因为先读入第一行后是按照预设的分隔符分隔的,FS还没有起作用
	可以用BEGIN这个关键词
	例	cat /etc/passwd | awk 'BEGIN {FS=":"} $3<10 {print $1 "\t" $3}'
	在{}内有多个动作时可以利用;来分隔,或者直接enter来分隔
	与bash shell的变量不同,在awk当中,变量可以直接使用,不用加上$符号
awk里使用正则表达式
	~		匹配
awk中使用shell变量
1."'$var'"		如果var变量中含有空格,可以使用"'"$var"'"
2.'"$var"'		与第一种类似,如果变量含有空格,可以使用'""$var""'
3.可以使用awk -v
next命令之后的命令都不执行,此行文本处理到此结束,开始读取下一条记录并操作

diff	-bBi	from-file  to-file	对比两个档案的差异,还可以对比两个目录的差异,以行为单位对比
	-c   上下文格式
	-y	 并排格式输出  -W 宽度
from-file	一个档名,作为原始比对档案的档名
to-file		一个档名,作为目的比对档案的档名
-b			忽略一行当中,仅有多个空白的差异(例如"about me"与"about   me"视为相同
-B			忽略空白行的差异
-i			忽略大小写的不同
-r			递归比较子目录
-Naur	old/ new/ test.pach		制作修补档案,升级可以使用
patch	-pN<patch_file
-p			后面接取消几层目录的意思
cmp  -s file1 file2  主要利用位单位去比,所以可以比对二进制档案	
-s			将所有的不同点的位处都列出来,因为cmp预设仅会输出第一个发现的不同点
pr	file	档案打印准备

UID		
	0:			代表这个账号是系统管理员
	1~499:		保留给系统使用的ID,一般来说,1~99会保留给系统预设的账号,另外100~499则保留给一些服务来使用
	500~65535	给一般使用者的

/etc/shadow
	1.账号名称
	2.加密后的密码,如果是*或!,表示这个账号不会被登入
	3.最近更动密码的日期,1970年1月1日为1,每天累加1
	4.密码不可被更动的天数,如果为0表示随时可以更动
	5.密码需要重新变更的天数,如果为99999的话,表示不需要更动密码
	6.密码需要变更前的警告期限
	7.密码过期的恕限时间
	8.账号失效日期,和3一样都是从1970年1月1日到某天的天数
	9.保留,看以后有没有新功能加入
	
/etc/group		记录群组与gid的关系
	1.群组名称
	2.密码,通常不需要
	3.GID
	4.支持的账号名称
	
初始群组:
	/etc/passwd里记录的就是初始群组,一登入系统就会取得这个群组的权限,所以并不用写进/etc/group

groups		查看当前使用者的群组,第一个输出的为有效群组(建立文件或档案时的群组拥有者)
newgrp	群组名称	切换有效群组,离开有效群组输入exit就可以了

/etc/gshadow
	1.群组名称
	2.密码栏
	3.群组管理员的账号
	4.该群组的所属账号

useradd	-u UID -g initial_group -G other_group -Mm -c 说明栏 -d home -s shell username	新增使用者
	-u	UID
	-g	初始GID
	-G	可以支持的群组
	-M	强制,不要建立使用者家目录
	-m	强制,要建立使用者家目录
	-c	这个是/etc/passwd的第五栏的说明内容
	-d	指定某个目录成为家目录,而不使用默认值
	-r	建立一个系统的账号,这个账号的UID会有限制
	-s	后面接一个shell,预设是/bin/bash
	注意
		使用useradd新增使用者时,这个使用者的/etc/shadow密码栏是不可登入的,因此还需要用passwd来给用户一个密码,/etc/default/useradd里的内容是预设内容,使用者家目录/etc/,关于UID和GID的设定会参考/etc/login.defs

passwd	用户名	更改密码
	-l	将这个账号的密码锁住
	-u	将-l的lock解开
	-n	接天数,即/etc/shadow内的第四栏
	-x	第五栏
	-w	第六栏
	-S	显示用户的相关信息
	-d	删除密码,仅有系统管理员可以使用

usermod		参数	用户名		对账户进行一些修改
	-c	后面接账号的说明
	-d	后面接账号的家目录
	-e	后面接日期,格式是YYYY-MM-DD
	-g	后面接group name
	-G	接支持的群组
	-l	后面接账号名称,亦即修改账号名称
	-s	后面接shell的实际档案
	-u	后面接UID数字
	-L	暂时将使用者的密码冻结,让他无法登入
	-U	解冻

userdel	用户名		删除使用者
	-r	连同使用者的家目录一起删除 

chsh	-ls  user
	-l	列出目前系统上面可用的shell
	-s	设定修改自己的shell

chfn	-foph
	-f	后面接完整的名字
	-o	办公室的房间号码
	-p	办公室的电话号码
	-h	家里的电话号码

id	用户名	列出UID,GID....

groupadd  参数
	-g	后面接某个特定的GID
	-r	建立系统群组

groupmod	参数	群组名
	-g	修改既有的GID数字
	-n	修改既有的群组名称

groupdel	群组名	删除群组

su	-lcm	用户名
	-	使用su -时,表示该使用者想变换身份成为root,且使用root的环境设定参数档
	-l	后面可以接使用者,可以使用欲换身份者的环境设定档
	-m	-m与-p是一样的,表示使用目前的环境设定档,而不重新读取新使用者的设定档
	-c	仅进行一次指令,所以-c后面可以加上指令,即执行完命令后恢复原来的身份

sudo	参数	command		/etc/sudoers(使用者的账号(前加%的话代表群组) 登入的主机=(可以变换的身份)可以下达的指令) 例: panwenjian ALL = NOPASSWD: ALL
	-u	后面接使用者账号名称,或者是UID(-u #1000)  
	
sudo su		可以在登录主机时一直保持root状态

write	用户名@终端机编号	发送消息给另一个用户
mesg y/n	打开/关闭write功能
wall  "消息内容"	发送给所有人一个消息(mesg y)
talk 用户名@终端机编号
mail	username@localhost -s "邮件标题" (输入小数点结束)
mail	代表收信

pwck	检查/etc/passwd内的信息与实际的家目录是否存在等信息,还可比对/etc/passwd与/etc/shadow内的信息是否一致
pwconv	将/etc/passwd内的账号与密码移到/etc/shadow内
chpasswd	读入未加密前的密码并经过加密再写入到/etc/shadow内

quota	磁盘限额
	-u	后面可以接username,表示显示出该使用者的quota限值,若不接username表示显示出执行者的quotq限制值
	-g	后面可以接groupname,表示显示出该群组的quota限制值
	-v	显示每人filesystem的quota值
	-s	可选择以inode或磁盘容量的限制值来显示
	-l	仅显示目前本机上面的filesystem的quota值

quotacheck  -avug  /mount_point
	-a	扫描所有在/etc/mtab内,含有quota支持的filesystem,加上此参数后,/mount_point可不必写,因为扫描是扫描所有的filesystem
	-u	仅针对使用者扫描档案与目录的使用情况,会建立aquota.user
	-g	针对群组扫描档案与目录的使用情况,会建立aquota.group
	-v	显示扫描过程的信息
	-M	强制进行quotacheck的扫描

edquota -u username -g groupname
edquota -t	修改恕限时间
edquota -p	username_demo -u username
	-u	后面接账号名称
	-g	后面接群组名称
	-t	可以修改恕限时间
	-p	复制范本.意义为将username_demo这个人的quotq限制值复制给username

quotaon	-avug
quotaon -vug	/mount_point
	-u	针对使用者启动quota(aquota.user)
	-g	针对群组启动quota(aquota.group)
	-v	显示启动过程的相关讯息
	-a	根据/etc/mtab内的filesystem设定启动有关的quota,若不加a的话,则后面就需要加上特定的那个filesystem

quotaoff -a
quotaoff -ug /mount_point
	-a	全部的filesystem的quota都关闭(根据/etc/mtab)
	-u	仅针对后面接的那个/mount_point关闭user quota
	-g	仅针对后面接的那个/mount_point关闭group quota

repquota -a -vug
	-a	直接到/etc/mtab搜寻具有quotq标志的filesystem,并报告quotq的结果
	-v	输出所有的quota结果,而非仅下达指令自己的quotq值
	-u	显示出使用者的quotq限值(这是默认值)
	-g	显示出个别群组的quota值

at		这个工作仅执行一次就从linux系统的排程中取消
cron	这个工作将持续例行性的作下去

at
	/etc/init.d/atd restart  启动atd服务

	先搜寻/etc/at.allow,写在这个档案中的使用者才能使用at,没有在这个档案中的使用者不能使用at
	如果没有/etc/at.allow就寻找/etc/at.deny这个档案,若写在这个at.deny的使用者则不能使用at,而没有在这个at.deny档案中的使用者,就可以使用at
	如果两个档案都不存在,那么只有root可以使用at这个指令

	at -m TIME
	-m	当at的工作完成后,以email的方式通知使用者该工作完成
	TIME:时间格式,这里可以定义出什么时候进行at这项工作的时间,格式有:
		HH:MM		例04:00
		在今日的HH:MM时刻进行,若该时刻已超过,则明天的HH:MM进行此工作
		HH:MM YYYY-MM-DD   例04:00 2005-12-03
		强制规定在某年某月的某一天的特殊时刻进行该工作
		HH:MM[am|pm] [Month] [Date]	例04pm December 3
		也是一样,强制在某年某月某日的某时刻进行
		HH:MM[am|pm]+number [minutes][hours][days][weeks]
		例now+5minutes,04pm+3days
		就是说,在某个时间点再加几个小时后才进行
		ctrl+d结束
	atq	查询目前主机上面有多少的at工作排程
	atrm num	移除num代表的工作排程

cron	
	/etc/cron.allow,/etc/cron.deny,cron.allow优先级比cron.deny高

	crontab  -u name -l|-e|-r
		-u	只有root才能进行这个任务,亦即帮其它使用者建立/移除 crontab
		-e	编辑crontab的工作内容
		-l	查询crontab的工作内容
		-r	移除crontab的工作内容,移除所有crontab工作,若要移除一项工作,要作用-e
		wq存储离开
		0	   12    *		 *		*		mail hells -s "at 12:00" < /home/hells/.bashrc
		分	   时	 日		 月		周		|<===============指令串=====================>|
		0-59   0-23	 1-31	 1-12	0-7		*代表任何时刻都接受		,代表分隔时段,例如下达的时间是3:00与6:00,就会是0 3,6 * * * command  -代表一段时间范围		*/n代表每隔n单位间隔的意思
	/etc/crontab 是系统的例行性任务
		有时候需要重新启动crond这个服务,因为有些系统是把crontab文件计入内存中的
		/etc/init.d/crond restart
工作管理
	在指令后加&表示在背景中执行的意思
	ctrl+z	将某项工作丢到背景中暂停的意思
	jobs	参数	观察目前的背景工作状态
		-l	除了列出job numbwr之外,同时列出PID
		-r	仅列出正在背景run的工作
		-s	仅列出正在背景当中暂停的工作
	fg %jobnumber	将背景工作拿到前景来处理,预设取胜+号那个number
	bg %jobnumber	将背景工作下停止运行的程序运行起来
	kill -signal %jobnumber
		-l	这个是L的小写,列出目前kill能够使用的讯号有哪些
		-1	重新读取一次参数的设定档
		-2	代表由键盘输入ctrl+c同样的动作
		-9	立刻强制删除一个工作
		-15	以正常的程序方式终止一项工作
		
pidof	-sx		program_name
	-s	仅列出一个PID而不列出所有的PID
	-x	同时列出该program name可能的PPID那个程序的PID
	
ps有3种不同类型的命令选项：
	UNIX选项，可以组合起来，必须在前面加一个连字符“-”
		-A 				列出所有的进程
		-w 				显示加宽可以显示较多的资讯
		-au 			显示较详细的资讯
		-aux 			显示所有包含其他使用者的进程
		-e 				显示所有进程,环境变量
		-f 				全格式
		-h 				不显示标题
		-l 				长格式
		-w 				宽输出
		-p	pid			显示某个pid的进程
		-o				自定义格式,中间以逗号分隔,如ps -p 45510 -o pid,cmd,lstart,etime,uid,gid
			lstart 	显示进程启动时间
			pid		进程号
			cmd		显示命令
			etime	进程运行的时间
			uid		显示用户id
			gid		显示组id
			state	进程状态
			rtprio  实时优先级,若显示-,则不是实时进程
		ps -e -o pid,cmd,etime,lstart  | grep EngineServer
		ps -lA
		ps -xH			显示所有线程信息
		ps -mq	pid		显示某个进程产生的线程数目
		tx1下可使用ps -o pid,comm,time,etime | grep EngineServer来查看启动时间
	BSD选项，可以组合起来，不能使用连字符“-”
		l  		长格式输出；
		u  		按用户名和启动时间的顺序来显示进程；
		j  		用任务格式来显示进程；
		f  		用树形格式来显示进程；
		a  		显示所有用户的所有进程(包括其它用户)；
		x  		显示无控制终端的进程；
		r  		只显示运行中的进程；
		ww 		避免详细参数被截断；
		ps 		aux
		ps 		axjf
	GNU长选项，在前面有2个连字符"--"

ps状态
D		不可中断的睡眠
L		进程具有有内存中锁定的页面
N		低优先权的任务
R		可运行
S		进程要求页面替换(正在睡眠)
T		被跟踪或者停止
Z		死亡(僵)的进程
W		无驻留页面的进程
<		高优先权的进程
		
top -d | top -bnp			默认是按cpu占用量来排序的
	-d	后面可以接秒数,就是整个程序画面更新的秒数,预设是5秒
	-b	以批次档的方式执行top,通常会搭配数据流重导向来将批次的结果输出成为档案
	-n	与-b搭配,意义是,需要进行几次top的输出结果
	-p	指定某些个PID来进行观察侦测
	在top执行过程当中可以使用的按键指令
		1	显示cpu核数及负载
		?:	显示在top当中可以输入的按键指令
		P:	以CPU的使用资源排序显示
		M:	以Memory的使用资源排序显示
		N:	以PID来排序
		T:	由该Process使用的CPU时间累积排序
		k:	给予某个PID一个讯号(signal)
		r:	给予某个PID重新制订一个nice值
		1:	监控每个逻辑cpu的状况
		b:	打开关闭加亮效果
		y:	打开关闭运行进程的加亮效果,如果y被关闭,按b也没用
		x:	打开关闭排序列的加亮效果
		shift + </>  :   向左或向右改变排序列
		f:	可以改变top的显示列
		A:	切换交替模式(显示四个窗口,Def默认字段组,job任务字段组,Mem内存字段组,User用户字段组),按g再按数字可切换到具体一个组
		d或s: 	再加一个数字,会以输入的数字作为时间间隔输出top信息
		
mpstat(Multiprocessor Statistics)		报告CPU的一些统计信息,这些信息存放在/proc/stat中
mpstat [-P {|ALL}] [internal [count]]
-P {|ALL}	表示监控哪个cpu,cpu在[0,cpu个数-1]中取值
internal 	相邻的两次采样的间隔时间
count		采样的次数,count只能和delay一起使用
没有参数时,mpstat显示系统启动以后所有信息的平均值,有interval时,第一行的信息自启动以来的平均信息,从第二行开始,输出前一个interval时间段的平均信息
%user      在internal时间段里，用户态的CPU时间(%)，不包含nice值为负进程  (usr/total)*100
%nice      在internal时间段里，nice值为负进程的CPU时间(%)   (nice/total)*100
%sys       在internal时间段里，内核时间(%)       (system/total)*100
%iowait    在internal时间段里，硬盘IO等待时间(%) (iowait/total)*100
%irq       在internal时间段里，硬中断时间(%)     (irq/total)*100
%soft      在internal时间段里，软中断时间(%)     (softirq/total)*100
%idle      在internal时间段里，CPU除去等待磁盘IO操作外的因为任何原因而空闲的时间闲置时间(%) (idle/total)*100

sar(System Activity Reporter系统活动情况报告),可以从多方面对系统的活动进行报告，包括：文件的读写情况、系统调用的使用情况、磁盘I/O、CPU效率、内存使用状况、进程活动及IPC有关的活动等
sar [options] [-A] [-o file] t [n]
t为采样间隔,n为采样次数
-o file		将采样结果以二进制存放到文件中
options 为命令行选项，sar命令常用选项如下：
	-A：所有报告的总和
	-u：输出CPU使用情况的统计信息
	-v：输出inode、文件和其他内核表的统计信息
	-d：输出每一个块设备的活动信息
	-r：输出内存和交换空间的统计信息
	-b：显示I/O和传送速率的统计信息
	-a：文件读写情况
	-c：输出进程统计信息，每秒创建的进程数
	-R：输出内存页面的统计信息
	-y：终端设备活动情况
	-w：输出系统交换活动信息
要查看sar生成的进制文件,需要使用sar -f(查看cpu再加上-u)

vmstat				后面直接跟数字表示几秒刷新一次
	监视内存性能：该命令用来检查虚拟内存的统计信息，并可显示有关进程状态、空闲和交换空间、调页、磁盘空间、CPU负载和交换，cache刷新以及中断等方面的信息。

pstree  -Aup
	-A	各程序树之间的连接以ASCII字符来连接
	-p	并同时列出每个process的PID
	-u	并同时列出每个process的所属账号名称

killall	-ile  command name
	-i	interactive的意思,交互式的,若需要删除时,会出现提示字符给使用者
	-e	exact的意思,表示后面接的command name要一致,但整个完整的指令不能超过15个字符
	-l	指令名称(可能含参数)忽略大小写

free -b|-k|-m|-g   -t
	-b	直接输入free时,显示的单位是Kbytes,可以使用b(bytes),m(Mbytes),k(kbytes),g(Gbytes)来显示单位
	-t	在输出的最终结果,显示物理内存与swap的总量
	-s  每隔几秒输出一次
A buffer is something that has yet to be "written" to disk. 
A cache is something that has been "read" from the disk and stored for later use.
也就是说buffer是用于存放要输出到disk(块设备)的数据的，而cache是存放从disk上读出的数据。这二者是为了提高IO性能的，并由OS管理。
free输出的第三行是从一个应用程序的角度看系统内存的使用情况。
对于FO[3][2]，即-buffers/cache，表示一个应用程序认为系统被用掉多少内存；
对于FO[3][3]，即+buffers/cache，表示一个应用程序认为系统还有多少内存；

uname -asrmpi
	-a	所有系统相关的信息
	-s	系统核心名称
	-r	核心的版本
	-m	本系统硬件的名称,和arch命令结果一样
	-p	CPU的类型
	-i	硬件的平台(ix86)
	
/etc/os-release			可查看系统版本
/etc/redhat-release		可查看系统版本

lsb_release				查看当前系统发行版信息
	-a					显示所有信息
	
getconf		将系统配置变量值打印到输出屏幕上
	-a		将所有系统配置变量值输出
	例:		getconf LONG_BIT   输出32还是64来判断系统是多少位的
	
arch	查看机器的处理器架构

uptime	显示系统当前时间,已经开机多久了,以及1,5,15分钟的平均负载,就是top画面的最上面的一行

nsenter 	进入其他进程的命名空间
	-t,--target  进程id 	                     
	-m,--mount 	 进入到mount namespace
	-u,--uts 	 进入到uts namespace	
	-i,--ipc	 进入到ipc namespace				  
	-n,--net	 进入到net namespace
	-p,--pid	 进入到pid namespace
	-U,--user	 进入到user namespace

ip [ OPTIONS ] OBJECT { COMMAND | help }  用来显示或操纵Linux主机的路由、网络设备、策略路由和隧道，是Linux下较新的功能强大的网络配置工具
OPTIONS
	-V：显示指令版本信息；
	-s：输出更详细的信息；
	-f：强制使用指定的协议族；
	-4：指定使用的网络层协议是IPv4协议；
	-6：指定使用的网络层协议是IPv6协议；
	-0：输出信息每条记录输出一行，即使内容较多也不换行显示；
	-r：显示主机时，不使用IP地址，而使用主机的域名。

OBJECT 		所有对象名都可以简写,例:address 可以简写为addr,甚至是a
	link 		网络设备
	address 	一个设备的协议(IPV4或者IPV6)地址
	neighbour	ARP或者NDISC缓冲区条目
	route		路由表条目
	rule		路由策略数据库中的规则
	maddress	多播地址
	mroute		多播路由缓冲区条目
	monitor		监控网络消息
	mrule		组播路由策略数据库中的规则
	tunnel		IP上的通道
	l2tp		隧道以太网(L2TPV3)

	增加IP地址(删除将add改为del): 	ip addr add ADDRESS/MASK dev DEVICE
	查看网络信息:				  	ip addr show
	添加路由表(删除将add改为del): 	ip route add TARGET via GW  如 ip route add 172.16.0.0/16 via 192.168.29.1
	显示路由表:					  	ip route show
	清空路由表:					  	ip route flush [dev IFACE] [via PREFIX] 如 ip route flush dev ens33
	清空ip地址:						ip addr flush [dev IFACE]
	显示网络设备运行状态:		  	ip link list
	查看网卡信息:				  	ip -s link list ens33
	设置MTU:					  	ip link set ens33 mtu 1400
	关闭网络设备(开启将down改为up):	ip link set ens33 down
	
	
ss		 显示处于活动状态的套按字信息,比netstat快速高效
	-h：显示帮助信息；
	-V：显示指令版本信息；
	-n：不解析服务名称，以数字方式显示；
	-a：显示所有的套接字；
	-l：显示处于监听状态的套接字；
	-o：显示计时器信息；
	-m：显示套接字的内存使用情况；
	-p：显示使用套接字的进程信息；
	-i：显示内部的TCP信息；
	-4：只显示ipv4的套接字；
	-6：只显示ipv6的套接字；
	-t：只显示tcp套接字；
	-u：只显示udp套接字；
	-d：只显示DCCP套接字；
	-w：仅显示RAW套接字；
	-x：仅显示UNIX域套接字。
	-s: 显示socket摘要信息

netstat	 -[atunlp]		显示网络连接,路由表,接口状态,伪装连接,网络链路信息和组播成员组。
netstat	-tuln	查询目前主机所有已经启动的服务
80:www
22:ssh
21:ftp
25:mail
	-a	显示所有正在或不在侦听的套接字。加上 --interfaces 选项将显示没有标记的接口
	-t	列出tcp网络封包的数据
	-u	列出udp网络封包的数据
	-n	不显示程序的服务名称,以端口号来显示
	-l	只显示正在监听的套按字(这是默认的选项)
	-p	显示套接字所属进程的PID和名称
	-r	显示内核路由表
	-C	显示路由缓冲中的路由信息
	-i	显示所有的网络接口或者是指定的iface
	活动的Internet网络连接 (TCP, UDP, raw)
	Proto
       套接字使用的协议。

   Recv-Q
       连接此套接字的用户程序未拷贝的字节数。

   Send-Q
       远程主机未确认的字节数。

   Local Address
       套接字的本地地址(本地主机名)和端口号。除非给定-n --numeric (-n) 选项,否则套接字地址按标准主机名(FQDN)进行解析,而端口号则转换到相应的服务名。

   Foreign Address
       套接字的远程地址(远程主机名)和端口号。 Analogous to "Local Address."

   State
       套接字的状态。因为在RAW协议中没有状态,而且UDP也不用状态信息,所以此行留空。通常它为以下几个值之一：

       ESTABLISHED
              套接字有一个有效连接。

       SYN_SENT
              套接字尝试建立一个连接。

       SYN_RECV
              从网络上收到一个连接请求。

       FIN-WAIT1
              套接字已关闭,连接正在断开。

       FIN-WAIT2
              连接已关闭,套接字等待远程方中止。

       TIME_WAIT
              在关闭之后,套接字等待处理仍然在网络中的分组

       CLOSED 套接字未用。

       CLOSE_WAIT
              远程方已关闭,等待套接字关闭。

       LAST_ACK
              远程方中止,套接字已关闭。等待确认。

       LISTEN 套接字监听进来的连接。如果不设置 --listening (-l) 或者 --all (-a) 选项,将不显示出来这些连接。

       CLOSING
              套接字都已关闭,而还未把所有数据发出。

       UNKNOWN
              套接字状态未知。
			  
		User
       套接字属主的名称或UID。

   PID/Program name
       以斜线分隔的处理套接字程序的PID及进程名。 --program 使此栏目被显示。你需要 superuser 权限来查看不是你拥有的套接字的信息。对IPX套接字还无法获得此信息。

   Timer
       (this needs to be written)

   活动的UNIX域套接字
   Proto
       套接字所用的协议(通常是unix)。

   RefCnt
       使用数量(也就是通过此套接字连接的进程数)。

   Flags
       显示的标志为SO_ACCEPTON(显示为 ACC), SO_WAITDATA (W) 或 SO_NOSPACE (N)。 如果相应的进程等待一个连接请求,那么SO_ACCECPTON用于未连接的套接字。其它标志通常并不重要

   Type
       套接字使用的一些类型：

       SOCK_DGRAM
              此套接字用于数据报(无连接)模式。

       SOCK_STREAM
              流模式(连接)套接字

       SOCK_RAW
              此套接字用于RAW模式。

       SOCK_RDM
              一种服务可靠性传递信息。

       SOCK_SEQPACKET
              连续分组套接字。

       SOCK_PACKET
              RAW接口使用套接字。

       UNKNOWN
              将来谁知道它的话将告诉我们,就填在这里 :-)

   State
       此字段包含以下关键字之一：

       FREE   套接字未分配。

       LISTENING
              套接字正在监听一个连接请求。除非设置 --listening (-l) 或者 --all (-a) 选项,否则不显示。

       CONNECTING
              套接字正要建立连接。

       CONNECTED
              套接字已连接。

       DISCONNECTING
              套接字已断开。
	 (empty)
              套接字未连。

       UNKNOWN
              ！不应当出现这种状态的。

   PID/Program name
       处理此套接字的程序进程名和PID。上面关于活动的Internet连接的部分有更详细的信息。

   Path
       当相应进程连入套接字时显示路径名。

   活动的IPX套接字
       (this needs to be done by somebody who knows it)

   Active NET/ROM sockets
       (this needs to be done by somebody who knows it)

   Active AX.25 sockets
       (this needs to be done by somebody who knows it)


dmesg	查询所有的核心开机时的信息

一般使用者的nice值为0~19,仅可将nice值越调越高,仅能调整自己的程序的nice值
root可用的nice值为-20~19

nice -n command
	-n	后面接一个数值,数值的范围-20~19
renice  number  PID

fuser -ki  -signal  file/dir  找出使用档案/目录的进程的PID
	-k	找出使用该档案/目录的PID,并试图以SIKKILL这个信号给予PID;
	-i	必须与-k配合,在删除PID之前会先询问使用者意愿
	PID后面字符的意义
		c   在当前的目录下
		e	可以被执行的
		f	是一个被开启的档案
		r	代表root directory

lsof	-Uu  +d		列出已经被开启的档案与装置
	-a	多项数据需要同时成立才显示出结果时
	-U	仅列出Unix like系统的socket的档案类型
	-u	后面接username,列出该使用者相关程序所开启的档案
	+d	后面接目录,亦即找出某个目录底下已经被开启的档案
	-i:端口		查看某端口运行情况
	-i:port1~port2
	
iconv	编码转换
-f, --from-code=名称 原始文本编码
-t, --to-code=名称 输出编码
-l, --list 列举所有已知的字符集
-o, 输出到指定文件,别和input同名

xxd   文件名   		以十六进制显示一个文件
	-p		以 postscript 的 连续 十六进制 转储 输出. 这 也叫做 纯 十六进制 转储

输出控制：
-c 从输出中忽略无效的字符
-o, --output=FILE 输出文件
-s, --silent 关闭警告
--verbose 打印进度信息

modinfo -adln	module_name|filename
	-a	仅列出作者名称
	-d	公列出该modules的说明(description)
	-l	仅列出授权
	-n	仅列出该模块的详细路径

makefile
	./configure   建立Makefile
	make clean
	make
	make install

./configure  --help |more	查询帮助
			 --prefix=/path	表示这个软件要安装到哪里,预设是/usr/local

在/etc/ld.so.conf里面写入[想要读入高速缓存当中的动态函式库所在的目录]
用ldconfig这个执行档将/etc/ld.so.conf的资料读入快取中
同时也将数据记录一份在/etc/ld.so.cache这个档案中

ldconfig -f conf -C cache -p	不加任何参数可以刷新缓冲中的动态库,ldconfig -vn .可以在当前目录生成库的soname链接到realname
	-v或--verbose：用此选项时，ldconfig将显示正在扫描的目录及搜索到的动态链接库，还有它所创建的连接的名字。 
	-n：用此选项时,ldconfig仅扫描命令行指定的目录，不扫描默认目录(/lib、/usr/lib)，也不扫描配置文件/etc/ld.so.conf所列的目录。 
	-N：此选项指示ldconfig不重建缓存文件(/etc/ld.so.cache)，若未用-X选项，ldconfig照常更新文件的连接。 
	-X：此选项指示ldconfig不更新文件的连接，若未用-N选项，则缓存文件正常更新。 
	-f CONF：此选项指定动态链接库的配置文件为CONF，系统默认为/etc/ld.so.conf。 
	-C CACHE：此选项指定生成的缓存文件为CACHE，系统默认的是/etc/ld.so.cache，此文件存放已排好序的可共享的动态链接库的列表。 
	-r ROOT：此选项改变应用程序的根目录为ROOT(是调用chroot函数实现的)。选择此项时，系统默认的配置文件/etc/ld.so.conf，实际对应的为ROOT/etc/ld.so.conf。如用-r /usr/zzz时，打开配置文件/etc/ld.so.conf时，实际打开的是/usr/zzz/etc/ld.so.conf文件。用此选项，可以大大增加动态链接库管理的灵活性。 
	-l：通常情况下,ldconfig搜索动态链接库时将自动建立动态链接库的连接，选择此项时，将进入专家模式，需要手工设置连接，一般用户不用此项。 
	-p或--print-cache：此选项指示ldconfig打印出当前缓存文件所保存的所有共享库的名字。 
	-c FORMAT 或 --format=FORMAT：此选项用于指定缓存文件所使用的格式，共有三种：old(老格式)，new(新格式)和compat(兼容格式，此为默认格式)。 
	-V：此选项打印出ldconfig的版本信息，而后退出。 -? 或 --help 或 --usage：这三个选项作用相同，都是让ldconfig打印出其帮助信息，而后退出。
	-? 或 --help 或 --usage：这三个选项作用相同，都是让ldconfig打印出其帮助信息，而后退出。

	
ldd(list dynamic dependencies) [-vdr]  filename  	列出动态库依赖关系,是个shell脚本,没有readelf -d准确,并不能将所有的依赖库列出来,系统调用dlopen可以在需要的时候自动调入需要的动态库,而这些库可能不会被ldd列出来
	-v	列出所有内容信息
	-d	执行重定位并报告所有丢失的函数
	-r	执行对函数和对象的重定位并报告丢失的任何函数或对象
	-u	显示不必要链接的动态库(若去掉这些不必要链接的动态库则可以加快程序链接速度)
首先,ldd不是一个可执行程序,而是一个shell脚本。ldd能够显示可执行模块的dependency,其原理是通过设置一系列的环境变量,如下：LD_TRACE_LOADED_OBJECTS、LD_WARN、LD_BIND_NOW、LD_LIBRARY_VERSION、LD_VERBOSE等。当LD_TRACE_LOADED_OBJECTS环境变量不为空时,任何可执行程序在运行时,它都会只显示模块的dependency,而程序并不真正执行

strip	name	裁减目标文件name的符号表,使得nm就看不到符号表的名字了,但使用readelf -s仍然可以看到

strings		文件名			打印文件中可打印的字符,可用在二进制文件中

nm  库名	列出file中的所有符号信息
	-C		限制解码c++符号,用c符号名
	-c		将符号转化为用户级的名字
	-s		相当于.a文件即静态库时,输出把符号名映射到定义该符号的模块或成员名的索引
	-u		显示在file外定义的符号或没有定义的符号
	-l		显示每个符号的行号,或为定义符号的重定义项
	-D		显示动态符号表的信息,动态符号表只用于动态加载器运行时的加载,另一个正常符号表一般是用来调试
	-A		同时打印文件名
A	Global absolute 符号。
a	Local absolute 符号。
B	Global bss 符号。
b	Local bss 符号。
D	Global data 符号。
d	Local data 符号。
f	源文件名称符号。
T	Global text 符号。
t	Local text 符号。
U	未定义符号。

readelf			分析elf格式文件的信息
-a --all 显示全部信息,等价于 -h -l -S -s -r -d -V -A -I. 
-h --file-header 显示elf文件开始的文件头信息. 
-l --program-headers --segments 显示程序头(段头)信息(如果有的话)。 
-S --section-headers --sections 显示节头信息(如果有的话)。 
-g --section-groups 显示节组信息(如果有的话)。 
-t --section-details 显示节的详细信息(-S的)。 
-s --syms --symbols 显示符号表段中的项(如果有的话)。 
-e --headers 显示全部头信息,等价于: -h -l -S -n --notes 显示note段(内核注释)的信息。 
-r --relocs 显示可重定位段的信息。 
-u --unwind 显示unwind段信息。当前只支持IA64 ELF的unwind段信息。 
-d --dynamic 显示动态段的信息。 -V --version-info 显示版本段的信息。 会显示搜索的动态链接库名(soname)及查看共享库的依赖(needed)
-A --arch-specific 显示CPU构架信息。 -D --use-dynamic 使用动态段中的符号表显示符号,而不是使用符号段。 
-x --hex-dump= 以16进制方式显示指定段内内容。number指定段表中段的索引,或字符串指定文件中的段名。 
-w[liaprmfFsoR] or --debug-dump[=line,=info,=abbrev,=pubnames,=aranges,=macro,=frames,=frames-interp,=str,=loc,=Ranges] 显示调试段中指定的内容。 
-I --histogram 显示符号的时候,显示bucket list长度的柱状图。 -v --version 显示readelf的版本信息。 -H --help 显示readelf所支持的命令行选项。 
-W --wide 宽行输出。 @file 可以将选项集中到一个文件中,然后使用这个@file选项载入。 

Num: = 符号序号
Value = 符号的地址
Size = 符号的大小
Type = 符号类型: Func = Function, Object, File (source file name), Section = memory section, Notype = untyped absolute symbol or undefined
Bind = GLOBAL 绑定意味着该符号对外部文件的可见. LOCAL 绑定意味着该符号只在这个文件中可见. WEAK 有点像GLOBAL, 该符号可以被重载.
Vis = Symbols can be default, protected, hidden or internal.
Ndx = The section number the symbol is in. ABS means absolute: not adjusted to any section address relocation
Name = symbol name

bc		命令行计算器,注意,16进制的数字一定要大写,obase一定要放在ibase前
-i		强制进入交互模式
-l		定义使用的标准数学库
-w		对POSI bc的扩展给出警告信息
-q		不打印正常的GNU bc环境信息
-v		显示指令版本信息
-h		显示指令帮助信息
scale = 2	设置小数位2位
ibase = 	输入进制
obase =     输出进制

c++filt  函数编译出来的符号		可以查看函数对应的原始名称

md5sum -bct filename		支持输入多个文件,支持通配符
	md5sum是校验文件内容，与文件名是否相同无关；
	md5sum是逐位校验，所以文件越大，校验时间越长。
	md5校验，可能极小概率出现不同的文件生成相同的校验和，比md5更安全的校验算法还有SHA*系列，如sha1sum/sha224sum/sha256sum/sha384sum/sha512sum等等，基本用法与md5sum命令类似
md5sum --status|--warn  --check filename
	-b	使用binary的读档方式
	-c	检验md5sum档案指纹
	-t	以文字形态来读取md5sum的档案指纹(默认)

daemon
	stand_alone  独立启动,常驻在内存,响应速度快,放置在/etc/init.d这个目录里,路径 start,service 服务 start
	super daemon 由统一的一个daemon来负责唤起该服务,当有数据来时,会先交给xinet这个服务,然后xinet根据封包内容(IP与port)发给相应的服务,然后服务再启动,不会一直占用系统资源,但速度秒慢,xinet或inet

super daemon又分为
	multi-threaded
		数据全部接收,再处理
	single-threaded
		来一个数据,处理一次,再接下一个数据

与服务有关的端口对应资料:  /etc/services

此命令位于包bridge-utils
brctl show				查看网桥信息
brctl addbr 网桥名		新建一个网桥
brctl delbr 网桥名		删除一个网桥
brctl addif 网桥名  网卡名  将网卡添加到网桥上

pipework  	是一个shell脚本,可以在比较复杂的网络环境中完成容器的连接,底层采用的是ip命令和brctl命令
	例: 	pipework br0 test 10.207.0.236/24@10.207.0.1 	首先会检查主机是否存在br0网桥,若不存在,就自己创建一个
			pipework br0 test dhcp		如果主机环境中有DHCP服务,也可以通过DHCP的方式获取IP

service  [service name] (start|stop|restart|status)   去/etc/init.d底下启动某个脚本

chkconfig  
	--list		仅将目前的各项服务状态列出来
	--add		增加一个服务名称给chkconfig,让chkconfig可以管理它
	--del		删除一个给chkconfig管理的服务
	--level		设定某个服务在该level下启动或关闭  on/off/reset,on和off开关,默认只对3,4,5等级有效,reset对所有等级有效
	 等级0表示：表示关机
     等级1表示：单用户模式
     等级2表示：无网络连接的多用户命令行模式
     等级3表示：有网络连接的多用户命令行模式
     等级4表示：不可用
     等级5表示：带图形界面的多用户模式
     等级6表示：重新启动
	 
systemd     systemd由一个叫做单元的概念,它保存了服务、设备、挂载点和操作系统其他信息的配置文件，并能够处理不同单元之间的依赖关系。大部分单元都静态的定义在单元文件中，也有一些是动态生成的。单元有多种状态
	处于活动的则是(active)，当前正在运行
	停止的则是(inactive)，当前已经停止
	启动中的则是(activing)，当前正在启动
	停止中的则是(deactiving)，当前正在停止
	失败的则是(failed)状态，意思说单元启动过程中遇到错误比如找不到文件、路径或者进程运行中崩溃了等。
	service单元	用于封装一个后台服务进程，比如通过systemctl start firewalld启动防火墙，这种就属于service单元。
	socket单元	用于封装一个后台服务进程，比如通过systemctl start firewalld启动防火墙，这种就属于service单元。
	target单元	用于将多个单元在逻辑上组合在一起让它们同时启动。
	device单元	用于封装一个设备文件，可用于基于设备启动。并不是每一个设备文件都需要一个device单元，但是每一个被udev规则标记的设备都必须作为一个device单元出现。
	mount单元	用于封装一个文件系统挂载点(向后兼容/etc/fstab)
	automount单元	用于封装一个文件系统自动挂载点，只有该文件系统被访问时才会进行挂载，它取代了传统的autofs服务。
	timer单元	用于封装一个基于时间触发的动作，它取代了atd、crond等计划任务。
	swap单元	用于封装一个交换分区或者交换文件，它与mount类似。
	path单元	用于根据文件系统上特定对象的变化来启动其他服务。
	slice单元	用于控制特定的CGroup内所有进程的总体资源占有。
	scope单元	它与service单元类似，但是由systemd根据D-bus接口接收到的信息自动创建，可用于管理外部创建的进程。
	systemd能够处理各种依赖与冲突关系以及先后顺序，依赖与冲突、先后顺序两者之间是独立的。比如service1依赖service2，而且启动service1必须先启动service2,，那么这2个服务将会同时启动。
	一个单元配置文件只能描述一种单元。
	当systemd以系统实例运行，那么优先级如下：
		/lib/systemd/system	本地配置的系统单元			高
		/run/systemd/system	运行时配置的系统单元		中
		/usr/lib/systemd/system	软件包安装的系统单元	低
	注意单元名称的后缀，可以看出是那一类单元。另外，enabled表示被启用的单元并不是说当前在运行，disabled表示被禁用的单元，至于static则表示不能直接启用，它们是被其他单元所依赖的对象。
	
在systemd中有一个叫做target的单元，也叫作目标单元。这个单元没有专用的配置选项，它只是以.target结尾的文件，它本身没有具体功能，你可以理解为类别，它的作用就是将一些单元汇聚在一起。通过下面的命令可以查看系统的target单元。
	systemctl list-unit-file --type=target
	常见的Target有:
		basic.target	    启动基本系统，该目标间接包含了所有的本地挂载点单元以及其他必须的系统初始化单元。
		ctrl-alt-del.target	当在控制台按下Ctrl+Alt+Del组合键时要启动的单元。
		default.target	    默认的启动目标，通常指向multi-user.target或者graphical.target的目标。
		graphical.target 	专用于启动图形化登陆界面的目标单元，其中包含了multi-user.target单元。
		hibernate.target 	专用于系统休眠到硬盘时启动的单元。
		halt.target      	专用于关闭系统单不切断电源时启动的单元。
		local-fs.target  	专用于集合本地文件系统挂载点的目标单元。
		multi-user.target   专用于多用户且为命令行模式下启动的单元。所有用于要在命令行多用户模式下启动的单元，其[Install]段都应该加上
		WantedBy=multi-user.target指令。
		reboot.target   	专用于重启系统时需要需要启动的单元。
		rescure.target  	专用于启动基本系统并打开一个救援shell时需要启动的单元。
		shutdown.target 	专用于在关机过程中关闭所有的单元。
		sleep.target    	专用于进入休眠状态的目标单元。
		timers.target   	专用于包含所有应该在系统启动时被启动的timer单元。
	
systemctl	将service和chkconfig命令结合到了一起,在/usr/lib/systemd/目录下,有system和user之分,需要开机不登陆就能运行的程序,存在系统服务里
	start	服务名  启动某服务
	restart	服务名	重新启动某服务
	stop	服务名	停止某服务
	enable	服务名	开机自动启动
	disable	服务名	停止开机自动启动
	status	服务名	查看服务状态
	list-units  --type=service	查看所有已启动的服务,不加--type=service可以列出所有单元
	is-enabled	服务名	查看是否开机启动
	daemon-reload	若修改了某个服务的配置,可以使用此命令
	每个服务以.service结尾,一般会分为3部分:[Unit] [Service] [Install]
		Unit: 		
			Description=	对单元进行简单描述的字符串。 用于UI中紧跟单元名称之后的简要描述文字。 例如 "Apache2 Web Server" 就是一个好例子。 不好的例子： "high-performance light-weight HTTP server"(太通用) 或 "Apache2"(信息太少)。
			Documentation=	一组用空格分隔的文档URI列表， 这些文档是对此单元的详细说明。 可接受 "http://", "https://", "file:", "info:", "man:" 五种URI类型。 有关URI语法的详细说明，参见 uri(7) 手册。 这些URI应该按照相关性由高到低列出。 比如，将解释该单元作用的文档放在第一个， 最好再紧跟单元的配置说明， 最后再附上其他文档。 可以多次使用此选项， 依次向文档列表尾部添加新文档。 但是，如果为此选项设置一个空字符串， 那么表示清空先前已存在的列表。
			Requires=		设置此单元所必须依赖的其他单元。 当此单元被启动时，所有这里列出的其他单元也必须被启动。 如果有某个单元未能成功启动，那么此单元也不会被启动。 想要添加多个单元， 可以多次使用此选项， 也可以设置一个空格分隔的单元列表。 注意，此选项并不影响单元之间的启动或停止顺序。 想要调整单元之间的启动或停止顺序， 请使用 After= 或 Before= 选项。 例如，在 foo.service 中设置了 Requires=bar.service 但是并未使用 After= 或 Before= 设定两者的启动顺序， 那么，当需要启动 foo.service 的时候， 这两个单元会被并行的同时启动。 建议使用 Wants= 代替 Requires= 来设置单元之间的非致命依赖关系， 从而有助于获得更好的健壮性， 特别是在某些单元启动失败的时候。
			Before=			同After
			After=			强制指定单元之间的先后顺序。 接受一个空格分隔的单元列表。 假定 foo.service 单元 包含 Before=bar.service 设置， 那么当两个单元都需要启动的时候， bar.service 将会一直延迟到 foo.service 启动完毕之后再启动。 注意，停止顺序与启动顺序正好相反， 也就是说， 只有当 bar.service 完全停止后， 才会停止 foo.service 单元。 After= 的含义 与 Before= 正好相反， 假定 foo.service 单元 包含 After=bar.service 设置， 那么当两个单元都需要启动的时候， foo.service 将会一直延迟到 bar.service 启动完毕之后再启动。 注意，停止顺序与启动顺序正好相反， 也就是说， 只有当 foo.service 完全停止后， 才会停止 bar.service 单元。 注意，此选项仅用于指定先后顺序， 与 Requires= 选项没有任何关系。 不过在实践中也经常遇见 将某个单元同时设置到 After= 与 Requires= 选项中的情形。 可以多次使用此选项， 以将多个单元添加到列表中。 假定两个单元之间存在先后顺序(无论谁先谁后)， 并且一个要停止而另一个要启动， 那么永远是"先停止后启动"的顺序。 但如果两个单元之间没有先后顺序， 那么它们的停止和启动就都是相互独立的， 并且是并行的
			Wants=			此选项是 Requires= 的弱化版。 当此单元被启动时，所有这里列出的其他单元只是尽可能被启动。 但是，即使某些单元不存在或者未能启动成功， 也不会影响此单元的启动。 推荐使用此选项来设置单元之间的依赖关系。注意，此种依赖关系也可以在单元文件之外通过向 .wants/ 目录中添加软连接来设置， 详见前文
			BindsTo=		与 Requires= 类似， 不同之处在于： 如果这里列出的单元停止运行或者崩溃， 那么也会连带导致该单元自身被停止。 这就意味着该单元可能因为 某个单元的主动退出、某个设备被拔出、某个挂载点被卸载， 而被强行停止。
			PartOf=			与 Requires= 类似， 不同之处在于：仅作用于单元的停止或重启。 其含义是，当停止或重启这里列出的某个单元时， 也会同时停止或重启该单元自身。 注意，这个依赖是单向的， 该单元自身的停止或重启并不影响这里列出的单元。
			Conflicts=		指定单元之间的冲突关系。 接受一个空格分隔的单元列表，表明该单元不能与列表中的任何单元共存， 也就是说：(1)当此单元启动的时候，列表中的所有单元都将被停止； (2)当列表中的某个单元启动的时候，该单元同样也将被停止。 注意，此选项与 After= 和 Before= 选项没有任何关系。
			OnFailure=		接受一个空格分隔的单元列表。 当该单元进入失败("failed")状态时， 将会启动列表中的单元。
			PropagatesReloadTo=		同下
			ReloadPropagatedFrom=	接受一个空格分隔的单元列表。 PropagatesReloadTo= 表示 在 reload 该单元时，也同时 reload 所有列表中的单元。 ReloadPropagatedFrom= 表示 在 reload 列表中的某个单元时，也同时 reload 该单元。
			JoinsNamespaceOf=	接受一个空格分隔的单元列表， 表示将该单元所启动的进程加入到列表单元的网络及 临时文件(/tmp, /var/tmp) 的名字空间中。 如果单元列表中仅有一个单元处于已启动状态， 那么该单元将加入到这个唯一已启动单元的名字空间中。 如果单元列表中有多个单元处于已启动状态， 那么该单元将随机加入一个已启动单元的名字空间中。 此选项仅适用于支持 PrivateNetwork= 与/或 PrivateTmp= 指令的单元 (对加入者与被加入者都适用)。 详见 systemd.exec(5) 手册。
			RequiresMountsFor=	接受一个空格分隔的绝对路径列表，表示该单元将会使用到这些文件系统路径。 所有这些路径中涉及的挂载点所对应的 mount 单元，都会被隐式的添加到 Requires= 与 After= 选项中。 也就是说，这些路径中所涉及的挂载点都会在启动该单元之前被自动挂载。
			OnFailureJobMode=	可设为 "fail", "replace", "replace-irreversibly", "isolate", "flush", "ignore-dependencies", "ignore-requirements" 之一。 默认值是 "replace" 。 指定 OnFailure= 中列出的单元应该以何种方式排队。值的含义参见 systemctl(1) 手册中对 --job-mode= 选项的说明。 如果设为 "isolate" ， 那么只能在 OnFailure= 中设置一个单独的单元。
			IgnoreOnIsolate=	如果设为 yes ， 那么在执行 systemctl isolate another.target 命令时，此单元不会被停止。 默认值是 no 
			StopWhenUnneeded=	如果设为 yes ， 那么当此单元不再被任何已启动的单元依赖时， 将会被自动停止。 默认值 no 的含义是， 除非此单元与其他即将启动的单元冲突， 否则即使此单元已不再被任何已启动的单元依赖， 也不会自动停止它。
			RefuseManualStart=  同下
			RefuseManualStop=	如果设为 yes ， 那么此单元将拒绝被手动启动(RefuseManualStart=) 或拒绝被手动停止(RefuseManualStop=)。 也就是说， 此单元只能作为其他单元的依赖条件而存在， 只能因为依赖关系而被间接启动或者间接停止， 不能由用户以手动方式直接启动或者直接停止。 设置此选项是为了 禁止用户意外的启动或者停止某些特定的单元。 默认值是 no。\AllowIsolate=	如果设为 yes ， 那么此单元将允许被 systemctl isolate 命令操作， 否则将会被拒绝。 唯一一个将此选项设为 yes 的理由，大概是为了兼容SysV初始化系统。 此时应该仅考虑对 target 单元进行设置， 以防止系统进入不可用状态。 建议保持默认值 no
			DefaultDependencies=	默认值 yes 表示为此单元隐式地创建默认依赖。 不同类型的单元，其默认依赖也不同，详见各自的手册页。 例如对于 service 单元来说， 默认的依赖关系是指： (1)开机时，必须在基础系统初始化完成之后才能启动该服务； (2)关机时，必须在该服务完全停止后才能关闭基础系统。 通常，只有那些在系统启动的早期就必须启动的单元， 以及那些必须在系统关闭的末尾才能关闭的单元， 才可以将此选项设为 no 。 注意，设为 no 并不表示取消所有的默认依赖， 只是表示取消非关键的默认依赖。 强烈建议对绝大多数普通单元保持此选项的默认值 yes 。
			JobTimeoutSec=				同下
			JobTimeoutAction=			同下
			JobTimeoutRebootArgument=	同下
			JobTimeoutSec=			用于设置该单元等候外部任务(job)完成的最长时限。 如果超时，那么超时的 job 将被撤销，并且该单元将保持其现有状态不变。 对于非 device 单元，此选项的默认值是 "infinity"(永不超时)。 注意，此选项的超时不是指单元自身的超时(例如 TimeoutStartSec= 就是指单元自身的超时)， 而是指该单元在启动或者停止等状态变化过程中，等候某个外部任务完成的最长时限。 换句话说，适用于单元自身的超时设置(例如 TimeoutStartSec=)用于指定单元自身在改变其状态时，总共允许使用多长时间； 而 JobTimeoutSec= 则是设置此单元在改变其状态的过程中，等候某个外部任务完成所能容忍的最长时间。
			JobTimeoutAction=	用于指定当超时发生时， 将触发什么样的额外动作。 默认值为 none 。 可设置的值与 StartLimitAction= 相同，参见 systemd.service(5) 手册。 JobTimeoutRebootArgument= 用于指定传递给 reboot(2) 系统调用的字符串参数。
			StartLimitIntervalSec=
			StartLimitBurst=  设置单元的启动频率限制。 默认情况下，一个单元在10秒内最多允许启动5次。 StartLimitIntervalSec= 用于设置时长， 默认值等于 DefaultStartLimitIntervalSec= 的值(默认为10秒)，设为 0 表示不作限制。 StartLimitBurst= 用于设置在一段给定的时长内，最多允许启动多少次， 默认值等于 DefaultStartLimitBurst= 的值(默认为5次)。 虽然此选项通常与 Restart= (参见 systemd.service(5)) 一起使用， 但实际上，此选项作用于任何方式的启动(包括手动启动)， 而不仅仅是由 Restart= 触发的启动。 注意，一旦某个设置了 Restart= 自动重启逻辑的单元 触碰到了启动频率限制，那么该单元将再也不会尝试自动重启； 不过，如果该单元后来又被手动重启成功的话，那么该单元的自动重启逻辑将会被再次激活。 注意，systemctl reset-failed 命令能够重置单元的启动频率计数器。 系统管理员在手动启动某个已经触碰到了启动频率限制的单元之前，可以使用这个命令清除启动限制。 注意，因为启动频率限制位于所有单元条件检查之后，所以基于失败条件的启动不会计入启动频率限制的启动次数之中。 注意， slice, target, device, scope 单元不受此选项的影响， 因为这几种单元要么永远不会启动失败、要么只能成功启动一次。
			RebootArgument=	 当 StartLimitAction= 或 FailureAction= 触发关机动作时， 此选项的值就是传递给 reboot(2) 系统调用的字符串参数。 相当于 systemctl reboot 命令接收的可选参数。
			ConditionArchitecture=,
			ConditionVirtualization=
			ConditionHost=
			ConditionKernelCommandLine=
			ConditionSecurity=
			ConditionCapability=
			ConditionACPower=
			ConditionNeedsUpdate=
			ConditionFirstBoot=
			ConditionPathExists=
			ConditionPathExistsGlob=
			ConditionPathIsDirectory=
			ConditionPathIsSymbolicLink=, ConditionPathIsMountPoint=
			ConditionPathIsReadWrite=
			ConditionDirectoryNotEmpty=
			ConditionFileNotEmpty=
			ConditionFileIsExecutable= 这组选项用于在启动单元之前，首先测试特定的条件是否为真。 若为真则开始启动，否则将会(悄无声息地)跳过此单元(仅是跳过，而不是进入"failed"状态)。 注意，即使某单元由于测试条件为假而被跳过，那些由于依赖关系而必须先于此单元启动的单元并不会受到影响(也就是会照常启动)。 可以使用条件表达式来跳过那些对于本机系统无用的单元， 比如那些对于本机内核或运行环境没有用处的功能。 如果想要单元在测试条件为假时进入"failed"状态(而不是跳过)， 可以使用对应的另一组 AssertXXX= 选项(见下面)。
			ConditionArchitecture=	检测是否运行于特定的硬件平台： x86, x86-64, ppc, ppc-le, ppc64, ppc64-le, ia64, parisc, parisc64, s390, s390x, sparc, sparc64, mips, mips-le, mips64, mips64-le, alpha, arm, arm-be, arm64, arm64-be, sh, sh64, m86k, tilegx, cris, native(编译 systemd 时的目标平台)。 可以在这些关键字前面加上感叹号(!)前缀表示逻辑反转。 注意，Personality= 的设置对此选项没有任何影响。
			ConditionVirtualization=	检测是否运行于(特定的)虚拟环境中： qemu, kvm, zvm, vmware, microsoft, oracle, xen, bochs, uml, openvz, lxc, lxc-libvirt, systemd-nspawn, docker, rkt, vm(某种虚拟机), container(某种容器), yes(某种虚拟环境), no(物理机)。 参见 systemd-detect-virt(1) 手册以了解所有已知的虚拟化技术及其标识符。 如果嵌套在多个虚拟化环境内， 那么以最内层的那个为准。 可以在这些关键字前面加上感叹号(!)前缀表示逻辑反转。
			ConditionHost=	检测系统的 hostname 或者 "machine ID" 。 参数可以是一个主机名字符串(首尾可加引号界定)， 或者是一个 "machine ID" 格式的字符串(首尾不可加引号)， 参见 machine-id(5) 手册。 可以在字符串前面加上感叹号(!)前缀表示逻辑反转。
			ConditionKernelCommandLine=	检测是否设置了某个特定的内核引导选项。 参数可以是一个单独的单词，也可以是一个 "var=val" 格式的赋值字符串。 如果参数是一个单独的单词，那么以下两种情况都算是检测成功： (1)恰好存在一个完全匹配的单词选项； (2)在某个 "var=val" 格式的内核引导选项中等号前的 "var" 恰好与该单词完全匹配。 如果参数是一个 "var=val" 格式的赋值字符串， 那么必须恰好存在一个完全匹配的 "var=val" 格式的内核引导选项，才算检测成功。 可以在字符串前面加上感叹号(!)前缀表示逻辑反转。
			ConditionSecurity=	检测是否启用了特定的安全模块： selinux, apparmor, ima, smack, audit 。 可以在这些关键字前面加上感叹号(!)前缀表示逻辑反转。
			ConditionCapability=	检测 systemd 的 capability 集合中是否存在特定的 capabilities(7) 。 参数应设为例如 "CAP_MKNOD" 这样的 capability 名称。 注意，此选项不是检测特定的 capability 是否实际可用， 而是仅检测特定的 capability 在绑定集合中是否存在。 可以在名称前面加上感叹号(!)前缀表示逻辑反转。
			ConditionACPower=	检测系统是否正在使用交流电源。 yes 表示至少在使用一个交流电源， 或者更本不存在任何交流电源。 no 表示存在交流电源， 但是没有使用其中的任何一个。
			ConditionNeedsUpdate=	可设为 /var 或 /etc 之一， 用于检测指定的目录是否需要更新。 设为 /var 表示 检测 /usr 目录的最后更新时间(mtime) 是否比 /var/.updated 文件的最后更新时间(mtime)更晚。 设为 /etc 表示 检测 /usr 目录的最后更新时间(mtime) 是否比 /etc/.updated 文件的最后更新时间(mtime)更晚。 可以在值前面加上感叹号(!)前缀表示逻辑反转。 当更新了 /usr 中的资源之后，可以通过使用此选项， 实现在下一次启动时更新 /etc 或 /var 目录的目的。 使用此选项的单元必须设置 ConditionFirstBoot=systemd-update-done.service ， 以确保在 .updated 文件被更新之前启动完毕。 参见 systemd-update-done.service(8) 手册。
			ConditionFirstBoot=	可设为 yes 或 no 。 用于检测 /etc 目录 是否处于未填充的原始状态 (也就是系统出厂后的首次启动)。 此选项可用于系统出厂后，首次开机时执行必要的初始化操作。
			ConditionPathExists=	检测指定的路径是否存在， 必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionPathExistsGlob=	与 ConditionPathExists= 类似， 唯一的不同是支持通配符。
			ConditionPathIsDirectory=	检测指定的路径是否存在并且是一个目录，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionPathIsSymbolicLink=	检测指定的路径是否存在并且是一个软连接，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionPathIsMountPoint=	检测指定的路径是否存在并且是一个挂载点，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionPathIsReadWrite=	检测指定的路径是否存在并且可读写(rw)，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionDirectoryNotEmpty=	检测指定的路径是否存在并且是一个非空的目录，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionDirectoryNotEmpty=	检测指定的路径是否存在并且是一个非空的目录，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionFileNotEmpty=	检测指定的路径是否存在并且是一个非空的普通文件，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
			ConditionFileIsExecutable=	检测指定的路径是否存在并且是一个可执行文件，必须使用绝对路径。 可以在路径前面加上感叹号(!)前缀表示逻辑反转。
		Service:	是服务的关键,是服务运行的一些具体参数的设置
			Type= 	下列之一
				simple  表示ExecStart=进程是该服务的主进程,如果它需要为其他进程提供服务,那么必须在该服务启动前先建立好通信渠道,比如套接字,以加快后续单元的启动速度
				forking 表示ExecStart=进程将会在启动时使用fork()函数,这是传统Unix的做法,也就是这个进程将由systemd进程fork出来,然后当该进程准备就绪时,systemd进程退出,而fork出来的进程作为服务的主进程继续运行,对于此类型的进程,建议设置PIDFile=选项，以帮助systemd准确定位该服务的主进程
				oneshot	该进程会在systemd启动后续单元之前退出，适用于仅需要执行一次的程序。比如清理磁盘，你只需要执行一次，不需要一直在后台运行这个程序
				dbus    该进程需要在D-Bus上获得一个由BusName=指定的名称，systemd将会在启动后续单元之前，首先确保该进程已经成功的获取了指定D-Bus名称。
				notify  与simple类似，不同之处在于该进程会在启动完成之后通过sd_notify之类的接口发送一个通知消息。systemd在启动后续单元之前，必须确保该进程已经成功地发送了一个消息。
				idel    与simple类似，不同之处在于该进程将会被延迟到所有操作都完成之后在执行。这样可以避免控制台上的状态信息与shell脚本的输出混在在一起。
			ReaminAfterExit=	 当该服务的所有进程都退出之后，是否依然将此无视为活动的，默认为no。
			User=			设置服务运行的用户,既可以设为数字形式的ID也可以设为字符串形式的名称。 如果没有明确设置 Group= 选项，则使用 User= 所属的默认组。 此选项不影响带有 "+" 前缀的命令
			Group=			设置服务运行的用户组,既可以设为数字形式的ID也可以设为字符串形式的名称。 如果没有明确设置 Group= 选项，则使用 User= 所属的默认组。 此选项不影响带有 "+" 前缀的命令
			PIDFile				守护进程的PID文件，必须是绝对路径，强烈建议在Type=forking的情况下明确设置此选项。这个路径也不是随便写的，而是你的进程实际的PID文件路径。这样systemd才能正确的读取该文件，但是它不会写入，只是会在服务停止后删除该文件，如果存在的话。
			GuessMainPID=	    在没有设置PIDFile=值的时候，systemd是否要猜测主进程的PID。默认是yes。
			ExecStartPre=		在执行ExecStart之前运行的命令。规则与ExecStart=相同
			ExecStartPost=		在执行ExecStart之后运行的命令
				对于ExecStartPost= 命令仅在服务已经启动成功之后才会运行，判断的标准基于 Type= 选项。 具体说来，对于 Type=simple 或 Type=idle 就是主进程已经成功启动； 对于 Type=oneshot 来说就是主进程已经成功退出； 对于 Type=forking 来说就是初始进程已经成功退出； 对于 Type=notify 来说就是已经发送了 "READY=1" ； 对于 Type=dbus 来说就是已经取得了 BusName= 中设置的总线名称。注意一下2点：
				不可将 ExecStartPre= 用于需要长时间执行的进程。 因为所有由 ExecStartPre= 派生的子进程 都会在启动 ExecStart= 服务进程之前被杀死。
				如果在服务启动完成之前，任意一个 ExecStartPre=, ExecStart=, ExecStartPost= 中无 "-" 前缀的命令执行失败或超时， 那么，ExecStopPost= 将会被继续执行，而 ExecStop= 则会被跳过。
			ExecStart			设置启动服务是要执行的命令(命令+参数)。命令行必须是一个绝对路径表示可执行文件的位置，后面可以跟多个该命令支持的参数。如果在命令前面加上下面的标志，将会有不同含义:
				@：表示后面的参数一次传递给被执行的程序
				-：表示即使该进程以失败状态退出，也会被视为成功退出
				+：表示该进程拥有超级用户特权
				如果设置多个ExecStart=那么将依次运行，如果某个没有“-”前缀的命令执行失败，那么后续的ExecStart=将不会执行，同时该单元变为失败(failed)状态。
				如果没有设置Type=forking时，这里的命令所启动的进程，将被视为该服务的主守护进程。
			ExecReload=	
				这是一个可选的指令， 用于设置当该服务被要求重新载入配置时所执行的命令行。 语法规则与 ExecStart= 完全相同。
				另外，还有一个特殊的环境变量 $MAINPID 可用于表示主进程的PID， 例如可以这样使用：/bin/kill -HUP $MAINPID
				注意，像上例那样，通过向守护进程发送复位信号， 强制其重新加载配置文件，并不是一个好习惯。 因为这是一个异步操作， 所以不适用于需要按照特定顺序重新加载配置文件的服务。 我们强烈建议将 ExecReload= 设为一个 能够确保重新加载配置文件的操作同步完成的命令行
			ExecStopPost=
				这是一个可选的指令， 用于设置在该服务停止之后所执行的命令行。 语法规则与 ExecStart= 完全相同。 注意，与 ExecStop= 不同，无论服务是否启动成功， 此选项中设置的命令都会在服务停止后被无条件的执行。
				应该将此选项用于设置那些无论服务是否启动成功都必须在服务停止后无条件执行的清理操作。 此选项设置的命令必须能够正确处理由于服务启动失败而造成的各种残缺不全以及数据不一致的场景。 由于此选项设置的命令在执行时，整个服务的所有进程都已经全部结束，所以无法与服务进行任何通信。
			RestartSec=			设置在重启服务(Restart=)前暂停多长时间。 默认值是100毫秒(100ms)。 如果未指定时间单位，那么将视为以秒为单位。 例如设为"20"等价于设为"20s"
			TimeoutStartSec=	设置该服务允许的最大启动时长。 如果守护进程未能在限定的时长内发出"启动完毕"的信号，那么该服务将被视为启动失败，并会被关闭。 如果未指定时间单位，那么将视为以秒为单位。
			TimeoutStopSec=		设置该服务允许的最大停止时长。 如果该服务未能在限定的时长内成功停止， 那么将会被强制使用 SIGTERM 信号关闭， 如果依然未能在相同的时长内成功停止， 那么将会被强制使用 SIGKILL 信号关闭。如果未指定时间单位，那么将视为以秒为单位。 例如设为"20"等价于设为"20s"。 设为 "infinity" 则表示永不超时。
			RuntimeMaxSec=	    允许服务持续运行的最大时长。 如果服务持续运行超过了此处限制的时长，那么该服务将会被强制终止，同时将该服务变为失败(failed)状态。 注意，此选项对 Type=oneshot 类型的服务无效，因为它们会在启动完成后立即终止。 默认值为 "infinity" (不限时长)。
			WatchdogSec=		设置该服务的看门狗(watchdog)的超时时长。 看门狗将在服务成功启动之后被启动。 该服务在运行过程中必须周期性的以 "WATCHDOG=1" ("keep-alive ping")调用 sd_notify(3) 函数。 如果在两次调用之间的时间间隔大于这里设定的值， 那么该服务将被视为失败(failed)状态， 并会被强制使用 SIGABRT 信号关闭。 通过将 Restart= 设为 on-failure, on-watchdog, on-abnormal, always 之一， 可以实现在失败状态下的自动重启该服务。 这里设置的值将会通过 WATCHDOG_USEC= 环境变量传递给守护进程， 这样就允许那些支持看门狗的服务自动启用"keep-alive ping"。 如果设置了此选项， 那么必须将 NotifyAccess= 设为 main(此种情况下的隐含默认值) 或 all 。 如果未指定时间单位，那么将视为以秒为单位。 例如设为"20"等价于设为"20s"。 默认值"0"表示禁用看门狗功能。 详见 sd_watchdog_enabled(3) 与 sd_event_set_watchdog(3) 手册。
			Restart=			当服务进程正常退出、异常退出、被杀死、超时的时候，是否重启系统该服务。进程通过正常操作被停止则不会被执行重启。可选值为：
				no：默认值，表示任何时候都不会被重启
				always：表示会被无条件重启
				no-success：表示仅在服务进程正常退出时重启				
				on-failure：表示仅在服务进程异常退出时重启				
				所谓正常退出是指，退出码为“0”，或者到IGHUP, SIGINT, SIGTERM, SIGPIPE 信号之一，并且退出码符合 SuccessExitStatus= 的设置。				
				所谓异常退出时指，退出码不为“0”，或者被强杀或者因为超时被杀死。
			ExecStop			停止命令
			PrivateTmp=true		表示给服务分配独立的临时空间
			BusName=			设置与此服务通讯所使用的D-Bus名称，如果Type=dbus，则必须设置此项
			SuccessExitStatus=	额外定义附加的进程"正常退出"状态。 可以设为一系列以空格分隔的数字退出码或者信号名称
			WorkingDirectory=	设置进程的工作目录。 既可以设为特殊值 "~" 表示 User= 用户的家目录， 也可以设为一个以 RootDirectory= 为基准的绝对路径。 例如当 RootDirectory=/sysroot 并且 WorkingDirectory=/work/dir 时， 实际的工作目录将是 /sysroot/work/dir 。 当 systemd 作为系统实例运行时，此选项的默认值是 / ； 当 systemd 作为用户实例运行时，此选项的默认值是对应用户的家目录。 如果给目录加上 "-" 前缀， 那么表示即使此目录不存在，也不算致命错误。 如果未设置 RootDirectory= 选项， 那么为 WorkingDirectory= 设置的绝对路径 将以主机(或容器)的根目录(也就是运行 systemd 的系统根目录)为基准。 注意，设置此选项将会导致自动添加额外的依赖关系(见上文)。
			RootDirectory=		设置以 chroot(2) 方式执行进程时的根目录。 必须设为一个以主机(或容器)的根目录(也就是运行 systemd 的系统根目录)为基准的绝对路径。 如果设置了此选项， 必须确保进程及其辅助文件在 chroot() 监狱中确实可用。 注意，设置此选项将会导致自动添加额外的依赖关系(见上文)。
			Nice=				设置进程的默认谦让值。 可以设为 -20(最高优先级) 到 19(最低优先级) 之间的整数值
			Environment=	    设置进程的环境变量， 值是一个空格分隔的 VAR=VALUE 列表。 可以多次使用此选项以增加新的变量或者修改已有的变量 (同一个变量以最后一次的设置为准)。 若设为空， 则表示清空先前所有已设置的变量。 注意： (1)不会在字符串内部进行变量展开(也就是"$"没有特殊含义)； (2)如果值中包含空格， 那么必须在字符串两边使用双引号("")界定
			KillMode=
				control-group(默认值)：当前控制组里面的所有子进程，都会被杀掉
				process 				 只杀主进程
				mixed：					 主进程将收到 SIGTERM 信号，子进程收到 SIGKILL 信号
				none：					 没有进程会被杀掉，只是执行服务的 stop 命令。
			EnvironmentFile=	
					与 Environment= 类似， 不同之处在于此选项是从文本文件中读取环境变量的设置。 文件中的空行以及以分号(;)或井号(#)开头的行会被忽略， 其他行的格式必须符合 VAR=VALUE 的shell变量赋值语法。 行尾的反斜杠(\)将被视为续行符， 这与shell语法类似。 若想在变量值中包含空格， 则必须在值的两端加上双引号(")界定。
					文件必须用绝对路径表示(可以包含通配符)。 但可在路径前加上"-"前缀表示忽略不存在的文件。 可以多次使用此选项， 以从多个不同的文件中读取设置。 若设为空， 则表示清空所有先前已经从文件中读取的环境变量。
					这里列出的文件将在进程启动前的瞬间被读取， 因此可以由前一个单元生成配置文件， 再由后一个单元去读取它。
					从文件中读取的环境变量会覆盖 Environment= 中设置的同名变量。 文件的读取顺序就是它们出现在单元文件中的顺序， 并且对于同一个变量，以最后读取的文件中的设置为准。
		[Install] 段：这个段包含单元启动信息，只有单元状态为enable或者disabled才会用到这个段，这个段不能出现在单元的.d/*.conf配置文件中。
			Alias=	启用时使用的别名，可以设为一个空格分隔的别名列表。 每个别名的后缀(也就是单元类型)都必须与该单元自身的后缀相同。 如果多次使用此选项，那么每个选项所设置的别名都会被添加到别名列表中。 在启用此单元时，systemctl enable 命令将会为每个别名创建一个指向该单元文件的软连接。 注意，因为 mount, slice, swap, automount 单元不支持别名，所以不要在这些类型的单元中使用此选项。
			WantedBy=
			RequiredBy= 接受一个空格分隔的单元列表， 表示在使用 systemctl enable 启用此单元时， 将会在每个列表单元的 .wants/ 或 .requires/ 目录中创建一个指向该单元文件的软连接。 这相当于为每个列表中的单元文件添加了 Wants=此单元 或 Requires=此单元 选项。 这样当列表中的任意一个单元启动时，该单元都会被启动。 有关 Wants= 与 Requires= 的详细说明， 参见前面 [Unit] 小节的说明。 如果多次使用此选项，那么每个选项的单元列表都会合并在一起。
						这个选项跟启动级别有关，通常设置的值为mult-user.targe 这是一个target，之后再讲，你只需要知道这相当于启动级别中的多用户默认。
			Also=		设置此单元的附属单元，可以设为一个空格分隔的单元列表。 表示当使用 systemctl enable 启用 或 systemctl disable 停用 此单元时， 也同时自动的启用或停用附属单元。如果多次使用此选项， 那么每个选项所设置的附属单元列表都会合并在一起。
			DefaultInstance=	仅对模板单元有意义， 用于指定默认的实例名称。 如果启用此单元时没有指定实例名称， 那么将使用这里设置的名称。
	
journalctl  服务日志管理
	--no-full,--full, -l
		如果字段内容超长则以省略号(…)截断以适应列宽。 默认显示完整的字段内容(超长的部分换行显示或者被分页工具截断)。
		老旧的 -l/--full 选项 仅用于撤销已有的--no-full 选项，除此之外没有其他用处。
	-a, --all
		完整显示所有字段内容， 即使其中包含不可打印字符或者字段内容超长。
	-f, --follow
		只显示最新的日志项，并且不断显示新生成的日志项。 此选项隐含了 -n 选项。
	-e, --pager-end
		在分页工具内立即跳转到日志的尾部。 此选项隐含了 -n1000 以确保分页工具不必缓存太多的日志行。 不过这个隐含的行数可以被明确设置的-n 选项覆盖。 注意，此选项仅可用于 less(1) 分页器。
	-n, --lines=
		限制显示最新的日志行数。 --pager-end 与 --follow 隐含了此选项。 此选项的参数：若为正整数则表示最大行数； 若为 "all" 则表示不限制行数； 若不设参数则表示默认值10行。
	--no-tail
		显示所有日志行， 也就是用于撤销已有的 --lines= 选项(即使与 -f 连用)。
	-r, --reverse
		反转日志行的输出顺序， 也就是最先显示最新的日志。
	-o, --output=
		控制日志的输出格式。 可以使用如下选项：
		short
			这是默认值， 其输出格式与传统的 syslog 文件的格式相似， 每条日志一行。
		short-iso
			与 short 类似，只是将时间戳字段以 ISO 8601 格式显示。
		short-precise
			与 short 类似，只是将时间戳字段的秒数精确到微秒级别。
		short-monotonic
			与 short 类似，只是将时间戳字段的零值从内核启动时开始计算。
		short-unix
			与 short 类似，只是将时间戳字段显示为从"UNIX时间原点"(1970-1-1 00:00:00 UTC)以来的秒数。 精确到微秒级别。
		verbose
			以结构化的格式显示每条日志的所有字段。
		export
			将日志序列化为二进制字节流(大部分依然是文本) 以适用于备份与网络传输(详见 Journal Export Format 文档)。
		json
			将日志项按照JSON数据结构格式化， 每条日志一行(详见 Journal JSON Format 文档)。
		json-pretty
			将日志项按照JSON数据结构格式化， 但是每个字段一行， 以便于人类阅读。
		json-sse
			将日志项按照JSON数据结构格式化，每条日志一行，但是用大括号包围， 以适应 Server-Sent Events 的要求。
		cat
			仅显示日志的实际内容， 而不显示与此日志相关的任何元数据(包括时间戳)。
		--utc
			以世界统一时间(UTC)表示时间
		--no-hostname
			不显示来源于本机的日志消息的主机名字段。 此选项仅对 short 系列输出格式(见上文)有效。
		-x, --catalog
			在日志的输出中增加一些解释性的短文本， 以帮助进一步说明日志的含义、 问题的解决方案、支持论坛、 开发文档、以及其他任何内容。 并非所有日志都有这些额外的帮助文本， 详见Message Catalog Developer Documentation 文档。
			注意，如果要将日志输出用于bug报告， 请不要使用此选项。
	-q, --quiet
		当以普通用户身份运行时， 不显示任何警告信息与提示信息。 例如："-- Logs begin at ...", "-- Reboot --"
	-m, --merge
		混合显示包括远程日志在内的所有可见日志。
	-b [ID][±offset],--boot=[ID][±offset]
		显示特定于某次启动的日志， 这相当于添加了一个 "_BOOT_ID=" 匹配条件。
		如果参数为空(也就是 ID 与±offset 都未指定)， 则表示仅显示本次启动的日志。
		如果省略了 ID ， 那么当±offset 是正数的时候， 将从日志头开始正向查找， 否则(也就是为负数或零)将从日志尾开始反响查找。 举例来说， "-b 1"表示按时间顺序排列最早的那次启动， "-b 2"则表示在时间上第二早的那次启动； "-b -0"表示最后一次启动， "-b -1"表示在时间上第二近的那次启动， 以此类推。 如果±offset 也省略了， 那么相当于"-b -0"， 除非本次启动不是最后一次启动(例如用--directory 指定了另外一台主机上的日志目录)。
		如果指定了32字符的 ID ， 那么表示以此ID 所代表的那次启动为基准 计算偏移量(±offset)， 计算方法同上。 换句话说， 省略ID 表示以本次启动为基准 计算偏移量(±offset)。
	--list-boots
		列出每次启动的 序号(也就是相对于本次启动的偏移量)、32字符的ID、 第一条日志的时间戳、最后一条日志的时间戳。
	-k, --dmesg
		仅显示内核日志。隐含了 -b 选项以及 "_TRANSPORT=kernel" 匹配项。
	-t, --identifier=SYSLOG_IDENTIFIER
		仅显示 syslog 识别符为 SYSLOG_IDENTIFIER 的日志项。
		可以多次使用该选项以指定多个识别符。
	-u, --unit=UNIT|PATTERN
		仅显示属于特定单元的日志。 也就是单元名称正好等于 UNIT 或者符合 PATTERN 模式的单元。 这相当于添加了一个 "_SYSTEMD_UNIT=UNIT" 匹配项(对于UNIT 来说)， 或一组匹配项(对于PATTERN 来说)。
		可以多次使用此选项以添加多个并列的匹配条件(相当于用"OR"逻辑连接)。
	--user-unit=
		仅显示属于特定用户会话单元的日志。 相当于同时添加了 "_SYSTEMD_USER_UNIT=" 与 "_UID=" 两个匹配条件。
		可以多次使用此选项以添加多个并列的匹配条件(相当于用"OR"逻辑连接)。
	-p, --priority=
		根据日志等级(包括等级范围)过滤输出结果。 日志等级数字与其名称之间的对应关系如下 (参见 syslog(3))： "emerg" (0), "alert" (1), "crit" (2), "err" (3), "warning" (4), "notice" (5), "info" (6), "debug" (7) 。 若设为一个单独的数字或日志等级名称， 则表示仅显示小于或等于此等级的日志 (也就是重要程度等于或高于此等级的日志)。 若使用 FROM..TO.. 设置一个范围， 则表示仅显示指定的等级范围内(含两端)的日志。 此选项相当于添加了 "PRIORITY=" 匹配条件。
	-c, --cursor=
		从指定的游标(cursor)开始显示日志。 [提示]每条日志都有一个"__CURSOR"字段，类似于该条日志的指纹。
	--after-cursor=
		从指定的游标(cursor)之后开始显示日志。 如果使用了 --show-cursor 选项， 则也会显示游标本身。
	--show-cursor
		在最后一条日志之后显示游标， 类似下面这样，以"--"开头：
	-- cursor: s=0639...
		游标的具体格式是私有的(也就是没有公开的规范)， 并且会变化。
	-S, --since=,-U, --until=
		显示晚于指定时间(--since=)的日志、显示早于指定时间(--until=)的日志。 参数的格式类似 "2012-10-30 18:17:16" 这样。 如果省略了"时:分:秒"部分， 则相当于设为 "00:00:00" 。 如果仅省略了"秒"的部分则相当于设为 ":00" 。 如果省略了"年-月-日"部分， 则相当于设为当前日期。 除了"年-月-日 时:分:秒"格式， 参数还可以进行如下设置： (1)设为 "yesterday", "today", "tomorrow" 以表示那一天的零点(00:00:00)。 (2)设为 "now" 以表示当前时间。 (3)可以在"年-月-日 时:分:秒"前加上 "-"(前移) 或 "+"(后移) 前缀以表示相对于当前时间的偏移。 关于时间与日期的详细规范， 参见 systemd.time(7)
	-F, --field=
		显示所有日志中某个字段的所有可能值。 [译者注]类似于SQL语句："SELECT DISTINCT 某字段 FROM 全部日志"
	-N, --fields
		输出所有日志字段的名称
	--system, --user
		仅显示系统服务与内核的日志(--system)、 仅显示当前用户的日志(--user)。 如果两个选项都未指定，则显示当前用户的所有可见日志。
	-M, --machine=
		显示来自于正在运行的、特定名称的本地容器的日志。 参数必须是一个本地容器的名称。
	-D DIR, --directory=DIR
		仅显示来自于特定目录中的日志， 而不是默认的运行时和系统日志目录中的日志。
	--file=GLOB
		GLOB 是一个可以包含"?"与"*"的文件路径匹配模式。 表示仅显示来自与指定的GLOB 模式匹配的文件中的日志， 而不是默认的运行时和系统日志目录中的日志。 可以多次使用此选项以指定多个匹配模式(多个模式之间用"OR"逻辑连接)。
	--root=ROOT
		在对日志进行操作时， 将 ROOT 视为系统的根目录。 例如--update-catalog 将会创建 ROOT/var/lib/systemd/catalog/database
	--new-id128
		此选项并不用于显示日志内容， 而是用于重新生成一个标识日志分类的 128-bit ID 。 此选项的目的在于 帮助开发者生成易于辨别的日志消息， 以方便调试。
	--header
		此选项并不用于显示日志内容， 而是用于显示日志文件内部的头信息(类似于元数据)。
	--disk-usage
		此选项并不用于显示日志内容， 而是用于显示所有日志文件(归档文件与活动文件)的磁盘占用总量。
	--vacuum-size=,--vacuum-time=, --vacuum-files=
		这些选项并不用于显示日志内容， 而是用于清理日志归档文件(并不清理活动的日志文件)， 以释放磁盘空间。 --vacuum-size= 可用于限制归档文件的最大磁盘使用量 (可以使用 "K", "M", "G", "T" 后缀)； --vacuum-time= 可用于清除指定时间之前的归档 (可以使用 "s", "m", "h", "days", "weeks", "months", "years" 后缀)； --vacuum-files= 可用于限制日志归档文件的最大数量。 注意，--vacuum-size= 对--disk-usage 的输出仅有间接效果， 因为 --disk-usage 输出的是归档日志与活动日志的总量。 同样，--vacuum-files= 也未必一定会减少日志文件的总数， 因为它同样仅作用于归档文件而不会删除活动的日志文件。 此三个选项可以同时使用，以同时从三个维度去限制归档文件。 若将某选项设为零，则表示取消此选项的限制。
	--list-catalog [128-bit-ID...]
		简要列出日志分类信息， 其中包括对分类信息的简要描述。
		如果明确指定了分类ID(128-bit-ID)， 那么仅显示指定的分类。
	--dump-catalog [128-bit-ID...]
		详细列出日志分类信息 (格式与 .catalog 文件相同)。
		如果明确指定了分类ID(128-bit-ID)， 那么仅显示指定的分类。
	--update-catalog
		更新日志分类索引二进制文件。 每当安装、删除、更新了分类文件，都需要执行一次此动作。
	--setup-keys
		此选项并不用于显示日志内容， 而是用于生成一个新的FSS(Forward Secure Sealing)密钥对。 此密钥对包含一个"sealing key"与一个"verification key"。 "sealing key"保存在本地日志目录中， 而"verification key"则必须保存在其他地方。 详见journald.conf(5) 中的Seal= 选项。
	--force
		与 --setup-keys 连用， 表示即使已经配置了FSS(Forward Secure Sealing)密钥对， 也要强制重新生成。
	--interval=
		与 --setup-keys 连用，指定"sealing key"的变化间隔。 较短的时间间隔会导致占用更多的CPU资源， 但是能够减少未检测的日志变化时间。 默认值是 15min
	--verify¶
		检查日志文件的内在一致性。 如果日志文件在生成时开启了FSS特性， 并且使用 --verify-key= 指定了FSS的"verification key"， 那么，同时还将验证日志文件的真实性。
	--verify-key=
		与 --verify 选项连用， 指定FSS的"verification key"
	--sync
		要求日志守护进程将所有未写入磁盘的日志数据刷写到磁盘上， 并且一直阻塞到刷写操作实际完成之后才返回。 因此该命令可以保证当它返回的时候， 所有在调用此命令的时间点之前的日志， 已经全部安全的刷写到了磁盘中。
	--flush
		要求日志守护进程 将 /run/log/journal 中的日志数据 刷写到 /var/log/journal 中 (如果持久存储设备当前可用的话)。 此操作会一直阻塞到操作完成之后才会返回， 因此可以确保在该命令返回时， 数据转移确实已经完成。 注意，此命令仅执行一个单独的、一次性的转移动作， 若没有数据需要转移， 则此命令什么也不做， 并且也会返回一个表示操作已正确完成的返回值。
	--rotate
		要求日志守护进程滚动日志文件。 此命令会一直阻塞到滚动完成之后才会返回。
	-h, --help
		显示简短的帮助信息并退出。
	--version
		显示简短的版本信息并退出。
	--no-pager
		不将程序的输出内容管道(pipe)给分页程序。
	
	
selinux				(Security-Enhanced Linux) 是美国国家安全局(NSA)对于强制访问控制的实现,是 linux历史上最杰出的新安全子系统。它不是用来防火墙设置的。但它对Linux系统的安全很有用
	配置文件位于/etc/sysconfig/selinux或/etc/selinux/config
		SELINUX=enforcing|permissive|disabled 		强制模式,并提供限制存取机制|开启功能,但是提供警告模式代替代替限制机制|关闭
		SELINUXTYPE=targeted|strict					只对主要的网络服务进行保护|对整个系统进行保护
iptables			iptables用于过滤数据包,属于网络层防火墙./etc/sysconfig/iptables-config可默认关闭,服务名称是firewalld
	-t	后面接table,例如net或filter,若省略此项目,则使用默认的filter
	-L	列出目前的table规则
	-n	不进行IP与HOSTNAME的反查,显示信息的速度会快很多
	-v	列出更多的信息,包括通过该规则的封包总位数,相关的网络接口等
	-F	清除所有已制定的规则
	-X	杀掉所有使用者"自定义"的chain(说的是tables)
	-Z	将所有的chain的计数与流量统计都归零
	-P	定义预设规则,ACCEPT为可接受,DROP为丢弃,例:iptables -P INPUT DROP
		例:kubernets微服务定义了nodePort,外部却无法访问,可以设置iptables -P FORWARD ACCEPT
iptables-save		会列出完整的防火墙规则,只是没有规格化输出
	-t	后面接table,可以指定输出table的规则,而不是所有的
firewalld			firewall是centos7里面的新的防火墙命令,它底层还是使用 iptables 对内核命令动态通信包过滤的,简单理解就是firewall是centos7下管理iptables的新命令

iptables里有多个表格,每个表格定义出自己的默认政策与规划,且每个表格的用途都不相同
	filter(过滤器):主要跟进入Linux本机的封包有关,是预设的table
		INPUT:主要与想要进入我们Linux本机的封包有关
		OUTPUT:主要与我们Linux本机所要送出的封包有关
		FORWARD:与Linux本机比较没有关系,他可以"转递封包"到后端的计算机中
	nat(地址转换):是Network Address Translation的缩写,主要在进行来源与目的之IP或port的转换,与Linux本机较无关,主要与Linux主机后的局域网络内计算机较有相关
		PREROUTING:在进行路由判断之前所要进行的规则(DNAT/REDIRECT)
		POSTROUTING:在进行路由判断之后所要进行的规则(SNAT/MASQUERADE)
		OUTPUT:与发送出去的封包有关
	mangle(破坏者):这个表格主要是与特殊的封包的路由旗杆有关,早期仅有PREROUTING及OUTPUT链,不过从kernel 2.4.18之后加入了INPUT及FORWARD链
					由于这个表格与特殊旗标相关性较高,所以像我们单纯的环境中,较少使用这个表格

getenforce		查看SElinux服务状态
setenforce 0	临时设置SElinux关闭,常久关闭修改/etc/selinux/config,增加SELINUX=disabled 

syslogd			进行系统或者是网络服务的登录文件记录工作;
logrotate		将旧的数据更名,并且建立新的档案,并视设定将最旧的登录档删除

核心编译
	make menuconfig		利用类似单选模式的方式进行核心参数的挑选
	make X Window		得用X Window的功能来进行挑选
	make gconfig		利用GDK函式库的图形接口来选择,也需要X Window支持

	make clean
	make bzImage
	make modules
	make modules install

date 用法： date [OPTION]... [+FORMAT
转秒用%s
date +%s
date -d "2014-10-25 11:11:11" +%s
秒转标准时间：
date -d "1970-1-1 0:0:0 +1415101567 seconds"
date -d @1415101567 
-s 	设定系统时间
%n : 下一行
%t : 跳格
%H : 小时(00-23)
%I : 小时(01-12)
%k : 小时(0-23)
%l : 小时(1-12)
%M : 分钟(00-59)
%p : 显示本地 AM 或 PM
%r : 直接显示时间 (12 小时制,格式为 hh:mm:ss [AP]M)
%s : 从 1970 年 1 月 1 日 00:00:00 UTC 到目前为止的秒数
%S : 秒(00-60)
%T : 直接显示时间 (24 小时制)
%X : 相当于 %H:%M:%S
%Z : 显示时区 %a : 星期几 (Sun-Sat)
%A : 星期几 (Sunday-Saturday)
%b : 月份 (Jan-Dec)
%B : 月份 (January-December)
%c : 直接显示日期与时间
%d : 日 (01-31)
%D : 直接显示日期 (mm/dd/yy)
%h : 同 %b
%j : 一年中的第几天 (001-366)
%m : 月份 (01-12)
%U : 一年中的第几周 (00-53) (以 Sunday 为一周的第一天的情形)
%w : 一周中的第几天 (0-6)
%W : 一年中的第几周 (00-53) (以 Monday 为一周的第一天的情形)
%x : 直接显示日期 (mm/dd/yy)
%y : 年份的最后两位数字 (00-99)
%Y : 完整年份 (0000-9999)



负数取模
x mod y = x - y * x / y
上面公式的意思是:
x mod y等于 x 减去 y 乘上 x与y的商的下界. 

ctags -R --c++-kinds=+px --fields=+iaS --extra=+q
ctags -R --languages=c++ --langmap=c++:+.inl -h +.inl --c++-kinds=+px --fields=+aiKSz --extra=+q --exclude=lex.yy.cc --exclude=copy_lex.yy.cc
-R												递归
--languages=c++									只扫描文件内容为c++的文件
--langmap=c++:+.inl								告知ctags,以inl为扩展名的文件是c++语言写的,在加之上述2中的选项,即要求ctags以c++语法扫描以inl为扩展名的文件
-h +.inl										告知ctags,把以inl为扩展名的文件看作是头文件的一种
--c++-kinds=+px									记录类型为函数声明和前向声明的语法元素
--fields=+aiKSz									控制记录的内容
--extra=+q										让ctags额外记录一些东西
--exclude=lex.yy.cc --exclude=copy_lex.yy.cc	告知ctags不要扫描名字是这样的文件
-f tagfile										指定生成的标签文件名,默认是tags

ctags里的kind
	x 					声明一个变量
	f(function)			函数实现
	p(prototype) 		函数声明
	c(class)			类定义
	s(struct)			结构体定义
	m(macro)			宏定义
	
pushd  目录   将某个目录放个栈中,实现快速切换,不加任何参数在最近的2个目录切换,当前目录总是位于堆栈的最上方
+n		n为数字,切换到第几个,popd时表示将第几个弹出
popd   目录   将某个目录从栈中弹出
pushd与popd都可以只影响堆栈而不切换目录,加上-n参数即可
dirs	先显示当前所在目录,然后显示栈中存在的目录
-p	以每行一个目录的方式显示栈中目录
-v	显示序号,不用加-p就会以每行一个目录的方式显示
-c	清除堆栈

locale		查看当前系统语系
	-a		查看所有支持的语系
默认语系(LANG)
1、语言符号及其分类(LC_CTYPE) 
2、数字(LC_NUMERIC) 
3、比较和排序习惯(LC_COLLATE) 
4、时间显示格式(LC_TIME) 
5、货币单位(LC_MONETARY) 
6、信息主要是提示信息,错误信息,状态信息,标题,标签,按钮和菜单等(LC_MESSAGES) 
7、姓名书写方式(LC_NAME) 
8、地址书写方式(LC_ADDRESS) 
9、电话号码书写方式(LC_TELEPHONE) 
10、度量衡表达方式 (LC_MEASUREMENT) 
11、默认纸张尺寸大小(LC_PAPER) 
12、对locale自身包含信息的概述(LC_IDENTIFICATION)。
最上级设定(LC_ALL)
LC_ALL>LC_*>LANG

sqlplus usr/pwd@//host:port/sid
usr：用户名
pwd：密码
host：数据库服务器IP
port：端口
sid：数据库标识符

dba_tables : 
all_tables : 当前用户有权限的表的信息(只要对某个表有任何权限,即可在此视图中看到表的相关信息)
user_tables: 当前用户名下的表的信息

select /*+ parallel(a,10) */ * from ucr_yz01.TG_CDR_DECODE  a 
where substr(a.file_no, 1, 10) = '0VGH731H02'  and a.source_type = '1A'

在 core文件 中 打印进程启动的配置文件和 序号：
p *(od_frame::CProgParam::m_ppArgv)
p od_frame::CProgParam::m_ppArgv[2]

Base64编码的思想是是采用64个基本的ASCII码字符对数据进行重新编码。它将需要编码的数据拆分成字节数组。以3个字节为一组。按顺序排列24位数据,再把这24位数据分成4组,即每组6位。再在每组的的最高位前补两个0凑足一个字节。这样就把一个3字节为一组的数据重新编码成了4个字节。当所要编码的数据的字节数不是3的整倍数,也就是说在分组时最后一组不够3个字节。这时在最后一组填充1到2个0字节。并在最后编码完成后在结尾添加1到2个"="。( 注BASE64字符表：ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/)
base64		从标准输入中读取数据,按CTRL+D结束输入,将输入的内容编码为base64字符串输出
echo "str" | base64		将字符str+换行编码为base64字符串输出
base64 -d	从标准输入中读取已经进行base64编码的内容,解码输出
base64 -d -i 加上-i参数,忽略非字母表字符,比如换行符

md5sum	用来计算和校验文件报文摘要的工具程序。

size 可执行程序		可查看段大小信息,bss,text,data段大小信息
LIBRARY_PATH		gcc编译器在编译链接时查找库的路径
LD_LIBRARY_PATH		程序运行时查找动态库路径

回调函数:	将保持不变的东西与变化的东西分隔开,一种函数指针,想让别人的代码执行你的代码,而别人的代码你又不能动,面向对象的封装性,模块间要解耦,模块内要内聚

ISO90: 
Decimal: int | long | unsigned | long long 
Hexadecimal: int | unsigned | long | unsigned long 
ISO99: 
Decimal: int | long | long long 
Hexadecimal: int | unsigned | long | unsigned long | long long | unsigned long long

gcc寻找头文件的路径(按照1->2->3的顺序)
    1. 在gcc编译源文件的时候,通过参数-I指定头文件的搜索路径,如果指定路径有多个路径时,则按照指定路径的顺序搜索头文件。命令形式如：“gcc -I /path/where/theheadfile/in sourcefile.c“,这里源文件的路径可以是绝对路径,也可以是相对路径。eg：
设当前路径为/root/test,include_test.c如果要包含头文件“include/include_test.h“,有两种方法：
1) include_test.c中#include “include/include_test.h”或者#include "/root/test/include/include_test.h",然后gcc include_test.c即可
2) include_test.c中#include <include_test.h>或者#include <include_test.h>,然后gcc –I include include_test.c也可
 
    2. 通过查找gcc的环境变量C_INCLUDE_PATH/CPLUS_INCLUDE_PATH/OBJC_INCLUDE_PATH来搜索头文件位置。
 
    3. 再找内定目录搜索,分别是
/usr/include
/usr/local/include
/usr/lib/gcc-lib/i386-linux/2.95.2/include
最后一行是gcc程序的库文件地址,各个用户的系统上可能不一样。
    gcc在默认情况下,都会指定到/usr/include文件夹寻找头文件。
    gcc还有一个参数：-nostdinc,它使编译器不再系统缺省的头文件目录里面找头文件,一般和-I联合使用,明确限定头文件的位置。在编译驱动模块时,由于非凡的需求必须强制GCC不搜索系统默认路径,也就是不搜索/usr/include要用参数-nostdinc,还要自己用-I参数来指定内核头文件路径,这个时候必须在Makefile中指定。

    4. 当#include使用相对路径的时候,gcc最终会根据上面这些路径,来最终构建出头文件的位置。如#include <sys/types.h>就是包含文件/usr/include/sys/types.h
	
clear	清屏,本质上是让终端向后翻一页,快捷键ctrl+l
reset	刷新终端屏幕,速度较慢,少用

rpm -ivh  package_name	安装软件
	-i	install的意思
	-v	察看更细部的安装信息画面
	-h	以安装信息列显示安装进度
rpm -ivh  网址   由网络上面的某个档案安装
	--nodeps		不检查信赖,直接强制安装,可能造成软件无法正常使用
	--nomd5			不想检查RPM档案所含的MD5信息
	--noscripts		不想让该软件自行启用或者自行执行某些系统指令
	--replacefiles	如果在安装的过程中出现[某个档案已经被安装在系统上面]的信息,又或许出现版本不合的信息时,可以使用这个参数来直接覆盖档案
	--replacepkgs	重新安装某个已经安装过的软件
	--force			是上面两个的综合体
	--test			测试一下该软件是否可以被安装到使用者的linux环境当中

rpm -Uvh	名称 后面接的软件若是没有安装过,则系统直接安装,若后面接的软件有安装过,则系统自动更新至新版
	-Fvh    后面接的软件或是没有安装过,则该软件不会被安装

rpm  -qa		查询软件信息
rpm  -q[licdR]  已安装的软件的名称
rmp  -qf		存在于系统上面的某个档案
rpm	 -qp[licdR]	未安装的某个文件名称
	
	-q			仅查询,后面接的软件是否有安装
	-qa			列出所有的,已经安装在本机系统上面的软件
	-qi			列出该软件的详细信息,包含开发商,版本与说明
	-ql			列出该软件的所有的档案与目录所在完整文件名
	-qc			列出该软件的所有设定档
	-qd			列出该软件的所有说明档
	-qR			列出与该软件有关的依赖的软件的档案
	-qf			由后面接的文件名称,找出该档案属于哪一个已安装的软件
	-qp[icdlR]	与上一致,但用途仅在找出某个RPM档案内的信息,而非已安装的软件的信息

rpm -Va    验证软件是否有数据丢失
	-V	   已安装的软件名称
	-Vp	   某个RPM档案的档名
	-Vf	   在系统上面的某个档案

	-V		若该软件所含的档案被更动过,才会列出来
	-Va		列出目前系统上面所有可能被更动过的档案
	-Vp		后面加的是文件名称,列出该软件内可能被更动过的档案
	-Vf		列出某个档案是否被更动过

rpm -e 名称   解安装软件
rpm --rebuilddb   重建数据库

yum		yellow dog updater,modified   更方便的添加/删除/更新rpm包,能自动解决包依赖,是杜克大学为了提高RPM 软件包安装性而开发的一种软件包管理器
yum check-update					  检查可更新的rpm包
yum update							  更新所有rpm包
yum update kernel kernel-source		  更新指定的rpm包
yum upgrade							  大规模的版本升级,与yum update不同的是,连旧的淘汰包也升级
yum install xxx						  安装rpm包,名字为xxx
yum	remove 	xxx						  删除rpm包,包括与该包有依赖的包
yum clean packages					  清除暂存(/var/cache/yum)中的rpm包
yum clean headers					  清除暂存中rpm头文件
yum clean oldheaders				  清除暂存中旧的rpm头文件 
yum clean或 yum clean all			  清除暂存中旧的rpm头文件和包文件
yum list							  列出资源库中所有可以安装或更新的包,list关键字可以換为info
yum list mozila						  列出含名字mozila的可以安装或更新的包
yum list updates					  列出资源库中所有可以更新的rpm包
yum list installed					  列出已经安装的所有的rpm包
yum list extras						  列出已经安装的但是不包含在资源库的rpm包
yum search mozilla					  搜索包含mozilla的rpm包
yum provides realplay				  搜索包含特定文件名的rpm包
yum makecache						  根据/etc/yum.repos.d/CentOS-Base.repo(centos环境下)将服务器上的包信息缓存到本地
yum downgrade						  降级
fastestmirror是yum的一个加速插件，可以修改/etc/yum/pluginconf.d/fastestmirror.conf里的enable为0禁用掉,也可以修改/etc/yum.conf里的plugin置为0

/etc/apt/sources.list				  若更改了些文件,则先执行apt-get update
apt-get 	update					  更新本机中的数据库缓存
apt-cache	search	要查找的名字	  查找包含部分关键字的软件包
apt-get 	install 名字			  安装某个软件包,卸载软件在名字后加一个-
ap-get		remove	卸载名字		  卸载软件
apt-get		source	名字			  下载源代码(如果有的话)

dpkg -i package.deb     #安装包
dpkg -r package         #删除包
dpkg -P package         #删除包(包括配置文件)
dpkg -L package         #列出与该包关联的文件
dpkg -l package         #显示该包的版本
dpkg --unpack package.deb  #解开deb包的内容
dpkg -S keyword            #搜索所属的包内容
dpkg -l                    #列出当前已安装的包
dpkg -c package.deb        #列出deb包的内容
dpkg --configure package   #配置包

dpkg-query命令是Debian Linux中软件包的查询工具，它从dpkg软件包数据库中查询并辨识软件包的信息。
-l：列出符合匹配模式的软件包；
-s：查询软件包的状态信息；
-L：显示软件包所安装的文件列表；
-S：从安装的软件包中查询文件；
-w：显示软件包信息；
-c：显示软件包的控制文件路径；
-p：显示软件包的细节。

wget  网络地址						从网络上自动下载文件的自由工具
	-V			显示版本号后退出
	-h			显示软件的帮助信息
	-e			执行一个.wgetrc命令
	-O			输出到文件
	-d			显示输出信息
	-q			不显示输出信息
	-i			从文件中取得url

ping	参数		主机名或ip地址
	-d				使用socket的so_debug功能
	-f				极限检测,大量且快速地送网络封包给一台机器,看它的回应
	-n				只输出数值
	-q				不显示任何传送封包的信息,只显示最后结果
	-r				忽略普通的Routing Table,直接将数据包送到远端主机上,通常是查看本机的网络接口是否有问题
	-R				记录路由过程
	-v				详细显示指令的执行过程,显示接收到的任何ICMP报文
	<p>-c 数目		在发送指定数目的包后停止
	-i	秒数		设定间隔几秒送一个网络封包给一台机器,预设值是一秒送一次
	-I	网络界面	使用指定的网络界面送出数据包
	-l	前置载入	设置在送出要求信息之前,先行发出的数据包
	-p	范本样式	设置填满数据包的范本样式
	-s	字节数		指定发送的数据字节数,预设值是56,加上8字节的ICMP头,一共是64ICMP数据字节
	-t	存活数值	设置存活数值TTL的大小
	
telnet  地址	端口		可测试某机器端口是否可用,也可不写端口号
	open : 使用 openhostname 可以建立到主机的 Telnet 连接。
　　close : 使用命令 close 命令可以关闭现有的 Telnet 连接。
　　display : 使用 display 命令可以查看 Telnet 客户端的当前设置。
　　send : 使用 send 命令可以向 Telnet 服务器发送命令。支持以下命令：
　　	ao : 放弃输出命令。
　　	ayt : “Are you there”命令。
　　	esc : 发送当前的转义字符。
　　	ip : 中断进程命令。
　　	synch : 执行 Telnet 同步操作。
　　	brk : 发送信号。

tcpdump		抓包
	-A			以ASCII码打印每个报文
	-i			指定网卡,-i lo 抓取回环网口的包,-i any是抓取所有网卡的包
	-e			显示链路层报头
	-c			指定监听的数据包数量
	-n			以数字显示主机及端口
	-w    		把包数据直接写入文件而不进行分析和打印输出. 这些包数据可在随后通过-r 选项来重新读入并进行分析和打印
	第一种是关于类型的关键字，主要包括host，net，port, 例如 host 210.27.48.2，指明 210.27.48.2是一台主机，net 202.0.0.0 指明 202.0.0.0是一个网络地址，port 23 指明端口号是23。如果没有指定类型，缺省的类型是host.
	第二种是确定传输方向的关键字，主要包括src , dst ,dst or src, dst and src ,这些关键字指明了传输的方向。举例说明，src 210.27.48.2 ,指明ip包中源地址是210.27.48.2 , dst net 202.0.0.0 指明目的网络地址是202.0.0.0 。如果没有指明方向关键字，则缺省是src or dst关键字。
	第三种是协议的关键字，主要包括fddi,ip,arp,rarp,tcp,udp等类型。Fddi指明是在FDDI(分布式光纤数据接口网络)上的特定 的网络协议，实际上它是"ether"的别名，fddi和ether具有类似的源地址和目的地址，所以可以将fddi协议包当作ether的包进行处理和 分析。其他的几个关键字就是指明了监听的包的协议内容。如果没有指定任何协议，则tcpdump将会监听所有协议的信息包。
	# 除了这三种类型的关键字之外，其他重要的关键字如下：gateway, broadcast,less,greater,还有三种逻辑运算，取非运算是 'not ' '!', 与运算是'and','&&;或运算 是'or' ,'||'；这些关键字可以组合起来构成强大的组合条件来满足人们的需要，下面举几个例子来说明。
	例:抓刀锋发到转发的抓包
		tcpdump -i ens2 dst port 21013 -w ./rec.cap	and greater 500
	例:以图搜图刀锋发给调度的包
		tcpdump -Ai any dst port 18018 and greater 500
	例:调度到中间件的包
		tcpdump -i bond0 src port 18011 -w ./rec.cap	and greater 500
	例:转下派任务到tx1时的包
		tcpdump -i ens2 dst port 9044 -w ./rec.cap	and greater 500
	例:下派任务到调度
		tcpdump -Ai bond0 dst port 18010 and greater 500
	B想要截获主机210.27.48.1 和主机210.27.48.2 或210.27.48.3的通信，使用命令：(在命令行中适用　括号时，一定要在括号前加上/
		tcpdump host 210.27.48.1 and /(210.27.48.2 or 210.27.48.3 /)
	C如果想要获取主机210.27.48.1除了和主机210.27.48.2之外所有主机通信的ip包，使用命令：
		tcpdump ip host 210.27.48.1 and ! 210.27.48.2
		
curl
-X/--request <command>          指定什么命令,有GET,POST
-k/--insecure                   允许不使用证书到SSL站点
-H/--header <line>              自定义头信息传递给服务器
-d/--data <data>                HTTP POST方式传送数据
-s								不回显统计信息
-a/--append                        上传文件时，附加到目标文件
--anyauth                            可以使用“任何”身份验证方法
--basic                                使用HTTP基本验证
-B/--use-ascii                      使用ASCII文本传输
--data-ascii <data>            以ascii的方式post数据
--data-binary <data>          以二进制的方式post数据
--negotiate                          使用HTTP身份验证
--digest                        使用数字身份验证
--disable-eprt                  禁止使用EPRT或LPRT
--disable-epsv                  禁止使用EPSV
--egd-file <file>              为随机数据(SSL)设置EGD socket路径
--tcp-nodelay                  使用TCP_NODELAY选项
-E/--cert <cert[:passwd]>      客户端证书文件和密码 (SSL)
--cert-type <type>              证书文件类型 (DER/PEM/ENG) (SSL)
--key <key>                    私钥文件名 (SSL)
--key-type <type>              私钥文件类型 (DER/PEM/ENG) (SSL)
--pass  <pass>                  私钥密码 (SSL)
--engine <eng>                  加密引擎使用 (SSL). "--engine list" for list
--cacert <file>                CA证书 (SSL)
--capath <directory>            CA目   (made using c_rehash) to verify peer against (SSL)
--ciphers <list>                SSL密码
--compressed                    要求返回是压缩的形势 (using deflate or gzip)
--connect-timeout <seconds>    设置最大请求时间
--create-dirs                  建立本地目录的目录层次结构
--crlf                          上传是把LF转变成CRLF
--ftp-create-dirs              如果远程目录不存在，创建远程目录
--ftp-method [multicwd/nocwd/singlecwd]    控制CWD的使用
--ftp-pasv                      使用 PASV/EPSV 代替端口
--ftp-skip-pasv-ip              使用PASV的时候,忽略该IP地址
--ftp-ssl                      尝试用 SSL/TLS 来进行ftp数据传输
--ftp-ssl-reqd                  要求用 SSL/TLS 来进行ftp数据传输
-F/--form <name=content>        模拟http表单提交数据
-form-string <name=string>      模拟http表单提交数据
-g/--globoff                    禁用网址序列和范围使用{}和[]
-G/--get                        以get的方式来发送数据
-h/--help                      帮助
--ignore-content-length        忽略的HTTP头信息的长度
-i/--include                    输出时包括protocol头信息
-I/--head                      只显示文档信息
-j/--junk-session-cookies      读取文件时忽略session cookie
--interface <interface>        使用指定网络接口/地址
--krb4 <level>                  使用指定安全级别的krb4
-K/--config                    指定的配置文件读取
-l/--list-only                  列出ftp目录下的文件名称
--limit-rate <rate>            设置传输速度
--local-port<NUM>              强制使用本地端口号
-m/--max-time <seconds>        设置最大传输时间
--max-redirs <num>              设置最大读取的目录数
--max-filesize <bytes>          设置最大下载的文件总量
-M/--manual                    显示全手动
-n/--netrc                      从netrc文件中读取用户名和密码
--netrc-optional                使用 .netrc 或者 URL来覆盖-n
--ntlm                          使用 HTTP NTLM 身份验证
-N/--no-buffer                  禁用缓冲输出
-p/--proxytunnel                使用HTTP代理
--proxy-anyauth                选择任一代理身份验证方法
--proxy-basic                  在代理上使用基本身份验证
--proxy-digest                  在代理上使用数字身份验证
--proxy-ntlm                    在代理上使用ntlm身份验证
-P/--ftp-port <address>        使用端口地址，而不是使用PASV
-Q/--quote <cmd>                文件传输前，发送命令到服务器
--range-file                    读取(SSL)的随机文件
-R/--remote-time                在本地生成文件时，保留远程文件时间
--retry <num>                  传输出现问题时，重试的次数
--retry-delay <seconds>        传输出现问题时，设置重试间隔时间
--retry-max-time <seconds>      传输出现问题时，设置最大重试时间
-S/--show-error                显示错误
--socks4 <host[:port]>          用socks4代理给定主机和端口
--socks5 <host[:port]>          用socks5代理给定主机和端口
-t/--telnet-option <OPT=val>    Telnet选项设置
--trace <file>                  对指定文件进行debug
--trace-ascii <file>            Like --跟踪但没有hex输出
--trace-time                    跟踪/详细输出时，添加时间戳
--url <URL>                    Spet URL to work with
-U/--proxy-user <user[:password]>  设置代理用户名和密码
-V/--version                    显示版本信息
-y/--speed-time                放弃限速所要的时间。默认为30
-Y/--speed-limit                停止传输速度的限制，速度时间'秒'
-z/--time-cond                  传送时间设置
-0/--http1.0                    使用HTTP 1.0
-1/--tlsv1                      使用TLSv1(SSL)
-2/--sslv2                      使用SSLv2的(SSL)
-3/--sslv3                      使用的SSLv3(SSL)
--3p-quote                      like -Q for the source URL for 3rd party transfer
--3p-url                        使用url，进行第三方传送
--3p-user                      使用用户名和密码，进行第三方传送
-4/--ipv4                      使用IP4
-6/--ipv6                      使用IP6
		
	
ifconfig 	 对网络接口进行配置和查询
	-a       未启动的网卡也显示出来
	ifconfig    ethx 		ipaddr 		netmask 		x.x.x.x
				网卡号		ip地址		固定			掩码地址
	重启后会失效
	修改/etc/sysconfig/network-scripts/ifcfg-ethx	可以永久修改ip地址,配置完成后重启network服务
	ifconfig 网卡名 up/down		开启/关闭某张网卡,也可以通过命令ifup,ifdown来开启或关闭(ifup只能开启由ifdown关闭的网卡,而不能开启由ifconfig关闭的网卡)
	
网卡配置文件ifcfg-xxx信息
	DEVICE:			网卡名称
	USERCTL:      	[yes|no](非root用户是否可以控制该设备)
	HWADDR:			物理mac地址
	TYPE：			网络类型(通常是Ethemet,桥接的话是Bond,网桥是Bridge)
	UUID：			网卡唯一标识
	ONBOOT：		开机或者重启是否重启网卡
	NM_CONTROLLED： 是否受network程序管理
	BOOTPROTO：		IP的配置方法[none|static|bootp|dhcp](引导时不使用协议|静态分配IP|BOOTP协议|DHCP协议)
	IPADDR：		设置ip
	DEFROUTE:		default route,是否把这个eth设置为默认路由
	GATEWAY：		设置网关
	NETMASK：		子网掩码
	PREFIX:			子网掩码,数字,如24
	NETWORK:		网络地址
	DNS:			域名解析服务,DNS1,DNS2
	IPV6INIT:       IPV6是否有效(yes/no)
	BROADCAST:		广播地址
	PEERDNS:		是否允许DHCP获得的DNS覆盖本地的DNS

	
arp			查看arp高速缓存
-d  	address					删除某条高速缓存
-s  	address  hw_addr		增加一条高速缓存,新增加的内容是永久的,没有超时值,除非在命令行的末尾加上temp,位于命令行末尾的关键字pub和-s选项一起,可以使用系统起着主机ARP代理的作用,系统将回答与主机名对应的IP地址的ARP请求,并以指定的以太网地址作为应答
	
host		使用域名服务器查询主机名字
	
nvidia-smi	查看GPU使用情况
	dmon    监控,实时输出
	-i n    指定卡号

svn无法cleanup时,可以进入.svn目录,sqlite3 wc.db select * from work_queue; delete from work_queue; 即可

pgrep	name	以name从运行队列里查找进程,并显示查找到的进程的ID,以十进制数表示
-o  	仅显示找到的最小的进程号
-n		仅显示找到的最大的进程号
-l		显示进程名称
-P		指定父进程号
-g		指定进程组
-t		指定开启进程的终端
-u		指定进程的有效用户ID

pstack 	pid		显示进程的栈跟踪

strace 	常用来跟踪进程执行时的系统调用和所接收的信号,在Linux世界,进程不能直接访问硬件设备,当进程需要访问硬件设备(比如读取磁盘文件,接收网络数据等等)时,必须由用户态模式切换至内核态模式,通 过系统调用访问硬件设备。strace可以跟踪到一个进程产生的系统调用,包括参数,返回值,执行消耗的时间。
		每一行都是一条系统调用,等号左边是系统调用的函数名及其参数，右边是该调用的返回值。
		显示这些调用的参数并返回符号形式的值。strace 从内核接收信息，而且不需要以任何特殊的方式来构建内核.
-c 			统计每一系统调用的所执行的时间,次数和出错的次数等. 
-d 			输出strace关于标准错误的调试信息. 
-f 			跟踪由fork调用所产生的子进程. 
-ff			如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号. 
-F 			尝试跟踪vfork调用.在-f时,vfork不被跟踪. 
-h 			输出简要的帮助信息. 
-i 			输出系统调用的入口指针. 
-q 			禁止输出关于脱离的消息. 
-r 			打印出相对时间关于,,每一个系统调用. 
-t 			在输出中的每一行前加上时间信息. 
-tt			在输出中的每一行前加上时间信息,微秒级. 
-ttt 		微秒级输出,以秒了表示时间. 
-T 			显示每一调用所耗的时间. 
-v 			输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出. 
-V 			输出strace的版本信息. 
-x 			以十六进制形式输出非标准字符串 
-xx 		所有字符串以十六进制形式输出. 
-a column 	设置返回值的输出位置.默认 为40. 
-e expr 	指定一个表达式,用来控制如何跟踪.格式如下: 
[qualifier=][!]value1[,value2]... 	qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.感叹号是否定符号.例如: 
-eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open表示跟踪除了open以外的其他调用.有两个特殊的符号 all 和 none. 注意有些shell使用!来执行历史记录里的命令,所以要使用\\. 
-e trace=set 		只跟踪指定的系统 调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all. 
-e trace=file 		只跟踪有关文件操作的系统调用. 
-e trace=process	只跟踪有关进程控制的系统调用. 
-e trace=network 	跟踪与网络有关的所有系统调用. 
-e strace=signal 	跟踪所有与系统信号有关的 系统调用 
-e trace=ipc 		跟踪所有与进程通讯有关的系统调用 
-e abbrev=set 		设定 strace输出的系统调用的结果集.-v 等与 abbrev=none.默认为abbrev=all. 
-e raw=set 			将指 定的系统调用的参数以十六进制显示. 
-e signal=set 		指定跟踪的系统信号.默认为all.如 signal=!SIGIO(或者signal=!io),表示不跟踪SIGIO信号. 
-e read=set 		输出从指定文件中读出 的数据.例如: 
	-e read=3,5 
-e write=set 		输出写入到指定文件中的数据. 
-o filename 		将strace的输出写入文件filename 
-p pid 				跟踪指定的进程pid. 
-s strsize 			指定输出的字符串的最大长度.默认为32.文件名一直全部输出. 
-u username 		以username 的UID和GID执行被跟踪的命令

route				显示 / 操作IP路由表
add			添加一条路由,如 route add default gw 10.66.91.254 
del			删除一条路由,如 route del -net 10.12.5.0/24 dev ens33
netmask		为添加的路由指定网络掩码,如指定0.0.0.0是默认路由
gw			为添加的路由指定网关
dev if		为添加的路由指定设备关联
-net		路由目标为网络
-host		路由目标为主机
-C			显示内核的路由缓存
-n			以数字形式代替主机名形式来显示地址

route命令输出的路由表字段含义如下：
    Destination 目标
          The destination network or destination host. 目标网络或目标主机。

    Gateway 网关
          The gateway address or '*' if none set. 网关地址，如果没有就显示星号。

    Genmask 网络掩码
          The  netmask  for  the  destination net; '255.255.255.255' for a
          host destination and '0.0.0.0' for the default route.

     Flags：总共有多个旗标，代表的意义如下：                        
         o U (route is up)：该路由是启动的,即可以使用                       
         o H (target is a host)：目标是一部主机 (IP) 而非网域,目的地址是一个完整的主机地址,如果没有设置该标志,说明该路由是到一个网络,而目的地址是一个网络地址     
         o G (use gateway)：需要透过外部的主机 (gateway) 来转递封包,说明该路由是到一个网关(路由器),如果没有设置该标志,说明目的地是直接相连的
			标志G表明了此路由是间接路由还是直接路由(直接路由不设置G),发往直接路由的分组中不但具有目的端的IP地址,还具有其链路层地址,当分组被发往一个间接路由时,IP地址指明的是最终的目的地,但是链路层地址指明的是网关(即下一站路由器)
         o R (reinstate route for dynamic routing)：使用动态路由时，恢复路由资讯的旗标；                       
         o D (dynamically installed by daemon or redirect)：已经由服务或转 port 功能设定为动态路由,该路由是由重定向报文创建的                     
         o M (modified from routing daemon or redirect)：路由已经被修改了,该路由已被重定向报文修改                       
         o !  (reject route)：这个路由将不会被接受(用来抵挡不安全的网域！)
         o A (installed by addrconf)
         o C (cache entry)

    Metric 距离、跳数。暂无用。
          The 'distance' to the target (usually counted in  hops).  It  is
          not  used  by  recent kernels, but may be needed by routing dae-
          mons.

    Ref   不用管，恒为0。表示正在使用路由的活动进程个数
          Number of references to this route. (Not used in the Linux  ker-nel.)

    Use    该路由被使用的次数，可以粗略估计通向指定网络地址的网络流量。
          Count  of lookups for the route.  Depending on the use of -F and
          -C this will be either route cache misses (-F) or hits (-C).

    Iface 接口，即eth0,eth0等网络接口名
          Interface to which packets for this route will be sent.
		  
例:添加一条路由
	route add default sun1 1		第三个参数代表目的端,第4个参数代表网关(路由器),第5个参数代表度量(metric),route命令在度量大于0时要为该路由设置G标志
		  
用route命令添加的路由重启会会失效,下面几种方式可以永久添加
在/etc/rc.local里添加
在/etc/sysconfig/network里添加到末尾
/etc/sysconfig/static-router :
any net x.x.x.x/24 gw y.y.y.y

/var/log/messages — 包括整体系统信息，其中也包含系统启动期间的日志。此外，mail，cron，daemon，kern和auth等内容也记录在var/log/messages日志中。
/var/log/dmesg — 包含内核缓冲信息(kernel ring buffer)。在系统启动时，会在屏幕上显示许多与硬件有关的信息。可以用dmesg查看它们。
/var/log/auth.log — 包含系统授权信息，包括用户登录和使用的权限机制等。
/var/log/boot.log — 包含系统启动时的日志。
/var/log/daemon.log — 包含各种系统后台守护进程日志信息。
/var/log/dpkg.log – 包括安装或dpkg命令清除软件包的日志。
/var/log/kern.log – 包含内核产生的日志，有助于在定制内核时解决问题。
/var/log/lastlog — 记录所有用户的最近信息。这不是一个ASCII文件，因此需要用lastlog命令查看内容。
/var/log/maillog /var/log/mail.log — 包含来着系统运行电子邮件服务器的日志信息。例如，sendmail日志信息就全部送到这个文件中。
/var/log/user.log — 记录所有等级用户信息的日志。
/var/log/Xorg.x.log — 来自X的日志信息。
/var/log/alternatives.log – 更新替代信息都记录在这个文件中。
/var/log/btmp – 记录所有失败登录信息。使用last命令可以查看btmp文件。例如，”last -f /var/log/btmp | more“。
/var/log/cups — 涉及所有打印信息的日志。
/var/log/anaconda.log — 在安装Linux时，所有安装信息都储存在这个文件中。
/var/log/yum.log — 包含使用yum安装的软件包信息。
/var/log/cron — 每当cron进程开始一个工作时，就会将相关信息记录在这个文件中。
/var/log/secure — 包含验证和授权方面信息。例如，sshd会将所有信息记录(其中包括失败登录)在这里。
/var/log/wtmp或/var/log/utmp — 包含登录信息。使用wtmp可以找出谁正在登陆进入系统，谁使用命令显示这个文件或信息等。
/var/log/faillog – 包含用户登录失败信息。此外，错误登录命令也会记录在本文件中。

除了上述Log文件以外， /var/log还基于系统的具体应用包含以下一些子目录：
/var/log/httpd/或/var/log/apache2 — 包含服务器access_log和error_log信息。
/var/log/lighttpd/ — 包含light HTTPD的access_log和error_log。
/var/log/mail/ – 这个子目录包含邮件服务器的额外日志。
/var/log/prelink/ — 包含.so文件被prelink修改的信息。
/var/log/audit/ — 包含被 Linux audit daemon储存的信息。
/var/log/samba/ – 包含由samba存储的信息。
/var/log/sa/ — 包含每日由sysstat软件包收集的sar文件。
/var/log/sssd/ – 用于守护进程安全服务。

在Unix中，当一个用户进程使用malloc()函数申请内存时，假如返回值是NULL，则这个进程知道当前没有可用内存空间，就会做相应的处理工作。许多进程会打印错误信息并退出。
Linux使用另外一种处理方式，它对大部分申请内存的请求都回复"yes"，以便能跑更多更大的程序。因为申请内存后，并不会马上使用内存。这种技术叫做Overcommit。
当内存不足时，会发生OOM killer(OOM=out-of-memory)。它会选择杀死一些进程(用户态进程，不是内核线程)，以便释放内存。
Overcommit的策略
Linux下overcommit有三种策略(Documentation/vm/overcommit-accounting)：
0. 启发式策略。合理的overcommit会被接受，不合理的overcommit会被拒绝。,表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
1. 任何overcommit都会被接受。而不管当前的内存状态如何
2. 当系统分配的内存超过swap+N%*物理RAM(N%由vm.overcommit_ratio决定)时，会拒绝commit。
overcommit的策略通过vm.overcommit_memory设置。
overcommit的百分比由vm.overcommit_ratio设置。

当oom-killer发生时，linux会选择杀死哪些进程
选择进程的函数是oom_badness函数(在mm/oom_kill.c中)，该函数会计算每个进程的点数(0~1000)。
点数越高，这个进程越有可能被杀死。每个进程的点数跟oom_score_adj有关，而且oom_score_adj可以被设置(-1000最低，1000最高)。

例:
echo 2 > /proc/sys/vm/overcommit_memory
echo 80 > /proc/sys/vm/overcommit_ratio

pmap   pid		显示进程内存状态
-x extended显示扩展格式
-d device显示设备格式
-q quiet不显示header/footer行
-V 显示版本信息

iostat	显示cpu统计信息与系统磁盘I/O相关统计信息
-c					仅显示cpu统计信息,与-d互斥
-d 					仅显示磁盘统计信息.与-c选项互斥.
-k 					以K为单位显示每秒的磁盘请求数,默认单位块.
-p device | ALL		与-x选项互斥,用于显示块设备及系统分区的统计信息.也可以在-p后指定一个设备名,如:
iostat -p hda
 或显示所有设备
iostat -p ALL
-t    				在输出数据时,打印搜集数据的时间.
-V    				打印版本号和帮助信息.
-x    				输出扩展信息.
-数字	数字		每几秒输出一次,输出多少次

watch				可以将命令的输出结果输出到标准输出设备，多用于周期性执行命令/定时执行命令
-n或--interval  	watch缺省每2秒运行一下程序，可以用-n或-interval来指定间隔的时间。
-d或--differences  	用-d或--differences 选项watch 会高亮显示变化的区域。 而-d=cumulative选项会把变动过的地方(不管最近的那次有没有变动)都高亮显示出来。
-t 或-no-title  	会关闭watch命令在顶部的时间间隔,命令，当前时间的输出。

run level:
	0	-halt(系统直接关机)
	1	-single user mode(单人维护模式,用在系统出问题时的维护)
	2	-类似下面的3,但无NFS服务
	3	-完整的含有网络功能的纯文字模式
	4	-系统保留功能
	5	-与3类似,但使用X Window
	6	-reboot(重新开机)
reunlevel	查看当前的run lenvel;

dmidecode			获取硬件信息,会访问/dev/mem,DMI (Desktop Management Interface, DMI)
	-t				指定类型输出相关信息
	-t processor	输出处理器相关信息,也可以是 -t 4
	-t 2			查看主板信息
	-t 16			查看内存信息
	
lshw	显示所有硬件摘要信息
	
lsblk	列出所有可用块设备信息,还能显示他们之间的依赖关系,但不会列出RAM盘的信息,块设备有硬盘,闪存盘,cd-Rom等
-a, --all 显示所有设备
-b, --bytes 以bytes方式显示设备大小
-d, --nodeps 不显示 slaves 或 holders
-D, --discard print discard capabilities
-e, --exclude 排除设备 (default: RAM disks)
-f, --fs 显示文件系统信息。 -h, --help 显示帮助信息
-i, --ascii use ascii characters only。 -m, --perms 显示权限信息
-l, --list 使用列表格式显示。 -n, --noheadings 不显示标题 
-o, --output 输出列。 -P, --pairs 使用key="value"格式显示
-r, --raw 使用原始格式显示。 -t, --topology 显示拓扑结构信息
-m, 显示块设备所有者相关信息,包括文件的所属用户,所属组以及文件系统挂载点

blkid   显示可用块设备的信息,即已经格式化过的块设备,它可以识别一个块设备内容的类型(文件系统,交换区)以及从内容的元数据(如卷标或UUID字段)中获取属性(如tokens和键值对)

lsscsi	查看scsi控制器设备的信息	
	-s  显示容量大小
	-c 用全称显示默认的信息。
	-d 显示设备主，次设备号。
	-g 显示对应的sg设备名。
	-H 显示主机控制器列表，-Hl,-Hlv。
	-l 显示相关属性，-ll,-lll=-L。
	-v 显示设备属性所在目录。
	-x 以16进制显示lun号。
	-p 输出DIF,DIX 保护类型。
	-P 输出有效的保护模式信息。
	-i 显示udev相关的属性
	-w 显示WWN

lscpu	查看cpu相关信息,是从sysfs和/proc/cpuinfo收集cpu体系结构信息，命令的输出比较易读 
	Architecture: #架构 
　　CPU(s): #逻辑cpu颗数 
　　Thread(s) per core: #每个核心线程 
　　Core(s) per socket: #每个cpu插槽核数/每颗物理cpu核数 
　　CPU socket(s): #cpu插槽数 
　　Vendor ID: #cpu厂商ID 
　　CPU family: #cpu系列 
　　Model: #型号 
　　Stepping: #步进 
　　CPU MHz: #cpu主频 
　　Virtualization: #cpu支持的虚拟化技术 
　　L1d cache: #一级缓存(google了下，这具体表示表示cpu的L1数据缓存) 
　　L1i cache: #一级缓存(具体为L1指令缓存) 
　　L2 cache: #二级缓存
查看/cpu/info也可获得cpu相关信息
	 processor 条目包括这一逻辑处理器的唯一标识符。查看逻辑cpu数量即可使用cat /proc/cpuinfo | grep "process" | sort -u
     physical id 条目包括每个物理封装的唯一标识符。查看物理cpu数量即可使用cat /proc/cpuinfo | grep "physical id" | sort -u
     core id 条目保存每个内核的唯一标识符。查看每个物理cpu核id即可使用cat /proc/cpuinfo | grep "core id" | sort -u
     siblings 条目列出了位于相同物理封装中的逻辑处理器的数量。查看每个物理cpu有多少个逻辑cpu即可使用cat /proc/cpuinfo | grep "siblings" | sort -u
     cpu cores 条目包含位于相同物理封装中的内核数量。查看每个物理cpu有多少个核即可使用cat /proc/cpuinfo | grep "cpu cores" | sort -u
     如果处理器为英特尔处理器，则 vendor id 条目中的字符串是 GenuineIntel。


lsmod	查看目前核心加载了多少模块
modprobe	自动处理可载入模块
	-r 模块名	      移除模块
	-a或--all 　	  载入全部的模块。
	-c或--show-conf 　显示所有模块的设置信息。
	-d或--debug 　	  使用排错模式。
	-l或--list 　	  显示可用的模块。
	-r或--remove 　	  模块闲置不用时，即自动卸载模块。
	-t或--type 　	  指定模块类型。
	-v或--verbose 　  执行时显示详细的信息。
	-V或--version 　  显示版本信息。
	-help 　		  显示帮助。
	
lspci				显示当前主机所有PCI总线信息,以及所有已连接的PCI设备信息
	-n：			以数字方式显示PCI厂商和设备代码；
	-t：			以树状结构显示PCI设备的层次关系，包括所有的总线、桥、设备以及它们之间的联接；
	-b：			以总线为中心的视图；
	-d：			仅显示给定厂商和设备的信息；
	-s：			仅显示指定总线、插槽上的设备和设备上的功能块信息；
	-i：			指定PCI编号列表文件，而不使用默认的文件；
	-m：			以机器可读方式显示PCI设备信息。
	-v:				使得 lspci 以冗余模式显示所有设备的详细信息
	
lsusb				显示当前连接的usb设备
	
/etc/resolv.conf里配置了dns名字服务器

nslookup domain [dns-server]    用于查询DNS的记录，查看域名解析是否正常，在网络故障的时候用来诊断网络问题

dig		domain					查询dns跟踪记录
+trace		查看详细的域名解析过程

smbpasswd			添加或删除samba用户名,修改密码
	-a		添加用户
	-c		指定samba配置文件
	-x		删除用户
	-d		禁用指定用户
	-e		激活指定用户
	-n		将指定的用户的密码置空
pdbedit 			samba保存用户资料的数据库
	-L		查看smaba用户
	-a 		新建samba账户
	-x		删除samba账户
	-Lv		列出samba用户列表的详细信息
	-c “[D]” –u username：暂停该Samba用户的账号。
	-c “[]” –u username： 恢复该Samba用户的账号。
smbstatus		    查看samba服务运行状态及客户端人数,只有root才可执行,也可netstat -atpln |grep 445 |grep ESTABLISHED

factor   正整数		分解因数
shred    文件名		粉碎文件,粉碎后默认是覆盖
	-u				粉碎后删除
	
ssh_pass			若要实现不输入密码登录ssh或telnet,可使用此工具

SSH: Port Forwarding
1.正向隧道-隧道监听本地port,为普通活动提供安全连接,又称正向端口转发,例:ssh -fN -L 0.0.0.0:1123:10.3.91.74:1123 root@10.66.91.2
	ssh -qTfnN -L localPort:remoteHost:remoteHostPort -l user@sshServer
	ssh -CfNg -L 6300:127.0.0.1:1521 oracle@172.16.1.164
	本机(运行这条命令的主机)打开6300端口, 通过加密隧道映射到远程主机172.16.1.164的1521端口(使用远程主机oracle用户). 在本机上用netstat -an|grep 6300可看到. 简单说,本机的6300端口就是远程主机172.16.1.164的1521端口. 
2.反向隧道----隧道监听远程port，突破防火墙提供服务,又称反射端口转发
	ssh -qTfnN -R sshServerPort:remoteHost:remoteHostPort -l user@sshServer 
	ssh -CfNg -R 1521:127.0.0.1:6300 oracle@172.16.1.164
	作用同上, 只是在远程主机172.16.1.164上打开1521端口, 来映射本机的6300端口. 
3.socks代理,又称动态端口转发,例 ssh -fN -D 0.0.0.0:1081 root@10.66.91.2
	SSH -qTfnN -D localPort sshServer(用证书验证就直接主机名，没用的还要加上用户名密码)
-q Quiet mode. 安静模式，忽略一切对话和错误提示。
-T Disable pseudo-tty allocation. 不占用 shell 了。
-f Requests ssh to go to background just before command execution. 后台运行，并推荐加上 -n 参数。
-n Redirects stdin from /dev/null (actually, prevents reading from stdin). -f 推荐的，不加这条参数应该也行。
-N Do not execute a remote command. 不执行远程命令，专为端口转发度身打造。
-C 表示压缩数据传输
-g 表示允许远程主机连接转发端口
-L 本地转发
-R 远程转发

nc/ncat				在两台电脑之间建立数据流,能建立一个服务器,传输文件,与朋友聊天,查看端口
-4 使用IPV4
-6 使用IPV6
-c, --sh-exec <command> 接收到的命令通过command(例如/bin/bash)执行
-e, --exec <command> 和-c差不多
--lua-exec <filename> 接收到的数据通过脚本filename执行
-m, --max-conns <n> 最大并发连接数(单独开启不生效，需配合--keep-open/--broker使用)
-d, --delay <time> 读写收发间隔时间
-o, --output <filename> 将会话数据转储到文件
-i, --idle-timeout <time> 读写超时时间
-p, --source-port port 指定连接使用的源端口号(client端使用)
-s, --source addr 客户端指定连接服务器使用的ip(client端使用)
-l, --listen 绑定和监听接入连接(server端使用)
-k, --keep-open 在监听模式中接受多个连接(配合-m使用)
-n, --nodns 不使用DNS解析主机名
-t, --telnet 响应telnet连接
-u, --udp 使用udp协议，默认tcp
-v, --verbose 显示详细信息
-w, --wait <time> 连接超时时间
--allow 允许指定主机连接
--allowfile 允许指定文件内的主机连接
--deny 拒绝指定主机连接
--denyfile 拒绝指定文件内的主机连接
--broker 启用代理模式
--proxy <addr[:port]> 指定代理主机ip和port
--proxy-type <type> 指定代理类型("http" or "socks4")
--proxy-auth <auth> 代理身份验证

nmap			网络探测工具和安全/端口扫描器
	-F			扫描100个最有可能开放的端口
	-v			获取扫描的信息
	-sT			采用的是tcp扫描,不写默认是tcp扫描
	-sU			扫描UDP端口,UDP端口扫描很慢
	-sS			秘密的扫描,相比上面的-sT,-sT会完成三次握手,容易被防火墙和日志记录,而-sS会在扫描端返回ack后发送rst,但-sS需要root权限
	-sV			打开系统版本检测
	-sP			ping的方式扫描,在网络中寻找所有在线主机,例 nmap 10.12.4.*
	-p			指定某个端口进行扫描,扫描全部端口可以指定一个范围, 例 nmap 10.12.4.12 -p 1-65535
	-D			使用诱饵隐蔽扫描,指定一个或多少ip与自己的真实ip同时访问目的主机
	-S			源地址欺骗,在使用的时候要注意与-e进行使用，因为除了制定要伪装成为的对象IP外，还要指定返回的IP地址
	-e 			使用指定的接口
	-T			通过时间优化也提高通过防火墙和IDS的通过率
	-f			将可疑的探测包进行分片处理(例如将TCP包拆分成多个IP包发送过去)，某些简单的防火墙为了加快处理速度可能不会进行重组检查，以此避开其检查。
	
端口状态
	Open	 端口开启，数据有到达主机，有程序在端口上监控
	Closed	 端口关闭，数据有到达主机，没有程序在端口上监控
	Filtered	 数据没有到达主机，返回的结果为空，数据被防火墙或者是IDS过滤
	UnFiltered	 数据有到达主机，但是不能识别端口的当前状态
	Open|Filtered	 端口没有返回值，主要发生在UDP、IP、FIN、NULL和Xmas扫描中
	Closed|Filtered  只发生在IP ID idle扫描
	
perf		从2.6.31内核开始，linux内核自带了一个性能分析工具perf，能够进行函数级与指令级的热点查找
			Perf是内置于Linux内核源码树中的性能剖析(profiling)工具。
			它基于事件采样原理，以性能事件为基础，支持针对处理器相关性能指标与操作系统相关性能指标的性能剖析。
			常用于性能瓶颈的查找与热点代码的定位
CPU周期(cpu-cycles)是默认的性能事件，所谓的CPU周期是指CPU所能识别的最小时间单元，通常为亿分之几秒,是CPU执行最简单的指令时所需要的时间，例如读取寄存器中的内容，也叫做clock tick。
Perf是一个包含22种子工具的工具集，以下是最常用的5种：
perf list [hw | sw | cache | tracepoint | event_glob]			用来查看perf所支持的性能事件,有软件的也有硬件的
	指定性能事件(以它的属性),举例:显示内核和模块中，消耗最多CPU周期的函数, perf top -e cycles:k
	-e <event> : u // userspace	
	-e <event> : k // kernel
	-e <event> : h // hypervisor
	-e <event> : G // guest counting (in KVM guests)
	-e <event> : H // host counting (not in KVM guests)
perf stat					用于分析指定程序的性能概况。
	task-clock：任务真正占用的处理器时间，单位为ms。CPUs utilized = task-clock / time elapsed，CPU的占用率。
	context-switches：上下文的切换次数。
	CPU-migrations：处理器迁移次数。Linux为了维持多个处理器的负载均衡，在特定条件下会将某个任务从一个CPU迁移到另一个CPU。
	page-faults：缺页异常的次数。当应用程序请求的页面尚未建立、请求的页面不在内存中，或者请求的页面虽然在内存中，但物理地址和虚拟地址的映射关系尚未建立时，都会触发一次缺页异常。另外TLB不命中，页面访问权限不匹配等情况也会触发缺页异常。
	cycles：消耗的处理器周期数。如果把被ls使用的cpu cycles看成是一个处理器的，那么它的主频为2.486GHz。可以用cycles / task-clock算出。
	stalled-cycles-frontend：略过。
	stalled-cycles-backend：略过。
	instructions：执行了多少条指令。IPC为平均每个cpu cycle执行了多少条指令。
	branches：遇到的分支指令数。branch-misses是预测错误的分支指令数。
常用参数
	-e：Select the PMU event.
	-a：System-wide collection from all CPUs.
	-p：Record events on existing process ID (comma separated list).
	-A：Append to the output file to do incremental profiling.
	-f：Overwrite existing data file.
	-o：Output file name.
	-g：Do call-graph (stack chain/backtrace) recording.
	-C：Collect samples only on the list of CPUs provided.
perf top [-e <EVENT> | --event=EVENT] [<options>]		对于一个指定的性能事件(默认是CPU周期)，显示消耗最多的函数或指令
	常用命令行参数
	-e <event>：指明要分析的性能事件。
	-p <pid>：Profile events on existing Process ID (comma sperated list). 仅分析目标进程及其创建的线程。
	-k <path>：Path to vmlinux. Required for annotation functionality. 带符号表的内核映像所在的路径。
	-K：不显示属于内核或模块的符号。
	-U：不显示属于用户态程序的符号。
	-d <n>：界面的刷新周期，默认为2s，因为perf top默认每2s从mmap的内存区域读取一次性能数据。
	-G：得到函数的调用关系图。
perf top -G [fractal]，路径概率为相对值，加起来为100%，调用顺序为从下往上。
perf top -G graph，路径概率为绝对值，加起来为该函数的热度。
perf record			收集采样信息，并将其记录在数据文件中。
perf report			读取perf record创建的数据文件，并给出热点分析结果
常用参数
	-i：Input file name. (default: perf.data)
常用交互命令
h：显示帮助
UP/DOWN/PGUP/PGDN/SPACE：上下和翻页。
a：annotate current symbol，注解当前符号。能够给出汇编语言的注解，给出各条指令的采样率。
d：过滤掉所有不属于此DSO的符号。非常方便查看同一类别的符号。
P：将当前信息保存到perf.hist.N中。

cfssl 	是CloudFlare开源的一款PKI/TLS工具。 CFSSL 包含一个命令行工具 和一个用于 签名，验证并且捆绑TLS证书的 HTTP API 服务。 使用Go语言编写。
	bundle: 创建包含客户端证书的证书包
	genkey: 生成一个key(私钥)和CSR(证书签名请求)
	scan: 扫描主机问题	
	revoke: 吊销证书
	certinfo: 输出给定证书的证书信息， 跟cfssl-certinfo 工具作用一样	
	gencrl: 生成新的证书吊销列表	
	selfsign: 生成一个新的自签名密钥和 签名证书	
	print-defaults: 打印默认配置，这个默认配置可以用作模板	
	serve: 启动一个HTTP API服务	
	gencert: 生成新的key(密钥)和签名证书	
	-ca：指明ca的证书	
	-ca-key：指明ca的私钥文件	
	-config：指明请求证书的json文件	
	-profile：与-config中的profile对应，是指根据config中的profile段来生成证书的相关信息	
	ocspdump	
	ocspsign	
	info: 获取有关远程签名者的信息	
	sign: 签名一个客户端证书，通过给定的CA和CA密钥，和主机名
	ocsprefresh	
	ocspserve
	
CFSSL可以创建一个获取和操作证书的内部认证中心。
运行认证中心需要一个CA证书和相应的CA私钥。任何知道私钥的人都可以充当CA颁发证书。因此，私钥的保护至关重要。
创建一个文件ca-csr.json：		
{
  "CN": "www.51yunv.com",		#Common Name，浏览器使用该字段验证网站是否合法，一般写的是域名。非常重要。浏览器使用该字段验证网站是否合法
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",				#Country， 国家
      "ST": "BeiJing",			#State，州，省
      "L": "BeiJing",			#Locality，地区，城市
      "O": "51yunv",			#Organization Name，组织名称，公司名称
      "OU": "ops"				#Organization Unit Name，组织单位名称，公司部门
    }
  ]
}
生成CA证书和CA私钥和CSR(证书签名请求):
cfssl gencert -initca ca-csr.json | cfssljson -bare ca  	## 初始化ca
CSR(Certificate Signing Request)，它是向CA机构申请数字×××书时使用的请求文件。在生成请求文件前，我们需要准备一对对称密钥。私钥信息自己保存，请求中会附上公钥信息以及国家，城市，域名，Email等信息，CSR中还会附上签名信息。当我们准备好CSR文件后就可以提交给CA机构，等待他们给我们签名，签好名后我们会收到crt文件，即证书。
注意：CSR并不是证书。而是向权威证书颁发机构获得签名证书的申请。

该命令会生成运行CA所必需的文件ca-key.pem(私钥)和ca.pem(证书)，还会生成ca.csr(证书签名请求)，用于交叉签名或重新签名。
cfssl certinfo -cert ca.pem			#查看证书信息
cfssl certinfo -csr ca.csr			#查看证书签名请求信息
配置证书生成策略，让CA软件知道颁发什么样的证书。这个策略，有一个默认的配置，和一个profile，可以设置多个profile，这里的profile是etcd。
vim ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"				#默认策略，指定了证书的有效期是一年(8760h)
    },
    "profiles": {
      "etcd": {						#etcd策略，指定了证书的用途
        "usages": [
            "signing",				#signing, 表示该证书可用于签名其它证书；生成的 ca.pem 证书中 CA=TRUE
            "key encipherment",
            "server auth",			#表示 client 可以用该 CA 对 server 提供的证书进行验证
            "client auth"			#表示 server 可以用该 CA 对 client 提供的证书进行验证
        ],
        "expiry": "8760h"
      }
    }
  }
}

openssl command [ command_opts ] [ command_args ]
	version    用于查看版本信息
		-a：打印所有信息。
		-v：仅打印版本信息		
		-b：打印当前版本构建的日期		
		-o：库构建时的相关信息		
		-f：编译参数		
		-p：平台信息		
		-d: 列出openssl的安装目录
	enc        用于加解密	
		-ciphername：对称算法名称，此命令有两种使用方式：-ciphername方式或者省略enc直接使用ciphername。
		-in filename：要加密/解密的输入文件，默认为标准输入。		
		-out filename：要加密/解密的输出文件，默认为标准输出。		
		-pass arg：输入文件如果有密码保护，指定密码来源。		
		-e：进行加密操作，默认操作。可以省略		
		-d：进行解密操作。		
		-a：使用base64编码对加密结果进行处理。加密后进行base64编码，解密前进行base64解密。		
		-base64：同-a选项。		
		-A：默认情况下，base64编码为一个多行的文件。使用此选项，可以让生成的结果为一行。解密时，必须使用同样的选项，否则读取数据时会出错。		
		-k：指定加密口令，不设置此项时，程序会提示用户输入口令。		
		-kfile：指定口令存放文件。可以从这个口令存放文件的第一行读取加密口令。		
		-K key：使用一个16进制的输入口令。如果仅指定-K key而没有指定-k password，必须用-iv选项指定IV。当-K key和-k password都指定时，用-K选项给定的key将会被使用，而使用password来产生初始化向量IV。不建议两者都指定。		
		-iv IV：手工指定初始化向量(IV)的值。IV值是16进制格式的。如果仅使用-K指定了key而没有使用-k指定password,那么就需要使用-iv手工指定IV值。如果使用-k指定了password，那么IV值会由这个password的值来产生。		
		-salt：产生一个随机数，并与-k指定的password串联，然后计算其Hash值来防御字典***和rainbow table***。		
			rainbow table***：用户将密码使用单向函数得到Hash摘要并存入数据库中，验证时，使用同一种单向函数对用户输入口令进行Hash得到摘要信息。将得到的摘要信息和数据中该用户的摘要信息进行比对，一致则通过。考虑到多数人使用的密码为常见的组合，***者可以将所有密码的常见组合进行单向Hash，得到一个摘要组合。然后与数据库中的摘要进行比对即可获得对应的密码。		
			salt将随机数加入到密码中，然后对一整串进行单向Hash。***者就很难通过上面的方式来得到密码。
		-S salt：使用16进制的salt。		
		-nosalt：表示不使用salt。		
		-z：压缩数据(前提是OpenSSL编译时加入了zip库)。		
		-md：指定摘要算法。如：MD5  SHA1  SHA256等。		
		-p：打印出使用的salt、口令以及初始化向量IV。		
		-P：打印出使用的salt、口令以及IV，不做加密和解密操作，直接退出。		
		-bufsize number：设置I/O操作的缓冲区大小。因为一个加密的文件可能会很大，每次能够处理的数据是有限的。		
		-nopad：没有数据填充(主要用于非对称加密操作)。		
		-debug：打印调试信息。		
		-none：不对数据进行加密操作。		
		-engine：指定硬件引擎。
	ciphers    列出加密套件	
		-v：详细列出所有加密套件。包括SSL版本(SSLv2、SSLv3以及TLS)、密钥交换算法、身份验证算法、对称算法、摘要算法以及该算法是否允许出口。
		-ssl2：只列出sslv2使用的加密套件。		
		-ssl3：只列出sslv3使用的加密套件。		
		-tls1: 只列出tls使用的加密套件。		
		cipherlist：列出一个cipher list的详细内容。此项能列出所有符合规则的加密套件，如果不加-v选项，它只会显示各个套件名称。		
		cipherlist格式： openssl ciphers 'cipherstring1:cipherstring2.....'
	genrsa     用于生成私钥
		-out fiename: 指定输出文件。如果没有设定此选项，将会输出到标准输出。
		-passout arg: 指定密码来源。		
		-des|-des3|-idea：用来加密私钥文件的三种对称加密算法。		
		-F4|-3：指定指数。-f4为0x1001  		
		-rand file(s)：指定随机种子。		
		-engine id：硬件引擎。		
		numbits:  生成的密钥位数。必须是本指令的最后一个参数。默认为512bits。
	rsa        RSA密钥管理(例如:从私钥中提取公钥)	
	req        生成证书签名请求(CSR)	
		-inform PEM|DER——输入的证书请求的格式。 DER选项使用与PKCS＃10兼容的ASN1 DER编码格式。 PEM格式是默认格式：它由DER格式base64编码，带有附加的头部和尾部。
		-outform PEM|DER——输出的证书或证书请求的格式，默认PEM
		-in filename——输入的证书请求文件名，如果未指定此选项，则从标准输入。只有未指定选项-new和-newkey)时，才会读取证书请求
		-out filename——输出证书或证书请求文件名，不指定则默认标准输出
		-[digest]——指定消息摘要算法(如-md5，-sha1)来对证书请求签名。这将覆盖配置文件中指定的摘要算法。 * 一些公钥算法可以忽略这个选项*。例如，DSA签名始终使用SHA1，GOST R 34.10签名始终使用GOST R 34.11-94(-md_gost94)。
		-config filename——使用的config文件的名称。本选项如果没有设置，将使用缺省的config文件
		-key filename—— 指定从中读取私钥的文件。它也读取PEM格式的PKCS＃8私钥
		-keyform PEM|DER——在-key参数中指定的读入的私钥文件的格式。默认 PEM
		-passin arg——私钥的口令
		-keyout filename—— 指定新创建的私钥的输出文件名字。如果未指定此选项，则使用配置文件中的文件名。只能以PEM格式输出
		-passout arg——新建的私钥口令
		-rand file(s)——指定随机数种子文件，或者EGD套接字的随机数据的文件，多个文件间用分隔符分开，windows用“;”，OpenVMS用“,“，其他系统用“：”
		-nodes——如果指定了此选项，创建私钥时则不会对其进行加密
		-keygen_engine id——生成私钥的引擎
		-pkeyopt opt：value 设置公钥算法选项选择值。genpkey手册页中的密钥生成选项。
		-newkey arg——用于生成新的私钥以及证书请求。arg 可以是下列： 
		rsa：nbits——其中nbits是比特数，指明生成一个RSA密钥的长度。如果省略nbits，如：-newkey rsa，则使用配置文件中指定的默认密钥长度。
		alg:file——所有其他算法都支持-newkey alg：filename，其中文件可能是由genpkey -genparam命令创建的算法参数文件或于具有适用于alg算法的密钥的X.509证书。
		param:file —— 用参数文件或证书文件生成一个密钥，算法由参数决定，
		algname:file—— 使用algname指定的算法和flle指定的参数生成密钥， 算法与参数必须匹配，algname指定代表所使用的算法，file可以省略，但必须用 -pkeyopt parameter指定参数。
		dsa：filename——使用文件filename中的参数生成DSA密钥。
		ec：filename——生成EC密钥(可用于ECDSA或ECDH算法)，
		gost2001：filename——生成GOST R 34.10-2001密钥(需要在配置文件中配置ccgost引擎)。如果只指定gost2001，则应通过-pkeyopt paramset：X指定参数集
		-verify—— 验证证书请求上的签名。
		-new——本选项产生一个新的证书请求，它会要用户输入创建证书请求的一些必须的信息。至于需要哪些信息，是在config文件里面定义好了的。如果-key没有被设置,，那么就将根据config文件里的信息先产生一对新的RSA密钥值。
		-multivalue-rdn——当采用-subj arg选项时，允许多个值的rdn，比如arg参数写作：/CN=china/OU=test/O=abc/UID=123456+CN=forxy。如果不使用此选项，则UID值为123456+CN=forxy
		-asn1-kludge——缺省的req指令输出不带属性的完全符合PKCS10格式的证书请求，但有的CA仅仅接受一种非正常格式的证书请求，这个选项的设置就可以输出那种格式的证书请求。PKCS＃10证书请求中的属性被定义为SET OF属性。 它们不是可选的，因此如果没有属性存在，那么它们应该被编码为空的SET OF。 而非正常格式的证书请求中不包括空的SET OF。 应该注意的是，很少的CA仍然需要使用这个选项。
		-no-asn1-kludge——不输出特定格式的证书请求。
		-newhdr——在CSR问的第一行和最后一行中加一个单词”NEW”，有的软件(netscape certificate server)和有的CA就有这样子的怪癖嗜好。如果那些必须要的选项的参数没有在命令行给出，那么就会到config文件里去查看是否有缺省值
		-extensions section -reqexts section——这俩个选项指定config文件里面的与证书扩展和证书请求扩展有关的俩个section的名字(如果-x509这个选项被设置)。这样你可以在config文件里弄几个不同的与证书扩展有关的section，然后为了不同的目的给证书请求签名的时候指明不同的section来控制签名的行为。。
		-utf8—— 此选项将字段值解释为UTF8字符串，默认情况下将其解释为ASCII。这意味着字段值(无论是从终端提示还是从配置文件获取)必须是有效的UTF8字符串。
		-subj arg——用于指定生成的证书请求的用户信息，或者处理证书请求时用指定参数替换。生成证书请求时，如果不指定此选项，程序会提示用户来输入各个用户信息，包括国名、组织等信息，如果采用此选择，则不需要用户输入了。比如：-subj /CN=china/OU=test/O=abc/CN=forxy，注意这里等属性必须大写。
			subj中设定的subject的信息为用户自己的数据，一般将CN设定为域名/机器名/或者IP名称，比如kubelet为所在node的IP即可
		-batch——不询问用户任何信息(私钥口令除外)，采用此选项生成证书请求时，不询问证书请求当各种信息
		-verbose—— 打印关于执行操作的额外的详细信息
		-engine id——引擎
		-x509—— 此选项输出自签名证书。这通常用于生成测试证书或自签名根证书。添加到证书的扩展项(如果有)在配置文件中指定。除非使用set_serial选项，否则将使用较大的随机数作为序列号。
		-days n—— 当使用-x509选项时，指定证书的有效期。默认为30天。
		-set_serial n—— 输出自签名证书时使用的序列号。如果前缀为0x，则可以将其指定为十进制值或十六进制值。可以使用负序列号，但不建议这样做。
		-text—— 以文本形式打印证书请求
		-pubkey—— 输出公钥。
		-noout——选项可防止输出证书请求的编码版本
		-modulus—— 该选项打印证书请求中公钥的模数值
		-subject—— 打印证书请求的subject
		-nameopt——用于确定主题或发行者名称的显示方式。选项参数可以是单个选项或多个选项，以逗号分隔。-nameopt开关可以被多次使用以设置多个选项。参见X509。
		-reqopt—— 定制与-text一起使用时的输出格式。选项参数可以是单个选项或多个选项，以逗号分隔。 请参阅x509命令中-certopt参数的说明。
	crl        证书吊销列表(CRL)管理	
	ca         CA管理(例如对证书进行签名)	
	dgst       生成信息摘要	
	rsautl     用于完成RSA签名、验证、加密和解密功能	
	passwd     生成散列密码	
	rand       生成伪随机数	
	speed      用于测试加解密速度                    	
	s_client   通用的SSL/TLS客户端测试工具	
	X509       X.509证书管理	
	verify      X.509证书验证	
	pkcs7       PKCS#7协议数据管理
	
	根证书公钥与私钥			ca.pem与ca.key
	API Server公钥与私钥		apiserver.pem与apiserver.key
	集群管理员公钥与私钥		admin.pem与admin.key
	节点proxy公钥与私钥			proxy.pem与proxy.key 			节点kubelet的公钥与私钥：是通过boostrap响应的方式，在启动kubelet自动会产生, 然后在master通过csr请求，就会产生
		kubelet 首次启动时向kube-apiserver 发送TLS Bootstrapping 请求，kube-apiserver 验证请求中的token 是否与它配置的token.csv 一致，如果一致则自动为kubelet 生成证书和密钥
		token.csv里的token可以通过head -c 16 /dev/urandom | od -An -t x | tr -d ' '来生成
	例:生成kubernetes相关证书
		1.生成ca私钥
			openssl genrsa -out ca.key 2048
		2.创建ca证书
			openssl req -x509 -new -nodes -key ca.key -subj "/CN=kubernetes/O=k8s" -days 5000 -out ca.crt
		3.生成apiserver,proxy等证书均可按如下方式创建,一般只需要创建etcd,apiserver,kubectl,kubeproxy证书,apiserver的可以取名叫kubernetes,kubectl的证书可以取名叫admin
			先生成私钥
				openssl genrsa -out server.key 2048
			再生成证书签名请求
				openssl req -new -key server.key -subj "/CN=kubernetes/O=k8s" -out server.csr -config openssl.cnf  (config配置可以没有)
			最后使用ca根证书和ca根私钥生成证书
				openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 5000 -extensions v3_req -extfile openssl.cnf (extension3和extfile是配合使用的)
			创建admin,由于后续 kube-apiserver 在启用RBAC模式之后， 客户端(如 kubelet、kube-proxy、Pod)请求进行授权的时候会需要认证用户名、以及用户组,这里的/CN=admin/O=system:masters/OU=System就是在CN定义用户为admin，O定义用户组为system:masters，OU 指定该证书的 Group 为 system:masters
				openssl req -new -key admin.key -out admin.csr -subj "/CN=admin/O=system:masters/OU=System"
				在证书的签名中，OU 指定该证书的 Group 为 system:masters，kubelet 使用该证书访问 kube-apiserver 时 ，由于证书被 CA 签名，所以认证通过，同时由于证书用户组为经过预授权的 system:masters，所以被授予访问所有 API 的权限；
			创建proxy证书
				openssl req -new -key proxy.key -out proxy.csr -subj "/CN=system:kube-proxy/O=k8s/OU=System"
				