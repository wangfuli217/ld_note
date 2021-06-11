Forward stdin/stdout to a file or network connection
netcat -s 127.0.0.1 -p 1234 -tL /bin/bash -l

$ nc -l 1234         # 服务器端
$ nc 127.0.0.1 1234  # 客户端

$ nc -l 1234 > filename.out                 # 服务器端
$ nc host.example.com 1234 < filename.in    # 客户端

$ echo -n "GET / HTTP/1.0\r\n\r\n" | nc host.example.com 80
$ # nc [-C] localhost 25 << EOF
  #          HELO host.example.com
  #          MAIL FROM: <user@host.example.com>
  #          RCPT TO: <user2@host.example.com>
  #          DATA
  #          Body of email.
  #          .
  #          QUIT
  #          <<EOF

$ nc -z host.example.com 20-30
echo "QUIT" | nc host.example.com 20-30

$ nc -p 31337 -w 5 host.example.com 42
$ nc -u host.example.com 53
$ nc -s 10.1.2.3 host.example.com 42
$ nc -lU /var/tmp/dsocket
$ nc -x10.2.3.4:8080 -Xconnect host.example.com 42


在网络工具中有“瑞士军刀”美誉的NetCat（以下简称nc），在我们用了N年了至今仍是爱不释手。因为它短小精悍
（这个用在它身上很适合，现在有人已经将其修改成大约10K左右，而且功能不减少）。
参数格式
连接到某处：

nc [-options] hostname port[s] [ports] …
监听端口等待连接：
nc -l -p port [-options] [hostname] [port]
主要参数：
options:
-d              无命令行界面,使用后台模式
-e prog         程序重定向 [危险!!]
-g gateway       源路由跳跃点, 不超过8
-G num          源路由指示器: 4, 8, 12, ...
-h              获取帮助信息
-i secs           延时设置,端口扫描时使用
-l               监听入站信息
-L              监听知道NetCat被结束(可断开重连)
-n              以数字形式表示的IP地址
-o file           使进制记录
-p port          打开本地端口
-r               随机本地和远程的端口
-s addr          本地源地址
-t               以TELNET的形式应答入站请求
-u              UDP 模式
-v               显示详细信息 [使用=vv获取更详细的信息]
-w secs          连接超时设置
-z               I/O 模式 [扫描时使用]

netcat(在服务器-客户端架构上使用)
{
1. 在服务器-客户端架构上使用 Netcat
netcat 工具可运行于服务器模式，侦听指定端口
$ nc -l 2389
然后你可以使用客户端模式来连接到 2389 端口：
$ nc localhost 2389
现在如果你输入一些文本，它将被发送到服务器端：
$ nc localhost 2389
HI, oschina
在服务器的终端窗口将会显示下面内容：
$ nc -l 2389
HI, oschina

}

netcat(使用 Netcat 来传输文件)
{
netcat 工具还可用来传输文件，在客户端，假设我们有一个 testfile 文件：
$ cat testfile
hello oschina

而在服务器端有一个空文件名为 test
然后我们使用如下命令来启用服务器端：
$ nc -l 2389 > test

紧接着运行客户端：
cat testfile | nc localhost 2389

然后你停止服务器端，你可以查看 test 内容就是刚才客户端传过来的 testfile 文件的内容：
$ cat test
hello oschina
}

netcat(Netcat 支持超时控制)
{
多数情况我们不希望连接一直保持，那么我们可以使用 -w 参数来指定连接的空闲超时时间，该参数紧接一个数值，代表秒数，如果连接超过指定时间则连接会被终止。

服务器:
nc -l 2389

客户端:
$ nc -w 10 localhost 2389

该连接将在 10 秒后中断。
注意: 不要在服务器端同时使用 -w 和 -l 参数，因为 -w 参数将在服务器端无效果。
}

netcat(Netcat 支持 IPv6)
{
netcat 的 -4 和 -6 参数用来指定 IP 地址类型，分别是 IPv4 和 IPv6：

服务器端：
$ nc -4 -l 2389

客户端：
$ nc -4 localhost 2389

然后我们可以使用 netstat 命令来查看网络的情况：
$ netstat | grep 2389
tcp        0      0 localhost:2389          localhost:50851         ESTABLISHED
tcp        0      0 localhost:50851         localhost:2389          ESTABLISHED


接下来我们看看IPv6 的情况：
服务器端：
$ nc -6 -l 2389

客户端：
$ nc -6 localhost 2389

再次运行 netstat 命令：

$ netstat | grep 2389
tcp6       0      0 localhost:2389          localhost:33234         ESTABLISHED
tcp6       0      0 localhost:33234         localhost:2389          ESTABLISHED

}

netcat(在 Netcat 中禁止从标准输入中读取数据)
{
该功能使用 -d 参数，请看下面例子：

服务器端：
$ nc -l 2389

客户端：
$ nc -d localhost 2389
Hi

你输入的 Hi 文本并不会送到服务器端。
}

netcat(强制 Netcat 服务器端保持启动状态)
{
如果连接到服务器的客户端断开连接，那么服务器端也会跟着退出。

服务器端：
$ nc -l 2389

客户端：
$ nc localhost 2389
^C

服务器端：
$ nc -l 2389
$

上述例子中，但客户端断开时服务器端也立即退出。
我们可以通过 -k 参数来控制让服务器不会因为客户端的断开连接而退出。

服务器端：
$ nc -k -l 2389

客户端：
$ nc localhost 2389
^C

服务器端：
$ nc -k -l 2389
}

netcat(配置 Netcat 客户端不会因为 EOF 而退出)
{
netcat 默认是使用 TCP 协议，但也支持 UDP，可使用 -u 参数来启用 UDP 协议通讯。

服务器端：
$ nc -4 -u -l 2389

客户端：
$ nc -4 -u localhost 2389

这样客户端和服务器端都使用了 UDP 协议，可通过 netstat 命令来查看：

$ netstat | grep 2389
udp        0      0 localhost:42634         localhost:2389          ESTABLISHED
}

netcat(使用NetCat或BASH创建反向Shell来执行远程执行Root命令)
{
除了能够创建任意的连接，Netcat还能够监听传入的连接。这里我们利用nc的这个功能再配合tar来快速有效的在服务器之间
拷贝文件。在服务器端，运行：
$nc –l 9090 | tar –xzf –

在客户端运行：
$tar –czf dir/ | nc server 9090


我们可以使用Netcat把任何应用通过网络暴露出来，这里我们通过8080端口将shell暴露出来：
$ mkfifo backpipe
$ nc –l 8080 0<backpipe | /bin/bash > backpipe

现在我们可以通过任意一台客户机来访问服务器了：Linode
$ nc example.com 8080
uname –a
Linux li228-162 2.6.39.1-linode34 ##1 SMP Tue Jun 21 10:29:24 EDT 2011 i686 GNU/Linux

}
