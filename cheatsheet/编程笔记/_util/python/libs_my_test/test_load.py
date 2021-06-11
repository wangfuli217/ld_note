#!python
# -*- coding:utf-8 -*-
'''
公用函数 load.py 的测试类
Created on 2014/7/16
Updated on 2016/2/16
@author: Holemar
'''
import os
import unittest

import __init__
from libs_my import load

class LoadTest(unittest.TestCase):
    def test_get_path(self):
        # 获取路径
        base_path = os.getcwd()
        assert load.get_path('.') == base_path + os.sep
        assert load.get_path('..') == os.path.abspath('..') + os.sep
        assert load.get_path('../libs/') == os.path.abspath('../libs/') + os.sep
        # 带上参考位置
        assert load.get_path('.', current_path="C:\\Windows\\System32\\com\\en-US\\comrepl.exe.mui") == "C:\\Windows\\System32\\com\\en-US\\"
        assert load.get_path('../zh-CN', current_path="C:\\Windows\\System32\\com\\en-US\\comrepl.exe.mui") == "C:\\Windows\\System32\\com\\zh-CN\\"

    def test_load_modules(self):
        module_list = load.load_modules(file_name='enum.py', path='../libs_my/')
        assert len(module_list) == 1
        Const = module_list[0].Const
        assert Const # 能获取到这个类
        class Platform(Const): pass # 继承这个类不报错，说明获取成功

if __name__ == "__main__":
    unittest.main()

