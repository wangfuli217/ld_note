#!python
# -*- coding:utf-8 -*-
'''
公用函数(密码处理) aes.py 的测试
Created on 2016/9/2
Updated on 2016/9/2
@author: Holemar
'''
import logging
import unittest

import __init__
from libs_my import aes


class AES_Test(unittest.TestCase):

    def test_english(self):
        # 普通英文 + 英文符号测试
        key = 'fgjtjirj4o234234' # 必须16、24、32 位
        txt = 'abc321cc55'
        assert aes.encryptData(key, txt)
        assert aes.decryptData(key, aes.encryptData(key, txt)) == txt

    def test_chinese(self):
        # 中文测试
        key = 'fgjtjirj4o234234' # 必须16、24、32 位
        txt = '15呵呵5@#E$$@#gh，。h()_=154中文4*4616'
        assert aes.encryptData(key, txt)
        assert aes.decryptData(key, aes.encryptData(key, txt)) == txt

    def test_unicode(self):
        # unicode测试
        key = 'fgjtjirj4o234234' # 必须16、24、32 位
        txt = u'15呵呵5@#E$$@#gh，。h()_=154中文4*4616'
        assert aes.encryptData(key, txt)
        assert aes.decryptData(key, aes.encryptData(key, txt)) == txt



if __name__ == "__main__":
    unittest.main()

