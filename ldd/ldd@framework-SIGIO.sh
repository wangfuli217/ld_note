step(user)
{
�û�����ִ�� 2 ������ʹ���첽֪ͨ��
    ָ��һ��������Ϊ�ļ���ӵ���ߣ�ʹ�� fcntl ϵͳ���÷��� F_SETOWN ������ӵ���߽��̵� ID �������� filp->f_owner��
Ŀ�ģ����ں�֪���źŵ���ʱ��֪ͨ�ĸ����̡�
    ʹ�� fcntl ϵͳ���ã�ͨ�� F_SETFL �������� FASYNC ��־��
���� 2 �������ѱ�ִ�к�,�������ļ�������ݽ�һ�� SIGIO �ź�, ���ۺ�ʱ�����ݵ���źű����͸��洢�� filp->f_owner �еĽ���
(���߽�����, ���ֵΪ��ֵ)��


�첽֪ͨ��
1. ָ��һ��������Ϊ�ļ���"����"��������ʹ��fcntlϵͳ����ִ��F_SETOWN����ʱ���������̵Ľ���ID�žͱ�������filp->f_owner�С�
�û����򻹱���������������FASYNC��־����ͨ��fcntl_F_SETFL�������
signal(SIGIO, &input_handler);
fcntl(STDIN_FILENO, F_SETOWN, getpid());
oflags = fcntl(STDIN_FILENO, F_GETFL);
fcntl(STDIN_FILENO, F_SETFL, oflags | FASYNC);
}

step(kernel)
{
�����۵㣺
    1. ������ F_SETOWN, ʲô��û����, ����һ��ֵ����ֵ�� filp->f_owner��
    2. �� F_SETFL ��ִ������ FASYNC, ������ fasync ����������. ����������������ۺ�ʱ FASYNC ��ֵ�� filp->f_flags �б��ı���֪ͨ��������仯, ���������ȷ����Ӧ. �����־���ļ�����ʱȱʡ�ر������
    3. �����ݵ���, ���е�ע���첽֪ͨ�Ľ��̱��뱻����һ�� SIGIO �źš�

Linux �ṩ��ͨ��ʵ���ǻ���һ�����ݽṹ�� 2 ������(������ǰ��ĵ� 2 ���͵� 3 ��������). ������ز��ϵ�ͷ�ļ���<linux/fs.h>

extern int fasync_helper(int, struct file *, int, struct fasync_struct **); ## ����һ��fasync_struct **����
extern void kill_fasync(struct fasync_struct **, int, int);                 ## ʹ��fasync_helper������fasync_struct **����
����һ���ļ���FSAYNC��־���޸�ʱ������fasync_helper�Ա����صĽ����б������ӻ�ɾ���ļ����������һ�������⣬�����������в��������ṩ��fasync
��������ͬ��������˿���ֱ�Ӵ��ݡ�
}


static int scull_p_fasync(int fd, struct file *filp, int mode)
{
        struct scull_pipe *dev = filp->private_data;

        return fasync_helper(fd, filp, mode, &dev->async_queue);
}

// ��ǰֻ��write�����д��ڡ�
	if (dev->async_queue)
			kill_fasync(&dev->async_queue, SIGIO, POLL_IN);
	PDEBUG("\"%s\" did write %li bytes\n",current->comm, (long)count);

