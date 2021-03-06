http://www.yunweipai.com/archives/22246.html

ntpd(概述){
1. ntpd 是一个操作系统Daemon进程，用于校正本地系统与Internet标准时钟源之间的时间。
2. ntpd 完整的实现了 NTP 协议版本v4，但是同时兼容版本v3(RFC-1305)、版本v1与v2(分别由RFC-1059, RFC-1119定义)。
3. ntpd 绝大多数情况下使用64位浮点数计算，仅在需要极高时间精度的情况下使用笨拙的64位固定长度数计算，
   这个极高的精度是 232*1/1,000,000,000,000 秒；要达到这个精度对CPU与网络带宽的要求已超过GHZ与GMbps的级别，
   当前的大多数工作站都无法满足
}
ntpd(工作原理){
1. ntpd 进程通过定期与NTP时钟源服务器发送消息来获取时间信息。在进程初始启动时候，不论是第一次boot还是随后启动，
   nptd 会给服务器发送消息以获取时间来设置到本地系统。
2. 为了防止网络风暴，进程启动后会在定义好的间隔64秒之上再加一个随机延迟值，这个随机值的范围是0~16秒；
   因此进程启动后需要数分钟才会开始同步时间。
3. 如今的计算机都带有硬件时钟芯片，用于在计算机掉电过程中仍然保持正确时间，当计算机上电，操作系统从时钟芯片中获取时间。
   # 当操作系统启动完成并连接到时钟源之后，操作系统会依据时钟源定时调整芯片时间。
   在服务器没有硬件时钟芯片或硬件时钟芯片故障(CMOS电池没电)或其他原因导致操作系统本地时间与时钟源时间差别超过1000秒，
   nptd认为此时发生了严重问题，唯一可靠的处理方法是人为介入。
   这种情况下nptd Daemon进程会退出并在操作系统的syslog中记录一条日志。
   # nptd 的启动选项 -g 选项可以忽略1000秒的检查并强制将时钟源时间设置为硬件时间，不过考虑到硬件时钟芯片故障的场景
   一旦再次出现芯片时间与时钟源超过1000秒，nptd还是会退出。
4. 通常情况下，ntpd 以很小的步长调整时间使得时间尽量是连续的、不出现跳跃。
   在网络极度拥塞的条件下，nptd 与时钟源之间发送一个消息包来回的时延有可能达到3秒，因此会导致同步距离(半个来回时延，1.5秒)变的很大。 
   # ntpd 同步算法会丢弃时差大于128ms的包，除非在900秒内没有时差小于128ms的包，还有就是首次启动时候不会检查这个时差直接同步。这种设计是为了减少误报时钟同步异常的告警。
5. 上述行为的结果是每次成功设置本地时间，一般不会超过128ms，即使在网络时延很高的情况下。
   有时候，特别是在ntpd首次启动的时候，时差可能超过128ms，这种罕见场景一般是本地时间比时钟源的时间快超过128秒，这种情况本地时间将会被往过去方向调回。
   这种情况下某些应用程序会有问题。如果启动nptd时候加上了 -x 选项，那么 nptd 不会以步长方式(stepped)同步，只会以微调校正方式(slew correction)同步。
6. 使用 -x 选项之前需要仔细考量影响。 ntpd 微调校准的最大频率是 500 个 PPM (parts-per-million)每秒
   也就是每秒校准 5/10,000 秒。因此会导致本地时间与时钟源之间需要很长时间才能将时差同步到一个可接受的范围，大概是2000秒同步一秒，对于依赖网络时钟源的应用来说这种情况不可接受。
  
}
ntp(频度规则){
    nptd 启动时的行为依赖频度文件是否存在，通常是 npt.drift 。这个文件包含了最近估算出的时钟频度误差值。
如果文件不存在，此时 ntpd 进入一种特殊模式会快速调整时间与频度误差值，这个快速大概好事15分钟，随后
在时间与频度误差值正常后nptd进入正常模式，时间与频度持续与时钟源同步。并在一个小时之后，将当前的
频度误差值写入 npt.drift 文件。如果文件存在，nptd从此文件读取频度误差值直接进入正常模式，并没隔一个小
时将计算好的频度误差值写入文件。
}
ntp(运行模式){
    nptd 可以运行在多种模式下，包括对称的 主动、被动（active/passive)，客户端、服务端(client/server)，广播、
多播(broadcast/multicase/manycase)，详细参考Association Management。通常运行模式是以Daemon方式持
续跟踪同步时钟源时间；当然也可以只运行一次，从外部时钟源同步时间（从上次纪录的频度误差文件中读取
频度误差值）。广播与多播模式下客户端能够自动发现时钟源服务器，并计算各个服务器的时延然后自动完成
配置，这种模式使得工作站集群自动配置变为现实。
    默认情况下nptd以Daemon方式持续跟踪多个时钟源，同步的间隔由一个复杂的状态机决定。状态机使用启发式
算法，根据消息包来回时延、频度误差来计算最优的同步间隔。通常情况下，状态机初始以64秒为间隔并最终
达到1024秒，少量的随机数值会被增加到间隔上为了均衡服务器压力。额外的，如果一个服务器不可达的情况
下，为了减少网络消息排队阻塞，间隔会逐步增加到1024秒。
    在某些情况下nptd不能正常持续运行，通常的规避手段时使用cron定时任务执行ntpdate命令。但是ntpdate并没
有像nptd一样有考虑各种信号处理、错误检查、连续同步算法。nptd -q 可以达到与 ntpdate同样的效果，-q 参数
使得 npt同步一次后就退出；同步的过程与Daemon模式的nptd是相同的。
    如果操作系统内核支持调整时钟频度（Solaris，Linux，FreeBSD都已经支持），那么时钟同步还有一种不以
Daemon方式运行的可选用法。首先，nptd以Daemon方式运行，配置好时钟源，大约一个或几个小时后，获取到
频度误差npt.drift 文件；然后退出nptd进程，并以一次性模式运行（nptd -q），此时每次nptd运行都基于当前获
取到的频度误差与时钟源同步时间。
}
ntp(同步间隔控制){
    当前版本的NTP包含了一个复杂的状态机，用于减少同步时的网络负载；同时也包含很多种提升精度的方法。
使用者在修改同步间隔（64秒~1024秒）的时候需要仔细考虑影响。默认的最小同步间隔可以使用 tinker minpool
命令修改为不小于16秒，这个值会被用作所有相关的使用到同步间隔的地方，除非显示使用minpoll 选项覆盖。
需要注意的是不少设备驱动在同步间隔小于64秒时候不能正常工作；同时广播与多播模式也是使用的默认值，除非显示覆盖。
}
ntp(NPTD语法){
ntpd [ -aAbdgLmNPqx ] [ -c conffile ] [ -f driftfile ] [ -g ] [ -k keyfile ] [ -l logfile ] [ -N high ] [ -p pidfile ] [ -r broadcastdelay ] [ -s statsdir]
-a              启动认证（默认启用）– -A禁用认证
-b              使用NTP广播消息同步– -c conffile指定配置文件名称
-d              启用调试模式– -D level指定调试级别
-f  driftfile   指定频度误差文件的路径– 
-g              正常情况下，ntpd 与时钟源的时间差超过1000秒的阈值会退出，如果阈值设置为0，
                则ntpd 不会检查，任何时差都会强制同步。-g 选项就是用于设置阈值为0；但是只是一次生效，如果ntpd 
                运行过程中发现时差超过1000秒，还是会退出。
-k keyfile     指定NTP认证key文件的路径– 
-l logfile     指定日志文件路径，默认是操作系统日志
-L             listen在虚拟IP上– 
-m             使用NTP多播消息在多播地址224.0.1.1上同步
-n             不fork进程– -N priority指定优先级运行ntpd进程
-p pidfile     指定ntpd的pid文件– -P覆盖操作系统的优先级限制
-q             仅同步一次后退出– -r broadcastdelay指定默认的广播、多播延迟时间
-s statsdir    指定统计工具生成的文件所在目录– -t key增加key到信任的key列表
-v, -V         增加系统变量
-x             默认情况下，ntpd在时差小于128ms时候使用微调模式，在大于128ms时候使用步长模式。
               -x 选项强制nptd仅使用微调模式同步。如果步长阈值（128ms）设置为0，则强制使用步长模式，-x也不生效。
               不是很推荐使用此选项，
               会导致时间同步变的非常缓慢，对强依赖网络时钟的应用有影响。微调模式的同步速率是0.5ms/s，需要2000s才同步1秒。
}
