< second.c >
#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <asm/io.h>
#include <asm/system.h>
#include <asm/uaccess.h>
#define SECOND_MAJOR 248    /*?€¨¦¨¨¦Ì?second¦Ì??¡Â¨¦¨¨¡À?o?*/                       
                                                                             
static int second_major = SECOND_MAJOR;                                      
                                                                             
/*second¨¦¨¨¡À??¨¢11¨¬?*/                                                         
struct second_dev {                                                          
  struct cdev cdev; /*cdev?¨¢11¨¬?*/                                           
  atomic_t counter;/* ¨°?12?-¨¤¨²¨¢??¨¤¨¦¨´??¡ê?*/                                   
  struct timer_list s_timer; /*¨¦¨¨¡À?¨°a¨º1¨®?¦Ì???¨º¡À?¡Â*/                          
};                                                                           
                                                                             
struct second_dev *second_devp; /*¨¦¨¨¡À??¨¢11¨¬?????*/                           
                                                                             
/*??¨º¡À?¡Â??¨¤¨ªo¡¥¨ºy*/                                                           
static void second_timer_handle(unsigned long arg)                           
{                                                                            
  mod_timer(&second_devp->s_timer,jiffies + HZ);                             
  atomic_inc(&second_devp->counter);                                         
                                                                             
  printk(KERN_NOTICE "current jiffies is %ld\n", jiffies);                   
}                                                                            
                                                                             
/*???t?¨°?ao¡¥¨ºy*/                                                             
int second_open(struct inode *inode, struct file *filp)                      
{                                                                            
  /*3?¨º??¡¥??¨º¡À?¡Â*/                                                           
  init_timer(&second_devp->s_timer);                                         
  second_devp->s_timer.function = &second_timer_handle;                      
  second_devp->s_timer.expires = jiffies + HZ;                               
                                                                             
  add_timer(&second_devp->s_timer); /*¨¬¨ª?¨®¡ê?¡Á¡é2¨¢¡ê???¨º¡À?¡Â*/                   
                                                                             
  atomic_set(&second_devp->counter,0); //??¨ºy??0                             
                                                                             
  return 0;                                                                  
}                                                                            
/*???t¨º¨ª¡¤?o¡¥¨ºy*/                                                             
int second_release(struct inode *inode, struct file *filp)                   
{                                                                            
  del_timer(&second_devp->s_timer);                                          
                                                                             
  return 0;                                                                  
}                                                                            
                                                                             
/*?¨¢o¡¥¨ºy*/                                                                   
static ssize_t second_read(struct file *filp, char __user *buf, size_t count,
  loff_t *ppos)                                                              
{                                                                            
  int counter;                                                               
                                                                             
  counter = atomic_read(&second_devp->counter);                              
  if(put_user(counter, (int*)buf))                                           
  	return - EFAULT;                                                         
  else                                                                       
  	return sizeof(unsigned int);                                             
}                                                                            
                                                                             
/*???t2¨´¡Á¡Â?¨¢11¨¬?*/                                                           
static const struct file_operations second_fops = {                          
  .owner = THIS_MODULE,                                                      
  .open = second_open,                                                       
  .release = second_release,                                                 
  .read = second_read,                                                       
};                                                                           
                                                                             
/*3?¨º??¡¥2¡é¡Á¡é2¨¢cdev*/                                                         
static void second_setup_cdev(struct second_dev *dev, int index)             
{                                                                            
  int err, devno = MKDEV(second_major, index);                               
                                                                             
  cdev_init(&dev->cdev, &second_fops);                                       
  dev->cdev.owner = THIS_MODULE;                                             
  err = cdev_add(&dev->cdev, devno, 1);                                      
  if (err)                                                                   
    printk(KERN_NOTICE "Error %d adding LED%d", err, index);                 
}                                                                            
                                                                             
/*¨¦¨¨¡À??y?¡¥?¡ê?¨¦?¨®??o¡¥¨ºy*/                                                     
int second_init(void)                                                        
{                                                                            
  int ret;                                                                   
  dev_t devno = MKDEV(second_major, 0);                                      
                                                                             
  /* ¨¦¨º??¨¦¨¨¡À?o?*/                                                            
  if (second_major)                                                          
    ret = register_chrdev_region(devno, 1, "second");                        
  else { /* ?¡¥¨¬?¨¦¨º??¨¦¨¨¡À?o? */                                                
    ret = alloc_chrdev_region(&devno, 0, 1, "second");                       
    second_major = MAJOR(devno);                                             
  }                                                                          
  if (ret < 0)                                                               
    return ret;                                                              
  /* ?¡¥¨¬?¨¦¨º??¨¦¨¨¡À??¨¢11¨¬?¦Ì??¨²??*/                                              
  second_devp = kmalloc(sizeof(struct second_dev), GFP_KERNEL);              
  if (!second_devp) {   /*¨¦¨º??¨º¡ì¡ã¨¹*/                                         
    ret =  - ENOMEM;                                                         
    goto fail_malloc;                                                        
  }                                                                          
  memset(second_devp, 0, sizeof(struct second_dev));                         
  second_setup_cdev(second_devp, 0);                                         
  return 0;                                                                  
fail_malloc:
  unregister_chrdev_region(devno, 1);
  return ret;                           
}                                                                            
/*?¡ê?¨¦D???o¡¥¨ºy*/                                                             
void second_exit(void)                                                       
{                                                                            
  cdev_del(&second_devp->cdev);   /*¡Á¡é?¨²cdev*/                               
  kfree(second_devp);     /*¨º¨ª¡¤?¨¦¨¨¡À??¨¢11¨¬??¨²??*/                             
  unregister_chrdev_region(MKDEV(second_major, 0), 1); /*¨º¨ª¡¤?¨¦¨¨¡À?o?*/        
}                                                                            
                                                                             
MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");                             
MODULE_LICENSE("Dual BSD/GPL");                                              
                                                                             
module_param(second_major, int, S_IRUGO);                                    
                                                                             
module_init(second_init);                                                    
module_exit(second_exit);                                                    
