qemu(qemu){
wget http://wiki.qemu-project.org/download/qemu-2.3.1.tar.bz2
tar xjvf qemu-2.3.1.tar.bz2
cd qemu-2.3.1
sudo yum install zlib-devel
sudo yum install glib2-devel -y
sudo yum install install autoconf automake libtool
./configure --enable-kvm --enable-debug --enable-vnc  --target-list="x86_64-softmmu"
sudo make install
install -d -m 0755 "/usr/local/bin"
install -c -m 0755 qemu-system-x86_64  "/usr/local/bin"
}
qemu(nbd){
sudo modprobe nbd max_part=8
modinfo nbd

sudo qemu-nbd -c /dev/nbd1 /home/centos.qcow2 

sudo fdisk -l /dev/nbd1
sudo mount /dev/nbd0p1 /mnt/test1  
sudo qemu-nbd -d /dev/nbd0p1    
}
ndb(实例){
1. 安装
http://sourceforge.net/projects/nbd/files/latest/download
# tar jxf nbd-2.8.8.tar.bz2
# cd nbd-2.8.8
# ./configure
# make
# make install
或者
sudo apt-get install nbd-client
sudo apt-get install nbd-server
2. 创建镜像
# cd /var/tmp
# dd if=/dev/zero of=nbd-disk0 bs=104857600 count=3 
3.启动nbd服务
nbd-server 1234 /var/tmp/nbd-disk0
4. 启动nbd客户端
nbd-client 192.168.1.1 1234 /dev/nbd0 
5. 断开块设备
# umount /mnt/nbd0/
# nbd-client -d /dev/nbd0 
}
nbd(nbd-server){
nbd-server port file [size][kKmM] [-l authorize_file] [-r] [-m] [-c] [-a timeout_sec]
  port nbd-server监听端口.
  file 绑定的映像文件.
  size 在客户端所见的块设备大小(单位可以是: k,K,m,M).
  -r|--read-only 只读模式,客户端无法在块设备上进行写操作.
  -m|--multi-file 多个文件,可以将多个映像文件作为一个块设备提供给客户端.
  -c|--copy-on-write 所有客户端的写操作被会另存为一个文件,连接断开后,这个文件会被删除. 
  可以保证映像文件内容不会被修改.
  -l|--authorize-file file 一个允许访问此nbd的主机列表文件.
  -a|--idle-time 服务器断开与客户端连接前的最大空闲时间.
}
ndb(nbd-client){
nbd-client [bs=blocksize] host port nbd_device [-swap]
  bs 用于设置块大小,默认是1024,可以是512,1024.2048,4096
  host 服务器的主机名或IP
  port 服务器的监听端口
  nbd_device 映射到本地的哪个nbd设备(如: /dev/nbd0)
  -swap 指定nbd设备将用做swap空间
nbd-client -d nbd_device 用于断开连接
}
qemu_img(info 查看镜像的信息){


}

qemu_img(create 创建镜像){
qemu-img create -f <fmt> -o <options> <fname> <size>
qemu-img create -f raw -o size=4G /images/vm2.raw
qemu-img info vm2.raw 
qemu-img create -f qcow2 -o ? temp.qcow # 可以使用“-o ?”来查询某种格式文件支持那些选项
}

qemu_img(check 检查镜像){
check [-f fmt] filename # 目前仅支持对“qcow2”、“qed”、“vdi”格式文件的检查。
}
qemu_img(commit  检查镜像){
提交filename文件中的更改到后端支持镜像文件（创建时通过backing_file指定的）中去。
}

qemu_img(convert 转化镜像的格式){
支持格式：vvfat vpc vmdk vdi sheepdog rbd raw host_cdrom host_floppy host_device file qed qcow2 qcow parallels nbd dmg tftp ftps ftp https http cow cloop bochs blkverify blkdebug

qemu-img convert -c -f fmt -O out_fmt -o options fname out_fname
  -c：采用压缩，只有qcow和qcow2才支持
  -f：源镜像的格式，它会自动检测，所以省略之
  -O 目标镜像的格式
  -o 其他选先
  fname：源文件
  out_fname:转化后的文件
  
qemu-img convert -c -O qcow2 vm2.raw vm2.qcow2
 # 如果想看要转化的格式支持的-o选项有哪些，可以在命令末尾加上 -o ？
qemu-img convert -c -O qcow2 vm2.raw vm2.qcow2 -o ?
}

qemu_img(snapshot 管理镜像的快照){
qemu-img snapshot -l /images/vm2.qcow2 # 查看快照
注意：只有qcow2才支持快照
qemu-img snapshot -c booting vm2.qcow2 # 打快照

qemu-img snapshot -c booting vm2.qcow2 
qemu-img snapshot -l vm2.qcow2 

qemu-img snapshot -a 1 /images/vm2.qcow2 # 从快照恢复

qemu-img snapshot -d 2 /images/vm2.qcow  # 删除快照
}
qemu_img(rebase 在已有的镜像的基础上创建新的镜像){


}
qemu_img(resize 增加或减小镜像大小){
注意：只有raw格式的镜像才可以改变大小
qemu-img resize vm2.raw +2GB
qemu-img info vm2.raw 
}

qemu_img(派生镜像){
    当创建的虚拟机越来越多，并且你发现好多虚拟机都是同一个操作系统，它们的区别就是安装的软件不大一样，那么你肯定
会希望把他们公共的部分提取出来，只保存那些与公共部分不同的东西，这样镜像大小下去了，空间变多了，管理也方便了。
派生镜像就是用来干这事的
qemu-img info vm3_base.raw  # 首先看一个原始镜像
qemu-img create -f qcow2 vm3_5.qcow2 -o backing_file=vm3_base.raw 5G # 新建一个镜像，但是派生自它
现在我们在vm3_5.qcow2上打了很多安全补丁，然后发现我又想在vm3_5.qcow2上派生新的虚拟机
qemu-img convert -O raw vm3_5.qcow2 vm3_base2.raw
qemu-img info vm3_base2.raw 
}
