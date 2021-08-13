#!python
# -*- coding:utf-8 -*-
'''
公用函数 rc4.py 的测试类
Created on 2014/7/16
Updated on 2016/2/26
@author: Holemar
'''
import unittest

import __init__
from libs_my import rc4


class RC4Test(unittest.TestCase):

    def test_encode_decode(self):
        key = "1bb762f7ce24ceee"

        # 英文加密测试
        txt = '01A0519'
        assert rc4.encode(txt, key) == '36824f33ca5d6c'
        assert rc4.decode(rc4.encode(txt, key),key) == txt

        # 中文加密测试
        txt = '哈哈'
        assert rc4.encode(txt, key) == 'e32086e66ce4'
        assert rc4.decode(rc4.encode(txt, key),key) == txt

        check_unicode = True
        try:
            # py2 的中文加密测试
            unicode
            txt = u'哈哈'
            check_unicode = False
            assert rc4.encode(txt, key) == 'e32086e66ce4'
            assert rc4.decode(rc4.encode(txt, key),key) == txt.encode("utf-8")
            check_unicode = True
        except NameError:pass
        assert check_unicode


if __name__ == "__main__":
    unittest.main()
