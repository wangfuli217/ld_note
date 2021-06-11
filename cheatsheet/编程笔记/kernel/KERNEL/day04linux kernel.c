回顾：
一.嵌入式linux系统软件之linux操作系统内核
1.linux内核特点
2.linux内核功能
  7大子系统
  uboot启动内核开始,掉电结束,运行在内存
3.linux内核源码操作
  3.1.获取官方源码
  3.2.windows创建SI源码工程

3.3.linux系统中进行配置编译
	1.安装好交叉编译器
	   版本要合适
	2.内核源码操作三步曲
	  make distclean
   	  make ABC_defconfig
	  make zImage
	  成果：arch/arm/boot/zImage

3.4.到目前为止，zImage肯定能够运行在芯片公司的参考板上，但不能保证能够      
    运行在自己的开发板上，此时需要从以下两个方面进行突破，
    具体实施步骤：

	1. 明确参考板和自己的开发板之间的硬件差异
	2. 观察linux内核配置信息，配置信息是否正确
	   cd /opt/kernel
	   make menuconfig //开始对linux内核进行菜单式配置
			  //掌握一些关键的配置信息
	  
	 System Type --->
		//当前内核源码能够支持ARM架构，能够支持三星S5PV210
		//如果没有以下信息，
		//一般问题出在没有make CW210_defconfig
		ARM system type(Samsung S5PV210/S5PC110) --->
	  
		//使用UART0作为调试打印串口，按回车键进入可以修改
		(0) S3C UART to use for low-level messages

		//开发板选项
		Board selection(SMDKV210) --->	

	 Boot options --->
		//明确：内核启动挂接rootfs，使用的启动参数的传参方法
		  方法1：利用uboot传递的bootargs
		  方法2：内核自己给自己传递参数，以下这条语句就是内核
		         自己传递的参数，按回车键进入进行修改
		(console=ttySAC2,115200) Default kernel command string

		//如果此条目选中，表示内核启动使用自己的参数信息，
		  如果没有选中此条目，表示内核使用uboot的bootargs
		  按Y键进行选中，选中以后变成[*]
		[ ]Always use the default kernel command string		

	 Device Drivers --->//设备驱动支持
		//Nor和Nand驱动支持
		<*> Memory Technology Device (MTD) support  --->
			<*>   Mapping drivers for chip access  ---> //Nor
			<*>   NAND Device Support  --->    //Nand
	
		//网卡驱动
		[*] Network device support  --->
			[*]   Ethernet (10 or 100Mbit)  --->
				<*>   DM9000 support		

		//input设备驱动：键盘，鼠标，触摸屏，游戏手柄等
		Input device support --->
			[*]   Keyboards  --->
			[*]   Touchscreens  ---> 

		//字符设备驱动
		Character device --->
		
		//I2C总线驱动支持
		<*> I2C support  --->

		//SPI总线驱动支持
		[*] SPI support  --->

		//GPIO操作库函数
		-*- GPIO Support  --->

		//一线式驱动
		< > Dallas's 1-wire support  --->  '

		//看门狗驱动
		[*] Watchdog Timer Support  --->

		//摄像头驱动支持
		<*> Multimedia support  --->

		//LCD显示屏驱动
		Graphics support  --->

		//声卡驱动
		<*> Sound card support  ---> 

	 File systems --->
		//支持EXT4系统格式，兼容ext2，ext3
		<*> The Extended 4 (ext4) filesystem

		[*] Miscellaneous filesystems  --->
			//支持yaffs2文件系统格式（一般应用于Nandflash）
			<*>   YAFFS2 file system support

			//支持jffs2（一般应用于NorFlash）
			<*>   Journalling Flash File System v2 (JFFS2) support
	
			//支持cramfs文件系统格式
			<*>   Compressed ROM file system support (cramfs)
	
		//网络文件系统
		[*] Network File Systems  --->
			//如果让内核采用NFS网络服务挂接rootfs，必须选中此条目
			[*] Root file system on NFS

案例：内核启动利用NFS网络服务挂接rootfs，参数由内核自身传递,
      不再使用uboot的bootargs
	
	实施步骤：
            1.cd /opt/kernel
              make menuconfig
                  Boot options  --->
                     (console=ttySAC2,115200) Default kernel command string 
                     按回车键进入,修改为如下：
                     root=/dev/nfs nfsroot=192.168.1.8:/opt/rootfs ip=192.168.1.110:192.168.1.8:192.168.1.1:255.255.255.0::eth0:on init=/linuxrc console=ttySAC0,115200
                     保存退出
                     
                     //按Y键选中此条目
                     [*]Always use the default kernel command string   
                     
              保存退出,记住按YES
              make zImage //重新编译内核源码
              cp arch/arm/boot/zImage /tftpboot
           
           2.开发板测试,开发板上执行：
             进入uboot的命令行：
             setenv bootargs  //设置bootargs为空,bootargs没有信息了 
             setenv bootcmd tftp 20008000 zImage \; bootm 20008000
             saveenv 
             boot //启动系统,就是执行bootcmd的命令 
             看内核是否能够启动,正常挂接rootfs
             
           3.实验做完,最后重新修改为uboot传递参数方式

	

	3.如果根据硬件差异，将内核配置完毕以后，内核同样不能运行在自己的板子上，
	  一定要多多看平台代码文件：
	  内核源码：arch/arm/mach-处理器名/mach-开发板名.c
	  cw210平台文件：arch/arm/mach-s5pv210/mach-cw210
	  切记：此平台文件定义了大量的开发板外设的硬件信息，这些信息将来都是
	       要给外设对应的设备驱动程序使用！
	       将来如果硬件上发生变化，只需关注此文件，修改即可！ 


4.1.linux内核源码菜单的操作
问：make menuconfig以后出现的菜单，如何添加一个新的子菜单
    菜单项如何最终跟对应的源码关联在一起

老师的场景：进入内核源码,执行make menuconfig,按/键搜索LM77关键字
            能够获取到内核支持LM77温度传感器的菜单信息,说明内核
            也就支持对应的硬件驱动,如何找到对应的源码呢？

1.菜单实现和代码的对应编译只需要两个关键文件：Kconfig和Makefile
   	Kconfig：用来生成一个菜单选项
	Makefile：用来编译源代码

2.Kconfig的基本语法
	参考代码：
	config HELLO_WORLD
	TAB键 tristate "hello,world"
	TAB键 help
		   "this is my first kernel code"

	说明：
	config关键字用来生成一个新的选项，叫HELLO_WORLD
	tristate关键字具有三种操作状态：不选，*，M
	bool关键字具有两种操作状态：不选和*
	help关键字用来指示选型的说明信息
	"不选"：将来对应的源代码不会被编译
	"*"：将对应的源代码和zImage编译在一起
	"M"：也会编译对应的源代码，但是不会和zImage编译器在一起
	     单独编译
	结论：这个菜单将来生成的最终选项是对应的Makefile文件使用，
	      最终的选项名为：CONFIG_HELLO_WORLD,给对应的Makefile使用
	      如果不选择，CONFIG_HELLO_WORLD=空
              如果选择为*，CONFIG_HELLO_WORLD=y
	      如果选择为M，CONFIG_HELLO_WORLD=m

	Makefile使用生成的CONFIG_HELLO_WORLD的步骤：
	obj-$(CONFIG_HELLO_WORLD) +=helloworld.o
	说明：
	根据CONFIG_HELLO_WORLD的值决定helloworld.c代码如何
	编译（不编译，在一起，单独编译）

	一般：
	将源码和zImage编译在一起，又称静态编译
	单独编译源码，又称模块化编译 （module）
/*重点  以后工作中能用上 */
案例：将TPAD开发板LED灯的驱动程序静态编译到内核中
实施步骤：
	1.从ftp下载LED灯的设备驱动程序
		led_drv.c //LED驱动程序
		led_test.c//LED应用测试程序
	2.拷贝驱动到内核源码中
	  cp led_drv.c /opt/kernel/drivers/char/
	3.修改Kconfig添加对led灯菜单的支持
	  vim /opt/kernel/driver/char/Kconfig 添加如下内容：
	  config TARENA_LED
	  	tristate "tpad led drivers support"
		help
			"this is my first led kernel drivers"
	3.保存退出
	4.修改Makefile添加对LED灯驱动的编译支持
	  vim /opt/kernel/driver/char/Makefile 添加如下内容
	  obj-$(CONFIG_TARENA_LED)  +=led_drv.o
	  保存退出
	5.配置内核源码
	  cd /opt/kernel
	  make menuconfig
		Device Drivers->
			Character devices->
				//按Y键选为*：和zImage编译在一起
				<*> "tpad led drivers support"
	  保存退出
	  make zImage
	  cp arch/arm/boot/zImage /tftpboot

	6.测试LED驱动
	  进入uboot命令行：
	  setenv bootcmd tftp 20008000 zImage \; bootm 20008000
	  setenv bootargs root=/dev/nfs nfsroot=192.168.1.8:/opt/rootfs ip=192.168.1.110:192.168.1.1:255.255.255.0::eth0:on init=/linuxrc console=ttySAC0,115200
	  saveenv
	  boot //启动系统
	   "this is my first led driver!"
    	   如果看到以上语句,说明驱动正常安装

  	7.交叉编译驱动测试程序
    	  cp led_test.c /opt/kernel/
    	  cd /opt/kernel/
    	  arm-linux-gcc -o led_test led_test.c
    	  cp led_test /opt/rootfs/
    
  	8.开发板运行测试程序(开发板的linux系统正常运行)
     	  ./led_test on 1
    	  ./led_test on 2
    	  ./led_test off 1
    	  ./led_test off 2


案例：将TPAD开发板LED灯的驱动程序采用模块化编译
实施步骤：
	1.配置内核源码，将LED驱动对应的菜单选择为M
	  cd /opy/kernel
	  make menuconfig
		Device Drivers->
			Character devices->
				//按M键选为M：模块化编译驱动
				<M> "tpad led drivers support"

	保存退出
	
	2.单独编译内核源码和LED驱动
	  cd /opt/kernel

	  make zImage //单独编译内核
	  cp arch/arm/boot/zImage /tftpboot

	  make modules //单独编译LED驱动

	成果：
	ls drivers/char/led_drv.ko 
	//将led_drv.c单独编译成对应的二进制文件led_drv.ko
	
	cp led_drv.ko /opt/rootfs/

	3.安装LED驱动到内核,开发板执行(前提是内核已经挂接NFS的rootfs)：
	
 	  cd /
  	  ls 
      	  led_drv.ko  //LED驱动的二进制文件 
      	  led_test    //LED驱动的测试程序
      
  	  insmod led_drv.ko //安装驱动到内核中,insmod = insert module
  	  ./led_test on 1
  	  ./led_test on 2
    	  ./led_test off 1
    	  ./led_test off 2
  
  	  rmmod led_drv //从内核中卸载LED驱动


**********************************************************************
问：rootfs根文件系统从何而来？
嵌入式linux系统软件之rootfs根文件系统

1.rootfs根文件系统概念
	根文件系统仅仅是一个代名词
	不代表任何一种文件系统格式，比如NFTS，FAT32等
	linux系统的“/”里面的内容组合在一起形成rootfs根文件系统

2.rootfs根文件系统包含哪些内容
  cd /
  ls //查看根文件系统包含的内容
  rootfs根文件系统包含了一大堆的用户命令，一大堆的静态库，动态库，
  一大堆的配置文件和服务
 
  rootfs根文件系统的内容有些必须存在，有些可以不需要：
 	必须的目录：8大目录
	bin：命令
	sbin：命令
	lib：库
	etc：配置服务
	proc：虚拟文件系统入口，驱动相关
	sys：虚拟文件系统入口，驱动相关
	dev：设备文件，驱动相关
	usr：命令

	可选目录：
	home：普通用户主目录
	mnt：挂接点
	var：临时目录
	root：root用户主目录
	opt：临时目录
	...

3.rootfs根文件系统如何制作呢？
答：利用开源软件busybox  	//www.busybox.net

问：为什么不用芯片厂家提供的rootfs呢？
答：一般不建议使用芯片厂家的rootfs，因为芯片厂家的rootfs功能相当之强大，
    带来的结果是rootfs的体积相当臃肿，会大量的占用内存空间，有些功能还用不着，
    建议自己制作rootfs！

切记：busybox仅仅给你提供各种命令，什么动态库，什么配置服务等这些都需要自己额外添加

4.busybox操作

	1.配置好交叉编译器
	  注意版本要合适
	2.在windows下解压缩，创建源码工程
	  便于将来阅读源码
	3.在linux系统解压缩，进行配置编译
	  cp /busybox.tar.bz2 /opt
	  cd /opt/
          tar -xvf busybox-1.21.1.tar.bz2
          mv bubusybox-1.21.1 busybox
          cd busybox //进入busybox源码根目录
          修改Makefile文件：
          vim Makefile +189
          将ARCH修改为：ARCH=arm  //指定将来运行的架构为ARM
      
          vim Makefile +163
          将CROSS_COMPILE修改为：CROSS_COMPILE=arm-linux-  //指定的交叉编译器
      
          保存退出
          make //编译
          make install //安装编译的成果
          将编译生成的各种命令的二进制文件统一放在busybox源码下的_install目录中
          ls _install //查看编译成果
          bin   sbin  usr  linuxrc
          说明：busybox仅仅是给你提供命令而已
	  
	  
