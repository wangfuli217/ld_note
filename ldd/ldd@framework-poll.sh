select BSD Unix
poll   System V
epoll  2.5.45

unsigned int (*poll)(struct file *filp, poll_table *wait);
1. ��һ��������ָʾpoll״̬�仯�ĵȴ������ϵ���poll_wait.�����ǰû���ļ�������������ִ��IO�����ں˽�ʹ�����ڴ��ݵ���ϵͳ���õ��ļ�����
��Ӧ�ĵȴ������ϵȴ���
2. ����һ�������������Ƿ������������ִ�е�λ���롣

���ݸ�poll�����ĵڶ���������poll_table�ṹ���������ں���ʵ��poll\select�Լ�epollϵͳ���á� linux/poll.h
��������������������ͷ�ļ������������д�߲���Ҫ�˽�ýṹ��ϸ�ڣ���ֻ��Ҫ���䵱��һ��͸���Ķ���ʹ�á�
�������ݸ��������򷽷�����ʹÿ�����Ի��ѽ��̺��޸�poll����״̬�ĵȴ����ж����Ա���������״̬��
ͨ��poll_wait����������������poll_table�ṹ���һ���ȴ����У�
void poll_wait(struct file*, wait_queue_head_t *, poll_table *);


poll(step)
{

ʵ������豸���ܷ�������
    1. ��һ��������ָʾ��ѯ״̬�仯�ĵȴ������ϵ��� poll_wait. ���û���ļ�������������ִ�� I/O, �ں�ʹ��������ڵȴ�������
�ȴ����еĴ��ݸ�ϵͳ���õ��ļ�������. ����ͨ�����ú��� poll_wait����һ���ȴ����е� poll_table �ṹ��ԭ��:
void poll_wait (struct file *, wait_queue_head_t *, poll_table *);

    2. ����һ��λ���룺�������ܲ������������̽��еĲ�����������־(ͨ�� <linux/poll.h> ����)����ָʾ���õĿ��ܲ���:
?�����Ѿ�׼���ã����Զ��ˣ����أ�POLLLIN|POLLRDNORA��
?�豸�Ѿ�׼���ã�����д�ˣ����أ�POLLOUT|POLLNORM��

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

����datasync�ֱ��Ӧ��fsync��fdatasync��
�Ƿ�����O_NONBLOCK��fsyncû��Ӱ�졣
}



