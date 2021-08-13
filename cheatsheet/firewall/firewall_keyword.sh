1. ATUH:TCP服务器端口113，与identd用户身份认证服务器相关。
2. chroot:既是一个程序又是一个系统调用，用于将一个目录定义为文件系统的根目录，然后将程序运行限制在这个虚拟文件系统范围内。
3. DoS(denial-of-service attack)拒绝服务攻击：一种攻击，通过发送非预期的数据或使用数据包对系统进行泛洪，以破坏服务器或使服务
   降级，使得合法的请求不能被响应或更糟糕的，是系统崩溃。
4. DMZ(demilitarized zone)非军事化区域的缩写：一个包含托管公共服务的服务器主机的网络防御带，与本地的私有网络隔开。对安全较低
   的公共服务器与私有局域网进行隔离。
5. firewall bastion(堡垒防火墙)：通常来说，包含两个或多个网络接口并且充当网关或作为网络间的连接点，通常是本地站点和互联网站点
   的连接点，因为堡垒防火墙是网络界的单个连接点，所以堡垒防火墙被给以最大可能的安全保护。通常，堡垒是一台可以从远程的站点直接
   进行访问的防火墙，不论该主机用于连接网络或保护提公共服务器的服务器。
6. firewall choke(隔断防火墙) ：拥有两个或多个网络接口，是这些网络间的网关或连接点的局域网防火墙。其中一个网络接口连接到DMZ(
   其一端连接到各段防火墙，另一端连接到堡垒防火墙)，另一端网络接口连接到内部的私有局域网。
7. firewall dual-homed(双宿主主机防火墙)：一个单主机网关防火墙，要求内部局域网用户连接到防火墙以实现访问互联网，或者是作为此内部
   局域网可以访问的所有互联网网站的代理。在使用了双宿主主机的网络系统中，所有的内部局域网和互联网之间的信息传输都必须经过此
   双宿主主机防火墙。
