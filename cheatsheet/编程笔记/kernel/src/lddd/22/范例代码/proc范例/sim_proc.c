/*======================================================================
    A kernel module: simple proc                                               
    This example is to introduce proc fs                          
                                                                        
    The initial developer of the original code is Baohua Song           
    <author@linuxdriver.cn>. All Rights Reserved.                       
======================================================================*/

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
#include <linux/proc_fs.h>

#define atoi(str) simple_strtoul(((str != NULL) ? str : ""), NULL, 0)

static struct proc_dir_entry *proc_entry;
static unsigned long val = 0x12345678;

/* 读/proc文件接口 */
ssize_t simple_proc_read(char *page, char **start, off_t off, int count,
  int*eof, void *data)
{
  int len;
  if (off > 0)
  {
    *eof = 1;
    return 0;
  }

  len = sprintf(page, "%08x\n", val);

  return len;
}

/* 写/proc文件接口 */
ssize_t simple_proc_write(struct file *filp, const char __user *buff, unsigned
  long len, void *data)
{
  #define MAX_UL_LEN 8
  char k_buf[MAX_UL_LEN];
  char *endp;
  unsigned long new;
  int count = min(MAX_UL_LEN, len);
  int ret;

  if (copy_from_user(k_buf, buff, count))
  //用户空间->内核空间
  {
    ret =  - EFAULT;
    goto err;
  }
  else
  {
    new = simple_strtoul(k_buf, &endp, 16); //字符串转化为整数
    if (endp == k_buf)
    //无效的输入参数
    {
      ret =  - EINVAL;
      goto err;
    }
    val = new;
    return count;
  }
  err:
  return ret;
}

int __init simple_proc_init(void)
{
  proc_entry = create_proc_entry("sim_proc", 0666, NULL); //创建/proc
  if (proc_entry == NULL)
  {
    printk(KERN_INFO "Couldn't create proc entry\n");
    goto err;
  }
  else
  {
    proc_entry->read_proc = simple_proc_read;
    proc_entry->write_proc = simple_proc_write;
    proc_entry->owner = THIS_MODULE;
  }
  return 0;
  err:
  return  - ENOMEM;
}

void __exit simple_proc_exit(void)
{
  remove_proc_entry("sim_proc", &proc_root); //撤销/proc
}

module_init(simple_proc_init);
module_exit(simple_proc_exit);

MODULE_AUTHOR("Song Baohua, author@linuxdriver.cn");
MODULE_DESCRIPTION("A simple Module for showing proc");
MODULE_VERSION("V1.0");