1. redis服务器将所有数据库保存在服务器状态redis.h/redisServer结构的db数组中，db数组的每个项都是一个redis.h/redisDb结构。
   每个redisDb结构代表一个数据库。
2. 在初始化服务器时，程序会根据服务器状态的dbnum属性来决定应该创建多少个数据库。
3. 数据库切换 select 1~16

4. Redis服务器的所有数据库都保存在redisserver.db数组中，而数据库的数据量则由redisServer.dbnum属性保存。
5. 客户端通过修改目标数据库指针，让它执行redisServer.db数组中的不同元素来切换不同的数据库。
6. 数据库主要由dict和expires两个字典构成，其中dict字典负责保存键值对，而expires字典负责保存键的过期时间。
7. 因为数据库由字典构成，所以数据库的操作都是建立在字典操作之上的。
8. 数据库的键总是一个字符串对象，而值则可以是任意一种Redis对象类型，包括字符串对象、哈希表对象、集合对象、列表对象和有序集合对象。
    分别对应字符串键、哈希表键、集合键、列表键和有序集合键。
9. expires字典的键指向数据库中的某个键，而值则记录了数据库键的过期时间，过期时间是一个以毫秒为单位的UNIX时间戳。
10. Redis使用惰性删除和定期删除两种策略来删除过期的键：惰性删除策略只是在碰到过期键时才进行删除操作，定时删除策略则是每隔一段时间来主动
    查找并删除过期键
11. 执行SAVE或者BGSAVE命令所产生新的RDB文件不包含已经过期的键。
12. 执行BGREWRITEAOF命令所产生的重写AOF文件不会包含已经过期的键。    
13. 当一个过期键被删除之后，服务器会追加一个DEL命令到现在AOF文件的末尾现实地删除过期键。
14. 当主服务器删除一个过期键之后，它会向所有从服务器发送一条DEL命令，显示的删除过期键。
15. 从服务器即使发现过期键也不会自作主张的删除它，而是等待主节点发来DEL命令，这种统一、中心化的过期键删除策略可以保证主从服务器数据的一致性。
16. 当Redis命令对数据库进行修改之后，服务器会根据配置向客户端发送数据库通知。

redisServer()
{
int dbnum;      服务器的数据库数量。由服务器配置的database选项决定。默认值为16.
struct saveparam *saveparams; 记录了保存条件的数组

long long dirty; 修改计数器
time_t lastsave; 上次执行保存的时间

sds aof_buf; 持久化实现
    processFileEvents
    processTimeEvents
    flushAppendOnlyFile 持久化函数
    
saveparam:
time_t seconds;
int changes;
}

redisClient()
{
redisDb *db;    记录当前正在使用的数据库。
}

redisDb()
{
dict *dict; 数据库键空间，保存着数据库中的所有键值对。

键空间和用户所见的数据库是直接对应的：
1. 键空间的键也就是数据库的键，每个键都是一个字符串对象。
2. 将空间的值也就是数据库的值，每个值可以是字符串对象、列表对象、哈希表对象、集合对象和有序集合对象中的任意一种Redis对象。

dict *expire; 过期字典，保存着键的过期时间。
}



redis(数据库键值空间)
{
SET date "2013.12.1"       添加新建
DEL date                   删除键
SET date "2013.12.2"       更新键
FLUSHDB 删除所有键值对
DBSIZE  键空间中包含的键值对的数量
EXISTS 
RENAME
KEYS

读写键空间时维护操作：
1. 在读取一个键时，服务器会根据键是否存在来更新服务器的键值空间中的次数或键空间的不命中次数，这两个值可以在info stat
   命令的keyspace_hits属性和keyspace_misses属性中查看
2. 在读取一个键后，服务器会更新键的LRU时间，这个值可以用于计算键的闲置时间，使用OBJECT idle <key>命令可以查看解ket的闲置时间。
3. 如果服务器在读取一个键时发现该键已经过期，那么服务器会先删除这个过期键，然后才执行余下的其他操作。
4. 如果有客户端使用watch命令监视这个键，那么服务器在对被监视的键进行修改之后，会将这个键标记为脏，从而让事物程序注意到这个键已经被修改过。
5. 服务器每次修改一个键之后，会对脏键计数器的值增1，这个计数器会被触发服务器持久化以及复制操作。
6. 如果服务器开启了数据通知功能，那么在对键进行修改之后，服务器将按配置发送响应的数据库通知。

expire(expire,pexpire,expireat,pexpireat){}
生存期或过期时间
expire命令--秒为单位 pexpire命令--毫秒为单位   
expire <key> <ttl>
pexpire <key> <ttl>

setex 可以在设置一个字符串键的同时为键设置过期时间。

过期时间
expireat命令--秒为单位 pexpireat--毫秒为单位 
expireat <key> <timestamp>
pexpireat <key> <timestamp>

persist(persist){}
持久化
persist 移除过期时间；

ttl(ttl, pttl){}
计算并返回剩余生存时间
ttl <key>
pttl <key>

expire(定时删除,惰性删除,定期删除)
过期键删除策略：
定时删除：在设置键的过期时间的同时，创建一个定时器，让定时器在键的过期时间来临时，立即执行对键的删除操作。
           对内存最友好的。对CPU是最不友好的。
惰性删除：放任键过期不管，但是每次从键空间获取键时，都检查取的的键是否过期，如果过期的话，就删除该键；如果没有过期，就返回该键。
            对CPU最友好的。对内存是最不友好的。
db.c/expireIfNeeded函数：
1. 如果输入键已经过期，那么expireIfNeeded函数将输入键从数据库中删除。
2. 如果输入键未过期，那么expireIfNeeded函数不做操作

1. 当键存在时，命令按照健存在的情况执行
2. 当键不存在时或者因为过期而被expireIfNeeded函数删除时，命令按照不存在的情况执行。

定期删除：每隔一段时间，程序就对数据库进行一次检查，删除里面的过期键。至于那些要删除多少过期键，以及检查多少个数据库，则由算法决定。
           折中
redis.c/activeExpireCycle函数：
DEFAULT_DB_BUMBERS = 16   默认每次检查的数据库数量
DEFAULT_KEY_BUMBERS = 16  默认每次数据检察的键数量


rdb(SAVE,BGSAVE)
{
1. 生成RDB文件
在执行SAVE,BGSAVE命令创建RDB文件时，程序会对数据库中的键进行检查，已过期的键不会被保存到新创建的RDB文件中。
2. 载入RDB文件
主服务器；在载入RDB时，程序会对文件中保存的键进行检查，未过期的键会被载入到数据库中，而过期的键则会被忽略，所以
          过期键对载入RDB文件的主服务器不会造成影响。
从服务器：在载入RDB时，程序会对文件中保存的键进行检查，不论是否过期，都会被载入到数据库中。不过，因为主从服务器在进行数据
          同步的时候，从服务器的数据库就会被清空，所以，一般来讲，过期键对载入RDB文件的从服务器不会造成影响。

AOF文件：当服务器以AOF持久化模式运行时，如果数据库中的某个键已经过期，但他还没有被惰性删除或者定期删除，那么AOF文件不会因为这个过期键
         而产生任何影响。
         当过期键被惰性删除或定期删除删除之后，程序会向AOF文件追加一个DEL命令，来显示地记录该键已经被删除。
和生成RDB文件时类似，在执行AOF重写过程中，程序会对数据库中的键进行检查，已过期的键不会被保存到重写后的AOF文件中。
3. 复制
当数据库运行在复制模式下时，从服务器的过期键删除动作由主服务器控制：
1. 主服务器在删除一个过期键之后，会显示第向所有从服务器发送一个DEL命令，告知从服务器删除这个过期键。
2. 从服务器在执行客户端发送的读命令时，即使碰到过期键也不会将过期键删除，是继续像处理未过期的键一样来处理过期键。
3. 从服务器只有在接到主服务器发送来的DEL命令时，才会删除过期键。
     
}


subscribe(数据库通知)
{
    键空间通知：key-space notification #SUBSCRIBE __keyspace@0__:message
    键事件通知：key-event notification #SUBSCRIBE __keyevent@0__:del
    notify-keyspace-events 配置：
    所有键空间和键事件通知： AKE
    所有类型的键空间通知  ： AK
    所有类型的键事件通知  ： AE
    只发送字符串相关的键空间通知：K$
    只发送列表有关的键事件通知： EL
    
    notify.c/notifyKeyspaceEvent(int type, char *event, robj *key, int dbid)
    event,key和dbid分别是事件的名称，产生事件的键，以及产生事件的数据库号码。
}

}

rdb(持久化)
{
save选项：  条件出发bgsave命令执行。
save 900 1     #服务器在900秒之内，对数据库进行了1次修改
save 300 10    #服务器在300秒之内，对数据库进行了10次修改。
save 60 10000  #服务器在60秒内，对数据进行了至少10000次修改。

1. RDB持久化功能既可以手动执行，也可以根据服务器配置选项定期执行，该功能可以将其某个时间点上的数据库状态保存到一个RDB文件中。
2. RDB持久化功能所生成的RDB文件是一个经过压缩的二进制文件，通过该文件可以还原生成RDB文件时的数据库状态。
3. 服务器在载入RDB文件期间，会一直处于阻塞状态，直到载入工作完成为止。

save命令会阻塞Redis服务器进程，直到RDB文件创建完毕为止，在服务器进程阻塞期间，服务器不能处理任何命令；
bgsave命令会派生一个子进程，然后由子进程负责创建RDB文件，服务器父进程继续处理命令请求。

创建RDB文件的实际工作由rdb.c/rdbSave函数完成。
和使用SAVE命令和BGSAVE命令创建RDB文件不同，RDB文件的载入工作是在服务器启动时自动执行的，所以Redis并没有专门用于载入RDB文件的命令，只要
redis服务器启动，他就会自动载入RDB文件。

AOF比RDB文件的更新频率要高，所以：
1. 如果服务器开启了AOF持久化功能，那么，服务器就会优先使用AOF文件来还原数据库状态。
2. 只有在AOF持久化功能处于关闭状态时，服务器才会使用RDB文件来还原数据库状态。

在BGSAVE命令执行期间，服务器处理SAVE，BGSAVE，BGREWRITEAOF三个命令会和平时有所不同。
    首先，在BGSAVE命令执行期间，客户端发送的SAVE命令会被服务器拒绝，服务器禁止SAVE命令和BGSAVE命令同时执行为了避免父进程和子进程同时执行
两个rdbsave调用，防止产生竞争条件。
    其次，在BGSAVE命令执行期间，客户端发送的BGSAVE命令会被服务器拒绝，因为同时执行两个bgsave命令会产生竞争条件。
    最后，BGREWRITEAOF和BGSACE两个命令不能同时执行。
    1. 如果BGSAVE命令正在执行，那么客户端发送的BGREWRITEAOF命令会被延迟到BGSAVE命令执行完毕之后执行。
    2. 如果BGREWRITEAOF命令正在执行，那么客户端发送的BGSAVE命令会被服务器拒绝。
BGSAVE和BGREWRITEAOF实际工作都是由子进程执行的。
    
除了saveparams数组之外，服务器状态还维持着一个dirty计数器，以及一个lastsave属性：
dirty：计数器记录距离上一次成功执行save命令或者bgsave命令之后，服务器对数据状态进行了多少次修改。
lastsave属性是一个UNIX时间戳，记录了服务器上一次成功执行save命令或者bgsave命令的时间。

执行检查的函数ServerCron函数，每个100毫秒执行一次。


a）保存(rdbSave)
    rdbSave负责将内存中的数据库数据以RDB格式保存到磁盘中，如果RDB文件已经存在将会替换已有的RDB文件。保存RDB文件期间会阻塞主进程，这段时间期间将不能处理新的客户端请求，直到保存完成为止。
    为避免主进程阻塞，Redis提供了rdbSaveBackground函数。在新建的子进程中调用rdbSave，保存完成后会向主进程发送信号，同时主进程可以继续处理新的客户端请求。

b）读取(rdbLoad)
    当Redis启动时，会根据配置的持久化模式，决定是否读取RDB文件,并将其中的对象保存到内存中。
    载入RDB过程中，每载入1000个键就处理一次已经等待处理的客户端请求，但是目前仅处理订阅功能的命令(PUBLISH 、 SUBSCRIBE 、 PSUBSCRIBE 、 UNSUBSCRIBE 、 PUNSUBSCRIBE)，其他一律返回错误信息。因为发布订阅功能是不写入数据库的，也就是不保存在Redis数据库的。


rdb(文件结构)
{
REDIS db_version databases EOF check_sum
REDIS：REDIS集合字母。
db_version:RDB文件版本号；
databases：包含一个多个数据库。
1. 如果服务器的数据库状态为空(所有数据库都是空)，那么这个部分也为空，长度为0字节。
2. 如果服务器的状态为非空，那么这个部分也为非空，根据数据库所保存键值对的数据、类型和内容不同，这部分的长度也会有所不同。
EOF：常量的长度为1字节，这个常量标志着RDB文件正文内容的结束。当读入程序遇到这个值的时候，他知道所有数据库的所有键值对都已经载入完毕了。
check_sum是一个8字节长度的无符号整数，保存一个校验和。

database(文件结构)
{
SELECTDB db_number key_value_pairs
SELEDTDB常量的长度为1字节，当读入程序遇到这个值的时候，他知道接下来要读入的将是一个数据库号码。
db_number保存着一个数据库号码，根据号码的大小不同，这个部分的长度可以是1字节、2字节或者5字节。
}

key_pairs(文件结构)
{
文件格式： TYPE key value
TYPE:
REDIS_RDB_TYPE_STRING
REDIS_RDB_TYPE_LIST
REDIS_RDB_TYPE_SET
REDIS_RDB_TYPE_ZSET
REDIS_RDB_TYPE_HASH
REDIS_RDB_TYPE_LIST_ZIPLIST
REDIS_RDB_TYPE_SET_INTSET
REDIS_RDB_TYPE_ZSET_ZIPLIST
REDIS_RDB_TYPE_HASH_ZIPLIST

不带时间的： TYPE key value
key:key总是一个字符串对象，它的编码方式和REDIS_RDB_TYPE_STRING类型的value一样。根据内容长度的不同，key的长度也会有所不同。
value：根据TYPE类型不同，以及保存内容长度不同，保存value的结构和长度也会有所不同。

文件格式： EXPIRETIME_MS ms TYPE key value

value(文件结构)
{
1. 字符串对象 # REDIS_RDB_TYPE_STRING
REDIS_RDB_TYPE_STRING可以编码为REDIS_ENCODING_INT或者REDIS_ENCODING_RAW。
REDIS_ENCODING_INT：REDIS_RDB_ENC_INT8,REDIS_RDB_ENC_INT16,REDIS_RDB_ENC_INT32

REDIS_ENCODING_RAW：
1.如果字符串长度小于等于20个字节，那么这个字符串会直接被原样保存。
2. 如果字符串长度大于20个字节，那么这个字符串会被压缩之后再保存。
REDIS_RDB_ENC_LZF压缩字符串；

文件结构: 长度 string
文件结构: REDIS_RDB_ENC_LZF compressed_len origin_len compressed_string

redis.conf中的rdbcompression选项的说明。

2. 列表对象 # REDIS_RDB_TYPE_LIST
文件结构: list_length item1 item2 itemN

3. 集合对象 #REDIS_RDB_TYPE_SET
set_size elem1 elem2 elem3 ... elemN

4. 哈希对象 #REDIS_RDB_TYPE_HASH
hash_size key_value_pair1 key_value_pair2 key_value_pair3 key_value_pairN

5. 有序集合对象
sorted_set_size element1 element2 ... elementN

}

}
}
}

start()
{
1. 执行redis入口函数redis.c/main
2. 初始化Server变量，设置服务器配置相关默认值。
3. 读取配置文件，覆盖服务器配置的默认值。
4. 初始化服务器功能模块
4.1 注册信号事件
4.2 初始化客户端链表
4.3 初始化共享对象
4.4 检查设置客户端连接最大数
4.5 初始化数据库
4.6 初始化网络连接
4.7 是否初始化AOF重写
4.8 初始服务器实时统计数据
4.9 初始化后台计划任务
4.10 初始化lua脚本环境
4.11 初始化满查询日志
4.12 初始化后台线程任务系统
5. 从RDB或AOF重载数据
6. 网络监听前的准备工作
7. 进入循环，开启事件监听



}

