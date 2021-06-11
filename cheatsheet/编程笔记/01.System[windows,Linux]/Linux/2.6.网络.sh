

ping    网络链接
    usage  ping host [timeout]
    usage  ping -s [-l | U] [adLnRrv] [-A addr_family] [-c traffic_class] [-g gateway [-g gateway ...]] [-F flow_label] [-I interval] [-i interface] [-P tos] [-p port] [-t ttl] host [data_size] [npackets]

ifconfig -a
     /sbin/ifconfig    查看本机的IP地址 (windows 上用 ipconfig)


telnet
    telnet IP 端口
    telnet 域名 端口

netstat -rn


ftp

wget 文件路径   # 下载文件




#上传
    #即是上传文件，xshell就会弹出文件选择对话框，选好文件之后关闭对话框，文件就会上传到linux里的当前目录 。
    Sudo rz

    # 如果没有 rz 上传权限，先传到自己的目录，然后再sudo再移动(得先传到跳板机)
    # 下面这命令,得在跳板机运行,上传到服务器自己的 home 目录
    scp -P 60086 -r cache.py fengwl@113.31.81.134:/home/fengwl

#下载
    #就是下载文件到windows上（保存的目录是可以配置） 比ftp命令方便多了，而且服务器不用再开FTP服务了。
    sz fileName
    sz *.py  # 下载此目录下的多个文件
    Sudo sz fileName
