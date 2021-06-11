这里基于 openwrt mt7620a 平台来跟踪，主要是想理清 dts 里的分区描述是如何一步步转化成内核分区行为。
# DTS是Device Tree Source的缩写，它用来描述设备的硬件细节。说简单点就是开发板的配置文件。
mt7620a
rt2880

先来看看 dts 中关于分区的描述：
# DTS格式有点类似Json
    palmbus@10000000 {
        spi@b00 {
            status = "okay";

            m25p80@0 {
                #address-cells = <1>;
                #size-cells = <1>;
                compatible = "w25q128";
                reg = <0 0>;
                linux,modalias = "m25p80", "w25q128";
                spi-max-frequency = <10000000>;

                partition@0 {
                    label = "u-boot";
                    reg = <0x0 0x30000>;
                    read-only;
                };

                partition@30000 {
                    label = "u-boot-env";
                    reg = <0x30000 0x10000>;
                    read-only;
                };

                factory: partition@40000 {
                    label = "factory";
                    reg = <0x40000 0x10000>;
                    read-only;
                };

                partition@50000 {
                    label = "firmware";
                    reg = <0x50000 0xfb0000>;
                };
            };
        };

dts 描述的是一个树状结构。spi 控制器挂在 platform 总线上，spi flash (w25q128) 挂在 spi 总线上。 探测到 spi flash 的流程如下：

1. plat_of_setup() 遍历 palmbus 上的设备，并为每一个动态创建 platform_device，添加到系统总线上 device_add()。对于 spi 这里会创建一个名为 "ralink,rt2880-spi" 的 platfrom_device 并添加到系统中。
2. drivers/spi/spi-rt2880.c 中会注册 spi 的 platform_driver，与上一步的 platfrom_device match 上了之后，触发调用 rt2880_spi_probe() 。
3. spi_register_master() 向系统注册 spi 主控制器，并最后调用 of_register_spi_devices(master) 看看 dts 中在 spi 总线上有哪些设备。
4. 对 dts 中描述的每一个 spi 总线下的设备，为其创建相应的 spi_device，同时根据 dts 中描述的 reg, spi-cpha, spi-cpol, spi-cs-high, spi-3wire, spi-max-frequency 等属性来配置该 spi 设备。对于这里，创建了一个名为 “m25p80” 的 spi_device。
5. drivers/mtd/device/m25p80.c 中有名为 "m25p80" 的 spi_driver，于是 match 上了。触发执行 m25p_probe()。
6. m25p_probe() 中读到了这颗 spi flash 的 id 后，确认了一些基本信息（如页大小、块大小）, 最后调用 mtd_device_parse_register() 开始真正的分区。

分区解析器
part_parser 用来按照某种规则将分区信息解析出来。这些规则可以有很多，内核里调用 register_mtd_parser() 即可注册一个新的解析器。
drivers/mtd/mtdpart.c 中维护了一个链表 part_parsers，解析器按注册顺序添加到这个链表里。
parse_mtd_partitions() 中，如果未指定解析器的话，则默认只允许用 cmdlinepart, ofpart 两种解析器。对于我们这里，实际上起作用的是 ofpart。

static struct mtd_part_parser ofpart_parser = {
    .owner = THIS_MODULE,
    .parse_fn = parse_ofpart_partitions,
    .name = "ofpart",
};

    parse_ofpart_partitions() 遍历 dts 中 spi flash 设备下的分区描述信息，取出其中的 reg, label, name, read-only, 
lock 等信息以填充一个 struct mtd_partition 结构体。上面 dts 里描述了 4 个分区， 就有一个大小为 4 的 struct 
mtd_partition 数组，最后由 add_mtd_partitions() 添加为各 mtd 分区。

分区的情况可以待系统启动后在 /proc/mtd 文件中查看到。
# cat /proc/mtd 
dev:    size   erasesize  name
mtd0: 00030000 00010000 "u-boot"
mtd1: 00010000 00010000 "u-boot-env"
mtd2: 00010000 00010000 "factory"
mtd3: 00fb0000 00010000 "firmware"
mtd4: 00ea9283 00010000 "rootfs"
mtd5: 00b30000 00010000 "rootfs_data"


根文件系统的解析
    上面 /proc/mtd 的内容中相比 dts 中的描述多了两个分区 rootfs, rootfs_data。这两个分区是何时添加的呢？
    看看添加 mtd 分区的函数：
int add_mtd_partitions(struct mtd_info *master,
               const struct mtd_partition *parts,
               int nbparts)
{
    struct mtd_part *slave;
    uint64_t cur_offset = 0;
    int i;

    printk(KERN_NOTICE "Creating %d MTD partitions on \"%s\":\n", nbparts, master->name);

    for (i = 0; i < nbparts; i++) {
        slave = allocate_partition(master, parts + i, i, cur_offset);
        if (IS_ERR(slave))
            return PTR_ERR(slave);

        mutex_lock(&mtd_partitions_mutex);
        list_add(&slave->list, &mtd_partitions);
        mutex_unlock(&mtd_partitions_mutex);

        add_mtd_device(&slave->mtd);
        mtd_partition_split(master, slave);

        cur_offset = slave->offset + slave->mtd.size;
    }

    return 0;
}

最后调用了 mtd_partition_split()。

static void mtd_partition_split(struct mtd_info *master, struct mtd_part *part)
{
    static int rootfs_found = 0;

    if (rootfs_found)
        return;

    if (!strcmp(part->mtd.name, "rootfs")) {
        rootfs_found = 1;

        if (config_enabled(CONFIG_MTD_ROOTFS_SPLIT))
            split_rootfs_data(master, part);
    }

    if (!strcmp(part->mtd.name, SPLIT_FIRMWARE_NAME) &&
        config_enabled(CONFIG_MTD_SPLIT_FIRMWARE))
        split_firmware(master, part);

    arch_split_mtd_part(master, part->mtd.name, part->offset,
                part->mtd.size);
}

如果：
rootfs 还没有被找到
    当前分区名是 "firmware"
    内核配置时开启了 CONFIG_MTD_SPLIT_FIRMWARE
    # grep FIRMWARE ./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621/linux-3.18.36/.config
    # grep FIRMWARE ./build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/linux-3.18.36/.config
    
    # build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621/firewrt-kernel.bin
则调用 split_firmware() 来解析。在该函数中做了以下几件事：
    找 type 为 MTD_PARSER_TYPE_FIRMWARE 的分区解析器来分析。
    "uimage-fw" 解析器读出 firmware 分区的头部，成功找到一个 uImage。
    跃过 uImage，紧接着成功找到 squashfs 的头信息，于是找到了格式为 squashfs 的 rootfs。
    解析器在找到一个分区后，会调用 __mtd_add_partition() 将此分区添加到系统中。
    __mtd_add_partition() 最后又调用 mtd_partition_split()，因为此时 rootfs 已经找到，所以会调用 split_rootfs_data() 找 rootfs_data 分区。
    rootfs 为 squashfs 分区，该格式的文件系统只读，且头信息里有标记分区大小。所以很容易就可以找到 rootfs_data 的起始位置。
    
    
https://blog.csdn.net/u012041204/article/details/54799858
demo(以rt5350.dtsi作为分析){
DTS格式有点类似Json

/ {                                                         #  "/"表示root节点
  #address-cells和#size-cells分别决定reg属性的address和length字段的长度。
  # 比如reg<0x500 0x100>,0x500和0x100两个数值都是32位的
    #address-cells = <1>;         //地址长度为1个32位的整型
    #size-cells = <1>;            //length为1个32位的整型
    # ralink:厂商  rt5350-soc:具体的芯片型号
    compatible = "ralink,rt5350-soc";  # 定义系统名称，compatible属性用于驱动和设备的绑定，
                                       # 属性值形式：<manufacturer>,<model>

    cpus {   # 芯片中的所有cpu定义
        cpu@0 {    # cpu@0表示第一个cpu,如果还有其他cpu就依次定义为cpu@1 cpu@2 .....
            compatible = "mips,mips24KEc";   # mips的cpu内核，mips24KEc是具体型号
        };
    };

    chosen {
        bootargs = "console=ttyS0,57600"; # 启动参数，定义了串口ttyS0为调试串口，波特率为57600
    };

    cpuintc: cpuintc@0 {
        #address-cells = <0>;
        #interrupt-cells = <1>;   # 中断号长度
        interrupt-controller;
        compatible = "mti,cpu-interrupt-controller";
    };

    aliases {         # 定义别名
        spi0 = &spi0;
        spi1 = &spi1;
        serial0 = &uartlite;   # uartlite的别名为serial0
    };

    palmbus@10000000 {  #  @后面代表address
        compatible = "palmbus";
        reg = <0x10000000 0x200000>;         # address: 0x10000000   length:0x200000
        ranges = <0x0 0x10000000 0x1FFFFF>;  # 地址转换表 ：<子地址 父地址 子地址空间的映射大小>

        #address-cells = <1>;     //决定子节点reg的address字段长度
        #size-cells = <1>;        //决定子节点reg的length字段长度

        sysc@0 {
            compatible = "ralink,rt5350-sysc", "ralink,rt3050-sysc";   # 兼容rt5350和rt3050
            reg = <0x0 0x100>;
        };

        timer@100 {
            compatible = "ralink,rt5350-timer", "ralink,rt2880-timer";
            reg = <0x100 0x20>;
            # 在RT5350中，将GPIO设置为中断方式，当它触发中断时，CPU的中断控制器先获取中断，在这里叫一级中断。
            # 判断它是GPIO中断，然后进入GPIO中断控制器判断是哪个GPIO产生的中断，这里叫二级中断，再进行中断处理。
            interrupt-parent = <&intc>;    # 当上级发生intc中断时才来查询是否是该中断。
            interrupts = <1>;              # 中断等级
        };

        watchdog@120 {
            compatible = "ralink,rt5350-wdt", "ralink,rt2880-wdt";
            reg = <0x120 0x10>;

            resets = <&rstctrl 8>;
            reset-names = "wdt";

            interrupt-parent = <&intc>;
            interrupts = <1>;
        };

        intc: intc@200 {
            compatible = "ralink,rt5350-intc", "ralink,rt2880-intc";
            reg = <0x200 0x100>;

            resets = <&rstctrl 19>;
            reset-names = "intc";

            interrupt-controller;
            #interrupt-cells = <1>;

            interrupt-parent = <&cpuintc>;
            interrupts = <2>;
        };

        memc@300 {
            compatible = "ralink,rt5350-memc", "ralink,rt3050-memc";
            reg = <0x300 0x100>;

            resets = <&rstctrl 20>;
            reset-names = "mc";

            interrupt-parent = <&intc>;
            interrupts = <3>;
        };

        uart@500 {
            compatible = "ralink,rt5350-uart", "ralink,rt2880-uart", "ns16550a";
            reg = <0x500 0x100>;

            resets = <&rstctrl 12>;
            reset-names = "uart";

            interrupt-parent = <&intc>;
            interrupts = <5>;

            reg-shift = <2>;

            status = "disabled"; # 内容去掉就使能了串口。
        };

        gpio0: gpio@600 {
            compatible = "ralink,rt5350-gpio", "ralink,rt2880-gpio";
            reg = <0x600 0x34>;  # 从0X600开始映射多少地址

            resets = <&rstctrl 13>; # 名字为PIO
            reset-names = "pio";

            interrupt-parent = <&intc>;
            interrupts = <6>;

            gpio-controller;
            #gpio-cells = <2>;

            ralink,gpio-base = <0>;
            ralink,num-gpios = <22>;
            ralink,register-map = [ 00 04 08 0c
                        20 24 28 2c
                        30 34 ]; # 各寄存器的地址
        };

        gpio1: gpio@660 {
            compatible = "ralink,rt5350-gpio", "ralink,rt2880-gpio";
            reg = <0x660 0x24>;

            interrupt-parent = <&intc>;
            interrupts = <6>;     # 中断号为6

            gpio-controller;
            #gpio-cells = <2>;

            ralink,gpio-base = <22>;
            ralink,num-gpios = <6>;
            ralink,register-map = [ 00 04 08 0c
                        10 14 18 1c
                        20 24 ];

            status = "disabled";     # 本模块状态
        };

        i2c@900 {
            compatible = "link,rt5350-i2c", "ralink,rt2880-i2c";
            reg = <0x900 0x100>;

            resets = <&rstctrl 16>;
            reset-names = "i2c";

            #address-cells = <1>;
            #size-cells = <0>;

            pinctrl-names = "default";
            pinctrl-0 = <&i2c_pins>;

            status = "disabled";
        };

        spi0: spi@b00 {
            compatible = "ralink,rt5350-spi", "ralink,rt2880-spi";
            reg = <0xb00 0x40>;

            resets = <&rstctrl 18>;
            reset-names = "spi";

            #address-cells = <1>;
            #size-cells = <1>;

            pinctrl-names = "default";
            pinctrl-0 = <&spi_pins>;

            status = "disabled";
        };

        spi1: spi@b40 {
            compatible = "ralink,rt5350-spi", "ralink,rt2880-spi";
            reg = <0xb40 0x60>;

            resets = <&rstctrl 18>;
            reset-names = "spi";

            #address-cells = <1>;
            #size-cells = <0>;

            pinctrl-names = "default";
            pinctrl-0 = <&spi_cs1>;

            status = "disabled";
        };

        uartlite: uartlite@c00 {
            compatible = "ralink,rt5350-uart", "ralink,rt2880-uart", "ns16550a";
            reg = <0xc00 0x100>;

            resets = <&rstctrl 19>;
            reset-names = "uartl";

            interrupt-parent = <&intc>;
            interrupts = <12>;

            pinctrl-names = "default";
            pinctrl-0 = <&uartlite_pins>;

            reg-shift = <2>;
        };

        systick@d00 {
            compatible = "ralink,rt5350-systick", "ralink,cevt-systick";
            reg = <0xd00 0x10>;

            interrupt-parent = <&cpuintc>;
            interrupts = <7>;
        };
    };

    pinctrl {  # 引脚控制
        compatible = "ralink,rt2880-pinmux";

        pinctrl-names = "default";
        pinctrl-0 = <&state_default>;

        state_default: pinctrl0 {
        };

        spi_pins: spi {
            spi {
                ralink,group = "spi";
                ralink,function = "spi";
            };
        };

        i2c_pins: i2c {
            i2c {
                ralink,group = "i2c";
                ralink,function = "i2c";
            };
        };

        phy_led_pins: phy_led {
            phy_led {
                ralink,group = "led";
                ralink,function = "led";
            };
        };

        uartlite_pins: uartlite {
            uart {
                ralink,group = "uartlite";
                ralink,function = "uartlite";
            };
        };

        uartf_pins: uartf {
            uartf {
                ralink,group = "uartf";
                ralink,function = "uartf";
            };
        };

        spi_cs1: spi1 {
            spi1 {
                ralink,group = "spi_cs1";
                ralink,function = "spi_cs1";
            };
        };
    };

    rstctrl: rstctrl {
        compatible = "ralink,rt5350-reset", "ralink,rt2880-reset";
        #reset-cells = <1>;
    };

    usbphy: usbphy {
        compatible = "ralink,rt3352-usbphy";
        #phy-cells = <1>;

        resets = <&rstctrl 22 &rstctrl 25>;
        reset-names = "host", "device";
    };

    ethernet@10100000 {
        compatible = "ralink,rt5350-eth";
        reg = <0x10100000 0x10000>;

        resets = <&rstctrl 21 &rstctrl 23>;
        reset-names = "fe", "esw";

        interrupt-parent = <&cpuintc>;
        interrupts = <5>;

        mediatek,switch = <&esw>;
    };

    esw: esw@10110000 {
        compatible = "ralink,rt3050-esw";
        reg = <0x10110000 0x8000>;

        resets = <&rstctrl 23>;
        reset-names = "esw";

        interrupt-parent = <&intc>;
        interrupts = <17>;
    };

    wmac@10180000 {
        compatible = "ralink,rt5350-wmac", "ralink,rt2880-wmac";
        reg = <0x10180000 0x40000>;

        interrupt-parent = <&cpuintc>;
        interrupts = <6>;

        ralink,eeprom = "soc_wmac.eeprom";
    };

    ehci@101c0000 {
        compatible = "generic-ehci";
        reg = <0x101c0000 0x1000>;

        phys = <&usbphy 1>;
        phy-names = "usb";

        interrupt-parent = <&intc>;
        interrupts = <18>;
    };

    ohci@101c1000 {
        compatible = "generic-ohci";
        reg = <0x101c1000 0x1000>;

        phys = <&usbphy 1>;
        phy-names = "usb";

        interrupt-parent = <&intc>;
        interrupts = <18>;
    };
};



  在执行完unflatten_device_tree()后，DTS节点信息被解析出来，保存到allnodes链表中，allnodes会在后面被用到。
  随后，当系统启动到board文件时，会调用.init_machine，高通8974平台对应的是msm8974_init()。接着调用
of_platform_populate(....)接口，加载平台总线和平台设备。至此，系统平台上的所有已配置的总线和设备将
被注册到系统中。注意：不是dtsi文件中所有的节点都会被注册，在注册总线和设备时，会对dts节点的状态作
一个判断，如果节点里面的status属性没有被定义，或者status属性被定义了并且值被设为"ok"或者"okay"，
其他情况则不被注册到系统中。

}
http://blog.chinaunix.net/uid-28790518-id-5196878.html
desc(ARM Device Tree起源){
    在过去的ARM Linux中，arch/arm/plat-xxx和arch/arm/mach-xxx中充斥着大量的垃圾代码，相当多数的代码只是在
描述板级细节，而这些板级细节对于内核来讲，不过是垃圾，如板上的platform设备、resource、i2c_board_info、
spi_board_info以及各种硬件的platform_data。读者有兴趣可以统计下常见的s3c2410、s3c6410等板级目录，代码量在数万行。

    Device Tree是一种描述硬件的数据结构;
    在Linux 2.6中，ARM架构的板级硬件细节过多地被硬编码在arch/arm/plat-xxx和arch/arm/mach-xxx，采用Device Tree后，
许多硬件的细节可以直接透过它传递给Linux，而不再需要在kernel中进行大量的冗余编码。
    Device Tree由一系列被命名的结点（node）和属性（property）组成，而结点本身可包含子结点。所谓属性，其实就是
成对出现的name和value。在Device Tree中，可描述的信息包括（原先这些信息大多被hard code到kernel中）：
  CPU的数量和类别
  内存基地址和大小
  总线和桥
  外设连接
  中断控制器和中断使用情况
  GPIO控制器和GPIO使用情况
  Clock控制器和Clock使用情况
    它基本上就是画一棵电路板上CPU、总线、设备组成的树，Bootloader会将这棵树传递给内核，然后内核可以识别这棵树，
并根据它展开出Linux内核中的platform_device、i2c_client、spi_device等设备，而这些设备用到的内存、IRQ等资源，
也被传递给了内核，内核会将这些资源绑定给展开的相应的设备。
}
desc(Device Tree组成和结构){
    整个Device Tree牵涉面比较广，即增加了新的用于描述设备硬件信息的文本格式，又增加了编译这一文本的工具，
同时Bootloader也需要支持将编译后的Device Tree传递给Linux内核。
    一个.dts文件对应一个ARM的machine，一般放置在内核的arch/arm/boot/dts/目录。
    由于一个SoC可能对应多个machine（一个SoC可以对应多个产品和电路板），势必这些.dts文件需包含许多共同的部分，
Linux内核为了简化，把SoC公用的部分或者多个machine共同的部分一般提炼为.dtsi，类似于C语言的头文件。

.dts（或者其include的.dtsi）基本元素即为前文所述的结点和属性：
/ {   # 1个root结点"/"； root结点下面含一系列子结点，本例中为"node1" 和 "node2"；
    node1 {   #结点"node1"下又含有一系列子结点，本例中为"child-node1" 和 "child-node2"；
        a-string-property = "A string";  
        a-string-list-property = "first string", "second string";  # 可能为字符串数组
        a-byte-data-property = [0x01 0x23 0x34 0x56]; # 可能为二进制数
        child-node1 {  
            first-child-property;               # 这些属性可能为空，
            second-child-property = <1>;        #
            a-string-property = "Hello, world"; # 可能为字符串
        };  
        child-node2 {  
        };  
    };  
    node2 {  
        an-empty-property;  
        a-cell-property = <1 2 3 4>; # 可能为Cells（由u32整数组成）
        child-node1 {  
        };  
    };  
};
}

在.dts文件的每个设备，都有一个compatible 属性，compatible属性用户驱动和设备的绑定。
compatible 属性是一个字符串的列表，列表中的第一个字符串表征了结点代表的确切设备，形式为"<manufacturer>,<model>"，其后的字符串表征可兼容的其他设备。
可以说前面的是特指，后面的则涵盖更广的范围。
如在arch/arm/boot/dts/vexpress-v2m.dtsi中的Flash结点：
compatible = "arm,vexpress-flash", "cfi-flash"; # compatible属性的第2个字符串"cfi-flash"明显比第1个字符串"arm,vexpress-flash"涵盖的范围更广。
compatible = "fsl,mpc8349-uart", "ns16550"      # Freescale MPC8349 SoC含一个串口设备，它实现了国家半导体（National Semiconductor）的ns16550 寄存器接口。
                                                # fsl,mpc8349-uart指代了确切的设备， ns16550代表该设备与National Semiconductor 的16550 UART保持了寄存器兼容。

desc(demo){
/ {  # 透过root结点"/"的compatible 属性即可判断它启动的是什么machine。
    compatible = "acme,coyotes-revenge";  # 系统的名称；组织形式为：<manufacturer>,<model>
    #address-cells = <1>;  
    #size-cells = <1>;  
    interrupt-parent = <&intc>;  
  # 注意cpus和cpus的2个cpu子结点的命名，它们遵循的组织形式为：<name>[@<unit-address>]，<>中的内容是必选项，[]中的则为可选项。
  # name是一个ASCII字符串，用于描述结点对应的设备类型，如3com Ethernet适配器对应的结点name宜为ethernet，而不是3com509。
  # 如果一个结点描述的设备有地址，则应该给出@unit-address。
  # 多个相同类型设备结点的name可以一样，只要unit-address不同即可
  
  # 本例中含有cpu@0、cpu@1以及serial@101f0000与serial@101f2000这样的同名结点。
  # 设备的unit-address地址也经常在其对应结点的reg属性中给出。
  
  # ePAPR标准给出了结点命名的规范。
  # 可寻址的设备使用如下信息来在Device Tree中编码地址信息：
  # reg              reg = <address1 length1 [address2 length2] [address3 length3] ... >，其中的每一组address length表明了设备使用的一个地址范围。
                   # address为1个或多个32位的整型（即cell），而length则为cell的列表或者为空（若#size-cells = 0）。address 和 length 字段是可变长的
                   # 父结点的#address-cells和#size-cells分别决定了子结点的reg属性的address和length字段的长度。
        # root结点的#address-cells = <1>;和#size-cells = <1>;决定了serial、gpio、spi等结点的address和length字段的长度分别为1。
        # cpus 结点的#address-cells = <1>;和#size-cells = <0>;决定了2个cpu子结点的address为1，而length为空，于是形成了2个cpu的reg = <0>;和reg = <1>;。
        # external-bus结点的#address-cells = <2>和#size-cells = <1>;决定了其下的ethernet、i2c、flash的reg字段形如reg = <0 0 0x1000>;、reg = <1 0 0x1000>;和reg = <2 0 0x4000000>;。
        # 其中，address字段长度为0，开始的第1个cell（0、1、2）是对应的片选，第2个cell（0，0，0）是相对该片选的基地址，第3个cell（0x1000、0x1000、0x4000000）为length。特别要留意的是i2c结点中定义的 #address-cells = <1>;和#size-cells = <0>;又作用到了I2C总线上连接的RTC，它的address字段为0x58，是设备的I2C地址。
        # root结点的子结点描述的是CPU的视图，因此root子结点的address区域就直接位于CPU的memory区域。但是，经过总线桥后的address往往需要经过转换才能对应的CPU的memory映射。
        # external-bus的ranges属性定义了经过external-bus桥后的地址范围如何映射到CPU的memory区域。
        # 
    # ranges = <0 0  0x10100000   0x10000     // Chipselect 1, Ethernet  
    #           1 0  0x10160000   0x10000     // Chipselect 2, i2c controller  
    #           2 0  0x30000000   0x1000000>; // Chipselect 3, NOR Flash  
        # ranges是地址转换表，其中的每个项目是一个子地址、父地址以及在子地址空间的大小的映射。
        # 映射表中的子地址、父地址分别采用子地址空间的#address-cells和父地址空间的#address-cells大小。
        # 对于本例而言，子地址空间的#address-cells为2，父地址空间的#address-cells值为1，
        # 因此0 0  0x10100000   0x10000的前2个cell为external-bus后片选0上偏移0，
        # 第3个cell表示external-bus后片选0上偏移0的地址空间被映射到CPU的0x10100000位置，
        # 第4个cell表示映射的大小为0x10000。
  # #address-cells 
  # #size-cells 
  cpus {  
        #address-cells = <1>;  
        #size-cells = <0>;  
        cpu@0 {  
            compatible = "arm,cortex-a9";  
            reg = <0>;  
        };  
        cpu@1 {  
            compatible = "arm,cortex-a9";  
            reg = <1>;  
        };  
    };  
  # 2个串口（分别位于0x101F1000 和 0x101F2000）
    serial@101f0000 {  
        compatible = "arm,pl011";  
        reg = <0x101f0000 0x1000 >;  
        interrupts = < 1 0 >;  
    };  
  
    serial@101f2000 {  
        compatible = "arm,pl011";  
        reg = <0x101f2000 0x1000 >;  
        interrupts = < 2 0 >;  
    };  
  # GPIO控制器（位于0x101F3000）
    gpio@101f3000 {  
        compatible = "arm,pl061";  
        reg = <0x101f3000 0x1000  
               0x101f4000 0x0010>;  
        interrupts = < 3 0 >;  
    };  
 # Device Tree中还可以中断连接信息，对于中断控制器而言，它提供如下属性：
 # interrupt-controller – 这个属性为空，中断控制器应该加上此属性表明自己的身份；
 # #interrupt-cells – 与#address-cells 和 #size-cells相似，它表明连接此中断控制器的设备的interrupts属性的cell大小。
 # 
 # 在整个Device Tree中，与中断相关的属性还包括：
 # interrupt-parent – 设备结点透过它来指定它所依附的中断控制器的phandle
 # 当结点没有指定interrupt-parent 时，则从父级结点继承。
 # 对于本例而言，root结点指定了interrupt-parent = <&intc>;其对应于intc: interrupt-controller@10140000，
 # 而root结点的子结点并未指定interrupt-parent，因此它们都继承了intc，即位于0x10140000的中断控制器。
 #
 # interrupts – 用到了中断的设备结点透过它指定中断号、触发方法等，具体这个属性含有多少个cell，
 # 由它依附的中断控制器结点的#interrupt-cells属性决定。
 # 而具体每个cell又是什么含义，一般由驱动的实现决定，而且也会在Device Tree的binding文档中说明。
 
 # 譬如，对于ARM GIC中断控制器而言，#interrupt-cells为3，它3个cell的具体含义Documentation/devicetree/bindings/arm/gic.txt就有如下文字说明：
 
 # 值得注意的是，一个设备还可能用到多个中断号。对于ARM GIC而言，若某设备使用了SPI的168、169号2个中断，而言都是高电平触发，则该设备结点的interrupts属性可定义为：interrupts = <0 168 4>, <0 169 4>;
 # 除了中断以外，在ARM Linux中clock、GPIO、pinmux都可以透过.dts中的结点和属性进行描述。
 # 中断控制器（位于0x10140000）
    intc: interrupt-controller@10140000 {  
        compatible = "arm,pl190";  
        reg = <0x10140000 0x1000 >;  
        interrupt-controller;  
        #interrupt-cells = <2>;  
    };  
  # SPI控制器（位于0x10115000）
    spi@10115000 {  
        compatible = "arm,pl022";  
        reg = <0x10115000 0x1000 >;  
        interrupts = < 4 0 >;  
    };  
  # 一个external bus桥
    external-bus {  
        #address-cells = <2>  
        #size-cells = <1>;  
        # 
        # address字段长度为0，开始的第1个cell（0、1、2）是对应的片选，
        # 第2个cell（0，0，0）是相对该片选的基地址，
        # 第3个cell（0x1000、0x1000、0x4000000）为length。
        ranges = <0 0  0x10100000   0x10000     // Chipselect 1, Ethernet  
                  1 0  0x10160000   0x10000     // Chipselect 2, i2c controller  
                  2 0  0x30000000   0x1000000>; // Chipselect 3, NOR Flash  
  # SMC SMC91111 Ethernet（位于0x10100000）
        ethernet@0,0 {  
            compatible = "smc,smc91c111";  
            reg = <0 0 0x1000>;  
            interrupts = < 5 2 >;  
        };  
  # I2C控制器（位于0x10160000）
        i2c@1,0 {  
            compatible = "acme,a1234-i2c-bus";  
            #address-cells = <1>;  
            #size-cells = <0>;  
            reg = <1 0 0x1000>;  
            interrupts = < 6 2 >; 
  # 连接的I2C控制器所对应的I2C总线上又连接了Maxim DS1338实时钟（I2C地址为0x58）            
         rtc@58 {  
                compatible = "maxim,ds1338";  
                reg = <58>;  
                interrupts = < 7 3 >;  
            };  
        };  
  # 64MB NOR Flash（位于0x30000000）
        flash@2,0 {  
            compatible = "samsung,k8f1315ebm", "cfi-flash";  
            reg = <2 0 0x4000000>;  
        };  
    };  
};

}

desc(DTC:device tree compiler){
将.dts编译为.dtb的工具。DTC的源代码位于内核的scripts/dtc目录，在Linux内核使能了Device Tree的情况下，编译内核的时候主机工具dtc会被编译出来，对应scripts/dtc/Makefile中的“hostprogs-y := dtc”这一hostprogs编译target。
在Linux内核的arch/arm/boot/dts/Makefile中，描述了当某种SoC被选中后，哪些.dtb文件会被编译出来，如与VEXPRESS对应的.dtb包括：

dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \  
            vexpress-v2p-ca9.dtb \  
            vexpress-v2p-ca15-tc1.dtb \  
            vexpress-v2p-ca15_a7.dtb \  
            xenvm-4.2.dtb  

在Linux下，我们可以单独编译Device Tree文件。当我们在Linux内核下运行make dtbs时，
若我们之前选择了ARCH_VEXPRESS，上述.dtb都会由对应的.dts编译出来。因为arch/arm/Makefile
中含有一个dtbs编译target项目。
}
desc(dtb:Device Tree Blob){
    .dtb是.dts被DTC编译后的二进制格式的Device Tree描述，可由Linux内核解析。通常在我们为电路板制作
NAND、SD启动image时，会为.dtb文件单独留下一个很小的区域以存放之，之后bootloader在引导kernel的过程中，
会先读取该.dtb到内存。
}
desc(Binding){
    对于Device Tree中的结点和属性具体是如何来描述设备的硬件细节的，一般需要文档来进行讲解，文档的后缀名一般为.txt。
这些文档位于内核的Documentation/devicetree/bindings目录，其下又分为很多子目录。
}
desc(Bootloader){
Uboot mainline 从 v1.1.3开始支持Device Tree，其对ARM的支持则是和ARM内核支持Device Tree同期完成。
为了使能Device Tree，需要编译Uboot的时候在config文件中加入
#define CONFIG_OF_LIBFDT 
在Uboot中，可以从NAND、SD或者TFTP等任意介质将.dtb读入内存，假设.dtb放入的内存地址为0x71000000，之后可在Uboot运行命令fdt addr命令设置.dtb的地址，如：
U-Boot> fdt addr 0x71000000
fdt的其他命令就变地可以使用，如fdt resize、fdt print等。
对于ARM来讲，可以透过bootz kernel_addr initrd_address dtb_address的命令来启动内核，即dtb_address作为bootz或者bootm的最后一次参数，第一个参数为内核映像的地址，第二个参数为initrd的地址，若不存在initrd，可以用 -代替。
}
desc(Device Tree引发的BSP和驱动变更){
有了Device Tree后，大量的板级信息都不再需要，譬如过去经常在arch/arm/plat-xxx和arch/arm/mach-xxx实施的如下事情：

1. 注册platform_device，绑定resource，即内存、IRQ等板级信息。
透过Device Tree后，形如
static struct resource xxx_resources[] = {   # .dts中设备结点的reg、interrupts属性
       [0] = {  
               .start  = …,  
               .end    = …,  
               .flags  = IORESOURCE_MEM,  
       },  
       [1] = {  
               .start  = …,  
               .end    = …,  
               .flags  = IORESOURCE_IRQ,  
        },  
};  
 
static struct platform_device xxx_device = {  
        .name           = "xxx",  
        .id             = -1,  
        .dev            = {  
                                .platform_data          = &xxx_data,  
        },  
        .resource       = xxx_resources,  
        .num_resources  = ARRAY_SIZE(xxx_resources),  
};
之类的platform_device代码都不再需要，其中platform_device会由kernel自动展开。
而这些resource实际来源于.dts中设备结点的reg、interrupts属性。
    典型地，大多数总线都与"simple_bus"兼容，而在SoC对应的machine的.init_machine成员函数中，
调用of_platform_bus_probe(NULL, xxx_of_bus_ids, NULL);即可自动展开所有的platform_device。
譬如，假设我们有个XXX SoC，则可在arch/arm/mach-xxx/的板文件中透过如下方式展开.dts中的设备结点对应的platform_device：

static struct of_device_id xxx_of_bus_ids[] __initdata = {  
        { .compatible = "simple-bus", },  
        {},  
};  
 
void __init xxx_mach_init(void)  
{  
        of_platform_bus_probe(NULL, xxx_of_bus_ids, NULL);  
}  
 
#ifdef CONFIG_ARCH_XXX  
 
DT_MACHINE_START(XXX_DT, "Generic XXX (Flattened Device Tree)")  
        …  
        .init_machine   = xxx_mach_init,  
        …  
MACHINE_END  
#endif
}
desc(注册i2c_board_info){
2.    注册i2c_board_info，指定IRQ等板级信息。
形如
static struct i2c_board_info __initdata afeb9260_i2c_devices[] = {  
        {  
                I2C_BOARD_INFO("tlv320aic23", 0x1a),  
        }, {  
                I2C_BOARD_INFO("fm3130", 0x68),  
        }, {  
                I2C_BOARD_INFO("24c64", 0x50),  
        },  
};  

之类的i2c_board_info代码，目前不再需要出现，现在只需要把tlv320aic23、fm3130、
24c64这些设备结点填充作为相应的I2C controller结点的子结点即可，类似于前面的
i2c@1,0 {  
          compatible = "acme,a1234-i2c-bus";  
          …  
          rtc@58 {  
              compatible = "maxim,ds1338";  
              reg = <58>;  
              interrupts = < 7 3 >;  
          };  
      };  

Device Tree中的I2C client会透过I2C host驱动的probe()函数中调用of_i2c_register_devices(&i2c_dev->adapter);
被自动展开。
}
desc(注册spi_board_info){
3.    注册spi_board_info，指定IRQ等板级信息。
形如
static struct spi_board_info afeb9260_spi_devices[] = {  
        {       /* DataFlash chip */  
                .modalias       = "mtd_dataflash",  
                .chip_select    = 1,  
                .max_speed_hz   = 15 * 1000 * 1000,  
                .bus_num        = 0,  
        },  
};  

之类的spi_board_info代码，目前不再需要出现，与I2C类似，现在只需要把mtd_dataflash之类的结点，
作为SPI控制器的子结点即可，SPI host驱动的probe函数透过spi_register_master()注册master的时候，
会自动展开依附于它的slave。
}
desc(多个针对不同电路板的machine，以及相关的callback){
过去，ARM Linux针对不同的电路板会建立由MACHINE_START和MACHINE_END包围起来的针对这个machine的一系列callback，
譬如：

MACHINE_START(VEXPRESS, "ARM-Versatile Express")  
        .atag_offset    = 0x100,  
        .smp            = smp_ops(vexpress_smp_ops),  
        .map_io         = v2m_map_io,  
        .init_early     = v2m_init_early,  
        .init_irq       = v2m_init_irq,  
        .timer          = &v2m_timer,  
        .handle_irq     = gic_handle_irq,  
        .init_machine   = v2m_init,  
        .restart        = vexpress_restart,  
MACHINE_END  

    这些不同的machine会有不同的MACHINE ID，Uboot在启动Linux内核时会将MACHINE ID存放在r1寄存器，
Linux启动时会匹配Bootloader传递的MACHINE ID和MACHINE_START声明的MACHINE ID，然后执行相应
machine的一系列初始化函数。


    引入Device Tree之后，MACHINE_START变更为DT_MACHINE_START，其中含有一个.dt_compat成员，
用于表明相关的machine与.dts中root结点的compatible属性兼容关系。如果Bootloader传递给内核的
Device Tree中root结点的compatible属性出现在某machine的.dt_compat表中，相关的machine就与
对应的Device Tree匹配，从而引发这一machine的一系列初始化函数被执行。

static const char * const v2m_dt_match[] __initconst = {  
        "arm,vexpress",  
        "xen,xenvm",  
        NULL,  
};  
DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")  
        .dt_compat      = v2m_dt_match,  
        .smp            = smp_ops(vexpress_smp_ops),  
        .map_io         = v2m_dt_map_io,  
        .init_early     = v2m_dt_init_early,  
        .init_irq       = v2m_dt_init_irq,  
        .timer          = &v2m_dt_timer,  
        .init_machine   = v2m_dt_init,  
        .handle_irq     = gic_handle_irq,  
        .restart        = vexpress_restart,  
MACHINE_END

    Linux倡导针对多个SoC、多个电路板的通用DT machine，即一个DT machine的.dt_compat表含多个电路板.dts文件
的root结点compatible属性字符串。之后，如果的电路板的初始化序列不一样，可以透过int of_machine_is_compatible
(const char *compat) API判断具体的电路板是什么。

譬如arch/arm/mach-exynos/mach-exynos5-dt.c的EXYNOS5_DT machine同时兼容"samsung,exynos5250"和"samsung,exynos5440"：

static char const *exynos5_dt_compat[] __initdata = {  
        "samsung,exynos5250",  
        "samsung,exynos5440",  
        NULL  
};  
 
DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")  
        /* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */  
        .init_irq       = exynos5_init_irq,  
        .smp            = smp_ops(exynos_smp_ops),  
        .map_io         = exynos5_dt_map_io,  
        .handle_irq     = gic_handle_irq,  
        .init_machine   = exynos5_dt_machine_init,  
        .init_late      = exynos_init_late,  
        .timer          = &exynos4_timer,  
        .dt_compat      = exynos5_dt_compat,  
        .restart        = exynos5_restart,  
        .reserve        = exynos5_reserve,  
MACHINE_END  

它的.init_machine成员函数就针对不同的machine进行了不同的分支处理：
static void __init exynos5_dt_machine_init(void)  
{  
        …  
 
        if (of_machine_is_compatible("samsung,exynos5250"))  
                of_platform_populate(NULL, of_default_bus_match_table,  
                                     exynos5250_auxdata_lookup, NULL);  
        else if (of_machine_is_compatible("samsung,exynos5440"))  
                of_platform_populate(NULL, of_default_bus_match_table,  
                                     exynos5440_auxdata_lookup, NULL);  
}  

    使用Device Tree后，驱动需要与.dts中描述的设备结点进行匹配，从而引发驱动的probe()函数执行。
对于platform_driver而言，需要添加一个OF匹配表，如前文的.dts文件的"acme,a1234-i2c-bus"兼容I2C
控制器结点的OF匹配表可以是：
static const struct of_device_id a1234_i2c_of_match[] = {  
        { .compatible = "acme,a1234-i2c-bus ", },  
        {},  
};  
MODULE_DEVICE_TABLE(of, a1234_i2c_of_match);  
 
static struct platform_driver i2c_a1234_driver = {  
        .driver = {  
                .name = "a1234-i2c-bus ",  
                .owner = THIS_MODULE,  
                .of_match_table = a1234_i2c_of_match,  
        },  
        .probe = i2c_a1234_probe,  
        .remove = i2c_a1234_remove,  
};  
module_platform_driver(i2c_a1234_driver);  

    对于I2C和SPI从设备而言，同样也可以透过of_match_table添加匹配的.dts中的相关结点的compatible属性，
如sound/soc/codecs/wm8753.c中的：
static const struct of_device_id wm8753_of_match[] = {  
        { .compatible = "wlf,wm8753", },  
        { }  
};  
MODULE_DEVICE_TABLE(of, wm8753_of_match);  
static struct spi_driver wm8753_spi_driver = {  
        .driver = {  
                .name   = "wm8753",  
                .owner  = THIS_MODULE,  
                .of_match_table = wm8753_of_match,  
        },  
        .probe          = wm8753_spi_probe,  
        .remove         = wm8753_spi_remove,  
};  
static struct i2c_driver wm8753_i2c_driver = {  
        .driver = {  
                .name = "wm8753",  
                .owner = THIS_MODULE,  
                .of_match_table = wm8753_of_match,  
        },  
        .probe =    wm8753_i2c_probe,  
        .remove =   wm8753_i2c_remove,  
        .id_table = wm8753_i2c_id,  
};
    不过这边有一点需要提醒的是，I2C和SPI外设驱动和Device Tree中设备结点的compatible 属性还有一种弱式匹配方法，
就是别名匹配。compatible 属性的组织形式为<manufacturer>,<model>，别名其实就是去掉compatible 属性中逗号前的
manufacturer前缀。关于这一点，可查看drivers/spi/spi.c的源代码，函数spi_match_device()暴露了更多的细节，
如果别名出现在设备spi_driver的id_table里面，或者别名与spi_driver的name字段相同，SPI设备和驱动都可以匹配上：
static int spi_match_device(struct device *dev, struct device_driver *drv)
static const struct spi_device_id *spi_match_id(const struct spi_device_id *id,  
                                                 const struct spi_device *sdev)   
}
desc(常用OF API){
    在Linux的BSP和驱动代码中，还经常会使用到Linux中一组Device Tree的API,这些API通常被冠以of_前缀，
它们的实现代码位于内核的drivers/of目录。这些常用的API包括：
    int of_device_is_compatible(const struct device_node *device,const char *compat);
    判断设备结点的compatible 属性是否包含compat指定的字符串。当一个驱动支持2个或多个设备的时候，
这些不同.dts文件中设备的compatible 属性都会进入驱动 OF匹配表。因此驱动可以透过Bootloader传递给
内核的Device Tree中的真正结点的compatible 属性以确定究竟是哪一种设备，从而根据不同的设备类型进行
不同的处理。如drivers/pinctrl/pinctrl-sirf.c即兼容于"sirf,prima2-pinctrl"，又兼容于"sirf,prima2-pinctrl"，
在驱动中就有相应分支处理：
if (of_device_is_compatible(np, "sirf,marco-pinctrl"))  
     is_marco = 1;
     
struct device_node *of_find_compatible_node(struct device_node *from,
         const char *type, const char *compatible);
    根据compatible属性，获得设备结点。遍历Device Tree中所有的设备结点，看看哪个结点的类型、compatible属性
与本函数的输入参数匹配，大多数情况下，from、type为NULL。

int of_property_read_u8_array(const struct device_node *np,
                     const char *propname, u8 *out_values, size_t sz);
int of_property_read_u16_array(const struct device_node *np,
                      const char *propname, u16 *out_values, size_t sz);
int of_property_read_u32_array(const struct device_node *np,
                      const char *propname, u32 *out_values, size_t sz);
int of_property_read_u64(const struct device_node *np, const char
                      *propname, u64 *out_value);
    读取设备结点np的属性名为propname，类型为8、16、32、64位整型数组的属性。对于32位处理器来讲，最常用的是
of_property_read_u32_array()。如在arch/arm/mm/cache-l2x0.c中，透过如下语句读取L2 cache的"arm,data-latency"属性：
of_property_read_u32_array(np, "arm,data-latency",  
                            data, ARRAY_SIZE(data));
在arch/arm/boot/dts/vexpress-v2p-ca9.dts中，含有"arm,data-latency"属性的L2 cache结点如下：
L2: cache-controller@1e00a000 {  
        compatible = "arm,pl310-cache";  
        reg = <0x1e00a000 0x1000>;  
        interrupts = <0 43 4>;  
        cache-level = <2>;  
        arm,data-latency = <1 1 1>;  
        arm,tag-latency = <1 1 1>;  
}  


    有些情况下，整形属性的长度可能为1，于是内核为了方便调用者，又在上述API的基础上封装出了更加简单的
读单一整形属性的API，它们为int of_property_read_u8()、of_property_read_u16()等，实现于include/linux/of.h：
static inline int of_property_read_u8(const struct device_node *np,  
                                       const char *propname,  
                                       u8 *out_value)  
{  
        return of_property_read_u8_array(np, propname, out_value, 1);  
}  
 
static inline int of_property_read_u16(const struct device_node *np,  
                                       const char *propname,  
                                       u16 *out_value)  
{  
        return of_property_read_u16_array(np, propname, out_value, 1);  
}  
 
static inline int of_property_read_u32(const struct device_node *np,  
                                       const char *propname,  
                                       u32 *out_value)  
{  
        return of_property_read_u32_array(np, propname, out_value, 1);  
}  
int of_property_read_string(struct device_node *np, const char
    *propname, const char **out_string);
int of_property_read_string_index(struct device_node *np, const char
    *propname, int index, const char **output);

    前者读取字符串属性，后者读取字符串数组属性中的第index个字符串。如drivers/clk/clk.c中的
of_clk_get_parent_name()透过of_property_read_string_index()遍历clkspec结点的所有"clock-output-names"
字符串数组属性。
 const char *of_clk_get_parent_name(struct device_node *np, int index)  
 {  
         struct of_phandle_args clkspec;  
         const char *clk_name;  
         int rc;  
  
         if (index < 0)  
                 return NULL;  
  
         rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,  
                                         &clkspec);  
         if (rc)  
                 return NULL;  
  
         if (of_property_read_string_index(clkspec.np, "clock-output-names",  
                                   clkspec.args_count ? clkspec.args[0] : 0,  
                                           &clk_name) < 0)  
                 clk_name = clkspec.np->name;  
  
         of_node_put(clkspec.np);  
         return clk_name;  
 }  
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);  

static inline bool of_property_read_bool(const struct device_node *np,
                                         const char *propname);
如果设备结点np含有propname属性，则返回true，否则返回false。一般用于检查空属性是否存在。

void __iomem *of_iomap(struct device_node *node, int index);
    通过设备结点直接进行设备内存区间的 ioremap()，index是内存段的索引。若设备结点的reg属性有多段，
可通过index标示要ioremap的是哪一段，只有1段的情况，index为0。采用Device Tree后，大量的设备驱动通过
of_iomap()进行映射，而不再通过传统的ioremap。

unsigned int irq_of_parse_and_map(struct device_node *dev, int index);
    透过Device Tree或者设备的中断号，实际上是从.dts中的interrupts属性解析出中断号。若设备使用了多个中断，
index指定中断的索引号。
}