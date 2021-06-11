mysql(基于linux使用mysql二进制包安装mysql5.5)
{
ubuntu 12.04 32bit

1.下载:在http://dev.mysql.com/downloads/mysql/官网上下载mysql-5.5.28-linux2.6-i686.tar.gz.
2.解压:tar -xvf mysql-5.5.28-linux2.6-i686.tar.gz
3.移动到/usr/local/mysql
mv mysql-5.5.28-linux2.6-i686 /usr/local/ 
ln -s mysql-5.5.28-linux2.6-i686/ mysql

4.安装依赖的lib包:执行/usr/local/bin/mysql/bin/mysqld,报错
/usr/local/mysql/bin/mysqld: error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
使用apt-cache search libaio,找到如下软件源
libaio-dev - Linux kernel AIO access library - development files
libaio1 - Linux kernel AIO access library - shared library
libaio1-dbg - Linux kernel AIO access library - debugging symbols
使用apt-get install libaio1.


# 配置用户，目录
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local/mysql
chown -R mysql .
chgrp -R mysql .

# 初始化mysql
scripts/mysql_install_db --user=mysql
# Next command is optional
cp support-files/my-medium.cnf /etc/my.cnf
# Next command is optional
cp support-files/mysql.server /etc/init.d/mysql.server
 这里最重要的就是初始化mysql的一些权限账户表，默认创建了一个空密码的root用户
 
 
# 启动mysql
最简单的启动方式:
shell> /usr/local/mysql/bin/mysqld --user=mysql
默认情况下使用/usr/local/mysql/data作为mysql的数据目录，包括数据库文件，log日志。
常用的mysql启动参数:
/usr/local/mysql/bin/mysqld  --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data  --port=3306 --socket=/tmp/mysql.sock
推荐的启动mysql
/usr/local/mysql/support-files/mysql.server start
一般来说，没什么特别需要的话就是使用上述脚本启动mysql服务器了，这个脚本可以加入到linux的系统服务。


# 关闭mysql
最简单的方式
killall mysqld
推荐的方式
/usr/local/mysql/support-files/mysql.server stop
使用mysql.server stop关闭mysqld会销毁pid文件，并做容错操作，但是最后也是调用kill命令kill mysql。
关闭mysql，尽量不要用kill -9 mysql_pid或者是killall -9 mysql,否则mysql进程无法做退出处理，就可能会丢失数据，甚至导致表损坏。


#浅析mysql.server脚本的启动流程
mysql.server脚本可以看到在以下脚本调用mysqld_safe这个bash
$bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path" $other_args >/dev/null 2>&1 &
默认情况下,$bindir/mysqld_safe就是/usr/local/mysql/bin/mysqld_safe这个shell，我的本机的调用参数如下:
/bin/sh /usr/local/mysql/bin/mysqld_safe --datadir=/usr/local/mysql/data --pid-file=/usr/local/mysql/data/blue-pc.pid
而mysqld_safe也是一个shell,可以看到在这个脚本在初始化N多变量后，调用
eval_log_error "$cmd"
这个shell function最后就是调用
 #echo "Running mysqld: [$cmd]"
 eval "$cmd"
在我本机，这个$cmd就是
/usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --plugin-dir=/usr/local/mysql/lib/plugin --user=mysql --log-error=/usr/local/mysql/data/blue-pc.err --pid-file=/usr/local/mysql/data/blue-pc.pid
}

mysql(mysql client命令行选项)
{
    该选项的形式可以为--password=pass_val或--password。在后一种情况(未给出 密码值)，程序将提示输入密码。
也可以给出密码选项，短形式为-ppass_val或-p。然而，对于短形式，如果给出了 密码值，必须紧跟在选项后面，中
间不能插入空格。这样要求的原因是如果选项后面有空格，程序没有办法来告知后面的参量是 密码值还是其它某种参量。
因此，下面两个命令的含义完全不同：

mysql -ptest
mysql -p test
第一个命令让mysql使用密码test，但没有指定默认数据库。
第二个命令让mysql提示输入密码并使用test作为默认数据库。

mysql -h主机地址 -u用户名 -p用户密码


mysql -h host -u user -p
mysql> QUIT

mysql -u root -p -e "SELECT User, Host FROM User" mysql #mysql数据库名
mysql -u root -p --execute="SELECT Name FROM Country WHERE Name LIKE 'AU%';SELECT COUNT(*) FROM City" world #world数据库名

从文本文件执行SQL语句
mysql db_name < text_file #还可以用一个USE db_name语句启动文本文件。
mysql < text_file
source filename
\. filename

}