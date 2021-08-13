#!python
# -*- coding:utf-8 -*-
'''
公用函数 parser_util.py 的测试
Created on 2015/11/27
Updated on 2016/2/16
@author: Holemar
'''
import sys
import unittest

import __init__
from libs_my import parser_util

class ParserUtilTest(unittest.TestCase):

    # get 测试
    def test_get(self):
        # 默认参数时
        sys.argv = [__file__]
        parser = parser_util.get('test')
        assert parser == {'debug': False, 'master': False, 'logfile': './logs/run_8080.log', 'backupCount': 30, 'port': 8080}
        # 直接取值
        assert parser.debug == False
        assert parser.logfile == './logs/run_8080.log'
        assert parser.port == 8080
        # 传入参数时
        sys.argv = [__file__, '-p1314', '-f', 'test.log', '-d']
        parser2 = parser_util.get('test')
        assert parser2 == {'debug': True, 'master': False, 'logfile': 'test.log', 'backupCount': 30, 'port': 1314}
        assert parser2.debug == True
        assert parser2.master == False
        assert parser2.logfile == 'test.log'
        assert parser2.port == 1314


    # get_args 测试
    def test_get_args(self):
        # 无正确参数时
        sys.argv = [__file__, 'runserver', '0.0.0.0:9009']
        args = parser_util.get_args()
        assert args == {}
        assert isinstance(args, dict)
        # 正确参数时
        sys.argv = [__file__, '-p1314', '-v', '1.5.2', '-d', '--config', 'config.py', 'aa']
        args = parser_util.get_args()
        assert args == {'p':'1314', 'v':'1.5.2', 'd':True, 'config':'config.py'}
        assert isinstance(args, dict)


if __name__ == "__main__":
    unittest.main()
