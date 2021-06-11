����֪������X86�У���I/O�ռ�ĸ��I/O�ռ���������ڴ�ռ�ĸ����ͨ���ض���ָ��in��out�����ʡ��˿ںű�ʶ������ļĴ�����ַ��
���ɵ���Arm��Ƕ��ʽ�������в����ṩI/O�ռ䣬�������ǾͲ������ˣ������ص�����ڴ�ռ䡣

1��TLB:Translation Lookaside Buffer����ת����·���档Ҳ�ƿ����ת�����cache�����������������ַ�������ַ�Ķ�Ӧ��ϵ��
2��TTW:Translation Table walk����ת�������Ρ���TLB��û�л����Ӧ�ĵ�ַת����ϵʱ����Ҫͨ�����ڴ���ת����ķ��������
  �����ַ�������ַ�Ķ�Ӧ��ϵ��TTW�ɹ��󣬽��Ӧд��TLB.

linux�ں˿ռ�3~4GB�ǻ������ڷֵ�,�ӵ͵��������ǣ�
�����ڴ�ӳ����->�����->vmalloc�����ڴ������->�����->�߶��ڴ�ӳ����->ר��ҳ��Ӱ����->��������

io(API)
{
1��I/O�˿ڲ�������Linux�豸�����У�Ӧʹ��Linux�ں��ṩ�ĺ��������ʶ�λ��I/O�ռ�Ķ˿ڣ�����һ�¼��֣�
   *��д�ֽڶ˿ڣ�8λ��
     unsigned inb(unsigned port);������          voi outb(unsigned char byte, unsigned port);��д��
   *��д�ֶ˿ڣ�16λ��
     unsigned inw(unsigned port);������          voi outw(unsigned short word, unsigned port);��д��
   *��д���ֶ˿ڣ�32λ��
     unsigned inl(unsigned port);������          voi outl(unsigned longword, unsigned port);��д��
   *��дһ���ֽ�
     unsigned insb(unsigned port�� void *addr�� unsigned long count);������      voi outsb(unsigned port, void *addr, unsigned long count);��д��
   *��дһ����
     unsigned insw(unsigned port�� void *addr��unsigned long count);������      voi outsb(unsigned port, void *addr, unsigned long count);��д��
   *��дһ������
     unsigned insl(unsigned port�� void * addr�� unsigned long count);������      voi outsb(unsigned port, void *addr, unsigned long count);��д��
    ˵����������������I/O�˿�port�����ͳ�������������Ӳ��ƽ̨������ֻ��д����unsigned
  2��I/O�ڴ棺���ں��з���I/O�ڴ�֮ǰ��������ʹ��ioremap()�������豸�����������ַӳ�䵽�����ַ��
   *ioremap()ԭ�ͣ�void *ioremap(unsigned long offset, unsigned long size);
     ������һ������������ַ���õ�ַ��������ȡ�ض��������ַ��Χ���������ص������ַӦ��ʹ��iounmap()�����ͷš�
   *iounmap()ԭ�ͣ�void iounmap(void *addr);
   ���ڣ����������ַ��ӳ������������ַ�����ǾͿ���ͨ��cָ����ֱ�ӷ�����Щ��ַ����Linux�ں�Ҳ�ṩ��һ�麯����������������ַ�Ķ�д������
   *��IO�ڴ�
     unsigned int ioread8(void *addr);      unsigned int ioread16(void *addr);     unsigned int ioread32(void *addr);  ��֮��Ӧ�Ľ���汾�ǣ�
     unsigned readb(address);                unsigned readw(address);                 unsigned readl(address);  ��Щ��2.6���ں�����Ȼ����ʹ�á�
   *дIO�ڴ�
     void iowrite8(u8 value��void *addr);  void iowrite16(u16 value, void *addr);   void iowrite32(u32 value, void *addr);  ��֮��Ӧ�Ľ���汾�ǣ�
     void writeb(unsigned value, address); void writew(unsigned value,address);  void writel(unsigned value,address);  2.6���ں�����Ȼ����ʹ�á�
   *��һ��IO�ڴ�                                                                          *дһ��IO�ڴ�
     void ioread8_rep(void *addr�� void *buf, unsigned long count);       void iowrite8_rep(void *addr�� void *buf, unsigned long count);
     void ioread16_rep(void *addr�� void *buf, unsigned long count);     void iowrite8_rep(void *addr�� void *buf, unsigned long count);
     void ioread32_rep(void *addr�� void *buf, unsigned long count);     void iowrite8_rep(void *addr�� void *buf, unsigned long count);
   *����IO�ڴ�
     void memcpy_fromio(void *dest, void *source, unsigned int count);
     void memcpy_toio(void *dest, void *source, unsigned int count);
   *����IO�ڴ�
     void *ioport_map(unsigned long port, unsigned int count);
  3)��IO�˿�ӳ�䵽�ڴ�ռ�
     void *ioport_map(unsigned long port, unsigned int count);   ͨ��������������԰�port��ʼ��count��������IO�˿���ӳ��Ϊһ�Ρ��ڴ�ռ䡱��Ȼ��
                                                                                     �Ϳ������䷵�صĵ�ַ�������IO�ڴ�һ��������Щ�˿ڣ���������Ҫ����ӳ��ʱ�����ã�
     void ioport_unmap(void *addr);                                      ����������ӳ��
  4)IO�˿�����
     struct resource *request_region(unsigned long first, unsigned long n, const char *name);
     ����������ں�����n���˿ڣ���Щ�˿ڴ�first��ʼ��name����Ϊ�豸�����ƣ��ɹ����ط�NULL.һ������˿�ʹ����ɺ�Ӧ��ʹ�ã�
     void release_region(unsigned long start, unsigned long n);
  
  5)IO�ڴ�����
    struct resource *request_mem_region(unsigned long start, unsigned long len, char *name);
    ����������ں�����n���ڴ棬��Щ��ַ��first��ʼ��nameΪ�豸�����ƣ��ɹ����ط�NULL,һ��������ڴ�ʹ����ɺ�Ӧ��ʹ�ã�
    void release_mem_region() ;          ���ͷŹ�ظ�ϵͳ����Ҫ˵����������������Ҳ���Ǳ���ģ�������ʹ�á�
}
io(�ڴ��ַ�ռ��IO��ַ�ռ�)
{
1. �豸������������������Ӳ����·֮���һ������㡣

1�� ÿ�����趼ͨ����д�Ĵ������п��ơ��󲿷����趼�м����Ĵ��������������ڴ��ַ�ռ仹����IO��ַ�ռ䣬��Щ�Ĵ����ķ�λ��ַ���������ġ�
2�� ��Ӳ���㣬�ڴ������IO����û�и����ϵĲ�����Ƕ�ͨ�����ַ���ߺͿ������߷��͵�ƽ�źŽ��з��ʣ���ͨ���������߶�д���ݡ�
3�� ����x86���ձ�ʹ�õ�IO�˿�֮�⣬���豸ͨ�ŵ���һ����Ҫ������ͨ��ʹ��ӳ�䵽�ڴ�ļĴ������豸�ڴ档�����ֶ���ΪIO�ڴ�
    ��Ϊ�Ĵ������ڴ�Ĳ��������͸���ġ�
    
��ַ�ռ䣺��һ�Ļ�����ģ�
����ָ������CPUָ�ͨ�õ�CPUָ�
1. һЩCPU���쳧�������ǵ�оƬ��ʹ�õ�һ��ַ�ռ�
2. һЩΪ���豣���˶����ĵ�ַ�ռ䣬�Ա���ڴ����ֿ�
3. һЩ��������ΪIO�˿ڵĶ�д�ṩ������������·����ʹ�������CPUָ����ʶ˿ڡ�

    ����IO�˿��������ʽ��һ���ֽڿ�ȵ�IO���򣬻�ӳ�䵽�ڴ棬����ӳ�䵽�˿ڡ���������д�뵽�������ʱ��
��������ϵĵ�ƽ�ź�����д��ĸ�λ��������Ӧ�ı仯�������������ȡ�������������������Ÿ�λ��ǰ�ĵ�ƽֵ��

�ж�����IO�˿ڵ�ַ��û�ж�����IO�˿ڵ�ַ��Ƕ��ʽ΢�������� -- > ģ��ɶ�дIO�˿�
    ��Ϊ����Ҫ����Χ������ƥ�䣬�������е�IO�����ǻ��ڸ��˼����ģ�͵ģ����Լ�ʹԭ��û�ж�����IO��ַ�ռ�Ĵ�������
�ڷ�������ʱҲҪģ��ɶ�дIO�˿ڡ���ͨ�����ⲿоƬ���CPU�����еĸ��ӵ�·��ʵ�֡���һ�ַ�ʽֻ��Ƕ��ʽ��΢��������
�Ƚϳ�����

    ����ͬ����ԭ��Linux�����еļ����ƽ̨�϶�ʵ����IO�˿ڣ�����ʹ�õ�һ��ַ�ռ��CPU���ڡ��˿ڲ����ľ���
ʵ����ʱ������������������ض��ͺźͽӿڡ�(��Ϊ��ͬ���ͺ�ʹ�ò�ͬ��оƬ�������ӳ�䵽�ڴ��ַ�ռ�)��

    ��ʹ��������ΪIO�˿ڱ����˷���ĵ�ַ�ռ䣬Ҳ���������豸���ѼĴ���ӳ�䵽IO�˿ڣ�ISA�豸�ձ�ʹ��IO�˿ڣ��������PCI
�豸��ѼĴ���ӳ�䵽ĳ���ڴ��ַ���Ρ�����IO�ڴ�ͨ������ѡ��������Ϊ����Ҫ����Ĵ�����ָ�����CPU���ķ����ڴ����Ч�ʡ�
ͬʱ�ڷ����ڴ�ʱ���������ڼĴ��������Ѱַ��ʽ��ѡ����Ҳ�и�������ɡ�
}

io(IO�Ĵ����ͳ����ڴ�)
{
------ IO�Ĵ����ͳ����ڴ� ------
����Ӳ���Ĵ������ڴ�ǳ����ƣ�������Ա�ڷ���IO�Ĵ�����ʱ�����ע���������CPU��������������Ż����ı�Ԥ�ڵ�IO������

IO�Ĵ�����RAM������Ҫ�������IO�������б߽�ЧӦ�����ڴ������û�У��ڴ�д������Ψһ���������ָ��λ�ô洢һ����ֵ��
�ڴ���������������ָ��λ�����һ��д�����ֵ�������ڴ�����ٶȶ�CPU������������Ҫ������Ҳû�б߼�ЧӦ�����Կ���
���ַ��������Ż�����ʹ�ø��ٻ��汣����ֵ�����������/дָ��ȡ�

IO�Ĵ��� VS RAM ------ �߼�ЧӦ
�ڴ�д������Ψһ���������ָ��λ�ô洢һ����ֵ���ڴ���������������ָ��λ�����һ��д�����ֵ��
�����ڴ�����ٶȶ�CPU������������Ҫ������Ҳû�б߼�ЧӦ�����ԣ������ö��ַ��������Ż������ٻ��汣����ֵ�����������/дָ��ȵȡ�

�ڶԳ����ڴ������Щ�Ż���ʱ���Ż�������͸���ģ�����Ч������(�����ڵ�������ϵͳ��������)������IO������˵��Щ�Ż��ܿ���
��������Ĵ���������Ϊ�����ܵ��߼�ЧӦ�ĸ��š�����ȴ�������������IO�Ĵ�������ҪĿ�ġ�

}

barrier()
{
void barrier(void)
    �������֪ͨ����������һ���ڴ����ϣ�����Ӳ��û��Ӱ�졣�����Ĵ����ѵ�ǰCPU�Ĵ����е������޸Ĺ�����ֵ���浽
�ڴ��У���Ҫ��Щ���ݵ�ʱ�������¶���������barrier�ĵ��ÿɱ���������ǰ��ı������Ż�����Ӳ��������Լ���������

void rmb(void)
void read_barrier_depends(void)
void wmb(void)
void mb(void)
��Щ�����ڱ����ָ�����в���Ӳ���ڴ����ϣ������ʵ�ַ�����ƽ̨��صġ�rmb(���ڴ�����)��֤������֮ǰ�Ķ�����һ����
�ں����Ķ�����ִ��֮ǰ��ɡ�wmb��֤д������������mbָ�֤�����߶����ᡣ��Щ��������barrier�ĳ�����

read_barrier_depends��һ������ġ���һЩ�Ķ�������ʽ������֪����rmb��������ǰ������ж�ȡִ�б���������
��read_barrier_depends������ֹĳЩ��ȡ����������������Щ��ȡ������������ȡ�������ص����ݡ�

void smp_rmb(void)
void smp_read_barrier_depends(void)
void smp_wmb(void)
void smp_mb(void)
����smpϵͳ����ʱ��Ч��

writel(dev->registers.operation, DEV_READ);
wmb();
writel(dev->registers.control, DEV_GO);

#define set_rmb(var, value)	do { var = value; rmb(); } while (0)
#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
#define set_mb(var, value)	do { var = value; mb(); } while (0)


------ �ڴ�����  http://blog.csdn.net/world_hello_100/article/details/50131497
                 https://www.kernel.org/doc/Documentation/memory-barriers.txt
				 
# define barrier() __memory_barrier()  ��CPU�Ĵ����������޸Ĺ�����ֵ���浽�ڴ��С�

����������ʱ�ڴ�ʵ�ʵķ���˳��ͳ�������д�ķ���˳��һ��һ�£�������ڴ�������ʡ��ڴ����������Ϊ���ֵ�������Ϊ��������������ʱ�����ܡ��ڴ����������Ҫ�����������׶Σ�

    ����ʱ���������Ż������ڴ�������ʣ�ָ�����ţ�
    ����ʱ���� CPU �佻�������ڴ��������

Memory barrier �ܹ��� CPU ����������ڴ����������һ�� Memory barrier ֮ǰ���ڴ���ʲ����ض�������֮�����ɡ�Memory barrier �������ࣺ

    ������ barrier
    CPU Memory barrier

------ asm/system.h
#define mb()		do { dsb(); outer_sync(); } while (0)
#define rmb()		dsb()
#define wmb()		mb()
#define read_barrier_depends()		do { } while(0)

rmb:���ڴ�����->��֤������֮ǰ�Ķ�����һ�����ں����Ķ�����ִ��֮ǰ��ɡ�
wmb:��֤д������������
read_barrier_depends����rmb��������֤��������������
mb ����֤rmb��wmb�������ܡ�


#define smp_mb()	dmb()
#define smp_rmb()	dmb()
#define smp_wmb()	dmb()
#define smp_read_barrier_depends()	do { } while(0)
��֧��SMPʱ��Ч��

#define set_rmb(var, value)	do { var = value; rmb(); } while (0)
#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
#define set_mb(var, value)	do { var = value; mb(); } while (0)

}



���磺 wmb
	__raw_writel((__force u32) cpu_to_be32(in_param >> 32),		  hcr + 0);
	__raw_writel((__force u32) cpu_to_be32(in_param & 0xfffffffful),  hcr + 1);
	__raw_writel((__force u32) cpu_to_be32(in_modifier),		  hcr + 2);
	__raw_writel((__force u32) cpu_to_be32(out_param >> 32),	  hcr + 3);
	__raw_writel((__force u32) cpu_to_be32(out_param & 0xfffffffful), hcr + 4);
	__raw_writel((__force u32) cpu_to_be32(token << 16),		  hcr + 5);

	/* __raw_writel may not order writes. */
	wmb();

#	__raw_writel((__force u32) cpu_to_be32((1 << HCR_GO_BIT)		|
#					       (cmd->toggle << HCR_T_BIT)	|
#					       (event ? (1 << HCR_E_BIT) : 0)	|
#					       (op_modifier << HCR_OPMOD_SHIFT) |
#					       op),			  hcr + 6);

do .... while	����걣֤��չ��ĺ�������������Ļ����е���һ��������C�����ִ�С�

io(io�˿ڷ���)
{
------ ʹ��IO�˿� ------ /proc/ioports ���е�io�˿ڷ�����Դӻ��
IO�˿ڷ��䣺
linux/ioport.h

�������������Լ���Ҫ�����Ķ˿ڡ�
#define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
struct resource * request_region(resource_size_t start, resource_size_t n,
				   const char *name)
����Ҫʹ����ʼ��start��n���˿ڡ�����nameӦ�����豸�����ơ�
NULL������ʧ��
!NULL: ����ɹ�

#define release_region(start,n)	__release_region(&ioport_resource, (start), (n))      // �ͷ�
#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))     // ���
}

io(����IO�˿�-һ�δ���һ������)
{
asm/io.h
				   
static inline u8 inb(unsigned long addr)
static inline u16 inw(unsigned long addr)
static inline u32 inl(unsigned long addr)
static inline void outb(u8 b, unsigned long addr)
static inline void outw(u16 b, unsigned long addr)
static inline void outl(u32 b, unsigned long addr)

ע�⣬����û��64λ��IO��������ʹ��64λ����ϵ�ܹ��ϣ��˿ڵ�ַ�ռ�Ҳֻ�������32λ������ͨ·��

}


ioperm()
{
/usr/share/man/man7/capabilities.7.gz? [ynq] 
/usr/share/man/man4/console_ioctl.4.gz? [ynq] 
/usr/share/man/man4/mem.4.gz? [ynq] 
/usr/share/man/man2/unimplemented.2.gz? [ynq] 
/usr/share/man/man2/ioctl_list.2.gz? [ynq] 
/usr/share/man/man2/syscalls.2.gz? [ynq] 
/usr/share/man/man2/outb.2.gz? [ynq] 
/usr/share/man/man2/ioperm.2.gz? [ynq] 
/usr/share/man/man2/iopl.2.gz? [ynq] 

misc-progs/inp.c
misc-progs/outp.c
------ ���û��ռ����IO�˿� ------<sys/io.h>
1. ����ó���ʱ�����-Oѡ������֮�ں�����չ����
2. ������ioperm��ioplϵͳ��������ȡ�Զ˿ڽ���IO������Ȩ�ޡ�
   ioperm������ȡ�Ե����˿ڵĲ���Ȩ��
   iopl������ȡ������IO�ռ�Ĳ���Ȩ��
3. ������root������иó�����ܵ���ioperm��iopl.���߽��̵����Ƚ���֮һ�Ѿ���rootʡ�ݻ�ȡ�Զ˿ڵķ��ʡ�

�������ƽ̨û��ioperm��ioplϵͳ���ã����û��ռ��Կ���ʹ��/dev/port�豸�ļ�����IO�˿ڡ�


}

io(������-һ�δ���һ����������)
{
void insb
void outsb
void insw
void outsb
void insl
void outsl
����ֱ�ӽ��ֽ����Ӷ˿��ж�ȡ��д�롣��ˣ����˿ں�����ϵͳ���в�ͬ���ֽ���ʱ�������²���Ԥ�ڵĽ����
ʹ��inw��ȡ�˿ڽ��ڱ�Ҫʱ�����ֽڣ��Ա�ȷ�������ֵƥ�����������ֽ���Ȼ��������������������ֽ�����

}

io(��ͣʽIO--��ֹ��ʧ����)
{
��ͣʽIO    
inb_p
inw_p
inl_p
outb_p
outw_p
outl_p

�ڴ�������ͼ�������Ͽ��ٴ�������ʱ��ĳЩƽ̨���������⡣
��������ʱ���������ʱ�ӿ�ʱ�ͻ�������⣬�������豸�忨�ر����Ǳ��ֳ�����
������취����ÿ��ioָ��������������ָ������һ��С���ӳ١�

������豸��ʧ���ݵ��������Ϊ�˷�ֹ��ʧ���ݵ����������ʹ����ͣʽIO������ȡ��ͨ����IO������

TTL 0�� 5�� 1.2�� /dev/short0
}

���߲����ڲ��˽�ײ�Ӳ���������Ϊ�ض���ϵͳ��д��������
ARM���˿�ӳ�䵽�ڴ棬֧�����к�������������C����ʵ�֡��˿�������unsigned int.
x86_64��֧�ֱ����ᵽ�����к������˿ںŵ�������unsigned short.

x86����֮��Ĵ���������Ϊ�˿��ṩ�����ĵ�ַ�ռ䣬����ʹ�����м��ִ������Ļ�������ISA��PCI���
(�������߶�ʵ���˲�ͬ��IO���ڴ��ַ�ռ�)��

io(�ڴ�-- ӳ���ڴ�ļĴ�����ӳ���豸�ڴ�)
{

    ����IO�ڴ�ķ����ͼ������ϵ�ܹ��������Լ�����ʹ�õ��豸�йأ�����ԭ������ͬ�ġ����ݼ����ƽ̨����ʹ�����ߵĲ�ͬ��
IO�ڴ�����ǡ�Ҳ���ܲ���ͨ��ҳ����ʵġ���������Ǿ���ҳ����еģ��ں˱������Ȱ��������ַʱ�ڶ��豸��������ɼ�(��ͨ��
��ζ���ڽ����κ�IO֮ǰ�����ȵ���ioremap)�������������ҳ����ôIO�ڴ�����ͷǳ�������IO�˿ڣ�����ʹ���ʵ���ʽ�ĺ�����д
���ǡ�
    ���ܷ���IO�ڴ�ʱ�Ƿ���Ҫ����ioremap,��������ֱ��ʹ��ָ��IO�ڴ��ָ�롣����IO�ڴ���Ӳ��һ������ͨRAMһ��Ѱַ��������IO
�Ĵ����ͳ����ڴ�һ��������������Ҫ����С�ĵ������У����ǲ�����ʹ����ͨ��ָ�롣�෴��ʹ�ð�װ��������IO�ڴ棬��һ����������
ƽ̨�϶��ǰ�ȫ�ģ���һ���棬�ڿ���ֱ�Ӷ�ָ��ָ����ڴ�����ִ�в�����ʱ����������Ǿ����Ż��ġ�
    
    ����x86���ձ�ʹ�õ�IO�˿�֮�⣬���豸ͨ�ŵ���һ����Ҫ������ͨ��ʹ��ӳ�䵽�ڴ�ļĴ������豸�ڴ档�����ֶ���ΪIO�ڴ�
��Ϊ�Ĵ������ڴ�Ĳ��������͸���ġ�
    IO�ڴ����������RAM��һ�����������ﴦ���ǿ���ͨ�����߷����豸�������ڴ��кܶ���;����������Ƶ���ݻ���̫�����ݰ���
Ҳ��������ʵ������IO�˿ڵ��豸�Ĵ���(Ҳ����˵�������ǵĶ�дҲ���ڱ߼�ЧӦ)��    
    
    һ������ioremap֮���豸��������ʹ���Է��������IO�ڴ��ַ�ˣ�������IO�ڴ��ַ�Ƿ�ֱ��ӳ�䵽�����ַ�ռ䡣���Ǽ�ס����
ioremap���صĵ�ַ��Ӧֱ�����ã���Ӧ��ʹ���ں��ṩ��accesssor������

------ ʹ���ڴ� ------ 
���ݼ����ƽ̨����ʹ�����ߵĲ�ͬ��IO�ڴ�����ǡ�Ҳ���ܲ���ͨ��ҳ����ʵġ�
io�ڴ�����ӳ�䣺

linux/ioport.h
#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
#define release_mem_region(start,n)	__release_region(&iomem_resource, (start), (n))
#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))

static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
#define ioremap_nocache ioremap
static inline void iounmap(void *addr)

------ read
#define ioread8(addr)		readb(addr)
#define ioread16(addr)		readw(addr)
#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
#define ioread32(addr)		readl(addr)
#define ioread32be(addr)	be32_to_cpu(ioread32(addr))

------ write
#define iowrite8(v, addr)	writeb((v), (addr))
#define iowrite16(v, addr)	writew((v), (addr))
#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
#define iowrite32(v, addr)	writel((v), (addr))
#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))

�����ڸ�����IO�ڴ��ַ����дһϵ�е�ֵ��
#define ioread8_rep(p, dst, count) 
#define ioread16_rep(p, dst, count) 
#define ioread32_rep(p, dst, count) 

#define iowrite8_rep(p, src, count)
#define iowrite16_rep(p, src, count) 
#define iowrite32_rep(p, src, count)

��һ��IO�ڴ���ִ�в�����
void memset_io(void *addr, u8 value, unsigned int count)
void memcpy_fromio(void *dest, void *source, unsigned int count)
void memcpy_ioto(void *dest, void *source, unsigned int count)

�����ӿ�
unsigned readb(address)
unsigned readw(address)
unsigned readl(address)
void writeb(unsigned value, address)
void writew(unsigned value, address)
void writel(unsigned value, address)

------ ��IO�ڴ�һ��ʹ�ö˿� ------ 

extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
extern void ioport_unmap(void __iomem *p);

}

ISA(0xA0000-0x100000 640KB-1MB)
{

}

