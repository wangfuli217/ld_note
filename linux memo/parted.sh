
help()
{
检查 MINOR                           #对文件系统进行一个简单的检查 
cp [FROM-DEVICE] FROM-MINOR TO-MINOR #将文件系统复制到另一个分区 
help [COMMAND]                       #打印通用求助信息，或关于 COMMAND 的信息 
mklabel 标签类型                      #创建新的磁盘标签 (分区表) 
mkfs MINOR 文件系统类型               #在 MINOR 创建类型为“文件系统类型”的文件系统 
mkpart 分区类型 [文件系统类型] 起始点 终止点    #创建一个分区 
mkpartfs 分区类型 文件系统类型 起始点 终止点    #创建一个带有文件系统的分区 
move MINOR 起始点 终止点              #移动编号为 MINOR 的分区 
name MINOR 名称                      #将编号为 MINOR 的分区命名为“名称” 
print [MINOR]                        #打印分区表，或者分区 
quit                                 #退出程序 
rescue 起始点 终止点                  #挽救临近“起始点”、“终止点”的遗失的分区 
resize MINOR 起始点 终止点            #改变位于编号为 MINOR 的分区中文件系统的大小 
rm MINOR                             #删除编号为 MINOR 的分区 
select 设备                          #选择要编辑的设备 
set MINOR 标志 状态                   #改变编号为 MINOR 的分区的标志
}

test()
{
    # 打印一个磁盘的当前的分区结构：
    $ parted /dev/sdb print
    # 将一个MBR的磁盘格式化为GPT磁盘：
    parted> mklabel gpt
    # 将一个GPT磁盘格式化为MBR磁盘：
    parted> mklabel msdos
    # 划分一个起始位置是0，大小为100M的主分区：
    parted> mkpart primary 0 100M 或者 $ parted /dev/sdb mkpart primary 0 100M
    # 将一个磁盘的所有空间都划分成一个分区：
    parted> mkpart primary 0 -1 或者 $ parted /dev/sdb mkpart primary 0 -1
    # 删除一个分区：
    parted> rm 1 或者 $ parted /dev/sdb rm 1
}

example()
{
1、首先类似fdisk一样，先选择要分区的硬盘，此处为/dev/hdd：
[root@10.10.90.97 ~]# parted /dev/hdd

2、选择了/dev/hdd作为我们操作的磁盘，接下来需要创建一个分区表(在parted中可以使用help命令打印帮助信息)：
(parted) mklabel
Warning: The existing disk label on /dev/hdd will be destroyed and all data on this disk will be lost. Do you want to continue?
Yes/No?(警告用户磁盘上的数据将会被销毁，询问是否继续，我们这里是新的磁盘，输入yes后回车) yes
New disk label type? [msdos]? (默认为msdos形式的分区，我们要正确分区大于2TB的磁盘，应该使用gpt方式的分区表，输入gpt后回车)gpt
3、创建好分区表以后，接下来就可以进行分区操作了，执行mkpart命令，分别输入分区名称，文件系统和分区 的起止位置
(parted) mkpart
Partition name? []? dp1
File system type? [ext2]? ext3
Start? 0
End? 500GB
4、分好区后可以使用print命令打印分区信息，下面是一个print的样例
(parted) print

5、如果分区错了，可以使用rm命令删除分区，比如我们要删除上面的分区，然后打印删除后的结果
(parted)rm 1 #rm后面使用分区的号码
(parted) print
Model: VBOX HARDDISK (ide)

6、按照上面的方法把整个硬盘都分好区，下面是一个分完后的样例
(parted) mkpart
Partition name? []? dp1
File system type? [ext2]? ext3
Start? 0
End? 500GB
(parted) mkpart
Partition name? []? dp2
File system type? [ext2]? ext3
Start? 500GB
End? 2199GB
(parted) print
Model: VBOX HARDDISK (ide)
Disk /dev/hdd: 2199GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number Start End Size File system Name Flags
1 17.4kB 500GB 500GB dp1
2 500GB 2199GB 1699GB dp2
7、由于parted内建的mkfs还不够完善，所以完成以后我们可以使用quit命令退出parted并使用 系统的mkfs命令对分区进行格式化了，此时如果使用fdisk -l命令打印分区表会出现警告信息，这是正常的
[root@10.10.90.97 ~]# fdisk -l
WARNING: GPT (GUID Partition Table) detected on '/dev/hdd'! The util fdisk doesn't support GPT. Use GNU Parted.


}