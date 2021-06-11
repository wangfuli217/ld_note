基于4.9.0-rc8，ARM-64，根据金步国《4.4内核配置选项简介》整理, @ 表示4.9版本内核无此选项

##

+-------------------------- Linux/x86 4.9.0-rc8 Kernel Configuration --------------------------+   
|  Arrow keys navigate the menu.  <Enter> selects submenus ---> (or empty submenus ----).      |  
|  Highlighted letters are hotkeys.  Pressing <Y> includes, <N> excludes, <M> modularizes      |  
|  features.  Press <Esc><Esc> to exit, <?> for Help, </> for Search.  Legend: [*] built-in    |  
|  [ ] excluded  <M> module  < > module capable  


[*] 64-bit kernel                                       编译64位内核                           
    General setup  --->                                 常规设置                              
[*] Enable loadable module support  --->                可加载模块支持                        
[*] Enable the block layer  --->                        块设备支持                        
    Processor type and features  --->                   中央处理器(CPU)类型及特性                         
    Power management and ACPI options  --->             电源管理和ACPI选项                       
    Bus options (PCI etc.)  --->                        总线选项                       
    Executable file formats / Emulations  --->          可执行文件格式/仿真                        
[*] Networking support  --->                            网络支持                       
    Device Drivers  --->                                设备驱动程序                        
    Firmware Drivers  --->                              固件(Firmware)驱动                        
    File systems  --->                                  文件系统                        
    Kernel hacking  --->                                内核hack选项                        
    Security options  --->                              安全选项                        
-*- Cryptographic API  --->                             内核加密API支持(这里的加密算法被广泛的应用于驱动程序通信协议等机制中.
                                                        子选项可以全不选,内核中若有其他部分依赖它,会自动选上.使用内核树外的
                                                        模块时可能需要手动选择.)                        
-*- Virtualization  --->                                虚拟化支持(仅在将此内核用作宿主机(host)的情况下才需要开启这里的子项)                
    Library routines  --->                               库子程序(子选项可以全不选,内核中若有其他部分依赖它,会自动选上.
                                                        使用内核树外的模块时可能需要手动选择.) 

()  Cross-compiler tool prefix                                                           CONFIG_CROSS_COMPILE                     交叉编译工具前缀(比如"arm-linux-"相当于使用"make CROSS_COMPILE=arm-linux-"进行编译)，配置后默认自动进行交叉编译                                         
[ ] Compile also drivers which will not load                                             CONFIG_COMPILE_TEST                      显示专属于其他平台(非x86平台)的驱动选项(需要交叉编译),仅供驱动开发者使用,普通的发行版制作者应该选"N".
()  Local version - append to kernel release                                             CONFIG_LOCALVERSION                      在内核版本后面加上自定义的版本字符串(最大64字符),可以用"uname -a"命令看到
[ ] Automatically append version information to the version string                       CONFIG_LOCALVERSION_AUTO                 自动在版本字符串(CONFIG_LOCALVERSION)后面添加版本信息(类似"-gxxxxxxxx"格式),需要有perl以及git仓库支持  
    Kernel compression mode (Gzip)  --->                                                 CONFIG_KERNEL_GZIP                         核镜像的压缩格式,可选Gzip/Bzip2/LZMA/XZ/LZO格式之一,推荐使用XZ格式.你的系统中需要有相应的压缩工具.
((none)) Default hostname                                                                CONFIG_DEFAULT_HOSTNAME                  设置默认主机名,默认值是"(none)".用户可以随后使用系统调用sethostname()来修改主机名.               
[*] Support for paging of anonymous memory (swap)                                        CONFIG_SWAP                              使用交换分区或者交换文件来做为虚拟内存   
[*] System V IPC                                                                         CONFIG_SYSVIPC                           System V 进程间通信(IPC)支持,用于进程间同步和交换数据,许多程序需要这个功能.选"Y",除非你确实知道自己在做什么
[*] POSIX Message Queues                                                                 CONFIG_POSIX_MQUEUE                      POSIX消息队列是POSIX IPC的一部分,如果你想编译和运行那些使用"mq_*"系统调用的程序(比如为Solaris开发的程序),
                                                                                                                                    或者需要使用Docker容器,就必须开启此选项.POSIX消息队列可以作为"mqueue"文件系统挂载以方便用户对队列进行操作.不确定的选"Y".                        
@ [*] Enable process_vm_readv/writev syscalls                                                 
[*] open by fhandle syscalls                                                             CONFIG_FHANDLE                           用户程序可以使用句柄(而非文件名)来追踪文件(使用open_by_handle_at(2)/name_to_handle_at(2)系统调用),即使某文件被重命名,
                                                                                                                                用户程序依然可定位那个文件.此特性有助于实现用户空间文件服务器(userspace file server).建议选"Y",因为systemd和udev依赖于它.
[*] uselib syscall                                                                       CONFIG_USELIB                            启用老旧的uselib()系统接口支持,仅在你需要使用基于libc5的古董级程序时才需要,不确定的选"N".
-*- Auditing support                                                                     CONFIG_AUDIT                             内核审计(跟踪每个进程的活动情况)支持,某些安全相关的内核子系统(例如SELinux)需要它.
                                                                                                                                    但是它会与systemd冲突,所以在使用systemd的系统上必须关闭.                                                   
    IRQ subsystem  --->                                                                                                             IRQ(中断请求)子系统
            [ ] Expose hardware/virtual IRQ mapping via debugfs                            CONFIG_IRQ_DOMAIN_DEBUG                     过debugfs中的irq_domain_mapping文件向用户显示硬件IRQ号/Linux IRQ号之间的对应关系.仅用于开发调试.
    Timers subsystem  --->                                                                                                         Linux内核时钟子系统
            Timer tick handling (Idle dynticks system (tickless idle))  --->                                                            核时钟滴答处理程序,更多信息可以参考内核源码树下的"Documentation/timers/NO_HZ.txt"文件
                    ( ) Periodic timer ticks (constant rate, no dynticks)                    CONFIG_HZ_PERIODIC                         论CPU是否需要,都强制按照固定频率不断触发时钟中断.这是最耗电的方式,不推荐使用
                    (X) Idle dynticks system (tickless idle)                                CONFIG_NO_HZ_IDLE                         PU在空闲状态时不产生不必要的时钟中断,以使处理器能够在较低能耗状态下运行以节约电力,适合于大多数场合 
                    ( ) Full dynticks system (tickless)                                    CONFIG_NO_HZ_FULL                         全无滴嗒:即使CPU在忙碌状态也尽可能关闭所有时钟中断,适用于CPU在同一时间仅运行一个任务,
                                                                                                                                    或者用户空间程序极少与内核交互的场合.即使开启此选项,也需要额外设置"nohz_full=?"内核命令行参数才能真正生效.
            [*] Old Idle dynticks config                                                   CONFIG_NO_HZ                            等价于CONFIG_NO_HZ_IDLE,临时用来兼容老版本内核选项,未来会被删除.                          
            [*] High Resolution Timer Support                                              CONFIG_HIGH_RES_TIMERS                     精度定时器(hrtimer)是从2.6.16开始引入,用于取代传统timer wheel(基于jiffies定时器)的时钟子系统.
                                                                                                                                    可以降低与内核其他模块的耦合性,还可以提供比1毫秒更高的精度(因为它可以读取HPET/TSC等新型硬件时钟源),
                                                                                                                                    可以更好的支持音视频等对时间精度要求较高的应用.建议选"Y".[提示]这里说的"定时器"是指"软件定时器",
                                                                                                                                    而不是主板或CPU上集成的硬件时钟发生器(ACPI PM Timer/HPET Timer/TSC Timer).
    CPU/Task time and stats accounting  --->                                                                                       CPU/进程的时间及状态统计   
            Cputime accounting (Simple tick based cputime accounting)  --->                                                     CPU时间统计方式 
                    (X) Simple tick based cputime accounting                                 CONFIG_TICK_CPU_ACCOUNTING                 单的基于滴答的统计,适用于大多数场合
                    ( ) Full dynticks CPU time accounting                                  CONFIG_VIRT_CPU_ACCOUNTING_GEN              利用上下文跟踪子系统,通过观察每一个内核与用户空间的边界进行统计.该选项对性能有显著的不良影响,
                                                                                                                                    目前仅用于完全无滴答子系统(CONFIG_NO_HZ_FULL)的调试
            [ ] Fine granularity task level IRQ time accounting                            CONFIG_IRQ_TIME_ACCOUNTING               通过读取TSC时间戳进行统计,这是统计进程IRQ时间的更细粒度的统计方式,
                                                                                                                                    但对性能有些不良影响(特别是在RDTSC指令速度较慢的CPU上).
            [*] BSD Process Accounting                                                     CONFIG_BSD_PROCESS_ACCT                  BSD进程记账支持.用户空间程序可以要求内核将进程的统计信息写入一个指定的文件,
                                                                                                                                    主要包括进程的创建时间/创建者/内存占用等信息.不确定的选"N".      
            [*]   BSD Process Accounting version 3 file format                             CONFIG_BSD_PROCESS_ACCT_V3               用新的v3版文件格式,可以包含每个进程的PID和其父进程的PID,但是不兼容老版本的文件格式.
                                                                                                                                    比如 GNU Accounting Utilities 这样的工具可以识别v3格式           
            -*- Export task/process statistics through netlink                             CONFIG_TASKSTATS                         通过netlink接口向用户空间导出进程的统计信息,与 BSD Process Accounting 的不同之处在于
                                                                                                                                    这些统计信息在整个进程生存期都是可用的.            
            -*-   Enable per-task delay accounting                                         CONFIG_TASK_DELAY_ACCT                   在统计信息中包含进程等候系统资源(cpu,IO同步,内存交换等)所花费的时间                 
            [*]   Enable extended accounting over taskstats                                CONFIG_TASK_XACCT                        在统计信息中包含进程的更多扩展信息.不确定的选"N".                    
            [*]   Enable per-task storage I/O accounting                                   CONFIG_TASK_IO_ACCOUNTING                在统计信息中包含进程在存储设备上的I/O字节数.
    RCU Subsystem  --->                                                                                                            RCU(Read-Copy Update)子系统.它允许程序查看到正在被修改/更新的文件.在读多写少的情况下,
                                                                                                                                    这是一个高性能的锁机制,对于被RCU保护的共享数据结构,读者不需要获得任何锁就可以访问它(速度非常快),
                                                                                                                                但写者在访问它时首先拷贝一个副本,然后对副本进行修改,最后使用一个回调机制在适当的时机
                                                                                                                                把指向原来数据的指针重新指向新的被修改的数据,速度非常慢.RCU只适用于读多写少的情况:
                                                                                                                                如网络路由表的查询更新,设备状态表的维护,数据结构的延迟释放以及多径I/O设备的维护等.
@            [*] Make expert-level adjustments to RCU configuration                             
            (64) Tree-based hierarchical RCU fanout value (NEW)                          CONFIG_RCU_FANOU                         这个选项控制着树形RCU层次结构的端点数(fanout),以允许RCU子系统在拥有海量CPU的系统上高效工作.
                                                                                                                                    这个值必须至少等于CONFIG_NR_CPUS的1/4次方(4次根号).生产系统上应该使用默认值(64).
                                                                                                                                仅在你想调试RCU子系统时才需要减小此值.                    
            (16) Tree-based hierarchical RCU leaf-level fanout value (NEW)              CONFIG_RCU_FANOUT_LEAF                   这个选项控制着树形RCU层次结构的叶子层的端点数(leaf-level fanout).
                                                                                                                                    对于期望拥有更高能耗比(更节能)的系统,请保持其默认值(16).
                                                                                                                                对于拥有成千上万个CPU的系统来说,应该考虑将其设为最大值     
            [ ] Accelerate last non-dyntick-idle CPU grace periods (NEW)              CONFIG_RCU_FAST_NO_HZ                     即使CPU还在忙碌,也允许进入dynticks-idle状态,并且阻止RCU每4个滴答就唤醒一次该CPU,
                                                                                                                                这样能够更有效的使用电力,同时也拉长了RCU grace period的时间,造成性能降低.
                                                                                                                                如果能耗比对你而言非常重要(你想节省每一分电力), 并且你不在乎系统性能的降低
                                                                                                                                (CPU唤醒时间增加),可以开启此选项.台式机和服务器建议关闭此选项. 
@            (0) Real-time priority to use for RCU worker threads (NEW)                       
            [*] Offload RCU callback processing from boot-selected CPUs                 CONFIG_RCU_NOCB_CPU                      如果你想帮助调试内核可以开启,否则请关闭.             
@            Build-forced no-CBs CPUs (All CPUs are build_forced no-CBs CPUs)  --->     
@                    ( ) No build_forced no-CBs CPUs                                   
@                    ( ) CPU 0 is a build_forced no-CBs CPU               
@                    (X) All CPUs are build_forced no-CBs CPUs     
< > Kernel .config support                                                               CONFIG_IKCONFIG                           把内核的配置信息编译进内核中,以后可以通过scripts/extract-ikconfig脚本从内核镜像中提取这些信息                 
(18) Kernel log buffer size (16 => 64KB, 17 => 128KB)                                   CONFIG_LOG_BUF_SHIFT                     设置内核日志缓冲区的最小尺寸(合理的设置应该等于CONFIG_LOG_CPU_MAX_BUF_SHIFT*最大CPU数量): 
                                                                                                                                    12(最小值)=4KB,...,16=64KB,17=128KB,18=256KB,...,25(最大值)   
(12) CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)              
(13) Temporary per-CPU NMI log buffer size (12 => 4KB, 13 => 8KB) (NEW)                 CONFIG_LOG_CPU_MAX_BUF_SHIFT             每个CPU的内核日志缓存大小(通常只有几行文字,但在报告故障时可能会产生大量文字).例如在最大CPU数量
                                                                                                                                    (包含热插拔CPU)为64的系统上,如果CONFIG_LOG_BUF_SHIFT=18,那么该值应该设为12
[*] Memory placement aware NUMA scheduler                                                CONFIG_NUMA_BALANCING                     允许自动根据NUMA系统的节点分布状况进行进程/内存均衡(方法很原始,就是简单的内存移动).
                                                                                                                                    这个选项对UMA系统无效.[提示]UMA系统的例子:(1)只有一颗物理CPU(即使是多核)的电脑,
                                                                                                                                    (2)不支持"虚拟NUMA",或"虚拟NUMA"被禁用的虚拟机(即使所在的物理机是NUMA系统)    
[*]   Automatically enable NUMA aware memory/task placement                             CONFIG_NUMA_BALANCING_DEFAULT_ENABLED    在NUMA(Non-Uniform Memory Access Architecture)系统上自动启用进程/内存均衡,
                                                                                                                                    也就是自动开启CONFIG_NUMA_BALANCING特性.
-*- Control Group support  --->                                                         CONFIG_CGROUPS                          Cgroup(Control Group)是一种进程管理机制,可以针对一组进程进行系统资源的分配和管理,
                                                                                                                                    可用于Cpusets,CFS(完全公平调度器),内存管理等子系统.此外,systemd与Docker/LXC等容器也依赖于它.
                                                                                                                                    更多细节可以参考内核的"Documentation/cgroups/cgroups.txt"文件
        [*]   Memory controller                                                           CONFIG_MEMCG                            为cgroup添加内存资源控制器,包含匿名内存和页面缓存(Documentation/cgroups/memory.txt).
                                                                                                                                    开启此选项后,将会增加关联到每个内存页fixed memory大小,具体在64位系统上是40bytes/PAGE_SIZE.
                                                                                                                                    仅在你确实明白什么是 memory resource controller 并且确实需要的情况下才开启此选项.
                                                                                                                                    此功能可以通过命令行选项"cgroup_disable=memory"进行关闭.Docker依赖于它.              
        [*]     Swap controller                                                         CONFIG_MEMCG_SWAP                        给 Memory Resource Controller 添加对swap的管理功能.这样就可以针对每个cgroup限定其使用的mem+swap总量.
                                                                                                                                    如果关闭此选项, memory resource controller 将仅能限制mem的使用量,而无法对swap进行控制
                                                                                                                                    (进程有可能耗尽swap).开启此功能会对性能有不利影响,并且为了追踪swap的使用也会消耗更多的内存
                                                                                                                                    (如果swap的页面大小是4KB,那么每1GB的swap需要额外消耗512KB内存),所以在内存较小的系统上不建议开启.

        [ ]       Swap controller enabled by default                                     CONFIG_MEMCG_SWAP_ENABLED                如果开启此选项,那么将默认开启CONFIG_MEMCG_SWAP特性,否则将默认关闭.即使默认开启也可以通过内核引导参数
                                                                                                                                    "swapaccount=0"禁止此特性.    
        [*]   IO controller                                                              CONFIG_BLK_CGROUP                        通用的块IO控制器接口,可以用于实现各种不同的控制策略.目前,IOSCHED_CFQ用它来在不同的cgroup之间
                                                                                                                                    分配磁盘IO带宽(需要额外开启CONFIG_CFQ_GROUP_IOSCHED),block io throttle也会用它来针对特定
                                                                                                                                    块设备限制IO速率上限(需要额外开启CONFIG_BLK_DEV_THROTTLING).
                                                                                                                                    更多信息可以参考"Documentation/cgroups/blkio-controller.txt"文件                
        [ ]     IO controller debugging                                                   CONFIG_DEBUG_BLK_CGROUP                    仅用于调试 Block IO controller 目的.           
        -*-   CPU controller  --->  
                -*-   Group scheduling for SCHED_OTHER                                  CONFIG_FAIR_GROUP_SCHED                 公平CPU调度策略,也就是在多个cgroup之间平均分配CPU带宽."鸡血补丁"CONFIG_SCHED_AUTOGROUP
                                                                                                                                    (自动分组调度功能)依赖于它.Docker依赖于它.systemd资源控制单元(resource control unit)
                                                                                                                                    的CPUShares功能也依赖于它.
                [*]     CPU bandwidth provisioning for FAIR_GROUP_SCHED                    CONFIG_CFS_BANDWIDTH                    允许用户为运行在CONFIG_FAIR_GROUP_SCHED中的进程定义CPU带宽限制.对于没有定义CPU带宽限制的cgroup而言,
                                                                                                                                    可以无限制的使用CPU带宽.详情参见Documentation/scheduler/sched-bwc.txt 文件.systemd资源控制单元
                                                                                                                                    (resource control unit)的CPUQuota功能也依赖于它.              
                [ ]   Group scheduling for SCHED_RR/FIFO                                  CONFIG_RT_GROUP_SCHED                    允许用户为cgroup分配实时CPU带宽,还可以对非特权用户的实时进程组进行调度.详情参见 
                                                                                                                                    Documentation/scheduler/sched-rt-group.txt 文档.使用systemd的系统应该选"N".
        [ ]   PIDs controller (NEW)                                                      CONFIG_CGROUP_PIDS                        允许限制同一cgroup内所有进程的数量,超出限制后将无法fork()出新进程.                            
        [*]   Freezer controller                                                          CONFIG_CGROUP_FREEZER                    允许冻结/解冻cgroup内所有进程.Docker依赖于它.                   
        [*]   HugeTLB controller                                                         CONFIG_CGROUP_HUGETLB                    为cgroup添加对HugeTLB页的资源控制功能.开启此选项之后,你就可以针对每个cgroup限定其对HugeTLB的使用.
                                                                                                                                    Docker依赖于它.
        [*]   Cpuset controller                                                          CONFIG_CPUSETS                            CPUSET支持:允许将CPU和内存进行分组,并指定某些进程只能运行于特定的分组.Docker依赖于它.
        [*]     Include legacy /proc/<pid>/cpuset file                                   CONFIG_PROC_PID_CPUSET                    提供过时的 /proc/<pid>/cpuset 文件接口
        [*]   Device controller                                                          CONFIG_CGROUP_DEVICE                    允许为cgroup建立设备白名单,这样cgroup内的进程将仅允许对白名单中的设备进行mknod/open操作.Docker依赖于它.
        [*]   Simple CPU accounting controller                                           CONFIG_CGROUP_CPUACCT                    提供一个简单的资源控制器(Resource Controller,用于实现一组任务间的资源共享),以监控cgroup内所有进程的总CPU使用量.
                                                                                                                                    Docker依赖于它.
        [*]   Perf controller                                                            CONFIG_CGROUP_PERF                        将per-cpu模式进行扩展,使其可以监控属于特定cgroup并运行于特定CPU上的线程.
        [ ]   Example controller                                                          CONFIG_CGROUP_DEBUG                        导出cgroups框架的调试信息,仅用于调试目的.
[*] Checkpoint/restore support                                                          CONFIG_CHECKPOINT_RESTORE                在内核中添加"检查点/恢复"支持.也就是添加一些辅助的代码用于设置进程的 text, data, heap 段,
                                                                                                                                    并且在 /proc 文件系统中添加一些额外的条目.用于检测两个进程是否共享同一个内核资源的kcmp()系统调用依赖于它.
                                                                                                                                    使用systemd的建议开启此项.
[*] Namespaces support  --->      
        --- Namespaces support                                                           CONFIG_NAMESPACES                        命名空间支持.主要用于支持基于容器的轻量级虚拟化技术(比如LXC和Linux-VServer以及Docker).                                     
        [*]   UTS namespace                                                             CONFIG_UTS_NS                            uname()系统调用的命名空间支持
        [*]   IPC namespace                                                             CONFIG_IPC_NS                            进程间通信对象ID的命名空间支持
        [*]   User namespace                                                            CONFIG_USER_NS                          允许容器使用user命名空间.如果开启此项,建议同时开启CONFIG_MEMCG和CONFIG_MEMCG_KMEM选项,
                                                                                                                                    以允许用户空间使用"memory cgroup"限制非特权用户的内存使用量.
                                                                                                                                    不确定的选"N",如果你打算构建一个VPS服务器就必须选"Y".
        [*]   PID Namespaces                                                            CONFIG_PID_NS                            进程PID命名空间支持
        [*]   Network namespace                                                         CONFIG_NET_NS                            网络协议栈的命名空间支持.systemd服务单元(service unit)中的"PrivateNetwork/PrivateDevices"依赖于它.                                 
[*] Automatic process group scheduling                                                  CONFIG_SCHED_AUTOGROUP                    每个TTY动态地创建任务分组(cgroup),这样就可以降低高负载情况下的桌面延迟.也就是传说中的桌面"鸡血补丁",
                                                                                                                                    桌面用户建议开启.但服务器建议关闭.  
[ ] Enable deprecated sysfs features to support old userspace tools                     CONFIG_SYSFS_DEPRECATED                 为了兼容旧版本的应用程序而保留过时的sysfs特性.仅当在使用2008年以前的发行版时才需要开启,
                                                                                                                                    2009年之后的发行版中必须关闭.此外,使用udev或systemd的系统也必须关闭.
-*- Kernel->user space relay support (formerly relayfs)                                  CONFIG_RELAY                            在某些文件系统(比如debugfs)中提供中继(relay)支持(从内核空间向用户空间传递大批量数据).主要用于调试内核                   
[*] Initial RAM filesystem and RAM disk (initramfs/initrd) support                      CONFIG_BLK_DEV_INITRD                    初始内存文件系统(initramfs,2.6以上内核的新机制,使用cpio格式,占据的内存随数据的增减自动增减)与初始内存盘
                                                                                                                                    (initrd,2.4以前内核遗留的老机制,使用loop设备,占据一块固定的内存,需要额外开启CONFIG_BLK_DEV_RAM选项才生效)
                                                                                                                                    支持,一般通过lilo/grub的initrd指令加载.更多细节可以参考"Documentation/initrd.txt"文件,
                                                                                                                                    关于initrd到initramfs的进化(墙内镜像),可以参考IBM上的两篇文章:
                                                                                                                                    Linux2.6 内核的 Initrd 机制解析和Linux 初始 RAM 磁盘（initrd）概述.                
()    Initramfs source file(s)                                                            CONFIG_INITRAMFS_SOURCE                    如果你想将initramfs镜像直接嵌入内核(比如嵌入式环境或者想使用 EFI stub kernel),
                                                                                                                                    而不是通过lilo/grub这样的引导管理器加载,可以使用此选项,否则请保持空白.这个选项指明用来制作initramfs镜像的原料,
                                                                                                                                    可以是一个.cpio文件,或一个Initramfs虚根目录(其下包含"bin,dev,etc,lib,proc,sys"等子目录),或一个描述文件.
                                                                                                                                    细节可以参考"Documentation/early-userspace/README"文档.[注意]内核帮助文档说可以指定多个目录或文件是错误的,
                                                                                                                                    实际只能接受单一的目录或文件                      
[*]   Support initial ramdisks compressed using gzip                                    CONFIG_RD_GZIP                            支持经过gzip压缩的ramdisk或cpio镜像
[*]   Support initial ramdisks compressed using bzip2                                   CONFIG_RD_BZIP2
[*]   Support initial ramdisks compressed using LZMA                                    CONFIG_RD_LZMA
[*]   Support initial ramdisks compressed using XZ                                      CONFIG_RD_XZ
[*]   Support initial ramdisks compressed using LZO                                     CONFIG_RD_LZO
@ [*]   Support initial ramdisks compressed using LZ4                             
    Compiler optimization level (Optimize for performance)  --->         
            (X) Optimize for performance                                                CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE      编译时优化内核性能(使用GCC的"-O2"参数编译)                                  
            ( ) Optimize for size                                                       CONFIG_CC_OPTIMIZE_FOR_SIZE                编译时优化内核尺寸(使用GCC的"-Os"而不是"-O2"参数编译),这会得到更小的内核,但是运行速度可能会更慢.主要用于嵌入式环境.                                       
[*] Configure standard kernel features (expert users)  --->   
        --- Configure standard kernel features (expert users)                           CONFIG_EXPERT                           配置标准的内核特性(仅供专家使用).这个选项允许你改变内核的"标准"特性(比如用于需要"非标准"内核的特定环境中),
                                                                                                                                    仅在你确实明白自己在干什么的时候才开启.                                        
        [*]   Enable 16-bit UID system calls                                            CONFIG_UID16                            允许对UID系统调用进行过时的16-bit包装,建议关闭            
        [*]   Multiple users, groups and capabilities support                           CONFIG_MULTIUSER                        多用户(组)支持.若选"N",则所有进程都将以"UID=0,GID=0"运行(也就是禁止存在非root用户).选"Y",除非你确实知道自己在干什么.                
        [*]   sgetmask/ssetmask syscalls support                                        CONFIG_SGETMASK_SYSCALL                 是否开启已被反对使用的sys_sgetmask/sys_ssetmask系统调用(已不再被libc支持).建议选"N".                       
        [*]   Sysfs syscall support                                                     CONFIG_SYSFS_SYSCALL                    是否开启已被反对使用的sys_sysfs系统调用(已不再被libc支持).建议选"N".                    
        [*]   Sysctl syscall support                                                    CONFIG_SYSCTL_SYSCALL                   二进制sysctl接口支持.由于现在流行直接通过/proc/sys以ASCII明码方式修改内核参数(需要开启CONFIG_PROC_SYSCTL选项),
                                                                                                                                    所以已经不需要再通过二进制接口去控制内核参数,建议关闭它以减小内核尺寸.                                    
@        -*-   Load all symbols for debugging/ksymoops                                   CONFIG_KALLSYMS                         在/proc/kallsyms中包含内核知道的所有符号,内核将会增大300K,仅在你确实需要的时候再开启                                        
@        [*]     Include all symbols in kallsyms                                                                                 
        [*]   Enable support for printk                                                 CONFIG_PRINTK                           允许内核向终端打印字符信息.任何由printk显示的字符串通常记录在/var/log/messages文件里.如果关闭,
                                                                                                                                    内核在初始化过程中将不会输出字符信息,这会导致很难诊断系统故障,并且"dmesg"命令也会失效.
                                                                                                                                    仅在你确实不想看到任何内核信息时选"N".否则请选"Y".             
        [*]   BUG() support                                                             CONFIG_BUG                              显示故障和失败条件(BUG和WARN),禁用它将可能导致隐含的错误被忽略.建议仅在嵌入式设备或者无法显示故障信息的系统上关闭          
        [*]   Enable ELF core dumps                                                     CONFIG_ELF_CORE                         内存转储支持,可以帮助调试ELF格式的程序,用于调试和开发用户态程序               
        [*]   Enable PC-Speaker support                                                 CONFIG_PCSPKR_PLATFORM                  主板上的蜂鸣器支持.主板上的蜂鸣器只能发出或长或短的"滴"或"嘟嘟"声,一般用于系统报警.不要和能够播放音乐的扬声器混淆.
                                                                                                                                    如果你的主板上没有就关闭,有的话(开机自检完成后一般能听到"滴"的一声)还是建议开启.                       
        [*]   Enable full-sized data structures for core                                CONFIG_BASE_FULL                        在内核中使用全尺寸的数据结构.禁用它将使得某些内核的数据结构减小以节约内存,但是将会降低性能                
        [*]   Enable futex support                                                      CONFIG_FUTEX                            快速用户空间互斥(fast userspace mutexes)可以使线程串行化以避免竞态条件,也提高了响应速度.
                                                                                                                                    禁用它将导致内核不能正确的运行基于glibc的程序            
        [*]   Enable eventpoll support                                                  CONFIG_EPOLL                            Epoll系列系统调用(epoll_*)支持,这是当前在Linux下开发大规模并发网络程序(比如Nginx)的热门人选,设计目的是取代既有
                                                                                                                                    POSIX select(2)与poll(2)系统接口,systemd依赖于它.建议开启.            
        [*]   Enable signalfd() system call                                             CONFIG_SIGNALFD                         signalfd()系统调用支持,建议开启.传统的处理信号的方式是注册信号处理函数,由于信号是异步发生的,
                                                                                                                                    要解决数据的并发访问和可重入问题.signalfd可以将信号抽象为一个文件描述符,当有信号发生时可以对其read,
                                                                                                                                    这样可以将信号的监听放到select/poll/epoll监听队列中.systemd依赖于它.                
        [*]   Enable timerfd() system call                                              CONFIG_TIMERFD                          timerfd()系统调用支持,建议开启.timerfd可以实现定时器功能,将定时器抽象为文件描述符,当定时器到期时可以对其read,
                                                                                                                                    这样也可以放到select/poll/epoll监听队列中.更多信息可以参考linux新的API signalfd、timerfd、eventfd使用说明.
                                                                                                                                    systemd依赖于它.

        -*-   Enable eventfd() system call                                              CONFIG_EVENTFD                          eventfd()系统调用支持,建议开启.eventfd实现了线程之间事件通知的方式,eventfd的缓冲区大小是sizeof(uint64_t),
                                                                                                                                    向其write可以递增这个计数器,read操作可以读取,并进行清零.eventfd也可以放到select/poll/epoll监听队列中.
                                                                                                                                    当计数器不是0时,有可读事件发生,可以进行读取                                                                                                     
[*] Enable bpf() system call                                                            CONFIG_BPF_SYSCALL                      开启内核的bpf()系统调用支持(从3.15版本开始引入),以支持eBPF功能.可用于内核调试与网络包过滤(tcpdump,libpcap,iptables).
                                                                                                                                    不确定的选"N".
-*- Use full shmem filesystem                                                           CONFIG_SHMEM                            完全使用shmem来代替ramfs.shmem是基于共享内存的文件系统(可以使用swap),在启用CONFIG_TMPFS后可以挂载为tmpfs供
                                                                                                                                    用户空间使用,它比简单的ramfs先进许多.仅在微型嵌入式环境中且没有swap的情况下才可能会需要使用原始的ramfs
[*] Enable AIO support                                                                  CONFIG_AIO                                开启POSIX异步IO支持.它常常被高性能的多线程程序使用,建议开启
[*] Enable madvise/fadvise syscalls                                                     CONFIG_ADVISE_SYSCALLS                  开启内核的madvise()/fadvise()系统调用支持(2.6.16版本开始引入).以允许应用程序预先提示内核,它将如何使用特定的内存与文件.
                                                                                                                                    这种措施有助于提升应用程序的性能.建议选"Y".
[ ] Enable userfaultfd() system call (NEW)                                              CONFIG_USERFAULTFD                        开启内核的userfaultfd()系统调用支持(从4.3版本开始引入).该特性可以被诸如QEMU/KVM之类的虚拟化技术用来提高GuestOS热迁移性能.
[*] Enable PCI quirk workarounds                                                        CONFIG_PCI_QUIRKS                        开启针对多种PCI芯片组的错误规避功能,仅在确定你的PCI芯片组确实没有没有任何bug时才关闭此功能.至于究竟哪些芯片组有bug,
                                                                                                                                    你可以直接打开"drivers/pci/quirks.c"文件查看.不确定的选"Y".
[*] Enable membarrier() system call (NEW)                                               CONFIG_MEMBARRIER                       开启内核的membarrier()系统调用支持(与Memory Barrier相关).有助于提升多CPU场景下的并行计算性能.建议选"Y".
[ ] Embedded system                                                                     CONFIG_EMBEDDED                         如果你是为嵌入式系统编译内核,可以开启此选项,这样一些高级选项就会显示出来.单独选中此项本身对内核并无任何改变.
    Kernel Performance Events And Counters  --->   
            -*- Kernel performance events and counters                                  CONFIG_PERF_EVENTS                        性能相关的事件和计数器支持(既有硬件的支持也有软件的支持).大多数现代CPU都会通过性能计数寄存器对特定类型的硬件事件
                                                                                                                                    (指令执行,缓存未命中,分支预测失败)进行计数,同时又丝毫不会减慢内核和应用程序的运行速度.这些寄存器还会在某些
                                                                                                                                    事件计数到达特定的阈值时触发中断,从而可以对代码进行性能分析. Linux Performance Event 子系统对上述特性进行了抽象,
                                                                                                                                    提供了针对每个进程和每个CPU的计数器,并可以被 tools/perf/ 目录中的"perf"工具使用.    
            [ ]   Debug: use vmalloc to back perf mmap() buffers                        CONFIG_DEBUG_PERF_USE_VMALLOC           主要用于调试vmalloc代码.
[*] Enable VM event counters for /proc/vmstat                                           CONFIG_VM_EVENT_COUNTERS                "/proc/vmstat"中包含了从内核导出的虚拟内存的各种统计信息.开启此项后可以显示较详细的信息(包含各种事件计数器),
                                                                                                                                    关闭此项则仅仅显示内存页计数.主要用于调试和统计.
[*] Enable SLUB debugging support                                                       CONFIG_SLUB_DEBUG                       SLUB调试支持,禁用后可显著降低内核大小,同时/sys/kernel/slab也将不复存在.       
[ ] Disable heap randomization                                                          CONFIG_COMPAT_BRK                       禁用堆随机化(heap randomization)功能.堆随机化可以让针对堆溢出的攻击变得困难,但是不兼容那些古董级的二进制程序(2000年以前).
                                                                                                                                    如果你不需要使用这些古董程序,那么选"N".
    Choose SLAB allocator (SLUB (Unqueued Allocator))  --->
            ( ) SLAB                                                                      CONFIG_SLAB                                久经考验的slab内存分配器,在大多数情况下都具有良好的适应性.
            (X) SLUB (Unqueued Allocator)                                                 CONFIG_SLUB                                SLUB与SLAB兼容,但通过取消大量的队列和相关开销,简化了slab的结构.特别是在多核时拥有比slab更好的性能和更好的系统可伸缩性
            ( ) SLOB (Simple Allocator)                                                  CONFIG_SLOB                                SLOB针对小型系统设计,做了非常激进的简化,以适用于内存非常有限(小于64M)的嵌入式环境
@ [ ] SLAB freelist randomization (NEW)                                           
[*] SLUB per cpu partial cache                                                             CONFIG_SLUB_CPU_PARTIAL                    让SLUB内存分配器使用基于每个CPU的局部缓存,这样可以加速分配和释放属于此CPU范围内的对象,但这样做的代价是增加对象释放延迟的
                                                                                                                                    不确定性.因为当这些局部缓存因为溢出而要被清除时,需要使用锁,从而导致延迟尖峰.
                                                                                                                                    对于需要快速响应的实时系统,应该选"N",服务器则可以选"Y".                                 
[*] Profiling support                                                                   CONFIG_PROFILING                        添加扩展的性能分析支持,可以被OProfile之类的工具使用.仅用于调试目的.
<M> OProfile system profiling                                                           CONFIG_OPROFILE                            OProfile性能分析工具支持,仅用于调试目的
[ ]   OProfile multiplexing support (EXPERIMENTAL)                                        CONFIG_OPROFILE_EVENT_MULTIPLEX            OProfile multiplexing技术支持          
[*] Kprobes                                                                             CONFIG_KPROBES                            Kprobes是一个轻量级的内核调试工具,能在内核运行的几乎任意时间点进行暂停/读取/修改等操作的调试工具.仅供调试使用.
[*] Optimize very unlikely/likely branches                                              CONFIG_JUMP_LABEL                        针对内核中某些"几乎总是为真"或者"几乎总是为假"的条件分支判断使用"asm goto"进行优化(在分支预测失败时会浪费很多时间在回退上,
                                                                                                                                    但是这种情况极少发生).很多内核子系统都支持进行这种优化.建议开启.
[ ]   Static key selftest (NEW)                                                         CONFIG_STATIC_KEYS_SELFTEST                在内核启动时对上述分支优化补丁进行一次自我检查.
@ [ ] GCC plugins (NEW)  ----                                                                                         
    Stack Protector buffer overflow detection (Strong)  --->                              CONFIG_CC_STACKPROTECTOR_STRONG         GCC的"stack-protector"功能可以在函数开始执行时,在函数的返回地址末端设置一个敏感值,当函数执行完成要返回时,检查这个敏感值,
                                                                                                                                    看看是否存在溢出.如果有溢出则表明可能受到了堆栈溢出攻击,内核将通过panic来阻止可能的攻击.
            ( ) None                                                                                                              关闭此功能
            ( ) Regular                                                                                                           启用此功能但是仅提供较弱的保护(需要GCC-4.2及以上版本)
            (X) Strong                                                                                                             提供较强的保护(需要GCC-4.9及以上版本)
@ (28) Number of bits to use for ASLR of mmap base address (NEW)                  
@ (8) Number of bits to use for ASLR of mmap base address for compatible applications
@ [*] Use a virtually-mapped stack (NEW)                                          
    GCOV-based kernel profiling  --->  
            [ ] Enable gcov-based kernel profiling                                         CONFIG_GCOV_KERNEL                        基于GCC的gcov(代码覆盖率测试工具)的代码分析支持,
--- Enable loadable module support                                                CONFIG_MODULES                       打开可加载模块支持,可以通过"make modules_install"把内核模块安装在/lib/modules/中.
                                                                                                                         然后可以使用 modprobe, lsmod, modinfo, insmod, rmmod 等工具进行各种模块操作.                   
[ ]   Forced module loading                                                     CONFIG_MODULE_FORCE_LOAD             允许使用"modprobe --force"在不校验版本信息的情况下强制加载模块,这绝对是个坏主意!建议关闭.                                                                                                
[*]   Module unloading                                                          CONFIG_MODULE_UNLOAD                 允许卸载已经加载的模块.如果将模块静态编译进内核中,那么内核的执行效率会更好.如果代码作为动态模块加载,
                                                                                                                         那么不使用时可以减少内核的内存使用并减少启动的时间,然而内核和模块在内存上相互独立又会影响内核的执行性能.                                                                                                
[ ]   Forced module unloading                                                   CONFIG_MODULE_FORCE_UNLOAD           允许强制卸载正在使用中的模块(rmmod -f),即使可能会造成系统崩溃.这又是一个坏主意!建议关闭.                                                                                     
[*]   Module versioning support                                                 CONFIG_MODVERSIONS                     允许使用为其他内核版本编译的模块,可会造成系统崩溃.这同样是个坏主意!建议关闭.                                                                                                
[*]   Source checksum for all modules                                           CONFIG_MODULE_SRCVERSION_ALL         为模块添加"srcversion"字段,以帮助模块维护者准确的知道编译此模块所需要的源文件,从而可以校验源文件的变动.仅内核模块开发者需要它.                                                                                                
[*]   Module signature verification                                             CONFIG_MODULE_SIG                     在加载模块时检查模块签名,详情参见"Documentation/module-signing.txt"文件.
                                                                                                                         [!!警告!!]开启此选项后,必须确保模块签名后没有被strip(包括rpmbuild之类的打包工具).                                                                                                
[ ]   Require modules to be validly signed                                      CONFIG_MODULE_SIG_FORCE                 仅加载已签名并且密钥正确的模块,拒绝加载未签名或者签名密钥不正确的模块                                                                                                
[*]   Automatically sign all modules                                            CONFIG_MODULE_SIG_ALL                 在执行"make modules_install"安装模块的时候,自动进行签名.否则你必须手动使用 scripts/sign-file 工具进行签名.                                                                                                
      Which hash algorithm should modules be signed with? (Sign modules with SHA-512)  --->                          选择对模块签名时使用的散列函数.建议使用强度最高的"SHA-512"算法.注意:所依赖的散列算法必须被静态编译进内核.
                                                                                                                         对于"SHA-512"来说,就是CONFIG_CRYPTO_SHA512和CONFIG_CRYPTO_SHA512_SSSE3(如果你的CPU支持SSSE3指令集的话).
            ( ) Sign modules with SHA-1                                                                              
            ( ) Sign modules with SHA-224                                                                            
            ( ) Sign modules with SHA-256                                                                            
            ( ) Sign modules with SHA-384                                                                            
            (X) Sign modules with SHA-512                                                                            
[ ]   Compress modules on installation                                          CONFIG_MODULE_COMPRESS               在'make modules_install'时对内核模块进行压缩.传统的module-init-tools工具可能支持gzip压缩,而新式的kmod可能支持gzip与xz压缩.
--- Enable the block layer                                                              CONFIG_BLOCK                          块设备支持,使用SSD/硬盘/U盘/SCSI/SAS设备者必选.除非你是某些特殊的嵌入式系统,否则没有理由不使用块设备     
-*-   Block layer SG support v4                                                         CONFIG_BLK_DEV_BSG                    为块设备启用第四版SG(SCSI generic)支持.v4相比v3能够支持更复杂的SCSI指令(可变长度的命令描述块,双向数据传输,
                                                                                                                                  通用请求/应答协议),而且UDEV也要用它来获取设备的序列号.对于使用systemd的系统来说,必须选"Y".
                                                                                                                                  对于不使用systemd的系统,如果你需要通过/dev/bsg/*访问块设备,建议开启此选项,否则(通过/dev/{sd*,st*,sr*})可以关闭.
-*-   Block layer SG support v4 helper lib                                              CONFIG_BLK_DEV_BSGLIB                 你不需要手动开启此选项,如果有其他模块需要使用,会被自动开启.
-*-   Block layer data integrity support                                                CONFIG_BLK_DEV_INTEGRITY              某些块设备可以通过存储/读取额外的信息来保障端到端的数据完整性,这个选项为文件系统提供了相应的钩子函数来使用这个特性.
                                                                                                                                  如果你的设备支持 T10/SCSI Data Integrity Field 或者 T13/ATA External Path Protection 特性,那么可以开启此选项,否则建议关闭.
[*]   Block layer bio throttling support                                                CONFIG_BLK_DEV_THROTTLING             Bio Throttling 支持,也就是允许限制每个cgroup对特定设备的IO速率.细节可以参考"Documentation/cgroups/blkio-controller.txt".     
-*-   Block device command line partition parser                                        CONFIG_BLK_CMDLINE_PARSER             允许通过内核引导参数设定块设备的分区信息(Documentation/block/cmdline-partition.txt).仅对某些嵌入式设备有意义     
      Partition Types  --->    
            [*] Advanced partition selection                                            CONFIG_PARTITION_ADVANCED             如果你想支持各种不同的磁盘分区格式(特别是与UEFI配合使用的GPT格式),务必选中此项.                        
            [ ]   Acorn partition support                                               CONFIG_ACORN_PARTITION                Acorn 操作系统使用的分区格式                                     
            [*]   AIX basic partition table support                                                                           AIX 平台
            [*]   Alpha OSF partition support                                                                                 Alpha 平台
            [*]   Amiga partition table support                                                                               AmigaOS 平台
            [*]   Atari partition table support                                                                               Atari 平台
            [*]   Macintosh partition map support                                                                             苹果的Macintosh 平台
            [*]   PC BIOS (MSDOS partition tables) support                              CONFIG_MSDOS_PARTITION                渐成历史垃圾,但目前依然最常见的DOS分区格式.除非你确信不使用此格式,否则必选.其下的子项根据实际情况选择.                                           
@            [*]     BSD disklabel (FreeBSD partition tables) support                                                         
@            [*]     Minix subpartition support                                                                               
@            [*]     Solaris (x86) partition table support                                                                    
@            [*]     Unixware slices support                                                                                  
            [*]   Windows Logical Disk Manager (Dynamic Disk) support                   CONFIG_LDM_PARTITION                  使用 Windows Logical Disk Manager 创建的分区格式.参见"Documentation/ldm.txt"                                      
@            [ ]     Windows LDM extra logging                                                                                 
            [*]   SGI partition support                                                 CONFIG_SGI_PARTITION                  SGI 平台上使用的分区格式
            [*]   Ultrix partition table support                                                                              DEC/Compaq Ultrix 平台 
            [*]   Sun partition tables support                                                                                SunOS 平台
            [*]   Karma Partition support                                                                                     Rio Karma MP3 player 
            [*]   EFI GUID Partition support                                            CONFIG_EFI_PARTITION                  代表未来趋势,眼下正大红大紫的EFI GPT(GUID Partition Table)分区格式.建议开启.如果你在UEFI平台上安装则必须开启.                                     
            [*]   SYSV68 partition table support                                                                              Motorola Delta 机器
@            [*]   Command line partition support                                                                             
      IO Schedulers  --->                                                                                                       IO调度器
            <*> Deadline I/O scheduler                                                  CONFIG_IOSCHED_DEADLINE               deadline调度器.简洁小巧(只有400+行代码),提供了最小的读取延迟,非常适合同一时间只有少数个别进程进行IO请求的情况.
                                                                                                                                  如果你希望尽快读取磁盘,而不介意写入延迟,那它是最佳选择.通常对于数据库工作负载有最佳的表现.                                  
            <*> CFQ I/O scheduler                                                       CONFIG_IOSCHED_CFQ                    cfq(Complete Fair Queuing)调度器.努力在各内核线程间公平分配IO资源,适用于系统中存在着大量内核线程同时进行IO请求的情况.
                                                                                                                                  但对于只有少数内核线程进行密集IO请求的情况,则会出现明显的性能下降                                  
            [*]   CFQ Group Scheduling support                                                                            
                Default I/O scheduler (Deadline)  --->                                                                        默认IO调度器.如果上述调度器都是模块,那么将使用最简单的内置NOOP调度器.NOOP(No Operation)调度器只是一个简单的FIFO队列,
                                                                                                                                  不对IO请求做任何重新排序处理(但还是会做一定程度的归并),适合于SSD/U盘/内存/虚拟机硬盘/SAN(Storage Area Networks)
                                                                                                                                  等无需寻道的存储设备,重点是可以节约CPU资源,但不适用于普通硬盘这样的需要依靠磁头来定位的设备.另外,有人说拥有TCQ/NCQ技术
                                                                                                                                  (能够自动重新排序)的硬盘也适合用NOOP调度器,这个说法其实并不那么合理,但笔者在此不敢断言,希望读者在严谨的测试之后再做定夺.
                    (X) Deadline                                                                                                    
                    ( ) CFQ                                                                                                         
                    ( ) No-op    

                    
|                            选项                                          |                  配置名                |               内容
--------------------------------------------------------------------------------------------------------------------------------------------------------------
   [*] DMA memory allocation support                                                       CONFIG_ZONE_DMA                            允许为寻址宽度不足32位的设备(也就是ISA和LPC总线设备)在物理内存的前16MB范围内(也就是传统上x86_32架构的ZONE_DMA区域)
                                                                                                                                    分配内存.不确定的选"N",内核中若有其它驱动(主要是某些老旧的声卡)需要它会自动选中此项.[提示]LPC总线通常和主板上
                                                                                                                                    的南桥物理相连,通常连接了一系列的传统设备:BIOS,PS/2键盘,PS/2鼠标,软盘,并口设备,串口设备,某些集成声卡,
                                                                                                                                    TPM(可信平台模块),等等.[题外话]x86_64已经没有ZONE_HIGHMEM了                                                     
   [*] Symmetric multi-processing support                                               CONFIG_SMP                                SMP(对称多处理器)支持,如果你有多个CPU或者使用的是多核CPU就选上.                                            
   [*] Support x2apic                                                                   CONFIG_X86_X2APIC                         x2apic支持.具有这个特性的CPU可以使用32位的APIC ID(可以支持海量的CPU),并且可以使用MSR而不是mmio去访问 local APIC 
                                                                                                                                    (更加高效).可以通过"grep x2apic /proc/cpuinfo"命令检查你的CPU是否支持这个特性.注意:有时候还需要在BIOS中也开启
                                                                                                                                    此特性才真正生效.[提示]在虚拟机中,还需要VMM的支持(例如qemu-kvm).                                   
   [*] Enable MPS table                                                                 CONFIG_X86_MPPARSE                      如果是不支持acpi特性的古董级SMP系统就选上.但现今的64位系统早都已经支持acpi了,所以可以安全的关闭.                                            
   [*] Support for extended (non-PC) x86 platforms                                      CONFIG_X86_EXTENDED_PLATFORM            支持非标准的PC平台: Numascale NumaChip, ScaleMP vSMP, SGI Ultraviolet. 绝大多数人都遇不见这些平台.                                            
   [*] Numascale NumaChip                                                               CONFIG_X86_NUMACHIP                     Numascale NumaChip 平台支持                                            
   [ ] ScaleMP vSMP                                                                                                             ScaleMP vSMP 平台    
   [ ] SGI Ultraviolet                                                                                                          SGI Ultraviolet 平台    
   [ ] Goldfish (Virtual Platform)                                                                                                  
   [ ] Intel MID platform support                                                                                                   
   < > Mellanox Technologies platform support                                                                                       
 @ [*] Intel Low Power Subsystem Support                                                                                            
   [*] AMD ACPI2Platform devices support                                                CONFIG_X86_AMD_PLATFORM_DEVICE          为AMD Carrizo以及后继架构的I2C,UART,GPIO提供支持.                                                                    
   -*- Intel SoC IOSF Sideband support for SoC platforms                                CONFIG_IOSF_MBI                            为主打低功耗的Intel SoC平台CPU开启"sideband"寄存器访问支持.这些CPU包括:BayTrail,Braswell,Quark                                            
 @ [*]   Enable IOSF sideband access through debugfs                                                                                
   [*] Single-depth WCHAN output                                                         CONFIG_SCHED_OMIT_FRAME_POINTER         使用简化的 /proc/<PID>/wchan 值,禁用此选项会使用更加精确的wchan值(可以在"ps -l"结果的WCHAN域看到),但会轻微增加调度器消耗.                                                                                      
   [*] Linux guest support  --->                    
           --- Linux guest support                                                      CONFIG_HYPERVISOR_GUEST                 如果这个内核将在虚拟机里面运行就开启,否则就关闭.                                         
           [*]   Enable paravirtualization code                                         CONFIG_PARAVIRT                         半虚拟化(paravirtualization)支持.                                         
           [ ]     paravirt-ops debugging                                               CONFIG_PARAVIRT_DEBUG                   仅供调试.paravirt-ops是内核通用的半虚拟化接口.                                         
           [*]     Paravirtualization layer for spinlocks                               CONFIG_PARAVIRT_SPINLOCKS               半虚拟化的自旋锁支持.开启之后运行在虚拟机里的内核速度会加快,但是运行在物理CPU上的宿主内核运行效率会降低
                                                                                                                                    (最多可能会降低5%).请根据实际情况选择.                                         
 @         [ ]       Paravirt queued spinlock statistics                                                                         
           [*]     Xen guest support                                                    CONFIG_XEN                              Xen半虚拟化技术支持            
 @         [*]       Limit Xen pv-domain memory to 512GB                                                                         
           [ ]       Enable Xen debug and tuning parameters in debugfs                  CONFIG_XEN_DEBUG_FS                     为Xen在debugfs中输出各种统计信息和调整选项.对性能有严重影响.仅供调试.                    
 @         [*]       Support for running as a PVH guest                                                                          
           [*]     KVM Guest support (including kvmclock)                               CONFIG_KVM_GUEST                        KVM客户机支持(包括kvmclock).                 
 @         [*]       Enable debug information for KVM Guests in debugfs                                                          
           [ ]     Paravirtual steal time accounting                                     CONFIG_PARAVIRT_TIME_ACCOUNTING            允许进行更细粒度的 task steal time 统计.会造成性能的略微降低.仅在你确实需要的时候才开启.
       Processor family (Generic-x86-64)  --->                                                                                     处理器系列,请按照你实际使用的CPU选择."Generic-x86-64"表示通用于所有x86-64平台,而不是针对特定类型的CPU进行优化.
           ( ) Opteron/Athlon64/Hammer/K8                   
           ( ) Intel P4 / older Netburst based Xeon         
           ( ) Core 2/newer Xeon                            
           ( ) Intel Atom                                   
           (X) Generic-x86-64       
   [*] Supported processor vendors  --->                                                                                          支持的CPU厂商,按实际情况选择.
           --- Supported processor vendors                                                             
           [*]   Support Intel processors                                                              
           [*]   Support AMD processors                                                                
           [*]   Support Centaur processors  
   [*] Enable DMI scanning                                                              CONFIG_DMI                              允许扫描DMI(Desktop Management Interface)/SMBIOS(System Management BIOS)以获得机器的硬件配置,
                                                                                                                                    从而对已知的bug bios进行规避.具体涉及到哪些机器可参见"drivers/acpi/blacklist.c"文件.
                                                                                                                                    除非确定你的机器没有bug,否则请开启此项.                                                                                                        
   [*] Old AMD GART IOMMU support                                                       CONFIG_GART_IOMMU                       为较旧的AMD Athlon64/Opteron/Turion/Sempron CPU提供GART IOMMU支持.图形地址重映射表
                                                                                                                                    (Graphics Address Remapping Table)可以将物理地址不连续的系统内存映射成看上去连续的图形内存交给GPU使用,
                                                                                                                                    是一种挖CPU内存补GPU内存机制,这种机制也可以被认为是一种"伪IOMMU"(缺乏地址空间隔离和访问控制).
                                                                                                                                    开启此选项以后,在内存大于3G的系统上,传统的32位总线(PCI/AGP)的设备将可以使用完全DMA的方式直接访问
                                                                                                                                    原本超出32位寻址范围之外的系统内存区域.具体方法是:通过编程让设备在受GART控制的显存区域工作,
                                                                                                                                    然后使用GART将这个地址映射为真实的物理地址(4GB以上)来实现的.USB/声卡/IDE/SATA之类的设备常常需要它.
                                                                                                                                    开启此选项之后,除非同时开启了CONFIG_IOMMU_DEBUG选项或者使用了"iommu=force"内核引导参数,
                                                                                                                                    否则此特性仅在条件满足的情况下(内存足够大且确有支持GART的设备)激活.由于较新的AMD CPU都已配备了AMD IOMMU
                                                                                                                                    (应该使用CONFIG_AMD_IOMMU),故而仅建议在内存大于3G的老式AMD系统上选"Y".                                            
   [*] IBM Calgary IOMMU support                                                        CONFIG_CALGARY_IOMMU                    IBM xSeries/pSeries 系列服务器的 Calgary IOMMU 支持.                                            
   [*]   Should Calgary be enabled by default?                                          CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT 开启此选项表示默认启用Calgary特性,关闭此选项表示默认禁用Calgary特性(可以使用"iommu=calgary"内核引导参数开启).                                            
   [ ] Enable Maximum number of SMP Processors and NUMA Nodes                           CONFIG_MAXSMP                           让内核支持x86_64平台所能支持的最大SMP处理器数量和最大NUMA节点数量.主要用于调试目的.                                            
   (256) Maximum number of CPUs                                                         CONFIG_NR_CPUS                          支持的最大CPU数量,每个CPU要占8KB的内核镜像,最小有效值是"2",最大有效值是"512".注意:这里的"CPU数量"是指"逻辑CPU数量".
                                                                                                                                    例如,对于一颗带有超线程技术的4核8线程CPU来说,相当于拥有8个CPU.                                            
   [*] SMT (Hyperthreading) scheduler support                                           CONFIG_SCHED_SMT                        Intel超线程技术(HyperThreading)支持.                                            
   [*] Multi-core scheduler support                                                     CONFIG_SCHED_MC                         针对多核CPU进行调度策略优化                                            
       Preemption Model (Voluntary Kernel Preemption (Desktop))  --->                                                           内核抢占模式    
           ( ) No Forced Preemption (Server)                                            CONFIG_PREEMPT_NONE                     禁止内核抢占,这是Linux的传统模式,可以得到最大的吞吐量,适合服务器和科学计算环境      
           (X) Voluntary Kernel Preemption (Desktop)                                    CONFIG_PREEMPT_VOLUNTARY                自愿内核抢占,通过在内核中设置明确的抢占点以允许明确的内核抢占,可以提高响应速度,但是对吞吐量有不利影响.适合普通桌面环境      
           ( ) Preemptible Kernel (Low-Latency Desktop)                                 CONFIG_PREEMPT                          主动内核抢占,允许抢占所有内核代码,对吞吐量有更大影响,适合需要运行实时程序的场合或者追求最快响应速度的桌面环境.      
   [*] Reroute for broken boot IRQs                                                     CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS 这是一个对某些芯片组bug(在某些情况下会发送多余的"boot IRQ")的修复功能.开启此选项之后,仅对有此bug的芯片组生效.
                                                                                                                                    要检查哪些芯片组有此bug可以查看"drivers/pci/quirks.c"文件中                                            
   [*] Machine Check / overheating reporting                                            CONFIG_X86_MCE                          MCE(Machine Check Exception)支持.让CPU检测到硬件故障(过热/数据错误)时通知内核,以便内核采取相应的措施
                                                                                                                                    (如显示一条提示信息或关机等).更多信息可以"manmcelog"看看.可以通过"grep mce /proc/cpuinfo"检查CPU是否支持此特性,
                                                                                                                                    若支持建议选中,否则请关闭.当然,如果你对自己的硬件质量很放心,又是桌面系统的话,不选也无所谓.                                            
   [*]   Intel MCE features                                                             CONFIG_X86_MCE_INTEL                    Intel CPU 支持                                            
   [*]   AMD MCE features                                                               CONFIG_X86_MCE_AMD                      AMD CPU 支持                                            
   <M> Machine check injector support                                                   CONFIG_X86_MCE_INJECT                   MCE注入支持,仅用于调试                         
       Performance monitoring  --->    
           <*> Intel uncore performance events                                                                   
           <*> Intel rapl performance events                                                                     
           <*> Intel cstate performance events                                                                   
           < > AMD Processor Power Reporting Mechanism                                                           
   [*] Enable support for 16-bit segments                                                 CONFIG_X86_VSYSCALL_EMULATION           对过时的vsyscall页提供仿真支持.禁用此项大致相当于使用"vsyscall=none"内核引导参数(差别在于当应用程序使用vsyscall时将
                                                                                                                                    直接崩溃(segfault)而不会产生警告消息).许多2013年之前编译的程序(也可能包括某些新近编译的程序)需要使用此特性.                                                                              
   [*] Enable vsyscall emulation                                                                                                    
   <M> Dell i8k legacy laptop support                                                   CONFIG_I8K                              Dell Inspiron 8000 笔记本的 System Management Mode 驱动(i8k).该驱动可以读取CPU温度和风扇转速,进而帮助上层工具控制
                                                                                                                                    风扇转速.该驱动仅针对 Dell Inspiron 8000 笔记本进行过测试,所以不保证一定能适用于其他型号的Dell笔记本.
   [*] CPU microcode loading support                                                    CONFIG_MICROCODE                        CPU的微代码更新支持,建议选中.CPU的微代码更新就像是给CPU打补丁,用于纠正CPU的行为.更新微代码的常规方法是升级BIOS,
                                                                                                                                    但是也可以在Linux启动后更新.比如在Gentoo下,可以使用"emerge microcode-ctl"安装microcode-ctl服务,再把这个服务
                                                                                                                                    加入boot运行级即可在每次开机时自动更新CPU微代码.其他Linux系统可以参考这个帖子.                                                
   [*]   Intel microcode loading support                                                CONFIG_MICROCODE_INTEL                    Intel CPU 微代码支持                                                  
   [*]   AMD microcode loading support                                                  CONFIG_MICROCODE_AMD                    AMD CPU                               
   <M> /dev/cpu/*/msr - Model-specific register support                                 CONFIG_X86_MSR                            允许用户空间的特权进程(使用rdmsr与wrmsr指令)访问x86的MSR寄存器(Model-Specific Register)以访问CPU的很多重要的参数.
                                                                                                                                    MSR是非标准寄存器,主要用于读取CPU的工作状态(频率/电压/功耗/温度/性能等),以及设置CPU的工作参数(触发特定的CPU特性,
                                                                                                                                    依CPU的不同而不同).msrtool工具可以转储出MSR的内容.不确定的可以选"M".                                                 
   <M> /dev/cpu/*/cpuid - CPU information support                                       CONFIG_X86_CPUID                        允许用户空间的特权进程使用CPUID指令获得详细的CPU信息(CPUID):CPU类型,型号,制造商信息,商标信息,序列号,缓存等.不确定的可以选"M".                                                  
   [*] Numa Memory Allocation and Scheduler Support                                     CONFIG_NUMA                             开启 NUMA(Non Uniform Memory Access) 支持.虽然说集成了内存控制器的CPU都属于NUMA架构.但事实上,对于大多数只有一颗物理CPU的
                                                                                                                                    个人电脑而言,即使支持NUMA架构,也没必要开启此特性.可以参考SMP/NUMA/MPP体系结构对比.此外,对于不支持"虚拟NUMA",
                                                                                                                                    或"虚拟NUMA"被禁用的虚拟机(即使所在的物理机是NUMA系统),也应该关闭此项.                                                 
   [*]   Old style AMD Opteron NUMA detection                                           CONFIG_AMD_NUMA                            因为AMD使用一种旧式的方法读取NUMA配置信息(新式方法是CONFIG_X86_64_ACPI_NUMA),所以如果你使用的是AMD多核CPU,建议开启.
                                                                                                                                    不过,即使开启此选项,内核也会优先尝试CONFIG_X86_64_ACPI_NUMA方法,仅在失败后才会使用此方法,
                                                                                                                                    所以即使你不能确定CPU的类型也可以安全的选中此项                                                 
   [*]   ACPI NUMA detection                                                            CONFIG_X86_64_ACPI_NUMA                 使用基于 ACPI SRAT(System Resource Affinity Table) 技术的NUMA节点探测方法.这也是检测NUMA节点信息的首选方法,建议选中.                                
   [ ]   NUMA emulation                                                                 CONFIG_NUMA_EMU                            仅供开发调试使用                                                 
   (6) Maximum NUMA Nodes (as a power of 2)                                             CONFIG_NODES_SHIFT                        允许的最大NUMA节点数.需要注意其计算方法:最大允许节点数=2CONFIG_NODES_SHIFT.也就是说这里设置的值会被当做2的指数使用.
                                                                                                                                    取值范围是[1,10],也就最多允许1024个节点.                                                 
 @ [*] Enable sysfs memory/probe interface                                                                                               
       Memory model (Sparse Memory)  --->                                                                                        内存模式."Sparse Memory"主要用来支持内存热插拔,相比其他两个旧有的内存模式,代码复杂性也比较低,而且还拥有一些性能上的优势,
                                                                                                                                    对某些架构而言是唯一的可选项.其他两个旧有的内存模式是:"Discontiguous Memory"和"Flat Memory".                                                                                
            (X) Sparse Memory
   [*] Sparse Memory virtual memmap                                                      CONFIG_SPARSEMEM_VMEMMAP                对于64位CPU而言,开启此选项可以简化pfn_to_page/page_to_pfn的操作,从而提高内核的运行效率.但是在32位平台则建议关闭.
   [*] Enable to assign a node which has only movable memory                            CONFIG_MOVABLE_NODE                        允许对一个完整的NUMA节点(CPU和对应的内存)进行热插拔.一般的服务器和个人电脑不需要这么高级的特性.                                                 
   [*] Allow for memory hot-add                                                         CONFIG_MEMORY_HOTPLUG                    支持向运行中的系统添加内存.也就是内存热插支持.                                                    
 @ [ ]   Online the newly added memory blocks by default                                                                                    
   [*]   Allow for memory hot remove                                                     CONFIG_MEMORY_HOTREMOVE                    支持从运行中的系统移除内存.也就是内存热拔支持.                                                                                               
   [*] Allow for balloon memory compaction/migration                                    CONFIG_BALLOON_COMPACTION                允许规整/合并泡状内存(balloon memory).内存的Ballooning技术是指虚拟机在运行时动态地调整它所占用的宿主机内存资源,
                                                                                                                                    该技术在节约内存和灵活分配内存方面有明显的优势,目前所有主流虚拟化方案都支持这项技术(前提是客户机操作系统中
                                                                                                                                    必须安装有相应的balloon驱动).由于内存的动态增加和减少会导致内存过度碎片化,特别是对于2M尺寸的连续大内存页
                                                                                                                                    来说更加严重,从而严重降低内存性能.允许balloon内存压缩和迁移可以很好的解决在客户机中使用大内存页时内存过度碎片化问题.
                                                                                                                                    如果你打算在虚拟机中使用大内存页(huge page),那么建议开启,否则建议关闭                                                    
   -*- Allow for memory compaction                                                      CONFIG_COMPACTION                       允许对大内存页(huge pages)进行规整.主要是为了解决大内存页的碎片问题.建议在使用大内存页的情况下开启此项,否则建议关闭.                             
   -*-   Page migration                                                                 CONFIG_MIGRATION                        允许在保持虚拟内存页地址不变的情况下移动其所对应的物理内存页的位置.这主要是为了解决两个问题:
                                                                                                                                    (1)在NUMA系统上,将物理内存转移到相应的节点上,以加快CPU与内存之间的访问速度.(2)在分配大内存页的时候,可以避免碎片问题.                                                    
   [*] Enable bounce buffers                                                            CONFIG_BOUNCE                            为那些不能直接访问所有内存范围的驱动程序开启bounce buffer支持.当CONFIG_ZONE_DMA被开启后,这个选项会被默认开启
                                                                                                                                    (当然,你也可以在这里手动关闭).这主要是为了那些不具备IOMMU功能的PCI/ISA设备而设,但它对性能有些不利影响.
                                                                                                                                    在支持IOMMU的设备上,应该关闭它而是用IOMMU来代替.                                                    
   [*] Enable KSM for page merging                                                      CONFIG_KSM                                KSM(Kernel Samepage Merging)支持:周期性的扫描那些被应用程序标记为"可合并"的地址空间,一旦发现有内容完全相同的页面,
                                                                                                                                    就将它们合并为同一个页面,这样就可以节约内存的使用,但对性能有不利影响.推荐和内核虚拟机KVM(Documentation/vm/ksm.txt)
                                                                                                                                    或者其他支持"MADV_MERGEABLE"特性的应用程序一起使用.KSM并不默认开启,仅在应用程序设置了"MADV_MERGEABLE"标记,
                                                                                                                                    并且 /sys/kernel/mm/ksm/run 被设为"1"的情况下才会生效.                                                    
   (65536) Low address space to protect from user allocation                            CONFIG_DEFAULT_MMAP_MIN_ADDR            2009年,内核曾经爆过一个严重的NULL指针漏洞,由于其根源是将NULL指针映射到地址"0"所致,所以从2.6.32版本以后,
                                                                                                                                    为了防止此类漏洞再次造成严重后果,特别设置了此选项,用于指定受保护的内存低端地址范围(可以在系统运行时通过 
                                                                                                                                    /proc/sys/vm/mmap_min_addr 进行调整),这个范围内的地址禁止任何用户态程序的写入,
                                                                                                                                    以从根本上堵死此类漏洞可能对系统造成的损害.但内核这种强加的限制,对于需要使用vm86系统调用
                                                                                                                                    (用于在保护模式的进程中模拟8086的实模式)或者需要映射此低端地址空间的程序(bitbake,dosemu,qemu,wine,...)来说,
                                                                                                                                    则会造成不兼容,不过目前这些程序的新版本都进行了改进,以适应内核的这种保护.一般情况下,
                                                                                                                                    "4096"是个明智的选择,或者你也可以保持默认值.                                                    
   [*] Enable recovery from hardware memory errors                                      CONFIG_MEMORY_FAILURE                    在具备MCA(Machine Check Architecture)恢复机制的系统上,允许内核在物理内存中的发生数据错误的情况下,
                                                                                                                                    依然坚强的纠正错误并恢复正常运行.这需要有相应的硬件(通常是ECC内存)支持.有ECC内存的选,没有的就别选了.                                                    
   <M>   HWPoison pages injector                                                        CONFIG_HWPOISON_INJECT                    仅用于调试.                                                    
   [*] Transparent Hugepage Support                                                     CONFIG_TRANSPARENT_HUGEPAGE                大多数现代计算机体系结构都支持多种不同的内存页面大小(比如x86_64支持4K和2M以及1G[需要cpu-flags中含有"pdpe1gb"]).
                                                                                                                                    大于4K的内存页被称为"大页"(Hugepage).TLB(页表缓存)是位于CPU内部的分页表(虚拟地址到物理地址的映射表)缓冲区,
                                                                                                                                    既高速又很宝贵(尺寸很小).如果系统内存很大(大于4G)又使用4K的内存页,那么分页表将会变得很大而难以在CPU内缓存,
                                                                                                                                    从而导致较高的TLB不命中概率,进而降低系统的运行效率.开启大内存页支持之后,就可以使用大页(2M或1G),
                                                                                                                                    从而大大缩小分页表的尺寸以大幅提高TLB的命中率,进而优化系统性能.传统上使用大内存页的方法是通过Hugetlbfs
                                                                                                                                    虚拟文件系统(CONFIG_HUGETLBFS),但是hugetlbfs需要专门进行配置以及应用程序的特别支持.所以从2.6.38版本开始
                                                                                                                                    引入了THP(Transparent Hugepages),目标是替代先前的Hugetlbfs虚拟文件系统(CONFIG_HUGETLBFS).THP允许内核在
                                                                                                                                    可能的条件下,透明的(对应用程序来说)使用大页(huge pages)与HugeTLB,THP不像hugetlbfs那样需要专门进行配置
                                                                                                                                    以及应用程序的特别支持.THP将这一切都交给操作系统来完成,也不再需要额外的配置,对于应用程序完全透明,
                                                                                                                                    因而可用于更广泛的应用程序.这对于数据库/KVM等需要使用大量内存的应用来说,可以提升其效能,但对于内存较小
                                                                                                                                    (4G或更少)的个人PC来说就没啥必要了.详见"Documentation/vm/transhuge.txt"文档                                                    
         Transparent Hugepage Support sysfs defaults (always)  --->                                                                设置 /sys/kernel/mm/transparent_hugepage/enabled 文件的默认值."always"表示总是对所有应用程序启用透明大内存页支持,
                                                                                                                                    "madvise"表示仅对明确要求该特性的程序启用.建议选"always".
                (X) always                   
                ( ) madvise   
   [*] Enable cleancache driver to cache clean pages if tmem is present                 CONFIG_CLEANCACHE                       Cleancache是内核VFS层新增的特性,可以被看作是内存页的"Victim Cache"(受害者缓存),当回收内存页时,先不把它清空,
                                                                                                                                    而是把其加入到内核不能直接访问的"transcendent memory"中,这样支持Cleancache的文件系统再次访问这个页时
                                                                                                                                    可以直接从"transcendent memory"加载它,从而减少磁盘IO的损耗.目前只有zcache和XEN支持"transcendent memory",
                                                                                                                                    不过将来会有越来越多的应用支持.开启此项后即使此特性不能得到利用,也仅对性能有微小的影响,所以建议开启.
                                                                                                                                    更多细节请参考"Documentation/vm/cleancache.txt"文件.                             
   [*] Enable frontswap to cache swap pages if tmem is present                          CONFIG_FRONTSWAP                        Frontswap是和Cleancache非常类似的东西,在传统的swap前加一道内存缓冲(同样位于"transcendent memory"中).
                                                                                                                                    目的也是减少swap时的磁盘读写.CONFIG_ZSWAP依赖于它,建议开启.                                                    
   [*] Contiguous Memory Allocator                                                      CONFIG_CMA                              这是一个分配连续物理内存页面的分配器.一些比较低端的DMA设备只能访问连续的物理内存,同时透明大内存页
                                                                                                                                    也需要连续的物理内存.传统的解决办法是在系统启动时,在内存还很充足的时候,先预留一部分连续物理内存页面,
                                                                                                                                    留作后用,但这部分内存就无法被挪作他用了,为了可能的分配需求,预留这么一大块内存,并不是一个明智的方法.
                                                                                                                                    而连续内存分配器(Contiguous Memory Allocator)可以做到允许这部分预留的内存被正常使用,
                                                                                                                                    仅在确实需要的时候才将大块的连续物理内存分配给相应的驱动程序.这个机制对于那些不支持I/O map和scatter-gather
                                                                                                                                    的设备很有作用.详情参见"include/linux/dma-contiguous.h"文件.此选项仅对嵌入式系统有意义,不确定的选"N".                       
 @ [ ]   CMA debug messages (DEVELOPMENT)                                                                                                   
 @ [ ]   CMA debugfs interface                                                                                                              
 @ (7)   Maximum count of the CMA areas                                                                                                    
   [*] Track memory changes                                                             CONFIG_MEM_SOFT_DIRTY                    在内核页表的PTE(Page Table Entry)数据结构上添加一个"soft-dirty"位以追踪内存页内容的变化.此特性基本上专用于CRIU
                                                                                                                                    (Checkpoint/Restore In Userspace)项目(可以帮助容器进行热迁移).不确定的选"N".                                                 
   [*] Compressed cache for swap pages (EXPERIMENTAL)                                   CONFIG_ZSWAP                            ZSWAP是一个放置在swap前面的压缩缓存,它可以将需要换出的页压缩存放在内存中的压缩池里,这样在压缩池没有满的时候,
                                                                                                                                    可以避免使用真正的swap设备.当压缩池满的时候,则把最老的页解压后写入swap设备.压缩池默认是内存总量的20%
                                                                                                                                    (/sys/module/zswap/parameters/max_pool_percent).ZSWAP不仅提升了swap的整体性能,也变相的增加了swap空间.
                                                                                                                                    选中此项后,可以通过"zswap.enabled=1"内核引导参数开启此功能.                                                 
   -*- Common API for compressed memory storage                                         CONFIG_ZPOOL                            通用的内存压缩API,主要用于给zbud(zswap)或zsmalloc提供支持.不确定的选"N",如果内核有其他选项依赖于它会自动选中                                                 
   <*> Low (Up to 2x) density storage for compressed pages                              CONFIG_ZBUD                             专用于zswap内部的低密度内存压缩API,最多允许将两个物理内存页压缩为一个压缩内存页,这既有优势
                                                                                                                                    (简单的空间收集及空闲空间复用)也有劣势(潜在的低内存利用率).
                                                                                                                                    此种算法还能确保压缩后的内存页不会比最初未压缩页数多.不确定的选"N".                    
 @ < > Up to 3x density storage for compressed pages                                                                                    
   <*> Memory allocator for compressed pages                                            CONFIG_ZSMALLOC                            zsmalloc压缩内存分配器主要用于给zram提供支持,建议与CONFIG_ZRAM同开关.参考:3种内存压缩方案对比.                                                                      
   [*]   Use page table mapping to access object in zsmalloc                            CONFIG_PGTABLE_MAPPING                    zsmalloc默认使用基于内存复制的对象映射方法来访问跨越不同页面的区域,但如果某些架构(例如ARM)
                                                                                                                                    执行虚拟内存映射的速度快于内存复制,那么应该将此项选"Y",这将导致zsmalloc使用页表映射
                                                                                                                                    而不是内存复制来进行对象的映射.你可以在你的系统上使用"https://github.com/spartacus06/zsmapbench"
                                                                                                                                    脚本来测试这两种方法的速度差异.在x86_64平台上,Debian8与Fedora22与openSUSE13此项默认为"N",
                                                                                                                                    而Ubuntu15此项默认为"Y",作者本人未测试过哪个更合理.                                                                         
 @ [ ]   Export zsmalloc statistics                                                                                                      
 @ [ ] Defer initialisation of struct pages to kthreads                                                                                  
   [ ] Enable idle page tracking                                                        CONFIG_IDLE_PAGE_TRACKING               此特性跟踪哪些用户页面需要被工作负载使用,哪些用户页面处于闲置状态.此信息(/sys/kernel/mm/page_idle)
                                                                                                                                    可用于确定工作负载需要的用户内存大小.从而帮助调优内存cgroup限制以及决定将此任务放置到集群中的
                                                                                                                                    那台机器上.参见Documentation/vm/idle_page_tracking.txt文档.不确定的选"N".                                  
 @ [ ] Device memory (pmem, etc...) hotplug support                                                                                      
   <*> Support non-standard NVDIMMs and ADR protected memory                            CONFIG_X86_PMEM_LEGACY                    支持 Intel Sandy Bridge-EP 处理器使用的不符合NVDIMM规范的非易失内存(以电容做后备电力且掉电后
                                                                                                                                    不会丢失数据的内存).仅有某些高端服务器才会使用这种外带电容供电的内存.                                                 
   [*] Check for low memory corruption                                                  CONFIG_X86_CHECK_BIOS_CORRUPTION        低位内存脏数据检查,即使开启此选项,默认也不会开启此功能(需要明确使用"memory_corruption_check=1"
                                                                                                                                    内核引导选项).这些脏数据通常被认为是有bug的BIOS引起的,默认每60秒(可以通过memory_corruption_check_period
                                                                                                                                    内核参数进行调整)扫描一次0-64k(可以通过memory_corruption_check_size内核参数进行调整)之间的区域.
                                                                                                                                    这种检查所占用的开销非常小,基本可以忽略不计.如果始终检查到错误,则可以通过"memmap="内核引导参数
                                                                                                                                    来避免使用这段内存.一般没必要选中,如果你对BIOS不放心,带着它试运行一段时间,确认没问题之后再去掉.                                                 
   [*]   Set the default setting of memory_corruption_check                             CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
                                                                                                                                设置memory_corruption_check的默认值,选中表示默认开启(相当于使用"memory_corruption_check=1"内核引导选项),
                                                                                                                                    不选中表示默认关闭.
   (64) Amount of low memory, in kilobytes, to reserve for the BIOS                     CONFIG_X86_RESERVE_LOW                    为BIOS设置保留的低端地址(默认是64K).内存的第一页(4K)存放的必定是BIOS数据,内核不能使用,所以必须要保留.
                                                                                                                                    但是有许多BIOS还会在suspend/resume/热插拔等事件发生的时候使用更多的页(一般在0-64K范围),所以默认
                                                                                                                                    保留0-64K范围.如果你确定自己的BIOS不会越界使用内存的话,可以设为"4",否则请保持默认值.但是也有一些
                                                                                                                                    很奇葩的BIOS会使用更多的低位内存,这种情况下可以考虑设为"640"以保留所有640K的低位内存区域.                                                    
   [*] MTRR (Memory Type Range Register) support                                        CONFIG_MTRR                                MTRR(Memory type range registers)是CPU内的一组MSR(Model-specific registers),其作用是告诉CPU以哪种模式
                                                                                                                                    (write-back/uncachable)存取各内存区段效率最高.这对于AGP/PCI显卡意义重大,因为write-combining技术
                                                                                                                                    可以将若干个总线写传输捆绑成一次较大的写传输操作,可以将图像写操作的性能提高2.5倍或者更多.
                                                                                                                                    这段代码有着通用的接口,其他CPU的寄存器同样能够使用该功能.简而言之,开启此选项是个明智的选择.                                                    
   [*]   MTRR cleanup support                                                           CONFIG_MTRR_SANITIZER                                                                        
   (1)     MTRR cleanup enable value (0-1)                                              CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT    "1"表示默认开启CONFIG_MTRR_SANITIZER特性,相当于使用"enable_mtrr_cleanup","0"表示默认关闭
                                                                                                                                    CONFIG_MTRR_SANITIZER特性,相当于使用"disable_mtrr_cleanup".建议设为"1".                                                    
   (1)     MTRR cleanup spare reg num (0-7)                                             CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
                                                                                                                                这里设定的值等价于使用内核引导参数"mtrr_spare_reg_nr=N"中的"N".也就是告诉内核reg0N可以被清理或改写
                                                                                                                                    (参见"/proc/mtrr"文件).在多数情况下默认值是"1",其含义是 /proc/mtrr 中的 reg01 将会被映射.
                                                                                                                                    一般保持其默认值即可.修改此项的值通常是为了解决某些MTRR故障.
   [*]   x86 PAT support                                                                CONFIG_X86_PAT                            PAT(Page Attribute Table)是对MTRR的补充,且比MTRR更灵活.如果你的CPU支持PAT(grep pat /proc/cpuinfo),
                                                                                                                                    那么建议开启.仅在开启后导致无法正常启动或者显卡驱动不能正常工作的情况下才需要关闭.                                                    
   [*] x86 architectural random number generator                                        CONFIG_ARCH_RANDOM                        Intel 从 Ivy Bridge 微架构开始(对于Atom来说是从Silvermont开始),在CPU中集成了一个高效的硬件随机数生成器
                                                                                                                                    (称为"Bull Mountain"技术),并引入了一个新的x86指令"RDRAND",可以非常高效的产生随机数.
                                                                                                                                    此选项就是对此特性的支持.                                                    
   [*] Supervisor Mode Access Prevention                                                CONFIG_X86_SMAP                            SMAP(Supervisor Mode Access Prevention)是Intel从Haswell微架构开始引入的一种新特征,它在CR4寄存器上引入
                                                                                                                                    一个新标志位SMAP,如果这个标志为1,内核访问用户进程的地址空间时就会触发一个页错误,目的是为了防止内核
                                                                                                                                    因为自身错误意外访问用户空间,这样就可以避免一些内核漏洞所导致的安全问题.但是由于内核在有些时候仍然
                                                                                                                                    需要访问用户空间,因此intel提供了两条指令STAC和CLAC用于临时打开/关闭这个功能,反复使用STAC和CLAC会
                                                                                                                                    带来一些轻微的性能损失,但考虑到增加的安全性,还是建议开启.                                                    
   [*] Intel MPX (Memory Protection Extensions)                                         CONFIG_X86_INTEL_MPX                    Intel MPX(内存保护扩展)是一种用于检测缓冲区溢出bug的硬件特性.此选项并非用于保护内核自身,而是用于允许
                                                                                                                                    应用程序利用MPX特性.可以通过"grep mpx /proc/cpuinfo"检查你的CPU是否支持MPX特性.
                                                                                                                                    详见Documentation/x86/intel_mpx.txt文档.不确定的选"N".                                                    
 @ [*] Intel Memory Protection Keys                                                                                                         
   [*] EFI runtime service support                                                      CONFIG_EFI                                EFI/UEFI支持.如果你打算在UEFI/EFI平台上安装Linux(2010年之后的机器基本都已经是UEFI规格了),那么就必须
                                                                                                                                    开启此项(开启后也依然可以在传统的BIOS机器上启动).UEFI启动流程与传统的BIOS相差很大.虽然Linux受到
                                                                                                                                    了所谓"安全启动"问题的阻挠(已经解决),但是UEFI依然将迅速一统江湖.[提示]在UEFI平台上安装Linux的
                                                                                                                                    关键之一是首先要用一个支持UEFI启动的LiveCD以UEFI模式启动机器.                                                    
   [*]   EFI stub support                                                               CONFIG_EFI_STUB                            EFI stub 支持.如果开启此项,就可以不通过GRUB2之类的引导程序来加载内核,而直接由EFI固件进行加载,
                                                                                                                                    这样就可以不必安装引导程序了.不过这是一个看上去很美的特性,由于EFI固件灵活性比GRUB2差许多,
                                                                                                                                    所以缺点有三:(1)不能在传统的BIOS机器上启动.(2)给内核传递引导参数很麻烦(需要使用"efibootmgr -u").
                                                                                                                                    (3)不能使用intrd.不过,针对后两点的解决办法是:使用CONFIG_CMDLINE和CONFIG_INITRAMFS_SOURCE.
                                                                                                                                    更多细节可参考"Documentation/x86/efi-stub.txt"文档.                                                  
   [*]     EFI mixed-mode support                                                       CONFIG_EFI_MIXED                        允许在32位固件上启动64位内核.选"N".                            
   [*] Enable seccomp to safely compute untrusted bytecode                              CONFIG_SECCOMP                            允许使用SECCOMP技术安全地运算非信任代码.通过使用管道或其他进程可用的通信方式作为文件描述符
                                                                                                                                    (支持读/写调用),就可以利用SECCOMP把这些应用程序隔离在它们自己的地址空间.这是一种有效的
                                                                                                                                    安全沙盒技术.systemd也强烈建议开启它.除非你是嵌入式系统,否则不要关闭.                                                    
       Timer frequency (250 HZ)  --->                                                                                              内核时钟频率.对于要求快速响应的场合,比如桌面环境,建议使用1000Hz,而对于不需要快速响应的
                                                                                                                                    SMP/NUMA服务器,建议使用250Hz或100Hz或300Hz(主要处理多媒体数据).
        ( ) 100 HZ                                                                                                                                       
       (X) 250 HZ                       
       ( ) 300 HZ                     
       ( ) 1000 HZ      
   [*] kexec system call                                                                CONFIG_KEXEC                            提供kexec系统调用,可以不必重启而切换到另一个内核(不一定必须是Linux内核),不过这个特性并不总是那么可靠.
                                                                                                                                    如果你不确定是否需要它,那么就是不需要                                                                            
 @ [*] kexec file based system call                                                                                                         
 @ [*]   Verify kernel signature during kexec_file_load() syscall                                                                           
   [*] kernel crash dumps                                                               CONFIG_CRASH_DUMP                          当内核崩溃时自动导出运行时信息的功能,主要用于调试目的.更多信息请参考"Documentation/kdump/kdump.txt"文件.                                                   
   [*] kexec jump                                                                       CONFIG_KEXEC_JUMP                        kexec jump 支持.这是对CONFIG_KEXEC的增强功能,仅在你确实明白这是干啥的情况下再开启,否则请关闭.                                                    
   (0x1000000) Physical address where the kernel is loaded                              CONFIG_PHYSICAL_START                   加载内核的物理地址.如果内核不是可重定位的(CONFIG_RELOCATABLE=n),那么bzImage会将自己解压到该物理地址并
                                                                                                                                    从此地址开始运行,否则,bzImage将忽略此处设置的值,而从引导装载程序将其装入的物理地址开始运行.
                                                                                                                                    仅在你确实知道自己是在干什么的情况下才可以改变该值,否则请保持默认.                                 
   -*- Build a relocatable kernel                                                       CONFIG_RELOCATABLE                        使内核可以在浮动的物理内存位置加载,主要用于调试目的.仅在你确实知道为什么需要的时候再开启,否则请关闭.                                                    
 @ [*]   Randomize the address of the kernel image (KASLR)                                                                                  
 @ (0x1000000) Alignment value to which kernel should be aligned                                                                            
 @ [*] Randomize the kernel memory sections                                                                                                 
 @ (0xa) Physical memory mapping padding                                                                                                    
   -*- Support for hot-pluggable CPUs                                                   CONFIG_HOTPLUG_CPU                        热插拔CPU支持(通过 /sys/devices/system/cpu 进行控制).                                                    
   [ ]   Set default setting of cpu0_hotpluggable                                       CONFIG_BOOTPARAM_HOTPLUG_CPU0            开启/关闭此项的意思是设置"cpu0_hotpluggable"的默认值为"on/off".开启此项表示默认将CPU0设置为允许热插拔.                                                    
   [ ]   Debug CPU0 hotplug                                                             CONFIG_DEBUG_HOTPLUG_CPU0                仅用于调试目的.                                                    
   [ ] Disable the 32-bit vDSO (needed for glibc 2.3.3)                                 CONFIG_COMPAT_VDSO                        是否将VDSO(Virtual Dynamic Shared Object)映射到旧式的确定性地址.如果Glibc版本大于等于2.3.3选"N",否则就选"Y".                                                    
       vsyscall table for legacy applications (Emulate)  --->                                                                     设置内核引导参数"vsyscall=[native|emulate|none]"的值.对于使用Glibc-2.14以上版本的系统来说,如果不需要使用特别
                                                                                                                                    老旧的静态二进制程序,应该将此项设为"None"以提升性能与安全性
       ( ) Native                         
       (X) Emulate                        
       ( ) None 
   [ ] Built-in kernel command line                                                     CONFIG_CMDLINE_BOOL                        将内核引导参数直接编进来.在无法向内核传递引导参数的情况下(比如在嵌入式系统上,或者想使用 EFI stub kernel),
                                                                                                                                    这就是唯一的救命稻草了.如果你使用grub之类的引导管理器,那么就可以不需要此特性.                                                    
   [*] Enable the LDT (local descriptor table)                                          CONFIG_MODIFY_LDT_SYSCALL               Linux允许用户空间的应用程序使用modify_ldt(2)系统调用针对每个CPU安装Local Descriptor Table (LDT).
                                                                                                                                    某些老旧的程序或者运行在DOSEMU/Wine中的程序需要使用此接口.不确定的选"N"(尤其是嵌入式系统与服务器).                                     
 @ [*] Kernel Live Patching                  

                            选项                                          |                   配置名                  |                    内容
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  [*] Suspend to RAM and standby                                                          CONFIG_SUSPEND                            "休眠到内存"(ACPI S3)支持.也就是系统休眠后,除了内存之外,其他所有部件都停止工作,重开机之后可以直接从内存中
                                                                                                                                        恢复运行状态.要使用此功能,你需要执行"echo mem > /sys/power/state"命令,还需要在BIOS中开启S3支持,否则可能会有问题.                         
@ [ ]   Skip kernels sys_sync() on suspend to RAM/standby                                                                                 
  [*] Hibernation (aka 'suspend to disk')                                                 CONFIG_HIBERNATION                        "休眠到硬盘"(ACPI S4)支持.也就是将内存的内容保存到硬盘(hibernation),所有部件全都停止工作.要使用此功能,你首先需要使用
                                                                                                                                        内核引导参数"resume=/dev/swappartition",然后执行"echo disk > /sys/power/state"命令.如果你不想从先前的休眠状态中
                                                                                                                                        恢复,那么可以使用"noresume"内核引导参数.更多信息,可以参考"Documentation/power/swsusp.txt"文件.                                                   
  ()  Default resume partition                                                            CONFIG_PM_STD_PARTITION                    默认的休眠分区.这个分区必须是swap分区.不过这里设置的值会被明确的内核引导参数中的值覆盖.                                                  
  [ ] Opportunistic sleep                                                                 CONFIG_PM_AUTOSLEEP                        这是一种从安卓借鉴过来的休眠方式.这个特性在安卓系统上被称为"suspend blockers"或"wakelocks".这是一种更激进的电源管理模式,
                                                                                                                                        以尽可能节约电力为目的.系统默认就处于休眠状态,仅为内存和少数唤醒系统所必须的设备供电,当有任务(唤醒源)需要运行的时候
                                                                                                                                        才唤醒相关组件工作,工作完成后又立即进入休眠状态.不过这些特性需要相应的设备驱动程序的支持.目前除了安卓设备,在PC和
                                                                                                                                        服务器领域,能够利用此特性的驱动还比较少,不过这是一项非常有前途的电源技术,喜欢尝鲜的可以考虑开启.                                                  
  [*] User space wakeup sources interface                                                 CONFIG_PM_WAKELOCKS                        允许用户空间的程序通过sys文件系统接口,创建/激活/撤销系统的"唤醒源".需要与CONFIG_PM_AUTOSLEEP配合使用.                                                  
  (100) Maximum number of user space wakeup sources (0 = no limit)                        CONFIG_PM_WAKELOCKS_LIMIT                    用户空间程序允许使用的"唤醒源"数量,"0"表示无限,最大值是"100000".                                                  
  [*]   Garbage collector for user space wakeup sources                                   CONFIG_PM_WAKELOCKS_GC                    对"唤醒源"对象使用垃圾回收.主要用于调试目的和Android环境.                                                  
  -*- Device power management core functionality                                          CONFIG_PM                                    允许IO设备(比如硬盘/网卡/声卡)在系统运行时进入省电模式,并可在收到(硬件或驱动产生的)唤醒信号后恢复正常.
                                                                                                                                        此功能通常需要硬件的支持.建议在笔记本/嵌入式等需要节约电力的设备上选"Y".                                                  
  [*]   Power Management Debug Support                                                    CONFIG_PM_DEBUG                            仅供调试使用

@ [*]     Extra PM attributes in sysfs for low-level debugging/testing                                                                      
@ [ ]     Test suspend/resume and wakealarm during bootup                                                                                   
@ [ ]     Device suspend/resume watchdog                                                                                                    
@ [*] Suspend/resume event tracing                                                                                                          
  [*] Enable workqueue power-efficient mode by default                                    CONFIG_WQ_POWER_EFFICIENT_DEFAULT         因为"per-cpu workqueue"的缓存更靠近对应的CPU,所以它比"unbound workqueue"拥有更好的性能,但另一方面"per-cpu workqueue"
                                                                                                                                        通常又比"unbound workqueue"需要消耗更多的电能.选中此项表示默认开启"workqueue.power_efficient"内核引导参数,以使用
                                                                                                                                        "unbound workqueue"而不是"per-cpu workqueue"以降低功耗,但是性能会有微小的损失.                                        
  -*- ACPI (Advanced Configuration and Power Interface) Support  --->   
        --- ACPI (Advanced Configuration and Power Interface) Support                     CONFIG_ACPI                               高级配置与电源接口(Advanced Configuration and Power Interface)包括了软件和硬件方面的规范,目前已被软硬件厂商广泛支持,
                                                                                                                                        并且取代了许多过去的配置与电源管理接口,包括 PnP BIOS (Plug-and-Play BIOS), MPS(CONFIG_X86_MPPARSE), 
                                                                                                                                        APM(Advanced Power Management) 等.总之,ACPI已经成为x86平台必不可少的组件,如果你没有特别的理由,务必选中此项.                                                              
        [ ]   AML debugger interface                                                      CONFIG_ACPI_DEBUGGER                        仅供调试使用                                                                                             
        [ ]   Deprecated power /proc/acpi directories                                     CONFIG_ACPI_PROCFS_POWER                    过时的 /proc/acpi 接口支持,建议关闭.                                                                                             
        [*]   Allow supported ACPI revision to be overriden                               CONFIG_ACPI_REV_OVERRIDE_POSSIBLE            某些笔记本固件会根据操作系统支持的ACPI版本决定硬件的工作模式.例如 Dell XPS 13 (2015) 期望操作系统支持"ACPI v5"规范,
                                                                                                                                        但Linux实际上只支持"ACPI v4"规范,此时固件会将声卡的工作模式从HDA模式(Linux支持此模式,且为首选模式)转换成I2S模式
                                                                                                                                        (次选模式).选中此项后,将强制Linux内核哄骗固件说它支持"ACPI v5"规范,相当于使用了"acpi_rev_override"内核引导参数.                                                                                             
        <M>   EC read/write access through /sys/kernel/debug/ec                           CONFIG_ACPI_EC_DEBUGFS                    仅供调试使用.                                                                                             
        <*>   AC Adapter                                                                  CONFIG_ACPI_AC                            允许在外接交流电源和内置电池之间进行切换.                                                                                             
        <*>   Battery                                                                     CONFIG_ACPI_BATTERY                        允许通过 /proc/acpi/battery 接口查看电池信息.                                                                                             
        {*}   Button                                                                      CONFIG_ACPI_BUTTON                        允许守护进程通过 /proc/acpi/event 接口捕获power/sleep/lid(合上笔记本)按钮事件,并执行相应的动作,
                                                                                                                                        软关机(poweroff)也需要它的支持.                                                                                             
        {M}   Video                                                                       CONFIG_ACPI_VIDEO                            对主板上的集成显卡提供ACPI支持.注意:仅支持集成显卡.                                                                                             
        {*}   Fan                                                                         CONFIG_ACPI_FAN                            允许用户层的程序对风扇进行控制(开/关/查询状态)                                                                                             
        [*]   Dock                                                                        CONFIG_ACPI_DOCK                            支持兼容ACPI规范的扩展坞(比如 IBM Ultrabay 和 Dell Module Bay)支持.                                                                                             
        -*-   Processor                                                                   CONFIG_ACPI_PROCESSOR                        在支持 ACPI C2/C3 的CPU上,将ACPI安装为idle处理程序.有几种CPU频率调节驱动依赖于它.而且目前的CPU都已经支持ACPI规范,
                                                                                                                                        建议开启此项.                                                                                             
        <M>   IPMI                                                                        CONFIG_ACPI_IPMI                            允许ACPI使用IPMI(智能平台管理接口)的请求/应答消息访问BMC(主板管理控制器).IPMI通常出现在服务器中,以允许通过诸如
                                                                                                                                        ipmitool这样的工具监视服务器的物理健康特征(温度/电压/风扇状态/电源状态).                                                                                             
        <M>   Processor Aggregator                                                        CONFIG_ACPI_PROCESSOR_AGGREGATOR            支持 ACPI 4.0 加入的处理器聚合器(processor Aggregator)功能,以允许操作系统对系统中所有的CPU进行统一的配置和控制.
                                                                                                                                        目前只支持逻辑处理器(也就是利用Intel超线程技术虚拟出来的CPU)idling功能,其目标是降低耗电量.不确定的应该选"N".
                                                                                                                                        在某些服务器上此驱动(acpi_pad)可能与BIOS中的节能功能冲突                                                                                             
        <*>   Thermal Zone                                                                CONFIG_ACPI_THERMAL                        ACPI thermal zone 支持.系统温度过高时可以及时调整风扇的工作状态以避免你的CPU被烧毁.
                                                                                                                                        目前所有CPU都支持此特性.务必开启.参见CONFIG_THERMAL选项.                                                                                             
        -*-   NUMA support                                                                CONFIG_ACPI_NUMA                            通过读取系统固件中的ACPI表,获得NUMA系统的CPU及物理内存分布信息.NUMA系统必选.                                                                                             
        ()    Custom DSDT Table file to include                                           CONFIG_ACPI_CUSTOM_DSDT_FILE                允许将一个定制过的DSDT编译进内核.详情参见"Documentation/acpi/dsdt-override.txt"文档.看不懂的请保持空白.                                                                                             
        [*]   Allow upgrading ACPI tables via initrd                                      CONFIG_ACPI_TABLE_UPGRADE                 允许initrd更改 ACPI tables 中的任意内容. ACPI tables 是BIOS提供给OS的硬件配置数据,包括系统硬件的电源管理和配置管理.
                                                                                                                                        详情参见"Documentation/acpi/initrd_table_override.txt"文件.                                                                            
        [ ]   Debug Statements                                                            CONFIG_ACPI_DEBUG                            详细的ACPI调试信息,不搞开发就别选.                                                                                             
        [*]   PCI slot detection driver                                                   CONFIG_ACPI_PCI_SLOT                        将每个PCI插槽都作为一个单独的条目列在 /sys/bus/pci/slots/ 目录中,有助于将设备的物理插槽位置与逻辑的PCI总线地址进行对应.
                                                                                                                                        不确定的选"No".                                                                                             
        [*]   Power Management Timer Support                                              CONFIG_X86_PM_TIMER                        ACPI PM Timer,简称"ACPI Timer",是一种集成在主板上的硬件时钟发生器,提供3.579545MHz固定频率.这是比较传统的硬件时钟发生器
                                                                                                                                        (HPET则是比较新型的硬件时钟发生器),目前所有的主板都支持,而且是ACPI规范不可分割的部分.除非你确定不需要,否则必选.                                                                                             
        -*-   Container and Module Devices                                                CONFIG_ACPI_CONTAINER                        支持 NUMA节点/CPU/内存 的热插拔. Device ID: ACPI0004, PNP0A05, PNP0A06 
                                                                                                                                        (find /sys/devices/ -name "PNP0A0[56]*" -or -name "ACPI0004*")                                                                                             
        [*]   Memory Hotplug                                                              CONFIG_ACPI_HOTPLUG_MEMORY                内存热插拔支持. Device ID: PNP0C80 (find /sys/devices/ -name "PNP0C80*")                                                                                             
        <M>   Smart Battery System                                                        CONFIG_ACPI_SBS                            智能电池系统(Smart Battery System)可以让笔记型电脑显示及管理详细精确的电池状态信息.使用锂电池的笔记本电脑必备利器.
                                                                                                                                        但遗憾的是并不是所有笔记本都支持这项特性.                                                                                             
        -*-   Hardware Error Device                                                       CONFIG_ACPI_HED                            Hardware Error Device (Device ID: PNP0C33) 能够通过 SCI 报告一些硬件错误(通常是已经被纠正的错误).如果你的系统中有设备ID
                                                                                                                                        为"PNP0C33"的设备(find /sys/devices/ -name "PNP0C33*"),那么就选上.                                                                                             
        < >   Allow ACPI methods to be inserted/replaced at run time                      CONFIG_ACPI_CUSTOM_METHOD                    允许在不断电的情况下直接对ACPI的功能进行删改,包含一定危险性,它允许root任意修改内存中内核空间的内容.仅用于调试.                                                                                             
        [*]   Boottime Graphics Resource Table support                                    CONFIG_ACPI_BGRT                            在 /sys/firmware/acpi/bgrt/ 中显示 ACPI Boottime Graphics Resource Table ,以允许操作系统获取固件中的启动画面(splash).                                                                                             
        [ ]   Hardware-reduced ACPI support only                                          CONFIG_ACPI_REDUCED_HARDWARE_ONLY            以"reduced hardware"模式编译内核的ACPI代码,从而获得体积更小的内核但仅能运行在ACPI "reduced hardware"模式的硬件上.
                                                                                                                                        不确定的选"N".                                                                                             
        <M>   ACPI NVDIMM Firmware Interface Table (NFIT)                                 CONFIG_ACPI_NFIT                            非易失性内存(NVDIMM)支持.此种内存使用超级电容作为后备电力,并且使用非挥发性的flash存储介质来保存数据,以使数据
                                                                                                                                        能够在掉电之后依然保存.这是一种很有前途的技术,但是目前笔记本与普通服务器并不使用这种内存.                                                                                             
      @ [ ]     NFIT DSM debug                                                                                                                                                         
        [*]   ACPI Platform Error Interface (APEI)                                        CONFIG_ACPI_APEI                            高级平台错误接口(ACPI Platform Error Interface)是RAS(Reliability, Availability and Serviceability)的一部分,
                                                                                                                                        是定义在 ACPI 4.0 规范中的一个面向硬件错误管理的接口,主要是为了统一 firmware/BIOS 和 OS 之间的错误交互机制,
                                                                                                                                        使用标准的错误接口进行管理,同时也扩展了错误接口的内容以便实现更加灵活丰富的功能                                                                                             
        [*]     APEI Generic Hardware Error Source                                        CONFIG_ACPI_APEI_GHES                        "Firmware First Mode"支持.由于BIOS/FIRMWARE是平台相关的,因此BIOS/FIRMWARE比OS更清楚硬件平台的配置情况,
                                                                                                                                        甚至包含各种必须的修正/定制/优化.这样,在"Firmware First"模式下,BIOS/FIRMWARE利用这一优势,可以有针对性的
                                                                                                                                        对发生的硬件错误进行分析/处理/分发,也可以更准确的记录错误的现场信息.这样,不但对硬件错误可以做出更准确,
                                                                                                                                        更复杂的处理,而且可以降低OS的复杂性和冗余度.建议开启.                                                                                             
        [*]     APEI PCIe AER logging/recovering support                                  CONFIG_ACPI_APEI_PCIEAER                    让 PCIe AER errors 首先通过 APEI firmware 进行报告.                                                                                             
        [*]     APEI memory error recovering support                                      CONFIG_ACPI_APEI_MEMORY_FAILURE           让 Memory errors 首先通过 APEI firmware 进行报告.                                                                                  
        <M>     APEI Error INJection (EINJ)                                               CONFIG_ACPI_APEI_EINJ                     仅供调试使用.                                                                       
        < >     APEI Error Record Serialization Table (ERST) Debug Support                CONFIG_ACPI_APEI_ERST_DEBUG               仅供调试使用.                                                                              
      @ < >   DPTF Platform Power Participant     
        <M>   Extended Error Log support                                                  CONFIG_ACPI_EXTLOG                          服务器CPU一般都会在非核心寄存器中记录比CONFIG_X86_MCE故障更详细的额外信息,诸如PFA(Predictive Failure Analysis)
                                                                                                                                        之类的故障预警系统需要收集这些信息.但由于这些非核心寄存器的位置差别很大没有统一标准,系统软件难以直接读取
                                                                                                                                        这些扩展的错误信息.此驱动可以在MCE或CMCI机制之外,将系统固件提供的这些额外扩展错误信息导出到用户空间.不确定的选"N".
        [ ]   PMIC (Power Management Integrated Circuit) operation region support  ----   CONFIG_PMIC_OPREGION                        电源管理芯片(PMIC)支持.此种芯片常用于以电池作为电源的嵌入式装置.          
      @ < >   ACPI configfs support 
  [*] SFI (Simple Firmware Interface) Support  ----                                       CONFIG_SFI                                简单固件接口规范(Simple Firmware Interface)使用一种轻量级的简单方法(通过内存中的一张静态表格)从firmware向操作系统传递信息.
                                                                                                                                        目前这个规范仅用于第二代 Intel Atom 平台,其核心名称是"Moorestown".                  
      CPU Frequency scaling  --->    
            [*] CPU Frequency scaling                                                     CONFIG_CPU_FREQ                            CPUfreq子系统允许动态改变CPU主频,达到省电和降温的目的.现如今的CPU都已经支持动态频率调整,建议开启.
                                                                                                                                        不过,如果你是为虚拟机编译内核,就没有必要开启了,由宿主机内核去控制就OK了.                                            
            [*]   CPU frequency transition statistics                                     CONFIG_CPU_FREQ_STAT                      通过sysfs文件系统输出CPU频率变化的统计信息                      
            [*]     CPU frequency transition statistics details                           CONFIG_CPU_FREQ_STAT_DETAILS              输出更详细的CPU频率变化统计信息                             
                  Default CPUFreq governor (performance)  --->                                                                         默认的CPU频率调节策略.不同策略拥有不同的调节效果.
                        (X) performance                                                                                               
                        ( ) powersave                                                                                                                                  
                        ( ) userspace     
                        ( ) ondemand 
                        ( ) conservative                                                                                                
                      @ ( ) schedutil                                                     
            -*-   'performance' governor                                                  CONFIG_CPU_FREQ_GOV_PERFORMANCE            '性能'优先,静态的将频率设置为cpu支持的最高频率.最耗电,发热量最大,性能/效率比最低.不建议使用.                                            
            <*>   'powersave' governor                                                    CONFIG_CPU_FREQ_GOV_POWERSAVE             '节能'优先,静态的将频率设置为cpu支持的最低频率,严重影响性能.此调控器事实上并不能节省电能,  
                                                                                                                                        因为系统需要花更长的时间才能进入空闲状态(C1E,C3,C6).不建议使用.
            <*>   'userspace' governor for userspace frequency scaling                    CONFIG_CPU_FREQ_GOV_USERSPACE             既允许手动调整cpu频率,也允许用户空间的程序动态的调整cpu频率(需要额外的调频软件).比较麻烦,不建议使用.                                
            <*>   'ondemand' cpufreq policy governor                                      CONFIG_CPU_FREQ_GOV_ONDEMAND              '随需应变',内核周期性的考察CPU负载,当CPU负载超过/低于设定的百分比阈值(/sys/devices/system/cpu/cpufreq/ondemand/up_threshold)时,
                                                                                                                                        就自动将cpu频率设为最高/最低值(也就是仅在最高和最低频率间切换),比较适合台式机.[优化建议]将"up_threshold"设为95左右,
                                                                                                                                        可以获得更高的"性能/瓦特"比.                                                                           
            <*>   'conservative' cpufreq governor                                            CONFIG_CPU_FREQ_GOV_CONSERVATIVE            '保守',和'ondemand'相似,内核同样周期性的考察CPU负载,但是频率的升降是渐变式的(通常只在相邻的两档频率间切换,但具体取决于                                            
                                                                                                                                        "/sys/devices/system/cpu/cpufreq/conservative/freq_step"的百分比设置,设为"100"则等价于仅允许在最高和最低频率间切换):                                            
                                                                                                                                        当CPU负载超过百分比上限(/sys/devices/system/cpu/cpufreq/conservative/up_threshold)时,就自动提升一档CPU频率;                                            
                                                                                                                                        当CPU负载低于百分比下限(/sys/devices/system/cpu/cpufreq/conservative/down_threshold)时,就自动降低一档CPU频率.                                            
                                                                                                                                        更适合用于笔记本/PDA/x86_64环境.[优化建议]'conservative'在默认设置下的"性能/瓦特"比通常不如'ondemand'优秀,                                            
                                                                                                                                        但是优化设置之后情况则可能反转.例如,在"down_threshold=93,up_threshold=97"的情况下,可以比"up_threshold=95"的'ondemand'略有优势.                                             
          @ [ ]   'schedutil' cpufreq policy governor        
                  *** CPU frequency scaling drivers ***      
            [*]   Intel P state control                                                    CONFIG_X86_INTEL_PSTATE                    此驱动是专用于Intel的"Sandy Bridge"/"Ivy Bridge"/"Haswell"或更新CPU微架构的首选驱动,可以更好的支持"Turbo Boost 2.0"技术.
            <*>   Processor Clocking Control interface driver                             CONFIG_X86_PCC_CPUFREQ                    PCC(Processor Clocking Control)接口支持.此种接口仅对某些HP Proliant系列服务器有意义.
                                                                                                                                        更多细节可以参考"Documentation/cpu-freq/pcc-cpufreq.txt"文件.                         
            <*>   ACPI Processor P-States driver                                          CONFIG_X86_ACPI_CPUFREQ                    此驱动同时支持Intel和AMD的CPU,这是较老的intel cpu与非intel cpu首选的驱动(除非你的CPU是古董级别).
                                                                                                                                        注意:对于可以使用P-state驱动的Intel CPU来说,应该选"N"                                                                                                                                        
            [*]     Legacy cpb sysfs knob support for AMD CPUs                            CONFIG_X86_ACPI_CPUFREQ_CPB               为了兼容旧的用户空间程序而设置,建议关闭.                                                                           
            <*>   AMD Opteron/Athlon64 PowerNow!                                          CONFIG_X86_POWERNOW_K8                    过时的驱动,仅为老旧的K8核心的AMD处理器提供支持.K10以及更新的CPU应该使用                                                                                           
            <M>   AMD frequency sensitivity feedback powersave bias                       CONFIG_X86_AMD_FREQ_SENSITIVITY            如果你使用 AMD Family 16h 或者更高级别的处理器,同时又使用"ondemand"频率调节器,
                                                                                                                                        开启此项可以更有效的进行频率调节(在保证性能的前提下更节能).                                                                                           
            <*>   Intel Enhanced SpeedStep (deprecated)                                   CONFIG_X86_SPEEDSTEP_CENTRINO                已被时代抛弃的驱动,仅对老旧的迅驰平台 Intel Pentium M 或者 Intel Xeons 处理器有意义.                                                                                           
            <M>   Intel Pentium 4 clock modulation                                        CONFIG_X86_P4_CLOCKMOD                    已被时代抛弃的驱动,仅对支持老旧的Speedstep技术的 Intel Pentium 4 / XEON 处理器有意义.而且即便是在这样的CPU上,
                                                                                                                                        因为种种兼容性问题可能导致的不稳定,也不建议开启.                                                                                           
                  *** shared options ***                                                                                              
      CPU Idle  --->     
            *- CPU idle PM support                                                        CONFIG_CPU_IDLE                            CPU idle 指令支持,该指令可以让CPU在空闲时"打盹"以节约电力和减少发热.只要是支持ACPI的CPU就应该开启.由于所有64位CPU都已支持ACPI,
                                                                                                                                        所以不必犹豫,开启![提示]为虚拟机编译的内核就没有必要开启了,由宿主机内核去控制就OK了.             
          @ [*]   Ladder governor (for periodic timer tick)                                            
          @ -*-   Menu governor (for tickless system)   
  [*] Cpuidle Driver for Intel Processors                                                 CONFIG_INTEL_IDLE                            专用于Intel CPU的cpuidle驱动.而CONFIG_CPU_IDLE则可用于非Intel的CPU.                                            
      Memory power savings  --->   
            <M> Intel chipset idle memory power saving driver                               CONFIG_I7300_IDLE                            在某些具备内存节能特性的intel服务器芯片组上,让内存也可以在空闲时通过idle指令"打盹".这些芯片组必须具备 I/O AT 支持(例如 Intel 7300).
                                                                                                                                        同时内存也需要支持此特性.                            

    选项                           |                   配置名                  |                    内容
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -*- Kernel support for ELF binaries                                   CONFIG_BINFMT_ELF                           ELF是最常用的跨平台二进制文件格式,支持动态连接,支持不同的硬件平台,支持不同的操作系统.必选,除非你知道自己在做什么
  [*] Write ELF core dumps with partial segments                        CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS        如果你打算在此Linux上开发应用程序或者帮助别人调试bug,那么就选"Y",否则选"N".注意这里的调试和开发不是指内核调试和开发,
                                                                                                                        是应用程序的调试和开发.                     
  <*> Kernel support for scripts starting with #!                       CONFIG_BINFMT_SCRIPT                        支持以"#!/path/to/interpreter"行开头的脚本.务必"Y",不要"M"或"N",除非你知道自己在做什么.                     
  <M> Kernel support for MISC binaries                                  CONFIG_BINFMT_MISC                            允许插入二进制封装层到内核中,运行Java,.NET(Mono-based),Python,Emacs-Lisp等语言编译的二进制程序时需要它,DOSEMU也需要它.
                                                                                                                        想要更方便的使用此特性,你还需要使用"mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc"挂载binfmt_misc伪
                                                                                                                        文件系统.具体详情可以参考"Documentation/binfmt_misc.txt"文档.                     
  [*] Enable core dump support                                          CONFIG_COREDUMP                                核心转储(core dump)支持.如果你打算在此Linux上开发应用程序或者帮助别人调试bug,那么就选"Y",否则选"N".注意这里的调试和
                                                                                                                        开发不是指内核调试和开发,是应用程序的调试和开发.                     
  [*] IA32 Emulation                                                    CONFIG_IA32_EMULATION                        允许在64位内核中运行32位代码.除非你打算使用纯64位环境,否则请开启此项.提示:GRUB2支持引导纯64位内核,但是GRUB不支持.                     
  < >   IA32 a.out support                                              CONFIG_IA32_AOUT                            早期UNIX系统的可执行文件格式(32位),目前已经被ELF格式取代.除非你需要使用古董级的二进制程序.否则请关闭.                     
  [*] x32 ABI for 64-bit mode                                             CONFIG_X86_X32                                允许32位程序使用完整的64位寄存器,以减小内存占用(memory footprint).这可以提高32位程序的运行性能.如果你使用binutils-2.22
                                                                                          
                                选项                                               |                   配置名                  |                    内容
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   <*> Packet socket                                                                        CONFIG_PACKET                            链路层PF_PACKET套接字支持.可以让应用程序(比如:抓包工具tcpdump,DHCP客户端dhclient,WiFi设置工具wpa_supplicant)
                                                                                                                                        直接与网络设备通讯,而无需使用内核中的其它中介协议.不确定的选"Y"或"M".                                                                       
   <M>   Packet: sockets monitoring interface                                               CONFIG_PACKET_DIAG                      PF_PACKET套接字监控接口,ss这样的诊断工具需要它.                                         
   <*> Unix domain sockets                                                                  CONFIG_UNIX                             Unix domain sockets 支持.许多程序都使用它在操作系统内部进行进程间通信(IPC),比如: X Window, syslog, udev 等等.
                                                                                                                                        选"Y",除非你确实知道自己在做什么.                                  
   <M>   UNIX: socket monitoring interface                                                  CONFIG_UNIX_DIAG                        CONFIG_UNIX_DIAG                                                               
   <M> Transformation user configuration interface                                          CONFIG_XFRM_USER                        为IPsec相关的工具提供Transformation(XFRM)用户配置接口                                                               
   [ ] Transformation sub policy support                                                    CONFIG_XFRM_SUB_POLICY                    XFRM子策略支持,不确定的选"N".                                                               
   [ ] Transformation migrate database                                                      CONFIG_XFRM_MIGRATE                        用于动态的更新 IPsec SA(security association) 的定位器(locator).这个特性对于手机这类移动设备来讲至关重要,
                                                                                                                                        因为它需要在不同的基站之间迁移.不确定的选"N".                                                               
   [*] Transformation statistics                                                            CONFIG_XFRM_STATISTICS                  转换统计,这不是SNMP/MIB规范的内容.用于调试目的.不确定的选"N".                                             
   <M> PF_KEY sockets                                                                       CONFIG_NET_KEY                          PF_KEYv2 套接字支持(与KAME兼容).PF_KEY协议族主要用来处理SA(安全关联),对SADB(SA数据库)进行管理,
                                                                                                                                        主要用在IPsec协议中.PF_KEY_v2的编程API在RFC2367中定义.                                     
   [ ]   PF_KEY MIGRATE                                                                     CONFIG_NET_KEY_MIGRATE                  向PF_KEYv2套接字中添加一个 PF_KEY MIGRATE 消息. PF_KEY MIGRATE 消息可用于动态的更新 IPsec SA(security association) 
                                                                                                                                        的定位器(locator).这个特性对于手机这类移动设备来讲至关重要,因为它需要在不同的基站之间迁移.不确定的选"N".                                             
   [*] TCP/IP networking                                                                    CONFIG_INET                             TCP/IP协议,必选!
   [*]   IP: multicasting                                                                   CONFIG_IP_MULTICAST                        IP多播(IP multicasting)支持.指的是一个发送者向一组特定的接收者发送数据,但只需发送一份数据副本.实际应用的场合很少,                                                
                                                                                                                                        MBONE算是其中之一,与RTP等音视频协议相结合也算一种.不确定的选"N".     
   [*]   IP: advanced router                                                                CONFIG_IP_ADVANCED_ROUTER                高级路由支持,需要开启内核的IP转发功能(echo 1 > /proc/sys/net/ipv4/ip_forward)才能正常工作.如果这个Linux系统用作
                                                                                                                                        专业的路由器就选上,选上之后还需要按需选择其下的子项.一般的主机不需要这个.                                                                                                                           
   [*]     FIB TRIE statistics                                                              CONFIG_IP_FIB_TRIE_STATS                主要用于测试TRIE性能                                                               
   [*]     IP: policy routing                                                               CONFIG_IP_MULTIPLE_TABLES                策略路由                                                               
   [*]     IP: equal cost multipath                                                         CONFIG_IP_ROUTE_MULTIPATH                用于基于目的地址的负载均衡                                                               
   [*]     IP: verbose route monitoring                                                     CONFIG_IP_ROUTE_VERBOSE                    显示冗余的路由监控信息                                                               
   [*]   IP: kernel level autoconfiguration                                                 CONFIG_IP_PNP                           在内核启动时自动配置网卡的ip地址/路由表,配置信息来自于以下途径:内核引导参数,自举协议(BOOTP),反向地址转换协议(RARP),
                                                                                                                                        动态主机配置协议(DHCP).通常,需要从网络启动的无盘工作站才需要这个东西(此时还需要开启CONFIG_ROOT_NFS),一般的发行版
                                                                                                                                        都通过启动脚本(dhcpcd/dhclient/ifconfig)配置网络.不确定的选"N".                                    
   [*]     IP: DHCP support                                                                 CONFIG_IP_PNP_DHCP                        DHCP协议支持                                                               
   [ ]     IP: BOOTP support                                                                CONFIG_IP_PNP_BOOTP                        BOOTP协议支持                                                               
   [ ]     IP: RARP support                                                                 CONFIG_IP_PNP_RARP                        RARP协议支持                                                               
   <M>   IP: tunneling                                                                      CONFIG_NET_IPIP                         IP隧道,主要目的是为了在TCP/IP网络中传输其他协议的数据包,当然也包括IP数据包(例如用于实现VPN).                                     
   <M>   IP: GRE demultiplexer                                                              CONFIG_NET_IPGRE_DEMUX                  GRE demultiplexer 支持.被CONFIG_NET_IPGRE和CONFIG_PPTP所依赖.                                             
   <M>   IP: GRE tunnels over IP                                                            CONFIG_NET_IPGRE                        基于IP的通用路由封装(Generic Routing Encapsulation)隧道支持.该驱动主要用于对端是Cisco路由器的场合,因为Cisco的路由器
                                                                                                                                        特别偏好GRE隧道(而不是CONFIG_NET_IPIP),并且GRE还允许通过隧道对组播进行再分发.                                       
   [*]     IP: broadcast GRE over IP                                                        CONFIG_NET_IPGRE_BROADCAST              GRE/IP的一种应用是构建一个广播WAN(Wide Area Network),而其看上去却很像一个跑在互联网上的LAN(Local Area Network).
                                                                                                                                        如果你想要创建这样的网络,那么就选"Y"(还要加上CONFIG_IP_MROUTE).                                                
   [*]   IP: multicast routing                                                              CONFIG_IP_MROUTE                        组播路由支持.实际应用的场合很少,MBONE算是其中之一,不确定的选"N".                                       
   [ ]     IP: multicast policy routing                                                     CONFIG_IP_MROUTE_MULTIPLE_TABLES        通常,组播路由器上会运行一个单独的用户态守护进程,根据源地址和目的地址来处理数据包.开启此项后,将能同时考虑数据包所带的标记
                                                                                                                                        (mark)和所通过的网络接口,并可在用户空间同时运行多个守护进程,每一个进程处理一张路由表.                                                               
   [*]     IP: PIM-SM version 1 support                                                     CONFIG_IP_PIMSM_V1                      Sparse Mode PIM (Protocol Independent Multicast) version 1 支持. 该协议被Cisco路由器广泛支持,你需要特定的软件(pimd-v1)才能使用它.                                         
   [*]     IP: PIM-SM version 2 support                                                     CONFIG_IP_PIMSM_V2                      Sparse Mode PIM (Protocol Independent Multicast) version 2 支持. 该协议的使用并不广泛,你需要特定的软件(pimd 或 gated-5)才能使用它.                                         
   -*-   IP: TCP syncookie support                                                          CONFIG_SYN_COOKIES                      TCP syncookie 支持,这是抵抗SYN flood攻击的好东西.此特性的开关可以通过"/proc/sys/net/ipv4/tcp_syncookies"文件控制,
                                                                                                                                        写入"1"表示开启,写入"0"表示关闭.建议服务器环境开启此项                                         
   <M>   Virtual (secure) IP: tunneling                                                     CONFIG_NET_IPVTI                        虚拟IP隧道.可以和xfrm隧道一起使用,以实现IPSEC安全隧道,并在其上使用路由协议.不确定的选"N".                                       
   {M}   IP: Foo (IP protocols) over UDP                                                    CONFIG_NET_FOU                          允许将任意IP层协议封装到UDP隧道中.不确定的选"N".                                     
 @ [*]   IP: FOU encapsulation of IP tunnels                                                                                                               
   <M>   IP: AH transformation                                                              CONFIG_INET_AH                          IPsec AH 支持.IPsec验证头(AH)可对整个数据包(IP报头与数据)提供身份验证/完整性/抗重播保护.但是它不提供保密性,即它不对数据进行加密.
                                                                                                                                        由于这个原因,AH头正在慢慢被ESP头取代.                                     
   <M>   IP: ESP transformation                                                             CONFIG_INET_ESP                         IPsec ESP 支持.IPsec封装安全负载(ESP)不仅为IP负载提供身份验证/完整性/抗重播保护,还提供保密性,也就是还对数据进行加密.
                                                                                                                                        ESP有两种使用模式:传输模式(ESP不对整个数据包进行签名,只对IP负载(不含IP报头)进行保护)和隧道模式(将原始IP包封装进新的带有ESP头
                                                                                                                                        的IP包内,可提供完整的保护).ESP可以独立使用,也可与AH组合使用(越来越少).                                      
   <M>   IP: IPComp transformation                                                          CONFIG_INET_IPCOMP                      IP静荷载压缩协议(IP Payload Compression Protocol)(RFC3173)支持.用于支持IPsec                                         
   <M>   IP: IPsec transport mode                                                           CONFIG_INET_XFRM_MODE_TRANSPORT         IPsec传输模式.常用于对等通信,用以提供内网安全.数据包经过了加密但IP头没有加密,因此任何标准设备或软件都可查看和使用IP头                                                      
   <M>   IP: IPsec tunnel mode                                                              CONFIG_INET_XFRM_MODE_TUNNEL            IPsec隧道模式.用于提供外网安全(包括虚拟专用网络).整个数据包(数据头和负载)都已经过加密处理且分配有新的ESP头/IP头/验证尾,
                                                                                                                                        从而能够隐藏受保护站点的拓扑结构                                                   
   <M>   IP: IPsec BEET mode                                                                CONFIG_INET_XFRM_MODE_BEET              IPsec BEET模式.                                                 
   <M>   INET: socket monitoring interface                                                  CONFIG_INET_DIAG                        INET(TCP,DCCP,...) socket 监视接口,一些Linux本地工具(如:包含ss的iproute2)需要使用它                                       
   <M>     UDP: socket monitoring interface                                                 CONFIG_INET_UDP_DIAG                    UDP socket 监视接口,一些Linux本地工具(如:包含ss的iproute2)需要使用它                                           
   [ ]     INET: allow privileged process to administratively close sockets                                                                                
   [*]   TCP: advanced congestion control  --->    
                --- TCP: advanced congestion control                                        CONFIG_TCP_CONG_ADVANCED                高级拥塞控制,子项提供多种拥塞控制算法供选用.如果没有特殊需求就别选了,内核会自动将默认的拥塞控制设为"CUBIC"并将"new Reno"作为候补.
                                                                                                                                        仅在你确实知道自己需要的情况下选"Y".不确定的选"N".
                <M>   Binary Increase Congestion (BIC) control                                              
                <*>   CUBIC TCP                                                                             
                <M>   TCP Westwood+                                                                         
                <M>   H-TCP                                                                                 
                <M>   High Speed TCP                                                                        
                <M>   TCP-Hybla congestion control algorithm                                                
                {M}   TCP Vegas                                                                             
                < >   TCP NV                                                                                
                <M>   Scalable TCP                                                                          
                <M>   TCP Low Priority                                                                      
                <M>   TCP Veno                                                                              
                <M>   YeAH TCP                                                                              
                <M>   TCP Illinois                                                                          
                <M>   DataCenter TCP (DCTCP)                                                                
                <M>   CAIA Delay-Gradient (CDG)                                                             
                < >   BBR TCP                                                                               
                    Default TCP congestion control (Cubic)  ---> 
                            (X) Cubic                       
                            ( ) Reno 
   [*]   TCP: MD5 Signature Option support (RFC2385)                                        CONFIG_TCP_MD5SIG                       RFC2385中描述了一种对TCP会话进行MD5签名的保护机制.目前仅用于保护互联网运营商骨干路由器间的BGP会话.一般的路由器/服务器等设备根本不需要这个.
   <*>   The IPv6 protocol  --->                                                            CONFIG_IPV6                                引领未来的IPv6支持.
                --- The IPv6 protocol                                                                      
                [*]   IPv6: Router Preference (RFC 4191) support                            CONFIG_IPV6_ROUTER_PREF                    主机连上IPv6网络后,会发出路由器邀请包(Router Solicitation),路由器则应答路由器公告包(Router Advertisement),其中包含网关地址/IPv6前缀/DNS地址,
                                                                                                                                        这样主机就能取得IPv6地址,并连接到互联网上,这就是无状态地址自动分配(StateLess Address AutoConfiguration)."Router Preference"是
                                                                                                                                        "Router Advertisement"包的可选扩展.它可以改进主机选中路由器的能力,特别是在多归属(multi-homed)网络中.不确定的选"N".               
                [*]     IPv6: Route Information (RFC 4191) support                          CONFIG_IPV6_ROUTE_INFO                  对"Route Information"的实验性支持.
                [ ]   IPv6: Enable RFC 4429 Optimistic DAD                                  CONFIG_IPV6_OPTIMISTIC_DAD              乐观重复地址检测(Optimistic Duplicate Address Detection)的实验性支持.可以更快的进行自动地址配置.不确定的选"N". 
                <M>   IPv6: AH transformation                                               CONFIG_INET6_AH                         IPsec AH 支持.不确定的选"Y"或"M".AH头正在慢慢被ESP头取代.
                <M>   IPv6: ESP transformation                                              CONFIG_INET6_ESP                        IPsec ESP 支持.不确定的选"Y"或"M".
                <M>   IPv6: IPComp transformation                                           CONFIG_INET6_IPCOMP                     IPv6静荷载压缩协议(IP Payload Compression Protocol)(RFC3173)支持.用于支持IPsec.不确定的选"Y"或"M".
                <M>   IPv6: Mobility                                                        CONFIG_IPV6_MIP6                        移动IPv6(RFC3775)支持.主要用于移动设备.不确定的选"N".
              @ < >   IPv6: Identifier Locator Addressing (ILA)                                            
                <M>   IPv6: IPsec transport mode                                            CONFIG_INET6_XFRM_MODE_TRANSPORT        Psec传输模式.常用于对等通信,用以提供内网安全.数据包经过了加密但IP头没有加密,因此任何标准设备或软件都可查看和使用IP头.不确定的选"Y"或"M".       
                <M>   IPv6: IPsec tunnel mode                                               CONFIG_INET6_XFRM_MODE_TUNNEL           IPsec隧道模式.用于提供外网安全(包括虚拟专用网络).整个数据包(数据头和负载)都已经过加密处理且分配有新的ESP头/IP头/验证尾,
                                                                                                                                        从而能够隐藏受保护站点的拓扑结构.不确定的选"Y"或"M".    
                <M>   IPv6: IPsec BEET mode                                                 CONFIG_INET6_XFRM_MODE_BEET             IPsec BEET模式.不确定的选"Y"或"M".  
                <M>   IPv6: MIPv6 route optimization mode                                   CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION
                                                                                                                                    移动IPv6(Mobile IPv6)路由优化模式.主要用于移动设备.不确定的选"N".               
              @ <M>   Virtual (secure) IPv6: tunneling                                                     
                <M>   IPv6: IPv6-in-IPv4 tunnel (SIT driver)                                CONFIG_IPV6_SIT                           在IPv4网络上建立IPv6隧道.如果你希望可以通过IPv4网络接入一个IPv6网络,可以选"Y"或"M",否则选"N".
                [*]     IPv6: IPv6 Rapid Deployment (6RD)                                   CONFIG_IPV6_SIT_6RD                       IPv6快速部署(6RD)支持.不确定的选"N".
                {M}   IPv6: IP-in-IPv6 tunnel (RFC2473)                                     CONFIG_IPV6_TUNNEL                       IPv6-in-IPv6/IPv4-in-IPv6 隧道(RFC2473)支持.不确定的选"N".
                <M>   IPv6: GRE tunnel                                                      CONFIG_IPV6_GRE                           基于IPv6的通用路由封装(Generic Routing Encapsulation)隧道支持.该驱动主要用于对端是Cisco路由器的场合,因为Cisco的路由器特别偏好GRE隧道
                                                                                                                                        (而不是CONFIG_IPV6_TUNNEL),并且GRE还允许通过隧道对组播进行再分发.
                [*]   IPv6: Multiple Routing Tables                                         CONFIG_IPV6_MULTIPLE_TABLES             多重路由表(Multiple Routing Tables)支持.不确定的选"N".  
                [*]     IPv6: source address based routing                                  CONFIG_IPV6_SUBTREES               
                [*]   IPv6: multicast routing                                               CONFIG_IPV6_MROUTE                       测试性的IPv6组播路由支持.实际应用的场合很少,不确定的选"N".
                [*]     IPv6: multicast policy routing                                      CONFIG_IPV6_MROUTE_MULTIPLE_TABLES      通常,组播路由器上会运行一个单独的用户态守护进程,根据源地址和目的地址来处理数据包.开启此项后,将能同时考虑数据包所带的标记(mark)和
                                                                                                                                        所通过的网络接口,并可在用户空间同时运行多个守护进程,每一个进程处理一张路由表.         
                [*]     IPv6: PIM-SM version 2 support                                      CONFIG_IPV6_PIMSM_V2                       IPv6 PIM multicast routing protocol PIM-SMv2 支持.

   -*-   NetLabel subsystem support                                                         CONFIG_NETLABEL                           NetLabel子系统支持.NetLabel子系统为诸如CIPSO与RIPSO之类能够在分组信息上添加标签的协议提供支持,看不懂就别选
   -*- Security Marking                                                                     CONFIG_NETWORK_SECMARK                  对网络包进行安全标记,类似于nfmark,但主要是为安全目的而设计.看不懂的就别选了                                             
   [ ] Timestamping in PHY devices                                                          CONFIG_NETWORK_PHY_TIMESTAMPING         允许在硬件支持的前提下,为物理层(PHY)数据包打上时间戳.这会略微增加发送与接收的开销.不确定的选"N".                                                      
   [*] Network packet filtering framework (Netfilter)  --->    
          --- Network packet filtering framework (Netfilter)                                CONFIG_NETFILTER                        Netfilter可以对数据包进行过滤和修改,可以作为防火墙("packet filter"或"proxy-based")或网关(NAT)或代理(proxy)或网桥使用.                                            
          [ ]   Network packet filtering debugging                                          CONFIG_NETFILTER_DEBUG                    仅供开发者调试Netfilter使用                                            
          [*]   Advanced netfilter configuration                                            CONFIG_NETFILTER_ADVANCED               选"Y"将会显示所有模块供用户选择,选"N"则会隐藏一些不常用的模块,并自动将常用模块设为"M".                             
          <M>     Bridged IP/ARP packets filtering                                          CONFIG_BRIDGE_NETFILTER                 如果你希望使用桥接防火墙就打开它.Docker依赖于它.不确定的选"N".                           
                Core Netfilter Configuration  --->                                                                                    核心Netfilter配置(当包流过Chain时如果match某个规则那么将由该规则的target来处理,否则将由同一个Chain中的下一个规则进行匹配,
                                                                                                                                        若不match所有规则那么最终将由该Chain的policy进行处理)
                       [*] Netfilter ingress support                                        CONFIG_NETFILTER_INGRESS                允许将入站包进行分类.                                                    
                       {M} Netfilter NFACCT over NFNETLINK interface                        CONFIG_NETFILTER_NETLINK_ACCT           允许通过NFNETLINK接口支持NFACCT(记账).                                                         
                       {M} Netfilter NFQUEUE over NFNETLINK interface                       CONFIG_NETFILTER_NETLINK_QUEUE          允许通过NFNETLINK接口支持NFQUEUE(排队).                                                          
                       {M} Netfilter LOG over NFNETLINK interface                           CONFIG_NETFILTER_NETLINK_LOG            允许通过NFNETLINK接口支持"LOG"(日志).该选项废弃了ipt_ULOG和ebg_ulog机制,并打算在将来废弃基于syslog的ipt_LOG和ip6t_LOG模块.                                                        
                       <M> Netfilter connection tracking support                            CONFIG_NF_CONNTRACK                     连接追踪(connection tracking)支持,连接跟踪把所有连接都保存在一个表格内,并将每个包关联到其所属的连接.
                                                                                                                                        可用于报文伪装或地址转换,也可用于增强包过滤能力                                               
                       -*- Connection mark tracking support                                 CONFIG_NF_CONNTRACK_MARK                允许对连接进行标记,与针对单独的包进行标记的不同之处在于它是针对连接流的. CONNMARK target 和 connmark match 需要它的支持.                                                    
                       [*] Connection tracking security mark support                        CONFIG_NF_CONNTRACK_SECMARK             允许对连接进行安全标记,通常这些标记包(SECMARK)复制到其所属连接(CONNSECMARK),再从连接复制到其关联的包(SECMARK).                                                       
                       [*] Connection tracking zones                                        CONFIG_NF_CONNTRACK_ZONES               "conntrack zones"支持.通常,每个连接需要一个全局唯一标示符,而"conntrack zones"允许在不同zone内的连接使用相同的标识符.                                                     
                       [ ] Supply CT list in procfs (OBSOLETE)                              CONFIG_NF_CONNTRACK_PROCFS              已被废弃,选"N".                                                      
                       [*] Connection tracking events                                       CONFIG_NF_CONNTRACK_EVENTS              连接跟踪事件支持.如果启用这个选项,连接跟踪代码将提供一个"notifier"链,它可以被其它内核代码用来获知连接跟踪状态的改变                                                      
                       [*] Connection tracking timeout                                      CONFIG_NF_CONNTRACK_TIMEOUT             连接跟踪"timeout"扩展.这样你就可以在网络流上通过 CT target 附加超时策略.                                                        
                       [*] Connection tracking timestamping                                 CONFIG_NF_CONNTRACK_TIMESTAMP           时间戳支持.这样你就能在连接建立和断开时打上时间戳.                                                         
                       <M> DCCP protocol connection tracking support                        CONFIG_NF_CT_PROTO_DCCP                 DCCP协议支持.                                                    
                       <M> SCTP protocol connection tracking support                                                                SCTP协议支持.                            
                       <M> UDP-Lite protocol connection tracking support                                                            UDP-Lite支持.                            
                       <M> Amanda backup protocol support                                                                           Amanda备份协议支持.                            
                       <M> FTP protocol support                                                                                     文件传输协议(FTP)支持.跟踪FTP连接需要额外的帮助程序.                            
                       <M> H.323 protocol support                                                                                   H.323协议支持.                            
                       <M> IRC protocol support                                                                                     IRC扩展协议DCC(Direct Client-to-Client Protocol)支持.该协议允许用户之间绕开服务器直接聊天和传输文件.                            
                       <M> NetBIOS name service protocol support                                                                    NetBIOS                            
                       <M> SNMP service protocol support                                                                            SNMP                            
                       <M> PPtP protocol support                                                                                    RFC2637 点对点隧道协议(Point to Point Tunnelling Protocol) 协议支持.                            
                       <M> SANE protocol support                                                                                    SANE                            
                       <M> SIP protocol support                                                                                     SIP                            
                       <M> TFTP protocol support                                                                                    TFTP                            
                       <M> Connection tracking netlink interface                            CONFIG_NF_CT_NETLINK                    基于netlink的用户接口支持.                                                
                       <M> Connection tracking timeout tuning via Netlink                   CONFIG_NF_CT_NETLINK_TIMEOUT            通过Netlink机制支持对连接追踪超时进行细粒度的调节:允许为特定的网络流指定超时策略,而不是使用统一的全局超时策略.                                                                    
                       [ ] NFQUEUE and NFLOG integration with Connection Tracking           CONFIG_NETFILTER_NETLINK_QUEUE_CT        开启此项后,即使网络包已经在队列(NFQUEUE)中,它依然可以包含连接追踪信息.                                                                    
                     @ -M- IPv4/IPv6 redirect support                                                                                                           
                     @ <M> Netfilter nf_tables support                                                                                                          
                     @ <M>   Netfilter nf_tables mixed IPv4/IPv6 tables support                                                                                 
                     @ <M>   Netfilter nf_tables netdev tables support                                                                                          
                     @ <M>   Netfilter nf_tables IPv6 exthdr module                                                                                             
                     @ <M>   Netfilter nf_tables meta module                                                                                                    
                     @ < >   Netfilter nf_tables number generator module                                                                                        
                     @ <M>   Netfilter nf_tables conntrack module                                                                                               
                     @ < >   Netfilter nf_tables rbtree set module
                     @ < >   Netfilter nf_tables hash set module                                                                                                  
                     @ <M>   Netfilter nf_tables counter module                                                                                                   
                     @ <M>   Netfilter nf_tables log module                                                                                                       
                     @ <M>   Netfilter nf_tables limit module                                                                                                     
                     @ <M>   Netfilter nf_tables masquerade support                                                                                               
                     @ <M>   Netfilter nf_tables redirect support                                                                                                 
                     @ <M>   Netfilter nf_tables nat module                                                                                                       
                     @ <M>   Netfilter nf_tables queue module                                                                                                     
                     @ < >   Netfilter nf_tables quota module                                                                                                     
                     @ <M>   Netfilter nf_tables reject support                                                                                                   
                     @ <M>   Netfilter x_tables over nf_tables module                                                                                             
                     @ <M>   Netfilter nf_tables hash module                                                                                                      
                     @ < >   Netfilter packet duplication support                                                                                                 
                     @ < >   Netfilter nf_tables netdev packet duplication support                                                                                
                     @ < >   Netfilter nf_tables netdev packet forwarding support                                                                                 
                     @ {M} Netfilter Xtables support (required for ip_tables)                                                                                     
                            *** Xtables combined modules ***                                                                                                     
                      -M-   nfmark target and match support                                 CONFIG_NETFILTER_XT_MARK                "nfmark"是用户给包打上的一个自定义标记.用于match时,允许基于"nfmark"值对包进行匹配.用于target时,
                                                                                                                                        允许在"mangle"表中创建规则以改变包的"nfmark"值.                                                      
                      -M-   ctmark target and match support                                 CONFIG_NETFILTER_XT_CONNMARK            "ctmark"是用户以连接为组,给同一连接中的所有包打上的自定义标记.用法与"nfmark"相似.                                                         
                      <M>   set target and match support                                    CONFIG_NETFILTER_XT_SET                 "set"是ipset工具创建的IP地址集合.使用match可以对IP地址集合进行匹配,使用target可以对集合中的项进行增加和删除.                                                    
                            *** Xtables targets ***                                                                                                              
                      <M>   AUDIT target support                                            CONFIG_NETFILTER_XT_TARGET_AUDIT        为被drop/accept的包创建审计记录.                                                                     
                      <M>   CHECKSUM target support                                         CONFIG_NETFILTER_XT_TARGET_CHECKSUM        用于"mangle"表,为缺少校验和的包添加checksum字段的值.主要是为了兼容一些老旧的网络程序(例如某些dhcp客户端).                                                                     
                      <M>   "CLASSIFY" target support                                       CONFIG_NETFILTER_XT_TARGET_CLASSIFY        允许为包设置优先级,一些qdiscs排队规则(atm,cbq,dsmark,pfifo_fast,htb,prio)需要使用它                                                                     
                      <M>   "CONNMARK" target support                                       CONFIG_NETFILTER_XT_TARGET_CONNMARK        这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_CONNMARK                                                                     
                      <M>   "CONNSECMARK" target support                                    CONFIG_NETFILTER_XT_TARGET_CONNSECMARK    针对链接进行安全标记,同时还会将连接上的标记还原到包上(如果链接中的包尚未进行安全标记),通常与 SECMARK target 联合使用                                                                     
                      <M>   "CT" target support                                             CONFIG_NETFILTER_XT_TARGET_CT            允许为包加上连接追踪相关的参数,比如"event"和"helper".                                                                     
                      <M>   "DSCP" and "TOS" target support                                 CONFIG_NETFILTER_XT_TARGET_DSCP            DSCP target 允许对IPv4/IPv6包头部的DSCP(Differentiated Services Codepoint)字段(常用于Qos)进行修改. 
                                                                                                                                        TOS target 允许在"mangle"表创建规则以修改IPv4包头的TOS(Type Of Service)字段或IPv6包头的Priority字段.                                                                     
                      -M-   "HL" hoplimit target support                                    CONFIG_NETFILTER_XT_TARGET_HL            HL(IPv6)/TTL(IPv4) target 允许更改包头的 hoplimit/time-to-live 值.                                                                     
                      <M>   "HMARK" target support                                          CONFIG_NETFILTER_XT_TARGET_HMARK        允许在"raw"和"mangle"表中创建规则,以根据特定范围的哈希计算结果设置"skbuff"标记                                                                     
                      <M>   IDLETIMER target support                                        CONFIG_NETFILTER_XT_TARGET_IDLETIMER    每个被匹配的包的定时器都会被强制指定为规则指定的值,当超时发生时会触发一个sysfs文件系统的通知.剩余时间可以通过sysfs读取                                                                     
                      <M>   "LED" target support                                            CONFIG_NETFILTER_XT_TARGET_LED            允许在满足特定条件的包通过的时候,触发LED灯闪烁.比如可以用于控制网卡的状态指示灯仅在有SSH活动的时候才闪烁.                                                                     
                      <M>   LOG target support                                              CONFIG_NETFILTER_XT_TARGET_LOG            允许向syslog中记录包头信息                                                                     
                      <M>   "MARK" target support                                           CONFIG_NETFILTER_XT_TARGET_MARK            这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_MARK                                                                     
                    @ -M-   "SNAT and DNAT" targets support 
                      -M-   "NETMAP" target support                                         CONFIG_NETFILTER_XT_TARGET_NETMAP        NETMAP用于实现一对一的静态NAT(地址转换).                                                                                    
                      <M>   "NFLOG" target support                                          CONFIG_NETFILTER_XT_TARGET_NFLOG        通过nfnetlink_log记录日志.                                                                                    
                      <M>   "NFQUEUE" target Support                                        CONFIG_NETFILTER_XT_TARGET_NFQUEUE        用于替代老旧的 QUEUE target. 因为NFQUEUE能支持最多65535个队列,而QUEUE只能支持一个.                                                                                    
                      < >   "NOTRACK" target support (DEPRECATED)                           CONFIG_NETFILTER_XT_TARGET_NOTRACK        已被废弃,勿选.                                                                                    
                      -M-   "RATEEST" target support                                        CONFIG_NETFILTER_XT_TARGET_RATEEST        RATEEST target 允许测量网络流的传输速率.[注: rateest match 允许根据速率进行匹配.]                                                                                    
                      -M-   REDIRECT target support                                         CONFIG_NETFILTER_XT_TARGET_REDIRECT        REDIRECT是一种特别的NAT:所有进入的连接都被映射到其入口网卡的地址,这样这些包就会"流入"本机而不是"流过"本机.
                                                                                                                                        这主要用于实现透明代理                                                                                    
                      <M>   "TEE" - packet cloning to alternate destination                 CONFIG_NETFILTER_XT_TARGET_TEE            对包进行克隆,并将克隆的副本路由到另一个临近的路由器(Next Hop).                                                                                    
                      <M>   "TPROXY" target transparent proxying support                    CONFIG_NETFILTER_XT_TARGET_TPROXY        类似于REDIRECT,但并不依赖于连接追踪和NAT,也只能用于"mangle"表,用于将网络流量重定向到透明代理.                                                                                    
                      <M>   "TRACE" target support                                          CONFIG_NETFILTER_XT_TARGET_TRACE        允许对包打标记,这样内核就可以记录每一个匹配到的规则.                                                                                    
                      <M>   "SECMARK" target support                                        CONFIG_NETFILTER_XT_TARGET_SECMARK        允许对包进行安全标记,用于安全子系统                                                                                    
                      <M>   "TCPMSS" target support                                         CONFIG_NETFILTER_XT_TARGET_TCPMSS        允许更改 TCP SYN 包的MSS(Maximum Segment Size)值,通常=MTU-40.                                                                                    
                      <M>   "TCPOPTSTRIP" target support                                    CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP    允许从TCP包头中剥离所有TCP选项.                                                                                    
                            *** Xtables matches ***                                                                                                                             
                      <M>   "addrtype" address type match support                           CONFIG_NETFILTER_XT_MATCH_ADDRTYPE        根据地址类型进行匹配: UNICAST, LOCAL, BROADCAST, ... Docker依赖于它.                                                                                    
                      <M>   "bpf" match support                                             CONFIG_NETFILTER_XT_MATCH_BPF            BPF(BSD Packet Filter)是一个强大的包匹配模块,用于匹配那些让过滤器返回非零值的包.                                                                                    
                    @ <M>   "control group" match support                                                                                                                       
                      <M>   "cluster" match support                                         CONFIG_NETFILTER_XT_MATCH_CLUSTER        这个模块可以用于创建网络服务器/防火墙集群,而无需借助价格昂贵的负载均衡设备.
                                                                                                                                        通常,在包必须被本节点处理的条件下,这个match返回"true".这样,所有节点都可以看到所有的包,
                                                                                                                                        但只有匹配的节点才需要进行处理,这样就将负载进行了分摊.而分摊算法是基于对源地址的哈希值.                                                                                    
                      <M>   "comment" match support                                         CONFIG_NETFILTER_XT_MATCH_COMMENT        这是一个"伪match",目的是允许你在iptables规则集中加入注释                                                                                    
                      <M>   "connbytes" per-connection counter match support                CONFIG_NETFILTER_XT_MATCH_CONNBYTESq    允许针对单个连接内部每个方向(进/出)匹配已经传送的字节数/包数                                                                                    
                      <M>   "connlabel" match support                                       CONFIG_NETFILTER_XT_MATCH_CONNLABEL        允许向连接分配用户自定义的标签名.内核仅存储bit值,而名称和bit之间的对应关系由用户空间处理.
                                                                                                                                        与"connmark"的不同之处在于:可以同时为一个连接分配32个标志位(flag bit).                                                                                    
                      <M>   "connlimit" match support                                       CONFIG_NETFILTER_XT_MATCH_CONNLIMIT        允许根据每一个客户端IP地址(或每一段客户端IP地址段)持有的并发连接数进行匹配.                                                                                    
                      <M>   "connmark" connection mark match support                        CONFIG_NETFILTER_XT_MATCH_CONNMARK        这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_CONNMARK                                                                                    
                      <M>   "conntrack" connection tracking match support                   CONFIG_NETFILTER_XT_MATCH_CONNTRACK        通用连接跟踪匹配,是"state"的超集,它允许额外的链接跟踪信息,在需要设置一些复杂的规则(比如网关)
                                                                                                                                        时很有用.Docker依赖于它.                                                                                    
                      <M>   "cpu" match support                                             CONFIG_NETFILTER_XT_MATCH_CPU            根据处理包所使用的CPU是哪个进行匹配                                                                                    
                      <M>   "dccp" protocol match support                                   CONFIG_NETFILTER_XT_MATCH_DCCP            DCCP是打算取代UDP的新传输协议,它在UDP的基础上增加了流控和拥塞控制机制,面向实时业务                                                                                    
                      <M>   "devgroup" match support                                        CONFIG_NETFILTER_XT_MATCH_DEVGROUP        允许根据网卡所属的"设备组"进行匹配                                                                                    
                      <M>   "dscp" and "tos" match support                                  CONFIG_NETFILTER_XT_MATCH_DSCP            dscp match 允许根据IPv4/IPv6包头的DSCP字段进行匹配, tos match 允许根据IPv4包头的TOS字段进行匹配                                                                                    
                      -M-   "ecn" match support                                             CONFIG_NETFILTER_XT_MATCH_ECN            允许根据IPv4 TCP包头的ECN字段进行匹配                                                                                    
                      <M>   "esp" match support                                             CONFIG_NETFILTER_XT_MATCH_ESP            允许对IPSec包的ESP头中的SPI(安全参数序列)范围进行匹配                                                                                    
                      <M>   "hashlimit" match support                                       CONFIG_NETFILTER_XT_MATCH_HASHLIMIT        此项的目的是取代"limit",它基于你选定的源/目的地址和/或端口动态创建"limit bucket"哈希表.
                                                                                                                                        这样你就可以迅速创建类似这样的匹配规则:(1)为给定的目的地址以每秒10k个包的速度进行匹配;
                                                                                                                                        (2)为给定的源地址以每秒500个包的速率进行匹配                                                                                    
                      <M>   "helper" match support                                          CONFIG_NETFILTER_XT_MATCH_HELPER        加载特定协议的连接跟踪辅助模块,由该模块过滤所跟踪的连接类型的包,比如ip_conntrack_ftp模块                                                                                    
                      -M-   "hl" hoplimit/TTL match support                                 CONFIG_NETFILTER_XT_MATCH_HL            基于IPv6包头的hoplimit字段,或IPv4包头的time-to-live字段进行匹配                                                                                    
                    @ <M>   "ipcomp" match support                                                                                                                              
                      <M>   "iprange" address range match support                           CONFIG_NETFILTER_XT_MATCH_IPRANGE        根据IP地址范围进行匹配,而普通的iptables只能根据"IP/mask"的方式进行匹配                                                                                    
                      <M>   "ipvs" match support                                             CONFIG_NETFILTER_XT_MATCH_IPVS            允许根据包的IPVS属性进行匹配                                                
                    @ <M>   "l2tp" match support                                                                                                                         
                      <M>   "length" match support                                          CONFIG_NETFILTER_XT_MATCH_LENGTH        允许对包的长度进行匹配                                                                             
                      <M>   "limit" match support                                           CONFIG_NETFILTER_XT_MATCH_LIMIT            允许根据包的进出速率进行规则匹配,常和"LOG target"配合使用以抵抗某些Dos攻击                                                                             
                      <M>   "mac" address match support                                     CONFIG_NETFILTER_XT_MATCH_MAC            允许根据以太网的MAC地址进行匹配                                                                             
                      <M>   "mark" match support                                            CONFIG_NETFILTER_XT_MATCH_MARK            这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_MARK                                                                             
                      <M>   "multiport" Multiple port match support                         CONFIG_NETFILTER_XT_MATCH_MULTIPORT        允许对TCP或UDP包同时匹配多个不连续的端口(通常情况下只能匹配单个端口或端口范围)                                                                             
                      <M>   "nfacct" match support                                          CONFIG_NETFILTER_XT_MATCH_NFACCT        允许通过nfnetlink_acct使用扩展记账                                                                             
                      <M>   "osf" Passive OS fingerprint match                              CONFIG_NETFILTER_XT_MATCH_OSF            开启Passive OS Fingerprinting模块,以允许通过进入的TCP SYN包被动匹配远程操作系统.
                                                                                                                                        规则和加载程序可以从这里获取:http://www.ioremap.net/projects/osf                                                                             
                      <M>   "owner" match support                                           CONFIG_NETFILTER_XT_MATCH_OWNER            基于创建套接字的本地进程身份(user/group)进行匹配,还可以用于检查一个套接字是否确实存在                                                                             
                      <M>   IPsec "policy" match support                                    CONFIG_NETFILTER_XT_MATCH_POLICY        基于IPsec policy进行匹配                                                                             
                      <M>   "physdev" match support                                         CONFIG_NETFILTER_XT_MATCH_PHYSDEV        允许对进入或离开所经过的物理网口进行匹配                                                                             
                      <M>   "pkttype" packet type match support                             CONFIG_NETFILTER_XT_MATCH_PKTTYPE        允许对封包目的地址类别(广播/组播/直播)进行匹配                                                                             
                      <M>   "quota" match support                                           CONFIG_NETFILTER_XT_MATCH_QUOTA            允许对总字节数的限额值进行匹配                                                                             
                      <M>   "rateest" match support                                         CONFIG_NETFILTER_XT_MATCH_RATEEST        根据 RATEEST target 评估的速率值进行匹配                                                                             
                      <M>   "realm" match support                                           CONFIG_NETFILTER_XT_MATCH_REALM            允许根据iptables中的路由子系统中的realm值进行匹配.它与tc中的CONFIG_NET_CLS_ROUTE4非常类似.                                                                             
                      <M>   "recent" match support                                          CONFIG_NETFILTER_XT_MATCH_RECENT        recent match 用于创建一个或多个最近使用过的地址列表,然后又可以根据这些列表再进行匹配                                                                             
                      <M>   "sctp" protocol match support                                   CONFIG_NETFILTER_XT_MATCH_SCTP            支持根据流控制传输协议(SCTP)源/目的端口和"chunk type"进行匹配.                                                                             
                      <M>   "socket" match support                                          CONFIG_NETFILTER_XT_MATCH_SOCKET        can be used to match packets for which a TCP or UDP socket lookup finds a valid socket. 
                                                                                                                                        It can be used in combination with the MARK target and policy routing to 
                                                                                                                                        implement full featured non-locally bound sockets.                                                                             
                      <M>   "state" match support                                           CONFIG_NETFILTER_XT_MATCH_STATE            这是对包进行分类的有力工具,它允许利用连接跟踪信息对连接中处于特定状态的包进行匹配                                                                             
                      <M>   "statistic" match support                                       CONFIG_NETFILTER_XT_MATCH_STATISTIC        允许根据一个给定的百分率对包进行周期性的或随机性的匹配                                                                             
                      <M>   "string" match support                                          CONFIG_NETFILTER_XT_MATCH_STRING        允许根据包所承载的数据中包含的特定字符串进行匹配                                                                             
                      <M>   "tcpmss" match support                                          CONFIG_NETFILTER_XT_MATCH_TCPMSS        允许根据TCP SYN包头中的MSS(最大分段长度)选项的值进行匹配                                                                             
                      <M>   "time" match support                                            CONFIG_NETFILTER_XT_MATCH_TIME            根据包的到达时刻(外面进入的包)或者离开时刻(本地生成的包)进行匹配                                                                             
                      <M>   "u32" match support                                             CONFIG_NETFILTER_XT_MATCH_U32            "u32"允许从包中提取拥有特定mask的最多4字节数据,将此数据移动(shift)特定的位数,
                                                                                                                                        然后测试其结果是否位于特定的集合范围内.更多细节可以直接参考内核源码(net/netfilter/xt_u32.c)                                                                             
          <M>   IP set support  ---> 
                      --- IP set support                                                    CONFIG_IP_SET                            为内核添加IP集(IP set)支持,然后就可以使用CONFIG_NETFILTER_XT_SET功能.此特性必须配合用户态工具ipset一起使用.                                                                
                      (256) Maximum number of IP sets                                       CONFIG_IP_SET_MAX                        默认的最大"set"数,取值范围是[2,65534].此值也可以由ip_set模块的max_sets参数设置                                                                
                      <M>   bitmap:ip set support                                           CONFIG_IP_SET_BITMAP_IP                    "bitmap:ip"集合类型.根据IP地址范围设定集合.                                                                
                      <M>   bitmap:ip,mac set support                                       CONFIG_IP_SET_BITMAP_IPMAC                "bitmap:ip,mac"集合类型.根据IP/MAC地址对范围设定集合.                                                                
                      <M>   bitmap:port set support                                         CONFIG_IP_SET_BITMAP_PORT                "bitmap:port"集合类型.根据端口范围设定集合.                                                                
                      <M>   hash:ip set support                                             CONFIG_IP_SET_HASH_IP                    "hash:ip"集合类型.为多个离散的IP地址设定集合.                                                                
                    @ <M>   hash:ip,mark set support                                                                                                        
                      <M>   hash:ip,port set support                                        CONFIG_IP_SET_HASH_IPPORT                "hash:ip,port"集合类型.为多个离散的IP/MAC地址对设定集合.                                                                
                      <M>   hash:ip,port,ip set support                                     CONFIG_IP_SET_HASH_IPPORTIP                "hash:ip,port,ip"集合类型.为多个离散的IP/端口/IP三元组设定集合.                                                                
                      <M>   hash:ip,port,net set support                                    CONFIG_IP_SET_HASH_IPPORTNET            "hash:ip,port,net"集合类型.为多个离散的IP/端口/网段三元组设定集合.                                                                
                    @ <M>   hash:mac set support                                                                                                            
                    @ <M>   hash:net,port,net set support                                                                                                   
                      <M>   hash:net set support                                            CONFIG_IP_SET_HASH_NET                    "hash:net"集合类型.为多个离散的网段设定集合                                                                
                    @ <M>   hash:net,net set support                                                                                                        
                      <M>   hash:net,port set support                                       CONFIG_IP_SET_HASH_NETPORT                "hash:net,port"集合类型.为多个离散的网段/端口对设定集合                                                                
                      <M>   hash:net,iface set support                                      CONFIG_IP_SET_HASH_NETIFACE                "hash:net,iface"集合类型.为多个离散的网段/网卡接口对设定集合                                                                
                      <M>   list:set set support                                              CONFIG_IP_SET_LIST_SET                    "list:set"集合类型.将多个集合组成一个更大的集合                        
          <M>   IP virtual server support  --->   
                    --- IP virtual server support                                           CONFIG_IP_VS                            IPVS(IP Virtual Server)支持.IPVS可以帮助LVS基于多个后端真实服务器创建一个高性能的虚拟服务器.
                                                                                                                                        可以使用三种具体的方法实现:NAT,隧道,直接路由(使用较广).                                                                     
                      [*]   IPv6 support for IPVS                                           CONFIG_IP_VS_IPV6                        为IPVS添加IPv6支持                                                                     
                      [ ]   IP virtual server debugging                                     CONFIG_IP_VS_DEBUG                        为IPVS添加调试支持                                                                     
                      (12)  IPVS connection table size (the Nth power of 2)                 CONFIG_IP_VS_TAB_BITS                    设置IPVS连接哈希表的大小(2CONFIG_IP_VS_TAB_BITS),取值范围是[8,20],默认值12的意思是哈希表的大小是212=4096项.
                                                                                                                                        IPVS连接哈希表使用链表来处理哈希碰撞.使用大的哈希表能够显著减少碰撞几率,特别是哈希表中有成千上万连接的时候.
                                                                                                                                        比较恰当的值差不多等于每秒的新建连接数乘以每个连接的平均持续秒数.太小的值会造成太多碰撞,
                                                                                                                                        从而导致性能大幅下降;太大的值又会造成占用太多不必要的内存(每个表项8字节+每个连接128字节).
                                                                                                                                        该值也可以通过ip_vs模块的conn_tab_bits参数进行设置.                                                                     
                            *** IPVS transport protocol load balancing support ***                                                                               
                      [*]   TCP load balancing support                                      CONFIG_IP_VS_PROTO_TCP                    TCP传输协议负载均衡支持                                                                     
                      [*]   UDP load balancing support                                      CONFIG_IP_VS_PROTO_UDP                    UDP传输协议负载均衡支持                                                                     
                      [*]   ESP load balancing support                                      CONFIG_IP_VS_PROTO_ESP                    IPSec ESP(Encapsulation Security Payload)传输协议负载均衡支持                                                                     
                      [*]   AH load balancing support                                       CONFIG_IP_VS_PROTO_AH                    IPSec AH(Authentication Header)传输协议负载均衡支持.                                                                     
                      [*]   SCTP load balancing support                                     CONFIG_IP_VS_PROTO_SCTP                    SCTP传输协议负载均衡支持                                                                     
                            *** IPVS scheduler ***                                                                                                               
                      <M>   round-robin scheduling                                          CONFIG_IP_VS_RR                            循环分散算法:最简单的调度算法,将连接简单的循环分散到后端服务器上                                                                     
                      <M>   weighted round-robin scheduling                                 CONFIG_IP_VS_WRR                        基于权重的循环分散算法:在循环分散的基础上,权重较高的后端服务器接纳较多的连接                                                                     
                      <M>   least-connection scheduling                                     CONFIG_IP_VS_LC                            最少连接算法:将连接优先分配到活动连接最少的后端服务器                                                                      
                      <M>   weighted least-connection scheduling                            CONFIG_IP_VS_WLC                        基于权重的最少连接算法:结合考虑活动连接数与服务器权重                                                                     
                    @ <M>   weighted failover scheduling                                                                                                         
                    @ < >   weighted overflow scheduling                                                                                                         
                      <M>   locality-based least-connection scheduling                      CONFIG_IP_VS_LBLC                        基于目的IP的最少连接算法(常用于缓存集群):优先根据目的IP地址将连接分配到特定的后端,仅在这些后端过载时
                                                                                                                                        (活动连接数大于其权重)才分散到其他后端.                                                                     
                      <M>   locality-based least-connection with replication scheduling     CONFIG_IP_VS_LBLCR                        与LBLC类似,不同之处在于:前端负载均衡器会像NAT一样同时记住客户端IP与后端的对应关系,并在新的连接到来的时候,
                                                                                                                                        复用这个对应关系.                                                                     
                      <M>   destination hashing scheduling                                  CONFIG_IP_VS_DH                            目标地址哈希表算法:简单的根据静态设定的目标IP地址哈希表将连接分发到后端                                                                     
                      <M>   source hashing scheduling                                       CONFIG_IP_VS_SH                            源地址哈希表算法:简单的根据静态设定的源IP地址哈希表将连接分发到后端                                                                     
                      <M>   shortest expected delay scheduling                              CONFIG_IP_VS_SED                        最小期望延迟算法:将连接分配到根据期望延迟公式((Ci+1)/Ui)算得的延迟最小的后端."i"是后端服务器编号,
                                                                                                                                        "Ci"是该服务器当前的连接数,"Ui"是该服务器的权重.                                                                     
                      <M>   never queue scheduling                                          CONFIG_IP_VS_NQ                            无排队算法:这是一个两阶段算法,如果有空闲服务器,就直接分发到空闲服务器(而不是等待速度最快的服务器),
                                                                                                                                        如果没有空闲服务器,就分发到期望延迟最小的服务器(SED算法).                                                                     
                            *** IPVS SH scheduler ***                                                                                                            
                      (8)   IPVS source hashing table size (the Nth power of 2)             CONFIG_IP_VS_SH_TAB_BITS                将源IP地址映射到后端服务器所使用的哈希表的大小(2CONFIG_IP_VS_SH_TAB_BITS),取值范围是[4,20],
                                                                                                                                        默认值8的意思是哈希表的大小是28=256项.理想的大小应该是所有后端的权重乘以后端总数                                                                     
                            *** IPVS application helper ***                                                                                                      
                      <M>   FTP protocol helper                                             CONFIG_IP_VS_FTP                        FTP协议连接追踪帮助                                                                     
                      -*-   Netfilter connection tracking                                   CONFIG_IP_VS_NFCT                        Netfilter连接追踪支持                                                                     
                      <M>   SIP persistence engine                                          CONFIG_IP_VS_PE_SIP                        基于SIP Call-ID提供持久连接支持                                                                     
                IP: Netfilter Configuration  --->                                                                                   针对IPv4的Netfilter配置
                      <M> IPv4 connection tracking support (required for NAT)               CONFIG_NF_CONNTRACK_IPV4                IPv4链接跟踪.可用于包伪装或地址转换,也可用于增强包过滤能力                                                                            
                    @ -M- IPv4 nf_tables support                                                                                                                        
                    @ <M>   IPv4 nf_tables route chain support                                                                                                          
                    @ < >   IPv4 nf_tables packet duplication support                                                                                                   
                    @ <M> ARP nf_tables support                                                                                                                         
                    @ -M- Netfilter IPv4 packet duplication to alternate destination                                                                                    
                    @ <M> ARP packet logging                                                                                                                            
                    @ {M} IPv4 packet logging                                                                                                                           
                    @ {M} IPv4 packet rejection                                                                                                                         
                      -M- IPv4 NAT                                                          CONFIG_NF_NAT_IPV4                      允许进行伪装/端口转发以及其它的NAT功能,
                                                                                                                                        仅在你需要使用iptables中的nat表时才需要选择.Docker依赖于它.                                                                             
                    @ <M>   IPv4 nf_tables nat chain support                                                                                                            
                    @ -M-   IPv4 masquerade support                                                                                                                     
                    @ <M>   IPv4 masquerading support for nf_tables                                                                                                     
                    @ <M>   IPv4 redirect support for nf_tables                                                                                                         
                    @ <M>   Basic SNMP-ALG support                                                                                                                      
                      <M> IP tables support (required for filtering/masq/NAT)               CONFIG_IP_NF_IPTABLES                    要用iptables就肯定要选上                                                                            
                      <M>   "ah" match support                                              CONFIG_IP_NF_MATCH_AH                    允许对IPSec包头的AH字段进行匹配                                                                            
                      <M>   "ecn" match support                                             CONFIG_IP_NF_MATCH_ECN                    这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_MATCH_ECN                                                                            
                      <M>   "rpfilter" reverse path filter match support                    CONFIG_IP_NF_MATCH_RPFILTER                对进出都使用同一个网络接口的包进行匹配                                                                            
                      <M>   "ttl" match support                                             CONFIG_IP_NF_MATCH_TTL                    这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_MATCH_HL                                                                            
                      <M>   Packet filtering                                                CONFIG_IP_NF_FILTER                        定义filter表,以允许对包进行过滤.Docker依赖于它.                                                                            
                      <M>     REJECT target support                                         CONFIG_IP_NF_TARGET_REJECT                允许返回一个ICMP错误包而不是简单的丢弃包                                                                            
                    @ <M>   SYNPROXY target support                                                                                                                     
                    @ <M>   iptables NAT support                                                                                                                        
                      <M>     MASQUERADE target support                                     CONFIG_IP_NF_TARGET_MASQUERADE            SNAT是指在数据包从网卡发送出去的时候,把数据包中的源地址部分替换为指定的IP,
                                                                                                                                        这样,接收方就认为数据包的来源是被替换的那个IP的主机.伪装(MASQUERADE)是一种特殊类型的
                                                                                                                                        SNAT:MASQUERADE是用发送数据的网卡上的IP来替换源IP,用于那些IP不固定的场合
                                                                                                                                        (比如拨号或者通过DHCP分配).Docker依赖于它.                                                                            
                      <M>     NETMAP target support                                         CONFIG_IP_NF_TARGET_NETMAP                这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_TARGET_NETMAP.                                                                            
                      <M>     REDIRECT target support                                       CONFIG_IP_NF_TARGET_REDIRECT            这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_TARGET_REDIRECT.                                                                            
                      <M>   Packet mangling                                                 CONFIG_IP_NF_MANGLE                        在iptables中启用mangle表以便对包进行各种修改,常用于改变包的路由                                                                            
                      <M>     CLUSTERIP target support                                      CONFIG_IP_NF_TARGET_CLUSTERIP            CLUSTERIP target 允许你无需使用昂贵的负载均衡设备也能创建廉价的负载均衡集群                                                                            
                      <M>     ECN target support                                            CONFIG_IP_NF_TARGET_ECN                    用于mangle表,可以去除IPv4包头的ECN(Explicit Congestion Notification)位,
                                                                                                                                        主要用于在保持ECN功能的前提下,去除网络上的"ECN黑洞".                                                                            
                      <M>     "TTL" target support                                          CONFIG_IP_NF_TARGET_TTL                    这只是一个兼容旧配置的选项,等价于CONFIG_NETFILTER_XT_TARGET_HL.                                                                            
                      <M>   raw table support (required for NOTRACK/TRACE)                  CONFIG_IP_NF_RAW                        在iptables中添加一个raw表,该表在netfilter框架中非常靠前,并在PREROUTING和OUTPUT链上有钩子,
                                                                                                                                        从而可以对收到的数据包在连接跟踪前进行处理                                                                            
                      <M>   Security table                                                  CONFIG_IP_NF_SECURITY                    在iptables中添加一个security表,以支持强制访问控制(Mandatory Access Control)策略                                                                            
                      <M> ARP tables support                                                CONFIG_IP_NF_ARPTABLES                    arptables支持                                                                            
                      <M>   ARP packet filtering                                            CONFIG_IP_NF_ARPFILTER                    ARP包过滤.对于进入和离开本地的ARP包定义一个filter表,在桥接的情况下还可以应用于被转发的ARP包                                                                            
                      <M>   ARP payload mangling                                            CONFIG_IP_NF_ARP_MANGLE                    允许对ARP包的荷载部分进行修改,比如修改源和目标物理地址                                                                            
                IPv6: Netfilter Configuration  --->                                                                                    针对IPv6的Netfilter配置.其子项内容类似于IPv4,需要的话可以参考前面IPv4的Netfilter配置进行选择
                      <M> IPv6 connection tracking support                                                                                          
                      -M- IPv6 nf_tables support                                                                                                    
                      <M>   IPv6 nf_tables route chain support                                                                                      
                      < >   IPv6 nf_tables packet duplication support                                                                               
                      -M- Netfilter IPv6 packet duplication to alternate destination                                                                
                      {M} IPv6 packet rejection                                                                                                     
                      {M} IPv6 packet logging                                                                                                       
                      -M- IPv6 NAT                                                                                                                  
                      <M>   IPv6 nf_tables nat chain support                                                                                        
                      -M-   IPv6 masquerade support                                                                                                 
                      <M>   IPv6 masquerade support for nf_tables                                                                                   
                      <M>   IPv6 redirect support for nf_tables                                                                                     
                      {M} IP6 tables support (required for filtering)                                                                               
                      <M>   "ah" match support                                                                                                      
                      <M>   "eui64" address check                                                                                                   
                      <M>   "frag" Fragmentation header match support                                                                               
                      <M>   "hbh" hop-by-hop and "dst" opts header match support                                                                    
                      <M>   "hl" hoplimit match support                                                                                             
                      <M>   "ipv6header" IPv6 Extension Headers Match                                                                               
                      <M>   "mh" match support                                                                                                      
                      <M>   "rpfilter" reverse path filter match support                                                                            
                      <M>   "rt" Routing header match support                                                                                       
                      <M>   "HL" hoplimit target support                                                                                            
                      <M>   Packet filtering                                                                                                        
                      <M>     REJECT target support                                                                                                 
                      <M>   SYNPROXY target support                                                                                                 
                      <M>   Packet mangling                                                                                                         
                      <M>   raw table support (required for TRACE)                                                                                  
                      <M>   Security table                                                                                                          
                      <M>   ip6tables NAT support                                                                                                   
                      <M>     MASQUERADE target support                                                                                             
                      <M>     NPT (Network Prefix translation) target support                                                                       
                DECnet: Netfilter Configuration  --->                                                                               针对DECnet的Netfilter配置    
                    @ <M> Routing message grabulator (for userland routing daemon)      
        @ <M>   Ethernet Bridge nf_tables support  --->                           
          <M>   Ethernet Bridge tables (ebtables) support  --->                             CONFIG_BRIDGE_NF_EBTABLES                针对以太网桥的ebtables Netfilter配置                                                                           
   <M> The DCCP Protocol  --->                                                              CONFIG_IP_DCCP                            数据报拥塞控制协议(Datagram Congestion Control Protocol)在UDP的基础上增加了流控和拥塞控制机制,
                                                                                                                                        使数据报协议能够更好地用于流媒体业务的传输
        @ DCCP CCIDs Configuration  ---> 
        @            [ ] CCID-2 debugging messages                                                                                    
        @            [ ] CCID-3 (TCP-Friendly)                                                                                        
        @ DCCP Kernel Hacking  --->  
        @            [ ] DCCP debug messages                                                                                            
        @            <M> DCCP connection probing                                                                                        
   {M} The SCTP Protocol  --->                                                                 CONFIG_IP_SCTP                            流控制传输协议(Stream Control Transmission Protocol)是一种新兴的传输层协议.
                                                                                                                                        TCP协议一次只能连接一个IP地址而在SCTP协议一次可以连接多个IP地址且可以自动平衡网络负载,
                                                                                                                                        一旦某一个IP地址失效会自动将网络负载转移到其他IP地址上
        @ <M>   SCTP: Association probing                                                               
        @ [ ]   SCTP: Debug object counts                                                               
        @       Default SCTP cookie HMAC encoding (Enable optional SHA1 hmac cookie generation)  --->
        @             ( ) Enable optional MD5 hmac cookie generation      
        @             (X) Enable optional SHA1 hmac cookie generation     
        @             ( ) Use no hmac alg in SCTP cookie generation  
        @ [*]   Enable optional MD5 hmac cookie generation                                              
        @ -*-   Enable optional SHA1 hmac cookie generation                                             
   <M> The RDS Protocol                                                                     CONFIG_RDS                              可靠数据报套接字(Reliable Datagram Sockets)协议支持.RDS可以使用Infiniband和iWARP作为支持RDMA
                                                                                                                                        (远程直接内存访问)的传输方式,RDMA用于一台远程计算机访问另一台计算机的内存而无需本机计算机
                                                                                                                                        操作系统的辅助,这就像直接内存访问(DMA),但是这里远程代替了本地计算机.           
 @ <M>   RDS over Infiniband                                                                                                                                            
 @ <M>   RDS over TCP                                                                                                                                                   
 @ [ ]   RDS debugging messages                                                                                                                                         
   <M> The TIPC Protocol  --->                                                              CONFIG_TIPC                                透明内部进程间通信协议(Transparent Inter Process Communication),以共享内存为基础实现任务
                                                                                                                                        和资源的调度,专门用于集群内部通信                                                                            
   <M> Asynchronous Transfer Mode (ATM)                                                     CONFIG_ATM                                异步传输模式(ATM)支持.主要用于高速LAN和WAN.目前已经日薄西山了.                                                                            
 @ <M>   Classical IP over ATM                                                                                                                                          
 @ [ ]     Do NOT send ICMP if no neighbour                                                                                                                             
 @ <M>   LAN Emulation (LANE) support                                                                                                                                   
 @ <M>     Multi-Protocol Over ATM (MPOA) support                                                                                                                       
 @ <M>   RFC1483/2684 Bridged protocols                                                                                                                                 
 @ [ ]     Per-VC IP filter kludge                                                                                                                                      
   <M> Layer Two Tunneling Protocol (L2TP)  --->                                               CONFIG_L2TP                                第二层隧道协议(RFC2661)是一种对应用透明的隧道协议,VPN经常使用它.                
       @ --- Layer Two Tunneling Protocol (L2TP)                                                                                        
       @ <M>   L2TP debugfs support                                                                                                     
       @ [*]   L2TPv3 support                                                                                                           
       @ <M>     L2TP IP encapsulation for L2TPv3                                                                                       
       @ <M>     L2TP ethernet pseudowire support for L2TPv3                                                                            
   <M> 802.1d Ethernet Bridging                                                             CONFIG_BRIDGE                            802.1d以太网桥(例如为QEMU虚拟机或Docker容器提供桥接网卡支持)                                                                            
   [*]   IGMP/MLD snooping                                                                  CONFIG_BRIDGE_IGMP_SNOOPING                选"Y"可以允许以太网桥根据IGMP(Internet Group Management Protocol, IPv4)/MLD
                                                                                                                                        (Multicast Listener Discovery, IPv6)负载选择性的转发不同端口上的多播包.
                                                                                                                                        选"N"可以减小二进制文件的体积.确定需要使用组播的选"Y".                                                                                    
 @ [*]   VLAN filtering                                                                                                                                                         
   <M> 802.1Q/802.1ad VLAN Support                                                          CONFIG_VLAN_8021Q                        802.1Q虚拟局域网                                                                                    
   [*]   GVRP (GARP VLAN Registration Protocol) support                                                                                                    
   [*]   MVRP (Multiple VLAN Registration Protocol) support 
   <M> DECnet Support                                                                       CONFIG_DECNET                            DECnet协议                                                                                               
   [ ]   DECnet: router support                                                                                                                                                            
   <M> ANSI/IEEE 802.2 LLC type 2 Support                                                   CONFIG_LLC2                                PF_LLC类型套接字支持.也就是IEEE 802.2 LLC 2                                                                                               
   <M> The IPX protocol                                                                     CONFIG_IPX                                IPX协议是由Novell公司提出的运行于OSI模型第三层的协议,具有可路由的特性,
                                                                                                                                        IPX的地址分为网络地址和主机地址,网络地址由管理员分配,主机地址为MAC地址.
                                                                                                                                        由于IP协议的广泛使用,IPX的应用早已日薄西山.                                                                                               
 @ [ ]   IPX: Full internal IPX network                                                                                                                                                    
   <M> Appletalk protocol support                                                           CONFIG_ATALK                            Appletalk是苹果公司创建的一组网络协议,仅用于苹果系列计算机.                                                                                               
 @ <M>   Appletalk interfaces support                                                                                                                                                      
 @ <M>     Appletalk-IP driver support                                                                                                                                                     
 @ [*]       IP to Appletalk-IP Encapsulation support                                                                                                                                      
   <M> CCITT X.25 Packet Layer                                                              CONFIG_X25                                CCITT X.25协议集支持                                                                                               
   <M> LAPB Data Link Driver                                                                CONFIG_LAPB                                LAPB协议支持.                                                                                               
   <M> Phonet protocols family                                                              CONFIG_PHONET                            PhoNet是Nokia开发的面相数据包的通信协议,仅用于Nokia maemo/meego产品.                                                                                               
   <M> 6LoWPAN Support  --->    
           @ [ ]   6LoWPAN debugfs support                                                                
           @ <M>   Next Header and Generic Header Compression Support  ---> 
                    @ --- Next Header and Generic Header Compression Support                                       
                   @ <M>   Destination Options Header Support                                                     
                   @ <M>   Fragment Header Support                                                                
                   @ <M>   Hop-by-Hop Options Header Support                                                      
                   @ <M>   IPv6 Header Support                                                                    
                   @ <M>   Mobility Header Support                                                                
                   @ <M>   Routing Header Support                                                                 
                   @ <M>   UDP Header Support                                                                     
                   @ < >   GHC Hop-by-Hop Options Header Support                                                  
                   @ < >   GHC UDP Support                                                                        
                   @ < >   GHC ICMPv6 Support                                                                     
                   @ < >   GHC Destination Options Header Support                                                 
                   @ < >   GHC Fragmentation Options Header Support                                               
                   @ < >   GHC Routing Options Header Support       
   <M> I    EEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support  --->             CONFIG_IEEE802154                        IEEE Std 802.15.4 定义了一个低速率/低功耗/低复杂度的短距离个人无线网络规范.
                                                                                                                                            主要用于物联网中的传感器/交换器之类设备之间的互联 
           @ [ ]   IEEE 802.15.4 experimental netlink support                                            
           @ <M>   IEEE 802.15.4 socket interface                                                        
           @ <M>   6lowpan support over IEEE 802.15.4                                                    
           @ <M>   Generic IEEE 802.15.4 Soft Networking Stack (mac802154) 
   [*] QoS and/or fair queueing  --->                                                              CONFIG_NET_SCHED                        QoS(Quality of Service)支持.当内核有多个包需要通过网络发送的时候,它需要决定哪个包先发,
                                                                                                                                            那个包后发,哪个包丢弃.这就是包调度算法.关闭此项表示内核使用最简单的FIFO算法,
                                                                                                                                            开启此项后就可以使用多种不同的调度算法(需要配合用户层工具iproute2+tc).
                                                                                                                                            QoS还用于支持diffserv(Differentiated Services)和RSVP(Resource Reservation Protocol)功能.
                                                                                                                                            包调度的状态信息可以从"/proc/net/psched"文件中获取.仅在你确实需要的时候选"Y".                                            
        @ --- QoS and/or fair queueing                                                                                                          
           @       *** Queueing/Scheduling ***                                                                                                     
           @ <M>   Class Based Queueing (CBQ)                                                                                                      
           @ <M>   Hierarchical Token Bucket (HTB)                                                                                                 
           @ <M>   Hierarchical Fair Service Curve (HFSC)                                                                                          
           @ <M>   ATM Virtual Circuits (ATM)                                                                                                      
           @ <M>   Multi Band Priority Queueing (PRIO)                                                                                             
           @ <M>   Hardware Multiqueue-aware Multi Band Queuing (MULTIQ)                                                                           
           @ <M>   Random Early Detection (RED)                                                                                                    
           @ <M>   Stochastic Fair Blue (SFB)                                                                                                      
           @ <M>   Stochastic Fairness Queueing (SFQ)                                                                                              
           @ <M>   True Link Equalizer (TEQL)                                                                                                      
           @ <M>   Token Bucket Filter (TBF)                                                                                                       
           @ <M>   Generic Random Early Detection (GRED)                                                                                           
           @ <M>   Differentiated Services marker (DSMARK)                                                                                         
           @ <M>   Network emulator (NETEM)                                                                                                        
           @ <M>   Deficit Round Robin scheduler (DRR)                                                                                             
           @ <M>   Multi-queue priority scheduler (MQPRIO)                                                                                         
           @ <M>   CHOose and Keep responsive flow scheduler (CHOKE)                                                                               
           @ <M>   Quick Fair Queueing scheduler (QFQ)                                                                                             
           @ <M>   Controlled Delay AQM (CODEL)                                                                                                    
           @ <M>   Fair Queue Controlled Delay AQM (FQ_CODEL)                                                                                      
           @ <M>   Fair Queue                                                                                                                      
           @ <M>   Heavy-Hitter Filter (HHF)                                                                                                       
           @ <M>   Proportional Integral controller Enhanced (PIE) scheduler                                                                       
           @ <M>   Ingress/classifier-action Qdisc                                                                                                 
           @ <M>   Plug network traffic until release (PLUG)                                                                                       
           @       *** Classification ***                                                                                                          
           @ <M>   Elementary classification (BASIC)                                                                                               
           @ <M>   Traffic-Control Index (TCINDEX)                                                                                                 
           @ <M>   Routing decision (ROUTE)                                                                                                        
           @ <M>   Netfilter mark (FW)                                                                                                             
           @ <M>   Universal 32bit comparisons w/ hashing (U32)                                                                                    
           @ [ ]     Performance counters support                                                                                                  
           @ [*]     Netfilter marks support                                                                                                       
           @ <M>   IPv4 Resource Reservation Protocol (RSVP)                                                                                       
           @ <M>   IPv6 Resource Reservation Protocol (RSVP6)    
           @ <M>   Flow classifier                                                                                                                       
           @ <M>   Control Group Classifier                                                                                                              
           @ <M>   BPF-based classifier                                                                                                                  
           @ <M>   Flower classifier                                                                                                                     
           @ < >   Match-all classifier                                                                                                                  
           @ [*]   Extended Matches                                                                                                                      
           @ (32)    Stack size                                                                                                                          
           @ <M>     Simple packet data comparison                                                                                                       
           @ <M>     Multi byte comparison                                                                                                               
           @ <M>     U32 key                                                                                                                             
           @ <M>     Metadata                                                                                                                            
           @ <M>     Textsearch                                                                                                                          
           @ <M>     CAN Identifier                                                                                                                      
           @ <M>     IPset                                                                                                                               
           @ [*]   Actions                                                                                                                               
           @ <M>     Traffic Policing                                                                                                                    
           @ <M>     Generic actions                                                                                                                     
           @ [*]       Probability support                                                                                                               
           @ <M>     Redirecting and Mirroring                                                                                                           
           @ <M>     IPtables targets                                                                                                                    
           @ <M>     Stateless NAT                                                                                                                       
           @ <M>     Packet Editing                                                                                                                      
           @ <M>     Simple Example (Debug)                                                                                                              
           @ <M>     SKB Editing                                                                                                                         
           @ <M>     Checksum Updating                                                                                                                   
           @ <M>     Vlan manipulation                                                                                                                   
           @ <M>     BPF based action                                                                                                                    
           @ <M>     Netfilter Connection Mark Retriever                                                                                                 
           @ < >     skb data modification action                                                                                                        
           @ < >     Inter-FE action based on IETF ForCES InterFE LFB                                                                                    
           @ < >     IP tunnel metadata manipulation                                                                                                     
           @ [ ]   Incoming device classification                                                                                                        
   [*] Data Center Bridging support                                                             CONFIG_DCB                                DCB(Data Center Bridging)支持.数据中心桥接是一组可增强传统以太网功能,以管理通信的功能,尤其
                                                                                                                                            适用于网络通信流量和传输率都很高的环境中.光纤通道可专用于承载此类型的通信.但是,如果使用
                                                                                                                                            专用链路来仅提供光纤通道通信,则成本可能会很高.因此,更多情况下使用以太网光纤通道.DCB功能
                                                                                                                                            可满足光纤通道对遍历以太网时包丢失的敏感度要求.DCB允许对等方基于优先级区分通信.通过区分
                                                                                                                                            优先级,可确保在主机之间发生拥塞时,保持较高优先级通信的包完整性.使用DCB交换协议,通信主机
                                                                                                                                            可以交换会影响高速网络通信的配置信息.然后,对等方可对公用配置进行协商,确保通信流不中断,
                                                                                                                                            同时防止高优先级包出现包丢失.这些功能都需要底层的网卡支持.一般网卡都是不支持的.
                                                                                                                                            所以不确定的可以选"N".                                                   
   {*} DNS Resolver support                                                                     CONFIG_DNS_RESOLVER                        内核DNS解析支持.用于支持CONFIG_AFS_FS/CONFIG_CIFS/CONFIG_CIFS_SMB2/NFS_V4模块.此功能需要
                                                                                                                                            用户态程序"/sbin/dns.resolve"和配置文件"/etc/request-key.conf"的支持.更多信息参见
                                                                                                                                            "Documentation/networking/dns_resolver.txt"文档,不确定的选"N".                                                   
   <M> B.A.T.M.A.N. Advanced Meshing Protocol                                                   CONFIG_BATMAN_ADV                        B.A.T.M.A.N.(更好的移动无线网络方案)是一种用于 multi-hop ad-hoc mesh 网络的路由协议.它是一种
                                                                                                                                            去中心化分布式无线Adhoc模式,特别适用于自然灾害等紧急情况下,创建临时的无线网络.不确定的选"N".                                                                                           
 @ [ ]   B.A.T.M.A.N. V protocol (experimental)                                                                                                                                            
 @ [*]   Bridge Loop Avoidance                                                                                                                                                             
 @ [*]   Distributed ARP Table                                                                                                                                                             
 @ [*]   Network Coding                                                                                                                                                                    
 @ [*]   Multicast optimisation                                                                                                                                                            
 @ [*]   batman-adv debugfs entries                                                                                                                                                        
 @ [ ]     B.A.T.M.A.N. debugging                                                                                                                                                          
   <M> Open vSwitch                                                                             CONFIG_OPENVSWITCH                        Open vSwitch 是一个多层虚拟交换标准.此选项提供了内核级的高速转发功能(需要配合用户态守护进程
                                                                                                                                            ovs-vswitchd来实现).                                                                                           
 @ <M>   Open vSwitch GRE tunneling support                                                                                                                                                
 @ <M>   Open vSwitch VXLAN tunneling support                                                                                                                                              
 @ <M>   Open vSwitch Geneve tunneling support                                                                                                                                             
   <M> Virtual Socket protocol                                                                  CONFIG_VSOCKETS                            这是一个类似于TCP/IP的协议,用于虚拟机之间以及虚拟机与宿主之间的通信.开启此项后,还需要从子项
                                                                                                                                            中选择适用于特定虚拟化技术的传输协议.                                                                                           
   <M>   VMware VMCI transport for Virtual Sockets                                              CONFIG_VMWARE_VMCI_VSOCKETS                适用于VMware虚拟化技术的VMCI传输协议支持.                                                                                           
 @ < >   virtio transport for Virtual Sockets                                                                                                                                              
   <M> NETLINK: socket monitoring interface                                                     CONFIG_NETLINK_DIAG                        NETLINK socket 监视接口.ss这样的诊断工具需要它.                                                                                           
   -*- MultiProtocol Label Switching  --->                                                         CONFIG_MPLS                                多协议标签交换(MPLS)是新一代的IP高速骨干网络交换标准.不确定的选"N".
        --- MultiProtocol Label Switching                                                                                                
      @ {M}   MPLS: GSO support                                                                                                          
      @ <M>   MPLS: routing support  
   <M> High-availability Seamless Redundancy (HSR)                                              CONFIG_HSR                                以太网HSR(高可用性无缝冗余)规范(IEC 62439-3:2010)支持.不确定的选"N".                                                                                           
 @ [ ] Switch (and switch-ish) device support                                                                                                                                              
 @ [ ] L3 Master device support                                                                                                                                                            
 @ [ ] NCSI interface support                                                                                                                                                              
   [*] Network priority cgroup                                                                  CONFIG_CGROUP_NET_PRIO                    Cgroup子系统支持:基于每个网络接口为每个进程分配网络使用优先级.Docker依赖于它.                                                                                           
 @ -*- Network classid cgroup                                                                                                                                                              
   [*] enable BPF Just In Time compiler                                                         CONFIG_BPF_JIT                            BPF(Berkeley Packet Filter)的过滤功能通常由一个解释器(interpreter)解释执行BPF虚拟机指令的方式工作.
                                                                                                                                            开启此项,内核在加载过滤指令后,会将其编译为本地指令,以加快执行速度.网络嗅探程序(libpcap/tcpdump)
                                                                                                                                            可以从中受益.注意:需要"echo 1 > /proc/sys/net/core/bpf_jit_enable"之后才能生效.                                                                                           
       Network testing  --->                                                                                                             网络测试,仅供调试使用
            @ <M> Packet Generator (USE WITH CAUTION)                                                                                    
            @ <M> TCP connection probing                                                                                                 
            @ < > Network packet drop alerting service                                                                                   
                                选项                                       |                   配置名                  |                    内容
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 [*]   Amateur Radio support  --->                                                 CONFIG_HAMRADIO                                    业余无线电支持.供无线电爱好者进行自我训练/相互通讯/技术研究
 <M>   CAN bus subsystem support  --->                                          CONFIG_CAN                                        CAN(Controller Area Network)是一个低速串行通信协议.被广泛地应用于工业自动化/船舶/医疗设备/工业设备等嵌入式领域.
                                                                                                                                    更多信息参见"Documentation/networking/can.txt"文件.                                                        
 <M>   IrDA (infrared) subsystem support  --->                                  CONFIG_IRDA                                        红外线通讯技术支持,主要用于嵌入式环境,某些老旧的笔记本上也可能会有红外接口.                                                        
 <M>   Bluetooth subsystem support  ---> 
            --- Bluetooth subsystem support                                     CONFIG_BT                                        蓝牙支持.蓝牙目前已经基本取代红外线,成为嵌入式设备/智能设备/笔记本的标配近距离(小于10米)通信设备.
                                                                                                                                    在Linux上通常使用来自BlueZ的hciconfig和bluetoothd工具操作蓝牙通信.                                                    
          @ [*]   Bluetooth Classic (BR/EDR) features                                                                               
            <M>     RFCOMM protocol support                                     CONFIG_BT_RFCOMM                                虚拟串口协议(RFCOMM)是一个面向连接的流传输协议,提供RS232控制和状态信号,从而模拟串口的功能.它被用于支持拨号网络,
                                                                                                                                    OBEX(Object Exchange),以及某些蓝牙程序(例如文件传输).                                                    
            [*]       RFCOMM TTY support                                        CONFIG_BT_RFCOMM_TTY                            允许在RFCOMM通道上模拟TTY终端                                                    
            <M>     BNEP protocol support                                       CONFIG_BT_BNEP                                    蓝牙网络封装协议(Bluetooth Network Encapsulation Protocol)可以在蓝牙上运行其他网络协议(TCP/IP). 
                                                                                                                                    Bluetooth PAN(Personal Area Network)需要它的支持.                                                    
            [*]       Multicast filter support                                  CONFIG_BT_BNEP_MC_FILTER                        组播支持                                                    
            [*]       Protocol filter support                                   CONFIG_BT_BNEP_PROTO_FILTER                        协议过滤器支持                                                    
            <M>     CMTP protocol support                                       CONFIG_BT_CMTP                                    CMTP(CAPI消息传输协议)用于支持已在上世纪被淘汰的ISDN设备.不确定的选"N".                                                    
            <M>     HIDP protocol support                                       CONFIG_BT_HIDP                                    人机接口设备协议(Human Interface Device Protocol)用于支持各种人机接口设备(比如鼠标/键盘/耳机等).                                                    
          @ [*]     Bluetooth High Speed (HS) features                                                                              
          @ [*]   Bluetooth Low Energy (LE) features                                                                                
          @ <M>     Bluetooth 6LoWPAN support                                                                                       
          @ [ ]   Enable LED triggers                                                                                               
          @ [ ]   Bluetooth self testing support                                                                                    
          @ [*]   Export Bluetooth internals in debugfs                                                                             
                  Bluetooth device drivers  --->                                                                                 各种蓝牙设备驱动            
                         <M> HCI USB driver                                     CONFIG_BT_HCIBTUSB                                使用USB接口的蓝牙设备支持                                                                                            
                       @ [*]   Broadcom protocol support                                                                                                                    
                       @ [*]   Realtek protocol support                                                                                                                     
                         <M> HCI SDIO driver                                    CONFIG_BT_HCIBTSDIO                                使用SDIO接口的蓝牙设备支持                                                                                            
                         <M> HCI UART driver                                    CONFIG_BT_HCIUART                                使用串口的蓝牙设备支持.此外,基于UART的蓝牙PCMCIA和CF设备也需要此模块的支持                                                                                            
                         -*-   UART (H4) protocol support                       CONFIG_BT_HCIUART_H4                            大多数使用UART接口的蓝牙设备(包括PCMCIA和CF卡)都使用这个协议                                                                                            
                         [*]   BCSP protocol support                            CONFIG_BT_HCIUART_BCSP                            基于CSR(Cambridge Silicon Radio)公司的BlueCore系列芯片的蓝牙设备(包括PCMCIA和CF卡)支持                                                                                            
                         [*]   Atheros AR300x serial support                    CONFIG_BT_HCIUART_ATH3K                            基于Atheros AR300x系列芯片的蓝牙设备支持                                                                                            
                         [*]   HCILL protocol support                           CONFIG_BT_HCIUART_LL                            基于Texas Instruments公司的BRF芯片的蓝牙设备支持                                                                                            
                         [*]   Three-wire UART (H5) protocol support            CONFIG_BT_HCIUART_3WIRE                            Three-wire UART (H5) 协议假定UART通信可能存在各种错误,从而使得CTS/RTS引脚线变得可有可无.看不懂就可以不选                                                                                            
                       @ [*]   Intel protocol support                                                                                                                       
                       @ [*]   Broadcom protocol support                                                                                                                    
                       @ [ ]   Qualcomm Atheros protocol support                                                                                                            
                       @ [ ]   Intel AG6XX protocol support                                                                                                                 
                       @ [ ]   Marvell protocol support                                                                                                                     
                       @ <M> HCI BCM203x USB driver                                                                                                                         
                       @ <M> HCI BPA10x USB driver                                                                                                                          
                       @ <M> HCI BlueFRITZ! USB driver                                                                                                                      
                       @ <M> HCI DTL1 (PC Card) driver                                                                                                                      
                       @ <M> HCI BT3C (PC Card) driver                                                                                                                      
                       @ <M> HCI BlueCard (PC Card) driver                                                                                                                  
                       @ <M> HCI UART (PC Card) device driver                                                                                                               
                         <M> HCI VHCI (Virtual HCI device) driver              CONFIG_BT_HCIVHCI                                模拟蓝牙设备支持.主要用于开发{大多数蓝牙设备并不需要特定的独立驱动,此处省略的独立驱动仅是为了驱动那些
                                                                                                                                    不严格遵守蓝牙规范的芯片}                                                                                             
                       @ <M> Marvell Bluetooth driver support                                                                                                               
                       @ <M>   Marvell BT-over-SDIO driver                                                                                                                  
                       @ <M> Atheros firmware download driver                                                                                                               
                       @ <M> Texas Instruments WiLink7 driver                                                                                                               
 {M}   RxRPC session sockets                                                   CONFIG_AF_RXRPC                                    RxRPC会话套接字支持(仅包括传输部分,不含表示部分).CONFIG_AFS_FS依赖于它.不确定的选"N".
                                                                                                                                    详情参见"Documentation/networking/rxrpc.txt"文档.                                                                                             
@ [ ]   IPv6 support for RxRPC                                                                                                                                               
@ [ ]   Inject packet loss into RxRPC packet stream                                                                                                                          
@ [ ]   RxRPC dynamic debugging                                                                                                          
@ [ ]   RxRPC Kerberos security                                                                                                          
@ < >   KCM sockets  
  -*-   Wireless  --->      
            --- Wireless                                                        CONFIG_WIRELESS                                    无线网络支持.                                                                                      
            <M>   cfg80211 - wireless configuration API                         CONFIG_CFG80211                                    cfg80211是Linux无线局域网(802.11)配置接口,是使用WiFi的前提.注意:"WiFi"是一个无线网路通信技术的品牌,
                                                                                                                                     由WiFi联盟所持有.目的是改善基于IEEE 802.11标准的无线网路产品之间的互通性.现时一般人会把WiFi及
                                                                                                                                     IEEE 802.11混为一谈,甚至把WiFi等同于无线网路(WiFi只是无线网络的一种).                                                                                      
            [ ]     nl80211 testmode command                                    CONFIG_NL80211_TESTMODE                            仅供调试和特殊目的使用.                                                                                      
            [ ]     enable developer warnings                                   CONFIG_CFG80211_DEVELOPER_WARNINGS                仅供调试开发使用                                                                                      
            [ ]     cfg80211 certification onus                                 CONFIG_CFG80211_CERTIFICATION_ONUS                仅在你确实明白此项含义的情况下,才考虑选"Y",否则请选"N".                                                                                     
            [*]     enable powersave by default                                 CONFIG_CFG80211_DEFAULT_PS                        若开启此项则表示默认开启省电模式(也就是默认"Soft blocked: yes").关闭此项则表示默认使用BIOS中的状态
                                                                                                                                     (通常是上一次关机时的状态).详情参见"Documentation/power/pm_qos_interface.txt"文档.                                                                                      
            [*]     cfg80211 DebugFS entries                                    CONFIG_CFG80211_DEBUGFS                            仅供调试                                                                                      
            [ ]     use statically compiled regulatory rules database           CONFIG_CFG80211_INTERNAL_REGDB                    由于绝大多数发行版都含有CRDA软件包,所以绝大多数人应该选"N".如果你确实需要选"Y",
                                                                                                                                     那么请认真阅读"net/wireless/db.txt"文件.                                                                                      
            [ ]   lib80211 debugging messages                                   CONFIG_LIB80211_DEBUG                            仅供调试                                                                                      
            <M>   Generic IEEE 802.11 Networking Stack (mac80211)               CONFIG_MAC80211                                    独立于硬件的通用IEEE 802.11协议栈模块(mac80211).它是驱动开发者用来编写softMAC无线设备驱动的框架,
                                                                                                                                     softMAC设备允许用软件实现帧的管理(包括解析和产生80211无线帧),从而让系统能更好的控制硬件,
                                                                                                                                     现在大多数的无线网卡都是softMAC设备.不确定的选"Y".                                                                                      
            [*]   Minstrel                                                      CONFIG_MAC80211_RC_MINSTREL                        minstrel发送速率(TX rate)控制算法.用于CONFIG_MAC80211模块.这是首选的算法,不确定的选"Y".                                                                                      
            [*]     Minstrel 802.11n support                                    CONFIG_MAC80211_RC_MINSTREL_HT                    minstrel_ht发送速率(TX rate)控制算法.适用于802.11n规范.不确定的选"Y".                                                                                      
          @ [*]       Minstrel 802.11ac support                                                                                                                       
                  Default rate control algorithm (Minstrel)  --->                                                                默认发送速率(TX rate)控制算法.相当于mac80211模块"ieee80211_default_rc_algo"参数的值.建议选择"Minstrel"算法.                                     
            [*]   Enable mac80211 mesh networking (pre-802.11s) support         CONFIG_MAC80211_MESH                                802.11s草案是无线网状网络(Mesh Networking)的延伸与增补标准(amendment).它扩展了IEEE 802.11 MAC(介质访问控制)
                                                                                                                                     标准,定义了利用自我组态的多点跳跃拓朴(multi-hop topologies),进行无线感知(radio-aware metrics),以支援
                                                                                                                                     广播/组播/单播传送网络封包的架构与协定.不确定的选"N".                                                                                      
            -*-   Enable LED triggers                                           CONFIG_MAC80211_LEDS                                允许在接受/发送数据时触发无线网卡的LED灯闪烁.                                                                                      
            -*-   Export mac80211 internals in DebugFS                          CONFIG_MAC80211_DEBUGFS                            在DebugFS中显示mac80211模块内部状态的扩展信息,仅用于调试目的.                                                                                      
            [*]   Trace all mac80211 debug messages                             CONFIG_MAC80211_MESSAGE_TRACING                    跟踪所有mac80211模块的调试信息,仅用于调试目的.                                                                                      
            [ ]   Select mac80211 debugging features  ----                      CONFIG_MAC80211_DEBUG_MENU                        仅供调试                                                                                      
  <M>   WiMAX Wireless Broadband support  --->                                                                                                                                                                                        
            --- WiMAX Wireless Broadband support                                 CONFIG_WIMAX                                        WiMAX(IEEE 802.16)协议支持.随着2010年英特尔放弃WiMAX以及LTE在4G市场成了唯一的主流标准,WiMAX的电信运营商
                                                                                                                                     也逐渐向LTE转移,WiMAX论坛也于2012年将TD-LTE纳入WiMAX2.1规范,一些WiMAX运营商也开始将设备升级为TD-LTE.
            (8)   WiMAX debug level                                             CONFIG_WIMAX_DEBUG_LEVEL                            设置允许使用的最大调试信息详细等级,推荐使用默认值"8",设为"0"表示允许使用所有调试信息.运行时默认禁止使用
                                                                                                                                     调试信息,但可通过sysfs文件系统中的debug-levels文件开启调试信息.
  <*>   RF switch subsystem support  --->   
            --- RF switch subsystem support                                     CONFIG_RFKILL                                    为了节约电力,很多无线网卡和蓝牙设备都有内置的射频开关(RF switche)用于开启和关闭设备(通过rfkill命令).
                                                                                                                                     建议选"Y".更多详情参见"Documentation/rfkill.txt"文档                                                                                                
            [*]   RF switch input support                                       CONFIG_RFKILL_INPUT                                这是个反对使用的特性,一般情况下建议关闭.若关闭此项导致某些笔记本的无线网卡开关按钮失效,可以考虑开启.                                                                                                
            <M>   Generic rfkill regulator driver                               CONFIG_RFKILL_REGULATOR                            通用射频开关驱动,其射频开关连接在电压调节器(voltage regulator)上.依赖于CONFIG_REGULATOR框架.不确定的选"N"或"M"                                                                                                
            <M>   GPIO RFKILL driver                                            CONFIG_RFKILL_GPIO                                通用GPIO射频开关驱动.仅用于嵌入式环境,其射频开关连接在GPIO总线上,比如NVIDIA的Tegra和三星的Exynos 4智能手机SoC芯片.                                                                                                
  <M>   Plan 9 Resource Sharing Support (9P2000)  --->                          CONFIG_NET_9P                                    实验性的支持Plan 9的9P2000协议.                                                                                                
  <M>   CAIF support  --->                                                      CONFIG_CAIF                                        除非你为Android/MeeGo系统编译内核,并且需要使用PF_CAIF类型的socket,否则请选"N".                                                                                                
  {M}   Ceph core library                                                       CONFIG_CEPH_LIB                                    仅在你需要使用Ceph分布式文件系统,或者rados块设备(rbd)时选"Y".否则应选"N".                                                                                                
@ [ ]     Include file:line in ceph debug output                                                                                                   
@ [*]     Use in-kernel support for DNS lookup                                                                                                     
  <M>   NFC subsystem support  --->                                             CONFIG_NFC                                        NFC(近场通信)子系统.这些设备主要用于智能手机之类的嵌入式领域.                                                                   
  [ ]   Network light weight tunnels                                            CONFIG_LWTUNNEL                                    为MPLS(多协议标签交换)之类的轻量级隧道提供基础结构支持.不确定的选"N".                                                                   
@ < >   Network physical/parent device Netlink interface                                                                                           
                                选项                                                        |                   配置名                  |                    内容
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Generic Driver Options  --->                                                                                                      驱动程序通用选项.[提示]Linux Kernel Driver DataBase网站是搜索驱动程序与硬件型号对应关系的绝佳网站.如果你不知道某个驱动
                                                                                                                                            (例如"CONFIG_INTEL_IOATDMA")究竟对应着哪些型号的硬件,那么可以直接根据该驱动选项的首字母(本例是"I")进入对应的索引页
                                                                                                                                            去查找到该驱动的详情页面(本例是"https://cateee.net/lkddb/web-lkddb/INTEL_IOATDMA.html").[提示]可以使用"lspci -nn"
                                                                                                                                            与"lsusb"命令查看本机所有PCI/USB设备的"vendor id"与"device id"及文本名称.也可以根据已知的id到pci.ids与usb.ids数据库
                                                                                                                                            中搜索设备的名称.
            [*] Support for uevent helper                                                       CONFIG_UEVENT_HELPER                    早年的内核(切换到基于netlink机制之前),在发生uevent事件(通常是热插拔)时,需要调用用户空间程序(通常是"/sbin/hotplug"),以
                                                                                                                                            帮助完成uevent事件的处理.此选项就是用于开启此功能.由于目前的发行版都已不再需要此帮助程序,所以请选"N".此外,如果你
                                                                                                                                            使用了systemd或udev则必须选"N".                                                      
            ()    path to uevent helper                                                         CONFIG_UEVENT_HELPER_PATH                早年的内核(切换到基于netlink机制之前),在发生uevent事件(通常是热插拔)时,需要调用用户空间程序(通常是"/sbin/hotplug"),
                                                                                                                                            以帮助完成uevent事件的处理.此选项就是用于设定这个帮助程序的路径.由于目前的发行版都已不再需要此帮助程序,所以请保持
                                                                                                                                            空白.此外,如果你使用了systemd或udev则必须保持空白.                                                 
            [*] Maintain a devtmpfs filesystem to mount at /dev                                 CONFIG_DEVTMPFS                            devtmpfs是一种基于CONFIG_TMPFS的文件系统(与proc和sys有几分相似).在系统启动过程中,随着各个设备的初始化完成,内核将会自动
                                                                                                                                            在devtmpfs中创建相应的设备节点(使用默认的文件名和权限)并赋予正确的主次设备号.更进一步,在系统运行过程中,随着各种设备
                                                                                                                                            插入和拔除,内核也同样会自动在devtmpfs中创建和删除的相应的设备节点(使用默认的文件名和权限)并赋予正确的主次设备号.如果
                                                                                                                                            将devtmpfs挂载到"/dev"目录(通常是系统启动脚本),那么便拥有了一个全自动且全功能的"/dev"目录,而且用户空间程序(通常是udevd)
                                                                                                                                            还可以对其中的内容进行各种修改(增删节点,改变权限,创建符号链接).目前的发行版和各种嵌入式系统基本都依赖于此,除非你知道
                                                                                                                                            自己在做什么,否则请选"Y".                                                 
            [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs               CONFIG_DEVTMPFS_MOUNT                    在内核挂载根文件系统的同时,立即自动将devtmpfs挂载到"/dev"目录.因为此时init进程都还尚未启动,所以这就确保在进入用户空间之前,
                                                                                                                                            所有设备文件就都已经准备完毕.开启此选项相当于设置内核引导参数"devtmpfs.mount=1",关闭此选项相当于设置内核引导参数
                                                                                                                                            "devtmpfs.mount=0".开启此项后,你就可以放心的使用"init=/bin/sh"直接进入救援模式,而不必担心"/dev"目录空无一物.注意:此选项
                                                                                                                                            并不影响基于initramfs的启动,此种情况下,devtmpfs必须被手动挂载.所以,如果你的系统使用initrd或者有专门的启动脚本用于挂载
                                                                                                                                            "/dev"目录(大多数发行版都有这样的脚本),或者你看了前面的解释,还是不确定,那就选"N".对于实在想要使用"init=/bin/sh"直接进入
                                                                                                                                            救援模式的人来说,还是使用"init=/bin/sh devtmpfs.mount=1"吧!                                                 
            [ ] Select only drivers that do not need compile-time external firmware              CONFIG_STANDALONE                        只显示那些编译时不需要额外固件支持的驱动程序,除非你有某些怪异硬件,否则请选"Y".                                                 
            [*] Prevent firmware from being built                                               CONFIG_PREVENT_FIRMWARE_BUILD            不编译固件(firmware).固件一般是随硬件的驱动程序提供的,仅在更新固件的时候才需要重新编译.建议选"Y".                                                 
            -*- Userspace firmware loading support                                              CONFIG_FW_LOADER                        用户空间固件加载支持.如果内核自带的模块需要它,它将会被自动选中.但某些内核树之外的模块也可能需要它,这时候就需要你根据实际情况
                                                                                                                                            手动开启了.                                                 
            [*]   Include in-kernel firmware blobs in kernel binary                             CONFIG_FIRMWARE_IN_KERNEL                内核源码树中包含了许多驱动程序需要的二进制固件(blob),推荐的方法是通过"make firmware_install"将"firmware"目录中所需的固件复制
                                                                                                                                            到系统的"/lib/firmware/"目录中,然后由用户空间帮助程序在需要的时候进行加载.开启此项后,将会把所需的"blob"直接编译进内核,
                                                                                                                                            这样就可以无需用户空间程序的帮助,而直接使用这些固件了(例如:当根文件系统依赖于此类固件,而你又不想使用initrd的时候).每个需要
                                                                                                                                            此类二进制固件的驱动程序,都会有一个"Include firmware for xxx device"的选项,如果此处选"Y",那么这些选项都将被隐藏.建议选"N".                                                 
            ()    External firmware blobs to build into the kernel binary                       CONFIG_EXTRA_FIRMWARE                    指定要额外编译进内核的二进制固件(blob).此选项的值是一个空格分隔的固件文件名字符串,这些文件必须位于CONFIG_EXTRA_FIRMWARE_DIR
                                                                                                                                            目录中(其默认值是内核源码树下的"firmware"目录).                                                 
            [ ] Fallback user-helper invocation for firmware loading                            CONFIG_FW_LOADER_USER_HELPER            在内核自己直接加载固件失败后,作为补救措施,调用用户空间帮助程序(通常是udev)再次尝试加载.通常这个动作是不必要的,因此应该选"N",
                                                                                                                                            如果你使用了udev或systemd,则必须选"N".仅在某些特殊的固件位于非标准位置时,才需要选"Y".                                                 
            [*] Allow device coredump                                                           CONFIG_ALLOW_DEV_COREDUMP                为驱动程序开启coredump机制,仅供调试.                                                 
            [ ] Driver Core verbose debug messages                                              CONFIG_DEBUG_DRIVER                        让驱动程序核心在系统日志中产生冗长的调试信息,仅供调试                                                 
            [ ] Managed device resources verbose debug messages                                 CONFIG_DEBUG_DEVRES                        为内核添加一个"devres.log"引导参数.当被设为非零值时,将会打印出设备资源管理驱动(devres)的调试信息.仅供调试使用.                                                 
          @ [ ] Test driver remove calls during probe (UNSTABLE)                                                                         
          @ [ ] Enable verbose FENCE_TRACE messages                                                                                      
          @ [ ] DMA Contiguous Memory Allocator                                                                                          
      Bus devices  ----                                                                                                                              
  {*} Connector - unified userspace <-> kernelspace linker  --->  
            --- Connector - unified userspace <-> kernelspace linker                            CONFIG_CONNECTOR                        统一的用户空间和内核空间连接器,工作在netlink socket协议的顶层.连接器是非常便利的用户态与内核态的通信方式,这些驱动使内核知道
                                                                                                                                            当进程fork并使用proc连接器更改UID/GID/SID(会话ID).内核需要知道什么时候进程fork(CPU中运行多个任务)并执行,否则,内核可能会
                                                                                                                                            低效管理资源.内核有几个连接器应用实例:CONFIG_HYPERV_UTILS,CONFIG_FB_UVESA,CONFIG_W1_CON,CONFIG_DM_LOG_USERSPACE.另外还有
                                                                                                                                            一个给Gentoo装上启动画面的例子.建议选"Y".                                                          
            [*]   Report process events to userspace                                            CONFIG_PROC_EVENTS                        提供一个向用户空间报告进程事件(fork,exec,id变化(uid,gid,suid))的连接器.建议选"Y".                                                          
  <M> Memory Technology Device (MTD) support  --->  
            --- Memory Technology Device (MTD) support                                          CONFIG_MTD                                MTD子系统是一个闪存转换层.其主要目的是提供一个介于闪存硬件驱动程序与高级应用程序之间的抽象层,以简化闪存设备的驱动.注意:MTD常
                                                                                                                                            用于嵌入式系统,而我们常见的U盘/MMC卡/SD卡/CF卡等移动存储设备以及固态硬盘(SSD),虽然也叫"flash",但它们并不是使用MTD技术的
                                                                                                                                            存储器.仅在你需要使用主设备号为31的MTD块设备(/dev/romX,/dev/rromX,/dev/flashX,/dev/rflashX),或者主设备号为90的MTD字符设备
                                                                                                                                            (/dev/mtdX,/dev/mtdrX)时选"Y",否则选"N"                                                
          @ < >   MTD tests support (DANGEROUS)                                                                                         
          @ <M>   RedBoot partition table parsing                                                                                       
          @ (-1)    Location of RedBoot partition table                                                                                 
          @ [ ]     Include unallocated flash regions                                                                                           
          @ [ ]     Force read-only for RedBoot system images                                                                                   
          @ <M>   Command line partition table parsing                                                                                          
          @ <M>   TI AR7 partitioning support                                                                                                   
          @       *** User Modules And Translation Layers ***                                                                                   
          @ <M>   Caching block device access to MTD devices                                                                                    
          @ <M>     Readonly block device access to MTD devices                                                                                 
          @ <M>   FTL (Flash Translation Layer) support                                                                                         
          @ <M>   NFTL (NAND Flash Translation Layer) support                                                                                   
          @ [*]     Write support for NFTL                                                                                                      
          @ <M>   INFTL (Inverse NAND Flash Translation Layer) support                                                                          
          @ <M>   Resident Flash Disk (Flash Translation Layer) support                                                                         
          @ <M>   NAND SSFDC (SmartMedia) read only translation layer                                                                           
          @ <M>   SmartMedia/xD new translation layer                                                                                           
          @ <M>   Log panic/oops to an MTD buffer                                                                                               
          @ <M>   Swap on MTD device support                                                                                                    
          @ [ ]   Retain master device when partitioned                                                                                         
          @       RAM/ROM/Flash chip drivers  --->                                                                                              
          @       Mapping drivers for chip access  --->                                                                                         
          @       Self-contained MTD device drivers  --->                                                                                       
          @ [ ]   NAND ECC Smart Media byte order                                                                                               
          @ <M>   NAND Device Support  --->                                                                                                     
          @ <M>   OneNAND Device Support  --->                                                                                                  
          @       LPDDR & LPDDR2 PCM memory drivers  --->                                                                                       
          @ <M>   SPI-NOR device support  --->                                                                                                  
          @ <M>   Enable UBI - Unsorted block images  ---> 
  [ ] Device Tree and Open Firmware support  ----                                               CONFIG_OF                                        Device Tree基础架构与Open Firmware支持.主要用于嵌入式环境.不确定的选"N".内核中若有其它选项依赖于它,则会自动选中此项.                                                             
  <M> Parallel port support  --->  
            --- Parallel port support                                                           CONFIG_PARPORT                                    25针并口(LPT接口)支持.古董级的打印机或扫描仪可能使用这种接口.目前已被淘汰.
          @ <M>   PC-style hardware                                                             
          @ <M>     Multi-IO cards (parallel and serial)                                        
          @ [*]     Use FIFO/DMA if available                                                   
          @ [ ]     SuperIO chipset support                                                     
          @ <M>     Support for PCMCIA management for PC-style ports                            
          @ <M>   AX88796 Parallel Port                                                         
          @ [*]   IEEE 1284 transfer modes                                                      
  -*- Plug and Play support  --->  
            --- Plug and Play support                                                           CONFIG_PNP                                        即插即用(PnP)支持.选"Y"表示让Linux为PnP设备分配中断和I/O端口(需要在BIOS中开启"PnP OS"),选"N"则表示让BIOS来分配(需要在BIOS
                                                                                                                                                    中关闭"PnP OS").建议选"Y".                                                           
            [ ]   PNP debugging messages                                                        CONFIG_PNP_DEBUG_MESSAGES                        允许使用"pnp.debug"内核参数在系统启动过程中输出PnP设备的调试信息,建议选"N".                                                           
                  *** Protocols ***   
  [*] Block devices  ---> 
            --- Block devices                                                                   CONFIG_BLK_DEV                                    块设备,建议选"Y".                                                                        
            <M>   Null test block driver                                                        CONFIG_BLK_DEV_NULL_BLK                            仅供调试使用                                                                        
            <M>   Normal floppy disk support                                                    CONFIG_BLK_DEV_FD                                通用软驱支持.已被时代抛弃的设备                                                                        
          @ <M>   Parallel port IDE device support                                              CONFIG_PARIDE                                    通过并口与计算机连接的IDE设备,比如某些老旧的外接光驱或硬盘之类.此类设备早就绝种了                                                                        
          @         *** Parallel IDE high-level drivers ***                                                                                                             
          @ <M>     Parallel port IDE disks                                                                                                                             
          @ <M>     Parallel port ATAPI CD-ROMs                                                                                                                         
          @ <M>     Parallel port ATAPI disks                                                                                                                           
          @ <M>     Parallel port ATAPI tapes                                                                                                                           
          @ <M>     Parallel port generic ATAPI devices                                                                                                                 
          @         *** Parallel IDE protocol modules ***                                                                                                               
          @ <M>     ATEN EH-100 protocol                                                                                                                                
          @ <M>     MicroSolutions backpack (Series 5) protocol                                                                                                         
          @ <M>     DataStor Commuter protocol                                                                                                                          
          @ <M>     DataStor EP-2000 protocol                                                                                                                           
          @ <M>     FIT TD-2000 protocol                                                                                                                                
          @ <M>     FIT TD-3000 protocol                                                                                                                                
          @ <M>     Shuttle EPAT/EPEZ protocol                                                                                                                          
          @ [*]       Support c7/c8 chips                                                                                                                               
          @ <M>     Shuttle EPIA protocol                                                                                                                               
          @ <M>     Freecom IQ ASIC-2 protocol                                                                                                                          
          @ <M>     FreeCom power protocol                                                                                                                              
          @ <M>     KingByte KBIC-951A/971A protocols                                                                                                                   
          @ <M>     KT PHd protocol                                                                                                                                     
          @ <M>     OnSpec 90c20 protocol                                                                                                                               
          @ <M>     OnSpec 90c26 protocol                                                                                                                               
            <M>   Block Device Driver for Micron PCIe SSDs                                      CONFIG_BLK_DEV_PCIESSD_MTIP32XX                    Micron P320/P325/P420/P425 系列固态硬盘支持                                                                        
            <M>   Compressed RAM block device support                                           CONFIG_ZRAM                                        zram是一种基于压缩内存的虚拟块设备,它允许你创建"/dev/zramN"块设备文件,并将它当作普通的磁盘一样使用.它完全位于物理内存中,
                                                                                                                                                    并被实时压缩与解压以节约物理内存的用量,所有对"/dev/zramN"的读写实质上都是对内存的读写,从而可以获得比一般的磁盘快的
                                                                                                                                                    多的IO速度.常将它用做'/tmp'分区或作为swap分区挂载.你可以把它看作是CONFIG_BLK_DEV_RAM的升级版.具体用法可以参考内核文                                                                        
            <M>   Compaq Smart Array 5xxx support                                               CONFIG_BLK_CPQ_CISS_DA                            基于 Compaq Smart 控制器的磁盘阵列卡                                                                        
            [*]     SCSI tape drive support for Smart Array 5xxx                                CONFIG_CISS_SCSI_TAPE                            在基于 Compaq Smart 控制器的磁盘阵列卡上使用的磁带机                                                                        
            <M>   Mylex DAC960/DAC1100 PCI RAID Controller support                              CONFIG_BLK_DEV_DAC960                            Mylex DAC960, AcceleRAID, eXtremeRAID PCI RAID 控制器.很古董的设备了.                                                                        
            <M>   Micro Memory MM5415 Battery Backed RAM support                                CONFIG_BLK_DEV_UMEM                                一种使用电池做后备电源的内存,但被用作块设备,可以像硬盘一样被分区                                                                        
            <*>   Loopback device support                                                       CONFIG_BLK_DEV_LOOPloop                            是指拿文件来模拟块设备(/dev/loopX),比如可以将一个iso9660镜像文件当成文件系统来挂载.建议选"Y".                                                                        
            (8)     Number of loop devices to pre-create at init time                           CONFIG_BLK_DEV_LOOP_MIN_COUNT                    系统预先初始化的loop设备个数.此值可以通过内核引导参数"loop.max_loop"修改.如果你使用util-linux-2.21以上版本,建议设为"0"
                                                                                                                                                    (loop设备将通过/dev/loop-control动态创建),否则保持默认值即可.                                                                        
            <M>     Cryptoloop Support                                                          CONFIG_BLK_DEV_CRYPTOLOOP                        使用系统提供的CryptoAPI对loop设备加密.注意:因为不能在Cryptoloop上创建日志型文件系统(CONFIG_DM_CRYPT模块可以),
                                                                                                                                                    所以Cryptoloop已经逐渐淡出了.建议选"N".                                                                        
            <M>   DRBD Distributed Replicated Block Device support                              CONFIG_BLK_DEV_DRBD                                DRBD(Distributed Replicated Block Device)是一种分布式储存系统.DBRD处于文件系统之下,比文件系统更加靠近操作系统内核及IO栈.
                                                                                                                                                    DRBD类似RAID1磁盘阵列,只不过RAID1是在同一台电脑内,而DRBD是透过网络.注意:为了进行连接认证,你还需要选中CONFIG_CRYPTO_HMAC
                                                                                                                                                    以及相应的哈希算法.不确定的选"N".                                                                        
            [ ]     DRBD fault injection                                                           CONFIG_DRBD_FAULT_INJECTION                        模拟IO错误,以用于测试DRBD的行为.主要用于调试目的
            <M>   Network block device support                                                  CONFIG_BLK_DEV_NBD                                让你的电脑成为网络块设备的客户端,也就是可以挂载远程服务器通过TCP/IP网络提供的块设备(/dev/ndX).提示:这与NFS或Coda没有任何关系.
                                                                                                                                                    更多详情参见"Documentation/blockdev/nbd.txt".不确定的选"N".                                                                         
            <M>   STEC S1120 Block Driver                                                       CONFIG_BLK_DEV_SKD                                STEC公司的S1120 PCIe SSD                                                                         
            <M>   OSD object-as-blkdev support                                                  CONFIG_BLK_DEV_OSD                                允许将一个单独的 SCSI OSD(Object-Based Storage Devices) 对象当成普通的块设备来使用.举例来说,你可以在OSD设备上创建一个2G大小
                                                                                                                                                    的对象,然后通过本模块将其模拟成一个2G大小的块设备使用.不确定的选"N".                                                                         
            <M>   Promise SATA SX8 support                                                      CONFIG_BLK_DEV_SX8                                基于Promise公司的SATA SX8控制器的RAID卡                                                                         
            <*>   RAM block device support                                                      CONFIG_BLK_DEV_RAM                                内存中的虚拟磁盘,大小固定.详情参阅"Documentation/blockdev/ramdisk.txt".由于其功能比CONFIG_TMPFS和CONFIG_ZRAM弱许多,使用上也
                                                                                                                                                    不方便,所以除非你有明确的理由,否则应该选"N",并转而使用CONFIG_TMPFS或CONFIG_ZRAM.                                                                         
            (16)    Default number of RAM disks                                                 CONFIG_BLK_DEV_RAM_COUNT                        默认RAM disk的数量.请保持默认值,除非你知道自己在做什么.                                                                         
            (65536) Default RAM disk size (kbytes)                                              CONFIG_BLK_DEV_RAM_SIZE                            默认RAM disk的大小.请保持默认值,除非你知道自己在做什么.                                                                         
            [*]     Support Direct Access (DAX) to RAM block devices                            CONFIG_BLK_DEV_XIP                                XIP(eXecute In Place)支持(指应用程序可以直接在flash闪存内运行,不必再把代码读到系统RAM中).一般用于嵌入式设备.                                                                         
            <M>   Packet writing on CD/DVD media                                                CONFIG_CDROM_PKTCDVD                            CD/DVD刻录机支持.详情参见"Documentation/cdrom/packet-writing.txt"文档                                                                         
            (8)     Free buffers for data gathering                                             CONFIG_CDROM_PKTCDVD_BUFFERS                    用于收集写入数据的缓冲区个数(每个占用64Kb内存),缓冲区越多性能越好.                                                                         
            [ ]     Enable write caching                                                        CONFIG_CDROM_PKTCDVD_WCACHE                        为CD-R/W设备启用写入缓冲,目前这是一个比较危险的选项.建议关闭                                                                         
            <M>   ATA over Ethernet support                                                     CONFIG_ATA_OVER_ETH                                以太网ATA设备(ATA over Ethernet)支持.                                                                         
            <*>   Xen virtual block device support                                              CONFIG_XEN_BLKDEV_FRONTEND                        XEN虚拟块设备前端驱动.此驱动用于与实际驱动块设备的后端驱动(通常位于domain0)通信.                                                                         
            <M>   Xen block-device backend driver                                               CONFIG_XEN_BLKDEV_BACKEND                        XEN块设备后端驱动(通常位于domain0)允许内核将实际的块设备通过高性能的共享内存接口导出给其他客户端的前端驱动(通常位于非domain0)使用                                                                         
            <*>   Virtio block driver                                                           CONFIG_VIRTIO_BLKVirtio                            虚拟块设备驱动.仅可用在基于lguest或QEMU的半虚拟化客户机中(一般是KVM或XEN).                                                                         
            [ ]   Very old hard disk (MFM/RLL/IDE) driver                                       CONFIG_BLK_DEV_HD                                又老又旧的MFM/RLL/ESDI硬盘驱动.无需犹豫,选"N".                                                                         
            <M>   Rados block device (RBD)                                                      CONFIG_BLK_DEV_RBD                                rados块设备(rbd)支持.它可以与分布式文件系统Ceph合作,也能独立工作.                                                                         
            <M>   IBM Flash Adapter 900GB Full Height PCIe Device Driver                        CONFIG_BLK_DEV_RSXX                                IBM Flash Adapter 900GB Full Height PCIe SSD 驱动                                                                         
                                选项                                                        |                   配置名                  |                    内容
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   <M> NVM Express block device                                                                 CONFIG_BLK_DEV_NVME                                NVM Express是专门针对PCI-E接口高性能固态硬盘的标准规范.有了这一标准,操作系统厂商只需要编写一种驱动,
                                                                                                                                                    就可以支持不同厂商的不同PCI-E SSD设备,以解决过去PCI-E SSD产品形态与规格五花八门,缺乏通用性和
                                                                                                                                                    互用性的问题.如果你有一块较新的PCIE固态硬盘,那么很大可能就是NVMe接口                                                 
 @ [ ] SCSI emulation for NVMe device nodes                                                                                                      
 @ < > NVM Express over Fabrics RDMA host driver                                                                                                 
 @ < > NVMe Target support                                                                                                                       
      @ Misc devices  --->                                                                                                                       杂项设备       
           @ <M> Analog Devices Digital Potentiometers                                                                                                 
           @ <M>   support I2C bus connection                                                                                                          
           @ <M>   support SPI bus connection                                                                                                          
           @ <M> Dummy IRQ handler                                                                                                                     
           @ <M> Device driver for IBM RSA service processor                                                                                           
           @ <M> Sensable PHANToM (PCI)                                                                                                                
           @ <M> SGI IOC4 Base IO support                                                                                                              
           @ {M} TI Flash Media interface support                                                                                                      
           @ <M>   TI Flash Media PCI74xx/PCI76xx host adapter support                                                                                 
             <M> Integrated Circuits ICS932S401                                                 CONFIG_ICS932S401                                IDT ICS932S401 系列时钟频率控制芯片支持(可能会出现在某些主板上).                                                       
             <M> Enclosure Services                                                             CONFIG_ENCLOSURE_SERVICES                        SES(SCSI Enclosure Services)是SCSI协议中用于查询设备状态(温度/风扇/电源/指示灯)的一项服务.
                                                                                                                                                    这里的设备可以是移动硬盘盒/磁盘阵列柜/硬盘托架等.SES可以让主机端透过SCSI命令去控制外接SCSI设备
                                                                                                                                                    的电源/风扇以及其他与数据传输无关的东西.要使用这项技术,外置设备和主机上的SCSI/ATA控制芯片都需要
                                                                                                                                                    支持SES技术才OK.事实上,目前大多数外置移动硬盘和所有磁盘阵列柜都支持SES规范.                                                       
           @ <M> Channel interface driver for the HP iLO processor                                                                                     
           @ <M> Medfield Avago APDS9802 ALS Sensor module                                                                                             
           @ <M> Intersil ISL29003 ambient light sensor                                                                                                
           @ <M> Intersil ISL29020 ambient light sensor                                                                                                
           @ <M> Taos TSL2550 ambient light sensor                                                                                                     
           @ <M> BH1770GLC / SFH7770 combined ALS - Proximity sensor                                                                                   
           @ <M> APDS990X combined als and proximity sensors                                                                                           
           @ <M> Honeywell HMC6352 compass                                                                                                             
           @ <M> Dallas DS1682 Total Elapsed Time Recorder with Alarm                                                                                  
           @ <M> Texas Instruments DAC7512                                                                                                             
             <M> VMware Balloon Driver                                                          CONFIG_VMWARE_BALLOON                            VMware物理内存balloon驱动(将客户机操作系统不需要的物理内存页交还给宿主机).参见CONFIG_BALLOON_COMPACTION选项.                                                       
           @ <M> FSA9480 USB Switch                                                                                                                    
           @ <M> Lattice ECP3 FPGA bitstream configuration via SPI                                                                                     
             [*] Generic on-chip SRAM driver                                                    CONFIG_SRAM                                        许多SoC系统都有芯片内嵌的SRAM.开启此项后,就可以声明将此段内存范围交给通用内存分配器(genalloc)管理.不确定的选"N".                                                       
           @ <M> Parallel port LCD/Keypad Panel support                                                                                                
           @ (0)   Default parallel port number (0=LPT1)                                                                                               
           @ (5)   Default panel profile (0-5, 0=custom)                                                                                               
           @ [ ]   Change LCD initialization message ?                                                                                                 
           @ <M> Silicon Labs C2 port support  --->                                                                                                    
                 EEPROM support  --->                                                                                                           EEPROM主要用于保存主板或板卡的BIOS,如果你想通过此Linux系统刷写BIOS可以考虑开启相应的子项.不确定的全部选"N".
                      @ <M> I2C EEPROMs / RAMs / ROMs from most vendors                                               
                      @ <M> SPI EEPROMs from most vendors                                                             
                      @ <M> Old I2C EEPROM reader                                                                     
                      @ <M> Maxim MAX6874/5 power supply supervisor                                                   
                      @ {M} EEPROM 93CX6 support                                                                      
                      @ <M> Microwire EEPROM 93XX46 support    
           @ {M} ENE CB710/720 Flash memory card reader support                                                                                        
           @ [ ]   Enable driver debugging                                                                                                             
           @     Texas Instruments shared transport line discipline  --->                                                                              
           @ <M> STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (I2C)                                                                   
           @     *** Altera FPGA firmware download module ***                                                                                          
           @ {M} Altera FPGA firmware download module 
             {M} Intel Management Engine Interface                                              CONFIG_INTEL_MEI                                Intel芯片组管理引擎,是一种面向企业环境的远程管理技术,其中的重头戏是英特尔主动管理技术.如果你的芯片组位于
                                                                                                                                                    "CONFIG_INTEL_MEI_ME"中,可以考虑选"Y",不过如果你不明白这是什么东西,那就说明你不需要它,就应该选"N".
                                                                                                                                                    此外,在某些服务器上此驱动(mei)还可能可能导致监视程序计时器错误,还可能导致无法正常关机.                                                                                           
             <M> ME Enabled Intel Chipsets                                                      CONFIG_INTEL_MEI_ME                                请根据帮助中列出的芯片组对照实际情况选择.                                                                                           
             <M> Intel Trusted Execution Environment with ME Interface                                                                                                                     
             <M> VMware VMCI Driver                                                             CONFIG_VMWARE_VMCI                                VMware VMCI(Virtual Machine Communication Interface)是一个在host和guest之间以及同一host上的guest和guest之间
                                                                                                                                                    进行高速通信的虚拟设备.VMCI主要是提供一个接口让guest内的程序来调用,通过这个接口能在一个主机上的多个虚拟机
                                                                                                                                                    之间进行直接的通信,而且无需经过更上层的其他途径,这样将有效地降低网络通信所产生的开支,但是这需要修改虚拟机
                                                                                                                                                    上的软件,所以VMCI只适用于对虚拟机间通信要求非常高的情况.不确定的选"N".                                                                                           
           @     *** Intel MIC Bus Driver ***                                                                                                                                              
           @ <M> Intel MIC Bus Driver                                                                                                                                                      
           @     *** SCIF Bus Driver ***                                                                                                                                                   
           @ <M> SCIF Bus Driver                                                                                                                                                           
           @     *** VOP Bus Driver ***                                                                                                                                                    
           @ < > VOP Bus Driver                                                                                                                                                            
           @     *** Intel MIC Host Driver ***                                                                                                                                             
           @     *** Intel MIC Card Driver ***                                                                                                                                             
           @     *** SCIF Driver ***                                                                                                                                                       
           @ <M> SCIF Driver                                                                                                                                                               
           @     *** Intel MIC Coprocessor State Management (COSM) Drivers ***                                                                                                             
           @ < > Intel MIC Coprocessor State Management (COSM) Drivers                                                                                                                     
           @     *** VOP Driver ***                                                                                                                                                        
           @ <M> GenWQE PCIe Accelerator  --->                                                                                                                                             
           @ <M> Line Echo Canceller support
   < > ATA/ATAPI/MFM/RLL support (DEPRECATED)  ----                                             CONFIG_IDE                                        已被废弃的IDE硬盘和ATAPI光驱等接口的驱动(已被CONFIG_ATA取代).选"N",除非你确实知道自己在干什么.                                                                       
       SCSI device support  --->                                                                                                                SCSI子系统
            {M} RAID Transport Class                                                            CONFIG_RAID_ATTRS                               这只是用来得到RAID信息以及将来可能用于配置RAID方式的一个类.不管你的系统使用的是哪种RAID,都可以放心的关闭此项.
                                                                                                                                                    不确定的选"N".                                                    
            -*- SCSI device support                                                             CONFIG_SCSISCSI                                    协议支持.有任何SCSI/SAS/SATA/USB/Fibre Channel/FireWire设备之一就必须选上.选"Y".                                                    
            [ ] SCSI: use blk-mq I/O path by default                                            CONFIG_SCSI_MQ_DEFAULT                            对所有SCSI块设备默认使用新式的多重队列I/O调度机制(blk-mq),也就是将I/O请求分散至多个CPU处理以提高性能.相当于
                                                                                                                                                    开启"scsi_mod.use_blk_mq"内核模块参数.尤其适合于SSD(高IOP)/磁盘阵列(多通道)这类存储设备.                                                    
            [*] legacy /proc/scsi/ support                                                      CONFIG_SCSI_PROC_FS                                过时的/proc/scsi/接口.某些老旧的刻录程序可能需要它,建议选"N".                                                    
                *** SCSI support type (disk, tape, CD-ROM) ***                                                                                      
            <*> SCSI disk support                                                               CONFIG_BLK_DEV_SD                                使用SCSI/SAS/SATA/PATA/USB/Fibre Channel存储设备的必选.选"Y".                                                    
            <M> SCSI tape support                                                               CONFIG_CHR_DEV_ST                                通用SCSI磁带驱动                                                    
            <M> SCSI OnStream SC-x0 tape support                                                CONFIG_CHR_DEV_OSST                                专用于OnStream SC-x0/USB-x0/DI-x0的SCSI磁带/USB盘驱动                                                    
            <*> SCSI CDROM support                                                              CONFIG_BLK_DEV_SR                                通过SCSI/FireWire/USB/SATA/IDE接口连接的DVD/CD驱动器(基本上涵盖了所有常见的接口).                                                    
            [ ]   Enable vendor-specific extensions (for SCSI CDROM)                            CONFIG_BLK_DEV_SR_VENDOR                        仅在某些古董级的SCSI CDROM设备上才需要:NEC/TOSHIBA cdrom, HP Writers                                                    
            <*> SCSI generic support                                                            CONFIG_CHR_DEV_SG                                通用SCSI协议(/dev/sg*)支持.也就是除硬盘/光盘/磁带之外的SCSI设备(例如光纤通道).这些设备还需要额外的用户层工具
                                                                                                                                                    支持才能正常工作.例如:SANE,Cdrtools,CDRDAO,Cdparanoia                                                    
            <M> SCSI media changer support                                                      CONFIG_CHR_DEV_SCHSCSI                            介质转换设备(SCSI Medium Changer device)是一种控制多个SCSI介质的转换器(例如在多个磁带/光盘之间进行切换),常用
                                                                                                                                                    于控制磁带库或者CD自动点歌机(jukeboxes).此种设备会在/proc/scsi/scsi中以"Type: Medium Changer"列出.控制此
                                                                                                                                                    类设备的用户层工具包是scsi-changer.更多细节参见"Documentation/scsi/scsi-changer.txt"文档.不确定的选"N".                                                    
            <M> SCSI Enclosure Support                                                          CONFIG_SCSI_ENCLOSURE                            "Enclosure"是一种用于管理SCSI设备的背板装置.移动硬盘盒与磁盘阵列柜就是最常见的"Enclosure"设备.此项主要用于向
                                                                                                                                                    用户层报告一些"Enclosure"设备的状态,这些状态对于SCSI设备的正常运行并非必须.
                                                                                                                                                    此项依赖于CONFIG_ENCLOSURE_SERVICES选项.                                                    
            [*] Verbose SCSI error reporting (kernel size += 36K)                               CONFIG_SCSI_CONSTANTS                            以易读的方式报告SCSI错误,内核将会增大75K                                                   
            [*] SCSI logging facility                                                           CONFIG_SCSI_LOGGING                                启用SCSI日志(默认并不开启,需要"echo [bitmask] > /proc/sys/dev/scsi/logging_level"),可用于跟踪和捕获SCSI设备
                                                                                                                                                    的错误.关于[bitmask]的说明可以查看"drivers/scsi/scsi_logging.h"文件.不确定的选"N".                                                    
            [*] Asynchronous SCSI scanning                                                      CONFIG_SCSI_SCAN_ASYNC                            异步扫描的意思是,在内核引导过程中,SCSI子系统可以在不影响其他子系统引导的同时进行SCSI设备的探测(包括同时在
                                                                                                                                                    多个总线上进行检测),这样可以加快系统的引导速度.但是如果SCSI设备驱动被编译为模块,那么异步扫描将会导致
                                                                                                                                                    内核引导出现问题(解决方法是加载scsi_wait_scan模块,或者使用"scsi_mod.scan=sync"内核引导参数).不确定的选"N".                                                      
                SCSI Transports  --->                                                                                                             SCSI接口类型,下面的子项可以全不选,内核中若有其他部分依赖它,会自动选上
                       {M} Parallel SCSI (SPI) Transport Attributes                             CONFIG_SCSI_SPI_ATTRS                            传统的并行SCSI(Ultra320/160之类),已逐渐被淘汰                                                                
                       <M> FiberChannel Transport Attributes                                    CONFIG_SCSI_FC_ATTRS                            光纤通道接口                                                                
                       {M} iSCSI Transport Attributes                                           CONFIG_SCSI_ISCSI_ATTRS                            iSCSI协议是利用TCP/IP网络传送SCSI命令和数据的I/O技术                                                                
                       {M} SAS Transport Attributes                                             CONFIG_SCSI_SAS_ATTRS                            串行SCSI传输属性支持(SAS对于SPI的关系犹如SATA对于IDE),这是目前的主流接口                                                                
                       {M} SAS Domain Transport Attributes                                      CONFIG_SCSI_SAS_LIBSAS                            为使用了SAS Domain架构的驱动程序提供帮助.SAS Domain即整个SAS交换构架,由"SAS device"和"SAS expander device"组成,
                                                                                                                                                    其中Device又区分为Initiator和Target,它们可以直接对接起来,也可以经过Expander进行连接,Expander起到通道交换
                                                                                                                                                    或者端口扩展的作用.看不懂就说明你不需要它.                                                                
                       [*]   ATA support for libsas (requires libata)                           CONFIG_SCSI_SAS_ATA                                在libsas中添加ATA支持,从而让libata和libsas协同工作.                                                                
                       [*]   Support for SMP interpretation for SAS hosts                       CONFIG_SCSI_SAS_HOST_SMP                        在libsas中添加SMP解释器,以允许主机支持SAS SMP协议                                                                
                       {M} SRP Transport Attributes                                             CONFIG_SCSI_SRP_ATTRS                            SCSI RDMA 协议(SCSI RDMA Protocol)通过将SCSI数据传输阶段映射到Infiniband远程直接内存访问
                                                                                                                                                    (Remote Direct Memory Access)操作加速了SCSI协议.                                                                
            [*] SCSI low-level drivers  --->       
                      --- SCSI low-level drivers                                                CONFIG_SCSI_LOWLEVEL                            底层SCSI驱动程序                                                           
                      <M>   iSCSI Initiator over TCP/IP                                         CONFIG_ISCSI_TCPiSCSI                            协议利用TCP/IP网络在"initiator"与"targets"间传送SCSI命令和数据.此选项便是iSCSI initiator驱动.相关的用户层
                                                                                                                                                    工具/文档/配置示例,可以在open-iscsi找到.                                                           
                      {M}   iSCSI Boot Sysfs Interface                                          CONFIG_ISCSI_BOOT_SYSFS                            通过sysfs向用户空间显示iSCSI的引导信息.不确定的选"N".                                                           
                    @ <M>   Chelsio T3 iSCSI support                                                                                                       
                    @ <M>   Chelsio T4 iSCSI support                                                                                                       
                    @ <M>   QLogic NetXtreme II iSCSI support                                                                                              
                    @ <M>   QLogic FCoE offload support                                                                                                    
                    @ <M>   Emulex 10Gbps iSCSI - BladeEngine 2                                                                                            
                    @ <M>   3ware 5/6/7/8xxx ATA-RAID support                                                                                              
                    @ <M>   HP Smart Array SCSI driver                                                                                                     
                    @ <M>   3ware 9xxx SATA-RAID support                                                                                                   
                    @ <M>   3ware 97xx SAS/SATA-RAID support                                                                                               
                    @ <M>   ACARD SCSI support                                                                                                             
                    @ <M>   Adaptec AACRAID support                                                                                                        
                    @ <M>   Adaptec AIC7xxx Fast -> U160 support (New Driver)                                                                              
                    @ (8)     Maximum number of TCQ commands per device                                                                                    
                    @ (5000)  Initial bus reset delay in milli-seconds                                                                                     
                    @ [ ]     Compile in Debugging Code                                                                                                    
                    @ (0)     Debug code enable mask (2047 for all debugging)                                                                              
                    @ [*]     Decode registers during diagnostics                                                                                          
                    @ <M>   Adaptec AIC79xx U320 support                                                                                                   
                    @ (32)    Maximum number of TCQ commands per device                                                                                    
                    @ (5000)  Initial bus reset delay in milli-seconds                                                                                     
                    @ [ ]     Compile in Debugging Code                                                                                                    
                    @ (0)     Debug code enable mask (16383 for all debugging)                                                                             
                    @ [*]     Decode registers during diagnostics                                                                                          
                    @ <M>   Adaptec AIC94xx SAS/SATA support                                                                                               
                    @ [ ]     Compile in debug mode                                                                                                        
                    @ <M>   Marvell 88SE64XX/88SE94XX SAS/SATA support                                                                                     
                    @ [ ]     Compile in debug mode                                                                                                        
                    @ [ ]     Support for interrupt tasklet                                                                                                
                    @ <M>   Marvell UMI driver                                                                                                             
                    @ <M>   Adaptec I2O RAID support                                                                                                       
                    @ <M>   AdvanSys SCSI support                                                                                                          
                    @ <M>   ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter                                                                      
                    @ <M>   ATTO Technology ExpressSAS RAID adapter driver                                                                               
                    @ [*]   LSI Logic New Generation RAID Device Drivers     
                    @ <M>     LSI Logic Management Module (New Driver)                                                                                       
                    @ <M>       LSI Logic MegaRAID Driver (New Driver)                                                                                       
                    @ <M>   LSI Logic Legacy MegaRAID Driver                                                                                                 
                    @ <M>   LSI Logic MegaRAID SAS RAID Module                                                                                               
                    @ {M}   LSI MPT Fusion SAS 3.0 & SAS 2.0 Device Driver                                                                                   
                    @ (128)   LSI MPT Fusion SAS 2.0 Max number of SG Entries (16 - 256)                                                                     
                    @ (128)   LSI MPT Fusion SAS 3.0 Max number of SG Entries (16 - 256)                                                                     
                    @ <M>   Legacy MPT2SAS config option                                                                                                     
                    @ < >   Microsemi PQI Driver                                                                                                             
                    @ <M>   Universal Flash Storage Controller Driver Core                                                                                   
                    @ <M>     PCI bus based UFS Controller support                                                                                           
                    @ < >       DesignWare pci support using a G210 Test Chip                                                                                
                    @ <M>     Platform bus based UFS Controller support                                                                                      
                    @ < >       DesignWare platform support using a G210 Test Chip                                                                           
                    @ <M>   HighPoint RocketRAID 3xxx/4xxx Controller support                                                                                
                    @ <M>   BusLogic SCSI support                                                                                                            
                    @ [*]     FlashPoint support                                                                                                             
                      <M>   VMware PVSCSI driver support                                        CONFIG_VMWARE_PVSCSI                            VMware半虚拟化的SCSI HBA控制器                                                             
                    @ <M>   XEN SCSI frontend driver                                                                                                         
                      <M>   Microsoft Hyper-V virtual storage driver                            CONFIG_HYPERV_STORAGE                            微软的Hyper-V虚拟存储控制器                                                             
                    @ <M>   LibFC module                                                                                                                     
                    @ <M>     LibFCoE module                                                                                                                 
                    @ <M>       FCoE module                                                                                                                  
                    @ <M>       Cisco FNIC Driver                                                                                                            
                    @ <M>   Cisco SNIC Driver                                                                                                                
                    @ [ ]     Cisco SNIC Driver Debugfs Support                                                                                              
                    @ <M>   DMX3191D SCSI support                                                                                                            
                    @ <M>   EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support                                                            
                    @ [*]     enable tagged command queueing                                                                                                 
                    @ [*]     enable elevator sorting                                                                                                        
                    @ (16)    maximum number of queued commands                                                                                              
                    @ <M>   Future Domain 16xx SCSI/AHA-2920A support                                                                                        
                    @ <M>   Intel/ICP (former GDT SCSI Disk Array) RAID Controller support 
                    @ <M>   Intel(R) C600 Series Chipset SAS Controller                                                                                                        
                    @ <M>   IBM ServeRAID support                                                                                                                              
                    @ <M>   Initio 9100U(W) support                                                                                                                            
                    @ <M>   Initio INI-A100U2W support                                                                                                                         
                    @ <M>   IOMEGA parallel port (ppa - older drives)                                                                                                          
                    @ <M>   IOMEGA parallel port (imm - newer drives)                                                                                                          
                    @ [ ]   ppa/imm option - Use slow (but safe) EPP-16                                                                                                        
                    @ [ ]   ppa/imm option - Assume slow parport control register                                                                                              
                    @ <M>   Promise SuperTrak EX Series support                                                                                                                
                    @ <M>   SYM53C8XX Version 2 SCSI support                                                                                                                   
                    @ (1)     DMA addressing mode                                                                                                                              
                    @ (16)    Default tagged command queue depth                                                                                                               
                    @ (64)    Maximum number of queued commands                                                                                                                
                    @ [*]     Use memory mapped IO                                                                                                                             
                    @ <M>   IBM Power Linux RAID adapter support                                                                                                               
                    @ [*]     enable driver internal trace                                                                                                                     
                    @ [*]     enable adapter dump support                                                                                                                      
                    @ <M>   Qlogic QLA 1240/1x80/1x160 SCSI support                                                                                                            
                    @ <M>   QLogic QLA2XXX Fibre Channel Support                                                                                                               
                    @ <M>     TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs                                                                               
                    @ [ ]       TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target mode HBAs                                                                  
                    @ <M>   QLogic ISP4XXX and ISP82XX host adapter family support                                                                                             
                    @ <M>   Emulex LightPulse Fibre Channel Support                                                                                                            
                    @ [ ]     Emulex LightPulse Fibre Channel debugfs Support                                                                                                  
                    @ <M>   Tekram DC395(U/UW/F) and DC315(U) SCSI support                                                                                                     
                    @ <M>   Tekram DC390(T) and Am53/79C974 SCSI support (new driver)                                                                                          
                    @ <M>   Western Digital WD7193/7197/7296 support                                                                                                           
                    @ <M>   SCSI debugging host and device simulator                                                                                                           
                    @ <M>   PMC SIERRA Linux MaxRAID adapter support                                                                                                           
                    @ <M>   PMC-Sierra SPC 8001 SAS/SATA Based Host Adapter driver                                                                                             
                    @ <M>   Brocade BFA Fibre Channel Support                                                                                                                  
                      <M>   virtio-scsi support                                                 CONFIG_SCSI_VIRTIOvirtio                        虚拟HBA控制器.仅可用在基于lguest或QEMU的半虚拟化客户机中(一般是KVM或XEN).                                                                               
                    @ <M>   Chelsio Communications FCoE support                                                                                                                
            [*] PCMCIA SCSI adapter support  --->                                               CONFIG_SCSI_LOWLEVEL_PCMCIA                        通过PCMCIA卡与计算机连接的SCSI设备                                                                               
            [ ] SCSI Device Handlers  ----                                                      CONFIG_SCSI_DH                                    针对某些多路径安装的SCSI设备的驱动,用在每个节点都需要一个到SCSI存储单元的直接路径的集群中,具体子项请按照
                                                                                                                                                    实际使用的控制器进行选择                                                             
            <M> OSD-Initiator library                                                           CONFIG_SCSI_OSD_INITIATOR                        OSD(Object-Based Storage Device)协议是一个T10 SCSI命令集,和SCSI处于同一级别,也跟SCSI很类似,分成
                                                                                                                                                    osd-initiator/osd-target两部分,用于对象存储文件系统,此选项实现了OSD-Initiator库(libosd.ko).更多细节参见
                                                                                                                                                    "Documentation/scsi/osd.txt"文件.看不懂就说明你不需要.[提示]此选项依赖于CONFIG_CRYPTO_SHA1和CONFIG_CRYPTO_HMAC模块.                                                           
            <M>   OSD Upper Level driver                                                        CONFIG_SCSI_OSD_ULD                                提供OSD上层驱动(也就是向用户层提供/dev/osdX设备).从而允许用户层控制OSD设备(比如挂载基于OSD的exofs文件系统).                                                    
          @ (1)   (0-2) When sense is returned, DEBUG print all sense descriptors                                                                   
          @ [ ]   Compile All OSD modules with lots of DEBUG prints                                                                                 

                                选项                                                        |                   配置名                  |                    内容
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   <*> Serial ATA and Parallel ATA drivers (libata)  --->                                                                                             
             --- Serial ATA and Parallel ATA drivers (libata)                                      CONFIG_ATA                                    SATA与PATA(IDE)设备.桌面级PC以及低端服务器的硬盘基本都是此种接口                                                                        
             [*]   Verbose ATA error reporting                                                     CONFIG_ATA_VERBOSE_ERROR                        输出详细的ATA命令描述信息.大约会让内核增大6KB.禁用它将会导致调试ATA设备错误变得困难.                                                                        
             [*]   ATA ACPI Support                                                                CONFIG_ATA_ACPI                                与ATA相关的ACPI对象支持.这些对象与性能/安全/电源管理等相关.不管你使用的是IDE硬盘还是SATA硬盘,
                                                                                                                                                    都建议开启(可以使用内核引导参数"libata.noacpi=1"关闭).                                                                        
             [*]     SATA Zero Power Optical Disc Drive (ZPODD) support                            CONFIG_SATA_ZPODD                            这是SATA-3.1版规范新增的节能相关内容,用新的电源管理策略降低了整个系统的电力需求,可以让处于空闲
                                                                                                                                                    状态的光驱耗电量近乎于零.这需要主板和光驱两者都支持SATA-3.1规范才                                                                        
             [*]   SATA Port Multiplier support                                                    CONFIG_SATA_PMP                                SATA端口复用器(Port Multiplier)是一个定义在SATA规范里面的可以选择的功能,可以把一个活动主机连接
                                                                                                                                                    多路复用至多个设备连接,相当于一个SATA HUB.不确定的选"N".                                                                        
                   *** Controllers with non-SFF native interface ***                                                                                                       
             <M>   AHCI SATA support                                                               CONFIG_SATA_AHCI                                AHCI SATA 支持.这是最佳的SATA模式(NCQ功能依赖于它).某些主板还需要在BIOS中将硬盘明确设为AHCI模式.
                                                                                                                                                    使用SATA硬盘者必选"Y".[提示]由于各厂商芯片组内的SATA控制器都遵循同一种规范,所以并不需要各种
                                                                                                                                                    各样针对不同SATA控制器的驱动,就这一个驱动基本就能通吃所有SATA控制器了,
                                                                                                                                                    这比丰富多彩的网卡驱动省事多了.                                                                        
             <M>   Platform AHCI SATA support                                                      CONFIG_SATA_AHCI_PLATFORM                    这是用于嵌入式系统的与AHCI接口兼容的SATA驱动.并不是常见的芯片组中的SATA控制器驱动.不确定的选"N".                                                                        
             <M>   Initio 162x SATA support (Very Experimental)                                                                                                            
             <M>   ACard AHCI variant (ATP 8620)                                                                                                                           
             <M>   Silicon Image 3124/3132 SATA support                                                                                                                    
             [*]   ATA SFF support (for legacy IDE and PATA)                                       CONFIG_ATA_SFF                                使用SATA硬盘的用户可无视此项,选"N"即可.对于依然使用老旧的IDE/PATA硬盘的用户而言,按照实际情况在
                                                                                                                                                    子项中选择相应的控制器驱动即可.                                                                        
                     *** SFF controllers with custom DMA interface ***                                                                                                     
             <M>     Pacific Digital ADMA support                                                                                                                          
             <M>     Pacific Digital SATA QStor support                                                                                                                    
             <M>     Promise SATA SX4 support (Experimental)                                                                                                               
             [*]     ATA BMDMA support                                                             CONFIG_ATA_BMDMA                                这是IDE控制器的事实标准.除了上世纪的古董外,绝大多数芯片组都遵守这个标准,选"Y",然后从子项中选择
                                                                                                                                                    恰当的芯片组/控制器.                                                                        
                       *** SATA SFF controllers with BMDMA ***                                                                                                             
             <*>       Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support                                                                                                      
             < >       DesignWare Cores SATA support                                                                                                                       
                        .......
                     *** Generic fallback / legacy drivers ***                                                                                      
             <M>     ACPI firmware driver for PATA                                                 CONFIG_PATA_ACPI                                通过ACPI BIOS去操作IDE控制器.仅用于某些比较奇特的IDE控制器.选"N".                                                       
             <*>     Generic ATA support                                                           CONFIG_ATA_GENERIC                            这是通用的IDE控制器驱动.如果你无法确定IDE控制器的具体型号(比如需要面对未知的硬件状况),或者不想
                                                                                                                                                    使用针对特定芯片组的IDE驱动,就选"Y"吧.                                                    
           @ <M>     Legacy ISA PATA support (Experimental)
   [*] Multiple devices driver support (RAID and LVM)  --->    
             --- Multiple devices driver support (RAID and LVM)                                    CONFIG_MD                                    多设备支持(RAID和LVM).RAID和LVM的功能是使用多个物理设备组建成一个单独的逻辑设备                                                           
             {*}   RAID support                                                                    CONFIG_BLK_DEV_MD                            "Software RAID"(需要使用mdadm工具)支持.也就是"软RAID".使用硬件RAID卡的用户并不需要此项.                                                           
             [*]     Autodetect RAID arrays during kernel boot                                     CONFIG_MD_AUTODETECT                            在内核启动过程中自动检测RAID模式.如果你没有使用RAID,那么选中此项将会让内核在启动过程中增加几秒
                                                                                                                                                    延迟.如果你使用了"raid=noautodetect"内核引导参数关闭了自动检测,或者此处选了"N",那么你必须
                                                                                                                                                    使用"md=???"内核引导参数明确告诉内核RAID模式及配置.                                                           
             <M>     Linear (append) mode                                                          CONFIG_MD_LINEAR                                线性模式(简单的将一个分区追加在另一个分区之后),一般不使用这种模式.                                                           
             <M>     RAID-0 (striping) mode                                                        CONFIG_MD_RAID0                                RAID-0(等量分割)模式,可以获取最高性能,但是却损害了可靠性,一般也不使用这种模式.                                                           
             {M}     RAID-1 (mirroring) mode                                                       CONFIG_MD_RAID1                                RAID-1(镜像)模式.包含内核的引导分区只能使用这种模式.                                                           
             {M}     RAID-10 (mirrored striping) mode                                              CONFIG_MD_RAID10                                RAID 1+0 模式                                                           
             {M}     RAID-4/RAID-5/RAID-6 mode                                                     CONFIG_MD_RAID456                            RAID-4/RAID-5/RAID-6 模式                                                           
             <M>     Multipath I/O support                                                         CONFIG_MD_MULTIPATH                            多路径IO支持是指在服务器和存储设备之间使用冗余的物理路径组件创建"逻辑路径",如果这些组件发生故障
                                                                                                                                                    并造成路径失败,多路径逻辑将为I/O使用备用路径以使应用程序仍然可以访问其数据.该选项已废弃,
                                                                                                                                                    并已被CONFIG_DM_MULTIPATH所取代.选"N".                                                           
             <M>     Faulty test module for MD                                                     CONFIG_MD_FAULTY                                用于MD(Multi-device)的缺陷测试模块,仅用于调试.                                                           
           @ <M>     Cluster Support for MD (EXPERIMENTAL)                                                                                                    
             <M>   Block device as cache                                                           CONFIG_BCACHE                                将一个块设备用作其他块设备的缓存(Bcache).此缓存使用btree(平衡树)索引,并专门为SSD进行了优化.仅在
                                                                                                                                                    你打算使用高速SSD作为普通硬盘的缓存时才需要此功能.详情参见"Documentation/bcache.txt"文档.                                                           
             [ ]     Bcache debugging                                                              CONFIG_BCACHE_DEBUG                            仅供内核开发者调试使用                                                           
             [ ]     Debug closures                                                                CONFIG_BCACHE_CLOSURES_DEBUG                    仅供内核开发者调试使用                                                           
             <*>   Device mapper support                                                           CONFIG_BLK_DEV_DM                            Device-mapper是一个底层的卷管理器,提供了一种从逻辑设备到物理设备的映射框架,用户可以很方便的根据
                                                                                                                                                    自己的需要制定存储资源的管理策略.它不像RAID那样工作在设备层,而是通过块和扇区的映射机制,将不同
                                                                                                                                                    磁盘的不同部分组合成一个大的块设备供用户使用.LVM2和EVMS都依赖于它.此外,那些集成在南桥
                                                                                                                                                    (例如ICH8R/ICH9R/ICH10R系列等)中所谓的"硬RAID"(准确的称呼应该是"Device Mapper RAID",又称为
                                                                                                                                                    "Fake RAID"/"BIOS RAID")也依赖于它.还有企业级高可用环境中经常使用的多路径设备也依赖于它.                                                           
             [ ]     request-based DM: use blk-mq I/O path by default                              CONFIG_DM_MQ_DEFAULT                            对所有Device-mapper块设备默认使用新式的多重队列I/O调度机制(blk-mq),也就是将I/O请求映射至多个硬件
                                                                                                                                                    或软件队列以提高性能.相当于开启"dm_mod.use_blk_mq"内核模块参数.推荐选"Y".                                                           
             [ ]     Device mapper debugging support                                               CONFIG_DM_DEBUG                                仅供内核开发者调试使用                                                           
             [ ]     Keep stack trace of persistent data block lock holders                        CONFIG_DM_DEBUG_BLOCK_STACK_TRACING            仅供内核开发者调试使用                                                           
             <M>     Crypt target support                                                          CONFIG_DM_CRYPT                                此模块允许你创建一个经过透明加密的逻辑设备(使用cryptsetup工具),要使用加密功能,除此项外,还需要在
                                                                                                                                                    "Cryptographic API"里选中相应的加密算法,例如CONFIG_CRYPTO_AES.更多文档请参考LUKS FAQ.                                                           
             <M>     Snapshot target                                                               CONFIG_DM_SNAPSHOT                            允许卷管理器为DM设备创建可写的快照(定格于特定瞬间的一个设备虚拟映像).LVM2 Snapshot需要它的支持.
                                                                                                                                                    更多详情参见"Documentation/device-mapper/snapshot.txt"文档.不确定的选"N".                                                           
             <M>     Thin provisioning target                                                      CONFIG_DM_THIN_PROVISIONING                    "Thin provisioning"(某些地方翻译为"精简配置")的意思是允许分配给所有用户的总存储容量超过实际的
                                                                                                                                                    存储容量(使用thin-provisioning-tools工具).例如给100个用户分配空间,每个用户最大允许10G空间,
                                                                                                                                                    共计需要1000G空间.但实际情况是95%的用户都只使用了不到1G的空间,那么实际准备1000G空间就是浪费.
                                                                                                                                                    有了"thin provisioning"的帮助,你实际只需要准备150G的空间就可以了,之后,可以随着用户需求的增加,
                                                                                                                                                    添加更多的实际存储容量,从而减少存储投资和避免浪费.
                                                                                                                                                    更多详情参见"Documentation/device-mapper/thin-provisioning.txt"文档.                                                           
             <M>     Cache target (EXPERIMENTAL)                                                   CONFIG_DM_CACHE                                dm-cache通过将频繁使用的热点数据缓存到一个容量较小但性能很高的存储设备上,从而提升块设备的性能.
                                                                                                                                                    它支持writeback和writethrough两种模式,并可以使用多种缓存策略(policy)以判断哪些是热点数据以及
                                                                                                                                                    哪些数据需要从缓存中移除.更多详情参见"Documentation/device-mapper/cache.txt"文档.不确定的选"N".                                                           
             <M>       Stochastic MQ Cache Policy (EXPERIMENTAL)                                   CONFIG_DM_CACHE_MQ                            MQ缓存策略.这是目前唯一真正可用的缓存策略.                                                           
             <M>       Cleaner Cache Policy (EXPERIMENTAL)                                         CONFIG_DM_CACHE_CLEANER                        Cleaner简单的把所有数据都同步写入到原始设备上,相当于关闭缓存.                                                           
             <M>     Era target (EXPERIMENTAL)                                                     CONFIG_DM_ERA                                跟踪块设备上的哪些部分被写入,用于在使用vendor快照时维护缓存一致性.不确定的选"N".                                                           
             <M>     Mirror target                                                                 CONFIG_DM_MIRROR                                允许对逻辑卷进行镜像,同时实时数据迁移工具pvmove也需要此项的支持.                                                           
             <M>       Mirror userspace logging                                                    CONFIG_DM_LOG_USERSPACE                        device-mapper用户空间日志功能由内核模块和用户空间程序两部分组成,此选项是内核模块(API定义于
                                                                                                                                                    "linux/dm-dirty-log.h"文件).不确定的选"N".                                                          
             <M>     RAID 1/4/5/6/10 target                                                        CONFIG_DM_RAID                                RAID 1/4/5/6/10 支持.即使使用ICH8R/ICH9R/ICH10R这样的南桥,也不推荐使用"Device Mapper RAID"
                                                                                                                                                    (既无性能优势又依赖于特定硬件),应该直接使用更成熟的CONFIG_BLK_DEV_MD模块.                                                            
             <M>     Zero target                                                                   CONFIG_DM_ZERO                                "Zero target"类似于"/dev/zero",所有的写入都被丢弃,所有的读取都可以得到无限多个零.可用于某些恢复场合.                                                           
             <M>     Multipath target                                                              CONFIG_DM_MULTIPATH                            设备映射多路径(DM-Multipath)支持.常用于对可靠性要求比较苛刻的场合.                                                           
             <M>       I/O Path Selector based on the number of in-flight I/Os                     CONFIG_DM_MULTIPATH_QL                        这是一个动态负载均衡路径选择器:选择当前正在处理中的I/O数量最小的通路.                                                           
             <M>       I/O Path Selector based on the service time                                 CONFIG_DM_MULTIPATH_ST                        这是一个动态负载均衡路径选择器:选择完成此I/O操作预期时间最少的通路.                                                           
             <M>     I/O delaying target                                                           CONFIG_DM_DELAY                                对读/写操作进行延迟,并可将其发送到不同的设备.仅用于测试DM子系统.                                                           
             [*]     DM uevents                                                                    CONFIG_DM_UEVENT                                为DM事件透过netlink向用户层的udevd发出uevent通知,这样就允许udevd在"/dev/"目录中执行相应的操作                                                           
             <M>     Flakey target                                                                 CONFIG_DM_FLAKEY                                模拟间歇性的I/O错误,以用于调试DM子系统                                                           
             <M>     Verity target support                                                         CONFIG_DM_VERITY                                Verity target 可以创建一个只读的逻辑设备,然后根据预先生成的哈希校验和(存储在其他设备上),校验底层设备
                                                                                                                                                    上的数据正确性.要使此模块正常工作,还需要在"Cryptographic API"部分选中相应的哈希算法.                                                           
           @ [ ]       Verity forward error correction support                                                    
             <M>     Switch target support (EXPERIMENTAL)                                          CONFIG_DM_SWITCH                                Switch target 可以创建这样的逻辑设备:将固定尺寸区块的I/O操作任意映射到一组固定的路径上.通过向target
                                                                                                                                                    发送一个消息,即可动态的切换指定区块的I/O操作所使用的路径.                                                                                                               
             <M>     Log writes target support                                                        CONFIG_DM_LOG_WRITES                            此种target需要两个设备:主设备按照常规方式使用,辅设备则专门记录所有主设备的写操作.主要用于帮助文件系统
                                                                                                                                                    的开发者验证文件系统的一致性,仅供开发调试使用.                        
   <M> Generic Target Core Mod (TCM) and ConfigFS Infrastructure  --->                              CONFIG_TARGET_CORE                            通用TCM存储引擎与ConfigFS虚拟文件系统(/sys/kernel/config)支持.看不懂就说明你不需要.
   [*] Fusion MPT device support  --->                                                             CONFIG_FUSION                                Fusion MPT(Message Passing Technology) 是 LSI Logic 公司为了更容易实现SCSI和光纤通道而提出的技术,
                                                                                                                                                    支持Ultra320 SCSI/光纤通道/SAS.                                                   
       IEEE 1394 (FireWire) support  --->                                                                                                       火线(IEEE 1394)是苹果公司开发的串行接口,类似于USB,但PC上并不常见,算得上是个没有未来的技术了.                                      
   [*] Macintosh device drivers  --->                                                              CONFIG_MACINTOSH_DRIVERS                        苹果的Macintosh电脑上的专有设备驱动                                                   
   -*- Network device support  --->   
            --- Network device support                                                             CONFIG_NETDEVICES                            网络设备.除非你不想连接任何网络,否则必选"Y".                                                
            [*]   Network core driver support                                                      CONFIG_NET_CORE                                如果你不想使用任何高级网络功能(拨号网络/EQL/VLAN/bridging/bonding/team/光纤通道/虚拟网络等),仅仅
                                                                                                                                                    是一般性质的联网(普通低端服务器,通过路由器或者局域网上网的常规个人电脑或办公电脑),可以选"N".                                                
            <M>     Bonding driver support                                                         CONFIG_BONDING                                链路聚合技术拥有多个不同的称谓:Linux称为"Bonding",IEEE称为"802.3ad",Sun称为"Trunking",Cisco称为
                                                                                                                                                    "Etherchannel".该技术可以将多个以太网通道聚合为一个单独的虚拟适配器,例如将两块网卡聚合成一个
                                                                                                                                                    逻辑网卡,可以用来实现负载均衡或硬件冗余.此项技术目前已逐渐被CONFIG_NET_TEAM取代.                                                
            <M>     Dummy net driver support                                                       CONFIG_DUMMYDummy                            网络接口本质上是一个可以配置IP地址的bit-bucket(位桶,所有发送到此设备的流量都将被湮灭),以使应用程序
                                                                                                                                                    看上去正在和一个常规的网络接口进行通信.使用SLIP(小猫拨号,目前应该已经绝迹了)或
                                                                                                                                                    PPP(常用于PPPoE ADSL)的用户需要它                                                
            <M>     EQL (serial line load balancing) support                                       CONFIG_EQUALIZER                                串行线路的负载均衡.如果有两个MODEM和两条SLIP/PPP线路,该选项可以让你同时使用这两个通道以达到双倍速度
                                                                                                                                                    (网络的对端也要支持EQL技术).曾经昙花一现的ISDN就这项技术的一个实例.                                                
            [*]     Fibre Channel driver support                                                   CONFIG_NET_FC                                光纤通道(Fibre Channel)是一种高速网络串行协议,主要用于存储局域网(SAN),与传统的iSCSI技术相比,除了提供
                                                                                                                                                    更高的数据传输速度(此优势不是绝对的),更远的传输距离,更多的设备连接支持,更稳定的性能,更简易的安装
                                                                                                                                                    以外,最重要的是支持网络区域存储(SAN)技术.FC与SCSI兼容,并意在取代iSCSI(看起来难以如愿,并且有可能
                                                                                                                                                    被40Gb以上的iSCSI反超).如果你的机器上有光纤通道卡(FC卡),除了需要开启此项外,还需要开启相应的FC卡
                                                                                                                                                    驱动,以及CONFIG_CHR_DEV_SG选项.                                                
            <M>     Intermediate Functional Block support                                          CONFIG_IFB                                     IFB是一个中间层驱动,可以用来灵活的配置资源共享.更多信息参见iproute2文档.看不懂就说明你不需要.                                                
            <M>     Ethernet team driver support  --->      
                            --- Ethernet team driver support                                       CONFIG_NET_TEAM                                team驱动.允许通过"ip link add link [ address MAC ] [ NAME ] type team"命令,或者使用将多个以太网卡
                                                                                                                                                    (称为"port")组合在一起,创建一个虚拟的"team"网络设备,从而允许故障转移或者提高吞吐率,其目的是取代
                                                                                                                                                    传统的"Bonding"(CONFIG_BONDING)驱动."ip"是iproute2包中的一个命令.不确定的选"N".                                                
                            Broadcast mode support                                                 CONFIG_NET_TEAM_MODE_BROADCAST                广播模式:所有网卡共用同一个MAC地址,每一个包都从所有网卡同时发送,不做负载均衡,仅做链路冗余,需要和交换机
                                                                                                                                                    的"聚合强制不协商"方式配合使用.此模式最浪费资源,但可靠性最高,容错能力最强.常用于强调极端可靠的金融业.                                                
                            Round-robin mode support                                               CONFIG_NET_TEAM_MODE_ROUNDROBIN                循环均衡模式:所有网卡共用同一个MAC地址,数据包依次从每个网卡循环分发(例如,在三个网卡一组的情况下,第0个包走
                                                                                                                                                    eth0,第1个包走eth1,第2个包走eth2,第3个包走eth0,第4个包走eth1,第5个包走eth2,第6个包走eth0,...一直循环
                                                                                                                                                    分发下去,直到传输完毕),带宽增加,支持容错(故障链路会被自动踢出),交换机需要配置聚合口(思科叫"port channel").
                                                                                                                                                    数据包从不同的网卡发出,若中途再经过不同的链路,在到达客户端时可能会乱序,从而造成吞吐量达不到理论上的翻倍效果.                                                
                            Random mode support                                                    CONFIG_NET_TEAM_MODE_RANDOM                    随机均衡模式:所有网卡共用同一个MAC地址,数据包依次随机选择一个网卡分发(例如,在三个网卡一组的情况下,第0个包走eth2,
                                                                                                                                                    第1个包走eth0,第2个包走eth2,第3个包走eth1,第4个包走eth1,第5个包走eth0,第6个包走eth2,...一直随机分发下去,
                                                                                                                                                    直到传输完毕),带宽增加,支持容错(故障链路会被自动踢出),交换机需要配置聚合口(思科叫"port channel").数据包
                                                                                                                                                    从不同的网卡发出,若中途再经过不同的链路,在到达客户端时可能会乱序,从而造成吞吐量达不到理论上的翻倍效果                                                
                            Active-backup mode support                                             CONFIG_NET_TEAM_MODE_ACTIVEBACKUP            主备模式:无需更改每个网卡的原生MAC地址,但是team的MAC地址对外仅在主网卡上可见并且保持不变,同一时刻仅有主网卡
                                                                                                                                                    处于激活状态,其他备用网卡都处于等待状态,所有流量仅通过主网卡发送,仅在主网卡故障时,某个备用网卡才会被激活
                                                                                                                                                    成主网卡.此模式仅提供容错能力,可靠性高,但是资源利用率最低.此模式最大的好处是不需要在交换机上做特别的设置.                                                
                            Load-balance mode support                                              CONFIG_NET_TEAM_MODE_LOADBALANCEBPF            均衡模式:均衡算法由用户空间通过BPF接口(bpf_hash_func)设置.                                                
            <M>     MAC-VLAN support                                                               CONFIG_MACVLAN                                MAC-VLAN是通过MAC地址来划分VLAN的方式,在Linux则用来给网卡添加多个MAC地址.你可以使用
                                                                                                                                                    "ip link add link <real dev> [ address MAC ] [ NAME ] type macvlan"命令创建一个虚拟的"macvlan"设备
                                                                                                                                                    (系统会自动打开网卡的混杂模式),然后就可以在同一个物理网卡上虚拟出多个以太网口.Docker依赖于它.                                                
            <M>       MAC-VLAN based tap driver                                                    CONFIG_MACVTAP                                基于MAC-VLAN接口的tap(虚拟以太网设备)字符设备(macvtap)驱动,旨在简化虚拟化的桥接网络,目的是替代TUN/TAP(CONFIG_TUN)
                                                                                                                                                    和Bridge(CONFIG_BRIDGE)内核模块.可以通过与创建macvlan设备相同的"ip"命令创建一个虚拟的"macvtap"设备,并通过TAP
                                                                                                                                                    用户空间接口进行访问.                                                
            <M>     Virtual eXtensible Local Area Network (VXLAN)                                  CONFIG_VXLAN                                    "vxlan"虚拟接口可以在第三层网络上创建第二层网络(跨多个物理IP子网的虚拟二层子网),是一种在UDP中封装MAC的简单机制,
                                                                                                                                                    主要用于虚拟化环境下的隧道虚拟网络(tunnel virtual network).                                                
          @ <M>     Generic Network Virtualization Encapsulation                                                                                   
          @ < >     GPRS Tunneling Protocol datapath (GTP-U)                                                                                       
          @ < >     IEEE 802.1AE MAC-level encryption (MACsec)                                                                                     
            <M>     Network console logging support                                                CONFIG_NETCONSOLE                            网络控制台(netconsole)的作用是通过网络记录内核日志信息.详情参见"Documentation/networking/netconsole.txt"文档.
                                                                                                                                                    不确定的选"N".                                                
            [*]       Dynamic reconfiguration of logging targets                                   CONFIG_NETCONSOLE_DYNAMIC                    允许通过configfs导出的用户空间接口,在运行时更改日志目标(网口, IP地址, 端口号, MAC地址).                                                
            <M>     Virtual Ethernet over NTB Transport                                            CONFIG_NTB_NETDEV                            PCI-E非透明桥(CONFIG_NTB)上的虚拟网卡.不确定的选"N".                                                
            <M>     RapidIO Ethernet over messaging driver support                                 CONFIG_RIONET                                在标准的RapidIO通信方式上发送以太网数据包.不确定的选"N".                                                
            (128)     Number of outbound queue entries                                                                                             
            (128)     Number of inbound queue entries                                                                                              
            <*>     Universal TUN/TAP device driver support                                        CONFIG_TUN                                    TUN/TAP可以为用户空间提供包的接收和发送服务,可以用来虚拟一张网卡或点对点通道(例如为QEMU提供虚拟网卡支持).当程序打开
                                                                                                                                                    "/dev/net/tun"设备时,驱动程序就会注册相应的"tunX"或"tapX"网络设备,当程序关闭"/dev/net/tun"设备时,驱动程序又会删除
                                                                                                                                                    相应的"tunX"或"tapX"网络设备以及所有与之相关联的路由.详情参见"Documentation/networking/tuntap.txt"文档.
                                                                                                                                                    看不懂就表明你不需要.                                                
            [ ]     Support for cross-endian vnet headers on little-endian kernels                 CONFIG_TUN_VNET_CROSS_LE                        允许小端序(little-endian)内核中的TUN/TAP与MACVTAP设备驱动解析来自大端序(big-endian)内核的老旧的virtio设备的vnet头.
                                                                                                                                                    不确定的选"N".                                                
            <M>     Virtual ethernet pair device                                                   CONFIG_VETH                                    该驱动提供了一个本地以太网隧道(设备会被成对的创建).Docker依赖于它.                                                
            <*>     Virtio network driver                                                          CONFIG_VIRTIO_NET                            virtio虚拟网卡驱动.仅可用在基于lguest或QEMU的半虚拟化客户机中(一般是KVM或XEN).                                                
            <M>     Virtual netlink monitoring device                                              CONFIG_NLMON                                    提供一个可以监视netlink skbs的网络设备,以允许tcpdump之类的工具通过packet socket来分析netlink消息.仅供调试使用.                                                
            <M>   ARCnet support  --->                                                             CONFIG_ARCNET                                ARCnet是1977年由Datapoint公司开发的一种局域网技术,它采用令牌总线方案来管理LAN上工作站和其他设备之间的共享线路,
                                                                                                                                                    主要用于工业控制领域中.                                                
            [*]   ATM drivers  --->                                                                CONFIG_ATM_DRIVERS                            可怜的ATM(异步传输模式),曾经在90年代风靡一时,现在已经消失的无影无踪了.                                                
          @       *** CAIF transport drivers ***                                                                                                   
          @ <M>   CAIF TTY transport driver                                                                                                        
          @ <M>   CAIF SPI transport driver for slave interface                                                                                    
          @ [ ]     Next command and length in start of frame                                                                                      
          @ <M>   CAIF HSI transport driver                                                                                                        
          @ <M>   CAIF virtio transport driver                                                                                                     
                  Distributed Switch Architecture drivers  ----                                                                                    Distributed Switch Architecture drivers分布式交换架构驱动,其子项都是Marvell系列以太网交换机芯片组的驱动                                                
            -*-   Ethernet driver support  ---> 
                         --- Ethernet driver support                                                                                               最常见的以太网卡驱动                                                                                              
                         [*]   3Com devices                                                                                                                                              
                                ...                                                                                                                                                  
                         [*]   Adaptec devices                                                                                                                                           
                                ...                                                                                                                 
                         [*]   Alteon devices                                                                                                                                            
                                ...                                                                                                            
                         <M>   Altera Triple-Speed Ethernet MAC support                                                                                                                  
                                ...                                                                                                                            
                         [*]   ARC devices                                                                                                                                               
                         [*]   Atheros devices  
                                ...
                         -*-   Broadcom devices                                                                                                                                          
                                ...                                                                                                                                                                                                                       
                         -*-   Cisco devices                                                                                                                                         
                         {M}     Cisco VIC Ethernet NIC Support                                                                                                
                         [*]   Digital Equipment devices                                                                                                                             
                                ...                                                                                                                       
                         [*]   D-Link devices     
                         [*]   Marvell devices                                                                                                                                                    
                                ...
            <*>   FDDI driver support                                                              CONFIG_FDDI                                    光纤分布式数据接口(FDDI)                                                                                               
            <M>     Digital DEFTA/DEFEA/DEFPA adapter support                                                                                                                                     
          @ [ ]       Use MMIO instead of PIO                                                                                                                                                     
          @ <M>     SysKonnect FDDI PCI support                                                                                                                                          
            [ ]   HIPPI driver support                                                             CONFIG_HIPPI                                    高性能并行接口(HIgh Performance Parallel Interface)是一个在短距离内高速传送大量数据的点对点协                                                                                      
            <M>   General Instruments Surfboard 1000                                               CONFIG_NET_SB1000                            SURFboard 1000 插卡式Cable Medem(ISA接口),这玩意早就绝种了                                                                                      
            {*}   PHY Device support and infrastructure  --->                                      CONFIG_PHYLIB                                数据链路层芯片简称为MAC控制器,物理层芯片简称之为PHY,通常的网卡把MAC和PHY的功能做到了一颗芯片中,
                                                                                                                                                    但也有一些仅含PHY的"软网卡".此选项就是对这些"软网卡"的支持.请根据实际情况选择其下的子项.                                                                                      
            <M>   Micrel KS8995MA 5-ports 10/100 managed Ethernet switch                           CONFIG_MICREL_KS8995                            MAMicrel KS8995MA 5端口 10/100M 以太网交换芯片                                                                                      
            <M>   PLIP (parallel port) support                                                     CONFIG_PLIP                                    PLIP(Parallel Line Internet Protocol)用于将两台电脑通过并口进行联网,组成一个简单的客户机/服务器结构.
                                                                                                                                                    详情参见"Documentation/networking/PLIP.txt".现在的电脑都使用网卡进行互联,并口早就经被丢进历史的垃圾箱了.                                                                                      
            {*}   PPP (point-to-point protocol) support                                            CONFIG_PPP                                    点对点协议(Point to Point Protocol)是SLIP的继任者,使用PPP需要用户层程序pppd的帮助.PPP实际上有两个版本:
                                                                                                                                                    基于普通模拟电话线的"异步PPP"和基于数字线路(例如ISDN线路)的"同步PPP".使用电脑直接拨号的 PPPoE ADSL 用户需要此项.                                                                                      
            <M>     PPP BSD-Compress compression                                                   CONFIG_PPP_BSDCOMP                            为PPP提供BSD(等价于LZW压缩算法,没有gzip高效)压缩算法支持,需要通信双方的支持才有效.大多数ISP都不支持此算法.                                                                                      
            <M>     PPP Deflate compression                                                        CONFIG_PPP_DEFLATE                            为PPP提供Deflate(等价于gzip压缩算法)压缩算法支持,需要通信双方的支持才有效.这是比BSD更好的算法(压缩率更高且无专利障碍).                                                                                      
            [*]     PPP filtering                                                                  CONFIG_PPP_FILTER                            允许对通过PPP接口的包进行过滤.仅在你需要使用pppd的pass-filter/active-filter选项时才需要开启.不确定的选"N".                                                                          
            <M>     PPP MPPE compression (encryption)                                              CONFIG_PPP_MPPE                                为PPP提供MPPE加密协议支持,它被用于微软的P2P隧道协议中.此特性需要PPTP Client工具的支持.                                                                          
            [*]     PPP multilink support                                                          CONFIG_PPP_MULTILINK                            多重链路协议(RFC1990)允许你将多个线路(物理的或逻辑的)组合为一个PPP连接一充分利用带宽,这不但需要pppd的支持,
                                                                                                                                                    还需要ISP的支持                                                                          
            <M>     PPP over ATM                                                                   CONFIG_PPPOATM                                在ATM上跑的PPP.果断"N".                                                                          
            <M>     PPP over Ethernet                                                              CONFIG_PPPOE                                    这就是ADSL用户最常见的PPPoE,也就是在以太网上跑的PPP协议.这需要RP-PPPoE工具的帮助                                                                          
            <M>     PPP over IPv4 (PPTP)                                                           CONFIG_PPTP                                    点对点隧道协议(Point-to-Point Tunneling Protocol)是一种主要用于VPN的数据链路层网络协议.此功能需要ACCEL-PPTP工具的支持.                                                                          
            <M>     PPP over L2TP                                                                  CONFIG_PPPO                                    L2TP第二层隧道协议(L2TP)是一种通过UDP隧道传输PPP流量的技术,对于VPN用户来说,L2TP VPN是比PPTP VPN的更好解决方案                                                                          
            <M>     PPP support for async serial ports                                             CONFIG_PPP_ASYNC                                基于普通模拟电话线或标准异步串口(COM1,COM2)的"异步PPP"支持. PPPoE ADSL 使用的就是这个.不能与下面的
                                                                                                                                                    CONFIG_PPP_SYNC_TTY同时并存.                                                                          
            <M>     PPP support for sync tty ports                                                 CONFIG_PPP_SYNC_TTY                            基于同步tty设备(比如SyncLink适配器)的"同步PPP"支持.常用于高速租用线路(比如T1/E1).不确定的选"N".                                                                          
            <M>   SLIP (serial line) support                                                       CONFIG_SLIP                                    一个在串行线上(例如电话线)传输IP数据报的TCP/IP协议.最原始的通过电话线拨号上网就用这个协议,如今基本绝迹了.不确定的选"N".                                                                          
            [*]   CSLIP compressed headers                                                         CONFIG_SLIP_COMPRESSEDC                        SLIP协议基于SLIP,但比SLIP快,它将TCP/IP头(而非数据)进行压缩传送,需要通信双方的支持才有效                                                                          
            [*]   Keepalive and linefill                                                           CONFIG_SLIP_SMART                            让SLIP驱动支持RELCOM linefill和keepalive监视,这在信号质量比较差的模拟线路上是个好主意                                                                          
            [*]   Six bit SLIP encapsulation                                                       CONFIG_SLIP_MODE_SLIP6                        这种线路非常罕见,选"N".                                                                          
            {M}   USB Network Adapters  --->                                                                                                                                 
            [*]   Wireless LAN  --->                                                                                                                                         
                  WiMAX Wireless Broadband devices  --->                                                                                           WiMAX无线设备                                                                          
          @ [*]   Wan interfaces support  --->                                                                                                                               
            <M>   IEEE 802.15.4 drivers  --->                                                      CONFIG_IEEE802154_DRIVERS                    IEEE 802.15.4描述了低速率无线个人局域网的物理层和媒体接入控制协议                                                                          
            <*>   Xen network device frontend driver                                               CONFIG_XEN_NETDEV_FRONTEND                    XEN半虚拟化网络设备前端驱动(通常是被"domain 0"导出的)                                                                          
            <M>   Xen backend network device                                                       CONFIG_XEN_NETDEV_BACKEND                    XEN半虚拟化网络设备后端驱动,通常被用在"domain 0"内核上,用于向其他domain导出半虚拟化网络设备.                                                                          
            <M>   VMware VMXNET3 ethernet driver                                                   CONFIG_VMXNET3VMware vmxnet3                 虚拟以太网卡驱动                                                                          
            < >   FUJITSU Extended Socket Network Device driver                                    CONFIG_FUJITSU_ESFUJITSU                     PRIMEQUEST 2000 E2 系列网卡                                                                          
            <M>   Microsoft Hyper-V virtual network driver                                         CONFIG_HYPERV_NETMicrosoft                     Hyper-V 虚拟以太网卡驱动                                                                          
            [*]   ISDN support  --->                                                                CONFIG_ISDN                                    上世纪在ADSL流行之前曾经有过短暂流行,但现在已经绝迹了











