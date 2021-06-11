mount -t usbdevfs none /proc/bus/usb #none /proc/bus/usb usbdevfs defaults 0 0  

drivers\usb\usb-skeleton.c

https://github.com/gnab/rtl8812au       # Realtek 802.11n WLAN Adapter Linux driver
drivers\staging\rtl8712\usb_intf.c      # Realtek 802.11n WLAN Adapter Linux driver
\rtl8723BU_WiFi\os_dep\linux\usb_intf.c # Realtek 802.11n WLAN Adapter Linux driver


1. 一个USB系统包含了3类硬件设备：                                                             ---- 串行方式传输数据
USB主机：   USB主机控制器 [主机控制器总是和根集线器关联。根集线器提供了到主机控制机器的附着点]
USB设备：   USB设备控制器
USB集线器：                                                                                   ---- 热插拔能力
每条总线上只有一个主机控制器，负责协调主机和设备间的通信，而设备不能主动向主机发送任何消息。  ---- 即插即用的系统
主机查询各种外设 ---- 单主实现

位于主机系统的驱动
USB设备驱动程序 USB device drivers ：控制插入其中的USB设备。
                                     为USB驱动程序提供了一个用于访问和控制USB硬件的接口。
位于设备的驱动                                     
USB器件驱动程序 USB gadget drivers : 描述控制连接到计算机的USB设备的驱动程序。
                                     控制单个设备如何作为一个 USB 设备看待主机系统.

如果一个设备遵循该标准，就不需要一个特殊的驱动程序。这些不同的特定类型成为类(class)，包括存储设备
键盘、鼠标、游戏杆、网络设备和调制解调器。对于不符合这些类的其他类型的设备，需要针对特定的设备编写
一个特定的于供货商的驱动程序(EM350驱动程序)。
-------------------------------------------------------------------------------
USB(树：一棵由几个点对点的连接构建而成的树)  地线，电源线，信号线*2 === 与以太网双绞线类似

USB驱动程序:USB 驱动位于不同的内核子系统(块, 网络, 字符, 等等)和硬件控制器之间. 
USB 核心提供了一个接口给 USB 驱动用来存取和控制 USB 硬件, 而不必担心出现在系统中的不同的 USB 硬件控制器.

USB核: 来处理大部分复杂的工作.驱动和 USB 核之间的交互.

设备描述符  bNumConfigurations
配置        bNumInterfaces
接口        bNumEndpoints
端口        


USB端点 ---- usb_endpoint_descriptor
---------------
USB设备： 配置，接口和端点，以及USB驱动程序如何绑定到USB接口上。
   [1:n] [1:m]
配置: 接口: 端点

端点：USB端点只能往一个方向传送数据，从主机到设备或者从设备到主机。端点可以看作是单向的管道。
端点类型 ---- CONTROL INTERRUPT  BULK ISOCHRONOUS
1. 控制:用来控制对USB设备不同部分的访问。(配置设备、获取设备信息、发送命令到设备，或者获取设备的状态报告)。
2. 中断:USB键盘和鼠标所使用的主要通信方式，还用于发送数据到USB设备以控制设备，不过一般不用来传输大量的数据。
3. 批量:打印机、存储设备和网络设备。
4. 等时:同样可以存储大量数据，但是数据是否到达是无法保证的。音频和视频设备,
           带宽     方式         内容        存在性
1. 控制    有保证   数据有保证   配置管理    必然存在   异步  端点 0;USB 核用来在插入时配置设备
2. 中断    有保证   数据有保证   少量数据    可能存在   周期  中断端点传送小量的数据,  
3. 批量    无保证   数据有保证   大量数据    可能存在   异步  块端点传送大量的数据. 
4. 等时    无保证   数据无保证   大量数据    可能存在   周期  同步端点也传送大量数据, 
控制和批量端点用于异步的数据传输，只要驱动程序决定使用它们。
中断和等时端点是周期性的，这意味着这些端点被设置来连续传送数据在固定的时间, 这使它们的带宽被 USB 核所保留.


usb_host_endpoint        描述USB端点
--------
struct usb_endpoint_descriptor desc; //端点描述符
struct list_head urb_list; //此端点的URB对列，由USB核心维护
void *hcpriv;
struct ep_device *ep_dev; /* For sysfs info */
unsigned char *extra; /* Extra descriptors */
int extralen;
int enabled;


usb_endpoint_descriptor  真正的端点信息，包含了所有的USB特定的数据，以设备自身特定的准确格式
--------
  bEndpointAddress;   #  这个特定端点的 USB 地址. 还包含在这个 8-位 值的是端点的方向
    #define USB_DIR_OUT         0       /* to device */  
    #define USB_DIR_IN          0x80        /* to host */
  bmAttributes;       #  端点类型  掩码：USB_ENDPOINT_XFERTYPE_MASK
    #define USB_ENDPOINT_XFER_CONTROL   0       //control endpoint  
    #define USB_ENDPOINT_XFER_ISOC      1       //isochronous endpoint  
    #define USB_ENDPOINT_XFER_BULK      2       //bulk endpoint  
    #define USB_ENDPOINT_XFER_INT       3       //interrupt endpoint
  wMaxPacketSize;     #  以字节计的这个端点可一次处理的最大大小. 注意驱动可能发送大量的比这个值大的数据到端点, 
  # 但是数据会被分为 wMaxPakcetSize 的块, 当真正传送到设备时. 对于高速设备, 这个成员可用来支持端点的一个高带宽模式, 
  # 通过使用几个额外位在这个值的高位部分.
  bInterval;          # 如果这个端点是中断类型的, 这个值是为这个端点设置的间隔, 即在请求端点的中断之间的时间. 这个值以毫秒表示.

USB接口 ---- usb_interface
---------------
USB端点被绑定为接口。USB接口只处理一种USB逻辑连接：鼠标、键盘或者音频流。一些USB设备具有多个接口。
USB扬声器可以包括两个接口：一个USB键盘用于按键和一个USB音频流。

struct usb_interface #本接口对应的所有的设置（与配置不是一个概念）
--------------- interface_to_usbdev
usb_host_interface *altsetting;
一个接口结构体数组，包含了所有可能用于该接口的可选设置。每个struct usb_host_interface结构体包含一套
由上述struct usb_host_endpoint结构体定义的端点配置。注意，这些接口结构体没有特定的次序。

usb_host_interface *cur_altsetting; 指向altsetting数组内部的指针，表示该接口当前活动设置。

unsigned num_altsetting; 可选设置的数量

int minor; 如果捆绑到该接口的USB驱动程序使用USB主设备号，这个变量包含USB核心分配给该接口的次设备号。
           这仅在一个成功的usb_register_dev调用之后才有效。
           [在 struct usb_interface 结构中有其他成员, 但是 USB 驱动不需要知道它们.]
enum usb_interface_condition condition;  接口是否绑定
unsigned sysfs_files_created:1;          文件系统存在的文件的属性
unsigned ep_devs_created:1;              endpoint "devices" exist 
unsigned unregistering:1;                标识卸载interface
unsigned needs_remote_wakeup:1;          驱动要求远程唤醒
unsigned needs_altsetting0:1;            当设置0被推迟时标识
unsigned needs_binding:1;                needs delayed unbind/rebind
unsigned reset_running:1;
unsigned resetting_device:1;             true: bandwidth alloc after reset 
struct device dev;                       interface specific device info 
struct device *usb_dev;                  当接口被绑定到usb主设备号的时候，它指向文件系统中表示的usb设备
atomic_t pm_usage_cnt;                   usage counter for autosuspend 
struct work_struct reset_ws;             for resets in atomic context 


USB配置 ---- usb_host_config
---------------
USB接口本身被绑定为配置。一个USB设备可以有多个配置，而且可以在配置之间切换以改变设备的状态。
Linux对多个配置的USB设备处理的不是很好。
linux 描述 USB 配置使用结构 struct usb_host_config 和整个 USB 设备使用结构 struct usb_device.
struct usb_config_descriptor desc; //配置描述符
char *string; /* 配置的字符串指针（如果存在） */
struct usb_interface_assoc_descriptor *intf_assoc[USB_MAXIADS]; //配置的接口联合描述符链表
struct usb_interface *interface[USB_MAXINTERFACES]; //接口描述符链表
struct usb_interface_cache *intf_cache[USB_MAXINTERFACES];
unsigned char *extra; /* 额外的描述符 */
int extralen;


struct usb_host_config
USB设备 ---- usb_device
--------------- 
int devnum; //设备号，是在USB总线的地址
char devpath [16]; //用于消息的设备ID字符串
enum usb_device_state state; //设备状态：已配置、未连接等等
enum usb_device_speed speed; //设备速度：高速、全速、低速或错误
struct usb_tt *tt; //处理传输者信息；用于低速、全速设备和高速HUB
int ttport; //位于tt HUB的设备口
unsigned int toggle[2]; //每个端点的占一位，表明端点的方向([0] = IN, [1] = OUT)
struct usb_device *parent; //上一级HUB指针
struct usb_bus *bus; //总线指针
struct usb_host_endpoint ep0; //端点0数据
struct device dev; //一般的设备接口数据结构
struct usb_device_descriptor descriptor; //USB设备描述符
struct usb_host_config *config; //设备的所有配置
struct usb_host_config *actconfig; //被激活的设备配置
struct usb_host_endpoint *ep_in[16]; //输入端点数组
struct usb_host_endpoint *ep_out[16]; //输出端点数组
char **rawdescriptors; //每个配置的raw描述符
unsigned short bus_mA; //可使用的总线电流
u8 portnum;//父端口号
u8 level; //USB HUB的层数
unsigned can_submit:1; //URB可被提交标志
unsigned discon_suspended:1; //暂停时断开标志
unsigned persist_enabled:1; //USB_PERSIST使能标志
unsigned have_langid:1; //string_langid存在标志
unsigned authorized:1;
unsigned authenticated:1;
unsigned wusb:1; //无线USB标志
int string_langid; //字符串语言ID
 
/* static strings from the device */ //设备的静态字符串
char *product; //产品名
char *manufacturer; //厂商名
char *serial; //产品串号
struct list_head filelist; //此设备打开的usbfs文件
#ifdef CONFIG_USB_DEVICE_CLASS
struct device *usb_classdev; //用户空间访问的为usbfs设备创建的USB类设备
#endif
#ifdef CONFIG_USB_DEVICEFS
struct dentry *usbfs_dentry; //设备的usbfs入口
#endif
int maxchild; //（若为HUB）接口数
struct usb_device *children[USB_MAXCHILDREN];//连接在这个HUB上的子设备
int pm_usage_cnt; //自动挂起的使用计数
　　 u32 quirks;
　　 atomic_t urbnum; //这个设备所提交的URB计数
unsigned long active_duration; //激活后使用计时
 
#ifdef CONFIG_PM //电源管理相关
struct delayed_work autosuspend; //自动挂起的延时
struct work_struct autoresume; //（中断的）自动唤醒需求
struct mutex pm_mutex; //PM的互斥锁
 
unsigned long last_busy; //最后使用的时间
int autosuspend_delay;
unsigned long connect_time; //第一次连接的时间
unsigned auto_pm:1; //自动挂起/唤醒
unsigned do_remote_wakeup:1; //远程唤醒
unsigned reset_resume:1; //使用复位替代唤醒
unsigned autosuspend_disabled:1; //挂起关闭
unsigned autoresume_disabled:1; //唤醒关闭
unsigned skip_sys_resume:1; //跳过下个系统唤醒
#endif
struct wusb_dev *wusb_dev; //（如果为无线USB）连接到WUSB特定的数据结构


-------------------------------------------------------------------------------
USB和Sysfs
/sys/devices/pci ---- USB接口信息
---------------
物理 USB 设备(通过 struct usb_device 表示)和单个 USB 接口(由 struct usb_interface 表示)都作为单个设备出现在 sysfs
这是因为usb_device和usb_interface结构都包含一个 struct device结构。

结构 usb_device 在树中被表示在 ----                              /sys/devices/pci0000:00/0000:00:09.0/usb2/2-1
鼠标的 USB 接口 - USB 鼠标设备驱动被绑定到的接口 - 位于目录 ---- /sys/devices/pci0000:00/0000:00:09.0/usb2/2-1/2-1:1.0 


1. 第一个 USB 设备是一个根集线器. 这是 USB 控制器, 常常包含在一个 PCI 设备中. 控制器的命名是由于
   它控制整个连接到它上面的 USB 总线. 控制器是一个 PCI 总线和 USB 总线之间的桥, 同时是总线上的第一个设备.
2. 所有的根集线器被 USB 核心安排了一个唯一的号. 在我们的例子里, 根集线器称为 usb2, 因为它是注册到 USB 核心
   的第 2 个根集线器. 可包含在单个系统中在任何时间的根集线器的数目没有限制. 
3. 每个在 USB 总线上的设备采用根集线器的号作为它的名子的第一个数字. 紧跟着的是 - 字符和设备插入的端口号. 
    由于我们例子中的设备插在第一个端口, 一个 1 被添加到名子. 因此给主 USB 鼠标设备的名子是2-1.
4. 因为这个 USB 设备包含一个接口, 那使得树中的另一个设备被添加到 sysfs 路径. 到此点, USB 接口的命名方法是设备名:
   在我们的例子, 是 2-1 接着一个分号和 USB 配置名, 接着一个句点和接口名. 因此对这个例子, 设备名是 2-1:1.0 因为它
   是第一个配置并且有接口号 0.
   
[root_hub]-[hub_port]:[config].[interface]
[根集线器]-[集线器端口号]:[配置].[接口]
[root_hub]-[hub_port]-[hub_port]:[config].[interface] 
根集线器-集线器端口号-集线器端口号:配置.接口

find -name "idVendor" | xargs cat -
find -name "idProduct" | xargs cat -

/proc/bus/usb/devices ---- USB端点信息
---------------

/proc/bus/usb/devices目录的和/sys/kernel/debug/usb/devices显示相同的信息

-------------------------------------------------------------------------------
URB
1. 由USB设备驱动程序创建
2. 分配给一个特定USB设备的特定端点
3. 由USB设备驱动程序递交到USB核心
4. 由USB核心递交给特定设备的特定USB主控制器驱动程序
5. 由USB主控制器驱动程序处理，它从设备进行USB传送。
6. 当urb结束之后，USB主控制器驱动程序通知USB设备驱动程序

urb(struct){


# usb 请求块（usb request block, urb）是usb设备驱动中用来描述与usb设备通信所用的基本载体和核心数据结构，
# 它用起来非常象一个 kiocb 结构被用在文件系统异步 I/O 代码, 或者如同一个 struct skbuff 用在网络代码中.
    struct kref kref;             /* URB引用计数 */  
    void *hcpriv;                 /* host控制器的私有数据 */  
    atomic_t use_count;           /* 当前提交计数 */  
    atomic_t reject;              /* 提交失败计数 */  
    int unlinked;                 /* 连接失败代码 */  
    struct list_head urb_list;    /* list head for use by the urb current owner */  
    struct list_head anchor_list; /* the URB may be anchored */  
    struct usb_anchor *anchor;  
    struct usb_device *dev;       # 指向这个 urb 要发送到的 struct usb_device 的指针. 这个变量必须被 USB 驱动初始化, 在这个 urb 被发送到 USB 核心之前. 
    struct usb_host_endpoint *ep; /* (internal) pointer to endpoint */  
    unsigned int pipe;    
    端点消息, 给这个 urb 要被发送到的特定 struct usb_device. 这个变量必须被 USB 驱动初始化, 在这个 urb 被发送到 USB 核心之前.
    一个管道号码，该管道记录了目标设备的端点以及管道的类型。每个管道只有一种类型和一个方向，它与他的目标设备
的端点向对应，我们可以通过以下几个函数来获得管道号并设置管道类型：
     unsigned int usb_sndctrlpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个控制OUT端点。
     unsigned int usb_rcvctrlpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个控制IN端点。
     unsigned int usb_sndbulkpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个批量OUT端点。
     unsigned int usb_rcvbulkpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个批量IN端点。
     unsigned int usb_sndintpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个中断OUT端点。
     unsigned int usb_rcvintpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个中断IN端点。
     unsigned int usb_sndisocpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个等时OUT端点。
     unsigned int usb_rcvisocpipe(struct usb_device *dev, unsigned int endpoint)
         把指定USB设备指定端点设置为一个等时IN端点。

    int status;           
    unsigned int transfer_flags;    /* 传输设置*/  
    这个变量可被设置为不同位值, 根据这个 USB 驱动想这个 urb 发生什么. 可用的值是:
    URB_SHORT_NOT_OK #只对从 USB 设备读的 urb 有用
        当置位, 它指出任何在一个 IN 端点上可能发生的短读, 应当被 USB 核心当作一个错误. 这个值
        只对从 USB 设备读的 urb 有用, 不是写 urbs.
    URB_ISO_ASAP # 同步的 & start_frame 变量
        如果这个 urb 是同步的, 这个位可被置位如果驱动想这个 urb 被调度, 只要带宽允许它这样, 
        并且在此点设置这个 urb 中的 start_frame 变量. 如果对于同步 urb 这个位没有被置位, 驱动
        必须指定 start_frame 值并且必须能够正确恢复, 如果没有在那个时刻启动. 见下面的章节关于同步 urb 更多的消息.
    URB_NO_TRANSFER_DMA_MAP # transfer_dma 和 transfer_buffer 选择器
        应当被置位, 当 urb 包含一个要被发送的 DMA 缓冲. USB 核心使用这个被 transfer_dma 
        变量指向的缓冲, 不是被 transfer_buffer 变量指向的缓冲.
    URB_NO_SETUP_DMA_MAP # setup_dma 和 setup_packet 选择器
        象 URB_NO_TRANSFER_DMA_MAP 位, 这个位用来控制有一个 DMA 缓冲已经建立的 urb. 
        如果它被置位, USB 核心使用这个被 setup_dma 变量而不是 setup_packet 变量指向的缓冲. 
    URB_ASYNC_UNLINK # 给这个 urb 的对 usb_unlink_urb 的调用几乎立刻返回
        如果置位, 给这个 urb 的对 usb_unlink_urb 的调用几乎立刻返回, 并且这个 urb 在后面被解除连接. 
        否则, 这个函数等待直到 urb 完全被去链并且在返回前结束. 小心使用这个位, 因为它可有非常难于调试的同步问题.
    URB_NO_FSBR # 仅适合于UHCI USB
        只有 UHCI USB 主机控制器驱动使用, 并且告诉它不要试图做 Front Side Bus Reclamation 逻辑. 
        这个位通常应当不设置, 因为有 UHCI 主机控制器的机器创建了许多 CPU 负担, 并且 PCI 总线被
        等待设置了这个位的 urb 所饱和.
    URB_ZERO_PACKET #
        如果置位, 一个块 OUT urb 通过发送不包含数据的短报文而结束, 当数据对齐到一个端点报文边界. 
        这被一些坏掉的 USB 设备所需要(例如一些 USB 到 IR 的设备) 为了正确的工作..
    URB_NO_INTERRUPT #
        如果置位, 硬件当 urb 结束时可能不产生一个中断. 这个位应当小心使用并且只在排队多个到相同端点的
        urb 时使用. USB 核心函数使用这个为了做 DMA 缓冲传送.
    
    
    void *transfer_buffer;          # 指向用在发送数据到设备(对一个 OUT urb)或者从设备中获取数据(对于一个 IN urb)
    # 的缓冲的指针. 对主机控制器为了正确存取这个缓冲, 它必须被使用一个对 kmalloc 调用来创建, 不是在堆栈或者静态地. 
    # 对控制端点, 这个缓冲是给发送的数据阶段.
    dma_addr_t transfer_dma;        # 用来使用 DMA 传送数据到 USB 设备的缓冲. 
    int transfer_buffer_length;     # 缓冲的长度, 被 transfer_buffer 或者 transfer_dma 变量指向(由于只有一个可被一个 urb 使用). 如果这是 0, 没有传送缓冲被 USB 核心所使用.  
    # 对于一个 OUT 端点, 如果这个端点最大的大小比这个变量指定的值小, 对这个 USB 设备的传送被分成更小的块为了正确的传送数据. 这种大的传送发生在连续的 USB 帧. 提交一个
    # 大块数据在一个 urb 中是非常快, 并且使 USB 主机控制器去划分为更小的快, 比以连续的顺序发送小缓冲.
    int actual_length;              # 当这个 urb 被完成, 这个变量被设置为数据的真实长度, 或者由这个 urb (对于 OUT urb)发送或者由这个 urb(对于 IN urb)接受. 对于 IN urb, 
    # 这个必须被用来替代 transfer_buffer_length 变量, 因为接收的数据可能比整个缓冲大小小. 
    unsigned char *setup_packet;    # 指向给一个控制 urb 的 setup 报文的指针. 它在位于传送缓冲中的数据之前被传送. 这个变量只对控制 urb 有效.  
    dma_addr_t setup_dma;           # 给控制 urb 的 setupt 报文的 DMA 缓冲. 在位于正常传送缓冲的数据之前被传送. 这个变量只对控制 urb 有效.  
    int start_frame;                # 设置或返回同步传送要使用的初始帧号. 
    int number_of_packets;          # 只对同步 urb 有效, 并且指定这个 urb 要处理的同步传送缓冲的编号. 这个值必须被 USB 驱动设置给同步 urb, 在这个 urb 发送给 USB 核心之前.
    int interval;                   # urb 被轮询的间隔. 这只对中断或者同步 urb 有效.
    # 对于低速和高速的设备, 单位是帧, 它等同于毫秒. 对于设备, 单位是宏帧的设备, 它等同于 1/8 微秒单位. 这个值必须被 USB 驱动设置给同步或者中断 urb, 在这个 urb被发送到 USB 核心之前.
    int error_count;                # 被 USB 核心设置, 只给同步 urb 在它们完成之后. 它指定报告任何类型错误的同步传送的号码.
    void *context;                  # 指向数据点的指针, 它可被 USB 驱动设置. 它可在完成处理者中使用当 urb 被返回到驱动. 
    usb_complete_t complete;        # 指向完成处理者函数的指针, 它被 USB 核心调用当这个 urb 被完全传送或者当 urb 发生一个错误. 在这个函数中, 
    # USB 驱动可检查这个 urb, 释放它, 或者重新提交它给另一次传送.
    struct usb_iso_packet_descriptor iso_frame_desc[0]; 
    结构 usb_iso_packet_descriptor 由下列成员组成:
unsigned int offset
    报文数据所在的传送缓冲中的偏移(第一个字节从 0 开始).
unsigned int length
    这个报文的传送缓冲的长度.
unsigned int actual_length
    接收到给这个同步报文的传送缓冲的数据长度.
unsigned int status
    这个报文的单独同步传送的状态. 它可采用同样的返回值如同主 struct urb 结构的状态变量.
    
    
    
    int status;  # 当这个 urb 被结束, 或者开始由 USB 核心处理, 这个变量被设置为 urb 的当前状态. 一个 USB 驱动
    # 可安全存取这个变量的唯一时间是在 urb 完成处理者函数中(在"CompletingUrbs: 完成回调处理者"一节中描述). 
    # 这个限制是阻止竞争情况, 发生在这个 urb 被 USB 核心处理当中. 对于同步 urb, 在这个变量中的一个成功的值(0)
    # 只指示是否这个 urb 已被去链. 为获得在同步 urb 上的详细状态, 应当检查 iso_frame_desc 变量.
    # status可能返回值
    0
    这个 urb 传送是成功的.
-ENOENT
    这个 urb 被对 usb_kill_urb 的调用停止.
-ECONNRESET
    urb 被对 usb_unlink_urb 的调用去链, 并且 transfer_flags 变量被设置为 URB_ASYNC_UNLINK.
-EINPROGRESS
    这个 urb 仍然在被 USB 主机控制器处理中. 如果你的驱动曾见到这个值, 它是一个你的驱动中的 bug.
-EPROTO
    这个urb 发生下面一个错误:
        一个 bitstuff 错误在传送中发生.
        硬件没有及时收到响应帧.
-EILSEQ
    在这个 urb 传送中有一个 CRC 不匹配.
-EPIPE
    这个端点现在被停止. 如果这个包含的端点不是一个控制端点, 这个错误可被清除通过一个对函数 usb_clear_halt 的调用.
-ECOMM
    在传送中数据接收快于能被写入系统内存. 这个错误值只对 IN urb.
-ENOSR
    在传送中数据不能从系统内存中获取得足够快, 以便可跟上请求的 USB 数据速率. 这个错误只对 OUT urb.
-EOVERFLOW
    这个 urb 发生一个"babble"错误. 一个"babble"错误发生当端点接受数据多于端点的特定最大报文大小.
-EREMOTEIO
    只发生在当 URB_SHORT_NOT_OK 标志被设置在 urb 的 transfer_flags 变量, 并且意味着 urb 请求的完整数量的数据没有收到.
-ENODEV
    这个 USB 设备现在从系统中消失.
-EXDEV
    只对同步 urb 发生, 并且意味着传送只部分完成. 为了决定传送什么, 驱动必须看单独的帧状态.
-EINVAL
    这个 urb 发生了非常坏的事情. USB 内核文档描述了这个值意味着什么:
    ISO 疯了, 如果发生这个: 退出并回家.
    它也可发生, 如果一个参数在 urb 结构中被不正确地设置了, 或者如果在提交这个 urb 给 USB 核心的 usb_submit_urb 调用中, 有一个不正确的函数参数.
-ESHUTDOWN
    这个 USB 主机控制器驱动有严重的错误; 它现在已被禁止, 或者设备和系统去掉连接, 并且这个urb 在设备被去除后被提交. 它也可发生当这个设备的配置改变, 而这个 urb 被提交给设备.
通常, 错误值 -EPROTO, -EILSEQ, 和 -EOVERFLOW 指示设备的硬件问题, 设备固件, 或者连接设备到计算机的线缆.
    
}

urb(function){
创建和销毁 urb
---------------
1. struct urb *usb_alloc_urb(int iso_packets, int mem_flags);
第一个参数, iso_packet, 是这个 urb 应当包含的同步报文的数目. 如果你不想创建一个同步 urb, 这个变量应当被设置为 0. 
第 2 个参数, mem_flags, 是和传递给 kmalloc 函数调用来从内核分配内存的相同的标志类型. 如果这个函数在分配足够内存
给这个 urb 成功, 一个指向 urb 的指针被返回给调用者. 如果返回值是 NULL, 某个错误在 USB 核心中发生了, 并且驱动
需要正确地清理.

2. void usb_free_urb(struct urb *urb);
参数是一个指向你要释放的 struct urb 的指针. 在这个函数被调用之后, urb 结构消失, 驱动不能再存取它.


中断 urb
---------------
函数 usb_fill_int_urb 是一个帮忙函数, 来正确初始化一个urb 来发送给 USB 设备的一个中断端点:
3. void usb_fill_int_urb(struct urb *urb, struct usb_device *dev, 
    unsigned int pipe, void *transfer_buffer, 
    int buffer_length, usb_complete_t complete, 
    void *context, int interval);
这个函数包含许多参数:
struct urb *urb
    指向要被初始化的 urb 的指针.
struct usb_device *dev
    这个 urb 要发送到的 USB 设备.
unsigned int pipe
    这个 urb 要被发送到的 USB 设备的特定端点. 这个值被创建, 使用前面提过的 usb_sndintpipe 或者 usb_rcvintpipe 函数.
void *transfer_buffer
    指向缓冲的指针, 从那里外出的数据被获取或者进入数据被接受. 注意这不能是一个静态的缓冲并且必须使用 kmalloc 调用来创建.
int buffer_length
    缓冲的长度, 被 transfer_buffer 指针指向. 
usb_complete_t complete
    指针, 指向当这个 urb 完成时被调用的完成处理者.
void *context
    指向数据块的指针, 它被添加到这个 urb 结构为以后被完成处理者函数获取.
int interval
    这个 urb 应当被调度的间隔. 见之前的 struct urb 结构的描述, 来找到这个值的正确单位.
    
块 urb
---------------
块 urb 被初始化非常象中断 urb. 做这个的函数是 usb_fill_bulk_urb, 它看来如此:
void usb_fill_bulk_urb(struct urb *urb, struct usb_device *dev,
    unsigned int pipe, void *transfer_buffer,
    int buffer_length, usb_complete_t complete,
    void *context);
这个函数参数和 usb_fill_int_urb 函数的都相同. 但是, 没有 interval 参数因为 bulk urb 没有间隔值. 
请注意这个 unsiged int pipe 变量必须被初始化用对 usb_sndbulkpipe 或者 usb_rcvbulkpipe 函数的调用.

usb_fill_int_urb 函数不设置 urb 中的 transfer_flags 变量, 因此任何对这个成员的修改不得不由这个驱动自己完成.

控制 urb
---------------
控制 urb 被初始化几乎和 块 urb 相同的方式, 使用对函数 usb_fill_control_urb 的调用:
void usb_fill_control_urb(struct urb *urb, struct usb_device *dev,
    unsigned int pipe, unsigned char *setup_packet,
    void *transfer_buffer, int buffer_length,
    usb_complete_t complete, void *context);
    函数参数和 usb_fill_bulk_urb 函数都相同, 除了有个新参数, unsigned char *setup_packet, 它必须指向要发送给端点的 
setup 报文数据. 还有, unsigned int pipe 变量必须被初始化, 使用对 usb_sndctrlpipe 或者 usb_rcvictrlpipe 函数的调用.
    usb_fill_control_urb 函数不设置 transfer_flags 变量在 urb 中, 因此任何对这个成员的修改必须游驱动自己完成. 
大部分驱动不使用这个函数, 因为使用在"USB 传送不用 urb"一节中介绍的同步 API 调用更简单.


同步 urb
---------------
不幸的是, 同步 urb 没有一个象中断, 控制, 和块 urb 的初始化函数. 因此它们必须在驱动中"手动"初始化, 在它们可被提交给 
USB 核心之前. 下面是一个如何正确初始化这类 urb 的例子. 
它是从 konicawc.c 内核驱动中取得的, 它位于主内核源码树的 drivers/usb/media 目录.
urb->dev = dev;
urb->context = uvd;
urb->pipe = usb_rcvisocpipe(dev, uvd->video_endp-1);
urb->interval = 1;
urb->transfer_flags = URB_ISO_ASAP;
urb->transfer_buffer = cam->sts_buf[i];
urb->complete = konicawc_isoc_irq;
urb->number_of_packets = FRAMES_PER_DESC;
urb->transfer_buffer_length = FRAMES_PER_DESC;
for (j=0; j < FRAMES_PER_DESC; j++) {

 urb->iso_frame_desc[j].offset = j;
 urb->iso_frame_desc[j].length = 1;
}

 提交 urb
---------------
一旦 urb 被正确地创建,并且被 USB 驱动初始化, 它已准备好被提交给 USB 核心来发送出到 USB 设备. 这通过调用函数 usb_submit_urb 实现:
int usb_submit_urb(struct urb *urb, int mem_flags);
urb 参数是一个指向 urb 的指针, 它要被发送到设备. mem_flags 参数等同于传递给 kmalloc 调用的同样的参数, 并且用来告诉 USB 核心如何及时分配任何内存缓冲在这个时间.
在 urb 被成功提交给 USB 核心之后, 应当从不试图存取 urb 结构的任何成员直到完成函数被调用.
因为函数 usb_submit_urb 可被在任何时候被调用(包括从一个中断上下文), mem_flags 变量的指定必须正确. 真正只有 3 个有效值可用, 根据何时 usb_submit_urb 被调用:
GFP_ATOMIC
    这个值应当被使用无论何时下面的是真:
        调用者处于一个 urb 完成处理者, 一个中断, 一个后半部, 一个 tasklet, 或者一个时钟回调.
        调用者持有一个自旋锁或者读写锁. 注意如果正持有一个旗标, 这个值不必要.
        current->state 不是 TASK_RUNNING. 状态一直是 TASK_RUNNING 除非驱动已自己改变 current 状态.
GFP_NOIO
    这个值应当被使用, 如果驱动在块 I/O 补丁中. 它还应当用在所有的存储类型的错误处理补丁中.
GFP_KERNEL
    这应当用在所有其他的情况中, 不属于之前提到的类别.
    
完成 urb: 完成回调处理者  
 ---------------
    如果对 usb_submit_urb 的调用成功, 传递对 urb 的控制给 USB 核心, 这个函数返回 0; 否则, 一个负错误值被返回. 
如果函数成功, urb 的完成处理者(如同被完成函数指针指定的)被确切地调用一次, 当 urb 被完成. 当这个函数被调用, 
USB 核心完成这个 urb, 并且对它的控制现在返回给设备驱动.
只有 3 个方法, 一个urb 可被结束并且使完成函数被调用:
    urb 被成功发送给设备, 并且设备返回正确的确认. 对于一个 OUT urb, 数据被成功发送, 对于一个 IN urb, 请求的数据被成功收到. 如果发生这个, urb 中的状态变量被设置为 0.
    一些错误连续发生, 当发送或者接受数据从设备中. 被 urb 结构中的 status 变量中的错误值所记录.
    这个 urb 被从 USB 核心去链. 这发生在要么当驱动告知 USB 核心取消一个已提交的 urb 通过调用 usb_unlink_urb 或者 usb_kill_urb, 要么当设备从系统中去除, 以及一个 urb 已经被提交给它.
一个如何测试在一个 urb 完成调用中不同返回值的例子在本章稍后展示.
 
取消 urb
 ---------------
为停止一个已经提交给 USB 核心的 urb, 函数 usb_kill_urb 或者 usb_unlink_urb 应当被调用:
int usb_kill_urb(struct urb *urb); 
int usb_unlink_urb(struct urb *urb);

当函数是 usb_kill_urb, 这个 urb 的生命循环就停止了. 这个函数常常在设备从系统去除时被使用, 在去连接回调中.

对一些驱动, 应当用 usb_unlink_urb 函数来告知 USB 核心去停止 urb. 这个函数在返回到调用者之前不等待这个 urb 完全停止.
 这对于在中断处理或者持有一个自旋锁时停止 urb 时是有用的, 因为等待一个 urb 完全停止需要 USB 核心有能力使调用进程睡眠.
 为了正确工作这个函数要求 URB_ASYNC_UNLINK 标志值被设置在正被要求停止的 urb 中.
 
 
}

usb(编写一个 USB 驱动)
{
驱动注册它的驱动对象到 USB 子系统并且之后使用供应商和设备标识来告知是否它的硬件已经安装.

驱动支持什么设备
---------------
    struct usb_device_id 结构提供了这个驱动支持的一个不同类型 USB 设备的列表. 这个列表被USB 核心用来决定给
设备哪个驱动, 并且通过热插拔脚本来决定哪个驱动自动加载, 当特定设备被插入系统时.
 
struct usb_device_id 结构定义有下面的成员:
__u16 match_flags
    决定设备应当匹配结构中下列的哪个成员. 这是一个位成员, 由在 include/linux/mod_devicetable.h 文件中指定的
不同的 USB_DEVICE_ID_MATCH_* 值所定义. 这个成员常常从不直接设置, 但是由 USB_DEVICE 类型宏来初始化.

__u16 idVendor
    这个设备的 USB 供应商 ID. 这个数由 USB 论坛分配给它的成员并且不能由任何别的构成.

__u16 idProduct
    这个设备的 USB 产品 ID. 所有的有分配给他们的供应商 ID 的供应商可以随意管理它们的产品 ID.
    
__u16 bcdDevice_lo
__u16 bcdDevice_hi
    定义供应商分配的产品版本号的高低范围. bcdDevice_hi 值包括其中; 它的值是最高编号的设备号. 
这 2 个值以BCD 方式编码. 这些变量, 连同 idVendor 和 idProduct, 用来定义一个特定的设备版本.

__u8 bDeviceClass
__u8 bDeviceSubClass
__u8 bDeviceProtocol
    定义类, 子类, 和设备协议, 分别地. 这些值被 USB 论坛分配并且定义在 USB 规范中. 这些值指定这个设备的行为, 
包括设备上所有的接口.

__u8 bInterfaceClass
__u8 bInterfaceSubClass
__u8 bInterfaceProtocol
    非常象上面的设备特定值, 这些定义了类, 子类, 和单个接口协议, 分别地. 这些值由 USB 论坛指定并且定义在 
USB 规范中.

kernel_ulong_t driver_info
    这个值不用来匹配, 但是它持有信息, 驱动可用来在 USB 驱动的探测回调函数区分不同的设备.

至于 USB 设备, 有几个宏可用来初始化这个结构:
USB_DEVICE(vendor, product)
    创建一个 struct usb_device_id, 可用来只匹配特定供应商和产品 ID 值. 这是非常普遍用的, 对于需要特定驱动的 USB 设备.

USB_DEVICE_VER(vendor, product, lo, hi)
    创建一个 struct usb_device_id, 用来在一个版本范围中只匹配特定供应商和产品 ID 值.
    
USB_DEVICE_INFO(class, subclass, protocol)
    创建一个 struct usb_device_id, 可用来只匹配一个特定类的 USB 设备.
    
USB_INTERFACE_INFO(class, subclass, protocol)
    创建一个 struct usb_device_id, 可用来只匹配一个特定类的 USB 接口.

对于一个简单的 USB 设备驱动, 只控制来自一个供应商的一个单一USB 设备, struct usb_device_id 表可定义如:

/* table of devices that work with this driver */ 
static struct usb_device_id skel_table [] = {
 { USB_DEVICE(USB_SKEL_VENDOR_ID, USB_SKEL_PRODUCT_ID) },
 { } /* Terminating entry */
};
MODULE_DEVICE_TABLE (usb, skel_table);

至于USB驱动, MODULE_DEVICE_TABLE 宏有必要允许用户空间工具来发现这个驱动可控制什么设备. 但是对于 USB 驱动, 
字符串 usb 必须是在这个宏中的第一个值.
}

usb(注册一个 USB 驱动:usb-skeleton.c){

所有 USB 驱动必须创建的主要结构是 struct usb_driver. 这个结构必须被 USB 驱动填充并且包含多个函数回调和变量, 
来向 USB 核心代码描述 USB 驱动:

struct module *owner
    指向这个驱动的模块拥有者的指针. USB 核心使用它正确地引用计数这个 USB 驱动, 以便它不被在不合适的时刻卸载. 这个变量应当设置到 THIS_MODULE 宏.
const char *name
    指向驱动名子的指针. 它必须在内核 USB 驱动中是唯一的并且通常被设置为和驱动的模块名相同. 它出现在 sysfs 中在 /sys/bus/usb/drivers/ 之下, 当驱动在内核中时.
const struct usb_device_id *id_table
    指向 struct usb_device_id 表的指针, 包含这个驱动可接受的所有不同类型 USB 设备的列表. 如果这个变量没被设置, USB 驱动中的探测回调函数不会被调用. 
    如果你需要你的驱动给系统中每个 USB 设备一直被调用, 创建一个只设置这个 driver_info 成员的入口项:
    static struct usb_device_id usb_ids[] = {
     {.driver_info = 42},
        {} 
    };

int (*probe) (struct usb_interface *intf, const struct usb_device_id *id)
    指向 USB 驱动中探测函数的指针. 这个函数(在"探测和去连接的细节"一节中描述)被 USB 核心调用当它认为它有一个这个驱动可处理的 struct usb_interface. 一个指向 USB 核心用来做决定的 struct usb_device_id 的指针也被传递到这个函数. 如果这个 USB 驱动主张传递给它的 struct usb_interface, 它应当正确地初始化设备并且返回 0. 如果驱动不想主张这个设备, 或者发生一个错误, 它应当返回一个负错误值.
void (*disconnect) (struct usb_interface *intf)
    指向 USB 驱动的去连接函数的指针. 这个函数(在"探测和去连接的细节"一节中描述)被 USB 核心调用, 当 struct usb_interface 已被从系统中清除或者当驱动被从 USB 核心卸载.
为创建一个值 struct usb_driver 结构, 只有 5 个成员需要被初始化:
static struct usb_driver skel_driver = {
 .owner = THIS_MODULE,
 .name = "skeleton",
 .id_table = skel_table,
 .probe = skel_probe,
 .disconnect = skel_disconnect, 
}; 
struct usb_driver 确实包含更多几个回调, 它们通常不经常用到, 并且不被要求使 USB 驱动正确工作:
int (*ioctl) (struct usb_interface *intf, unsigned int code, void *buf)
    指向 USB 驱动的 ioctl 函数的指针. 如果它出现, 在用户空间程序对一个关联到 USB 设备的 usbfs 文件系统设备入口, 
做一个 ioctl 调用时被调用. 实际上, 只有 USB 集线器驱动使用这个 ioctl, 因为没有其他的真实需要对于任何其他 USB 驱动要使用.
mount -t usbfs none /proc/bus/usb

int (*suspend) (struct usb_interface *intf, u32 state)
    指向 USB 驱动中的悬挂函数的指针. 当设备要被 USB 核心悬挂时被调用.
int (*resume) (struct usb_interface *intf)
    指向 USB 驱动中的恢复函数的指针. 当设备正被 USB 核心恢复时被调用.
为注册 struct usb_driver 到 USB 核心, 一个调用 usb_register_driver 带一个指向 struct usb_driver 的指针. 
传统上在 USB 驱动的模块初始化代码做这个:
static int __init usb_skel_init(void)
{
        int result;
        /* register this driver with the USB subsystem */
        result = usb_register(&skel_driver);
        if (result)
                err("usb_register failed. Error number %d", result);
        return result;
}
当 USB 驱动被卸载, struct usb_driver 需要从内核注销. 使用对 usb_deregister_driver 的调用做这个. 
当这个调用发生, 任何当前绑定到这个驱动的 USB 接口被去连接, 并且去连接函数为它们而被调用.
static void __exit usb_skel_exit(void)
{
        /* deregister this driver with the USB subsystem */
        usb_deregister(&skel_driver);
}

}

usb(探测和断开的细节:usb-skeleton.c){
1. 探测和去连接函数回调都在 USB 集线器内核线程上下文中被调用, 因此它们中睡眠是合法的. 但是, 
建议如果有可能大部分工作应当在设备被用户打开时完成. 为了保持 USB 探测时间为最小. 这是因为 
USB 核心处理 USB 设备的添加和去除在一个线程中, 因此任何慢设备驱动可导致 USB 设备探测时间慢
下来并且用户可注意到.

2. 在探测函数回调中, USB 驱动应当初始化任何它可能使用来管理 USB 设备的本地结构. 它还应当保存
任何它需要的关于设备的信息到本地结构, 因为在此时做这些通常更容易. 作为一个例子, USB 驱动常常
想为设备探测端点地址和缓冲大小是什么, 因为和设备通讯需要它们.
}

usb(提交和控制一个urb:usb-skeleton.c){
1. 当驱动有数据发送到 USB 设备(如同在驱动的 write 函数中发生的), 一个 urb 必须被分配来传送数据到设备.
urb = usb_alloc_urb(0, GFP_KERNEL);
if (!urb)
{
    retval = -ENOMEM;
    goto error;
}

2. 应当数据被正确地从用户空间拷贝到本地缓冲, urb 在它可被提交给 USB 核心之前必须被正确初始化:
/* initialize the urb properly */
usb_fill_bulk_urb(urb, dev->udev,
                  usb_sndbulkpipe(dev->udev, dev->bulk_out_endpointAddr),
                  buf, count, skel_write_bulk_callback, dev);
urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

3. 现在 urb 被正确分配, 数据被正确拷贝, 并且 urb 被正确初始化, 它可被提交给 USB 核心来传递给设备.
/* send the data out the bulk port */
retval = usb_submit_urb(urb, GFP_KERNEL);
if (retval)
{
    err("%s - failed submitting write urb, error %d", __FUNCTION__, retval);
    goto error;
}

4. 在urb被成功传递到 USB 设备(或者在传输中发生了什么), urb 回调被 USB 核心调用. 在我们的例子中, 我们初始化 urb 来指向函数 skel_write_bulk_callback, 并且那就是被调用的函数:

static void skel_write_bulk_callback(struct urb *urb, struct pt_regs *regs)
{
        /* sync/async unlink faults are not errors */
        if (urb->status &&

                        !(urb->status == -ENOENT ||
                          urb->status == -ECONNRESET ||
                          urb->status == -ESHUTDOWN)){
                dbg("%s - nonzero write bulk status received: %d",
                    __FUNCTION__, urb->status);
        }

        /* free up our allocated buffer */
        usb_buffer_free(urb->dev, urb->transfer_buffer_length,
                        urb->transfer_buffer, urb->transfer_dma);
}

回调函数做的第一件事是检查 urb 的状态来决定是否这个 urb 成功完成或没有. 错误值, -ENOENT, -ECONNRESET, 和
 -ESHUTDOWN 不是真正的传送错误, 只是报告伴随成功传送的情况. (见 urb 的可能错误的列表, 在"结构 struct urb"
 一节中详细列出). 接着这个回调释放安排给这个 urb 传送的已分配的缓冲.

在 urb 的回调函数在运行时另一个 urb 被提交给设备是普遍的. 当流数据到设备时是有用的. 记住 urb 回调是在中断
上下文运行, 因此它不应当做任何内存分配, 持有任何旗标, 或者任何可导致进程睡眠的事情. 当从回调中提交 urb, 
使用 GFP_ATOMIC 标志来告知 USB 核心不要睡眠, 如果它需要分配新内存块在提交过程中.
}


usb(使用 USB 数据函数){
USB 核心中的几个帮忙函数可用来从所有的 USB 设备中存取标准信息. 这些函数不能从中断上下文或者持有自旋锁时调用.

函数 usb_get_descriptor 获取指定的 USB 描述符从特定的设备. 这个函数被定义为:
int usb_get_descriptor(struct usb_device *dev, unsigned char type, unsigned char index, void *buf, int size);

这个函数可被一个 USB 驱动用来从 struct usb_device 结构中, 获取任何还没有在 struct usb_device 和 struct usb_interface 结构中出现的设备描述符, 例如声音描述符或者其他类的特定消息. 这个函数的参数是:

struct usb_device *usb_dev

    指向应当从中获取描述符的 USB 设备的指针
unsigned char type

    描述符类型. 这个类型在 USB 规范中描述, 并且是下列类型之一:

    USB_DT_DEVICE USB_DT_CONFIG USB_DT_STRING USB_DT_INTERFACE USB_DT_ENDPOINT USB_DT_DEVICE_QUALIFIER USB_DT_OTHER_SPEED_CONFIG USB_DT_INTERFACE_POWER USB_DT_OTG USB_DT_DEBUG USB_DT_INTERFACE_ASSOCIATION USB_DT_CS_DEVICE USB_DT_CS_CONFIG USB_DT_CS_STRING USB_DT_CS_INTERFACE USB_DT_CS_ENDPOINT
unsigned char index

    应当从设备获取的描述符的数目.
void *buf

    你拷贝描述符到的缓冲的指针.
int size

    由 buf 变量指向的内存的大小.

如果这个函数成功, 它返回从设备读取的字节数, 否则, 它返回由它所调用的底层函数 usb_control_msg 所返回的一个负错误值.

usb_get_descripter 调用的一项最普遍的用法是从 USB 设备获取一个字符串. 因为这个是非常普遍, 有一个帮忙函数称为 usb_get_string:

int usb_get_string(struct usb_device *dev, unsigned short langid, unsigned char index, void *buf, int size);

如果成功, 这个函数返回设备收到的给这个字符串的字节数. 否则, 它返回一个由这个函数调用的底层函数 usb_control_msg 返回的负错误值.

如果这个函数成功, 它返回一个以 UTF-16LE 格式编码的字符串(Unicode, 16位每字符, 小端字节序)在 buf 参数指向的缓冲中. 因为这个格式不是非常有用, 有另一个函数, 称为 usb_string, 它返回一个从一个 USB 设备读来的字符串, 并且已经转换为一个 ISO 8859-1 格式字符串. 这个字符集是一个 8 位的 UICODE 的子集, 并且是最普遍的英文和其他西欧字符串格式. 因为这是 USB 设备的字符串的典型格式, 建议 usb_string 函数来替代 usb_get_string 函数.

}
usb(/proc/bus/usb/devices){

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 2
B:  Alloc=  0/800 us ( 0%), #Int=  3, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.32-279.el6.x86_64 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T---topology，表示的是拓扑结构上的意思。
    Bus：是其所在的usb总线号，一个总线号会对应一个rootHub，并且一个总线号对应的设备总数<=127，这是倒不是因为电气特性限制，而是因为USB规范中规定用7bit寻址设备，第八个bit用于标识数据流向。00就是0号总线。
    Lev：该设备所在层，这个Lev信息看图最明显了。
    Prnt：parent Devicenumber父设备的ID号，rootHUb没有父设备，该值等于零，其它的设备的父设备一定指向一个hub。
    port：该设备连接的端口号，这里指的端口号是下行端口号，并且一个hub通常下行端口号有多个，上行端口号只有一个。
    Cnt：这个Lev上设备的总数，hub也会计数在内，hub也是usb设备，其是主机控制器和usb设备通信的桥梁。
    Dev：是设备号，按顺序排列的，一个总线上最多挂127个；可以有多个总线。
    spd：设备的速率，12M（1.1）、480M（2.0）等。
    MxCh：最多挂接的子设备个数，这个数值通常对应于HuB的下行端口号个数。
B---Band width
    Alloc:该总线分配得到的带宽
    Int：中断请求数
    ISO：同步传输请求数，USB有四大传输，中断、控制、批量和同步。
D--Device Descriptor 设备描述符。
    Ver：设备USB版本号。
    Cls：设备的类（hub的类是9），
    sub：设备的子类
    Prot：设备的协议
    MxPS：default 端点的最大packet size
    Cfgs： 配置的个数；USB里共有四大描述符，它们是设备描述符、端点描述符、接口描述符和配置描述符。
P---设备信息
    Vendor： 厂商ID，Linuxfoundation的ID是1d6b，http://www.Linux-usb.org/usb.ids
    Rev： 校订版本号
S---Manufacturer
S---产品
S---序列号
C---*配置描述信息
    #Ifs：接口的数量，
    Atr：属性
    MxPwr：最大功耗，USB设备供电有两种方式，self-powered和bus-powered两种方式，驱动代码会判断设备标志寄存器是否过流的。最大500mA。
    I--描述接口的接口描述符
    If#：接口号
    Alt：接口属性
    #EPs：接口具有的端点数量，端点零必须存在，在USB设备addressed之前，会使用该端口配置设备。
    Cls：接口的类
    Sub：接口的子类
    Prot：接口的协议
    Driver：驱动的名称。
E---端点描述符
    Ad(s)：端点地址,括号的s为I或者O表示该端点是输入还是输出端点。
    Atr（sss）：端点的属性，sss是端点的类型，对应上述的四大传输类型。
    MxPS：端点具有的最大传输包
    Ivl：传输间的间隔。
}