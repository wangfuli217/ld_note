1. Sysctl��һ���û�Ӧ�������úͻ������ʱ�ں˵����ò�����һ����Ч��ʽ��ͨ�����ַ�ʽ���û�Ӧ�ÿ������ں����е��κ�ʱ��
   ���ı��ں˵����ò�����Ҳ�������κ�ʱ�����ں˵����ò�����
2. Sysctl ��ĿҲ������Ŀ¼����ʱ mode �ֶ�Ӧ������Ϊ 0555������ͨ�� sysctl ϵͳ���ý��޷������������ sysctl ��Ŀ��
   child ��ָ���Ŀ¼��Ŀ�����������Ŀ��������ͬһĿ¼�µĶ����Ŀ������һһע�ᣬ�û����԰�������֯��һ�� 
   struct ctl_table ���͵����飬Ȼ��һ��ע��Ϳ��ԡ�  
   
sysctl(/proc/sys/)
{
ʵ����drivers/scsi/scsi_sysctl.c

/proc/sys/�е��ļ���Ŀ¼������ctl_table�ṹ����ġ�ctl_table�ṹ��ע��ͳ�����ͨ����kernel/sysctl.c�ж����
register_sysctl_table��unregister_sysctl_table������ɡ�

struct ctl_table
{
    const char *procname;        /* proc/sys�����õ��ļ��� */
    void *data;                  /* ��ʾ��Ӧ���ں��еı�������    */
    int maxlen;                  /* ������ں˱����ĳߴ��С */
    �ֶ�maxlen������Ҫ�����ַ����ں˱������Ա��ڶԸ���Ŀ����ʱ���Գ�������󳤶ȵ��ַ����ص����泬���Ĳ���.
    
    mode_t mode;                 /* ������/proc/sys������ļ���Ŀ¼�ķ���Ȩ�� */
    struct ctl_table *child;     /* ���ڽ���Ŀ¼���ļ�֮��ĸ��ӹ�ϵ */
    
    ���к��ļ��������ctl_instance��������proc_handler��ʼ�������ں˻��Ŀ¼����һ��Ĭ��ֵ

    struct ctl_table *parent;    /* Automatically set */
    proc_handler *proc_handler;  /* ��ɶ�ȡ����д������ĺ��� */
    �ֶ�proc_handler����ʾ�ص�����,
    ���������ں˱�����Ӧ������Ϊ&proc_dointvec��
    �����ַ����ں˱�����������Ϊ &proc_dostring��
    
    ��/proc/sys������ļ���д��ʱ�򽫵����������

    ctl_handler *strategy; /* Callback function for all r/w */ 
    ��sysctl��дϵͳ����ʱ�򣬽������������

    struct proc_dir_entry *de; /* /proc control block */ 
    ָ����/proc/sys�еĽ��(proc�ļ�ϵͳ���ݽṹ��

    void *extra1;
    void *extra2;                /* ������ѡ������ͨ�����ڶ����������Сֵ�����ֵ? */
};

�������ļ�������ı������͵Ĳ�ͬ��proc_handler��ָ�ĺ���Ҳ����ͬ��
proc_dostring����/дһ���ַ���
/proc/sys/kernel/core_pattern  �ַ���

proc_dointvec����дһ������һ����������������
/proc/sys/kernel/sched_child_runs_first ����

proc_dointvec_minmax��ͬ�ϣ�����Ҫȷ������������min/max��Χ�ڣ����ڸ÷�Χ�ڵ�ֵ�ᱻ�ܾ�
/proc/sys/kernel/sched_min_granularity_ns ����

�û�̬��ʾ�� - �ں�̬��Ӧjiffies
proc_dointvec_jiffies����дһ���������飬�����ں˱�����jiffiesΪ��λ��ʾ���ڷ����û�ǰ��ת��Ϊ������д��ǰת��Ϊjiffies
/proc/sys/kernel/printk_ratelimit ���� #�����´���Ϣ֮ǰӦ�õȴ���������

�û�̬��ʾ���� -  �ں�̬��Ӧjiffies
proc_dointvec_ms_jiffies��ͬ�ϣ�ֻ��������ת��Ϊ������
/proc/sys/net/ipv4/neigh/default/retrans_time_ms

proc_doulongvec_minmax������proc_dointvec_minmax������ֵΪ��������


proc_doulongvec_ms_jiffies_minmax����ȡһ�����������顣���ں˱�����jiffiesΪ��λ�����û��ռ��Ѻ���Ϊ��λ����ֵҲ����ָ��min��max����


1. extern asmlinkage long sys_sysctl(struct __sysctl_args *args)
    2. int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp, void __user *newval, size_t newlen)
        3. static int parse_table(int __user *name, int nlen,
                void __user *oldval, size_t __user *oldlenp,
                void __user *newval, size_t newlen,
                struct ctl_table_root *root,
                struct ctl_table *table)

typedef int proc_handler (struct ctl_table *ctl, int write, void __user *buffer, size_t *lenp, loff_t *ppos);
                                              д����write=1    ���뻺����buffer   �������ݳ���lenp   ��������ƫ��ppos
                                              ������write=0    ���������buffer   ������ݳ���lenp   �������ƫ��ppos
}

sysfs(ģ�������sysfs)
{


}