回顾：
1.嵌入式linux系统软件之linux内核
  linux内核特点
  linux内核功能
  linux内核生命周期
  linux内核源码操作
  获取源码
  创建源码阅读工程
  交叉编译器的环境配置
  配置编译
  make distclean
  make ABC_defconfig
  make zImage
  arch/arm/boot/zImage
  尝试先运行
  检查内核的配置信息
  make menuconfig
  	System Type->
  	Boot options->
  	Device Drivers->
  	File system->
  仔细阅读平台文件：arch/arm/mach-处理器名/mach-开发板名.c
  注意：此文件定义的大量硬件信息将来给设备驱动使用
  还要确保硬件正常
  向内核添加一个内核代码的过程：Kconfig和Makefile
  
2.嵌入式linux系统软件之rootfs根文件系统

  2.1.rootfs根文件系统概念
  仅仅是一个代名词而已
  不是具体某种文件系统格式
  本质就是"/"
  
  2.2.rootfs包含的内容
  cd /
  ls //看到的东西就是rootfs的内容
  就是包含了一大堆的命令,一大堆的库,一大堆的配置服务等
  
  必要的目录：
  bin
  sbin
  usr
  proc
  sys
  etc
  lib
  dev
  
  可选的目录：  
  home
  tmp
  var
  mnt
  ...
  
  2.3.制作rootfs根文件系统只需busybox
  2.4.busybox特点
      开源软件
      www.busybox.net
      瑞士军刀
      切记：busybox开源软件仅仅获取命令而已(ls,cd等)！
            至于其他的动态库,配置文件等需要自己额外的添加

3.busybox源码操作
  注意：配置好交叉编译器,版本要合适
  具体的实施步骤：
  1.下载busybox源码
  2.windows解压缩一份,创建SI工程,便于将来看源码
    玩好UC编程,看busybox源码即可！
    例如：第一号进程/sbin/init->源码init/init.c
  3.linux交叉编译过程
    3.1.源码解压缩
    cp busybox-1.21.1.tar.bz2 /opt/
    cd /opt/
    tar -xvf  busybox-1.21.1.tar.bz2
    mv busybox-1.21.1 busybox
    cd busybox  //进入busybox源码根目录
    
    3.2.修改Makefile,指定交叉编译器
    cd /opt/busybox
    vim Makefile +189
    将ARCH修改:ARCH=arm
    
    vim Makefile +163
    将CROSS_COMPILE修改为：CROSS_COMPILE=arm-linux-
    保存退出
    
    3.3.注意：busybox也可以进行make menuconfig菜单式配置
        可以将有些命令支持或者不支持
        注意：buysbox去除一些关键的命令
        cd /opt/busybox
        make menuconfig
            //支持驱动安装和卸载命令
            Linux Module Utilities  --->
            	  [*] Simplified modutils //去除精简的命令,此时会出现完整的驱动操作命令
            	 //以下全部选中,这些都是完整的驱动操作命令
            	  [*]   insmod                            
                  [*]   rmmod                              
   		  [*]   lsmod                             
                  [*]   Pretty output                      
                  [*]   modprobe                           
                  [*]   Blacklist support                  
   		  [*]   depmod       
            
            Miscellaneous Utilities  --->
          	  //去除nand写和读命令
          	  [ ] nandwrite
          	  [ ] nanddump
         保存退出
     
     3.4.交叉编译和安装busybox
         cd /opt/kernel
         make 
         make install //安装,默认安装到当前目录下的_install目录中
         cd _install 
         ls 
           bin sbin usr linuxrc
         重要结论：生成的各种命令都是软链接文件,最终都链接到
         bin/busybox,所以说编译busybox源码最终生成的二进制
         文件只有一个：bin/busybox    


3.4.交叉编译和安装busybox

     	 cd /opt/busybox
         make 
         make install //安装,默认安装到当前目录下的_install目录中
         cd _install 
         ls 
           bin sbin usr linuxrc
         重要结论：生成的各种命令都是软连接文件,最终都连接到
         bin/busybox,所以说编译busybox源码最终生成的二进制
         文件只有一个：bin/busybox     

3.5.创建必要目录和可选目录

        cd /opt/busybox/_install
        mkdir  lib etc dev proc sys  //必要目录
        mkdir home var tmp mnt //可选目录

3.6.添加应用程序（bin/busybox）所需的动态库
    明确：动态库在哪里
	  动态库在交叉编译器中         		(在交叉编译器中找动态库)
          动态库的命名：lib名.so.....

    添加原则：应用程序需要哪些动态库就添加对应的动态库即可

    明确：获取应用程序所需动态库的方法
    cd /opt/busybox/_install
    arm-linux-readelf -a bin/busybox | grep "Shared"
    得到：
         0x00000001 (NEEDED)  Shared library: [libm.so.6]
         0x00000001 (NEEDED)  Shared library: [libc.so.6]

    结论：busybox可执行程序所需两个库：libm.so.6 和 libc.so.6

    明确：将来找到的动态库放在lib中

    进入交叉编译器中，找所需的动态库，并拷贝：
    拷贝前先查看文件属性 ls -lh 
        cd /home/tarena/workdir/toolchains/opt/S5PV210-crosstools/4.4.6
        find . -name libm.so.6
        得到：
        ./arm-concenwit-linux-gnueabi/concenwit/usr/lib/libm.so.6
        ls ./arm-concenwit-linux-gnueabi/concenwit/usr/lib/libm.so.6 -lh
        得到：
        libm.so.6也是软连接文件,所以还需要拷贝它的实体文件

        拷贝：
	cp -d  拷贝时保留链接
        cp arm-concenwit-linux-gnueabi/concenwit/usr/lib/libm-2.10.1.so /opt/busybox/_install/lib/ -d
	cp arm-concenwit-linux-gnueabi/concenwit/usr/lib/libm.so.6 /opt/busybox/_install/lib/ -d
    

	同理拷贝libc库：
	find . -name libc.so.6
	./arm-concenwit-linux-gnueabi/concenwit/usr/lib/libc.so.6
        ls ./arm-concenwit-linux-gnueabi/concenwit/usr/lib/libc.so.6 -lh
        得到：
        libc.so.6也是软连接文件,所以还需要拷贝它的实体文件
        拷贝：
        cp arm-concenwit-linux-gnueabi/concenwit/usr/lib/libc-2.10.1.so /opt/busybox/_install/lib/ -d
	cp arm-concenwit-linux-gnueabi/concenwit/usr/lib/libc.so.6 /opt/busybox/_install/lib/ -d

    关键 最后：拷贝动态链接库（加载器）到lib
    提示：加载器的命名：ld-...
    cp arm-concenwit-linux-gnueabi/concenwit/usr/lib/ld-* /opt/busybox/_install/lib/ -d
    
    总结：将来拷贝动态库，首先获取应用程序所需的动态库有哪些，
          然后到交叉编译器中进行拷贝，拷贝时，不要光拷贝链接文件
	  还要把对应的实体文件进行拷贝！


3.7.添加系统启动的必要配置文件和启动脚本文件
    明确：配置文件和脚本文件一般放置在etc目录
    明确：两个配置文件inittab，fstab
          一个脚本文件rcS

    1.添加inittab文件
      cd /opt/busybox/_install
      vim etc/inittab 添加如下内容：

      ::sysinit:/etc/init.d/rcS
      ::respawn:-/bin/sh
      ::ctrlaltdel:/sbin/reboot
      ::shutdown:/bin/umount -a –r

      说明inittab文件格式：
      id:runlevel:action:process
  
      注意：嵌入式linux来说，一般id，runlevel给空即可
      
      action的三个关键字：sysinit，askfirst，respawn
      sysinit：此action表示第一号进程/sbin/init启动以后会创建一个子进程，
               子进程会执行sysinit对应process信息（/etc/init.d/rcs,脚本），
 	       父进程等待子进程的结束。

      askfirst和respawn是一样的：当sysinit对应的process进程执行完毕，
      父进程init继续执行，会再次创建一个子进程，
      执行askfirst或者respawn对应的process信息（/bin/sh）
      至此就启动了一个shell，就可以跟用户进行交互;
      前者askfirst在执行/bin/sh之前需要用户按回车键
      后者respawn无需用户按回车键,直接去执行/bin/sh
      所以建议：采用respawn 


    总结：细分嵌入式linux系统启动进程：
     上电->uboot->根据bootcmd加载启动内核->根据bootargs挂接
     rootfs->挂接成功->启动linuxrc进程->启动/sbin/init->
     init解析inittab文件->init进程首先找sysinit信息->
     找到以后创建子进程,执行/etc/init.d/rcS脚本->
     rcS执行完毕->init继续往下执行->init继续找askfirt或者
     respawn->执行对应的/bin/sh->至此启动了shell->可以跟
     用户进行交互   

    2.添加启动脚本文件etc/init.d/rcS
      cd /opt/busybox/_install
      mkdir etc/init.d
      vim etc/init.d/rcS 添加如下内容：

      #!/bin/sh
      /bin/mount -a
      mkdir /dev/pts
      mount -t devpts devpts /dev/pts
      echo /sbin/mdev > /proc/sys/kernel/hotplug
      mdev -s

      保存退出
      chmod 777 etc/init.d/rcS

      说明：
      /bin/mount -a:将来系统会自己解析并且执行etc/fstab

      mkdir /dev/pts
      mount -t devpts devpts /dev/pts
      以上两句话用户远程登录服务,例如telnet

    3.添加文件系统挂机配置文件etc/fstab   (file system tab 文件系统列表)
      切记：etc/fstab文件必须由rcS脚本中的mount -a命令执行
   
      cd /opt/busybox/_install
      vim etc/fstab 添加如下内容
 
      proc           /proc        proc   defaults        0    0
      tmpfs          /tmp         tmpfs  defaults        0    0
      sysfs          /sys         sysfs  defaults        0    0
      tmpfs          /dev         tmpfs  defaults        0    0
 
     保存退出

      说明：
      将proc目录，tmp目录，sys目录，dev目录分别挂接成
      procfs，sysfs，tmpfs虚拟文件系统，也代表将来
      proc目录,tmp目录,sys目录,dev目录下的内容都是
      由内核自动创建,这三种虚拟文件系统的内容都是存在于
      内存,掉电丢失！

3.8.至此最小根文件系统制作完毕，利用NFS进行测试
    mv /opt/rootsfs /opt/rootfs_bak    //备份原先的根文件系统
    cp /opt/busybox/_install /opt/rootfs -frd  
    //-f 删除已经存在的目标文件而不提示
      -d 拷贝时保留链接
      -r 若给出的源文件是一目标文件，此时cp将递归复制该目录下所有的子目录和文件。此时目标文件必须为一个目录名
    du /opt/rootfs -lh  //目前来说大小为3.2M （du不算文件空洞，有效大小 ls算文件空洞）
    重启开发板，进入uboot，执行：
    setenv bootargs root=/dev/nfs nfsroot=192.168.1.8:/opt/rootfs ip=192.168.1.110:192.168.1.1:255.255.255.0::eth0:on init=/linuxrc console=ttySAC0,115200
    saveenv
    boot //启动,看是否能够挂接自己的rootfs
    linux系统启动完毕,执行：
    cat /proc/cmdline //查看内核的启动参数

3.9.利用NFS网络进行应用程序的测试
    虚拟机执行：
    cd /opt/rootfs/
    vim helloworld.c
    arm-linux-gcc -o helloworld helloworld.c

    开发板测试：
    ./helloworld


3.10.如何实现应用程序的自启动？
     虚拟机执行：
     cd /opt/rootfs
     vim etc/init.d/rcS 在文件最后添加：
     cd /
     ./helloworld & //让应用程序helloworld后台运行,便于后序咱们继续能够输入命令
     保存退出
     重启开发板
     观察应用程序是否启动：
     ps 


      
4.1.问:rootfs.cramfs,android_rootfs.bin从何而来?
    部署(烧写)rootfs到开发板上Nand

    实施步骤：
    1.明确：rootfs目前还是一个目录
    2.明确：要烧写rootfs到Nand,首先必须将rootfs目录制作成单个镜像文件
    3.明确：在操作系统下访问文件,文件所在分区必须要格式化成
            某种文件系统格式,类似安装windows到C盘,首先会提示
            你将C盘格式化成NTFS或者FAT32文件系统格式

    4.常见的嵌入式linux闪存使用的文件系统格式：
      cramfs文件系统格式：只读压缩
      yaffs2文件系统格式：针对NandFlash，非压缩，可读写
      jffs2文件系统格式：针对NorFlash,非压缩,可读写
      ubifs文件系统格式：针对NandFlash,卷,非压缩,可读写
      ramdisk文件系统格式：存在内存中,效率最高,占用内存空间
      initramfs文件系统格式：本质就是zImage+ramdisk

5.案例：将rootfs制作成cramfs文件系统格式的镜像文件
  实施步骤：
  1.配置linux内核支持cramfs文件系统格式
    cd /opt/kernel
    make menuconfig
        File systems  --->  
           [*] Miscellaneous filesystems  --->
           	//按Y选择为*支持cramfs文件系统格式
                  < >   Compressed ROM file system support (cramfs) 
    保存退出
    make zImage 
    cp arch/arm/boot/zImage /tftpboot 

  2.切记：烧写之前一定要记得对内存进行分区规划
  
    0——————2M——————7M——————17M——————剩余
        uboot         zImage       rootfs        userdata
     mtdblock0      mtdblock1    mtdblock2      mtdblock3


  3.修改内核的NandFlash驱动中的分区表
    cd /opt/kernel
    vim drivers/mtd/nand/s3c_nand.c +40 将内核现在的Nand

    分区表修改为如下形式：
    struct mtd_partition s3c_partition_info[] = {
    	 //描述第一分区的信息
    	 {
  	    .name           = "uboot",//分区名
  	    .offset         = (0), //分区起始地址              
  	    .size           = (2*SZ_1M),//分区大小
         },
         //描述第二分区的信息
         {
  	    .name           = "zImage",
  	    .offset         = MTDPART_OFS_APPEND,//追加              
  	    .size           = (SZ_1M*5),
         },
         //描述第三分区的信息
         {
  	    .name           = "rootfs",
  	    .offset         = MTDPART_OFS_APPEND,               
  	    .size           = (10*SZ_1M),
         },
         //描述第四分区的信息
         {
  	    .name           = "userdata",
  	    .offset         = MTDPART_OFS_APPEND,               
  	    .size           = MTDPART_SIZ_FULL,//剩余
         },

    };
    保存退出
    make zImage
    cp arch/arm/boot/zImage /tftpboot

 
  4.将rootfs制作成单个镜像文件rootfs.cramfs
    只需工具：mkfs.cramfs
    cd /opt/
    mkfs.cramfs rootfs rootfs.cramfs  
    cp rootfs.cramfs /tftpboot

  5.开发板烧写  
    重启开发板,进入uboot：
    tftp 50008000 rootfs.cramfs
    nand erase 700000 a00000
    nand write 50008000 700000 a00000
    setenv bootargs root=/dev/mtdblock2 init=/linxurc console=ttySAC0,115200 rootfstype=cramfs
    说明：告诉内核,rootfs在Nand的第三分区上
    saveenv
    boot //启动linux系统
    启动以后,验证：
    cat /proc/cmdline //查看内核启动参数,确保是从Nand启动
    mkdir helloworld //失败,cramfs文件系统格式是只读的
    ps //查看自启动的应用程序的pid
    kill 程序的pid  


6.案例：将rootfs制作成yaffs2文件系统格式的镜像文件
  实施步骤：
  1.配置linux内核支持yaffs2文件系统格式
    cd /opt/kernel
    make menuconfig
        File systems  --->  
           [*] Miscellaneous filesystems  --->
           	//按Y选择为*支持yaffs2文件系统格式
                  <*>   YAFFS2 file system support
    保存退出
    make zImage 
    cp arch/arm/boot/zImage /tftpboot
  
  2. 切记：烧写之前一定要记得对闪存进行分区规划
  0------2M--------7M---------17M---------剩余
   uboot    zImage    rootfs      userdata
  mtdblock0 mtdblock1 mtdblock2  mtdblock3
 
  3.分区表已经修改过
    
  4.将rootfs制作成单个镜像文件rootfs.yaffs2
    只需要工具：mkyaffs2image
    从ftp下载工具mkyaffs2image
    sudo cp mkyaffs2image /sbin/ //将工具拷贝到linux虚拟机中
    sudo chmod 777 /sbin/mkyaffs2image
    cd /opt/
    mkyaffs2image rootfs rootfs.yaffs2  
    cp rootfs.yaffs2 /tftpboot
    sudo chmod 777 rootfs.yaffs2
  
  5.开发板烧写
    重启开发板,进入uboot：
    tftp 50008000 rootfs.yaffs2
    nand erase 700000 a00000
    nand write.yaffs 50008000 700000 $filesize
    或者
    nand write.yaffs 50008000 700000 $(filesize)
    setenv bootargs root=/dev/mtdblock2 init=/linxurc console=ttySAC0,115200 rootfstype=yaffs2
    说明：告诉内核,rootfs在Nand的第三分区上
    saveenv
    boot //启动linux系统
    启动以后,验证：
    cat /proc/cmdline //查看内核启动参数,确保是从Nand启动
    mkdir zhangsan //成功
    ps //查看自启动的应用程序的pid
    
    kill 程序的pid  

面试题：谈谈对嵌入式linux系统软件的认识
面试题：谈谈对嵌入式linux系统启动流程的认识


