/*
 * =========================================================
 *
 *       Filename:  cmos.c
 *
 *    Description:  
 *
 *        Created:  09.12.10
 *       Revision:  
 *       Compiler:  GCC 4.4
 *
 *         Author:  Yang Zhang, treblih.divad@gmail.com
 *        Company:  
 *
 * =========================================================
 */

#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/types.h>
#include <linux/slab.h>
#include <linux/pci.h>
#include <asm/uaccess.h>

#define NUM_CMOS_BANKS  2
#define CMOS_BANK_SIE   (0xff * 8)
#define DEVICE_NAME     "cmos"
#define CMOS_BANK0_INDEX_PORT   0x70
#define CMOS_BANK0_DATA_PORT    0x71
#define CMOS_BANK1_INDEX_PORT   0x72
#define CMOS_BANK1_DATA_PORT    0x73

static unsigned char addr_ports[NUM_CMOS_BANKS] = {
    CMOS_BANK0_INDEX_PORT, CMOS_BANK1_INDEX_PORT
};
static unsigned char data_ports[NUM_CMOS_BANKS] = {
    CMOS_BANK0_DATA_PORT, CMOS_BANK1_DATA_PORT
};
static dev_t cmos_dev_number;
static struct class *cmos_class;

static struct cmos_dev {
    unsigned short current_pointer;
    unsigned size;
    int bank_number;
    struct cdev cdev;
    char name[16];
} *cmos_devp[NUM_CMOS_BANKS];

static struct file_operations cmos_fops = {
    .owner = THIS_MODULE,
#if 0
    .open = cmos_open,
    .release = cmos_release,
    .read = cmos_read,
    .write = cmos_write,
    .llseek = cmos_llseek,
    .ioctl = cmos_ioctl
#endif
};

static int __init cmos_init(void)
{
    int ret;
    dev_t devno;
    if ((ret = alloc_chrdev_region(&cmos_dev_number, 0, 
         NUM_CMOS_BANKS, DEVICE_NAME) < 0)) {
        printk(KERN_ERR "can not register device\n");
        goto end;
    }
    cmos_class = class_create(THIS_MODULE, DEVICE_NAME);
    /* alloc memory, may block */
    cmos_devp[0] = kmalloc(sizeof(struct cmos_dev) << 1, GFP_KERNEL);
    if (!cmos_devp[0]) {
        printk(KERN_ERR "bad kmalloc\n");
        ret = -ENOMEM;
        goto end;
    }
    cmos_devp[1] = cmos_devp[0] + 1;
    for (int i = 0; i < NUM_CMOS_BANKS; ++i) {
        devno = MKDEV(MAJOR(cmos_dev_number), i);
        sprintf(cmos_devp[i]->name, "cmos%d", i);
        if (!(request_region(addr_ports[i], 2, cmos_devp[i]->name))) {
            printk(KERN_ERR "cmos: I/O ports 0x%x isn't free\n", 
                   addr_ports[i]);
            ret = -EIO;
            goto end;
        }
        cdev_init(&cmos_devp[i]->cdev, &cmos_fops);
        cmos_devp[i]->bank_number = i;
        cmos_devp[i]->cdev.owner = THIS_MODULE;
        ret = cdev_add(&cmos_devp[i]->cdev, devno, 1);
        if (ret) {
            printk(KERN_ERR "bad cdev\n");
            goto end;
        }
        /* send uevents to udev, auto create /dev/ nodes */
        device_create(cmos_class, NULL, devno, NULL, "cmos%d", i);
    }
    printk(KERN_NOTICE "cmos driver initialized\n");
end:
    return ret;
}

static void __exit cmos_exit(void)
{
    unregister_chrdev_region(cmos_dev_number, NUM_CMOS_BANKS);
    for (int i = 0; i < NUM_CMOS_BANKS; ++i) {
        device_destroy(cmos_class, MKDEV(MAJOR(cmos_dev_number), i));
        release_region(addr_ports[i], 2);
        cdev_del(&cmos_devp[i]->cdev);
    }
    kfree(cmos_devp);
    class_destroy(cmos_class);
}

module_init(cmos_init);
module_exit(cmos_exit);
MODULE_AUTHOR("haskell");
MODULE_LICENSE("Dual BSD/GPL");

char_device_struct
cdev_map
register_chrdev
spinlock_t
spin_lock
