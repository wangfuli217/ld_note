
一、 环境搭建
  1.简介
    redis是一个开源的key-value数据库。
    它又经常被认为是一个数据结构服务器。因为它的value不仅包括基本的 string 类型还有 list, set ,sorted set和hash类型。当然这些类型的元素也都是string类型。也就是说list, set这些集合类型也只能包含string 类型。你可以在这些类型上做很多原子性的操作。比如对一个字符value追加字符串（APPEND命令）。加加或者减减一个数字字符串(INCR命令, 当然是按整数处理的).可以对list类型进行push,或者pop元素操作（可以模拟栈和队列）。对于set类型可以进行一些集合相关操作 (intersection union difference)。
    Memcache 也有类似与++,--的命令。不过memcache的 value只包括string类型。远没有redis 的value类型丰富。
    和 memcahe 一样为了性能。redis的数据通常都是放到内存中的。当然 redis 可以每间隔一定时间将内存中数据写入到磁盘以防止数据丢失。
    redis 也支持主从复制机制（master-slave replication）。
    Redis 的其他特性包括简单的事务支持和 发布订阅(pub/sub)通道功能,而且redis 配置管理非常简单。还有各种语言版本的开源客户端类库。

    中文参考文档: http://redis.readthedocs.org/en/latest/index.html

  2.安装
    Linux:
        下载地址：http://code.google.com/p/redis/
         http://redis.googlecode.com/files/redis-2.2.11.tar.gz

        可以在linux下运行如下命令进行安装:
        $ tar xzf redis-2.2.11.tar.gz
        $ cd redis-2.2.11
        $ make

        $ sudo apt-get install redis-server

        make完后 redis-2.2.11目录下会出现编译后的redis服务程序redis-server,还有用于测试的客户端程序redis-cli

        启动redis服务:
            $ src/redis-server

        注意这种方式启动redis 使用的是默认配置。也可以通过启动参数告诉redis使用指定配置文件使用下面命令启动.
        redis.conf是一个默认的配置文件。我们可以根据需要使用自己的配置文件。
            $ src/redis-server redis.conf
            $ src/redis-cli  # 客户端,默认端口: 6379
            $ soft/redis/redis-cli -a AGW_redis_p@ssw0rd  -h 117.121.55.208 -p 6371 # -a密码 -h地址 -p端口号

        启动redis服务进程后, 就可以使用测试客户端程序redis-cli和redis服务交互了.


    Windows:
        Windows版的Redis可到此处下载, 非官方版：  http://code.google.com/p/servicestack/wiki/RedisWindowsDownload
        微软自己写的： https://github.com/MSOpenTech/redis

        解压下载的redis包。我的windows下的解压地址是D:\redis-2.0.2
        将redis.conf 拷贝到D:\redis-2.0.2\下

        指定redis的配置文件, 如没有指定, 则使用默认设置
        启动服务器端：
        D:\redis-2.0.2>redis-server.exe redis.conf

        启动命令客户端：
        D:\redis-2.0.2>redis-cli.exe -h 192.168.1.51 -p 6379
        192.168.1.51 是我本地的地址


二、 数据类型
     redis支持的各种数据类型包括: string, list, set, sorted set 和 hash

  1. keys
    redis本质上一个 key-value db。首先key也是字符串类型, 但是key中不能包括边界字符(像"my key"和"mykey\n"这样包含空格和换行的key是不允许的)
    顺便说一下在redis内部并不限制使用binary字符, 这是redis协议限制的。"\r\n"在协议格式中会作为特殊字符。
    redis 1.2以后的协议中部分命令已经开始使用新的协议格式了(比如MSET)。总之目前还是把包含边界字符当成非法的key吧, 免得被bug纠缠。

    另外关于key的一个格式约定介绍下, object-type:id:field。比如： user:1000:password, blog:xxidxx:title
    还有key的长度最好不要太长, 以节省内存和提高查找效率。不过也推荐过短的key, 为了有更好的可读性。

   key 相关的命令：
    set key1 value1             设置变量 key1 的值为 value1
    get key1                    获取变量 key1 的值
    exits key                   测试指定key是否存在, 返回1表示存在, 0不存在  # 测试不通过,不存在
    del key1 key2 ....keyN      删除给定key, 返回删除key的数目, 0表示给定key都不存在
    type key                    返回给定 key 的 value 类型。返回 none 表示不存在key、 string字符类型、 list 链表类型、 set 无序集合类型...
    keys pattern                返回匹配指定模式的所有key
    randomkey                   返回从当前数据库中随机选择的一个key,如果当前数据库是空的, 返回空串
    rename oldkey newkey        原子的重命名一个key,如果newkey存在, 将会被覆盖, 返回1表示成功, 0失败。可能是oldkey不存在或者和newkey相同
    renamenx oldkey newkey      同上, 但是如果newkey存在返回失败
    dbsize                      返回当前数据库的key数量
    expire key seconds          为key指定过期时间, 单位是秒。返回1成功, 0表示key已经设置过过期时间或者不存在
    ttl key                     返回设置过过期时间的key的剩余过期秒数 -1表示key不存在或者没有设置过过期时间
    select db-index             通过索引选择数据库, 默认连接的数据库所有是0,默认数据库数是16个。返回1表示成功, 0失败
    move key db-index           将key从当前数据库移动到指定数据库。返回1成功。0 如果key不存在, 或者已经在指定数据库中
    flushdb                     删除当前数据库中所有key,此方法不会失败。慎用
    flushall                    删除所有数据库中的所有key, 此方法不会失败。更加慎用

   例如：
    redis> set test dsf     -- 设置变量 test
    redis> set tast dsaf    -- 设置变量 tast
    redis> set tist adff    -- 设置变量 tist
    redis> get tast         -- 获取变量 tast 的值
    "dsaf"
    redis> keys t*          -- 查询所有 t 开头的变量
    1. "tist"
    2. "tast"
    3. "test"
    redis> keys t[ia]st     -- 按指定正则表达式查询变量
    1. "tist"
    2. "tast"
    redis> keys t?st        -- 按指定正则表达式查询变量
    1. "tist"
    2. "tast"
    3. "test"
    redis> del tast         -- 删除指定的变量
    redis> type test        -- 查询指定变量的 value 的类型,显示 string
    redis> flushdb          -- 删除当前数据库中所有key
    OK
    redis> dbsize           -- 当前数据库的key数量
    (integer) 0


  2. string 类型
     string是redis最基本的类型, 而且string类型是二进制安全的。意思是redis的string可以包含任何数据。比如jpg图片或者序列化的对象。
     从内部实现来看其实string可以看作byte数组, 最大上限是1G字节。因为它本质上就是个byte数组。当然可以包含任何数据了。
     另外string类型可以被部分命令按int处理.比如incr等命令。
     redis的其他类型像 list, set, sorted set , hash 它们包含的元素与都只能是string类型。
     如果只用string类型, redis就可以被看作加上持久化特性的memcached.当然redis对string类型的操作比memcached多很多啊。

   string 相关的命令：
    set key value                       设置key对应的值为string类型的value,返回1表示成功, 0失败
    setnx key value                     同上, 如果key已经存在, 返回0 。nx 是not exist的意思
    get key                             获取key对应的string值,如果key不存在返回 (nil)
    getset key value                    原子的设置key的值, 并返回key的旧值。如果key不存在返回 (nil)
    mget key1 key2 ... keyN             一次获取多个key的值, 如果对应key不存在, 则对应返回nil。下面是个实验,首先清空当前数据库, 然后设置k1,k2.获取时k3对应返回 (nil)
    mset key1 value1 ... keyN valueN    一次设置多个key的值, 成功返回1表示所有的值都设置了, 失败返回0表示没有任何值被设置
    msetnx key1 value1 ... keyN valueN  同上, 但是不会覆盖已经存在的key
    incr key                            对key的值做加加操作,并返回新的值。注意incr一个不是int的value会返回错误, incr一个不存在的key, 则设置key为1
    decr key                            同上, 但是做的是减减操作, decr一个不存在key, 则设置key为-1
    incrby key integer                  同incr, 加指定值 , key不存在时候会设置key, 并认为原来的value是 0
    decrby key integer                  同decr, 减指定值。decrby完全是为了可读性, 我们完全可以通过incrby一个负值来实现同样效果, 反之一样。
    append key value                    给指定key的字符串值追加value,返回新字符串值的长度。
    substr key start end                返回截取过的key的字符串值,注意并不修改key的值。下标从0开始

   例如：
    redis> set k1 a
    OK
    redis> set k2 b
    OK
    redis> mget k1 k2 k3
    1. "a"
    2. "b"
    3. (nil)
    redis> set k hello
    OK
    redis> append k ,world  -- 字符串拼接
    (integer) 11
    redis> get k
    "hello,world"
    redis> substr k 0 8     -- 字符串截取, 3个参数都必须有
    "hello,wor"
    redis> get k
    "hello,world"


  3. list
    redis的list类型其实就是一个每个子元素都是string类型的双向链表。所以[lr]push和[lr]pop命令的算法时间复杂度都是O(1)
    另外list会记录链表的长度。所以llen操作也是O(1).链表的最大长度是(2的32次方-1)。
    我们可以通过push,pop操作从链表的头部或者尾部添加删除元素。这使得list既可以用作栈, 也可以用作队列。
    有意思的是list的pop操作还有阻塞版本的。当我们[lr]pop一个list对象时, 如果list是空, 或者不存在, 会立即返回(nil)。
    但是阻塞版本的b[lr]pop则可以阻塞, 当然可以加超时时间, 超时后也会返回(nil)。

  list 相关命令:
    lpush key string            在key对应list的头部添加字符串元素, 返回list的长度表示成功, 0表示key存在且不是list类型
    rpush key string            同上, 在尾部添加
    llen key                    返回key对应list的长度, key不存在返回0,如果key对应类型不是list返回错误
    lrange key start end        返回指定区间内的元素, 下标从0开始, 负值表示从后面计算, -1表示倒数第一个元素 , key不存在返回空列表
    ltrim key start end         截取list, 保留指定区间内元素, 成功返回1, key不存在返回错误
    lset key index value        设置list中指定下标的元素值, 成功返回1, key或者下标不存在返回错误
    lrem key count value        从key对应list中删除count个和value相同的元素。count为0时候删除全部
    lpop key                    从list的头部删除元素, 并返回删除元素。如果key对应list不存在或者是空返回nil, 如果key对应值不是list返回错误
    rpop                        同上, 但是从尾部删除
    blpop key1...keyN timeout   从左到右扫描返回对第一个非空list进行lpop操作并返回, 比如blpop list1 list2 list3 0 ,
                                如果list不存在 list2,list3 都是非空则对list2做lpop并返回从list2中删除的元素。
                                如果所有的list都是空或不存在, 则会阻塞timeout秒, timeout为0表示一直阻塞。
                                当阻塞时, 如果有client对key1...keyN中的任意key进行push操作, 则第一在这个key上被阻塞的client会立即返回。
                                如果超时发生, 则返回(nil)。有点像unix的select或者poll
    brpop                       同blpop, blpop是从头部删除,这个是从尾部删除
    rpoplpush srckey destkey    从srckey对应list的尾部移除元素并添加到destkey对应list的头部,最后返回被移除的元素值, 整个操作是原子的.如果srckey是空或者不存在返回nil


  4. set
     redis的set是string类型的无序集合。set元素最大可以包含(2的32次方-1)个元素。
     set的是通过hash table实现的, 所以添加, 删除, 查找的复杂度都是O(1)。hash table会随着添加或者删除自动的调整大小。
     需要注意的是调整hash table大小时候需要同步（获取写锁）会阻塞其他读写操作。可能不久后就会改用跳表（skip list）来实现跳表已经在sorted set中使用了。
     关于set集合类型除了基本的添加删除操作, 其他有用的操作还包含集合的取并集(union), 交集(intersection), 差集(difference)。

  set 相关命令
    sadd key member                 添加一个string元素到,key对应的set集合中, 成功返回1,如果元素以及在集合中返回0,key对应的set不存在返回错误
    srem key member                 从key对应set中移除给定元素, 成功返回1, 如果member在集合中不存在或者key不存在返回0, 如果key对应的不是set类型的值返回错误
    spop key                        删除并返回key对应set中随机的一个元素,如果set是空或者key不存在返回nil
    srandmember key                 同spop, 随机取set中的一个元素, 但是不删除元素
    smove srckey dstkey member      从srckey对应set中移除member并添加到dstkey对应set中, 整个操作是原子的。
                                    成功返回1,如果member在srckey中不存在返回0, 如果key不是set类型返回错误
    scard key                       返回set的元素个数, 如果set是空或者key不存在返回0
    sismember key member            判断member是否在set中, 存在返回1, 0表示不存在或者key不存在
    sinter key1 key2...keyN         返回所有给定key的交集
    sinterstore dstkey key1...keyN  同sinter, 但是会同时将交集存到dstkey下
    sunion key1 key2...keyN         返回所有给定key的并集
    sunionstore dstkey key1...keyN  同sunion, 并同时保存并集到dstkey下
    sdiff key1 key2...keyN          返回所有给定key的差集
    sdiffstore dstkey key1...keyN   同sdiff, 并同时保存差集到dstkey下
    smembers key                    返回key对应set的所有元素, 结果是无序的


  5. sorted set
     和set一样sorted set也是string类型元素的集合, 不同的是每个元素都会关联一个double类型的score。sorted set的实现是skip list和hash table的混合体
     当元素被添加到集合中时, 一个元素到score的映射被添加到hash table中, 所以给定一个元素获取score的开销是O(1),另一个score到元素的映射被添加到skip list并按照score排序, 所以就可以有序的获取集合中的元素。
     添加, 删除操作开销都是O(log(N))和skip list的开销一致,redis的skip list实现用的是双向链表,这样就可以逆序从尾部取元素。
     sorted set最经常的使用方式应该是作为索引来使用.我们可以把要排序的字段作为score存储, 对象的id当元素存储。

 sorted set 相关命令:
    zadd key score member           添加元素到集合, 元素在集合中存在则更新对应score；score必须是数字
    zrem key member                 删除指定元素, 1表示成功, 如果元素不存在返回0
    zincrby key incr member         增加对应member的score值, 然后移动元素并保持skip list保持有序。返回更新后的score值
    zrank key member                返回指定元素在集合中的排名（下标）,集合中元素是按score从小到大排序的
    zrevrank key member             同上,但是集合中元素是按score从大到小排序
    zrange key start end            类似lrange操作从集合中去指定区间的元素。返回的是有序结果
    zrevrange key start end         同上, 返回结果是按score逆序的
    zrangebyscore key min max       返回集合中score在给定区间的元素
    zcount key min max              返回集合中score在给定区间的数量
    zcard key                       返回集合中元素个数
    zscore key element              返回给定元素对应的score
    zremrangebyrank key min max     删除集合中排名在给定区间的元素
    zremrangebyscore key min max    删除集合中score在给定区间的元素

  6. hash
     redis hash是一个string类型的field和value的映射表.它的添加, 删除操作都是O(1)（平均）.hash特别适合用于存储对象。相较于将对象的每个字段存成单个string类型。
     将一个对象存储在hash类型中会占用更少的内存, 并且可以更方便的存取整个对象。省内存的原因是新建一个hash对象时开始是用zipmap（又称为small hash）来存储的。
     这个zipmap其实并不是hash table, 但是zipmap相比正常的hash实现可以节省不少hash本身需要的一些元数据存储开销。
     尽管zipmap的添加, 删除, 查找都是O(n), 但是由于一般对象的field数量都不太多。所以使用zipmap也是很快的,也就是说添加删除平均还是O(1)。
     如果field或者value的大小超出一定限制后, redis会在内部自动将zipmap替换成正常的hash实现. 这个限制可以在配置文件中指定:
        hash-max-zipmap-entries 64  -- 配置字段最多64个
        hash-max-zipmap-value 512   -- 配置value最大为512字节

  下面介绍hash相关命令:
    hset key field value                        设置hash field为指定值, 如果key不存在, 则先创建
    hget key field                              获取指定的hash field
    hmget key filed1....fieldN                  获取全部指定的hash filed
    hmset key filed1 value1 ... filedN valueN   同时设置hash的多个field
    hincrby key field integer                   将指定的hash filed 加上给定值
    hexists key field                           测试指定field是否存在
    hdel key field                              删除指定的hash field
    hlen key                                    返回指定hash的field数量
    hkeys key                                   返回hash的所有field
    hvals key                                   返回hash的所有value
    hgetall                                     返回hash的所有filed和value


三、 排序
     redis支持对 list, set 和 sorted set 元素的排序。
     排序命令是sort 完整的命令格式如下：
       SORT key [BY pattern] [LIMIT start count] [GET pattern] [ASC|DESC] [ALPHA] [STORE dstkey]

   各种命令选项:
    （1）sort key
         这个是最简单的情况, 没有任何选项就是简单的对集合自身元素排序并返回排序结果.

       例如：
        redis> lpush ml 12 -- 添加一个 list 元素, 显示内容这里不再写
        redis> lpush ml 11
        redis> lpush ml 23
        redis> lpush ml 13
        redis> lrange ml 0 3  -- 直接显示的顺序
        1. "13"
        2. "23"
        3. "11"
        4. "12"
        redis> sort ml  -- 排序显示(并不会改变原来的 list 的排序, 只是本次显示而已)
        1. "11"
        2. "12"
        3. "13"
        4. "23"

    (2) [ASC|DESC] [ALPHA]
        sort默认的排序方式（asc）是从小到大排的,当然也可以按照逆序或者按字符顺序排。逆序可以加上desc选项, 想按字母顺序排可以加alpha选项, 当然alpha可以和desc一起用。

       例如：
        redis> lpush mylist baidu
        redis> lpush mylist hello
        redis> lpush mylist xhan
        redis> lpush mylist soso
        redis> sort mylist -- 跟没有排序的显示一样,因为没有数字, 又不按字母排序
        1. "soso"
        2. "xhan"
        3. "hello"
        4. "baidu"
        redis> sort mylist alpha -- 按字母排序
        1. "baidu"
        2. "hello"
        3. "soso"
        4. "xhan"
        redis> sort mylist desc alpha
        1. "xhan"
        2. "soso"
        3. "hello"
        4. "baidu"


    （3）[BY pattern]
        除了可以按集合元素自身值排序外, 还可以将集合元素内容按照给定pattern组合成新的key, 并按照新key中对应的内容进行排序。

       下面的例子接着使用第一个例子中的ml集合做演示：
        redis> set name11 5
        redis> set name12 6
        redis> set name13 2
        redis> set name14 1
        redis> sort ml by name*
        -- *代表了ml中的元素值, 所以这个排序是按照 name11 name12 name13 name23 这四个key对应值排序的,当然返回的还是排序后ml集合中的元素
        1. "23"  -- 对应 name23 在 name* 中的排序, 因为没有name23, 所以对应的值是(nil), 所以排最前
        2. "13"  -- 对应 name13 在 name* 中的排序, 因为 name13 对应的值是 2, 数值中除 nil 之外最小, 故排第二
        3. "11"  -- 对应 name11 在 name* 中的排序, 因为 name11 对应的值是 5, 比 2 大，但比 6 小， 故排第三
        4. "12"  -- 对应 name12 在 name* 中的排序, 因为 name12 对应的值是 6, 故排第四


    (4) [GET pattern]
        上面的例子都是返回的ml集合中的元素。我们也可以通过get选项去获取指定pattern作为新key对应的值。

       组合起来的例子:
        redis> sort ml by name* get name* alpha
        -- 列表的是“sort ml by name*”中的 name* 对应的排序的值
        1. (nil)
        2. "2"
        3. "5"
        4. "6"

        get选项可以有多个。如：（#特殊符号引用的是原始集合也就是ml）
        redis> sort ml by name* get name* get # alpha
        -- 显示的列表，比上面列表多了原始集合, 即先显示“get name*”再显示“get # alpha”,相错显示
        1. (nil)  -- 对应 name23 的值
        2. "23"
        3. "2"    -- 对应 name13 的值
        4. "13"
        5. "5"    -- 对应 name11 的值
        6. "11"
        7. "6"    -- 对应 name12 的值
        8. "12"

       最后在还有一个引用hash类型字段的特殊字符“->”
       例如：
        redis> hset user1 name 1
        redis> hset user11 name hanjie
        redis> hset user12 name 86
        redis> hset user13 name lxl
        redis> sort ml get user*->name
        -- 查询 user* 里面，hash名为 name 的值(排序是按 ml 的排序)
        1. "hanjie"
        2. "86"
        3. "lxl"
        4. (nil)  -- 对应的user23不存在时候返回的是nil


    (5) [LIMIT start count]
        上面例子返回结果都是全部。limit选项可以限定返回结果的数量。
        start下标是从0开始的, count 是取多少个

       例子
        redis> sort ml limit 1 2
        1. "12"
        2. "13"


    (6) [STORE dstkey]
        如果对集合经常按照固定的模式去排序，那么把排序结果缓存起来会减少不少cpu开销.使用store选项可以将排序内容保存到指定key中。保存的类型是list

       例如： 我们将排序结果保存到了cl中
        redis> sort ml get name* limit 1 2 store cl
        (integer) 2
        redis> type cl
        list
        redis> lrange cl 0 -1
        1. "wo"
        2. "shi"

    关于排序的一些问题：
        1.如果我们有多个 redis server 的话，不同的key可能存在于不同的server上。比如 name12 name13 name23 name11，很有可能分别在四个不同的server上存贮着。这种情况会对排序性能造成很大的影响。redis作者在他的blog上提到了这个问题的解决办法，就是通过key tag将需要排序的key都放到同一个server上 。由于具体决定哪个key存在哪个服务器上一般都是在client端hash的办法来做的。我们可以通过只对key的部分进行hash.举个例子假如我们的client如果发现key中包含[]。那么只对key中[]包含的内容进行hash。我们将四个name相关的key，都这样命名[name]12 [name]13 [name]23 [name]11，于是client 程序就会把他们都放到同一server上。不知道jredis实现了没。
        2.如果要sort的集合非常大的话排序就会消耗很长时间。由于redis单线程的，所以长时间的排序操作会阻塞其他client的请求。解决办法是通过主从复制机制将数据复制到多个slave上。然后我们只在slave上做排序操作。并进可能的对排序结果缓存。另外就是一个方案是就是采用sorted set对需要按某个顺序访问的集合建立索引。



四、 事务
    redis对事务的支持目前还比较简单。只能保证一个client发起的事务中的命令可以连续的执行，而中间不会插入其他client的命令。 由于redis是单线程来处理所有client的请求的所以做到这点是很容易的。一般情况下redis在接受到一个client发来的命令后会立即处理并 返回处理结果，但是当一个client在一个连接中发出multi命令有，这个连接会进入一个事务上下文，该连接后续的命令并不是立即执行，而是先放到一个队列中。当从此连接受到exec命令后，redis会顺序的执行队列中的所有命令。并将所有命令的运行结果打包到一起返回给client.然后此连接就 结束事务上下文。

    例如：
        redis> multi
        OK
        redis> incr a  -- 命令发出后并没执行而是被放到了队列中
        QUEUED
        redis> incr b
        QUEUED
        redis> exec     -- 调用exec后,所有队列中的命令被连续的执行
        1. (integer) 1  -- 运行 incr a 的结果
        2. (integer) 1  -- 运行 incr b 的结果

    我们可以调用discard命令来取消一个事务。discard命令其实就是清空事务的命令队列并退出事务上下文。
    接着上面例子：
        redis> multi
        OK
        redis> incr a
        QUEUED
        redis> incr b
        QUEUED
        redis> discard  -- 取消命令队列，命令也不会再被执行
        OK
        redis> get a
        "1"
        redis> get b
        "1"

    虽说redis事务在本质上也相当于序列化隔离级别的了。但是由于事务上下文的命令只排队并不立即执行，所以事务中的写操作不能依赖事务中的读操作结果。
    主要问题是没有对共享资源的访问进行任何的同步，也就是说redis没提供任何的加锁机制来同步对共享资源的访问。
    例如：
        redis> multi
        OK
        redis> get a
        QUEUED
        redis> get b
        QUEUED
        redis> exec
        1. "1"
        2. "1"

    还好redis 2.1后添加了watch命令，可以用来实现乐观锁。看个正确实现incr命令的例子,只是在前面加了watch a
    watch 命令会监视给定的key,当exec时候如果监视的key从调用watch后发生过变化，则整个事务会失败。也可以调用watch多次监视多个key.这样就可以对指定的key加乐观锁了。
    注意watch的key是对整个连接有效的，事务也一样。如果连接断开，监视和事务都会被自动清除。当然了 exec,discard,unwatch命令都会清除连接中的所有监视.

    redis的事务问题：
       第一个问题是redis只能保证事务的每个命令连续执行，但是如果事务中的一个命令失败了，并不回滚其他命令，比如使用的命令类型不匹配。

    例如：
        redis> set a 5
        OK
        redis> lpush b 5
        (integer) 1
        redis> set c 5
        OK
        redis> multi
        OK
        redis> incr a
        QUEUED
        redis> incr b
        QUEUED
        redis> incr c
        QUEUED
        redis> exec
        1. (integer) 6
        2. (error) ERR Operation against a key holding the wrong kind of value
        3. (integer) 6
        -- 可以看到虽然incr b失败了，但是其他两个命令还是执行了。

    最后一个十分罕见的问题是 当事务的执行过程中，如果redis意外的挂了。很遗憾只有部分命令执行了，后面的也就被丢弃了。
    当然如果我们使用的append-only file方式持久化，redis会用单个write操作写入整个事务内容。即是是这种方式还是有可能只部分写入了事务到磁盘。
    发生部分写入事务的情况下，redis重启时会检测到这种情况，然后失败退出。可以使用redis-check-aof工具进行修复，修复会删除部分写入的事务内容。修复完后就能够重新启动了。



五、 pipeline
    redis是一个cs模式的tcp server，使用和http类似的请求响应协议。一个client可以通过一个socket连接发起多个请求命令。每个请求命令发出后client通常会阻塞并等待redis服务处理，redis处理完后请求命令后会将结果通过响应报文返回给client。
    基本上四个命令需要8个tcp报文才能完成。由于通信会有网络延迟,假如从client和server之间的包传输时间需要0.125秒。那么上面的四个命 令8个报文至少会需要1秒才能完成。这样即使redis每秒能处理100个命令，而我们的client也只能一秒钟发出四个命令。这显示没有充分利用 redis的处理能力。除了可以利用mget,mset 之类的单条命令处理多个key的命令外
    我们还可以利用pipeline的方式从client打包多条命令一起发出，不需要等待单条命令的响应返回，而redis服务端会处理完多条命令后会将多条命令的处理结果打包到一起返回给客户端。
    假设不会因为tcp 报文过长而被拆分。可能两个tcp报文就能完成四条命令,client可以将四个incr命令放到一个tcp报文一起发送，server则可以将四条命令 的处理结果放到一个tcp报文返回。通过pipeline方式当有大批量的操作时候。我们可以节省很多原来浪费在网络延迟的时间。
    需要注意到是用 pipeline方式打包命令发送，redis必须在处理完所有命令前先缓存起所有命令的处理结果。打包的命令越多，缓存消耗内存也越多。所以并是不是打包的命令越多越好。具体多少合适需要根据具体情况测试。











