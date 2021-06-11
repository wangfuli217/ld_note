/*
 * =====================================================================================
 *
 *       Filename:  my_register.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年12月02日 22时22分50秒
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
extern struct bus_type my_bus_type;
static int my_probe(struct device *dev) {
    printk("Driver found device!\n");
    return 0;
};
static int my_remove(struct device *dev) {
    printk("Driver unpluged!\n");
    return 0;
};
struct device_driver my_driver = {
    .name = "my_dev",
    .bus = &my_bus_type,
    .probe = my_probe,
    .remove = my_remove,
};
//定义设备驱动属性

static ssize_t my_driver_show(struct device_driver *driver, char *buf) {
    return sprintf(buf, "%s\n", "This is my driver!");
};
static DRIVER_ATTR(drv, S_IRUGO, my_driver_show, NULL);
static int __init my_driver_init(void){
    int ret;
    //注册设备驱动

    ret = driver_register(&my_driver);
    if(ret)
        printk("driver_register failed!\n");
    //创建设备驱动属性

    ret = driver_create_file(&my_driver, &driver_attr_drv);
    if(ret)
        printk("create_driver_file failed!\n");

    return ret;
}
static void __exit my_driver_exit(void){
    driver_unregister(&my_driver);//注销设备驱动

}
module_init(my_driver_init);
module_exit(my_driver_exit);
MODULE_AUTHOR("Fany");
MODULE_LICENSE("GPL");
