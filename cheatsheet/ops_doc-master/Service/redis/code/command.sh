官方主站：http://www.redis.io/
下载地址：http://www.redis.cn/download.html
Interactive Tutorial：http://try.redis-db.com/ 一步一步教你熟悉Redis的基本命令
Command API：http://redis.io/commands    http://www.redis.cn/commands.html
客户端程序：http://redis.io/clients
Redis文档：http://redis.io/documentation
命令参考：http://manual.csser.com/redis/
Redis内存使用优化与存储：http://www.infoq.com/cn/articles/tq-redis-memory-usage-optimization-storage
http://www.infoq.com/cn/articles/tq-redis-memory-usage-optimization-storage
Redis复制与可扩展集群搭建:
http://www.infoq.com/cn/articles/tq-redis-copy-build-scalable-cluster
Redis资料汇总专题http://blog.nosqlfan.com/html/3537.html
将redis变成数据库：http://code.google.com/p/alchemydatabase/
类似的产品：http://code.google.com/p/memlink/
redis-dump，将Redis数据dump成json格式的工具：https://github.com/delano/redis-dump


redis(redis-server usage)
{
Usage: ./redis-server [/path/to/redis.conf] [options]
       ./redis-server - (read config from stdin)
       ./redis-server -v or --version
       ./redis-server -h or --help
       ./redis-server --test-memory <megabytes>

Examples:
       ./redis-server (run the server with default conf)
       ./redis-server /etc/redis/6379.conf
       ./redis-server --port 7777
       ./redis-server --port 7777 --slaveof 127.0.0.1 8888
       ./redis-server /etc/myredis.conf --loglevel verbose

Sentinel mode:
       ./redis-server /etc/sentinel.conf --sentinel
       
redis-server    listen port 6379
redis-sentinel  listen port 26379
       
}

redis(redis.conf)
{

CONFIG(get restart rewrite set){}
<CONFIG GET>
1. CONFIG GET 命令用于取得运行中的 Redis 服务器的配置参数(configuration parameters)，在 Redis 2.4 版本中， 
   有部分参数没有办法用 CONFIG GET 访问，但是在最新的 Redis 2.6 版本中，所有配置参数都已经可以用 CONFIG GET 访问了。
2. CONFIG GET 接受单个参数 parameter 作为搜索关键字，查找所有匹配的配置参数，其中参数和值以“键-值对”(key-value pairs)
   的方式排列。 
比如执行 CONFIG GET s* 命令，服务器就会返回所有以 s 开头的配置参数及参数的值：

CONFIG GET s*
CONFIG GET slowlog-max-len
CONFIG GET *

<CONFIG RESETSTAT>
CONFIG RESETSTAT
重置 INFO 命令中的某些统计数据，包括：
    Keyspace hits (键空间命中次数)
    Keyspace misses (键空间不命中次数)
    Number of commands processed (执行命令的次数)
    Number of connections received (连接服务器的次数)
    Number of expired keys (过期key的数量)
    Number of rejected connections (被拒绝的连接数量)
    Latest fork(2) time(最后执行 fork(2) 的时间)
    The aof_delayed_fsync counter(aof_delayed_fsync 计数器的值)

# 重置前
redis 127.0.0.1:6379> INFO

<CONFIG REWRITE>
CONFIG REWRITE 命令对启动 Redis 服务器时所指定的 redis.conf 文件进行改写： 因为 CONFIG SET 命令可以对服务器的当前配置进行修改， 而修改后的配置可能和 redis.conf 文件中所描述的配置不一样， CONFIG REWRITE 的作用就是通过尽可能少的修改， 将服务器当前所使用的配置记录到 redis.conf 文件中。

重写会以非常保守的方式进行：

    原有 redis.conf 文件的整体结构和注释会被尽可能地保留。
    如果一个选项已经存在于原有 redis.conf 文件中 ， 那么对该选项的重写会在选项原本所在的位置（行号）上进行。
    如果一个选项不存在于原有 redis.conf 文件中， 并且该选项被设置为默认值， 那么重写程序不会将这个选项添加到重写后的 redis.conf 文件中。
    如果一个选项不存在于原有 redis.conf 文件中， 并且该选项被设置为非默认值， 那么这个选项将被添加到重写后的 redis.conf 文件的末尾。
    未使用的行会被留白。 比如说， 如果你在原有 redis.conf 文件上设置了数个关于 save 选项的参数， 但现在你将这些 save 参数的一个或全部都关闭了， 那么这些不再使用的参数原本所在的行就会变成空白的。

<CONFIG SET>  
CONFIG SET parameter value

CONFIG SET 命令可以动态地调整 Redis 服务器的配置(configuration)而无须重启。

你可以使用它修改配置参数，或者改变 Redis 的持久化(Persistence)方式。

CONFIG SET 可以修改的配置参数可以使用命令 CONFIG GET * 来列出，所有被 CONFIG SET 修改的配置参数都会立即生效。
}

redis(redis-cli usage)
{
可输入redis-cli直接进入命令行操作界面。

redis-cli参数
-h  设置检测主机IP地址，默认为127.0.0.1
-p  设置检测主机的端口号，默认为6379
-s  服务器套接字(压倒主机和端口)
-a  连接到Master服务器时使用的密码
-r  执行指定的N次命令
-i  执行命令后等待N秒，如–i 0.1 info(执行后等0.1秒)
-n  指定连接N号ID数据库，如 –n 3(连接3号数据库)
-x  从控制台输入的信息中读取最后一个参数
-d  定义多个定界符为默认输出格式（默认: \n）
--raw   使用原数据格式返回输出内容
--latency   进入一个不断延时采样的特殊模式
--slave 模拟一个从服务器到主服务器的命令显示反馈
--pipe  使用管道协议模式
--bigkeys   监听显示数据量大的key值，--bigkeys -i 0.1 
--help  显示命令行帮助信息
--version   显示版本号

例子：
$ redis-cli进入命令行模式
$ redis-cli -r 3 info 重复执行info命令三次
$ cat testStr.txt | redis-cli -x set testStr读取testStr.txt文件所有内容设置为testStr的值
$ redis-cli -r 100 lpush mylist x
$ redis-cli -r 100 -i 1 info | grep used_memory_human

redis-cli --latency -h `host` -p `port`  #计算延迟时间

Examples:
  cat /etc/passwd | redis-cli -x set mypasswd
  redis-cli get mypasswd
  redis-cli -r 100 lpush mylist x
  redis-cli -r 100 -i 1 info | grep used_memory_human:
  redis-cli --eval myscript.lua key1 key2 , arg1 arg2 arg3
  redis-cli --scan --pattern '*:12345*'

查看、删除key信息
redis-cli keys \*   #查看所有键值信息
redis-cli -n 1 keys "test*" | xargs redis-cli -n 1 del 删除DBID为1的test开头的key值
  
获取服务器的信息和统计
redis-cli info查询系统信息。默认为localhost，端口为6379。
redis-cli -p 6379 info |  grep '\' 过滤查询used_memory属性
当used_memory_rss接近maxmemory或者used_memory_peak超过maxmemory时，要加大maxmemory 负责性能下降
redis服务的统计信息：

}

redis(redis-check-aof usage){

redis-check-aof
更新日志检查 ，加--fix参数为修复log文件
redis-check-aof appendonly.aof
}
redis(redis-check-dump usage){

redis-check-dump
检查本地数据库文件
redis-check-dump  dump.rdb
}

redis(redis-benchmark usage){

redis-benchmark -h localhost -p 6379 -c 100 -n 100000
100个并发连接，100000个请求，检测host为localhost 端口为6379的redis服务器性能
./redis-benchmark -n 100000 –c 50

redis-benchmark参数
-h  设置检测主机IP地址，默认为127.0.0.1
-p  设置检测主机的端口号，默认为6379
-s  服务器套接字(压倒主机和端口)
-c  并发连接数
-n  请求数
-d  测试使用的数据集的大小/字节的值(默认3字节)
-k  1：表示保持连接(默认值)0：重新连接
-r  ET/GET/INCR方法使用随机数插入数值，设置10则插入值为rand:000000000000 - rand:000000000009
-P  默认为1(无管道)，当网络延迟过长时，使用管道方式通信(请求和响应打包发送接收)
-q  简约信息模式，只显示查询和秒值等基本信息。
--csv   以CSV格式输出信息
-l  无线循环插入测试数据，ctrl+c停止
-t  只运行测试逗号分隔的列表命令，如：-t ping,set,get
-I  空闲模式。立即打开50个空闲连接和等待。
例子：
$ redis-benchmark基本测试
$ redis-benchmark -h 192.168.1.1 -p 6379 -n 100000 -c 20
$ redis-benchmark -t set -n 1000000 -r 100000000
$ redis-benchmark -t ping,set,get -n 100000 –csv
$ redis-benchmark -r 10000 -n 10000 lpush mylist ele:rand:000000000000


}


redis-faina()
{
redis-faina(https://github.com/Instagram/redis-faina) 是由Instagram 开发并开源的一个Redis 查询分析小工具，需安装python环境。
redis-faina 是通过Redis的MONITOR命令来实现的，通过对在Redis上执行的query进行监控，统计出一段时间的query特性，需root权限。
通过管道从stdin读取N条命令，直接分析
redis-cli -p 6439 monitor  | head -n | ./redis-faina.py

从一个文件中读取117773条命令，再分析
redis-cli -p 6439 monitor  | head -n 117773 > /tmp/outfile.txt
./redis-faina.py /tmp/outfile.txt

其输出结果如下：
Overall Stats
========================================
Lines Processed     117773
Commands/Sec        11483.44
Top Prefixes(按key前缀统计)
========================================
friendlist          69945
followedbycounter   25419
followingcounter    10139
recentcomments      3276
queued              7
Top Keys(操作最频繁的key)
========================================
friendlist:zzz:1:2     534
followingcount:zzz     227
friendlist:zxz:1:2     167
friendlist:xzz:1:2     165
friendlist:yzz:1:2     160
friendlist:gzz:1:2     160
friendlist:zdz:1:2     160
friendlist:zpz:1:2     156
Top Commands(执行最多的命令)
========================================
SISMEMBER   59545
HGET        27681
HINCRBY     9413
SMEMBERS    9254
MULTI       3520
EXEC        3520
LPUSH       1620
EXPIRE      1598
Command Time (microsecs)(命令执行时长)
========================================
Median      78.25
75%         105.0
90%         187.25
99%         411.0
Heaviest Commands (microsecs)(耗时最多的命令)
========================================
SISMEMBER   5331651.0
HGET        2618868.0
HINCRBY     961192.5
SMEMBERS    856817.5
MULTI       311339.5
SADD        54900.75
SREM        40771.25
EXEC        28678.5
Slowest Calls(最慢的命令)
========================================
3490.75     "SMEMBERS" "friendlist:zzz:1:2"
2362.0      "SMEMBERS" "friendlist:xzz:1:3"
2061.0      "SMEMBERS" "friendlist:zpz:1:2"
1961.0      "SMEMBERS" "friendlist:yzz:1:2"
1947.5      "SMEMBERS" "friendlist:zpz:1:2"
1459.0      "SISMEMBER" "friendlist:hzz:1:2" "zzz"
1416.25     "SMEMBERS" "friendlist:zhz:1:2"
1389.75     "SISMEMBER" "friendlist:zzx:1:2" "zzz"
从上面结果我们可以看到对Redis的操作规律，比如针对哪些key在进行操作，进行了什么操作，这些操作的效率如何等相关有用信息。
由于Redis的MONITOR 也对性能有所影响，所以建议在使用时不要一直开启MONITOR来分析。可以采用定时抽样一段时间来做样本分析。
}

redis(master -> slave)
{
方式可以有2种：1 master -> slave，2 master -> slave -> slave -> slave..
一个集群可以包含最多4096个节点(主节点master和从节点slave)，建议最多设置几百个节点
进入Redis安装目录，创建主从配置文件
 cd
创建主从服务器工作目录及对应的配置、日志等目录，服务器目录创建规则



 名称+编号+端口号
Master100_6379      主服务器
Slave101_6380       从服务器    对应Master100的从服务器
Master200_6381      主服务器
Slave201_6382       从服务器    对应Master200的从服务器

mkdir Master100_6379 Slave101_6380
 mkdir Master100_6379/conf Master100_6379/log Master100_6379/data
 mkdir Slave101_6380/conf Slave101_6380/log Slave101_6380/data
复制配置文件到服务器的conf目录
cp redis.conf Master100_6379/conf/redis.conf
cp redis.conf  Slave101_6380/conf/slave.conf
修改主服务器配置文件：
pidfile /redis/redis/Master100_6379/run/redis_Master100_6379.pid
port 6379
logfile /redis/redis/Master100_6379/log/stdout.log
dbfilename /redis/redis/Master100_6379/data/dump.rdb
appendfilename /redis/redis/Master100_6379/log//appendonly.aof
修改从服务器配置文件：
pidfile /redis/redis/Slave101_6380/run/redis_ Slave101_6380.pid
port 6380
logfile /redis/redis/Slave101_6380/log/stdout.log
dbfilename /redis/redis/Slave101_6380/data/dump.rdb
slaveof 127.0.0.1 6379
appendfilename /redis/redis/ Slave101_6380/log//appendonly.aof

 
启动主服务器：
redis-server /redis/redis/Master100_6379/conf/redis.conf     
插入测试数据：
redis-benchmark
启动从服务器：
redis-server /redis/redis/Slave101_6380/conf/slave.conf 
查询主从服务是否已运行：
ps xal|grep redis  

进入主从服务器目录，查询对比所有服务器数据文件的散列值和文件大小：
find . -type f -name "*.rdb" | xargs md5sum
find . -type f -name "*.rdb" | xargs ls -l
生成报文摘要并验证，如果对比成功则数据已同步：
find . -type f -name "*.rdb" | xargs md5sum >biran     
md5sum --check biran


强制同步数据到磁盘：

redis-cli save  或 redis-cli -p 6380 save (根据端口号指定某台服务器同步)
5.10.2 备份服务器方案
增设一台主机备份服务器，执行定时启动，同步，停止脚本，或直接在服务器上cp rdb数据文件
redis-server conf/bak.conf
redis-cli save
redis-cli shutdown

}

redis(FAQ)
{

1. Redis主从结构，主服务器宕机解决方法
绝对不能重新启动主服务器，如果主服务器没有配置持久化，否则数据会全部丢失。
解决方法是连接从服务器，做save操作。将会在从服务器的data目录保存一份从服务器最新的dump.rdb文件。将这份dump.rdb文件拷贝到主服务器的data目录下。再重启主服务器。

2. 调整overcommit_memory参数
如果内存情况比较紧张的话，需要设定内核参数overcommit_memory，指定内核针对内存分配的策略，其值可以是0、1、2。
0，表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
1，表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
2，表示内核允许分配超过所有物理内存和交换空间总和的内存
Redis在dump数据的时候，会fork出一个子进程，理论上child进程所占用的内存和parent是一样的，比如parent占用的内存为 8G，这个时候也要同样分配8G的内存给child, 如果内存无法负担，往往会造成redis服务器的down机或者IO负载过高，效率下降。所以这里比较优化的内存分配策略应该设置为 1(表示内核允许分配所有的物理内存，而不管当前的内存状态如何)。

设置方式有两种，需确定当前用户的权限活使用root用户修改：
1：重设文件 echo 1 > /proc/sys/vm/overcommit_memory(默认为0)
2： echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
/sbin/sysctl -p


3. 安装tcmalloc包
Redis并没有自己实现内存池，没有在标准的系统内存分配器上再加上自己的东西。所以系统内存分配器的性能及碎片率会对Redis造成一些性能上的影响。在最新版本中，jemalloc已经作为源码包的一部分包含在源码包中，所以可以直接被使用。如果要使用tcmalloc的话，是需要自己安装的。
tcmalloc是google-proftools( http://code.google.com/p/gperftools/downloads/list)中的一部分，所以我们实际上需要安装google-proftools。如果你是在64位机器上进行安装，需要先安装其依赖的libunwind库
wget http://download.savannah.gnu.org/releases/libunwind/libunwind-0.99-alpha.tar.gz
tar zxvf libunwind-0.99-alpha.tar.gz
cd libunwind-0.99-alpha/
CFLAGS=-fPIC ./configure
make CFLAGS=-fPIC
make CFLAGS=-fPIC install
然后再进行google-preftools的安装
wget http://google-perftools.googlecode.com/files/google-perftools-1.8.1.tar.gz
tar zxvf google-perftools-1.8.1.tar.gz
cd google-perftools-1.8.1/
./configure  --disable-cpu-profiler --disable-heap-profiler --disable-heap-checker --disable-debugalloc --enable-minimal
make && make install 
sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf  #如果没有这个文件，自己建一个
sudo /sbin/ldconfig
然后再进行Redis的安装，在make时指定相应的参数以启用tcmalloc

}

COMMAND
获取 Redis 命令详情数组
COMMAND COUNT
获取 Redis 命令总数
COMMAND GETKEYS
获取给定命令的所有键

redis-cli(help command)
{
#group# generic string list set sorted_set hash pubsub transactions connection server scripting hyperloglog
help @<group> 
help <command>


set(key, value)：给数据库中名称为key的string赋予值value
get(key)：返回数据库中名称为key的string的value
getset(key, value)：给名称为key的string赋予上一次的value
mget(key1, key2,…, key N)：返回库中多个string的value
setnx(key, value)：添加string，名称为key，值为value
setex(key, time, value)：向库中添加string，设定过期时间time
mset(key N, value N)：批量设置多个string的值
msetnx(key N, value N)：如果所有名称为key i的string都不存在
incr(key)：名称为key的string增1操作
incrby(key, integer)：名称为key的string增加integer
decr(key)：名称为key的string减1操作
decrby(key, integer)：名称为key的string减少integer
append(key, value)：名称为key的string的值附加value
substr(key, start, end)：返回名称为key的string的value的子串
string(help @string)
{
  APPEND key value
  summary: Append a value to a key

  BITCOUNT key [start] [end]
  summary: Count set bits in a string

  BITOP operation destkey key [key ...]
  summary: Perform bitwise operations between strings

  BITPOS key bit [start] [end]
  summary: Find first bit set or clear in a string

  DECR key
  summary: Decrement the integer value of a key by one

  DECRBY key decrement
  summary: Decrement the integer value of a key by the given number

  GET key
  summary: Get the value of a key

  GETBIT key offset
  summary: Returns the bit value at offset in the string value stored at key

  GETRANGE key start end
  summary: Get a substring of the string stored at a key

  GETSET key value
  summary: Set the string value of a key and return its old value

  INCR key
  summary: Increment the integer value of a key by one

  INCRBY key increment
  summary: Increment the integer value of a key by the given amount

  INCRBYFLOAT key increment
  summary: Increment the float value of a key by the given amount

  MGET key [key ...]
  summary: Get the values of all the given keys

  MSET key value [key value ...]
  summary: Set multiple keys to multiple values

  MSETNX key value [key value ...]
  summary: Set multiple keys to multiple values, only if none of the keys exist

  PSETEX key milliseconds value
  summary: Set the value and expiration in milliseconds of a key

  SET key value [EX seconds] [PX milliseconds] [NX|XX]
  summary: Set the string value of a key

  SETBIT key offset value
  summary: Sets or clears the bit at offset in the string value stored at key

  SETEX key seconds value
  summary: Set the value and expiration of a key

  SETNX key value
  summary: Set the value of a key, only if the key does not exist

  SETRANGE key offset value
  summary: Overwrite part of a string at key starting at the specified offset

  STRLEN key
  summary: Get the length of the value stored in a key
}

exists(key)：确认一个key是否存在
del(key)：删除一个key
type(key)：返回值的类型
keys(pattern)：返回满足给定pattern的所有key
randomkey：随机返回key空间的一个
keyrename(oldname, newname)：重命名key
dbsize：返回当前数据库中key的数目
expire：设定一个key的活动时间（s）
ttl：获得一个key的活动时间
move(key, dbindex)：移动当前数据库中的key到dbindex数据库
flushdb：删除当前选择数据库中的所有key
flushall：删除所有数据库中的所有key
generic(help @generic)
{
  DEL key [key ...]
  summary: Delete a key
  DUMP key
  summary: Return a serialized version of the value stored at the specified key.
  EXISTS key
  summary: Determine if a key exists
  EXPIRE key seconds
  summary: Set a key s time to live in seconds
  EXPIREAT key timestamp
  summary: Set the expiration for a key as a UNIX timestamp
  KEYS pattern
  summary: Find all keys matching the given pattern
  MIGRATE host port key destination-db timeout [COPY] [REPLACE]
  summary: Atomically transfer a key from a Redis instance to another one.
  MOVE key db
  summary: Move a key to another database
  OBJECT subcommand [arguments [arguments ...]]
  summary: Inspect the internals of Redis objects
  PERSIST key
  summary: Remove the expiration from a key
  PEXPIRE key milliseconds
  summary: Set a key  time to live in milliseconds
  PEXPIREAT key milliseconds-timestamp
  summary: Set the expiration for a key as a UNIX timestamp specified in milliseconds
  PTTL key
  summary: Get the time to live for a key in milliseconds
  RANDOMKEY -
  summary: Return a random key from the keyspace
  RENAME key newkey
  summary: Rename a key
  RENAMENX key newkey
  summary: Rename a key, only if the new key does not exist
  RESTORE key ttl serialized-value
  summary: Create a key using the provided serialized value, previously obtained using DUMP.
  SCAN cursor [MATCH pattern] [COUNT count]
  summary: Incrementally iterate the keys space
  SORT key [BY pattern] [LIMIT offset count] [GET pattern [GET pattern ...]] [ASC|DESC] [ALPHA] [STORE destination]
  summary: Sort the elements in a list, set or sorted set
  TTL key
  summary: Get the time to live for a key
  TYPE key
  summary: Determine the type stored at key
}

rpush(key, value)：在名称为key的list尾添加一个值为value的元素
lpush(key, value)：在名称为key的list头添加一个值为value的 元素
llen(key)：返回名称为key的list的长度
lrange(key, start, end)：返回名称为key的list中start至end之间的元素
ltrim(key, start, end)：截取名称为key的list
lindex(key, index)：返回名称为key的list中index位置的元素
lset(key, index, value)：给名称为key的list中index位置的元素赋值
lrem(key, count, value)：删除count个key的list中值为value的元素
lpop(key)：返回并删除名称为key的list中的首元素
rpop(key)：返回并删除名称为key的list中的尾元素
blpop(key1, key2,… key N, timeout)：lpop命令的block版本。
brpop(key1, key2,… key N, timeout)：rpop的block版本。
rpoplpush(srckey, dstkey)：返回并删除名称为srckey的list的尾元素，并将该元素添加到名称为dstkey的list的头部
list(help @list)
{
  BLPOP key [key ...] timeout
  summary: Remove and get the first element in a list, or block until one is available
  BRPOP key [key ...] timeout
  summary: Remove and get the last element in a list, or block until one is available
  BRPOPLPUSH source destination timeout
  summary: Pop a value from a list, push it to another list and return it; or block until one is available
  LINDEX key index
  summary: Get an element from a list by its index
  LINSERT key BEFORE|AFTER pivot value
  summary: Insert an element before or after another element in a list
  LLEN key
  summary: Get the length of a list
  LPOP key
  summary: Remove and get the first element in a list
  LPUSH key value [value ...]
  summary: Prepend one or multiple values to a list
  LPUSHX key value
  summary: Prepend a value to a list, only if the list exists
  LRANGE key start stop
  summary: Get a range of elements from a list
  LREM key count value
  summary: Remove elements from a list
  LSET key index value
  summary: Set the value of an element in a list by its index
  LTRIM key start stop
  summary: Trim a list to the specified range
  RPOP key
  summary: Remove and get the last element in a list
  RPOPLPUSH source destination
  summary: Remove the last element in a list, append it to another list and return it
  RPUSH key value [value ...]
  summary: Append one or multiple values to a list
  RPUSHX key value
  summary: Append a value to a list, only if the list exists

}

set(help @set)
{
  BLPOP key [key ...] timeout
  summary: Remove and get the first element in a list, or block until one is available
  BRPOP key [key ...] timeout
  summary: Remove and get the last element in a list, or block until one is available
  BRPOPLPUSH source destination timeout
  summary: Pop a value from a list, push it to another list and return it; or block until one is available
  LINDEX key index
  summary: Get an element from a list by its index
  LINSERT key BEFORE|AFTER pivot value
  summary: Insert an element before or after another element in a list
  LLEN key
  summary: Get the length of a list
  LPOP key
  summary: Remove and get the first element in a list
  LPUSH key value [value ...]
  summary: Prepend one or multiple values to a list
  LPUSHX key value
  summary: Prepend a value to a list, only if the list exists
  LRANGE key start stop
  summary: Get a range of elements from a list
  LREM key count value
  summary: Remove elements from a list
  LSET key index value
  summary: Set the value of an element in a list by its index
  LTRIM key start stop
  summary: Trim a list to the specified range
  RPOP key
  summary: Remove and get the last element in a list
  RPOPLPUSH source destination
  summary: Remove the last element in a list, append it to another list and return it
  RPUSH key value [value ...]
  summary: Append one or multiple values to a list
  RPUSHX key value
  summary: Append a value to a list, only if the list exists

}

sorted_set(help @sorted_set)
{
  ZADD key score member [score member ...]
  summary: Add one or more members to a sorted set, or update its score if it already exists
  ZCARD key
  summary: Get the number of members in a sorted set
  ZCOUNT key min max
  summary: Count the members in a sorted set with scores within the given values
  ZINCRBY key increment member
  summary: Increment the score of a member in a sorted set
  ZINTERSTORE destination numkeys key [key ...] [WEIGHTS weight] [AGGREGATE SUM|MIN|MAX]
  summary: Intersect multiple sorted sets and store the resulting sorted set in a new key
  ZLEXCOUNT key min max
  summary: Count the number of members in a sorted set between a given lexicographical range
  ZRANGE key start stop [WITHSCORES]
  summary: Return a range of members in a sorted set, by index
  ZRANGEBYLEX key min max [LIMIT offset count]
  summary: Return a range of members in a sorted set, by lexicographical range
  ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
  summary: Return a range of members in a sorted set, by score
  ZRANK key member
  summary: Determine the index of a member in a sorted set
  ZREM key member [member ...]
  summary: Remove one or more members from a sorted set
  ZREMRANGEBYLEX key min max
  summary: Remove all members in a sorted set between the given lexicographical range
  ZREMRANGEBYRANK key start stop
  summary: Remove all members in a sorted set within the given indexes
  ZREMRANGEBYSCORE key min max
  summary: Remove all members in a sorted set within the given scores
  ZREVRANGE key start stop [WITHSCORES]
  summary: Return a range of members in a sorted set, by index, with scores ordered from high to low
  ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count]
  summary: Return a range of members in a sorted set, by score, with scores ordered from high to low
  ZREVRANK key member
  summary: Determine the index of a member in a sorted set, with scores ordered from high to low
  ZSCAN key cursor [MATCH pattern] [COUNT count]
  summary: Incrementally iterate sorted sets elements and associated scores
  ZSCORE key member
  summary: Get the score associated with the given member in a sorted set
  ZUNIONSTORE destination numkeys key [key ...] [WEIGHTS weight] [AGGREGATE SUM|MIN|MAX]
  summary: Add multiple sorted sets and store the resulting sorted set in a new key

}

hset(key, field, value)：向名称为key的hash中添加元素field
hget(key, field)：返回名称为key的hash中field对应的value
hmget(key, (fields))：返回名称为key的hash中field i对应的value
hmset(key, (fields))：向名称为key的hash中添加元素field
hincrby(key, field, integer)：将名称为key的hash中field的value增加integer
hexists(key, field)：名称为key的hash中是否存在键为field的域
hdel(key, field)：删除名称为key的hash中键为field的域
hlen(key)：返回名称为key的hash中元素个数
hkeys(key)：返回名称为key的hash中所有键
hvals(key)：返回名称为key的hash中所有键对应的value
hgetall(key)：返回名称为key的hash中所有的键（field）及其对应的value
hash(help @hash)
{
  HDEL key field [field ...]
  summary: Delete one or more hash fields
  HEXISTS key field
  summary: Determine if a hash field exists
  HGET key field
  summary: Get the value of a hash field
  HGETALL key
  summary: Get all the fields and values in a hash
  HINCRBY key field increment
  summary: Increment the integer value of a hash field by the given number
  HINCRBYFLOAT key field increment
  summary: Increment the float value of a hash field by the given amount
  HKEYS key
  summary: Get all the fields in a hash
  HLEN key
  summary: Get the number of fields in a hash
  HMGET key field [field ...]
  summary: Get the values of all the given hash fields
  HMSET key field value [field value ...]
  summary: Set multiple hash fields to multiple values
  HSCAN key cursor [MATCH pattern] [COUNT count]
  summary: Incrementally iterate hash fields and associated values
  HSET key field value
  summary: Set the string value of a hash field
  HSETNX key field value
  summary: Set the value of a hash field, only if the field does not exist
  HVALS key
  summary: Get all the values in a hash

}

psubscribe：订阅一个或多个符合给定模式的频道 例如psubscribe news.* tweet.*
publish：将信息 message 发送到指定的频道 channel 例如publish msg "good morning"
pubsub channels：列出当前的活跃频道 例如PUBSUB CHANNELS news.i*
pubsub numsub：返回给定频道的订阅者数量 例如PUBSUB NUMSUB news.it news.internet news.sport news.music
pubsub numpat：返回客户端订阅的所有模式的数量总和
punsubscribe：指示客户端退订所有给定模式。
subscribe：订阅给定的一个或多个频道的信息。例如 subscribe msg chat_room
unsubscribe：指示客户端退订给定的频道。
subpub(help @subpub)
{
  PSUBSCRIBE pattern [pattern ...]
  summary: Listen for messages published to channels matching the given patterns
  PUBLISH channel message
  summary: Post a message to a channel
  PUBSUB subcommand [argument [argument ...]]
  summary: Inspect the state of the Pub/Sub subsystem
  PUNSUBSCRIBE [pattern [pattern ...]]
  summary: Stop listening for messages posted to channels matching the given patterns
  SUBSCRIBE channel [channel ...]
  summary: Listen for messages published to the given channels
  UNSUBSCRIBE [channel [channel ...]]
  summary: Stop listening for messages posted to the given channels

}

transactions(help @transactions)
{
  DISCARD -
  summary: Discard all commands issued after MULTI
  EXEC -
  summary: Execute all commands issued after MULTI
  MULTI -
  summary: Mark the start of a transaction block
  UNWATCH -
  summary: Forget about all watched keys
  WATCH key [key ...]
  summary: Watch the given keys to determine execution of the MULTI/EXEC block

}

默认直接连接  远程连接-h 192.168.1.20 -p 6379
ping：测试连接是否存活如果正常会返回pong
echo：打印
select：切换到指定的数据库，数据库索引号 index 用数字值指定，以 0 作为起始索引值
quit：关闭连接（connection）
auth：简单密码认证
connection(help @connection)
{
  AUTH password
  summary: Authenticate to the server
  ECHO message
  summary: Echo the given string
  PING -
  summary: Ping the server
  QUIT -
  summary: Close the connection
  SELECT index
  summary: Change the selected database for the current connection

}

time：返回当前服务器时间
client list: 返回所有连接到服务器的客户端信息和统计数据  参见http://redisdoc.com/server/client_list.html
client kill ip:port：关闭地址为 ip:port 的客户端
save：将数据同步保存到磁盘
bgsave：将数据异步保存到磁盘
lastsave：返回上次成功将数据保存到磁盘的Unix时戳
shundown：将数据同步保存到磁盘，然后关闭服务
info：提供服务器的信息和统计
config resetstat：重置info命令中的某些统计数据
config get：获取配置文件信息
config set：动态地调整 Redis 服务器的配置(configuration)而无须重启，可以修改的配置参数可以使用命令 CONFIG GET * 来列出
config rewrite：Redis 服务器时所指定的 redis.conf 文件进行改写
monitor：实时转储收到的请求
slaveof：改变复制策略设置
server(help @server)
{
  BGREWRITEAOF -
  summary: Asynchronously rewrite the append-only file
  BGSAVE -
  summary: Asynchronously save the dataset to disk
  CLIENT GETNAME -
  summary: Get the current connection name
  CLIENT KILL ip:port
  summary: Kill the connection of a client
  CLIENT LIST -
  summary: Get the list of client connections
  CLIENT PAUSE timeout
  summary: Stop processing commands from clients for some time
  CLIENT SETNAME connection-name
  summary: Set the current connection name
  CONFIG GET parameter
  summary: Get the value of a configuration parameter
  CONFIG RESETSTAT -
  summary: Reset the stats returned by INFO
  CONFIG REWRITE -
  summary: Rewrite the configuration file with the in memory configuration
  CONFIG SET parameter value
  summary: Set a configuration parameter to the given value
  DBSIZE -
  summary: Return the number of keys in the selected database
  DEBUG OBJECT key
  summary: Get debugging information about a key
  DEBUG SEGFAULT -
  summary: Make the server crash
  FLUSHALL -
  summary: Remove all keys from all databases
  FLUSHDB -
  summary: Remove all keys from the current database
  INFO [section]
  summary: Get information and statistics about the server
  LASTSAVE -
  summary: Get the UNIX time stamp of the last successful save to disk
  MONITOR -
  summary: Listen for all requests received by the server in real time
  SAVE -
  summary: Synchronously save the dataset to disk
  SHUTDOWN [NOSAVE] [SAVE]
  summary: Synchronously save the dataset to disk and then shut down the server
  SLAVEOF host port
  summary: Make the server a slave of another instance, or promote it as master
  SLOWLOG subcommand [argument]
  summary: Manages the Redis slow queries log
  SYNC -
  summary: Internal command used for replication
  TIME -
  summary: Return the current server time

}

scripting(help @scripting)
{
  EVAL script numkeys key [key ...] arg [arg ...]
  summary: Execute a Lua script server side
  EVALSHA sha1 numkeys key [key ...] arg [arg ...]
  summary: Execute a Lua script server side
  SCRIPT EXISTS script [script ...]
  summary: Check existence of scripts in the script cache.
  SCRIPT FLUSH -
  summary: Remove all the scripts from the script cache.
  SCRIPT KILL -
  summary: Kill the script currently in execution.
  SCRIPT LOAD script
  summary: Load the specified Lua script into the script cache.

}

hyperloglog(help @hyperloglog)
{
  PFADD key element [element ...]
  summary: Adds the specified elements to the specified HyperLogLog.
  PFCOUNT key [key ...]
  summary: Return the approximated cardinality of the set(s) observed by the HyperLogLog at key(s).
  PFMERGE destkey sourcekey [sourcekey ...]
  summary: Merge N different HyperLogLogs into a single one.
}

}


 
