linux/seq_file.h
�ʺ϶�ʵ����ʽ�������
�Ե�ʵ���ģ���ͨ�����������֯

https://www.ibm.com/developerworks/cn/linux/l-kerns-usrs2/
instance(iomem ioport)
{
��ʾresource�������ݣ�resource�����ַ�Ϊiomem��ioport���ࡣ
iomem :kernel/resource.c
iomem_resource����kernel/resoure.c�б���ʼ������driver/Ŀ¼�µ������б����á�
ioport:kernel/resource.c
ioport_resource����kernel/resoure.c�б���ʼ������driver/Ŀ¼�µ������б����á�

buddyinfo:       mm/vmstat.c   ��ʾpg_data_t�������ݣ�        �ڴ��������㷨
pagetypeinfo:    mm/vmstat.c   ��ʾpg_data_t�������ݣ�        ��ͬ����page�Ļ���㷨
vmstat:          mm/vmstat.c   ��ʾvm_event_state�������ݣ�   ���������ڴ�״̬
zoneinfo:        mm/vmstat.c   ��ʾpg_data_t�������ݣ�        zone

meminfo��        fs/proc/meminfo.c ��ʾsysinfo�������ݺ�page��ͳ����Ϣ��
ֱ�ӵ�����single_open(file, meminfo_proc_show, NULL);������

vmallocinfo:      mm/vmalloc.c  ��ʾvm_struct��������ݣ�

uptime��         fs/proc/uptime.c
}

1. seq�ļ��ӿھ������ڼ�procfs��read()�������������������ʱ���ں˸������ơ�seq�ļ�ʹprocfs������Ϊ�򵥡����ˡ�
seq_file *m->private�����ڴ洢����֮�乲���ݵı������ñ�������open�����б���ʼ����
   ���������
start stop next show�е�void *v�����ڴ洢���̱������ݹ����ӡ� start��next�ķ���ֵ���ǵݹ����ӡ�Ȼ����show�г��ֳ�����
   ʵ�ִ�������
   
seq_operations()
{
struct seq_operations {
        void * (*start) (struct seq_file *m, loff_t *pos);
        void (*stop) (struct seq_file *m, void *v);
        void * (*next) (struct seq_file *m, void *v, loff_t *pos);
        int (*show) (struct seq_file *m, void *v);
};
start��������ָ��seq_file�ļ��Ķ���ʼλ�ã�����ʵ�ʶ���ʼλ�ã����ָ����λ�ó����ļ�ĩβ��Ӧ������NULL��
      �����ȱ�seq�ӿڵ��ã����ڳ�ʼ���������е�λ�ã��������ҵ��ĵ�һ����������
start����������һ������ķ���SEQ_START_TOKEN����������show��������ļ�ͷ������ֻ����posΪ0ʱʹ�á�

next�������ڰ�seq_file�ļ��ĵ�ǰ��λ���ƶ�����һ����λ�ã�����ʵ�ʵ���һ����λ�ã�����Ѿ������ļ�ĩβ������NULL��
    ��������λ��ǰ�ƣ���������һ���������ָ�롣�˺������ڵ���������ں˽ṹ���ǲ���֪�������俴��Ϊͨ������
    
stop���������ڶ���seq_file�ļ�����ã����������ļ�����close��������һЩ��Ҫ���������ͷ��ڴ�ȣ�
    �ڽ���ʱ�����ã����һЩ��������
    
show�������ڸ�ʽ�����������ɹ�����0�����򷵻س����롣
    ���ڽ��ʹ��ݸ����ĵ������󣬲����û���ȡ��Ӧ��procfs�ļ�ʱ��������ʾ������ַ������˷���ʹ����һЩ����������
    seq_printf() seq_putc() seq_puts ��ʽ�������
    
}

Seq_file()
{
int seq_putc(struct seq_file *m, char c);
����seq_putc���ڰ�һ���ַ������seq_file�ļ���

int seq_puts(struct seq_file *m, const char *s);
����seq_puts�����ڰ�һ���ַ��������seq_file�ļ���

int seq_escape(struct seq_file *, const char *, const char *);
����seq_escape������seq_puts��ֻ�ǣ������ѵ�һ���ַ��������г��ֵİ����ڵڶ����ַ��������е��ַ����հ˽�����ʽ�����
Ҳ������Щ�ַ�����ת�崦��

int seq_printf(struct seq_file *, const char *, ...)
        __attribute__ ((format (printf,2,3)));

����seq_printf����õ���������������ڰѸ����������ո����ĸ�ʽ�����seq_file�ļ���

int seq_path(struct seq_file *, struct vfsmount *, struct dentry *, char *);

����seq_path����������ļ������ַ��������ṩ��Ҫת����ļ����ַ�������Ҫ���ļ�ϵͳʹ�á�

�ڶ����˽ṹstruct seq_operations֮���û�����Ҫ�Ѵ�seq_file�ļ���open�������Ա�ýṹ���Ӧ��seq_file�ļ���struct file�ṹ�������������磬struct seq_operations����Ϊ��

struct seq_operations exam_seq_ops = {
   .start = exam_seq_start,
   .stop = exam_seq_stop,
   .next = exam_seq_next,
   .show = exam_seq_show
};

��ô��open����Ӧ�����¶��壺

static int exam_seq_open(struct inode *inode, struct file *file)
{
    return seq_open(file, &exam_seq_ops);
};

ע�⣬����seq_open��seq_file�ṩ�ĺ����������ڰ�struct seq_operations�ṹ��seq_file�ļ����������� ����û���Ҫ��������struct file_operations�ṹ��

struct file_operations exam_seq_file_ops = {
        .owner   = THIS_MODULE,
        .open    = exm_seq_open,     
        .read    = seq_read,         /* built-in helper function */
        .llseek  = seq_lseek,        /* built-in helper function */
        .release = seq_release       /* built-in helper function */
};

ע�⣬�û�����Ҫ����open�����������Ķ���seq_file�ṩ�ĺ�����

Ȼ���û�����һ��/proc�ļ����������ļ���������Ϊexam_seq_file_ops���ɣ�

struct proc_dir_entry *entry;
entry = create_proc_entry("exam_seq_file", 0, NULL);
if (entry)
entry->proc_fops = &exam_seq_file_ops;

���ڼ򵥵������seq_file�û�������Ҫ�����������ô�ຯ����ṹ�������趨��һ��show������Ȼ��ʹ��single_open������open�����Ϳ��ԣ�
}


void *(*start) (struct seq_file *m, loff_t *pos);
sfile�����������ڴ��������º��ԡ�pos��һ��������λ��ֵ����ʾ��ȡ��λ�á���λ�õĽ�����ȫȡ���ڵ�������ʵ�ֱ���
����һ���ǵ��ǽ���ļ����ַ�λ�á���Ϊseq_file��ʵ��ͨ����Ҫ����һ����Ŀ���У����λ��ͨ��������Ϊָ����������һ
��Ŀ���αꡣ
�����pos�Ϳɼ���Ϊscull_devices�����������


void (*stop) (struct seq_file *m, void *v);


void *(*next) (struct seq_file *m, void *v, loff_t *pos);
v ����ǰ��start����next�ĵ��������صĵ�������pos���ļ��ĵ�ǰλ�ã�next����Ӧ����posָ���ֵ��
�������ڵ������Ĺ�����ʽ��

int (*show) (struct seq_file *m, void *v);
v��Ϊ��ָ�����Ŀ���������

int seq_printf(struct seq_file *sfile, const char *fmt, ...)  ## ��ʽ���������
	__attribute__ ((format (printf,2,3)));
	
int seq_escape(struct seq_file *sfile, const char *s, const char *esc); ## �ȼ���puts��ֻ����s�е�ĳ���ַ�Ҳ������esc�У�
    ����ַ����԰˽�����ʽ��ӡ�����ݸ�esc�����ĳ���ֵΪ"\t\n\\"
int seq_putc(struct seq_file *m, char c);             ## �û��ռ�putc
int seq_puts(struct seq_file *m, const char *s);      ## �û��ռ�puts
int seq_path(struct seq_file *, struct path *, char *); ## ���������ĳ��Ŀ¼�������ļ���



