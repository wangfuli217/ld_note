回顾：
场景：给一块开发板,如何将linux系统运行起来
面试题：谈谈对uboot的理解
实施步骤：
1. 配置上位机的开发环境
  装系统：linux
  装软件: vim tftp nfs ctags cscope minicom kermit
  获取交叉编译器:芯片厂家,版本要合适
  配置交叉编译器:PATH
  
2. 部署(烧写,下载)嵌入式linux到下位机
   掌控下位机开发板的基本硬件信息
  	三大件：CPU,内存,闪存
  	外设：务必弄清楚外设芯片跟CPU之间的通信方式
  	明确：下位机必备UART和网口(建议)或者USB口
  	注意一个人：硬件工程师
  
  明确嵌入式linux系统软件组成部分：
  bootloader：
  	1.类似BIOS
  	2.硬件初始化,将硬件工作状态准备就绪
  	3.加载linux操作系统内核到内存,并且启动内核
  	  通过环境变量bootcmd
  	4.给内核传递启动参数,告诉内核rootfs根文件系统
  	  在哪里(Nand某个分区上或者上位机的某个目录中/opt/rootfs)
  	  通过环境变量bootargs
  	5.uboot属于其中一种
  	  
  linux内核：
  	1.linux操作系统内核
  	2. 包含7大功能(7大子系统)
  	  内存管理
  	  系统调用
  	  进程管理
  	  网络协议栈
  	  设备驱动
  	  文件系统
  	  平台代码
  	3.内核最终要挂接rootfs根文件系统
  	  一旦挂接成功,将来把操作权交给用户(shell)
  	     
  rootfs根文件系统:
        1.仅仅是个代名词
        2.本质就是"/"
        3.包含了一堆的目录,一堆的目录中有一堆的各种
          命令,库,配置文件等
          bin:sbin:usr/bin:usr/sbin->各种命令
          lib->库
          etc->tftp,nfs等配置
        4.内核挂接完rootfs以后,要启动第一号用户进程sbin/init
  
  嵌入式linux系统启动流程：
  上电->bootloader(内存的某个地方运行)->根据bootcmd加载内核
  到内存,启动内核->内核启动->根据bootargs到某个地方去挂接
  rootfs->挂接成功->启动linuxrc->启动/sbin/init(第一号进程)
  ->创建子进程->调用exec函数族某个函数->调用/bin/sh->
  用户就可以输入命令   
  
  画出系统启动示意图！
  
  两个相当关键重要的启动参数(环境变量)：
  bootcmd:
  bootargs:
  常见实例：
  setenv bootcmd nand read 内存地址 闪存起始地址  大小 \; bootm 内核起始地址
  或者
  setenv bootcmd tftp 内存起始地址 linux内核镜像名 \; bootm 内存起始地址
  
  研发阶段用第二个,产品发布用第一个 
  
  setenv bootargs root=/dev/闪存分区名 init=/linuxrc console=ttySAC0,115200
  或者：
  setenv bootargs root=/dev/nfs nfsroot=上位机IP:rootfs路径 ip=上位机IP:下位机IP:网关：掩码：:eth0:on ...
  研发阶段用第二个,产品发布用第一个
  
  嵌入式linux系统烧写：
  1.烧写之前一定要记得进行分区规划！
  2.tftp+nand命令

*********************************************************************************
3. 问：u-boot.bin从何而来？
   答：从uboot而来,肯定有对应的源码呀  
  3.1 uboot特点
  1. uboot是一款相当有名的开源软件,由德国denx开源小组负责
     uboot的官方网站：ftp://denx.de
     千万别从这个网站下载源码,然后编译烧写到自己的开发板上，
     几乎100%不好使！
  2. uboot支持多种处理器架构
     X86,ARM,MIPS,Powerpc,DSP,FPGA
  3. uboot支持多种多样的硬件开发板
     提示：即使CPU一样,有可能外设不一样,u-boot.bin势必也不一样
     全世界没有一个通用的u-boot.bin
  4. uboot可以引导多种操作系统
     linux,qnx,vxworks等
     主流的嵌入式操作系统：
     linux：
     vxworks:硬实时
     wince
 
  3.2 获取uboot源码
  1. 切记一定要从芯片厂家或者开发板的厂家获取源码
  2. 切记芯片厂家的源码仅仅支持芯片厂家提供的参考板
     所以将来自己的开发板如果跟参考板的硬件有不一致的
     地方,需要对芯片厂家的源码进行修改 
     案例：TPAD的官方uboot源码：u-boot_CW210_1.3.4.tar.gz(三星)
           三星S5PV210处理器官方参考板名：smdkv210
           TPAD由融汇光泽基于参考板设计,名：cw210
     注意：很多芯片厂家将自家的芯片源码都放置在开源软件托管的地址：
           www.github.com
          
  3. 源码操作
    3.0.windows安装sourceinsight,安装包ftp的SourceInsight35.zip
    3.1.在windows解压缩uboot源码一份,利用sourceinsight创建源码工程
        便于将来阅读源码,提示创建过程：
        Project->New Project->指定工程名称和保存位置->OK->OK->
        将"Show only known ..."前面的勾去掉->点击Add All,
        添加uboot所有的源码->在新的对话框中将两个勾都加上
        ->OK(大概1391个源文件)->点击Close关闭
        
        Project->Sync....->OK,将源码进行同步,将来便于跳转
        
        通过点击右键进行跳转
        通过点击<-实现返回
        通过点击"R"实现搜索
    3.2.在linux系统解压缩一份,为了能够编译
        cp  u-boot_CW210_1.3.4.tar.gz /opt/
        cd /opt/
        tar -xvf u-boot_CW210_1.3.4.tar.gz
        mv u-boot_CW210_1.3.4 uboot
        结果：uboot就是源码根目录
    
    3.3.友情提示,编译源码之前,记得将交叉编译器配置好
        注意交叉编译器的版本要合适
    
    3.4.开启源码的配置和编译
        注意：uboot源码支持的处理器架构非常多
              并且uboot支持的硬件开发板也非常多
        cd /opt/uboot 
        make distclean  //彻底删除之前编译生成的目标文件
                          获取最干净的源码,只做一次！              
        make ABC_config  //对源码进行配置,将源码配置成能够
                          运行在某个处理器架构并且能够运行
                          在某个开发板上
        说明：
        ABC:就是当前开发板的名称
            如果是自己设计的开发板,只需要使用官方的参考板名即可
        对于TPAD,配置命令：
        make CW210_config 
        结论：当前uboot源码就可以支持ARM架构,并且支持S5PV210处理器,并且支持CW210开发板
        
        配置完毕,可以踏踏实实进行编译：
        time make
        或者
        time make -j4  //用4核编译
        结果：在uboot源码根目录生成最终二进制文件u-boot.bin
        cd /opt/uboot
        ls 
          u-boot.bin
          
   3.5.以上操作步骤仅仅是热身,因为上面编译的u-boot.bin目前
       只能运行在官方的参考板上,但不一定能够运行在你自己设计的
       开发板上,除非硬件一模一样,接下来就要对uboot源码进行
       各种修改。
       实施步骤：
       1. 一定要将自己设计的硬件开发板和参考板之间的硬件差异找出来
          友情提示：硬件差异需要咨询硬件工程师
          案例：处理器为I.MX25,参考板A,自己的板子B
          参考板A：
         	CPU:I.MX25
         	DDR:512MB
         	Nand:1GB
         	晶振：24MHz
         	网卡：CPU自带的MAC
         	UART:2
         	...
          自己的板子B：
         	CPU:I.MX25
         	DDR:1GB
         	Nor:1GB
         	晶振：24MHz
                网卡：CPU自带的MAC
            	UART:0
            	...
          总结：接下来只要对uboot源码修改DDR,Nor,UART相关代码即可
        
       2. 需要有针对性的修改uboot源码
         2.1.明确uboot代码就是一个ARM裸板程序,类似裸板的shell
             仅仅是比咱们的shell代码复杂而已
         2.2.修改之前,掌握uboot代码的执行顺序
             首先查看make编译的打印信息,得到：
             arm-linux-ld -Bstatic -T /opt/uboot/board/CONCENWIT/CW210/u-boot.lds  -Ttext 0x23e00000 $UNDEF_SYM cpu/s5pv210/start.o \
			--start-group lib_generic/libgeneric.a cpu/s5pv210/libs5pv210.a 
             结论：
             1.首先获取到了连接脚本：/opt/uboot/board/CONCENWIT/CW210/u-boot.lds
             2.并且获取到了将来uboot在内存的运行起始地址 0x23e00000
             3.最后通过连接脚本u-boot.lds能够获取到u-boot.bin运行的第一个文件：
               ENTRY(_start) //程序的入口为：_start
               cpu/s5pv210/start.o->start.S //程序运行的第一个文件
             
             恭喜：重要阶段性成果终于诞生start.S
         
         2.3.利用sourceinsight慢慢阅读start.S
             b  reset 这个阶段用汇编实现
             reset:
             	1.设置CPU的工作模式为SVC
             	2.初始化CPU
             	  初始化cache
             	  关闭看门狗
             	  关闭中断
             	  初始化内存
             	  初始化系统时钟(24MHz(倍频)->1GHz)
             	  初始化UART
             	  初始化Nand
             	  
             	3.判断开发板的启动方式
             	4.将Nand上的uboot拷贝到DDR上0x23e00000运行
             	5.从内存中继续运行uboot
             	
            ldr p, start_armboot 支持进入C实现的启动流程：
            start_armboot {
            	...
            	...
            	board_init, //初始化板卡上的外设
            	说明：如果将来添加自己的硬件外设的初始化代码
            	建议把初始化代码的函数的定义放在board_init所在的
            	文件
            	...
            	总结：做了大量的各种硬件初始化
            
                 for (;;) {
			main_loop () {
			        //如果有环境变量bootcmd
			        //并且如果用户没有按空格键,
			        //最终运行bootcmd对应的命令
				s = getenv ("bootcmd");
				//运行命令
				run_command (s, 0); //run_command("nand erase");
				
				//如果bootcmd没有运行
				//彻底进入shell终端
				for (;;) {
				 //获取用户输入的命令
				 readline (CFG_PROMPT);
				 //执行对应的命令
				 run_command (lastcommand, flag);
				}
			}
		}
            }        
            
            总结：代码流程：
            1.切记uboot运行的第一个文件start.S
            2.uboot运行的第一个阶段:b reset
            3.uboot运行的第二个阶段：ldr pc, start_armboot
       
      2.4 切记：实际如果硬件存在差异,修改很少去阅读代码的启动流程
                 去修改代码,一般来说只需要看一个头文件即可搞定！
           此头文件又称硬件平台头文件,此文件定义了大量的跟当前开发板硬件相关的宏
           头文件路径：include/configs/开发板名.h  
           总结：一旦找到硬件差异,玩命多多多看对应的硬件平台
                 头文件
                 
       2.6 uboot启动仅仅是系统启动的第一个阶段,一旦uboot将内核
       引导起来,uboot的生命周期就到此为止,所以,uboot做硬件初始化
       但是不要做大量的无关的硬件初始化,只要做了,就势必加长系统的启动时间
       所以,uboot尽量所做事情要简单为主！
       
       uboot初始化的必要硬件：
       1. CPU
       2. 内存
       3. 闪存
       4. UART
       5. 网卡或USB(也可以不用初始化)
       
       uboot初始化的可选硬件：
       原则：根据用户需求来定,是否做某个外设的初始化
       案例：手机显示屏上显示logo(提高用户的体验度)
             此时此刻,必须在uboot添加LCD显示屏硬件初始化代码
             
             无线路由器需要logo显示吗？对于这个产品
             就无需在uboot中添加LCD显示屏的初始化
             
案例：将uboot命令行提示修改为自己喜欢的提示符                    
实施步骤：
1.cd /opt/uboot
2.vim include/configs/CW210.h
  修改,保存
3.make //无需再次make CW210_config
4.cp u-boot.bin /tftpboot
5.开发板烧写：
  tftp 50008000 u-boot.bin
  nand erase 0 200000
  nand write 50008000 0 200000
  reset //复位命令
   
