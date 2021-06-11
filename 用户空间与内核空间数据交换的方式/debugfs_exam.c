//kernel module: debugfs_exam.c
//#include <linux/config.h>
#include <linux/module.h>
#include <linux/debugfs.h>
#include <linux/types.h>

/*dentry:目录项，是Linux文件系统中某个索引节点(inode)的链接。这个索引节点可以是文件，也可以是目录。
Linux用数据结构dentry来描述fs中和某个文件索引节点相链接的一个目录项(能是文件,也能是目录)。
　　（1）未使用（unused）状态：该dentry对象的引用计数d_count的值为0，但其d_inode指针仍然指向相关的的索引节点。该目录项仍然包含有效的信息，只是当前没有人引用他。这种dentry对象在回收内存时可能会被释放。
　　（2）正在使用（inuse）状态：处于该状态下的dentry对象的引用计数d_count大于0，且其d_inode指向相关的inode对象。这种dentry对象不能被释放。
　　（3）负（negative）状态：和目录项相关的inode对象不复存在（相应的磁盘索引节点可能已被删除），dentry对象的d_inode指针为NULL。但这种dentry对象仍然保存在dcache中，以便后续对同一文件名的查找能够快速完成。这种dentry对象在回收内存时将首先被释放。
*/
static struct dentry *root_entry, *u8_entry, *u16_entry, *u32_entry, *bool_entry;
static u8 var8;
static u16 var16;
static u32 var32;
static u32 varbool;

static int __init exam_debugfs_init(void)
{

        root_entry = debugfs_create_dir("debugfs-exam", NULL);
        if (!root_entry) {
                printk("Fail to create proc dir: debugfs-exam\n");
                return 1;
        }

        u8_entry = debugfs_create_u8("u8-var", 0644, root_entry, &var8);
        u16_entry = debugfs_create_u16("u16-var", 0644, root_entry, &var16);
        u32_entry = debugfs_create_u32("u32-var", 0644, root_entry, &var32);
        bool_entry = debugfs_create_bool("bool-var", 0644, root_entry, &varbool);

        return 0;
}

static void __exit exam_debugfs_exit(void)
{
        debugfs_remove(u8_entry);
        debugfs_remove(u16_entry);
        debugfs_remove(u32_entry);
        debugfs_remove(bool_entry);
        debugfs_remove(root_entry);
}

module_init(exam_debugfs_init);
module_exit(exam_debugfs_exit);
MODULE_LICENSE("GPL");