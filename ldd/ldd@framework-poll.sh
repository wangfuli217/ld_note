select BSD Unix
poll   System V
epoll  2.5.45

unsigned int (*poll)(struct file *filp, poll_table *wait);
1. 在一个或多个可指示poll状态变化的等待队列上调用poll_wait.如果当前没有文件描述符可用来执行IO。则内核将使进程在传递到给系统调用的文件描述
对应的等待队列上等待。
2. 返回一个用描述操作是否可立即无阻塞执行的位掩码。

传递给poll方法的第二个参数，poll_table结构，用于在内核中实现poll\select以及epoll系统调用。 linux/poll.h
驱动程序代码必须包含这个头文件，驱动程序编写者不需要了解该结构的细节，且只需要将其当成一部透明的对象使用。
它被传递给驱动程序方法，以使每个可以唤醒进程和修改poll操作状态的等待队列都可以被驱动程序状态。
通过poll_wait函数，驱动程序向poll_table结构添加一个等待队列：
void poll_wait(struct file*, wait_queue_head_t *, poll_table *);


poll(step)
{

实现这个设备功能分两步：
    1. 在一个或多个可指示查询状态变化的等待队列上调用 poll_wait. 如果没有文件描述符可用来执行 I/O, 内核使这个进程在等待队列上
等待所有的传递给系统调用的文件描述符. 驱动通过调用函数 poll_wait增加一个等待队列到 poll_table 结构，原型:
void poll_wait (struct file *, wait_queue_head_t *, poll_table *);

    2. 返回一个位掩码：描述可能不必阻塞就立刻进行的操作，几个标志(通过 <linux/poll.h> 定义)用来指示常用的可能操作:
?数据已经准备好，可以读了，返回（POLLLIN|POLLRDNORA）
?设备已经准备好，可以写了，返回（POLLOUT|POLLNORM）

}

static unsigned int scull_p_poll(struct file *filp, poll_table *wait)
{
        struct scull_pipe *dev = filp->private_data;
        unsigned int mask = 0;

        /*
         * The buffer is circular; it is considered full
         * if "wp" is right behind "rp" and empty if the
         * two are equal.
         */
        down(&dev->sem);
        poll_wait(filp, &dev->inq,  wait);
        poll_wait(filp, &dev->outq, wait);
        if (dev->rp != dev->wp)
                mask |= POLLIN | POLLRDNORM;    /* readable */
        if (spacefree(dev))
                mask |= POLLOUT | POLLWRNORM;   /* writable */
        up(&dev->sem);
        return mask;
}

fsync()
{
int (*fsync)(struct file *file, struct dentry *dentry, int datasync);

参数datasync分别对应于fsync和fdatasync。
是否设置O_NONBLOCK对fsync没有影响。
}



