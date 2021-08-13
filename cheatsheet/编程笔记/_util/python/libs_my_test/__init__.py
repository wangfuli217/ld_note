#!python
# -*- coding:utf-8 -*-
'''
本目录主要是对公用类库的测试初始化
导入公用类库 及 必要的第三方库

Created on 2015/11/17
Updated on 2016/8/9
@author: Holemar
'''
import os
import sys
import logging
import unittest

# 避免编码问题导致报错
try:
    reload(sys)
    sys.setdefaultencoding('utf8')
except:pass

# 导入运行环境
dirname = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(1, dirname + '/..')
sys.path.insert(2, dirname + '/../../libs')

# 尝试定义 django 的配置，因为涉及 django 的测试，必须要先定义配置，否则会出异常。
try:
    from django.conf import settings
    settings.configure(
        DATABASES = {
            'default': {
                # 使用 sqlite3 的内存数据库，避免外部依赖
                'ENGINE': 'django.db.backends.sqlite3',
                'NAME': ':memory:', # 内存处理
            }
        },
        DEBUG=True,
    )
except:pass


@classmethod
def setUpClass(cls):
    '''测试这个类前的初始化动作'''
    logging.info('--------------------- %s 类的测试开始 -----------------', cls.__name__)

@classmethod
def tearDownClass(cls):
    '''测试这个类所有函数后的结束动作'''
    logging.info('--------------------- %s 类的测试结束 -----------------\r\n', cls.__name__)

def setUp(self):
    """初始化"""
    self.class_name = self.__class__.__name__
    logging.info('%s 类的 %s 函数测试开始...', self.class_name, self._testMethodName)

def tearDown(self):
    """销毁"""
    self.class_name = self.__class__.__name__
    logging.info('%s 类的 %s 函数测试完毕。。。\r\n', self.class_name, self._testMethodName)

# 修改 unittest.TestCase 的 setUp / tearDown 函数, 以便添加默认的 初始化及销毁函数
setattr(unittest.TestCase, 'setUpClass', setUpClass)
setattr(unittest.TestCase, 'tearDownClass', tearDownClass)
setattr(unittest.TestCase, 'setUp', setUp)
setattr(unittest.TestCase, 'tearDown', tearDown)

# 先预设一下 log,以便调试
format_str = "[%(asctime)s] [%(module)s.%(funcName)s:%(lineno)s] %(levelname)s: %(message)s"
logging.basicConfig(level=logging.DEBUG, format=format_str)

