

��Linux kernel�У�
0�Ž�����scheduler��
1�Ž�����init/systemd������user thread�����ȣ���
2�Ž�����[kthreadd]������kernel thread�ĸ����̣���

kthread(kernel_thread)
{
         �ں��̣߳�thread������ػ�����(daemon)���ڲ���ϵͳ��ռ���൱��ı�������Linux����ϵͳ�����Ժ��������
"ps -ef"����鿴ϵͳ�еĽ��̣���ʱ�ᷢ�ֺܶ��ԡ�d����β�Ľ�������ȷ��˵������ʾ����� "[]"�ģ���Щ���̾����ں��̡߳�

�ں��̣߳����з�æ���첽������Ҳ����˯�ߵȴ�ĳ�¼��ķ�����
�ں��̺߳��û��������ƣ�Ψһ��ͬ�����ں��߳�λ���ں˿ռ䲢���Է����ں˺��������ݽṹ��

ksoftirqd���ں��߳���ʵ�����е����֣����ж������жϷ���Ŀ��Ա��Ӻ�ִ�еĵװ벽���̣�����Ļ���˼�������жϴ�������еĴ���Խ��Խ�ã�
ϵͳ�����жϵ�ʱ���Խ�̣�ʱ��Խ�ͣ�ksoftirqd�Ĺ�����ȷ���߸�������£����жϼȲ�����У��ֲ�����ѹ��ϵͳ���ڶԳƶദ�����ϣ�����߳�ʵ������
���е������ڲ�ͬ�Ĵ������ϡ�Ϊ�������������ϵͳΪÿ��CPU������һ��ksoftirqd�߳�[ksoftirqd/n ����n������CPU���]

ksoftirqd��һ�����������ڳ��ص����жϸ�����������е����ÿ��cpu���ں��̡߳����ж�ͨ��������һ��Ӳ���жϵķ��أ������п������жϻ������������
�Ķ������ش��������һ�����ж����ڱ�����ʱ����һ�δ�������ksoftirq����ͱ������ڽ��̵��������д���������жϡ����ksoftirqdռ���˳�����CPU
ʱ���������ٷֱȣ��ͱ��������������ص����жϸ����С�

kevent/n:����n����CPU��ţ��߳�ʵ���˹������У�������һ�ֵ��ں����Ӻ�ִ�е��ֶΣ��ں����ڴ��ӳ�ִ�й����ĳ�����Դ����Լ��Ĺ������С�����ʹ��
Ĭ�ϵ�event/n�������̡߳�

kpdflush �Ը��ٻ����е���ҳ���л�д
bdflush��kupdated��2.4�ں��и��ٻ����е���ҳ���л�д��ʵ��
kjournald��ͨ�õ��ں���־�߳�
khubd��������USB������

ret = kernel_thread(mythread, NULL, CLONE_FS|CLONE_FILES|CLONE_SIGHAND|SIGCHLD);
kthreadd:�ں��̵߳ĸ��̣߳����ڽ����̻߳��ա�
}

kthread_queue(�ں��̡߳��ȴ����С��߳�״̬)
{
����ȴ����У�add_wait_queue() remove_wait_queue() 
���ѵȴ��̣߳�wake_up_interruptible()
�����س�״̬��set_current_state()

1. ����ȴ����У������߳�״̬�������̵߳���
2. ����֪ͨ����SIGKILL���͵Ļ���֪ͨ��

##################### �ں��̡߳��ȴ����С��߳�״̬ #########################
add_wait_queue(&myevent_waitqueue, &wait);
for(;;)
{
/* ....  */
set_current_state(TASK_INTERRUPTIBLE);
schedule()
/* Point A */
/* ... ... */

}
set_current_state(TASK_RUNNING);
remove_wait_queue(&myevent_waitqueue, &wait);

}

run_umode_handler(call_usermodehelper�û�ģʽ��������)
{

�ں�֧�����ֻ��ƣ����û�ģʽ�Ľ��̷�����������ִ��ĳЩ����run_umode_handler()ͨ������call_usermodehelper()ʹ�������ֻ��ơ�
�ں���mdev�û�̬���� echo /sbin/mdev > /proc/sys/kernel/hotplug
/sys/kernel/uevent_helper
}


kernel(˫������ ɢ������ �������� ֪ͨ�� ��ɽӿ� kthread�����ӿ�)
{

##################### ˫������ ɢ������ �������� ֪ͨ�� #########################
˫������ list_head
INIT_LIST_HEAD               ��ʼ����ͷ                              
list_add                     �ڱ�ͷ������һ��Ԫ��                    hlist_add_head(struct hlist_node *n, struct hlist_head *h)
list_add_tail                ������β������һ��Ԫ��                  hlist_add_before |��hlist_add_after
list_del                     ������β��ɾ��һ��Ԫ��                  hlist_move_list
list_replace                 ����һ��Ԫ�����Ԫ���е�ĳһ��Ԫ��      hlist_del(struct hlist_node *n)
list_entry                   ���������е����нڵ�                    hlist_entry
list_for_each_entry          �򻯵�����ݹ�ӿ�                      hlist_for_each(pos, head)
list_for_each_entry_safe                                             hlist_for_each_safe(pos, n, head)
list_empty                   ��������Ƿ�Ϊ��                        hlist_empty
list_splice                  ������������������                      
INIT_LIST_HEAD               ��ʼ����ͷ                              INIT_HLIST_HEAD
LIST_HEAD_INIT               {&{name}, &{name}}                      HLIST_HEAD_INIT
LIST_HEAD                    ��̬��ʼ����ͷ                          HLIST_HEAD
list_for_each_entry(pos, head, member) ����������ÿ��Ԫ��            hlist_for_each_entry(tpos, pos, head, member)


ɢ������ hlist_head hlist_node   ### http://blog.csdn.net/hs794502825/article/details/24597773
//hashͰ��ͷ���  
struct hlist_head {  
    struct hlist_node *first;//ָ��ÿһ��hashͰ�ĵ�һ������ָ��  
};  
//hashͰ����ͨ���  
struct hlist_node {  
    struct hlist_node *next;//ָ����һ������ָ��  
    struct hlist_node **pprev;//ָ����һ������nextָ��ĵ�ַ  
};
hlist_head�ṹ��ֻ��һ���򣬼�first�� firstָ��ָ���hlist����ĵ�һ���ڵ㡣
hlist_node�ṹ����������next ��pprev�� nextָ���������⣬��ָ���¸�hlist_node��㣬�����ýڵ�����������һ���ڵ㣬nextָ��NULL��
pprev��һ������ָ�룬 ��ָ��ǰһ���ڵ��nextָ��ĵ�ַ��

���hlist_node���ô�ͳ��next,prevָ�룬���ڵ�һ���ڵ�ͺ��������ڵ�Ĵ���᲻һ�¡������������ţ�����Ч����Ҳ����ʧ��
hlist_node����ؽ�pprevָ����һ���ڵ��nextָ��ĵ�ַ������hlist_head��first��ָ��Ľ�����ͺ�hlist_nodeָ�����һ�����Ľ��������ͬ��
�����ͽ����ͨ���ԣ�
ɾ����һ����ͨ����ɾ���ǵ�һ����ͨ���Ĵ�����һ���ġ�


�������У����ں������ڽ����Ӻ�����һ�ַ�ʽ�� wrokqueue_struct work_struct
    1. 1�������жϷ����󣬴���������������������
    2. ͬ�����̻��������ļ�ϵͳ����
    3. �����̷���һ����������ٴ洢Э��״̬��
   
1. 1.����һ����������(��һ��workqueue_struct)���ù���������һ�������ں��̹߳���������ʹ��create_singlethread_workqueue()����һ��
     ������workqueue_struct���ں��̣߳�Ϊ����ϵͳ�е�ÿ��CPU�ϴ���һ���������̣߳�����ʹ��create_workqueue()���塣���⣬�ں���Ҳ
     ����Ĭ�ϵ����ÿ��CPU�Ĺ������߳� (event/n, n��CPU���)�����Է�ʱ���� ����̣߳������Ǵ���һ�������Ĺ������̡߳�
   2. ����һ������Ԫ��(����һ��work_struct)��ʹ��INIT_WORK���Գ�ʼ��һ��work_struct��������Ĺ��������ĵ�ַ�Ͳ�����
   3. ������ Ԫ���ύ�������̡߳�����ͨ��queue_work()��work_struct�ύ��һ��ר�õ�create_singlethread_workqueue()����ͨ��
      schedule_work�ύ��Ĭ�ϵ��ں˹������̡߳�
    
֪ͨ���������ڽ�״̬�ı���Ϣ���͸�������Щ�仯�Ĵ���Ρ���Ӳ���벻ͬ��֪ͨ��һ���ڸ���Ȥ���¼�����ʱ��ø澯��.
    1. ����֪ͨ�����ں˴���������ʹ���ʱ��������֪ͨ��
    2. �����豸֪ͨ����һ������ӿڿ�������رյ�ʱ���͸�֪ͨ
    3. CPUƵ��֪ͨ������������Ƶ�ʷ��������ʱ�򣬻�ַ�һ֪ͨ
    4. ��������ַ֪ͨ������鵽����ӿڿ���IP��ַ�����ı��ʱ�򣬻ᷢ�ʹ�֪ͨ��
����֪ͨ����֪ͨ�¼������������ڽ��������ı����ã���˿��Խ���˯��״̬��
ԭ��֪ͨ�������֪ͨ������������ж������ĵ��ã���Ҫԭ��֪ͨ����

wait_for_completion
complete
completeall

��ɽӿڣ��ں��е����ط��ἤ��ĳЩ������ִ���̣߳�֮��ȴ�������ɡ���ɽӿ���һ����ֵġ��򵥵Ĵ����̵�ʵ��ģʽ��
     ����ģ���а���һ�������ں��̣߳���ж�����ģ��ʱ����ģ��Ĵ�����ں˿ռ䱻�Ƴ�֮ǰ��release���������á��ͷ�����Ҫ���ں��߳��˳�������
���߳��˳�ǰһֱ��������״̬
     �����д���豸���������н��豸�������ŶӵĲ��֡��⼤�����Ե����̻߳������з�ʽʵ�ֵ�һ��״̬���ı������������������һֱ�ȵ���
������ɺ���ִ����һ�β�����driver/block/floppy.c��������һ�����ӡ�
     һ��Ӧ�ó�������ģ������ת���������������һ�����ݲ����������������ʼ����һ��ת�����󣬽�����һֱ�ȴ�ת����ɵ��жϲ�����������ת��������ݡ�

     
kthread�����ӿڣ�kthreadΪԭʼ���̴߳������������һ��"����"���ɴ˼����̹߳��������
kthread_create = kernel_thread + daemonize
kthread�������ɵص����ڽ��ġ�����ɽӿ���ʵ�ֵ��˳�ͬ�����ơ���ˣ�����ֱ�ӵ���kthread_stop()��������������pink_slip������
my_thread()��ʹ��wait_for_completion()�ȴ�������ɡ�
}
    
kthread_create_kernel_thread(kthread_create��kernel_thread��������ܽ�)
{
    kthread_should_stop()����should_stop��־�������ڴ������̼߳�������־���������Ƿ��˳����߳���ȫ����������Լ��Ĺ���������������
����ȴ�should_stop��־��

�ú���������include/linux/kthread.h�У�������صĻ��У�
struct task_struct kthread_run(int (*threadfn)(void *data), void *data,constchar namefmt[],...);
int kthread_stop(struct task_struct *k);

    kthread_run()�����ں��̵߳Ĵ���������������ں��� threadfn������data���߳�����namefmt�����Կ����̵߳����ֿ���������sprintf��ʽ���
���ַ��������ʵ�ʿ��� kthread.h�ļ����ͻᷢ��kthread_runʵ����һ���궨�壬����kthread_create()��wake_up_process() ��������ɣ�
�����ĺô�����kthread_run()�������߳̿���ֱ�����У�ʹ�÷��㡣
    kthread_stop()��������������̣߳������Ǵ���ʱ���ص�task_structָ�롣kthread���ñ�־should_stop������ ���߳����������������̵߳�
����ֵ���߳̿�����kthread_stop()����ǰ�ͽ�����

���������kthread_create��kernel_thread�Ĵ���Ĳ�ͬ���֣�����Ҳ�ᵽ�˼��㲻ͬ�������ܽ�һ�£�
��1������Ҫ�Ĳ�ͬ��kthread_create�������ں��߳��иɾ������������Ļ������ʺ�������ģ����û��ռ�ĳ��򴴽�
     �ں��߳�ʹ�ã������ĳЩ�ں���Ϣ��¶���û�����
��2�����ߴ����Ľ��̵ĸ����̲�ͬ�� kthread_create�����Ľ��̵ĸ����̱�ָ��Ϊkthreadd, ��kernel_thread�����Ľ���
     ������init�������ں��̡߳�
}


���������֣�
IS_ERR��PTR_ERR

ksoftirqd pdflushd khubd�ں��̴߳���ֱ�λ��kernel/softirq.c mm/pdflush.c��drivers/usb/core/hub.c�ļ�
��kernel/exit.c�ļ��п����ҵ�daemonize().���û�ģʽ����ʵ�ֵĴ�����Լ�kernel/exit.c�ļ���
kernel/workqueue.c �μ�drivers/net/wireless/ipw2200.c


wait_queue_t        include/linux/wait.h        �ں��߳����ȴ�ĳ�¼���ϵͳ��Դʱʹ�� 
list_head           include/linux/list.h        ���ڹ���˫���������ݽṹ���ں˽ṹ�� 
hlist_head          include/linux/list.h        ����ʵ��ɢ���б���ں˽ṹ�� 
work_struct         include/linux/workqueue.h   ʵ�ֹ������У�����һ�����ں��н����Ӻ����ķ�ʽ 
notifier_block      include/linux/notifier.h    ʵ��֪ͨ�������ڽ�״̬�仯��Ϣ���͸�����˱���Ĵ���� 
completion          include/linux/completion.h  ���ڿ�ʼĳ�̻߳���ȴ�������ɡ� 
     
DECLWAR_WAITQUEUE       inlcue/linux/wait.h               ����ȴ�����
add_wait_queue          kernel/wait.c                     ��һ���������һ���ȴ����У����������˯��״̬��ֱ��������һ���̻߳��жϴ���������
remove_wait_queue       kernel/wait.c                     �ӵȴ�������ɾ������
wake_up_interruptible   inlcue/linux/wait.h               ����һ�����ڵȴ�������˯�ߵ����񣬽����ص����������ж���
schedule                kernel/sched.h                    ����CPU��Ȼ�ں˵�������������
set_current_state       include/linux/sched.h             ����״̬��һ�֣�TASK_RUNNING��TASK_INTERRUPTIBLE��TASK_UNINTERRUPTIBLE��
                                                          TASK_STOPPED��TASK_TASKTRACED��EXIT_ZOMBIE��EXIT_DEAD
kernel_thread           arch/your-arch/kernel/process.c   �����ں��߳�
deamonize                        kernel/exit.c                       �����ں��̣߳����������̵߳ĸ��̸߳�Ϊktheadd
allow_signal                     kernel/exit.c                       ʹ��ĳָ���źŵķַ�
signal_pending                   include/linux/sched.h               ����Ƿ����ź��Ѿ������ͣ����ں���û���źŴ���������˲��ò���ʾ�ؼ���ź��Ƿ��ѷַ�
call_usermodehelper              include/linux/kmod.h kernel/kmod.c  ִ���û�ģʽ�ĳ���
register_die_notifier            arch/your-arch/kernel/trap.c        ע������֪ͨ��
register_netdevice_notifier      net/core/dev.c                      ע������֪ͨ��
register_inetaddr_notifier       net/ipv4/devinet.c                  ע��inetaddr֪ͨ��
BLOCKING_NOTIFIER_HEAD           include/linux/notifier.h            �����û�����������Ե�֪ͨ
blocking_notifier_chain_register kernel/sys.c                        ע�������Ե�֪ͨ
blocking_notifier_call_chain     kernel/sys.c                        ���¼��ַ���������֪ͨ��
ATOMIC_NOTIFIER_HEAD             include/linux/notifier.h            ����ԭ���Ե�֪ͨ
atomic_notifier_chain_register   kernel/sys.c                        ע��ԭ���Ե�֪ͨ
DECLARE_COMPLETION               include/linux/completion.h          ��̬�������ʵ��
init_completion                  include/linux/completion.h          ��̬�������ʵ��
complete                         kernel/sched.c                      �������
wait_for_completion              kernel/sched.c                      һֱ�ȴ����ʵ�������
complete_and_exit                kernel/exit.c                       ԭ���Ե�֪ͨ��ɲ��˳�
kthread_create                   kernel/sched.c                      �����ں��߳�
kthread_stop                     kernel/sched.c                      ��һ���ں��߳�ֹͣ
kthread_should_stop              kernel/sched.c                      �ں��سǿ���ʹ�øú�����ѯ�Ƿ�������ִ�е�Ԫ�Ѿ�����kthread_stop����ֹͣ
IS_ERR                           include/linux/err.h                 �鿴����ֵ�Ƿ���һ��������



�ڴ�����ʼ��ִ��arch/x86/bootĿ¼�е�ʵģʽ�����룬�鿴arch/x86/kernel/setup_32.c�ļ����Կ���
����ģʽ���ں���ô����ȡʵģʽ�ں��ռ�����Ϣ��

��һ����Ϣ����init/main.c�еĴ��룬�����ھ�int/calibrate.c���Զ�BogoMIPSУ׼���ĸ��������
/include/asm-your-arch/bugs.h�������ϵ�ܹ���صļ�顣

�ں��е�ʱ�������פ����arch/your-arh/kernel�е���ϵ�ܹ���صĲ��ֺ�ʵ����kernel/timer.c�е�ͨ�ò�����ɡ�
��include/linux/time*.h���ļ��п��Ի�ȡ��صĶ��塣

jiffies������linux/jiffise.h�ļ��У�HZ��ֵ�봦������أ����Դ�include/asm-your-arch/param.h�ҵ���
�ڴ����Դ�������ڶ���mmĿ¼�С�

     
     
     









