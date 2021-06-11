内核分为基础部分和应用部分：基础部分有内存管理、任务调度和中断异常处理；
                            应用部分有文件系统、设备管理和驱动。
内核分为内核框架和内核实现：内核框架有块设备、字符设备、总线、文件系统的VFS层等；
                            内核应用有寄存器的使用、设备链路状态如何探测、文件系统如何使用barrier IO、同步和异步IO区别等等。

lkd(内存)
{
从伙伴系统分配，提供页式的内存管理。
1. alloc_pages -> page_address() 
2. __get_free_pages() 封装了 alloc_pages和page_address两个函数。

从slab系统分配，提供基于对象的内存管理。
}  

lkd(任务调度)
{
wait_event_timeout()
wait_event_interruptible()
wait_event_interruptible_timeout()
wait_event_interruptoble_exclusive()
}                          

lib/rbtree.c 红黑树
lib/radix-tree.c radix树

super_block(整个文件系统本身)
{
    超级块是对应文件系统自身的控制块结构。超级块保存了文件系统设定的文件块大小、超级块的操作函数，而文件系统
内所有的inode也都要链接到超级块的链表头。
    超级块的内容需要读取具体文件系统在磁盘上的超级块结构获得，所以超级块是具体文件系统超级块的内存抽象。
关键字段：
    s_blocksize: 文件系统的块大小
    s_maxbytes:  文件系统中最大文件的尺寸
    s_type:      指向file_system_type结构的指针
    s_magic:     魔术数字，每个文件系统都有一个魔术数字
    s_root:      指向文件系统根dentry的指针
关键字段：链表
    s_inodes:    指向文件系统内所有的inode，通过它可以遍历inode对象
    s_dirty:     所有dirty的inode对象
    s_bdev:      文件系统存在的块设备指针
    
super_blocks链表头：链接了内核所有的超级块实例。
}


super_operations()
{

}

dentry(树状关系)
{
dentry hash:内核使用了hash表缓存dentry。

    d_inode:指向一个inode结构，这个inode和dentry共同描述了普通文件或者目录文件
    dentry结构里有d_subdirs成员和d_child成员。d_subdirs是子项(子项可能是目录，也可能是文件)的链表头，所有的子项都要链接到这个链表中，
    d_child是dentry自身的链表头，需要链接到父dentry的d_subdirs成员。当移动文件的时候，需要把一个dentry结构从旧的父dentry的链表上脱离，然后
    链接到新的父dentry的d_sbudirs成员。
    d_parent:指向父dentry结构
    d_hash是连接到dentry cache的hash链表
    d_name成员保存的是文件或目录的名字。
    d_mounted用来指示dentry是否是一个挂载点。如果是挂载点，该成员不为零。
    
1. 每个文件dentry链接到父目录的dentry，形成了文件系统的结构树。
2. 所有的dentry都指向一个dentry_hashtable.
3. home命令下的mnt目录指向一个挂载的文件系统。 dentry的d_mounted成员不为0，代表该dentry有个挂载点，有文件系统挂载，需要特殊处理。
4. vfsmount结构被连接到内核一个全局变量mount_hashtable数组链表。

    }

inode(文件)
{
inode保存了文件的大小、创建时间、文件的块大小等参数，以及对文件的读写函数、文件的读写缓存等信息。
一个真实的文件可以有多个dentry,因为指向文件的路径可以有多个，而inode只有一个。

    成员i_list,i_sb_list,i_dentry分别是三个链表头。成员i_list用于连接描述inode当前状态的链表。
    成员i_sb_list用于链接到超结块的中的inode链表。当创建一个新的inode的时候，成员i_list要连接到
    inode_in_use这个链表，表示Inode处于使用状态，同时成员i_sb_list也要链接到文件系统超级块的s_inodes链表头。
    由于一个文件可以对应多个dentry，这些dentry都要链接到成员i_dentry这个链表头。
    
    成员i_ino是inode的号，而i_count是inode的引用计数。成员i_size是以字节为单位的文件长度。
    
    成员i_blkbits是文件块的位数。
    
    成员i_fop是一个struct file_operations类型的指针。文件的读写函数和异步io函数都在这个结构中提供。
    每一个具体的文件系统，基基本都要求提供各自的文件操作函数。
    
    i_mapping是一个重要的成员。这个结构的是缓存文件的内容，对文件的读写操作直接从缓存中获得，
    而不用再去物理磁盘读取，从而大大加速了文件的读操作。写操作也要首先访问缓存，写入到文件的缓存。
    然后等待适合的机会，在从缓冲写入磁盘。
    
    成员i_bdev是指向块设备的指针。这个块设备就是文件所在的文件系统所绑定的块设备。
    
}

file(描述进程和文件交互的关系)
{
    f_dentry和f_vfsmnt分别指向文件对应的dentry结构和文件所属于的文件系统的vfsmount对象。
    
    成员f_pos表示进程对文件操作的位置。例如对文件读取前10字节，f_pos就指示11字节的位置
    
    f_uid和f_gid分别表示文件的用户ID和用户组ID。
    
    成员f_ra用于文件预读的设置。
    
    f_mapping指向一个address_space结构。这个结构封装了文件的读写缓存页面。
}