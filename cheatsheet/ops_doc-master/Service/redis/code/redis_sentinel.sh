1. sentinel哨岗是redis的高可用性解决方案：有一个或多个Sentinel组成的Sentinel系统可以监视任意多个主服务器以及这些主服务器
   属下的所有从服务器，并在被监视的主服务器进入下线状态时，自动将下线主服务器属下的从服务器升级为新的主服务器。
   然后由新的主服务器代替已下线的主服务器继续处理命令请求。
2. redis-sentinel /path/to/your/sentine.conf 
   redis-server /path/to/your/sentine.conf  --sentinel
   2.1 初始化服务器
   2.2 将普通Redis服务器使用的代码转换成Sentinel专用代码
   2.3 初始化Sentinel状态
   2.4 根据给定的配置文件，出初始化Sentinel的监视主服务器列表
   2.5 创建连向主服务器的网络连接。
   
                     功能                         使用情况
数据库和键值对方面的命令，比如SET、DEL、FLUSHDB   不使用
事务命令比如MULTI和WATCH                          不使用
脚本命令，比如EVAL                                不使用
RDB持久化命令 SAVE BGSAVE                         不使用
AOF持久化命令 BGREWRITEAOF                        不使用
复制命令 SLAVEOF                                   Sentinel内部使用，但客户端不可以使用
发布与订阅命令 PUBLISH和SUBSCRIBE                 SUBSCRIBE\PSUBSCRIBE\UNSUBSCRIBE\PUBSUBSCRIBE四个命令在Sentinel内部和客户端都
                                                  可以使用，但是PUBLISH命令只能在Sentinel内部使用
文件事件处理器                                    Sentinel内部使用，但关联的文件事件处理器和普通Redis服务器不同
时间事件处理器                                    Sentinel内部使用，时间事件的处理器仍然是ServerCron函数，ServerCron函数会调用
                                                   sentinel.c/sentinelTimer函数，后者包含了Sentinel要执行的所有操作。


redis.h/REDIS_SERVERPORT
#define REDIS_SERVERPORT 6379
sentinel.c/REDIS_SENTINEL_PORT
#define REDIS_SENTINEL_PORT 26379

redisserver使用redis.c/redisCommandTable
redis-sentinel使用sentinel.c/sentinelcmds

/* Sentinel 的状态结构 */
struct sentinelState {

    // 当前纪元，用于实现故障转移
    uint64_t current_epoch;     /* Current epoch. */

    // 保存了所有被这个 sentinel 监视的主服务器
    // 字典的键是主服务器的名字
    // 字典的值则是一个指向 sentinelRedisInstance 结构的指针
    dict *masters;      

    // 是否进入了 TILT 模式？
    int tilt;       

    // 目前正在执行的脚本的数量
    int running_scripts;    

    // 进入 TILT 模式的时间
    mstime_t tilt_start_time;   

    // 最后一次执行时间处理器的时间
    mstime_t previous_time;     
    
    // 一个 FIFO 队列，包含了所有需要执行的用户脚本
    list *scripts_queue;   

} sentinel;     

<1> masters字典记录了所有被sentinel监视的主服务器的相关信息：
1. 字典的键是被监视主服务器的名字
2. 而字典的值则是被监视主服务器对应的sentinel.c/sentinelRedisInstance结构。
每个sentinelRedisInstance结构代表一个被Sentinel监视的redis服务器实例，这个实例可以使主服务器、从服务器或者另外一个Sentinel.

// Sentinel 会为每个被监视的 Redis 实例创建相应的 sentinelRedisInstance 实例
// （被监视的实例可以是主服务器、从服务器、或者其他 Sentinel ）
typedef struct sentinelRedisInstance {
    
    // 标识值，记录了实例的类型，以及该实例的当前状态
    int flags; 
    
    // 实例的名字
    // 主服务器的名字由用户在配置文件中设置
    // 从服务器以及 Sentinel 的名字由 Sentinel 自动设置
    // 格式为 ip:port ，例如 "127.0.0.1:26379"
    char *name;

    // 实例的运行 ID
    char *runid;  

    // 配置纪元，用于实现故障转移
    uint64_t config_epoch; 

    // 实例的地址
    sentinelAddr *addr; 

    // 用于发送命令的异步连接
    redisAsyncContext *cc; 

    // 用于执行 SUBSCRIBE 命令、接收频道信息的异步连接
    // 仅在实例为主服务器时使用
    redisAsyncContext *pc; 

    // 已发送但尚未回复的命令数量
    int pending_commands;  

    // cc 连接的创建时间
    mstime_t cc_conn_time; 
    
    // pc 连接的创建时间
    mstime_t pc_conn_time; 

    // 最后一次从这个实例接收信息的时间
    mstime_t pc_last_activity; 

    // 实例最后一次返回正确的 PING 命令回复的时间
    mstime_t last_avail_time; 
    
    // 实例最后一次发送 PING 命令的时间
    mstime_t last_ping_time;  
    // 实例最后一次返回 PING 命令的时间，无论内容正确与否
    mstime_t last_pong_time;  

    // 最后一次向频道发送问候信息的时间
    // 只在当前实例为 sentinel 时使用
    mstime_t last_pub_time;   

    // 最后一次接收到这个 sentinel 发来的问候信息的时间
    // 只在当前实例为 sentinel 时使用
    mstime_t last_hello_time; 

    // 最后一次回复 SENTINEL is-master-down-by-addr 命令的时间
    // 只在当前实例为 sentinel 时使用
    mstime_t last_master_down_reply_time; 

    // 实例被判断为 SDOWN 状态的时间
    mstime_t s_down_since_time; 

    // 实例被判断为 ODOWN 状态的时间
    mstime_t o_down_since_time; 

    // SENTINEL down-after-milliseconds 选项所设定的值
    // 实例无响应多少毫秒之后才会被判断为主观下线（subjectively down）
    mstime_t down_after_period; 

    // 从实例获取 INFO 命令的回复的时间
    mstime_t info_refresh; 

    // 实例的角色
    int role_reported;
    // 角色的更新时间
    mstime_t role_reported_time;

    // 最后一次从服务器的主服务器地址变更的时间
    mstime_t slave_conf_change_time; 

   
    /* 主服务器实例特有的属性 -------------------------------------------------------------*/

    // 其他同样监控这个主服务器的所有 sentinel
    dict *sentinels;    

    // 如果这个实例代表的是一个主服务器
    // 那么这个字典保存着主服务器属下的从服务器
    // 字典的键是从服务器的名字，字典的值是从服务器对应的 sentinelRedisInstance 结构
    dict *slaves;       

    // SENTINEL monitor <master-name> <IP> <port> <quorum> 选项中的 quorum 参数
    // 判断这个实例为客观下线（objectively down）所需的支持投票数量
    int quorum;        

    // SENTINEL parallel-syncs <master-name> <number> 选项的值
    // 在执行故障转移操作时，可以同时对新的主服务器进行同步的从服务器数量
    int parallel_syncs; 

    // 连接主服务器和从服务器所需的密码
    char *auth_pass;   

    /* 从服务器实例特有的属性 -------------------------------------------------------------*/

    // 主从服务器连接断开的时间
    mstime_t master_link_down_time; 

    // 从服务器优先级
    int slave_priority; 

    // 执行故障转移操作时，从服务器发送 SLAVEOF <new-master> 命令的时间
    mstime_t slave_reconf_sent_time; 

    // 主服务器的实例（在本实例为从服务器时使用）
    struct sentinelRedisInstance *master; 

    // INFO 命令的回复中记录的主服务器 IP
    char *slave_master_host;    
    
    // INFO 命令的回复中记录的主服务器端口号
    int slave_master_port;      

    // INFO 命令的回复中记录的主从服务器连接状态
    int slave_master_link_status;

    // 从服务器的复制偏移量
    unsigned long long slave_repl_offset; 

    /* Failover */
    /* 故障转移相关属性 -------------------------------------------------------------------*/


    // 如果这是一个主服务器实例，那么 leader 将是负责进行故障转移的 Sentinel 的运行 ID 。
    // 如果这是一个 Sentinel 实例，那么 leader 就是被选举出来的领头 Sentinel 。
    // 这个域只在 Sentinel 实例的 flags 属性的 SRI_MASTER_DOWN 标志处于打开状态时才有效。
    char *leader;      
    
    // 领头的纪元
    uint64_t leader_epoch; 
    // 当前执行中的故障转移的纪元
    uint64_t failover_epoch; 
    // 故障转移操作的当前状态
    int failover_state;

    // 状态改变的时间
    mstime_t failover_state_change_time;

    // 最后一次进行故障迁移的时间
    mstime_t failover_start_time;   

    // SENTINEL failover-timeout <master-name> <ms> 选项的值
    // 刷新故障迁移状态的最大时限
    mstime_t failover_timeout;      

    mstime_t failover_delay_logged; 
    // 指向被提升为新主服务器的从服务器的指针
    struct sentinelRedisInstance *promoted_slave; 

    
    // 一个文件路径，保存着 WARNING 级别的事件发生时执行的，
    // 用于通知管理员的脚本的地址
    char *notification_script;

    // 一个文件路径，保存着故障转移执行之前、之后、或者被中止时，
    // 需要执行的脚本的地址
    char *client_reconfig_script;

} sentinelRedisInstance;

创建连向主服务器的网络连接：
Sentinel将成为主服务器的客户端，它可以向主服务器发送命令，并从命令回复中获取相关的信息。
对于每个被sentinel监视的主服务器来说，Sentinel会创建两个连向主服务器的异步网络连接：
1. 一个是命令连接，这个连接专门用于向主服务器发送命令，并接收命令回复。
2. 另一个用于订阅连接，这个连接专门用于订阅主服务器的__sentinel__:hello频道。

<2> 获取主服务器信息
sentinel默认会以每10秒1次的频率，通过命令连接向被监视的主服务器发送INFO命令，并通过分析INFO命令的回复来获取主服务器的当前信息。
1. 关于主服务器本身的信息，包括run_id域记录的服务器运行ID，以及role域记录的服务器角色。
2. 关于主服务器属下所有从服务器的信息。

<3> 获取从服务器信息
当sentinel发现主服务器有新的从服务器出现时，sentinel除了会为这个新的从服务器创建相应的实例结构之外，sentinel还会创建连接
到从服务器的命令连接和订阅连接。
1. 从服务器的运行ID run_id
2. 从服务器的角色role
3. 主服务器的IP地址master_host，以及主服务器的端口号master_port
4. 主从服务器的连接状态master_link_status
5. 从服务器的优先级slave_priority
6. 从服务器的复制偏移量slave_repl_offset

<4> 向主服务器和从服务器发送信息
PUBLISH __sentinel__:hello "<s_ip>,<s_port>,<s_runid>,<s_epoch>,<m_name>,<m_ip>,<m_port>,<m_epoch>"
如果sentinel正在监视的是主服务器，那么这些参数记录的就是主服务器的信息；
如果sentinel正在监视的是从服务器，那么这些参数记录的就是从服务器正在复制的主服务器的信息。
s_ip      sentinel的IP地址
s_port    sentinel的端口号
s_runid   sentinel的运行ID
s_epoch   sentinel当前的配置纪元
m_name    主服务器的名字
m_ip      主服务器的IP地址
m_port    主服务器的端口号
m_epoch   主服务器当前的配置纪元

<5> 接收来自主服务器和从服务器的频道信息
当sentinel与一个主服务器或者从服务器建立起订阅连接之后，sentinel就会通过订阅连接，向服务器发送以下命令：
SUBSCRIBE __sentinel__:hello
sentinel对__sentinel__:hello频道的订阅会一直持续到sentinel与服务器的连接断开位置。
这就是说：对于每个与sentinel连接的服务器，sentinel既通过命令连接向服务器的__sentinel__:hello频道发送信息，有通过订阅连接从
服务器__sentinel__:hello频道接收消息。

对于监视同一个服务器的多个sentinel来说，一个sentinel发送的信息会被其他sentinel接收到，这些信息会被用于更新其他sentinel
对发送信息sentinel的认知，也会被用于更新其他sentinel对被监视服务器的认知。

<6> 更新sentinels字典
sentinel为主服务器创建的实例结构中的sentinels字典保存了除sentinel本身之外，所有同样监视这个主服务器的其他sentinels的资料。

<7> 创建连向其他sentinel的命令连接
当sentinel通过频道信息发现一个新的sentinel时，它不仅会为新的sentinel在sentinels字典中创建相应的实例结构，还会创建一个连向新
sentinel的命令连接，而新的sentinel也同样会创建连向这个sentinel的命令连接，最终监视同一主服务器的多个sentinel将形成互相连接
的网络：sentinel A有连向Sentinel B的命令连接，而Sentinel B也有连向Sentinel A的命令连接。

sentinel之间不会创建订阅连接。
sentinel -> sentinel master slave 
  PING         PONG LOADING MASTERDOWN      有效回复
               PONG LOADING MASTERDOWN之外  无效回复

down-after-milliseconds:指定了sentinel判断实例进入主观下线所需的时间长度：
用户设置的 down-after-milliseconds的值，不仅会被sentinel用来判断主服务器的主观下线状态，还会被用于判断主服务器属下的所有从服务器，以及所有同样
监视这个主服务器的其他sentinel的主观下线状态。
sentinel monitor master 127.0.0.1 6379 2
sentinel down-after-milliseconds master 50000

<8> 多个sentinel设置的主观下线时长可能不同  
sentinel1
sentinel monitor master 127.0.0.1 6379 2
sentinel down-after-milliseconds master 50000

sentinel2
sentinel monitor master 127.0.0.1 6379 2
sentinel down-after-milliseconds master 10000
      
<9> 检查客观下线状态
当sentinel将一个主服务器判断为主观下线之后，为了确认这个主服务器是否真的下线了，它会向同样监视这一主服务器的其他sentinel
进行查询，看他们是否也认为主服务器已经进入了下线状态。当sentienl从其他sentinel那里接收到足够数量的已下线判断之后，
sentinel就会将从服务器判断客观下线，并对主服务器执行故障转移。              
9.1 发送sentinel is-master-down-by-addr命令
SENTINEL is-master-down-by-addr <ip> <port> <current_epoch> <runid>
ip              被sentinel判断为主观下线的主服务器的IP地址
port            被sentinel判断为主观下线的主服务器的端口号
current_epoch   sentinel当前的配置纪元，用于选举领头sentinel,
runid           可以是* 或者sentinel 的运行ID：*符号代表命令仅仅 用于检查主服务器的下线状态
                而局部领头sentinel的运行ID则用于选举领头sentinel
                
9.2 接收sentinel is-master-down-by-addr命令
回复： <down_state> <leader_runid> <leader_epoch>
down_state       返回目标sentinel对主服务器的检查结果，1代表主服务器已下线，0表示主服务器未下线。
leader_runid     可以使是* 符号或者目标sentinel的局部领头sentinel的运行ID：*符号代表命令仅仅 用于检查主服务器的下线状态
                 而局部领头sentinel的运行ID则用于选举领头sentinel
leader_epoch     目标sentinel的局部领头sentinel的配置纪元，用于选举领头sentinel，仅在leader_runid的值不为*时有效，如果
                  leader_runid的值为*，那么leader_epoch总为0

9.3 接收sentinel is-master-down-by-addr命令的回复
根据其他sentinel发回的sentinel is-master-down-by-addr命令回复，sentinel将统计其他sentinel同意主服务器已下线的数量，当这一数量达到配置
指定的判断客观下下所需的数量时，sentinel会将主服务器实例结构的flags属性的SRI_O_DOWN标识打开，表示主服务器已经进入客观下线状态：

不同sentinel判断客观下线的条件可能不同。

<10> 选举领头sentinel



                  
