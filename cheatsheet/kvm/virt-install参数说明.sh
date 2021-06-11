一般选项
-n NAME, --name=NAME：虚拟机名称，需全局惟一； 
-r MEMORY, --ram=MEMORY：虚拟机内在大小，单位为MB； 
--vcpus=VCPUS[,maxvcpus=MAX][,sockets=#][,cores=#][,threads=#]：VCPU个数及相关配置；
 --cpu=CPU：CPU模式及特性，如coreduo等；可以使用qemu-kvm -cpu ?来获取支持的CPU模式；
-c CDROM, --cdrom=CDROM：光盘安装介质；
 -l LOCATION, --location=LOCATION：安装源URL，支持FTP、HTTP及NFS等，如ftp://172.16.0.1/pub； 
--pxe：基于PXE完成安装； --livecd: 把光盘当作LiveCD； 
--os-type=DISTRO_TYPE：操作系统类型，如linux、unix或windows等； 
--os-variant=DISTRO_VARIANT：某类型操作系统的变体，如rhel5、fedora8等； 
-x EXTRA, --extra-args=EXTRA：根据--location指定的方式安装GuestOS时，用于传递给内核的额外选项，例如指定kickstart文件的位置，
--extra-args "ks=http://172.16.0.1/class.cfg" 
--boot=BOOTOPTS：指定安装过程完成后的配置选项，如指定引导设备次序、使用指定的而非安装的kernel/initrd来引导系统启动等 ；例如： --boot cdrom,hd,network：指定引导次序； 
--boot kernel=KERNEL,initrd=INITRD,kernel_args=”console=/dev/ttyS0”：指定启动系统的内核及initrd文件；

硬盘
--disk=DISKOPTS：指定存储设备及其属性；格式为--disk /some/storage/path,opt1=val1，opt2=val2等；常用的选项有： device：设备类型，如cdrom、disk或floppy等，默认为disk； bus：磁盘总结类型，其值可以为ide、scsi、usb、virtio或xen； perms：访问权限，如rw、ro或sh（共享的可读写），默认为rw； size：新建磁盘映像的大小，单位为GB； cache：缓存模型，其值有none、writethrouth（缓存读）及writeback（缓存读写）； format：磁盘映像格式，如raw、qcow2、vmdk等； sparse：磁盘映像使用稀疏格式，即不立即分配指定大小的空间； --nodisks：不使用本地磁盘，在LiveCD模式中常用；
网络
-w NETWORK, --network=NETWORK,opt1=val1,opt2=val2：将虚拟机连入宿主机的网络中，其中NETWORK可以为： bridge=BRIDGE：连接至名为“BRIDEG”的桥设备； network=NAME：连接至名为“NAME”的网络；
虚拟化
-v, --hvm：当物理机同时支持完全虚拟化和半虚拟化时，指定使用完全虚拟化；
-p, --paravirt：指定使用半虚拟化；
--virt-type：使用的hypervisor，如kvm、qemu、xen等；所有可用值可以使用’virsh capabilities’命令获取；

图像
--graphics TYPE,opt1=val1,opt2=val2：指定图形显示相关的配置，此选项不会配置任何显示硬件（如显卡），而是仅指定虚拟机启动后对其进行访问的接口； 
TYPE：指定显示类型，可以为vnc、sdl、spice或none等，默认为vnc； port：
TYPE为vnc或spice时其监听的端口； listen：TYPE为vnc或spice时所监听的IP地址，默认为127.0.0.1，可以通过修改/etc/libvirt/qemu.conf定义新的默认值； password：TYPE为vnc或spice时，为远程访问监听的服务进指定认证密码； --noautoconsole：禁止自动连接至虚拟机的控制台；