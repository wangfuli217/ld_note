http://www.cnblogs.com/kubtu/archive/2010/12/22/1913999.html

    虽然通常是先kernel后rootfs，但是kernel要不停改，rootfs却必须得先存在，所以先搞定rootfs，rootfs采用据说是
nand flash上最先进的ubifs。

上http://www.busybox.net/下载busybox源代码，目前最新的稳定版本为1.18.1，解压至Workspaces。
以下切换到root用户进行操作（在其他用户模式下编译出来的rootfs登录时不是以root登录，好像是比较麻烦，简单起见先）
修改Makefile：
    CROSS_COMPILE = /opt/arm-2010q1/bin/arm-none-linux-gnueabi-
    ARCH = arm
保存退出后：
    make menuconfig
    已经把make install目录默认改成./_install了。而且也不打算改成静态库，所以没啥好改的，看一看保存退出后：
    make （生成busybox）
    make install （生成文件到_install目录）

然后修改_install/bin/busybox权限：
    chmod 4755 _install/bin/busybox
    （给予busybox任何人可读可执行，所有者可读可写可执行，4读，2写，1执行，7=4+2+1,5=4+1，三者分别是所有者，所有者组，其他组。最前面的4表示其他用户执行该文件时，权限同所有者）

进入到_install目录创建linux需要的一些目录：
    mkdir -p dev etc home lib mnt proc root sys tmp usr var/lib/misc var/lock var/log var/run var/tmp
    并修改权限：
    chmod 1777 tmp
    chmod 1777 var/tmp
    （最前面1防止被其他用户删除）
    在dev下创建console和null设备：
    mknod -m 660 console c 5 1
    mknod -m 660 null c 1 3     
    （这两个设备用来供init启动时调用）

现在来看一下busybox需要哪些动态链接库，返回到busybox目录后输入：
    /opt/arm-2010q1/bin/arm-none-linux-gnueabi-readelf -a busybox  | grep Shared
    显示需要libm.so.6和libc.so.6
    把交叉编译器里的library拷贝到_install/lib目录下，codesourcery的arm-2010q1，默认是armv5te，在目录
    /opt/arm-2010q1/arm-none-linux-gnueabi/libc下的lib中（对应ARMv4T在在armv4t中，对应armv7-a thumb2在thumb2中），鉴于以后的应用程序可能会用到除libm.so.6和libc.so.6外的这些库，因此全部拷过去，在_install下执行：
    cp /opt/arm-2010q1/arm-none-linux-gnueabi/libc/lib/*.so*  lib -a
    
然后在_install/etc下创建一些配置文件：
    fstab
        #
        # /etc/fstab: static file system information.
        #
        # 
        #
        # file system   mount       type    options           dump    pass
        
        #for mdev
        proc            /proc       proc    defaults          0       0
        sysfs           /sys        sysfs   defaults          0       0
        
        #make sure /dev /tmp /var are tmpfs(tmpfs use ram as media) thus can be r/w  
        tmpfs           /tmp        tmpfs   defaults          0       0
        tmpfs           /dev        tmpfs   defaults          0       0
        tmpfs           /var        tmpfs   defaults          0       0
        
        #usbfs        /proc/bus/usb  usbfs   defaults          0       0

    inittab
        # see busybox/examples/inittab
        
        # Boot-time system configuration/initialization script.
        # This is run first except when booting in single-user mode.
        ::sysinit:/etc/init.d/rcS
        
        #Start an "askfirst" shell on the console (whatever that may be)
        #use respawn instead askfirst to make sure console always active
        ::respawn:-bin/sh
        
        # Stuff to do when restarting the init process
        ::restart:/sbin/init
        
        # Stuff to do before rebooting
        ::ctrlaltdel:/sbin/reboot
        ::shutdown:/bin/umount -a -r
        ::shutdown:/sbin/swapoff -a

    init.d/rcS
        #!/bin/sh
        
        #add setting here for auto start program
        PATH=/sbin:/bin:/usr/sbin:/usr/bin
        runlevel=S
        prevlevel=N
        umask 022 
        export PATH runlevel prevlevel
        
        #See docs/mdev.txt
        #mount all fs in fstab,proc and sysfs are must for mdev
        mount -a   
        
        #create device nodes
        echo /sbin/mdev > /proc/sys/kernel/hotplug
        
        #seed  all device nodes
        mdev -s
        
        #create pts directory for remote login such as SSH and telnet
        mkdir -p /dev/pts
        mount -t devpts devpts /dev/pts   
        
        
        
        if [ -f /etc/hostname ]; then
        /bin/hostname -F /etc/hostname
        fi
        
        if [ -e /sys/class/net/eth0 ]; then 
        ifconfig eth0 192.168.1.15
        fi
        
        echo "etc init.d rcS done"

更改rcS和inittab的权限为777：
chmod 777 init.d/rcS
chmod 777 inittab
 

另外还有几个文件和目录：
rc.d目录，可以存放自启动的一些脚本
mdev.conf（内容可为空，也可参考busybox docs/mdev.txt）
    profile
        #id -un = whoami
        export USER="id -un"
        export LOGNAME=$USER
        export PATH=$PATH
        
        #a colorful prompt begin with "\e[" end with "m"
        export PS1='\e[1;32m\u@\e[1;31m\h#\e[0m'
    
resolve.conf （是标注dns服务器的，就一句 nameserver 202.96.134.133）
hostname  （供init.d/rcS读取，就一个hostname名称，如mx27）
passwd，group，shadow用户/组/密码，可以用PC机上的替代，这里是一些说明：

代码
    passwd一共由7个字段组成，6个冒号将其隔开。它们的含义分别为：
        1     用户名
        2     是否有加密口令，x表示有，不填表示无，采用MD5、DES加密。
        3     用户ID
        4     组ID
        5     注释字段
        6     登录目录
        7     所使用的shell程序
    
    Group一共由4个字段组成，3个冒号将其隔开，它们的含义分别为：
        1     组名
        2     是否有加密口令，同passwd
        3     组ID
        4     指向各用户名指针的数组
    
    shadow一共由9个字段组成，8个冒号将其隔开，它们的含义分别为：
        1     用户名
        2     加密后的口令，若为空，表示该用户不需要口令即可登陆，若为*号，表示该账号被禁用。 上面的表示的是123456加密后的口令。
        3     从1970年1月1日至口令最近一次被修改的天数
        4     口令在多少天内不能被用户修改
        5     口令在多少天后必须被修改（0为没有修改过）
        6     口令过期多少天后用户账号被禁止
        7     口令在到期多少天内给用户发出警告
        8     口令自1970年1月1日被禁止的天数
        9     保留域
    
现在除了lib/modules/`uname -r`/kernel下的文件（`uname -r`为开发板linux版本，可以输入echo `uname -r`查看），这个rootfs基本完成了。在www.infradead.org的FAQ里找到mkfs的git地址（汗，不好找）:
    git clone git://git.infradead.org/mtd-utils.git
    cd mtd-utils
    git describe master  （版本号是v1.3.1-138-gf0cc488）
    进入mkfs.ubifs编译出错，在FAQ中看到需要3个库，安装之:
    sudo apt-get install zlib1g-dev
    sudo apt-get install liblzo2-dev
    sudo apt-get install uuid-dev
    make 成功产生mkfs.ubifs

接着把_install做成ubifs文件系统：
./mkfs.ubifs -r <path>/_install -m 512 -e 15360 -c 3897 -o ubifs.img
其中-m表示页面大小，-e表示逻辑擦除块大小，-c表示最大的逻辑擦除块数量，具体的可以通过barebox执行ubiattach的时候看到。

上电进入barebox：
erase /dev/nand0.root
ubiattach /dev/nand0.root
ubimkvol /dev/ubi0 root 0 （注意这里的名字必须跟bootargs匹配，默认为ubi0.root）
dhcp
tftp ubifs.img /dev/ubi0.root