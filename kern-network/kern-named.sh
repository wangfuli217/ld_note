1. GSO(Gereric Segmentation Offload)通用分段减负。不在传输层对出栈数据包进行分段，而是尽可能接近网络驱动程序的地方，
   或网络驱动程序中进行分段。
   最大长度65536
   
2. MSS(Maxinum Segment Size) 最大分段长度，TCP协议的一个参数。
3. TSO(TCP Segmentation Offload) TCP分段减负


1. 网络设备名字最长不能大于16个字节。
2. ifconfig up -> ioctl(SIOCSIFFLAGS) -> dev_open(NETDEV_UP)
   ifconfig down -> ioctl(SIOCSIFFLAGS) -> dev_close(NETDEV_DOWN)
3. tcp最小长度为536 慢启动初始窗口为2   