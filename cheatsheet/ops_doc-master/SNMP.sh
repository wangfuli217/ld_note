Linux服务器SNMP常用OID # http://www.haiyun.me/archives/linux-snmp-oid.html

操作系统：Ubuntu Server 11.10

1、安装配置snmp
apt-get install snmp snmpd #安装，根据提示输入y即可
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.confbak #备份原有配置文件


nano /etc/snmp/snmpd.conf #新建配置文件，添加以下内容
agentAddress  udp:0.0.0.0:161
# sec.name source community
#com2sec paranoid default public
com2sec readonly default public
#com2sec readwrite default private


设置 syslocation 和 syscontact参数：
syslocation 17smt.com
syscontact Leejd@GridOK.com

/etc/init.d/snmpd start #启动 
/etc/init.d/snmpd stop #停止 
/etc/init.d/snmpd start #重启 
chkconfig snmpd on #设置开机启动


/etc/default/snmpd
# snmpd options (use syslog, close stdin/out/err).
SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -I -smux -p /var/run/snmpd.pid'


2、测试snmp
netstat -nlup | grep ":161" #检查snmp服务是否已在运行，出现类似下面的内容，说明snmp运行正常 udp 0 0 0.0.0.0:161 0.0.0.0:* 4999/snmpd 
lsof -i:161 #检查snmp端口是否监听，出现下面的内容，说明snmp端口监听正确 snmpd 4999 snmp 7u IPv4 17222 0t0 UDP *:snmp 
snmpwalk -v 2c -c public localhost #有数据输出说明配置正确 snmpwalk -v 2c -c public 192.168.21.168 #有数据输出说明配置正确

root@wangshaojuan-106:/etc/snmp# netstat -nlup | grep ":162" 
udp 0 0 0.0.0.0:162 0.0.0.0:* 24253/snmptrapd 
root@wangshaojuan-106:/etc/snmp#

apt-get install snmp-mibs-downloader 
=======================ubuntu needs to install this mibs================================


snmpwalk命令则是测试系统各种信息最有效的方法,常用的方法如下:
1、snmpwalk -c public -v 1 -m ALL 127.0.0.1 .1.3.6.1.2.1.25.1 得到取得windows端的系统进程用户数等
2、snmpwalk -c public -v 1 -m ALL 127.0.0.1 .1.3.6.1.2.1.25.2.2 取得系统总内存
3、snmpwalk -c public -v 1 -m ALL 127.0.0.1 hrSystemNumUsers 取得系统用户数
4、snmpwalk -c public -v 1 -m ALL 127.0.0.1 .1.3.6.1.2.1.4.20 取得IP信息
5、snmpwalk -v 2c -c public 127.0.0.1 system 查看系统信息
6、snmpwalk -v 1 127.0.0.1 -c public ifDescr 获取网卡信息

1、snmpwalk -v 2c -c public 127.0.0.1 .1.3.6.1.2.1.25.1 得到取得windows端的系统进程用户数等
其中-v是指版本,-c 是指密钥。
snmpwalk功能很多,可以获取系统各种信息,只要更改后面的信息类型即可。如果不知道什么类型,也可以不指定,
这样所有系统信息都获取到:
nmpwalk -v 2c -c public localhost


snmptrapd -d -f -Lo
snmptrap -v 2c -c public 0.0.0.0:162 "" .1.3.6.1.4.1.2021.251.1 sysLocation.0 s "this is test"

使用snmptrap发送SNMP trap
使用net-snmp提供的 snmptrap 等工具可以实现trap的发送和接收，下面是具体做法。
    创建 snmptrapd.conf 文件 snmptrapd.conf文件的内容如下: authCommunity log,execute,net public 在这里，为了简单，我们没有指定收到trap后对应的处理程序。
    启动 snmptrapd（指定config文件的位置） 在前台运行，将log信息打印到stdout： 
    $ sudo snmptrapd -C -c ./snmptrapd.conf -f -Lo
也可以在后台运行，并将log信息打印到文件中： 
    $ sudo snmptrapd -C -c ./snmptrapd.conf -Lf /tmp/trapd.log tail -f /tmp/trapd.log
    通过snmptrap工具发送一个trap（目标地址是“127.0.0.1:162”） 
    snmptrap的命令行格式如下： snmptrap -v [2c|3] [COMMON OPTIONS] uptime trap-oid [OID TYPE VALUE] 
    $ snmptrap -v 2c -c public 127.0.0.1:162 "" .1.3.6.1.4.1.2021.251.1 sysLocation.0 s "test" 
    $ snmptrap -v 2c -c public 127.0.0.1:162 "12345678" .1.3.6.1.4.1.2021.251.1 sysLocation.0 s "test"
    查看snmptrapd的log信息，可以看到我们发送的trap：
    
=========mib-snmp-downloader===================================== <================not for 
cd /tmp git clone git://git.debian.org/collab-maint/snmp-mibs-downloader.git 
cd snmp-mibs-downloader dpkg-buildpackage -us -uc debi
/etc/snmp/snmp.conf and remove the line "mibs :".

