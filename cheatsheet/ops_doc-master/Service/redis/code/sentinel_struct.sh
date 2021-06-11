/* Sentinel 的状态结构 */
sentinelState(struct){
    // 当前纪元
    uint64_t current_epoch;     /* Current epoch. */
    // 保存了所有被这个 sentinel 监视的主服务器
    // 字典的键是主服务器的名字
    // 字典的值则是一个指向 sentinelRedisInstance 结构的指针
    dict *masters;      /* Dictionary of master sentinelRedisInstances.
                           Key is the instance name, value is the
                           sentinelRedisInstance structure pointer. */
    // 是否进入了 TILT 模式？
    int tilt;           /* Are we in TILT mode? */
    // 目前正在执行的脚本的数量
    int running_scripts;    /* Number of scripts in execution right now. */
    // 进入 TILT 模式的时间
    mstime_t tilt_start_time;   /* When TITL started. */
    // 最后一次执行时间处理器的时间
    mstime_t previous_time;     /* Last time we ran the time handler. */
    // 一个 FIFO 队列，包含了所有需要执行的用户脚本
    list *scripts_queue;    /* Queue of user scripts to execute. */
} sentinel;


