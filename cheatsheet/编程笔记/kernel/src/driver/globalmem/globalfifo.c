/*
 * =====================================================================================
 *
 *       Filename:  globalfifo.c
 *
 *    Description:  
 *
 *        Created:  03.12.10
 *       Revision:  none
 *       Compiler:  GCC 4.4
 *
 *         Author:  Yang Zhang, treblih.divad@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/poll.h>

#include <asm/io.h>
#include <asm/system.h>
#include <asm/uaccess.h>

#define GLOBALFIFO_SIZE  0x1000
#define GLOBALFIFO_MAGIC 0x11
#define MEM_CLEAR       _IO(GLOBALFIFO_MAGIC, _IOC_NONE)

static int globalfifo_major;

struct globalfifo_dev {
    unsigned cur_len;
    wait_queue_head_t r_wait, w_wait;
    struct cdev cdev;
    struct semaphore sem;
    unsigned char mem[GLOBALFIFO_SIZE];
} *devp;

static int globalfifo_open(struct inode *inodep, struct file *filp)
{
    filp->private_data = container_of(inodep->i_cdev, struct globalfifo_dev, cdev);
    return 0;
}

static int globalfifo_release(struct inode *inodep, struct file *filp) {return 0;}

static ssize_t globalfifo_read(struct file *filp, char __user *buf,
                              size_t cnt, loff_t *ppos)
{
    int ret;
    struct globalfifo_dev *dev = filp->private_data;
    DECLARE_WAITQUEUE(wait, current);

    down(&dev->sem);
    add_wait_queue(&dev->r_wait, &wait);    /* read queue */

    while (dev->cur_len == 0) {             /* not empty */
        if (filp->f_flags & O_NONBLOCK) {
            ret = -EAGAIN;
            goto out;
        }
        __set_current_state(TASK_INTERRUPTIBLE);
        up(&dev->sem);
        schedule();
        if (signal_pending(current)) {
            ret = -ERESTARTSYS;
            goto out2;
        }
        down(&dev->sem);
    }

    if (cnt > dev->cur_len) cnt = dev->cur_len;
    if (copy_to_user(buf, dev->mem, cnt)) {
        return -EFAULT;
        goto out;
    } else {
        memcpy(dev->mem, dev->mem + cnt, dev->cur_len - cnt);
        dev->cur_len -= cnt;
        wake_up_interruptible(&dev->w_wait);    /* read done, write's turn */
        ret = cnt;
        printk(KERN_INFO "read %d byte(s), current length: %d\n", cnt, dev->cur_len);
    }
    out:
    up(&dev->sem);
    out2:
    remove_wait_queue(&dev->r_wait, &wait);     /* remove from read queue */
    set_current_state(TASK_RUNNING);
    return ret;
}

static ssize_t globalfifo_write(struct file *filp, const char __user *buf,
                               size_t cnt, loff_t *ppos)
{
    int ret;
    struct globalfifo_dev *dev = filp->private_data;
    DECLARE_WAITQUEUE(wait, current);

    down(&dev->sem);
    add_wait_queue(&dev->w_wait, &wait);        /* write queue */

    /* full, can't write any more, wait to read */
    while (dev->cur_len == GLOBALFIFO_SIZE) {
        if (filp->f_flags & O_NONBLOCK) {
            ret = -EAGAIN;
            goto out;
        }
        __set_current_state(TASK_INTERRUPTIBLE);
        up(&dev->sem);
        schedule();
        if (signal_pending(current)) {
            ret = -ERESTARTSYS;
            goto out2;
        }
        down(&dev->sem);
    }

    if (cnt > GLOBALFIFO_SIZE - dev->cur_len) cnt = GLOBALFIFO_SIZE - dev->cur_len;
    if (copy_from_user(dev->mem + dev->cur_len, buf, cnt)) {
        return -EFAULT;
        goto out;
    } else {
        dev->cur_len += cnt;
        wake_up_interruptible(&dev->r_wait);    /* write done, read's turn */
        ret = cnt;
        printk(KERN_INFO "written %d byte(s), current length: %d\n", cnt, dev->cur_len);
    }
out:
    up(&dev->sem);
out2:
    remove_wait_queue(&dev->w_wait, &wait);
    set_current_state(TASK_RUNNING);
    return ret;
}

static loff_t globalfifo_llseek(struct file *flip, loff_t offset, int mod)
{
    loff_t cur = flip->f_pos;
    switch (mod) {
    /* from the start */
    case 0:
        if (offset < 0 || offset > GLOBALFIFO_SIZE) return -EINVAL;
        return flip->f_pos = offset;
    /* from the current */
    case 1:
        if (cur + offset < 0 || cur + offset > GLOBALFIFO_SIZE) return -EINVAL;
        return flip->f_pos += offset;
    default:
        return -EINVAL;
    }
}

static int globalfifo_ioctl(struct inode *inodep, struct file *filp,
                           unsigned cmd, unsigned long arg)
{
    struct globalfifo_dev *dev = filp->private_data;
    switch (cmd) {
    case MEM_CLEAR:
        if (down_interruptible(&dev->sem)) return -ERESTARTSYS;
        memset(dev->mem, 0, GLOBALFIFO_SIZE);
        up(&dev->sem);
        printk(KERN_INFO "globalfifo is set to zero\n");
        break;
    default:
        return -EINVAL;
    }
    return 0;
}

static unsigned globalfifo_poll(struct file *filp, poll_table *wait)
{
    unsigned mask = 0;
    struct globalfifo_dev *dev = filp->private_data;

    down(&dev->sem);
    poll_wait(filp, &dev->r_wait, wait);
    poll_wait(filp, &dev->w_wait, wait);
    if (dev->cur_len != 0)
        mask |= POLLIN | POLLRDNORM;
    if (dev->cur_len != GLOBALFIFO_SIZE)
        mask |= POLLOUT | POLLWRNORM;
    up(&dev->sem);
    return mask;
}

/*  =========================================================  */
static const struct file_operations globalfifo_fops = {
    .owner = THIS_MODULE,
    .open = globalfifo_open,
    .release = globalfifo_release,
    .llseek = globalfifo_llseek,
    .read = globalfifo_read,
    .write = globalfifo_write,
    .ioctl = globalfifo_ioctl,
    .poll = globalfifo_poll,
};

static void globalfifo_setup_cdev(struct globalfifo_dev *devp, int idx)
{
    int err, devno = MKDEV(globalfifo_major, idx);

    cdev_init(&devp->cdev, &globalfifo_fops);
    devp->cdev.owner = THIS_MODULE;
    if (err = cdev_add(&devp->cdev, devno, 1))      /* 1 by 1, devno is diff in 2 times */
        printk(KERN_NOTICE "Error %d adding globalfifo", err);
}

static int globalfifo_init(void)
{
    int result;
    dev_t devno = MKDEV(globalfifo_major, 0);

    /* only register */
    if (globalfifo_major) {
        if (result = register_chrdev_region(devno, 1, "globalfifo"))
            return result;
    /* sys alloc then register */
    } else {
        /* 2 devices, start from minor 0 */
        if (result = alloc_chrdev_region(&devno, 0, 1, "globalfifo"))
            return result;
    }
    globalfifo_major = MAJOR(devno);

    /* device memory alloc */
    if (!(devp = kmalloc(sizeof(struct globalfifo_dev), GFP_KERNEL))) {
        unregister_chrdev_region(devno, 1);
        return -ENOMEM;
    }

    memset(devp, 0, sizeof(struct globalfifo_dev));
    globalfifo_setup_cdev(devp, 0);     /* init & add */
    init_MUTEX(&devp->sem);             /* init semaphore */
    init_waitqueue_head(&devp->r_wait);
    init_waitqueue_head(&devp->w_wait);
    return 0;
}

static void globalfifo_exit(void)
{
    dev_t devno = MKDEV(globalfifo_major, 0);
    cdev_del(&devp->cdev);
    kfree(devp);
    unregister_chrdev_region(devno, 1);
}

MODULE_AUTHOR("haskell");
MODULE_LICENSE("Dual BSD/GPL");

module_init(globalfifo_init);
module_exit(globalfifo_exit);
