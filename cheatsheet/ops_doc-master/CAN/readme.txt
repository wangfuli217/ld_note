就底层协议而言，数据帧、控制帧、错误帧、过载帧、帧间隔是由CAN控制器自动实现，还是由内核实现。
如果内核实现，那么能否通过接口发送和接口
如果CAN控制器实现，那么能否通过内核控制CAN控制器发送和接收？
  === socketCAN可以接收数据帧、遥控帧和错误帧，socketCAN能够发送数据帧和遥控帧。过载帧和帧间隔由底层自动实现。
  === 基于can设备编程的时候，由应用程序控制数据帧、遥控帧、错误帧和过载帧、帧间隔的收发，控制can协议要求实现的内容。

通过Socket CAN可以接收数据帧、遥控帧和错误帧? === 是的
通过访问串口设备方式，数据帧、控制帧、错误帧和过载帧、帧间隔的处理都有用户态实现。 === 是的

仲裁段中can id和RTU设备中板卡位置信息的对应关系？值越小优先级越高，还是值越大优先级越高？ === ID数值越小，报文优先级越高。
CAN_RAW和CAN_BCM之间的关系？

当处于逻辑1，CAN_High和CAN_Low的电压差小于0.5V时，称为隐性电平(Recessive)；
当处于逻辑0，CAN_High和CAN_Low的电压差大于0.9V，称为显性电平(Dominant)。
    CAN总线遵从线与机制：“显性”位可以覆盖“隐性”位；只有所有节点都发送“隐性”位， 
总线才处于“隐性” 状态。这种“线与”机制使CAN总线呈现显性优先的特性。

    简洁的物理层决定了CAN必然要配上一套更为复杂的协议。
如何用一个信号通道实现同样甚至更强大的功能，答案就是对数据或操作命令进行打包。
  多主机（Multi-Master）: 消息的发送不必遵从任何预先设定的时序，通信是事件驱动的。
  寻址机制              : 通过消息的标识符(Identifier)来区别消息。
  总线访问CSMA/CD+AMP   ： 多路载波侦听+基于消息优先级的冲突检测和非破坏性的仲裁机制(CSMA/CD+AMP)。
    CSMA(Carrie Sense Multiple Access)指的是所有节点必须都等到总线处于空闲状态时才能往总线上发送消息
    CD+AMP(Collision Detection + Arbitration on Message Priority)指的是如果多个节点往总线上发送消息时，具备最高优先级的消息获得总线。
    多路载波侦听：若网络上有数据，暂时不发送数据，等待网络空闲时再发；           若网络上无数据，立即发送已经准备好的数据。
    冲突检测：节点在发送数据时，要不停的检测发送的数据，确定是否与其他节点数据发送冲突，如果有冲突，则保证优先级高的报文先发送。（CD+AMP）
    非破坏性仲裁机制：通过ID仲裁，ID数值越小，报文优先级越高。
      发送低优先级报文的节点退出仲裁后，在下次总线空闲时自动重发报文。
      高优先级的报文不能中断低优先级报文的发送.
      

# RAW 默认功能
- filter将会接收所有的数据
- 套接字仅仅接收有效的数据帧（=> no error frames）
- 发送帧的回环功能被开启（参见 3.2节）
- （回环模式下）套接字不接收它自己发送的帧

# https://blog.csdn.net/zhangxiaopeng0829/article/details/7646639
linux-can-program.txt can接口管理和收发数据，日志管理相关工具，包括cangw网关(转发数据)
1. ip命令(ip link set can0 type can help)，/proc/net/can/rcvlist_all /proc/net/can can.ko vcan.ko虚拟can总线，
2. can-utils(lib.c lib.h  CL_CFSZ ) struct msghdr msg;与对应的setopt命令(SO_TIMESTAMPING SO_TIMESTAMP)
3. candump canplayer cangen cansend asc2log log2asc log2long 命令
4. ioctl(SIOCGIFINDEX | SIOCGIFNAME) IFNAMSIZ 


# can总线部分设计
关键字: can接口名  canid和mask(数据帧过滤)   error_mask(错误帧过滤)

1. 业务数据  业务日志(业务数据发送和业务数据接收) 业务数据由多个 canfd_frame(can数据包)组成。 --- 无连接，失败之后刷新缓冲区即可
   poll的发送和poll的接收。 
   xxx_serve(根据read和write返回值，调用xxx_read和xxx_write)  xxx_read和xxx_write中实现日志功能?
   xxx_desc(根据业务数据注册read和write信息)  ---- 任务(任务如何区分? 不同板卡的多个相同请求? 相同板卡的多个相同或不同请求? )
   1.1 超时: 多长时间没有回应即判定插槽上没有板卡 (任务不同，超时时间可能不同；未结束的任务请求对后续请求的影响) 由板卡周期性发送保活报文。
   1.2 优先级: 周期性任务、定期性任务、事件(任务)触发任务、网管请求任务？
   1.3 插槽业务: 是否存在插槽上板卡长时间不能响应业务请求(该类型任务与网管主站之间关系: 将底层心跳转发给网管主站 -- 时间不定；或者 超时上报 -- 超时计算)
   1.4 周期性任务的周期为多久?  是否存在mcu异常任务?  周期性任务一个8字节的心跳数据包应该就可以了。
关键任务:网管请求任务和异常(正常)上报任务需要记录 -- notice级别打印，周期性任务debug级别打印。
         mcu与板卡之间任务记录                    -- notice级别打印，周期性任务debug级别打印。
         存放到持久文件系统(error和notice)  或者 存放到临时文件系统(error、notice和debug)
         日志的轮转和日志的时间
         
    程序配置文件
    板卡和mcu卡自身配置文件
         
2. candump中-l指定日志文件(asc2log log2asc log2long canreplayer) 用于分析can总线日志  lib.c
# 日志解析 (fprint_canframe 和 sprint_canframe)  -- canplayer cansend log2asc log2long
int parse_canframe(char *cs, struct canfd_frame *cf);
# 日志输出
void fprint_canframe(FILE *stream , struct canfd_frame *cf, char *eol, int sep, int maxdlen);
void sprint_canframe(char *buf , struct canfd_frame *cf, int sep, int maxdlen);
# 支持view
void fprint_long_canframe(FILE *stream , struct canfd_frame *cf, char *eol, int view, int maxdlen);
void sprint_long_canframe(char *buf , struct canfd_frame *cf, int view, int maxdlen);
# 错误帧
void snprintf_can_error_frame(char *buf, size_t len, const struct canfd_frame *cf,const char *sep);

candump中日志输出形式 可以被canplayer log2asc log2long解析

2.1 交叉记录read和write还是 read一个文件|write一个文件。
2.2 日志放在/var/log/内存中(多少个记录反转，多少个文件覆盖)， /var/log/message放在内存中。

3. 关键字部分: 配置文件中指定can接口名 canid和mask(数据帧过滤) error_mask(错误帧过滤)

gpio口管理模块，
网口管理模块，

https://search.chongbuluo.com/  -- 快速查找

https://blog.csdn.net/lizhu_csdn/article/details/51490958  # CAN 编程说明+Demo

由于CAN总线是双主模式，功能性板卡那些状态可以主动上报给MCU板，然后转发给网管主站？
阎琪琳拷贝给我，或者网上下载的工具 私下学习下？ ---- 在CentOS没有编译通过，

OSPF的状态(华为ppt) 对状态机的处理 指的学习。

------------ CAN 总线使用UDP方式通信，拥有过滤功能 ------ 数据长度受限，一个报文只有8个字节的最大长度。给上层处理很大负担
1. CAN 接口编程是TCP方式那种? 插入槽位板卡通过TCP连接连接到MCU板，那么，
1.1 MCU进程启动之后就需要设定板卡连接超时时间段，即MCU启动之后多久，可以上报插入板卡基本信息。
1.2 协议层面依赖心跳报文维护板卡状态(在线|下线)，还是通过底层TCP似得心跳报文实现(TCP重连有2分钟)，

2. CAN 接口编程是UDP方式那种？插入槽位板卡通过UDP连接到MCU板，那么
2.1 MCU 和 板卡的请求应答超时时间为多久? 对于接地和电阻测试而言，有无问题? 


控制板卡重启和烧入序列号问题?
控制电源，使得整台设备重新启动的功能?

希望《rtud设计拓展.txt》能给我更多设计拓展。         侧重程序设计

系统《需求跟踪.txt》 能避免RTU设计中存在的若干遗憾。 侧重需求拓展

支持升级: qt版本界面设计，mcu进程升级，其他板卡升级。

版本问题: svn版本: 编译时间版本: 对外系统版本。

关于协议: CAN总线协议(数据帧 遥控帧 错误帧 过载帧和帧间隔)
帧起始 仲裁段 控制段 数据段 CRC段 ACK段 帧结束
错误帧: 位错误 ACK错误 填充错误 CRC错误和格式错误
        主动错误状态 被动错误状态 总关闭状态

RTU串口协议:  起始标志 地址标志 类型标志 命令标志 数据 CRC 结束标志
              错误: 长度错误 起始标识|地址标识|类型标识|结束标识错误 CRC错误
              对于发现的错误忽略掉，没有关闭串口、重新打开串口的操作。

网络TCP协议： 命令类型 数据长度 数据内容
              错误: 命令类型错误 长度错误 协议格式错误 协议内容错误(插槽位置，板卡类型，接口个数)
              发生任何错误都主动关闭TCP连接，等待新的TCP连接
              
OTDR协议:     命令字符串 命令参数
              错误: 查询错误 命令错误 状态错误 设置错误 文件错误 保留 设备错误
              发生任何错误都主动关闭TCP连接，发起新的TCP连接；
              再不行，通知重启OTDR板卡
              
https://github.com/linux-can/  -- 开始学习，还没有很熟悉


ioctl(s,SIOCGIFINDEX,&ifr); 和 ioctl(s,SIOCGIFNAME,&ifr); 实现ifindex 和 ifname之间的转换， 前者用于bind,后者用于recvfrom
struct sockaddr_can addr;   用于将socket绑定到特定的接口上，如果ifindex等于0，在表示不绑定任何借口，此时发送使用sendto接口使用recvfrom
struct can_frame;           指定can id和发送缓冲区。将数据发送给对应can id.

标准帧: can_id 的低 11 位
扩展帧: can_id 的低 11 + 18 位

can_id 的第 29、 30、 31 位是帧的标志位，用来定义帧的类型
#define CAN_EFF_FLAG 0x80000000U //扩展帧的标识 
#define CAN_RTR_FLAG 0x40000000U //远程帧的标识 
#define CAN_ERR_FLAG 0x20000000U //错误帧的标识，用于错误检查


# 如果要发送远程帧(标识符为 0x123)
struct can_frame frame; 
frame.can_id = CAN_RTR_FLAG | 0x123; 
write(s, &frame, sizeof(frame));

# 错误(帧)处理
当帧接收后，可以通过判断 can_id 中的 CAN_ERR_FLAG 位来判断接收的帧是否为错误帧。 
如果为错误帧，可以通过 can_id 的其他符号位来判断错误的具体原因。

# 数据帧过滤规则
1. 接收到的数据帧的 can_id & mask == can_id & mask
2. 在 can_filter 结构的 can_id 中，符号位 CAN_INV_FILTER 在置位时可以实现 can_id 在执行过滤前的位反转。
3. 如果应用程序不需要接收报文，可以禁用过滤规则。
   setsockopt(s, SOL_CAN_RAW, CAN_RAW_FILTER, NULL, 0);  原始套接字就会忽略所有接收到的报文
   
   0~0
    rfilter[numfilter].can_id |= CAN_INV_FILTER;
    rfilter[numfilter].can_mask &= ~CAN_ERR_FLAG;
    if (*(ptr+8) == '~')
        rfilter[numfilter].can_id |= CAN_EFF_FLAG;
   0:0
    rfilter[numfilter].can_mask &= ~CAN_ERR_FLAG;
    if (*(ptr+8) == ':')
        rfilter[numfilter].can_id |= CAN_EFF_FLAG;

# 错误帧过滤规则
1. 通过错误掩码可以实现对错误帧的过滤
can_err_mask_t err_mask = ( CAN_ERR_TX_TIMEOUT | CAN_ERR_BUSOFF );
setsockopt(s, SOL_CAN_RAW, CAN_RAW_ERR_FILTER, err_mask, sizeof(err_mask));

   #FFFFFFFF
    setsockopt(s[i], SOL_CAN_RAW, CAN_RAW_ERR_FILTER,  &err_mask, sizeof(err_mask));


# 回环功能设置 -- 当前不需要回环功能
在默认情况下， 本地回环功能是开启的，可以使用下面的方法关闭回环/开启功能：
int loopback = 0; // 0 表示关闭, 1 表示开启( 默认)
setsockopt(s, SOL_CAN_RAW, CAN_RAW_LOOPBACK, &loopback, sizeof(loopback));
在本地回环功能开启的情况下，所有的发送帧都会被回环到与 CAN 总线接口对应的套接字上。
默认情况下，发送 CAN 报文的套接字不想接收自己发送的报文，因此发送套接字上的回环功能是关闭的。

可以在需要的时候改变这一默认行为：
int ro = 1; // 0 表示关闭( 默认), 1 表示开启
setsockopt(s, SOL_CAN_RAW, CAN_RAW_RECV_OWN_MSGS, &ro, sizeof(ro));



IFNAMSIZ PF_CAN, SOCK_RAW, CAN_RAW， SIOCGIFINDEX SIOCGIFNAME

 










