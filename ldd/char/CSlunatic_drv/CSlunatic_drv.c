#include <linux/init.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/proc_fs.h>
#include <linux/device.h>
#include <linux/sched.h>
#include <linux/poll.h>
#include <asm/uaccess.h>

#include "cslunatic_drv.h"/*���豸�ʹ��豸�ű���*/

#define DEFAULT_INTERVAL  500
#define MEM_CLEAR 0x1

static int CSlunatic_major = 0;
static int CSlunatic_minor = 0;/*�豸�����豸����*/

static struct class *CSlunatic_class = NULL;
static struct CSlunatic_char_dev *CSlunatic_dev = NULL;/*��ͳ���豸�ļ���������*/

static int int_var = 0;
static const char *str_var = "default";
static int int_array[6];
int narr;

/*��ʱ��������*/
static void CSlunatic_timer_hander(unsigned long args)
{
     int i;
     struct CSlunatic_char_dev *dev;

     printk("%s enter.\n", __func__);
     dev = (struct CSlunatic_char_dev *)args;
     
     /*ͬ������*/    
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
        mod_timer(&dev->timer, jiffies + dev->timer_interval);/*�޸Ķ�ʱ���ĵ���ʱ��*/
   
    up(&(dev->sem));   

    printk("%s leave.\n", __func__);
}

/*���豸����*/
static int CSlunatic_open(struct inode* inode, struct file* filp) 
{    
    struct CSlunatic_char_dev *dev;                

    /*���Զ����豸�ṹ�屣�����ļ�ָ���˽���������У��Ա�����豸ʱ������*/    
    dev = container_of(inode->i_cdev, struct CSlunatic_char_dev, dev);    
    
    init_timer(&dev->timer);/*��ʼ����ʱ��*/
    dev->timer.function = CSlunatic_timer_hander; /*��ʱ����������*/
    dev->timer.expires = jiffies + dev->timer_interval; /*��ʱʱ�䣬*/
    dev->timer.data = (unsigned long)dev; /*���ݸ���ʱ���������������Ĳ���*/
    add_timer(&dev->timer);/*����ʱ���ӵ���ʱ��������*/
    
    filp->private_data = dev;        

    return 0;
}

/*����FASYNC��־���*/
static int CSlunatic_fasync(int fd, struct file *filp, int mode)
{
    struct CSlunatic_char_dev *dev = filp->private_data;

    /*�����豸�Ǽǵ�fasync_queue������ȥ��Ҳ���Դ��б���ɾ��*/
    return fasync_helper(fd, filp, mode, &(dev->async_queue));
}


/*�豸�ļ��ͷ�ʱ����*/
static int CSlunatic_release(struct inode *inode, struct file *filp) 
{    
    struct CSlunatic_char_dev *dev;
    
    dev = (struct CSlunatic_char_dev*)filp->private_data;
    
    del_timer(&dev->timer);

    /*���ļ����첽֪ͨ�б���ɾ��*/
    CSlunatic_fasync(-1, filp, 0);
        
    printk("CSlunatic device close success!\n");
    
    return 0;
}

/*��ȡ�豸�Ļ�������ֵ
   linux�����ж�����local_irq_disable(�����ж�)��local_irq_enable(���ж�)
   linux ��������wait_event_interruptible()(˯��)   wake_up_interruptible() (����)��
   linux������ͬ��down_interruptible()(��ȡ�ź���)  up(�ͷ��ź���)��
   linux�����Ļ���spin_lock(��ȡ������)��spin_unlock(�ͷ�������),
   ���̾�����ҪǶ�׻�����(����������)
   */
static ssize_t CSlunatic_read(struct file* filp, char __user *buf, size_t count, loff_t* f_pos) 
{   
    ssize_t err = 0;    
    struct CSlunatic_char_dev *dev = filp->private_data;            

  
    /*ͬ������
       ����ȡ�ź����ɹ�ʱ�����ź�����ֵ��һ��else��ʾ��ȡ�ź���ʧ�ܣ���ʱ���̽���˯��״̬�������˽��̲��뵽�ȴ�����β��
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
        
         /*Ϊ�˽�������һ�ְ�ȫ�ķ�ʽ�������ߣ�������Ҫ�μ���������
             һ����Զ��Ҫ��ԭ���������н������ߡ�
             �����������ߺ󣬶Ի���һ����֪�����Ѻ󣬱����ٴμ����ȷ�����ǵȴ�����������Ϊ�������
       */
        /*����Ϊ�棬��ǰ���̵�״̬���ó�TASK_INTERRUPTIBLE��Ȼ�����schedule()��
           ��schedule()�Ὣλ��TASK_INTERRUPTIBLE״̬�ĵ�ǰ���̴�runqueue ������ɾ����
           ��runqueue������ɾ���Ľ���ǣ���ǰ������̽����ٲ� ����ȣ�����ͨ����������������������·������runqueue������
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

    /*��������buf��ֵ�������û��ṩ�Ļ�����*/   
    if(copy_to_user(buf, dev->buf,  count)){      
        err = -EFAULT;      
        goto out;   
     }   
    
    wake_up_interruptible(&dev->w_wait);

    /*�����첽���ź�
    ��������������Ҫ�ĵط��������жϣ���������Ĵ���,�ͻ���fasync_queue��������豸����SIGIO
   �źţ�Ӧ�ó����յ��źţ�ִ�д������
   ע��, һЩ�豸��ʵ���첽֪ͨ��ָʾ���豸�ɱ�д��ʱ; ��������, 
   ��Ȼ, kill_fasnyc ���뱻ʹ��һ�� POLL_OUT ģʽ������.*/
    if(dev->async_queue)
        kill_fasync(&(dev->async_queue), SIGIO, POLL_IN);/*�ͷ��ź��õĺ���*/
    
    err = count;
    
 out: 
    up(&(dev->sem));   
    return err;
}

/*д�豸�Ļ�����buf*/
static ssize_t CSlunatic_write(struct file* filp, const char __user *buf, size_t count, loff_t* f_pos) 
{    
    struct CSlunatic_char_dev *dev = filp->private_data;    
    ssize_t err = 0;            

    /*ͬ������*/    
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
    
    /*���û��ṩ�Ļ�������ֵд���豸�Ĵ���ȥ*/    
    if(copy_from_user(dev->buf + dev->current_len, buf, count)) {    
        err = -EFAULT;        
        goto out;    
    }
    
    dev->current_len += count;
    
    /*����Ϊ�棬����Ҫ���ѽ���*/
   wake_up_interruptible(&(dev->r_wait));
   
    err = count;
    
out:    
    up(&(dev->sem));    
    return err;
}

/*������ioctlʵ��*/
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

/*��������ʱ����ѯ����*/
static unsigned int CSlunatic_poll(struct file *filp, poll_table *wait)
{
    unsigned int mask = 0;
    struct CSlunatic_char_dev *dev = filp->private_data;  // ����豸�ṹָ��

   if( down_interruptible(&(dev->sem)));
        return -ERESTARTSYS;

    /*���������仰��Ϊ���ڶ�д״̬�����仯��ʱ��֪ͨ���Ĳ㣬�ú��Ĳ����µ���poll������ѯ��Ϣ��
    Ҳ����˵������ֻ����select������ʱ���õ���������select�������ּȲ��ܶ��ֲ���дʱ��select
    ���������������Ǵ�ʱ��������������ѯ������˯�ߣ�ͨ�������������з����仯ʱ֪ͨselect*/
    poll_wait(filp, &dev->r_wait, wait);  // �Ӷ��ȴ�����ͷ
    poll_wait(filp, &dev->w_wait, wait);  // ��д�ȴ�����ͷ
   
    if(dev->current_len != 0)  // �ɶ�
    {
        mask |= POLLIN | POLLRDNORM;  // ��ʾ���ݿɻ��
    }
   
    if(dev->current_len != MAX_FIFO_BUF)  // ��д
    {
        mask |= POLLOUT | POLLWRNORM;  // ��ʾ���ݿ�д��
    }

    up(&(dev->sem));
    
    return mask;
}

/*��ȡ�Ĵ���val��ֵ��������buf�У��ڲ�ʹ��*/
static ssize_t __CSlunatic_get_val(struct CSlunatic_char_dev *dev, char *buf) 
{    
    int val = 0;            

    /*ͬ������*/    
    if(down_interruptible(&(dev->sem))) {                        
        return -ERESTARTSYS;     
    }            

    val = dev->val;            

    up(&(dev->sem));            

    return snprintf(buf, PAGE_SIZE, "%d\n", val);
}

/*�ѻ�����buf��ֵд���豸�Ĵ���val��ȥ���ڲ�ʹ��*/
static ssize_t __CSlunatic_set_val(struct CSlunatic_char_dev *dev, const char *buf, size_t count) 
{    
    int val = 0;            

    /*���ַ���ת��������*/            
    val = simple_strtol(buf, NULL, 10);

    /*�@�������Ĺ��ܾ��ǻ���ź���������ò����ź�����˯�ߣ��˕r�]����̖����ϣ���ô��
     ��˯�ߡ�������˯�߹����п��ܱ��ź�����ϣ����֮�󷵻�-EINTR����Ҫ�������̼�Ļ���ͬ����
     ʹ�ÿɱ��жϵ��ź����汾����˼�ǣ���һ���F��semaphore�����������л�����ctrl+c�������жϣ�
     �õȴ�����ȴ��ں��������ص����û�̬�����˳��������ǰ�����ϵ�y����ס�ˡ�*/            
    if(down_interruptible(&(dev->sem))) {                        
        return -ERESTARTSYS;            
    }            

    dev->val = val;            

    up(&(dev->sem));    

    return count;
}

/*��ȡ�豸�Ĵ���val��ֵ��������page��������*/
static ssize_t CSlunatic_proc_read(char *page, char **start, off_t off, int count, int *eof, void *data) 
{    
    if(off > 0) {        
        *eof = 1;      
        return 0;   
    }   

    return __CSlunatic_get_val(CSlunatic_dev, page);
}

/*�ѻ�������ֵbuff���浽�豸�Ĵ���val��ȥ*/
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
    
     /*�Ȱ��û��ṩ�Ļ�����ֵ�������ں˻�������ȥ*/    
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

/*��ȡ�豸����val*/
static ssize_t CSlunatic_val_show(struct device *dev, struct device_attribute *attr, char *buf)
{    
    struct CSlunatic_char_dev* hdev = (struct CSlunatic_char_dev*)dev_get_drvdata(dev);       
    
    return __CSlunatic_get_val(hdev, buf);
}

/*д�豸����val*/
static ssize_t CSlunatic_val_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) 
{     
    struct CSlunatic_char_dev *hdev = (struct CSlunatic_char_dev*)dev_get_drvdata(dev);          

    return __CSlunatic_set_val(hdev, buf, count);
}

/*������DEVICE_ATTR�ڷ�װ����__ATTR(_name,_mode,_show,_stroe)������_show��ʾ���Ƕ�������_stroe��ʾ����д������
sysfs�ӿ�*/
static DEVICE_ATTR(val, S_IRUGO | S_IWUSR, CSlunatic_val_show, CSlunatic_val_store);

/*����/proc/CSlunatic�ļ�*/
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

/*ɾ��/proc/CSlunatic�ļ�*/
static void CSlunatic_remove_proc(void) 
{    
    remove_proc_entry(CSLUNATIC_DEVICE_PROC_NAME, NULL);
}

/*�����������Է���*/
static struct file_operations CSlunatic_fops = {    
    .owner = THIS_MODULE,
    .open = CSlunatic_open, 
    .release = CSlunatic_release,   
    .read = CSlunatic_read, 
    .write = CSlunatic_write,
    .unlocked_ioctl = CSlunatic_ioctl,/*��kernel 2.6.37 ���Ѿ���ȫɾ����struct file_operations �е�ioctl ����ָ�룬ȡ����֮����unlocked_ioctl */
    .fasync = CSlunatic_fasync,
    .poll = CSlunatic_poll,
};

/*��ʼ���豸*/
static int  __CSlunatic_setup_dev(struct CSlunatic_char_dev *dev) 
{    
    int err;    
    
    dev_t devno = MKDEV(CSlunatic_major, CSlunatic_minor);    

    /*���cdev û�з���ռ䣬���Ե���cdev_alloc������ռ�*/
    memset(dev, 0, sizeof(struct CSlunatic_char_dev));    

    cdev_init(&(dev->dev), &CSlunatic_fops);    
    dev->dev.owner = THIS_MODULE;    
    dev->dev.ops = &CSlunatic_fops;            

    /*ע���ַ��豸*/    
    err = cdev_add(&(dev->dev),devno, 1);    
    if(err) {        
        return err;    
    }            

    /*��ʼ���ź���
        linux 2.6.37 û��init_MUTEX()����
        #define init_MUTEX(sem)                  sema_init(sem, 1)*/
    sema_init(&(dev->sem), 1);    

    /*��ʼ���ȴ�����*/
    init_waitqueue_head(&(dev->r_wait));
    init_waitqueue_head(&(dev->w_wait));
    
    /*�Ĵ���val��ֵ*/
    dev->val = 0;    

    /*��ʱ�����10 S*/
    dev->timer_interval = 10 * HZ;
    
    return 0;
}

/*ģ����ط���  insmod cslunatic_drv.ko int_var=100 str_var=hello int_array=100,200
  * modinfo cslunatic_drv.ko �鿴ģ����Ϣ
  * lsmod �鿴�Ѽ��ص�ģ��
  * modprobe ������ģ���Լ���ģ����������ģ��,������������з���������modprobe��ж�������ģ�顣
  * modprobe �����Ǹ���depmod -a�����/lib/modules/version/modules.dep������ȫ��������Ҫģ�顣
  * modprobe -r  ģ����Ҳ����ж��ģ��
  * rmmod cslunatic_drv.ko ж��ģ��
  * dmesg | tail -8 �鿴�����ĩβ8����Ϣ
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
        /*��̬�豸�ŷ���*/
        err = alloc_chrdev_region(&dev, 0, 1, CSLUNATIC_DEVICE_NODE_NAME);
        if (!err) {
            CSlunatic_major = MAJOR(dev);
            CSlunatic_minor = MINOR(dev);
        }
    } else {
        /*��̬�豸�ŷ���*/
        dev = MKDEV(CSlunatic_major, CSlunatic_minor);
        err = register_chrdev_region(dev,1, CSLUNATIC_DEVICE_NODE_NAME);
    }
    if(err < 0) {        
        printk(KERN_ALERT"Failed to alloc char dev region.\n");     
        goto fail;  
    }   
    
    /*����CSlunatic�豸�ṹ�����*/    
    CSlunatic_dev = kmalloc(sizeof(struct CSlunatic_char_dev), GFP_KERNEL);    
    if(!CSlunatic_dev) {        
        err = -ENOMEM;      
        printk(KERN_ALERT"Failed to alloc CSlunatic_dev.\n");        
        goto unregister;    
    }            

    /*��ʼ���豸*/    
    err = __CSlunatic_setup_dev(CSlunatic_dev);
    if(err) {        
        printk(KERN_ALERT"Failed to setup dev: %d.\n", err);        
        goto cleanup;    
    }            

    /*��/sys/class/Ŀ¼�´����豸���Ŀ¼CSlunatic*/    
    CSlunatic_class = class_create(THIS_MODULE, CSLUNATIC_DEVICE_CLASS_NAME);    
    if(IS_ERR(CSlunatic_class)) {        
        err = PTR_ERR(CSlunatic_class);     
        printk(KERN_ALERT"Failed to create CSlunatic class.\n");        
        goto destroy_cdev;    
    }            

    /* ��/dev/Ŀ¼��/sys/class/CSlunaticĿ¼�·ֱ𴴽��豸�ļ�CSlunatic* Ҳ�����ֹ�(mknod /dev/fgj c 50 0) �����豸�ڵ�  
������ʹ��udev�������ļ�ϵͳʱ���ں�Ϊ�����ṩ��һ�麯��������������ģ����ص�ʱ���Զ���/devĿ¼�´����豸�ļ�OR��ж��ʱ�Զ�ɾ���豸�ļ���
������Ҫ�漰��������
����class_create(owner, class_name) 
����������sysfs����һ���࣬�豸��Ϣ�����������棻
����struct device *device_create(struct class *class, struct device *parent,
    ��������������������������������dev_t devt, void *drvdata, const char *fmt, ...)
����������/devĿ¼�´���һ���豸�ļ���
��������ģ��ʱ���û��ռ��udev���Զ���Ӧdevice_create()��������sysfs��Ѱ�Ҷ�Ӧ����Ӷ������豸�ڵ㡣
����*/
    temp = device_create(CSlunatic_class, NULL, dev, "%s", CSLUNATIC_DEVICE_FILE_NAME);    
    if(IS_ERR(temp)) {        
        err = PTR_ERR(temp);        
        printk(KERN_ALERT"Failed to create CSlunatic device.");    
        goto destroy_class; 
    }      
    
    /*��/sys/class/CSlunatic/CSlunaticĿ¼�´��������ļ�val*/    
    err = device_create_file(temp, &dev_attr_val);    if(err < 0) {        
        printk(KERN_ALERT"Failed to create attribute val.");                        
        goto destroy_device;    
    }    

   /*�����豸��˽������dev_get_drvdata ��ȡ�豸�������Ϣ
    ���������û�����ã�Ҳ������open������ʱ������*/
    dev_set_drvdata(temp, CSlunatic_dev);            

    /*����/proc/CSlunatic�ļ�*/    
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

/*ģ��ж�ط���*/
static void __exit CSlunatic_exit(void) 
{   
    dev_t devno = MKDEV(CSlunatic_major, CSlunatic_minor);    
    printk(KERN_ALERT"Destroy CSlunatic device.\n");            

    /*ɾ��/proc/CSlunatic�ļ�*/    
    CSlunatic_remove_proc();            

    /*�����豸�����豸*/    
    if(CSlunatic_class) {        
        device_destroy(CSlunatic_class, MKDEV(CSlunatic_major, CSlunatic_minor));        
        class_destroy(CSlunatic_class);    
    }            

    /*ɾ���ַ��豸���ͷ��豸�ڴ�*/    
    if(CSlunatic_dev) {        
        cdev_del(&(CSlunatic_dev->dev));        
        kfree(CSlunatic_dev);    
     }            

     /*�ͷ��豸��*/    
     unregister_chrdev_region(devno, 1);
}

/*module_init�еĳ�ʼ��������ϵͳ����������start_kernel()->rest_init()->kernel_init()->do_basic_setup()->do_initcalls()��
    do_initcalls����.initcall.init�ڵĺ���ָ�룬��ʼ���ں�ģ�顣
    #define module_init(x) __initcall(x);
    #define __initcall(fn) device_initcall(fn)
    #define device_initcall(fn)           __define_initcall("6",fn)
    ����module_init���豸�����ĳ�ʼ�����ȼ�Ϊ6(Ҳ���ǳ�ʼ����˳��Ϊ6)
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
  * EXPORT_SYMBOLֻ������2.6�ں��У���2.4�ں�Ĭ�ϵķ�static �����ͱ��������Զ����뵽kernel �ռ�ģ� ������EXPORT_SYMBOL() ����ǵġ�
  * 2.6�ͱ�����EXPORT_SYMBOL() ������������Ϊ2.6Ĭ�ϲ��������еķ��ţ���
  * EXPORT_SYMBOL��ǩ�ڶ���ĺ������߷��Ŷ�ȫ���ں˴��빫���������޸��ں˴���Ϳ����������ں�ģ����ֱ�ӵ��ã���ʹ��
  * EXPORT_SYMBOL���Խ�һ�������Է��ŵķ�ʽ����������ģ��ʹ�á�
  * ����Ҫ��System.map��һ�¶Աȣ�
  * System.map �е�������ʱ�ĺ�����ַ����������Ժ���2.6�ں����й����У��ǲ�֪���ĸ��������ĸ���ַ�ġ�
  * EXPORT_SYMBOL�ķ��ţ��ǰ���Щ���źͶ�Ӧ�ĵ�ַ�������������ں����еĹ����У������ҵ���Щ���Ŷ�Ӧ�ĵ�ַ����ģ���ڼ��ع����У��䱾�ʾ� 
  * ���ܶ�̬���ӵ��ںˣ������ģ�����������ں˻�����ģ��ķ��ţ���ҪEXPORT_SYMBOL��Щ���ţ����������ҵ���Ӧ�ĵ�ַ���ӡ�
  * ʹ�÷���
  *     ��һ����ģ�麯������֮��ʹ��EXPORT_SYMBOL����������
  *     �ڶ����ڵ��øú�����ģ����ʹ��extern��֮����
  *     ���������ȼ��ض���ú�����ģ�飬�ټ��ص��øú�����ģ��
  *     ���⣬�ڱ������ĳ����������ģ��ʱ����������WARNING: "��������" [��������������������] undefined!
  *  ʹ��dmesg �����ῴ����ͬ����Ϣ����ʼ����ΪֻҪ���������Ͳ��ܼ���ģ�飬������������һ�£�
  *  ��������Ҫ����Ϊ�ڱ������ӵ�ʱ��û�к��ں˴� ������Ȼ�Ҳ���symbol�ˣ��������������ɵ���һ���ں�ģ�飬
  *   ����ld ����ʾerror�����Ǹ���һ��warning����ϣ������ insmod��ʱ ���ں��ܹ������symbol�����ϡ�
  */
void CSlunatic_fun(void)  
{  
    printk("CSlunatic_fun \n");  
}  
EXPORT_SYMBOL(CSlunatic_fun);  

/*_GPL�汾�ĺ궨��ֻ��ʹ���Ŷ�GPL��ɵ�ģ�����*/
void CSlunatic_fun_GPL(void)  
{  
    printk("hello wold again\n");  
}  
EXPORT_SYMBOL_GPL(CSlunatic_fun_GPL);  

/* 
  * module_param() �� module_param_array() �����þ�������Щȫ�ֱ����� insmod �ɼ���ʹģ��װ��ʱ�����¸�ֵ��
  * module_param_array() ��ĵ���������������¼�û� insmod ʱ�ṩ�ĸ���������Ԫ�ظ�����NULL ��ʾ�������û��ṩ�ĸ���
  * module_param() �� module_param_array() ���һ������Ȩ��ֵ���ܰ�������ͨ�û�Ҳ��дȨ�ޣ�������뱨�����ɲο� linux/moduleparam.h �� __module_param_call() ��Ķ��塣
  * ͨ����MODULE_PARM_DESC()�Բ�������˵��
  * ͨ����module_param_array_named()ʹ���ڲ������������ⲿ�Ĳ������в�ͬ�����֡�
  * ͨ����module_param_string()���ں˰��ַ���ֱ�Ӹ��Ƶ������е��ַ������ڡ�
  * �ַ��������е��ַ����ƺ����ܰ������ţ�����һ���ַ����ᱻ����������
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