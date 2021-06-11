#!python
# -*- coding:utf-8 -*-
'''
公用函数 ftp_util.py 的测试类
Created on 2016/6/15
Updated on 2016/6/15
@author: Holemar
'''
import os
import logging
import unittest

import __init__
from libs_my import ftp_util

class TestFtpUtil(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        # 先配置连接
        ftp_util.init(**{
            'host' : '123.59.41.214', # {string} ftp连接域名/ip
            'port' : 18121, # {int} ftp端口号
            'user' : 'osscdn', # {string} ftp登录名
            'passwd' : 'user123', # {string} ftp登录密码
            'pasv' : True, # {bool} 是否打开被动模式。
            'timeout' : 5, # {int} 超时时间
            'char_code' : 'gbk', # {string} ftp服务器的编码
            })

    def test_ftp(self):
        u'''文件上传测试'''
        logging.info(u'文件上传测试')
        remote_path = 'local/test'
        file_path = 'C:\\workspace\\oss_develop\\static\\excel_import_templates\\供应商信息登记表导入模板.xlsx'
        #file_path = 'C:\\workspace\\oss_develop\\static\\images\\404.png'
        assert ftp_util.ftp_upload(remote_path, file_path) == True

        logging.info(u'文件下载测试')
        file1 = u'../供应商信息登记表导入模板.xlsx'
        assert ftp_util.ftp_download(remote_path + '/供应商信息登记表导入模板.xlsx', file1) == True
        assert os.path.isfile(file1)
        os.remove(file1)


if __name__ == "__main__":
    unittest.main()
