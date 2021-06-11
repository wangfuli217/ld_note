1. 内核子系统或设备驱动可以直接编译到内核，也可以编译成模块，如果编译到内核，可以使用前一节介绍的方法通过内核启动参数来向
   它们传递参数，如果编译成模块，则可以通过命令行在插入模块时传递参数，或者在运行时，通过sysfs来设置或读取模块数据。

2. Sysfs是一个基于内存的文件系统，实际上它基于ramfs，sysfs提供了一种把内核数据结构、它们的属性以及属性与数据结构的联系
   开放给用户态的方式，它与kobject子系统紧密地结合在一起，因此内核开发者不需要直接使用它，而是内核的各个子系统使用它。
   用户要想使用 sysfs 读取和设置内核参数，仅需装载 sysfs 就可以通过文件操作应用来读取和设置内核通过 sysfs 开放给用户
   的各个参数：
   
# mkdir -p /sysfs
$ mount -t sysfs sysfs /sysfs

3. 注意，不要把 sysfs 和 sysctl 混淆，sysctl 是内核的一些控制参数，其目的是方便用户对内核的行为进行控制，而 sysfs 仅仅是
  把内核的 kobject 对象的层次关系与属性开放给用户查看，因此 sysfs 的绝大部分是只读的，模块作为一个 kobject 也被出口到 
  sysfs，模块参数则是作为模块属性出口的，内核实现者为模块的使用提供了更灵活的方式，允许用户设置模块参数在 sysfs 的可见性
  并允许用户在编写模块时设置这些参数在 sysfs 下的访问权限，然后用户就可以通过sysfs 来查看和设置模块参数，从而使得用户
  能在模块运行时控制模块行为。
  
4. 对于模块而言，声明为 static 的变量都可以通过命令行来设置，但要想在 sysfs下可见，必须通过宏 module_param 来显式声明，
   该宏有三个参数，第一个为参数名，即已经定义的变量名，第二个参数则为变量类型，可用的类型有 
   byte, short, ushort, int, uint, long, ulong, charp 和 bool 或 invbool，分别对应于 c 类型 
   char, short, unsigned short, int, unsigned int, long, unsigned long, char * 和 int，
   用户也可以自定义类型 XXX（如果用户自己定义了 param_get_XXX，param_set_XXX 和 param_check_XXX）。
   
   该宏的第三个参数用于指定访问权限，如果为 0，该参数将不出现在 sysfs 文件系统中，允许的访问权限为 
   S_IRUSR， S_IWUSR，S_IRGRP，S_IWGRP，S_IROTH 和 S_IWOTH 的组合，它们分别对应于
   用户读，用户写，用户组读，用户组写，其他用户读和其他用户写，因此用文件的访问权限设置是一致的。

   
static int my_invisible_int = 0;
static int my_visible_int = 0;
static char * mystring = "Hello, World";

module_param(my_invisible_int, int, 0);
MODULE_PARM_DESC(my_invisible_int, "An invisible int under sysfs");
module_param(my_visible_int, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
MODULE_PARM_DESC(my_visible_int, "An visible int under sysfs");
module_param(mystring, charp, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
MODULE_PARM_DESC(mystring, "An visible string under sysfs");

module_param_named(){
module_param和module_param_named定义在<linux/moduleparam.h>文件：
#define module_param(name, type, perm)              \
    module_param_named(name, name, type, perm)

#define module_param_named(name, value, type, perm)            \
    param_check_##type(name, &(value));                \
    module_param_cb(name, &param_ops_##type, &value, perm);        \
    __MODULE_PARM_TYPE(name, #type)
module_param用来定义一个模块参数，type指定类型（int，bool等等），perm指定用户访问权限，取值如下（<linux/stat.h>）：

#define S_IRWXU 00700
#define S_IRUSR 00400
#define S_IWUSR 00200
#define S_IXUSR 00100

#define S_IRWXG 00070
#define S_IRGRP 00040
#define S_IWGRP 00020
#define S_IXGRP 00010

#define S_IRWXO 00007
#define S_IROTH 00004
#define S_IWOTH 00002
#define S_IXOTH 00001

#define S_IRWXUGO   (S_IRWXU|S_IRWXG|S_IRWXO)
#define S_IALLUGO   (S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
#define S_IRUGO     (S_IRUSR|S_IRGRP|S_IROTH)
#define S_IWUGO     (S_IWUSR|S_IWGRP|S_IWOTH)
#define S_IXUGO     (S_IXUSR|S_IXGRP|S_IXOTH)
module_param_named则是为变量取一个可读性更好的名字。

以ktap源码为例：

int kp_max_loop_count = 100000;
module_param_named(max_loop_count, kp_max_loop_count, int, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(max_loop_count, "max loop execution count");
加载ktapvm模块，读取kp_max_loop_count的值：

[root@Linux ~]# cat /sys/module/ktapvm/parameters/max_loop_count
100000
[root@Linux ~]# ls -lt /sys/module/ktapvm/parameters/max_loop_count
-rw-r--r--. 1 root root 4096 Oct 22 22:51 /sys/module/ktapvm/parameters/max_loop_count
可以看到kp_max_loop_count变量在/sys/module/ktapvm/parameters文件夹下的名字是max_loop_count，值是100000，只有root用户拥有写权限。可以通过修改这个文件达到改变kp_max_loop_count变量的目的：

[root@Linux ~]# echo 200000 > /sys/module/ktapvm/parameters/max_loop_count
[root@Linux ~]# cat /sys/module/ktapvm/parameters/max_loop_count
200000
MODULE_PARM_DESC用来定义参数的描述信息，使用modinfo命令可以查看：

[root@Linux ~]# modinfo ktapvm.ko
.....
parm:           max_loop_count:max loop execution count (int)

}

