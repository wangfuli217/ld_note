#!python
# -*- coding:utf-8 -*-
'''
公用函数(FTP文件上传、下载)
Created on 2016/06/15
Updated on 2016/06/15
@author: Holemar
'''
import os
import ftplib
from ftplib import FTP
import logging

from . import str_util

__all__=('init', 'ftp_upload', 'ftp_download')
logger = logging.getLogger('libs_my.ftp_util')


CONFIG = {
    'host' : '', # {string} ftp连接域名/ip
    'port' : ftplib.FTP_PORT, # {int} ftp端口号
    'user' : '', # {string} ftp登录名
    'passwd' : '', # {string} ftp登录密码
    'acct' : '',
    'pasv' : True, # {bool} 是否打开被动模式。为True表示作为客户端发送FTP请求, 为False表示作为服务器接收FTP请求。默认情况下,被动模式为打开状态。
    'timeout' : ftplib._GLOBAL_DEFAULT_TIMEOUT, # {int} 超时时间
    'char_code' : 'utf-8', # {string} ftp服务器的编码
}

def init(**kwargs):
    '''
    @summary: 初始化ftp默认参数
    @param {string} host: ftp连接域名/ip,默认空字符串
    @param {int} port: ftp端口号,默认空字符串
    @param {string} user: ftp登录名,默认空字符串
    @param {string} passwd: ftp登录密码,默认空字符串
    @param {string} acct:
    @param {int} timeout: 超时时间
    '''
    global CONFIG
    CONFIG.update(kwargs)


def mkdir(ftp, path):
    u"""
    @summary: 创建ftp里面的目录(会自动创建各级父目录)
    @param {ftplib.FTP} ftp: ftp实例
    @param {string} path: 目录
    """
    path_splitted = path.split('/')
    for path_part in path_splitted:
        try:
            ftp.cwd(path_part)
        except:
            try:
                ftp.mkd(path_part)
                ftp.cwd(path_part)
            except ftplib.all_errors:
                pass
    return

def ftp_upload(remote_path, file_path, blocksize=1024):
    """
    summary: FTP 上传文件
    @param {string} remote_path: ftp上的文件路径(只有目录，没有文件名)
    @param {string} file_path: 文件路径(包括目录及文件名)
    @param {int} file_path: 文件路径(包括目录及文件名)
    @return {bool}: 是否上传成功
    """
    global CONFIG
    ftp = None
    try:
        ftp = FTP()
        ftp.connect(host=CONFIG.get('host'), port=CONFIG.get('port'), timeout=CONFIG.get('timeout'))
        ftp.login(user=CONFIG.get('user'), passwd=CONFIG.get('passwd'), acct=CONFIG.get('acct'))
        ftp.set_pasv(CONFIG.get('pasv'))

        mkdir(ftp, remote_path)

        file_path = str_util.to_unicode(file_path)
        filename = os.path.basename(file_path)
        cmd = 'STOR %s' % str_util.to_str(filename, encode=CONFIG.get('char_code'))
        post_file = open(file_path,'rb') # 以读模式在本地打开文件
        ftp.storbinary(cmd, post_file, blocksize)
        post_file.close()
        ftp.quit()
    except Exception, e:
        if ftp:
            try:
                ftp.quit()
            except:
                pass
        logger.error(u"上传FTP文件错误：%s", e, exc_info=True)
        return False
    return True

def ftp_download(remote_file, file_path, blocksize=1024):
    """
    summary: FTP 下载文件
    @param {string} remote_file: ftp上的文件路径(包括目录及文件名)
    @param {string} file_path: 文件路径(包括目录及文件名)
    @return {bool}: 是否下载成功
    """
    global CONFIG
    ftp = None
    try:
        ftp = FTP()
        ftp.connect(host=CONFIG.get('host'), port=CONFIG.get('port'), timeout=CONFIG.get('timeout'))
        ftp.login(user=CONFIG.get('user'), passwd=CONFIG.get('passwd'), acct=CONFIG.get('acct'))

        file_path = str_util.to_unicode(file_path)
        directory = os.path.dirname(file_path)
        if not os.path.isdir(directory):
            os.makedirs(directory)

        file_handler = open(file_path, 'wb')
        cmd = 'RETR %s' % str_util.to_str(remote_file, encode=CONFIG.get('char_code'))
        ftp.retrbinary(cmd, file_handler.write, blocksize)
        file_handler.close()
        ftp.quit()
    except Exception, e:
        if ftp:
            try:
                ftp.quit()
            except:
                pass
        logger.error(u"下载FTP文件错误：%s", e, exc_info=True)
        return False
    return True
