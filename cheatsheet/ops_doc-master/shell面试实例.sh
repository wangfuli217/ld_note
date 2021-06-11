shell(28个企业运维岗经典面试题)
{
1. Linux如何挂载windows下的共享目录？
mount.cifs //IP地址/server /mnt/server -o user=administrator,password=123456
linux 下的server需要自己手动建一个 后面的user与pass 是windows主机的账号和密码 注意空格和逗号.

2. 如何查看http的并发请求数与其TCP连接状态？
netstat -n | awk '/^tcp/ {++b[$NF]}  END {for(a in b) print a,b[a]}'
还有ulimit -n 查看linux系统打开最大的文件描述符，这里默认1024，不修改这里web服务器修改再大也没用。若要用就修改很几个办法，这里说其中一个：
修改/etc/security/limits.conf
* soft nofile 10240
* hard nofile 10240
重启后生效

3. 如何用tcpdump嗅探80端口的访问看看谁最高？
tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F '.' '{print $1"."$2"."$3"."$4"."}' | sort | uniq -c | sort -nr | head -5

4. 如何查看/var/log目录下的文件数？
ls /var/log/ -1R | grep "-" | wc -l

5. 如何查看linux系统每个ip的连接数？
netstat -n | awk '/^tcp/ {print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -rn

6.shell下生成32位随机密码
cat /dev/urandom | head -1 | md5sum | head -c 32 >> /pass

7. 统计出apache的access.log中访问量最多的5个ip
cat access.log | awk '{print $1}' | sort | uniq -c | sort -n -r | head -5

8. 如何查看二进制文件的内容？
我们一般通过hexdump命令来查看二进制文件的内容。 hexdump -C XXX(文件名) -C是参数 不同的参数有不同的意义 -C
是比较规范的 十六进制和ASCII码显示
-c 是单字节字符显示
-b 单字节八进制显示
-o 是双字节八进制显示
-d 是双字节十进制显示
-x 是双字节十六进制显示

9. ps aux 中的VSZ代表什么意思，RSS代表什么意思？
VSZ:虚拟内存集,进程占用的虚拟内存空间
RSS:物理内存集,进程战用实际物理内存空间

[root@foundation66 Desktop]# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 192216  6004 ?        Ss   09:19   0:07 /usr/lib/systemd/
root         2  0.0  0.0      0     0 ?        S    09:19   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S    09:19   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   09:19   0:00 [kworker/0:0H]
root         7  0.0  0.0      0     0 ?        S    09:19   0:00 [migration/0]

10. 如何检测并修复/dev/hda5？
fsck用来检查和维护不一致的文件系统。若系统掉电或磁盘发生问题，可利用fsck命令对文件系统进行检查

11. 介绍下Linux系统的开机启动顺序
加载BIOS–>读取MBR–>Boot Loader–>加载内核–>用户层init一句inittab文件来设定系统运行的等级
(一般3或者5，3是多用户命令行，5是界面)
–>init进程执行rc.syninit
–>启动内核模块
–>执行不同级别运行的脚本程序
–>执行/etc/rc.d/rc.local(本地运行服务)
–>执行/bin/login,就可以登录了。

12. 符号链接与硬链接的区别
我们可以把符号链接，也就是软连接 当做是 windows系统里的 快捷方式。 
硬链接 就好像是又复制了一份，
举例说明： ln 3.txt 4.txt 这是硬链接，相当于复制，不可以跨分区，但修改3,4会跟着变，若删除3,4不受任何影响。 
ln -s 3.txt 4.txt 这是软连接，相当于快捷方式。修改4,3也会跟着变，若删除3,4就坏掉了。不可以用了。


13. 保存当前磁盘分区的分区表
dd 命令是以个强大的命令，在复制的同时进行转换
dd if=/dev/sda of=./mbr.txt bs=1 count=512

14. 如何在文本里面进行复制、粘贴，删除行，删除全部，按行查找和按字母查找？
*注意目前所处的状态

以下操作全部在命令行状态操作，不要在编辑状态操作。
 在文本里 移动到想要复制的行 按yy 想复制到哪就移动到哪，然后按P 就黏贴了 
 删除行 移动到改行 按dd 
 删除全部 dG 这里注意G一定要大写 
 按行查找 :90 这样就是找到第90行 按字母查找 
 /path 这样就是 找到path这个单词所在的位置，文本里可能存在多个,多次查找会显示在不同的位置。

15. 手动安装grub
grub-install /dev/sda

16. 修改内核参数
vi /etc/sysctl.conf 这里修改参数 
sysctl -p 刷新后可用

17. 在1-39内取随机数
expr $[RANDOM%39] +1
RANDOM随机数
%39取余数范围0-38

18. 限制apache每秒新建连接数为1，峰值为3
每秒新建连接数 一般都是由防火墙来做，apache本身好像无法设置每秒新建连接数，只能设置最大连接：
iptables -A INPUT -d 172.16.100.1 -p tcp –dport 80 -m limit –limit 1/second -j ACCEPT

19. FTP的主动模式和被动模式
FTP协议有两种工作方式：PORT方式和PASV方式，中文意思为主动式和被动式。

PORT（主动）方式的连接过程是：客户端向服务器的FTP端口（默认是21）发送连接请求，服务器接受连接，建立一条命令链路。
当需要传送数据时，客户端在命令链路上用PORT命令告诉服务器："我打开了XX端口，你过来连接我"。于是服务器从20端口向
客户端的 XX端口发送连接请求，建立一条数据链路来传送数据。

PASV（被动）方式的连接过程是：客户端向服务器的FTP端口（默认是21）发送连接请求，服务器接受连接，建立一条命令链路。
当需要传送数据时，服务器在命令链路上用PASV 命令告诉客户端："我打开了XX端口，你过来连接我"。于是客户端向服务器的
XX端口发送连接请求，建立一条数据链路来传送数据。

从上面可以看出，两种方式的命令链路连接方法是一样的，而数据链路的建立方法就完 全不同。

20. 显示/etc/inittab中以#开头，且后面跟了一个或者多个空白字符，而后又跟了任意非空白字符的行
grep "^#\{1,\}[^]" /etc/inittab

21. 显示/etc/inittab中包含了:一个数字:(即两个冒号中间一个数字)的行
grep "\:[0-9]\{1\}:" /etc/inittab

22. 怎么把脚本添加到系统服务里，即用service来调用？

在脚本里加入
#!/bin/bash
# chkconfig: 345 85 15
# description: httpd
然后保存
chkconfig httpd –add 创建系统服务
现在就可以使用service 来 start or restart

23. 写一个脚本，实现批量添加20个用户，用户名为user01-20，密码为user后面跟5个随机字符

#!/bin/bash
#description: useradd
for i in 'seq -f "%02g" 1 20';do
useradd user$i
echo "user$i-`echo $RANDOM|md5sum|cut -c 1-5`"|passwd –stdinuser$i >/dev/null 2>&1
done

24. 写一个脚本，实现判断192.168.1.0/24网络里，当前在线的IP有哪些，能ping通则认为在线

#!/bin/bash
for ip in $(seq 1 255)
do
{
    ping -c 1 192.168.1.$ip > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo 192.168.1.$ip UP
    else
        echo 192.168.1.$ip DOWN
    fi
}&
done
wait


25. 如何让history命令显示具体时间？
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S"
export HISTTIMEFORMAT
重新开机后会还原，可以写/etc/profile

}

shell(IT运维常见面试题大集合–运维必看)
{
1.查找文件后缀是log的三天前的文件删除和三天内没修改过的文件
find  / -name ".log" -mtime +3 -exec rm  -fr {} ;   
find /log ! -mtime -3

用find命令查找指定的文件，并且执行rm操作
find ./ -name "*****" -exec rm -f {} \;

2.写一个脚本将目录下大于100kb的文件移动到/tmp下
find / -size +100k -exec mv {} /tmp ;

3.用tcpdump截取ip 192.168.23.1访问主机 ip 192.168.23.2 的80端口的包
tcpdump host 192.168.23.1 and 192.168.23.2 and dst port 80

4.用iptables将192.168.0.100的80端口映射到59.15.17.231的8080端口
iptables -t nat -A PREROUTINT -p tcp -d 192.168.0.100 --dport 80 -j DNAT --to-destination 59.15.17.231:8080

5.本机的80端口转发到8080
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080

6.禁止一个用户登录，但可以使用ftp
修改etc/passwd 最后一个字段 改成/bin/nologin

7.用什么命令查询指定IP地址的服务器端口
nmap 127.0.0.1

8.查看3306端口被谁占用
lsof -i:3306
}

shell(Linux的管理员密码如何破解？)
{
linux root密码找回方法一
第1步：在系统进入单用户状态，直接用passwd root去更改。
第2步：用安装光盘引导系统，进行linux rescue状态，将原来/分区挂接上来,作法如下：
    cd /mnt mkdir hd mount -t auto /dev/hdaX(原来/分区所在的分区号) hd cd hd chroot ./ passwd root
第3步：将本机的硬盘拿下来，挂到其他的linux系统上，采用的办法与第二种相同.


linux root密码找回方法二
第1步：用lilo引导系统时：在出现 lilo: 提示时键入 linux single
画面显示lilo: linux single
第2步：回车可直接进入linux命令行
第3步：使用以下命令“vi /etc/shadow”将第一行，即以root开头的一行中root:后和下一个:前的内容删除，第一行将类似于root::......保存
vim /etc/shadow
第4步：reboot重启，root密码为空。


linux root密码找回方法三
第1步：用grub引导系统时：在出现grub画面时，用上下键选中你平时启动linux的那一项(别选dos哟)，然后按e键
第2步：再次用上下键选中你平时启动linux的那一项(类似于kernel /boot/vmlinuz-2.4.18-14 ro root=LABEL=/)，然后按e键
第3步：修改你现在见到的命令行，加入single，结果如下：
    kernel /boot/vmlinuz-2.4.18-14 single ro root=LABEL=/ single
第4步：回车返回，然后按b键启动，即可直接进入linux命令行.
第5步：使用以下命令“vi /etc/shadow”将第一行，即以root开头的一行中root:后和下一个:前的内容删除，第一行将类似于root::......保存
vim /etc/shadow
第6步：reboot重启，root密码为空。
}

shell(请描述Linux系统优化的几个步骤)
{
1、登录系统:不使用root登录，通过sudo授权管理，使用普通用户登录。
2、禁止SSH远程：更改默认的远程连接SSH服务及禁止root远程连接。
3、时间同步：定时自动更新服务器时间。
4、配置yum更新源，从国内更新下载安装rpm包。
5、关闭selinux及iptables（iptables工作场景如有wan ip，一般要打开，高并发除外）
6、调整文件描述符数量，进程及文件的打开都会消耗文件描述符。
7、定时自动清理/var/spool/clientmquene/目录垃圾文件，防止节点被占满（c6.4默认没有sendmail，因此可以不配。）
8、精简开机启动服务（crond、sshd、network、rsyslog）
9、Linux内核参数优化/etc/sysctl.conf，执行sysct -p生效。
10、更改字符集，支持中文，但是还是建议使用英文，防止乱码问题出现。
11、锁定关键系统文件（chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab 处理以上内容后，把chatter改名，就更安全了。）
12、清空/etc/issue，去除系统及内核版本登陆前的屏幕显示。
}

shell(在浏览器输入www.didichuxing.com域名，其DNS查询过程是怎样的？请简述DNS查找过程){
1、在浏览器中输入www.didichuxing.com域名，操作系统会先检查自己本地的hosts文件是否有这个网址映射关系，
   如果有，就先调用这个IP地址映射，完成域名解析。
2、如果hosts里没有这个域名的映射，则查找本地DNS解析器缓存，是否有这个网址映射关系，如果有，直接返回，
   完成域名解析。
3、如果hosts与本地DNS解析器缓存都没有相应的网址映射关系，首先会找TCP/IP参数中设置的首选DNS服务器，
   在此我们叫它本地DNS服务器，此服务器收到查询时，如果要查询的域名，包含在本地配置区域资源中，
   则返回解析结果给客户机，完成域名解析，此解析具有权威性。
4、如果要查询的域名，不由本地DNS服务器区域解析，但该服务器已缓存了此网址映射关系，则调用这个IP地址映射，
   完成域名解析，此解析不具有权威性。
5、如果本地DNS服务器本地区域文件与缓存解析都失效，则根据本地DNS服务器的设置（是否设置转发器）进行查询，
   如果未用转发模式，本地DNS就把请求发至13台根DNS，根DNS服务器收到请求后会判断这个域名(.com)是谁来授权管理，
   并会返回一个负责该顶级域名服务器的一个IP。本地DNS服务器收到IP信息后，将会联系负责.com域的这台服务器。
   这台负责.com域的服务器收到请求后，如果自己无法解析，它就会找一个管理.com域的下一级DNS服务器地址(qq.com)
   给本地DNS服务器。当本地DNS服务器收到这个地址后，就会找qq.com域服务器，重复上面的动作，进行查询，
   直至找到www.qq.com主机。
6、如果用的是转发模式，此DNS服务器就会把请求转发至上一级DNS服务器，由上一级服务器进行解析，上一级服务器
   如果不能解析，或找根DNS或把转请求转至上上级，以此循环。不管是本地DNS服务器用是是转发，还是根提示，
   最后都是把结果返回给本地DNS服务器，由此DNS服务器再返回给客户机。

}

shell(权威DNS和递归DNS含义，智能DNS的实现原理){
权威DNS是经上一级授权对域名进行解析的DNS服务器，同时它可以把解析授权转授给其他服务器；
递归DNS负责接受用户对任何域名的查询，并返回结果给用户，它可以缓存结果避免用户再向上查询；
智能DNS就是将对用户发起的查询进行判断出是哪个运营商的用户查询，然后将请求转发给相应的运营商IP处理，减少跨运营访问的时间，提高访问速度。
}


shell(当你在浏览器输入一个网址，如http://www.didichuxing.com，按回车之后发生了什么？请从技术的角度描述，如浏览器、网络（UDP、TCP、HTTP等），以及服务器等各种参与对象上由此引发的一系列活动，请尽可能的涉及到所有的关键技术点。){
参考答案：
1) DNS域名解析：浏览器缓存、系统缓存、路由器、ISP的DNS服务器、根域名服务器。把域名转化成IP地址。 
2)与IP地址对应的服务器建立TCP连接，经历三次握手：SYN，ACK、SYN，ACK 
3)以get，post方式发送HTTP请求，get方式发送主机，用户代理，connection属性，cookie等 
4）获得服务器的响应，显示页面
}

shell(请阐述traceroute的工作原理){
trcertroute建立一个UDP数据包，不断修改TTL值并发送出去，如果收到"超时错"，表示刚刚到达的是路由器，
而如果收到的是"端口不可达"错误，表示刚刚到达的就是目的主机。这样路由跟踪完成，程序结束。
}