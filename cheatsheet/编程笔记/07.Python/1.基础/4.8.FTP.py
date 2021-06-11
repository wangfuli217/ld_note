from ftplib import FTP  
f = FTP('some.ftp.server') 
f.login('anonymous', 'your@email.address') 
    : 
f.quit()

ftp登陆连接
from ftplib import FTP            #加载ftp模块
ftp=FTP()                         #设置变量
ftp.set_debuglevel(2)             #打开调试级别2，显示详细信息
ftp.connect("IP","port")          #连接的ftp sever和端口
ftp.login("user","password")      #连接的用户名，密码    login(user ='anonymous', passwd ='', acct='') 
print ftp.getwelcome()            #打印出欢迎信息
ftp.cmd("xxx/xxx")                #进入远程目录           cwd(path)
bufsize=1024                      #设置的缓冲区大小
filename="filename.txt"           #需要下载的文件
file_handle=open(filename,"wb").write #以写模式在本地打开文件
ftp.retrbinaly("RETR filename.txt",file_handle,bufsize) #接收服务器上文件并写入本地文件
ftp.set_debuglevel(0)             #关闭调试模式
ftp.quit()                        #退出ftp
 
ftp相关命令操作
ftp.cwd(pathname)                 #设置FTP当前操作的路径
ftp.dir()                         #显示目录下所有目录信息    dir ([path [,...[,cb]])
ftp.nlst()                        #获取目录下的文件          nlst ([path [,...]) 
ftp.mkd(pathname)                 #新建远程目录
ftp.pwd()                         #返回当前所在位置
ftp.rmd(dirname)                  #删除远程目录
ftp.delete(filename)              #删除远程文件
ftp.rename(fromname, toname)      #将fromname修改名称为toname。
ftp.storbinaly("STOR filename.txt",file_handel, bufsize)  #上传目标文件
ftp.retrbinary("RETR filename.txt",file_handel, bufsize)  #下载FTP文件

retrlines(cmd   [, cb ]) # 给定 FTP 命令（如“RETR filename ”），用于下载文本文件。可选的回调函数 cb 用于处理文件的每一行
storlines( cmd ,  f)     # 给定FTP 命令（如“STOR fil ename ”），用来上传文本文件。要给定一个文件对象 f 
f.retrbinary('RETR %s' % "/sbin/rtud", open(FILE, 'wb').write) # 下载
f.storbinary('STOR %s' % "/sbin/rtud", open(FILE, 'rb').read)  # 上传

0.  FTP.quit()与FTP.close()的区别
    FTP.quit():发送QUIT命令给服务器并关闭掉连接。这是一个比较“缓和”的关闭连接方式，但是如果服务器对QUIT命令返回错误时，会抛出异常。
    FTP.close()：单方面的关闭掉连接，不应该用在已经关闭的连接之后，例如不应用在FTP.quit()之后。
    
1. 下载、上传文件
#coding: utf-8
from ftplib import FTP
import time
import tarfile
#!/usr/bin/python
#-*- coding: utf-8 -*-

from ftplib import FTP

def ftpconnect(host, username, password):
    ftp = FTP()
    #ftp.set_debuglevel(2)         #打开调试级别2，显示详细信息
    ftp.connect(host, 21)          #连接
    ftp.login(username, password)  #登录，如果匿名登录则用空串代替即可
    return ftp
    
def downloadfile(ftp, remotepath, localpath):
    bufsize = 1024                #设置缓冲块大小
    fp = open(localpath,'wb')     #以写模式在本地打开文件
    ftp.retrbinary('RETR ' + remotepath, fp.write, bufsize) #接收服务器上文件并写入本地文件
    ftp.set_debuglevel(0)         #关闭调试
    fp.close()                    #关闭文件

def uploadfile(ftp, remotepath, localpath):
    bufsize = 1024
    fp = open(localpath, 'rb')
    ftp.storbinary('STOR '+ remotepath , fp, bufsize) #上传文件
    ftp.set_debuglevel(0)
    fp.close()                                    

if __name__ == "__main__":
    ftp = ftpconnect("******", "***", "***")
    downloadfile(ftp, "***", "***")
    uploadfile(ftp, "***", "***")

    ftp.quit()

 2. 上传、下载文件/目录
#coding:utf-8
from ctypes import *
import os
import sys
import ftplib

class myFtp:
    ftp = ftplib.FTP()
    bIsDir = False
    path = ""
    def __init__(self, host, port='21'):
        #self.ftp.set_debuglevel(2) #打开调试级别2，显示详细信息 
        #self.ftp.set_pasv(0)      #0主动模式 1 #被动模式
        self.ftp.connect( host, port )
            
    def Login(self, user, passwd):
        self.ftp.login( user, passwd )
        print self.ftp.welcome

    def DownLoadFile(self, LocalFile, RemoteFile):
        file_handler = open( LocalFile, 'wb' )
        self.ftp.retrbinary( "RETR %s" %( RemoteFile ), file_handler.write ) 
        file_handler.close()
        return True
    
    def UpLoadFile(self, LocalFile, RemoteFile):
        if os.path.isfile( LocalFile ) == False:
            return False
        file_handler = open(LocalFile, "rb")
        self.ftp.storbinary('STOR %s'%RemoteFile, file_handler, 4096)
        file_handler.close()
        return True

    def UpLoadFileTree(self, LocalDir, RemoteDir):
        if os.path.isdir(LocalDir) == False:
            return False
        print "LocalDir:", LocalDir
        LocalNames = os.listdir(LocalDir)
        print "list:", LocalNames
        print RemoteDir
        self.ftp.cwd( RemoteDir )
        for Local in LocalNames:
            src = os.path.join( LocalDir, Local)
            if os.path.isdir( src ): self.UpLoadFileTree( src, Local )
            else:
                self.UpLoadFile( src, Local )
                
        self.ftp.cwd( ".." )
        return
    
    def DownLoadFileTree(self, LocalDir, RemoteDir):
        print "remoteDir:", RemoteDir
        if os.path.isdir( LocalDir ) == False:
            os.makedirs( LocalDir )
        self.ftp.cwd( RemoteDir )
        RemoteNames = self.ftp.nlst()  
        print "RemoteNames", RemoteNames
        print self.ftp.nlst("/del1")
        for file in RemoteNames:
            Local = os.path.join( LocalDir, file )
            if self.isDir( file ):
                self.DownLoadFileTree( Local, file )                
            else:
                self.DownLoadFile( Local, file )
        self.ftp.cwd( ".." )
        return
    
    def show(self, list):
        result = list.lower().split( " " )
        if self.path in result and "<dir>" in result:
            self.bIsDir = True
     
    def isDir(self, path):
        self.bIsDir = False
        self.path = path
        #this ues callback function ,that will change bIsDir value
        self.ftp.retrlines( 'LIST', self.show )
        return self.bIsDir
    
    def close(self):
        self.ftp.quit()

if __name__ == "__main__":
    ftp = myFtp('*****')
    ftp.Login('***','***')

    ftp.DownLoadFileTree('del', '/del1')#ok
    ftp.UpLoadFileTree('del', "/del1" )
    ftp.close()
    print "ok!"
    
3. 异常处理
#!/usr/bin/env python

import ftplib
import os
import socket

HOST = 'ftp.mozilla.org'
DIRN = 'pub/mozilla.org/webtools'
FILE = 'bugzilla-LATEST.tar.gz'

def main():
    try:
        f = ftplib.FTP(HOST)
    except (socket.error, socket.gaierror), e:
        print 'ERROR: cannot reach "%s"' % HOST
        return
    print '*** Connected to host "%s"' % HOST

    try:
        f.login()
    except ftplib.error_perm:
        print 'ERROR: cannot login anonymously'
        f.quit()
        return
    print '*** Logged in as "anonymous"'

    try:
        f.cwd(DIRN)
    except ftplib.error_perm:
        print 'ERROR: cannot CD to "%s" folder' % DIRN
        f.quit()
        return
    print '*** Changed to "%s" folder' % DIRN

    try:
        f.retrbinary('RETR %s' % FILE,
            open(FILE, 'wb').write)
    except ftplib.error_perm:
        print 'ERROR: cannot read file "%s"' % FILE
        if os.path.exists(FILE):
            os.unlink(FILE)
    else:
        print '*** Downloaded "%s" to CWD' % FILE
    f.quit()

if __name__ == '__main__':
    main()