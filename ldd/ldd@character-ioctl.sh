ioctl(interface)
{

------ ioctl ------
1、除了读取和写入设备之外，大部分驱动程序还需要另外一种能力，即通过设备驱动程序执行各种类型的硬件控制。  --- ioctl
   1. 请求设备锁门
   2. 弹出介质
   3. 报告错误信息
   4. 改变波特率
   5. 执行自破坏
int ioctl(int fd, unsigned long cmd, ...);  ioctl调用的非结构本质导致众多内核开发者倾向于放弃它。
...：通常表示可变数目的参数表。
	系统调用不会真正可变数目的参数，而是必须具有精确定义的原型，这是因为用户程序只能通过硬件"门"才能访问它们。所以，
	原型中的这些点数目不确定的一串参数，而只是一个可选参数。
	习惯上用char *argp定义，这里用点只是为了在编译时防止编译器进行类型检查。
   
int (*ioctl)(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);

从任何一个系统调用返回时，正的返回值是是受保护的；而负值则被认为是一个错误，并被用来设置用户空间中的errno变量。
## 实际上，当前使用的所有libc实现认为错误范围在-4095~-1之间，不幸的是，返回大的负错误号而不是小的错误号并不十分有用。


}

ioctl(cmd)
{
------ 选择ioctl命令 ------
-EINVAL
cmd字段： 高8位是与设备相关的"幻数"；低8位是一个序列号码，在设备内是唯一的。 include/asm/ioctl.h  documentation/ioctl-number.txt

type：幻数。选择一个号码(记住先仔细阅读ioctl-number.txt)，并在整个驱动程序用这个号码。8位宽(__IOC_TYPEBITS)
number:顺序(顺序编号)。它由8位宽(__IOC_NRBITS).
direction：如果相关命令涉及到数据传输，则该位字段定义数据传输方向。 __IOC_READ __IOC_WRITE __IOC_NONE
size: 所涉及的用户数据大小，这个字段的宽度与体系结构相关，通常是13位或14位。 __IOC_SIZEBITS

linux/ioctl.h  asm/ioctl.h
组
__IO(type, nr)            用于构造无参数的命令编号
__IOR(type, nr, datatype) 用于构造从驱动程序中读取数据的命令编号
__IOW(type, nr, datatype) 用于构造写入数据的命令
__IOWR(type, nr, datatype) 用于构造双向数据传输
解
__IOC_DIR(nr)
__IOC_TYPE(nr)
__IOC_NR(nr)
__IOC_SIZE(nr)
}


-------------- scull 例子 --------------
/*
 * Ioctl definitions
 */

/* Use 'k' as magic number */
#define SCULL_IOC_MAGIC  'k'
/* Please use a different 8-bit number in your code */

#define SCULL_IOCRESET    _IO(SCULL_IOC_MAGIC, 0)

/*
 * S means "Set" through a ptr,
 * T means "Tell" directly with the argument value
 * G means "Get": reply by setting through a pointer
 * Q means "Query": response is on the return value
 * X means "eXchange": switch G and S atomically
 * H means "sHift": switch T and Q atomically
 */
#define SCULL_IOCSQUANTUM _IOW(SCULL_IOC_MAGIC,  1, int)
#define SCULL_IOCSQSET    _IOW(SCULL_IOC_MAGIC,  2, int)
#define SCULL_IOCTQUANTUM _IO(SCULL_IOC_MAGIC,   3)
#define SCULL_IOCTQSET    _IO(SCULL_IOC_MAGIC,   4)
#define SCULL_IOCGQUANTUM _IOR(SCULL_IOC_MAGIC,  5, int)
#define SCULL_IOCGQSET    _IOR(SCULL_IOC_MAGIC,  6, int)
#define SCULL_IOCQQUANTUM _IO(SCULL_IOC_MAGIC,   7)
#define SCULL_IOCQQSET    _IO(SCULL_IOC_MAGIC,   8)
#define SCULL_IOCXQUANTUM _IOWR(SCULL_IOC_MAGIC, 9, int)
#define SCULL_IOCXQSET    _IOWR(SCULL_IOC_MAGIC,10, int)
#define SCULL_IOCHQUANTUM _IO(SCULL_IOC_MAGIC,  11)
#define SCULL_IOCHQSET    _IO(SCULL_IOC_MAGIC,  12)

/*
 * The other entities only have "Tell" and "Query", because they're
 * not printed in the book, and there's no need to have all six.
 * (The previous stuff was only there to show different ways to do it.
 */
#define SCULL_P_IOCTSIZE _IO(SCULL_IOC_MAGIC,   13)
#define SCULL_P_IOCQSIZE _IO(SCULL_IOC_MAGIC,   14)
/* ... more to come */

#define SCULL_IOC_MAXNR 14

------ 返回值 ------
命令号不匹配： -ENVAl(共识) 或 -ENOTTY(POSIX)

------ 预定义命令 ------
1. 可用于任何文件的命令
2. 只用于普通文件的命令
3. 特定于文件系统类型的命令

FIOCLEX：设置执行时关闭标识(File IOctl Close on EXec).设置了这个标识之后，当调用进程执行一个新进程是，文件描述符将被关闭
FIONCLEX：清除执行时关闭标识(File IOctl Not Close on EXec)该命令将恢复通常的文件行为，并撤销上述FIOCLEX命令所作的工作。
FIOASYNC：设置或复位文件异步通知。注意这道Linux 2.2.4版本的内核都不正确地使用了这个命令来修改O_SYNC标识。
FIOQSIZE：返回文件或目录的大小，不过用于设备文件时，会导致ENOTTY错误的返回。
FIONBIO：File IOctl Non-Blocking IO

当Unix的开发人员面对控制IO操作的问题时，我们认为文件和设备是不同的。那时，与ioctl实现相关的唯一设备就是终端，
这也解释了为什么非法的ioctl命令的标准返回值是-ENOTTY。现在情况虽然不同了，但是fcntl还是为了向后兼容而保留了下来。

------ 使用ioctl参数 ------
asm/uaccess.h
int access_ok(int type, congst void *addr, unsigned long size);
type: VERIFY_READ 或 VERIFY_WRITE，取决于要执行的动作是读取还是写入用户空间内存区。
addr：用户空间地址
size：字节数
返回值：1标识成功，0标识失败。如果需要返回，返回-EFAULT.


------ 全能和受限 ------
capget
capset
CAP_DAC_OVERRIDE, CAP_NET_ADMIN, CAP_SYS_MODULE, CAP_SYS_RAWIO, CAP_SYS_ADMIN, CAP_SYS_TTY_CONFIG
sys/sched.h
int capable(int capability);

------ 非ioctl的设备控制 ------
设备控制：图形显示。




