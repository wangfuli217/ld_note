1	PSUBSCRIBE pattern [pattern ...]
订阅一个或多个符合给定模式的频道。
2	PUBSUB subcommand [argument [argument ...]]
查看订阅与发布系统状态。
3	PUBLISH channel message
将信息发送到指定的频道。
4	PUNSUBSCRIBE [pattern [pattern ...]]
退订所有给定模式的频道。
5	SUBSCRIBE channel [channel ...]
订阅给定的一个或多个频道的信息。
6	UNSUBSCRIBE [channel [channel ...]]
指退订给定的频道。

subpub()
{
Redis的发布与订阅功能由PUBLISH、SUBSCRIBE、PSUBSCRIBE等命令组成。

SUBSCRIBE：客户端可以订阅一个或多个频道，从而成为这个频道的订阅者：每当有其他客户端向被订阅者的频道发送消息时，
           频道的所有订阅者都会收到这条消息。
           UNSUBSCRIBE：退订频道
PSUBSCRIBE: 客户端还可以通过执行PSUBSCRIBE命令订阅一个或多个模式，从而成为这些模式的订阅者：每当有其他客户端
           向某个频道发送消息时，消息不仅会被发送给这个频道的所有订阅者，它还会被发送给所有与这个频道相匹配的
           模式订阅者。 
           UNPSUBSCRIBE ：退订模式频道   


redisServer.pubsub_channels字典类型：Redis将所有频道的订阅关系都保存在服务器状态的pubsub_channels字典里面，
            这个字典的键是某个被订阅的频道，而键的值则是一个链表，链表里面记录了所有订阅这个频道的客户端。
redisServer.pubsub_patterns链表类型:          
typedef struct pubsubPattern {
    redisClient *client; #订阅模式的客户端
    robj *pattern;       #被订阅的模式
} pubsubPattern;

PUBLISH ：当一个Redis客户端执行PUBLISH <channel> <message>命令将消息message发送给频道channel的时候，服务器需要执行以下
          两个动作；
          1. 将消息message发送给channel频道的所有订阅者
          2. 如果一个或多个模式pattern与频道channel相匹配，那么将消息message发送给pattern模式的订阅者。
PUBSUB：客户端通过这个命令来查看频道或者模式的相关信息，比如某个频道目前有多少个订阅者，又或某个模式目前有多少订阅者；
        诸如此类。
        1. pubsub channels [pattern] 子命令用于返回服务器当前被订阅的频道，其中pattern参数是可选的。
        2. pubsub numsub [channel-1 channel-2 ... channel-3] 子命令接收任意多个频道作为输入参数，并返回这些频道的订阅者数量。
        3. pubsub numpat 子命令用于返回服务器当前被订阅模式的数量。

}

1	DISCARD
取消事务，放弃执行事务块内的所有命令。
2	EXEC
执行所有事务块内的命令。
3	MULTI
标记一个事务块的开始。
4	UNWATCH
取消 WATCH 命令对所有 key 的监视。
5	WATCH key [key ...]
监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。
ACID()
{
Redis通过MULTI、EXEC、WATCH等命令来实现事务功能。事务提供了一种将所有命令请求打包，然后一次性、按顺序地执行多个命令的机制。
并且在事务执行期间，服务器不会中断事务而该去执行其他客户端的命令请求，它会将事务中的所有命令都执行完毕，然后才去处理其他
客户端的命令请求。

事务的实现：事务开始、事务入队、事务执行。
事务开始：MULTI 命令可以将执行该命令的客户端从非事物状态切换值事物状态，这一切换是通过在客户端状态的flags属性中打开
          REDIS_MULTI表示来完成的。
事务入队：当一个客户端处于非事物状态时，这个客户端发送的命令会立即被服务器执行；与此不同的是
          当一个客户端切换到事物状态之后，服务器会根据这个客户端发来的不同命令执行不同的操作。
1.如果客户端发送的命令为EXEC、DISCARD、WATCH、MULTI四个命令的其中一个，那么服务器立即执行这个命令；
2.与此相反，如果客户端发送的命令为EXEC、DISCARD、WATCH、MULTI四个命令之外的命令，那么服务器并不立即执行这个命令，而是
  将这个命令放入一个事物队列里面，然后向客户端返回QUEUED回复。
  
redisClient.mstate 事务状态
          
typedef struct multiState {
    multiCmd *commands;           事务队列，FIFO顺序
    int count;                    已入队命令计数
    int minreplicas;              
    time_t minreplicas_timeout;   
} multiState;
        
typedef struct multiCmd {
    robj **argv;                   命令参数
    int argc;                      命令参数个数
    struct redisCommand *cmd;      处理命令
} multiCmd;

事务执行：
EXEC： 当一个处于事物状态的客户端向服务器发送EXEC命令时，则个EXEC命令将立即被服务器执行。服务器会遍历这个客户端的事务队列，
       执行队列中保存的所有命令，最后将执行命令所得的结果全部返回给客户端。
WATCH：WATCH命令是一个乐观锁，他可以在EXEC命令执行之前，监视任意数量数据库键，并在EXEC命令执行时，检查被监视的键是否至少
       有一个已经被修改过了，如果是的话，服务器将拒绝执行事务，并向客户端返回代表事务执行失败的空回复。

redisDb.watched_keys 正在被WATCH命令监视的键。
通过watched_keys字典，服务器可以清楚地知道哪些数据库键正在被监视，以及哪些客户端正在监视这些数据库键。
multi.c/touchWachtKey() 在执行SET、LPUSH、SADD、ZREM、DEL、FLUSHDB等等。
当服务器接收到一个客户端发来的EXEC命令时，服务器会根据这个客户端是否打开了REDIS_DIRTY_CAS表示来决定是否执行事务：
REDIS_DIRTY_CAS被打开事务不安全；REDIS_DIRTY_CAS未被打开，事务执行安全。

ACID：Atomicity原子性
      Consistency一致性：数据符合数据库本身的定义和要求，没有包含非法或者无效的错误数据。
                 入队错误；执行错误；服务器宕机
      Isolation隔离性：多个事务并发地执行，各个事务之间也不会互相影响，并且在并发状态下执行的事务和串行执行的事务产生的结果
                       完全相同。
      Durability耐久性：当一个事物执行完毕时，执行这个事务所得的结果已经被保存到永久性存储介质里面了。即使服务器在事务执行完毕之后
                       停机，执行事务所的的结果也不会丢失。

no-appendfsync-on-rewrite选项对那就行有影响。

1. 事务提供了一种将多个命令打包，然后一次性、有序执行的机制。
2. 多个命令会被入队到事务队列中，然后按先进先出的顺序执行。
3. 事务在执行过程中不会被中断，当事务队列中的所有命令都被执行完毕之后，事务才会结束。
4. 带有WATCH命令的事务会将客户端和被监视的键在数据库的watched_keys字典中进行关联，当键被修改时，程序会将所有监视被修改
    键的客户端的REDIS_DIRTY_CAS标志打开。
5. 只有在客户端的REDIS_DIRTY_CAS标识未被打开时，服务器才会执行客户端提交的事务，否则的话，服务器将拒绝执行客户端提交的事务。
6. Redis的事务总是具有ACID中的原子性、一致性和隔离性。当服务器运行在AOF持久化模式下，并且appendfasync选项的值为
   always时，事务也具有耐久性。    
}


sort(ASC、DESC、ALPHA、LIMIT、STORE、BY、GET)
{
SORT：可以对列表键、集合键或者有序集合键的值进行排序。
      ASC、DESC、ALPHA、LIMIT、STORE、BY、GET在内的所有sort命令选项。
SORT <key> ALPHA sort命令可以对包含字符串值的进行排序。
SORT <key> ASC   默认是升序
SORT <key> DESC  可以设置为降序
SORT fruits BY *-price #在默认情况下，SORT命令使用被排序键包含的元素作为排序的权重，元素本身决定了元素在排序之后所处的位置。
             #BY，SORT命令可以指定某些字符串键，或者某个哈希键所包含的某些域作为元素的权重，对一个键进行排序。
SORT fruits BY *-price ALPHA
LIMIT选项，可以让SORT命令只返回其中一部分已排序的元素。 LIMIT <offset> <count>     
SORT alphabet ALPHA LIMIT 0 4
GET选项，让SORT命令在对键进行排序之后，根据被排序的元素，以及GET选项所指定的模式，查找并返回某些键的值。
SORT stuendts ALPHA GET *-name
STORE选项将排序结果保存在指定的键里面。
SORT students STORE stored_students

SORT <key> ALPHA DESC BY <by-pattern> LIMIT <offset> <count> GET <get-pattern> STORE <store_key>
SORT <key> LIMIT <offset> <count> BY <by-pattern> ALPHA GET <get-pattern> STORE <store_key> DESC
SORT <key> STORE <store_key> DESC BY <by-pattern> GET <get-pattern> ALPHA LIMIT <offset> <count>
返回同样的结果

1. sort命令通过将被排序键包含的元素载入到数组里面，然后对数组进行排序来完成对键进行排序的工作。
2. 默认情况下，SORT命令假设被排序键包含的都是数字值，并且以数字值的方式来进行排序。
3. 如果SORT命令使用了ALPHA选项，那么SORT命令假设被排序键包含的都是字符串值，并且以字符串的方式进行排序
4. SORT命令的排序操作由快速排序算法实现。
5. SORT命令会根据用户是否使用了DESC选项来决定是使用升序比对还是降序比对来比对被排序的元素，升序对比会
   产生升序排序结果，被排序的元素按值的大小从小到大排序，降序比对会产生降序排序结果，被排序的元素按值
   的大小从大到小排序。
6. 当SORT命令使用了BY选项时，命令使用其他键的值作为权重来进行排序操作。
7. 当SORT命令使用了LIMIT选项时，命令只保留排序的结果集中LIMIT选项指定的元素。
8. 当SORT命令使用了GET选项时，命令会根据排序结果集中的元素，以及GET选项给定的模式，查找并返回其他键的值，
    而不是返回被排序的元素。
9. 当SORT命令使用了STORE选项时，命令限制性排序操作，然后执行LIMIT选项，之后执行GET选项，在之后执行STORE选项
    最后才将排序结果集返回给客户端。
10. 除了GET选项之外，调整选项的摆放位置不会影响STORE命令的排序结果。    



}


      
binary(SETBIT、GETBIT、BITCOUNT、BITOP)
{
SETBIT、GETBIT、BITCOUNT、BITOP
SETBIT <bitarray> <offset> <value>
SETBIT用于为位数组指定偏移量上的二进制位设置值，位数组的偏移量从0开始计数，而二进制位的值则可以是0或1.
SETBIT bit 0 1   #0000 0001
SETBIT bit 3 1   #0000 1001
SETBIT bit 0 0   #0000 1000
GETBIT <bitarray> <offset>
GETBIT用于获取位数组指定偏移量上的二进制位的值。
GETBIT bit 0
GETBIT bit 1
BITCOUNT 用于统计位数组里面，值为1的二进制位的数量。
BITCOUNT bitarray
1、 遍历算法
2、 查表算法
3、 计算汉明码重量 variable-precision SWAR算法
4、 Redis用到了2和3两种算法

BITOP 即可以对多个位数组进行按位与、按位或、按位异或运算。也可以取反
BITOP AND and-reslut x y z
BITOP OR and-reslut x y z
BITOP XOR and-reslut x y z
BITOP NOT not-value value

Redis使用字符串对象来表示位数组，因为字符串对象使用的SDS数据结构是二进制安全的，所以程序可以
直接使用SDS结构来保存位数组，并使用SDS结构的操作函数来处理位数组。

}


slowlog(
slowlog-log-slower-than、
slowlog-max-len、
slowlog get、
slowlog len、
slowlog reset、
)
{
慢查询日志：Redis的慢查询日志功能用于记录执行时间超过给定时长的命令请求，用户可以通过这个功能产生的日志来监视和优化查询速度。

slowlog-log-slower-than:指定执行时间超过多少微秒的命令请求会被记录到日志上。
slowlog-max-len 指定服务器最多保存多少条慢查询日志。
                 服务器是哟个先进先出的方式保存多条慢查询日志，当服务器存储的慢查询日志数量等于slowlog-max-len选项的值时，
                 服务器在添加一条新的慢查询日志之前，会先将旧的一条慢查询日志删除。
CONFIG SET slowlog-log-slower-than 0
CONFIG SET slowlog-max-len 5
然后使用slowlog get命令查看服务器所保存的慢查询日志。
slowlog len
slowlog reset

Redis服务器将所有的慢查询日志保存在服务器状态的slowlog链表中，每个链表节点都包含一个slowlogEntry结构。
redisServer
slowlog_entry_id 下一条慢查询日志的ID
slowlog           保存了所有慢查询日志的链表
slowlog_log_slower_than 服务器配置 slowlog-log-slower-than 选项的值。
slowlog_max_len    服务器配置slowlog-max-len选项的值。

slowlogEntry
id 唯一标识符
time 命令执行的时候，格式为UNIX时间戳
duration 执行命令消耗的时间，以微秒为单位
** argv 命令与命令参数
argc 命令与命令参数的数量
}

MONITOR 实时打印出 Redis 服务器接收到的命令，调试用
monitor(monitor、REDIS_MONITOR)
{
monitor：客户端可以将自己变成一个监视器，实时地接受并打印服务器当前处理的命令请求的相关信息。
REDIS_MONITOR:monitor命令促使该标识符被打开。
replicationFeedMonitors函数：向监视器发送命令信息。

}

