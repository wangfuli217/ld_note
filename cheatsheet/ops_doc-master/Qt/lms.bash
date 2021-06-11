cat - <<'EOF'
  lms_i_upgrade: 使用 MFGTools 升级配置说明 
  lms_i_upgrade_MFGTools: MFGTools 配置文件详细说明
  
  lms_i_disk : sfdisk 初始化分区
  lms_i_rtud : lms 工程构建 rtud slotd hostd 等
  lms_i_hostd: 上层协议测试工具，shunit2+hostd
  lms_i_slotd: 下层协议测试工具，shunit2+slotd
  lms_i_qt   : qt 部分，从boot到内核，以及上层应用
  lms_i_gpio : gpio部分实现
  
  lms_i_rootfs: 文件系统构建     -> 升级 lms_i_upgrade
  lms_i_build_uboot: uboot构建   -> 升级 lms_i_upgrade
  lms_i_build_kernel:内核构建    -> 升级 lms_i_upgrade
EOF

lms_i_upgrade_MFGTools(){ cat - <<'EOF'
    MFGTools是飞思卡尔专门为imx系列产品开发的烧写工具.
Document\\V2\\Manufacturing Tool V2 Quick Start Guide.docx 软件操作文档

[software] -> 配置文件 UIcfg.ini, cfg.ini, Profiles\MX6Q Linux Update\OS Firmware\ucl2.xml
    https://github.com/NXPmicro/mfgtools

1. "UIcfg.ini"
    # UIcfg.ini 用来描述可以同时烧写 lms 系统的个数 # 当前只支持同时烧写一块单板; 即PortMgrDlg=1
    
2. "cfg.ini" 
    # cfg.ini文件用来配置目标芯片和目标操作列表。
    "profiles/chip" 用于表明目标芯片
    "list/name"     用于表明目标操作操作列表，该名字可以在"profiles/CHIP_PROFILE/OS Firmware/ucl2.xml"文件中找到
    "platform/board"字段目前保留，在修改的时候忽略即可
    
    配置 - [profiles]
    配置 - chip = MX6Q Linux Update
    即profiles\\"MX6Q Linux Update"\\ 目录下 "OS Firmware\ucl2.xml" 文件
    
3. "Profiles\MX6Q Linux Update\OS Firmware\ucl2.xml" 
    # USB OTG发现，烧写什么固件，怎么烧写
    
    配置 - <STATE name="BootStrap" dev="MX6Q" vid="15A2" pid="0054"/>
    配置 - <STATE name="Updater"   dev="MSC" vid="066F" pid="37FF"/> 
    如果name是"BootStrap",在该条目下dev只能是"MX6Q", "MX6D", "MX6SL"，其余值均不合法。
    如果name是"Updater"，则dev必须是"MSC",该名称对所有的SoC来说固定不变。
    只有 "BootStrap" 和 "Updater" 是有效的名称，其他名称为无效名称。
    
    ## USB OTG发现: 通过 vid="15A2" pid="0054" 确定可进行 升级 USB从设备
      CFG: USB(Universal Serial BUS，通用串行总线)协议规定.
           VID(Vendor ID)   供应商向USB-IF(Implementers Forum，应用者论坛)申请,每个供应商的VID是唯一的。
           PID(Product ID)  PID由供应商自行决定。
      主机通过VID和PID来识别不同设备，根据它们(以及设备的版本号),可以给设备加载或安装相应的驱动程序。VID和PID的长度都是两个字节的。
      VID,PID http://www.linux-usb.org/usb.ids
           Base Class: 用来识别设备的功能，根据这些功能，以加载设备驱动。这种信息包含在名为基类，子类和协议的3个字节里
           设备描述符: lsusb -v [Device Descriptor]              struct usb_device_descriptor    厂商信息、产品ID等
             配置描述符: lsusb -v [Configuration Descriptor]     struct usb_config_descroptor    配置信息
               接口描述符: lsusb -v [Interface Descriptor]       struct usb_interface_descriptor 接口功能信息
                 端点描述符: lsusb -v [Endpoint Descriptor]      struct usb_endpoint_descriptor  底层通信细节
           https://www.usb.org/defined-class-codes
    详细见 man_usb 
    
    ## 判断当前是在给I.MX系列的哪个SoC进行镜像烧写，并且具有很多个<LIST>描述的内容，  
    配置 - <LIST name="qt-SabreSD-eMMC" desc="Choose eMMC android as media"> "qt-SabreSD-eMMC" 就是在 cfg.ini 中确定的 LIST
      通常目标板烧写过程分为两个阶段：分别是bootstrap 和updater。
        Bootstrap阶段，MFGTools将特殊的uboot和kernel镜像烧写到目标板上，这特殊的镜像在目标板正常运行后为下一阶段做准备。
        Updater阶段，是主机(PC)与目标板建立连接，然后将uboot、kernel、文件系统等烧写到目标板的整个过程。 
    暗示，将镜像烧写到 Freescale "qt-SabreSD-eMMC" 开发板上。
    
    
4. mksdcard.sh.tar  修改分区大小  增加新分区
  sh mksdcard.sh /dev/mmcblk0
EOF
}

lms_i_upgrade(){
cat - <<'EOF'
[description]
    MfgTools烧写的基本原理为将目标板的启动模式设置为Serial Downloader模式(BOOT_MODE[1:0]=01)，
然后通过USB OTG接口将uboot、Linux kernel和dtb等下载到DRAM内存中，然后将DRAM里面的Linux系统启动起来，
接下来通过这个启动的Linux系统将目标镜像固化到Nand Flash、eMMC或SD卡等.
1. 第一阶段是通过USB OTG接口将uboot、Linux kernel和dtb等下载到DRAM中，并将该Linux系统进行启动
2. 第二阶段则是通过这个启动的Linux系统将目标镜像固化到存储介质中，烧写Nand Flash
[hardware] -> mcu前面板 按钮及功能
    USB - USB                mount /dev/sda1 /mnt/cdrom
    USB - upgrade USB        USB OTG(On-The-Go) OTG可以实现主机与主机之间通信，但实质也是通过设备作为媒介实现
    USB - console            screen /dev/ttyUSB0 115200
    Button - mask            蜂鸣器停止或者初始化LMS设备使用
    pointer - reset          手动重启LMS设备
    pointer - upgrade input  Mfgtools-MX6Q-linux-UPDATER_DDR_2GB

[ucl2.xml]
  阶段1: BootStrap 
    OS Firmware\u-boot-mx6q-sabresd.bin
    OS Firmware\uImage
    OS Firmware\initramfs.cpio.gz.uboot
  阶段2: Updater
    # boot 升级
    /sys/devices/platform/sdhci-esdhc-imx.3/mmc_host/mmc0/mmc0:0001/boot_config
    
    OS Firmware/files/linux/u-boot.bin
      dd if=u-boot.bin of=/dev/mmcblk0 bs=512 seek=2 skip=2
    
    # 分区表创建 和 uImage 烧写
    OS Firmware/mksdcard.sh.tar
      tar xf $FILE
      sh mksdcard.sh /dev/mmcblk0
    
    OS Firmware/files/files/linux/uImage
      dd if=uImage of=/dev/mmcblk0p1
     
    # 文件系统构建 和 文件系统烧写
    mkfs.ext3 -j /dev/mmcblk0p
      mkdir -p /mnt/mmcblk0p2
      mount -t ext3 /dev/mmcblk0p2 /mnt/mmcblk0p2
    
    OS Firmware/files/linux/qt4/rootfs.tar.bz2
      body="pipe tar  -jxv -C /mnt/mmcblk0p2" file="files/linux/qt4/rootfs.tar.bz2"
    
    # 结尾退出
    body="frf"
    body="$ umount /mnt/mmcblk0p2"
    body="$ echo Update Complete!"
EOF
}

lms_t_upgrade_win_driver(){ cat - <<'EOL'
1. 2020年11月18日: 在Windows环境下使用 MFGTools 升级的时候，出现了 uboot 和 initramdisk 都升级成功，
但是后续文件升级不成功的情况。就日志而言: 如下
Loading U-boot
Loading Kernel.
Loading Initramfs.
推断问题: usb可以作为windows的从设备，将数据发送给开发板，但是usb不能作为OTG类型的USB主设备，主要问题是驱动问题?
问题结论: 待求
EOL
}

lms_i_disk(){ cat - <<'EOL'
sfdisk [options] <dev> [[-N] <part>]
 <dev>                     device (usually disk) path
 <part>                    partition number
 <type>                    partition type, GUID for GPT, hex for MBR
 
-s, --show-size [<dev> ...]       list sizes of all or specified devices

sfdisk --force -uM ${node} << EOF
,${boot_rom_sizeb},83
#,${RECOVERY_ROM_SIZE},83
#,${extend_size},5
#,${data_size},83
,${SYSTEM_ROM_SIZE},83
#,${CACHE_SIZE},83
#,${VENDER_SIZE},83
#,${MISC_SIZE},83
EOF

sh mksdcard.sh /dev/mmcblk0
sfdisk --force -uM /dev/mmcblk0

1. boot_rom_sizeb
# partition size in MB
BOOTLOAD_RESERVE=8
BOOT_ROM_SIZE=8

boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}` # 16M

2. SYSTEM_ROM_SIZE=1024
SYSTEM_ROM_SIZE
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
SYSTEM_ROM_SIZE=`expr ${total_size} - ${boot_rom_sizeb}`

cat /proc/partitions
major      minor    #blocks    name
 179        0       15267840   mmcblk0
 179        1           8192   mmcblk0p1
 179        2       15251456   mmcblk0p2
 179       16           4096   mmcblk0boot1
 179        8           4096   mmcblk0boot0

df -h
Filesystem                Size      Used      Available Use% Mounted on
/dev/root                  14.3G    582.6M     13.0G    4%   /

mount 
/dev/root on / type ext3 (rw,relatime,errors=continue,barrier=0,data=writeback)


/sys/block/mmcblk0boot0/force_ro ?
/sys/devices/platform/sdhci-esdhc-imx.1/mmc_host/mmc0/mmc0:0001/boot_config ?
EOL
}


lms_i_rtud(){
cdlms # ubuntu笔记本
cat - <<'EOF'
[.bashrc]
LMSPAHT="/usr/local/arm/gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12/fsl-linaro-toolchain/bin"
export PATH=${LMSPAHT}:${PATH}
export TARGET=arm-none-linux-gnueabi

[rtud]
  [rtud slotd hostd]
  make 
  [test_* proto_desc_iterate proto_desc_tree_binary]
  make lmstest
  
  [static sanity]
  make cppcheck
  make clang-lint
  
  [code style]
  make codestyle
  
  [complexity]
  make complexity
  
[rtud.cfg]
EOF
}

lms_i_hostd(){
cdhostd # centos系统
cat - <<'EOF'
[lms-hostd_evolution]
  如何使用shunit2自动化测试hostd的问题?
1.已解决:
1.1 模块化(文件分解): 将hostd.sh分解成多个可以被测试的 小文件
方法1: module_source_suite  使用 source + suite_addTest 方式实现；共用同一个 shunit2 文件
方法2: module_multi_shunit2 使用 主脚本 runall 依次调用 依赖 shunit2 文件

1.2 表驱动测试 (测试单元 模块化)
方法1: while read -r want argument; do ... done <<'EOF' 多个参数情况下，参数放在read最后。

1.3 skip方法:
方法1: 在 test_      开头内进行判断 [ -z "${ILM_SLOT:-}" ] && startSkipping
方法2: 在 hostd_test 尾部进行    if [ -n "${GDM_SLOT}" ] ; then 启动 GDM测试
方法3: 在 表驱动测试中，根据条件 if [ -n "${ILM_E_SLOT}" ] ; 判断是否进行额外测试

2. 待优化:
模块化(文件分解): 不再支持 单实例 测试.
通过 test_helper  方式进行自动化测试，而不是脚本调用


2.1 hostd_test 代码覆盖率测试 (bashcov)
2.2 hostd      代码覆盖率测试 (gcov hostd.c) -> 将hostd.sh整合成一个更大的文件
2.3 sanitize   内存调试       (ubuntu-20)
EOF
}

lms_i_slotd(){
cdslotd # centos系统
cat - <<'EOL'
  如何使用shunit2自动化测试slotd的问题?
while read -r slot content1 content2; do
    \[ ${slot} = 255 ] && startSkipping
    # if [ ${slot} != 255 ]; then
      output="$($SLOTD version ${slot})"
      status=$?
      assertTrue "$SLOTD version ${slot} @ret:${status} @output:${output}" "${status}"
      assertContains "$SLOTD version ${slot} @output:${output}" "${output}" "${content1}"
      assertContains "$SLOTD version ${slot} @output:${output}" "${output}" "${content2}"
    \[ ${slot} = 255 ] && endSkipping || true
    # echo "\$\?:$?"
    # fi
  done <<EOF
"${ILM_SLOT:-255}"    hardware  software
"${ILM_E_SLOT:-255}"  hardware  software
"${GDM_SLOT:-255}"    hardware  software
"${TPWU_SLOT:-255}"   hardware  software
"${PWU_SLOT:-255}"    hardware  software
EOF

表驱动高级形式:
EOL
}

lms_i_qt(){ 
cat - <<'EOF'
[boot]
  uboot2009-08/include/configs/mx6q_sabresd.h
  /* 关闭 CONFIG_MIPI 打开 CONFIG_LVDS */
  //#define CONFIG_LVDS
  #define CONFIG_MIPI
  
  ./build/build_uboot.sh
[kernel]
  /* 关闭 CONFIG_LVDS_10_INCH 打开 CONFIG_MIPI_5_INCH */
  linux-3.0.35/drivers/input/touchscreen/gt9xx.h
  //#define CONFIG_LVDS_10_INCH
  #define CONFIG_MIPI_5_INCH
  
  0x46,0xE0,0x01,0x56,0x03,0x05,0x35, -> 0x46,0xE0,0x01,0x56,0x03,0x05,0x3D,
  
  ./build/build_kernel.sh
  
[lms_upgrade] configuration from Mfgtools-MX6Q-linux-UPDATER_DDR_2GB\Profiles\MX6Q Linux Update\OS Firmware\ucl2.xml 
result/u-boot.bin  u-boot.imx  uImage  zImage
       u-boot.bin      -> Mfgtools-MX6Q-linux-UPDATER_DDR_2GB\Profiles\MX6Q Linux Update\OS Firmware\u-boot-mx6q-sabresd.bin
       uImage  zImage  -> Mfgtools-MX6Q-linux-UPDATER_DDR_2GB\Profiles\MX6Q Linux Update\OS Firmware\files\linux\
       
[environment]
  /etc/rc_env.sh 
  /* 修改如下: 实现显示横屏 */
  export QWS_DISPLAY="transformed:rot270:linuxfb:mmWidth50:mmHeight130:0"
  
[qt]
  mv QtLMS /opt/qt4.8.5/demos/embedded/fluidlauncher/fluidlauncher 
EOF
}

lms_i_gpio(){ cat - <<'EOF'
蜂鸣器: 3-19  value=0 停止鸣叫  value=1 开始鸣叫
风扇  : 6-11
mask  : 



EOF
}


lms_i_rootfs(){ cat - <<'EOF'
1. 关于同步问题
lms系统添加了rsync后端服务程序，默认不启动，手动启动命令如下:
/sbin/rsync --daemon --bwlimit=500
使得客户端可以将目录信息同步到指定位置(
lms系统        : 对裸板系统进行升级
或者ubuntu系统 : 制作升级需要文件系统:rootfs.tar.bz2
)

1.1 从lms系统同步到其他的lms系统:
rsync -az  192.168.27.172::lms/bin . 
在根目录执行如下命令，即可将 192.168.27.172 系统上的bin目录同步到本地目录。
情况1: 原初系统，未使用 "Mfgtools-MX6Q-linux-UPDATER_DDR_2GB" 升级系统时。
nc -l -p 8001 > /sbin/rsync
rsync -az  192.168.27.172::lms/bin . 
rsync -az  192.168.27.172::lms/sbin . 
rsync -az  192.168.27.172::lms/etc . 
rsync -az  192.168.27.172::lms/usr . 
rsync -az  192.168.27.172::lms/lib . 
rsync -az  192.168.27.172::lms/home . 
rsync -az  192.168.27.172::lms/opt . 

情况2: 已使用 "Mfgtools-MX6Q-linux-UPDATER_DDR_2GB" 升级系统后
rsync -az  192.168.27.172::lms/etc . 
同步时，注意lms中/etc/rtud中配置信息

1.2 从lms系统同步到ubuntu系统制作rootfs.tar.bz2
sudo rsync -az  192.168.27.172::lms/bin . 
注意: 增加sudo开头，保证同步过来文件权限 与 所在系统文件权限一致。

rsync_rootfs 在重新编译lms工程，同步完新编rtud slotd hostd之后，将临时 lms 目录中文件同步到 rootfs/filesystem/
build-rootfs 在设定sbin bin etc 目录下文件权限之后，创建 "Mfgtools-MX6Q-linux-UPDATER_DDR_2GB" 
需要的rootfs.tar.bz2
注意: 增加sudo开头，保证有权限进行同步和bin sbin etc目录的权限设定。
-> lms_upgrade 说明升级所需要关注: 前面板按钮功能， "Mfgtools-MX6Q-linux-UPDATER_DDR_2GB"
设定uboot kernel rootfs.tar.bz2等文件所在位置。

2. 关于制作rootfs.tar.bz2的细节: 参考 笔记本: lms_middle目录中rsync_rootfs文件 和 filesystem/build-rootfs文件
[extract] -> 将"Mfgtools-MX6Q-linux-UPDATER_DDR_2GB"中文件系统解压到 filesystem 目录
  mkdir filesystem && cd filesystem
  tar -xjvf rootfs.tar.bz2 .
[rsync]   -> 将定制(新增)文件同步到 rootfs/filesystem 目录，即 实现对上层应用重新定制
  rsync -arv lms/* rootfs/filesystem/
[create]  -> 重新创建 rootfs.tar.bz2 并将此文件拷贝到 升级软件所需位置
  cd rootfs/filesystem
  tar -cf ./rootfs.tar *
  bzip2 -z rootfs.tar
[move]
  mv rootfs.tar.bz2 "Mfgtools-MX6Q-linux-UPDATER_DDR_2GB/Profiles/MX6Q Linux Update/OS Firmware/files/linux/"
EOF
}


lms_i_build_kernel(){ cat - <<'EOF'
ROOT_DIR=`pwd`
#ROOT_DIR=$BUILD_DIR/../
KERNEL_DIR=$ROOT_DIR/linux-3.0.35/
export ROOT_DIR
export KERNEL_DIR
CPUS=12
export ARCH=arm
export CROSS_COMPILE=$ROOT_DIR/build/arm-gcc-toolchain-4.6.2/arm-eabi-4.6/bin/arm-eabi-
export PATH=$ROOT_DIR/build/arm-gcc-toolchain-4.6.2/arm-eabi-4.6/bin:$PATH
cd $KERNEL_DIR

if [ ! -f .config ]; then
  make distclean
  cp arch/arm/configs/imx6_defconfig .config
fi

make uImage -j${CPUS}

cd $ROOT_DIR
if [ ! -d result ]; then
  mkdir result
fi

cp -a $KERNEL_DIR/arch/arm/boot/uImage $ROOT_DIR/result
cp -a $KERNEL_DIR/arch/arm/boot/zImage $ROOT_DIR/result
EOF
}
lms_i_build_uboot(){ cat - <<'EOF'
ROOT_DIR=`pwd`
#ROOT_DIR=$BUILD_DIR/../
DEV=
UBOOT_DIR=$ROOT_DIR/uboot2009-08/

if [ ! -d result ]; then
  mkdir result
fi

if [ ! -n "$1" ] || [ $1 = 6q ]; then
  DEV=6q
elif [ "$1" = 6dl ]; then
  DEV=6dl
  UBOOT_DIR=$ROOT_DIR/uboot2015-04/
elif [ ! -n "$DEV" ]; then
  echo "input wrong, try ./build/build_uboot.sh 6dl(6q) or ./build/build_uboot.sh"
  exit 1
fi

CPUS=`grep -c processor /proc/cpuinfo`
export ARCH=arm
export CROSS_COMPILE=$ROOT_DIR/build/arm-gcc-toolchain-4.6.2/arm-eabi-4.6/bin/arm-eabi-
export PATH=$ROOT_DIR/build/arm-gcc-toolchain-4.6.2/arm-eabi-4.6/bin:$PATH
cd $UBOOT_DIR
pwd
if [ "$DEV" == "6q" ]; then
  echo "================= build 6q uboot ===================="
  make distclean
  make mx6q_sabresd_config
  make -j${CPUS}
  cp -a $UBOOT_DIR/u-boot.bin $ROOT_DIR/result/
elif [ "$DEV" = 6dl ]; then
  echo "================= build 6dl uboot ===================="
  make distclean
  make mx6dlsabresd_config
  make -j${CPUS}
  cp -a $UBOOT_DIR/u-boot.imx $ROOT_DIR/result/
fi
EOF
}

lms_t_test(){ cat - <<'EOF'
1. 升级测试
通过 MFGTools 对系统进行升级.

1.1 otg 口测试(升级功能)
USB - upgrade USB      
pointer - upgrade input

1.2 串口测试 (输入输出功能)
USB - console   

1.3 USB接口测试 (U盘识别)
USB - USB  

1.4 reset 按键测试 (系统重启)


2. gpio 接口测试;
2.1 led灯测试
亮灯 | 灭灯
2.2 蜂鸣器测试
鸣叫 | 停止鸣叫
2.3 风扇测试
转动 | 停止转动
2.4 mask按键测试
按下 | 弹起


3. 序列号功能测试
3.1 获取序列号
3.2 设置序列号


4. 绝缘板测试
4.1 设置室外监测站
<正常测试>
在室外监测站方向，个数，距离有效状态设置: 
设置方向1，方向2，方向3， 方向4(如果有ilm扩展板，设置方向5，方向6，方向7， 方向8)

<异常测试>
方向无效设置:     例如方向0，方向9
测试个数无效设置: 例如室外监测站个数多余15
距离无效状态:     例如距离大于10或者等于0

4.2 获取室外监测站
<正常测试>
在室外监测站方向有效状态获取: 
获取方向1，方向2，方向3， 方向4(如果有ilm扩展板，获取方向5，方向6，方向7， 方向8)
<异常测试>
方向无效获取:     例如方向0，方向9

4.3 绝缘测试 (灯状态) 测试过程中，测试结束120秒内，测试结束120秒后. 250V上电|250V下电
<正常测试>
在室外监测站方向有效状态测试: 
测试方向1，方向2，方向3， 方向4(如果有ilm扩展板，测试方向5，方向6，方向7， 方向8)

<异常测试>
方向无效测试:     例如方向0，方向9

绝缘测试中，又发起同方向新测试；
绝缘测试中，又发起不同方向新测试；
绝缘测试后120秒内，又发起同方向新测试；
绝缘测试后120秒内，又发起不同方向新测试；
绝缘测试120秒后，又发起同方向新测试；
绝缘测试120秒后，又发起不同方向新测试；

4.4 绝缘测试精度问题:
根据环境正确"设置室外监测站"之后，
多少次测试后；测试精度误差范围； ? 
某一个室外监测站绝缘电阻变化后：未变化绝缘电阻值与标准值之间误差 ?
某一个室外监测站断缆之后:       未变化绝缘电阻值与标准值之间误差

4.5 绝缘结果值设置
绝缘结果值：设置方向1，方向2，方向3， 方向4(如果有ilm扩展板，设置方向5，方向6，方向7， 方向8)

4.6 绝缘结果值获取
绝缘结果值：获取方向1，方向2，方向3， 方向4(如果有ilm扩展板，设置方向5，方向6，方向7， 方向8)


绝缘测试方向1，方向2，方向3， 方向4(如果有ilm扩展板，测试方向5，方向6，方向7， 方向8)

绝缘测试中，又发起同方向新测试；
绝缘测试中，又发起不同方向新测试；
绝缘测试后120秒内，又发起同方向新测试；
绝缘测试后120秒内，又发起不同方向新测试；
绝缘测试120秒后，又发起同方向新测试；
绝缘测试120秒后，又发起不同方向新测试；

多少次测试后；测试精度误差范围； ? 


4.7 绝缘结果值清除
绝缘结果值：清除方向1，方向2，方向3， 方向4(如果有ilm扩展板，设置方向5，方向6，方向7， 方向8)

5. 250V电源板测试 (灯状态) 250V上电|250V下电
5.1 使250V上电
5.2 使250V下电

6. gpio业务功能
6.1 LED灯在何种状态下点亮，何种状态下熄灭
6.2 风扇在何种状态启动转动，何种状态停止转动
6.3 蜂鸣器在何种状态下鸣叫，何种状态下停止鸣叫
6.4 mask按键，按下去对mcu板有何种影响，
6.5 显示屏gpio控制原则: 

7. LMS板卡热插拔测试
7.1 设备上电后，查看当前板卡状态及位置。
    拔出250V电源板或ILM绝缘板120秒后，重新查看当前板卡状态及位置。    -> 保证插入位置和灯状态
    重新插入250V电源板或ILM绝缘板120秒后，重新查看当前板卡状态及位置。-> 保证插入位置和灯状态

7.2 设备上电后，进行绝缘电阻测试；测试结束
    拔出250V电源板进行绝缘测试...                        -> 结果应该是测试失败。
    重新插入250V电源板120秒后，重新进行绝缘电阻测试。    -> 结果应该是测试成功。

    拔出ILM绝缘板进行绝缘测试...                         -> 结果应该是测试失败。
    重新插入ILM绝缘板120秒后，重新进行绝缘电阻测试。     -> 结果应该是测试成功。
    
8. 显示屏操作待说明

EOF
}