关键字：ioctl接口  
	应用程序要传递第三个参数要用copy_from_user #include<linux/uaccess.h>
	设备文件自动创建需要配置文件  还有4个配套函数

 	通过file指针获取inode 获取设备号
	struct inode *inode = file->f_path.dentry->d_inode;
	int minor = MINOR(inode->i_rdev);
		
	混杂设备 #include<linux/miscdevice.h>  两个配套函数 一个结构体

vim分屏显示：
进入vim的命令行模式输入：
vs 文件名 //左右分屏
sp 文件名 //上下分屏
屏幕切换：ctrl+ww   

回顾：
1. linux内核字符设备驱动相关内容
   1.1.理念
   1.2.字符设备文件
      c
      主设备号
      次设备号
      设备文件名
      mknod
      仅仅在open时使用
   1.3.设备号
      dev_t
      12
      20
      MKDEV
      MAJOR
      MINOR
      宝贵资源
      alloc_chrdev_region
      unregister_chrdev_region
      主设备号：应用找到驱动
      次设备号：驱动分区硬件个体
   1.4.linux内核描述字符设备驱动数据结构
      struct cdev
      	.dev
      	.count
      	.ops
      配套函数：
      cdev_init
      cdev_add
      cdev_del
      
   1.5.字符设备驱动描述硬件操作接口的数据结构
      struct file_operations {
      	.open
      	.release
      	.read
      	.write
      };
      open/release:可以根据用户的实际需求不用初始化
                   应用程序open/close永远返回成功
      read:
      	1.分配内核缓冲区
      	2.获取硬件信息将信息拷贝到内核缓冲区
      	3.拷贝内核缓冲区数据到用户缓冲区  //copy_to_user
      write:
      	1.分配内核缓冲区
      	2.拷贝用户缓冲区数据到内核缓冲区  //copy_from_user
      	3.拷贝内核缓冲区到硬件
      	
      注意：第二个形参buf:保存用户缓冲区的首地址,驱动不能直接
      	              访问,需要利用内存拷贝函数
      copy_from_user/copy_to_user



2.1  linux内核字符设备驱动硬件操作接口之ioctl
	掌握ioctl系统调用函数
	函数原型：
	int ioctl(int fd, unsigned long request, ...);

	函数功能：
	1. 不仅仅能够向设备发送控制命令（例如开关灯命令）
	2. 还能够跟硬件设备进行数据的读写操作

	参数：
	fd：设备文件描述符
	request：向设备发送的控制命令，命令需要自己定义
	         例如：
			#define LED_ON  (0x100001)
			#define LED_OFF (0x100002)
	...：如该应用程序要传递第三个参数，第三个参数要传递用户缓冲去的首地址，
	     将来底层驱动可以访问这个用户缓冲区的首地址，同样底层驱动不能直接访问，
	     需要利用内存拷贝函数

	回忆C编程：
  	int a = 0x12345678;
  	int *p = &a;
  	printf("a = %#x\n", *p);
  	等价于：
  	unsigned long p = &a;
  	printf("a = %#x\n", *(int *)p);


	返回值：成功返回0，失败返回-1

	参考代码：
		//传递两个参数：
		//开灯
		ioctl(fd, LED_ON);
		//关灯
		ioctl(fd, LED_OFF);
		说明：仅仅发送命令
		  
		//传递三个参数：
		//开第一个灯：
		int uindex = 1;
		ioctl(fd, LED_ON, &uindex); 	  
		  
		//关第一个灯：
		int uindex = 1;
		ioctl(fd, LED_OFF, &uindex);     
		说明：不仅仅发送命令,还传递用户缓冲区的首地址,完成对设备的读或者写



2.2 ioctl对应的底层驱动的接口

	struct file_operations{
		long (*unlocked_ioctl) (struct file *file,
					unsigned int cmd,
					unsigned long arg)
	};

	调用关系：
	应用ioctl->C库ioctl->软中断->内核sys_ioctl->驱动unlocked_ioctl接口

	接口功能：
	1. 不仅仅向设备发送控制命令
  	2. 还能够和设备进行数据的读或者写操作
	参数：
  	file：文件指针
  	cmd：保存用户传递过来的参数,保存应用层中ioctl的第二个参数
 	arg：如果应用ioctl传递第三个参数,arg保存用户缓冲区的
             首地址,内核不允许直接直接访问(int kindex=*(int *)arg)
             需要利用内存拷贝函数,使用时注意数据类型的转换
	     用到第三个参数就势必用到copy_from_user


案例：利用ioctl实现开关任意一个灯  1.0
实施步骤：
	  虚拟机执行：
  	mkdir /opt/drivers/day04/1.0 -p
  	cd /opt/drivers/day04/1.0
  	vim led_drv.c

		#include <linux/init.h>
		#include <linux/module.h>
		#include <linux/cdev.h>
		#include <linux/fs.h>   //(file_system)	//file_operations
		#include <linux/uaccess.h>	//copy_from_user
		#include <asm/gpio.h>
		#include <plat/gpio-cfg.h>

		//声明描述LED硬件信息的数据结构
		struct led_resource {
		    int gpio;
		    char *name;
		};

		//定义初始化2个LED的硬件信息对象
		static struct led_resource led_info[] = {
		    {
			.gpio = S5PV210_GPC1(3),
			.name = "LED1"
		    },
		    {
			.gpio = S5PV210_GPC1(4),
			.name = "LED2"
		    }
		};

		//定义设备操作控制命令
		#define LED_ON  (0x100001)
		#define LED_OFF (0x100002)

		//应用ioctl->软中断->内核sys_ioctl->驱动led_ioctl
		//应用：int uindex=1;ioctl(fd, LED_ON, &uindex);
		static long led_ioctl(struct file *file,
				        unsigned int cmd,
				        unsigned long arg)
		{
		    //1.由于应用传递第三个参数用户缓冲区的首地址,
		    //所以分配内核缓冲区
		    int kindex;

		    //2.拷贝用户缓冲区的数据到内核缓冲区
		    copy_from_user(&kindex, (int *)arg, 4);

		    //3.解析用户控制命令然后操作硬件
		    switch(cmd) {
			case LED_ON:
			    gpio_set_value(led_info[kindex-1].gpio, 1);
			    printk("%s: 开第%d个灯\n", 
				    __func__, kindex);
			    break;
			case LED_OFF:
			    gpio_set_value(led_info[kindex-1].gpio, 0);
			    printk("%s: 关第%d个灯\n", 
				    __func__, kindex);
			    break;
			default:
			    printk("无效的命令\n");
			    return -1;
		    }
		    return 0;
		}

		//定义初始化硬件操作接口对象
		static struct file_operations led_fops = {
		    .owner = THIS_MODULE,
		    .unlocked_ioctl = led_ioctl //控制接口
		};

		//定义字符设备对象和设备号对象
		static struct cdev led_cdev;
		static dev_t dev;

		static int led_init(void)
		{
		    int i;
		    //1.申请GPIO资源
		    //2.配置GPIO为输出口，输出0
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_request(led_info[i].gpio, 
				        led_info[i].name);
			gpio_direction_output(led_info[i].gpio, 0);
		    }
		    //3.申请设备号
		    alloc_chrdev_region(&dev, 0, 1, "tarena");
		    //4.初始化字符设备对象
		    cdev_init(&led_cdev, &led_fops);
		    //5.注册字符设备对象到内核
		    cdev_add(&led_cdev, dev, 1);
		    return 0;
		}

		static void led_exit(void)
		{
		    int i;
		    //1.卸载字符设备对象
		    cdev_del(&led_cdev);
		    //2.释放设备号
		    unregister_chrdev_region(dev, 1);
		    //3.释放GPIO资源
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_direction_output(led_info[i].gpio, 0);
			gpio_free(led_info[i].gpio);
		    }
		}
		module_init(led_init);
		module_exit(led_exit);
		MODULE_LICENSE("GPL");

  	vim Makefile
  	vim led_test.c

		#include <stdio.h>
		#include <sys/types.h>
		#include <sys/stat.h>
		#include <sys/ioctl.h>
		#include <fcntl.h>

		#define LED_ON  0x100001
		#define LED_OFF 0x100002

		int main(int argc, char *argv[])
		{
		    int fd;
		    int uindex; //用户缓冲区

		    if (argc != 3) {
			printf("Usage: %s <on|off> <1|2>\n", argv[0]);
			return -1;
		    }

		    fd = open("/dev/myled", O_RDWR);
		    if (fd < 0)
			return -1;
		    
		    //"1" - > 1
		    uindex = strtoul(argv[2], NULL, 0);

		    if (!strcmp(argv[1], "on"))
			ioctl(fd, LED_ON, &uindex);
		    else
			ioctl(fd, LED_OFF, &uindex);

		    close(fd);
		    return 0;
		}

  	make
  	arm-linux-gcc -o led_test led_test.c
  	cp led_drv.ko led_test /opt/rootfs/home/drivers
  
 	 ARM执行：
  	insmod /home/drivers/led_drv.ko
  	cat /proc/devices
  	mknod /dev/myled c 主设备号 0
  	/home/drivers/led_test on 1
  	/home/drivers/led_test on 2
  	/home/drivers/led_test off 1
  	/home/drivers/led_test off 2    


3. linux内核字符设备驱动之设备文件的自动创建
	3.1 设备文件手动创建
	    mknod /dev/设备文件名 C 主设备号 次设备号

	3.2 设备文件自动创建实施步骤：
	    1. 保证根文件系统rootfs具有mdev可执行程序
	       mdev可执行程序将来会帮你自动创建设备文件
	       which is mdev
	       /sbin/mdev
  	    2. 保证根文件系统rootfs的启动脚本etc/init.d/rcS必须有以下两句话：
	       /bin/mount -a
 	       echo /sbin/mdev > /proc/sys/kernel/hotplug
						  //热插拔
	       说明：
		/bin/mount -a:将来系统会自动解析etc/fstab文件，进行
                  一系列的挂接动作
    		echo /sbin/mdev > /proc/sys/kernel/hotplug：将来驱动
    		创建设备文件时,会解析hotplug文件,驱动最终启动mdev来帮
    		驱动创建设备文件 
  	     3. 保证根文件系统rootfs必须有etc/fstab文件,文件内容如下：
    		 proc           /proc        proc   defaults 0 0
   		     sysfs          /sys         sysfs  defaults 0 0
    		将/proc,/sys目录分别作为procfs,sysfs两种虚拟文件系统
    		的入口,这两个目录下的内容都是内核自己创建,创建的内容
    		存在于内存中
  	     4. 驱动程序只需调用以下四个函数即可完成设备文件的自动
    		创建和自动删除
		    struct class *cls; //定义一个设备类指针
		    //定义一个设备类,设备类名为tarena(类似长树枝)
		    cls = class_create(THIS_MODULE, "tarena");
		    //创建设备文件(类似长苹果)
		    device_create(cls, NULL, 设备号, NULL, 设备文件名);
		    例如：
		    //自动在/dev/创建一个名为myled的设备文件
		    device_create(cls, NULL, dev, NULL, "myled");
		   
		    //删除设备文件(摘苹果)
		    device_destroy(cls, dev);
		    
		    //删除设备类(砍树枝)
		    class_destroy(cls);
    
案例：在ioctl实现的设备驱动中添加设备文件自动创建功能
	2.0
led_drv.c
		#include <linux/init.h>
		#include <linux/module.h>
		#include <linux/cdev.h>
		#include <linux/fs.h>
		#include <linux/uaccess.h>
		#include <asm/gpio.h>
		#include <plat/gpio-cfg.h>
		#include <linux/device.h> //自动创建设备文件

		//声明描述LED硬件信息的数据结构
		struct led_resource {
		    int gpio;
		    char *name;
		};

		//定义初始化2个LED的硬件信息对象
		static struct led_resource led_info[] = {
		    {
			.gpio = S5PV210_GPC1(3),
			.name = "LED1"
		    },
		    {
			.gpio = S5PV210_GPC1(4),
			.name = "LED2"
		    }
		};

		//定义设备操作控制命令
		#define LED_ON  (0x100001)
		#define LED_OFF (0x100002)

		//应用ioctl->软中断->内核sys_ioctl->驱动led_ioctl
		//应用：int uindex=1;ioctl(fd, LED_ON, &uindex);
		static long led_ioctl(struct file *file,
				        unsigned int cmd,
				        unsigned long arg)
		{
		    //1.由于应用传递第三个参数用户缓冲区的首地址,
		    //所以分配内核缓冲区
		    int kindex;  //kernel index

		    //2.拷贝用户缓冲区的数据到内核缓冲区
		    copy_from_user(&kindex, (int *)arg, 4);

		    //3.解析用户控制命令然后操作硬件
		    switch(cmd) {
			case LED_ON:
			    gpio_set_value(led_info[kindex-1].gpio, 1);
			    printk("%s: 开第%d个灯\n", 
				    __func__, kindex);
			    break;
			case LED_OFF:
			    gpio_set_value(led_info[kindex-1].gpio, 0);
			    printk("%s: 关第%d个灯\n", 
				    __func__, kindex);
			    break;
			default:
			    printk("无效的命令\n");
			    return -1;
		    }
		    return 0;
		}

		//定义初始化硬件操作接口对象
		static struct file_operations led_fops = {
		    .owner = THIS_MODULE,
		    .unlocked_ioctl = led_ioctl //控制接口
		};

		//定义字符设备对象和设备号对象
		static struct cdev led_cdev;
		static dev_t dev;

		//定义设备类指针
		static struct class *cls; 

		static int led_init(void)
		{
		    int i;
		    //1.申请GPIO资源
		    //2.配置GPIO为输出口，输出0
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_request(led_info[i].gpio, 
				        led_info[i].name);
			gpio_direction_output(led_info[i].gpio, 0);
		    }
		    //3.申请设备号
		    alloc_chrdev_region(&dev, 0, 1, "tarena");
		    //4.初始化字符设备对象
		    cdev_init(&led_cdev, &led_fops);
		    //5.注册字符设备对象到内核
		    cdev_add(&led_cdev, dev, 1);
		    //6.定义一个设备类对象，类似长树枝
		    cls = class_create(THIS_MODULE, "tarena");
		    //7.创建设备文件/dev/myled,类似长苹果
		    device_create(cls, NULL, dev, NULL, "myled");
		    return 0;
		}

		static void led_exit(void)
		{
		    int i;
		    //0.删除设备文件和设备类
		    device_destroy(cls, dev); //摘苹果
		    class_destroy(cls); //砍树枝

		    //1.卸载字符设备对象
		    cdev_del(&led_cdev);
		    //2.释放设备号
		    unregister_chrdev_region(dev, 1);
		    //3.释放GPIO资源
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_direction_output(led_info[i].gpio, 0);
			gpio_free(led_info[i].gpio);
		    }
		}
		module_init(led_init);
		module_exit(led_exit);
		MODULE_LICENSE("GPL");

led_test.c
		#include <stdio.h>
		#include <sys/types.h>
		#include <sys/stat.h>
		#include <sys/ioctl.h>
		#include <fcntl.h>

		#define LED_ON  0x100001
		#define LED_OFF 0x100002

		int main(int argc, char *argv[])
		{
		    int fd;
		    int uindex; //用户缓冲区  user index

		    if (argc != 3) {
			printf("Usage: %s <on|off> <1|2>\n", argv[0]);
			return -1;
		    }

		    fd = open("/dev/myled", O_RDWR);
		    if (fd < 0)
			return -1;
		    
		    //"1" - > 1
		    uindex = strtoul(argv[2], NULL, 0);

		    if (!strcmp(argv[1], "on"))
			ioctl(fd, LED_ON, &uindex);
		    else
			ioctl(fd, LED_OFF, &uindex);

		    close(fd);
		    return 0;
		}




4. linux内核字符设备驱动之通过次设备号区分硬件个体
	4.1 明确：多个硬件设备个体可以作为一个硬件看待，驱动也能够通过软件进行区分
	4.2 实现思路：
		1. 驱动管理的硬件特性相似
			四个UART Nand的多个分区
			不能把LED，按键放在一起
		2. 说明主设备号为一个，驱动为一个，驱动共享 
			cdev共享
			file_operations共享
			.open
			.read
			.write
			.release
    		.unlocked_ioctl
		3. 多个硬件个体都有对应的设备文件
		4. 驱动通过次设备号区分，次设备号的个数和硬件个数的数据一致
			
	4.3 了解两个数据结构：struct inode， struct file

		struct inode{
			dev_t i_rdev; //保存设备文件的设备号信息
			struct cdev *i_cdev; //指向驱动定义初始化的字符设备对象led_cdev
			.....
		};
		作用：描述一个文件的物理上的信息（文件UID(user id)，GID(group id)，时间信息，大小等）
		生命周期：文件一旦被创建（mknod），内核就会创建一个文件对应的对象
			 文件一旦被销毁（rm），内核就会删除文件对应的inode对象
		注意：struct file_operations中的open,release接口的第一个就是inode
	


		struct file {
			const struct file_operations *f_op;//指向驱动定义初始化的硬件操作接口对象led_fops
			.....
		}
		作用：描述一个文件被打开以后的信息
		生命周期：一旦文件被成功打开(open)，内核就会创建一个file对象来描述
			  一个文件被打开以后的状态属性
            		  一旦文件被关闭(close),内核就会销毁对应的file对象

		总结：一个文件只有一个inode对象，但是可以有多个file对象
							//(多次被打开)
		
		切记：  通过file对象指针获取inode对象指针的方法：
  			内核源码：fbmem.c
 			struct inode *inode = file->f_path.dentry->d_inode;
  			提取次设备号：
  			int minor = MINOR(inode->i_rdev);
   
案例：编写设备驱动,实现通过次设备号来区分两个LED 3.0
  mknod /dev/myled1 c  250 0
  mknod /dev/myled2 c  250 1        

led_drv.c 

		#include <linux/init.h>
		#include <linux/module.h>
		#include <linux/cdev.h>
		#include <linux/fs.h>
		#include <linux/uaccess.h>
		#include <asm/gpio.h>
		#include <plat/gpio-cfg.h>
		#include <linux/device.h> //自动创建设备文件

		//声明描述LED硬件信息的数据结构
		struct led_resource {
		    int gpio;
		    char *name;
		};

		//定义初始化2个LED的硬件信息对象
		static struct led_resource led_info[] = {
		    {
			.gpio = S5PV210_GPC1(3),
			.name = "LED1"
		    },
		    {
			.gpio = S5PV210_GPC1(4),
			.name = "LED2"
		    }
		};

		//定义设备操作控制命令
		#define LED_ON  (0x100001)
		#define LED_OFF (0x100002)

		//应用ioctl->软中断->内核sys_ioctl->驱动led_ioctl
		//应用：int uindex=1;ioctl(fd, LED_ON, &uindex);
		static long led_ioctl(struct file *file,
				        unsigned int cmd,
				        unsigned long arg)
		{

		    //1.通过file指针获取inode
		    //通过inode获取次设备号
		    //应用访问myled1,minor=0;访问myled2,minor=1
		    struct inode *inode = file->f_path.dentry->d_inode;
		    int minor = MINOR(inode->i_rdev);
				   //inode->i_rdev  设备号

		    //2.解析用户控制命令然后操作硬件
		    switch(cmd) {
			case LED_ON:
			    gpio_set_value(led_info[minor].gpio, 1);
			    printk("%s: 开第%d个灯\n", 
				    __func__, minor+1);
			    break;
			case LED_OFF:
			    gpio_set_value(led_info[minor].gpio, 0);
			    printk("%s: 关第%d个灯\n", 
				    __func__, minor+1);
			    break;
			default:
			    printk("无效的命令\n");
			    return -1;
		    }
		    return 0;
		}

		//定义初始化硬件操作接口对象
		static struct file_operations led_fops = {
		    .owner = THIS_MODULE,
		    .unlocked_ioctl = led_ioctl //控制接口
		};

		//定义字符设备对象和设备号对象
		static struct cdev led_cdev;
		static dev_t dev;

		//定义设备类指针
		static struct class *cls; 

		static int led_init(void)
		{
		    int i;
		    //1.申请GPIO资
		    //2.配置GPIO为输出口，输出0
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_request(led_info[i].gpio, 
				        led_info[i].name);
			gpio_direction_output(led_info[i].gpio, 0);
		    }
		    //3.申请设备号
		    alloc_chrdev_region(&dev, 0, 2, "tarena");
		    //4.初始化字符设备对象
		    cdev_init(&led_cdev, &led_fops);
		    //5.注册字符设备对象到内核
		    cdev_add(&led_cdev, dev, 2);
		    //6.定义一个设备类对象，类似长树枝
		    cls = class_create(THIS_MODULE, "tarena");
		    //7.创建设备文件/dev/myled1,类似长苹果
		    device_create(cls, NULL, 
				MKDEV(MAJOR(dev),0), NULL, "myled1");
                        //#define MKDEV(ma,mi)	(((ma) << MINORBITS) | (mi))
		    //8.创建设备文件/dev/myled2,类似长苹果
		    device_create(cls, NULL, 
				MKDEV(MAJOR(dev),1), NULL, "myled2");
		    return 0;
		}

		static void led_exit(void)
		{
		    int i;
		    //0.删除设备文件和设备类
		    device_destroy(cls, MKDEV(MAJOR(dev),0)); //摘苹果
		    device_destroy(cls, MKDEV(MAJOR(dev),1)); //摘苹果
		    class_destroy(cls); //砍树枝

		    //1.卸载字符设备对象
		    cdev_del(&led_cdev);
		    //2.释放设备号
		    unregister_chrdev_region(dev, 2);
		    //3.释放GPIO资源
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_direction_output(led_info[i].gpio, 0);
			gpio_free(led_info[i].gpio);
		    }
		}
		module_init(led_init);
		module_exit(led_exit);
		MODULE_LICENSE("GPL");

led_test.c
	
		#include <stdio.h>
		#include <sys/types.h>
		#include <sys/stat.h>
		#include <sys/ioctl.h>
		#include <fcntl.h>

		#define LED_ON  0x100001
		#define LED_OFF 0x100002

		int main(int argc, char *argv[])
		{
		    int fd1;
		    int fd2;

		    fd1 = open("/dev/myled1", O_RDWR);
		    if (fd1 < 0)
			return -1;
		    
		    fd2 = open("/dev/myled2", O_RDWR);
		    if (fd2 < 0)
			return -1;
		   
		    while(1) {
			//开第一个灯
			ioctl(fd1, LED_ON);
			sleep(1);
			//开第二个灯
			ioctl(fd2, LED_ON);
			sleep(1);
			//关第一个灯
			ioctl(fd1, LED_OFF);
			sleep(1);
			//关第二个灯
			ioctl(fd2, LED_OFF);
			sleep(1);
		    }
		    
		    close(fd1);
		    close(fd2);
		    return 0;
		}


********************************************************************************

二. linux内核混杂设备驱动开发相关内容  
		//misc -> miscellaneous 各种各样的；不同性质的
1. 概念
	混杂设备本质还是字符设备，只是混杂设备的主设备号由内核已经定义好，为10,
	将来各个混杂设备个体通过次设备号来进行区分

2. 混杂设备驱动的数据结构
	struct miscdevice {
		int minor;
		const char *name;
		const struct file_operations *fops;
		...
	}；
	minor：混杂设备对应的次设备号，一般初始化时指定 MISC_DYNAMIC_MINOR,
		表明让内核帮你分配一个次设备号
	name：设备文件名,并且设备文件由内核帮你自动创建
	fops：混杂设备具有的硬件操作接口

	配套函数：
	misc_register(&混杂设备对象);//注册混杂设备到内核
  	misc_deregister(&混杂设备对象);//卸载混杂设备  

案例：利用混杂设备实现LED驱动，给用户提供的接口为ioctl
	4.0
led_drv.c

		#include <linux/init.h>
		#include <linux/module.h>
		#include <linux/fs.h>
		#include <linux/uaccess.h>
		#include <linux/miscdevice.h>
		#include <asm/gpio.h>
		#include <plat/gpio-cfg.h>

		//声明描述LED硬件信息的数据结构
		struct led_resource {
		    int gpio;
		    char *name;
		};

		//定义初始化2个LED的硬件信息对象
		static struct led_resource led_info[] = {
		    {
			.gpio = S5PV210_GPC1(3),
			.name = "LED1"
		    },
		    {
			.gpio = S5PV210_GPC1(4),
			.name = "LED2"
		    }
		};

		#define LED_ON  0x100001
		#define LED_OFF 0x100002

		//int uindex=1,ioctl(fd, LED_ON, &uindex);
		static long led_ioctl(struct file *file,
				        unsigned int cmd,
				        unsigned long arg)
		{
		    //1.分配内核缓冲区
		    int kindex;

		    //2.拷贝用户缓冲区数据到内核缓冲区
		    copy_from_user(&kindex, (int *)arg, 4);

		    //3.解析命令,操作硬件
		    switch(cmd) {
			case LED_ON:
			    gpio_set_value(led_info[kindex-1].gpio, 1);
			    break;
			case LED_OFF:
			    gpio_set_value(led_info[kindex-1].gpio, 1);
			    break;
		    }
		    return 0;
		}
		//定义初始化硬件操作接口对象
		static struct file_operations led_fops = {
		    .owner = THIS_MODULE,
		    .unlocked_ioctl = led_ioctl //控制接口
		};

		//定义初始化混杂设备对象
		static struct miscdevice led_misc = {
		    .minor  = MISC_DYNAMIC_MINOR, //让内核帮你分配一个次设备号
		    .name   = "myled", //自动创建设备文件/dev/myled
		    .fops   = &led_fops, //添加硬件操作接口
		};

		static int led_init(void)
		{
		    int i;

		    //1.申请GPIO资源
		    //2.配置为输出，输出0
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_request(led_info[i].gpio, 
				        led_info[i].name);
			gpio_direction_output(led_info[i].gpio, 0);
		    }
		    //3.注册混杂设备对象到内核
		    misc_register(&led_misc);
		    return 0;
		}

		static void led_exit(void)
		{
		    int i;
		    //1.卸载混杂设备对象
		    misc_deregister(&led_misc);
		    //2.释放GPIO资源
		    for (i = 0; i < ARRAY_SIZE(led_info); i++) {
			gpio_direction_output(led_info[i].gpio, 0);
			gpio_free(led_info[i].gpio);
		    }
		}
		module_init(led_init);
		module_exit(led_exit);
		MODULE_LICENSE("GPL");

led_test.c

		#include <stdio.h>
		#include <sys/types.h>
		#include <sys/stat.h>
		#include <sys/ioctl.h>
		#include <fcntl.h>

		#define LED_ON  0x100001
		#define LED_OFF 0x100002

		int main(int argc, char *argv[])
		{
		    int fd;
		    int uindex; //用户缓冲区

		    if (argc != 3) {
			printf("Usage: %s <on|off> <1|2>\n", argv[0]);
			return -1;
		    }

		    fd = open("/dev/myled", O_RDWR);
		    if (fd < 0)
			return -1;
		    
		    //"1" - > 1
		    uindex = strtoul(argv[2], NULL, 0);

		    if (!strcmp(argv[1], "on"))
			ioctl(fd, LED_ON, &uindex);
		    else
			ioctl(fd, LED_OFF, &uindex);

		    close(fd);
		    return 0;
		}

vim分屏显示：
进入vim的命令行模式输入：
vs 文件名 //左右分屏
sp 文件名 //上下分屏
屏幕切换：ctrl+ww      

作业：利用混杂设备驱动框架实现按键驱动，能够获取按键的操作状态 按下或松开
应用程序
int ustate;
while(1){
	read(fd, &ustate, 4);
	printf("%s\n", ustate?"松开":"按下")
}
