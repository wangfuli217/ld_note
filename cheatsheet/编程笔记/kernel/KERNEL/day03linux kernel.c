回顾：
面试题：谈谈对uboot的认识
1.uboot特点
2.uboot功能
  uboot生命周期:上电运行,内核启动结束
  uboot运行的时间尽量要快,提高用户的体验度
  硬件初始化
  	必要硬件初始化
  		CPU初始化
  		关闭看门狗
  		关闭中断
  		初始化系统时钟
  		初始化UART
  		初始化闪存
  		初始化内存
  	可选硬件初始化
  	        一般来说：网卡和USB是需要初始化,便于软件调试
  	        根据用户的实际需求来定
  	        手机和路由器是否添加LOGO显示为例
  将内核从"某个地方"加载到内存中,并且启动内核,通过bootcmd
  给内核传递启动参数,告诉内核rootfs在哪里

3.uboot移植操作步骤
  获取源码
  windows解压
  linux解压
  先别尝试修改,先去编译
  make distclean
  make ABC_config
  make
  结果：u-boot.bin,尝试先运行
  找出参考板和自己的板卡之间的硬件差异(硬件工程师)
  例如：
  前提：
  	处理器架构：FPGA+ARM核
  	厂家：xilinx
  	处理器名：zynq720
  	参考板名：zed
  	自己板卡名：sdr
  硬件差异对比：
  zed板卡：
  	zynq720
  	DDR 1GB
  	SD卡8G
  	UART0
  	UART时钟频率：33.3MHz
  	网卡基地址:0x10000000
  	
  sdr板卡：
       zynq720
       DDR 128MB
       Norflash 256MB
       UART1
       UART时钟频率:40MHz
       网卡基地址:0x30000000
       ...
  一旦掌握硬件差异,接下来只需修改uboot源码即可
  慢慢阅读uboot的启动过程：
  通过编译uboot的打印信息获取到连接脚本和连接地址
  uboot编译连接脚本：u-boot.lds
  运行第一个文件：start.S
  运行第一条指令：b reset //开启汇编
  运行第一条C语言：ldr pc, start_armboot //开启C
  顺藤摸瓜
  真正的修改一般只需要关注头文件：include/configs/ABC.h
  	
3. uboot关键一些命令
  3.1.uboot现有命令的介绍
      查看uboot所有命令：?
      查看命令帮助：help 命令
      常见命令：
      printenv或print
      setenv
      savenv  
      go 
      bootm 
      tftp
      reset
      nand erase
      nand read
      nand write
      mw:写数据到外设
      md:从外设读取数据
  
  案例：利用mw,md实现读取Nand ID信息
  读取Nand ID信息时序：参见Nand手册
  uboot操作步骤：
  mw.b 0xB0E00008 0x90
  mw.b 0xB0E0000c 0x00
  md.b 0xB0E00010 1
  md.b 0xB0E00010 1
  md.b 0xB0E00010 1
  md.b 0xB0E00010 1
  md.b 0xB0E00010 1
  
  案例：利用mw,md实现开关灯和蜂鸣器

	mw.b E0200061 0x10
	mw.b E0200068 0x00
	mw.b E0200064 0x08

 3.2.uboot命令的实现过程
     1. 明确uboot命令的源码在uboot的common存在
        一般命名：cmd_xxx.c
     2. 注意：如果将来自己添加一个新的命令实现源码在common
        记得要修改common目录下的Makeifle文件添加对新文件的编译支持
     3. uboot命令实现的基本语法：
   第一步：
   vim cmd_nand.c

   U_BOOT_CMD(
	nand,	5,	1,	do_nand,
	"nand    - legacy NAND sub-system\n",
	"info  - show available NAND devices\n"
	"nand device [dev] - show or set current device\n"
	"nand read[.jffs2[s]]  addr off size\n"
	"nand write[.jffs2] addr off size - read/write `size' bytes starting\n"
	"    at offset `off' to/from memory address `addr'\n"
	"nand erase [clean] [off size] - erase `size' bytes from\n"
	"    offset `off' (entire device if not specified)\n"
	"nand bad - show bad blocks\n"
	"nand read.oob addr off size - read out-of-band data\n"
	"nand write.oob addr off size - read out-of-band data\n"
  );
  说明：
  宏U_BOOT_CMD用来定义一个命令对象
  第一个参数：表示命令的名称
  第二个参数：表明命令参数的最大个数
  第三个参数：表示命令是否重复,1:按回车命令重复执行
                               0：按回车命令不会重复执行
  第四个参数：表示命令对应的执行函数
  第五个参数：命令的简要说明
  第六个参数：命令的详细说明,一行不够写,记得续行                             
    
  第二步：编写对应的命令执行函数
  返回值为int
  cmdtp,flags:两个形参无需关注！
  argc:命令参数的个数
  argv:命令参数的信息
  int do_nand(cmd_tbl_t * cmdtp, int flag, 
  		int argc, char *argv[])
  {
  	//函数根据传递的参数执行不同的业务
        ...
  	return 0; //执行成功
  	或者
  	return 非0;//执行失败
  }
  
  第三步：修改Makefile添加新文件的支持

案例：给uboot添加开关灯命令
实施步骤：
1. 从ftp://porting下载led开关命令的源码
   led_logo.rar/u-boot-led目录：
                cmd_led.c //命令实现的代码,调用
                led.h //开关灯函数的声明
                led.c //开关灯函数的定义  

2. 潜心研究以上源码
3. 添加命令的编译
   cd /opt/uboot
   cp cmd_led.c /opt/uboot/common
   cp led.h /opt/uboot/common
   cp led.c /opt/uboot/common
  
4. 修改Makefile
   vim /opt/uboot/common/Makefile 添加：
   COBJS-y += cmd_led.o
   COBJS-y += led.o
  
5. 编译
   cd /opt/uboot
   make
   cp u-boot.bin /tftpboot
  
6. 更新uboot
   执行开关灯命令：
   led 1 on
   led 1 off
   led 2 on
   led 2 off
     
3. logo显示
  1.用途
    提高用户的体验,善意"欺骗"用户
  2.原则
    只要有LCD显示屏,必须添加此功能
    显示时间越早越好,所以在uboot中实现
    logo本质上就是一张图片,但是图片要做小
  3.LCD显示屏显示logo的工作原理
  
案例：在TPAD的uboot中添加logo显示
      具体操作参见LOGO显示.doc

案例：在TPAD的LCD屏幕的正中央显示一个矩形块

案例：在TPAD的LCD屏幕上画圆

***********************************************************
4. 问：zImage从何而来？
   答：通过编译源码获取
   嵌入式linux系统软件之linux内核
  4.1.明确嵌入式linux系统软件组成部分
      bootloader:u-boot属于其中的一种
      linux操作系统内核
      rootfs根文件系统
  4.2.明确嵌入式linux系统启动的顺序
      硬件上电->uboot->根据bootcmd加载内核到内存,启动内核
      ->内核启动->根据uboot传递的bootargs,挂接rootfs
      ->rootfs挂接成功->启动linuxrc->启动第一号进程/sbin/init
      ->创建子进程,利用exec启动shell->用户输入命令交互
  4.3.linux内核特点
      著名的开源软件
      www.kernel.org
      支持多种处理器架构：X86,ARM,MIPS,POWERPC,FPGA,DSP等
      支持多种多样的硬件开发板
      支持TCP/IP网络协议栈
      支持多种多样的文件系统,NTFS,FAT32,EXT4,CRMAFS,YAFFS2,UBIFS等
      支持多种多样的硬件设备驱动   
      视频<<the code linux>> 
  4.4.linux内核功能
      7大子系统
      linux内核就像一个"管家"
      linux内核就像一个"服务器",应用程序就是客户端
  4.5.获取linux内核源码
      1. 切记：linux内核源码的获取一定从芯片厂家或者开发板的
            厂家获取源码,很多芯片厂家将源码放在www.github.com
            进行托管
         TPAD开发板,三星提供的linux内核源代码ftp://porting/kernel.tar.bz2
      
  4.6.对官方源码进行操作
      1. 切记保证交叉编译器的环境变量要设置好
         交叉编译器的版本要合适
      2. 在windows下解压缩一份,利用sourceinsight创建
         源码工程,便于将来阅读linux内核源码
      3. 在linux系统下解压缩一份,要开始编译
         cp kernel.tar.bz2 /opt/
         cd /opt
         tar -jxvf kernel.tar.bz2
         cd /opt/kernel //进入linux内核源码根目录
         make distclean //获取最干净的内核源码,只做一次
         make ABC_defconfig //配置内核源码,将内核源码配制成
                            能够运行在某个开发板上
         注意：ABC就是开发板的名称,如果是自己的开发板
               ABC采用参考板的名称
         CW210开发板配置命令：
         make cw210_defconfig  //linux内核源码将来就可以
                               运行在ARM架构,S5PV210处理器,CW210开发板上
         make zImage -j4//将内核源码编译成zImage
         成果：
         ls arch/arm/boot/zImage
         友情提示：先尝试在开发板上运行编译的zImage
         cp arch/arm/boot/zImage /tftpboot
         开发板测试,进入uboot命令行执行：
         tftp 50008000 zImage
         bootm 50008000




