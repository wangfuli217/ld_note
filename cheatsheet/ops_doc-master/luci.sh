http://wiki.openwrt.org/zh-cn/doc/uci

你需要用/etc/init.d/crond start起动它或用/etc/init.d/crond enable激活它。 大部分后台程序都可以
disable(禁用),stop(停止)和restart（重起）。

luci(共同原则){
OpenWrt的所有配置文件皆位于/etc/config/目录下。每个文件大致与它所配置的那部分系统相关。可用文本编辑器、
"uci" 命令行实用程序或各种编程API(比如 Shell, Lua and C)来编辑/修改这些配置文件。

}

luci(配置文件){
文件位置 	描述
基本配置
/etc/config/dhcp 	dnsmasq和DHCP的配置
/etc/config/dropbear 	SSH服务端选项
/etc/config/firewall 	中央防火墙配置
/etc/config/network 	交换，接口和路由配置
/etc/config/system 	杂项与系统配置
/etc/config/timeserver 	rdate的时间服务器列表
/etc/config/wireless 	无线设置和无线网络的定义
IPv6
/etc/config/ahcpd 	Ad-Hoc配置协议(AHCP) 服务端配置以及转发器配置
/etc/config/aiccu 	AICCU 客户端配置
/etc/config/dhcp6c 	WIDE-DHCPv6 客户端配置
/etc/config/dhcp6s 	WIDE-DHCPv6 服务端配置
/etc/config/gw6c 	GW6c 客户端配置
/etc/config/radvd 	路由通告 (radvd) 配置
其他
/etc/config/etherwake 	以太网唤醒: etherwake
/etc/config/fstab 	挂载点及swap
/etc/config/hd-idle 	另一个可选的硬盘空闲休眠进程(需要路由器支持usb硬盘)
/etc/config/httpd 	网页服务器配置选项(Busybox 自带httpd, 已被舍弃)
/etc/config/luci 	基础 LuCI 配置
/etc/config/luci_statistics 	包统计配置
/etc/config/mini_snmpd 	mini_snmpd 配置
/etc/config/mountd 	OpenWrt 自动挂载进程(类似autofs)
/etc/config/multiwan 	简单多WAN出口配置
/etc/config/ntpclient 	ntp客户端配置，用以获取正确时间
/etc/config/pure-ftpd 	Pure-FTPd 服务端配置
/etc/config/qos 	QoS配置(流量限制与整形)
/etc/config/samba 	samba配置(Microsoft文件共享)
/etc/config/snmpd 	SNMPd(snmp服务进程) 配置
/etc/config/sshtunnel 	sshtunnel配置
/etc/config/stund 	STUN 服务端配置
/etc/config/transmission 	BitTorrent配置
/etc/config/uhttpd 	Web服务器配置(uHTTPd)
/etc/config/upnpd 	miniupnpd UPnP服务器配置
/etc/config/ushare 	uShare UPnP 服务器配置
/etc/config/vblade 	vblade 用户空间AOE(ATA over Ethernet)配置
/etc/config/vnstat 	vnstat 下载器配置
/etc/config/wifitoogle 	使用按钮来开关WiFi的脚本
/etc/config/wol 	Wake-on-Lan: wol
/etc/config/znc 	ZNC 配置
}

luci(文件语法){
在UCI的配置文件通常包含一个或多个配置语句，包含一个或多个用来定义实际值的选项语句的所谓的节。
下面是一个简单的配置示例文件：
package 'example' 
config 'example' 'test'
        option   'string'      'some value'
        option   'boolean'     '1'
        list     'collection'  'first item'
        list     'collection'  'second item'

1. config 'example' 'test' 语句标志着一个节的开始。这里的配置类型是example，配置名是test。配置中也允许出现
匿名节，即自定义了配置类型，而没有配置名的节。配置类型对应配置处理程序来说是十分重要的，因为配置程序需要
根据这些信息来处理这些配置项。
2. option 'string' 'some value' 和  option 'boolean' '1' 定义了一些简单值。文本选项和布尔选项在语法上并没有差异。布尔选项中可以用'0' ， 'no'， 'off'， 或者'false'来表示false值，或者也可以用'1'， 'yes'，'on'或者'true'来表示真值。
    以list关键字开头的多个行，可用于定义包含多个值的选项。所有共享一个名称的list语句，会组装形成一个值列表，列表中每个值出现的顺序，和它在配置文件中的顺序相同。如上例种中，列表的名称是'collection'，它包含了两个值，即'first item'和'second item'。

    'option'和'list'语句的缩进可以增加配置文件的可读性，但是在语法不是必须的。

下面列举的例子都是符合uci语法的正确配置：
    option example value
    option 'example' value
    option example "value"
    option "example"    'value' 
    option   'example' "value"
反之，以下配置则存在语法错误
    option 'example" "value' (引号不匹配)
    option example some value with space (值中包含空格，需要为值加引号)

还有一点是必须知道的，即UCI标识符和配置文件名称所包含的字符必须是由a-z， 0-9和_组成。 选项值则可以包含任意字符，
只要这个值是加了引号的。 

}

uci(){
用法: uci [<options>] <command> [<arguments>]

命令:
	batch
	export     [<config>]
	import     [<config>]
	changes    [<config>]
	commit     [<config>]
	add        <config> <section-type>
	add_list   <config>.<section>.<option>=<string>
	show       [<config>[.<section>[.<option>]]]
	get        <config>.<section>[.<option>]
	set        <config>.<section>[.<option>]=<value>
	delete     <config>[.<section[.<option>]]
	rename     <config>.<section>[.<option>]=<name>
	revert     <config>[.<section>[.<option>]]

参数:
	-c <path>  set the search path for config files (default: /etc/config)
	-d <str>   set the delimiter for list values in uci show
	-f <file>  use <file> as input instead of stdin
	-m         when importing, merge data into an existing package
	-n         name unnamed sections on export (default)
	-N         don't name unnamed sections
	-p <path>  add a search path for config change files
	-P <path>  add a search path for config change files and use as default
	-q         quiet mode (don't print error messages)
	-s         force strict mode (stop on parser errors, default)
	-S         disable strict mode
    -X         do not use extended syntax on 'show'
}

uci(导出整个配置){
root@OpenWrt:~# uci export uhttpd
package 'uhttpd'

config 'uhttpd' 'main'
	list 'listen_http' '0.0.0.0:80'
	list 'listen_http' '0.0.0.0:8080'
	list 'listen_https' '0.0.0.0:443'
	option 'home' '/www'
	option 'rfc1918_filter' '1'
	option 'cert' '/etc/uhttpd.crt'
	option 'key' '/etc/uhttpd.key'
	option 'cgi_prefix' '/cgi-bin'
	option 'script_timeout' '60'
	option 'network_timeout' '30'
	option 'tcp_keepalive' '1'

config 'cert' 'px5g'
	option 'days' '730'
	option 'bits' '1024'
	option 'country' 'DE'
	option 'state' 'Berlin'
	option 'location' 'Berlin'
	option 'commonname' 'OpenWrt'
}

uci(查看所有配置项的值){
root@OpenWrt:~# uci show uhttpd
uhttpd.main=uhttpd
uhttpd.main.listen_http=0.0.0.0:80 0.0.0.0:8080
uhttpd.main.listen_https=0.0.0.0:443
uhttpd.main.home=/www
uhttpd.main.rfc1918_filter=1
uhttpd.main.cert=/etc/uhttpd.crt
uhttpd.main.key=/etc/uhttpd.key
uhttpd.main.cgi_prefix=/cgi-bin
uhttpd.main.script_timeout=60
uhttpd.main.network_timeout=30
uhttpd.main.tcp_keepalive=1
uhttpd.px5g=cert
uhttpd.px5g.days=730
uhttpd.px5g.bits=1024
uhttpd.px5g.country=DE
uhttpd.px5g.state=Berlin
uhttpd.px5g.location=Berlin
uhttpd.px5g.commonname=OpenWrt

}

uci(查看特定配置项的值){
root@OpenWrt:~# uci get uhttpd.@uhttpd[0].listen_http
0.0.0.0:80 0.0.0.0:8080
}

uci(查询网络接口的状态){
root@OpenWrt:~# uci -P/var/state show network.wan
network.wan=interface
network.wan.ifname=eth0.1
network.wan.proto=dhcp
network.wan.defaultroute=0
network.wan.peerdns=0
network.wan.device=eth0.1
network.wan.ipaddr=10.11.12.13
network.wan.broadcast=255.255.255.255
network.wan.netmask=255.255.255.0
network.wan.gateway=10.11.12.1
network.wan.dnsdomain=
network.wan.dns=10.11.12.100 10.11.12.200
network.wan.up=1
network.wan.lease_gateway=10.11.12.1
network.wan.lease_server=10.11.12.25
network.wan.lease_acquired=1262482940
network.wan.lease_lifetime=5400
network.wan.lease_hostname=x-10-11-12-13
}

uci(添加防火墙规则){
这是一个添加SSH端口转发到防火墙规则的例子，和'-1'使用的一个例子。
root@OpenWrt:~# uci add firewall rule
root@OpenWrt:~# uci set firewall.@rule[-1].src=wan
root@OpenWrt:~# uci set firewall.@rule[-1].target=ACCEPT
root@OpenWrt:~# uci set firewall.@rule[-1].proto=tcp
root@OpenWrt:~# uci set firewall.@rule[-1].dest_port=22
root@OpenWrt:~# uci commit firewall
root@OpenWrt:~# /etc/init.d/firewall restart
}


luci(开发){
http://blog.sxx1314.com/openwrt/89.html
http://blog.sxx1314.com/openwrt/87.html  luci配置界面初步入门开发(1)
http://blog.sxx1314.com/openwrt/88.html  luci配置界面初步入门开发(2)
}

luci(luci页面“save&apply”的实现分析){
http://www.cnblogs.com/rohens-hbg/p/5358307.html
}

http://www.cnblogs.com/rohens-hbg/p/5363364.html
luci(openwrt设置语言的过程){
设置语言的流程
一、关联的配置文件
/etc/config/luci
查看配置文件内容如下：
root@hbg:/# cat /etc/config/luci

config core 'main'
        option mediaurlbase '/luci-static/openwrt.org'
        option resourcebase '/luci-static/resources'
        option lang 'zh_cn'     // 目前使用的语言zh_cn，中文

config extern 'flash_keep'
        option uci '/etc/config/'
        option dropbear '/etc/dropbear/'
        option openvpn '/etc/openvpn/'
        option passwd '/etc/passwd'
        option opkg '/etc/opkg.conf'
        option firewall '/etc/firewall.user'
        option uploads '/lib/uci/upload/'

config internal 'languages'    // 语言选项
        option zh_cn 'chinese' // 中文
        option en 'English'    // 英语

config internal 'sauth'
        option sessionpath '/tmp/luci-sessions'
        option sessiontime '3600'

config internal 'ccache'
        option enable '1'

config internal 'themes'
        option Bootstrap '/luci-static/bootstrap'
  
二、调用过程 

在dispatcher.lua中httpdispatch() 函数中调用了函数dispatch(),
在dispatch()函数中实现：

        local conf = require "luci.config"    // 配置文件为/etc/config/luci
        assert(conf.main,                     // 查看配置文件中是否有main段，若无，提示错误。
                "/etc/config/luci seems to be corrupt, unable to find section 'main'")

        local lang = conf.main.lang

  if lang == nil then
   lang = "zh_cn"
            luci.sys.call("uci set luci.main.lang=zh_cn; uci commit luci")   
        end   
        
        require "luci.i18n".setlanguage(lang)  // 设置语言

查找调用dispatch()的地方，可以找到：
1）cgi.lua 
2）uhttpd.lua
两个脚本都位 ./feeds/luci/modules/base/luasrc/sgi目录下,
并且都是调用这句
local x = coroutine.create(luci.dispatcher.httpdispatch)
调用cgi.lua脚本的地方为./feeds/luci/modules/base/htdocs/cgi-bin/luci
文件内容如下：
#!/usr/bin/lua
require "luci.cacheloader"
require "luci.sgi.cgi"    // 包含头文件cgi.lua
luci.dispatcher.indexcache = "/tmp/luci-indexcache"
luci.sgi.cgi.run()        // 调用cgi.lua中的run函数。

三、luci的启动-uhttpd
uhttpd是一个简单的web服务器程序，主要就是cgi的处理，openwrt是利用uhttpd作为web服务器，
实现客户端web页面配置功能。对于request处理方式，采用的是cgi，而所用的cgi程序就是luci.

四、luci的启动-luci
在web server中的cgi-bin目录下，运行 luci 文件（权限一般是 755，luci的代码如下：
　　#!/usr/bin/lua      --cgi的执行命令的路径
　　require"luci.cacheloader"    --导入cacheloader包
　　require"luci.sgi.cgi"         --导入sgi.cgi包 
　　luci.dispatcher.indexcache = "/tmp/luci-indexcache"  --cache缓存路径地址
　　luci.sgi.cgi.run()  --执行run，此方法位于*/luci/sgi/cgi.lua

五、Luci-- Web
　　a.登录
　　输入： http://x.x.x.x/ 登录LuCI.
    调用 /www/cgi-bin/luci.
　　b. 进入主菜单‘status’
　　输入： http://x.x.x.x/cgi-bin/luci/admin/status/即可访问status页面。
    Luci则会调用 /luci/admin/目录下的status.lua脚本：
　　module("luci.controller.admin.status", package.seeall)
　　/usr/lib/lua/luci/controller/admin/status.lua->index()

六、以status模块为例进行说明
　　模块入口文件status.lua在目录lua\luci\controller\admin下在index()函数中，使用entry函数来完成每个模块函数的注册：
entry(path, target, title=nil, order=nil)
entry()函数
　　第一个参数是定义菜单的显示（Virtual path）。
　　第二个参数定义相应的处理方式(target)。
　　alias是指向别的entry的别名，from调用的某一个view，cbi调用某一个model，call直接调用函数。
　　第三个参数是菜单的文本，_(“string”),国际化。
　　第四个参数是是同级菜单下，此菜单项的位置，从大到小
target主要分为三类：call，template 和cbi。

call用来调用函数。即语句
entry({"admin", "status", "iptables"}, call("action_iptables"), _("Firewall"), 2)
Firewall模块调用了action_iptables函数

template调用
template用来调用已有的htm模版，模版目录在lua\luci\view目录下。即语句
entry({"admin","status","overview"},template("admin_status/index"),_("Overview"), 1)
调用lua\luci\view\admin_status\index.htm文件来显示。

CBI调用
　　a. CBI了解 –- Configuration Binding Interface
　　CBI模型是Lua文件描述UCI配置文件的结构和由此产生的HTML表单来评估CBI解析器，
所有CBI luci.cbi.Map类型的模型文件必须返回一个map对象，
在cbi模块中定义各种控件，Luci系统会自动执行大部分处理工作。其链接目录在lua\luci\model\cbi下
entry({"admin", "status", "processes"}, cbi("admin_status/processes"), _("Processes"), 6)
调用\lua\luci\model\cbi\admin_status\processes.lua来实现模块。
}

luci(openwrt 汉化){
make menuconfig 
添加luci
LuCI--->Collections----- <*> luci
添加luci的中文语言包
LuCI--->Translations---- <*> luci-i18n-chinese

这种方式只能翻译系统自带的一些功能。新增加的功能例如snmp、lldp等相关信息，需要修改其他地方，进行翻译。
/home/hbg//trunk/xyz/feeds/luci/po/zh_CN目录下的base.po
进行修改，添加需要翻译项：
eg：
msgid "(%s available)"   -----需要翻译的项
msgstr "(%s 可用)"         -----翻译后
注意：
重新编译时，需要先删除build_dir下的luci目录，然后再进行编译。
}

luci(LuCI探究){
1. 多语言
    1）检查：
    opkg list | grep luci-i18n-
    2）安装语言包：
    opkg install luci-i18n-hungarian
2.uhttpd
    这个是LuCI所在的Web Server。docroot在/www下边，index-html指向了/cgi-bin/luci，注意这是相对于docroot而言的路径。
    openwrt中利用它作为web服务器，实现客户端web页面配置功能。对于request处理方式，采用的是cgi，而所用的cgi程序就是luci。
    Client端和serv端采用cgi方式交互，uhttpd服务器的cgi方式中，fork出一个子进程，子进程利用execl替换为luci进程空间，
并通过setenv环境变量的方式，传递一些固定格式的数据（如PATH_INFO）给luci。另外一些非固定格式的数据（post-data）
则由父进程通过一个w_pipe写给luci的stdin，而luci的返回数据则写在stdout上，由父进程通过一个r_pipe读取。

2）luci 文件（权限一般是 755 ） ， luci 的代码如下：
#!/usr/bin/lua -- 执行命令的路径
require"luci.cacheloader" -- 导入 cacheloader 包
require"luci.sgi.cgi" -- 导入 sgi.cgi 包
luci.dispatcher.indexcache = "/tmp/luci-indexcache" --cache 缓存路径地址
luci.sgi.cgi.run() -- 执 行 run 方法，此方法位于 /usr/lib/lua/luci/sgi/cgi.lua中

}

luci(){
# 在OpenWrt路由器上添加LuCI的模块 
http://blog.csdn.net/bailyzheng/article/details/48663419
# 如何调试LUCI
http://blog.csdn.net/bailyzheng/article/details/48663369
}