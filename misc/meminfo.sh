
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
MemTotal: ���п���RAM��С ���������ڴ��ȥһЩԤ��λ���ں˵Ķ����ƴ����С��

MemFree: LowFree��HighFree���ܺͣ���ϵͳ����δʹ�õ��ڴ�

Buffers: �������ļ��������С

Cached: �����ٻ���洢����cache memory���õ��ڴ�Ĵ�С������ diskcache minus SwapCache ��.

SwapCached:�����ٻ���洢����cache memory���õĽ����ռ�Ĵ�С�Ѿ�
�������������ڴ棬����Ȼ�������swapfile�С���������Ҫ��ʱ��ܿ��
���滻������Ҫ�ٴδ�I/O�˿ڡ�

Active: �ڻ�Ծʹ���еĻ������ٻ���洢��ҳ���ļ��Ĵ�С�����Ƿǳ���Ҫ���򲻻ᱻ��������.

Inactive: �ڲ�����ʹ���еĻ������ٻ���洢��ҳ���ļ��Ĵ�С�����ܱ���������;��.

HighTotal:
HighFree: ��������ֱ��ӳ�䵽�ں˿ռ䡣�ں˱���ʹ�ò�ͬ���ַ�ʹ�øö��ڴ档

LowTotal:
LowFree: ��λ���Դﵽ��λ�ڴ�һ�������ã����������ܹ����ں�������¼
һЩ�Լ������ݽṹ��Among many other things, it is where
everything from the Slab is allocated.  Bad things happen
when you��re out of lowmem.

SwapTotal: �����ռ���ܴ�С

SwapFree: δ��ʹ�ý����ռ�Ĵ�С

Dirty: �ȴ���д�ص����̵��ڴ��С��

Writeback: ���ڱ�д�ص����̵��ڴ��С��

AnonPages��δӳ��ҳ���ڴ��С

Mapped: �豸���ļ���ӳ��Ĵ�С��

Slab: �ں����ݽṹ����Ĵ�С�����Լ���������ͷ��ڴ���������ġ�

SReclaimable:���ջ�Slab�Ĵ�С

SUnreclaim�������ջ�Slab�Ĵ�С��SUnreclaim+SReclaimable��Slab��

PageTables�������ڴ��ҳҳ���������Ĵ�С��

NFS_Unstable:���ȶ�ҳ��Ĵ�С

VmallocTotal: ����vmalloc�����ڴ��С

VmallocUsed: �Ѿ���ʹ�õ������ڴ��С��

VmallocChunk: largest contigious block of vmalloc area which is free
}

sysinfo()
{
struct sysinfo {
long uptime; /* ���������ھ�����ʱ�� */
unsigned long loads[3];
/* 1, 5, and 15 minute load averages */
unsigned long totalram; /* �ܵĿ��õ��ڴ��С */
unsigned long freeram; /* ��δ��ʹ�õ��ڴ��С */
unsigned long sharedram; /* ����Ĵ洢���Ĵ�С*/
unsigned long bufferram; /* �Ĵ洢���Ĵ�С */
unsigned long totalswap; /* ��������С */
unsigned long freeswap; /* �����õĽ�������С */
unsigned short procs; /* ��ǰ������Ŀ */
unsigned short pad; /* explicit padding for m68k */
unsigned long totalhigh; /* �ܵĸ��ڴ��С */
unsigned long freehigh; /* ���õĸ��ڴ��С */
unsigned int mem_unit; /* ���ֽ�Ϊ��λ���ڴ��С */
char _f[20-2*sizeof(long)-sizeof(int)];
};
}