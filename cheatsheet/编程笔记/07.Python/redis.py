
一、数据库操作
    1. 导入模块
       import redis
       print(redis.VERSION) # 显示 python 的 redis 模块版本号
    2. 数据库连接
       r = redis.Redis(host='localhost', port=6379, db=0) # 直接连接
       pool = redis.ConnectionPool(host='localhost', port=6379, db=0) # 建立连接池
       r = redis.Redis(connection_pool=pool) # 池连接
    3. 设值(添加值)
       r.set('foo', 'bar')   # 返回值: True
       r['foo'] = 'bar'  # 上句的另一种写法
       r.getset('foo', 'jj') # 可以在存新数据的同时,将上次存储内容同时读取出来。返回上次存储的值(没有则返回 None),并将 'jj' 赋值给 'foo'
    4. 取值
       r.get('foo')  # 返回读取的值(没有则返回 None),如: 'bar'
       r['foo']      # 类似上句,返回读取的值(没有时会报错),如: 'bar'
       r.mget('a','foo')  # 同时取一批数据,返回值的 list
    5. 取键
       r.exists('chang')  # 看是否存在这个键值,返回值: True / False
       r.keys()   # 列出所有键值。返回键的 list
       r.keys('a*')  # 按正则匹配一批键出来(*表示任意多个字符,?表示任意一个字符,[内容]匹配中括号里面的任意一个字符,特殊符号用"\"隔开),返回匹配的键的 list
       r.dbsize()   # 库里有多少key，多少条数据, 返回整数
       r.randomkey()  # 随机取一个键
    6. 删除值
       r.delete('foo')  # 删除成功则返回 True, 没有这键则返回 False
       r.delete('c1','c2')  # 它支持批量操作,只要有一个值删除成功则返回 True, 所有这些键都没有则返回 False
       r.flushdb()   # 删除当前数据库的所有数据,返回值: True / False

    7. 取 递增/递减的整数
       print( r.incr('a') )  # 设置一个递增的整数,每执行一次它自加1,返回自增后的整数(第一次时是1)
       print( r.decr('a2') )  # 设置一个递减的整数,每执行一次它自减1,返回自减后的整数(第一次时是-1)
    8. 查看数据类型,类型有四种： string(key,val)、list(序列)、set(集合)、zset(有序集合,多了一个顺序属性)
       print( r.type('a') ) # 返回数据的类型
    9. 其它
       r.rename('a','c3')  # 改名,成功则返回 True, 没有这键时报错
       r.expire('c3',10)  # 让数据10秒后过期(如果执行的进程终止了,此数据会马上过期,即使还没到时间也过期)
       r.ttl('c3')  # 看剩余过期时间，不存在返回 None，返回剩余多少秒的整数
       r.persist('c3') # 删除到期的key，有这key则返回 True，没有则返回 False

    10.保存值
       r.save()   # 强行把数据库保存到硬盘。保存时阻塞,返回值: True / False
    11.r.lastsave() # 取最后一次save时间
    12.r.shutdown() # 关闭所有客户端，停掉所有服务，退出服务器
    13.r.flush()  # 刷新
    14.看 redis 信息
       info = r.info()
       for key in info:
           print( "%s: %s" % (key, info[key]) )
    15.换数据库
       r.select(2)
    16.移动数据去其它数据库
       r.move('a',2)  # 将 'a' 的内容由当前数据库移动到 2 数据库

    17.序列(list)操作
       # 它是两头通的。以下操作，如果 'b' 不是 list 类型则报错
       r.lpush('b','gg') # 从左边塞入,返回塞入后的 list 长度
       r.rpush('b','hh') # 从右边塞入,返回塞入后的 list 长度
       r.lpop('b')  # 从左边弹出,返回弹出的值
       r.rpop('b')  # 从右边弹出,返回弹出的值
       r.rpoplpush('b', 'j') # 从'b'的右边弹出,从左边塞入到list'j'里面,返回弹出的值(相当于 r.lpush('j', r.rpop('b')) )

       r.llen('b') # 返回 list 的长度
       r.lrange('b',start=0,end=-1) # 这里是列出所有,可以指定 star 和 end 列出那些值
       r.lindex('b',0) # 取出指定 index 的一个值

       # 修剪列表
       # 若 start 大于end, 则将这个list清空
       r.ltrim('b',start=0,end=3) # 只留 从0到3 的四个值,返回True

    18.集合(set)操作
       # 以下，如果 's' 不是 set 类型则报错
       r.sadd('s', 'a')  # 添加数据,如果成功往 set 里面添加此数据则返回 True,已经有这数据则返回 False
       r.scard('s') # 判断 set 的长度,不存在为0,返回长度的整数
       r.sismember('s','a') # 判断 set 中一个对象是否存在,集合或者对象不存在都返回 False, set 中存在此值则返回 True
       r.smembers('s') # 看一个set对象。返回的是 set([交集的值列表]) 类型
       # 交集
       r.sinter('s','s2') # 求交集,返回 's' 和 's2' 两个 set 的交集的set。
       r.sinterstore('s3','s','s2') # 求交集并将结果赋值。求得第二个参数及之后的所有 set 的交集,并将结果赋值给第一个参数的 set。返回赋值后的第一个参数的 set 的长度('s3'赋值前的值不再保存)
       # 并集
       r.sunion('s','s2') # 求并集,返回 's' 和 's2' 两个 set 的并集的set。
       r.sunionstore('ss','s','s2','s3') # 求并集 并将结果赋值。 求得第二个参数及之后的所有 set 的并集,并将结果赋值给第一个参数的 set。返回赋值后的第一个参数的 set 的长度
       # 不同
       r.sdiff('s','s2','s3') # 求不同。在's'中有，但在's2'和's3'中都没有的值的set
       r.sdiffstore('s4','s','s2') # 求不同 并将结果赋值。 类似 sinterstore, sunionstore, 你懂的
       r.srandmember('s') # 取个随机值。返回 set 里面的随机一个值, set 里面没有值时返回 None

    19.zset 有序 set
       r.zadd('z', 'a', 1) # 添加,给zset'z'添加值'a',添加到下标为1的位置上。返回 True / False
       r.zcard('z') # 判断 zset 的长度,不存在为0,返回长度的整数
       zincr # 自加1
       zrange # 取数据
       zrangebyscore # 按照积分(范围)取数据
       zrem # 删除
       zscore # 取积分

    20.字典(dict)
       r.hmset('ehr:sign_data2', {'subject': '', 'lessonid': 0}) # 设置一个字典
       r.hgetall('ehr:sign_data2') # 获取一个字典

       r.hset('ehr:sign_data2', 'subject': '1') # 设置字典里面的一个值
       r.hget('ehr:sign_data2', 'subject') # 获取字典里面的一个值


    0. 查看这模块的所有函数、类和变量
       print( dir(r) )
       返回结果: [
            'RESPONSE_CALLBACKS',
            '__class__', '__contains__', '__delattr__', '__delitem__', '__dict__', '__doc__', '__format__', '__getattribute__', '__getitem__', '__hash__',
            '__init__', '__module__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setitem__', '__sizeof__', '__str__',
            '__subclasshook__', '__weakref__', '_zaggregate',
            'append', 'bgrewriteaof', 'bgsave', 'blpop', 'brpop', 'brpoplpush',
            'config_get', 'config_set', 'connection_pool',
            'dbsize', # r.dbsize()   # 库里有多少key，多少条数据, 返回整数
            'decr',   # r.decr('a2') # 设置一个递减的整数,每执行一次它自减1,返回自减后的整数(第一次时是-1)
            'delete', # r.delete('foo'), r.delete('c1','c2')  # 全部删除成功则返回 True, 没有这键则返回 False
            'execute_command',
            'exists', # r.exists('chang')  # 看是否存在这个键值,返回值: True / False
            'expire', # r.expire('c3',10)  # 让数据10秒后过期
            'expireat',
            'flushall',
            'flushdb', # r.flushdb()   # 删除当前数据库的所有数据,返回值: True / False
            'get', # r.get('foo')  # 返回读取的值(没有则返回 None)
            'getbit',
            'getset', # r.getset('foo', 'jj') # 可以在存新数据的同时,将上次存储内容同时读取出来
            'hdel', 'hexists',
            'hget', 'hgetall', 'hincrby', 'hkeys', 'hlen', 'hmget', 'hmset',
            'hset', 'hsetnx', 'hvals',
            'incr', # r.incr('a')  # 设置一个递增的整数,每执行一次它自加1,返回自增后的整数(第一次时是1)
            'info', # r.info() # 返回 redis 信息的字典
            'keys', # r.keys() # 列出所有键值。返回键的 list。 # r.keys('a*')  # 按正则匹配一批键出来
            'lastsave', # r.lastsave() # 取最后一次save时间
            'lindex', # r.lindex('b',0) # list 的取出指定 index 的一个值
            'linsert',
            'llen', # r.llen('b') # 返回 list 的长度
            'lock',
            'lpop', # r.lpop('b')  # list 的从左边弹出,返回弹出的值
            'lpush', # r.lpush('b','gg') # list 的从左边塞入,返回塞入后的 list 长度
            'lpushx',
            'lrange', 'lrem', 'lset', 'ltrim',
            'mget', # r.mget('a','foo')  # 同时取一批数据,返回值的 list
            'move', # r.move('a',2)  # 将 'a' 的内容由当前数据库移动到 2 数据库
            'mset',
            'msetnx',
            'parse_response', 'persist', 'ping', 'pipeline', 'publish', 'pubsub',
            'randomkey', # r.randomkey()  # 随机取一个键
            'rename',  # r.rename('a','c3')  # 改名
            'renamenx', 'response_callbacks',
            'rpop', # r.rpop('b')  # list 的从右边弹出,返回弹出的值
            'rpoplpush', # r.rpoplpush('b', 'jj') # list 的从右边弹出,从左边塞入,返回弹出的值(相当于 rpop + lpush)
            'rpush', # r.rpush('b','hh') # list 的从右边塞入,返回塞入后的 list 长度
            'rpushx',
            'sadd', # r.sadd('s', 'a') # set 的添加数据,如果成功往 set 里面添加此数据则返回 True,已经有这数据则返回 False
            'save', # r.save()   # 强行把数据库保存到硬盘。保存时阻塞,返回值: True / False
            'scard', # r.scard('s') # set 的判断长度,不存在为0,返回长度的整数
            'sdiff', # r.sdiff('s','s2','s3') # set 的求不同。在's'中有，但在's2'和's3'中都没有的值
            'sdiffstore', # r.sdiffstore('s4','s','s2') # 求不同 并将结果赋值。
            'set', # r.set('foo', 'bar') # 设值(添加值),返回值: True
            'set_response_callback', 'setbit', 'setex',
            'setnx', 'setrange',
            'shutdown', # r.shutdown() # 关闭所有客户端，停掉所有服务，退出服务器
            'sinter', # r.sinter('s','s2') # set 的求交集,返回 's' 和 's2' 两个 set 的交集的set。
            'sinterstore', # r.sinterstore('s3','s','s2') # set 的求交集并将结果赋值。
            'sismember', # r.sismember('s','a') # 判断 set 中一个对象是否存在,集合或者对象不存在都返回 False, set 中存在此值则返回 True
            'slaveof',
            'smembers', # r.smembers('s') # 看一个set对象。返回的是 set([交集的值列表]) 类型
            'smove', 'sort', 'spop', 'srandmember', 'srem',
            'strlen', 'substr',
            'sunion', # r.sunion('s','s2') # set 的求并集,返回 's' 和 's2' 两个 set 的并集的set。
            'sunionstore', # r.sunionstore('ss','s','s2','s3') # set 的求并集 并将结果赋值。
            'ttl', # r.ttl('c3')  # 看剩余过期时间，不存在返回 None，返回剩余多少秒的整数
            'type', # r.type('a')  # 查看数据类型,类型有四种： string(key,val)、list(序列)、set(集合)、zset(有序集合,多了一个顺序属性)
            'unwatch',
            'watch', 'zadd', 'zcard', 'zcount', 'zincrby', 'zinterstore', 'zrange',
            'zrangebyscore', 'zrank', 'zrem', 'zremrangebyrank', 'zremrangebyscore',
            'zrevrange', 'zrevrangebyscore', 'zrevrank', 'zscore', 'zunionstore'
       ]

其他命令API，请参照redis-Python作者的博客：
https://github.com/andymccurdy/redis-py




