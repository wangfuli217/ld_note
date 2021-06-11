1. Sysctl是一种用户应用来设置和获得运行时内核的配置参数的一种有效方式，通过这种方式，用户应用可以在内核运行的任何时刻
   来改变内核的配置参数，也可以在任何时候获得内核的配置参数。
2. Sysctl 条目也可以是目录，此时 mode 字段应当设置为 0555，否则通过 sysctl 系统调用将无法访问它下面的 sysctl 条目，
   child 则指向该目录条目下面的所有条目，对于在同一目录下的多个条目，不必一一注册，用户可以把它们组织成一个 
   struct ctl_table 类型的数组，然后一次注册就可以。  
   
sysctl(/proc/sys/)
{
实例：drivers/scsi/scsi_sysctl.c

/proc/sys/中的文件和目录都是依ctl_table结构定义的。ctl_table结构的注册和除名是通过在kernel/sysctl.c中定义的
register_sysctl_table和unregister_sysctl_table函数完成。

struct ctl_table
{
    const char *procname;        /* proc/sys中所用的文件名 */
    void *data;                  /* 表示对应于内核中的变量名称    */
    int maxlen;                  /* 输出的内核变量的尺寸大小 */
    字段maxlen，它主要用于字符串内核变量，以便在对该条目设置时，对超过该最大长度的字符串截掉后面超长的部分.
    
    mode_t mode;                 /* 创建的/proc/sys猪相关文件或目录的访问权限 */
    struct ctl_table *child;     /* 用于建立目录与文件之间的父子关系 */
    
    所有和文件相关联的ctl_instance都必须有proc_handler初始化，内内核会给目录分派一个默认值

    struct ctl_table *parent;    /* Automatically set */
    proc_handler *proc_handler;  /* 完成读取或者写入操作的函数 */
    字段proc_handler，表示回调函数,
    对于整型内核变量，应当设置为&proc_dointvec，
    对于字符串内核变量，则设置为 &proc_dostring。
    
    对/proc/sys下面的文件读写的时候将调用这个例程

    ctl_handler *strategy; /* Callback function for all r/w */ 
    用sysctl读写系统参数时候，将调用这个例程

    struct proc_dir_entry *de; /* /proc control block */ 
    指向在/proc/sys中的结点(proc文件系统数据结构）

    void *extra1;
    void *extra2;                /* 两个可选参数，通常用于定义变量的最小值和最大值? */
};

根据与文件相关联的变量类型的不同，proc_handler所指的函数也不相同。
proc_dostring：读/写一个字符串
/proc/sys/kernel/core_pattern  字符串

proc_dointvec：读写一个包含一个或多个整数的数组
/proc/sys/kernel/sched_child_runs_first 整数

proc_dointvec_minmax：同上，但是要确定输入数据在min/max范围内，不在该范围内的值会被拒绝
/proc/sys/kernel/sched_min_granularity_ns 整数

用户态表示秒 - 内核态对应jiffies
proc_dointvec_jiffies：读写一个整数数组，但此内核变量以jiffies为单位表示，在返回用户前会转化为秒数，写入前转化为jiffies
/proc/sys/kernel/printk_ratelimit 整数 #在重新打开消息之前应该等待的秒数。

用户态表示毫秒 -  内核态对应jiffies
proc_dointvec_ms_jiffies：同上，只是这里是转化为毫秒数
/proc/sys/net/ipv4/neigh/default/retrans_time_ms

proc_doulongvec_minmax：类似proc_dointvec_minmax，但其值为长整数。


proc_doulongvec_ms_jiffies_minmax：读取一个长整数数组。此内核变量以jiffies为单位，而用户空间已毫秒为单位。此值也必须指定min和max区间


1. extern asmlinkage long sys_sysctl(struct __sysctl_args *args)
    2. int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp, void __user *newval, size_t newlen)
        3. static int parse_table(int __user *name, int nlen,
                void __user *oldval, size_t __user *oldlenp,
                void __user *newval, size_t newlen,
                struct ctl_table_root *root,
                struct ctl_table *table)

typedef int proc_handler (struct ctl_table *ctl, int write, void __user *buffer, size_t *lenp, loff_t *ppos);
                                              写数据write=1    输入缓冲区buffer   输入数据长度lenp   输入数据偏移ppos
                                              读数据write=0    输出缓冲区buffer   输出数据长度lenp   输出数据偏移ppos
}

sysfs(模块参数与sysfs)
{


}