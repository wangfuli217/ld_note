/*
 * ycbus: a software bus driver (virtual bus driver)
 *
 * a trivial ycbus driver
 */
#include <linux/device.h>
#include <linux/module.h>
struct bus_type ycbus_type = {
  .name      = "ycbus",
};
static int __init ycbus_driver_init(void)
{
  printk(KERN_DEBUG "ycbus_driver_init/n");
  return bus_register(&ycbus_type);
}
static void __exit ycbus_driver_exit(void)
{
  printk(KERN_DEBUG "ycbus_driver_exit/n");
  bus_unregister(&ycbus_type);
}
module_init(ycbus_driver_init);
module_exit(ycbus_driver_exit);
MODULE_AUTHOR("yc <cppgp@qq.com>");
MODULE_DESCRIPTION("yc pseudo-bus driver");
MODULE_LICENSE("GPL");