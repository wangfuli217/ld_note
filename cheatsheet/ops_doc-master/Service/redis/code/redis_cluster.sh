redis集群是Redis提供的分布式数据库方案，集群通过分片来进行数据共享，并提供复制和故障转移。

cluster(节点)
{
一个Redis集群通常由多个节点组成，在刚开始的时候，每个节点都是相互独立的，它们都处于一个只包含自己的集群当中，
要组建一个真正的可工作的集群，我们必须将各个独立的节点连接起来，构成一个包含多个节点的集群。
连接各个节点的工作可以使用cluster meet命令来完成，
cluster meet <ip> <port>
向一个节点node发送cluster meet命令，可以让node节点与ip和port所指定的节点进行握手，当握手成功时，node节点就会将ip和port
所指定的节点添加到node节点当前所在的集群中。
127.0.0.1:7000
127.0.0.1:7001
127.0.0.1:7002

redis-cli -c -p 7000
127.0.0.1:7000>cluster nodes 

127.0.0.1:7000>cluster meet 127.0.0.1 7001
127.0.0.1:7000>cluster nodes
127.0.0.1:7000>cluster meet 127.0.0.1 7002
127.0.0.1:7000>cluster nodes

1. 启动节点
一个节点就是一个运行在集群模式下的Redis服务器，Redis服务器在启动时会根据cluster-enabled配置选项是否为yes来判断是否开启
服务器的集群模式。

2. 集群数据结构
clusterNode保存了一个节点的当前状态，比如节点的创建时间、节点的名称、节点当前的配置纪元、节点的IP地址和端口号等等。
每个节点都会使用一个clusterNode结构来记录自己的状态，并为集群中的所有其他节点（包括主节点和从节点）都创建一二相应的
clusterNode结构，以此来记录其他节点的状态：

// 节点状态
struct clusterNode {
    // 创建节点的时间
    mstime_t ctime; 
    
    // 节点的名字，由 40 个十六进制字符组成
    // 例如 68eef66df23420a5862208ef5b1a7005b806f2ff
    char name[REDIS_CLUSTER_NAMELEN]; 

    // 节点标识
    // 使用各种不同的标识值记录节点的角色（比如主节点或者从节点），
    // 以及节点目前所处的状态（比如在线或者下线）。
    int flags;     

    // 节点当前的配置纪元，用于实现故障转移
    uint64_t configEpoch; 

    // 由这个节点负责处理的槽
    // 一共有 REDIS_CLUSTER_SLOTS / 8 个字节长
    // 每个字节的每个位记录了一个槽的保存状态
    // 位的值为 1 表示槽正由本节点处理，值为 0 则表示槽并非本节点处理
    // 比如 slots[0] 的第一个位保存了槽 0 的保存情况
    // slots[0] 的第二个位保存了槽 1 的保存情况，以此类推
    unsigned char slots[REDIS_CLUSTER_SLOTS/8]; 

    // 该节点负责处理的槽数量
    int numslots;  

    // 如果本节点是主节点，那么用这个属性记录从节点的数量
    int numslaves;  

    // 指针数组，指向各个从节点
    struct clusterNode **slaves; 

    // 如果这是一个从节点，那么指向主节点
    struct clusterNode *slaveof; 

    // 最后一次发送 PING 命令的时间
    mstime_t ping_sent;     

    // 最后一次接收 PONG 回复的时间戳
    mstime_t pong_received;  

    // 最后一次被设置为 FAIL 状态的时间
    mstime_t fail_time;    

    // 最后一次给某个从节点投票的时间
    mstime_t voted_time;     

    // 最后一次从这个节点接收到复制偏移量的时间
    mstime_t repl_offset_time;  

    // 这个节点的复制偏移量
    long long repl_offset;      

    // 节点的 IP 地址
    char ip[REDIS_IP_STR_LEN];  

    // 节点的端口号
    int port;                   

    // 保存连接节点所需的有关信息
    clusterLink *link;          

    // 一个链表，记录了所有其他节点对该节点的下线报告
    list *fail_reports;        

};
typedef struct clusterNode clusterNode;

typedef struct clusterLink {  #用于连接节点

    // 连接的创建时间
    mstime_t ctime;             

    // TCP 套接字描述符
    int fd;                     

    // 输出缓冲区，保存着等待发送给其他节点的消息（message）。
    sds sndbuf;                

    // 输入缓冲区，保存着从其他节点接收到的消息。
    sds rcvbuf;                

    // 与这个连接相关联的节点，如果没有的话就为 NULL
    struct clusterNode *node;   

} clusterLink;

typedef struct clusterState {

    // 指向当前节点的指针
    clusterNode *myself;  

    // 集群当前的配置纪元，用于实现故障转移
    uint64_t currentEpoch;

    // 集群当前的状态：是在线还是下线
    int state;           

    // 集群中至少处理着一个槽的节点的数量。
    int size;           

    // 集群节点名单（包括 myself 节点）
    // 字典的键为节点的名字，字典的值为 clusterNode 结构
    dict *nodes;         

    // 节点黑名单，用于 CLUSTER FORGET 命令
    // 防止被 FORGET 的命令重新被添加到集群里面
    // （不过现在似乎没有在使用的样子，已废弃？还是尚未实现？）
    dict *nodes_black_list; 

    // 记录要从当前节点迁移到目标节点的槽，以及迁移的目标节点
    // migrating_slots_to[i] = NULL 表示槽 i 未被迁移
    // migrating_slots_to[i] = clusterNode_A 表示槽 i 要从本节点迁移至节点 A
    clusterNode *migrating_slots_to[REDIS_CLUSTER_SLOTS];

    // 记录要从源节点迁移到本节点的槽，以及进行迁移的源节点
    // importing_slots_from[i] = NULL 表示槽 i 未进行导入
    // importing_slots_from[i] = clusterNode_A 表示正从节点 A 中导入槽 i
    clusterNode *importing_slots_from[REDIS_CLUSTER_SLOTS];

    // 负责处理各个槽的节点
    // 例如 slots[i] = clusterNode_A 表示槽 i 由节点 A 处理
    clusterNode *slots[REDIS_CLUSTER_SLOTS];

    // 跳跃表，表中以槽作为分值，键作为成员，对槽进行有序排序
    // 当需要对某些槽进行区间（range）操作时，这个跳跃表可以提供方便
    // 具体操作定义在 db.c 里面
    zskiplist *slots_to_keys;

    // 以下这些域被用于进行故障转移选举

    // 上次执行选举或者下次执行选举的时间
    mstime_t failover_auth_time; 

    // 节点获得的投票数量
    int failover_auth_count;   

    // 如果值为 1 ，表示本节点已经向其他节点发送了投票请求
    int failover_auth_sent;     

    int failover_auth_rank;     

    uint64_t failover_auth_epoch; 

    /* 共用的手动故障转移状态 */

    // 手动故障转移执行的时间限制
    mstime_t mf_end;           
                                   
    /* 主服务器的手动故障转移状态 */
    clusterNode *mf_slave;    
  
    /* 从服务器的手动故障转移状态 */
    long long mf_master_offset;
    
    // 指示手动故障转移是否可以开始的标志值
    // 值为非 0 时表示各个主服务器可以开始投票
    int mf_can_start;           

    /* 以下这些域由主服务器使用，用于记录选举时的状态 */

    // 集群最后一次进行投票的纪元
    uint64_t lastVoteEpoch;   

    // 在进入下个事件循环之前要做的事情，以各个 flag 来记录
    int todo_before_sleep; 

    // 通过 cluster 连接发送的消息数量
    long long stats_bus_messages_sent;  

    // 通过 cluster 接收到的消息数量
    long long stats_bus_messages_received;

} clusterState;

}

cluster(槽指派)
{
redis集群通过分片的方式来保存数据库中的键值对，集群的整个数据库被分为16384个槽，数据库中的每个键都属于16384个槽的
其中一个，集群中的每个节点可以处理0或最多16384个槽。
当数据库中的16384个槽都有节点在处理时，集群处于上线状态；相反地，如果数据库中有任何一个槽没有得到处理，那么集群处于
下线状态。

cluster addslots <slot> [slot ...]
127.0.0.1:7000>cluster addslots 0 1 2 3 4 ... 5000
127.0.0.1:7001>cluster addslots 5001 5002 5003 5004 ... 10000
127.0.0.1:7001>cluster addslots 10001 1000 10003 10004 ... 16383

clusterNode结构中的
unsigned char slots[16384/8];
int numslots;

传播节点的槽指派信息
一个节点处理会将自己负责处理的槽记录在clusterNode结构的slots属性和numslots属性之外，它还会将自己的slots数组通过消息发送给集群中的其他节点、
以此来告知其他节点自己目前负责处理那些槽。

记录集群所有槽的指派信息
clusterState结构中的
clusterNode *slots[16384];



}

cluster(在集群中执行命令)
{
当客户端向节点发送与数据库键有关的命令时，接收命令的节点会计算出命令要处理的数据库键属于哪个槽，并检查这个槽是否指派给了自己。
1.如果键所在的草正好就指派给了当前节点，那么节点直接执行这个命令
2.如果键所在的槽没有指派给当前节点，那么节点会向客户端返回一个MOVED错误，指引客户端转向至正确的节点，并再次发送之前想要
  执行的命令。

127.0.0.1:7001>cluster keyslot "date"

集群模式：
redis-cli -c -p 7000
单机模式：
redis-cli -p 7000
  
}

cluster(重新分片)
{
1. redis集群的重新分片操作可以将任意数量已经指派给某个节点的槽改为指派给另一个节点，并且相关槽所属的键值对也会从源节点被转移到目标节点。
2. 重新分片操作可以在线进行，在重新分片的过程中，集群不需要下线，并且源节点和目标节点都可以继续处理命令请求。

3. redis集群的重新分片操作是由redis的集群管理软件redis-trib负责执行的，redis提供了进行重新分片所有需要的所有命令，而
   redis-trib则通过向源节点和目标节点发送命令来进行重新分片操作。
   3.1 redis-trib对目标节点发送cluster setslot <slot> importing <source_id>命令，让目标节点准备好从源节点导入属于槽slot的键值对
   3.2 redis-trib对源节点发送cluster setslot <slot> migrating <target_id>命令，让源节点准备好将属于槽slot的键值对迁移至目标节点
   3.3 redis-trib向源节点发送cluster getkeysinlost <slot> <count>命令，获得最多count个属于槽slot的键值对的键名。
   3.4 对于步骤3获得的每个键名，redis-trib都向源节点发送一个MIGRATE <target_ip> <target_port> <key_name> 0 <timeout>命令
       将被选中的键原子地从源节点迁移至目标节点
   3.5 重复执行步骤3和步骤4，直至源节点保存的所有属于槽slot的键值对都被迁移至目标节点为止
   3.6 redis-trib 向集群中的任意一个节点发送cluster setslot <slot> NODE <target_id>命令，将槽slot指派给目标节点，这一指派信息
       会通过消息发送至整个集群，最终集群中的所有节点都会知道槽slot已经指派给目标节点。



}

cluster(ASK错误)
{
在进行重新分片期间，源节点向目标节点迁移一个槽的过程中，可能会出现这样一种情况：属于被迁移槽的一部分键值保存在源节点里面，
而另一部分键值对则保存在目标节点里面。
当客户端向源节点发送一个与数据库键有关的命令，并且命令要处理数据库键恰好就属于正在被迁移的槽时：
1. 源节点会先在自己的数据库里面查找指定的键，如果找到的话，就直接执行客户端发送过来的命令。
2. 相反地，如果源节点没能在自己的数据库里面找到指定的键，那么这个键有可能已经被迁移到目标节点，源节点将向客户端发回一个ASK
   错误，指引客户端转向正在导入槽的目标节点，并再次发送之前想要执行的命令。
   
}

cluster(消息)
{
集群中的各个节点通过发送和接收消息来进行通信：
MEET消息
PING消息
PONG消息
FAIL消息
PUBLISH消息

消息头：



}