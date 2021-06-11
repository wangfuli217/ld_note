
netconsole(利用netconsole将linux的内核printk消息发送到远程主机的udp端口)
{
modprobe netconsole netconsole=[srcport]@[srcip]/[srcdev],[dstport]@dstip/[dstmac]
   srcport: udp 源端口 (缺省为6665)
   srcip:    源ip地址 (缺省为接口地址)
   srcdev:  网络接口
   dstport: udp 目标端口 (缺省为6666)
   dstip:    目标ip地址
   dstmac: 目标主机接口的 MAC 地址
#modprobe netconsole netconsole=@/,514@192.168.107.1/00:0D:60:2C:05:B2

上面这条命令会将本机的 kernel printk msg 发送到主机 192.168.107.1 的 udp 端口 514 (syslogd 缺省监听的端口)，
发送给 mac 地址为00:0D:60:2C:05:B2的接口。
如果那台主机的 syslogd 配置成为接收远程的 syslog 消息，来自 netconsole 的消息就可以记录在那台主机的系统日志里。
在没有syslogd在运行的主机上可以用命令接收来自远程主机的消息:

# netcat -u -l -p


1. /usr/src/linux/Documentation/networking/netconsole.txt
2. man 8 syslogd
3. man 1 netcat
}