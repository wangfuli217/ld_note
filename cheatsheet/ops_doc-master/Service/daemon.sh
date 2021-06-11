1. 运行方式
daemon根据启动与管理方式,可分为独立启动的stand_alone,与通过一个super daemon来统一管理
    stand_alone:此类型daemon可自行独立启动
一直在内存中持续提供服务,对于客服端的请求,响应较快,常见的此类型daemon有提供WWW服务的daemon(httpd)与FTP服务的daemon(vsftpd)等
    super daemon：一个stand_alone的daemon(xinetd,早期是inetd)管理
其内部提供多种服务,当客服端请求时,xinetd才会去唤醒相应的daemon提供服务,请求结束后,此唤醒的daemon也会关闭

2. 线程类型
    multi-threaded (多重线程)
    single-threaded (单个线程)

3. daemon根据提供服务的工作状态可分为singal-control与interval-control
    singal-control:此类daemon通过信号管理
接收到客服端的请求,daemon就会去处理
    interval-control:此类daemon每隔一段时间就主动去执行工作,我们需要在配置文件指定daemon的服务时间与工作内容,如周期例行工作调度的crond

daemon相关文件
daemon不同与一般的进程,其启动除了需要执行文件外,还需配置文件,执行环境,运行数据存储等.一个daemon的相关文件如下:
    /etc/init.d/* : 放置stand_alone的daemon启动脚本
该脚本会进行环境检测,配置文件分析等工作,可以用来管理daemon的状态
    /etc/sysconfig/*(RedHat) /etc/default/*(Debian):服务初始化环境配置文件
存放服务初始化的参数设置的文件,比如网络设置写在/etc/sysconfig/network中
    /etc/*：各服务的配置文件
    /etc/xinetd.conf /etc/xinetd.d/*:super daemon及所属daemon的配置文件
    /etc/xinted.conf是super daemon的配置文件,其是所属daemon最上级的配置文件,当所属daemon的配置文件(/etc/xinetd.d/*)中与xinetd.conf有相同项的配置,参考所属daemon
    /var/lib/*: 各服务产生的数据
一些会产生数据的服务将其数据写入/var/lib中,比如Mysql
    /var/run/*: 各服务的PID记录
为了能简单地管理各服务的进程,所以daemon会将其PID写入/var/run中



