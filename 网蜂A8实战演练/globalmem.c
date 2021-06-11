//< ch6 / globalmem.c >

/*
 * A globalmem driver as an example of char device drivers
 *
 * The initial developer of the original code is Barry Song
 * <author@linuxdriver.cn>. All Rights Reserved.
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <asm/io.h>
#include <asm/system.h>
#include <asm/uaccess.h>

#define GLOBALMEM_SIZE	0x1000	/*¨¨????¨²??¡Á??¨®4K¡Á??¨²*/
#define MEM_CLEAR 0x1  /*??0¨¨????¨²??*/
#define GLOBALMEM_MAJOR 250    /*?€¨¦¨¨¦Ì?globalmem¦Ì??¡Â¨¦¨¨¡À?o?*/

static int globalmem_major = GLOBALMEM_MAJOR;
/*globalmem¨¦¨¨¡À??¨¢11¨¬?*/
struct globalmem_dev {
	struct cdev cdev; /*cdev?¨¢11¨¬?*/
	unsigned char mem[GLOBALMEM_SIZE]; /*¨¨????¨²??*/
};

struct globalmem_dev *globalmem_devp; /*¨¦¨¨¡À??¨¢11¨¬?????*/
/*???t?¨°?ao¡¥¨ºy*/
int globalmem_open(struct inode *inode, struct file *filp)
{
	/*??¨¦¨¨¡À??¨¢11¨¬??????3?¦Ì?????t??¨®D¨ºy?Y????*/
	filp->private_data = globalmem_devp;
	return 0;
}
/*???t¨º¨ª¡¤?o¡¥¨ºy*/
int globalmem_release(struct inode *inode, struct file *filp)
{
	return 0;
}

/* ioctl¨¦¨¨¡À?????o¡¥¨ºy */
static int globalmem_ioctl(struct inode *inodep, struct file *filp, unsigned
	int cmd, unsigned long arg)
{
	struct globalmem_dev *dev = filp->private_data;/*??¦Ì?¨¦¨¨¡À??¨¢11¨¬?????*/

	switch (cmd) {
	case MEM_CLEAR:
		memset(dev->mem, 0, GLOBALMEM_SIZE);
		printk(KERN_INFO "globalmem is set to zero\n");
		break;

	default:
		return  - EINVAL;
	}

	return 0;
}

/*?¨¢o¡¥¨ºy*/
static ssize_t globalmem_read(struct file *filp, char __user *buf, size_t size,
	loff_t *ppos)
{
	unsigned long p =  *ppos;
	unsigned int count = size;
	int ret = 0;
	struct globalmem_dev *dev = filp->private_data; /*??¦Ì?¨¦¨¨¡À??¨¢11¨¬?????*/

	/*¡¤???o¨ª??¨¨?¨®DD¡ì¦Ì?D?3€?¨¨*/
	if (p >= GLOBALMEM_SIZE)
		return 0;
	if (count > GLOBALMEM_SIZE - p)
		count = GLOBALMEM_SIZE - p;

	/*?¨²o?????->¨®??¡ì????*/
	if (copy_to_user(buf, (void *)(dev->mem + p), count)) {
		ret =  - EFAULT;
	} else {
		*ppos += count;
		ret = count;

		printk(KERN_INFO "read %u bytes(s) from %lu\n", count, p);
	}

	return ret;
}

/*D?o¡¥¨ºy*/
static ssize_t globalmem_write(struct file *filp, const char __user *buf,
	size_t size, loff_t *ppos)
{
	unsigned long p =  *ppos;
	unsigned int count = size;
	int ret = 0;
	struct globalmem_dev *dev = filp->private_data; /*??¦Ì?¨¦¨¨¡À??¨¢11¨¬?????*/

	/*¡¤???o¨ª??¨¨?¨®DD¡ì¦Ì?D?3€?¨¨*/
	if (p >= GLOBALMEM_SIZE)
		return 0;
	if (count > GLOBALMEM_SIZE - p)
		count = GLOBALMEM_SIZE - p;

	/*¨®??¡ì????->?¨²o?????*/
	if (copy_from_user(dev->mem + p, buf, count))
		ret =  - EFAULT;
	else {
		*ppos += count;
		ret = count;

		printk(KERN_INFO "written %u bytes(s) from %lu\n", count, p);
	}

	return ret;
}

/* seek???t????o¡¥¨ºy */
static loff_t globalmem_llseek(struct file *filp, loff_t offset, int orig)
{
	loff_t ret = 0;
	switch (orig) {
	case 0:   /*?¨¤?????t?a¨º???????¨°?*/
		if (offset < 0)	{
			ret =  - EINVAL;
			break;
		}
		if ((unsigned int)offset > GLOBALMEM_SIZE) {
			ret =  - EINVAL;
			break;
		}
		filp->f_pos = (unsigned int)offset;
		ret = filp->f_pos;
		break;
	case 1:   /*?¨¤?????t¦Ì¡À?¡ã??????¨°?*/
		if ((filp->f_pos + offset) > GLOBALMEM_SIZE) {
			ret =  - EINVAL;
			break;
		}
		if ((filp->f_pos + offset) < 0) {
			ret =  - EINVAL;
			break;
		}
		filp->f_pos += offset;
		ret = filp->f_pos;
		break;
	default:
		ret =  - EINVAL;
		break;
	}
	return ret;
}

/*???t2¨´¡Á¡Â?¨¢11¨¬?*/
static const struct file_operations globalmem_fops = {
	.owner = THIS_MODULE,
	.llseek = globalmem_llseek,
	.read = globalmem_read,
	.write = globalmem_write,
	.ioctl = globalmem_ioctl,
	.open = globalmem_open,
	.release = globalmem_release,
};

/*3?¨º??¡¥2¡é¡Á¡é2¨¢cdev*/
static void globalmem_setup_cdev(struct globalmem_dev *dev, int index)
{
	int err, devno = MKDEV(globalmem_major, index);

	cdev_init(&dev->cdev, &globalmem_fops);
	dev->cdev.owner = THIS_MODULE;
	err = cdev_add(&dev->cdev, devno, 1);
	if (err)
		printk(KERN_NOTICE "Error %d adding LED%d", err, index);
}

/*¨¦¨¨¡À??y?¡¥?¡ê?¨¦?¨®??o¡¥¨ºy*/
int globalmem_init(void)
{
	int result;
	dev_t devno = MKDEV(globalmem_major, 0);

	/* ¨¦¨º??¨¦¨¨¡À?o?*/
	if (globalmem_major)
		result = register_chrdev_region(devno, 1, "globalmem");
	else { /* ?¡¥¨¬?¨¦¨º??¨¦¨¨¡À?o? */
		result = alloc_chrdev_region(&devno, 0, 1, "globalmem");
		globalmem_major = MAJOR(devno);
	}
	if (result < 0)
		return result;

	/* ?¡¥¨¬?¨¦¨º??¨¦¨¨¡À??¨¢11¨¬?¦Ì??¨²??*/
	globalmem_devp = kmalloc(sizeof(struct globalmem_dev), GFP_KERNEL);
	if (!globalmem_devp) {    /*¨¦¨º??¨º¡ì¡ã¨¹*/
		result =  - ENOMEM;
		goto fail_malloc;
	}

	memset(globalmem_devp, 0, sizeof(struct globalmem_dev));

	globalmem_setup_cdev(globalmem_devp, 0);
	return 0;

fail_malloc:
	unregister_chrdev_region(devno, 1);
	return result;
}

/*?¡ê?¨¦D???o¡¥¨ºy*/
void globalmem_exit(void)
{
	cdev_del(&globalmem_devp->cdev);   /*¡Á¡é?¨²cdev*/
	kfree(globalmem_devp);     /*¨º¨ª¡¤?¨¦¨¨¡À??¨¢11¨¬??¨²??*/
	unregister_chrdev_region(MKDEV(globalmem_major, 0), 1); /*¨º¨ª¡¤?¨¦¨¨¡À?o?*/
}

MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
MODULE_LICENSE("Dual BSD/GPL");

module_param(globalmem_major, int, S_IRUGO);

module_init(globalmem_init);
module_exit(globalmem_exit);