1 Core文件大小和进程打开文件个数限制的调整。
2 启动用户的选择。
3 以daemon的方式启动，daemon的实现如下，该daemon没有进行2次fork，APUE上面也有说第二次fork不是必须的。
4 锁定内存，默认分配的内存都是虚拟内存，在程序执行过程中可以按需换出，如果内存充足的话，可以锁定内存，不让系统将该进程所持有的内存换出。
5 忽略PIPE信号，PIPE信号是当网络连接一端已经断开，这时发送数据，会进行RST的重定向，再次发送数据，会触发PIPE信号，而PIPE信号的默认动作是退出进程，所以需要忽略该信号。
6 保存daemon进程的进程id到文件中，这样便于控制程序，读取文件内容，即可得到进程ID。



set foo 0 0 3                                                   保存命令
bar                                                             数据
get foo                                                         取得命令

set()
{
Memcached set 命令用于将 value(数据值) 存储在指定的 key(键) 中。
如果set的key已经存在，该命令可以更新该key所对应的原来的数据，也就是实现更新的作用。
set key flags exptime bytes [noreply] 
value

key：键值 key-value 结构中的 key，用于查找缓存值。
flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
bytes：在缓存中存储的字节数
noreply（可选）： 该参数告知服务器不需要返回数据
value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）

key → runoob
flag → 0
exptime → 900 (以秒为单位)
bytes → 9 (数据存储的字节数)
value → memcached

set runoob 0 900 9
get runoob
}

add()
{
Memcached add 命令用于将 value(数据值) 存储在指定的 key(键) 中。
如果 add 的 key 已经存在，则不会更新数据，之前的值将仍然保持相同，并且您将获得响应 NOT_STORED。

add key flags exptime bytes [noreply]
value
参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）

key → new_key
    flag → 0
    exptime → 900 (以秒为单位)
    bytes → 10 (数据存储的字节数)
    value → data_value
add new_key 0 900 10
get new_key
}

replace()
{
Memcached replace 命令用于替换已存在的 key(键) 的 value(数据值)。

如果 key 不存在，则替换失败，并且您将获得响应 NOT_STORED。
语法：

replace 命令的基本语法格式如下：

replace key flags exptime bytes [noreply]
value

参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
}

append()
{
Memcached append 命令用于向已存在 key(键) 的 value(数据值) 后面追加数据 。
语法：

append 命令的基本语法格式如下：

append key flags exptime bytes [noreply]
value

参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）

    set runoob 0 900 9

    get runoob

    append runoob 0 900 5

}

prepend()
{
Memcached prepend 命令用于向已存在 key(键) 的 value(数据值) 前面追加数据 。
语法：

prepend 命令的基本语法格式如下：

prepend key flags exptime bytes [noreply]
value

参数说明如下：

    key：键值 key-value 结构中的 key，用于查找缓存值。
    flags：可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息 。
    exptime：在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
    bytes：在缓存中存储的字节数
    noreply（可选）： 该参数告知服务器不需要返回数据
    value：存储的值（始终位于第二行）（可直接理解为key-value结构中的value）
}

cas()
{
Memcached CAS（Check-And-Set 或 Compare-And-Swap） 命令用于执行一个"检查并设置"的操作

它仅在当前客户端最后一次取值后，该key 对应的值没有被其他客户端修改的情况下， 才能够将值写入。

检查是通过cas_token参数进行的， 这个参数是Memcach指定给已经存在的元素的一个唯一的64位值。
语法：

CAS 命令的基本语法格式如下：

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
}

get()
{
Memcached get 命令获取存储在 key(键) 中的 value(数据值) ，如果 key 不存在，则返回空。
语法：

get 命令的基本语法格式如下：
get key

多个 key 使用空格隔开，如下:
get key1 key2 key3

参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
    
}

gets()
{
Memcached gets 命令获取带有 CAS 令牌存 的 value(数据值) ，如果 key 不存在，则返回空。
语法：

gets 命令的基本语法格式如下：
gets key

多个 key 使用空格隔开，如下:
gets key1 key2 key3

参数说明如下：
    key：键值 key-value 结构中的 key，用于查找缓存值。
}

delete()
{
Memcached delete 命令用于删除已存在的 key(键)。
语法：

delete 命令的基本语法格式如下：
delete key [noreply]

参数说明如下：

    key：键值 key-value 结构中的 key，用于查找缓存值。
    noreply（可选）： 该参数告知服务器不需要返回数据
}

incr_decr()
{
Memcached incr 与 decr 命令用于对已存在的 key(键) 的数字值进行自增或自减操作。
incr 与 decr 命令操作的数据必须是十进制的32位无符号整数。

如果 key 不存在返回 NOT_FOUND，如果键的值不为数字，则返回 CLIENT_ERROR，其他错误返回 ERROR。
incr 命令
语法：

incr 命令的基本语法格式如下：
incr key increment_value

参数说明如下：

    key：键值 key-value 结构中的 key，用于查找缓存值。
    increment_value： 增加的数值。
}

stats()
{
Memcached stats 命令
Memcached stats items 命令
Memcached stats slabs 命令
Memcached stats sizes 命令
Memcached flush_all 命令
}
