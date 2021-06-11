
linux/slab.h

kmalloc(物理地址连续)
{
static void *kmalloc(size_t size, gfp_t flags)
1. 可以分为阻塞和非阻塞两种
2. 不对获取的内存空间清零，分配给它的内存保持原有的数据
3. 分配的区域在物理内存中也是连续的。

GFP：get_free_pages()

1.内核负责管理系统物理内存，物理内存只能按页面进行分配。
2. 驱动程序开发人员应经该记住一点，就是内核只能分配一些预定义的、固定大小的字节数组。
   如果申请任意数量的内存，那么得到的很可能会多一些，最多会到申请数量的两倍。
   程序员应该记住，kmalloc能处理的最小的内存块是32或64，到底是哪个则取决于当前体系结构的页面大小。
   对kmalloc能够分配的内存块大小，存在一个上限。这个限制随着体系结构的不同以及内核配置选项的不同而变化。
   如果我们系统代码具有完整的移植性，则不应该分配大于128KB的内存。如果希望得到多于几千字节的内存，则最好使用除kmalloc
   之外的内存获取方法。
}

kmalloc(flags)
{
1. 分配给哪些机制使用
2. 从哪些区域获取内存
3. 内存分配优先级和尝试
------ flags: ------
GFP_KERNEL: 内存分配是代表运行在内核空间的进程执行的。最终总是调用get_free_pages来实现实际的分配，这是GFP的由来。
            这意味着调用它的函数正代表某个进程执行系统调用。    ------ 进程上下文
            kmalloc所在函数必须是可重入的，
            当前进程休眠时，内核会采取适当行动，或者是把缓冲区的内容刷写到硬盘上，或者是从用户进程换出内存，以获取一个内存页面。

GFP_ATOMIC: 中断上下文或其他运行于进程上下文之外的代码中分配内存，不会休眠
            中断处理例程、tasklet、内核定时器中。
            内核通常会给原子性的分配预留一些空闲页面。
            
GFP_KERNEL：内核内存的通常分配方法，可能引起休眠
GFP_USER:   用于为用户空间分配内存，可能会休眠
GFP_HIGHUSER:类似GFP_USER，不过如果有高端内存的话会从哪里分配。
GFP_NOIO:   
GFP_NOFS:   类似于GFP_KERNEL,但是内核分配内存的工作方式添加了一些限制。具有GFP_NOFS分配不允许执行任何文件系统调用
            GFP_NOIO禁止任何IO的初始化。
            这两个标志主要在文件系统和虚拟内存代码中使用，这些代码中的内存分配可以休眠，但不应该发生递归的文件系统调用。

__GPF_DMA     请求分配发生在可进行DMA的内存段中
__GPF_HIGHMEM 要分配的内存可位于高端内存
__GPF_COLD    通常，内存分配器会使图返回"缓存热"页面，即可在处理缓存中找到的页面。相反。这个标志请求尚未使用的"冷"页面。
              对用于DMA读取的页面分配，可以使用这个标志。因为这种情况下，页面存在于处理器缓存中没有多个帮助。
              
__GPF_NOWARN  可以避免内核在无法满足分配请求时产生告警
__GPF_HIGH    高优先级的请求，它允许为紧急状况而消耗由内核保留的最后一些页面
__GPF_REPEAT  努力在尝试一次，它会重新尝试分配，但仍有可能失败。
__GPF_NOFAIL  告诉分配器始终不返回失败，它会努力满足分配请求
__GPF_NORETRT 请求的内存不可获得，就立即返回。
         
__GPF_DMA和__GPF_HIGHMEM的使用与平台相关，尽管在所有平台上都可以使用这两个标志。

每种计算平台都必须知道如何把自己特定的内存范围归类到这三个区段中，而不是认为所有RAM都一样的。

1. 可用DMA的内存  存在于DMA的内存指存在于特别地址范围的内存，外设可以利用这些内存执行DMA访问。
                  在大多数健全的系统上，所有内存都位于这一区段。
                  x86平台，DMA区段是RAM的前16M，老式的ISA设备可以该区段上执行DMA；
                  PCI设备则无此限制。
2. 常规内存       
3. 高端内存       32位平台为了访问大量的内存而存在的一种机制。如果不首先完成一些特殊的映射，我们就无法从内核中直接访问这些内存。
                  因此通常较难处理。
                  如果驱动程序要使用大量的内存，那么在能够使用高端内存的大系统上可以工作的更好。
                  
__GPF_DMA：只是用低16M内存；
没有指定特定的标志：常规区段和DMA区段都被所搜索。
__GPF_HIGHMEM所有三个内存区段都会被请求。

内核负责管理系统物理内存，物理内存只能按页面进行分配。 

内存区段的背后机制在mm/page_alloc.c中实现，区段的初始化是平台相关的，通常对应的arch树下的mm/init.c中。   
}


slab(后备高速缓存)
{
设备驱动程序通常不会涉及这种使用后备高速缓存的内存行为。也有例外：USB和SCSI驱动程序。


------ 后备高速缓存 ------ /proc/slabinfo -- scullc
linux/slab.h

struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,  // 初始化
            unsigned long,
            void (*)(void *));
size：区域的大小。
name：关联这个高速缓存；静态名字。保管一些信息一边跟踪问题。
      高速缓存保留指向该名称的指针，而不是复制其内容，因此，驱动程序应该将指向静态存储的指针传递给这个函数。
      名称不能包含空白。
offset: 页面中第一个对象的偏移量。它可以用来确保对已分配的对象进行某种特殊对齐，但是最常用的就是0.表示使用默认值。

flags：控制如何分配
SLAB_NO_REAP: 保护高速缓存在系统寻找内存的时候不会被减少。
SLAB_HWCACHE_ALIGN：所有数据对象跟高速缓存行对齐；实际的操作依赖于主机平台的硬件高速缓存布局。---可能浪费大量内存
                    如果在SMP机器上，高速缓存中包含有频繁访问的数据项的话，则该选项是非常好的选择。
SLAB_CACHE_DMA：每个数据对象都从可用于DMA的内存段中分配。

constructor：这些内存中可能会包含好几个对象，所以constructor可能会被多次调用
             我们不能认为分配一个对象之后随之就会调用一次constructor
destructor： 可能不是在一个对象释放后就立即被调用，而是在将来对某个时间才被调用。
             

void *kmem_cache_alloc(struct kmem_cache *, gfp_t);                 // 分配
void kmem_cache_free(struct kmem_cache *, void *);                  // 释放
void kmem_cache_destroy(struct kmem_cache *);                       // 注销


}

mempool(容易浪费内存的内存池)
{
内存池很容易浪费大量内存。

内核中有些地方的内存分配不允许失败的。为了确保这些情况下的成功分配，内核开发者建立了一种称为内存池的抽象。
内存池其实就是某种形式的后被高速缓存，他试图始终保持空闲的内存，以便在紧急状态下使用。

------ 内存池 ------ 
linux/mempool.h

回调函数
typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);  // malloc
typedef void (mempool_free_t)(void *element, void *pool_data);      // free
实例：mempool_alloc_slab和mempool_free_slab                     分配和释放函数实例
      kmem_cache_alloc  和kmem_cache_free                       分配和释放函数实例调用这两个函数进行内存管理。
回调函数实例
void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data);          // malloc 推荐函数
void mempool_free_slab(void *element, void *pool_data);             // free   推荐函数

初始化函数
mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn, // 初始化
    mempool_free_t *free_fn, void *pool_data);
min_nr：内存池应始终保持的已分配对象的最少数目。对象的实际分配和释放由alloc_fn和free_fn函数处理。
pool_data，被传入alloc_fn和free_fn
内存申请和释放
void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask);          // 分配
void mempool_free(void *element, mempool_t *pool);              // 释放

内存池管理
int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask); // 调整缓存大小
内存池释放
void mempool_destroy(mempool_t *pool); //释放
在销毁mempool之前，必须将所有已分配的对象返回到内存池中，否则会导致内核oops.

}     

get_free_page(kmalloc底层函数)
{
只要符合和kmalloc同样的规则，get_free_pages和其他函数可以在任何时间调用。某些情况下函数分配内存会失败，
特别是在使用了GFP_ATOMIC的时候，因此，调用了这些函数的程序在分配出错时都应提供响应处理。

------ get_free_page和相关函数 ------ /proc/buddyinfo scullp
get_zerod_page(unsigned int flags)  指向新页面的指针并将页面清零
__get_free_page(unsigned int flags) 指向新页面的指针但不清零页面
__get_free_pages(unsigned int flags, unsigned int order) 分配若干个页面，但不清零页面
order:介数，0表示1个页面，1表示2个页面，2表示4个页面。如果order很大又没有那么大连续区域可以分配，就返回失败。

buddyinfo告诉系统中每个内存区段上每个阶数下可获得的数据数目
void free_page(uisigned long addr)
void free_pages(unsigned long addr, unsigned long order);
只要符合和kmalloc一样的规则，get_free_pages和其他函数可以在任何时间调用。 某些时候会失败。


}

alloc_pages(页大小管理)
{

struct page是内核用来描述单个内存页的数据结构。

------ alloc_pages ------ 
struct page 内核用来描述单个内存页的数据结构

struct page *alloc_pages_node(int nid, gfp_t gfp_mask,  // Linux页分配器的核心代码
                        unsigned int order)
nid为NUMA节点的ID，表示要在其中分配内存空间
flags是通常的GFP_分配标志
order是要分配的内存大小。

struct page *alloc_pages(gfp_t gfp_mask, unsigned int order) //alloc_pages_node变种
struct page *alloc_page(gfp_t gfp_mask)                      //alloc_pages_node变种


#define __free_page(page) __free_pages((page), 0)
#define free_page(addr) free_pages((addr), 0)

void __free_page(struct page *page);
void __free_pages(struct page *page, unsigned int order);
void free_hot_page(struct page *page);
void free_cold_page(struct page *page);
如果读者知道某个页面中的内容是否驻留在处理器高速缓存中，则应该使用free_hot_page(用于驻留在高速缓存中的页)；
或者free_cold_page和内核通信。

}

vmalloc(虚拟地址连续)
{
vmalloc是Linux内存分配机制的基础。


kmalloc和__get_free_pages返回的内存地址也是虚拟地址，其实际值仍然要由MMU处理才能转为物理内存地址，
vmalloc在如何使用硬件上没有区别，区别在于内核如何执行分配任务上。
kmalloc和__get_free_pages使用的虚拟地址范围与物理地址内存是一一对应的，可能会有基于常量PAGE_OFFSET的一个偏移量。这两个
函数不需要为该地址段修改页表，但另一方面，vmalloc和ioremap使用的地址范围完全是虚拟的，每次分配都要通过对页表的适当
设置来建立虚拟内存区域。

vmalloc开销比__get_free_pages大，因为它不但获取内存，还要建立页表。
因此使用vmalloc分配仅仅一页的内存空间是不值得的。

vmalloc不能在原子上下文中调用。

------ vmalloc及其辅助函数 ------  scullv /proc/ksyms 需要页表映射  create_module
分配虚拟地址空间的连续区域。尽管这段区域在物理上可能不是连续的内核却认为他们在地址上是连续的。
vmalloc是Linux内存分配机制的基础。这种方法内存使用起来效率不高。获取内存和建立页表。

void *vmalloc(unsigned long size)
void vfree(const void *addr)
kmalloc和get_free_pages返回的内存地址也是虚拟地址，其实际值仍然要用到MMU处理才能转换为物理内存地址。
kmalloc和get_free_pages使用的虚拟地址范围与物理内存是一一对应的，可能会有基于常量PAGE_OFFSET的一个偏移。这两个函数不需要为该地址段修改页表。

vmalloc在如何使用硬件上没有区别，区别在于内核如何执行分配任务上。
vmalloc和ioremap使用的地址范围完全是虚拟的，每次分配都要通过页表的设定设置来建立内存区域。

VMALLOC_START~VMALLOC_END范围中。

用vmalloc分配得到的地址是不能在微处理器之外使用的，因为他们只在处理的内存管理单元上才有意义。
当驱动程序需要真正的物理内存的时候，就不能使用vmalloc分配。


}

ioremap(建立页表但不分配内存)
{
ioremap建立新的页表，ioremap并不实际分配内存。
ioremap的返回值是一个特殊的虚拟底子好，可以用来访问指定的物理内存区域，这个虚拟地址最后要调用iounmap来释放。
ioremap多用于映射(物理的)PCI缓冲区地址到(虚拟的)内核空间。

ioremap和vmalloc函数都是面向页，因此重新定位或分配的内存空间实际上都会上调到最近的一个页边界。
ioremap通过重新映射的地址向下下调到页边界。不能直接把PCI内存区映射到处理的地址空间。

ioremap用来把physical memory映射到kernel virtual address space，常用于把设备的I/O memory address映射到
kernel virtual address space。
}

 per_CPU(处理器私有数据)
 {
 ------ per-CPU ------  
当建立一个per-CPU变量是，系统中的每个处理器都会用该变量的副本。优点
对per-CPU变量的访问几乎不需要锁定，因为每个处理器在其自己的副本上工作。
per-CPU变量还可以保存在对应处理器的高速缓冲中。，这样，就可以在频繁更新时获得更好的性能。

网络子系统：

linux/percpu.h
DEFINE_PER_CPU(type, name);
DECLARE_PER_CPU(type, name);
定义和声明per-CPU变量的宏

per_cpu(variable, int cpu_id);
get_cpu_var(variable);
put_cpu_var(variable);
用于访问静态声明的per-CPU变量的宏

void *alloc_percpu(type);
void *__alloc_percpu(size_t size, size_t align);
void free_percpu(void *variable);
执行per-CPU变量的运行时分配和释放的函数

int get_cpu();
void put_cpu();
per_cpu_ptr(void *variable, int cpu_id);
get_cpu获得当前处理器的引用并返回处理的ID号；
put_cpu返回该引用。
为了访问动态分配的per-CPU变量，应使用per_cpu_ptr，并传递要访问的变量版本的CPU ID号。对某个动态的per-CPU变量
的当前CPU版本的操作，应该包含在对get_cpu和put_cpu的调用中间。

/linux/percpu.h

------ 在引导时获取专用缓冲区 ------ 最大尺寸 & 固定颗粒
linux/bootmem.h 绕过了buddyinfo系统。

}

bootmem()
{
    如果的确需要连续的大块内存用作缓冲区，就最好在系统引导期间通过请求内存来分配，在引导时就进行分配是获得大量
；连续内存也免得唯一方法，他绕过了__get_free_pages函数在缓冲区大小上的尺寸和固定粒度的双重限制。在引导时分配缓冲区
有点"脏"，因为它通过保留私有内存池而跳过了内核的内存管理策略。这种技术比较粗暴也很不灵活。但是也是很不容易失败的。
显然，模块不能在引导时分配内存，而只有直接连接到内核的设备驱动程序才能在引导时分配内存。

    还有一个值得注意的问题是：对于普通用户来说引导时的分配不是一个切实可用的选项，因为这种机制支队连接到内核镜像
中的代码可用。要安装或替换使用了这种分配技术的驱动程序，就只能重新编译内核并重启计算机了。

    内核被引导时，他可以访问系统所有的物理内存，然后调用各个子系统的初始化函数进行初始化，它允许初始化代码分配私有
的缓冲区，同时减少了留给常规系统操作的RAM数量。

alloc_bootmem(x)
alloc_bootmem_low(x)
alloc_bootmem_pages(x)
alloc_bootmem_low_pages(x)
要么分配整个页(若以pages结尾)，要么分配不在页面边界上对齐的内存区。
除非使用具有_low后缀的版本，否则分配的内存可能会使高端内存。

extern void free_bootmem(unsigned long addr, unsigned long size);
通过上述函数释放的部分页面不会返还给系统，但是，如果我们使用这种技术，则其实应经分配得到了一些完整的页面。

}



