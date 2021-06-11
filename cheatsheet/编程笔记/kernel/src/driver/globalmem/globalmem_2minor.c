/*
 * =====================================================================================
 *
 *       Filename:  globalmem.c
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

#include <asm/io.h>
#include <asm/system.h>
#include <asm/uaccess.h>

#define GLOBALMEM_SIZE  0x1000
#define GLOBALMEM_MAGIC 0x11
#define MEM_CLEAR       _IO(GLOBALMEM_MAGIC, _IOC_NONE)
#define GLOBALMEM_MAJOR 250

static int globalmem_major;

struct globalmem_dev {
    struct cdev cdev;
    unsigned char mem[GLOBALMEM_SIZE];
} *devp;

static int globalmem_open(struct inode *inodep, struct file *filp)
{
    filp->private_data = container_of(inodep->i_cdev, struct globalmem_dev, cdev);
    return 0;
}

static int globalmem_release(struct inode *inodep, struct file *filp) {return 0;}

static ssize_t globalmem_read(struct file *filp, char __user *buf,
                              size_t cnt, loff_t *ppos)
{
    loff_t p = *ppos;    /* offset, not address */
    struct globalmem_dev *dev = filp->private_data;

    /* out of boundary */
    if (p >= GLOBALMEM_SIZE) return 0;
    /* needs is beyond what we have */
    if (cnt > GLOBALMEM_SIZE - p) cnt = GLOBALMEM_SIZE - p;

    if (copy_to_user(buf, (void *)(dev->mem + p), cnt)) return -EFAULT;
    else {
        *ppos += cnt;           /* num add, not pointer add */
        printk(KERN_INFO "read %d byte(s) from %lld\n", cnt, p);
    }
    return cnt;
}

static ssize_t globalmem_write(struct file *filp, const char __user *buf,
                               size_t cnt, loff_t *ppos)
{
    loff_t p = *ppos;
    struct globalmem_dev *dev = filp->private_data;

    if (p >= GLOBALMEM_SIZE) return 0;
    if (cnt > GLOBALMEM_SIZE - p) cnt = GLOBALMEM_SIZE - p;

    if (copy_from_user((void *)(dev->mem + p), buf, cnt)) return -EFAULT;
    else {
        *ppos += cnt;
        printk(KERN_INFO "write %d byte(s) from %lld\n", cnt, p);
    }
    return cnt;
}

static loff_t globalmem_llseek(struct file *flip, loff_t offset, int mod)
{
    loff_t cur = flip->f_pos;
    switch (mod) {
    /* from the start */
    case 0:
        if (offset < 0 || offset > GLOBALMEM_SIZE) return -EINVAL;
        return flip->f_pos = offset;
    /* from the current */
    case 1:
        if (cur + offset < 0 || cur + offset > GLOBALMEM_SIZE) return -EINVAL;
        return flip->f_pos += offset;
    default:
        return -EINVAL;
    }
}

static int globalmem_ioctl(struct inode *inodep, struct file *filp,
                           unsigned cmd, unsigned long arg)
{
    struct globalmem_dev *dev = filp->private_data;
    switch (cmd) {
    case MEM_CLEAR:
        memset(dev->mem, 0, GLOBALMEM_SIZE);
        printk(KERN_INFO "globalmem is set to zero\n");
        break;
    default:
        return -EINVAL;
    }
    return 0;
}


static const struct file_operations globalmem_fops = {
    .owner = THIS_MODULE,
    .open = globalmem_open,
    .release = globalmem_release,
    .llseek = globalmem_llseek,
    .read = globalmem_read,
    .write = globalmem_write,
    .ioctl = globalmem_ioctl
};

static void globalmem_setup_cdev(struct globalmem_dev *devp, int idx)
{
    int err, devno = MKDEV(globalmem_major, idx);

    cdev_init(&devp->cdev, &globalmem_fops);
    devp->cdev.owner = THIS_MODULE;
    if (err = cdev_add(&devp->cdev, devno, 1))      /* 1 by 1, devno is diff in 2 times */
        printk(KERN_NOTICE "Error %d adding globalmem", err);
}

static int globalmem_init(void)
{
    int result;
    dev_t devno = MKDEV(globalmem_major, 0);

    /* only register */
    if (globalmem_major) {
        if (result = register_chrdev_region(devno, 2, "globalmem"))
            return result;
    /* sys alloc then register */
    } else {
        /* 2 devices, start from minor 0 */
        if (result = alloc_chrdev_region(&devno, 0, 2, "globalmem"))
            return result;
    }
    globalmem_major = MAJOR(devno);

    /* device memory alloc */
    if (!(devp = kmalloc(sizeof(struct globalmem_dev) << 1, GFP_KERNEL))) {
        unregister_chrdev_region(devno, 2);
        return -ENOMEM;
    }

    memset(devp, 0, sizeof(struct globalmem_dev) << 1);
    globalmem_setup_cdev(&devp[0], 0);     /* init & add */
    globalmem_setup_cdev(&devp[1], 1);
    return 0;
}

static void globalmem_exit(void)
{
    dev_t devno = MKDEV(globalmem_major, 0);
    cdev_del(&devp->cdev);
    cdev_del(&(devp + 1)->cdev);
    kfree(devp);
    unregister_chrdev_region(devno, 2);
}

MODULE_AUTHOR("haskell");
MODULE_LICENSE("Dual BSD/GPL");

module_init(globalmem_init);
module_exit(globalmem_exit);
