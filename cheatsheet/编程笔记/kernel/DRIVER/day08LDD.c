关键字：等待队列
	内核调用器  等待队列头 等待的进程
	利用定时器 按键消抖

回顾：
1.linux内核并发和竞态
  1.1.概念
  并发
  竞态
  共享资源
  临界区
  互斥访问
  执行路径具有原子性
  
  1.2.形成竞态的4中情形
  SMP
  单CPU,进程与进程的抢占
  中断和进程
  中断和中断
  画图
  
  1.3.解决竞态问题的方法
  中断屏蔽
  自旋锁
  衍生自旋锁
  信号量
  P
  场景：设置某个GPIO的高低电平的时间为严格的500us    PWM
  此时要考虑到竞态问题,一般来说中断最会捣鬼！
  
  spin_lock_irqsave(&lock ,flags);
  gpio_direction_output(., 1);
  udelay(500);
  gpio_direction_output(., 0);
  udelay(500);
  spin_unlock_irqrestore(&lock, flags);


********************************************************************************

2. linux内核等待队列机制
   	2.1 等待分两种
		忙等待：CPU原地空转，等待时间比较短的场合
		休眠等待：专指进程，进程等待某个事件发生前进入休眠状态

	等待队列机制研究休眠等待！

	2.2 等待的本质 
	由于外设的处理速度慢于CPU，当某个进程要操作访问硬件外设，
	当硬件外设没有准备就绪,那么此进程将进入休眠等待,那么进程会释放CPU资源
	给其他任务使用,直到外设准备好数据(外设会给CPU发送中断信号),唤醒之前
  	休眠等待的进程,进程被唤醒以后即可操作访问硬件外设
	    
 	2.3
	以CPU读取UART数据为例，理理数据的整个操作流程：
	1. 应用程序调用read,最终进程通过软中断由用户空间
	   陷入内核空间的底层驱动read接口
  	2. 进程进入底层UART的read接口发现接收缓冲区数据没有准备就绪,
           此进程释放CPU资源进入休眠等待状态,此时代码停止不前等待UART缓冲区来数据
  	3. 如果在某个时刻,UART接收到数据,最终势必给CPU发送一个中断信号
    	   内核调用其中断处理函数,只需在中断处理函数中唤醒之前休眠的进程
  	4. 休眠的进程一旦被唤醒,进程继续执行底层驱动的read接口
    	   read接口将接收缓冲区的数据最终上报给用户空间


	问：如何让进程在内核空间休眠呢？
	答：
		利用已学的休眠函数：msleep/ssleep/schedule/schedule_timeout
  		这些函数的缺点都需要指定一个休眠超时时间,不能够随时随地休眠
		随时随地被唤醒！

	问：如何让进程在内核空间随时随地休眠,随时随地被唤醒呢？
	答：利用等待队列机制
  		msleep/ssleep/信号量这些休眠机制都是利用等待队列实现！

	2.4 等待队列和工作队列对比
	    工作队列是底半部的一个实现方法,本质让事情延后执行
    	    等待队列是让进程在内核空间进行休眠唤醒


	2.5 利用等待队列实现进程在驱动中休眠的编程步骤：
	老鹰<------->进程的调度器(给进程分配CPU资源,时间片,切换,抢占),
		     此代码有内核已经实现
  	鸡妈妈<------>等待队列头,所代表的等待队列中每一个节点表示的是要休眠的进程
  		      只要进程休眠,只需把休眠的进程放到鸡妈妈所对应的等待队列中
  	小鸡<----->每一个休眠的进程,一个休眠的进程对应的是一个小鸡
  
  	linux内核进程状态的宏：
  	进程的运行状态：TASK_RUNNING
  	进程的休眠状态：
  		不可中断的休眠状态：TASK_UNINTERRUPTIBLE
  		可中断的休眠状态：TASK_INTERRUPTIBLE
  	进程的准备就绪状态：TASK_READY


	编程操作步骤：
	1. 定义初始化等待队列头对象(构造一个鸡妈妈)
    		wait_queue_head_t wq; //定义
    		init_waitqueue_head(&wq); //初始化	
    
  	2. 定义初始化装载休眠进程的容器(构造一个小鸡)
    		wait_queue_t wait; //定义一个装载休眠进程的容器
    		init_waitqueue_entry(&wait, current);//将当前进程添加到wait容器中
    					//此时当前进程还没有休眠，以后休眠
    	“当前进程”：正在获取CPU资源执行的进程,当前进程是一个动态变化的
    	current：内核全局指针变量,对应的数据类型：
		     struct task_struct {
		     	pid_t pid;//进程号
		     	char comm[TASK_COMM_LEN];//进程的名称
		     	...
		     };//此数据结构就是描述linux系统进程
       只要创建一个进程,内核就会帮你创建一个task_struct对象来描述你创建的这个进程信息
             current指针就是指向当前进程对应的task_struct对象
   	打印当前进程的PID和名称：
   	printk("当前进程[%s]PID[%d]\n", 
   			current->comm, current->pid);         
             
   	注意：一个休眠的进程要有一个对应的容器wait！
  
  	3. 将休眠的进程添加到等待队列中去(将小鸡添加到鸡妈妈的后面)
    		add_wait_queue(&wq, &wait);   
  
  	4. 设置进程的休眠状态
    		set_current_state(TASK_INTERRUPTIBLE);//可中断的休眠状态 
    		或者
    		set_current_state(TASK_UNINTERRUPTIBLE); //不可中断的休眠状态
    		//此时进程还没有休眠
  
  	5. 当前进程进入真正的休眠状态,一旦进入休眠状态,代码停止不前,等待被唤醒
    		schedule(); //休眠然后等待被唤醒

    	对于可中断的休眠状态,唤醒的方法有两种：
    	1. 接收到了信号引起唤醒
    	2. 驱动主动唤醒(数据到来,中断处理函数中进行唤醒)
    
    	对于不可中断的休眠状态，唤醒的方法有一种：
    	1. 驱动主动唤醒
    
  	6. 一旦进程被唤醒,设置进程的状态为运行,并且将当前进程
     		从等待队列中移除
     		set_current_state(TASK_RUNNING);
     		remove_wait_queue(&wq, &wait); 
  
  	7. 一旦被唤醒,一般还要判断唤醒的原因
		    if(signal_pending(current)) {
		    	printk("进程由于接收到了信号引起的唤醒!\n");
		    	return -ERESTARTSYS;
		    } else {
		    	printk("驱动主动唤醒!\n");
		    	//说明硬件数据准备就绪
		    	//进程继续操作硬件
		    	copy_to_user//将数据上报给用户空间
		    }
   
   	8. 驱动主动唤醒的方法：
	     wake_up(&wq); //唤醒wq所对应的等待队列中所有的进程
	     或者
	     wake_up_interruptible(&wq); //只唤醒休眠类型为可中断的进程
    
案例：写进程唤醒读进程  2.0
   ARM测试步骤：
   insmod /home/drivers/btn_drv.ko
   /home/drivers/btn_test r & //启动读进程
   ps  //查看PID
   top //查看休眠类型
   /home/drivers/btn_test w   //启动写进程

btn_drv.c
	#include <linux/init.h>
	#include <linux/module.h>
	#include <linux/fs.h>
	#include <linux/miscdevice.h>
	#include <linux/irq.h>
	#include <linux/interrupt.h>
	#include <asm/gpio.h>
	#include <plat/gpio-cfg.h>
	#include <linux/sched.h> //TASK_*

	//定义初始化等待队列头对象(构造鸡妈妈)
	static wait_queue_head_t rwq; //每一个节点存放读进程

	//进程read->软中断->内核sys_read->驱动btn_read
	static ssize_t btn_read(struct file *file,
		                char __user *buf,
		                size_t count,
		                loff_t *ppos)
	{
	    //1.定义初始化装载休眠进程的容器(构造小鸡)
	    //将当前进程添加到容器中
	    wait_queue_t wait;
	    init_waitqueue_entry(&wait, current);

	    //2.将当前进程添加到等待队列中
	    add_wait_queue(&rwq, &wait);

	    //3.设置当前进程的休眠状态为可中断
	    set_current_state(TASK_INTERRUPTIBLE);

	    printk("读进程[%s][%d]将进入休眠状态.!\n",
		            current->comm, current->pid);
	    //4.当前进程进入真正的休眠状态
	    schedule(); //停止不动,等待被唤醒
	   
	    //5.一旦被唤醒,设置进程的状态为运行
	    //并且从等待队列中移除
	    set_current_state(TASK_RUNNING);
	    remove_wait_queue(&rwq, &wait); 
	   
	    //6.判断唤醒的原因
	    if (signal_pending(current)) {
		printk("读进程[%s][%d]由于接收到了信号引起的唤醒!\n", current->comm, current->pid);
		return -ERESTARTSYS;
	    } else {
		printk("读进程[%s][%d]由于写进程引起唤醒\n",
		        current->comm, current->pid);
	    }
	    return count;
	}

	static ssize_t btn_write(struct file *file,
		                const char __user *buf,
		                size_t count,
		                loff_t *ppos)
	{
	    //唤醒读进程
	    printk("写进程[%s][%d]唤醒读进程!\n",
		        current->comm, current->pid);
	    wake_up_interruptible(&rwq);
	    return count;
	}

	//定义初始化硬件操作接口对象
	static struct file_operations btn_fops = {
	    .owner = THIS_MODULE,
	    .write = btn_write, //写
	    .read = btn_read //读
	};

	//定义初始化混杂设备对象
	static struct miscdevice btn_misc = {
	    .minor = MISC_DYNAMIC_MINOR,
	    .name = "mybtn",
	    .fops = &btn_fops
	};

	static int btn_init(void)
	{
	    //注册
	    misc_register(&btn_misc);
	    //初始化等待队列头
	    init_waitqueue_head(&rwq);
	    return 0;
	}

	static void btn_exit(void)
	{
	    //卸载
	    misc_deregister(&btn_misc);
	}
	module_init(btn_init);
	module_exit(btn_exit);
	MODULE_LICENSE("GPL");


btn_test.c
	#include <stdio.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>

	//./btn_test r
	//./btn_test w
	int main(int argc, char *argv[])
	{
	    int fd;

	    if (argc != 2) {
		printf("Usage: %s <r|w>\n", argv[0]);
		return -1;
	    }   

	    fd = open("/dev/mybtn", O_RDWR);
	    if (fd < 0)
		return -1;

	    if (!strcmp(argv[1], "r"))
		read(fd, NULL, 0); //启动读进程
	    else if(!strcmp(argv[1], "w"))
		write(fd, NULL, 0); //启动写进程

	    close(fd);
	    return 0;
	}


案例：编写按键驱动，给用户应用程序上报按键状态和按键值  3.0
 分析：
  1.应用程序获取按键的状态和按键值
    应用程序调用read或者ioctl获取这些信息
  2.如果按键没有操作,应用程序应该进入休眠等待按键有操作
  3.一旦按键有操作,势必给CPU发送中断信号,此时唤醒休眠的
    进程,进程再去读取按键的信息上报给用户
  
  测试步骤：
  insmod /home/drivers/btn_drv.ko
  ls /dev/mybtn -lh
  cat /proc/interrupts //查看中断的注册信息

btn_drv.c
	#include <linux/init.h>
	#include <linux/module.h>
	#include <linux/fs.h>    //file_operations
	#include <linux/miscdevice.h>
	#include <linux/irq.h>
	#include <linux/interrupt.h>
	#include <asm/gpio.h>
	#include <plat/gpio-cfg.h>
	#include <linux/sched.h> //TASK_*
	#include <linux/input.h> //KEY_* 标准按键值
	#include <linux/uaccess.h> //copy_to_user

	//声明上报按键信息的数据结构
	struct btn_event {
	    int code;
	    int state;
	};

	//声明描述按键信息的数据结构
	struct btn_resource {
	    char *name; //按键名
	    int irq; //中断号
	    int gpio; //GPIO编号
	    int code; //按键值
	};

	//定义初始化按键对象
	static struct btn_resource btn_info[] = {
	    {
		.name = "KEY_UP",
		.irq = IRQ_EINT(0),
		.gpio = S5PV210_GPH0(0),
		.code = KEY_UP
	    },
	    {
		.name = "KEY_DOWN",
		.irq = IRQ_EINT(1),
		.gpio = S5PV210_GPH0(1),
		.code = KEY_DOWN
	    }
	};

	//定义上报按键信息的对象
	static struct btn_event g_data;

	//定义初始化等待队列头对象(构造鸡妈妈)
	static wait_queue_head_t rwq; //每一个节点存放读进程

	//进程read->软中断->内核sys_read->驱动btn_read
	static ssize_t btn_read(struct file *file,
		                char __user *buf,
		                size_t count,
		                loff_t *ppos)
	{
	    //1.定义初始化装载休眠进程的容器(构造小鸡)
	    //将当前进程添加到容器中
	    wait_queue_t wait;
	    init_waitqueue_entry(&wait, current);

	    //2.将当前进程添加到等待队列中
	    add_wait_queue(&rwq, &wait);

	    //3.设置当前进程的休眠状态为可中断
	    set_current_state(TASK_INTERRUPTIBLE);

	    //4.当前进程进入真正的休眠状态
	    schedule(); //停止不动,等待被唤醒
	   //××××××××××××××××××××××××××××××××××××××××
	    //5.一旦被唤醒,设置进程的状态为运行
	    //并且从等待队列中移除
	    set_current_state(TASK_RUNNING);
	    remove_wait_queue(&rwq, &wait); 
	   
	    //6.判断唤醒的原因
	    if (signal_pending(current)) {
		printk("读进程[%s][%d]由于接收到了信号引起的唤醒!\n", current->comm, current->pid);
		return -ERESTARTSYS;
	    } else {
		copy_to_user(buf, &g_data, sizeof(g_data));
	    }

	    return count;
	}

	//中断处理函数
	static irqreturn_t button_isr(int irq, void *dev)
	{
	    //1.通过dev获取对应的按键的硬件信息
	    struct btn_resource *pdata = 
		    (struct btn_resource *)dev;

	    //2.获取按键的状态和键值
	    g_data.state = gpio_get_value(pdata->gpio);
	    g_data.code = pdata->code;

	    //3.唤醒休眠的进程
	    wake_up(&rwq);
	    return IRQ_HANDLED;
	}

	//定义初始化硬件操作接口对象
	static struct file_operations btn_fops = {
	    .owner = THIS_MODULE,
	    .read = btn_read //读
	};

	//定义初始化混杂设备对象
	static struct miscdevice btn_misc = {
	    .minor = MISC_DYNAMIC_MINOR,
	    .name = "mybtn",
	    .fops = &btn_fops
	};

	static int btn_init(void)
	{
	    int i;
	    //申请GPIO资源注册中断处理函数
	    for (i = 0; i < ARRAY_SIZE(btn_info); i++) {
		gpio_request(btn_info[i].gpio, 
		                btn_info[i].name);
		request_irq(btn_info[i].irq, button_isr,
		    IRQF_TRIGGER_FALLING|IRQF_TRIGGER_RISING,
		            btn_info[i].name,
		            &btn_info[i]);
	    }
	    //注册混杂设备
	    misc_register(&btn_misc);
	    //初始化等待队列头
	    init_waitqueue_head(&rwq);
	    return 0;
	}

	static void btn_exit(void)
	{
	    int i;
	    for (i = 0; i < ARRAY_SIZE(btn_info); i++) {
		gpio_free(btn_info[i].gpio); 
		free_irq(btn_info[i].irq, &btn_info[i]);
	    }
	    //卸载
	    misc_deregister(&btn_misc);
	}
	module_init(btn_init);
	module_exit(btn_exit);
	MODULE_LICENSE("GPL");

btn_test.c
	#include <stdio.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>

	//声明上报按键信息的数据结构
	struct btn_event {
	    int code;
	    int state;
	};

	//./btn_test r
	//./btn_test w
	int main(int argc, char *argv[])
	{
	    int fd;
	    struct btn_event btn;

	    fd = open("/dev/mybtn", O_RDWR);
	    if (fd < 0)
		return -1;

	    while(1) {
		read(fd, &btn, sizeof(btn));
		printf("按键状态为%s,按键值为%d\n",
		        btn.state ?"松开":"按下",
		        btn.code);
	    }
	    close(fd);
	    return 0;
	}


3. 按键去除抖动
   由于按键的机械结构,按键的质量问题造成按键存在抖动     按键抖动实际的波形

   去除抖动的方法：
   硬件去抖动：加滤波电路 两个“与非”门构成一个RS触发器
			利用电容的放电延时，采用并联电容法 并联 0.1uf 电容
   软件去抖动：宗旨延时
   每次上升沿和下降沿的时间间隔经验值5~10ms
   单片机裸板开发,采用忙延时,浪费CPU资源
   linux内核同样采用延时,延时采用定时器进行延时

程序： 4.0

btn_drv.c
	#include <linux/init.h>
	#include <linux/module.h>
	#include <linux/fs.h>  	//file_operations
	#include <linux/miscdevice.h>
	#include <linux/irq.h>
	#include <linux/interrupt.h>
	#include <asm/gpio.h>
	#include <plat/gpio-cfg.h>
	#include <linux/sched.h> //TASK_*
	#include <linux/input.h> //KEY_* 标准按键值
	#include <linux/uaccess.h> //copy_to_user
	#include <linux/timer.h>  //timer

	//声明上报按键信息的数据结构
	struct btn_event {
	    int code;
	    int state;
	};

	//声明描述按键信息的数据结构
	struct btn_resource {
	    char *name; //按键名
	    int irq; //中断号
	    int gpio; //GPIO编号
	    int code; //按键值
	};

	//定义初始化按键对象
	static struct btn_resource btn_info[] = {
	    {
		.name = "KEY_UP",
		.irq = IRQ_EINT(0),
		.gpio = S5PV210_GPH0(0),
		.code = KEY_UP
	    },
	    {
		.name = "KEY_DOWN",
		.irq = IRQ_EINT(1),
		.gpio = S5PV210_GPH0(1),
		.code = KEY_DOWN
	    }
	};

	//定义上报按键信息的对象
	static struct btn_event g_data;

	//定义初始化等待队列头对象(构造鸡妈妈)
	static wait_queue_head_t rwq; //每一个节点存放读进程

	//定义初始化定时器对象
	static struct timer_list btn_timer;

	//进程read->软中断->内核sys_read->驱动btn_read
	static ssize_t btn_read(struct file *file,
		                char __user *buf,
		                size_t count,
		                loff_t *ppos)
	{
	    //1.定义初始化装载休眠进程的容器(构造小鸡)
	    //将当前进程添加到容器中
	    wait_queue_t wait;
	    init_waitqueue_entry(&wait, current);

	    //2.将当前进程添加到等待队列中
	    add_wait_queue(&rwq, &wait);

	    //3.设置当前进程的休眠状态为可中断
	    set_current_state(TASK_INTERRUPTIBLE);

	    //4.当前进程进入真正的休眠状态
	    schedule(); //停止不动,等待被唤醒
	   
	    //5.一旦被唤醒,设置进程的状态为运行
	    //并且从等待队列中移除
	    set_current_state(TASK_RUNNING);
	    remove_wait_queue(&rwq, &wait); 
	   
	    //6.判断唤醒的原因
	    if (signal_pending(current)) {
		printk("读进程[%s][%d]由于接收到了信号引起的唤醒!\n", current->comm, current->pid);
		return -ERESTARTSYS;
	    } else {
		copy_to_user(buf, &g_data, sizeof(g_data));
	    }

	    return count;
	}

	static struct btn_resource *pdata; //记录按键硬件信息

	//定时器超时处理函数
	static void btn_timer_function(unsigned long data)
	{
	    //2.获取按键的状态和键值
	    g_data.state = gpio_get_value(pdata->gpio);
	    g_data.code = pdata->code;

	    //3.唤醒休眠的进程
	    wake_up(&rwq);
	}

	//中断处理函数
	static irqreturn_t button_isr(int irq, void *dev)
	{
	    //1.通过dev获取对应的按键的硬件信息
	    pdata = (struct btn_resource *)dev;

	    //2.启动定时器
	    mod_timer(&btn_timer, 
		    jiffies + msecs_to_jiffies(10));
	    return IRQ_HANDLED;
	}

	//定义初始化硬件操作接口对象
	static struct file_operations btn_fops = {
	    .owner = THIS_MODULE,
	    .read = btn_read //读
	};

	//定义初始化混杂设备对象
	static struct miscdevice btn_misc = {
	    .minor = MISC_DYNAMIC_MINOR,
	    .name = "mybtn",
	    .fops = &btn_fops
	};

	static int btn_init(void)
	{
	    int i;
	    //申请GPIO资源注册中断处理函数
	    for (i = 0; i < ARRAY_SIZE(btn_info); i++) {
		gpio_request(btn_info[i].gpio, 
		                btn_info[i].name);
		request_irq(btn_info[i].irq, button_isr,
		    IRQF_TRIGGER_FALLING|IRQF_TRIGGER_RISING,
		            btn_info[i].name,
		            &btn_info[i]);
	    }
	    //注册
	    misc_register(&btn_misc);
	    //初始化等待队列头
	    init_waitqueue_head(&rwq);

	    //初始化定时器
	    init_timer(&btn_timer);
	    //指定定时器的超时处理函数
	    btn_timer.function = btn_timer_function;

	    return 0;
	}

	static void btn_exit(void)
	{
	    int i;
	    for (i = 0; i < ARRAY_SIZE(btn_info); i++) {
		gpio_free(btn_info[i].gpio); 
		free_irq(btn_info[i].irq, &btn_info[i]);
	    }
	    //卸载
	    misc_deregister(&btn_misc);
	}
	module_init(btn_init);
	module_exit(btn_exit);
	MODULE_LICENSE("GPL");

btn_test.c
	#include <stdio.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>

	//声明上报按键信息的数据结构
	struct btn_event {
	    int code;
	    int state;
	};

	//./btn_test r
	//./btn_test w
	int main(int argc, char *argv[])
	{
	    int fd;
	    struct btn_event btn;

	    fd = open("/dev/mybtn", O_RDWR);
	    if (fd < 0)
		return -1;

	    while(1) {
		read(fd, &btn, sizeof(btn));
		printf("按键状态为%s,按键值为%d\n",
		        btn.state ?"松开":"按下",
		        btn.code);
	    }
	    close(fd);
	    return 0;
	}

编写驱动步骤：
1.先头文件
2.该声明的声明,该定义的定义,该初始化的初始化
  先搞硬件再弄软件
  struct btn_event
  struct btn_resource
  
  struct btn_event g_data;
  struct btn_resource btn_info...
  
  struct file_operations ...
  struct miscdevice ...
3.填充入口和出口
  但凡初始化工作都在入口
  出口跟入口对着干
4.最后完成各个接口函数
  .open
  .release
  .read
  .write
  .unlocked_ioctl
  .mmap
  编写接口函数一定要根据实际的用户需求来完成
  
  如果有中断,编写中断处理函数
  注意：中断处理函数和各个接口函数之间的关系(数据传递)
  
按键程序的执行流程：
应用read->驱动read,睡眠->按键按下->产生中断->内核调中断处理函数
->中断处理函数准备上报的数据,唤醒进程->read进程唤醒,继续执行-》
把中断准备好的数据给用户    

应用read->驱动read,睡眠->按键按下->产生中断->内核调中断处理函数->定时器计时
->超时后进入超时处理函数->超时处理函数准备上报的数据,唤醒进程->read进程唤醒,继续执行
->把超时处理函数准备好的数据给用户


