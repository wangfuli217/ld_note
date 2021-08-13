
scp
	#scp -P 4400 -r root@10.0.24.103:/home2/backup/ /home/mover00/shadow_bak/sites/
	拷贝远程（10.0.24.103）的/home2/backup/ 到本地的 /home/mover00/shadow_bak/sites/

	#scp -P 4400 -r /home2/backup/ root@10.0.24.99:/home/mover00/shadow_bak/sites/
	拷贝本地的/home2/backup/ 到远程（10.0.24.99）的 /home/mover00/shadow_bak/sites/


	scp 是可以拷贝通过配置ssh的两台电脑之间的数据,数据加密,比FTP安全.
	scp是 secure copy的缩写, scp是linux系统下基于ssh登陆进行安全的远程文件拷贝命令。linux的scp命令可以在linux服务器之间复制文件和目录.
	scp命令的用处：scp在网络上不同的主机之间复制文件，它使用ssh安全协议传输数据，具有和ssh一样的验证机制，从而安全的远程拷贝文件。

	scp命令基本格式：
	scp [-1246BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file] [-l limit] [-o ssh_option] [-P port] [-S program] [[user@]host1:]file1 [...] [[user@]host2:]file2

	scp命令的参数说明:
	-1	强制scp命令使用协议ssh1
	-2	强制scp命令使用协议ssh2
	-4	强制scp命令只使用IPv4寻址
	-6	强制scp命令只使用IPv6寻址
	-B	使用批处理模式（传输过程中不询问传输口令或短语）
	-C	允许压缩。（将-C标志传递给ssh，从而打开压缩功能）
	-p	保留原文件的修改时间，访问时间和访问权限。
	-q	不显示传输进度条。
	-r	递归复制整个目录。
	-v	详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题。
	-c cipher	以cipher将数据传输进行加密，这个选项将直接传递给ssh。
	-F ssh_config	指定一个替代的ssh配置文件，此参数直接传递给ssh。
	-i identity_file	从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh。
	-l limit	限定用户所能使用的带宽，以Kbit/s为单位。
	-o ssh_option	如果习惯于使用ssh_config(5)中的参数传递方式，
	-P port	注意是大写的P, port是指定数据传输用到的端口号
	-S program	指定加密传输时所使用的程序。此程序必须能够理解ssh(1)的选项。

	scp命令的实际应用
	1>从本地服务器复制到远程服务器
	(1) 复制文件：
		命令格式：
		scp local_file remote_username@remote_ip:remote_folder
		或者
		scp local_file remote_username@remote_ip:remote_file
		或者
		scp local_file remote_ip:remote_folder
		或者
		scp local_file remote_ip:remote_file
		第1,2个指定了用户名，命令执行后需要输入用户密码，第1个仅指定了远程的目录，文件名字不变，第2个指定了文件名
		第3,4个没有指定用户名，命令执行后需要输入用户名和密码，第3个仅指定了远程的目录，文件名字不变，第4个指定了文件名
		实例：
		scp /home/linux/soft/scp.zip root@www.mydomain.com:/home/linux/others/soft
		scp /home/linux/soft/scp.zip root@www.mydomain.com:/home/linux/others/soft/scp2.zip
		scp /home/linux/soft/scp.zip www.mydomain.com:/home/linux/others/soft
		scp /home/linux/soft/scp.zip www.mydomain.com:/home/linux/others/soft/scp2.zip
	(2) 复制目录：
		命令格式：
		scp -r local_folder remote_username@remote_ip:remote_folder
		或者
		scp -r local_folder remote_ip:remote_folder
		第1个指定了用户名，命令执行后需要输入用户密码；
		第2个没有指定用户名，命令执行后需要输入用户名和密码；
		例子：
		scp -r /home/linux/soft/ root@www.mydomain.com:/home/linux/others/
		scp -r /home/linux/soft/ www.mydomain.com:/home/linux/others/
		上面 命令 将 本地 soft 目录 复制 到 远程 others 目录下，即复制后远程服务器上会有/home/linux/others/soft/ 目录

	2>从远程服务器复制到本地服务器
		从远程复制到本地的scp命令与上面的命令雷同，只要将从本地复制到远程的命令后面2个参数互换顺序就行了。
		例如：
		scp root@www.mydomain.com:/home/linux/soft/scp.zip /home/linux/others/scp.zip
		scp www.mydomain.com:/home/linux/soft/ -r /home/linux/others/
		linux系统下scp命令中很多参数都和 ssh1 有关 , 还需要看到更原汁原味的参数信息,可以运行man scp 看到更细致的英文说明.
