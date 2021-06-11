    autofs服务程序是一种Linux系统守护进程，当检测到用户试图访问一个尚未挂载的文件系统时，
将自动挂载该文件系统。换句话说，我们将挂载信息填入/etc/fstab文件后，系统在每次开机时
都自动将其挂载，而autofs服务程序则是在用户需要使用该文件系统时才去动态挂载，

yum install autofs

vim /etc/auto.master

+ /media /etc/iso.misc
+ vim /etc/iso.misc