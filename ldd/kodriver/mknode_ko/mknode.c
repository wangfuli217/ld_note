/*
 * =====================================================================================
 *
 *       Filename:  mknode.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月30日 22时37分29秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
 
int HELLO_MAJOR = 0;
int HELLO_MINOR = 0;
int NUMBER_OF_DEVICES = 2;
 
struct class *my_class;
struct cdev cdev;
dev_t devno;
 
struct file_operations hello_fops = {
 .owner = THIS_MODULE
};

static ssize_t daq_show_version(struct device *dev, struct device_attribute * attr, char * buf)
{
	return sprintf(buf, "%s\n","fuck class");

}
static ssize_t daq_write_version(struct device *dev, struct device_attribute * attr, char * buf, size_t count)
{
	printk("enter %s +++++",__func__);
	return count;

}
static DEVICE_ATTR(version,S_IRWXUGO, daq_show_version,daq_write_version);

static int __init hello_init (void)
{
    int result,err;
    struct device *dev;
    devno = MKDEV(HELLO_MAJOR, HELLO_MINOR);

    if (HELLO_MAJOR)
        result = register_chrdev_region(devno, 2, "memdev");
    else
    {
        result = alloc_chrdev_region(&devno, 0, 2, "memdev");
        HELLO_MAJOR = MAJOR(devno);
    }  
    printk("MAJOR IS %d\n",HELLO_MAJOR);
    my_class = class_create(THIS_MODULE,"hello_char_class");  //类名为hello_char_class
    if(IS_ERR(my_class)) 
    {
        printk("Err: failed in creating class.\n");
        return -1; 
    }
    dev  = device_create(my_class,NULL,devno,NULL,"memdev");      //设备名为memdev
    if (result<0) 
    {
        printk (KERN_WARNING "hello: can't get major number %d\n", HELLO_MAJOR);
        return result;
    }
	if (!IS_ERR(dev))
	{

		err = device_create_file(dev, &dev_attr_version);
		if(err < 0)
		{
			printk(KERN_ALERT"Failed to create attribute val.");
		}
	}

 
    cdev_init(&cdev, &hello_fops);
    cdev.owner = THIS_MODULE;
    cdev_add(&cdev, devno, NUMBER_OF_DEVICES);
    printk (KERN_INFO "Character driver Registered\n");
    return 0;
}
 
static void __exit hello_exit (void)
{
    cdev_del (&cdev);
//    device_remove_file(dev, &dev_attr_version);
    device_destroy(my_class, devno);         //delete device node under /dev//必须先删除设备，再删除class类
    class_destroy(my_class);                 //delete class created by us
    unregister_chrdev_region (devno,NUMBER_OF_DEVICES);
    printk (KERN_INFO "char driver cleaned up\n");
}
 
module_init (hello_init);
module_exit (hello_exit);
 
MODULE_LICENSE ("GPL");
