http://www.runoob.com/memcached/memcached-connection.html

Memcached(安装)
{
sudo apt-get install libevent libevent-deve          自动下载安装（Ubuntu/Debian）
yum install libevent libevent-deve                      自动下载安装（Redhat/Fedora/Centos）


wget http://memcached.org/latest                    下载最新版本
tar -zxvf memcached-1.x.x.tar.gz                    解压源码
cd memcached-1.x.x                                  进入目录
./configure --prefix=/usr/local/memcached           配置
make && make test                                   编译
sudo make install                                   安装


$ /usr/local/memcached/bin/memcached -h                           命令帮助

注意：如果使用自动安装 memcached 命令位于 /usr/local/bin/memcached。
启动选项：
    -d是启动一个守护进程；
    -m是分配给Memcache使用的内存数量，单位是MB；
    -u是运行Memcache的用户；
    -l是监听的服务器IP地址，可以有多个地址；
    -p是设置Memcache监听的端口，，最好是1024以上的端口；
    -c是最大运行的并发连接数，默认是1024；
    -P是设置保存Memcache的pid文件。
作为前台程序运行： 
/usr/local/memcached/bin/memcached -p 11211 -m 64m -vv

作为后台服务程序运行：
# /usr/local/memcached/bin/memcached -p 11211 -m 64m -d
或者
/usr/local/memcached/bin/memcached -d -m 64M -u root -l 192.168.0.200 -p 11211 -c 256 -P /tmp/memcached.pid

    
}
Memcached(连接)
{
语法
telnet HOST PORT
命令中的 HOST 和 PORT 为运行 Memcached 服务的 IP 和 端口。

telnet 127.0.0.1 11211
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
set foo 0 0 3                                                   保存命令
bar                                                             数据
STORED                                                          结果
get foo                                                         取得命令
VALUE foo 0 3                                                   数据
bar                                                             数据
END                                                             结束行
quit                                                            退出
}

Memcached(存储命令)
{

}

Memcached(查找命令)
{

}

Memcached(统计命令)
{

}

Memcached(实例)
{

}