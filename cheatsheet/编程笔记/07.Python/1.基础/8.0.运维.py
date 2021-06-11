1. psutil是一个跨平台库
https://github.com/giampaolo/psutil/
	能够轻松实现获取系统运行的进程和系统利用率(CPU，内存，磁盘，网络等)信息，主要应用于系统监控，分析和
限制系统资源及进程的管理，它实现了同等命令行工具提供的功能，如ps,top,lsof,netstat,ifconfig,who,df,kill,
free,nice等.支持32位，和64位的Linux，Windows,OS X，FreeBSD等操作系统。
pip install psutil
# http://www.cnblogs.com/xiao1/p/6164204.html

2. IPy Python第三方模块IPy，可完成高效的IP规划工作
pip install IPy

3. dnspython 是Python实现的一个DNS工具包，支持几乎所有的记录类型，可以用于查询，传输并动态更新ZONE信息，
   同时支持TSIG（事务签名）验证消息和EDNS0（扩展DNS）。可以替代nslookup，dig等工具。
pip install dnspython
http://www.cnblogs.com/xiao1/p/6165614.html

4. difflib为python的标准库模块，无需安装。作用时对比文本之间的差异。并且支持输出可读性比较强的HTML文档，
   与LInux下的diff 命令相似。在版本控制方面非常有用。
   
5. filecmp可以实现文件，目录，遍历子目录的差异对比功能。
　自带filecmp模块，无需安装。

6. pycurl是curl的一个python版本。
   # https://github.com/pycurl/pycurl

python编写windows tomcat守护进程 # http://www.361way.com/python-tomcat-deamon/5235.html


7. glances
git clone https://github.com/nicolargo/glances.git
# sudo apt-get update
# sudo apt-get install python-pip build-essential python-dev
# sudo pip install glances

glances的参数
 glances 是一个命令行工具包括如下命令选项：
 -b：显示网络连接速度 Byte/ 秒
 -B @IP|host ：绑定服务器端 IP 地址或者主机名称
 -c @IP|host：连接 glances 服务器端
 -C file：设置配置文件默认是 /etc/glances/glances.conf
 -d：关闭磁盘 I/O 模块
 -e：显示传感器温度
 -f file：设置输出文件（格式是 HTML 或者 CSV）
 -m：关闭挂载的磁盘模块
 -n：关闭网络模块
 -p PORT：设置运行端口默认是 61209
 -P password：设置客户端 / 服务器密码
 -s：设置 glances 运行模式为服务器
 -t sec：设置屏幕刷新的时间间隔，单位为秒，默认值为 2 秒，数值许可范围：1~32767
 -h : 显示帮助信息
 -v : 显示版本信息
 
 注：如果要输出温度，需要lm_sensors的支持，安装方法为：
     # yum install lm_sensors
     # pip-python install pysensors
 三、glances的高级用法

1、输出html格式，配置web server展出
    # pip-python install jinja2
    # glances -o HTML -f /var/www/html

注：输出html格式时，需要jinja2的支持，需要先安装依赖。默认输出的文件名是glances.html，可以通过http://IP/glances.html访问。

2、输出为csv格式，并用excel或libreoffice查看
    #glances -o CSV -f /home/cjh/glances.csv
    #libreoffice --calc %U /tmp/glances.csv

3、c/s模式及API编程

服务端按下面的命令启动
    # glances -s -B 192.168.10.16
     glances server is running on 192.168.10.16:61209

注：如果使用防火墙的情况下，需要在iptables上的放行。

客户端查看
     # glances – c 192.168.10.16

如果客户端在终端下可能有串行显示的问题。除些外，我们也可以利用glances提供的XML-RPC API编程出，示例出下：
    $ vim test.py
    #!/usr/bin/python
    import xmlrpclib
    s = xmlrpclib.ServerProxy('http://192.168.10.16:61209')
    print s.getSystem()

执行上面的python脚本的结果为：

四、颜色告警及设置
绿色表示性能良好，无需做任何额外工作；（此时 CPU 使用率、磁盘空间使用率和内存使用率低于 50%，系统负载低于 0.7）。
蓝色表示系统性能有一些小问题，用户应当开始关注系统性能；（此时 CPU 使用率、磁盘空间使用率和内存使用率在 50%-70% 之间，系统负载在 0.7-1 之间）。
淡红表示性能报警，应当采取措施比如备份数据；（此时 CPU 使用率、磁盘空间使用率和内存使用率在 70%-90% 之间，，系统负载在 1-5 之间）。
深红表示性能问题严重，可能宕机；（此时 CPU 使用率、磁盘空间使用率和内存使用率在大于 90%，系统负载大于 5）。
具体告警阀值可以通过修改文件/etc/glances/glances.conf进行修改。

8. psdash

9. python shell
https://github.com/amoffat/sh