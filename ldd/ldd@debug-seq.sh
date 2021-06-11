linux/seq_file.h
适合多实例格式化输出；
对单实例的，可通过数组进行组织

https://www.ibm.com/developerworks/cn/linux/l-kerns-usrs2/
instance(iomem ioport)
{
显示resource对象内容；resource对象又分为iomem和ioport两类。
iomem :kernel/resource.c
iomem_resource：在kernel/resoure.c中被初始化，在driver/目录下的驱动中被引用。
ioport:kernel/resource.c
ioport_resource：在kernel/resoure.c中被初始化，在driver/目录下的驱动中被引用。

buddyinfo:       mm/vmstat.c   显示pg_data_t对象内容；        内存总体伙伴算法
pagetypeinfo:    mm/vmstat.c   显示pg_data_t对象内容；        不同类型page的伙伴算法
vmstat:          mm/vmstat.c   显示vm_event_state对象内容；   各种类型内存状态
zoneinfo:        mm/vmstat.c   显示pg_data_t对象内容；        zone

meminfo：        fs/proc/meminfo.c 显示sysinfo对象内容和page的统计信息。
直接调用了single_open(file, meminfo_proc_show, NULL);函数。

vmallocinfo:      mm/vmalloc.c  显示vm_struct对象的内容；

uptime；         fs/proc/uptime.c
}

1. seq文件接口就是用于简化procfs的read()处理大数据量遇到困难时的内核辅助机制。seq文件使procfs操作更为简单、明了。
seq_file *m->private可用于存储函数之间共享传递的变量，该变量常在open函数中被初始化。
   共享处理过程
start stop next show中的void *v可用于存储过程变量。递归因子。 start和next的返回值就是递归因子。然后在show中呈现出来。
   实现处理流程
   
seq_operations()
{
struct seq_operations {
        void * (*start) (struct seq_file *m, loff_t *pos);
        void (*stop) (struct seq_file *m, void *v);
        void * (*next) (struct seq_file *m, void *v, loff_t *pos);
        int (*show) (struct seq_file *m, void *v);
};
start函数用于指定seq_file文件的读开始位置，返回实际读开始位置，如果指定的位置超过文件末尾，应当返回NULL，
      它首先被seq接口调用，用于初始化迭代序列的位置，并返回找到的第一个迭代对象。
start函数可以有一个特殊的返回SEQ_START_TOKEN，它用于让show函数输出文件头，但这只能在pos为0时使用。

next函数用于把seq_file文件的当前读位置移动到下一个读位置，返回实际的下一个读位置，如果已经到达文件末尾，返回NULL，
    它将迭代位置前移，并返回下一迭代对象的指针。此函数对于迭代对象的内核结构体是不可知，并将其看作为通过对象。
    
stop函数用于在读完seq_file文件后调用，它类似于文件操作close，用于做一些必要的清理，如释放内存等，
    在结束时被调用，完成一些清理工作。
    
show函数用于格式化输出，如果成功返回0，否则返回出错码。
    用于解释传递给它的迭代对象，并在用户读取相应的procfs文件时，产生显示的输出字符串。此方法使用了一些辅助程序，如
    seq_printf() seq_putc() seq_puts 格式化输出。
    
}

Seq_file()
{
int seq_putc(struct seq_file *m, char c);
函数seq_putc用于把一个字符输出到seq_file文件。

int seq_puts(struct seq_file *m, const char *s);
函数seq_puts则用于把一个字符串输出到seq_file文件。

int seq_escape(struct seq_file *, const char *, const char *);
函数seq_escape类似于seq_puts，只是，它将把第一个字符串参数中出现的包含在第二个字符串参数中的字符按照八进制形式输出，
也即对这些字符进行转义处理。

int seq_printf(struct seq_file *, const char *, ...)
        __attribute__ ((format (printf,2,3)));

函数seq_printf是最常用的输出函数，它用于把给定参数按照给定的格式输出到seq_file文件。

int seq_path(struct seq_file *, struct vfsmount *, struct dentry *, char *);

函数seq_path则用于输出文件名，字符串参数提供需要转义的文件名字符，它主要供文件系统使用。

在定义了结构struct seq_operations之后，用户还需要把打开seq_file文件的open函数，以便该结构与对应于seq_file文件的struct file结构关联起来，例如，struct seq_operations定义为：

struct seq_operations exam_seq_ops = {
   .start = exam_seq_start,
   .stop = exam_seq_stop,
   .next = exam_seq_next,
   .show = exam_seq_show
};

那么，open函数应该如下定义：

static int exam_seq_open(struct inode *inode, struct file *file)
{
    return seq_open(file, &exam_seq_ops);
};

注意，函数seq_open是seq_file提供的函数，它用于把struct seq_operations结构与seq_file文件关联起来。 最后，用户需要如下设置struct file_operations结构：

struct file_operations exam_seq_file_ops = {
        .owner   = THIS_MODULE,
        .open    = exm_seq_open,     
        .read    = seq_read,         /* built-in helper function */
        .llseek  = seq_lseek,        /* built-in helper function */
        .release = seq_release       /* built-in helper function */
};

注意，用户仅需要设置open函数，其它的都是seq_file提供的函数。

然后，用户创建一个/proc文件并把它的文件操作设置为exam_seq_file_ops即可：

struct proc_dir_entry *entry;
entry = create_proc_entry("exam_seq_file", 0, NULL);
if (entry)
entry->proc_fops = &exam_seq_file_ops;

对于简单的输出，seq_file用户并不需要定义和设置这么多函数与结构，它仅需定义一个show函数，然后使用single_open来定义open函数就可以，
}


void *(*start) (struct seq_file *m, loff_t *pos);
sfile参数几乎可在大多数情况下忽略。pos是一个整数的位置值，表示读取的位置。对位置的解释完全取决于迭代器的实现本身，
并不一定非得是结果文件的字符位置。因为seq_file的实现通常都要遍历一个项目序列，因此位置通常被解释为指向序列中下一
项目的游标。
传入的pos就可简单作为scull_devices数组的索引。


void (*stop) (struct seq_file *m, void *v);


void *(*next) (struct seq_file *m, void *v, loff_t *pos);
v ：先前对start或者next的调用所返回的迭代器，pos是文件的当前位置，next方法应增加pos指向的值。
这依赖于迭代器的工作方式。

int (*show) (struct seq_file *m, void *v);
v：为所指向的项目建立输出，

int seq_printf(struct seq_file *sfile, const char *fmt, ...)  ## 格式化输出调用
	__attribute__ ((format (printf,2,3)));
	
int seq_escape(struct seq_file *sfile, const char *s, const char *esc); ## 等价于puts，只是若s中的某个字符也存在于esc中，
    则该字符会以八进制形式打印。传递给esc参数的长键值为"\t\n\\"
int seq_putc(struct seq_file *m, char c);             ## 用户空间putc
int seq_puts(struct seq_file *m, const char *s);      ## 用户空间puts
int seq_path(struct seq_file *, struct path *, char *); ## 用于输出与某个目录关联的文件名



