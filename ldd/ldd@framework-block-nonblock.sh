O_NONBLOCK��O_NDELAY ��������ͬ�ı�ʶ��O_NDELAY��Ϊ�˼���systemV����ļ����Զ���Ƶġ� -EAGAIN
O_BLOCK�����෴��O_NONBLOCK��O_NDELAYĬ��������Ǳ�����ġ�

1�����һ�����̵�����read���ǻ�û�����ݿɶ����˽��̱������������ݵ���ʱ���л��ѣ��������ݷ��ظ������ߡ���ʹ������Ŀ����count����ָ������ĿҲ����ˡ�
2�����һ�����̵�����write��������û�пռ䣬�˽��̱������������ұ������������ȡ���̲�ͬ�ĵȴ������ϡ�����Ӳ���豸д��һЩ���ݣ��Ӷ��ڳ��˲������
   �������󣬽��̼������ѣ�write���óɹ�����ʹ�������п���û����Ҫ���count�ֽڵĿռ��ֻд�벿�����ݣ�Ҳ����ˡ�
   
������������ʵ���������������������ܣ�������ڼ������������л����û���/�ں˼�ת���Ĵ�����
    ������������ź��������豸��صġ�   

�����������������أ��ǵ�Ӧ�ó�����Բ�ѯ���ݡ��ڴ�����������ļ�ʱ��Ӧ�ó������stdio��������ǳ�С�ģ���Ϊ�����װ�һ����������������Ϊ��EOF��
���Ա���ʼ�ռ��errno��

O_NONBLOCK��open�����е��������ڣ�open���ÿ��ܻ������ܳ�ʱ��ĳ��ϡ�
ֻ��read��write��open�ļ������ܷ�������־��Ӱ�졣

sheep(һ�������������)
{
1.һ�������������
  1.1 ��һ�������Ƿ��䲢��ʼ��һ��wait_queue_t�ṹ��Ȼ������뵽��Ӧ�ĵȴ����С�
  1.2 �ڶ������������ý���״̬��������Ϊ���ߡ�<linux/sched.h>�����˶������״̬��
  1.3 ���һ�������Ƿ��������������ڴ�֮ǰ��Ҫ������ߵȴ���������
}
 
sleep()
{
2.�ֹ�����
�漰���൱��ġ����׵��´���Ĵ��룬��һ���߳���ζ�Ĺ��̡�����������ߺ��а������ڴ˾Ͳ�������ˡ�
}


wait(��ռ�ȴ�)
{
3.��ռ�ȴ�
    ��һ�����̵��� wake_up �ڵȴ������ϣ����е�����������ϵȴ��Ľ��̱���Ϊ�����еġ� ����������������ȷ������������ʱ��
����ֻ��һ�������ѵĽ��̽��ɹ������Ҫ����Դ��������Ľ��ٴ����ߡ���ʱ����ȴ������еĽ�����Ŀ����������ؽ���ϵͳ���ܡ�
Ϊ�ˣ��ں˿�����������һ������ռ�ȴ���ѡ�����һ�������������� 2 ����Ҫ�Ĳ�ͬ:
    ���ȴ�������������� WQ_FLAG_EXCLUSEVE ��־��������ӵ��ȴ����е�β����������ӵ�ͷ����
    ��ĳ���ȴ������ϵ��� wake_up , ���ỽ�ѵ�һ���� WQ_FLAG_EXCLUSIVE ��־�Ľ��̺�ֹͣ����.���ں���Ȼÿ�λ������еķǶ�ռ�ȴ���

���ö�ռ�ȴ�Ҫ���� 2 ������:
��1����ĳ����Դ�������ؾ�����
��2������һ�����̾��㹻����ȫ������Դ��
ʹһ�����̽����ռ�ȴ����ɵ��ã�
void prepare_to_wait_exclusive(wait_queue_head_t *queue, wait_queue_t *wait, int state);
ע�⣺�޷�ʹ�� wait_event �����ı��������ж�ռ�ȴ�.
}

wakeup(���ѵ�ϸ��)
{
4.���ѵ�ϸ��
    ��һ�����̱�����ʱ��ʵ�ʵĽ���ɵȴ���������е�һ���������ơ�Ĭ�ϵĻ��Ѻ���(�鹹������ default_wake_function)��������Ϊ������״̬��
��������ý��̾��и������ȼ������ִ��һ���������л��Ա��л����ý��̡�
����wake_up_interruptible ֮����ٻ���������� wake_up ������
}



scull_pipe��������˵��
------------------------  scull_p_read  ------------------------

scull_p_read()
{

    static ssize_t scull_p_read (struct file *filp, chra __user *buf, size_t count, loff_t *f_ops)
    {
        struct scull_pipe *dev = filp->private_data;
        
        if(down_interruptible(&dev->sem))
            return -ERESTAERTSYS;
        
        while(dev->rp == dev->wp){ /* �����ݿ��Զ�ȡ */
            up(&dev->sem);          /* �ͷ��� */
            if(filp->f_flags & O_NONBLOCK)
                return -EAGAIN;
            
            if(wait_event_interruptible(dev->inq, (dev->rp != dev->wp)))
                return -ERESTARTSYS;    /* �źţ�֪ͨfs��������Ӧ���� */
            /* ����ѭ���������Ȼ�ȡ�� */
            if(down_interruptible(&dev->sem))
                return -ERESTARTSYS;
        }
        /* �����Ѿ��������� */
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
            dev->rp = dev->buffer /* �ؾ� */
        up(&dev->sem);
        
        /* ��󣬻�������д���߲����� */
        wake_up_interruptible(&dev->outq);
        
        return count;
    }

}


------------------------  scull_p_write  ------------------------
# ���ǵ���finish_wait����signal_pending�ĵ��ø��������Ƿ���Ϊ�źŶ������ѣ�����ǣ�������Ҫ���ظ��û������û��ٴ����ԣ�����
���ǽ���ȡ�ź���������ͨ�������ٴβ��Կ��пռ䡣

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
                            return -ERESTARTSYS; /* �źţ�֪ͨfs��������Ӧ���� */
                    if (down_interruptible(&dev->sem))
                            return -ERESTARTSYS;
            }
            return 0;
    }

}


spacefree()
{

    /* �ж��ٿռ䱻�ͷ�? */
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

            /* ȷ���пռ��д�� */
            result = scull_getwritespace(dev, filp);
            if (result)
                    return result; /* scull_getwritespace called up(&dev->sem) */

            /* �пռ���ã��������� */
            count = min(count, (size_t)spacefree(dev));
            if (dev->wp >= dev->rp)
                    count = min(count, (size_t)(dev->end - dev->wp)); /* ֱ������������ */
            else /* д��ָ��ؾ���䵽rp-1 */
                    count = min(count, (size_t)(dev->rp - dev->wp - 1));
            PDEBUG("Going to accept %li bytes to %p from %p\n", (long)count, dev->wp, buf);
            if (copy_from_user(dev->wp, buf, count)) {
                    up (&dev->sem);
                    return -EFAULT;
            }
            dev->wp += count;
            if (dev->wp == dev->end)
                    dev->wp = dev->buffer; /* �ؾ� */
            up(&dev->sem);

            /* ��󣬻��Ѷ�ȡ�� */
            wake_up_interruptible(&dev->inq);  /* ������read()��select() */

            /* ֪ͨ�첽��ȡ�ߣ����ڱ��º������ */
            if (dev->async_queue)
                    kill_fasync(&dev->async_queue, SIGIO, POLL_IN);
            PDEBUG("\"%s\" did write %li bytes\n",current->comm, (long)count);
            return count;
    }

}



