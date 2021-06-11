offsetof(避免内存碎片化){
in_packetstruct,fsnode,fsnode_bucket,fsedge_bucket,write_job,symlink_bucket

malloc(offsetof(in_packetstruct,data)+leng);
typedef struct in_packetstruct {
    struct in_packetstruct *next;
    uint32_t type,leng;
    uint8_t data[1];
} in_packetstruct;
1. 将协议的数据包头和数据包内容统一在一段内存中
2. 在结构体尾部增加可变字段

# 在struct内union中不同类型的内存申请
nrelemsize[0] = offsetof(fsnode,data)+offsetof(struct _ddata,end);   # dir
nrelemsize[1] = offsetof(fsnode,data)+offsetof(struct _fdata,end);   # file
nrelemsize[2] = offsetof(fsnode,data)+offsetof(struct _sdata,end);   # symlink
nrelemsize[3] = offsetof(fsnode,data)+offsetof(struct _devdata,end); # dev
nrelemsize[4] = offsetof(fsnode,data);                               # other
1. 将dir，file，symlink，dev，other统一成一个fsnode对象进行管理，在内存上，又将fsnode划分
   为dir，file，symlink，dev，other进行管理，避免了内存浪费。

}

bucket(构建内存池){
slist, CREATE_BUCKET_ALLOCATOR(slist,slist,5000)
chunk, CREATE_BUCKET_ALLOCATOR(chunk,chunk,20000)
freenode, CREATE_BUCKET_ALLOCATOR(freenode,freenode,5000)
quotanode, CREATE_BUCKET_ALLOCATOR(quotanode,quotanode,500)

#define CREATE_BUCKET_ALLOCATOR(allocator_name,element_type,bucket_size)
slist_malloc();slist_free(s);
}

linux(系统级别内存申请){

1. 进程管理单次内存申请限制
RLIMIT_MEMLOCK  进程中使用mlock锁定内存的最大尺寸
setrlimit(RLIMIT_MEMLOCK,&rls);   # RLIM_INFINITY
2. 调用mlockall函数后，保证所有申请内存都在物理内存中
mlockall(MCL_CURRENT|MCL_FUTURE) 
int munlockall(void);
3. 调用mlock函数后，保证addr对应的长度为len的内存在物理内存中
int mlock(const void *addr, size_t len);
int munlock(const void *addr, size_t len);

4. mmap 适用于申请块比较大，且不频繁回收的情况，这样性能要比malloc稳定。[mmap系统调用，malloc封装了sbrk系统调用]
pdata = mmap(NULL,pdataleng,PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,-1,0);
内存映射文件的情况
1：在读取方面 两者差异较小,MMAP性能略高
2：在写入方面 两者差距较大,MMAP完全取胜利

5. glibc内存管理
void *calloc(size_t nmemb, size_t size);  # 申请后为zero类型内存
void *malloc(size_t size);                # 申请未被zero类型内存
void free(void *ptr);                     # 释放
void *realloc(void *ptr, size_t size);    # 会保留已申请内存的数据，可以用于内存扩展和内存收缩

}

malloc(glibc){

mallopt - set memory allocation parameters
mallopt(M_ARENA_MAX, 8);
M_ARENA_MAX        MALLOC_ARENA_MAX       # MALLOC_ARENA_MAX 1或2；提高了内存利用率，降低了多线程性能
M_ARENA_TEST       MALLOC_ARENA_TEST      # 如果MALLOC_ARENA_MAX不为0的时候，MALLOC_ARENA_TEST才有效
M_CHECK_ACTION     
M_MMAP_MAX         MALLOC_MMAP_MAX_
M_MMAP_THRESHOLD   MALLOC_MMAP_THRESHOLD_
M_MXFAST           
M_PERTURB          MALLOC_PERTURB_
M_TOP_PAD          MALLOC_TOP_PAD_
M_TRIM_THRESHOLD   MALLOC_TRIM_THRESHOLD_

MALLOC_ARENA_MAX:... ... 
1. 减少thread的数量开始测试，在测试的时候偶然发现一个很奇怪的现象。那就是如果进程创建了一个线程
   并且在该线程内分配一个很小的内存1k，整个进程虚拟内存立马增加64M，然后再分配，内存就不增加了。
2. 刨根问底
   经过一番google和代码查看。终于知道了原来是glibc的malloc在这里捣鬼。glibc 版本大于2.11的都会
   有这个问题：在redhat 的官方文档上：https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/6.0_Release_Notes/compiler.html
3. 总结一下，
   glibc为了分配内存的性能的问题，使用了很多叫做arena的memory pool,缺省配置在64bit下面是每一个
   arena为64M，一个进程可以最多有 cores * 8个arena。假设你的机器是4核的，那么最多可以有4 * 8 = 32
   个arena，也就是使用32 * 64 = 2048M内存。 当然你也可以通过设置环境变量来改变arena的数量.
   例如export MALLOC_ARENA_MAX=1
   
malloc per thread arenas:... ...
    在过去的 malloc 实现中，每个程序会有一个 main arenas 供 malloc 申请使用。对于多线程的程序，
每个线程调用 malloc 的时候，都需要事先检查是否有锁，确认没有锁后，才能拿到内存空间。这影响了程序的性能。
    在现在的实现中，每一个线程都会有自己的 arenas，这就避免了线程之间的竞争，从而提高性能。
    另外，我们可以看到 arenas 是一些大约为 64MB 的无权限匿名页（64位系统中）。
}

libc(redis)
{
glibc
tcmalloc
jemalloc
}

container_of(内存处理似乎有offsetof，就需要再考虑container_of){

#define container_of(ptr, type, member)					\
	({								\
		const typeof(((type *) NULL)->member) *__mptr = (ptr);	\
		(type *) ((char *) __mptr - offsetof(type, member));	\
	})

}