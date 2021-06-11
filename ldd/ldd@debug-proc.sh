linux/proc_fs.h
适合单实例格式化输出


instance(gen_rtc_proc_init)
{
drivers/char/genrtc.c 中gen_rtc_proc_init函数

sysrq-trigger:  write_sysrq_trigger 只有输入时如何注册？

kpagecount：fs/proc/page.c
kpageflags：fs/proc/page.c   max_pfn
}
内核会分配一个内存页(即PAGE_SIZE字节的内存块)，驱动程序可以将数据通过这个内存页返回到用户空间。

read_proc_t()
{
typedef	int (read_proc_t)(char *page, char **start, off_t off, int count, int *eof, void *data);
page：内核提供给驱动的内存页(大小由 PAGE_SIZE 决定)，用于驱动向其中写入信息；
       pointer to a kernel buffer
start：内核提供给驱动的，用于提示驱动，从前面提供的 Page 的哪个部分开始写入数据。
        start 说明了驱动应该从内核提供的 Page 的那个位置开始"写"。
         pointer (optional) to module’ own buffer 
offset：offset 则是用户空间传给内核的参数，用于告诉内核从 proc 里面的文件的哪个偏移开始读取数据。
        offset 说明了从待读取的文件的哪个位置开始"读"，
        current file-pointer offset 
count：  size of space available in the kernel’s buffer   
eof 指向一个整数值，当没有数据返回时，驱动程序必须设置这个参数；
    如果*eof在返回前未被赋值，为了读取更多的数据将会再次调用procfs读入口点。
    如果将*eof赋值的行注释掉，会再次调用readme_proc()，其偏移参数设为1190(1190是从Node No:0到Node No:99整字符串的ASCII字节数)
    readme_proc()返回已复制到缓冲区的字节数。
    
data：参数是提供给驱动程序的专用数据指针，可用于内部记录。

start的用法有点复杂，可以帮助实现大于一个内存页的/proc文件。
      start参数的用法看起来有些特别，它用来只是要返回给用户的数据保存在内存页的什么位置。
	  在我们的read_proc方法被调用时，*start的初始值为NULL。
	  如果保留*start为空，内核将假设数据保存在内存页偏移量为0的地方；也就是说：内核将对read_proc作如下假设：
	  该函数将虚拟文件的整个数据放到了内存页，并同时忽略offset参数。
	  如果*start为非空，内核将认为由*start指向的数据是offset指定的偏移量处的数据，可直接返回给用户。
	  fs/proc/generic.c

################### readme_proc 再次被调用  ###################
1. readme_proc被调用多次，每次调用获取从offset开始的最大数据量为count的字节数。每次调用时所请求的字节小于一页。
2. 每次调用，内核将offset增加，增加的大小为上次调用返回的字节数。
3. 仅当请求的字节数与当前偏移的和大于或等于实际的数据量时，readme_proc才为eof赋值。若eof未被赋值，则此函数会
   被再次调用，调用时的offset会增加上次读取的字节数。
4. 每次调用后，仅从*start处开始的字节被收集并返回至调用者。
   



老的/proc接口
	int (*get_info)(char *page, char **start, off_t offset, int count);
	 
struct proc_dir_entry *create_proc_read_entry(const char *name, 
		mode_t mode, struct proc_dir_entry *base, read_proc_t *read_proc, void *data);
name: 要创建的文件名称
mode：是该文件的保护掩码
base：文件所在的目录(如果base为NULL，则文件将创建在/proc的根目录)
read_proc:
data: 内核会忽略data参数，但是会将该参数传递给read_func_proc。

void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
struct remove_proc_entry("scullmem", NULL);
如果删除入口项失败，将导致未预期的调用，如果模块已被卸载，内核会崩溃。

}

create_proc_entry(create_proc_entry,remove_proc_entry)
{
struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
                                          struct proc_dir_entry *parent)
该函数用于创建一个正常的proc条目，参数name给出要建立的proc条目的名称，参数mode给出了建立的该proc条目的访问权限，
参数parent指定建立的proc条目所在的目录。如果要在/proc下建立proc条目，parent应当为NULL。否则它应当为proc_mkdir
返回的struct proc_dir_entry结构的指针。

extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
该函数用于删除上面函数创建的proc条目，参数name给出要删除的proc条目的名称，参数parent指定建立的proc条目所在的目录。                    
}

proc_mkdir(proc_mkdir,proc_mkdir_mode,proc_symlink)
{
struct proc_dir_entry *proc_mkdir(const char * name, struct proc_dir_entry *parent)
该函数用于创建一个proc目录，参数name指定要创建的proc目录的名称，参数parent为该proc目录所在的目录。

extern struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode, struct proc_dir_entry *parent); 
struct proc_dir_entry *proc_symlink(const char * name, struct proc_dir_entry * parent, const char * dest)

该函数用于建立一个proc条目的符号链接，参数name给出要建立的符号链接proc条目的名称，参数parent指定符号连接所在的目录，
参数dest指定链接到的proc条目名称。
}

create_proc_read_entry(create_proc_read_entry,create_proc_info_entry)
{
struct proc_dir_entry *create_proc_read_entry(const char *name, mode_t mode, struct proc_dir_entry *base, read_proc_t *read_proc, void * data)

该函数用于建立一个规则的只读proc条目，参数name给出要建立的proc条目的名称，参数mode给出了建立的该proc条目的访问权限，
参数base指定建立的proc条目所在的目录，参数read_proc给出读去该proc条目的操作函数，参数data为该proc条目的专用数据，
它将保存在该proc条目对应的struct file结构的private_data字段中。

struct proc_dir_entry *create_proc_info_entry(const char *name,
        mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
该函数用于创建一个info型的proc条目，参数name给出要建立的proc条目的名称，参数mode给出了建立的该proc条目的访问权限，
参数base指定建立的proc条目所在的目录，参数get_info指定该proc条目的get_info操作函数。实际上get_info等同于read_proc，
如果proc条目没有定义个read_proc，对该proc条目的read操作将使用get_info取代，因此它在功能上非常类似于函数
create_proc_read_entry。
}

proc_net_create()
{
struct proc_dir_entry *proc_net_create(const char *name, mode_t mode, get_info_t *get_info)

该函数用于在/proc/net目录下创建一个proc条目，参数name给出要建立的proc条目的名称，参数mode给出了建立的该proc条目的访问权限，
参数get_info指定该proc条目的get_info操作函数。

struct proc_dir_entry *proc_net_fops_create(const char *name,
        mode_t mode, struct file_operations *fops)
该函数也用于在/proc/net下创建proc条目，但是它也同时指定了对该proc条目的文件操作函数。

void proc_net_remove(const char *name)
该函数用于删除前面两个函数在/proc/net目录下创建的proc条目。参数name指定要删除的proc名称。

}

proc_dir_entry()
{
除了这些函数，值得一提的是结构struct proc_dir_entry，为了创建一了可写的proc条目并指定该proc条目的写操作函数，必须设置
上面的这些创建proc条目的函数返回的指针指向的struct proc_dir_entry结构的write_proc字段，并指定该proc条目的访问权限有写
权限。

为了使用这些接口函数以及结构struct proc_dir_entry，用户必须在模块中包含头文件linux/proc_fs.h。
}

2、write_proc_t
typedef	int (write_proc_t)(struct file *file, const char __user *buffer, unsigned long count, void *data);



------ csdn ------
一、先看下之前版本在/proc/下创建文件并提供ops
	proc_dir = proc_mkdir(MOTION_PROC_DIR, NULL);
	if (!proc_dir) {
		err = -ENOMEM;
		goto no_proc_dir;
	}
	proc_file = create_proc_entry(MOTION_PROC_FILE, 0666, proc_dir);
	if (!proc_file) {
		err = -ENOMEM;
		goto no_proc_file;
	}
	proc_file->proc_fops = &event_fops;
	
二、看看Linux3.10版本相同操作
	proc_dir = proc_mkdir(MOTION_PROC_DIR, NULL);
	if (!proc_dir) {
			err = -ENOMEM;
			goto no_proc_dir;
	}
	//modify by tan for linux3.10
	//proc_file = create_proc_entry(MOTION_PROC_FILE, 0666, proc_dir);
	proc_file = proc_create(MOTION_PROC_FILE, 0666, proc_dir,&event_fops);
	//end tank
	if (!proc_file) {
			err = -ENOMEM;
			goto no_proc_file;
	}
	//proc_file->proc_fops = &event_fops;  //modify by tank for linux3.10
	
	
------ ibm ------
proc_dir_entry		在文件系统中的位置
proc_root_fs		/proc
proc_net			/proc/net
proc_bus			/proc/bus
proc_root_driver	/proc/driver	

## 创建
struct proc_dir_entry *proc_symlink(const char *,struct proc_dir_entry *, const char *);  # 链接文件
struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);                  # 目录文件
struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode, struct proc_dir_entry *parent); # 目录文件包含属性
struct proc_dir_entry *proc_create(const char *name, mode_t mode,                         #
	struct proc_dir_entry *parent, const struct file_operations *proc_fops);
static inline struct proc_dir_entry *create_proc_read_entry(const char *name,             # 创建只读文件
	mode_t mode, struct proc_dir_entry *base, 
	read_proc_t *read_proc, void * data);


struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,                  # 创建文件
						struct proc_dir_entry *parent);
struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
				struct proc_dir_entry *parent,
				const struct file_operations *proc_fops,
				void *data);
## 删除
void remove_proc_entry(const char *name, struct proc_dir_entry *parent);

proc_dir_entry的proc_fops 与 read_proc、write_proc是互斥调用关系


------ proc_create
struct proc_dir_entry *mytest_dir = proc_mkdir("mytest", NULL);

然后来看看proc文件的创建。
创建方法是调用以下函数：
static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode,
struct proc_dir_entry *parent, const struct file_operations *proc_fops);
name就是要创建的文件名。
mode是文件的访问权限，以UGO的模式表示。
parent与proc_mkdir中的parent类似。也是父文件夹的proc_dir_entry对象。
proc_fops就是该文件的操作函数了。
例如：
struct proc_dir_entry *mytest_file = proc_create("mytest", 0x0644, mytest_dir, mytest_proc_fops);
还有一种方式：
struct proc_dir_entry *mytest_file = proc_create("mytest/mytest", 0x0644, NULL, mytest_proc_fops);
如果文件夹名称和文件名定义为常量：
#define MYTEST_PROC_DIR "mytest"
#define MYTEST_PROC_FILE "mytest"
第二种方式为：
struct proc_dir_entry *mytest_file = proc_create(MYTEST_PROC_DIR"/"MYTEST_PROC_FILE, 0x0644, NULL, mytest_proc_fops);

接下来看看mytest_proc_fops的定义。
static const struct file_operations mytest_proc_fops = {
 .open  = mytest_proc_open,
 .read  = seq_read,
 .write  = mytest_proc_write,
 .llseek  = seq_lseek,
 .release = single_release,
};