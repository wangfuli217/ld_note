/********************************************** 
 * Author: lewiyon@hotmail.com 
 * File name: proc_sample.c 
 * Description: create a file "proc_example" in the /proc,  
 *              which allows read. 
 * Date: 2011-12-11 
 * Version: V1.0 
 *********************************************/  
  
#include <linux/kernel.h> /* We're doing kernel work */  
#include <linux/module.h> /* Specifically, a module */  
#include <linux/proc_fs.h>    /* Necessary because we use proc fs */  
#include <asm/uaccess.h>  /* for get_user and put_user */  
  
#define MESSAGE_LENGTH 80  
#define PROC_NAME "proc_sample"  
  
unsigned int flag = 100;   
  
static struct proc_dir_entry *proc_sample;  
static struct proc_dir_entry *sample, *sample_r;  
  
/** 
 * proc_read_data() 
 * @page - buffer to write the data in 
 * @start - where the actual data has been written in page 
 * @offset - same meaning as the read system call 
 * @count - same meaning as the read system call 
 * @eof - set if no more data needs to be returned 
 * @data - pointer to our soft state 
 */  
static int proc_read_data(char *page, char **stat, off_t off,  
                          int count, int *eof, void *data)  
{  
    int len;  
    len = sprintf(page, "jiffies = %ld\n", jiffies);  
    return len;  
}  
  
/*  
 * 模块初始化  
 */  
static int __init sample_init(void)  
{     
    int ret = 0;  
      
    /* 
     * proc_mkdir(name, parent) 
     * 在parent对应的目录下创建name目录 
     * 返回目录对应的proc_dir_dentry 
     */  
    proc_sample = proc_mkdir(PROC_NAME, NULL);    
    if (NULL == proc_sample) {  
        ret = -ENOMEM;    
        goto proc_sample_err;  
    }  
    /* 
     * create_proc_entry(name, mode,parent) 
     * 在parent对应的目录下创建name文件 
     * 返回目录对应的proc_dir_dentry 
     */  
    sample = create_proc_entry("sample", 0644, proc_sample);      
    if (NULL == sample) {  
        ret = -ENOMEM;    
        goto sample_err;  
    }  
      
    sample_r = create_proc_read_entry("sample_r", 0444,   
                proc_sample, proc_read_data, NULL);   
    if (NULL == sample_r) {  
        ret = -ENOMEM;    
        goto sample_r_err;  
    }  
  
    printk(KERN_INFO "Create sample\n");   
    return ret;  
  
sample_r_err:  
    remove_proc_entry("sample", proc_sample);  
sample_err:  
    remove_proc_entry(PROC_NAME, NULL);  
proc_sample_err:  
    return ret;  
}  
  
/* 
 * 模块清理 
 */  
static void __exit sample_exit(void)  
{  
    remove_proc_entry("sample", proc_sample);  
    remove_proc_entry("sample_r", proc_sample);  
    remove_proc_entry(PROC_NAME, NULL);  
    printk(KERN_INFO "Remove /proc/proc_sample\n");  
}  
  
module_init(sample_init);  
module_exit(sample_exit);  
MODULE_LICENSE("GPL");  
MODULE_AUTHOR("lewiyon <lewiyon@hotmail.com>");