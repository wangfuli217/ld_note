/*
 * =====================================================================================
 *
 *       Filename:  helloko.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月29日 21时52分10秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include "linux/init.h"
#include "linux/kernel.h"
#include "linux/module.h"
#include "linux/pci.h"
#include "linux/errno.h"

MODULE_LICENSE("GPL");

#define demo_MODULE_NAME "plx_demo"

/* 指明该驱动程序适用于哪一些PCI设备 */
static struct pci_device_id demo_pci_tbl [] __initdata = {
    {0x10b5, 0x9054,
     PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
    {0,}
};

static int demo_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci_id)
{
	printk("%s+++++",__func__);
//    struct demo_card *card;
    /* 启动PCI设备 */
    if (pci_enable_device(pci_dev))
        return -EIO;
    /* 设备DMA标识 */
//    if (pci_set_dma_mask(pci_dev, DEMO_DMA_MASK)) {
//        return -ENODEV;
//    }
    /* 在内核空间中动态申请内存 */
//    if ((card = kmalloc(sizeof(struct demo_card), GFP_KERNEL)) == NULL) {
//        printk(KERN_ERR "pci_demo: out of memory\n");
//        return -ENOMEM;
//    }
//    memset(card, 0, sizeof(*card));
//    /* 读取PCI配置信息 */
//    card->iobase = pci_resource_start (pci_dev, 1);
//    card->pci_dev = pci_dev;
//    card->pci_id = pci_id->device;
//    card->irq = pci_dev->irq;
//    card->next = devs;
//    card->magic = DEMO_CARD_MAGIC;
    /* 设置成总线主DMA模式 */
    printk("bar[0]:%lx",pci_resource_start (pci_dev, 0));
    pci_set_master(pci_dev);
    /* 申请I/O资源 */
//    request_region(card->iobase, 64, card_names[pci_id->driver_data]);
    return 0;
}

static int demo_open(struct inode *inode, struct file *file)
{
    /* 申请中断，注册中断处理程序 */
//    request_irq(card->irq, &demo_interrupt, SA_SHIRQ,
//        card_names[pci_id->driver_data], card)) {
//    /* 检查读写模式 */
//    if(file->f_mode & FMODE_READ) {
//        /* ... */
//    }
//    if(file->f_mode & FMODE_WRITE) {
//       /* ... */
//    }
//
//    /* 申请对设备的控制权 */
//    down(&card->open_sem);
//    while(card->open_mode & file->f_mode) {
//        if (file->f_flags & O_NONBLOCK) {
//            /* NONBLOCK模式，返回-EBUSY */
//            up(&card->open_sem);
//            return -EBUSY;
//        } else {
//            /* 等待调度，获得控制权 */
//            card->open_mode |= f_mode & (FMODE_READ | FMODE_WRITE);
//            up(&card->open_sem);
//            /* 设备打开计数增1 */
//            MOD_INC_USE_COUNT;
//            /* ... */
//        }
//    }
	return 0;
}

/* 设备模块信息 */
static struct pci_driver demo_pci_driver = {
    name:       demo_MODULE_NAME,    /* 设备模块名称 */
    id_table:   demo_pci_tbl,    /* 能够驱动的设备列表 */
    probe:      demo_probe,    /* 查找并初始化设备 */
  //  remove:     demo_remove    /* 卸载设备模块 */
    /* ... */
};
static int __init demo_init_module (void)
{
   pci_register_driver(&demo_pci_driver);
}
static void __exit demo_cleanup_module (void)
{
    pci_unregister_driver(&demo_pci_driver);
}
/* 加载驱动程序模块入口 */
module_init(demo_init_module);
/* 卸载驱动程序模块入口 */
module_exit(demo_cleanup_module);
MODULE_AUTHOR("blaider");
MODULE_DESCRIPTION("hello");
