--- 防火墙 --- 

nfs(exports)
{
ro 只读共享
rw 可读可写共享
sync 同步写操作 # 同时将数据写入到内存与硬盘中，保证不丢失数据
async 异步写操作 # 优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据
wdelay 延迟写操作
root_squash 屏蔽远程root权限 # 当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户
no_root_squash 不屏蔽远程root权限 # 当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员
all_squash 屏蔽所有远程用户权限 # 无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户


共享路径 客户端主机(选项)
共享路径 客户端主机(选项)  客户端主机(选项)
# 例如
/home/iaas *(rw,async,no_root_squash)
/home/share *(rw,async,no_root_squash)
/home/back *(rw,async,no_root_squash)
/home/back 192.168.10.106(rw,async,no_root_squash)

192.168.10.10:/nfsfile /nfsfile nfs defaults 0 0
}

nfs(server)
{
nfs:NFS服务器主程序
nfslock：为NFS文件系统提供锁机制
rpcbind:提供地址与端口注册服务
rpc.mountd：该进程被NFS服务器用来处理NFSv2和NFSv3的mount请求。
rpc.nfsd：动态处理客户端请求
lockd:lockd是内核线程，在服务器端与客户端运行，用来实现NLM网络协议，允许NFSv2与NFSv3客户端对文件加锁。
rpc.statd：该进程实现网络状态监控NSM协议。
rpc.rquotad:提供用户配额信息
rpc.idmapd:提供NFSv4名称映射,/etc/idmapd.conf必须被配置
}

mount -t nfs -o 选项 服务器主机:/服务器共享目录  /本地挂在目录
Intr
nfsvers=version #[2|3|4]
noacl      关闭ACL
nolock     关闭LOCK
noexec     在挂在的文件系统中屏蔽可执行的二进制程序
port=num   指定NFS服务器端口
rpcbind    注册端口信息，2049
rsize=num  设置最大数据块大小调整NFS读取数据的速度，num单位为字节
wsize=num  设置最大数据块大小调整NFS写入数据的速度，num单位为字节
tcp        使用TCP协议挂载
udp        使用UDP协议挂载

nfs(操作)
{
exportfs 动态更新/etc/exports文件给主程序
nfsstat：查看NFS共享状态
rpcinfo: 生成RPC信息报表
}

nfs(sysconfig)
{
/etc/sysconfig/nfs
MOUNTD_PORT=端口号    # 设置mountd程序端口号
LOCKD_TCPPORT=端口号  # 设置tcp的lockd程序端口号
LOCKD_UDPPORT=端口号  # 设置udp的lockd程序端口号
STATD_PORT=端口号     # 设置rpc.statd程序端口号
}



