/********************************************** 
 * Author: lewiyon@hotmail.com 
 * File name: kset_sample.c 
 * Description: kset example 
 * Date: 2011-12-10 
 *********************************************/  
  
#include <linux/kobject.h>  
#include <linux/string.h>  
#include <linux/sysfs.h>  
#include <linux/slab.h>  
#include <linux/module.h>  
#include <linux/init.h>  
  
/* 
 * ��Ҫ�������ļ�foo��Ӧ��kobj. 
 */  
struct foo_obj {  
       struct kobject kobj;  
       int foo;  
       int baz;  
       int bar;  
};  
  
/* ͨ�����Ա���ؽṹ���ָ�� */  
#define to_foo_obj(x) container_of(x, struct foo_obj, kobj)  
  
/* ���� */  
struct foo_attribute {  
       struct attribute attr;  
       ssize_t (*show)(struct foo_obj *foo, struct foo_attribute *attr, char *buf);  
       ssize_t (*store)(struct foo_obj *foo, struct foo_attribute *attr, const char *buf, size_t count);  
};  
  
#define to_foo_attr(x) container_of(x, struct foo_attribute, attr)  
  
/* 
 * ����foo��Ϣ��ʾ���� (�漰�ļ�Ŀ¼foo/) 
 */  
static ssize_t foo_attr_show(struct kobject *kobj,  
                          struct attribute *attr,  
                          char *buf)  
{  
       struct foo_attribute *attribute;  
       struct foo_obj *foo;  
  
       attribute = to_foo_attr(attr);  
       foo = to_foo_obj(kobj);  
  
       if (!attribute->show)  
              return -EIO;  
  
       return attribute->show(foo, attribute, buf);  
}  
  
/* 
 * ����foo�洢����(�漰�ļ�Ŀ¼foo/) (when a value is written to a file.) 
 */  
static ssize_t foo_attr_store(struct kobject *kobj,  
                           struct attribute *attr,  
                           const char *buf, size_t len)  
{  
       struct foo_attribute *attribute;  
       struct foo_obj *foo;  
  
       attribute = to_foo_attr(attr);  
       foo = to_foo_obj(kobj);  
  
       if (!attribute->store)  
              return -EIO;  
  
       return attribute->store(foo, attribute, buf, len);  
}  
  
/* 
 * foo��show/store�б� 
 */  
static const struct sysfs_ops foo_sysfs_ops = {  
       .show = foo_attr_show,  
       .store = foo_attr_store,  
};  
  
/* 
 * The release function for our object.  This is REQUIRED by the kernel to 
 * have.  We free the memory held in our object here. 
 */  
static void foo_release(struct kobject *kobj)  
{  
       struct foo_obj *foo;  
  
       foo = to_foo_obj(kobj);  
       kfree(foo);  
}  
  
/* 
 * ����Ҫ��foo�ļ��ж�ȡ��Ϣʱ�����ô˺��� 
 */  
static ssize_t foo_show(struct foo_obj *foo_obj, struct foo_attribute *attr,  
                     char *buf)  
{  
       return sprintf(buf, "%d\n", foo_obj->foo);  
}  
  
/* 
 * ����foo�ļ�д����Ϣʱ�����ô˺��� 
 */  
static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,  
                      const char *buf, size_t count)  
{  
       sscanf(buf, "%du", &foo_obj->foo);  
       return count;  
}  
  
static struct foo_attribute foo_attribute =  
       __ATTR(foo, 0666, foo_show, foo_store);  
  
/* 
 * foo_ktype�������б� 
 */  
static struct attribute *foo_default_attrs[] = {  
       &foo_attribute.attr,  
       NULL,     /* need to NULL terminate the list of attributes */  
};  
  
/* 
 * ����kobj_type�ṹ�� 
 * ָ��sysfs_ops,release����, �����б�foo_default_attrs 
 */  
static struct kobj_type foo_ktype = {  
       .sysfs_ops = &foo_sysfs_ops,  
       .release = foo_release,  
       .default_attrs = foo_default_attrs,  
};  
  
static struct kset *example_kset;  
static struct foo_obj *foo_obj;  
  
static struct foo_obj *create_foo_obj(const char *name)  
{  
       struct foo_obj *foo;  
       int retval;  
  
       /* allocate the memory for the whole object */  
       foo = kzalloc(sizeof(*foo), GFP_KERNEL);  
       if (!foo)  
              return NULL;  
  
       foo->kobj.kset = example_kset;  
  
    /* 
     * ��ʼ��kobject���ݽ�ṹfoo->lobj, 
     * �� ��foo->kobj�Ĳ����֯kset�д�������Ϊname���ļ�foo/foo 
     * �ɹ�����0 
     */  
       retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);  
       if (retval) {  
        /* ��Сkobj�����ü��� */  
              kobject_put(&foo->kobj);  
              return NULL;  
       }  
  
       /* 
        * ���� KOBJ_ADD / KOBJ_REMOVE ���¼� 
        * We are always responsible for sending the uevent that the kobject 
        * was added to the system. 
        */  
       kobject_uevent(&foo->kobj, KOBJ_ADD);  
  
       return foo;  
}  
  
static void destroy_foo_obj(struct foo_obj *foo)  
{  
    /* ��Сkobj�����ü��� */  
       kobject_put(&foo->kobj);  
}  
  
static int __init example_init(void)  
{  
       /* 
        * ��̬����kernel_kobj����Ӧ��Ŀ¼/sys/kernel/�´���һ��Ŀ¼kset_example 
        * ������kset_example��Ӧ��kset 
        */  
       example_kset = kset_create_and_add("kset_example", NULL, kernel_kobj);  
       if (!example_kset)  
              return -ENOMEM;  
  
       foo_obj = create_foo_obj("foo");  
       if (!foo_obj)  
              goto foo_error;  
  
       return 0;  
  
foo_error:  
       return -EINVAL;  
}  
  
static void __exit example_exit(void)  
{  
       destroy_foo_obj(foo_obj);  
       kset_unregister(example_kset);  
}  
  
module_init(example_init);  
module_exit(example_exit);  
MODULE_LICENSE("GPL");  
MODULE_AUTHOR("Younger Liu <younger.liucn@gmail.com>");