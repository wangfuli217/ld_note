#include <linux/init.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/proc_fs.h>
#include <linux/device.h>
#include <linux/sched.h>
#include <linux/poll.h>
#include <asm/uaccess.h>

#include "cslunatic_drv.h"/*主设备和从设备号变量*/

#define DEFAULT_INTERVAL  500
#define MEM_CLEAR 0x1

static int CSlunatic_major = 0;
static int CSlunatic_minor = 0;/*设备类别和设备变量*/

static struct class *CSlunatic_class = NULL;
static struct CSlunatic_char_dev *CSlunatic_dev = NULL;/*传统的设备文件操作方法*/

static int int_var = 0;
static const char *str_var = "default";
static int int_array[6];
int narr;

/*定时器处理函数*/
static void CSlunatic_timer_hander(unsigned long args)
{
     int i;
     struct CSlunatic_char_dev *dev;

     printk("%s enter.\n", __func__);
     dev = (struct CSlunatic_char_dev *)args;
     
     /*同步访问*/    
    if(down_interruptible(&(dev->sem))) {        
        return;    
    }     
    
     for(i =0; i < 4; i++){
               dev->buf[i] = i;
     }
     
     dev->current_len += i;
     if(dev->current_len > MAX_FIFO_BUF){
            dev->current_len = MAX_FIFO_BUF;
     }
     
    wake_up_interruptible(&dev->r_wait);
     
    if(dev->timer_interval > 0)
        mod_timer(&dev->timer, jiffies + dev->timer_interval);/*修改定时器的到期时间*/
   
    up(&(dev->sem));   

    printk("%s leave.\n", __func__);
}

/*打开设备方法*/
static int CSlunatic_open(struct inode* inode, struct file* filp) 
{    
    struct CSlunatic_char_dev *dev;                

    /*将自定义设备结构体保存在文件指针的私有数据域中，以便访问设备时拿来用*/    
    dev = container_of(inode->i_cdev, struct CSlunatic_char_dev, dev);    
    
    init_timer(&dev->timer);/*初始化定时器*/
    dev->timer.function = CSlunatic_timer_hander; /*定时器操作函数*/
    dev->timer.expires = jiffies + dev->timer_interval; /*定时时间，*/
    dev->timer.data = (unsigned long)dev; /*传递给定时器操作函数函数的参数*/
    add_timer(&dev->timer);/*将定时器加到定时器队列中*/
    
    filp->private_data = dev;        

    return 0;
}

/*处理FASYNC标志变更*/
static int CSlunatic_fasync(int fd, struct file *filp, int mode)
{
    struct CSlunatic_char_dev *dev = filp->private_data;

    /*将该设备登记到fasync_queue队列中去，也可以从列表中删除*/
    return fasync_helper(fd, filp, mode, &(dev->async_queue));
}


/*设备文件释放时调用*/
static int CSlunatic_release(struct inode *inode, struct file *filp) 
{    
    struct CSlunatic_char_dev *dev;
    
    dev = (struct CSlunatic_char_dev*)filp->private_data;
    
    del_timer(&dev->timer);

    /*将文件从异步通知列表中删除*/
    CSlunatic_fasync(-1, filp, 0);
        
    printk("CSlunatic device close success!\n");
    
    return 0;
}

/*读取设备的缓冲区的值
   linux驱动中断屏蔽local_irq_disable(屏蔽中断)，local_irq_enable(开中断)
   linux 驱动阻塞wait_event_interruptible()(睡眠)   wake_up_interruptible() (唤醒)，
   linux驱动的同步down_interruptible()(获取信号量)  up(释放信号量)，
   linux驱动的互斥spin_lock(获取自旋锁)，spin_unlock(释放自旋锁),
   进程尽量不要嵌套互斥锁(或者自旋锁)
   */
static ssize_t CSlunatic_read(struct file* filp, char __user *buf, size_t count, loff_t* f_pos) 
{   
    ssize_t err = 0;    
    struct CSlunatic_char_dev *dev = filp->private_data;            

  
    /*同步访问
       当获取信号量成功时，对信号量的值减一。else表示获取信号量失败，此时进程进入睡眠状态，并将此进程插入到等待队列尾部
     */    
    if(down_interruptible(&(dev->sem))) {        
        return -ERESTARTSYS;    
    }  
    
    while(dev->current_len == 0){
        if(filp->f_flags & O_NONBLOCK){
            err = -EAGAIN; 
            goto out;
        }

        up(&(dev->sem));   
        
         /*为了将进程以一种安全的方式进入休眠，我们需要牢记两条规则：
             一、永远不要在原子上下文中进入休眠。
             二、进程休眠后，对环境一无所知。唤醒后，必须再次检查以确保我们等待的条件真正为真简单休眠
       */
        /*条件为真，当前进程的状态设置成TASK_INTERRUPTIBLE，然后调用schedule()，
           而schedule()会将位于TASK_INTERRUPTIBLE状态的当前进程从runqueue 队列中删除。
           从runqueue队列中删除的结果是，当前这个进程将不再参 与调度，除非通过其他函数将这个进程重新放入这个runqueue队列中
        */
        if (wait_event_interruptible(dev->r_wait, dev->current_len == 0)){
            return -ERESTARTSYS;
        }

        if(down_interruptible(&(dev->sem))) {        
            return -ERESTARTSYS;    
        }  
    }

     if(count > dev->current_len)
        count = dev->current_len;

    /*将缓冲区buf的值拷贝到用户提供的缓冲区*/   
    if(copy_to_user(buf, dev->buf,  count)){      
        err = -EFAULT;      
        goto out;   
     }   
    
    wake_up_interruptible(&dev->w_wait);

    /*产生异步读信号
    这样后我们在需要的地方（比如中断）调用下面的代码,就会向fasync_queue队列里的设备发送SIGIO
   信号，应用程序收到信号，执行处理程序
   注意, 一些设备还实现异步通知来指示当设备可被写入时; 在这个情况, 
   当然, kill_fasnyc 必须被使用一个 POLL_OUT 模式来调用.*/
    if(dev->async_queue)
        kill_fasync(&(dev->async_queue), SIGIO, POLL_IN);/*释放信号用的函数*/
    
    err = count;
    
 out: 
    up(&(dev->sem));   
    return err;
}

/*写设备的缓冲区buf*/
static ssize_t CSlunatic_write(struct file* filp, const char __user *buf, size_t count, loff_t* f_pos) 
{    
    struct CSlunatic_char_dev *dev = filp->private_data;    
    ssize_t err = 0;            

    /*同步访问*/    
    if(down_interruptible(&(dev->sem))) {      
        return -ERESTARTSYS;            
    }         

    while(dev->current_len == MAX_FIFO_BUF){
        if(filp->f_flags & O_NONBLOCK){
            err = -EAGAIN; 
            goto out;
        }

         up(&(dev->sem));   
         
        if (wait_event_interruptible(dev->w_wait, dev->current_len == 0)){
            err = -ERESTARTSYS;
            goto out;
        }

        if(down_interruptible(&(dev->sem))) {      
            return -ERESTARTSYS;            
        }        
    }
      
    if(count > (MAX_FIFO_BUF - dev->current_len))
    {
        count = MAX_FIFO_BUF-dev->current_len;
    }
    
    /*将用户提供的缓冲区的值写到设备寄存器去*/    
    if(copy_from_user(dev->buf + dev->current_len, buf, count)) {    
        err = -EFAULT;        
        goto out;    
    }
    
    dev->current_len += count;
    
    /*条件为真，且需要唤醒进程*/
   wake_up_interruptible(&(dev->r_wait));
   
    err = count;
    
out:    
    up(&(dev->sem));    
    return err;
}

/*驱动的ioctl实现*/
static long CSlunatic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    struct CSlunatic_char_dev *dev = filp->private_data;

    switch(cmd){
    case MEM_CLEAR:
        if(down_interruptible(&(dev->sem)))
            return -ERESTARTSYS;

        memset(dev->buf, 0, MAX_FIFO_BUF);
        up(&(dev->sem));

        printk(KERN_INFO "globamem is set to zero \n");
        break;
    default:
        return -EINVAL;
    }
}

/*非阻塞的时候轮询操作*/
static unsigned int CSlunatic_poll(struct file *filp, poll_table *wait)
{
    unsigned int mask = 0;
    struct CSlunatic_char_dev *dev = filp->private_data;  // 获得设备结构指针

   if( down_interruptible(&(dev->sem)));
        return -ERESTARTSYS;

    /*加入这两句话是为了在读写状态发生变化的时候，通知核心层，让核心层重新调用poll函数查询信息。
    也就是说这两句只会在select阻塞的时候用到。当利用select函数发现既不能读又不能写时，select
    函数会阻塞，但是此时的阻塞并不是轮询，而是睡眠，通过下面两个队列发生变化时通知select*/
    poll_wait(filp, &dev->r_wait, wait);  // 加读等待队列头
    poll_wait(filp, &dev->w_wait, wait);  // 加写等待队列头
   
    if(dev->current_len != 0)  // 可读
    {
        mask |= POLLIN | POLLRDNORM;  // 标示数据可获得
    }
   
    if(dev->current_len != MAX_FIFO_BUF)  // 可写
    {
        mask |= POLLOUT | POLLWRNORM;  // 标示数据可写入
    }

    up(&(dev->sem));
    
    return mask;
}

/*读取寄存器val的值到缓冲区buf中，内部使用*/
static ssize_t __CSlunatic_get_val(struct CSlunatic_char_dev *dev, char *buf) 
{    
    int val = 0;            

    /*同步访问*/    
    if(down_interruptible(&(dev->sem))) {                        
        return -ERESTARTSYS;     
    }            

    val = dev->val;            

    up(&(dev->sem));            

    return snprintf(buf, PAGE_SIZE, "%d\n", val);
}

/*把缓冲区buf的值写到设备寄存器val中去，内部使用*/
static ssize_t __CSlunatic_set_val(struct CSlunatic_char_dev *dev, const char *buf, size_t count) 
{    
    int val = 0;            

    /*将字符串转换成数字*/            
    val = simple_strtol(buf, NULL, 10);

    /*這個函数的功能就是获得信号量，如果得不到信号量就睡眠，此時沒有信號打斷打断，那么进
     入睡眠。但是在睡眠过程中可能被信号量打断，打断之后返回-EINTR，主要用来进程间的互斥同步。
     使用可被中断的信号量版本的意思是，万一出現了semaphore的死锁，还有机会用ctrl+c发出软中断，
     让等待这个等待内核驱动返回的用用户态进程退出。而不是把整个系統都锁住了。*/            
    if(down_interruptible(&(dev->sem))) {                        
        return -ERESTARTSYS;            
    }            

    dev->val = val;            

    up(&(dev->sem));    

    return count;
}

/*读取设备寄存器val的值，保存在page缓冲区中*/
static ssize_t CSlunatic_proc_read(char *page, char **start, off_t off, int count, int *eof, void *data) 
{    
    if(off > 0) {        
        *eof = 1;      
        return 0;   
    }   

    return __CSlunatic_get_val(CSlunatic_dev, page);
}

/*把缓冲区的值buff保存到设备寄存器val中去*/
static ssize_t CSlunatic_proc_write(struct file *filp, const char __user *buff, unsigned long len, void *data) 
{    
    int err = 0;    
    char* page = NULL;    

    if(len > PAGE_SIZE) {        
        printk(KERN_ALERT"The buff is too large: %lu.\n", len);        
        return -EFAULT;    
    }    

    page = (char*)__get_free_page(GFP_KERNEL);    
    if(!page) {                        
        printk(KERN_ALERT"Failed to alloc page.\n");        
        return -ENOMEM; 
    }           
    
     /*先把用户提供的缓冲区值拷贝到内核缓冲区中去*/    
     if(copy_from_user(page, buff, len)) {        
        printk(KERN_ALERT"Failed to copy buff from user.\n");                        
        err = -EFAULT;        
        goto out;    
     }    

     err = __CSlunatic_set_val(CSlunatic_dev, page, len);

out:
    free_page((unsigned long)page); 
    return err;
}

/*读取设备属性val*/
static ssize_t CSlunatic_val_show(struct device *dev, struct device_attribute *attr, char *buf)
{    
    struct CSlunatic_char_dev* hdev = (struct CSlunatic_char_dev*)dev_get_drvdata(dev);       
    
    return __CSlunatic_get_val(hdev, buf);
}

/*写设备属性val*/
static ssize_t CSlunatic_val_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) 
{     
    struct CSlunatic_char_dev *hdev = (struct CSlunatic_char_dev*)dev_get_drvdata(dev);          

    return __CSlunatic_set_val(hdev, buf, count);
}

/*函数宏DEVICE_ATTR内封装的是__ATTR(_name,_mode,_show,_stroe)方法，_show表示的是读方法，_stroe表示的是写方法。
sysfs接口*/
static DEVICE_ATTR(val, S_IRUGO | S_IWUSR, CSlunatic_val_show, CSlunatic_val_store);

/*创建/proc/CSlunatic文件*/
static void CSlunatic_create_proc(void) 
{    
    struct proc_dir_entry *entry;    
    
    entry = create_proc_entry(CSLUNATIC_DEVICE_PROC_NAME, 0, NULL);    
    if(entry) {        
       // entry->owner = THIS_MODULE;        
        entry->read_proc = CSlunatic_proc_read;        
        entry->write_proc = CSlunatic_proc_write;    
    }
}

/*删除/proc/CSlunatic文件*/
static void CSlunatic_remove_proc(void) 
{    
    remove_proc_entry(CSLUNATIC_DEVICE_PROC_NAME, NULL);
}

/*访问设置属性方法*/
static struct file_operations CSlunatic_fops = {    
    .owner = THIS_MODULE,
    .open = CSlunatic_open, 
    .release = CSlunatic_release,   
    .read = CSlunatic_read, 
    .write = CSlunatic_write,
    .unlocked_ioctl = CSlunatic_ioctl,/*在kernel 2.6.37 中已经完全删除了struct file_operations 中的ioctl 函数指针，取而代之的是unlocked_ioctl */
    .fasync = CSlunatic_fasync,
    .poll = CSlunatic_poll,
};

/*初始化设备*/
static int  __CSlunatic_setup_dev(struct CSlunatic_char_dev *dev) 
{    
    int err;    
    
    dev_t devno = MKDEV(CSlunatic_major, CSlunatic_minor);    

    /*如果cdev 没有分配空间，可以调用cdev_alloc来分配空间*/
    memset(dev, 0, sizeof(struct CSlunatic_char_dev));    

    cdev_init(&(dev->dev), &CSlunatic_fops);    
    dev->dev.owner = THIS_MODULE;    
    dev->dev.ops = &CSlunatic_fops;            

    /*注册字符设备*/    
    err = cdev_add(&(dev->dev),devno, 1);    
    if(err) {        
        return err;    
    }            

    /*初始化信号量
        linux 2.6.37 没有init_MUTEX()函数
        #define init_MUTEX(sem)                  sema_init(sem, 1)*/
    sema_init(&(dev->sem), 1);    

    /*初始化等待队列*/
    init_waitqueue_head(&(dev->r_wait));
    init_waitqueue_head(&(dev->w_wait));
    
    /*寄存器val的值*/
    dev->val = 0;    

    /*定时器间隔10 S*/
    dev->timer_interval = 10 * HZ;
    
    return 0;
}

/*模块加载方法  insmod cslunatic_drv.ko int_var=100 str_var=hello int_array=100,200
  * modinfo cslunatic_drv.ko 查看模块信息
  * lsmod 查看已加载的模块
  * modprobe 挂载新模块以及新模块相依赖的模块,若在载入过程中发生错误，在modprobe会卸载整组的模块。
  * modprobe 命令是根据depmod -a的输出/lib/modules/version/modules.dep来加载全部的所需要模块。
  * modprobe -r  模块名也可以卸载模块
  * rmmod cslunatic_drv.ko 卸载模块
  * dmesg | tail -8 查看输出的末尾8行信息
  */
static int __init CSlunatic_init(void)
{     
    int err = -1;    
    int i = 0;
    dev_t dev = 0;    
    struct device *temp = NULL;    

    printk(KERN_ALERT"Initializing CSlunatic device.\n");        
    printk(KERN_ALERT "int_var %d.\n", int_var);
    printk(KERN_ALERT "str_var %s.\n", str_var);

    for(i = 0; i < narr; i ++){
        printk("int_array[%d] = %d\n", i, int_array[i]);
    }

    if (!CSlunatic_major) {
        /*动态设备号分配*/
        err = alloc_chrdev_region(&dev, 0, 1, CSLUNATIC_DEVICE_NODE_NAME);
        if (!err) {
            CSlunatic_major = MAJOR(dev);
            CSlunatic_minor = MINOR(dev);
        }
    } else {
        /*静态设备号分配*/
        dev = MKDEV(CSlunatic_major, CSlunatic_minor);
        err = register_chrdev_region(dev,1, CSLUNATIC_DEVICE_NODE_NAME);
    }
    if(err < 0) {        
        printk(KERN_ALERT"Failed to alloc char dev region.\n");     
        goto fail;  
    }   
    
    /*分配CSlunatic设备结构体变量*/    
    CSlunatic_dev = kmalloc(sizeof(struct CSlunatic_char_dev), GFP_KERNEL);    
    if(!CSlunatic_dev) {        
        err = -ENOMEM;      
        printk(KERN_ALERT"Failed to alloc CSlunatic_dev.\n");        
        goto unregister;    
    }            

    /*初始化设备*/    
    err = __CSlunatic_setup_dev(CSlunatic_dev);
    if(err) {        
        printk(KERN_ALERT"Failed to setup dev: %d.\n", err);        
        goto cleanup;    
    }            

    /*在/sys/class/目录下创建设备类别目录CSlunatic*/    
    CSlunatic_class = class_create(THIS_MODULE, CSLUNATIC_DEVICE_CLASS_NAME);    
    if(IS_ERR(CSlunatic_class)) {        
        err = PTR_ERR(CSlunatic_class);     
        printk(KERN_ALERT"Failed to create CSlunatic class.\n");        
        goto destroy_cdev;    
    }            

    /* 在/dev/目录和/sys/class/CSlunatic目录下分别创建设备文件CSlunatic* 也可以手工(mknod /dev/fgj c 50 0) 创建设备节点  
　　当使用udev制作的文件系统时，内核为我们提供了一组函数，可以用来在模块加载的时候自动在/dev目录下创建设备文件OR在卸载时自动删除设备文件。
　　主要涉及两个函数
　　class_create(owner, class_name) 
　　用来在sysfs创建一个类，设备信息导出在这下面；
　　struct device *device_create(struct class *class, struct device *parent,
    　　　　　　　　　　　　　　　　dev_t devt, void *drvdata, const char *fmt, ...)
　　用来在/dev目录下创建一个设备文件；
　　加载模块时，用户空间的udev会自动响应device_create()函数，在sysfs下寻找对应的类从而创建设备节点。
　　*/
    temp = device_create(CSlunatic_class, NULL, dev, "%s", CSLUNATIC_DEVICE_FILE_NAME);    
    if(IS_ERR(temp)) {        
        err = PTR_ERR(temp);        
        printk(KERN_ALERT"Failed to create CSlunatic device.");    
        goto destroy_class; 
    }      
    
    /*在/sys/class/CSlunatic/CSlunatic目录下创建属性文件val*/    
    err = device_create_file(temp, &dev_attr_val);    if(err < 0) {        
        printk(KERN_ALERT"Failed to create attribute val.");                        
        goto destroy_device;    
    }    

   /*设置设备的私有数据dev_get_drvdata 获取设备的相关信息
    如果在这里没有设置，也可以在open函数的时候设置*/
    dev_set_drvdata(temp, CSlunatic_dev);            

    /*创建/proc/CSlunatic文件*/    
    CSlunatic_create_proc();    
    
    printk(KERN_ALERT"Succedded to initialize CSlunatic device.\n");    
    
    return 0;
    
 destroy_device:    
    device_destroy(CSlunatic_class, dev);
destroy_class:    
    class_destroy(CSlunatic_class);
destroy_cdev:    
    cdev_del(&(CSlunatic_dev->dev));
cleanup:    
     kfree(CSlunatic_dev) ;
unregister:    
    unregister_chrdev_region(MKDEV(CSlunatic_major, CSlunatic_minor), 1);
fail:    
    return err;
}

/*模块卸载方法*/
static void __exit CSlunatic_exit(void) 
{   
    dev_t devno = MKDEV(CSlunatic_major, CSlunatic_minor);    
    printk(KERN_ALERT"Destroy CSlunatic device.\n");            

    /*删除/proc/CSlunatic文件*/    
    CSlunatic_remove_proc();            

    /*销毁设备类别和设备*/    
    if(CSlunatic_class) {        
        device_destroy(CSlunatic_class, MKDEV(CSlunatic_major, CSlunatic_minor));        
        class_destroy(CSlunatic_class);    
    }            

    /*删除字符设备和释放设备内存*/    
    if(CSlunatic_dev) {        
        cdev_del(&(CSlunatic_dev->dev));        
        kfree(CSlunatic_dev);    
     }            

     /*释放设备号*/    
     unregister_chrdev_region(devno, 1);
}

/*module_init中的初始化函数在系统启动过程中start_kernel()->rest_init()->kernel_init()->do_basic_setup()->do_initcalls()。
    do_initcalls调用.initcall.init节的函数指针，初始化内核模块。
    #define module_init(x) __initcall(x);
    #define __initcall(fn) device_initcall(fn)
    #define device_initcall(fn)           __define_initcall("6",fn)
    看出module_init是设备驱动的初始化，等级为6(也就是初始化的顺序为6)
    #define core_initcall(fn)        __define_initcall("1",fn)
    #define postcore_initcall(fn)        __define_initcall("2",fn)
    #define arch_initcall(fn)        __define_initcall("3",fn)
    #define subsys_initcall(fn)            __define_initcall("4",fn)
    #define fs_initcall(fn)                     __define_initcall("5",fn)
    #define device_initcall(fn)           __define_initcall("6",fn)
    #define late_initcall(fn)         __define_initcall("7",fn)
   */
module_init(CSlunatic_init);
module_exit(CSlunatic_exit);

/*
  * EXPORT_SYMBOL只出现在2.6内核中，在2.4内核默认的非static 函数和变量都会自动导入到kernel 空间的， 都不用EXPORT_SYMBOL() 做标记的。
  * 2.6就必须用EXPORT_SYMBOL() 来导出来（因为2.6默认不到处所有的符号）。
  * EXPORT_SYMBOL标签内定义的函数或者符号对全部内核代码公开，不用修改内核代码就可以在您的内核模块中直接调用，即使用
  * EXPORT_SYMBOL可以将一个函数以符号的方式导出给其他模块使用。
  * 这里要和System.map做一下对比：
  * System.map 中的是连接时的函数地址。连接完成以后，在2.6内核运行过程中，是不知道哪个符号在哪个地址的。
  * EXPORT_SYMBOL的符号，是把这些符号和对应的地址保存起来，在内核运行的过程中，可以找到这些符号对应的地址。而模块在加载过程中，其本质就 
  * 是能动态连接到内核，如果在模块中引用了内核或其它模块的符号，就要EXPORT_SYMBOL这些符号，这样才能找到对应的地址连接。
  * 使用方法
  *     第一、在模块函数定义之后使用EXPORT_SYMBOL（函数名）
  *     第二、在调用该函数的模块中使用extern对之声明
  *     第三、首先加载定义该函数的模块，再加载调用该函数的模块
  *     另外，在编译调用某导出函数的模块时，往往会有WARNING: "＊＊＊＊" [＊＊＊＊＊＊＊＊＊＊] undefined!
  *  使用dmesg 命令后会看到相同的信息。开始我以为只要有这个错误就不能加载模块，后来上网查了一下，
  *  发现这主要是因为在编译连接的时候还没有和内核打交 道，当然找不到symbol了，但是由于你生成的是一个内核模块，
  *   所以ld 不提示error，而是给出一个warning，寄希望于在 insmod的时 候，内核能够把这个symbol连接上。
  */
void CSlunatic_fun(void)  
{  
    printk("CSlunatic_fun \n");  
}  
EXPORT_SYMBOL(CSlunatic_fun);  

/*_GPL版本的宏定义只能使符号对GPL许可的模块可用*/
void CSlunatic_fun_GPL(void)  
{  
    printk("hello wold again\n");  
}  
EXPORT_SYMBOL_GPL(CSlunatic_fun_GPL);  

/* 
  * module_param() 和 module_param_array() 的作用就是让那些全局变量对 insmod 可见，使模块装载时可重新赋值。
  * module_param_array() 宏的第三个参数用来记录用户 insmod 时提供的给这个数组的元素个数，NULL 表示不关心用户提供的个数
  * module_param() 和 module_param_array() 最后一个参数权限值不能包含让普通用户也有写权限，否则编译报错。这点可参考 linux/moduleparam.h 中 __module_param_call() 宏的定义。
  * 通过宏MODULE_PARM_DESC()对参数进行说明
  * 通过宏module_param_array_named()使得内部的数组名与外部的参数名有不同的名字。
  * 通过宏module_param_string()让内核把字符串直接复制到程序中的字符数组内。
  * 字符串数组中的字符串似乎不能包含逗号，否则一个字符串会被解析成两个
  */
module_param(int_var, int, 0644);
MODULE_PARM_DESC(int_var, "A integer variable");

module_param(str_var, charp, 0644);
MODULE_PARM_DESC(str_var, "A string variable");

module_param_array(int_array, int, &narr, 0644);
MODULE_PARM_DESC(int_array, "A integer array");

MODULE_LICENSE("GPL");
MODULE_AUTHOR("CSlunatic");
MODULE_DESCRIPTION("Linux Device Driver");