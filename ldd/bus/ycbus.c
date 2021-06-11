/*
 * ycbus: a software bus driver (virtual bus driver)
 *
 * a trivial ycbus driver
 */
#include <linux/device.h>
#include <linux/module.h>
/*
 * attributes helper
 */
static const char *attrs_rw_test(bool bset, const char *value, size_t l)
{
  static char buf[64] = "rw-test-default";
  if (bset)
  {
    if (value)
    {
      /* Despite of c-library snprintf, kernel snprintf will appended '/0' automatically */
      if (l > 63) l = 63;
      memcpy(buf, value, l);
      buf[l] = '/0';
    }
    else
    {
      buf[0] = '/0';
    }
  }
  return buf;
}
static inline ssize_t attrs_version_show(const char *prefix, char *buf)
{
  return snprintf(buf, PAGE_SIZE, "%s: version 1.0.0/n", prefix);
}
static inline ssize_t attrs_rw_test_show(const char *prefix, char *buf)
{
  return snprintf(buf, PAGE_SIZE, "%s: %s/n", prefix,  attrs_rw_test(false, NULL, 0));
}
static inline ssize_t attrs_rw_test_store(const char *prefix, const char *buf, size_t count)
{
  /* it will not be failed */
  attrs_rw_test(true, buf, count);
  return count;
}
/*
 * bus attributes methods
 */
ssize_t bus_attrs_version_show(struct bus_type *bus, char *buf)
{
  return attrs_version_show("ycbus", buf);
}
ssize_t bus_attrs_rw_test_show(struct bus_type *bus, char *buf)
{
  return attrs_rw_test_show("ycbus", buf);
}
ssize_t bus_attrs_rw_test_store(struct bus_type *bus, const char *buf, size_t count)
{
  return attrs_rw_test_store("ycbus", buf, count);
}
/*
 * device attribute methods
 */
ssize_t dev_attrs_version_show(struct device *dev, struct device_attribute *attr, char *buf)
{
  return attrs_version_show("ycbus-dev0", buf);
}
ssize_t dev_attrs_rw_test_show(struct device *dev, struct device_attribute *attr, char *buf)
{
  return attrs_rw_test_show("ycbus-dev0", buf);
}
ssize_t dev_attrs_rw_test_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
  return attrs_rw_test_store("ycbus-dev0", buf, count);
}
/*
 * driver attribute
 */
ssize_t drv_attrs_version_show(struct device_driver *driver, char *buf)
{
  return attrs_version_show("ycbus-drv0", buf);
}
ssize_t drv_attrs_rw_test_show(struct device_driver *drv, char *buf)
{
  return attrs_rw_test_show("ycbus-drv0", buf);
}
ssize_t drv_attrs_rw_test_store(struct device_driver *drv, const char *buf, size_t count)
{
  return attrs_rw_test_store("ycbus-drv0", buf, count);
}
void dev_release(struct device *dev)
{
}
static struct bus_attribute bus_attrs[] = {
  __ATTR(version, S_IRUGO, bus_attrs_version_show, NULL),
  __ATTR(rw-test, (S_IRUGO|S_IWUGO), bus_attrs_rw_test_show, bus_attrs_rw_test_store),
  __ATTR_NULL,
};
static struct device_attribute dev_attrs[] = {
  __ATTR(version, S_IRUGO, dev_attrs_version_show, NULL),
  __ATTR(rw-test, (S_IRUGO|S_IWUGO), dev_attrs_rw_test_show, dev_attrs_rw_test_store),
  __ATTR_NULL,
};
struct driver_attribute drv_attrs[] = {
  __ATTR(version, S_IRUGO, drv_attrs_version_show, NULL),
  __ATTR(rw-test, (S_IRUGO|S_IWUGO), drv_attrs_rw_test_show, drv_attrs_rw_test_store),
  __ATTR_NULL,
};
static struct bus_type ycbus_type = {
  .name      = "ycbus",
  .bus_attrs = bus_attrs,
  .dev_attrs = dev_attrs,
  .drv_attrs = drv_attrs,
};
static struct device ycbus_dev = {
  .init_name = "ycbus-dev0",
  .bus       = &ycbus_type,
}; 
static struct device_driver ycbus_drv = {
  .name = "ycbus-drv0",
  .bus = &ycbus_type,
};
static int __init ycbus_driver_init(void)
{
  int ret;
  printk(KERN_DEBUG "ycbus_driver_init/n");
  
  ret = bus_register(&ycbus_type);
  if (ret) goto bus_fail;
  ret = device_register(&ycbus_dev);
  if (ret) goto dev_fail;
  ret = driver_register(&ycbus_drv);
  if (ret) goto drv_fail;
  return ret;
drv_fail:
  device_unregister(&ycbus_dev);
dev_fail:
  bus_unregister(&ycbus_type);
bus_fail:
  return ret;
}
static void __exit ycbus_driver_exit(void)
{
  printk(KERN_DEBUG "ycbus_driver_exit/n");
  driver_unregister(&ycbus_drv);
  device_unregister(&ycbus_dev);
  bus_unregister(&ycbus_type);
}
MODULE_AUTHOR("yc <cppgp@qq.com>");
MODULE_DESCRIPTION("yc pseudo-bus driver");
MODULE_LICENSE("GPL");
module_init(ycbus_driver_init);
module_exit(ycbus_driver_exit);
