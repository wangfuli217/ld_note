#!python
# -*- coding:utf-8 -*-

'''
公用函数 enum.py 的测试类
Created on 2015/12/11
Updated on 2016/4/20
@author: Holemar
'''
import logging
import unittest

import __init__
from libs_my.enum import Const

class Platform(Const):
    ios = (1, 'IOS')
    android = (2, 'ANDROID')
    wp = (3, 'WP')

class LocationType(Const):
    asia = ('Asia', u'亚洲')
    europe = ('Europe', u'欧洲')
    america = ('America', '美洲') # str 类型与 unicode 类型的字符串需区分
    australia = ('Australia', '澳洲')

class LocationType2(Const):
    asia = {'value':'Asia', 'label':u'亚洲'}
    europe = {'value':'Europe', 'label':u'欧洲'}
    america = {'value':'America', 'label':'美洲'} # str 类型与 unicode 类型的字符串需区分
    australia = {'value':'Australia', 'label':'澳洲'}


class TestConst(unittest.TestCase):

    def test_items(self):
        u'''返回数值列表 测试'''
        logging.info(u'测试 枚举 选项的取值')
        assert Platform() == [(1, 'IOS'), (2, 'ANDROID'), (3, 'WP')]
        assert Platform._items == [(1, 'IOS'), (2, 'ANDROID'), (3, 'WP')]
        # 会自动排序
        assert LocationType() == [('America', '美洲'), ('Asia', u'亚洲'), ('Australia', '澳洲'), ('Europe', u'欧洲')]
        assert LocationType._items == [('America', '美洲'), ('Asia', u'亚洲'), ('Australia', '澳洲'), ('Europe', u'欧洲')]
        # dict 值
        assert LocationType2() == [('America', '美洲'), ('Asia', u'亚洲'), ('Australia', '澳洲'), ('Europe', u'欧洲')]
        assert LocationType2._items == [('America', '美洲'), ('Asia', u'亚洲'), ('Australia', '澳洲'), ('Europe', u'欧洲')]

    def test_key(self):
        u'''获取键 测试'''
        logging.info(u'测试 枚举.key 的取值')
        # 数字类型的值
        assert Platform.ios == 1
        assert Platform.android == 2
        assert Platform.wp == 3
        # 字符串类型的值
        assert LocationType.asia == 'Asia'
        assert LocationType.europe == 'Europe'
        assert LocationType.america == 'America'
        assert LocationType.australia == 'Australia'
        # dict 值
        assert LocationType2.asia == 'Asia'
        assert LocationType2.europe == 'Europe'
        assert LocationType2.america == 'America'
        assert LocationType2.australia == 'Australia'

    def test_value(self):
        u'''获取展示值 测试'''
        logging.info(u'测试 枚举._attrs[键] 的取值')
        # 数字类型的值
        assert Platform._attrs[Platform.ios] == 'IOS'
        assert Platform._attrs[Platform.android] == 'ANDROID'
        assert Platform._attrs[Platform.wp] == 'WP'
        # 字符串类型的值
        assert LocationType._attrs[LocationType.asia] == u'亚洲'
        assert LocationType._attrs[LocationType.europe] == u'欧洲'
        assert LocationType._attrs[LocationType.america] == '美洲'
        assert LocationType._attrs[LocationType.australia] == '澳洲'
        # dict 值
        assert LocationType2._attrs[LocationType.asia] == u'亚洲'
        assert LocationType2._attrs[LocationType.europe] == u'欧洲'
        assert LocationType2._attrs[LocationType.america] == '美洲'
        assert LocationType2._attrs[LocationType.australia] == '澳洲'


if __name__ == "__main__":
    unittest.main()
