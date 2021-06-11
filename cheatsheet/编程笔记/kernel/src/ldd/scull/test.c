/*
 * =====================================================================================
 *
 *       Filename:  scull.c
 *
 *    Description:  
 *
 *        Created:  28.04.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include 	<linux/module.h>                        /* THIS_MODULE */
#include 	<linux/kernel.h>                        /* KERN_xx container_of */
#include 	<linux/init.h>                          /* module_init() */
#include 	<linux/fs.h>                            /* file_operations file inode */
#include 	<linux/cdev.h>                          /* cdev */


struct file_operations scull_fops = {
	.owner = THIS_MODULE;
	.llseek = scull_llseek;
	.read = scull_read;
	.write = scull_write;
	.ioctl = scull_ioctl;
	.open = scull_open;
	.release = scull_release;
};

struct scull_qset {
	void ** data;
	struct scull_qset * next;
};

struct scull_dev {
	struct scull_qset * data;
	int quantum;
	int qset;
	unsigned long size;
	unsigned int access_key;
	struct semaphore sem;
	struct cdev cdev;
};

int scull_trim(struct scull_dev *dev)
{
	struct scull_qset *next, *dptr;
	int qset = dev->qset;   /* "dev" is not-null */
	int i;

	for (dptr = dev->data; dptr; dptr = next) { /* all the list items */
		if (dptr->data) {
			for (i = 0; i < qset; i++)
				kfree(dptr->data[i]);
			kfree(dptr->data);
			dptr->data = NULL;
		}
		next = dptr->next;
		kfree(dptr);
	}
	dev->size = 0;
	dev->quantum = scull_quantum;
	dev->qset = scull_qset;
	dev->data = NULL;
	return 0;
}

static void scull_setup_cdev(struct scull_dev * dev, int index)
{
	dev_t devno = MKDEV(scull_major, scull_minor + index); 
	cdev_init(&dev->cdev, &scull_fops);
	dev->cdev.owner = THIS_MODULE;
	dev->cdev.ops = &scull_fops;
	int err = cdev_add(&dev->cdev, devno, 1);
	if (err) {
		printk(KERN_NOTICE "Error %d, adding scull%d\n", err, index);
	}
}

static int __init scull_init()
{
	int result, i;
	dev_t dev = 0;                                  /* major & minor num */

	/*
	 * Get a range of minor numbers to work with, asking for a dynamic
	 * major unless directed otherwise at load time.
	 */
	if (scull_major) {
		dev = MKDEV(scull_major, scull_minor);
		result = register_chrdev_region(dev, scull_nr_devs, "scull");
	} else {
		result = alloc_chrdev_region(&dev, scull_minor, scull_nr_devs, "scull");
		scull_major = MAJOR(dev);
	}
	if (result < 0) {
		printk(KERN_WARNING "scull: can't get major %d\n", scull_major);
		return result;
	}
}

module_init(scull_init);
module_exit(scull_exit);
