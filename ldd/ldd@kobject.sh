kobject(Ϊ�ں˽�����һ��ͳһ���豸ģ��)
{
-----------------------------------------------------------------------------------
2.6����豸ģ���ṩ��[��ϵͳ�ṹ��һ���Գ�������]�����ĳ��������ں�ʹ�øó���֧���˶��ֲ�ͬ���������а�����
1. ��Դ�����ϵͳ�ػ���һ��USB�������������ڴ����������������ӵ��豸ǰ�ǲ��ܱ��رյġ��豸ģ��ʹ�ò���ϵͳ�ܹ�����ȷ��˳�����ϵͳӲ����
2. ���û��ռ�ͨ�ţ�sysfs�����չʾ�����������Ľṹ�����û��ռ����ṩ��ϵͳ��Ϣ���Լ��ı���������Ľӿڣ���Խ��Խ��ͨ��sysfsʵ�֡�
3. �Ȳ���豸����Χ�豸�ɸ����û�������װ��ж�ء�
4. �豸���ͣ��豸ģ���н��豸����Ļ��ơ�
5. �����������ڣ��豸ģ�͵�ʵ����Ҫ����һϵ�л����Դ��������������ڣ�����֮��Ĺ�ϵ���Լ���Щ�������û��ռ��еı�ʾ��

sysfs�ļ�ϵͳ��һ������ ram ���ļ�ϵͳ���û��ռ�ɷ��ʣ�������֯ bus��device��driver�Ĳ�νṹ
kobject����Ӧsysfs�ļ�ϵͳ��һ��Ŀ¼����Ŀ¼������һЩ�豸������ص��ļ�
kset��   ��ͬ���͵�kobject�ļ��ϣ�Ҳ��Ӧsysfs�ļ�ϵͳ�е�һ��Ŀ¼��������Ŀ¼������kobject��Ŀ¼

��������ļ��ء�ɾ����kset��kobject����ӡ�ɾ�������ᴥ��һ���¼������ں˿ռ䷢�͵��û��ռ䣬
��udev���գ���������е�����ص�ϵͳ���ã���������ʵ�֣�/devĿ¼���豸�ڵ���Զ��������Զ�ɾ��
}




kobject(kobject kset ��ϵͳ)
{
-----------------------------------------------------------------------------------
kobject������豸ģ�͵Ļ����ṹ�������ֻ�Ǳ����Ϊһ���򵥵����ü�������������ʱ������ƣ���������Խ��Խ�࣬���Ҳ��������Ա������
kobject�ṹ���ܴ���������Լ�����֧�ֵĴ��������
1. ��������ü���
2. sysfs����
3. ���ݽṹ����
4. �Ȳ���¼�����
}


kobject(����֪ʶ)
{
-----------------------------------------------------------------------------------
linux/kobject.h 
kobject: �� Linux �豸ģ����������Ķ������Ĺ������ṩ���ü�����ά�ָ���(parent)�ṹ��ƽ��(sibling)Ŀ¼��ϵ��
����� device, device_driver �ȸ��������� kobject ��������֮��ʵ�ֵģ�
struct kobject {
        const char              *name;             ����������ֵ�����
        struct list_head        entry;             
        struct kobject          *parent;           ָ��kobject�ĸ�����
        struct kset             *kset;             kset��ktypeָ��ֱ�ָ��kobject���ڵļ��Ϻͷ��ŵ����ͣ�kset����kobject�ļ��ϣ�����һ������������kobject��Щ�Ӽ���
        struct kobj_type        *ktype;            ��ʾ�ö�������ͣ��Ǿ�����ͬ������kobject�ļ��ϡ����������һ��kobject��sysfs�µĲ�������Ҫ��show��store������ʵ�֡�
        struct sysfs_dirent     *sd;               ָ��ָ��sysfs_dirent�ṹ�壬����sysfs�е�kobject.
        struct kref             kref;              �����ṹ��,entry��ksetһ������ʹ�á�
        unsigned int state_initialized:1;          
        unsigned int state_in_sysfs:1;             
        unsigned int state_add_uevent_sent:1;      
        unsigned int state_remove_uevent_sent:1;   
};
���� struct kref �ں�һ�� atomic_t �����������ü����� parent �ǵ���ָ�򸸽ڵ��ָ�룬 entry ����
�� kset������ͷ�ṹ�� kobject �ṹά����˫������

kobject_init()        kobject��ʼ������
kobject_set_name()    ����ָ��kobject������
kobject_get()         ��kobject��������ü�����1
kobject_put()         ��kobject��������ü�����1��������ü�����Ϊ0�������kobject release()�ͷŸ�kobject����
kobject_register()    kobjectע�ắ��
kobject_unregister()  kobjectע������������kobject put()���ٸö�������ü�����������ü�����Ϊ0�����ͷ�kobject����


kobject���ݽṹ
1. kobject����һЩ��������������ɵķ���
2. һ��kobject������������Ȥ�������ڵ��������ڰѸ߼��������ӵ��豸ģ���ϡ�
�ں˴������ȥ����һ��������kobject�����෴��kobject���ڿ��ƶԴ�������ض���ķ��ʡ�Ϊ�˴ﵽ���Ŀ�ģ�kobject����Ƕ�뵽�����ṹ�С�
struct cdev{
	struct kobject kobj;
	struct module *owner;
	struct file_operations *ops;
	struct list_head list;
	dev_t dev;
	unsigned int count;
};
cdev�ṹ��Ƕ����kobject�ṹ��
���ʹ�øýṹ��ֻ��Ҫ����kobject��Ա���ܻ��Ƕ��ʽ��kobject���� container_of��
struct cdev *device = container_of(kp, struct cdev, kobj);
}


kobject(��������)
{
------ ��ʼ�� ------
1. ������kobject����Ϊ0����ͨ��ʹ��memset������ͨ���ڶ԰���kobject�Ľṹ����ʱ��ʹ�����ֳ�ʼ��������
   ������Ƕ�kobject�������ʼ���������Ժ�ʹ��kobjectʱ�����ܻᷢ��һЩ��ֵĴ�����ˣ�����������һ���裺
2. void kobject_init(struct kobject *kobj);
3. int kobject_set_name(struct kobjet *kobj, const char *format, ...);
kobject�Ĵ�������Ҫֱ�ӻ������õĳ�Ա�У�ktype��kset��parent��
parent:����Ҫ����;����sysfs�ֲ�ṹ�ж�λ����
kset�� ����kobj_type�ṹ�����䡣һ��kset��Ƕ����ͬ���͵�kobject���ϡ�
        kset�ṹ���ĵ��Ƕ���ľۼ��ͼ��ϣ�kobj_type�ṹ���ĵ��Ƕ�������͡�
		kset����Ҫ�����ǰ��ݡ����ǿ�����Ϊ����kobject�Ķ��������ࡣ
		ʵ���ϣ���ÿ��kset�ڲ����������Լ���kobject�����ҿ����ö��ִ���kobject�ķ�������kset��
		��Ҫע����ǣ�kset������sysfs�г��֣�һ��������kset��������ӵ�ϵͳ�У�����sysfs�д���һ��Ŀ¼��
		kobject������sysfs�б�ʾ������kset�е�ÿһ��kobject��Ա������sysfs�еõ�������
int kobject_add(struct kobject *kobj);
extern int kobject_register(struct kobject *kobj); // �ú���ֻ��kobject_init��kobject_add�ļ���ϡ�
void kobject_del(struct kobject *kobj);
����һ��kobject_unregister����������kobject_del��kobject_put����ϡ�

kset��һ����׼���ں������б����������ӽڵ㡣�ڴ�������ϲ������������kobject�������ǵ�parent��Ա�б���kset(�ϸ��˵������Ƕ��kobject)
��ָ�롣
        kset������һ����ϵͳָ��subsys��û��kset����������һ����ϵͳ����ϵͳ�ĳ�Ա�������ں��ڷֲ�ṹ�ж�λkset��

        
------ �����ü����Ĳ��� ------
struct kobject *kobject_get(struct kobject *kobj);
void kobject_put(struct kobject *obj);

kobject_init�������ü���Ϊ1�����Ե�����kobjectʱ�����������Ҫ��ʼ�����ã���Ҫ������Ӧ��kobject_put������
ע�⣺���������£���kobject�е����ü��������Է�ֹ��̬�Ĳ�����

------ release��kobject���� ------
һ����kobject�������Ľṹ�����������������������ڵ��κο�Ԥ֪�ġ�������ʱ����ϱ��ͷŵ�������kobject�����ü���Ϊ0ʱ��
������Ҫ��ʱ׼�����С����ü�����Ϊ����kobject�Ĵ�����ֱ�ӿ��ơ���˵�kobhject�����һ�����ü������ٴ���ʱ�������첽��֪ͨ��
֪ͨ��ʹ��kobject��release����ʵ�ֵģ��÷���ͨ����ԭ�����£�
void my_object_release(struct kobject *kobj)
{
	struct my_object *mine = container_of(kobj, struct my_object, kobj);
	kfree(mine);
}

struct kobj_type{
	void (*release)(struct kobject *); //kobject���͵�releaseָ�롣
	struct sysfs_ops *sysfs_ops;
	struct attribute **default_attr;   //default_attr�����е����һ��Ԫ�ر���������䡣
};
default_attrs����˵���˶���Щʲô���ԣ�����û�и���sysfs�������ʵ����Щ���ԣ�������񽻸���kobj_type->sysfs_ops��Ա��
����ָ��Ľṹ�������£�
struct sysfs_ops {
	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
};
------ ��Ĭ������ ------
int sysfs_create_file(struct kobject *kobj, struct attribute *attr);
int sysfs_remove_file(struct kobject *kobj, struct attribute *attr);
------ ���������� ------
struct bin_attribute {
	struct attribute	attr;
	size_t			size;
	void			*private;
	ssize_t (*read)(struct file *, struct kobject *, struct bin_attribute *,
			char *, loff_t, size_t);
	ssize_t (*write)(struct file *,struct kobject *, struct bin_attribute *,
			 char *, loff_t, size_t);
	int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
		    struct vm_area_struct *vma);
};
int __must_check sysfs_create_bin_file(struct kobject *kobj, const struct bin_attribute *attr);
void sysfs_remove_bin_file(struct kobject *kobj, const struct bin_attribute *attr);
------ ������������ ------			   
int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
				   const char *name);
void sysfs_remove_link(struct kobject *kobj, const char *name);				   
------ Ĭ������ ------				   
struct attribute{
	char *name;             ���Ե����֣���kobject��sysfsĿ¼����ʾ
	struct module *owner;   ָ��ģ���ָ�룬��ģ�鸺��ʵ����Щ����
	mode_t mode;            Ӧ�������Եı���λ��
}

------ kset����ϵͳ ------
kset: ��������ͬ���Ͷ����ṩһ����װ���ϣ����ں����ݽṹ����Ҳ������Ƕһ��kboject ʵ�֣������ͬʱҲ��һ�� kobject 
(������� OOP �����еļ̳й�ϵ) ������ kobject ��ȫ�����ܣ�
struct kset {
        struct list_head list;                ���Ӹü���kset�����е�kobject����
        spinlock_t list_lock;                 
        struct kobject kobj;                  �����˸ü��ϵĻ���
        struct kset_uevent_ops *uevent_ops;   ָ��һ�����ڴ�������kobject����ĸ������Ľṹ�塣
};
���е� struct list_head list ���ڽ������е� kobject �� struct list_head entry ά����˫������

void kset_init(struct kset *kset);            ���ָ��kset�ĳ�ʼ�� 
int kset_add(struct kset *kset);              �����kset�ӵ���νṹ��
int kset_register(struct kset *kset);         ���kset��ע��
void kset_unregister(struct kset *kset);      ���kset��ע��
                                               
struct kset *kset_get(struct kset *kset);      ��kset_put()�ֱ����Ӻͼ���kset��������ü���(��ʵ������Ƕkobject�����ü���)
void kset_put(struct kset *kset);              
kobject_set_name(&my_set->kobj, "The name");   

kset��Ҳ��һ��ָ��ָ��kobj_type�ṹ��������������������kobject�������͵�ʹ��������kobject�е�ktype.
���͵�Ӧ���У�kobject�е�ktype��Ա�����ó�NULL����Ϊkset�е�ktype��Ա��ʵ���ϱ�ʹ�õĳ�Ա��

kset������һ����ϵͳָ��subsys����ϵͳ�Ƕ������ں���һЩ�߼����ֵı�����
��ϵͳͨ����ʾ��sysfs�ֲ�ṹ�еĶ��㡣�ں��е���ϵͳ����block_subsys(�Կ��豸��˵��/sys/block)
                                        devices_subsys(/sys/devices �豸�ֲ�ṹ�ĺ���)

decl_subsys(name, struct kobj_type *type, struct kset_hotplug_ops *hotplug_ops);
void subsystem_init(struct subsystem *subsys);
int subsystem_register(struct subsystem *subsys);
void subsystem_unregister(struct subsystem *subsys);
struct subsystem *subsys_get(struct subsystem *subsys);
void subsys_put(struct subsystem *subsys)��

------ �ײ�sysfs���� ------
kobject��������sysfs�����ļ�ϵͳ��Ļ��ƣ�����sysfs�е�ÿ��Ŀ¼���ں��ж������һ����Ӧ��kobject.
ÿһ��kobject�����һ�����߶�����ԣ�������kobject��sysfsĿ¼�б�����Ϊ�ļ������е��������ں����ɡ�

------ �Ȳ���¼��Ĳ��� ------
һ���Ȳ���¼��Ǵ��ں˿ռ䷢�͵��û��ռ��֪ͨ��������ϵͳ���ó����˱仯������kojbect���������Ǳ�ɾ����������������¼���
�Ȳ���¼��ᵼ�¶�/sbin/hotplug����ĵ��ã��ó���ͨ�������������򣬴����豸�ڵ㣬���ڷ���������������ȷ�Ķ�������Ӧ�¼���
kobject����������Щ�¼��������ǰ�kobject���ݸ�kobject_add��kobject_delʱ���Ż�����������Щ�¼���
���¼������ݵ��û��ռ�֮ǰ������kobject�Ĵ����ܹ�Ϊ�û��ռ������Ϣ��������ȫ��ֹ�¼��Ĳ�����
}

hotplug(�Ȳ���¼�����)
{
1. �ں˼�⵽��Ӳ�����룬Ȼ��ֱ�֪ͨhotplug��udev.ǰ������װ����Ӧ���ں�ģ��(����usb-storage)������������/dev�д�����Ӧ���豸�ڵ�(��/dev/sda1).
2. udev��������Ӧ���豸�ڵ�󣬻Ὣ��һ��Ϣ֪ͨhal���ػ�����hald.udev�����뱣֤�´������豸�ڵ���Ա���ͨ�û����ʡ�
3. hotplugװ������Ӧ���ں�ģ�鲢����һ��Ϣ֪ͨ��hald.
4. hald���յ�hotplug��udev��������Ϣ֮����Ϊ��Ӳ���Ѿ���ʽ��ϵͳ�Ͽɣ���ʱ����ͨ��һϵ�н��б�д�Ĺ����ļ�(xxx-policy.fdi)
   ���·���Ӳ������Ϣͨ��netlink���ͳ�ȥ��ͬʱ�������update-fstab��fstab-sync��������/etc/fstab,Ϊ��Ӧ���豸�ڵ㴴�����ʵĹ��ص㡣
5. ������������netlink�з�����Ӳ������Ϣ������������Ӳ��(����U�̺����������)�Ĳ�ͬ������������Ƚ���Ӧ���豸�ڵ���ص�hald
   �����Ĺ��ص��ϣ�Ȼ���ڴ򿪲�ͬ��Ӧ�ó���������ڹ����в�����̣����̱Ƚϼ򵥡���Ϊ�����������һ���̶���Ӳ��������
   hotplug��udev��Э����
6. hald���Զ����ӹ��������������мܿ��ϵ���Ϣͨ��netlink����ȥ��
7. �����������������е���Ƭ���ݣ����й��أ������ú��ʵ�Ӧ�ó���Ҫע�⣺hald�Ĺ����Ǵ����εõ�Ӳ����������Ϣ��Ȼ��
   �������Ϣת����netlink�С�����������ó���������fastab��ʵ�����Լ���ִ�й��ڹ�����

  Kernel --> udev --> Network Manager <--> D-Bus <--> Evolution 
  
  udev[����ʹ��hotplug(/etc/hotplug.d/default)���ں˽���ͨ�ţ�����ʹ��Netlink���ƺ��ں˽���ͨ��]
  1. libudev
  2. udevd
  3. udevadm
}

hotplug(�Ȳ���¼�����)
{
1. ������ֱ�ӱ�����ں˻�������ʱ���أ���������udev�м�������ģ�飬��bus_probe_device()�л�Ϊ���ҵ���Ӧ��������
2. ��������Ҫ��̬���أ�������device������driver���п��ܡ��ں˲��棬���ֶ����ص�����register�����У��ҵ���Ӧdevice���й�����
   �û����棬udev(Ŀǰ���������������ǰҲ��������ʽ������/sbin/hotplug��)�У���̬������Ӧ�ű�����
   
}

hotplug(ģ��)
{
    hotplug�����ں����hotplugģ�鲻��һ���£�2.6���ں����pci_hotplug.ko��һ���ں�ģ�飬��hotplug�������������ں˲���
��hotplug�¼�������������������ʱ����ִ�Ӳ�����������е��ں��м�����Ӧģ�顣

���η������ں������Ĺ����У�
/etc/hotplug/*.rc     ��Щ�ű��������Σ����ͼ�����ϵͳ����ʱ�Ѵ��ڵĵ�Ӳ�������Ǳ�hotplug��ʼ���ű����á�
                      *.rc�ű��᳢�Իָ�ϵͳ����ʱ��ʧ���Ȳ��ʱ�䣬������˵���ں�û�й��ظ��ļ�ϵͳ��
/etc/hotplug/*.agent  ��Щ�ű���hotplug���ã�����Ӧ�ں˲����ĸ��ֲ�ͬ���Ȳ���¼����㣬���²�����Ӧ���ں�ģ���
                      �����û�Ԥ����Ľű�
/sbin/hotplug         �ں�Ĭ������£������ں�̬��ĳЩ���鷢���仯ʱ(����Ӳ���Ĳ���Ͱγ�)���ô˽ű���
}

HALD(Linux�ػ�����HALD)
{
hal������udev֮�ϡ�

    hal��hardware abstract lever��Ӳ������ ����Linux��hal�������û��ռ���Ϊһ��daemon���̡�����һ��socket�ӿڡ�
�ȴ�udev������֪ͨ�� udevΪ�豸�����������豸���ú�������udev�Ĺ�����udev֪ͨhald��ʾ�豸�䶯�ˡ� 
hal��Ϊһ��Ӳ�������ݿ⣬��¼��Ӳ�������ԣ���ǰӲ������Щ�����ǵ�������ʲô���ȵ���Ϣ�� �����
�û�̬������Բ�ѯhald�õ�Ӳ������Ϣ��Ҳ����ע������¼���hald���档��������Ӳ���¼�����ʱ��hald��֪ͨ���ǡ�

* Linux kernel 2.6.19 (or later) 
* util-linux 2.15 (or later) 
* udev 125 (or later) 
* dbus 0.61 (or later) 
* glib 2.6.0 (or later) 
* expat 1.95.8 (or later) 
* bash 2.0 (or later) 
* hal-info 20070402 (or later)

}

kset_uevent_ops()
{
��ϵͳ���÷����仯ʱ���������kset��ϵͳ�����ƶ�kobject��һ��֪ͨ����ں˿ռ䷢�͵��û��ռ䣬������Ȳ���¼���
Linux�в���kset_uevent_ops���������Ȳ���¼�������Ӧ���١�
struct kset_uevent_ops {
    int (*filter)(struct kset *kset, struct kobject *kobj);
    const char *(*name)(struct kset *kset, struct kobject *kobj);
    int (*uevent)(struct kset *kset, struct kobject *kobj,
            struct kobj_uevent_env *env);
};

filter�������Ƿ��¼����ݵ��û��ռ䡣���filter����0���������¼��� 
name��   ������Ӧ���ַ������ݸ��û��ռ���Ȳ�δ������
uevent�� ���û��ռ���Ҫ�Ĳ�����ӵ����������С�����ֵ������0�������ط�0������ֹ�Ȳ���¼��Ĳ�����


}


sysfs()
{
sysfs-rules.txt
ls -F #����
ls -F /sys
ls -F /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/
ls -F /sys/devices/
ls -F /sys/devices/pci0000:00/
ls -F /sys/devices/pci0000:00/0000:00:01.0/

ps xfa |grep Xorg
lsof -nP -p 2001
ע�⵽�� Xorg �����������ڴ�ӳ�� (mem) ����ʽ���� "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource0" �� "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource1" ��
ͬʱ���ļ���д��ʽ (7u,9u) ���� "/sys/devices/pci0000:00/0000:00:00.0/config" �� "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/config"
hexdump -C /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/config
lspci -v -d 1039:6330
ls -lU /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/

�� /sys/devices ���������豸����ʵ���󣬰�������Ƶ������̫��������ʵ���豸��Ҳ���� ACPI �Ȳ���ô�Զ��׼�����ʵ�豸������ tty, bonding �ȴ���������豸��

DEVICE_ATTR �豸(Devices)               �豸�Ǵ�ģ��������������ͣ����豸��������Ӱ������֯ struct device           /sys/devices/*/*/.../
DRIVER_ATTR �豸����(Device Drivers)    ��һ��ϵͳ�а�װ�����ͬ�豸��ֻ��Ҫһ�����������֧�� struct device_driver    /sys/bus/pci/drivers/*/
BUS_ATTR    ��������(Bus Types)         ���������߼���Դ����������ӵ������豸���й���         struct bus_type         /sys/bus/*/
CLASS_ATTR  �豸���(Device Classes)    ���ǰ��չ��ܽ��з�����֯���豸�������
                                        �� USB �ӿں� PS/2 �ӿڵ���궼�������豸��
                                        ��������� /sys/class/input/ ��                        struct class            /sys/class/*/
��ͷ�ļ���include/linux/device.h
#define BUS_ATTR(_name, _mode, _show, _store) \ 
struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store) 
#define CLASS_ATTR(_name, _mode, _show, _store) \ 
struct class_attribute class_attr_##_name = __ATTR(_name, _mode, _show, _store) 
#define DRIVER_ATTR(_name, _mode, _show, _store) \ 
struct driver_attribute driver_attr_##_name = \ __ATTR(_name, _mode, _show, _store) 
#define DEVICE_ATTR(_name, _mode, _show, _store) \ 
struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)

    sysfs ��һ�ֻ��� ramfs ʵ�ֵ��ڴ��ļ�ϵͳ��������ͬ���� ramfs ʵ�ֵ��ڴ��ļ�ϵͳ(configfs,debugfs,tmpfs,...)���ƣ� 
    sysfs Ҳ��ֱ���� VFS �е� struct inode �� struct dentry �� VFS ��εĽṹ��ֱ��ʵ���ļ�ϵͳ�еĸ��ֶ���
ͬʱ��ÿ���ļ�ϵͳ��˽������ (�� dentry->d_fsdata ��λ��) �ϣ�ʹ���˳�Ϊ struct sysfs_dirent �Ľṹ���ڱ�ʾ /sys 
�е�ÿһ��Ŀ¼�
    ������� kobject �����п��Կ������� sysfs_dirent ��ָ�룬�����sysfs������ͬһ�� struct sysfs_dirent ��ͳһ�豸ģ��
�е� kset/kobject/attr/attr_group.

    ���������ݽṹ��Ա�ϣ� sysfs_dirent ����һ�� union ������������ֲ�ͬ�Ľṹ���ֱ���Ŀ¼�����������ļ��������ļ���
�����������ļ�������Ŀ¼���Ϳ��Զ�Ӧ kobject������Ӧ�� s_dir ��Ҳ�ж� kobject ��ָ�룬������ں����ݽṹ�� kobject ��
 sysfs_dirent �ǻ������õģ�

 
1. ʹ������(PCI)�� sysfs �����ļ��� bind, unbind �� new_id
2. ʹ�� scsi_host �� scan ����
3. �ں�ģ���е� sysfs �����ļ�


}