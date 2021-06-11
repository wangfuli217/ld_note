/proc/devices ���Բ鿴ע������豸�ţ�                      ---- /dev/
/proc/modules ���Բ鿴����ʹ��ģ��Ľ�������
/lib/modules/2.4.XXĿ¼�����������Ե�ǰ�ں˰汾��ģ�顣
/etc/modules.conf�ļ���������һЩ�����豸�ı�����          mknod�����ô��ļ��ṩ�ı������������������ṩ���豸����
                                                           insmod�������ṩ�Ĳ�������ģ���ṩָ������
�ִ���Linux�ں��������������������豸�ţ������ǿ�������Ȼ���ա�һ �����豸�Ŷ�Ӧһ���������򡰵�ԭ����֯��

cdev(�ֶ�˵��)
{
struct kobject kobj;//��Ƕ��kobject����   
struct module *owner;//����ģ��   
struct file_operations *ops;//�ļ������ṹ��   
struct list_head list; 
dev_t dev;//�豸��,����Ϊ32λ�����и�12Ϊ���豸�ţ���20λΪ���豸��   
unsigned int count;
}
dev_t()
{
���豸�ű�����ĳһ���豸��һ���Ӧ��ȷ�����������򣻴��豸��һ�������ֲ�ͬ���ԣ�

------ ���豸�źʹ��豸�� ------
1�����豸�ű�ʾ�豸��Ӧ���������� /dev/null��/dev/zero����������1�����������̨�ʹ����ն�����������4����
   ���Ƶ�vcsl��vcsal�豸������������7����
   �ִ���Linux�ں��������������������豸�ţ������ǿ����Ĵ�����豸��Ȼ����"һ�����豸�Ŷ�Ӧһ����������"��ԭ����֯��
2�����豸�����ں�ʹ�ã�������ȷȷ���豸�ļ���ָ�����豸��
    �ں˳���֪�����豸������ָ������������ʵ�ֵ��豸֮�⣬�ں˱�����������Ĺ��ڴ��豸�ŵ��κ���Ϣ��

3��dev_t�������������豸��� ---- �������豸�źʹ��豸�� dev_t 32λ(12λ���豸�ţ�20���豸��)��
    <linux/kdev_t.h> MAJOR(dev_t dev) 
                     MINOR(dev_t dev) 
                     MKDEV(int major, int minor)
4��������ͷ��豸���
   ------ ���һ�������豸���(��ȷ֪������Ҫ���豸���)
   int register_chrdev_region(dev_t first, unsigned int count, char *name);
   first:Ҫ������豸��ŷ�Χ����ʼֵ��first�Ĵ��豸�ž���������Ϊ0�����Ըú������������Ǳ���ġ�       �ں��Ƽ�ֵ 
   count: ��������������豸��ŵĸ�����ע�⣬���count�ǳ�����������ķ�Χ���ܺ���һ�����豸���ص�   ����Ϊ1
   name���͸ñ�Ź������豸���ƣ�����������/proc/devices��sysfs�С�(�������ƻ��豸����)                 �����Լ����� 
-> ����������/proc/devices��sysfs�С�
   
   ------ ���һ�������豸���(��̬�����豸���)
   int alloc_chrdev_region(dev_t *dev, unsigned int firstminor, unsigned int count, char *name);         
   dev: ����������Ĳ������ڳɹ���ɵ��ú󽫱����ѷ��䷶Χ�ĵ�һ�����                                  ������� 
   firstminor :Ӧ����Ҫʹ�õı�����ĵ�һ�����豸�ţ���ͨ����0                                           
   count��name������register_chrdev_region����һ��

   ------ �ͷ�ָ�����豸���
   void unregister_chrdev_region(dev_t first, unsigned int count);                                    firstΪ��ȡ���豸�ţ� count��Ϊ1

5����̬�������豸�ź;�̬�������豸��
   documentation/devices.txt ��̬�������豸��
   /proc/devices             ϵͳ�ѷ������豸���� ## awk && ��/devĿ¼�д����豸�ļ�
}


###### ������ϵͳ��rc.local�ļ��е�������ű�����������Ҫģ��ʱ�ֶ����� ######   
#!/bin/sh
# $Id: scull_load,v 1.4 2004/11/03 06:19:49 rubini Exp $
module="scull"
device="scull"
mode="664"

# �����ᵱ�������Լ���ɣ����޸�����
# �������еķ��а涼����staff�飬��Щ��whell��

if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

# ʹ�ô��뵽�ýű������в�������insmod��ͬʱʹ��·������ָ��ģ��λ�á�
# ������Ϊ�µ�modutilsĬ�ϲ����ڵ�ǰĿ�в���ģ��
/sbin/insmod ./$module.ko $* || exit 1

# retrieve major number
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)

# Remove stale nodes and replace them, then give gid and perms
# Usually the script is shorter, it's scull that has several devices in it.
# ɾ�����нڵ�
rm -f /dev/${device}[0-3]
mknod /dev/${device}0 c $major 0
mknod /dev/${device}1 c $major 1
mknod /dev/${device}2 c $major 2
mknod /dev/${device}3 c $major 3
ln -sf ${device}0 /dev/${device}
chgrp $group /dev/${device}[0-3] 
chmod $mode  /dev/${device}[0-3]

rm -f /dev/${device}pipe[0-3]
mknod /dev/${device}pipe0 c $major 4
mknod /dev/${device}pipe1 c $major 5
mknod /dev/${device}pipe2 c $major 6
mknod /dev/${device}pipe3 c $major 7
ln -sf ${device}pipe0 /dev/${device}pipe
chgrp $group /dev/${device}pipe[0-3] 
chmod $mode  /dev/${device}pipe[0-3]

rm -f /dev/${device}single
mknod /dev/${device}single  c $major 8
chgrp $group /dev/${device}single
chmod $mode  /dev/${device}single

rm -f /dev/${device}uid
mknod /dev/${device}uid   c $major 9
chgrp $group /dev/${device}uid
chmod $mode  /dev/${device}uid

rm -f /dev/${device}wuid
mknod /dev/${device}wuid  c $major 10
chgrp $group /dev/${device}wuid
chmod $mode  /dev/${device}wuid

rm -f /dev/${device}priv
mknod /dev/${device}priv  c $major 11
chgrp $group /dev/${device}priv
chmod $mode  /dev/${device}priv


###### scull_load scull_unload scull_init �ű��ļ� ######
scull_init ���������������е���������ѡ�����֧��һ�������ļ�����Ϊ����ű���Ϊ�����͹ػ�ʱ�Զ����ж���Ƶġ�

5���������豸�ŵ���ѷ�ʽ��Ĭ�ϲ��ö�̬���䣬ͬʱ�����ڼ��������Ǳ���ʱָ�����豸�ŵ���ء�
int scull_major =   SCULL_MAJOR;
module_param(scull_major, int, S_IRUGO);

if (scull_major) {
	dev = MKDEV(scull_major, scull_minor);
	result = register_chrdev_region(dev, scull_nr_devs, "scull");
} else {
	result = alloc_chrdev_region(&dev, scull_minor, scull_nr_devs,
			"scull");
	scull_major = MAJOR(dev);
}

file_operations()
{
6���ļ�����file_operations

    1. file_operations <linux/fs.h>
    2. file_operations�ṹ����ָ������ṹ��ָ���Ϊfops������ṹ�е�ÿһ���ֶζ�����ָ������������ʵ���ض������ĺ�����
    3.__user�ַ���������ʵ��һ����ʽ���ĵ����ѣ�����ָ����һ���ÿռ��ַ����˲��ܱ�ֱ�����ã���ͨ���ı���������
      __userû���κ�Ч�����ǿ����ⲿ������ʹ�ã�����Ѱ�Ҷ��û��ռ��ַ�Ĵ���ʹ�á�

    4. struct module *owner ָ��"ӵ��"�ýṹ��ģ��ָ�롣���������е�����£��ó�Ա���ᱻ��ʼ��ΪTHIS_MODULE�����Ƕ�����linux/module.h�еĺꡣ
	5. llseek ΪNULL����seek�ĵ��ý�����ĳ�ֲ���Ԥ�ڵķ�ʽ�޸�file�ṹ
	6. readΪNULL��������readϵͳ���ó�������-EINVAL��
	    1. ssize_t read(struct file *filp, char __user *buff, size_t count, loff_t *offp); # ssize_t signed size type
		2. �������ֵ���ڴ��ݸ�readϵͳ���õ�count��������˵����������ֽ�������ɹ���
		3. ������������ģ����Ǳ�countС����˵��ֻ�в������ݳɹ����ݡ�����������豸�Ĳ�ͬ�����ж���������󲿷�����£���������¶����ݡ�
		4. �������ֵΪ0�����ʾ�Ѿ��ﵽ���ļ�β
		5. ��ֵ��ζ�ŷ����˴��󣬸�ֵָ���˷���ʲô����
		6. ���������ڻ�û�����ݣ����Ժ���ܻ��С�
		
	7. aio_readΪNULL�����еĲ�����ͨ��readͬ������
	8. write ΪNULL�����س���һ��-EINVAL
		1. ssize_t write(struct file *filp, char __user *buff, size_t count, loff_t *offp);
		2. �������ֵ����count������������������ݵ��ֽڴ��͡�
		3. �������ֵ�����ģ�����С��count����ָ�����˲������ݡ�����ܿ����ٴ���ͼд�����µ����ݡ�
		4. ���ֵΪ0����ζֵʲôҲû��д�롣���������Ǵ��󣬶���Ҳû�����ɷ���һ�������롣
		5. ��ֵ��ζ�ŷ����˴�����read��ͬ��
		��Щ�������ֻ�����˲��ִ���ͱ����쳣�˳�����������ķ��������ڳ���Աϰ���϶�write����Ҫôʧ��Ҫô����ȫ�ɹ���
		
	9. aio_write ��ʼ���豸�ϵ��첽д�������
	10. poll������poll��select��epoll����ϵͳ���õĺ��ʵ�֡�
	11. ����豸��֧��ioctl��������-ENOTTY No Such ioctl for device
        #����豸���ṩ������������ں��ֲ�ʶ�������򷵻�-EINVAL.
	12. mmapΪNULL��������-ENODEV;
	13. openΪNULL���豸�Ĵ򿪲�����Զ�ɹ�����ϵͳ����֪ͨ��������
	    1. ����豸�ض��Ĵ���(�����豸δ���������Ƶ�Ӳ������)��
		2. ����豸���״δ򿪣��������г�ʼ��
		3. ����б�Ҫ������f_opָ��
		4. ���䲢��д����filp->private_data������ݽṹ
		
		int (*open)(struct inode *inode, struct file *filp) /* inode�����ײ��豸�� filp�����ϲ�Ӧ�ý��� */
		���е�inode����������i_cdev�ֶ��а�������������Ҫ����Ϣ����������ǰ���õ�cdev�ṹ��Ψһ�������ǣ�
		����ͨ������Ҫcdev�ṹ��������ϣ���õ�����cdev�ṹ��scull_dev�ṹ��
		contianer_of(pointer, container_type, container_field)
		
		struct scull_dev *dev;
		dev = container_of(inode->i_cdev, struct scull_dev, cdev);
		filp->private_data = dev;
		
		��һ��ȷ��Ҫ�򿪵��豸�ķ����ǣ���鱣����inode�ṹ�еĴ��豸�š������������register_chrdevע���Լ����豸�������ʹ�øü�����
		��һ��ʹ��iminor���Inode�ṹ�л�Ĵ��豸�ţ���ȷ������Ӧ��������������׼���򿪵��豸��
		
	14. flush����flush�����ĵ��÷����ڽ��̹ر��豸�ļ�������������ʱ����Ӧ��ִ��(���ȴ�)�豸����δ���Ĳ�����
	    �벻Ҫ����ͬ�û������fsync����������Ŀǰflush���������������������������flush������ΪNULL���ں˽��򵥵غ���
		�û�Ӧ�ó��������
	15. release����file�ṹ���ͷ�ʱ�������������������open��£�Ҳ���Խ�release�豸ΪNULL��
	    1. �ͷ���open����ġ�������filp->private_data�е���������
		2. �����һ�ιرղ���ʱ�ر��豸
		������ÿ��closeϵͳ���ö��������release�����ĵ��á�ֻ����Щ�����ͷ����ݽṹ��close���òŻ�������������
		�ں˶�ÿ��file�ṹά���䱻ʹ�ö��ٴεļ�����������fork����dup�������ᴴ���µ����ݽṹ(����open����)��
fsync - fsync aio_fsync fasync - FASYNC��ʶ readv writev sendfile sendpage get_unmapped_area check_flag dir_notify

readv writev # �ں˽���ͨ��read��write��ģ�����ǣ������ս����Ȼ��ˡ�
}

THIS_MODULE(){
THIS_MODULE��һ��macro��������<linux/module.h>�У�
#ifdef MODULE
#define MODULE_GENERIC_TABLE(gtype,name)            \
extern const struct gtype##_id __mod_##gtype##_table        \
  __attribute__ ((unused, alias(__stringify(name))))

extern struct module __this_module;
#define THIS_MODULE (&__this_module)
#else  /* !MODULE */
#define MODULE_GENERIC_TABLE(gtype,name)
#define THIS_MODULE ((struct module *)0)
#endif
THIS_MODULE����__this_module��������ĵ�ַ��__this_module��ָ�����ģ����ʼ�ĵ�ַ�ռ䣬ǡ����struct module���������λ�á�

file_operations�ṹ��ĵ�һ����Ա��struct module���͵�ָ�룬������<linux/fs.h>�У�
struct file_operations {
    struct module *owner;
    ......
}

ownerָ���file_operations��ģ�顣�ڴ��ʱ��ֻ���THIS_MODULE���������ɡ�

}

unsigned long copy_to_user(void __user *to, const void *from unsigned long count);����# -EFAULT ->read
unsigned long copy_from_user(void *to, const void __user *from unsigned long count);��# -EFAULT ->write
��Ѱַ�ڴ治���ڴ��У������ڴ���ϵͳ�Ὣ�ý���ת��˯��״̬��ֱ����ҳ�汻������������λ�á�
Ҫ�󣺷����û��ռ���κκ����������ǿ�����ģ����ұ����ܺ�������������������ִ�У����ر���ǣ����봦���ܹ��Ϸ����ߵ�״̬��

����1,2,4,8�ֽ����ݴ��ݷ�ʽ��
#define put_user(x, ptr)    #define __put_user(x, ptr)
#define get_user(x, ptr)	#define __get_user(x, ptr) 



struct file_operations scullc_fops = {
	.owner =     THIS_MODULE,
	.llseek =    scullc_llseek,
	.read =	     scullc_read,
	.write =     scullc_write,
	.ioctl =     scullc_ioctl,
	.open =	     scullc_open,
	.release =   scullc_release,
	.aio_read =  scullc_aio_read,
	.aio_write = scullc_aio_write,
};
��ǻ��ĳ�ʼ����������Խṹ��Ա�����������С���ĳЩ�����£���Ƶ�������ʵĳ�Ա������ͬ��Ӳ���������ϣ�������������

file()
{
7���ļ�����file
����һ���򿪵��ļ��������ں���openʱ�����������ݸ��ڸ��ļ��Ͻ��в��������к�����ֱ������close������
���ļ�������ʵ�������ر�֮���ں˻��ͷ�������ݽṹ��
    1.	f_mode  FMODE_READ FMODE_WRITE �ں��ڵ������������read��writeǰ�Ѿ�����˷���Ȩ�ޣ����Բ���Ϊ�������������Ȩ�ޡ�
	2.  f_pos   ��ǰ�Ķ�дλ��
	3.  f_flags �ļ���־
	4.  f_op ���ļ���صĲ������ں���ִ��open����ʱ�����ָ�븳ֵ���Ժ���Ҫ������Щ����ʱ�Ͷ�ȡ���ָ�롣filp->f_op�е�ֵ������Ϊ����
        ���ö�����������Ҳ����˵�����ǿ������κ���Ҫ��ʱ���޸��ļ��Ĺ����������ڷ��ص�����֮���µĲ���������������Ч�����磺
		��Ӧ�����豸��1(/dev/null��/dev/zero�ȵ�)��open�������Ҫ�򿪵Ĵ��豸���滻filp->f_op�еĲ��������ּ���������ͬ���豸
		�µ��豸ʵ�ֶ��ֲ�����Ϊ������������ϵͳ���õĸ����������滻�ļ���������������������̼����г�Ϊ"��������"��
		
	5. private_data openϵͳ�����ڵ������������open����ǰ�����ָ������ΪNULL������������Խ�����ֶ������κ�Ŀ�Ļ��ߺ�������ֶΡ�
        ��һ��Ҫ���ں�����file�ṹǰ��release�������ͷ��ڴ棬private_data�ǿ�ϵͳ����ʱ����״̬��Ϣ�ķǳ����õ���Դ��
    6. f_dentry: �ļ���Ӧ��Ŀ¼�ṹ��������filp->f_dentry->d_inode�ķ�ʽ�����������ڵ�֮�⣬�豸��������Ŀ�����һ���������dentry�Ľṹ

8�� inode
    1. dev_t i_rdev; �Ա�ʾ�豸�ļ���inode�ṹ�����ֶΰ������������豸���
    ���inode����һ���豸����i_rdev��ֵΪ�豸�š�Ϊ�˴�����õؿ���ֲ�ԣ���ȡinode��major��minor��Ӧ��ʹ��imajor��iminor������
    2. struct cdev *i_cdev ��ʾ�ַ��豸���ں˵��ڲ��ṹ����Inodeָ��һ���ַ��豸�ļ�ʱ�����ֶΰ�����ָ��struct cdev�ṹ��ָ�롣
    unsigned int  iminor(struct inode *inode)
    unsigned int  imajor(struct inode *inode)
9�� cdev
    struct cdev *my_cdev = cdev_alloc();
	my_cdev->ops = &my_fops;
	��
	void cdev_init(struct cdev *cdev, struct file_operations *fops);
	
	int cdev_add(struct cdev *dev, dev_t num, unsigned int count)
	ֻҪcdev_add�����ˣ����ǵ��豸��"��"�ˣ����Ĳ����ͻᱻ�ں˵��á���ˣ��������ɻ�û����ȫ׼���ô����豸�ϵĲ���ʱ���Ͳ��ܵ���cdev_add.
	
	void cdev_del(struct cdev *dev)
	Ҫ������ǣ��ڽ�cdev�ṹ���ݸ�cdev_del����֮�󣬾Ͳ�Ӧ���ٷ���cdev�ṹ�ˡ�
}

cdev(˵��){
#include <linux/kobject.h>
#include <linux/kdev_t.h>
#include <linux/list.h>

struct file_operations;
struct inode;
struct module;

struct cdev {
    struct kobject kobj;
    struct module *owner;
    const struct file_operations *ops;
    struct list_head list;
    dev_t dev;
    unsigned int count;
};

void cdev_init(struct cdev *, const struct file_operations *);
struct cdev *cdev_alloc(void);
void cdev_put(struct cdev *p);
int cdev_add(struct cdev *, dev_t, unsigned);
void cdev_del(struct cdev *);
void cd_forget(struct inode *);

����ͳ�ʼ��cdev�ṹ������ַ�ʽ��
struct cdev *my_cdev = cdev_alloc();
my_cdev->ops = &my_fops;
my_cdev->owner = THIS_MODULE;

������һ����cdevǶ�뵽�����豸�Ľṹ���У�

struct scull_dev {
    ......
    struct cdev cdev; /* Char device structure */
    ......
};

static void scull_setup_cdev(struct scull_dev *dev, int index)
{
    int err, devno = MKDEV(scull_major, scull_minor + index);
    cdev_init(&dev->cdev, &scull_fops);
    dev->cdev.owner = THIS_MODULE;
    dev->cdev.ops = &scull_fops;
    ......
}

���ַ�ʽ��Ҫע���owner��ֵΪTHIS_MODULE��

��ʼ��cdev�ṹ���Ժ�Ҫʹ��cdev_add���豸����ϵͳ��
Ҫע��countָ������������minor number����

ɾ���豸ʹ��cdev_del������
2.6�汾֮ǰ��ע���ɾ���豸��register_chrdev��unregister_chrdev�����Ѿ���ʱ������ʹ�á�
}


register_chrdev()
{
10���������Ͻӿڣ�
int register_chrdev(unsigned int major, congst char *name, struct file_operations *fops);
major:�豸�����豸��
name��������������� /proc/devices (�ɼ�����ӿڲ�֧��sysfs)
fops����Ĭ�ϵ�file_operations�ṹ
��register_chrdev�ĵ��ý�Ϊ���������豸��ע��0~255��Ϊ���豸�ţ���Ϊÿ���豸����һ����Ӧ��cdev�ṹ�� 
���豸�źʹ��豸�Ų���ʹ�ô���255�ġ�

int unregister_chrdev(unsigned int major, const char *name);
major��name�����봫�ݸ�register_chrdev������ֵ����һ�£�����õ��û�ʧ�ܡ�
}



11���ڴ�ʹ��
void *kmalloc(size_t size, int flags); # flags: GFP_KERNEL
void kfree(void *ptr); # ��NULL���ݸ�kfree�ǺϷ���


register_chrdev_region 		�� register a range of device numbers
alloc_chrdev_region 		�� register a range of char device numbers
__register_chrdev 			�� create and register a cdev occupying a range of minors
unregister_chrdev_region 	�� unregister a range of device numbers
__unregister_chrdev 		�� unregister and destroy a cdev
cdev_add 					�� add a char device to the system
cdev_del 					�� remove a cdev from the system
cdev_alloc 					�� allocate a cdev structure
cdev_init 					�� initialize a cdev structure


nonseekable_open() 
{
    ʹ��������ʱ������ʹ�� lseek ���������µض�λ���ݡ����񴮿ڻ����һ���豸��ʹ�õ�����������
���Զ�λ��Щ�豸û�����壻����������£����ܼ򵥵ز����� llseek ��������ΪĬ�Ϸ���������λ�ġ�

    �� open �����е��� nonseekable_open() ʱ������֪ͨ�ں��豸��֧�� llseek��nonseekable_open() 
������ʵ�ֶ����� fs/open.c �У�
}