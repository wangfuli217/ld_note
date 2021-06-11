/*
 * =====================================================================================
 *
 *       Filename:  bus.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年12月02日 21时36分46秒
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
static char *version = "version 1.0";
//用于判断指定的驱动程序是否能处理指定的设备。

static int my_match(struct device *dev, struct device_driver *driver) {
    return !strncmp(dev->bus->name, driver->name, strlen(driver->name));
}
//static void my_bus_release(struct device *dev) {
//    return  ;
//}
static ssize_t show_bus_version(struct bus_type *bus, char *buf) {
    return snprintf(buf, PAGE_SIZE, "%s\n", version);
}
static BUS_ATTR(version, S_IRUGO, show_bus_version, NULL);

struct device my_bus = {//定义总线设备
		.init_name = "my_bus",
};
EXPORT_SYMBOL(my_bus);
struct bus_type my_bus_type = { //定义总线类型
    .name = "my_bus",
    .match = my_match,
};
EXPORT_SYMBOL(my_bus_type);
static int __init my_bus_init(void){
    int ret;
    ret = bus_register(&my_bus_type);//注册总线

    if(ret)
        printk("bus_register failed!\n");
    if(bus_create_file(&my_bus_type, &bus_attr_version))//创建总线属性
        printk("Creat bus failed!\n");
    ret = device_register(&my_bus);//注册总线设备
    if (ret)
        printk("device_register failed!\n");
    return ret;
}
static void __exit my_bus_exit(void) {
   bus_unregister(&my_bus_type);//删除总线属性
    device_unregister(&my_bus);//删除总线设备

}
module_init(my_bus_init);
module_exit(my_bus_exit);
MODULE_AUTHOR("Fany");
MODULE_LICENSE("GPL");
