------ �������еĳ�ʼ����INIT_WORK�Ĳ������⣩ ------
�ڱ�д�������е�С����ʱ������
error: macro "INIT_WORK" passed 3 arguments, but takes just 2

��2.6.20���ں˿�ʼ,INIT_WORK�����˸ı�,

ԭ������������,�����ĳ�����������
 
from http://blog.csdn.net/fudan_abc/archive/2007/08/20/1751565.aspx

���Ǿ�����������ϸ����INIT_WORK��INIT_DELAYED_WORK.��ʵǰ���Ǻ��ߵ�һ������,�����漰���ľ��Ǵ�˵�еĹ�������.�������궼������include/linux/workqueue.h��:

#define INIT_WORK(_work, _func)                                         /
        do {                                                            /
                (_work)->data = (atomic_long_t) WORK_DATA_INIT();       /
                INIT_LIST_HEAD(&(_work)->entry);                        /
                PREPARE_WORK((_work), (_func));                         /
        } while (0)

#define INIT_DELAYED_WORK(_work, _func)                         /
        do {                                                    /
                INIT_WORK(&(_work)->work, (_func));             /
                init_timer(&(_work)->timer);                    /
        } while (0)

http://blog.csdn.net/laichao1112/article/details/6313175


