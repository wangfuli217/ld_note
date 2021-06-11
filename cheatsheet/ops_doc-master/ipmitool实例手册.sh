yum -y install ipmitool
apt-get -y install ipmitool
modprobe ipmi_msghandler
modprobe ipmi_devintf
modprobe ipmi_si


help帮助命令
ipmitool chassis help
则可以得到如下的帮助信息：
Chassis Commands:  status, power, identify, policy, restart_cause, poh, bootdev, bootparam, selftest
其中status，power，identify，policy，restart_cause，poh，bootdev，bootparam，selftest就是chassis命令的下一级参数。

ipmitool(bmc/mc相关命令)
{
bmc reset
对BMC执行热（冷）复位，格式为bmc reset { warm | cold }。

ipmitool bmc reset warm  #对BMC执行热复位
ipmitool bmc info        #获取BMC的版本信息
ipmitool bmc selftest    #执行BMC自我测试
}

ipmitool(user相关命令)
{
ipmitool user list 1
重设管理员密码，2表示管理员ID，后面就是管理员的新密码

ipmitool -I lan -U root -H 192.168.1.101 chassis status
ipmitool -I lan -U root -f ~/.racpasswd -H 192.168.1.101 chassis status

user summary
显示用户ID的概要信息。
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user summary

user list
显示所有已经定义的用户信息。
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user list 1

user set name
设置指定ID的用户名。
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user set name 4 test

user set password
设置指定ID用户的用户密码，格式为user set password userid [password]。
参数说明如下：
    userid表示用户ID，范围为0～63，其中0是保留用户名，1是匿名用户，2～63是使用的用户。
    password表示输入的用户密码。
说明：
如果不填写密码，则会清空该用户的密码。
如设置用户ID为4的用户密码为1111111111111111111：
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user set password 4 1111111111111111111


user disable
禁用指定ID的用户，格式为user disable userid。
参数userid表示用户ID，范围为0～63，其中0是保留用户名，1是匿名用户，2～63是使用的用户。
如禁用用户ID为4的用户：
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user disable 4

user enable
使能指定ID的用户，格式为user enable userid。
参数userid表示用户ID，范围为0～63，其中0是保留用户名，1是匿名用户，2～63是使用的用户。
如使能用户ID为4的用户：
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword user enable 4

}

ipmitool(设置IPMI ip 地址)
{
# ipmitool lan set 1 ipsrc dhcp 
# ipmitool lan print 1
# ipmitool lan set 1 ipsrc static
# ipmitool lan set 1 ipaddress 10.1.199.211 Setting LAN IP Address to 10.1.199.211
# ipmitool lan set 1 netmask 255.255.255.0 Setting LAN Subnet Mask to 255.255.255.0
# ipmitool lan set 1 defgw ipaddr 10.1.199.1 Setting LAN Default Gateway IP to 10.1.199.1
# ipmitool lan print 1

使用静态地址：ipmitool lan set <channel_no> ipsrc static
使用动态地址：ipmitool lan set <channel_no> ipsrc dhcp
设置IP：ipmitool lan set <channel_no> ipaddr <x.x.x.x>
设置掩码：ipmitool lan set <channel_no> netmask <x.x.x.x>
设置网关：ipmitool lan set <channel_no> defgw ipaddr <x.x.x.x>
本地操作 -I open 表示接口本地：ipmitool -I open lan print 1
操作远程机器 -I lan 表示接口远程：ipmitool -I lan -H 10.1.199.12 -U ADMIN -P ADMIN lan print 1

alert print
打印告警通道信息，格式为alert print channel。
如打印告警通道1的信息：
ipmitool lan alert print 1
}

ipmitool(改变服务器引导方式)
{
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev pxe
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev disk
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev cdrom
}

ipmitool(服务器电源管理)
{
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power off 
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power reset 
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power on 
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power status
}

ipmitool(channel相关命令)
{
channel authcap
显示指定通道的鉴权级别支持的信息，格式为channel authcap channelnumber privilegelevel。
参数说明如下：
    channelnumber表示通道号，一般为1和2。
    privilegelevel表示鉴权级别，取值范围为1～5以及15。
        1：Callback level
        2：User level
        3：Operator level
        4：Administrator level
        5：OEM Proprietary level
        15：No access
如显示通道1内管理员级别所支持的信息：
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword channel authcap 1 4


channel getaccess
显示指定通道指定用户的配置信息，格式为channel getaccess channelnumber userid。
参数说明如下：
    channelnumber表示通道号，一般为1和2。
    userid表示用户ID，范围为0～63，其中0是保留用户名，1是匿名用户，2～63是使用的用户。
如显示通道1内用户ID为2的用户的配置信息：
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword channel getaccess 1 2

channel setaccess
设置用户和通道的配置信息。
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword channel setaccess 1 2 callin=on ipmi=on link=on privilege=4
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword channel getaccess 1 2

channel info
显示选择的通道信息。
如果没有输入具体通道号，则显示当前通道信息。
ipmitool -I lanplus -L operator -H  192.168.100.211 -U solusername -P soluserpassword channel info
}

ipmitool(chassis)
{
chassis status
获取设置底板电源状态信息。
ipmitool chassis status

chassis power
设置底板电源状态，格式为chassis power { status | on | off | cycle | reset | diag | soft }
参数说明如下：
    status：查询单板的电源状态。
    on：给单板上电。
    off：不通知操作系统直接给单板下电。
    cycle：在命令发送1秒后向单板发送下电命令。只有单板处于上电状态或者休眠状态时发送该命令才有意义。
    reset：对单板执行硬件复位。
    diag：使单板进入处理器中断诊断模式。
    soft：通知操作系统给单板下电。
如直接将单板下电：
ipmitool chassis power off

Chassis Power Control: Down/Off
}
ipmitool(log)
{
ipmitool sel info
ipmitool sel list
ipmitool sel elist                       # extended list (see manpage)
ipmitool sel clear
ipmitool sel get 2
ipmitool sel add
ipmitool sel time [ get | set “m/dd/yyyy hh:mm:s” ] 
ipmitool sel readraw /fd/rawfile.txt # sel readraw
ipmitool sel writeraw /fd/rawfile.txt # sel writeraw
}

ipmitool(sensor)
{
# Show sensor output
ipmitool sdr info
ipmitool sdr list  #sdr list { all | full | compact | event | mcloc | fru | generic }。
ipmitool sdr type list
ipmitool sdr type Temperature
ipmitool sdr type Fan
ipmitool sdr type 'Power Supply'
}

ipmitool(fru)
{
#Show field-replaceable-unit details
ipmitool fru print
}

ipmitool(sensor相关命令)
{
ipmitool sensor list #显示传感器的门限以及其他信息。

sensor thresh
ipmitool sensor thresh +3.3VDD lnc 3.2 # 设置传感器的门限值，格式为sensor thresh id threshold setting。

sensor get
查询具体某些传感器的信息。
ipmitool sensor get +3.3VDD +12VDD "CPU1 Core Temp" # 如查询“+3.3VDD”传感器、“+12VDD” 传感器和“CPU1 Core Temp”传感器的信息：
}

ipmitool(pef)
{
pef命令
pef命令支持以下几个参数：
    Info：用于查询并打印BMC对PEF（Platform Event Filtering）的支持信息。
    status：打印当前的PEF信息（最后产生日志信息）。
    policy：打印PEF策略表，每条策略描述一条告警。
    list：打印PEF表格条目，每个PEF条目描述了一个传感器事件。当PEF 被激活时，每个系统事件都会触发BMC扫描所有条目，寻找匹配的事件并执行相应的操 作。操作有优先级，高优先级的先执行。
如打印PEF策略表：
[root@localhost /]# ipmitool pef policy
}