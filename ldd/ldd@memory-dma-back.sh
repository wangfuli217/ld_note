dma(API)
{

http://www.cnblogs.com/hanyan225/archive/2010/10/28/1863854.html

上节我们说到了dma_mem_alloc()函数，需要说明的是DMA的硬件使用总线地址而非物理地址，总线地址是从设备角度上看到的内存地址，物理地址是从CPU角度上看到的未经转换的内存地址(经过转换的那叫虚拟地址)。在PC上，对于ISA和PCI而言，总线即为物理地址，但并非每个平台都是如此。由于有时候接口总线是通过桥接电路被连接，桥接电路会将IO地址映射为不同的物理地址。例如，在PRep(PowerPC Reference Platform)系统中，物理地址0在设备端看起来是0X80000000，而0通常又被映射为虚拟地址0xC0000000,所以同一地址就具备了三重身份：物理地址0,总线地址0x80000000及虚拟地址0xC0000000,还有一些系统提供了页面映射机制，它能将任意的页面映射为连续的外设总线地址。内核提供了如下函数用于进行简单的虚拟地址/总线地址转换：

unsigned long virt_to_bus(volatile void *address);
void *bus_to_virt(unsigned long address);

在使用IOMMU或反弹缓冲区的情况下，上述函数一般不会正常工作。而且，这两个函数并不建议使用。

需要说明的是设备不一定能在所有的内存地址上执行DMA操作，在这种情况下应该通过下列函数执行DMA地址掩码：

int dma_set_mask(struct device *dev, u64 mask);

比如，对于只能在24位地址上执行DMA操作的设备而言，就应该调用dma_set_mask(dev, 0xffffffff).DMA映射包括两个方面的工作：分配一片DMA缓冲区；为这片缓冲区产生设备可访问的地址。结合前面所讲的，DMA映射必须考虑Cache一致性问题。内核中提供了一下函数用于分配一个DMA一致性的内存区域：

void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp);

这个函数的返回值为申请到的DMA缓冲区的虚拟地址。此外，该函数还通过参数handle返回DMA缓冲区的总线地址。与之对应的释放函数为：

void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle);

以下函数用于分配一个写合并(writecombinbing)的DMA缓冲区：

void *dma_alloc_writecombine(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp);

与之对应的是释放函数：dma_free_writecombine(),它其实就是dma_free_conherent,只不过是用了#define重命名而已。

此外，Linux内核还提供了PCI设备申请DMA缓冲区的函数pci_alloc_consistent(),原型为：

void *pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma_addrp);  对应的释放函数为：

void pci_free_consistent(struct pci_dev *pdev, size_t size, void *cpu_addr, dma_addr_t dma_addr);

相对于一致性DMA映射而言，流式DMA映射的接口较为复杂。对于单个已经分配的缓冲区而言，使用dma_map_single()可实现流式DMA映射：

dma_addr_t dma_map_single(struct device *dev, void *buffer, size_t size, enum dma_data_direction direction);  如果映射成功，返回的是总线地址，否则返回NULL.最后一个参数DMA的方向，可能取DMA_TO_DEVICE, DMA_FORM_DEVICE, DMA_BIDIRECTIONAL和DMA_NONE;

与之对应的反函数是：

void dma_unmap_single(struct device *dev,dma_addr_t *dma_addrp,size_t size,enum dma_data_direction direction);

通常情况下，设备驱动不应该访问unmap()的流式DMA缓冲区，如果你说我就愿意这么做,我又说写什么呢，选择了权利，就选择了责任，对吧。这时可先使用如下函数获得DMA缓冲区的拥有权：

void dma_sync_single_for_cpu(struct device *dev,dma_handle_t bus_addr, size_t size, enum dma_data_direction direction);

在驱动访问完DMA缓冲区后，应该将其所有权还给设备，通过下面的函数:

void dma_sync_single_for_device(struct device *dev,dma_handle_t bus_addr, size_t size, enum dma_data_direction direction);如果设备要求较大的DMA缓冲区，在其支持SG模式的情况下，申请多个不连续的，相对较小的DMA缓冲区通常是防止申请太大的连续物理空间的方法，在Linux内核中，使用如下函数映射SG:

int dma_map_sg(struct device *dev,struct scatterlist *sg, int nents,enum dma_data_direction direction); 其中nents是散列表入口的数量，该函数的返回值是DMA缓冲区的数量，可能小于nents。对于scatterlist中的每个项目，dma_map_sg()为设备产生恰当的总线地址，它会合并物理上临近的内存区域。下面在给出scatterlist结构：

struct scatterlist
{
   struct page *page;    
   unsigned int offset;   //偏移量
   dma_addr_t dma_address;   //总线地址   
   unsigned int length;   //缓冲区长度
}

执行dma_map_sg()后，通过sg_dma_address()后可返回scatterlist对应缓冲区的总线结构，sg_dma_len()可返回scatterlist对应的缓冲区的长度，这两个函数的原型是：

dma_addr_t sg_dma_address(struct scatterlist *sg);       unsigned int sg_dma_len(struct scatterlist *sg);

在DMA传输结束后，可通过dma_map_sg(）的反函数dma_unmap_sg()去除DMA映射：
void dma_map_sg(struct device *dev, struct scatterlist *sg, int nents, enum dma_data_direction direction);   SG映射属于流式DMA映射，与单一缓冲区情况下流式DMA映射类似，如果设备驱动一定要访问映射情况下的SG缓冲区，应该先调用如下函数：
int dma_sync_sg_for_cpu(struct device *dev,struct scatterlist *sg, int nents,enum dma_data_direction direction);
访问完后，通过下列函数将所有权返回给设备：
int dma_map_device(struct device *dev,struct scatterlist *sg, int nents,enum dma_data_direction direction);
Linux系统中可以有一个相对简单的方法预先分配缓冲区，那就是同步“mem=”参数预留内存。例如，对于内存为64MB的系统，通过给其传递mem=62MB命令行参数可以使得顶部的2MB内存被预留出来作为IO内存使用，这2MB内存可以被静态映射，也可以执行ioremap().
相应的函数都介绍完了:说真的，好费劲啊，我都想放弃了，可为了小王，我继续哈..在linux设备驱动中如何操作呢：
像使用中断一样，在使用DMA之前，设备驱动程序需要首先向系统申请DMA通道，申请DMA通道的函数如下：
int request_dma(unsigned int dmanr, const char * device_id);  同样的，设备结构体指针可作为传入device_id的最佳参数。
使用完DMA通道后，应该使用如下函数释放该通道：void free_dma(unsinged int dmanr);
}