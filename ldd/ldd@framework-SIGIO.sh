step(user)
{
用户程序执行 2 个步骤使能异步通知：
    指定一个进程作为文件的拥有者：使用 fcntl 系统调用发出 F_SETOWN 命令，这个拥有者进程的 ID 被保存在 filp->f_owner。
目的：让内核知道信号到达时该通知哪个进程。
    使用 fcntl 系统调用，通过 F_SETFL 命令设置 FASYNC 标志。
在这 2 个调用已被执行后,，输入文件可请求递交一个 SIGIO 信号, 无论何时新数据到达。信号被发送给存储于 filp->f_owner 中的进程
(或者进程组, 如果值为负值)。


异步通知：
1. 指定一个进程作为文件的"属主"，当进程使用fcntl系统调用执行F_SETOWN命令时，属主进程的进程ID号就被保存在filp->f_owner中。
用户程序还必须在设置中设置FASYNC标志，这通过fcntl_F_SETFL命令完成
signal(SIGIO, &input_handler);
fcntl(STDIN_FILENO, F_SETOWN, getpid());
oflags = fcntl(STDIN_FILENO, F_GETFL);
fcntl(STDIN_FILENO, F_SETFL, oflags | FASYNC);
}

step(kernel)
{
驱动观点：
    1. 当发出 F_SETOWN, 什么都没发生, 除了一个值被赋值给 filp->f_owner。
    2. 当 F_SETFL 被执行来打开 FASYNC, 驱动的 fasync 方法被调用. 这个方法被调用无论何时 FASYNC 的值在 filp->f_flags 中被改变来通知驱动这个变化, 因此它可正确地响应. 这个标志在文件被打开时缺省地被清除。
    3. 当数据到达, 所有的注册异步通知的进程必须被发出一个 SIGIO 信号。

Linux 提供的通用实现是基于一个数据结构和 2 个函数(它们在前面的第 2 步和第 3 步被调用). 声明相关材料的头文件是<linux/fs.h>

extern int fasync_helper(int, struct file *, int, struct fasync_struct **); ## 创建一个fasync_struct **对象
extern void kill_fasync(struct fasync_struct **, int, int);                 ## 使用fasync_helper创建的fasync_struct **对象
当打开一个文件的FSAYNC标志被修改时，调用fasync_helper以便从相关的进程列表中增加或删除文件。处理最后一个参数外，他的其他所有参数都是提供给fasync
方法的相同参数。因此可以直接传递。
}


static int scull_p_fasync(int fd, struct file *filp, int mode)
{
        struct scull_pipe *dev = filp->private_data;

        return fasync_helper(fd, filp, mode, &dev->async_queue);
}

// 当前只在write函数中存在。
	if (dev->async_queue)
			kill_fasync(&dev->async_queue, SIGIO, POLL_IN);
	PDEBUG("\"%s\" did write %li bytes\n",current->comm, (long)count);

