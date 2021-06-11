menory_space()
{
1. 用户虚拟内存：这是在用户空间程序所能看到的常规地址。用户地址或者是32位的，或者是64位的，这取决于硬件的体系结构。每个进程
                 都有自己的虚拟地址空间。
2. 物理地址：   该地址在处理器和系统内存之间使用。物理内存也可以是32位或者64位长的，着某些情况下甚至32位系统也能使用63位的
                 物理内存
3. 总线地址：    该地址在外围总线和内存之间使用。通常它们与处理器使用的物理地址相同，但是这么做并不是必须的。一些计算机体系
                 架构提供了IO内存管理单元，它实现总线和主内存之间的重新映射。IOMMU可以用很多种方式让事情变得简单(比如使用内存
                 中的分散缓冲区对设备来说是连续的)，但是当设置DMA操作时，编写IOMMU相关的代码是一个必须的额外步骤。当然总线地址
                是与体系架构密切相关的。
4. 内核逻辑地址：内核逻辑地址组成了内核的常规地址空间。该地址映射了部分(或者全部)内存并经常视为物理内存。在大多数体系架构中，逻辑地址
               和其他相关的物理地址的不同，仅仅是在它们之间存在一个固定的偏移量。
5. 内核虚拟地址：内核虚拟地址和逻辑地址的相同之处在于，它们都将内核空间的地址映射到物理地址上。内核虚拟地址和物理地址的映射不必
               是线性的和一对一的，而这是逻辑地址空间的特点。所有的逻辑地址都是内核虚拟地址，但是许多内核地址不是逻辑地址。

               
}

page()
{
宏__pa()返回逻辑地址对应的物理地址
    将虚拟地址转换为物理地址。对于32位系统来说，其物理地址是从x中减去PAGE_OFFSET。
宏__va()也能将物理地址逆向映射到逻辑地址
    将物理地址转换为虚拟地址。对于32位系统来说，给定一个物理地址x，其虚拟地址为x+PAGE_OFFSET。
 
内核无法直接操作没有映射到内核地址空间的内存，换句话说，内核对任何内存的访问，都需要使用自己的虚拟地址。

高端内存：存在于内核空间上的逻辑地址内存，几乎所有现有读者遇到的系统，他全部的内存都是低端内存。
高端内存：是指那些不存在逻辑地址的内存，这是因为他们处于虚拟地址之上。

由于历史的关系，内核使用逻辑地址来引用物理内存中的页，然而由于支持了高端内存就暴露出一个明显的问题----在高端内存中将无法使用
逻辑地址。因此内核中处理内存的函数趋向使用page结构的指针。该数据结构用来保留内核需要知道的所有物理内存的信息。
对系统中的每个物理页，都有一个page结构向对应。

mem_map是一个数组，page是一个指针，所以这里的操作是两个指针相减，所以得到的结果是page在mem_map数组中的索引
 
struct page *page;
unsigned long flags:flags存储了体系结构无关的标志，用于描述页的属性。各个标志由page-flags.h中的宏定义的。参见PG_locked.
atomic_t _count;_count是一个使用计数，表示内核中引用该页的次数。在其值到达0时，内核就知道page实例当前不适用，因此可以删除。
                如果其值大于0，该实例绝不会从内存删除。
void *virtual;virtual用于高端内存区域中的页，换言之，即无法直接映射到内核内存中的页。virtual用于存储该页的虚拟地址。
              virtual成员只在摩托罗拉m68k、FRV和Extensa这几个体系结构下有定义。所有其他体系结构都采用了一种不同的
              方案来寻址虚拟内存页。其核心是用来查找所有高端内存页帧的散列表。

将虚拟地址转换为指向struct page的指针。
#define virt_to_page(kaddr) pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
针对给定的页帧号，返回page结构指针。
#define __pfn_to_page(pfn)  (mem_map + ((pfn) - ARCH_PFN_OFFSET))
获取指定的物理页面对应的虚拟地址
#define page_address(page) lowmem_page_address(page)

映射的数量是有限的，因此不要持有映射过长的时间。
void *kmap(struct page *page) 为系统中的页返回内核虚拟地址。对于低端内存页来说，他只返回的逻辑地址；
                              对于高端内存，kmap在专用的内核地址空间创建特殊的映射。
void kunmap(struct page *page) 释放

void *kmap_atomic(struct page *page, enum km_type type) 
                 
void kunmap_atomic(void *page, enum km_type type)
}

一个进程包含多个虚拟内存区；一个虚拟内存区具有很多属性。
maps(虚拟内存区)
{
虚拟内存区
虚拟内存区用于管理进程地址空间中不同区域的内核数据结构。一个VMA表示在进程的虚拟内存中的一个同类区域；
拥有同样权限标识位和被同样对象(一个文件或者交换空间)备份的一个连续的虚拟内存地址范围。

虚拟内存区符合更宽泛的段的概念，但是把其描述成"拥有自身属性的内存对象"更为贴切。进程的内存映射至少
包含下这些区域：
1. 程序的可执行代码区域
2. 多数数据区，其中包含初始化数据(在开始执行的时候就拥有明确的值)、非初始化数据BBS及程序堆栈
3. 与每个活动的内存映射对应的区域。

start    end      perm   offset major:minor inode image
40003000-40009000 r-xp 00000000 b3:02       418   /lib/libnss_compat-2.8.so
40009000-40010000 ---p 00006000 b3:02       418   /lib/libnss_compat-2.8.so
40010000-40011000 r-xp 00005000 b3:02       418   /lib/libnss_compat-2.8.so
40011000-40012000 rwxp 00006000 b3:02       418   /lib/libnss_compat-2.8.so
rwx[p|s]: p私有的，s共享的；

vm_area_struct(用于管理用户空间进程的虚拟地址空间内容--mmap对应内核结构)
{
1. 用于管理用户空间进程的虚拟地址空间内容
2. 当用户空间程序进程调用mmap，将设备内存映射到它的地址空间时，系统通过创建一个表示该映射的新VMA作为响应。
3. 支持mmap的驱动程序需要帮助进程完成VMA的初始化。因此驱动程序作者为了能支持mmap，需要对VMA有所了解。

vm_mm是一个反向指针，指向该区域所属的mm_struct实例。
struct mm_struct * vm_mm;

vm_start和vm_end指定了该区域在用户空间中的起始和结束地址。
unsigned long vm_start;
unsigned long vm_end;

进程所有vm_area_struct实例的链表是通过vm_next实现的，而与红黑树的继承则通过vm_rb实现
struct vm_area_struct *vm_next;

存储该区域的访问权限
pgprot_t vm_page_prot;

可取的值为VM_READ等；驱动程序员最感兴趣的标志时VM_IO和VM_RESERVED.
VM_IO将VMA设置成一个内存映射IO区域。VM_IO会阻止系统将该区域包含在进程的核心转存中。
VM_RESERVED告诉内存管理系统不要将该VMA交换出去，大多数设备映射中都设置该标志。

unsigned long vm_flags;

struct rb_node vm_rb;
4. 为优化查找方法，内核维护了VMA的链表和属性结构，而vm_area_struct中的许多成员都是用来维护这个结构的。

从文件到进程的虚拟地址空间中的映射，可通过文件中的区间和内存中对应的区间唯一地确定。为跟踪与进程关联的所有区间，内核使用了
链表和红黑树。但还必须能够反向查询:给出文件中的一个区间，内核有时需要知道该区间映射到的所有进程。这种映射称作共享映射。
为提供所需的信息，所有的vm_area_struct实例都还通过一个优先树管理，包含在shared成员中。
	union {
		struct {
			struct list_head list;
			void *parent;	/* aligns with prio_tree_node parent */
			struct vm_area_struct *head;
		} vm_set;

		struct raw_prio_tree_node prio_tree_node;
	} shared;
    
    
  anon_vma_node和anon_vma用于管理源自匿名映射的共享页。指向相同页的映射都保存在一个双链表上，anon_vma_node充当链表元素。   
  有若干此类链表，具体的数目取决于共享物理内存页的映射集合的数目。anon_vma成员是一个指向与各链表关联的管理结构的指针，   
  该管理结构由一个表头和相关的锁组成。   
    struct list_head anon_vma_node;
    struct anon_vma *anon_vma;
    
    const struct vm_operations_struct *vm_ops;
    
    vm_pgoff指定了文件映射的偏移量，该值用于只映射了文件部分内容时(如果映射了整个文件，则偏移量为0).偏移量的单位不是字节，
而是页(即PAGE_SIZE在页长度为4K的系统上，偏移量值为10，折合实际的字节偏移量为40960.这是合理的，因为内核只支持以整页为
单位的映射，更小的值没有意义。
    unsigned long vm_pgoff;
    
    vm_file指向与该区域(如果存在的话)相关联的file实例，描述了一个被映射的文件(如果映射的对象不是文件，
    则为NULL指针)。
    struct file * vm_file;

    取决于映射类型，vm_private_data可用于存储私有数据，不由通用内存管理例程操作。内核只确保在创建新区域时该成员初始化
为NULL指针。目前，只有少数声音和视频驱动程序使用了该选项。
void * vm_private_data;
unsigned long vm_truncate_count;


}  

vm_operations_struct()
{
在创建和删除区域时，分别调用open和close。这两个接口通常不使用，设置为NULL指针。
void (*open)(struct vm_area_struct * area);
void (*close)(struct vm_area_struct * area);
1. 内核调用open函数，以允许实现VMA的子系统初始化该区域。当对VMA产生一个新的引用时(比如fork程序时)，则调用这个函数。
   唯一的例外发生在mmap第一次创建VMA时，在这种情况下，需要调用驱动程序的mmap方法。
2. 当销毁一个区域时，内核将调用close操作。请注意由于VMA没有使用相应的计数，所以每个使用区域的进程都只能打开和关闭它一次。
   
fault非常重要。如果地址空间中的某个虚拟内存页不在物理内存中，自动触发的缺页异常处理程序会调用该函数，将对应的数据读取到一个
映射在用户地址空间的物理内存页中。大多数文件都使用filemap_fault()。
int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);

}

1. 多个进程可以共享相同的虚拟内存，如libc库代码段和共享内存，实质上是vm_area_struct实例的共享。
2. 多个线程可以共享内存管理结构，Linux的pthread线程就是这样实现的，实质上是mm_struct实例的共享。
映射共享：
1. 两个进程映射了一个文件的同一个区域时他们会共享物理内存的相同分页。
2. 通过fork创建的子进程会继承其父进程的映射的副本，并且这些映射所引用的物理内存分页与父进程
   中相应映射所引用的分页相同。

mm_struct(虚拟内存区域Virtual Memory Area列表)
{
最后一个内存管理难题是处理内存映射结构，他负责整合所有其他是数据结构。在系统中的每个进程(除了内核空间
的一些辅助线程外)都拥有一个struct mm_struct结构，其中包含了虚拟内存区域链表、页表以及其他大量内存管理
信息，还包含了信号灯和一个自旋锁。在task结构中能找到该结构的指针。

在很少情况下当驱动程序需要访问它时，常用的办法是使用current->mm。请注意，多个进程可以共享内存管理结构，
Linux就是用这种方式实现线程的。


}
MAP_SHARED，MAP_PRIVATE：文件和匿名
在调用进程的虚拟地址空间中创建一个新内存映射。映射分为两种：
文件映射、匿名映射。
私有文件映射：使用一个文件的内容来初始化一块内存区域。
私有匿名映射：在分配大块内存时malloc会为此而使用mmap
共享文件映射：允许内存映射IO，表示一个文件会被加载到进程的虚拟内存中的一个区域中，并且对该块内容的变更会自动
              被写入到这个文件中，因此，内存映射IO为使用read和write来执行文件IO这种做法提供一种替代方案。
共享匿名映射：允许以一种类似于System V共享内存段的方式来进行IPC，但只有相关进程之间才能这么做。

mmap优点：
1. 使用read()或write()系统调用时，需要从用户缓冲区进行数据读写，而使用映射文件进行操作，可以避免多余的数据拷贝操作。
2. 处理可能潜在页错误，读写映射文件不会带来系统调用和上下文切换的开销，他就像直接操作内存一样简单。
3. 当多个进程把同一个对象映射到内存中时，数据会在所有进程间共享。只读和写共享的映射在全体中都是共享的；私有可写的映射
   对尚未进行写时拷贝的页是共享的。
4. 在映射对象中搜索只需要很简单的指针操作，不需要使用系统调用lseek().

mmap不足：
1. 由于映射区域的大小总是页大小的整数倍，因此，文件大小与页大小的整数倍之间有空间浪费。对于小文件，空间浪费会被较严重。
2. 存储映射区域必须在进程地址空间内。对于32位的地址空间，大量的大小不同的映射会导致生成大量的碎片，是的很难找到连续的
   大片空内存。当然，这个问题在64位地址空间就不是很明显。
3. 创建和维护映射以及相关的内核数据结构有一定的开销。不过，如上节所述，由于mmap()消除了读写时不必要的拷贝，这种开销
   几乎可以忽略，对大文件和频繁访问的文件更是如此。




mmap(用户程序直接访问内存的能力)
{
    在现代Unix系统中，内存映射是最吸引人的特征，对于驱动程序来说，内存映射可以提供给用户程序直接访问设备
内存的能力。
    映射一个设备意味着将用户空间的一段内存与设备内存关联起来。无论何时当程序在分配的地址范围内读写时，
实际上访问的就是设备。在X服务器例子中，使用mmap就能迅速而便捷地访问显卡内存。
    性能要求苛刻的应用程序，直接访问内存明显提升性能。X服务器负责和显存间读写大量数据；与使用lseek/write相比，
将图形显示映射到用户空间极大地提高了吞吐量；大多数PCI外围设备将它们的控制寄存器映射到内存地址中，高性能的应用
程序更愿意直接访问寄存器，而不是不停的调用ioctl去获取需要的信息。
    
    必须以PAGE_SIZE为单位进行映射。所以串口和其他面向流的设备就不能这样的抽象。
    内核只能在页表一级对虚拟内存地址进行管理，因此那些被映射的区域必须是PAGE_SIZE的整数倍，并且在物理内存中的
起始地址也要求是PAGE_SIZE的整数倍。如果区域的大小不是页的整数倍，则内核强制指定比区域稍大一点的尺寸作为映射
的粒度。

Xorg: proc/Xorg/maps
/dev/mem
/proc/iomem : Video
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ce3ff : Video ROM
000ce800-000cf7ff : Adapter ROM
000d0000-000d3fff : PCI Bus 0000:00

mmap(caddr_t addr, size_t len, int prot, int flags, int fd, off_t offset)
int (*mmap)(struct file *filp, struct vm_area_struct *vma);
为了执行mmap，驱动程序只需要为该地址范围建立合适的页表，并将vm->vm_ops替换为一系列的新操作就可以了。





建立页表：使用remap_pfn_range函数一次全部建立；
          使用nopage VMA方法每次建立一个页表。
int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
            unsigned long pfn, unsigned long size, pgprot_t prot)
vma 虚拟内存区域，在一定范围的也将被映射到该区域中
virt_addr 重新映射时的起始用户虚拟地址，该地址为处于virt_addr和virt_addr+size之间的虚拟地址建立页表
pfn 与物理内存对应的页帧号，虚拟内存将要被映射到该物理内存上。页帧号只是将物理地址右移PAGE_SIZE位。在多数
情况下，VMA结构中的vm_pgoff成员包含了用户需要的值。该函数对位于(#pfn<<PAGE_SHIFT)到(#pfn<<PAGE_SHIFT)+size
之间的物理地址有效。
size 以字节为单位，被重新映射的区域大小
prot 新VMA要求的保护属性。驱动程序能够使用vma->vm_page_count中的值。

如果要支持mremap系统调用，就必须实现nopage函数。
strtuct page *(*nopage)(struct vm_area_struct *vma, unsigned long address, int *type);
    
}

html(http://www.cnblogs.com/hanyan225/archive/2010/10/27/1862171.html){}
在内核生成一个VMA后，它就会调用该VMA的open()函数。
  而驱动中的mmap()函数将在用户进行mmap()系统调用时最终被调用，当用户调用mmap()时候内核会进行如下处理：
  1)在进程的虚拟空间查找一块VMA.
  2)将这块VMA进行映射。
  3)如果设备驱动程序或文件系统的file_operations定义了mmap()操作，则调用它。
  4)将这个VMA插入到进程的VMA链表中。

file_operations中mmap()函数的第一个参数就是步骤1中找的VMA.由mmap()系统调用映射的内存可由munmap()解除映射。这个函数原型如下：
int munmap(caddr_t addr, size_t len);

  但是，需要注意的是：当用户进行mmap()系统调用后，尽管VMA在设备驱动文件操作结构体的mmap()被调用前就已经产生，内核却不会调用VMA的open
函数，通常需要在驱动的mmap()函数中先上调用vma->vm_ops->open().为了说明问题，给出一个vm_operations_struct操作范例：
static int xxx_mmp(struct file *filp, struct vm_area_struct *vma)
{
    if(remap_pfn_range(vma, vma->vm_start, vm->vm_pgoff, vma->vm_end - vma->start, vma->vm_page_prot))   //建立页表
     return - EAGAIN;
    vma->vm_ops = &xxx_remap_vm_ops;
    xxx_vma_open(vma);
    return 0;
}
void xxx_vma_open(struct vm_area_struct *vma) //VMA打开函数
{
  ...
  printk(KERN_NOTICE "xxx VMA open, virt %lx, phys %1x\n",vma->vm_start, vma->vm_pgoff 《PAGE_SHIFT);
}
void xxx_vma_close(struct vm_area_struct *vma)  //VMA关闭函数
{
  ...
  printk(KERN_NOTICE "xxx VMA close. \n");
}
static struct vm_operation_struct xxx_remap_vm_ops = //VM操作结构体
{
   .open=xxx_vma_open,
   .close=xxx_vma_close,
   ...
}

在这段代码中调用的remap_pfn_range()创建页表。我们前边说过在内核空间用kmalloc申请内存，这部分内存如果要映射到用户空间可以通过mem_map
_reserve()调用设置为保留后进行，具体怎么操作，咱们下集继续。


上节讲到kmalloc()申请的内存若要被映射到用户空间可以通过mem_map_reserve()设置为保留后进行。具体怎么操作呢，给你一个模版吧：

// 内核模块加载函数
int __init kmalloc_map_init(void)
{
    ../申请设备号，添加cedv结构体
  buffer = kmalloc(BUF_SIZE, GFP_KERNEL); //申请buffer
  for(page = virt_to_page(buffer); page< virt_to_page(buffer+BUF_SIZE); page++)
  {
     mem_map_reserve(page);  //置业为保留
  }
}
//mmap()函数
static int kmalloc_map_mmap(struct file *filp, struct vm_area_struct *vma)
{
    unsigned long page, pos;
    unsigned long start = (unsigned long)vma->start;
    unsigned long size = (unsigned long)(vma->end - vma->start);
    printk(KERN_INFO, "mmaptest_mmap called\n");
    if(size > BUF_SIZE)  //用户要映射的区域太大
        return - EINVAL;
    pos = (unsigned long)buffer;
    while(size > 0)   //映射buffer中的所有页
    {
        page = virt_to_phys((void *)pos);
        if(remap_page_range(start, page, PAGE_SIZE, PAGE_SHARRED))
            return -EAGAIN;
        start += PAGE_SIZE;
        pos +=PAGE_SIZE;
        size -= PAGE_SIZE;
    }
    return 0;
}

另外通常，IO内存被映射时需要是nocache的，这个时候应该对vma->vm_page_prot设置nocache标志。如下：

static int xxx_nocache_mmap(struct file *filp, struct vm_area_struct *vma)
{
  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);   //赋nocache标志
  vma->vm_pgoff = ((u32)map_start >> PAGE_SHIFT);
  if(rempa_pfn_range(vma, vma->vm_start, vma->vm_pgoff, vma->vm_end - vm_start, vma->vm_page_prot));
     return - EAGGIN;
  return 0;
}

这段代码中的pgprot_noncached()是一个宏，它实际上禁止了相关页的cache和写缓冲(write buffer),另外一个稍微少的一些限制的宏是：

#define pgprot_writecombine(prot)  __pgprot(pgprot_val (prot) & –L_PTE_CACHEABLE);    它则没有禁止写缓冲

而除了rempa_pfn_range()外，在驱动程序中实现VMA的nopage()函数通常可以为设备提供更加灵活的内存映射途径。当发生缺页时，nopage()会被内核自动调用，。这是因为,当发生缺页异常时，系统会经过如下处理过程：

1)找到缺页的虚拟地址所在的VMA             2)如果必要，分配中间页目录表和页表              

3)如果页表项对应的物理页表不存在，则调用这个VMA的nopage()方法，它返回物理页面的页描述符。

4)将物理页面的地址填充到页表中。

实现nopage后，用户空间可以通过mremap()系统调用重新绑定映射区所绑定的地址，下面给出一个在设备驱动中使用nopage()的典型范例：

static int xxx_mmap(struct file *filp, struct vm_area_struct *vma);
{
     unsigned long offset = vma->vm_pgoff << PAGE_OFFSET;
     if(offset >= _ _pa(high_memory) || (filp->flags &O_SYNC))
             vma->vm_flags |=VM_IO;
     vma->vm_ops = &xxx_nopage_vm_ops;
     xxx_vma_open(vma);
     return 0;
}
struct page *xxx_vma_nopage(struct vm_area_struct *vma, unsigned long address, int *type)
{
   struct page *pageptr;
   unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
   unsigned long physaddr = address - vma->vm_start + offset;   //物理内存
   unsigned long pageframe = physaddr >> PAGE_SHIFT;  //页帧号
   if(!pfn_valid(pageframe))   //页帧号有效
      return NOPAGE_SIGBUS;
   pageptr = pfn_to_page(pageframe);    //页帧号->页描述符
   get_page(pageptr);   //获得页，增加页的使用计数
   if(type)
      *type = VM_FAULT_MINOR;
   return pageptr;    //返回页描述符

}

上述函数对常规内存进行映射，返回一个页描述符，可用于扩大或缩小映射的内存区域，由此可见，nopage()和remap_pfn_range()一个较大的区别在于remap_pfn

_range()一般用于设备内存映射，而nopage()还可以用于RAM映射。