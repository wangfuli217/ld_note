nmap(Name)
{
nmap — 网络探测工具和安全/端口扫描器
}

nmap(Synopsis)
{
nmap [ <扫描类型> ...] [ <选项> ] { <扫描目标说明> }
<功能描述>
Nmap ("Network Mapper(网络映射器)") 是一款开放源代码的 网络探测和安全审核的工具。它的设计目标是快速地扫描大型网络，当然用它扫描单个主机也没有问题。
Nmap以新颖的方式使用原始IP报文来发现网络上有哪些主机，那些 主机提供什么服务(应用程序名和版本)，那些服务运行在什么操作系统(包括版本信息)， 
    它们使用什么类型的报文过滤器/防火墙，以及一堆其它功能。
Nmap通常用于安全审核， 许多系统管理员和网络管理员也用它来做一些日常的工作，比如查看整个网络的信息， 管理服务升级计划，以及监视主机和服务的运行。

<输出说明>  [端口号，协议，服务名，状态]
Nmap输出的是扫描目标的列表，以及每个目标的补充信息，至于是哪些信息则依赖于所使用的选项。"所感兴趣的端口表格"是其中的关键。那张表列出端口号，协议，服务名
    称和状态。状态可能是 open(开放的)，filtered(被过滤的)， closed(关闭的)，或者unfiltered(未被过滤的)。

<状态>
Open(开放的)意味着目标机器上的应用程序正在该端口监听连接/报文。                                                               有报文响应
filtered(被过滤的) 意味着防火墙，过滤器或者其它网络障碍阻止了该端口被访问，Nmap无法得知它是 open(开放的) 还是closed(关闭的)。 有ICMP报文响应
closed(关闭的) 端口没有应用程序在它上面监听，但是他们随时可能开放。                                                           无报文响应
当端口对Nmap的探测做出响应，但是Nmap无法确定它们是关闭还是开放时，这些端口就被认为是 unfiltered(未被过滤的)                   有未预知报文响应
如果Nmap报告状态组合 open|filtered 和 closed|filtered时，那说明Nmap无法确定该端口处于两个状态中的哪一个状态。                 
当要求进行版本探测时，端口表也可以包含软件的版本信息。
当要求进行IP协议扫描时 (-sO)，Nmap提供关于所支持的IP协议而不是正在监听的端口的信息。

除了所感兴趣的端口表，Nmap还能提供关于目标机的进一步信息，包括反向域名，操作系统猜测，设备类型，和MAC地址。

}

nmap -A -T4 scanme.nmap.org playground   # -A， 用来进行操作系统及其版本的探测，-T4 可以加快执行速度，接着是两个目标主机名。

nmap(选项概要)
{
当Nmap不带选项运行时，该选项概要会被输出，最新的版本在这里 http://www.insecure.org/nmap/data/nmap.usage.txt。 它帮助人们记住最常用的选项，
但不能替代本手册其余深入的文档，一些晦涩的选项甚至不在这里。

Usage: nmap [Scan Type(s)] [Options] {target specification}
TARGET SPECIFICATION:
  Can pass hostnames, IP addresses, networks, etc.
  Ex: scanme.nmap.org, microsoft.com/24, 192.168.0.1; 10.0-255.0-255.1-254
  -iL <inputfilename>: Input from list of hosts/networks
  -iR <num hosts>: Choose random targets
  --exclude <host1[,host2][,host3],...>: Exclude hosts/networks
  --excludefile <exclude_file>: Exclude list from file
HOST DISCOVERY:
  -sL: List Scan - simply list targets to scan
  -sP: Ping Scan - go no further than determining if host is online
  -P0: Treat all hosts as online -- skip host discovery
  -PS/PA/PU [portlist]: TCP SYN/ACK or UDP discovery probes to given ports
  -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes
  -n/-R: Never do DNS resolution/Always resolve [default: sometimes resolve]
SCAN TECHNIQUES:
  -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans
  -sN/sF/sX: TCP Null, FIN, and Xmas scans
  --scanflags <flags>: Customize TCP scan flags
  -sI <zombie host[:probeport]>: Idlescan
  -sO: IP protocol scan
  -b <ftp relay host>: FTP bounce scan
PORT SPECIFICATION AND SCAN ORDER:
  -p <port ranges>: Only scan specified ports
    Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080
  -F: Fast - Scan only the ports listed in the nmap-services file)
  -r: Scan ports consecutively - do not randomize
SERVICE/VERSION DETECTION:
  -sV: Probe open ports to determine service/version info
  --version-light: Limit to most likely probes for faster identification
  --version-all: Try every single probe for version detection
  --version-trace: Show detailed version scan activity (for debugging)
OS DETECTION:
  -O: Enable OS detection
  --osscan-limit: Limit OS detection to promising targets
  --osscan-guess: Guess OS more aggressively
TIMING AND PERFORMANCE:
  -T[0-6]: Set timing template (higher is faster)
  --min-hostgroup/max-hostgroup <msec>: Parallel host scan group sizes
  --min-parallelism/max-parallelism <msec>: Probe parallelization
  --min-rtt-timeout/max-rtt-timeout/initial-rtt-timeout <msec>: Specifies
      probe round trip time.
  --host-timeout <msec>: Give up on target after this long
  --scan-delay/--max-scan-delay <msec>: Adjust delay between probes
FIREWALL/IDS EVASION AND SPOOFING:
  -f; --mtu <val>: fragment packets (optionally w/given MTU)
  -D <decoy1,decoy2[,ME],...>: Cloak a scan with decoys
  -S <IP_Address>: Spoof source address
  -e <iface>: Use specified interface
  -g/--source-port <portnum>: Use given port number
  --data-length <num>: Append random data to sent packets
  --ttl <val>: Set IP time-to-live field
  --spoof-mac <mac address, prefix, or vendor name>: Spoof your MAC address
OUTPUT:
  -oN/-oX/-oS/-oG <file>: Output scan results in normal, XML, s|<rIpt kIddi3,
     and Grepable format, respectively, to the given filename.
  -oA <basename>: Output in the three major formats at once
  -v: Increase verbosity level (use twice for more effect)
  -d[level]: Set or increase debugging level (Up to 9 is meaningful)
  --packet-trace: Show all packets sent and received
  --iflist: Print host interfaces and routes (for debugging)
  --append-output: Append to rather than clobber specified output files
  --resume <filename>: Resume an aborted scan
  --stylesheet <path/URL>: XSL stylesheet to transform XML output to HTML
  --no-stylesheet: Prevent Nmap from associating XSL stylesheet w/XML output
MISC:
  -6: Enable IPv6 scanning
  -A: Enables OS detection and Version detection
  --datadir <dirname>: Specify custom Nmap data file location
  --send-eth/--send-ip: Send packets using raw ethernet frames or IP packets
  --privileged: Assume that the user is fully privileged
  -V: Print version number
  -h: Print this help summary page.
EXAMPLES:
  nmap -v -A scanme.nmap.org
  nmap -v -sP 192.168.0.0/16 10.0.0.0/8
  nmap -v -iR 10000 -P0 -p 80

}

nmap(目标说明)
{
除了选项，所有出现在Nmap命令行上的都被视为对目标主机的说明。 最简单的情况是指定一个目标IP地址或主机名。

[网段扫描] CIDR
有时候您希望扫描整个网络的相邻主机。为此，Nmap支持CIDR风格的地址。您可以附加一个/<numbit>在一个IP地址或主机名后面， Nmap将会扫描所有和该参考
IP地址具有 <numbit>相同比特的所有IP地址或主机。 例如，192.168.10.0/24将会扫描192.168.10.0 (二进制格式: 11000000 10101000 00001010 00000000)
和192.168.10.255 (二进制格式: 11000000 10101000 00001010 11111111)之间的256台主机。 192.168.10.40/24 将会做同样的事情。假设主机 
scanme.nmap.org的IP地址是205.217.153.62， scanme.nmap.org/16 将扫描205.217.0.0和205.217.255.255之间的65,536 个IP地址。 所允许的最小值是/1， 
这将会扫描半个互联网。最大值是/32，这将会扫描该主机或IP地址， 因为所有的比特都固定了。
[网段扫描] - 连字符
CIDR标志位很简洁但有时候不够灵活。例如，您也许想要扫描 192.168.0.0/16，但略过任何以.0或者.255 结束的IP地址，因为它们通常是广播地址。 
Nmap通过八位字节地址范围支持这样的扫描，您可以用逗号分开的数字或范围列表为IP地址的每个八位字节指定它的范围。 例如，192.168.0-255.1-254 
将略过在该范围内以.0和.255结束的地址。 范围不必限于最后的8位：0-255.0-255.13.37 将在整个互联网范围内扫描所有以13.37结束的地址。 
这种大范围的扫描对互联网调查研究也许有用。

IPv6地址只能用规范的IPv6地址或主机名指定。 CIDR 和八位字节范围不支持IPv6，因为它们对于IPv6几乎没什么用。

Nmap命令行接受多个主机说明，它们不必是相同类型。命令nmap scanme.nmap.org 192.168.0.0/8 10.0.0，1，3-7.0-255将和您预期的一样执行。

虽然目标通常在命令行指定，下列选项也可用来控制目标的选择：

-iL <inputfilename> (从列表中输入)
    从 <inputfilename>中读取目标说明。在命令行输入一堆主机名显得很笨拙，然而经常需要这样。 例如，您的DHCP服务器可能导出10,000个当前租约的列表，
    而您希望对它们进行扫描。如果您不是使用未授权的静态IP来定位主机，或许您想要扫描所有IP地址。 只要生成要扫描的主机的列表，用-iL 把文件名作
    为选项传给Nmap。列表中的项可以是Nmap在 命令行上接受的任何格式(IP地址，主机名，CIDR，IPv6，或者八位字节范围)。 每一项必须以一个或多个空格，
    制表符或换行符分开。 如果您希望Nmap从标准输入而不是实际文件读取列表， 您可以用一个连字符(-)作为文件名。

-iR <hostnum> (随机选择目标)
    对于互联网范围内的调查和研究， 您也许想随机地选择目标。 <hostnum> 选项告诉 Nmap生成多少个IP。不合需要的IP如特定的私有，组播或者未分配的
    地址自动 略过。选项 0 意味着永无休止的扫描。记住，一些网管对于未授权的扫描可能会很感冒并加以抱怨。 使用该选项的后果自负! 如果在某个雨天
    的下午，您觉得实在无聊， 试试这个命令nmap -sS -PS80 -iR 0 -p 80随机地找一些网站浏览。

--exclude <host1[，host2][，host3]，...> (排除主机/网络)
    如果在您指定的扫描范围有一些主机或网络不是您的目标， 那就用该选项加上以逗号分隔的列表排除它们。该列表用正常的Nmap语法， 因此它可以包括
    主机名，CIDR，八位字节范围等等。 当您希望扫描的网络包含执行关键任务的服务器，已知的对端口扫描反应强烈的 系统或者被其它人看管的子网时，
    这也许有用。

--excludefile <excludefile> (排除文件中的列表)
    这和--exclude 选项的功能一样，只是所排除的目标是用以 换行符，空格，或者制表符分隔的 <excludefile>提供的，而不是在命令行上输入的。


}

nmap(主机发现)
{
任何网络探测任务的最初几个步骤之一就是把一组IP范围(有时该范围是巨大的)缩小为 一列活动的或者您感兴趣的主机。扫描每个IP的每个端口很慢，通常也没必要。 当然，什么
样的主机令您感兴趣主要依赖于扫描的目的。网管也许只对运行特定服务的 主机感兴趣，而从事安全的人士则可能对一个马桶都感兴趣，只要它有IP地址:-)。
@@@ 一个系统管理员也许仅仅使用Ping来定位内网上的主机，而一个外部入侵测试人员则可能绞尽脑汁用各种方法试图 突破防火墙的封锁。

由于主机发现的需求五花八门，Nmap提供了一箩筐的选项来定制您的需求。主机发现有时候也叫做ping扫描，但它远远超越用世人皆知的ping工具发送简单的ICMP回声请求报
文。用户完全可以通过使用列表扫描(-sL)或者通过关闭ping (-P0)跳过ping的步骤，也可以使用多个端口把TCP SYN/ACK，UDP和ICMP 任意组合起来玩一玩。这些探测的目的是
获得响应以显示某个IP地址是否是活动的(正在被某主机或者网络设备使用)。 在许多网络上，在给定的时间，往往只有小部分的IP地址是活动的。 这种情况在基于RFC1918的私有
地址空间如10.0.0.0/8尤其普遍。 那个网络有16,000,000个IP，但我见过一些使用它的公司连1000台机器都没有。 主机发现能够找到零星分布于IP地址海洋上的那些机器。

如果没有给出主机发现的选项，Nmap 就发送一个TCP ACK报文到80端口和一个ICMP回声请求到每台目标机器。 一个例外是ARP扫描用于局域网上的任何目标机器。对于非特权
UNIX shell用户，使用connect()系统调用会发送一个SYN报文而不是ACK这些默认行为和使用-PA -PE选项的效果相同。 扫描局域网时，这种主机发现一般够用了，但是对于安全
审核，建议进行更加全面的探测。

-P*选项(用于选择 ping的类型)可以被结合使用。 您可以通过使用不同的TCP端口/标志位和ICMP码发送许多探测报文 来增加穿透防守严密的防火墙的机会。另外要注意的是即使您
指定了其它 -P*选项，ARP发现(-PR)对于局域网上的目标而言是默认行为，因为它总是更快更有效。

下列选项控制主机发现。

-sL (列表扫描)
    列表扫描是主机发现的退化形式，它仅仅列出指定网络上的每台主机， 不发送任何报文到目标主机。默认情况下，Nmap仍然对主机进行反向域名解析以获取它们的名字。
    简单的主机名能给出的有用信息常常令人惊讶。例如， fw.chi.playboy.com是花花公子芝加哥办公室的防火墙。Nmap最后还会报告IP地址的总数。列表扫描可以很好的
    确保您拥有正确的目标IP。如果主机的域名出乎您的意料，那么就值得进一步检查以防错误地扫描其它组织的网络。
    
    既然只是打印目标主机的列表，像其它一些高级功能如端口扫描，操作系统探测或者Ping扫描的选项就没有了。如果您希望关闭ping扫描而仍然执行这样的高级功能，
    请继续阅读关于 -P0选项的介绍。

-sP (Ping扫描)
    该选项告诉Nmap仅仅进行ping扫描 (主机发现)，然后打印出对扫描做出响应的那些主机。 没有进一步的测试 (如端口扫描或者操作系统探测)。 这比列表扫描更积极，
    常常用于和列表扫描相同的目的。它可以得到些许目标网络的信息而不被特别注意到。 对于攻击者来说，了解多少主机正在运行比列表扫描提供的一列IP和主机名往往
    更有价值。

    系统管理员往往也很喜欢这个选项。 它可以很方便地得出网络上有多少机器正在运行或者监视服务器是否正常运行。常常有人称它为 地毯式ping，它比ping广播地址
    更可靠，因为许多主机对广播请求不响应。

    -sP选项在默认情况下， 发送一个ICMP回声请求和一个TCP报文到80端口。如果非特权用户执行，就发送一个SYN报文(用connect()系统调用)到目标机的80端口。
    当特权用户扫描局域网上的目标机时，会发送ARP请求(-PR)， ，除非使用了--send-ip选项。 -sP选项可以和除-P0)之外的任何发现探测类型-P* 选项结合使用
    以达到更大的灵活性。 一旦使用了任何探测类型和端口选项，默认的探测(ACK和回应请求)就被覆盖了。 当防守严密的防火墙位于运行Nmap的源主机和目标网络之间时，
    推荐使用那些高级选项。否则，当防火墙捕获并丢弃探测包或者响应包时，一些主机就不能被探测到。

-P0 (无ping)
    该选项完全跳过Nmap发现阶段。 通常Nmap在进行高强度的扫描时用它确定正在运行的机器。 默认情况下，Nmap只对正在运行的主机进行高强度的探测如端口扫描，
    版本探测，或者操作系统探测。用-P0禁止主机发现会使Nmap对每一个指定的目标IP地址进行所要求的扫描。所以如果在命令行指定一个B类目标地址空间(/16)， 
    所有 65,536 个IP地址都会被扫描。 -P0的第二个字符是数字0而不是字母O。 和列表扫描一样，跳过正常的主机发现，但不是打印一个目标列表， 而是继续执行所
    要求的功能，就好像每个IP都是活动的。

-PA [portlist] (TCP ACK Ping)
    TCP ACK ping和刚才讨论的SYN ping相当类似。 也许您已经猜到了，区别就是设置TCP的ACK标志位而不是SYN标志位。 ACK报文表示确认一个建立连接的尝试，但该连接尚
    未完全建立。 所以远程主机应该总是回应一个RST报文， 因为它们并没有发出过连接请求到运行Nmap的机器，如果它们正在运行的话。
    
-PU [portlist] (UDP Ping)
    还有一个主机发现的选项是UDP ping，它发送一个空的(除非指定了--data-length UDP报文到给定的端口。端口列表的格式和前面讨论过的-PS和-PA选项还是一样。 
    如果不指定端口，默认是31338。该默认值可以通过在编译时改变nmap.h文件中的 DEFAULT-UDP-PROBE-PORT值进行配置。默认使用这样一个奇怪的端口是因为对开放端口 
    进行这种扫描一般都不受欢迎。  

-PE; -PP; -PM (ICMP Ping Types)
    除了前面讨论的这些不常见的TCP和UDP主机发现类型， Nmap也能发送世人皆知的ping 程序所发送的报文。Nmap发送一个ICMP type 8 (回声请求)
    报文到目标IP地址， 期待从运行的主机得到一个type 0 (回声响应)报文。 对于网络探索者而言，不幸的是，许多主机和防火墙现在封锁这些报文，
    而不是按期望的那样响应， 参见RFC 1122。因此，仅仅ICMP扫描对于互联网上的目标通常是不够的。 但对于系统管理员监视一个内部网络，
    它们可能是实际有效的途径。 使用-PE选项打开该回声请求功能。

-PR (ARP Ping)
    最常见的Nmap使用场景之一是扫描一个以太局域网。 在大部分局域网上，特别是那些使用基于 RFC1918私有地址范围的网络，在一个给定的时间
    绝大部分 IP地址都是不使用的。 当Nmap试图发送一个原始IP报文如ICMP回声请求时， 操作系统必须确定对应于目标IP的硬件 地址(ARP)，这样
    它才能把以太帧送往正确的地址。 这一般比较慢而且会有些问题，因为操作系统设计者认为一般不会在短时间内 对没有运行的机器作几百万次的
    ARP请求。

-n (不用域名解析)
    告诉Nmap 永不对它发现的活动IP地址进行反向域名解析。 既然DNS一般比较慢，这可以让事情更快些。
    
-R (为所有目标解析域名)
    告诉Nmap 永远 对目标IP地址作反向域名解析。 一般只有当发现机器正在运行时才进行这项操作。
    
--system-dns (使用系统域名解析器)
    默认情况下，Nmap通过直接发送查询到您的主机上配置的域名服务器 来解析域名。
 
}

nmap(端口扫描基础)
{

虽然Nmap这些年来功能越来越多， 它也是从一个高效的端口扫描器开始的，并且那仍然是它的核心功能。 nmap <target>这个简单的命令扫描主机
<target>上的超过 1660个TCP端口。许多传统的端口扫描器只列出所有端口是开放还是关闭的， Nmap的信息粒度比它们要细得多。 它把端口分成六
个状态: open(开放的)， closed(关闭的)，filtered(被过滤的)， unfiltered(未被过滤的)， open|filtered(开放或者被过滤的)，或者 
closed|filtered(关闭或者被过滤的)。

这些状态并非端口本身的性质，而是描述Nmap怎样看待它们。例如， 对于同样的目标机器的135/tcp端口，从同网络扫描显示它是开放的，而跨网络
作完全相同的扫描则可能显示它是 filtered(被过滤的)。


Nmap所识别的6个端口状态。

open(开放的)
    应用程序正在该端口接收TCP 连接或者UDP报文。发现这一点常常是端口扫描 的主要目标。安全意识强的人们知道每个开放的端口都是攻击的入口。攻击者或者入侵测试者
    想要发现开放的端口。 而管理员则试图关闭它们或者用防火墙保护它们以免妨碍了合法用户。 非安全扫描可能对开放的端口也感兴趣，因为它们显示了网络上那些服务可
    供使用。 

closed(关闭的)
    关闭的端口对于Nmap也是可访问的(它接受Nmap的探测报文并作出响应)， 但没有应用程序在其上监听。 它们可以显示该IP地址上(主机发现，或者ping
    扫描)的主机正在运行up 也对部分操作系统探测有所帮助。 因为关闭的关口是可访问的，也许过会儿值得再扫描一下，可能一些又开放了。 系统管理
    员可能会考虑用防火墙封锁这样的端口。 那样他们就会被显示为被过滤的状态，下面讨论。 

filtered(被过滤的)
    由于包过滤阻止探测报文到达端口， Nmap无法确定该端口是否开放。过滤可能来自专业的防火墙设备，路由器规则 或者主机上的软件防火墙。这样的
    端口让攻击者感觉很挫折，因为它们几乎不提供 任何信息。有时候它们响应ICMP错误消息如类型3代码13 (无法到达目标: 通信被管理员禁止)，但更
    普遍的是过滤器只是丢弃探测帧， 不做任何响应。 这迫使Nmap重试若干次以访万一探测包是由于网络阻塞丢弃的。 这使得扫描速度明显变慢。 

unfiltered(未被过滤的)
    未被过滤状态意味着端口可访问，但Nmap不能确定它是开放还是关闭。 只有用于映射防火墙规则集的ACK扫描才会把端口分类到这种状态。 
    用其它类型的扫描如窗口扫描，SYN扫描，或者FIN扫描来扫描未被过滤的端口可以帮助确定 端口是否开放。 

open|filtered(开放或者被过滤的)
    当无法确定端口是开放还是被过滤的，Nmap就把该端口划分成 这种状态。开放的端口不响应就是一个例子。没有响应也可能意味着报文过滤器丢弃
    了探测报文或者它引发的任何响应。因此Nmap无法确定该端口是开放的还是被过滤的。 UDP，IP协议， FIN，Null，和Xmas扫描可能把端口归入此类。

closed|filtered(关闭或者被过滤的)
    该状态用于Nmap不能确定端口是关闭的还是被过滤的。 它只可能出现在IPID Idle扫描中。
}

nmap(端口扫描技术)
{
这一节讨论Nmap支持的大约十几种扫描技术。一般一次只用一种方法， 除了UDP扫描(-sU)可能和任何一种TCP扫描类型结合使用。 友情提示一下，端口扫描
类型的选项格式是-s<C>， 其中<C> 是个显眼的字符，通常是第一个字符。 一个例外是deprecated FTP bounce扫描(-b)。默认情况下，Nmap执行一个 SYN
扫描，但是如果用户没有权限发送原始报文(在UNIX上需要root权限)或者如果指定的是IPv6目标，Nmap调用connect()。 本节列出的扫描中，非特权用户只能
执行connect()和ftp bounce扫描。

-sS (TCP SYN扫描)
    SYN扫描作为默认的也是最受欢迎的扫描选项，是有充分理由的。 它执行得很快，在一个没有入侵防火墙的快速网络上，每秒钟可以扫描数千个端口。
    SYN扫描相对来说不张扬，不易被注意到，因为它从来不完成TCP连接。 它也不像Fin/Null/Xmas，Maimon和Idle扫描依赖于特定平台，而可以应对任何
    兼容的 TCP协议栈。 它还可以明确可靠地区分open(开放的)， closed(关闭的)，和filtered(被过滤的) 状态.
    
-sT (TCP connect()扫描)
    当SYN扫描不能用时，TCP Connect()扫描就是默认的TCP扫描。 当用户没有权限发送原始报文或者扫描IPv6网络时，就是这种情况。 
    Instead of writing raw packets as most other scan types do，Nmap通过创建connect() 系统调用要求操作系统和目标机以及端口建立连接，
    而不像其它扫描类型直接发送原始报文。 这是和Web浏览器，P2P客户端以及大多数其它网络应用程序用以建立连接一样的 高层系统调用。
    它是叫做Berkeley Sockets API编程接口的一部分。Nmap用 该API获得每个连接尝试的状态信息，而不是读取响应的原始报文。
    
-sU (UDP扫描)
    虽然互联网上很多流行的服务运行在TCP 协议上，UDP服务也不少。 DNS，SNMP，和DHCP (注册的端口是53，161/162，和67/68)是最常见的三个。
    因为UDP扫描一般较慢，比TCP更困难，一些安全审核人员忽略这些端口。 这是一个错误，因为可探测的UDP服务相当普遍，攻击者当然不会忽略
    整个协议。 所幸，Nmap可以帮助记录并报告UDP端口。 
    
-sN; -sF; -sX (TCP Null，FIN，and Xmas扫描)
    这三种扫描类型 (甚至用下一节描述的 --scanflags 选项的更多类型) 在TCP RFC 中发掘了一个微妙的方法来区分open(开放的)和 closed(关闭的)端口。第65页说“如果 [目标]端口状态是关闭的.... 进入的不含RST的报文导致一个RST响应。” 接下来的一页 讨论不设置SYN，RST，或者ACK位的报文发送到开放端口: “理论上，这不应该发生，如果您确实收到了，丢弃该报文，返回。 ”
    如果扫描系统遵循该RFC，当端口关闭时，任何不包含SYN，RST，或者ACK位的报文会导致 一个RST返回，而当端口开放时，应该没有任何响应。只要不包含SYN，RST，或者ACK， 任何其它三种(FIN，PSH，and URG)的组合都行。Nmap有三种扫描类型利用这一点：

    Null扫描 (-sN)
        不设置任何标志位(tcp标志头是0)
    FIN扫描 (-sF)
        只设置TCP FIN标志位。
    Xmas扫描 (-sX)
        设置FIN，PSH，和URG标志位，就像点亮圣诞树上所有的灯一样。   

-sA (TCP ACK扫描)
    这种扫描与目前为止讨论的其它扫描的不同之处在于 它不能确定open(开放的)或者 open|filtered(开放或者过滤的))端口。 它用于发现防火墙规则，
    确定它们是有状态的还是无状态的，哪些端口是被过滤的。

    ACK扫描探测报文只设置ACK标志位(除非您使用 --scanflags)。当扫描未被过滤的系统时， open(开放的)和closed(关闭的) 端口 都会返回RST报文。
    Nmap把它们标记为 unfiltered(未被过滤的)，意思是 ACK报文不能到达，但至于它们是open(开放的)或者 closed(关闭的) 无法确定。不响应的端口 
    或者发送特定的ICMP错误消息(类型3，代号1，2，3，9，10， 或者13)的端口，标记为 filtered(被过滤的)。
    
-sW (TCP窗口扫描)
    除了利用特定系统的实现细节来区分开放端口和关闭端口，当收到RST时不总是打印unfiltered， 窗口扫描和ACK扫描完全一样。 它通过检查返回的
    RST报文的TCP窗口域做到这一点。 在某些系统上，开放端口用正数表示窗口大小(甚至对于RST报文) 而关闭端口的窗口大小为0。因此，当收到RST时，
    窗口扫描不总是把端口标记为 unfiltered， 而是根据TCP窗口值是正数还是0，分别把端口标记为open或者 closed.
    
-sM (TCP Maimon扫描)
    Maimon扫描是用它的发现者Uriel Maimon命名的。他在 Phrack Magazine issue #49 (November 1996)中描述了这一技术。 Nmap在两期后加入了这一技术。 这项技术和Null，FIN，以及Xmas扫描完全一样，除了探测报文是FIN/ACK。 根据RFC 793 (TCP)，无论端口开放或者关闭，都应该对这样的探测响应RST报文。 然而，Uriel注意到如果端口开放，许多基于BSD的系统只是丢弃该探测报文。 
    
--scanflags (定制的TCP扫描)
    真正的Nmap高级用户不需要被这些现成的扫描类型束缚。 --scanflags选项允许您通过指定任意TCP标志位来设计您自己的扫描。 让您的创造力流动，
    躲开那些仅靠本手册添加规则的入侵检测系统！
    --scanflags选项可以是一个数字标记值如9 (PSH和FIN)， 但使用字符名更容易些。 只要是URG， ACK，PSH， RST，SYN，and FIN的任何组合就行。
    例如，--scanflags URGACKPSHRSTSYNFIN设置了所有标志位，但是这对扫描没有太大用处。 标志位的顺序不重要。 
    
-sI <zombie host[:probeport]> (Idlescan)
    这种高级的扫描方法允许对目标进行真正的TCP端口盲扫描 (意味着没有报文从您的真实IP地址发送到目标)。  

-sO (IP协议扫描)
    IP 协议扫描可以让您确定目标机支持哪些IP协议 (TCP，ICMP，IGMP，等等)。从技术上说，这不是端口扫描 ，既然它遍历的是IP协议号而不是
    TCP或者UDP端口号。 但是它仍使用 -p选项选择要扫描的协议号， 用正常的端口表格式报告结果，甚至用和真正的端口扫描一样 的扫描引擎。
    因此它和端口扫描非常接近，也被放在这里讨论。
   
}

nmap(端口说明和扫描顺序)
{
除了所有前面讨论的扫描方法， Nmap提供选项说明那些端口被扫描以及扫描是随机还是顺序进行。 默认情况下，Nmap用指定的协议对端口1到1024以及
nmap-services 文件中列出的更高的端口在扫描。

-p <port ranges> (只扫描指定的端口)
    该选项指明您想扫描的端口，覆盖默认值。 单个端口和用连字符表示的端口范围(如 1-1023)都可以。 范围的开始以及/或者结束值可以被省略， 
    分别导致Nmap使用1和65535。所以您可以指定 -p-从端口1扫描到65535。 如果您特别指定，也可以扫描端口0。 对于IP协议扫描(-sO)，该选项指定
    您希望扫描的协议号 (0-255)。

    当既扫描TCP端口又扫描UDP端口时，您可以通过在端口号前加上T: 或者U:指定协议。 协议限定符一直有效您直到指定另一个。 例如，参数 -p U:53，111，137，T:21-25，80，139，8080 将扫描UDP 端口53，111，和137，同时扫描列出的TCP端口。注意，要既扫描 UDP又扫描TCP，您必须指定 -sU ，以及至少一个TCP扫描类型(如 -sS，-sF，或者 -sT)。如果没有给定协议限定符， 端口号会被加到所有协议列表。

-F (快速 (有限的端口) 扫描)
    在nmap的nmap-services 文件中(对于-sO，是协议文件)指定您想要扫描的端口。 这比扫描所有65535个端口快得多。 因为该列表包含如此多的TCP
    端口(1200多)，这和默认的TCP扫描 scan (大约1600个端口)速度差别不是很大。如果您用--datadir选项指定您自己的 小小的nmap-services文件 ，
    差别会很惊人。

-r (不要按随机顺序扫描端口)
    默认情况下，Nmap按随机顺序扫描端口 (除了出于效率的考虑，常用的端口前移)。这种随机化通常都是受欢迎的， 但您也可以指定-r来顺序端口扫描。
    

}

nmap(服务和版本探测)
{
-sV (版本探测)
    打开版本探测。 您也可以用-A同时打开操作系统探测和版本探测。

--allports (不为版本探测排除任何端口)
    默认情况下，Nmap版本探测会跳过9100 TCP端口，因为一些打印机简单地打印送到该端口的 任何数据，这回导致数十页HTTP get请求，二进制 
    SSL会话请求等等被打印出来。这一行为可以通过修改或删除nmap-service-probes 中的Exclude指示符改变， 您也可以不理会任何Exclude指示符，
    指定--allports扫描所有端口 

--version-intensity <intensity> (设置 版本扫描强度)
    当进行版本扫描(-sV)时，nmap发送一系列探测报文 ，每个报文都被赋予一个1到9之间的值。 被赋予较低值的探测报文对大范围的常见服务有效，
    而被赋予较高值的报文 一般没什么用。强度水平说明了应该使用哪些探测报文。数值越高， 服务越有可能被正确识别。 然而，高强度扫描花更多
    时间。强度值必须在0和9之间。 默认是7。当探测报文通过nmap-service-probes ports指示符 注册到目标端口时，无论什么强度水平，探测报文
    都会被尝试。这保证了DNS 探测将永远在任何开放的53端口尝试， SSL探测将在443端口尝试，等等。

--version-light (打开轻量级模式)
    这是 --version-intensity 2的方便的别名。轻量级模式使 版本扫描快许多，但它识别服务的可能性也略微小一点。
    
--version-all (尝试每个探测)
    --version-intensity 9的别名， 保证对每个端口尝试每个探测报文。
    
--version-trace (跟踪版本扫描活动)
    这导致Nmap打印出详细的关于正在进行的扫描的调试信息。 它是您用--packet-trace所得到的信息的子集。
    
-sR (RPC扫描)
    这种方法和许多端口扫描方法联合使用。 它对所有被发现开放的TCP/UDP端口执行SunRPC程序NULL命令，来试图 确定它们是否RPC端口，如果是， 是什么程序和版本号。因此您可以有效地获得和rpcinfo -p一样的信息， 即使目标的端口映射在防火墙后面(或者被TCP包装器保护)。Decoys目前不能和RPC scan一起工作。 这作为版本扫描(-sV)的一部分自动打开。 由于版本探测包括它并且全面得多，-sR很少被需要。
}

nmap(操作系统探测)
{
-O (启用操作系统检测)
    也可以使用-A来同时启用操作系统检测和版本检测。
    
--osscan-limit (针对指定的目标进行操作系统检测)
    如果发现一个打开和关闭的TCP端口时，操作系统检测会更有效。 采用这个选项，Nmap只对满足这个条件的主机进行操作系统检测，这样可以 
    节约时间，特别在使用-P0扫描多个主机时。这个选项仅在使用 -O或-A 进行操作系统检测时起作用。
    
--osscan-guess; --fuzzy (推测操作系统检测结果)
    当Nmap无法确定所检测的操作系统时，会尽可能地提供最相近的匹配，Nmap默认 进行这种匹配，使用上述任一个选项使得Nmap的推测更加有效。
}

nmap(时间和性能)
{
--min-hostgroup <milliseconds>; --max-hostgroup <milliseconds> (调整并行扫描组的大小)
--min-parallelism <milliseconds>; --max-parallelism <milliseconds> (调整探测报文的并行度)
--min-rtt-timeout <milliseconds>， --max-rtt-timeout <milliseconds>， --initial-rtt-timeout <milliseconds> (调整探测报文超时)
--host-timeout <milliseconds> (放弃低速目标主机) 
--scan-delay <milliseconds>; --max-scan-delay <milliseconds> (调整探测报文的时间间隔)
-T <Paranoid|Sneaky|Polite|Normal|Aggressive|Insane> (设置时间模板)
}

nmap(防火墙/IDS躲避和哄骗)
{
-f (报文分段); --mtu (使用指定的MTU) 
-D <decoy1 [，decoy2][，ME]，...> (使用诱饵隐蔽扫描)
-S <IP_Address> (源地址哄骗) 
-e <interface> (使用指定的接口) 
--source-port <portnumber>; -g <portnumber> (源端口哄骗)
--data-length <number> (发送报文时 附加随机数据)
--ttl <value> (设置IP time-to-live域)
--randomize-hosts (对目标主机的顺序随机排列) 
--spoof-mac <mac address，prefix，or vendor name> (MAC地址哄骗)
}

nmap(输出)
{
-oN <filespec> (标准输出)
    要求将标准输出直接写入指定 的文件。如上所述，这个格式与交互式输出 略有不同。
-oX <filespec> (XML输出)
-oS <filespec> (ScRipT KIdd|3 oUTpuT)
    脚本小子输出类似于交互工具输出，这是一个事后处理.
-oG <filespec> (Grep输出)

-v (提高输出信息的详细度)
-d [level] (提高或设置调试级别)
--packet-trace (跟踪发送和接收的报文)
--iflist (列举接口和路由)
}


http://blog.csdn.net/heimian/article/details/7080739
nmap(BASIC SCANNING TECHNIQUES)
{
Goal                            command                                    example
Scan a Single Target            nmap [target]                              nmap 192.168.0.1
Scan Multiple Targets           nmap [target1, target2, etc]               nmap 192.168.0.1 192.168.0.2
Scan a List of Targets          nmap -iL [list.txt]                        nmap -iL targets.txt
Scan a Range of Hosts           nmap [range of ip addresses]               nmap 192.168.0.1-10
Scan an Entire Subnet           nmap [ip address/cdir]                     nmap 192.168.0.1/24
Scan Random Hosts               nmap -iR [number]                          nmap -iR 0
Excluding Targets from a Scan   nmap [targets] –exclude [targets]          nmap 192.168.0.1/24 –exclude 192.168.0.100, 192.168.0.200
Excluding Targets Using a List  nmap [targets] –excludefile [list.txt]     nmap 192.168.0.1/24 –excludefile notargets.txt
Perform an Aggressive Scan      nmap -A [target]                           nmap -A 192.168.0.1
Scan an IPv6 Target             nmap -6 [target]                           nmap -6 1aff:3c21:47b1:0000:0000:0000:0000:2afe
}


nmap(DISCOVERY OPTIONS)
{
Goal                            command                                 example
Perform a Ping Only Scan        nmap -sP [target]                       nmap -sP 192.168.0.1
Don’t Ping                      nmap -PN [target]                       nmap -PN 192.168.0.1
TCP SYN Ping                    nmap -PS [target]                       nmap -PS 192.168.0.1
TCP ACK Ping                    nmap -PA [target]                       nmap -PA 192.168.0.1
UDP Ping                        nmap -PU [target]                       nmap -PU 192.168.0.1
SCTP INIT Ping                  nmap -PY [target]                       nmap -PY 192.168.0.1
ICMP Echo Ping                  nmap -PE [target]                       nmap -PE 192.168.0.1
ICMP Timestamp Ping             nmap -PP [target]                       nmap -PP 192.168.0.1
ICMP Address Mask Ping          nmap -PM [target]                       nmap -PM 192.168.0.1
IP Protocol Ping                nmap -PO [target]                       nmap -PO 192.168.0.1
ARP Ping                        nmap -PR [target]                       nmap -PR 192.168.0.1
Traceroute                      nmap –traceroute [target]               nmap –traceroute 192.168.0.1
Force Reverse DNS Resolution    nmap -R [target]                        nmap -R 192.168.0.1
Disable Reverse DNS Resolution  nmap -n [target]                        nmap -n 192.168.0.1
Alternative DNS Lookup          nmap –system-dns [target]               nmap –system-dns 192.168.0.1
Manually Specify DNS Server(s)  nmap –dns-servers [servers] [target]    nmap –dns-servers 201.56.212.54 192.168.0.1
Create a Host List              nmap -sL [targets]                      nmap -sL 192.168.0.1/24
}

nmap(ADVANCED SCANNING OPTIONS)
{
Goal                        command                             example
TCP SYN Scan                nmap -sS [target]                   nmap -sS 192.168.0.1
TCP Connect Scan            nmap -sT [target]                   nmap -sT 192.168.0.1
UDP Scan                    nmap -sU [target]                   nmap -sU 192.168.0.1
TCP NULL Scan               nmap -sN [target]                   nmap -sN 192.168.0.1
TCP FIN Scan                nmap -sF [target]                   nmap -sF 192.168.0.1
Xmas Scan                   nmap -sX [target]                   nmap -sX 192.168.0.1
TCP ACK Scan                nmap -sA [target]                   nmap -sA 192.168.0.1
Custom TCP Scan             nmap –scanflags [flags] [target]    nmap –scanflags SYNFIN 192.168.0.1
IP Protocol Scan            nmap -sO [target]                   nmap -sO 192.168.0.1
Send Raw Ethernet Packets   nmap –send-eth [target]             nmap –send-eth 192.168.0.1
Send IP Packets             nmap –send-ip [target]              nmap –send-ip 192.168.0.1
}

nmap(PORT SCANNING OPTIONS)
{
Goal                            command                                         example
Perform a Fast Scan             nmap -F [target]                                nmap -F 192.168.0.1
Scan Specific Ports             nmap -p [port(s)] [target]                      nmap -p 21-25,80,139,8080 192.168.1.1
Scan Ports by Name              nmap -p [port name(s)] [target]                 nmap -p ftp,http* 192.168.0.1
Scan Ports by Protocol          nmap -sU -sT -p U:[ports],T:[ports] [target]    nmap -sU -sT -p U:53,111,137,T:21-25,80,139,8080 192.168.0.1
Scan All Ports                  nmap -p ‘*’ [target]                            nmap -p ‘*’ 192.168.0.1
Scan Top Ports                  nmap –top-ports [number] [target]               nmap –top-ports 10 192.168.0.1
Perform a Sequential Port Scan  nmap -r [target]                                nmap -r 192.168.0.1
}

nmap(VERSION DETECTION)
{
Goal                                command                             example
Operating System Detection          nmap -O [target]                    nmap -O 192.168.0.1
Submit TCP/IP Fingerprints          www.nmap.org/submit/         
Attempt to Guess an Unknown OS      nmap -O –osscan-guess [target]      nmap -O –osscan-guess 192.168.0.1
Service Version Detection           nmap -sV [target]                   nmap -sV 192.168.0.1
Troubleshooting Version Scans       nmap -sV –version-trace [target]    nmap -sV –version-trace 192.168.0.1
Perform a RPC Scan                  nmap -sR [target]                   nmap -sR 192.168.0.1
}

nmap(TIMING OPTIONS)
{
Goal                                    command                                         example
Timing Templates                        nmap -T[0-5] [target]                           nmap -T3 192.168.0.1
Set the Packet TTL                      nmap –ttl [time] [target]                       nmap –ttl 64 192.168.0.1
Minimum # of Parallel Operations        nmap –min-parallelism [number] [target]         nmap –min-parallelism 10 192.168.0.1
Maximum # of Parallel Operations        nmap –max-parallelism [number] [target]         nmap –max-parallelism 1 192.168.0.1
Minimum Host Group Size                 nmap –min-hostgroup [number] [targets]          nmap –min-hostgroup 50 192.168.0.1
Maximum Host Group Size                 nmap –max-hostgroup [number] [targets]          nmap –max-hostgroup 1 192.168.0.1
Maximum RTT Timeout                     nmap –initial-rtt-timeout [time] [target]       nmap –initial-rtt-timeout 100ms 192.168.0.1
Initial RTT Timeout                     nmap –max-rtt-timeout [TTL] [target]            nmap –max-rtt-timeout 100ms 192.168.0.1
Maximum Retries                         nmap –max-retries [number] [target]             nmap –max-retries 10 192.168.0.1
Host Timeout                            nmap –host-timeout [time] [target]              nmap –host-timeout 30m 192.168.0.1
Minimum Scan Delay                      nmap –scan-delay [time] [target]                nmap –scan-delay 1s 192.168.0.1
Maximum Scan Delay                      nmap –max-scan-delay [time] [target]            nmap –max-scan-delay 10s 192.168.0.1
Minimum Packet Rate                     nmap –min-rate [number] [target]                nmap –min-rate 50 192.168.0.1
Maximum Packet Rate                     nmap –max-rate [number] [target]                nmap –max-rate 100 192.168.0.1
Defeat Reset Rate Limits                nmap –defeat-rst-ratelimit [target]             nmap –defeat-rst-ratelimit 192.168.0.1
}

nmap(OUTPUT OPTIONS)
{
Goal                                    command                                 example
Save Output to a Text File              nmap -oN [scan.txt] [target]            nmap -oN scan.txt 192.168.0.1
Save Output to a XML File               nmap -oX [scan.xml] [target]            nmap -oX scan.xml 192.168.0.1
Grepable Output                         nmap -oG [scan.txt] [targets]           nmap -oG scan.txt 192.168.0.1
Output All Supported File Types         nmap -oA [path/filename] [target]       nmap -oA ./scan 192.168.0.1
Periodically Display Statistics         nmap –stats-every [time] [target]       nmap –stats-every 10s 192.168.0.1
133t Output                             nmap -oS [scan.txt] [target]            nmap -oS scan.txt 192.168.0.1
}

nmap(TROUBLESHOOTING AND DEBUGGING)
{
Goal                            command                         example
Getting Help                    nmap -h                         nmap -h
Display Nmap Version            nmap -V                         nmap -V
Verbose Output                  nmap -v [target]                nmap -v 192.168.0.1
Debugging                       nmap -d [target]                nmap -d 192.168.0.1
Display Port State Reason       nmap –reason [target]           nmap –reason 192.168.0.1
Only Display Open Ports         nmap –open [target]             nmap –open 192.168.0.1
Trace Packets                   nmap –packet-trace [target]     nmap –packet-trace 192.168.0.1
Display Host Networking         nmap –iflist                    nmap –iflist
Specify a Network Interface     nmap -e [interface] [target]    nmap -e eth0 192.168.0.1

}

nmap(NMAP SCRIPTING ENGINE)
{
Goal                                command                                         example
Execute Individual Scripts          nmap –script [script.nse] [target]              nmap –script banner.nse 192.168.0.1
Execute Multiple Scripts            nmap –script [expression] [target]              nmap –script ‘http-*’ 192.168.0.1
Script Categories                   all, auth, default, discovery, external, intrusive, malware, safe, vuln         
Execute Scripts by Category         nmap –script [category] [target]                nmap –script ‘not intrusive’ 192.168.0.1
Execute Multiple Script Categories  nmap –script [category1,category2,etc]          nmap –script ‘default or safe’ 192.168.0.1
Troubleshoot Scripts                nmap –script [script] –script-trace [target]    nmap –script banner.nse –script-trace 192.168.0.1
Update the Script Database          nmap –script-updatedb                           nmap –script-updatedb
}





nmap{

    nmap -PT 192.168.1.1-111             # 先ping在扫描主机开放端口
    nmap -O 192.168.1.1                  # 扫描出系统内核版本
    nmap -sV 192.168.1.1-111             # 扫描端口的软件版本
    nmap -sS 192.168.1.1-111             # 半开扫描(通常不会记录日志)
    nmap -P0 192.168.1.1-111             # 不ping直接扫描
    nmap -d 192.168.1.1-111              # 详细信息
    nmap -D 192.168.1.1-111              # 无法找出真正扫描主机(隐藏IP)
    nmap -p 20-30,139,60000-             # 端口范围  表示：扫描20到30号端口，139号端口以及所有大于60000的端口
    nmap -P0 -sV -O -v 192.168.30.251    # 组合扫描(不ping、软件版本、内核版本、详细信息)

    # 不支持windows的扫描(可用于判断是否是windows)
    nmap -sF 192.168.1.1-111
    nmap -sX 192.168.1.1-111
    nmap -sN 192.168.1.1-111
    
    官方下载及文档地址：http://insecure.org/nmap/ 使用
    进行ping扫描，打印出对扫描做出响应的主机,不做进一步测试(如端口扫描或者操作系统探测)：
    nmap -sP 192.168.1.0/24 仅列出指定网络上的每台主机，不发送任何报文到目标主机：
    nmap -sL 192.168.1.0/24 探测目标主机开放的端口，可以指定一个以逗号分隔的端口列表(如-PS22，23，25，80)：
    nmap -PS 192.168.1.234 使用UDP ping探测主机：
    nmap -PU 192.168.1.0/24 使用频率最高的扫描选项：SYN扫描,又称为半开放扫描，它不打开一个完全的TCP连接，执行得很快：
    nmap -sS 192.168.1.0/24 当SYN扫描不能用时，TCP Connect()扫描就是默认的TCP扫描：
    nmap -sT 192.168.1.0/24 UDP扫描用-sU选项,UDP扫描发送空的(没有数据)UDP报头到每个目标端口: nmap -sU 192.168.1.0/24 确定目标机支持哪些IP协议 (TCP，ICMP，IGMP等): nmap -sO 192.168.1.19 探测目标主机的操作系统：
    nmap -O 192.168.1.19 nmap -A 192.168.1.19 另外，nmap官方文档中的例子：
    nmap -v scanme.nmap.org 这个选项扫描主机scanme.nmap.org中 所有的保留TCP端口。选项-v启用细节模式。
    nmap -sS -O scanme.nmap.org/24 进行秘密SYN扫描，对象为主机Saznme所在的“C类”网段 的255台主机。同时尝试确定每台工作主机的操作系统类型。因为进行SYN扫描 和操作系统检测，这个扫描需要有根权限。
    nmap -sV -p 22，53，110，143，4564 198.116.0-255.1-127 进行主机列举和TCP扫描，对象为B类188.116网段中255个8位子网。这 个测试用于确定系统是否运行了sshd、DNS、imapd或4564端口。如果这些端口 打开，将使用版本检测来确定哪种应用在运行。
    nmap -v -iR 100000 -P0 -p 80 随机选择100000台主机扫描是否运行Web服务器(80端口)。由起始阶段 发送探测报文来确定主机是否工作非常浪费时间，而且只需探测主机的一个端口，因 此使用-P0禁止对主机列表。
    nmap -P0 -p80 -oX logs/pb-port80scan.xml -oG logs/pb-port80scan.gnmap 216.163.128.20/20 扫描4096个IP地址，查找Web服务器(不ping)，将结果以Grep和XML格式保存。
    host -l company.com | cut -d -f 4 | nmap -v -iL - 进行DNS区域传输，以发现company.com中的主机，然后将IP地址提供给 Nmap。上述命令用于GNU/Linux -- 其它系统进行区域传输时有不同的命令。
    其他选项：
    -p (只扫描指定的端口) 单个端口和用连字符表示的端口范 围(如 1-1023)都可以。当既扫描TCP端口又扫描UDP端口时，可以通过在端口号前加上T: 或者U:指定协议。 协议限定符一直有效直到指定另一个。 例如，参数 -p U:53，111，137，T:21-25，80，139，8080 将扫描UDP 端口53，111，和137，同时扫描列出的TCP端口。
    -F (快速 (有限的端口) 扫描)

    
nmap -v scanme.nmap.org
这个选项扫描主机scanme.nmap.org中 所有的保留TCP端口。选项-v启用细节模式。

nmap -sS -O scanme.nmap.org/24
进行秘密SYN扫描，对象为主机Saznme所在的“C类”网段 的255台主机。同时尝试确定每台工作主机的操作系统类型。因为进行SYN扫描 和操作系统检测，这个扫描需要有根权限。

nmap -sV -p 22，53，110，143，4564 198.116.0-255.1-127
进行主机列举和TCP扫描，对象为B类188.116网段中255个8位子网。这 个测试用于确定系统是否运行了sshd、DNS、imapd或4564端口。如果这些端口 打开，将使用版本检测来确定哪种应用在运行。

nmap -v -iR 100000 -P0 -p 80
随机选择100000台主机扫描是否运行Web服务器(80端口)。由起始阶段 发送探测报文来确定主机是否工作非常浪费时间，而且只需探测主机的一个端口，因 此使用-P0禁止对主机列表。

nmap -P0 -p80 -oX logs/pb-port80scan.xml -oG logs/pb-port80scan.gnmap 216.163.128.20/20
扫描4096个IP地址，查找Web服务器(不ping)，将结果以Grep和XML格式保存。

host -l company.com | cut -d -f 4 | nmap -v -iL -
进行DNS区域传输，以发现company.com中的主机，然后将IP地址提供给 Nmap。上述命令用于GNU/Linux -- 其它系统进行区域传输时有不同的命令。  
    
}
