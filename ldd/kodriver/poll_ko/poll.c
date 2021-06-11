#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/device.h>
//#include <asm/io.h>
//#include <asm/system.h>
//#include <asm/uaccess.h>

#include <linux/poll.h>
#ifndef MEMDEV_MAJOR
#define MEMDEV_MAJOR 0   /*预设的mem的主设备号*/
#endif

#ifndef MEMDEV_NR_DEVS
#define MEMDEV_NR_DEVS 2    /*设备数*/
#endif

#ifndef MEMDEV_SIZE
#define MEMDEV_SIZE 4096
#endif

/*mem设备描述结构体*/
struct mem_dev
{
  char *data;
  unsigned long size;
  wait_queue_head_t inq;
};

struct class *my_class;
struct cdev cdev;
dev_t devno;
static int mem_major = MEMDEV_MAJOR;
bool have_data = false; /*表明设备有足够数据可供读*/

module_param(mem_major, int, S_IRUGO);

struct mem_dev *mem_devp; /*设备结构体指针*/

struct cdev cdev;

/*文件打开函数*/
int mem_open(struct inode *inode, struct file *filp)
{
    struct mem_dev *dev;

    /*获取次设备号*/
    int num = MINOR(inode->i_rdev);

    if (num >= MEMDEV_NR_DEVS)
            return -ENODEV;
    dev = &mem_devp[num];

    /*将设备描述结构指针赋值给文件私有数据指针*/
    filp->private_data = dev;

    return 0;
}

/*文件释放函数*/
int mem_release(struct inode *inode, struct file *filp)
{
  return 0;
}

/*读函数*/
static ssize_t mem_read(struct file *filp, char __user *buf, size_t size, loff_t *ppos)
{
  unsigned long p =  *ppos;
  unsigned int count = size;
  int ret = 0;
  struct mem_dev *dev = filp->private_data; /*获得设备结构体指针*/

  /*判断读位置是否有效*/
  if (p >= MEMDEV_SIZE)
    return 0;
  if (count > MEMDEV_SIZE - p)
    count = MEMDEV_SIZE - p;

  while (!have_data) /* 没有数据可读，考虑为什么不用if，而用while */
  {
        if (filp->f_flags & O_NONBLOCK)
            return -EAGAIN;

    wait_event_interruptible(dev->inq,have_data);
  }

  /*读数据到用户空间*/
  if (copy_to_user(buf, (void*)(dev->data + p), count))
  {
    ret =  - EFAULT;
  }
  else
  {
    *ppos += count;
    ret = count;

    printk(KERN_INFO "read %u bytes(s) from %lu\n", count, p);
  }

  have_data = false; /* 表明不再有数据可读 */
  /* 唤醒写进程 */
  return ret;
}

/*写函数*/
static ssize_t mem_write(struct file *filp, const char __user *buf, size_t size, loff_t *ppos)
{
  unsigned long p =  *ppos;
  unsigned int count = size;
  int ret = 0;
  struct mem_dev *dev = filp->private_data; /*获得设备结构体指针*/

  /*分析和获取有效的写长度*/
  if (p >= MEMDEV_SIZE)
    return 0;
  if (count > MEMDEV_SIZE - p)
    count = MEMDEV_SIZE - p;

  /*从用户空间写入数据*/
  if (copy_from_user(dev->data + p, buf, count))
    ret =  - EFAULT;
  else
  {
    *ppos += count;
    ret = count;

    printk(KERN_INFO "written %u bytes(s) from %lu\n", count, p);
  }

  have_data = true; /* 有新的数据可读 */

    /* 唤醒读进程 */
    wake_up(&(dev->inq));

  return ret;
}

/* seek文件定位函数 */
static loff_t mem_llseek(struct file *filp, loff_t offset, int whence)
{
    loff_t newpos;

    switch(whence) {
      case 0: /* SEEK_SET */
        newpos = offset;
        break;

      case 1: /* SEEK_CUR */
        newpos = filp->f_pos + offset;
        break;

      case 2: /* SEEK_END */
        newpos = MEMDEV_SIZE -1 + offset;
        break;

      default: /* can't happen */
        return -EINVAL;
    }
    if ((newpos<0) || (newpos>MEMDEV_SIZE))
        return -EINVAL;

    filp->f_pos = newpos;
    return newpos;

}
unsigned int mem_poll(struct file *filp, poll_table *wait)
{
    struct mem_dev  *dev = filp->private_data;
    unsigned int mask = 0;

   /*将等待队列添加到poll_table */
    poll_wait(filp, &dev->inq,  wait);


    if (have_data)         mask |= POLLIN | POLLRDNORM;  /* readable */

    return mask;
}


/*文件操作结构体*/
static const struct file_operations mem_fops =
{
  .owner = THIS_MODULE,
  .llseek = mem_llseek,
  .read = mem_read,
  .write = mem_write,
  .open = mem_open,
  .release = mem_release,
  .poll = mem_poll,
};

/*设备驱动模块加载函数*/
static int memdev_init(void)
{
  int result;
  int i;

  devno = MKDEV(mem_major, 0);

  /* 静态申请设备号*/
  if (mem_major)
    result = register_chrdev_region(devno, 2, "memdev");
  else  /* 动态分配设备号 */
  {
    result = alloc_chrdev_region(&devno, 0, 2, "memdev");
    mem_major = MAJOR(devno);
  }

  if (result < 0)
    return result;

  my_class = class_create(THIS_MODULE,"hello_char_class");  //类名为hello_char_class
  if(IS_ERR(my_class))
  {
      printk("Err: failed in creating class.\n");
      return -1;
  }
  device_create(my_class,NULL,devno,NULL,"memdev0");      //设备名为memdev
  if (result<0)
  {
      printk (KERN_WARNING "hello: can't get major number %d\n", mem_major);
      return result;
  }
  /*初始化cdev结构*/
  cdev_init(&cdev, &mem_fops);
  cdev.owner = THIS_MODULE;
  cdev.ops = &mem_fops;

  /* 注册字符设备 */
  cdev_add(&cdev, MKDEV(mem_major, 0), MEMDEV_NR_DEVS);

  /* 为设备描述结构分配内存*/
  mem_devp = (struct mem_dev * ) kmalloc(MEMDEV_NR_DEVS * sizeof(struct mem_dev), GFP_KERNEL);
  if (!mem_devp)    /*申请失败*/
  {
    result =  - ENOMEM;
    goto fail_malloc;
  }
  memset(mem_devp, 0, sizeof(struct mem_dev));

  /*为设备分配内存*/
  for (i=0; i < MEMDEV_NR_DEVS; i++)
  {
        mem_devp[i].size = MEMDEV_SIZE;
        mem_devp[i].data = kmalloc(MEMDEV_SIZE, GFP_KERNEL);
        memset(mem_devp[i].data, 0, MEMDEV_SIZE);

      /*初始化等待队列*/
     init_waitqueue_head(&(mem_devp[i].inq));
     //init_waitqueue_head(&(mem_devp[i].outq));
  }

  return 0;

  fail_malloc:
  unregister_chrdev_region(devno, 1);

  return result;
}

/*模块卸载函数*/
static void memdev_exit(void)
{
  cdev_del(&cdev);   /*注销设备*/
  device_destroy(my_class, devno);         //delete device node under /dev//必须先删除设备，再删除class类
    class_destroy(my_class);                 //delete class created by us
  kfree(mem_devp);     /*释放设备结构体内存*/
  unregister_chrdev_region(MKDEV(mem_major, 0), 2); /*释放设备号*/
}

MODULE_AUTHOR("David Xie");
MODULE_LICENSE("GPL");

module_init(memdev_init);
module_exit(memdev_exit);
