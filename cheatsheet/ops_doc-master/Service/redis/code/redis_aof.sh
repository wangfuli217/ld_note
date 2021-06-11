ae(read)
{
从文件描述符获取数据进行处理
void readQueryFromClient(aeEventLoop *el, int fd, void *privdata, int mask) 读客户端输入缓冲区
    void processInputBuffer(redisClient *c) 处理客户端输入内容
        processCommand 处理客户端输入请求
            quit: 断开当前连接
            lookupCommand: 查找要执行命令，以及命令合法性
                unknown command：命令错误
                wrong number of arguments for '%s' command： 命令参数个数错误
                shared.noautherr：检查用户认证信息
            server.cluster_enabled：集群模式使能
            server.maxmemory：最大内存使用情况
            min-slaves-to-write：选项判断
            server.masterhost：该服务器是一个slave服务器
            在订阅于发布模式下的上下文，只能执行订阅和退订相关的命令
            slave-serve-stale-data：选项判断
            queueMultiCommand：执行事务
            call(c,REDIS_CALL_FULL);执行命令
            +call
                replicationFeedMonitors : 将信息发送给monitor客户端
                c->cmd->proc(c);        : 执行响应的命令处理函数；统计数据库被修改的次数server.dirty，dirty为当前是否被修改标志。
                slowlogPushEntryIfNeeded: 判断命令是否添加到slowlog缓存中
                propagate(
                REDIS_PROPAGATE_NONE : 不进行传播
                REDIS_PROPAGATE_AOF  : 传播到AOF文件     ++++feedAppendOnlyFile++++
                REDIS_PROPAGATE_REPL : 传播到slave       replicationFeedSlaves
                )
    
从文件描述符得到EXEC命令进行处理      
execCommand(redisClient *c)
    call(c,REDIS_CALL_FULL);执行命令
}

ae(write)
{
将数据添加到发送文件描述符
addReply：添加响应命令
    prepareClientToWrite(c) 为客户端安装发送请求
        sendReplyToClient   发送数据处理函数
}
        
aof(interface)
{
rewriteAppendOnlyFileBackground(void)   在BGREWRITEAOF命令中被调用+开始
backgroundRewriteDoneHandler            在BGREWRITEAOF命令中被调用+结束(当子进程退出时，调用该进程)
loadAppendOnlyFile                      在void loadDataFromDisk(void) 中被调用
feedAppendOnlyFile                      在propagate中被调用
stopAppendOnly                          在void configSetCommand(redisClient *c)中被调用
startAppendOnly                         在void configSetCommand(redisClient *c)中被调用
}

aof(持久化)
{
Append Only File功能。通过记录redis执行的命令进行持久化。
    服务器在处理文件事件时可能会执行写命令，使得一些内容被追加到aof_buf缓冲区里面，所以在服务器每次结束一个时间循环之间，它都会
调用flushAppendOnlyFile函数，考虑是否需要将aof_buf缓冲区中的内容写入和保存到AOF文件里面。

appendfsync: 
1. always   将aof_buf缓冲区中的所有内容写入并同步到AOF文件
2. everysec 将aof_buf缓冲区中的所有内容写入到AOF文件，如果上次同步AOF文件的时间距离现在超过一分钟，
            那么在此对AOF文件进行同步，并且这个同步操作是由一个线程专门负责执行的。
3. no       将aof_buf缓冲区中的所有内容写入到AOF文件，但不对AOF文件进行同步，何时同步由操作系统来决定
如果用户没有主动为appendfsync选项设置值，那么appendfsync选项的默认值为everysec.

always时，服务器在每个事件循环都要将aof_buf缓冲中的所有内容写入到AOF文件，并且同步AOF文件，所以always的效率是appendfsync选项
三个值当中最慢的一个，但从安全性来说，always也是最安全的，因为，即使出现故障停机，AOF持久化也只会丢失一个时间循环中所产生的
命令数据。

everysec时，服务器在每个事件循环都要将aof_buf缓冲区中的所有内容写入到AOF文件，并且每隔一秒就要在子线程中对AOF文件进行一次同步
从效率上来讲，everysec模式足够快，并且就算出现故障停机，数据库也只丢失一秒钟的命令数据。

no时，服务器在每个事件循环都要讲aof_buf缓冲区中所有数据内容写入到AOF文件，至于何时对AOF文件进行同步，则由操作系统控制。
}
    
Redis提供了AOF文件重写功能，Redis可以创建一个新的AOF文件来代替现有的AOF文件，新旧两个AOF文件所保存的数据库状态相同，但新
AOF文件不会包含任何浪费空间的冗余命令，所以新的AOF文件的体积通常会比旧AOF文件的体积小得多。

BGREWRITEAOF命令；
1. 子进程进行AOF重写期间，服务器进程可以继续处理命令请求。
2. 子进程带有服务器进程的数据副本，使用子进程而不是线程，可以避免使用锁的情况下，保证数据的安全性。
服务器进程
1.执行客户端发来的命令，
2. 将执行后的写命令追加到AOF缓冲区，
3. 将执行后的写命令追加到AOF重写缓冲区。
AOF缓冲区的内容会定期被写入和同步到AOF文件，对现有AOF文件的处理工作如常进行。
从创建子进程开始，服务器执行的所有写命令都会被记录到AOF重写缓冲区里面。

flushAppendOnlyFile()
{
void flushAppendOnlyFile(int force) 
将 AOF 缓存写入到文件中。
1. 因为程序需要在回复客户端之前对 AOF 执行写操作。而客户端能执行写操作的唯一机会就是在事件 loop 中，
   因此，程序将所有 AOF 写累积到缓存中，并在重新进入事件 loop 之前，将缓存写入到文件中。
关于 force 参数：
2. 当 fsync 策略为每秒钟保存一次时，如果后台线程仍然有 fsync 在执行，那么我们可能会延迟执行冲洗（flush）操作，
   因为 Linux 上的 write(2) 会被后台的 fsync 阻塞。
   2.1 当这种情况发生时，说明需要尽快冲洗 aof 缓存，程序会尝试在 serverCron() 函数中对缓存进行冲洗。
   2.2 不过，如果 force 为 1 的话，那么不管后台是否正在 fsync ，程序都直接进行写入。
   
 }
 
 都是元数据+日志文件；但是moosefs是元数据+周期性N个日志文件；redis是元数据+1个日志文件。
1. moosefs使用fopen释放打开文件，使用fprintf将数据刷新到内存中，使用fflush方式将数据从用户态刷新到内存。
   没有使用fsync或者fdatasync，将内核内存中数据刷到磁盘中。
2. redis对日志由三种机制：每次修改刷新一次；每秒刷新一次和从来不由redis刷新。这里的刷新是将内核中的数据，
   调用fsync或者datasync将数据刷新到磁盘中。
   
1. moosefs写日志文件是按照时间间隔一个个写文件的，比如每个1个小时，写一个日志文件，然后开始第二个日志文件的写入。
   而moosefs的元数据通常是2个小时，将内存中的数据同步到磁盘上。
2. redis写日志文件依赖管理，通过bgrewriteaof命令通知重写日志到一个临时的日志文件中。临时的日志文件是内存中日志数据的抽象。
   redis通过bgsave或者save将内存中的数据保存到磁盘上。

   


