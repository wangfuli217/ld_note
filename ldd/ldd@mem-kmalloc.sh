
linux/slab.h

kmalloc(�����ַ����)
{
static void *kmalloc(size_t size, gfp_t flags)
1. ���Է�Ϊ�����ͷ���������
2. ���Ի�ȡ���ڴ�ռ����㣬����������ڴ汣��ԭ�е�����
3. ����������������ڴ���Ҳ�������ġ�

GFP��get_free_pages()

1.�ں˸������ϵͳ�����ڴ棬�����ڴ�ֻ�ܰ�ҳ����з��䡣
2. �������򿪷���ԱӦ���ü�סһ�㣬�����ں�ֻ�ܷ���һЩԤ����ġ��̶���С���ֽ����顣
   ������������������ڴ棬��ô�õ��ĺܿ��ܻ��һЩ�����ᵽ����������������
   ����ԱӦ�ü�ס��kmalloc�ܴ������С���ڴ����32��64���������ĸ���ȡ���ڵ�ǰ��ϵ�ṹ��ҳ���С��
   ��kmalloc�ܹ�������ڴ���С������һ�����ޡ��������������ϵ�ṹ�Ĳ�ͬ�Լ��ں�����ѡ��Ĳ�ͬ���仯��
   �������ϵͳ���������������ֲ�ԣ���Ӧ�÷������128KB���ڴ档���ϣ���õ����ڼ�ǧ�ֽڵ��ڴ棬�����ʹ�ó�kmalloc
   ֮����ڴ��ȡ������
}

kmalloc(flags)
{
1. �������Щ����ʹ��
2. ����Щ�����ȡ�ڴ�
3. �ڴ�������ȼ��ͳ���
------ flags: ------
GFP_KERNEL: �ڴ�����Ǵ����������ں˿ռ�Ľ���ִ�еġ��������ǵ���get_free_pages��ʵ��ʵ�ʵķ��䣬����GFP��������
            ����ζ�ŵ������ĺ���������ĳ������ִ��ϵͳ���á�    ------ ����������
            kmalloc���ں��������ǿ�����ģ�
            ��ǰ��������ʱ���ں˻��ȡ�ʵ��ж��������ǰѻ�����������ˢд��Ӳ���ϣ������Ǵ��û����̻����ڴ棬�Ի�ȡһ���ڴ�ҳ�档

GFP_ATOMIC: �ж������Ļ����������ڽ���������֮��Ĵ����з����ڴ棬��������
            �жϴ������̡�tasklet���ں˶�ʱ���С�
            �ں�ͨ�����ԭ���Եķ���Ԥ��һЩ����ҳ�档
            
GFP_KERNEL���ں��ڴ��ͨ�����䷽����������������
GFP_USER:   ����Ϊ�û��ռ�����ڴ棬���ܻ�����
GFP_HIGHUSER:����GFP_USER����������и߶��ڴ�Ļ����������䡣
GFP_NOIO:   
GFP_NOFS:   ������GFP_KERNEL,�����ں˷����ڴ�Ĺ�����ʽ�����һЩ���ơ�����GFP_NOFS���䲻����ִ���κ��ļ�ϵͳ����
            GFP_NOIO��ֹ�κ�IO�ĳ�ʼ����
            ��������־��Ҫ���ļ�ϵͳ�������ڴ������ʹ�ã���Щ�����е��ڴ����������ߣ�����Ӧ�÷����ݹ���ļ�ϵͳ���á�

__GPF_DMA     ������䷢���ڿɽ���DMA���ڴ����
__GPF_HIGHMEM Ҫ������ڴ��λ�ڸ߶��ڴ�
__GPF_COLD    ͨ�����ڴ��������ʹͼ����"������"ҳ�棬�����ڴ��������ҵ���ҳ�档�෴�������־������δʹ�õ�"��"ҳ�档
              ������DMA��ȡ��ҳ����䣬����ʹ�������־����Ϊ��������£�ҳ������ڴ�����������û�ж��������
              
__GPF_NOWARN  ���Ա����ں����޷������������ʱ�����澯
__GPF_HIGH    �����ȼ�������������Ϊ����״�����������ں˱��������һЩҳ��
__GPF_REPEAT  Ŭ���ڳ���һ�Σ��������³��Է��䣬�����п���ʧ�ܡ�
__GPF_NOFAIL  ���߷�����ʼ�ղ�����ʧ�ܣ�����Ŭ�������������
__GPF_NORETRT ������ڴ治�ɻ�ã����������ء�
         
__GPF_DMA��__GPF_HIGHMEM��ʹ����ƽ̨��أ�����������ƽ̨�϶�����ʹ����������־��

ÿ�ּ���ƽ̨������֪����ΰ��Լ��ض����ڴ淶Χ���ൽ�����������У���������Ϊ����RAM��һ���ġ�

1. ����DMA���ڴ�  ������DMA���ڴ�ָ�������ر��ַ��Χ���ڴ棬�������������Щ�ڴ�ִ��DMA���ʡ�
                  �ڴ������ȫ��ϵͳ�ϣ������ڴ涼λ����һ���Ρ�
                  x86ƽ̨��DMA������RAM��ǰ16M����ʽ��ISA�豸���Ը�������ִ��DMA��
                  PCI�豸���޴����ơ�
2. �����ڴ�       
3. �߶��ڴ�       32λƽ̨Ϊ�˷��ʴ������ڴ�����ڵ�һ�ֻ��ơ�������������һЩ�����ӳ�䣬���Ǿ��޷����ں���ֱ�ӷ�����Щ�ڴ档
                  ���ͨ�����Ѵ���
                  �����������Ҫʹ�ô������ڴ棬��ô���ܹ�ʹ�ø߶��ڴ�Ĵ�ϵͳ�Ͽ��Թ����ĸ��á�
                  
__GPF_DMA��ֻ���õ�16M�ڴ棻
û��ָ���ض��ı�־���������κ�DMA���ζ�����������
__GPF_HIGHMEM���������ڴ����ζ��ᱻ����

�ں˸������ϵͳ�����ڴ棬�����ڴ�ֻ�ܰ�ҳ����з��䡣 

�ڴ����εı��������mm/page_alloc.c��ʵ�֣����εĳ�ʼ����ƽ̨��صģ�ͨ����Ӧ��arch���µ�mm/init.c�С�   
}


slab(�󱸸��ٻ���)
{
�豸��������ͨ�������漰����ʹ�ú󱸸��ٻ�����ڴ���Ϊ��Ҳ�����⣺USB��SCSI��������


------ �󱸸��ٻ��� ------ /proc/slabinfo -- scullc
linux/slab.h

struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,  // ��ʼ��
            unsigned long,
            void (*)(void *));
size������Ĵ�С��
name������������ٻ��棻��̬���֡�����һЩ��Ϣһ�߸������⡣
      ���ٻ��汣��ָ������Ƶ�ָ�룬�����Ǹ��������ݣ���ˣ���������Ӧ�ý�ָ��̬�洢��ָ�봫�ݸ����������
      ���Ʋ��ܰ����հס�
offset: ҳ���е�һ�������ƫ����������������ȷ�����ѷ���Ķ������ĳ��������룬������õľ���0.��ʾʹ��Ĭ��ֵ��

flags��������η���
SLAB_NO_REAP: �������ٻ�����ϵͳѰ���ڴ��ʱ�򲻻ᱻ���١�
SLAB_HWCACHE_ALIGN���������ݶ�������ٻ����ж��룻ʵ�ʵĲ�������������ƽ̨��Ӳ�����ٻ��沼�֡�---�����˷Ѵ����ڴ�
                    �����SMP�����ϣ����ٻ����а�����Ƶ�����ʵ�������Ļ������ѡ���Ƿǳ��õ�ѡ��
SLAB_CACHE_DMA��ÿ�����ݶ��󶼴ӿ�����DMA���ڴ���з��䡣

constructor����Щ�ڴ��п��ܻ�����ü�����������constructor���ܻᱻ��ε���
             ���ǲ�����Ϊ����һ������֮����֮�ͻ����һ��constructor
destructor�� ���ܲ�����һ�������ͷź�����������ã������ڽ�����ĳ��ʱ��ű����á�
             

void *kmem_cache_alloc(struct kmem_cache *, gfp_t);                 // ����
void kmem_cache_free(struct kmem_cache *, void *);                  // �ͷ�
void kmem_cache_destroy(struct kmem_cache *);                       // ע��


}

mempool(�����˷��ڴ���ڴ��)
{
�ڴ�غ������˷Ѵ����ڴ档

�ں�����Щ�ط����ڴ���䲻����ʧ�ܵġ�Ϊ��ȷ����Щ����µĳɹ����䣬�ں˿����߽�����һ�ֳ�Ϊ�ڴ�صĳ���
�ڴ����ʵ����ĳ����ʽ�ĺ󱻸��ٻ��棬����ͼʼ�ձ��ֿ��е��ڴ棬�Ա��ڽ���״̬��ʹ�á�

------ �ڴ�� ------ 
linux/mempool.h

�ص�����
typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);  // malloc
typedef void (mempool_free_t)(void *element, void *pool_data);      // free
ʵ����mempool_alloc_slab��mempool_free_slab                     ������ͷź���ʵ��
      kmem_cache_alloc  ��kmem_cache_free                       ������ͷź���ʵ���������������������ڴ����
�ص�����ʵ��
void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data);          // malloc �Ƽ�����
void mempool_free_slab(void *element, void *pool_data);             // free   �Ƽ�����

��ʼ������
mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn, // ��ʼ��
    mempool_free_t *free_fn, void *pool_data);
min_nr���ڴ��Ӧʼ�ձ��ֵ��ѷ�������������Ŀ�������ʵ�ʷ�����ͷ���alloc_fn��free_fn��������
pool_data��������alloc_fn��free_fn
�ڴ�������ͷ�
void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask);          // ����
void mempool_free(void *element, mempool_t *pool);              // �ͷ�

�ڴ�ع���
int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask); // ���������С
�ڴ���ͷ�
void mempool_destroy(mempool_t *pool); //�ͷ�
������mempool֮ǰ�����뽫�����ѷ���Ķ��󷵻ص��ڴ���У�����ᵼ���ں�oops.

}     

get_free_page(kmalloc�ײ㺯��)
{
ֻҪ���Ϻ�kmallocͬ���Ĺ���get_free_pages�����������������κ�ʱ����á�ĳЩ����º��������ڴ��ʧ�ܣ�
�ر�����ʹ����GFP_ATOMIC��ʱ����ˣ���������Щ�����ĳ����ڷ������ʱ��Ӧ�ṩ��Ӧ����

------ get_free_page����غ��� ------ /proc/buddyinfo scullp
get_zerod_page(unsigned int flags)  ָ����ҳ���ָ�벢��ҳ������
__get_free_page(unsigned int flags) ָ����ҳ���ָ�뵫������ҳ��
__get_free_pages(unsigned int flags, unsigned int order) �������ɸ�ҳ�棬��������ҳ��
order:������0��ʾ1��ҳ�棬1��ʾ2��ҳ�棬2��ʾ4��ҳ�档���order�ܴ���û����ô������������Է��䣬�ͷ���ʧ�ܡ�

buddyinfo����ϵͳ��ÿ���ڴ�������ÿ�������¿ɻ�õ�������Ŀ
void free_page(uisigned long addr)
void free_pages(unsigned long addr, unsigned long order);
ֻҪ���Ϻ�kmallocһ���Ĺ���get_free_pages�����������������κ�ʱ����á� ĳЩʱ���ʧ�ܡ�


}

alloc_pages(ҳ��С����)
{

struct page���ں��������������ڴ�ҳ�����ݽṹ��

------ alloc_pages ------ 
struct page �ں��������������ڴ�ҳ�����ݽṹ

struct page *alloc_pages_node(int nid, gfp_t gfp_mask,  // Linuxҳ�������ĺ��Ĵ���
                        unsigned int order)
nidΪNUMA�ڵ��ID����ʾҪ�����з����ڴ�ռ�
flags��ͨ����GFP_�����־
order��Ҫ������ڴ��С��

struct page *alloc_pages(gfp_t gfp_mask, unsigned int order) //alloc_pages_node����
struct page *alloc_page(gfp_t gfp_mask)                      //alloc_pages_node����


#define __free_page(page) __free_pages((page), 0)
#define free_page(addr) free_pages((addr), 0)

void __free_page(struct page *page);
void __free_pages(struct page *page, unsigned int order);
void free_hot_page(struct page *page);
void free_cold_page(struct page *page);
�������֪��ĳ��ҳ���е������Ƿ�פ���ڴ��������ٻ����У���Ӧ��ʹ��free_hot_page(����פ���ڸ��ٻ����е�ҳ)��
����free_cold_page���ں�ͨ�š�

}

vmalloc(�����ַ����)
{
vmalloc��Linux�ڴ������ƵĻ�����


kmalloc��__get_free_pages���ص��ڴ��ַҲ�������ַ����ʵ��ֵ��ȻҪ��MMU�������תΪ�����ڴ��ַ��
vmalloc�����ʹ��Ӳ����û���������������ں����ִ�з��������ϡ�
kmalloc��__get_free_pagesʹ�õ������ַ��Χ�������ַ�ڴ���һһ��Ӧ�ģ����ܻ��л��ڳ���PAGE_OFFSET��һ��ƫ������������
��������ҪΪ�õ�ַ���޸�ҳ������һ���棬vmalloc��ioremapʹ�õĵ�ַ��Χ��ȫ������ģ�ÿ�η��䶼Ҫͨ����ҳ����ʵ�
���������������ڴ�����

vmalloc������__get_free_pages����Ϊ��������ȡ�ڴ棬��Ҫ����ҳ��
���ʹ��vmalloc�������һҳ���ڴ�ռ��ǲ�ֵ�õġ�

vmalloc������ԭ���������е��á�

------ vmalloc���丨������ ------  scullv /proc/ksyms ��Ҫҳ��ӳ��  create_module
���������ַ�ռ���������򡣾�����������������Ͽ��ܲ����������ں�ȴ��Ϊ�����ڵ�ַ���������ġ�
vmalloc��Linux�ڴ������ƵĻ��������ַ����ڴ�ʹ������Ч�ʲ��ߡ���ȡ�ڴ�ͽ���ҳ��

void *vmalloc(unsigned long size)
void vfree(const void *addr)
kmalloc��get_free_pages���ص��ڴ��ַҲ�������ַ����ʵ��ֵ��ȻҪ�õ�MMU�������ת��Ϊ�����ڴ��ַ��
kmalloc��get_free_pagesʹ�õ������ַ��Χ�������ڴ���һһ��Ӧ�ģ����ܻ��л��ڳ���PAGE_OFFSET��һ��ƫ�ơ���������������ҪΪ�õ�ַ���޸�ҳ��

vmalloc�����ʹ��Ӳ����û���������������ں����ִ�з��������ϡ�
vmalloc��ioremapʹ�õĵ�ַ��Χ��ȫ������ģ�ÿ�η��䶼Ҫͨ��ҳ����趨�����������ڴ�����

VMALLOC_START~VMALLOC_END��Χ�С�

��vmalloc����õ��ĵ�ַ�ǲ�����΢������֮��ʹ�õģ���Ϊ����ֻ�ڴ�����ڴ����Ԫ�ϲ������塣
������������Ҫ�����������ڴ��ʱ�򣬾Ͳ���ʹ��vmalloc���䡣


}

ioremap(����ҳ���������ڴ�)
{
ioremap�����µ�ҳ��ioremap����ʵ�ʷ����ڴ档
ioremap�ķ���ֵ��һ�������������Ӻã�������������ָ���������ڴ�������������ַ���Ҫ����iounmap���ͷš�
ioremap������ӳ��(�����)PCI��������ַ��(�����)�ں˿ռ䡣

ioremap��vmalloc������������ҳ��������¶�λ�������ڴ�ռ�ʵ���϶����ϵ��������һ��ҳ�߽硣
ioremapͨ������ӳ��ĵ�ַ�����µ���ҳ�߽硣����ֱ�Ӱ�PCI�ڴ���ӳ�䵽����ĵ�ַ�ռ䡣

ioremap������physical memoryӳ�䵽kernel virtual address space�������ڰ��豸��I/O memory addressӳ�䵽
kernel virtual address space��
}

 per_CPU(������˽������)
 {
 ------ per-CPU ------  
������һ��per-CPU�����ǣ�ϵͳ�е�ÿ�������������øñ����ĸ������ŵ�
��per-CPU�����ķ��ʼ�������Ҫ��������Ϊÿ�������������Լ��ĸ����Ϲ�����
per-CPU���������Ա����ڶ�Ӧ�������ĸ��ٻ����С����������Ϳ�����Ƶ������ʱ��ø��õ����ܡ�

������ϵͳ��

linux/percpu.h
DEFINE_PER_CPU(type, name);
DECLARE_PER_CPU(type, name);
���������per-CPU�����ĺ�

per_cpu(variable, int cpu_id);
get_cpu_var(variable);
put_cpu_var(variable);
���ڷ��ʾ�̬������per-CPU�����ĺ�

void *alloc_percpu(type);
void *__alloc_percpu(size_t size, size_t align);
void free_percpu(void *variable);
ִ��per-CPU����������ʱ������ͷŵĺ���

int get_cpu();
void put_cpu();
per_cpu_ptr(void *variable, int cpu_id);
get_cpu��õ�ǰ�����������ò����ش����ID�ţ�
put_cpu���ظ����á�
Ϊ�˷��ʶ�̬�����per-CPU������Ӧʹ��per_cpu_ptr��������Ҫ���ʵı����汾��CPU ID�š���ĳ����̬��per-CPU����
�ĵ�ǰCPU�汾�Ĳ�����Ӧ�ð����ڶ�get_cpu��put_cpu�ĵ����м䡣

/linux/percpu.h

------ ������ʱ��ȡר�û����� ------ ���ߴ� & �̶�����
linux/bootmem.h �ƹ���buddyinfoϵͳ��

}

bootmem()
{
    �����ȷ��Ҫ�����Ĵ���ڴ��������������������ϵͳ�����ڼ�ͨ�������ڴ������䣬������ʱ�ͽ��з����ǻ�ô���
�������ڴ�Ҳ���Ψһ���������ƹ���__get_free_pages�����ڻ�������С�ϵĳߴ�͹̶����ȵ�˫�����ơ�������ʱ���仺����
�е�"��"����Ϊ��ͨ������˽���ڴ�ض��������ں˵��ڴ������ԡ����ּ����Ƚϴֱ�Ҳ�ܲ�������Ҳ�Ǻܲ�����ʧ�ܵġ�
��Ȼ��ģ�鲻��������ʱ�����ڴ棬��ֻ��ֱ�����ӵ��ں˵��豸�����������������ʱ�����ڴ档

    ����һ��ֵ��ע��������ǣ�������ͨ�û���˵����ʱ�ķ��䲻��һ����ʵ���õ�ѡ���Ϊ���ֻ���֧�����ӵ��ں˾���
�еĴ�����á�Ҫ��װ���滻ʹ�������ַ��似�����������򣬾�ֻ�����±����ں˲�����������ˡ�

    �ں˱�����ʱ�������Է���ϵͳ���е������ڴ棬Ȼ����ø�����ϵͳ�ĳ�ʼ���������г�ʼ�����������ʼ���������˽��
�Ļ�������ͬʱ��������������ϵͳ������RAM������

alloc_bootmem(x)
alloc_bootmem_low(x)
alloc_bootmem_pages(x)
alloc_bootmem_low_pages(x)
Ҫô��������ҳ(����pages��β)��Ҫô���䲻��ҳ��߽��϶�����ڴ�����
����ʹ�þ���_low��׺�İ汾�����������ڴ���ܻ�ʹ�߶��ڴ档

extern void free_bootmem(unsigned long addr, unsigned long size);
ͨ�����������ͷŵĲ���ҳ�治�᷵����ϵͳ�����ǣ��������ʹ�����ּ���������ʵӦ������õ���һЩ������ҳ�档

}



