linux/proc_fs.h
�ʺϵ�ʵ����ʽ�����


instance(gen_rtc_proc_init)
{
drivers/char/genrtc.c ��gen_rtc_proc_init����

sysrq-trigger:  write_sysrq_trigger ֻ������ʱ���ע�᣿

kpagecount��fs/proc/page.c
kpageflags��fs/proc/page.c   max_pfn
}
�ں˻����һ���ڴ�ҳ(��PAGE_SIZE�ֽڵ��ڴ��)������������Խ�����ͨ������ڴ�ҳ���ص��û��ռ䡣

read_proc_t()
{
typedef	int (read_proc_t)(char *page, char **start, off_t off, int count, int *eof, void *data);
page���ں��ṩ���������ڴ�ҳ(��С�� PAGE_SIZE ����)����������������д����Ϣ��
       pointer to a kernel buffer
start���ں��ṩ�������ģ�������ʾ��������ǰ���ṩ�� Page ���ĸ����ֿ�ʼд�����ݡ�
        start ˵��������Ӧ�ô��ں��ṩ�� Page ���Ǹ�λ�ÿ�ʼ"д"��
         pointer (optional) to module�� own buffer 
offset��offset �����û��ռ䴫���ں˵Ĳ��������ڸ����ں˴� proc ������ļ����ĸ�ƫ�ƿ�ʼ��ȡ���ݡ�
        offset ˵���˴Ӵ���ȡ���ļ����ĸ�λ�ÿ�ʼ"��"��
        current file-pointer offset 
count��  size of space available in the kernel��s buffer   
eof ָ��һ������ֵ����û�����ݷ���ʱ��������������������������
    ���*eof�ڷ���ǰδ����ֵ��Ϊ�˶�ȡ��������ݽ����ٴε���procfs����ڵ㡣
    �����*eof��ֵ����ע�͵������ٴε���readme_proc()����ƫ�Ʋ�����Ϊ1190(1190�Ǵ�Node No:0��Node No:99���ַ�����ASCII�ֽ���)
    readme_proc()�����Ѹ��Ƶ����������ֽ�����
    
data���������ṩ�����������ר������ָ�룬�������ڲ���¼��

start���÷��е㸴�ӣ����԰���ʵ�ִ���һ���ڴ�ҳ��/proc�ļ���
      start�������÷���������Щ�ر�������ֻ��Ҫ���ظ��û������ݱ������ڴ�ҳ��ʲôλ�á�
	  �����ǵ�read_proc����������ʱ��*start�ĳ�ʼֵΪNULL��
	  �������*startΪ�գ��ں˽��������ݱ������ڴ�ҳƫ����Ϊ0�ĵط���Ҳ����˵���ں˽���read_proc�����¼��裺
	  �ú����������ļ����������ݷŵ����ڴ�ҳ����ͬʱ����offset������
	  ���*startΪ�ǿգ��ں˽���Ϊ��*startָ���������offsetָ����ƫ�����������ݣ���ֱ�ӷ��ظ��û���
	  fs/proc/generic.c

################### readme_proc �ٴα�����  ###################
1. readme_proc�����ö�Σ�ÿ�ε��û�ȡ��offset��ʼ�����������Ϊcount���ֽ�����ÿ�ε���ʱ��������ֽ�С��һҳ��
2. ÿ�ε��ã��ں˽�offset���ӣ����ӵĴ�СΪ�ϴε��÷��ص��ֽ�����
3. ����������ֽ����뵱ǰƫ�Ƶĺʹ��ڻ����ʵ�ʵ�������ʱ��readme_proc��Ϊeof��ֵ����eofδ����ֵ����˺�����
   ���ٴε��ã�����ʱ��offset�������ϴζ�ȡ���ֽ�����
4. ÿ�ε��ú󣬽���*start����ʼ���ֽڱ��ռ��������������ߡ�
   



�ϵ�/proc�ӿ�
	int (*get_info)(char *page, char **start, off_t offset, int count);
	 
struct proc_dir_entry *create_proc_read_entry(const char *name, 
		mode_t mode, struct proc_dir_entry *base, read_proc_t *read_proc, void *data);
name: Ҫ�������ļ�����
mode���Ǹ��ļ��ı�������
base���ļ����ڵ�Ŀ¼(���baseΪNULL�����ļ���������/proc�ĸ�Ŀ¼)
read_proc:
data: �ں˻����data���������ǻὫ�ò������ݸ�read_func_proc��

void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
struct remove_proc_entry("scullmem", NULL);
���ɾ�������ʧ�ܣ�������δԤ�ڵĵ��ã����ģ���ѱ�ж�أ��ں˻������

}

create_proc_entry(create_proc_entry,remove_proc_entry)
{
struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
                                          struct proc_dir_entry *parent)
�ú������ڴ���һ��������proc��Ŀ������name����Ҫ������proc��Ŀ�����ƣ�����mode�����˽����ĸ�proc��Ŀ�ķ���Ȩ�ޣ�
����parentָ��������proc��Ŀ���ڵ�Ŀ¼�����Ҫ��/proc�½���proc��Ŀ��parentӦ��ΪNULL��������Ӧ��Ϊproc_mkdir
���ص�struct proc_dir_entry�ṹ��ָ�롣

extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
�ú�������ɾ�����溯��������proc��Ŀ������name����Ҫɾ����proc��Ŀ�����ƣ�����parentָ��������proc��Ŀ���ڵ�Ŀ¼��                    
}

proc_mkdir(proc_mkdir,proc_mkdir_mode,proc_symlink)
{
struct proc_dir_entry *proc_mkdir(const char * name, struct proc_dir_entry *parent)
�ú������ڴ���һ��procĿ¼������nameָ��Ҫ������procĿ¼�����ƣ�����parentΪ��procĿ¼���ڵ�Ŀ¼��

extern struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode, struct proc_dir_entry *parent); 
struct proc_dir_entry *proc_symlink(const char * name, struct proc_dir_entry * parent, const char * dest)

�ú������ڽ���һ��proc��Ŀ�ķ������ӣ�����name����Ҫ�����ķ�������proc��Ŀ�����ƣ�����parentָ�������������ڵ�Ŀ¼��
����destָ�����ӵ���proc��Ŀ���ơ�
}

create_proc_read_entry(create_proc_read_entry,create_proc_info_entry)
{
struct proc_dir_entry *create_proc_read_entry(const char *name, mode_t mode, struct proc_dir_entry *base, read_proc_t *read_proc, void * data)

�ú������ڽ���һ�������ֻ��proc��Ŀ������name����Ҫ������proc��Ŀ�����ƣ�����mode�����˽����ĸ�proc��Ŀ�ķ���Ȩ�ޣ�
����baseָ��������proc��Ŀ���ڵ�Ŀ¼������read_proc������ȥ��proc��Ŀ�Ĳ�������������dataΪ��proc��Ŀ��ר�����ݣ�
���������ڸ�proc��Ŀ��Ӧ��struct file�ṹ��private_data�ֶ��С�

struct proc_dir_entry *create_proc_info_entry(const char *name,
        mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
�ú������ڴ���һ��info�͵�proc��Ŀ������name����Ҫ������proc��Ŀ�����ƣ�����mode�����˽����ĸ�proc��Ŀ�ķ���Ȩ�ޣ�
����baseָ��������proc��Ŀ���ڵ�Ŀ¼������get_infoָ����proc��Ŀ��get_info����������ʵ����get_info��ͬ��read_proc��
���proc��Ŀû�ж����read_proc���Ը�proc��Ŀ��read������ʹ��get_infoȡ����������ڹ����Ϸǳ������ں���
create_proc_read_entry��
}

proc_net_create()
{
struct proc_dir_entry *proc_net_create(const char *name, mode_t mode, get_info_t *get_info)

�ú���������/proc/netĿ¼�´���һ��proc��Ŀ������name����Ҫ������proc��Ŀ�����ƣ�����mode�����˽����ĸ�proc��Ŀ�ķ���Ȩ�ޣ�
����get_infoָ����proc��Ŀ��get_info����������

struct proc_dir_entry *proc_net_fops_create(const char *name,
        mode_t mode, struct file_operations *fops)
�ú���Ҳ������/proc/net�´���proc��Ŀ��������Ҳͬʱָ���˶Ը�proc��Ŀ���ļ�����������

void proc_net_remove(const char *name)
�ú�������ɾ��ǰ������������/proc/netĿ¼�´�����proc��Ŀ������nameָ��Ҫɾ����proc���ơ�

}

proc_dir_entry()
{
������Щ������ֵ��һ����ǽṹstruct proc_dir_entry��Ϊ�˴���һ�˿�д��proc��Ŀ��ָ����proc��Ŀ��д������������������
�������Щ����proc��Ŀ�ĺ������ص�ָ��ָ���struct proc_dir_entry�ṹ��write_proc�ֶΣ���ָ����proc��Ŀ�ķ���Ȩ����д
Ȩ�ޡ�

Ϊ��ʹ����Щ�ӿں����Լ��ṹstruct proc_dir_entry���û�������ģ���а���ͷ�ļ�linux/proc_fs.h��
}

2��write_proc_t
typedef	int (write_proc_t)(struct file *file, const char __user *buffer, unsigned long count, void *data);



------ csdn ------
һ���ȿ���֮ǰ�汾��/proc/�´����ļ����ṩops
	proc_dir = proc_mkdir(MOTION_PROC_DIR, NULL);
	if (!proc_dir) {
		err = -ENOMEM;
		goto no_proc_dir;
	}
	proc_file = create_proc_entry(MOTION_PROC_FILE, 0666, proc_dir);
	if (!proc_file) {
		err = -ENOMEM;
		goto no_proc_file;
	}
	proc_file->proc_fops = &event_fops;
	
��������Linux3.10�汾��ͬ����
	proc_dir = proc_mkdir(MOTION_PROC_DIR, NULL);
	if (!proc_dir) {
			err = -ENOMEM;
			goto no_proc_dir;
	}
	//modify by tan for linux3.10
	//proc_file = create_proc_entry(MOTION_PROC_FILE, 0666, proc_dir);
	proc_file = proc_create(MOTION_PROC_FILE, 0666, proc_dir,&event_fops);
	//end tank
	if (!proc_file) {
			err = -ENOMEM;
			goto no_proc_file;
	}
	//proc_file->proc_fops = &event_fops;  //modify by tank for linux3.10
	
	
------ ibm ------
proc_dir_entry		���ļ�ϵͳ�е�λ��
proc_root_fs		/proc
proc_net			/proc/net
proc_bus			/proc/bus
proc_root_driver	/proc/driver	

## ����
struct proc_dir_entry *proc_symlink(const char *,struct proc_dir_entry *, const char *);  # �����ļ�
struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);                  # Ŀ¼�ļ�
struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode, struct proc_dir_entry *parent); # Ŀ¼�ļ���������
struct proc_dir_entry *proc_create(const char *name, mode_t mode,                         #
	struct proc_dir_entry *parent, const struct file_operations *proc_fops);
static inline struct proc_dir_entry *create_proc_read_entry(const char *name,             # ����ֻ���ļ�
	mode_t mode, struct proc_dir_entry *base, 
	read_proc_t *read_proc, void * data);


struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,                  # �����ļ�
						struct proc_dir_entry *parent);
struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
				struct proc_dir_entry *parent,
				const struct file_operations *proc_fops,
				void *data);
## ɾ��
void remove_proc_entry(const char *name, struct proc_dir_entry *parent);

proc_dir_entry��proc_fops �� read_proc��write_proc�ǻ�����ù�ϵ


------ proc_create
struct proc_dir_entry *mytest_dir = proc_mkdir("mytest", NULL);

Ȼ��������proc�ļ��Ĵ�����
���������ǵ������º�����
static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode,
struct proc_dir_entry *parent, const struct file_operations *proc_fops);
name����Ҫ�������ļ�����
mode���ļ��ķ���Ȩ�ޣ���UGO��ģʽ��ʾ��
parent��proc_mkdir�е�parent���ơ�Ҳ�Ǹ��ļ��е�proc_dir_entry����
proc_fops���Ǹ��ļ��Ĳ��������ˡ�
���磺
struct proc_dir_entry *mytest_file = proc_create("mytest", 0x0644, mytest_dir, mytest_proc_fops);
����һ�ַ�ʽ��
struct proc_dir_entry *mytest_file = proc_create("mytest/mytest", 0x0644, NULL, mytest_proc_fops);
����ļ������ƺ��ļ�������Ϊ������
#define MYTEST_PROC_DIR "mytest"
#define MYTEST_PROC_FILE "mytest"
�ڶ��ַ�ʽΪ��
struct proc_dir_entry *mytest_file = proc_create(MYTEST_PROC_DIR"/"MYTEST_PROC_FILE, 0x0644, NULL, mytest_proc_fops);

����������mytest_proc_fops�Ķ��塣
static const struct file_operations mytest_proc_fops = {
 .open  = mytest_proc_open,
 .read  = seq_read,
 .write  = mytest_proc_write,
 .llseek  = seq_lseek,
 .release = single_release,
};