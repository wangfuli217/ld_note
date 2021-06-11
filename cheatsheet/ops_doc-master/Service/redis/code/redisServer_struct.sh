1. pidfile
2. redis.conf
3. rdb文件
4. aof文件
5. logfile
6. cluster_configfile

设置服务器的运行ID
设置服务器的默认运行频率
设置服务器的默认配置文件路径
设置服务器的运行架构
设置服务器的默认端口号
设置服务器的默认RDB持久化天剑和AOF持久化条件
初始化服务器的LUR时钟
创建命令表


redisServer(struct) {
    /* 通用配置参数 */
    char *configfile;           配置文件的绝对路径
    
    int hz;                     serverCron() 每秒调用的次数：默认是REDIS_DEFAULT_HZ(10)
    redisDb *db;                数据库
    dict *commands;             命令表（受到 rename 配置选项的作用）
    dict *orig_commands;        命令表（无 rename 配置选项的作用）
    aeEventLoop *el;            事件状态
    unsigned lruclock:REDIS_LRU_BITS; 最近一次使用时钟
    int shutdown_asap;          关闭服务器的标识
    int activerehashing;        在执行 serverCron() 时进行渐进式 rehash
    char *requirepass;          是否设置了密码
    char *pidfile;              PID 文件
    int arch_bits;              架构类型 : 通过sizeof(long)来确定是32位还是64为操作系统。
    int cronloops;              serverCron() 函数的运行次数计数器
    char runid[REDIS_RUN_ID_SIZE+1];  本服务器的 RUN ID ：通过getRandomHexChars生成的hex类型的数值字符串。
    int sentinel_mode;          服务器是否运行在 SENTINEL 模式


    /* Networking */
    // TCP 监听端口
    int port;                   /* TCP listening port */  REDIS_SERVERPORT(监听端口默认值6379)
    int tcp_backlog;            /* TCP listen() backlog */ REDIS_TCP_BACKLOG(accept接口并发TCP排到最大值)
    // 地址
    char *bindaddr[REDIS_BINDADDR_MAX]; /* Addresses we should bind to */ 绑定IP地址默认为0
    // 地址数量
    int bindaddr_count;         /* Number of addresses in server.bindaddr[] */
    // UNIX 套接字
    char *unixsocket;           /* UNIX socket path */  unix socket默认为空，
    mode_t unixsocketperm;      /* UNIX socket permission */ unix socket 文件默认权限 REDIS_DEFAULT_UNIX_SOCKET_PERM为0
    // 描述符
    int ipfd[REDIS_BINDADDR_MAX]; /* TCP socket file descriptors */
    // 描述符数量
    int ipfd_count;             /* Used slots in ipfd[] */
    // UNIX 套接字文件描述符
    int sofd;                   /* Unix socket file descriptor */
    int cfd[REDIS_BINDADDR_MAX];/* Cluster bus listening socket */
    int cfd_count;              /* Used slots in cfd[] */

    
    // 一个链表，保存了所有客户端状态结构
    list *clients;              /* List of active clients */
    // 链表，保存了所有待关闭的客户端
    list *clients_to_close;     /* Clients to close asynchronously */

    // 链表，保存了所有从服务器，以及所有监视器
    list *slaves, *monitors;    /* List of slaves and MONITORs */
    // 服务器的当前客户端，仅用于崩溃报告
    redisClient *current_client; /* Current client, only used on crash report */
    int clients_paused;         /* True if clients are currently paused */
    mstime_t clients_pause_end_time; /* Time when we undo clients_paused */

    // 网络错误
    char neterr[ANET_ERR_LEN];   /* Error buffer for anet.c */
    // MIGRATE 缓存
    dict *migrate_cached_sockets;/* MIGRATE cached sockets */
    /* RDB / AOF loading information */

    // 这个值为真时，表示服务器正在进行载入
    int loading;                /* We are loading data from disk if true */   负载信息统计
    // 正在载入的数据的大小
    off_t loading_total_bytes;
    // 已载入数据的大小
    off_t loading_loaded_bytes;
    // 开始进行载入的时间
    time_t loading_start_time;
    off_t loading_process_events_interval_bytes;
    /* Fast pointers to often looked up command */
    // 常用命令的快捷连接
    struct redisCommand *delCommand, *multiCommand, *lpushCommand, *lpopCommand,
                        *rpopCommand;
                        /*
    server.delCommand = lookupCommandByCString("del");
    server.multiCommand = lookupCommandByCString("multi");
    server.lpushCommand = lookupCommandByCString("lpush");
    server.lpopCommand = lookupCommandByCString("lpop");
    server.rpopCommand = lookupCommandByCString("rpop");
                        */

    /* Fields used only for stats */
    // 服务器启动时间
    time_t stat_starttime;          /* Server start time */
    // 已处理命令的数量
    long long stat_numcommands;     /* Number of processed commands */
    // 服务器接到的连接请求数量
    long long stat_numconnections;  /* Number of connections received */
    // 已过期的键数量
    long long stat_expiredkeys;     /* Number of expired keys */
    // 因为回收内存而被释放的过期键的数量
    long long stat_evictedkeys;     /* Number of evicted keys (maxmemory) */
    // 成功查找键的次数
    long long stat_keyspace_hits;   /* Number of successful lookups of keys */
    // 查找键失败的次数
    long long stat_keyspace_misses; /* Number of failed lookups of keys */
    // 已使用内存峰值
    size_t stat_peak_memory;        /* Max used memory record */
    // 最后一次执行 fork() 时消耗的时间
    long long stat_fork_time;       /* Time needed to perform latest fork() */
    // 服务器因为客户端数量过多而拒绝客户端连接的次数
    long long stat_rejected_conn;   /* Clients rejected because of maxclients */
    // 执行 full sync 的次数
    long long stat_sync_full;       /* Number of full resyncs with slaves. */
    // PSYNC 成功执行的次数
    long long stat_sync_partial_ok; /* Number of accepted PSYNC requests. */
    // PSYNC 执行失败的次数
    long long stat_sync_partial_err;/* Number of unaccepted PSYNC requests. */

    /* slowlog */
    // 保存了所有慢查询日志的链表
    list *slowlog;                  /* SLOWLOG list of commands */
    // 下一条慢查询日志的 ID
    long long slowlog_entry_id;     /* SLOWLOG current entry ID */
    // 服务器配置 slowlog-log-slower-than 选项的值
    long long slowlog_log_slower_than; /* SLOWLOG time limit (to get logged) */
    // 服务器配置 slowlog-max-len 选项的值
    unsigned long slowlog_max_len;     /* SLOWLOG max number of items logged */
    size_t resident_set_size;       /* RSS sampled in serverCron(). */
    /* The following two are used to track instantaneous "load" in terms
     * of operations per second. */
    // 最后一次进行抽样的时间
    long long ops_sec_last_sample_time; /* Timestamp of last sample (in ms) */
    // 最后一次抽样时，服务器已执行命令的数量
    long long ops_sec_last_sample_ops;  /* numcommands in last sample */
    // 抽样结果
    long long ops_sec_samples[REDIS_OPS_SEC_SAMPLES];
    // 数组索引，用于保存抽样结果，并在需要时回绕到 0
    int ops_sec_idx;


    /* 配置信息 */
    // 日志可见性
    int verbosity;                  /* Loglevel in redis.conf */    REDIS_DEFAULT_VERBOSITY 默认是NOTICE级别打印
    // 客户端最大空转时间
    int maxidletime;                /* Client timeout in seconds */  REDIS_MAXIDLETIME 0 客户端多长时间不通信，准备断开连接
    // 是否开启 SO_KEEPALIVE 选项
    int tcpkeepalive;               /* Set SO_KEEPALIVE if non-zero. */  REDIS_DEFAULT_TCP_KEEPALIVE 0 TCP层多长时间进行连接保持
    int active_expire_enabled;      /* Can be disabled for testing purposes. */ 老化机制是否开启
    size_t client_max_querybuf_len; /* Limit for client query buffer length */  客户端最长请求缓冲区大小REDIS_MAX_QUERYBUF_LEN 1GB
    int dbnum;                      /* Total number of configured DBs */        REDIS_DEFAULT_DBNUM redis默认支持16个数据库
    int daemonize;                  /* True if running as a daemon */           最为一个守护进程运行
    // 客户端输出缓冲区大小限制
    // 数组的元素有 REDIS_CLIENT_LIMIT_NUM_CLASSES 个
    // 每个代表一类客户端：普通、从服务器、pubsub，诸如此类
    clientBufferLimitsConfig client_obuf_limits[REDIS_CLIENT_LIMIT_NUM_CLASSES];


    /* AOF persistence */
    // AOF 状态（开启/关闭/可写）
    int aof_state;                  /* REDIS_AOF_(ON|OFF|WAIT_REWRITE) */  REDIS_AOF_OFF 不记录aof文件
    // 所使用的 fsync 策略（每个写入/每秒/从不）
    int aof_fsync;                  /* Kind of fsync() policy */                 操作系统同步到磁盘，每次同步到磁盘，每秒同步一次磁盘
    char *aof_filename;             /* Name of the AOF file */                   aof文件名称
    int aof_no_fsync_on_rewrite;    /* Don not fsync if a rewrite is in prog. */ 在rewrite是，不调用fsync函数
    int aof_rewrite_perc;           /* Rewrite AOF if % growth is > M and... */  aof文件比例
    off_t aof_rewrite_min_size;     /* the AOF file is at least N bytes. */      aof文件最小大小64M

    // 最后一次执行 BGREWRITEAOF 时， AOF 文件的大小
    off_t aof_rewrite_base_size;    /* AOF size on latest startup or rewrite. */   
    // AOF 文件的当前字节大小
    off_t aof_current_size;         /* AOF current size. */
    int aof_rewrite_scheduled;      /* Rewrite once BGSAVE terminates. */
    // 负责进行 AOF 重写的子进程 ID
    pid_t aof_child_pid;            /* PID if rewriting process */
    // AOF 重写缓存链表，链接着多个缓存块
    list *aof_rewrite_buf_blocks;   /* Hold changes during an AOF rewrite. */
    // AOF 缓冲区
    sds aof_buf;      /* AOF buffer, written before entering the event loop */
    // AOF 文件的描述符
    int aof_fd;       /* File descriptor of currently selected AOF file */
    // AOF 的当前目标数据库
    int aof_selected_db; /* Currently selected DB in AOF */
    // 推迟 write 操作的时间
    time_t aof_flush_postponed_start; /* UNIX time of postponed AOF flush */
    // 最后一直执行 fsync 的时间
    time_t aof_last_fsync;            /* UNIX time of last fsync() */
    time_t aof_rewrite_time_last;   /* Time used by last AOF rewrite run. */
    // AOF 重写的开始时间
    time_t aof_rewrite_time_start;  /* Current AOF rewrite start time. */
    // 最后一次执行 BGREWRITEAOF 的结果
    int aof_lastbgrewrite_status;   /* REDIS_OK or REDIS_ERR */
    // 记录 AOF 的 write 操作被推迟了多少次
    unsigned long aof_delayed_fsync;  /* delayed AOF fsync() counter */
    // 指示是否需要每写入一定量的数据，就主动执行一次 fsync()
    int aof_rewrite_incremental_fsync;/* fsync incrementally while rewriting? */
    int aof_last_write_status;      /* REDIS_OK or REDIS_ERR */
    int aof_last_write_errno;       /* Valid if aof_last_write_status is ERR */
    /* RDB persistence */

    // 自从上次 SAVE 执行以来，数据库被修改的次数
    long long dirty;                /* Changes to DB from the last save */
    // BGSAVE 执行前的数据库被修改次数
    long long dirty_before_bgsave;  /* Used to restore dirty on failed BGSAVE */
    // 负责执行 BGSAVE 的子进程的 ID
    // 没在执行 BGSAVE 时，设为 -1
    pid_t rdb_child_pid;            /* PID of RDB saving child */    子进程
    struct saveparam *saveparams;   /* Save points array for RDB */  多长时间保存一次RDB库
    int saveparamslen;              /* Number of saving points */    上次保存的时间点
    char *rdb_filename;             /* Name of RDB file */           rdb文件名
    int rdb_compression;            /* Use compression in RDB? */    是否进行压缩
    int rdb_checksum;               /* Use RDB checksum? */          rdb文件是否有校验和

    // 最后一次完成 SAVE 的时间
    time_t lastsave;                /* Unix time of last successful save */

    // 最后一次尝试执行 BGSAVE 的时间
    time_t lastbgsave_try;          /* Unix time of last attempted bgsave */

    // 最近一次 BGSAVE 执行耗费的时间
    time_t rdb_save_time_last;      /* Time used by last RDB save run. */

    // 数据库最近一次开始执行 BGSAVE 的时间
    time_t rdb_save_time_start;     /* Current RDB save start time. */

    // 最后一次执行 SAVE 的状态
    int lastbgsave_status;          /* REDIS_OK or REDIS_ERR */
    int stop_writes_on_bgsave_err;  /* Don't allow writes if can't BGSAVE */


    /* Propagation of commands in AOF / replication */
    redisOpArray also_propagate;    /* Additional command to propagate. */


    /* Logging */
    char *logfile;                  /* Path of log file */     日志文件路径配置                   默认为空
    int syslog_enabled;             /* Is syslog enabled? */   是否打印到syslog转发的message文件  默认不开启
    char *syslog_ident;             /* Syslog ident */         syslog日志文件打印的抬头           默认为redis
    int syslog_facility;            /* Syslog facility */      syslog可以配置的设备信息           默认为LOG_LOCAL0


    /* Replication (master) */
    int slaveseldb;                 /* Last SELECTed DB in replication output */
    // 全局复制偏移量（一个累计值）
    long long master_repl_offset;   /* Global replication offset */
    // 主服务器发送 PING 的频率
    int repl_ping_slave_period;     /* Master pings the slave every N seconds */

    // backlog 本身
    char *repl_backlog;             /* Replication backlog for partial syncs */
    // backlog 的长度
    long long repl_backlog_size;    /* Backlog circular buffer size */
    // backlog 中数据的长度
    long long repl_backlog_histlen; /* Backlog actual data length */
    // backlog 的当前索引
    long long repl_backlog_idx;     /* Backlog circular buffer current offset */
    // backlog 中可以被还原的第一个字节的偏移量
    long long repl_backlog_off;     /* Replication offset of first byte in the
                                       backlog buffer. */
    // backlog 的过期时间
    time_t repl_backlog_time_limit; /* Time without slaves after the backlog
                                       gets released. */

    // 距离上一次有从服务器的时间
    time_t repl_no_slaves_since;    /* We have no slaves since that time.
                                       Only valid if server.slaves len is 0. */

    // 是否开启最小数量从服务器写入功能
    int repl_min_slaves_to_write;   /* Min number of slaves to write. */
    // 定义最小数量从服务器的最大延迟值
    int repl_min_slaves_max_lag;    /* Max lag of <count> slaves to write. */
    // 延迟良好的从服务器的数量
    int repl_good_slaves_count;     /* Number of slaves with lag <= max_lag. */


    /* Replication (slave) */
    // 主服务器的验证密码
    char *masterauth;               /* AUTH with this password with master */
    // 主服务器的地址
    char *masterhost;               /* Hostname of master */
    // 主服务器的端口
    int masterport;                 /* Port of master */
    // 超时时间
    int repl_timeout;               /* Timeout after N seconds of master idle */
    // 主服务器所对应的客户端
    redisClient *master;     /* Client that is master for this slave */
    // 被缓存的主服务器，PSYNC 时使用
    redisClient *cached_master; /* Cached master to be reused for PSYNC. */
    int repl_syncio_timeout; /* Timeout for synchronous I/O calls */
    // 复制的状态（服务器是从服务器时使用）
    int repl_state;          /* Replication status if the instance is a slave */
    // RDB 文件的大小
    off_t repl_transfer_size; /* Size of RDB to read from master during sync. */
    // 已读 RDB 文件内容的字节数
    off_t repl_transfer_read; /* Amount of RDB read from master during sync. */
    // 最近一次执行 fsync 时的偏移量
    // 用于 sync_file_range 函数
    off_t repl_transfer_last_fsync_off; /* Offset when we fsync-ed last time. */
    // 主服务器的套接字
    int repl_transfer_s;     /* Slave -> Master SYNC socket */
    // 保存 RDB 文件的临时文件的描述符
    int repl_transfer_fd;    /* Slave -> Master SYNC temp file descriptor */
    // 保存 RDB 文件的临时文件名字
    char *repl_transfer_tmpfile; /* Slave-> master SYNC temp file name */
    // 最近一次读入 RDB 内容的时间
    time_t repl_transfer_lastio; /* Unix time of the latest read, for timeout */
    int repl_serve_stale_data; /* Serve stale data when link is down? */
    // 是否只读从服务器？
    int repl_slave_ro;          /* Slave is read only? */
    // 连接断开的时长
    time_t repl_down_since; /* Unix time at which link with master went down */
    // 是否要在 SYNC 之后关闭 NODELAY ？
    int repl_disable_tcp_nodelay;   /* Disable TCP_NODELAY after SYNC? */
    // 从服务器优先级
    int slave_priority;             /* Reported in INFO and used by Sentinel. */
    // 本服务器（从服务器）当前主服务器的 RUN ID
    char repl_master_runid[REDIS_RUN_ID_SIZE+1];  /* Master run id for PSYNC. */
    // 初始化偏移量
    long long repl_master_initial_offset;         /* Master PSYNC offset. */


    /* Replication script cache. */
    // 复制脚本缓存
    // 字典
    dict *repl_scriptcache_dict;        /* SHA1 all slaves are aware of. */
    // FIFO 队列
    list *repl_scriptcache_fifo;        /* First in, first out LRU eviction. */
    // 缓存的大小
    int repl_scriptcache_size;          /* Max number of elements. */

    /* Synchronous replication. */
    list *clients_waiting_acks;         /* Clients waiting in WAIT command. */
    int get_ack_from_slaves;            /* If true we send REPLCONF GETACK. */
    /* Limits */
    int maxclients;                 /* Max number of simultaneous clients */   最大客户端数量10000
    unsigned long long maxmemory;   /* Max number of memory bytes to use */    可以使用最大内存
    int maxmemory_policy;           /* Policy for key eviction */              使用内存的策略
    int maxmemory_samples;          /* Pricision of random sampling */         REDIS_DEFAULT_MAXMEMORY_SAMPLES 5


    /* Blocked clients */
    unsigned int bpop_blocked_clients; /* Number of clients blocked by lists */
    list *unblocked_clients; /* list of clients to unblock before next loop */
    list *ready_keys;        /* List of readyList structures for BLPOP & co */


    /* Sort parameters - qsort_r() is only available under BSD so we
     * have to take this state global, in order to pass it to sortCompare() */
    int sort_desc;
    int sort_alpha;
    int sort_bypattern;
    int sort_store;


    /* hash list set 和 zset使用的策略  */
    size_t hash_max_ziplist_entries;
    size_t hash_max_ziplist_value;
    size_t list_max_ziplist_entries;
    size_t list_max_ziplist_value;
    size_t set_max_intset_entries;
    size_t zset_max_ziplist_entries;
    size_t zset_max_ziplist_value;
    size_t hll_sparse_max_bytes;
    time_t unixtime;        /* Unix time sampled every cron cycle. */                  unixtime
    long long mstime;       /* Like 'unixtime' but with milliseconds resolution. */    mstime


    /* Pubsub */
    // 字典，键为频道，值为链表
    // 链表中保存了所有订阅某个频道的客户端
    // 新客户端总是被添加到链表的表尾
    dict *pubsub_channels;  /* Map channels to list of subscribed clients */

    // 这个链表记录了客户端订阅的所有模式的名字
    list *pubsub_patterns;  /* A list of pubsub_patterns */

    int notify_keyspace_events; /* Events to propagate via Pub/Sub. This is an
                                   xor of REDIS_NOTIFY... flags. */


    /* Cluster */

    int cluster_enabled;      /* Is cluster enabled? */
    mstime_t cluster_node_timeout; /* Cluster node timeout. */
    char *cluster_configfile; /* Cluster auto-generated config file name. */
    struct clusterState *cluster;  /* State of the cluster */

    int cluster_migration_barrier; /* Cluster replicas migration barrier. */
    /* Scripting */

    // Lua 环境
    lua_State *lua; /* The Lua interpreter. We use just one for all clients */
    
    // 复制执行 Lua 脚本中的 Redis 命令的伪客户端
    redisClient *lua_client;   /* The "fake client" to query Redis from Lua */

    // 当前正在执行 EVAL 命令的客户端，如果没有就是 NULL
    redisClient *lua_caller;   /* The client running EVAL right now, or NULL */

    // 一个字典，值为 Lua 脚本，键为脚本的 SHA1 校验和
    dict *lua_scripts;         /* A dictionary of SHA1 -> Lua scripts */
    // Lua 脚本的执行时限
    mstime_t lua_time_limit;  /* Script timeout in milliseconds */
    // 脚本开始执行的时间
    mstime_t lua_time_start;  /* Start time of script, milliseconds time */

    // 脚本是否执行过写命令
    int lua_write_dirty;  /* True if a write command was called during the
                             execution of the current script. */

    // 脚本是否执行过带有随机性质的命令
    int lua_random_dirty; /* True if a random command was called during the
                             execution of the current script. */

    // 脚本是否超时
    int lua_timedout;     /* True if we reached the time limit for script execution. */

    // 是否要杀死脚本
    int lua_kill;         /* Kill the script if true. */
    /* Assert & bug reporting */

    char *assert_failed;
    char *assert_file;
    int assert_line;
    int bug_report_start; /* True if bug report header was already logged. */
    int watchdog_period;  /* Software watchdog period in ms. 0 = off */
};


redisClient()
{
1. 客户端的套接字描述符；
2. 客户端的名字
3. 客户端的标志值
4. 执行客户端正在使用的数据库的指针，以及该数据库的号码。
5. 客户端当前要执行的命令、命令的参数、命令参数的个数，以及执行命令实现函数的指针。
6. 客户端的输入缓冲区和输出缓冲区
7. 客户端的复制状态信息，以及进行复制所需的数据结构
8. 客户端执行BRPOP，BLPOP等列表阻塞命令时使用的数据结构。
9. 客户端的事物状态，以及执行WATCH命令时用到的数据结构。
10. 客户端执行发布和订阅功能时用到的数据结构
11. 客户端的身份验证标志。
12. 客户端的创建时间，客户端和服务器最后一次通信的时间，以及客户端的输出缓冲区大小超过软限制的时间。

客户端状态包括的属性可以分为两类
   1. 一类是比较普通的属性，这些属性很少与特定的功能相关，无论客户端执行的是什么工作，它们都要用到这些属性。
   2. 另外一类适合特定功能相关的属性，比如操作数据库时需要用到的db属性和dictid属性，执行事务时需要
      用到的mstate属性，以及执行WATCH命令时需要用到的watched_keys属性等等。
1、文件描述符   
伪客户端的文件描述符fd属性的值为-1，伪客户端处理的命令请求来源于AOF文件或者lua脚本，而不是网络。
普通客户端的文件描述符fd属性大于0，

client list #命令

2、名字
client list #命令
client setname #设置名字

3、标识
客户端的角色：
3.1 在主从服务器进行复制操作时，主服务器会成为从服务器的客户端，而从服务器也会成为主服务器的客户端。REDIS_MASTER标志标识
    客户端代表的是一个主服务器，REDIS_SLAVE标识表示客户端代表的是一个从服务器。
3.2 REDIS_PRE_PSYNC标识表示客户端代表的是一个版本低于Redis2.8的从服务器，主服务器不能使用PSYNC命令与从服务器进行同步。
    这个标志只能在REDIS_SLAVE标识处于打开状态时使用。
3.3 REDIS_LUA_CLIENT标识表示客户端是专门处理lua脚本里面包含的redis命令的伪客户端。

4、客户端目前的状态：
 REDIS_MONITOR表示客户端正在执行monitor命令
 REDIS_UNIX_SOCKET表示服务器使用UNIX套接字来连接客户端
 REDIS_BLOCKED表示客户端正在被BRPOP、LRPOP等命令阻塞。
 REDIS_UNBLOCKED表示客户端已经从REDIS_BLOCKED标志所表示的阻塞状态中脱离出来
 REDIS_MULTI表示客户端正在执行事务
 REDIS_DIRTY_CAS表示事务使用watch命令监视的数据库键已经被修改。
 REDIS_DIRTY_EXEC表示事务在命令入队时出现了错误，以上两个标志都表示事务的安全性已经被破坏，只要这两个表示中的任意已被打开，EXEC命令
       必然会执行失败，这两个标识只能在客户端打开了REDIS_MULTI标志的情况下使用。
REDIS_CLOSE_ASAP表示客户端的输出缓冲区大小超过了服务器允许的范围，服务器会在下一次执行serverCron函数时，关闭这个客户端，以避免服务器
       的稳定性受到这个客户端的影响，积存在输出缓冲区中的所有内容会直接被释放，不会返回给客户端。
REDIS_CLOSE_AFTER_REPLY标志表示有用户对这个客户端执行client kill命令，或者客户端发送给定服务器的命令请求中包含了错误的协议内容。
       服务器会将客户端积存在发送缓冲区中的所有内容发送给客户端，然后关闭客户端。
REDIS_ASKING：表示客户端向集群节点发送了ASKING命令
REDIS_FORCE_AOF强制服务器将当前执行的命令写入到AOF文件里面
REDIS_FORCE_REPL强制主服务器将当前执行的命令复制给所有从服务器。


客户端是一个主服务器：REDIS_MASTER
客户端正在被列表命令阻塞：REDIS_BLOCKED
客户端正在执行事务，但事务的安全性已被破坏：REDIS_MULTI | REDIS_DIRTY_CAS
客户端是一个从服务器，并且版本低于2.8： REDIS_SLAVE | REDIS_PRE_PSYNC
执行LUA脚本：REDIS_LUA_CLIENT | REDIS_FORCE_AOF | REDIS_FORCE_REPL

5、 输入缓冲区
sds querybuf;
输入缓冲区的大小根据输入内容动态地缩小或者扩大，但它的最大大小不能超过1GB，否则服务器将关闭客户端。

6、命令和命名参数
robj **argv;
int argc;

7、命令的实现函数
struct redisCommand *cmd;

8、输出缓冲区
执行命令所得的命令回复会被保存在客户端状态的输出缓冲区里面，每个客户端都有两个输出缓冲区可用，
一个缓冲区的大小是固定的，另一个缓冲区的大小是可变的。
char buf[REDIS_REPLY_CHUNK_BYTES];
int bufpos;
list *reply;

9、身份认证
int authenticated;

redis.conf的requirepass选项。

10、时间
time_t ctime;
time_t lastinteraction;
time_t obuf_soft_limit_reached_time;

11、关闭普通客户端
11.1 如果客户端进程退出或者被杀死，那么客户端与服务器之间的网络连接将被关闭，从而造成客户端被关闭。
11.2 如果客户端向服务器发送了带有不符合协议格式的命令请求，那么这个客户端也会被服务器关闭。
11.3 如果客户端成为了client kill命令的目标，那么他也会被关闭；
11.4 如果用户伪客户端设置了timeout配置选项，那么，当客户端的空转时间超过timeout选项设置的值时，客户端将被关闭。
     不过timeout选项有一些例外情况：如果客户端是主服务器，从服务器，正在被BLPOP等命令阻塞，或者正在执行SUBSCRIBE、PSUBSCRIBE等命令订阅
11.5 如果客户端发送的命令请求的大小超过输入缓冲区的限制大小，那么这个客户端会被服务器关闭。
11.6 如果要发送给客户端的命令回复的大小超过输出缓冲区的限制大小，那么这个客户端也会被服务器关闭。

12、lua脚本的伪客户端
redisClient *lua_client;
     

}

redisCommand()
{
name            char *               命令的名字，比如"set"
proc            redisCommandProc *   函数指针，指向命令的实现函数，比如setCommand.typedef void redisCommandProc(redisClient *c);
arity           int                  命令参数的个数，用于检查命令请求的格式是否正确。如果这个值是-N，那么表示参数的数据量大于等于N。
sflags          char *               字符串形式的标识值，这个值记录了命令的属性，
flags           int                  对sflags标识进行分析得到的二进制标识，由程序自动生成
calls           long long            服务器总共执行了多少次这个命令
milliseconds    long long            服务器执行这个命令所耗费的总时长


w   写入命令，可能会修改数据库
r   只读命令，不会修改数据库
m   这个命令可能会占用大量内存，执行之前需要先检查服务器的内存使用情况，如果内存紧张禁止执行
a   管理命令
p   发布与订阅功能方面的命令
s   不可以在lua脚本中使用
R   随机命令。对相同的数据集和相同的参数，命令返回的结果可能不同
S   当在lua脚本中使用这个命令时，对这个命令的输出结果进行一次排序，使得命令的结果有序
l   可以在服务器载入数据的过程中使用
t   允许从服务器在带有过期数据时使用的命令
M   在监视器模式下不会自动被传播

}

