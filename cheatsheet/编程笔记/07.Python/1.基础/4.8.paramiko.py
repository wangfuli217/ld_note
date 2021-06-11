yum install gcc python-crypto python-paramiko python-devel  -y  

方法一：
    import paramiko
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # 上面的第二行代码的作用是允许连接不在know_hosts文件中的主机。
    ssh.connect("某IP地址",22,"用户名", "口令")
    
方法二：
    import paramiko
    t = paramiko.Transport(("主机","端口"))
    t.connect(username = "用户名", password = "口令")
如果连接远程主机需要提供密钥，上面第二行代码可改成：
    t.connect(username = "用户名", password = "口令", hostkey="密钥")
    
实例1：
#!/usr/bin/python
#-*- coding: utf-8 -*-
import paramiko
#paramiko.util.log_to_file('/tmp/sshout')
def ssh2(ip,username,passwd,cmd):
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip,22,username,passwd,timeout=5)
        stdin,stdout,stderr = ssh.exec_command(cmd)
#           stdin.write("Y")   #简单交互，输入 ‘Y’
        print stdout.read()
#        for x in  stdout.readlines():
#          print x.strip("n")
        print '%stOKn'%(ip)
        ssh.close()
    except :
        print '%stErrorn'%(ip)
ssh2("192.168.0.102","root","361way","hostname;ifconfig")
ssh2("192.168.0.107","root","123456","ifconfig")

实例2：
import paramiko
#建立一个加密的管道
scp=paramiko.Transport(('192.168.0.102',22))
#建立连接
scp.connect(username='root',password='361way')
#建立一个sftp客户端对象，通过ssh transport操作远程文件
sftp=paramiko.SFTPClient.from_transport(scp)
#Copy a remote file (remotepath) from the SFTP server to the local host
sftp.get('/root/testfile','/tmp/361way')
#Copy a local file (localpath) to the SFTP server as remotepath
sftp.put('/root/crash-6.1.6.tar.gz','/tmp/crash-6.1.6.tar.gz')
scp.close()

实例3 一个目录下多个文件上传下载的示例：
#!/usr/bin/env python
#-*- coding: utf-8 -*-
import paramiko,datetime,os
hostname='192.168.0.102'
username='root'
password='361way'
port=22
local_dir='/tmp/getfile'
remote_dir='/tmp/abc'
try:
    t=paramiko.Transport((hostname,port))
    t.connect(username=username,password=password)
    sftp=paramiko.SFTPClient.from_transport(t)
    #files=sftp.listdir(dir_path)
    files=sftp.listdir(remote_dir)
    for f in files:
        print ''
        print '#########################################'
        print 'Beginning to download file  from %s  %s ' % (hostname,datetime.datetime.now())
        print 'Downloading file:',os.path.join(remote_dir,f)
        sftp.get(os.path.join(remote_dir,f),os.path.join(local_dir,f))#下载
        #sftp.put(os.path.join(local_dir,f),os.path.join(remote_dir,f))#上传
        print 'Download file success %s ' % datetime.datetime.now()
        print ''
        print '##########################################'
    t.close()
except Exception:
       print "connect error!"
       
       
实例4 paramiko.transport对象也支持以socket的方式进行连接，如下示例：
    import paramiko
    transport = paramiko.Transport(('localhost',22))
    transport.connect(username='root', password = 'password')
    sftp = paramiko.SFTPClient.from_transport(transport)
    sftp.get(remotefile,localfile)
    #如果是上传则用:
    #sftp.put(localfile, remotefile)
    transport.close()
    #用socket连接
    tcpsock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    tcpsock.settimeout(5)
    tcpsock.connect((ip,22),)
    ssh = paramiko.Transport(tcpsock)
    ssh.connect(username=user,password=password)
    sftpConnect=paramiko.SFTPClient.from_transport(ssh)