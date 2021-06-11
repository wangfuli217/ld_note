/*
 * =====================================================================================
 *
 *       Filename:  my_device.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年12月02日 22时08分34秒
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
#include <linux/device.h>
#include <linux/string.h>
extern struct device my_bus; //这里用到了总线设备中定义的结构体

extern struct bus_type my_bus_type;
static void my_device_release(struct device *dev) {
    return ;
}
struct device my_dev={ //创建设备属性

    .bus = &my_bus_type,//定义总线类型

    .parent = &my_bus,//定义my_dev的父设备。

    .release = my_device_release,
};
static ssize_t mydev_show(struct device *dev, struct device_attribute *attr,char *buf) {
    return sprintf(buf, "%s\n", "This is my device!");
}
static DEVICE_ATTR(dev, S_IRUGO, mydev_show, NULL);
static int __init my_device_init(void){
    int ret;
//    strncpy(my_dev.bus->name, "my_dev", BUS_ID_SIZE); //初始化设备

    ret = device_register(&my_dev); //注册设备

    if (ret)
        printk("device register!\n");
    device_create_file(&my_dev, &dev_attr_dev); //创建设备文件

    return ret;
}
static void __exit my_device_exit(void) {
        device_unregister(&my_dev);//卸载设备

}
module_init(my_device_init);
module_exit(my_device_exit);
MODULE_AUTHOR("Fany");
MODULE_LICENSE("GPL");
