http://www.reactivated.net/writing_udev_rules.html

udevadm()
{
udevadm 中文手册
译者：金步国
udevadm — udev 管理工具
udevadm [--debug] [--version] [--help]
udevadm info options
udevadm trigger [options]
udevadm settle [options]
udevadm control command
udevadm monitor [options]
udevadm test [options] devpath
udevadm test-builtin [options] command devpath
描述
udevadm 可用于： 控制 systemd-udevd.service(8) 服务、 请求内核事件、管理事件队列、进行简单的调试。
选项
--debug
    在标准错误(STDERR)上显示调试信息
--version
    显示版本信息
-h, --help
    显示帮助信息
udevadm info [options] [devpath|file]
从udev数据库中提取设备信息。 此外，还可以从sysfs中提取设备的属性， 以帮助创建与此设备匹配的udev规则。
-q, --query=TYPE
    提取特定类型的设备信息。 必须和 --path 或 --name 选项连用。 TYPE 可以是下列值之一： name, symlink, path, property, all(默认值)
-p, --path=DEVPATH
    该设备在 /sys 文件系统下的路径(例如 [/sys]/class/block/sda)。 因为 udev 能够猜测参数的意义， 所以通常将 --devpath=/class/block/sda 直接简写为 /sys/class/block/sda
-n, --name=FILE
    设备节点或软连接的名称(例如 [/dev]/sda)。 因为 udev 能够猜测参数的意义， 所以通常将 --name=sda 直接简写为 /dev/sda
-r, --root
    以绝对路径显示 --query=name 与 --query=symlink 的查询结果
-a, --attribute-walk
    按照udev规则的格式，显示所有可用于匹配该设备的sysfs属性： 从该设备自身开始，沿着设备树向上回溯(一直到树根)，显示沿途每个设备的sysfs属性。 
-x, --export
    以 key=value 的格式输出此设备的属性
-P, --export-prefix=NAME
    在输出的键名前添加一个前缀。
-d, --device-id-of-file=FILE
    显示 FILE 文件所在底层设备的主/次设备号。 
-e, --export-db
    导出udev数据库的全部内容
-c, --cleanup-db
    清除udev数据库
--version
    显示版本信息
-h, --help
    显示帮助信息

[devpath|file] 可用作 --path|--name 选项的简写替代，但是必须使用 /dev 或 /sys 开头的绝对路径。
udevadm trigger [options] [devpath|file...]
强制内核触发设备事件，主要用于重放内核初始化过程中的冷插(coldplug)设备事件。
-v, --verbose
    显示被触发的设备列表
-n, --dry-run
    并不真正触发设备事件
-t, --type=TYPE
    仅触发特定类型的设备，TYPE 可以是下列值之一： devices(默认值), subsystems
-c, --action=ACTION
    指定触发哪种类型的设备事件，ACTION 可以是下列值之一： add, remove, change(默认值)
-s, --subsystem-match=SUBSYSTEM
    仅触发属于 SUBSYSTEM 子系统的设备事件。 可以多次使用此选项， 并且可以在 SUBSYSTEM 中使用shell风格的通配符。
-S, --subsystem-nomatch=SUBSYSTEM
    不触发属于 SUBSYSTEM 子系统的设备事件。 可以多次使用此选项，并且可以在 SUBSYSTEM 中使用shell风格的通配符。
-a, --attr-match=ATTRIBUTE=VALUE
    仅触发那些在设备的sysfs目录中存在 ATTRIBUTE 文件的设备事件。 如果同时还指定了"=VALUE"， 那么表示仅触发那些 ATTRIBUTE 文件的内容等于 VALUE 的设备事件。 可以多次使用此选项， 并且可以在 VALUE 中使用shell风格的通配符。 
-A, --attr-nomatch=ATTRIBUTE=VALUE
    不触发那些在设备的sysfs目录中存在 ATTRIBUTE 文件的设备事件。 如果同时还指定了"=VALUE"， 那么表示不触发那些 ATTRIBUTE 文件的内容等于 VALUE 的设备事件。 可以多次使用此选项， 并且可以在 VALUE 中使用shell风格的通配符。 
-p, --property-match=PROPERTY=VALUE
    仅触发那些设备的 PROPERTY 属性值等于 VALUE 的设备事件。 可以多次使用此选项， 并且可以在 VALUE 中使用shell风格的通配符。
-g, --tag-match=PROPERTY
    仅触发带有 PROPERTY 标签的设备事件。 可以多次使用此选项。
-y, --sysname-match=PATH
    仅触发设备的路径(也就是该设备在sysfs文件系统下的路径)为 PATH 的设备事件。 因为udev能够猜测参数的意义，所以通常将 --sysname-match=/class/block/sda 直接简写为 /sys/class/block/sda 。 [译者注]实测仅简写有效。
--name-match=NAME
    仅触发设备的节点名称为 NAME 的设备事件。 因为udev能够猜测参数的意义， 所以通常将 --name-match=sda 直接简写为 /dev/sda 。
-b, --parent-match=SYSPATH
    触发给定设备的所有子设备事件。 SYSPATH 是父设备的路径(也就是父设备在sysfs文件系统下的路径)。
-h, --help
    显示帮助信息
[devpath|file...] 可用作 --sysname-match|--name-match 选项的简写替代，但是必须使用 /dev 或 /sys 开头的绝对路径。
udevadm settle [options]

监视udev事件队列，并且在所有事件全部处理完成之后退出。
-t, --timeout=SECONDS
    最多允许花多少秒等候事件队列清空。 默认值是120秒。 设为 0 表示仅检查事件队列是否为空， 并且立即返回。
-E, --exit-if-exists=FILE
    如果 FILE 文件存在，则停止等待。
-h, --help

    显示帮助信息
udevadm control command
控制udev守护进程(systemd-udevd)的内部状态。
-e, --exit
    向 systemd-udevd 发送"退出"信号并等待其退出。
-l, --log-priority=value
    设置 systemd-udevd.service(8) 的内部日志等级。 可以用数字或文本表示： remerg(0), alert(1), crit(2), err(3), warning(4), notice(5), info(6), debug(7)
-s, --stop-exec-queue
    向 systemd-udevd 发送"禁止处理事件"信号， 这样所有新发生的事件都将进入等候队列。
-S, --start-exec-queue
    向 systemd-udevd 发送"开始处理事件"信号，也就是开始处理事件队列中尚未处理的事件。
-R, --reload
    向 systemd-udevd 发送"重新加载"信号，也就是重新加载udev规则与各种数据库(包括内核模块索引)。 注意，重新加载之后并不影响已经存在的设备， 但是新的配置将会应用于所有将来发生的新设备事件。
-p, --property=KEY=value
    为所有将来发生的新设备事件统一设置一个全局的 KEY 属性，并将其值设为 value
-m, --children-max=value
    设置最多允许 systemd-udevd 同时处理多少个设备事件。 
--timeout=seconds
    设置等候 systemd-udevd 应答的最大秒数
-h, --help
    显示帮助信息
udevadm monitor [options]
监视内核发出的设备事件(以"KERNEL"标记)， 以及udev在处理完udev规则之后发出的事件(以"UDEV"标记)，并在控制台上输出事件的设备路径(devpath)。 可用于分析udev处理设备事件所花的时间(比较"KERNEL"与"UDEV"的时间戳)。
-k, --kernel
    仅显示"KERNEL"事件
-u, --udev
    仅显示"UDEV"事件
-p, --property
    同时还显示事件的各属性
-s, --subsystem-match=subsystem[/devtype]
    根据 subsystem[/devtype] 对事件进行过滤：仅显示与"子系统[/设备类型]"匹配的"UDEV"事件。
-t, --tag-match=string
    根据设备标签对事件进行过滤：仅显示与"标签"匹配的"UDEV"事件。
-h, --help
    显示帮助信息
udevadm test [options] [devpath]
模拟一个设备事件，并输出调试信息。
-a, --action=ACTION
    指定模拟哪种类型的设备事件，ACTION 可以是下列值之一：add(默认值), remove, change
-N, --resolve-names=early|late|never
    指定 udevadm 何时解析用户与组的名称： early(默认值) 表示在规则的解析阶段； late 表示在每个事件发生的时候； never 表示从不解析， 所有设备的属主与属组都是 root 。
-h, --help
    显示帮助信息
udevadm test-builtin [options] [command] [devpath]
针对 DEVPATH设备 运行一个内置的 COMMAND 命令， 并输出调试信息。
-h, --help
    显示帮助信息
}

udev(config)
{
udev 中文手册
译者：金步国

udev — 动态设备管理
描述
udev 能够处理设备事件、管理设备文件的权限、 在 /dev 目录中创建额外的符号链接、重命名网络接口，等等。 内核通常仅根据设备被发现的先后顺序给设备文件命名， 因此很难在设备文件与物理硬件之间建立稳定的对应关系。 而根据设备的物理属性或配置特征创建有意义的符号链接名称或网络接口名称， 就可以在物理设备与设备文件名称之间建立稳定的对应关系。

udev守护进程(systemd-udevd.service(8)) 直接从内核接收设备的插入、拔出、改变状态等事件， 并根据这些事件的各种属性， 到规则库中进行匹配，以确定触发事件的设备。 被匹配成功的规则有可能提供额外的设备信息，这些信息可能会被记录到udev数据库中， 也可能会被用于创建符号链接。

udev处理的所有设备信息都存储在udev数据库中， 并且会发送给可能的设备事件的订阅者。 可以通过 libudev 库访问udev数据库以及设备事件源。
规则文件

规则文件分别位于： 系统规则目录(/usr/lib/udev/rules.d)、 运行时规则目录(/run/udev/rules.d)、 本机规则目录(/etc/udev/rules.d)。 所有的规则文件(无论位于哪个目录中)，统一按照文件名的字典顺序处理。 对于不同目录下的同名规则文件，仅以优先级最高的目录中的那一个为准。 具体说来就是： /etc/ 的优先级最高、 /run/ 的优先级居中、 /usr/lib/ 的优先级最低。 如果系统管理员想要屏蔽 /usr/lib/ 目录中的某个规则文件， 那么最佳做法是在 /etc/ 目录中创建一个指向 /dev/null 的同名符号链接， 即可彻底屏蔽 /usr/lib/ 目录中的同名文件。 注意，规则文件必须以 .rules 作为后缀名，否则将被忽略。

规则文件中以 "#" 开头的行以及空行将被忽略， 其他不以 "#" 开头的非空行，每行必须至少包含一个"键-值"对。 "键"有两种类型：匹配与赋值。 如果某条规则的所有匹配键的值都匹配成功，那么就表示此条规则匹配成功， 也就是此条规则中的所有赋值键都会被赋予指定的值。

一条匹配成功的规则可以： 重命名网络接口、为某个设备文件添加一个软连接、运行一个指定的程序， 等等。

每条规则都是由一系列逗号分隔的"键-值"对组成。 根据操作符的不同，每个键都对应着一个唯一的操作。 可用的操作符如下：

"=="

    (匹配)"等于"
"!="

    (匹配)"不等于"
"="

    (赋值)为键赋予指定的值。 此键之前的值(可能是个列表)将被丢弃。
"+="

    (赋值)在键的现有值列表中增加此处指定的值。
"-="

    (赋值)在键的现有值列表中删除此处指定的值。
":="

    (赋值)为键赋予指定的值，并视为最终值，也就是禁止被继续修改。

下面的"键"可用于匹配。注意，其中的某些键还可以针对父设备进行匹配，而不仅仅是生成设备事件的那个设备自身。 如果在同一条规则中有多个键可以针对父设备进行匹配，那么仅在所有这些键都同时成功匹配同一个父设备时，才算匹配成功。 [译者注]Linux通过sysfs以树状结构展示设备，例如硬盘是SCSI设备的孩子、SCSI设备又是ATA控制器的孩子、 ATA控制器又是PCI总线的孩子。而你经常需要从父设备那里引用信息， 比如硬盘的序列号就是通过父设备(SCSI设备)展现的。

ACTION

    匹配事件的动作。例如"add"表示插入一个设备。
DEVPATH

    匹配设备的路径(也就是该设备在sysfs文件系统下的相对路径)。[举例] /dev/sda1 对应的 devpath 是 /block/sda/sda1 (一般对应着 /sys/block/sda/sda1 目录)。
KERNEL

    匹配设备的内核名称。"内核名称"是指设备在sysfs里的名称，也就是默认的设备文件名称，例如"sda"。
NAME

    匹配网络接口的名称。 仅在先前的规则中已将 NAME 键赋值的前提下，才可将此键用于匹配。
SYMLINK

    匹配指向此设备节点的软连接的名称。 仅在先前的规则中已将 SYMLINK 键赋值的前提下，才可将此键用于匹配。 可能有多个软连接指向同一个设备节点，但只需其中的一个匹配成功即可。 
SUBSYSTEM

    匹配设备所属的子系统。例如"sound"或"net"
DRIVER

    匹配设备的驱动程序名称。 仅在设备事件发生时，此设备确实正好绑定着一个驱动程序情况下，此键才会被设置。
ATTR{文件}, SYSCTL{内核参数}

    匹配设备在sysfs中的属性值。属性值中的尾部空白会被忽略，除非指定的值自身就包含尾部空白。 [译者注]大括号中的"文件"是指设备路径(devpath)下的文件。 例如，对于 /dev/sda1 来说，ATTR{size} 的含义其实是指 /sys/block/sda/sda1/size 文件的内容。

    匹配"内核参数"的值。[译者注]所谓"内核参数"其实是指 /proc/sys/ 中的"内核参数"。 例如，可以用 SYSCTL{kernel/hostname} 匹配 /proc/sys/kernel/hostname 的值。
KERNELS

    匹配设备及其所有父设备的内核名称
SUBSYSTEMS

    匹配设备及其所有父设备所属的子系统
DRIVERS

    匹配设备及其所有父设备的驱动程序名称
ATTRS{文件}

    匹配设备及其所有父设备在sysfs中的属性值。 如果指定了多个 ATTRS 匹配， 那么必须在同一个设备上全部匹配成功，才算最终匹配成功。 属性值中的尾部空白会被忽略，除非指定的值自身就包含尾部空白。
TAGS

    匹配设备及其所有父设备的标签。
ENV{设备属性}

    匹配设备的属性。例如 "DEVTYPE", "ID_PATH", "SYSTEMD_WANTS" 等等。[提示]可以通过 udevadm info --query=property /dev/sda 命令查看 /dev/sda 的所有属性。
TAG

    匹配设备的标签。
TEST{八进制模式掩码}

    检测指定的文件是否存在。 如果有必要，还可以额外指定一个八进制的访问模式掩码。
PROGRAM

    执行指定的程序并检查返回值， 如果返回值为零，则匹配成功，否则匹配失败。 设备的属性会转化为该程序的环境变量供其使用。 同时该程序的标准输出会被自动保存在 RESULT 键中。

    注意，仅可用于执行时间很短的前台程序。 参见 RUN
RESULT

    匹配最近一次 PROGRAM 程序的输出字符串， 必须位于 PROGRAM 之后(但可出现在同一条规则中)。 

可以在用于匹配的"值"中使用shell风格的通配符， 具体说来就是：

"*"

    匹配任意数量的字符(包括零个)
"?"

    匹配单独一个字符
"[]"

    匹配中括号内的任意一个字符。 例如 "tty[SR]" 可以匹配 "ttyS" 或 "ttyR" 。 还可以使用 "-" 符号表示一个区间。 例如 "[0-9]" 可以匹配任意数字。 如果在左括号 "[" 后紧接着一个 "!" 则表示匹配非括号内的字符。
"|"

    用于分隔两个可相互替代的匹配模式(也就是"或"的意思)。 例如 "abc|x*" 的意思是匹配 "abc" 或 "x*"

下面的键可用于赋值：

NAME

    设置网络接口的名称。参见 systemd.link(5) 以了解设置网络接口名称的高级机制。 实际上，udev 并不能直接修改网络接口的设备节点名称， 只是额外创建了一个符号链接而已。
SYMLINK

    设置指向此设备节点的软连接名称。

    软连接的名字中仅允许使用下列字符： "0-9A-Za-z#+-.:=@_/" 、有效的UTF-8字符、 "\x00" 风格的十六进制编码(实际的文件名并不转码)。 其他字符将被替换为 "_" 字符。

    只需在多个名称之间使用空格分隔，即可一次指定多个软连接名称。 如果为多个不同的设备指定了相同的软连接， 那么实际的软连接将指向 link_priority 值最高的设备。 如果 link_priority 值最高的设备被移除， 那么该软连接将重新指向下一个 link_priority 值最高的设备，以此类推。 对于未指定 link_priority 值或者 link_priority 值相等的设备， 它们之间的顺序是不确定的。

    符号连接的名称必须不能与内核的默认名称相同， 否则会得到无法预知的结果。 
OWNER, GROUP, MODE

    设置设备节点的属主、属组、权限。 会覆盖内置的默认值。
SECLABEL{模块}

    设置设备节点的Linux安全模块标签。
ATTR{文件}

    设置在sysfs中的设备属性。[译者注]大括号中的"文件"是指设备路径(devpath)下的文件。 例如，对于 /dev/sda1 来说，ATTR{size} 的含义其实是指 /sys/block/sda/sda1/size 文件的内容。
SYSCTL{内核参数}

    设置"内核参数"的值。[译者注]所谓"内核参数"其实是指 /proc/sys/ 中的"内核参数"。例如，可以用 SYSCTL{kernel/hostname} 设置 /proc/sys/kernel/hostname 的值。
ENV{属性}

    设置设备的属性。例如 "DEVTYPE", "ID_PATH", "SYSTEMD_WANTS" 等等。 [提示]可以通过 udevadm info --query=property /dev/sda 命令查看 /dev/sda 的所有属性。 如果属性名以 "." 开头，那么此属性将不会被记录到udev数据库中， 也不会被导出为环境变量(例如 PROGRAM)。
TAG

    设置设备的标签。 用于为libudev监视(monitor)功能的用户过滤事件或者枚举已标记的设备。 标签仅在与特殊的设备过滤器一起使用时才有意义， 千万不要用于常规目的。 滥用标签将会导致设备事件处理效率显著下降， 所以应该尽量避免为设备设置标签。 
RUN{类型}

    对于每一个设备事件来说，在处理完所有udev规则之后， 都可以再接着执行一个由此键设置的程序列表(默认为空)。 不同的"类型"含义如下：

    "program"

        一个外部程序， 如果是相对路径， 那么视为相对于 /usr/lib/udev 目录。 否则必须使用绝对路径。

        如果未明确指定"类型"，那么这是默认值。 
    "builtin"

        与 program 类似， 但是仅用于表示内置的程序。

    程序名与其参数之间用空格分隔。 如果参数中含有空格，那么必须使用单引号("'")界定。

    仅可使用运行时间非常短的前台程序， 切勿设置任何后台守护进程或者长时间运行的程序。

    设备事件处理完成之后， 所有派生的进程(无论是否已经分离)， 都将会被无条件的杀死。
LABEL

    设置一个可用作 GOTO 跳转目标的标签。
GOTO

    跳转到下一个匹配的 LABEL 标签所在的规则。
IMPORT{类型}

    将一组变量导入为设备的属性。 不同的"类型"含义如下：

    "program"

        执行一个外部程序，并且当其返回值为零时导入其输出内容。 注意，输出内容的每一行都必须符合"key=value"格式。 关于程序路径、命令与参数分隔符、引号的使用规则、程序执行时间，等等， 都与 RUN 相同。
    "builtin"

        与 "program" 类似， 但是仅用于执行内置的程序。
    "file"

        导入一个文本文件的内容。该文本文件的每一行都必须符合"key=value"格式。 以"#"开头的行将被视为注释而忽略。
    "db"

        从当前已有的udev数据库中导入一个单独的属性。 仅可用于udev数据库确实已经被早先的设备事件所填充的情形。 
    "cmdline"

        从内核引导选项导入一个单独的属性。对于那些仅有单独的标记而没有值的属性， 其值将被指定为 "1" 。
    "parent"

        从父设备导入已有的属性(包括对应的值)。 可以将 IMPORT{parent} 赋值为shell风格的匹配模式， 以导入多个属性名称与匹配模式相符的属性。 

    仅可使用运行时间非常短的前台程序，切勿设置任何后台守护进程或者长时间运行的程序。 参见 RUN
OPTIONS

    规则与设备的选项：

    link_priority=value

        指定创建符号链接时的优先级。 数值越大优先级越高。默认值是"0"。
    string_escape=none|replace

        在对设备进行命名时，如何处理设备名字中的非常规字符(比如控制字符与不安全的字符)。 none 表示不做处理，保持原样； replace 表示将这些非常规字符替换为"_"(下划线)。
    static_node=

        将本条规则设定的权限应用到此选项指定的静态设备节点上。 同时，如果在本规则中指定了标签(tag)， 那么还会在 /run/udev/static_node-tags/tag 目录中创建一个指向该静态设备节点的软连接。 注意，在 systemd-udevd 启动之前， 静态设备节点就已经由 systemd-tmpfiles 创建完成了。 创建静态设备节点时，并不要求存在对应的内核设备， 因为当这些设备节点被访问时，会触发内核模块的自动加载功能。
    watch

        使用文件系统的 inotify 功能监视设备节点。 当节点被打开并写入之后又被关闭， 将会触发一个"设备状态已变化"的事件。
    nowatch

        禁用针对设备节点的 inotify 监视功能。

NAME, SYMLINK, PROGRAM, OWNER, GROUP, MODE, RUN 都支持简单的字符串替换。 RUN 的替换发生在 所有规则全部处理完成之后、程序将要执行之前， 因此可以使用由匹配成功的规则所设置的设备属性。 而其他键的替换发生在该键所在规则被处理完成的当时。 可用的替换标记如下：

$kernel, %k

    设备的内核名称
$number, %n

    设备在内核中的序号。例如，对于 "sda3" 来说，此值为 "3" 
$devpath, %p

    设备路径(devpath)。也就是该设备在sysfs文件系统下的相对路径。例如，/dev/sda1 对应的设备路径是 /block/sda/sda1 (一般对应着 /sys/block/sda/sda1 目录)。
$id, %b

    被 SUBSYSTEMS, KERNELS, DRIVERS, ATTRS 成功匹配到的设备的设备名称 
$driver

    被 SUBSYSTEMS, KERNELS, DRIVERS, ATTRS 成功匹配到的设备的驱动名称 
$attr{文件}, %s{文件}

    在规则匹配成功时， 设备路径(devpath)下"文件"的内容(用于表示设备的属性)。 如果该设备路径下没有此文件， 则从先前 KERNELS, SUBSYSTEMS, DRIVERS, ATTRS 匹配的父设备中提取。

    如果"文件"是一个软连接， 则一直追踪软连接到最终的实际文件。 
$env{属性}, %E{属性}

    设备的属性值。例如 "DEVTYPE", "ID_PATH", "SYSTEMD_WANTS" 等等。[提示]可以通过 udevadm info --query=property /dev/sda 命令查看 /dev/sda 的所有属性。
$major, %M

    设备的主设备号
$minor, %m

    设备的次设备号
$result, %c

    PROGRAM 程序的输出字符串。 可以使用 "%c{N}" 提取第N个子字符串(以空格为分隔符，从"1"开始计数)。 也可以通过 "%c{N+}"(也就是在数字后附加一个 "+")提取从第N个子字符串开始一直到结尾的部分。 
$parent, %P

    父设备的节点名称
$name

    设备的当前名称。如果没有被任何udev规则修改， 那么等于该设备的内核名称。
$links

    一个空格分隔的软链接名称列表，这些软链接都指向该设备的节点。 该值仅在两种情况下存在：(1)发生"remove"事件；(2)先前的规则已对 SYMLINK 赋值。
$root, %r

    udev_root 的值
$sys, %S

    sysfs 文件系统的挂载点
$devnode, %N

    设备节点的名称(也就是设备文件的名称)
%%

    百分号 "%" 自身
$$

    美元符号 "$" 自身

参见

systemd-udevd.service(8), udevadm(8), systemd.link(5)

}