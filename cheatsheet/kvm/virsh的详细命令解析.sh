virsh(虚拟机的状态){
virsh list
列出所有的虚拟机，虚拟机的状态有(8)种
  runing 是运行状态
  idle 是空闲状态
  paused 暂停状态
  shutdown 关闭状态
  crash 虚拟机崩坏状态
  dying 垂死状态
  shut off 不运行完全关闭
  pmsuspended客户机被关掉电源中中断
}
virsh(连接实例){
qemu：///session (本地连接到个人实例)
qemu+unix：///session (本地连接到个人实例)
qemu:///system (本地连接到系统实例)
qemu+nuix:///system(本地连接到系统实例)
qemu://example.com/system(远程连接，TLS)
qemu+tcp://example.com/system(远程登录，SASI)
qemu+ssl://example.com/system(远程登录，ssl)
-v
是只显示版本号
-V
使显示版本的详细信息
-c - -connect 连接远程的主机
-l - -log 输出日志
-q - -quiet避免额外的信息
-r - - readonly 只读，一般和connect配合使用
-t - - timing 输出消逝的时间
-e - - escape 设置转意序列
}
virsh(主机信息:host){ virsh help host
capabilities                   性能
connect                        连接（重新连接）到 hypervisor
freecell                       NUMA可用内存
hostname                       打印管理程序主机名
nodecpustats                   输出节点的 cpu 状统计数据。
nodeinfo                       节点信息
nodememstats                   输出节点的内存状统计数据。
nodesuspend                    在给定时间段挂起主机节点
qemu-attach                    QEMU 附加
qemu-monitor-command           QEMU 监控程序命令
sysinfo                        输出 hypervisor sysinfo
uri                            打印管理程序典型的URI
}
virsh(虚拟机监控:monitor){ virsh help monitor
domblkinfo                     域块设备大小信息
domblklist                     列出所有域块
domblkstat                     获得域设备块状态
domcontrol                     域控制接口状态
domif-getlink                  获取虚拟接口链接状态
domifstat                      获得域网络接口状态
dominfo                        域信息
dommemstat                     获取域的内存统计
domstate                       域状态
list                           列出域
}
virsh(虚拟机域管理:domain){ virsh help domain
attach-device                  从一个XML文件附加装置
attach-disk                    附加磁盘设备
attach-interface               获得网络界面
autostart                      自动开始一个域
blkdeviotune                   设定或者查询块设备 I/O 调节参数。
blkiotune                      获取或者数值 blkio 参数
blockpull                      使用其后端映像填充磁盘。
blockjob                       Manage active block operations.
blockresize                    创新定义域块设备大小
console                        连接到客户会话
cpu-baseline                   计算基线 CPU
cpu-compare                    使用 XML 文件中描述的 CPU 与主机 CPU 进行对比
create                         从一个 XML 文件创建一个域
define                         从一个 XML 文件定义（但不开始）一个域
destroy                        销毁（停止）域
detach-device                  从一个 XML 文件分离设备
detach-disk                    分离磁盘设备
detach-interface               分离网络界面
domid                          把一个域名或 UUID 转换为域 id
domif-setlink                  设定虚拟接口的链接状态
domjobabort                    忽略活跃域任务
domjobinfo                     域任务信息
domname                        将域 id 或 UUID 转换为域名
domuuid                        把一个域名或 id 转换为域 UUID
domxml-from-native             将原始配置转换为域 XML
domxml-to-native               将域 XML 转换为原始配置
dump                           把一个域的内核 dump 到一个文件中以方便分析
dumpxml                        XML 中的域信息
edit                           编辑某个域的 XML 配置
inject-nmi                     在虚拟机中输入 NMI
send-key                       向虚拟机发送序列号
managedsave                    管理域状态的保存
managedsave-remove             删除域的管理保存
maxvcpus                       连接 vcpu 最大值
memtune                        获取或者数值内存参数
migrate                        将域迁移到另一个主机中
migrate-setmaxdowntime         设定最大可耐受故障时间
migrate-setspeed               设定迁移带宽的最大值
migrate-getspeed               获取最长迁移带宽
reboot                         重新启动一个域
reset                          重新设定域
restore                        从一个存在一个文件中的状态恢复一个域
resume                         重新恢复一个域
save                           把一个域的状态保存到一个文件
save-image-define              为域的保存状态文件重新定义 XML
save-image-dumpxml             在 XML 中保存状态域信息
save-image-edit                为域保存状态文件编辑 XML
schedinfo                      显示/设置日程安排变量
screenshot                     提取当前域控制台快照并保存到文件中
setmaxmem                      改变最大内存限制值
setmem                         改变内存的分配
setvcpus                       改变虚拟 CPU 的号
shutdown                       关闭一个域
start                          开始一个（以前定义的）非活跃的域
suspend                        挂起一个域
ttyconsole                     tty 控制台
undefine                       取消定义一个域
update-device                  从 XML 文件中关系设备
vcpucount                      域 vcpu 计数
vcpuinfo                       详细的域 vcpu 信息
vcpupin                        控制或者查询域 vcpu 亲和性
version                        显示版本
vncdisplay                     vnc 显示

}
virsh(虚拟机设备){ virsh help domain
attach-device (demo file)添加设备从file文件中
attach-interface (demo type source )添加一个接口
update-device(demo file)更新设备根据file
}
virsh(虚拟网络:network){ virsh help network
net-autostart                  自动开始网络
net-create                     从一个 XML 文件创建一个网络
net-define                     从一个 XML 文件定义(但不开始)一个网络
net-destroy                    销毁（停止）网络
net-dumpxml                    XML 中的网络信息
net-edit                       为网络编辑 XML 配置
net-info                       网络信息
net-list                       列出网络
net-name                       把一个网络UUID 转换为网络名
net-start                      开始一个(以前定义的)不活跃的网络
net-undefine                   取消定义一个非活跃的网络
net-uuid                       把一个网络名转换为网络UUID
}
virsh(接口:interface){ virsh help interface
iface-begin                    create a snapshot of current interfaces settings, which can be later commited (iface-commit) or restored (iface-rollback)
iface-bridge                   生成桥接设备并为其附加一个现有网络设备
iface-commit                   提交 iface-begin 后的更改并释放恢复点
iface-define                   定义（但不启动）XML 文件中的物理主机接口
iface-destroy                  删除物理主机接口（启用它请执行 "if-down"）
iface-dumpxml                  XML 中的接口信息
iface-edit                     为物理主机界面编辑 XML 配置
iface-list                     物理主机接口列表
iface-mac                      将接口名称转换为接口 MAC 地址
iface-name                     将接口 MAC 地址转换为接口名称
iface-rollback                 恢复到之前保存的使用 iface-begin 生成的更改
iface-start                    启动物理主机接口（启用它请执行 "if-up"）
iface-unbridge                 分离其辅助设备后取消定义桥接设备
iface-undefine                 取消定义物理主机接口（从配置中删除）
}
virsh(存储管理:pool){ virsh help pool
find-storage-pool-sources-as   找到潜在存储池源
find-storage-pool-sources      发现潜在存储池源
pool-autostart                 自动启动某个池
pool-build                     建立池
pool-create-as                 从一组变量中创建一个池
pool-create                    从一个 XML 文件中创建一个池
pool-define-as                 在一组变量中定义池
pool-define                    在一个 XML 文件中定义（但不启动）一个池
pool-delete                    删除池
pool-destroy                   销毁（删除）池
pool-dumpxml                   XML 中的池信息
pool-edit                      为存储池编辑 XML 配置
pool-info                      存储池信息
pool-list                      列出池
pool-name                      将池 UUID 转换为池名称
pool-refresh                   刷新池
pool-start                     启动一个（以前定义的）非活跃的池
pool-undefine                  取消定义一个不活跃的池
pool-uuid                      把一个池名称转换为池 UUID
}
virsh(卷管理:volume){ virsh help volume
vol-clone                      克隆卷。
vol-create-as                  从一组变量中创建卷
vol-create                     从一个 XML 文件创建一个卷
vol-create-from                生成卷，使用另一个卷作为输入。
vol-delete                     删除卷
vol-download                   Download a volume to a file
vol-dumpxml                    XML 中的卷信息
vol-info                       存储卷信息
vol-key                        为给定密钥或者路径返回卷密钥
vol-list                       列出卷
vol-name                       为给定密钥或者路径返回卷名
vol-path                       为给定密钥或者路径返回卷路径
vol-pool                       为给定密钥或者路径返回存储池
vol-upload                     upload a file into a volume
vol-wipe                       擦除卷

}
virsh(快照管理:snapshot){ virsh help snapshot
snapshot-create                使用 XML 生成快照
snapshot-create-as             使用一组参数生成快照
snapshot-current               获取或者设定当前快照
snapshot-delete                删除域快照
snapshot-dumpxml               为域快照转储 XML
snapshot-edit                  编辑快照 XML
snapshot-list                  为域列出快照
snapshot-parent                获取快照的上级快照名称
snapshot-revert                将域转换为快照
}

virsh(nodedev){ virsh help nodedev
nodedev-create                 根据节点中的 XML 文件定义生成设备
nodedev-destroy                销毁（停止）节点中的设备
nodedev-dettach                dettach node device from its device driver
nodedev-dumpxml                XML 中的节点设备详情
nodedev-list                   这台主机中中的枚举设备
nodedev-reattach               重新将节点设备附加到他的设备驱动程序中
nodedev-reset                  重置节点设备
}
virsh(防火墙:filter){ virsh help filter
nwfilter-define                使用 XML 文件定义或者更新网络过滤器
nwfilter-dumpxml               XML 中的网络过滤器信息
nwfilter-edit                  为网络过滤器编辑 XML 配置
nwfilter-list                  列出网络过滤器
nwfilter-undefine              取消定义网络过滤器
}
https://blog.csdn.net/xxoo00xx00/article/details/49802367

/usr/share/libvirt/ 下面有很多参考文档
virt-host-validate
virt-pki-validate
virt-xml-validate