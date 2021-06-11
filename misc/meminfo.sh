
log()
{
MemTotal: 507480 kB
MemFree: 10800 kB
Buffers: 34728 kB
Cached: 98852 kB
SwapCached: 128 kB
Active: 304248 kB
Inactive: 46192 kB
HighTotal: 0 kB
HighFree: 0 kB
LowTotal: 507480 kB
LowFree: 10800 kB
SwapTotal: 979956 kB
SwapFree: 941296 kB
Dirty: 32 kB
Writeback: 0 kB
AnonPages: 216756 kB
Mapped: 77560 kB
Slab: 22952 kB
SReclaimable: 15512 kB
SUnreclaim: 7440 kB
PageTables: 2640 kB
NFS_Unstable: 0 kB
Bounce: 0 kB
CommitLimit: 1233696 kB
Committed_AS: 828508 kB
VmallocTotal: 516088 kB
VmallocUsed: 5032 kB
VmallocChunk: 510580 kB
}

desc()
{
MemTotal: 所有可用RAM大小 （即物理内存减去一些预留位和内核的二进制代码大小）

MemFree: LowFree与HighFree的总和，被系统留着未使用的内存

Buffers: 用来给文件做缓冲大小

Cached: 被高速缓冲存储器（cache memory）用的内存的大小（等于 diskcache minus SwapCache ）.

SwapCached:被高速缓冲存储器（cache memory）用的交换空间的大小已经
被交换出来的内存，但仍然被存放在swapfile中。用来在需要的时候很快的
被替换而不需要再次打开I/O端口。

Active: 在活跃使用中的缓冲或高速缓冲存储器页面文件的大小，除非非常必要否则不会被移作他用.

Inactive: 在不经常使用中的缓冲或高速缓冲存储器页面文件的大小，可能被用于其他途径.

HighTotal:
HighFree: 该区域不是直接映射到内核空间。内核必须使用不同的手法使用该段内存。

LowTotal:
LowFree: 低位可以达到高位内存一样的作用，而且它还能够被内核用来记录
一些自己的数据结构。Among many other things, it is where
everything from the Slab is allocated.  Bad things happen
when you’re out of lowmem.

SwapTotal: 交换空间的总大小

SwapFree: 未被使用交换空间的大小

Dirty: 等待被写回到磁盘的内存大小。

Writeback: 正在被写回到磁盘的内存大小。

AnonPages：未映射页的内存大小

Mapped: 设备和文件等映射的大小。

Slab: 内核数据结构缓存的大小，可以减少申请和释放内存带来的消耗。

SReclaimable:可收回Slab的大小

SUnreclaim：不可收回Slab的大小（SUnreclaim+SReclaimable＝Slab）

PageTables：管理内存分页页面的索引表的大小。

NFS_Unstable:不稳定页表的大小

VmallocTotal: 可以vmalloc虚拟内存大小

VmallocUsed: 已经被使用的虚拟内存大小。

VmallocChunk: largest contigious block of vmalloc area which is free
}

sysinfo()
{
struct sysinfo {
long uptime; /* 启动到现在经过的时间 */
unsigned long loads[3];
/* 1, 5, and 15 minute load averages */
unsigned long totalram; /* 总的可用的内存大小 */
unsigned long freeram; /* 还未被使用的内存大小 */
unsigned long sharedram; /* 共享的存储器的大小*/
unsigned long bufferram; /* 的存储器的大小 */
unsigned long totalswap; /* 交换区大小 */
unsigned long freeswap; /* 还可用的交换区大小 */
unsigned short procs; /* 当前进程数目 */
unsigned short pad; /* explicit padding for m68k */
unsigned long totalhigh; /* 总的高内存大小 */
unsigned long freehigh; /* 可用的高内存大小 */
unsigned int mem_unit; /* 以字节为单位的内存大小 */
char _f[20-2*sizeof(long)-sizeof(int)];
};
}