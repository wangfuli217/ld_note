嵌入式linux系统移植相关内容：
课程安排：
1.嵌入式linux系统部署和开发环境的搭建
2.uboot移植
3.kernel移植
4.rootfs移植
------------------------------------------------------------
一. 嵌入式linux系统部署和开发环境的搭建
1. 给一块开发板，如何将开发板的系统运行起来
实施步骤：
	概念：
		上位机：也就是PC机
		下位机：也就是开发板

1.1 搭建好上位机的开发环境
	1. 安装linux系统
	发行版本：Ubuntu，fedora

	2. 安装必要的开发工具
	sudo apt-get install vim
	安装vim的配置文件和插件
	百度搜vim插件
	/home/tarena/.vimrc  vim的配置文件
	/home/tarena/.vim    vim的插件
	
	sudo apt-get install minicom kermit //串口工具
	windows下的串口工具：SecureCRT
	sudo apt-get install tftpd-hpa      //tftp网络服务
	sudo apt-get install nfs-kernel-server //nfs网络服务
	sudo apt-get install ctags cscope   //linux阅读源码工具

1.2 部署交叉编译器的环境变量（arm-linux-gcc）
“交叉编译”：上位机编译，下位机运行，编译器针对于下位机
	1. 一定要先获取到交叉编译器
	四种方法：
		1.从芯片厂家获取
			如果芯片厂家提供编译器，一定要使用这个！
		2.从ARM-linux交叉编译器的官方网站下载
		3.利用交叉编译器制作的自动化脚本crosstool-ng自行制作交叉编译
		4.自己一点点制作，下载制作交叉编译器的安装包，自己编译
	
	2. 切记交叉编译器的版本一定要和当前软件的版本配对
	例如：交叉编译QT-4.8.4就不能使用arm-linux-gcc-4.4.1版本编译器，这个编译器版本过低！可以使用arm-linux-gcc-4.4.6版本即可编译QT-4.8.4

1.3 最后在linux系统中的PATH环境变量中添加arm-linux-gcc交叉编译器
案例：在linux系统添加arm-linux-gcc-4.4.6的环境变量
实施步骤
	1. 4.4.6交叉编译器的路径：
	/home/tarena/workdir/toolchains/opt/S5PV210-crosstools/4.4.6/

	2. sudo vim /etc/envirconment    //添加环境变量

	在PATH中添加	/home/tarena/workdir/toolchains/opt/S5PV210crosstools/4.4.6/bin：
	保存退出

	3. 重启虚拟机
	4. 验证：arm-linux-gcc -v  //查看是否为4.4.6
	5. 交叉编译器不是通用的,针对ARM核
	6. 添加环境变量 在/etc/envirconment
	7. tar -jcvf xxx.tar.bz2 xxx  压缩
  	   tar -jxvf xxx.tar.bz2      解压


1.4 掌控开发板的基本硬件信息

	1.掌控开发板的核心硬件组件，三大件
	cpu：什么架构,什么厂家，什么型号
	内存：什么厂家，什么型号，容量，基地址
	闪存：什么厂家，什么型号，容量。nand还是nor
	
	2.掌控开发板的外设接口的通信类型
	明确：CPU跟外设通信的接口类型：
		GPIO：LED
		UART：BT，GPS，GPRS
		总线（地址线，数据线）：Nor，Nand flash
		I2C：触摸屏，重力传感器
		SPI：Nor，SD卡
		1-Wire：ds18b20温度传感器
		总结：一定要弄清楚外设跟CPU之间的通信接口
	 
	切记：开发板必备的通信接口：
		UART：将来用于调试软件，也可以用来数据通信，文件下载，但是速度太慢。
		网口（建议选网口）或USB口：将来用于数据的通信，文件传输，网口下载速度，传输速度快！

		如果采用UART传输100MB，波特率115200，需2个小时 

1.5 了解开发板将来运行的软件信息
	1. 搞清楚软件是否包含操作系统
	   如果是裸板程序。。。。
	2. 如果开发板上将来运行操作系统，例如linux系统
	   只要获取到开发板上运行的软件代码即可

1.6 如果运行linux系统，明确嵌入式linux系统软件组成部分

	1. 嵌入式linux系统软件由三大件组成
		bootloader（uboot属于bootloader的一种）
		linux kernel
		rootfs根文件系统
	
	2. 系统软件之bootloader的功能，
	  特点：
		1.系统上电运行的第一个软件
		2.bootloader是裸板代码，跟ARM裸板的shell一样
	    3.主要做硬件相关的初始化工作，类似ARM裸板shell的main函数的各种xx_init();
		4.硬件初始化完毕，将linux内核加载到内存，并且从内存中引导linux内核，至此linux内核运行
		5.在linux内核正式运行之前，还要给linux内核传递启动参数，告诉内核，rootfs根文件系统在哪里。将来内核去挂接rootfs。
		6.bootloader类似PC机的BIOS

	3. 系统软件之linux kernel 的功能，特点

		1.linux kernel包含7大功能，7大子系统
		进程管理：负责进程的创建，调度，抢占，销毁等
		内存管理：负责内存的分配，内存的映射，内存的销毁等
		网络协议栈：TCP/IP网络协议栈
		设备驱动：负责硬件的管理和操作
		文件系统：支持多种多样的文件系统，例如：ntfs，fat32，ext4，yaffs2，cramfs等等
		系统调用：open，close，read，write，mmap，brk，sbrk，fork，exit等
		平台代码：linux能够运行在多种多样的硬件平台上（x86，arm，mips，powerpc） 说明linux内核中有相关的支持代码，这些代码为通常平台代码

		2.linux内核由bootloader启动，并且最终要挂接rootfs根文件系统，将最终的控制权交给rootfs根文件系统
		
	4. 系统软件之rootfs根文件系统
		
		1.rootfs=root file system  根文件系统
		2.rootfs根文件系统仅仅是一个代名词，
		  可以把它认为就是“/”
		   总结：根文件系统就是包含了一大堆的用户命令（ls），动态库（lib.so），和各种相关的配置文件(/etc/init.d/tftpd-hpa)
		3.内核启动到最后，一定要挂接rootfs根文件系统，然后启动第一号用户进程(/sbin/init程序)
		init进程启动一个shell，用户即可进行命令的操作


1.7 明确三部分软件将来部署(烧写)信息
	1. 开发板软件最终要烧写到内存上（Nor或Nand）
	2. 明确三部分软件将来在闪存上的存储位置
	0————————————2M———————7M——————————17M————————————剩余
	  bootloader                linux内核         roofts（/）
	    定死的
	注意：分区大小可以自己定

1.8 明确三部分软件启动的过程
	挂接：又称找

	1.硬件上电，CPU自动运行bootloader
	2.bootloader初始化硬件
	  然后将linux kernel 从Nand上读到内存上（将内核加载到内存中）
	  最后从内存中启动linux kernel
	  最后最后给linux kernel传递启动参数，告诉linux kernel，rootfs所在位置
	3.linux kernel启动，最后到Nand上某个位置去挂接rootfs根文件系统，
	  一旦挂接成功启动rootfs根文件系统的第一个进程/sbin/init
	4./sbin/init进程创建一个子进程，子进程调用sh程序（shell）
	  接下来用户即可输入linux命令
	  至此整个嵌入式linux系统启动完毕！
	5.画系统启动图

2.1 实战：烧写安卓系统
实施步骤：
	1.从ftp下载
	2.android_system
		u-boot_menu.bin：bootloader，带菜单
		u-boot_nomenu.bin：bootloader，不带菜单
		烧写不带菜单
		zImage.bin：linux kernel
		rootfs_android.bin：rootfs根文件系统
		logo.bin：系统启动logo
	3.cp Android_system/ * /tftpboot
	4.切记：烧写软件之前，一定要对Nand进行分区规划

	  第一分区		 第二分区    第三分区    第四分区
	0----------1M———-----——2M—————---5M—————-----10M————------剩余
	   uboot       隐藏        logo       zImage      rootfs
	分区名称：
	 mtdblock0              mtdblock1  mtdblock2    mtdblock3

	5.利用tftp烧写
	  1. 重启开发板，进入uboot命令行模式
	  2. 已经烧写，想烧写
	  	tftp 50008000 u-boot_nomenu.bin
		nand erase 0 100000
		nand write 50008000 0 100000
	  3. 烧写logo
		tftp 50008000 logo.bin
		nand erase 200000 300000
		nand write 50008000 200000 300000	//文件所在的内存地址 准备写入的起始地址 写入的地址大小
	  4. 烧写linux kernel
		tftp 50008000 zImage
		nand erase 500000 500000  
		nand write 50008000 500000 500000
	  5. 烧写rootfs
		tftp 50008000 rootfs_android.bin
		nand erase a00000
		nand write.yaffs 50008000 a00000 $filesize
		或者
		nand write.yaffs 50008000 a00000 $(filesize)
	  6. 在uboot中设置关键的启动参数
        	setenv bootcmd nand read 50008000 500000 500000 \; bootm 50008000                 内存地址 nand起始地址 大小
        	setenv bootargs root=/dev/mtdblock3 init=/init console=ttySAC0,115200

        说明：
        bootcmd环境变量：uboot根据bootcmd能够将内核从Nand加载到
                         内存,并且从内存启动内核
        bootargs环境变量：内核启动以后,内核根据uboot传递过来的
        		  bootargs参数信息,内核到Nand第四分区
        		  挂接rootfs根文件系统,一旦挂接成功
        		  执行第一个用户进程init(在根目录)
        root=/dev/mtdblock3：告诉内核rootfs根文件系统在Nand的第四分区
        init=/init:内核挂接rootfs以后,执行的第一个进程init
        console=ttySAC0,115200:内核启动和挂接rootfs以后,所有的打印信息
                               输出到ttySAC0(第一个串口)
        
        saveenv 保存设置好的环境变量
        重启开发板,静静等待安卓的启动 


2.2 实战：向下位机部署一个普通的linux系统
实施步骤：
	1.从ftp下载镜像文件
	normal_system
     		u-boot-menu.bin
     		u-boot-nomenu.bin
     		以上都是bootloader(uboot)
     	
     		zImage:linux内核
     		rootfs.cramfs：rootfs根文件系统
        cp normal_system/ * /tftpboot

	2.切记：烧写软件之前，一定要对Nand进行分区规划

	  第一分区    第二分区     第三分区      第四分区
	0—————————2M———————————7M———————————17M—————————剩余
	   uboot      zImage      rootfs        用户数据
	分区名称：
	 mtdblock0   mtdblock1   mtdblock2      mtdblock3

	3.烧写各个镜像
		tftp 50008000 zImage 
     		nand erase 200000 500000 
     		nand write 50008000 200000 500000
     
     		tftp 50008000 rootfs.cramfs
     		nand erase 700000 a00000
     		nand write 50008000 700000 a00000

	4.设置系统启动的环境变量
    		进入uboot的命令行模式：
     setenv bootcmd nand read 50008000 200000 500000 \; bootm 50008000
     setenv bootargs root=/dev/mtdblock2 init=/linuxrc console=ttySAC0,115200
     saveenv
     说明：
     root=/dev/mtdblock2:告诉内核rootfs在Nand的第三分区
     init=/linuxrc:内核一但挂接rootfs成功,执行的第一个
                   用户进程linuxrc(在根目录下)
                   注意：linuxrc最终调用/sbin/init  
     重启开发板,不要进入uboot命令行,等待
     最终进入linux的shell中,输入：
     ls
     cd 
     mkdir helloworld //是否能创建呢？
     cd /
     ls 
       helloworld
     ./helloworld //执行一个UC测试程序


问：如果helloworld功能需要改变，此时面临需要更新rootfs中的helloworld可执行程序事情，但是更新的过程有些问题
	更新一次过于繁琐 每次都要对nand擦除写入
答：利用NFS网络服务（只是调试 最终还是要烧写到Nand里）


3.1 掌握NFS网络服务情形1：
	 此情形是uboot,内核,rootfs已经烧写到Nand,此时只需要执行一下操作步骤,即可利用NFS在开发板上测试和运行自己的程序

	实施步骤：
	0. 首先在linux虚拟机中启动NFS网络服务
	自己的电脑，执行sudo apt-get install nfs-kernel-server

	1. 在linux虚拟机中添加NFS网络服务的共享目录
	cp /home/tarena/workdir/rootfs/rootfs /opt -frd

	2. 修改NFS网络服务的配置文件，添加共享目录
	sudo vim /etc/exports 在文件最后添加
	/opt/rootfs *(rw,sync,no_root_squash)
	注意：可以添加多个共享目录
	保存退出
	
	3. 重启NFS网络服务
      	sudo /etc/init.d/nfs-kernel-server restart
      	至此开发板就可以进行挂接！
	
	4. 前提是你现在已经将普通的linux系统烧写完毕，并且启动完毕

	5. 在开发板上执行以下命令
      	ifconfig eth0 192.168.1.110 //给开发板的网卡配置一个ip地址
      	ping 192.168.1.8 //开发板ping虚拟机
      	mount -t nfs -o nolock 192.168.1.8:/opt/rootfs /mnt
      	说明：
      	将linux虚拟机的NFS共享目录/opt/rootfs挂接到开发板
      	rootfs的mnt目录上,将来在开发板上访问这个mnt目录就是
      	在访问linux虚拟机的/opt/rootfs
   
    	6. 在linux虚拟机中编辑和交叉编译自己的UC程序
      	cd /opt/rootfs
      	vim helloworld.c //添加自己的UC代码
      	保存退出
      	arm-linux-gcc -o helloworld hellworld.c 
      	helloworld不能在虚拟机上运行,需要在开发板上运行
      
    	7. 在开发板上运行测试,开发板上执行
     	cd /mnt //类似进入linux虚拟机的/opt/rootfs
      	ls
        	helloworld helloworld.c
      	./helloworld

3.2 掌握NFS网络服务情形2：
     问：如果开发板没有烧写linux内核zImage,也没有烧写
         rootfs根文件系统,能否调试应用程序呢？
     答：实施步骤：
     1. 启动开发板,进入uboot的命令行模式,输入：
     setenv bootcmd tftp 50008000 zImage \; bootm 50008000
     说明：将来上电,uboot根据这个bootcmd自动将linux虚拟机上的
           zImage下载到开发板上的内存,并且启动内核
           这样就无需对Nand进行读操作(nand read)
     setenv bootargs root=/dev/nfs nfsroot=192.168.1.8:/nfs/rootfs ip=192.168.1.110:192.168.1.8:192.168.1.1:255.255.255.0::eth0:on init=/linuxrc console=ttySAC0,115200
     说明：
     nfsroot=192.168.1.8:/nfs/rootfs:告诉内核,挂载的rootfs在linux虚拟机的/nfs/rootfs
                   而不再是Nand的第三分区或者第四分区
     ip=开发板ip:linux虚拟机ip:网关:子网掩码::开发板网卡名:打开
     
     saveenv  
     重启开发板
     注意注意：开发板上执行：
     cd / //类似linux虚拟机执行cd /opt/rootfs
            也就是开发板的"/"代表的就是/opt/rootfs
     ls
        helloworld helloworld.c
     ./helloworld
     
     总结：此过程无需对Nand进行烧写内核和rootfs,也照样能够
           调试应用程序          
           
           将来只要在linux虚拟机的/nfs/rootfs编辑和编译自己的
           UC源代码,最后在开发板上运行即可！
           如果helloworld调试测试完成,最终还是要烧写到Nand


/* tftp */
			  通过网络方式把PC上的文件传到开发板内存
			  tftp方式传输，需要tftp服务器，需要一个tftp客户端
			  在我们的开发方式中谁作为服务器？谁作为客户端？
				电脑（开发主机）作为服务器，需要tftp服务器软件
				开发板端需要一个tftp客户端，u-boot的tftp命令
				
				u-boot 的tftp命令如何使用？
				tftp 下载地址	下载的文件名
				
					 下载地址是开发板的内存地址
						把下载的文件存到开发板什么位置
					 下载的文件名
						把服务器上的文件下载到开发板
						这个文件应该在tftp服务器端存在
						
				tftp  0x20008000  u-boot.bin
				
					 把tftp服务器上的u-boot.bin下载到
					 开发板内存中，内存地址是0x20008000
					 
			   为了使用tftp命令下载需要
				  1、pc端需要安装tftp服务器，配置服务器
					 tftpd-hpa
					 sudo apt-get install tftpd-hpa
					 
					 配置 /etc/default/tftpd-hpa
					 
				  2、启用tftp服务器
		   
					 sudo /etc/init.d/tftpd-hpa  restart 
					 
				  3、使用u-boot的tftp命令下载服务器上的文件
					 到开发板内存。
					 需要保证网络是连同。
					 需要对网络做一个配置
					 如果ping不通：
					   1、网线
					   2、pc端网口
					   3、开发板端的网口
					   4、可以尝试关闭pc端防火墙
				 4、把u-boot.bin放到ubuntu的 tftp 服务器目录中
					 /tftpboot
					 
					 tftp 20008000 u-boot.bin
		
		1.ubuntn ip  与 serverip 一致
		2.两个桥接
			1.VM->Settings->Network Adapter->Network connection->Bridged
			2.Edit->Virtual Network Editor ->Bridged to->选择与开发板连接的网卡
		
			用dnw 输入 ping 192.168.1.8（serverip） 检查是否连通
		
		3.配置服务器 tftpd-hpa
		
			  1 # /etc/default/tftpd-hpa
			  2 
			  3 TFTP_USERNAME="tftp"
			  4 TFTP_DIRECTORY="/tftpboot"		 //配置文件目录 下载文件放在此目录
			  5 TFTP_ADDRESS="0.0.0.0:69"
			  6 TFTP_OPTIONS="--secure"
		
			
		4.一个启用tftp服务器指令
		
			sudo /etc/init.d/tftpd-hpa	restart

