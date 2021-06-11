kobject(为内核建立起一个统一的设备模型)
{
-----------------------------------------------------------------------------------
2.6版的设备模型提供了[对系统结构的一般性抽象描述]这样的抽象，现在内核使用该抽象支持了多种不同的任务，其中包括：
1. 电源管理和系统关机：一个USB宿主适配器，在处理完所有与其连接的设备前是不能被关闭的。设备模型使得操作系统能够以正确的顺序遍历系统硬件。
2. 与用户空间通信：sysfs向外界展示了它所表述的结构，向用户空间所提供的系统信息，以及改变操作参数的接口，将越来越多通过sysfs实现。
3. 热插拔设备：外围设备可根据用户的需求安装和卸载。
4. 设备类型：设备模型有将设备分类的机制。
5. 对象生命周期：设备模型的实现需要创建一系列机制以处理对象的生命周期，对象之间的关系，以及这些对象在用户空间中的表示。

sysfs文件系统是一个基于 ram 的文件系统，用户空间可访问，用于组织 bus、device、driver的层次结构
kobject，对应sysfs文件系统的一个目录，该目录可以有一些设备属性相关的文件
kset，   相同类型的kobject的集合，也对应sysfs文件系统中的一个目录，他的子目录，就是kobject的目录

驱动程序的加载、删除（kset、kobject，添加、删除），会触发一个事件，从内核空间发送到用户空间，
由udev接收，如果驱动有调用相关的系统调用，可以用来实现，/dev目录下设备节点的自动创建、自动删除
}




kobject(kobject kset 子系统)
{
-----------------------------------------------------------------------------------
kobject是组成设备模型的基本结构。最初它只是被理解为一个简单的引用计数，但是随着时间的推移，它的任务越来越多，因此也有了许多成员。现在
kobject结构所能处理的任务以及他所支持的代码包括：
1. 对象的引用计数
2. sysfs表述
3. 数据结构关联
4. 热插拔事件处理
}


kobject(基础知识)
{
-----------------------------------------------------------------------------------
linux/kobject.h 
kobject: 在 Linux 设备模型中最基本的对象，它的功能是提供引用计数和维持父子(parent)结构、平级(sibling)目录关系，
上面的 device, device_driver 等各对象都是以 kobject 基础功能之上实现的；
struct kobject {
        const char              *name;             真正存放名字的数组
        struct list_head        entry;             
        struct kobject          *parent;           指向kobject的父对象
        struct kset             *kset;             kset和ktype指针分别指向kobject所在的集合和符号的类型；kset就是kobject的集合，就像一个容器来包容kobject这些子集。
        struct kobj_type        *ktype;            表示该对象的类型，是具有相同操作的kobject的集合。负责管理这一类kobject在sysfs下的操作。主要是show和store函数的实现。
        struct sysfs_dirent     *sd;               指针指向sysfs_dirent结构体，代表sysfs中的kobject.
        struct kref             kref;              其他结构体,entry与kset一起联合使用。
        unsigned int state_initialized:1;          
        unsigned int state_in_sysfs:1;             
        unsigned int state_add_uevent_sent:1;      
        unsigned int state_remove_uevent_sent:1;   
};
其中 struct kref 内含一个 atomic_t 类型用于引用计数， parent 是单个指向父节点的指针， entry 用于
父 kset以链表头结构将 kobject 结构维护成双向链表；

kobject_init()        kobject初始化函数
kobject_set_name()    设置指定kobject的名称
kobject_get()         将kobject对象的引用计数加1
kobject_put()         将kobject对象的引用计数减1，如果引用计数将为0，则调用kobject release()释放该kobject对象
kobject_register()    kobject注册函数
kobject_unregister()  kobject注销函数，调用kobject put()减少该对象的引用计数，如果引用计数将为0，则释放kobject对象。


kobject数据结构
1. kobject都是一些代表其他对象完成的服务。
2. 一个kobject对自身并不感兴趣，它存在的意义在于把高级对象连接到设备模型上。
内核代码很少去创建一个单独的kobject对象，相反，kobject用于控制对大型域相关对象的访问。为了达到这个目的，kobject对象被嵌入到其他结构中。
struct cdev{
	struct kobject kobj;
	struct module *owner;
	struct file_operations *ops;
	struct list_head list;
	dev_t dev;
	unsigned int count;
};
cdev结构中嵌入了kobject结构。
如果使用该结构，只需要访问kobject成员就能获得嵌入式的kobject对象。 container_of宏
struct cdev *device = container_of(kp, struct cdev, kobj);
}


kobject(操作函数)
{
------ 初始化 ------
1. 将整个kobject设置为0，这通常使用memset函数。通常在对包含kobject的结构清零时，使用这种初始化方法。
   如果忘记对kobject的清零初始化，则在以后使用kobject时，可能会发生一些奇怪的错误。因此，不能跳过这一步骤：
2. void kobject_init(struct kobject *kobj);
3. int kobject_set_name(struct kobjet *kobj, const char *format, ...);
kobject的创建者需要直接或间接设置的成员有：ktype，kset和parent。
parent:最重要的用途是在sysfs分层结构中定位对象。
kset： 像是kobj_type结构的扩充。一个kset是嵌入相同类型的kobject集合。
        kset结构关心的是对象的聚集和集合，kobj_type结构关心的是对象的类型。
		kset的主要功能是包容。我们可以认为它是kobject的顶层容器类。
		实际上，在每个kset内部，包括了自己的kobject，并且可以用多种处理kobject的方法处理kset。
		需要注意的是，kset总是在sysfs中出现；一旦设置了kset并发他添加到系统中，将在sysfs中创建一个目录。
		kobject不必在sysfs中表示，但是kset中的每一个kobject成员都将在sysfs中得到表述。
int kobject_add(struct kobject *kobj);
extern int kobject_register(struct kobject *kobj); // 该函数只是kobject_init和kobject_add的简单组合。
void kobject_del(struct kobject *kobj);
还有一个kobject_unregister函数，它是kobject_del和kobject_put的组合。

kset在一个标准的内核链表中保存了它的子节点。在大多数情况喜爱，所包含的kobject会在它们的parent成员中保存kset(严格地说是其内嵌的kobject)
的指针。
        kset包含了一个子系统指针subsys。没个kset都必须属于一个子系统。子系统的成员将帮助内核在分层结构中定位kset。

        
------ 对引用计数的操作 ------
struct kobject *kobject_get(struct kobject *kobj);
void kobject_put(struct kobject *obj);

kobject_init设置引用计数为1，所以当创建kobject时，如果不再需要初始的引用，就要调用响应的kobject_put函数。
注意：在许多情况下，在kobject中的引用计数不足以防止静态的产生。

------ release和kobject类型 ------
一个被kobject所保护的结构，不能在驱动程序生命周期的任何可预知的、单独的时间点上被释放掉。但当kobject的引用计数为0时，
代码又要随时准备运行。引用计数不为创建kobject的代码所直接控制。因此当kobhject的最后一个引用计数不再存在时，必须异步地通知。
通知是使用kobject的release方法实现的，该方法通常的原型如下：
void my_object_release(struct kobject *kobj)
{
	struct my_object *mine = container_of(kobj, struct my_object, kobj);
	kfree(mine);
}

struct kobj_type{
	void (*release)(struct kobject *); //kobject类型的release指针。
	struct sysfs_ops *sysfs_ops;
	struct attribute **default_attr;   //default_attr链表中的最后一个元素必须用零填充。
};
default_attrs数组说明了都有些什么属性，但是没有告诉sysfs如何真正实现这些属性，这个任务交给了kobj_type->sysfs_ops成员，
它所指向的结构定义如下：
struct sysfs_ops {
	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
};
------ 非默认属性 ------
int sysfs_create_file(struct kobject *kobj, struct attribute *attr);
int sysfs_remove_file(struct kobject *kobj, struct attribute *attr);
------ 二进制属性 ------
struct bin_attribute {
	struct attribute	attr;
	size_t			size;
	void			*private;
	ssize_t (*read)(struct file *, struct kobject *, struct bin_attribute *,
			char *, loff_t, size_t);
	ssize_t (*write)(struct file *,struct kobject *, struct bin_attribute *,
			 char *, loff_t, size_t);
	int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
		    struct vm_area_struct *vma);
};
int __must_check sysfs_create_bin_file(struct kobject *kobj, const struct bin_attribute *attr);
void sysfs_remove_bin_file(struct kobject *kobj, const struct bin_attribute *attr);
------ 符号链接属性 ------			   
int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
				   const char *name);
void sysfs_remove_link(struct kobject *kobj, const char *name);				   
------ 默认属性 ------				   
struct attribute{
	char *name;             属性的名字，在kobject的sysfs目录中显示
	struct module *owner;   指向模块的指针，该模块负责实现这些属性
	mode_t mode;            应用于属性的保护位。
}

------ kset和子系统 ------
kset: 它用来对同类型对象提供一个包装集合，在内核数据结构上它也是由内嵌一个kboject 实现，因而它同时也是一个 kobject 
(面向对象 OOP 概念中的继承关系) ，具有 kobject 的全部功能；
struct kset {
        struct list_head list;                连接该集合kset中所有的kobject对象
        spinlock_t list_lock;                 
        struct kobject kobj;                  代表了该集合的基类
        struct kset_uevent_ops *uevent_ops;   指向一个用于处理集合中kobject对象的各操作的结构体。
};
其中的 struct list_head list 用于将集合中的 kobject 按 struct list_head entry 维护成双向链表；

void kset_init(struct kset *kset);            完成指定kset的初始化 
int kset_add(struct kset *kset);              把鱼个kset加到层次结构中
int kset_register(struct kset *kset);         完成kset的注册
void kset_unregister(struct kset *kset);      完成kset的注销
                                               
struct kset *kset_get(struct kset *kset);      和kset_put()分别增加和减少kset对象的引用计数(其实就是内嵌kobject的引用计数)
void kset_put(struct kset *kset);              
kobject_set_name(&my_set->kobj, "The name");   

kset中也有一个指针指向kobj_type结构，用来描述它所包含的kobject。该类型的使用优先于kobject中的ktype.
典型的应用中，kobject中的ktype成员被设置成NULL。因为kset中的ktype成员是实际上被使用的成员。

kset包含了一个子系统指针subsys。子系统是对整个内核中一些高级部分的表述。
子系统通常显示在sysfs分层结构中的顶层。内核中的子系统包括block_subsys(对快设备来说是/sys/block)
                                        devices_subsys(/sys/devices 设备分层结构的核心)

decl_subsys(name, struct kobj_type *type, struct kset_hotplug_ops *hotplug_ops);
void subsystem_init(struct subsystem *subsys);
int subsystem_register(struct subsystem *subsys);
void subsystem_unregister(struct subsystem *subsys);
struct subsystem *subsys_get(struct subsystem *subsys);
void subsys_put(struct subsystem *subsys)；

------ 底层sysfs操作 ------
kobject是隐藏在sysfs虚拟文件系统后的机制，对于sysfs中的每个目录，内核中都会存在一个对应的kobject.
每一个kobject都输出一个或者多个属性，他们在kobject的sysfs目录中表现问为文件，其中的内容由内核生成。

------ 热插拔事件的产生 ------
一个热插拔事件是从内核空间发送到用户空间的通知，它表明系统配置出现了变化。无论kojbect被创建还是被删除，都会产生这种事件。
热插拔事件会导致对/sbin/hotplug程序的调用，该程序通过加载驱动程序，创建设备节点，挂在分区，或者其他正确的动作来响应事件。
kobject用来产生这些事件。当我们把kobject传递给kobject_add或kobject_del时，才会真正产生这些事件。
在事件被传递到用户空间之前，处理kobject的代码能够为用户空间添加信息，或者完全禁止事件的产生。
}

hotplug(热插拔事件流程)
{
1. 内核检测到新硬件插入，然后分别通知hotplug和udev.前者用来装入相应的内核模块(例如usb-storage)，后者用来在/dev中创建相应的设备节点(如/dev/sda1).
2. udev创建了相应的设备节点后，会将这一消息通知hal的守护进程hald.udev还必须保证新创建的设备节点可以被普通用户访问。
3. hotplug装入了相应的内核模块并把这一消息通知给hald.
4. hald在收到hotplug和udev发出的消息之后，认为新硬件已经正式被系统认可，此时它会通过一系列进行编写的规则文件(xxx-policy.fdi)
   把新发现硬件的消息通过netlink发送出去，同时还会调用update-fstab或fstab-sync来个更新/etc/fstab,为响应的设备节点创建合适的挂载点。
5. 卷管理器会监视netlink中发现新硬件的消息。根据所插入硬件(区分U盘和数码相机等)的不同，卷管理器会先将相应的设备节点挂载到hald
   创建的挂载点上，然后在打开不同的应用程序。如果是在光驱中插入光盘，过程比较简单。因为光驱本身就是一个固定的硬件，无需
   hotplug和udev的协助。
6. hald会自动监视光驱，并将光驱托架开合的消息通过netlink发出去。
7. 卷管理器负责检查光驱中的盘片内容，进行挂载，并调用合适的应用程序。要注意：hald的工作是从上游得到硬件就绪的消息，然后
   将这个消息转发给netlink中。尽管他会调用程序来更新fastab，实际上自己不执行挂在工作。

  Kernel --> udev --> Network Manager <--> D-Bus <--> Evolution 
  
  udev[早期使用hotplug(/etc/hotplug.d/default)和内核进行通信，后期使用Netlink机制和内核进行通信]
  1. libudev
  2. udevd
  3. udevadm
}

hotplug(热插拔事件流程)
{
1. 若驱动直接编译进内核或在启动时加载，则无需在udev中加载驱动模块，在bus_probe_device()中会为其找到相应的驱动，
2. 若驱动需要动态加载，则现有device或现有driver具有可能。内核层面，在手动加载的驱动register函数中，找到相应device进行关联，
   用户层面，udev(目前的情况是这样，以前也有其他方式，例如/sbin/hotplug等)中，动态加载相应脚本程序。
   
}

hotplug(模块)
{
    hotplug包和内核里的hotplug模块不是一回事，2.6板内核里的pci_hotplug.ko是一个内核模块，而hotplug包是用来处理内核产生
的hotplug事件。这个软件包还在引导时检测现存硬件，并在运行的内核中加载相应模块。

冷插拔发生在内核启动的过程中：
/etc/hotplug/*.rc     这些脚本用于冷插拔，检查和激活在系统启动时已存在的的硬件。它们被hotplug初始化脚本调用。
                      *.rc脚本会尝试恢复系统引导时丢失的热插拔时间，举例来说：内核没有挂载根文件系统。
/etc/hotplug/*.agent  这些脚本被hotplug调用，以响应内核产生的各种不同的热插拔事件爱你，导致插入相应的内核模块和
                      调用用户预定义的脚本
/sbin/hotplug         内核默认情况下，将在内核态的某些事情发生变化时(例如硬件的插入和拔出)调用此脚本。
}

HALD(Linux守护进程HALD)
{
hal构建在udev之上。

    hal（hardware abstract lever）硬件抽象。 但是Linux的hal运行于用户空间作为一个daemon进程。监听一个socket接口。
等待udev发来的通知。 udev为设备加载驱动，设备可用后，往往有udev的规则，让udev通知hald表示设备变动了。 
hal作为一个硬件的数据库，记录了硬件的属性，当前硬件有哪些，他们的属性是什么，等等信息。 因而，
用户态程序可以查询hald得到硬件的信息。也可以注册监听事件在hald上面。当监听的硬件事件发生时候，hald会通知他们。

* Linux kernel 2.6.19 (or later) 
* util-linux 2.15 (or later) 
* udev 125 (or later) 
* dbus 0.61 (or later) 
* glib 2.6.0 (or later) 
* expat 1.95.8 (or later) 
* bash 2.0 (or later) 
* hal-info 20070402 (or later)

}

kset_uevent_ops()
{
当系统配置发生变化时，例如添加kset到系统，或移动kobject，一个通知会从内核空间发送到用户空间，这就是热插拔事件；
Linux中采用kset_uevent_ops函数来对热插拔事件进行相应跟踪。
struct kset_uevent_ops {
    int (*filter)(struct kset *kset, struct kobject *kobj);
    const char *(*name)(struct kset *kset, struct kobject *kobj);
    int (*uevent)(struct kset *kset, struct kobject *kobj,
            struct kobj_uevent_env *env);
};

filter：决定是否将事件传递到用户空间。如果filter返回0，不传递事件。 
name：   负责将相应的字符串传递给用户空间的热插拔处理程序。
uevent： 将用户空间需要的参数添加到环境变量中。返回值正常是0，若返回非0，则终止热插拔事件的产生。


}


sysfs()
{
sysfs-rules.txt
ls -F #命令
ls -F /sys
ls -F /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/
ls -F /sys/devices/
ls -F /sys/devices/pci0000:00/
ls -F /sys/devices/pci0000:00/0000:00:01.0/

ps xfa |grep Xorg
lsof -nP -p 2001
注意到此 Xorg 服务器是以内存映射 (mem) 的形式打开了 "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource0" 和 "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource1" ，
同时以文件读写形式 (7u,9u) 打开了 "/sys/devices/pci0000:00/0000:00:00.0/config" 和 "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/config"
hexdump -C /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/config
lspci -v -d 1039:6330
ls -lU /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/

在 /sys/devices 下是所有设备的真实对象，包括如视频卡和以太网卡等真实的设备，也包括 ACPI 等不那么显而易见的真实设备、还有 tty, bonding 等纯粹虚拟的设备；

DEVICE_ATTR 设备(Devices)               设备是此模型中最基本的类型，以设备本身的连接按层次组织 struct device           /sys/devices/*/*/.../
DRIVER_ATTR 设备驱动(Device Drivers)    在一个系统中安装多个相同设备，只需要一份驱动程序的支持 struct device_driver    /sys/bus/pci/drivers/*/
BUS_ATTR    总线类型(Bus Types)         在整个总线级别对此总线上连接的所有设备进行管理         struct bus_type         /sys/bus/*/
CLASS_ATTR  设备类别(Device Classes)    这是按照功能进行分类组织的设备层次树；
                                        如 USB 接口和 PS/2 接口的鼠标都是输入设备，
                                        都会出现在 /sys/class/input/ 下                        struct class            /sys/class/*/
见头文件：include/linux/device.h
#define BUS_ATTR(_name, _mode, _show, _store) \ 
struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store) 
#define CLASS_ATTR(_name, _mode, _show, _store) \ 
struct class_attribute class_attr_##_name = __ATTR(_name, _mode, _show, _store) 
#define DRIVER_ATTR(_name, _mode, _show, _store) \ 
struct driver_attribute driver_attr_##_name = \ __ATTR(_name, _mode, _show, _store) 
#define DEVICE_ATTR(_name, _mode, _show, _store) \ 
struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)

    sysfs 是一种基于 ramfs 实现的内存文件系统，与其它同样以 ramfs 实现的内存文件系统(configfs,debugfs,tmpfs,...)类似， 
    sysfs 也是直接以 VFS 中的 struct inode 和 struct dentry 等 VFS 层次的结构体直接实现文件系统中的各种对象；
同时在每个文件系统的私有数据 (如 dentry->d_fsdata 等位置) 上，使用了称为 struct sysfs_dirent 的结构用于表示 /sys 
中的每一个目录项。
    在上面的 kobject 对象中可以看到有向 sysfs_dirent 的指针，因此在sysfs中是用同一种 struct sysfs_dirent 来统一设备模型
中的 kset/kobject/attr/attr_group.

    具体在数据结构成员上， sysfs_dirent 上有一个 union 共用体包含四种不同的结构，分别是目录、符号链接文件、属性文件、
二进制属性文件；其中目录类型可以对应 kobject，在相应的 s_dir 中也有对 kobject 的指针，因此在内核数据结构， kobject 与
 sysfs_dirent 是互相引用的；

 
1. 使用驱动(PCI)的 sysfs 属性文件， bind, unbind 和 new_id
2. 使用 scsi_host 的 scan 属性
3. 内核模块中的 sysfs 属性文件


}