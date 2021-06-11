科学上网最佳实践(Shadowsocks)：

一、组件：  申请收费VPS(eg:Vultr) + (免费Shadowsocks Server&&Client )，不再需要chrome代理插件了,Shadowsocks(影梭)的好处是自动识别内外网，只有外网才代理。

二、大体步骤：a)申请空间，安装VPS ； b)在VPS安装shadowsocks Server； c)在本地安装shadowsocks Client，填写Server信息；d)启用BBR加速

三、详细步骤：

a)申请空间，安装VPS：
有很多VPS厂商，比如Vultr, DigitalOcean,Linode， 我用的是Vultr(https://www.vultr.com/), 支持支付宝付款，$5 每月，创建账号后，付款充值，
然后安装虚拟主机，我安装的是Ubuntu17.10  + America-Dallas节点，网速还不错，安装完VPS后，可以通过界面的Console直接登录操作；

b)在VPS安装shadowsocks Server: 
    ShadowsocksServer一键安装脚本权威参考:  https://teddysun.com/486.html , 关键命令如下(我选的是Python版本，按照脚本安装后默认支持"tcp fast_open")：
    wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
    chmod +x shadowsocks-all.sh
    ./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
    安装过程中要求输入一些参数(如port, password)，安装完成后还会产生QR二维码可以用于手机上,
    启动Shadowsocks server: /etc/init.d/shadowsocks-python start
    启动成功后，查看状态:  /etc/init.d/shadowsocks-python status， 正常的话会显示 Shadowsocks (pid xxx) is running...
    客户端需要用到信息保留在配置文件： /etc/shadowsocks-python/config.json
    
c)在本地安装shadowsocks Client，填写Server信息，启用系统代理（PAC模式）       
   windows client: 4.0.6, https://github.com/shadowsocks/shadowsocks-windows/releases
   安装完，在本地客户端填写服务器参数（ip,server port,pwd,method,local proxy port=1080），启用系统代理（PAC模式）；
    
d)启用BBR加速网络（内核4.9以上版本无需升级内核， "uname -r" 查看内核版本）：
参考 https://ifconfiger.com/page/Speed-Up-Network-wit-BBR  ，关键信息：
启用BBR需要向/etc/sysctl.conf里面写入两个配置：
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
然后执行命令让这些配置生效： sysctl -p
如果一切正常，lsmod | grep bbr ,返回值有 tcp_bbr 模块即说明 bbr 已启动
设置开机自动启动BBR, 你可以新建文件 /etc/sysctl.d/80-bbr.conf 并写入net.ipv4.tcp_congestion_control = bbr

启用BBR后，就可以快速访问谷歌了，不启用的话可能访问不了，甚至本地无法ping通VSPIP，
完成上述这些步骤后，本地能用putty/secureCRT ssh登陆VSP server; 也能顺利访问谷歌了。


四、整个过程遇到的问题：
    刚开始安装的是Centos，选的是洛杉矶节点，分配的IP不好(45.32.83.159)，被GFW了，导致本地无法ping通，也无法ssh连接上，最后删除主机，重新建立主机，
选择了Ubuntu17.10  + America-Dallas节点，IP也自动更换了，重新测试了新的IP发现没有被墙。

    问：怎么知道IP被墙了？
    答： https://asm.ca.com/en/ping.php    or   http://ping.chinaz.com/  网站提供免费 ping 测试服务，输入VPS的IP，发现这个IP可以被其它国家的
节点ping通，唯独China的不行。

五、手机版下载：
  https://github.com/shadowsocks/shadowsocks-android/releases 
  手机上安装方法：先把.apk下载到PC，然后USB传输到手机，安装完输入服务器参数(ip,port,pwd,method)就可以直接使用了，我立即去GooglePlay商店下载个chrome。

六、官方wiki
  https://github.com/shadowsocks/shadowsocks/wiki  
  
七、脚本源码：
  https://github.com/teddysun/shadowsocks_install  提供各种OS环境的脚本，本文用的是（2017.11更新的）万能脚本 shadowsocks-all.sh 

八、软件源码
https://github.com/shadowsocks 包含python, go, rust, scala, c, c++ 等各种语言的开源代码
