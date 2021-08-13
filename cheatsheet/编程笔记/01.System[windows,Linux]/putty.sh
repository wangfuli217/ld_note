
putty工具命令行参数
	putty.exe [-ssh | -telnet | -rlogin | -raw] [user@]host
	Example: putty -ssh -l vagrant -pw vagrant -P 2222 127.0.0.1

	 -V        print version information and exit
	 -pgpfp    print PGP key fingerprints and exit
	 -v        show verbose messages
	 -load sessname  Load settings from saved session
	 -ssh -telnet -rlogin -raw            force use of a particular protocol
	 -P port   connect to specified port
	 -l user   connect with specified username
	 -batch    disable all interactive prompts The following options only apply to SSH connections:  -pw passw login with specified password
	 -D [listen-IP:]listen-port           Dynamic SOCKS-based port forwarding
	 -L [listen-IP:]listen-port:host:port            Forward local port to remote address
	 -R [listen-IP:]listen-port:host:port            Forward remote port to local address
	 -X -x     enable / disable X11 forwarding
	-A -a     enable / disable agent forwarding
	 -t -T     enable / disable pty allocation
	-1 -2     force use of particular protocol version
	-4 -6     force use of IPv4 or IPv6
	 -C        enable compression
	-i key    private key file for authentication
	 -m file   read remote command(s) from file
	 -s        remote command is an SSH subsystem (SSH-2 only)
	 -N        don't start a shell/command (SSH-2 only)

	自动登录后执行默认的命令：
	putty [-pw password] [-m file] user@ip_addr
	主要在于-m参数，其后面跟着的是当前目录下存在的一个shell脚本，记住了不是在【远程】的计算上，而是在putty程序的相同目录中


用 putty 登录远程服务器之后, 可以写 shell 命令, 这些命令跟系统相关, 跟 putty 已经没有关系了。
如:
	ssh 64.71.156.178	# 连上远程服务器
	scp 文件名  远程登录名@远程ip地址:	# 传文件到远程服务器
	exit # 终止当前进程，并退出到前一个进程


	cd （文件夹名）--查看路径
	dir ---查看当前路径下的所有文件
	unzip ***.zip-----压缩文件到当前目录
	wget （路径）----下载
	mv ***   ****----移动或者重命名
	rm *** *** ----删除一次可以删除多个
	pwd ----显示当前路径
	cp ---拷贝
	unzip FileName.zip # 解压
    zip FileName.zip DirName # 压缩


putty 上的复制粘贴
  复制：
    putty用鼠标左键选中即已经放到剪贴板。选中后即可在windows的其他编辑器或输入栏按Ctrl+V 粘贴。往putty粘贴直接点鼠标右键。

  》putty选择并复制小技巧
    鼠标左键按住拖拉选择，即已经复制。
    双击鼠标左键，选择复制一个单词，支持中文。双击并在第二次按下时不放，拖动鼠标左键，会按单词选择。
    鼠标三击，会选择并复制一行。鼠标三击并在最后一击时拖动，会按行选择。


  粘贴：
    windows中复制：直接选中文本，按Ctrl+C。
    putty中粘贴：鼠标右键

  》vi 中的复制粘贴问题
    对于vi编辑有点特殊。粘贴前应位于插于模式，不像vi快捷键P，是命令模式下的粘贴。粘贴的位置是光标所在的位置，而不是鼠标点的位置。
    如果vim里有set ai （auto indent）或者set cindent,对于格式化文本，粘贴时可能导致前面不断叠加空格，使格式完全错乱。那么在.vimrc里加一句set paste，即可正确粘贴格式化文本。

