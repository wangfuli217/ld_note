Memcached(){
1. Memcached 是一个高性能的分布式内存对象缓存系统，用于动态Web应用以减轻数据库负载。它通过在内存中缓存数据和对象来减少读取数据库的次数，
   从而提供动态、数据库驱动网站的速度。Memcached基于一个存储键/值对的hashmap。其守护进程（daemon）是用C写的，但是客户端可以用任何语言
   来编写，并通过memcached协议与守护进程通信。但是它并不提供冗余（例如，复制其hashmap条目）；当某个服务器S停止运行或崩溃了，所有存放
   在S上的键/值对都将丢失。

2. Memcached采用的是单进程多线程的编程模型。通常来讲，可开启的线程数量受制于主机的CPU核数。由于Memcached是基于libevent而开发的，那么
   Memcached内部的每一任务的处理都是基于事件(event)的。并且为了得到较高的处理性能，Memcached又在event之上增加了"单事件，多处理"的机制。
   也就是在单次事件中，可以处理多个客户请求。类似于Linux内核驱动中的数据接收与发送处理模型中的NAPI（New Application Programming Interface）
   的工作原理，这样可以获得很大的性能提升。
}

http://blog.chinaunix.net/xmlrpc.php?r=blog/article&uid=24585858&id=3040563

prepare(){
1. 安装
$./configure --with-libevent=/usr/local/libevent
$make
$sudo make install

man memcached

2. 调试
$sudo make uninstall命令进行卸载
$make  CFLAGS="-g -O0"
$sudo make install
$gdb memcached

3. 启动命令
设置-l和-p分别用来设置ip和监听的端口。-vv是输出一些运行信息。
$memcached  -l 192.168.10.109  -p 8888  -vv -u root

4. 如何阅读memcached源代码
4.1 内部有哈希表、slab内存分配器、LRU队列 《memcached完全剖析》
4.2 分模块阅读代码，可以单独阅读slabs.c文件、assoc.c文件、items.c文件。
# https://blog.csdn.net/unix21/article/details/15501049

5. 后台启动
/usr/local/memcached/bin/memcached -p 11211 -m 64m -d
或者
/usr/local/memcached/bin/memcached -d -m 64M -u root -l 192.168.0.200 -p 11211 -c 256 -P /tmp/memcached.pid
}


Scheme(){
1. 一致性Hash算法的目的有两点：
1.1. 节点变动后其他节点受影响尽可能小；
1.2. 节点变动后数据重新分配尽可能均衡 。
2. 为什么要运行 memcached ？
如果网站的高流量很大并且大多数的访问会造成数据库高负荷的状况下，使用 memcached 能够减轻数据库的压力。
3. 适用memcached的业务场景？
3.1 如果网站包含了访问量很大的动态网页，因而数据库的负载将会很高。由于大部分数据库请求都是读操作，
    那么memcached可以显著地减小数据库负载。
3.2 如果数据库服务器的负载比较低但CPU使用率很高，这时可以缓存计算好的结果（ computed objects ）
    和渲染后的网页模板（enderred templates）。
3.3 利用memcached可以缓存session数据、临时数据以减少对他们的数据库写操作。
3.4 缓存一些很小但是被频繁访问的文件。
3.5 缓存Web 'services'（非IBM宣扬的Web Services，译者注）或RSS feeds的结果。

4. 不适用memcached的业务场景？
4.1 缓存对象的大小大于1MB
4.2 key的长度大于250字符
4.3 虚拟主机不让运行memcached服务
4.4 应用运行在不安全的环境中
4.5 业务本身需要的是持久化数据或者说需要的应该是database
4.6 能够遍历memcached中所有的item吗？不能

5. memcached是怎么工作的？
    Memcached的高性能源于两阶段哈希（two-stage hash）结构。Memcached就像一个巨大的、存储了很多<key,value>对的
哈希表。通过key，可以存储或查询任意的数据。 客户端可以把数据存储在多台memcached上。当查询数据时，客户端首先
参考节点列表计算出key的哈希值（阶段一哈希），进而选中一个节点；客户端将请求发送给选中的节点，然后memcached节点
通过一个内部的哈希算法（阶段二哈希），查找真正的数据（item）并返回给客户端。
    从实现的角度看，memcached是一个非阻塞的、基于事件的服务器程序。
    
6. memcached最大的优势是什么？
    Memcached最大的好处就是它带来了极佳的水平可扩展性，特别是在一个巨大的系统中。由于客户端自己做了一次哈希，
那么我们很容易增加大量memcached到集群中。memcached之间没有相互通信，因此不会增加 memcached的负载；没有多播协议，
不会网络通信量爆炸（implode）。

7. memcached的cache机制是怎样的？
    Memcached主要的cache机制是LRU（最近最少用）算法+超时失效。当您存数据到memcached中，可以指定该数据在缓存
中可以呆多久Which is forever, or some time in thefuture。如果memcached的内存不够用了，过期的slabs会优先被替换，
接着就轮到最老的未被使用的slabs。

8. 如何将memcached中item批量导入导出？
不应该这样做！

9. memcached是如何做身份验证的？
没有身份认证机制！

10. memcached的多线程是什么？如何使用它们？
    命令解析（memcached在这里花了大部分时间）可以运行在多线程模式下。memcached内部对数据的操作是基于很多
全局锁的（因此这部分工作不是多线程的）。未来对多线程模式的改进，将移除大量的全局锁，提高memcached在负载
极高的场景下的性能。

11. memcached能接受的key的最大长度是多少？
memcached能接受的key的最大长度是250个字符。

12. memcached对item的过期时间有什么限制？
item对象的过期时间最长可以达到30天。

13. memcached最大能存储多大的单个item？
memcached最大能存储1MB的单个item。如果需要被缓存的数据大于1MB，可以考虑在客户端压缩或拆分到多个key中。

14. 为什么单个item的大小被限制在1M byte之内？
简单的回答：因为内存分配器的算法就是这样的。
    Memcached的内存存储引擎，使用slabs来管理内存。内存被分成大小不等的slabs chunks（先分成大小相等的slabs，
然后每个slab被分成大小相等chunks，不同slab的chunk大小是不相等的）。chunk的大小依次从一个最小数开始，按某个
因子增长，直到达到最大的可能值。如果最小值为400B，最大值是1MB，因子是1.20，各个slab的chunk的大小依次是： 
slab1 - 400B；slab2 - 480B；slab3 - 576B ...slab中chunk越大，它和前面的slab之间的间隙就越大。因此，最大值越大，
内存利用率越低。Memcached必须为每个slab预先分配内存，因此如果设置了较小的因子和较大的最大值，会需要为Memcached
提供更多的内存。
    不要尝试向memcached中存取很大的数据，例如把巨大的网页放到mencached中。因为将大数据load和unpack到内存中
需要花费很长的时间，从而导致系统的性能反而不好。如果确实需要存储大于1MB的数据，可以修改slabs.c：POWER_BLOCK
的值，然后重新编译memcached；或者使用低效的malloc/free。另外，可以使用数据库、MogileFS等方案代替Memcached系统。

15. 可以在不同的memcached节点上使用大小不等的缓存空间吗？如果这么做之后，memcached能够更有效地使用内存吗？
    Memcache客户端仅根据哈希算法来决定将某个key存储在哪个节点上，而不考虑节点的内存大小。因此，可以在不同
的节点上使用大小不等的内存作为缓存空间。但是一般可以这样做：拥有较多内存的节点上可以运行多个memcached实例，
每个实例使用的内存跟其他节点上的实例相同。

16. 什么是二进制协议，是否需要关注？
    二进制协议尝试为端提供一个更有效的、可靠的协议，减少客户端/服务器端因处理协议而产生的CPU时间。
根据Facebook的测试，解析ASCII协议是memcached中消耗CPU时间最多的环节。

17. memcached的内存分配器是如何工作的？为什么不适用malloc/free！？为何要使用slabs？
    实际上，这是一个编译时选项。默认会使用内部的slab分配器，而且确实应该使用内建的slab分配器。
最早的时候，memcached只使用malloc/free来管理内存。然而，这种方式不能与OS的内存管理以前很好地工作。
反复地malloc/free造成了内存碎片，OS最终花费大量的时间去查找连续的内存块来满足malloc的请求，
而不是运行memcached进程。

18. memcached是原子的吗？
    所有的被发送到memcached的单个命令是完全原子的。如果您针对同一份数据同时发送了一个set命令和一个get命令，
它们不会影响对方。它们将被串行化、先后执行。

19. memcached没有我的database快，为什么？
    在一对一比较中，memcached可能没有SQL查询快。但是，这不是memcached的设计目标。Memcached的目标是可伸缩性。
当连接和请求增加的时候，memcached的性能将比大多数数据库查询好。可以先在高负载的环境（并发的连接和请求）
中测试您的代码，然后再决定memcached是否适合您。

todo: https://github.com/itrunc/notes
}

cmd(){
telnet HOST PORT
命令中的 HOST 和 PORT 为运行 Memcached 服务的 IP 和 端口。

set foo 0 0 3  保存命令
bar            数据
STORED         结果
get foo        取得命令
VALUE foo 0 3  数据
bar            数据
END            结束行
quit           退出
}
cmd(set){
Memcached set 命令用于将 value(数据值) 存储在指定的 key(键) 中。
如果set的key已经存在，该命令可以更新该key所对应的原来的数据，也就是实现更新的作用。

set key flags exptime bytes [noreply] 
value 
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
STORED：保存成功后输出。
ERROR：在保存失败后输出。

set runoob 0 900 9
memcached
STORED

get runoob
VALUE runoob 0 9
memcached

END

key          runoob
flag         0
exptime      900 (以秒为单位)
bytes        9 (数据存储的字节数)
value        memcached
}

cmd(add){
Memcached add 命令用于将 value(数据值) 存储在指定的 key(键) 中。
如果 add 的 key 已经存在，则不会更新数据(过期的 key 会更新)，之前的值将仍然保持相同，并且您将获得响应 NOT_STORED。
add key flags exptime bytes [noreply]
value
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
    
STORED：保存成功后输出。
NOT_STORED ：在保存失败后输出。

add new_key 0 900 10
data_value
STORED
add new_key 0 900 10
data_value
NOT_STORED
}

cmd(replace){
Memcached replace 命令用于替换已存在的 key(键) 的 value(数据值)。
如果 key 不存在，则替换失败，并且您将获得响应 NOT_STORED。

replace key flags exptime bytes [noreply]
value
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
    
输出信息说明：
    STORED：保存成功后输出。
    NOT_STORED：执行替换失败后输出。
}

cmd(append){
Memcached append 命令用于向已存在 key(键) 的 value(数据值) 后面追加数据 。
append key flags exptime bytes [noreply]
value
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
输出信息说明：
    STORED：保存成功后输出。
    NOT_STORED：该键在 Memcached 上不存在。
    CLIENT_ERROR：执行错误。
}
cmd(prepend){
Memcached prepend 命令用于向已存在 key(键) 的 value(数据值) 前面追加数据 。
prepend key flags exptime bytes [noreply]
value
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
输出信息说明：
    STORED：保存成功后输出。
    NOT_STORED：该键在 Memcached 上不存在。
    CLIENT_ERROR：执行错误。
}
cmd(cas){
Memcached CAS（Check-And-Set 或 Compare-And-Swap） 命令用于执行一个"检查并设置"的操作
它仅在当前客户端最后一次取值后，该key 对应的值没有被其他客户端修改的情况下， 才能够将值写入。
检查是通过cas_token参数进行的， 这个参数是Memcach指定给已经存在的元素的一个唯一的64位值。

cas key flags exptime bytes unique_cas_token [noreply]
value
参数说明如下：
  key：键值 key-value 结构中的 key，用于查找缓存值。
  flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
  exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
  bytes：在缓存中存储的字节数
  unique_cas_token通过 gets 命令获取的一个唯一的64位值。
  noreply（可选）： 该参数告知服务器不需要返回数据
  value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
输出信息说明：
  STORED：保存成功后输出。
  ERROR：保存出错或语法错误。
  EXISTS：在最后一次取值后另外一个用户也在更新该数据。
  NOT_FOUND：Memcached 服务上不存在该键值。

实例步骤如下：
    如果没有设置唯一令牌，则 CAS 命令执行错误。
    如果键 key 不存在，执行失败。
    添加键值对。
    通过 gets 命令获取唯一令牌。
    使用 cas 命令更新数据
    使用 get 命令查看数据是否更新

cas tp 0 900 9
ERROR             <− 缺少 token

cas tp 0 900 9 2
memcached
NOT_FOUND         <− 键 tp 不存在

set tp 0 900 9
memcached
STORED

gets tp
VALUE tp 0 9 1
memcached
END

cas tp 0 900 5 1
redis
STORED

get tp
VALUE tp 0 5
redis
END
}
cmd(incr decr){
Memcached incr 与 decr 命令用于对已存在的 key(键) 的数字值进行自增或自减操作。
incr 与 decr 命令操作的数据必须是十进制的32位无符号整数。
如果 key 不存在返回 NOT_FOUND，如果键的值不为数字，则返回 CLIENT_ERROR，其他错误返回 ERROR。

incr key increment_value
参数说明如下：
  key：键值 key-value 结构中的 key，用于查找缓存值。
  increment_value： 增加的数值。

  NOT_FOUND：key 不存在。
  CLIENT_ERROR：自增值不是对象。
  ERROR其他错误，如语法错误等。
}
cmd(stats){
Memcached stats 命令用于返回统计信息例如 PID(进程号)、版本号、连接数等。
stats
pid： memcache服务器进程ID
uptime：服务器已运行秒数
time：服务器当前Unix时间戳
version：memcache版本
pointer_size：操作系统指针大小
rusage_user：进程累计用户时间
rusage_system：进程累计系统时间
curr_connections：当前连接数量
total_connections：Memcached运行以来连接总数
connection_structures：Memcached分配的连接结构数量
cmd_get：get命令请求次数
cmd_set：set命令请求次数
cmd_flush：flush命令请求次数
get_hits：get命令命中次数
get_misses：get命令未命中次数
delete_misses：delete命令未命中次数
delete_hits：delete命令命中次数
incr_misses：incr命令未命中次数
incr_hits：incr命令命中次数
decr_misses：decr命令未命中次数
decr_hits：decr命令命中次数
cas_misses：cas命令未命中次数
cas_hits：cas命令命中次数
cas_badval：使用擦拭次数
auth_cmds：认证命令处理的次数
auth_errors：认证失败数目
bytes_read：读取总字节数
bytes_written：发送总字节数
limit_maxbytes：分配的内存总大小（字节）
accepting_conns：服务器是否达到过最大连接（0/1）
listen_disabled_num：失效的监听数
threads：当前线程数
conn_yields：连接操作主动放弃数目
bytes：当前存储占用的字节数
curr_items：当前存储的数据总数
total_items：启动以来存储的数据总数
evictions：LRU释放的对象数目
reclaimed：已过期的数据条目来存储新数据的数目
}
cmd(stats items){
Memcached stats items 命令用于显示各个 slab 中 item 的数目和存储时长(最后一次访问距离现在的秒数)。
}
cmd(stats slabs){
stats slabs 命令用于显示各个slab的信息，包括chunk的大小、数目、使用情况等。
}
cmd(stats sizes){
Memcached stats sizes 命令用于显示所有item的大小和个数。
该信息返回两列，第一列是 item 的大小，第二列是 item 的个数。
}
cmd(flush_all){
Memcached flush_all 命令用于清理缓存中的所有 key=>value(键=>值) 对。
该命令提供了一个可选参数 time，用于在制定的时间后执行清理缓存操作。

flush_all 命令的基本语法格式如下：
flush_all [time] [noreply]
}

