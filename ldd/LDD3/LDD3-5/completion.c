#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/cdev.h>

#include <linux/sched.h>  /* current and everything */
#include <linux/kernel.h> /* printk() */
#include <linux/fs.h>     /* everything... */
#include <linux/types.h>  /* size_t */
#include <linux/completion.h>
#include <linux/slab.h>

struct cdev *complete_cdev;	

static int complete_major = 0;
static int complete_minor = 0;

module_param(complete_major, int, S_IRUGO);
module_param(complete_minor, int, S_IRUGO);

DECLARE_COMPLETION(comp);

ssize_t complete_read (struct file *filp, char __user *buf, size_t count, loff_t *pos)
{
	printk(KERN_DEBUG "process %i (%s) going to sleep\n",
			current->pid, current->comm);
	wait_for_completion(&comp);
	printk(KERN_DEBUG "awoken %i (%s)\n", current->pid, current->comm);
	return 0; /* EOF */
}

ssize_t complete_write (struct file *filp, const char __user *buf, size_t count,
		loff_t *pos)
{
	printk(KERN_DEBUG "process %i (%s) awakening the readers...\n",
			current->pid, current->comm);
	complete(&comp);
	return count; /* succeed, to avoid retrial */
}


struct file_operations complete_fops = {
	.owner = THIS_MODULE,
	.read =  complete_read,
	.write = complete_write,
};


void complete_cleanup(void)
{

	dev_t devno = MKDEV(complete_major, complete_minor);
	/* Get rid of our char dev entries */
	if (complete_cdev) {
		cdev_del(complete_cdev);		
		kfree(complete_cdev);
	}
	/* cleanup_module is never called if registering failed */
	unregister_chrdev_region(devno,1);

}


int complete_init(void)
{

	int result,err;
	dev_t dev = 0;

	if (complete_major) {
		dev = MKDEV(complete_major, complete_minor);
		result = register_chrdev_region(dev, 1 , "complete");
	} else {
		result = alloc_chrdev_region(&dev, complete_minor , 1,
				"complete");
		complete_major = MAJOR(dev);
	}
	if (result < 0) {
		printk(KERN_WARNING "complete: can't get major %d\n", complete_major);
		return result;
	}

    /* 
	 * allocate the devices -- we can't have them static, as the number
	 * can be specified at load time
	 */

	//complete_cdev = cdev_alloc();	//cdev_alloc() and kmalloc()  are both ok!  use them as you want!
	complete_cdev = kmalloc( sizeof(struct cdev), GFP_KERNEL);

	if (!complete_cdev) {
		result = -ENOMEM;
		goto fail;  /* Make this more graceful */
	}
	
	cdev_init(complete_cdev, &complete_fops);

	complete_cdev->owner = THIS_MODULE;

	err = cdev_add (complete_cdev, dev, 1);
	/* Fail gracefully if need be */
	if (err)
		printk(KERN_NOTICE "Error %d adding complete_cdev", err);

	return 0; /* succeed */

  fail:
	complete_cleanup();
	return result;

}

module_init(complete_init);
module_exit(complete_cleanup);

MODULE_AUTHOR("CK");
MODULE_LICENSE("Dual BSD/GPL");