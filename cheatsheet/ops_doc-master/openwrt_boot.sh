https://wiki.openwrt.org/doc/techref/process.boot

总的流程是：1.CFE->2.linux->3./etc/preinit->4./sbin/init ->5./etc/inittab ->6./etc/init.d/rcS->7./etc/rc.d/S*
初始化从bootloader开始，会调用/etc/preinit脚本。 至于bootloader又是如何启动的，
以及bootloader如何调用/etc/preinit的，

/sbin/init -> procd -> "sysinit" -> /etc/rc.d/xxx
/etc/rc.d/S10boot -> /etc/init.d/boot
/etc/init.d/boot -> /bin/board_detect
/bin/board_detect -> /etc/board.d/02_network

boot(JTAG:Joint Test Action Group){
JTAG: 测试和编程用的电器特性的接口。总是集成在Soc或CPU内部，然后引导PCB板上用于测试。
JTAG commands：连接到计算机并口上。PCB <-> [JTAG cable] <-> PC ; 可以进行bootloader的擦写。
JTAG可以在没有内存和没有Flash的情况下，和SoC芯片进行交互。
在有Flash的情况下，可以通过JTAG对Flash进行编程，在某些硬件损耗的情况下，可以通过JTAG对Flash上数据进行恢复。
JTAG不是一个标准的系统，ARM和MIPS内核运行通过JTAG控制CPU运行情况。

JTAG software：
1. Raspberry Pi [the onboard GPIO pins] -> JTAG
2. Openwince JTAG. -> UrJTAG
3. Hairydairymaid variants: 
4. OpenOCD

link:https://wiki.openwrt.org/doc/hardware/port.jtag
}

boot(Bootloader){
1. bootloader:可以在独立的EEPROM 或 在Flash某段上。
2. bootloader是与设备紧密相关的，用来初始化底层的硬件设备。
3. bootloader被看做firmware的一部分，bootloader不被看做OpenWrt的一部分。
http://www.wehavemorefun.de/fritzbox/ADAM2#Funktionen  

}

内核开动，同时扫描mtd文件系统分区
内核执行/etc/preinit脚本
boot(/sbin/init){
early()
    mount /proc /sys /tmp /dev /dev/pts目录(early_mount)
    创建设备节点和/dev/null文件结点(early_dev)
    设置PATH环境变量(early_env)
    初始化/dev/console
    
cmdline()
    根据/proc/cmdline内容init_debug=([0-9]+)判断debug级别 

watchdog_init()
    初始化内核watchdog(/dev/watchdog) 

加载内核模块
    创建子进程/sbin/kmodloader加载/etc/modules-boot.d/目录中的内核模块
}

boot(/etc/preinit){
1. openwrt源码中的linux补丁文件放在$<openwrt_dir>/target/linux/generic/文件下面，有对于不同版本的linux内核补丁。
2. ./patches-3.18/921-use_preinit_as_init.patch
3. 可以看到他修改linux中默认的启动项，可以看到它首先启动/etc/preinit.他是一个脚本，咱们就从脚本说起.
4. 分区表（target/linux/ramips/dts/MPRA2.dts）

boot_hook_init 和 boot_run_hook 他们的定义在/lib/functions/preinit.sh文件当中，
    boot_hook_init是初始化一个函数队列，
    boot_run_hook是运行一个函数队列，

例如： preinit_main_hook define_default_set_state do_ar71xx preinit_enable_reset_button \
preinit_set_mac_address set_preinit_iface init_tuxera_fs preinit_ip pi_indicate_preinit \
failsafe_wait run_failsafe_hook indicate_regular_preinit init_hotplug initramfs_test do_mount_root \
do_load_ath10k_board_bin restore_config load_qos_modules run_init

# run_init函数处于preinit_main_hook链上，这个函数的功能就是当完成preinit后执行/sbin/init，开始openwrt启动的下一流程。
run_init -> 将/etc/preinit中配置的IP地址释放掉。
# 见： base(Openwrt启动流程：procd)

}

创建子进程执行/etc/preinit脚本，此时PREINIT环境变量被设置为1，主进程同时使用uloop_process_add()把/etc/preinit子进程加入uloop进行监控，当/etc/preinit执行结束时回调plugd_proc_cb()函数把监控/etc/preinit进程对应对象中pid属性设置为0，表示/etc/preinit已执行完成
创建子进程执行/sbin/procd -h /etc/hotplug-preinit.json，主进程同时使用uloop_process_add()把/sbin/procd子进程加入uloop进行监控，当/sbin/procd进程结束时回调spawn_procd()函数
spawn_procd()函数繁衍后继真正使用的/sbin/procd进程，从/tmp/debuglevel读出debug级别并设置到环境变量DBGLVL中，把watchdog fd设置到环境变量WDTFD中，最后调用execvp()繁衍/sbin/procd进程

boot(procd){
procd启动各服务
procd: - early -   //初始化看门狗。
procd: - watchdog -
procd: - ubus -
procd: - init -
如上日志表示了procd的初始化过程。
procd有几个state。state_enter函数为状态机处理入口。
STATE_NONE -->STATE_EARLY -->STATE_UBUS-->STATE_INIT-->STATE_RUNNING

procd有5个状态，分别为STATE_EARLY、STATE_INIT、STATE_RUNNING、STATE_SHUTDOWN、STATE_HALT，这5个状态将按顺序变化，当前状态保存在全局变量state中，可通过procd_state_next()函数使用状态发生变化
STATE_EARLY状态 - init前准备工作
    初始化watchdog
    根据"/etc/hotplug.json"规则监听hotplug
    procd_coldplug()函数处理，把/dev挂载到tmpfs中，fork udevtrigger进程产生冷插拔事件，以便让hotplug监听进行处理
    udevstrigger进程处理完成后回调procd_state_next()函数把状态从STATE_EARLY转变为STATE_INIT 

STATE_INIT状态 - 初始化工作
    连接ubusd，此时实际上ubusd并不存在，所以procd_connect_ubus函数使用了定时器进行重连，而uloop_run()需在初始化工作完成后才真正运行。当成功连接上ubusd后，将注册service main_object对象，system_object对象、watch_event对象(procd_connect_ubus()函数)，
    初始化services（服务）和validators（服务验证器）全局AVL tree
    把ubusd服务加入services管理对象中(service_start_early)
    根据/etc/inittab内容把cmd、handler对应关系加入全局链表actions中
    顺序加载respawn、askconsole、askfirst、sysinit命令
    sysinit命令把/etc/rc.d/目录下所有启动脚本执行完成后将回调rcdone()函数把状态从STATE_INITl转变为STATE_RUNNING 

STATE_RUNNING状态
    进入STATE_RUNNING状态后procd运行uloop_run()主循环
}

boot(inittab){
# x86_64
::sysinit:/etc/init.d/rcS S boot
::shutdown:/etc/init.d/rcS K shutdown
ttyS0::askfirst:/usr/libexec/login.sh
tty1::askfirst:/usr/libexec/login.sh
------------------------------------
# renren
::sysinit:/etc/init.d/rcS S boot
::shutdown:/etc/init.d/rcS K shutdown
::askconsole:/bin/ash --login
------------------------------------
# busybox
::askconsole:/bin/busybox login
}

ask(){
/bin/ash 附带 --login 参数, ash 则会在进入 cmdloop 之前, 先去载入 /etc/profile , 执行其中的动作.
openwrt 在 /etc/profile 里初始化了系统环境变量 PATH, HOME, PS1,.

用户登陆
::askconsole:/bin/ash --login
改为
::askconsole:/bin/busybox login
busybox 里编译选项把 login 选上.
}

procd(watchdog){
    如果存在/dev/watchdog设备，设置watchdog timeout等于30秒，如果内核在30秒内没有收到任何数据将重启系统。
用户状进程使用uloop定时器设置5秒周期向/dev/wathdog设备写一些数据通知内核，表示此用户进程在正常工作

初始化watchdog
void watchdog_init(int preinit)

设备通知内核/dev/watchdog频率(缺省为5秒)返回老频率值
int watchdog_frequency(int frequency)

设备内核/dev/watchdog超时时间当参数timeout<=0时，表示从返回值获取当前超时时间
int watchdog_timeout(int timeout)

val为true时停止用户状通知定时器，意味着30秒内系统将重启
void watchdog_set_stopped(bool val)
}

procd(signal){
信息处理，下面为procd对不同信息的处理方法
    SIGBUS、SIGSEGV信号将调用do_reboot() RB_AUTOBOOT重启系统
    SIGHUP、SIGKILL、SIGSTOP信号将被忽略
    SIGTERM信号使用RB_AUTOBOOT事件重启系统
    SIGUSR1、SIGUSR2信号使用RB_POWER_OFF事件关闭系统 
}

procd(trigger){
trigger任务队列
数据结构
struct trigger {
    struct list_head list;

    char *type;

    int pending;
    int remove;
    int timeout;

    void *id;

    struct blob_attr *rule;
    struct blob_attr *data;
    struct uloop_timeout delay;

    struct json_script_ctx jctx;
};

struct cmd {
    char *name;
    void (*handler)(struct job *job, struct blob_attr *exec, struct blob_attr *env);
};

struct job {
    struct runqueue_process proc;
    struct cmd *cmd;
    struct trigger *trigger;
    struct blob_attr *exec;
    struct blob_attr *env;
};

接口说明
    初始化trigger任务队列
    void trigger_init(void)
    
    把服务和服务对应的规则加入trigger任务队列
    void trigger_add(struct blob_attr *rule, void *id)
    
    把服务从trigger任务队列中删除
    void trigger_del(void *id)
    
    void trigger_event(const char *type, struct blob_attr *data)
}

http://blog.csdn.net/wdsfup/article/details/51693848
procd(hotplug){
由内核发出 event 事件.
    kobject_uevent() 产生 uevent 事件(lib/kobject_uevent.c 中), 产生的 uevent 先由 netlink_broadcast_filtered() 发出, 最后调用 uevent_helper[] 所指定的程序来处理.
    uevent_helper[] 里默认指定 "/sbin/hotplug", 但可以通过 /sys/kernel/uevent_helper (kernel/ksysfs.c) 或 /proc/kernel/uevent_helper (kernel/sysctl.c) 来修改成指定的程序.
    在 OpenWrt 并不使用 user_helper[] 指定程序来处理 uevent (/sbin/hotplug 不存在), 而是使用 PF_NETLINK 来获取来自内核的 uevent.
    
用户空间监听 uevent
    openwrt 中, procd 作为 init 进程会处理许多事情, 其中就包括 hotplug.
    procd/plug/hotplug.c 中, 创建一个 PF_NETLINK 套接字来监听内核 netlink_broadcast_filtered() 发出的 uevent.
    收到 uevent 之后, 再根据 /etc/hotplug.json 里的描述来处理.
    通常情况下, /etc/hotplug.json 会调用 /sbin/hotplug-call 来处理, 它根据 uevent 的 $SUBSYSTEM 变量来分别调用 /etc/hotplug.d/ 下不同目录中的脚本.
    比如, 插入U盘或SD卡时, 会产生的事件消息如下:
procd: rule_handle_command(355): Command: makedev
procd: rule_handle_command(357):  /dev/sda1
procd: rule_handle_command(357):  0644
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  ACTION=add
procd: rule_handle_command(362):  DEVPATH=/devices/101c0000.ehci/usb1/1-1/1-1.3/1-1.3:1.0/host16/target16:0:0/16:0:0:0/block/sda/sda1
procd: rule_handle_command(362):  SUBSYSTEM=block
procd: rule_handle_command(362):  MAJOR=8
procd: rule_handle_command(362):  MINOR=1
procd: rule_handle_command(362):  DEVNAME=sda1
procd: rule_handle_command(362):  DEVTYPE=partition
procd: rule_handle_command(362):  SEQNUM=865
procd: rule_handle_command(363): 
procd: rule_handle_command(355): Command: exec
procd: rule_handle_command(357):  /sbin/hotplug-call
procd: rule_handle_command(357):  block
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  ACTION=add
procd: rule_handle_command(362):  DEVPATH=/devices/101c0000.ehci/usb1/1-1/1-1.3/1-1.3:1.0/host16/target16:0:0/16:0:0:0/block/sda/sda1
procd: rule_handle_command(362):  SUBSYSTEM=block
procd: rule_handle_command(362):  MAJOR=8
procd: rule_handle_command(362):  MINOR=1
procd: rule_handle_command(362):  DEVNAME=sda1
procd: rule_handle_command(362):  DEVTYPE=partition
procd: rule_handle_command(362):  SEQNUM=865
procd: rule_handle_command(363): 

    第一个 makedev 会创建 /dev/sda1 节点. 第二个 exec 命令, 其附带的消息中指定了 ACTION, DEVPATH, SUBSYSTEM, DEVNAME, DEVTYPE 等变量.
于是 hotplug-call 会尝试执行 /etc/hotplug.d/block/ 目录下的所有可执行脚本.
所以我们可以在这里放置我们的自动挂载/卸载处理脚本.

按键 button 的检测
openwrt 中, 按键的检测也是通过 hotplug 来实现的.

它首先写了一个内核模块: gpio_button_hotplug, 用于监听按键, 有中断和 poll 两种方式. 然后在发出事件的同时, 将记录并计算得出的两次按键时间差也作为 uevent 变量发出来.

这样在用户空间收到这个 uevent 事件时就知道该次按键按下了多长时间.

hotplug.json 中有描述, 如果 uevent 中含有 BUTTON 字符串, 而且 SUBSYSTEM 为 "button", 则执行 /etc/rc.button/ 下的 %BUTTON% 脚本来处理.

        [ "if",
                [ "and",
                        [ "has", "BUTTON" ],
                        [ "eq", "SUBSYSTEM", "button" ],
                ],
                [ "exec", "/etc/rc.button/%BUTTON%" ]
        ],
使用 export DBGLVL=10; procd -h /etc/hotplug.json 截获一些打印信息看看:

{{"HOME":"\/","PATH":"\/sbin:\/bin:\/usr\/sbin:\/usr\/bin","SUBSYSTEM":"button","ACTION":"pressed","BUTTON":"reset","SEEN":"862","SEQNUM":"593"}}
procd: rule_handle_command(355): Command: exec
procd: rule_handle_command(357):  /etc/rc.button/reset
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  HOME=/
procd: rule_handle_command(362):  PATH=/sbin:/bin:/usr/sbin:/usr/bin
procd: rule_handle_command(362):  SUBSYSTEM=button
procd: rule_handle_command(362):  ACTION=pressed
procd: rule_handle_command(362):  BUTTON=reset
procd: rule_handle_command(362):  SEEN=862
procd: rule_handle_command(362):  SEQNUM=593
procd: rule_handle_command(363): 

procd: rule_handle_command(355): Command: exec
procd: rule_handle_command(357):  /sbin/hotplug-call
procd: rule_handle_command(357):  button
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  HOME=/
procd: rule_handle_command(362):  PATH=/sbin:/bin:/usr/sbin:/usr/bin
procd: rule_handle_command(362):  SUBSYSTEM=button
procd: rule_handle_command(362):  ACTION=pressed
procd: rule_handle_command(362):  BUTTON=reset
procd: rule_handle_command(362):  SEEN=862
procd: rule_handle_command(362):  SEQNUM=593
procd: rule_handle_command(363): 


{{"HOME":"\/","PATH":"\/sbin:\/bin:\/usr\/sbin:\/usr\/bin","SUBSYSTEM":"button","ACTION":"released","BUTTON":"reset","SEEN":"3","SEQNUM":"594"}}
procd: rule_handle_command(355): Command: exec
procd: rule_handle_command(357):  /etc/rc.button/reset
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  HOME=/
procd: rule_handle_command(362):  PATH=/sbin:/bin:/usr/sbin:/usr/bin
procd: rule_handle_command(362):  SUBSYSTEM=button
procd: rule_handle_command(362):  ACTION=released
procd: rule_handle_command(362):  BUTTON=reset
procd: rule_handle_command(362):  SEEN=3
procd: rule_handle_command(362):  SEQNUM=594
procd: rule_handle_command(363): 

procd: rule_handle_command(355): Command: exec
procd: rule_handle_command(357):  /sbin/hotplug-call
procd: rule_handle_command(357):  button
procd: rule_handle_command(358): 
procd: rule_handle_command(360): Message:
procd: rule_handle_command(362):  HOME=/
procd: rule_handle_command(362):  PATH=/sbin:/bin:/usr/sbin:/usr/bin
procd: rule_handle_command(362):  SUBSYSTEM=button
procd: rule_handle_command(362):  ACTION=released
procd: rule_handle_command(362):  BUTTON=reset
procd: rule_handle_command(362):  SEEN=3
procd: rule_handle_command(362):  SEQNUM=594
procd: rule_handle_command(363):
}


boot(FailSafe){
JFFS2 partition: 如果仅仅是JFFS2上部分有问题，可以重启进入failsafe模式。
SquashFS partition 或者 Kernel ：如果是SquashFS部分或者内核坏掉，并且进入不了failsafe模式，但是
                                 bootloader还能正常工作，你可以通过启动完boot后，进行时串口烧写。
如果bootloader也坏掉了，那就只有两种方法了：1. 通过JTAG口，来进行恢复bootloader。
                                            2. 通过短接芯片上的某些管脚，来恢复bootloader。
}

openwrt_release(luci使用){
DISTRIB_ID='OpenWrt'
DISTRIB_RELEASE='15.05'
DISTRIB_REVISION='r46767'
DISTRIB_CODENAME='chaos_calmer'
DISTRIB_TARGET='x86/64'
DISTRIB_DESCRIPTION='OpenWrt Chaos Calmer 15.05'
DISTRIB_TAINTS=''
}
openwrt_version(luci使用){
15.05
}
hotplug(rc.button){
failsafe    # gpio_button_hotplug
power       # 
reset       # 
rfkill      # 

<*> kmod-gpio-button-hotplug................Simple GPIO Button Hotplug driver
gpio-button-hotplug是gpio-button  platform总线的driver，负责与name为gpio-button-hotplug的platform总线 device匹配
源代码：./build_dir/linux-ralink_mt7620/gpio-button-hotplug/gpio-button-hotplug.c

<*> kmod-input-polldev........................... Polled Input device support
是input system的input_dev,采用采取轮询方式，不断通过input_gpio_button查询GPIO状态,然后发送input event。
源代码： ./build_dir/linux-ralink_mt7620/linux-3.3.8/drivers/input/input-polldev.c

<*> kmod-button-hotplug................................ Button Hotplug driver
button-hotplug是面向应用层接口的，把input_event转换成hotplug消息。这个主要是内核的hotplug机制（通过内核netlink技术广播对象消息，从而支持热插拔之类的)。OpenWRT用的是hotplug2，具体配置在/etc/hotplug.d下。如果要在应用层处理按键事件，就新建/etc/hotplug.d/button目录，写个测试脚本;
源代码：./build_dir/linux-ralink_mt7620/button-hotplug/button-hotplug.c
}

boot(Flash 布局){
    如果闪存芯片是直接连接到CPU(SoC),并且能够直接被操作系统/Linux读取, 我们就把他叫做"raw flash".
    如果闪存芯片不能够直接被操作系统/Linux读取 (由于闪存和SoC之间还需要另外的控制芯片来连接), 我们叫他 
"FTL (Flash Translation Layer) flash". 嵌入式系统几乎全部使用"raw flash", 而USB 闪存盘/U盘, 几乎全部
使用 FTL flash!

SquashFS文件的分区
    嵌入式系统中的Flash芯片并不需要单独的控制芯片,存储空间是通过操作MTD设备 MTD加上特定的文件系统
Filesystems来完成的.
    传统的存储空间使用 MBR 和 PBRs 来存储分区相关的信息, 而嵌入式设备中 这由内核 Linux Kernel 来
完成(而且有时候会单独由bootloader来完成!). 你只需要定义, "kernel分区 由偏移量x起 至偏移量y止". 
# /build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/linux/arch
root@OpenWrt:~# cat /proc/mtd 
dev:    size   erasesize  name 
mtd0: 00030000 00010000 "u-boot" 
mtd1: 00010000 00010000 "u-boot-env" 
mtd2: 00010000 00010000 "factory" 
mtd3: 01fb0000 00010000 "firmware" 
mtd4: 00125545 00010000 "kernel" 
mtd5: 01e8aabb 00010000 "rootfs" 
mtd6: 01950000 00010000 "rootfs_data"

# /build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/linux/arch
cat /proc/mtd
dev:    size   erasesize  name
mtd0: 00020000 00010000 "u-boot"
mtd1: 00140000 00010000 "kernel"
mtd2: 00690000 00010000 "rootfs"
mtd3: 00530000 00010000 "rootfs_data"
mtd4: 00010000 00010000 "art"
mtd5: 007d0000 00010000 "firmware"

1. Layer0 [m25p80 spi0.0: m25p64 8192KiB]:
第0层Layer0: 对应Flash芯片,8MiB大小, 焊接在PCB上,连接到CPU(SoC)SoC – 通过SPI总线.
2. Layer1 [mtd0 u-boot 128KiB ] [mtd5 firmware 8000KiB] [mtd4 art 64KiB]
第1层Layer1: 我们把存储空间"分区"为 mtd0 给 bootloader, mtd5 给 firmware/固件使用, 并且, 在这个例子中,
mtd4给ART (Atheros Radio Test/Atheros电波测试) - 它包含MAC地址和无线系统的校准信息(EEPROM). 如果该部分
的信息丢失或损坏,ath9k (无线驱动程序) 就彻底罢工了.
3. Layer2 [mtd1 kernel 1280KiB] [mtd2 rootfs 6720KiB] => [mtd5 firmware 8000KiB]
第2层Layer2: 我们把mtd5 (固件) 进一步分割为 mtd1 (kernel/内核) and mtd2 (rootfs); 在固件的一般处理流程
中Kernel 二进制文件 先由LZMA打包, 然后用gzip压缩 之后文件被 直接写入到raw flash (mtd1)中 而不mount到
任何文件系统上!
4. Layer3 [SquashFS:/rom] [JFFS2] => [mtd3 rootfs_data 5184KiB]

}

1. rc.d/ 下的脚本都是链接到 init.d/ 下的.
2. S开头的表示在开机时执行, K开头的表示在关机时执行. 数字序号用来控制各脚本的执行的顺序.
3. 脚本里 boot() 函数会在开机时默认被执行
4. start_service()

Vanilla (boot){
init reads /etc/inittab for the "sysinit" entry (default is "::sysinit:/etc/init.d/rcS S boot")
init calls /etc/init.d/rcS S boot
rcS executes the symlinks to the actual startup scripts located in /etc/rc.d/S##xxxxxx with option "start":
after rcS finishes, system should be up and running
S05defconfig        create config files with default values for platform (if config file is not exist), really does this on first start after OpenWRT installed (copy unexisted files from /etc/defconfig/$board/ to /etc/config/)
S10boot             starts hotplug-script, mounts filesystesm, starts .., starts syslogd, …
S39usb              mount -t usbfs none /proc/bus/usb
S40network          start a network subsystem (run /sbin/netifd, up interfaces and wifi
S45firewall         create and implement firewall rules from /etc/config/firewall
S50cron             starts crond, see → /etc/crontabs/root for configuration
S50dropbear         starts dropbear, see → /etc/config/dropbear for configuration
S50telnet           checks for root password, if non is set, /usr/sbin/telnetd gets started
S60dnsmasq          starts dnsmasq, see → /etc/config/dhcp for configuration
S95done             executes /etc/rc.local
S96led              load a LED configuration from /etc/config/system and set up LEDs (write values to /sys/class/leds/*/*)
S97watchdog         start the watchdog daemon (/sbin/watchdog)
S99sysctl           interprets /etc/sysctl.conf
The init daemon will run all the time
}
Vanilla (down){
reads /etc/inittab for shutdown (default is "::shutdodwn:/etc/init.d/rcS K stop")
init calls /etc/init.d/rcS K stop
rcS executes the shutdown scripts located in /etc/rc.d/K##xxxxxx with option "stop"
system halts/reboots

K50dropbear         kill all instances of dropbear
K90network          down all interfaces and stop netifd
K98boot             stop logger daemons: /sbin/syslogd and /sbin/klogd
K99umount           writes caches to disk, unmounts all         
}

boot(){
procd 解析 /etc/inittab 文件. 该文件内容如下:

::sysinit:/etc/init.d/rcS S boot
::shutdown:/etc/init.d/rcS K shutdown
::askconsole:/bin/ash --login
sysinit 指明启动初始化时, 在 procd 内针对它有相应的回调函数. 该函数到 /etc/rc.d/ 下找脚本执行.
/etc/init.d/rcS 的本意是指明处理该过程的脚本. OpenWrt 中在 procd 中已经预设后处理函数为 rcS().
S 表示找 /etc/rc.d/ 下面名字以 'S' 开头的脚本.
boot 就是执行该脚本中时以 boot 为参数. 执行脚本中的 boot 函数.
同里, 也可以知道 shutdown 里的处理过程:

找 /etc/rc.d/ 下名字以 'K' 开头的脚本.
以 shutdown 为参数执行该脚本, 即执行脚本中的 shutdown 函数.

}

x86(){
"kernel /boot/vmlinuz root=/dev/hda2 init=/etc/preinit [rest of options]"
}
Vanilla (){
"root=/dev/hda2 rootfstype=ext2 init=/etc/preinit noinitrd console=ttyS0,38400,n,8,1 reboot=bios"
}

make(world)
{
 make[1] world
 make[2] target/compile
 make[3] -C target/linux compile
 make[2] package/cleanup
 make[2] package/compile
 make[3] -C package/libs/toolchain compile
 make[3] -C package/libs/libnl-tiny compile
 make[3] -C package/libs/libjson-c compile
 make[3] -C package/utils/lua compile
 make[3] -C package/libs/libubox compile
 make[3] -C package/system/ubus compile
 make[3] -C package/system/uci compile
 make[3] -C package/network/config/netifd compile
 make[3] -C package/system/opkg host-compile
 make[3] -C package/system/ubox compile
 make[3] -C package/libs/lzo compile
 make[3] -C package/libs/zlib compile
 make[3] -C package/libs/ncurses host-compile
 make[3] -C package/libs/ncurses compile
 make[3] -C package/utils/util-linux compile
 make[3] -C package/utils/ubi-utils compile
 make[3] -C package/system/procd compile
 make[3] -C package/system/usign host-compile
 make[3] -C package/utils/jsonfilter compile
 make[3] -C package/system/usign compile
 make[3] -C package/base-files compile
 make[3] -C feeds/luci/modules/luci-base host-compile
 make[3] -C package/firmware/linux-firmware compile
 make[3] -C package/kernel/linux compile
 make[3] -C package/network/utils/iptables compile
 make[3] -C package/network/config/firewall compile
 make[3] -C package/utils/lua host-compile
 make[3] -C feeds/luci/applications/luci-app-firewall compile
 make[3] -C feeds/luci/libs/luci-lib-ip compile
 make[3] -C feeds/luci/libs/luci-lib-nixio compile
 make[3] -C package/network/utils/iwinfo compile
 make[3] -C package/system/rpcd compile
 make[3] -C feeds/luci/modules/luci-base compile
 make[3] -C feeds/luci/modules/luci-mod-admin-full compile
 make[3] -C feeds/luci/protocols/luci-proto-ipv6 compile
 make[3] -C feeds/luci/protocols/luci-proto-ppp compile
 make[3] -C feeds/luci/themes/luci-theme-bootstrap compile
 make[3] -C package/kernel/gpio-button-hotplug compile
 make[3] -C package/firmware/ath10k-firmware compile
 make[3] -C package/firmware/b43legacy-firmware compile
 make[3] -C package/libs/ocf-crypto-headers compile
 make[3] -C package/libs/openssl compile
 make[3] -C package/network/services/hostapd compile
 make[3] -C package/network/utils/iw compile
 make[3] -C package/kernel/mac80211 compile
 make[3] -C package/kernel/mt76 compile
 make[3] -C package/network/config/swconfig compile
 make[3] -C package/network/ipv6/odhcp6c compile
 make[3] -C package/network/services/dnsmasq compile
 make[3] -C package/network/services/dropbear compile
 make[3] -C package/network/services/odhcpd compile
 make[3] -C package/libs/libpcap compile
 make[3] -C package/network/utils/linux-atm compile
 make[3] -C package/network/utils/resolveip compile
 make[3] -C package/network/services/ppp compile
 make[3] -C package/libs/polarssl compile
 make[3] -C package/libs/ustream-ssl compile
 make[3] -C package/network/services/uhttpd compile
 make[3] -C package/system/fstools compile
 make[3] -C package/system/mtd compile
 make[3] -C package/system/opkg compile
 make[3] -C package/utils/busybox compile
 make[2] package/install
 make[3] package/preconfig
 make[2] target/install
 make[3] -C target/linux install
}

