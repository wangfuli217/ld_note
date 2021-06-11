/*
 * =====================================================================================
 *
 *       Filename:  drv.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月30日 18时15分41秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include 	<linux/kernel.h>
#include	<linux/module.h>
#include	<linux/init.h>
#include	<linux/fs.h>
#include	<linux/mm.h>
#include	<linux/cdev.h>
#include	<linux/errno.h>
#include	<linux/types.h>
#include	<linux/interrupt.h>
#include	<linux/delay.h>
#include    <linux/errno.h>
#include    <linux/sched.h>
#include    <linux/slab.h>
#include <asm-generic/ioctl.h>
//#include     <asm/semaphore.h>
#include    <asm/system.h>
#include	<asm/uaccess.h>
//#include	<asm/arch/irqs.h>
#include 	<asm/io.h>
#include 	<linux/version.h>
//#include     <asm/hardware.h>
#include     <linux/delay.h>

#define	DRIVE_MAJOR				165
#define	DRIVE_NAME				"Test drv"

#define MEM_IOC_MAGIC 'x' //定义类型
#define MEM_IOCSET 			_IOW(MEM_IOC_MAGIC,0,int)
#define MEM_IOCGQSET 	_IOR(MEM_IOC_MAGIC, 1, int)

typedef struct code_dev
{
	dev_t dev_num;
	struct cdev cdev;
} code_dev;
static code_dev test_dev;
unsigned char data_source;
unsigned char *testmap;
unsigned char *kmalloc_area;
unsigned long msize;
static int test_open(struct inode *inode, struct file *filp)
{
	struct code_dev *dev = (struct code_dev *) container_of( inode->i_cdev, code_dev, cdev );
	printk("enter %s+++++\n", __func__);
	printk("node:%x\n",dev->dev_num);
	filp->private_data = dev;
	printk("leave %s-----\n", __func__);
	return 0;
}
static int test_close(struct inode *inode, struct file *filp)
{
	struct code_dev *dev = (struct code_dev *)container_of( inode->i_cdev, code_dev, cdev );

	int i;
	printk("enter %s+++++\n", __func__);
	for(i = 0;i<16;i++)
		printk("%c ",*(testmap+i));
	printk("\n");
	for(i = 0;i<16;i++)
			printk("%02x ",*(testmap+i));
	printk("\n");
	printk("node:%x\n",dev->dev_num);

	printk("leave %s-----\n", __func__);
	return 0;
}

static ssize_t test_write(struct file *filp, const char __user *buf,
		size_t count, loff_t *ppos)
{
	struct code_dev *dev = (struct code_dev *)filp->private_data;
	printk("enter %s+++++\n", __func__);
	printk("node:%x\n",dev->dev_num);
	if (copy_from_user(&data_source, buf, sizeof(data_source)))
	{
		printk("write error!\n");
	}
	printk("leave %s-----\n", __func__);
	return (sizeof(data_source));
}

static ssize_t test_read(struct file *filp, char __user *buf, size_t count,
		loff_t *ppos)
{
	struct code_dev *dev =(struct code_dev *) filp->private_data;
	printk("enter %s+++++\n", __func__);
	printk("node:%x\n",dev->dev_num);
	if (copy_to_user(buf, &data_source, sizeof(data_source)))
	{
		printk("read error!\n");
	}
	printk("leave %s-----\n", __func__);
	return (sizeof(data_source));
}
static int test_mmap(struct file *file, struct vm_area_struct *vma)
{
	int ret;
	struct code_dev *dev =(struct code_dev *) file->private_data;
		printk("enter %s+++++\n", __func__);
		printk("node:%x\n",dev->dev_num);
	ret = remap_pfn_range(vma, vma->vm_start,
			virt_to_phys((void *) ((unsigned long) kmalloc_area)) >> PAGE_SHIFT,
			vma->vm_end - vma->vm_start, PAGE_SHARED);
	if (ret != 0)
	{
		return -EAGAIN;
	}
	printk("leave %s-----\n", __func__);
	return ret;
}
static long test_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{

	int result;
	int i;
	struct code_dev *dev = (struct code_dev *)filp->private_data;
			printk("enter %s+++++\n", __func__);
			printk("node:%x\n",dev->dev_num);
	printk("cmd:%x\n",cmd);
	switch (cmd)
	{
	case MEM_IOCSET:
	{
		for (i = 0; i < 20; i++)
		{
			printk("i=%d  %c\n", i, *(testmap + i));
		}
		result = 2;
	}
		break;
	default:
		return -ENOTTY;
	}
	printk("leave %s-----\n", __func__);
	return (result);
}
static struct file_operations test_fs =
{
		.owner = THIS_MODULE,
		.open = test_open,
		.release = test_close,
		.read = test_read,
		.write = test_write,
		.mmap = test_mmap,
		.unlocked_ioctl = test_ioctl
};
static int	__init test_init(void)
{

	unsigned int 	ret ;
	unsigned char *virt_addr;
	printk("enter %s+++++\n",__func__);
	memset(&test_dev , 0 ,sizeof(test_dev)) ;
	test_dev.dev_num = MKDEV(DRIVE_MAJOR, 0);
	ret = register_chrdev_region(test_dev.dev_num , 1 ,DRIVE_NAME) ;
	if(ret < 0)
	{
		return(ret) ;
	}

	cdev_init(&test_dev.cdev , &test_fs) ;
	test_dev.cdev.owner = THIS_MODULE ;
	test_dev.cdev.ops = &test_fs ;

	printk("\nInit drv \n") ;

	ret = cdev_add(&test_dev.cdev , test_dev.dev_num , 1) ;
	if(ret < 0)
	{
		printk("cdev add error !\n") ;
		return(ret) ;
	}

	testmap=(unsigned char *)kmalloc(4096,GFP_KERNEL);
	kmalloc_area=(unsigned char *)(((unsigned long)testmap +PAGE_SIZE-1)&PAGE_MASK);
	if(testmap==NULL)
	{
	 printk("Kernel mem get pages error\n");
	}
	for(virt_addr=(unsigned long)kmalloc_area;(unsigned long)virt_addr<(unsigned long)kmalloc_area+4096;virt_addr+=PAGE_SIZE)
   {
   SetPageReserved(virt_to_page(virt_addr));
   }
	memset(testmap,'q',100);
	printk("Test drv reg success !\n") ;
	printk("leave %s-----\n",__func__);
	return 0 ;
}


static void __exit test_exit(void)
{
	printk("enter %s+++++\n",__func__);
	printk("Test drv  exit\n") ;
	cdev_del(&test_dev.cdev) ;
	unregister_chrdev_region(test_dev.dev_num , 1) ;
	printk("leave %s-----\n",__func__);
}

MODULE_LICENSE("GPL") ;

module_init(test_init);
module_exit(test_exit);

