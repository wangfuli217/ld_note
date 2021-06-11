//< ch8 / globalfifo.c >

/*
 * A globalfifo driver as an example of char device drivers
 * This example is to introduce poll,blocking and non-blocking access
 *
 * The initial developer of the original code is Baohua Song
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
#include <linux/poll.h>

#define GLOBALFIFO_SIZE	0x1000	/*��???fifo��??��4K��??��*/
#define FIFO_CLEAR 0x1  /*??0��????��??��?3�?��*/
#define GLOBALFIFO_MAJOR 249    /*?�������?globalfifo��??�¨�����?o?*/

static int globalfifo_major = GLOBALFIFO_MAJOR;
/*globalfifo������??��11��?*/
struct globalfifo_dev {
	struct cdev cdev; /*cdev?��11��?*/
	unsigned int current_len;    /*fifo��DD�쨺y?Y3�?��*/
	unsigned char mem[GLOBALFIFO_SIZE]; /*��????��??*/
	struct semaphore sem; /*2�顤��????��?��?D?o?��?*/
	wait_queue_head_t r_wait; /*������??����?��?�̨�?y?����D����*/
	wait_queue_head_t w_wait; /*������?D?��?��?�̨�?y?����D����*/
};

struct globalfifo_dev *globalfifo_devp; /*������??��11��?????*/
/*???t?��?ao����y*/
int globalfifo_open(struct inode *inode, struct file *filp)
{
	/*??������??��11��??????3?��?????t??��D��y?Y????*/
	filp->private_data = globalfifo_devp;
	return 0;
}
/*???t������?o����y*/
int globalfifo_release(struct inode *inode, struct file *filp)
{
	return 0;
}

/* ioctl������?????o����y */
static int globalfifo_ioctl(struct inode *inodep, struct file *filp, unsigned
	int cmd, unsigned long arg)
{
	struct globalfifo_dev *dev = filp->private_data;/*??��?������??��11��?????*/

	switch (cmd) {
	case FIFO_CLEAR:
		down(&dev->sem); /* ??��?D?o?��? */
		dev->current_len = 0;
		memset(dev->mem,0,GLOBALFIFO_SIZE);
		up(&dev->sem); /* ������?D?o?��? */

		printk(KERN_INFO "globalfifo is set to zero\n");
		break;

	default:
		return  - EINVAL;
	}
	return 0;
}

static unsigned int globalfifo_poll(struct file *filp, poll_table *wait)
{
	unsigned int mask = 0;
	struct globalfifo_dev *dev = filp->private_data; /*??��?������??��11��?????*/

	down(&dev->sem);

	poll_wait(filp, &dev->r_wait, wait);
	poll_wait(filp, &dev->w_wait, wait);
	/*fifo��???*/
	if (dev->current_len != 0) {
		mask |= POLLIN | POLLRDNORM; /*������?��y?Y?��??��?*/
	}
	/*fifo��??��*/
	if (dev->current_len != GLOBALFIFO_SIZE) {
		mask |= POLLOUT | POLLWRNORM; /*������?��y?Y?��D?��?*/
	}

	up(&dev->sem);
	return mask;
}


/*globalfifo?��o����y*/
static ssize_t globalfifo_read(struct file *filp, char __user *buf, size_t count,
	loff_t *ppos)
{
	int ret;
	struct globalfifo_dev *dev = filp->private_data;
	DECLARE_WAITQUEUE(wait, current);

	down(&dev->sem); /* ??��?D?o?��? */
	add_wait_queue(&dev->r_wait, &wait); /* ??��??���̨�?y?����D���� */

	/* �̨�?yFIFO��??? */
	if (dev->current_len == 0) {
		if (filp->f_flags &O_NONBLOCK) {
			ret =  - EAGAIN;
			goto out;
		}
		__set_current_state(TASK_INTERRUPTIBLE); /* ??��???3����?��??a?��?? */
		up(&dev->sem);

		schedule(); /* �̡�?��??????3��??DD */
		if (signal_pending(current)) {
			/* ��?1?��?����?aD?o???D? */
			ret =  - ERESTARTSYS;
			goto out2;
		}

		down(&dev->sem);
	}

	/* ??��?��?��??��???? */
	if (count > dev->current_len)
		count = dev->current_len;

	if (copy_to_user(buf, dev->mem, count)) {
		ret =  - EFAULT;
		goto out;
	} else {
		memcpy(dev->mem, dev->mem + count, dev->current_len - count); /* fifo��y?Y?�㨰? */
		dev->current_len -= count; /* ��DD�쨺y?Y3�?��??���� */
		printk(KERN_INFO "read %d bytes(s),current_len:%d\n", count, dev->current_len);

		wake_up_interruptible(&dev->w_wait); /* ??D?D?�̨�?y?����D */

		ret = count;
	}
out:
	up(&dev->sem); /* ������?D?o?��? */
out2:
	remove_wait_queue(&dev->w_wait, &wait); /* ?��??��?��?�̨�?y?����D������?3y */
	set_current_state(TASK_RUNNING);
	return ret;
}


/*globalfifoD?2������*/
static ssize_t globalfifo_write(struct file *filp, const char __user *buf,
	size_t count, loff_t *ppos)
{
	struct globalfifo_dev *dev = filp->private_data;
	int ret;
	DECLARE_WAITQUEUE(wait, current);

	down(&dev->sem);
	add_wait_queue(&dev->w_wait, &wait);

	/* �̨�?yFIFO��??�� */
	if (dev->current_len == GLOBALFIFO_SIZE) {
		if (filp->f_flags &O_NONBLOCK) {
			ret =  - EAGAIN;
			goto out;
		}
		__set_current_state(TASK_INTERRUPTIBLE); /* ??��???3����?��??a?��?? */
		up(&dev->sem);

		schedule(); /* �̡�?��??????3��??DD */
		if (signal_pending(current)) {
			/* ��?1?��?����?aD?o???D? */
			ret =  - ERESTARTSYS;
			goto out2;
		}

		down(&dev->sem); /* ??��?D?o?��? */
	}

	/*?����??��??????��?��??��o?????*/
	if (count > GLOBALFIFO_SIZE - dev->current_len)
		count = GLOBALFIFO_SIZE - dev->current_len;

	if (copy_from_user(dev->mem + dev->current_len, buf, count)) {
		ret =  - EFAULT;
		goto out;
	} else {
		dev->current_len += count;
		printk(KERN_INFO "written %d bytes(s),current_len:%d\n", count, dev
			->current_len);

		wake_up_interruptible(&dev->r_wait); /* ??D??���̨�?y?����D */

		ret = count;
	}

out:
	up(&dev->sem); /* ������?D?o?��? */
out2:
	remove_wait_queue(&dev->w_wait, &wait); /* ?��??��?��?�̨�?y?����D������?3y */
	set_current_state(TASK_RUNNING);
	return ret;
}


/*???t2������?��11��?*/
static const struct file_operations globalfifo_fops = {
	.owner = THIS_MODULE,
	.read = globalfifo_read,
	.write = globalfifo_write,
	.ioctl = globalfifo_ioctl,
	.poll = globalfifo_poll,
	.open = globalfifo_open,
	.release = globalfifo_release,
};

/*3?��??��2�����2��cdev*/
static void globalfifo_setup_cdev(struct globalfifo_dev *dev, int index)
{
	int err, devno = MKDEV(globalfifo_major, index);

	cdev_init(&dev->cdev, &globalfifo_fops);
	dev->cdev.owner = THIS_MODULE;
	err = cdev_add(&dev->cdev, devno, 1);
	if (err)
		printk(KERN_NOTICE "Error %d adding LED%d", err, index);
}

/*������??y?��?��?��?��??o����y*/
int globalfifo_init(void)
{
	int ret;
	dev_t devno = MKDEV(globalfifo_major, 0);

	/* ����??������?o?*/
	if (globalfifo_major)
		ret = register_chrdev_region(devno, 1, "globalfifo");
	else  { /* ?����?����??������?o? */
		ret = alloc_chrdev_region(&devno, 0, 1, "globalfifo");
		globalfifo_major = MAJOR(devno);
	}
	if (ret < 0)
		return ret;
	/* ?����?����??������??��11��?��??��??*/
	globalfifo_devp = kmalloc(sizeof(struct globalfifo_dev), GFP_KERNEL);
	if (!globalfifo_devp) {
		ret =  - ENOMEM;
		goto fail_malloc;
	}

	memset(globalfifo_devp, 0, sizeof(struct globalfifo_dev));

	globalfifo_setup_cdev(globalfifo_devp, 0);

	init_MUTEX(&globalfifo_devp->sem);   /*3?��??��D?o?��?*/
	init_waitqueue_head(&globalfifo_devp->r_wait); /*3?��??��?���̨�?y?����D����*/
	init_waitqueue_head(&globalfifo_devp->w_wait); /*3?��??��D?�̨�?y?����D����*/

	return 0;

fail_malloc: unregister_chrdev_region(devno, 1);
			 return ret;
}


/*?��?��D???o����y*/
void globalfifo_exit(void)
{
	cdev_del(&globalfifo_devp->cdev);   /*����?��cdev*/
	kfree(globalfifo_devp);     /*������?������??��11��??��??*/
	unregister_chrdev_region(MKDEV(globalfifo_major, 0), 1); /*������?������?o?*/
}

MODULE_AUTHOR("Song Baohua");
MODULE_LICENSE("Dual BSD/GPL");

module_param(globalfifo_major, int, S_IRUGO);

module_init(globalfifo_init);
module_exit(globalfifo_exit);