/proc/devices 可以查看注册的主设备号；                      ---- /dev/
/proc/modules 可以查看正在使用模块的进程数。
/lib/modules/2.4.XX目录，下面就是针对当前内核版本的模块。
/etc/modules.conf文件，定义了一些常用设备的别名。          mknod会利用此文件提供的别名，命名驱动程序提供的设备名。
                                                           insmod会利用提供的参数，给模块提供指定配置
现代的Linux内核允许多个驱动程序共享主设备号，但我们看到的仍然按照”一 个主设备号对应一个驱动程序“的原则组织。

cdev(字段说明)
{
struct kobject kobj;//内嵌的kobject对象   
struct module *owner;//所属模块   
struct file_operations *ops;//文件操作结构体   
struct list_head list; 
dev_t dev;//设备号,长度为32位，其中高12为主设备号，低20位为此设备号   
unsigned int count;
}
dev_t()
{
主设备号表明了某一类设备，一般对应着确定的驱动程序；次设备号一般是区分不同属性，

------ 主设备号和次设备号 ------
1、主设备号表示设备对应的驱动程序， /dev/null和/dev/zero由驱动程序1管理。虚拟控制台和串口终端由驱动程序4管理；
   类似的vcsl和vcsal设备都有驱动程序7管理。
   现代的Linux内核允许多个驱动程序共享主设备号，但我们看到的大多数设备任然按照"一个主设备号对应一个驱动程序"的原则组织。
2、次设备号由内核使用，用于正确确定设备文件所指定的设备。
    内核除了知道次设备号用来指向驱动程序所实现的设备之外，内核本身基本不关心关于次设备号的任何信息。

3、dev_t类型用来保存设备编号 ---- 包括主设备号和次设备号 dev_t 32位(12位主设备号，20次设备号)。
    <linux/kdev_t.h> MAJOR(dev_t dev) 
                     MINOR(dev_t dev) 
                     MKDEV(int major, int minor)
4、分配和释放设备编号
   ------ 获得一个或多个设备编号(明确知道所需要的设备编号)
   int register_chrdev_region(dev_t first, unsigned int count, char *name);
   first:要分配的设备编号范围的起始值。first的次设备号经常被设置为0，但对该函数来讲并不是必须的。       内核推荐值 
   count: 是所请求的连续设备编号的个数，注意，如果count非常大，则所请求的范围可能和下一个主设备号重叠   多数为1
   name：和该编号关联的设备名称，它将出现在/proc/devices和sysfs中。(驱动名称或设备名称)                 名字自己定义 
-> 将来出现在/proc/devices和sysfs中。
   
   ------ 获得一个或多个设备编号(动态申请设备编号)
   int alloc_chrdev_region(dev_t *dev, unsigned int firstminor, unsigned int count, char *name);         
   dev: 仅用于输出的参数，在成功完成调用后将保存已分配范围的第一个编号                                  用于输出 
   firstminor :应该是要使用的被请求的第一个次设备号，它通常是0                                           
   count和name参数和register_chrdev_region函数一样

   ------ 释放指定的设备编号
   void unregister_chrdev_region(dev_t first, unsigned int count);                                    first为获取主设备号， count常为1

5、动态分配主设备号和静态分配主设备号
   documentation/devices.txt 静态分配主设备号
   /proc/devices             系统已分配主设备驱动 ## awk && 在/dev目录中创建设备文件
}


###### 可以在系统的rc.local文件中调用这个脚本，或是在需要模块时手动调用 ######   
#!/bin/sh
# $Id: scull_load,v 1.4 2004/11/03 06:19:49 rubini Exp $
module="scull"
device="scull"
mode="664"

# 给定舍当的组属性及许可，并修改属组
# 并非所有的发行版都具有staff组，有些有whell组

if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

# 使用传入到该脚本的所有参数调用insmod，同时使用路径名来指定模块位置。
# 这是因为新的modutils默认不会在当前目中查找模块
/sbin/insmod ./$module.ko $* || exit 1

# retrieve major number
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)

# Remove stale nodes and replace them, then give gid and perms
# Usually the script is shorter, it's scull that has several devices in it.
# 删除所有节点
rm -f /dev/${device}[0-3]
mknod /dev/${device}0 c $major 0
mknod /dev/${device}1 c $major 1
mknod /dev/${device}2 c $major 2
mknod /dev/${device}3 c $major 3
ln -sf ${device}0 /dev/${device}
chgrp $group /dev/${device}[0-3] 
chmod $mode  /dev/${device}[0-3]

rm -f /dev/${device}pipe[0-3]
mknod /dev/${device}pipe0 c $major 4
mknod /dev/${device}pipe1 c $major 5
mknod /dev/${device}pipe2 c $major 6
mknod /dev/${device}pipe3 c $major 7
ln -sf ${device}pipe0 /dev/${device}pipe
chgrp $group /dev/${device}pipe[0-3] 
chmod $mode  /dev/${device}pipe[0-3]

rm -f /dev/${device}single
mknod /dev/${device}single  c $major 8
chgrp $group /dev/${device}single
chmod $mode  /dev/${device}single

rm -f /dev/${device}uid
mknod /dev/${device}uid   c $major 9
chgrp $group /dev/${device}uid
chmod $mode  /dev/${device}uid

rm -f /dev/${device}wuid
mknod /dev/${device}wuid  c $major 10
chgrp $group /dev/${device}wuid
chmod $mode  /dev/${device}wuid

rm -f /dev/${device}priv
mknod /dev/${device}priv  c $major 11
chgrp $group /dev/${device}priv
chmod $mode  /dev/${device}priv


###### scull_load scull_unload scull_init 脚本文件 ######
scull_init 不接受来自命令行的驱动程序选项，但它支持一个配置文件，因为这个脚本是为启动和关机时自动运行而设计的。

5、分配主设备号的最佳方式：默认采用动态分配，同时保留在加载甚至是编译时指定主设备号的余地。
int scull_major =   SCULL_MAJOR;
module_param(scull_major, int, S_IRUGO);

if (scull_major) {
	dev = MKDEV(scull_major, scull_minor);
	result = register_chrdev_region(dev, scull_nr_devs, "scull");
} else {
	result = alloc_chrdev_region(&dev, scull_minor, scull_nr_devs,
			"scull");
	scull_major = MAJOR(dev);
}

file_operations()
{
6、文件操作file_operations

    1. file_operations <linux/fs.h>
    2. file_operations结构或者指向这类结构的指针称为fops。这个结构中的每一个字段都必须指向驱动程序中实现特定操作的函数。
    3.__user字符串，它其实是一种形式的文档而已，标明指针是一个用空间地址，因此不能被直接引用，对通常的编译来讲，
      __user没有任何效果但是可由外部检查软件使用，用来寻找对用户空间地址的错误使用。

    4. struct module *owner 指向"拥有"该结构的模块指针。几乎在所有的情况下，该成员都会被初始化为THIS_MODULE，它是定义在linux/module.h中的宏。
	5. llseek 为NULL，对seek的调用将会以某种不可预期的方式修改file结构
	6. read为NULL，将导致read系统调用出错并返回-EINVAL。
	    1. ssize_t read(struct file *filp, char __user *buff, size_t count, loff_t *offp); # ssize_t signed size type
		2. 如果返回值等于传递给read系统调用的count参数，则说明所请求的字节数传输成功。
		3. 如果返回是正的，但是比count小，则说明只有部分数据成功传递。这种情况因设备的不同可能有多种情况。大部分情况下，程序会重新读数据。
		4. 如果返回值为0，则表示已经达到了文件尾
		5. 负值意味着发生了错误，该值指明了发生什么错误。
		6. 阻塞：现在还没有数据，但以后可能会有。
		
	7. aio_read为NULL，所有的操作将通过read同步处理
	8. write 为NULL，返回程序一个-EINVAL
		1. ssize_t write(struct file *filp, char __user *buff, size_t count, loff_t *offp);
		2. 如果返回值等于count，则完成了所请求数据的字节传送。
		3. 如果返回值是正的，但是小于count，则指传输了部分数据。程序很可能再次试图写入余下的数据。
		4. 如果值为0，意味值什么也没有写入。这个结果不是错误，而且也没有理由返回一个错误码。
		5. 负值意味着发生了错误，与read相同。
		有些错误程序只进行了部分传输就报错并异常退出。这种情况的发生是由于程序员习惯认定write调用要么失败要么就完全成功。
		
	9. aio_write 初始化设备上的异步写入操作。
	10. poll方法是poll、select和epoll三个系统调用的后端实现。
	11. 如果设备不支持ioctl，将返回-ENOTTY No Such ioctl for device
        #如果设备不提供这个函数，而内核又不识别该命令，则返回-EINVAL.
	12. mmap为NULL，将返回-ENODEV;
	13. open为NULL，设备的打开操作永远成功，但系统不会通知驱动程序
	    1. 检查设备特定的错误(诸如设备未就绪或类似的硬件问题)。
		2. 如果设备是首次打开，则对其进行初始化
		3. 如果有必要，更新f_op指针
		4. 分配并填写置于filp->private_data里的数据结构
		
		int (*open)(struct inode *inode, struct file *filp) /* inode关联底层设备； filp关联上层应用进程 */
		其中的inode参数的在其i_cdev字段中包含了我们所需要的信息，即我们先前设置的cdev结构。唯一的问题是，
		我们通常不需要cdev结构本身，而是希望得到包含cdev结构的scull_dev结构。
		contianer_of(pointer, container_type, container_field)
		
		struct scull_dev *dev;
		dev = container_of(inode->i_cdev, struct scull_dev, cdev);
		filp->private_data = dev;
		
		另一个确定要打开的设备的方法是：检查保存在inode结构中的次设备号。如果读者利用register_chrdev注册自己的设备，则必须使用该技术。
		请一定使用iminor宏从Inode结构中或的次设备号，并确保它对应于驱动程序真正准备打开的设备。
		
	14. flush：对flush操作的调用发生在进程关闭设备文件描述符副本的时候，它应该执行(并等待)设备上尚未完结的操作。
	    请不要将它同用户程序的fsync操作混淆。目前flush仅仅用于少数几个驱动程序，如果flush被设置为NULL，内核将简单地忽略
		用户应用程序的请求。
	15. release：当file结构被释放时，将调用这个操作。与open相仿，也可以将release设备为NULL。
	    1. 释放由open分配的、保存在filp->private_data中的所有内容
		2. 在最后一次关闭操作时关闭设备
		并不是每个close系统调用都会引起对release方法的调用。只有那些真正释放数据结构的close调用才会调用这个方法。
		内核对每个file结构维护其被使用多少次的计数器。无论fork还是dup，都不会创建新的数据结构(仅有open创建)。
fsync - fsync aio_fsync fasync - FASYNC标识 readv writev sendfile sendpage get_unmapped_area check_flag dir_notify

readv writev # 内核将会通过read和write来模拟它们，而最终结果让然如此。
}

THIS_MODULE(){
THIS_MODULE是一个macro，定义在<linux/module.h>中：
#ifdef MODULE
#define MODULE_GENERIC_TABLE(gtype,name)            \
extern const struct gtype##_id __mod_##gtype##_table        \
  __attribute__ ((unused, alias(__stringify(name))))

extern struct module __this_module;
#define THIS_MODULE (&__this_module)
#else  /* !MODULE */
#define MODULE_GENERIC_TABLE(gtype,name)
#define THIS_MODULE ((struct module *)0)
#endif
THIS_MODULE即是__this_module这个变量的地址。__this_module会指向这个模块起始的地址空间，恰好是struct module变量定义的位置。

file_operations结构体的第一个成员是struct module类型的指针，定义在<linux/fs.h>中：
struct file_operations {
    struct module *owner;
    ......
}

owner指向绑定file_operations的模块。在大多时候，只需把THIS_MODULE赋给它即可。

}

unsigned long copy_to_user(void __user *to, const void *from unsigned long count);　　# -EFAULT ->read
unsigned long copy_from_user(void *to, const void __user *from unsigned long count);　# -EFAULT ->write
当寻址内存不在内存中，虚拟内存子系统会将该进程转入睡眠状态，直到该页面被传送至期望的位置。
要求：访问用户空间的任何函数都必须是可重入的，并且必须能和其他驱动程序函数并发执行，更特别的是，必须处于能够合法休眠的状态。

传递1,2,4,8字节数据传递方式：
#define put_user(x, ptr)    #define __put_user(x, ptr)
#define get_user(x, ptr)	#define __get_user(x, ptr) 



struct file_operations scullc_fops = {
	.owner =     THIS_MODULE,
	.llseek =    scullc_llseek,
	.read =	     scullc_read,
	.write =     scullc_write,
	.ioctl =     scullc_ioctl,
	.open =	     scullc_open,
	.release =   scullc_release,
	.aio_read =  scullc_aio_read,
	.aio_write = scullc_aio_write,
};
标记化的初始化方法允许对结构成员进行重新排列。在某些场合下，将频繁被访问的成员放在相同的硬件缓存行上，将大大提高性能

file()
{
7、文件对象file
代表一个打开的文件。它由内核在open时创建，并传递给在该文件上进行操作的所有函数，直到最后的close函数。
在文件的所有实例都被关闭之后，内核会释放这个数据结构。
    1.	f_mode  FMODE_READ FMODE_WRITE 内核在调用驱动程序的read和write前已经检查了访问权限，所以不必为这两个方法检查权限。
	2.  f_pos   当前的读写位置
	3.  f_flags 文件标志
	4.  f_op 与文件相关的操作，内核在执行open操作时对这个指针赋值，以后需要处理这些操作时就读取这个指针。filp->f_op中的值决不会为方便
        引用而保存起来；也就是说，我们可以在任何需要的时候修改文件的关联操作，在返回调用者之后，新的操作方法就立刻生效，例如：
		对应于主设备号1(/dev/null，/dev/zero等等)的open代码根据要打开的次设备号替换filp->f_op中的操作，这种技巧允许相同主设备
		下的设备实现多种操作行为，而不会增加系统调用的负担。这种替换文件操作的能力在面向对象编程技术中成为"方法重载"。
		
	5. private_data open系统调用在调用驱动程序的open方法前将这个指针设置为NULL。驱动程序可以将这个字段用于任何目的或者忽略这个字段。
        但一定要在内核销毁file结构前在release方法中释放内存，private_data是跨系统调用时保存状态信息的非常有用的资源。
    6. f_dentry: 文件对应的目录结构，除了用filp->f_dentry->d_inode的方式来访问索引节点之外，设备驱动程序的开发者一般无需关心dentry的结构

8、 inode
    1. dev_t i_rdev; 对表示设备文件的inode结构，该字段包含了真正的设备编号
    如果inode代表一个设备，则i_rdev的值为设备号。为了代码更好地可移植性，获取inode的major和minor号应该使用imajor和iminor函数：
    2. struct cdev *i_cdev 表示字符设备的内核的内部结构。当Inode指向一个字符设备文件时，该字段包含了指向struct cdev结构的指针。
    unsigned int  iminor(struct inode *inode)
    unsigned int  imajor(struct inode *inode)
9、 cdev
    struct cdev *my_cdev = cdev_alloc();
	my_cdev->ops = &my_fops;
	或
	void cdev_init(struct cdev *cdev, struct file_operations *fops);
	
	int cdev_add(struct cdev *dev, dev_t num, unsigned int count)
	只要cdev_add返回了，我们的设备就"活"了，它的操作就会被内核调用。因此，在驱动成还没有完全准备好处理设备上的操作时，就不能调用cdev_add.
	
	void cdev_del(struct cdev *dev)
	要清楚的是，在将cdev结构传递给cdev_del函数之后，就不应该再访问cdev结构了。
}

cdev(说明){
#include <linux/kobject.h>
#include <linux/kdev_t.h>
#include <linux/list.h>

struct file_operations;
struct inode;
struct module;

struct cdev {
    struct kobject kobj;
    struct module *owner;
    const struct file_operations *ops;
    struct list_head list;
    dev_t dev;
    unsigned int count;
};

void cdev_init(struct cdev *, const struct file_operations *);
struct cdev *cdev_alloc(void);
void cdev_put(struct cdev *p);
int cdev_add(struct cdev *, dev_t, unsigned);
void cdev_del(struct cdev *);
void cd_forget(struct inode *);

分配和初始化cdev结构体的两种方式：
struct cdev *my_cdev = cdev_alloc();
my_cdev->ops = &my_fops;
my_cdev->owner = THIS_MODULE;

和另外一种是cdev嵌入到代表设备的结构体中：

struct scull_dev {
    ......
    struct cdev cdev; /* Char device structure */
    ......
};

static void scull_setup_cdev(struct scull_dev *dev, int index)
{
    int err, devno = MKDEV(scull_major, scull_minor + index);
    cdev_init(&dev->cdev, &scull_fops);
    dev->cdev.owner = THIS_MODULE;
    dev->cdev.ops = &scull_fops;
    ......
}

两种方式都要注意把owner赋值为THIS_MODULE。

初始化cdev结构体以后，要使用cdev_add把设备加入系统：
要注意count指定的是连续的minor number数。

删除设备使用cdev_del函数：
2.6版本之前的注册和删除设备的register_chrdev和unregister_chrdev函数已经过时，不再使用。
}


register_chrdev()
{
10、兼容性老接口：
int register_chrdev(unsigned int major, congst char *name, struct file_operations *fops);
major:设备的主设备号
name：驱动程序的名称 /proc/devices (可见这个接口不支持sysfs)
fops：是默认的file_operations结构
对register_chrdev的调用将为给定的主设备号注册0~255作为次设备号，并为每个设备建立一个对应的cdev结构。 
主设备号和次设备号不能使用大于255的。

int unregister_chrdev(unsigned int major, const char *name);
major和name必须与传递给register_chrdev函数的值保持一致，否则该调用会失败。
}



11、内存使用
void *kmalloc(size_t size, int flags); # flags: GFP_KERNEL
void kfree(void *ptr); # 将NULL传递给kfree是合法的


register_chrdev_region 		— register a range of device numbers
alloc_chrdev_region 		— register a range of char device numbers
__register_chrdev 			— create and register a cdev occupying a range of minors
unregister_chrdev_region 	— unregister a range of device numbers
__unregister_chrdev 		— unregister and destroy a cdev
cdev_add 					— add a char device to the system
cdev_del 					— remove a cdev from the system
cdev_alloc 					— allocate a cdev structure
cdev_init 					— initialize a cdev structure


nonseekable_open() 
{
    使用数据区时，可以使用 lseek 来往上往下地定位数据。但像串口或键盘一类设备，使用的是数据流，
所以定位这些设备没有意义；在这种情况下，不能简单地不声明 llseek 操作，因为默认方法是允许定位的。

    在 open 方法中调用 nonseekable_open() 时，它会通知内核设备不支持 llseek，nonseekable_open() 
函数的实现定义在 fs/open.c 中：
}