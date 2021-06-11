#!python
# -*- coding:utf-8 -*-
'''
本目录主要是对所有公用类库的测试

注意，并非真的所有文件都加入进来，部分由于特殊原因没加，如:
    test.http_curl.py      # 需要依赖第三方库 curl，在 py2.7.9 下装不成功
    test.cache_redis.py    # 需要依赖 redis 数据库，这程序不一定启动，或者不是这配置
    test.mysql_util.py     # 需要依赖 mysql 数据库，这程序不一定启动，或者不是这配置

'''

import os
import glob
import unittest
import __init__

if __name__ == '__main__':

    # 加载本目录下所有 test_*.py 里面的单元测试类
    dirname = os.path.dirname(os.path.abspath(__file__))
    for module_file in glob.glob(dirname + '/test_*.py'):
        module_name, ext = os.path.splitext(os.path.basename(module_file))
        module = __import__(module_name)
        #args = dict([(module_name + '_' + arg, cls) for arg, cls in vars(module).items() if hasattr(cls, 'assertEqual')])
        args = dict([(module_name + '_' + arg, cls) for arg, cls in vars(module).items() if type(cls) == type and issubclass(cls, unittest.TestCase)])
        globals().update(args)

    unittest.main()

