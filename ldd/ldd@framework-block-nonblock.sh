O_NONBLOCK和O_NDELAY 是两个相同的标识，O_NDELAY是为了兼容systemV代码的兼容性而设计的。 -EAGAIN
O_BLOCK与上相反，O_NONBLOCK和O_NDELAY默认情况下是被清除的。

1、如果一个进程调用了read但是还没有数据可读，此进程必须阻塞。数据到达时进行唤醒，并发数据返回给调用者。即使数据数目少于count参数指定的数目也是如此。
2、如果一个进程调用了write但缓冲区没有空间，此进程必须阻塞，而且必须休眠在与读取进程不同的等待队列上。当向硬件设备写入一些数据，从而腾出了部分输出
   缓冲区后，进程即被唤醒，write调用成功。即使缓冲区中可能没有所要求的count字节的空间而只写入部分数据，也是如此。
   
在驱动程序中实现输出缓冲区可以提高性能，这得益于减少了上下文切换和用户级/内核级转换的次数。
    输出缓冲区多大才合适是与设备相关的。   

非阻塞操作立即返回，是的应用程序可以查询数据。在处理非阻塞性文件时，应用程序调用stdio函数必须非常小心，因为很容易把一个非阻塞返回误认为是EOF，
所以必须始终检查errno。

O_NONBLOCK在open方法中的意义在于：open调用可能会阻塞很长时间的场合。
只有read、write、open文件操作受非阻塞标志的影响。

sheep(一个进程如何休眠)
{
1.一个进程如何休眠
  1.1 第一个步骤是分配并初始化一个wait_queue_t结构，然后将其加入到对应的等待队列。
  1.2 第二个步骤是设置进程状态，将其标记为休眠。<linux/sched.h>定义了多个任务状态。
  1.3 最后一个步骤是放弃处理器，但在此之前还要检查休眠等待的条件。
}
 
sleep()
{
2.手工休眠
涉及到相当多的、容易导致错误的代码，是一个冗长乏味的过程。但对理解休眠很有帮助。在此就不多介绍了。
}


wait(独占等待)
{
3.独占等待
    当一个进程调用 wake_up 在等待队列上，所有的在这个队列上等待的进程被置为可运行的。 这在许多情况下是正确的做法。但有时，
可能只有一个被唤醒的进程将成功获得需要的资源，而其余的将再次休眠。这时如果等待队列中的进程数目大，这可能严重降低系统性能。
为此，内核开发者增加了一个“独占等待”选项。它与一个正常的休眠有 2 个重要的不同:
    当等待队列入口设置了 WQ_FLAG_EXCLUSEVE 标志，它被添加到等待队列的尾部；否则，添加到头部。
    在某个等待队列上调用 wake_up , 它会唤醒第一个有 WQ_FLAG_EXCLUSIVE 标志的进程后停止唤醒.但内核仍然每次唤醒所有的非独占等待。

采用独占等待要满足 2 个条件:
（1）对某个资源存在严重竞争；
（2）唤醒一个进程就足够来完全消耗资源。
使一个进程进入独占等待，可调用：
void prepare_to_wait_exclusive(wait_queue_head_t *queue, wait_queue_t *wait, int state);
注意：无法使用 wait_event 和它的变体来进行独占等待.
}

wakeup(唤醒的细节)
{
4.唤醒的细节
    当一个进程被唤醒时，实际的结果由等待队列入口中的一个函数控制。默认的唤醒函数(虚构的名字 default_wake_function)将进程置为可运行状态，
并且如果该进程具有更高优先级，则会执行一次上下文切换以便切换到该进程。
除了wake_up_interruptible 之外很少会调用其他的 wake_up 函数。
}



scull_pipe例子予以说明
------------------------  scull_p_read  ------------------------

scull_p_read()
{

    static ssize_t scull_p_read (struct file *filp, chra __user *buf, size_t count, loff_t *f_ops)
    {
        struct scull_pipe *dev = filp->private_data;
        
        if(down_interruptible(&dev->sem))
            return -ERESTAERTSYS;
        
        while(dev->rp == dev->wp){ /* 无数据可以读取 */
            up(&dev->sem);          /* 释放锁 */
            if(filp->f_flags & O_NONBLOCK)
                return -EAGAIN;
            
            if(wait_event_interruptible(dev->inq, (dev->rp != dev->wp)))
                return -ERESTARTSYS;    /* 信号，通知fs层做出相应处理 */
            /* 否则循环，但首先获取锁 */
            if(down_interruptible(&dev->sem))
                return -ERESTARTSYS;
        }
        /* 数据已就绪，返回 */
        if(dev->wp > dev->rp){
            count = min(count, (size_t)(dev->wp - dev->rp));
        else
            count = min(count, (size_t)(dev->end - dev->rp));
        }
        
        if(copy_to_user(buf, dev->buf, count)){
            up(&dev->sem);
            return -EFAULT;
        }	
        
        dev->rp += count;
        if(dev->rp == dev->end)
            dev->rp = dev->buffer /* 回卷 */
        up(&dev->sem);
        
        /* 最后，唤醒所有写入者并返回 */
        wake_up_interruptible(&dev->outq);
        
        return count;
    }

}


------------------------  scull_p_write  ------------------------
# 我们调用finish_wait，对signal_pending的调用告诉我们是否因为信号而被唤醒，如果是，我们需要返回给用户并让用户再次重试；否则；
我们将获取信号量，并像通常那样再次测试空闲空间。

scull_getwritespace()
{

    static int scull_getwritespace(struct scull_pipe *dev, struct file *filp)
    {
            while (spacefree(dev) == 0) { /* full */
                    DEFINE_WAIT(wait);

                    up(&dev->sem);
                    if (filp->f_flags & O_NONBLOCK)
                            return -EAGAIN;
                    PDEBUG("\"%s\" writing: going to sleep\n",current->comm);
                    prepare_to_wait(&dev->outq, &wait, TASK_INTERRUPTIBLE);
                    if (spacefree(dev) == 0)
                            schedule();
                    finish_wait(&dev->outq, &wait);
                    if (signal_pending(current))
                            return -ERESTARTSYS; /* 信号：通知fs层做出相应处理 */
                    if (down_interruptible(&dev->sem))
                            return -ERESTARTSYS;
            }
            return 0;
    }

}


spacefree()
{

    /* 有多少空间被释放? */
    static int spacefree(struct scull_pipe *dev)
    {
            if (dev->rp == dev->wp)
                    return dev->buffersize - 1;
            return ((dev->rp + dev->buffersize - dev->wp) % dev->buffersize) - 1;
    }
    
}

scull_p_write()
{

    static ssize_t scull_p_write(struct file *filp, const char __user *buf, size_t count,
                    loff_t *f_pos)
    {
            struct scull_pipe *dev = filp->private_data;
            int result;

            if (down_interruptible(&dev->sem))
                    return -ERESTARTSYS;

            /* 确保有空间可写入 */
            result = scull_getwritespace(dev, filp);
            if (result)
                    return result; /* scull_getwritespace called up(&dev->sem) */

            /* 有空间可用，接受数据 */
            count = min(count, (size_t)spacefree(dev));
            if (dev->wp >= dev->rp)
                    count = min(count, (size_t)(dev->end - dev->wp)); /* 直到缓冲区结束 */
            else /* 写入指针回卷，填充到rp-1 */
                    count = min(count, (size_t)(dev->rp - dev->wp - 1));
            PDEBUG("Going to accept %li bytes to %p from %p\n", (long)count, dev->wp, buf);
            if (copy_from_user(dev->wp, buf, count)) {
                    up (&dev->sem);
                    return -EFAULT;
            }
            dev->wp += count;
            if (dev->wp == dev->end)
                    dev->wp = dev->buffer; /* 回卷 */
            up(&dev->sem);

            /* 最后，唤醒读取者 */
            wake_up_interruptible(&dev->inq);  /* 阻塞在read()和select() */

            /* 通知异步读取者，将在本章后面解释 */
            if (dev->async_queue)
                    kill_fasync(&dev->async_queue, SIGIO, POLL_IN);
            PDEBUG("\"%s\" did write %li bytes\n",current->comm, (long)count);
            return count;
    }

}



