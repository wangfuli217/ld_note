/*======================================================================
    A kernel module: oops example                                               
    This example is to introduce how to debug according to oops                          
                                                                        
    The initial developer of the original code is Baohua Song           
    <author@linuxdriver.cn>. All Rights Reserved.                       
======================================================================*/
#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <asm/uaccess.h>

#define MAJOR_NUM  251   //���豸��

static ssize_t oopsexam_read(struct file *, char *, size_t, loff_t*);
static ssize_t oopsexam_write(struct file *, const char *, size_t, loff_t*);

//��ʼ���ַ��豸������file_operations�ṹ��
struct file_operations oopsexam_fops =
{
  read: oopsexam_read, write: oopsexam_write,
};

static int __init oopsexam_init(void)
{
  int ret;

  //ע���豸����
  ret = register_chrdev(MAJOR_NUM, "oopsexam", &oopsexam_fops);
  if (ret)
  {
    printk("oopsexam register failure");
  }
  else
  {
    printk("oopsexam register success");
  }
  return ret;
}

static void __exit oopsexam_exit(void)
{
  int ret;

  //ע���豸����
  ret = unregister_chrdev(MAJOR_NUM, "oopsexam");
  if (ret)
  {
    printk("oopsexam unregister failure");
  }
  else
  {
    printk("oopsexam unregister success");
  }
}

static ssize_t oopsexam_read(struct file *filp, char *buf, size_t len, loff_t *off)
{
  int *p=0;  
  *p  = 1;  //create oops
  return len;
}

static ssize_t oopsexam_write(struct file *filp, const char *buf, size_t len, loff_t
  *off)
{
  int *p=0;  
  *p  = 1;    //create oops
  return len;
}

module_init(oopsexam_init);
module_exit(oopsexam_exit);


MODULE_AUTHOR("Song Baohua");
MODULE_LICENSE("Dual BSD/GPL");
