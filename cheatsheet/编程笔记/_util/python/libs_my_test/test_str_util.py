#!python
# -*- coding:utf-8 -*-
'''
公用函数(字符串处理) str_util.py 的测试
Created on 2014/7/16
Updated on 2016/4/6
@author: Holemar
'''
import os
import copy
import string
import decimal
import time
import datetime
import unittest

import __init__
from libs_my import str_util


class StrUtilTest(unittest.TestCase):
    # toString 测试
    def test_toString(self):
        # 处理 utf-8 编码
        a = "哈哈"
        assert isinstance(str_util.to_unicode(a), unicode)
        str_util.to_str(a).decode("utf-8") # 可正常运行即可
        assert isinstance(str_util.to_str(a), str)

        # 处理 unicode 编码
        a = u"哈哈"
        assert isinstance(str_util.to_unicode(a), unicode)
        str_util.to_str(a).decode("utf-8") # 可正常运行即可
        assert isinstance(str_util.to_str(a), str)

        # 编码转成人能阅读的
        b = "eval 处理是为了让“\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字"
        assert b != "eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字"
        assert str_util.to_unicode(b, to_read=True) == u"eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字"
        assert str_util.to_str(b, to_read=True) == "eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字"

        # 截取最大长度
        d = "eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字"
        assert str_util.to_unicode(b, max=10) == u"eval 处理是为了..."
        assert str_util.to_str(b, max='10') == "eval 处理是为了..."

    # deep_str 测试
    def test_deep_str(self):
        # 测试键值是否同时转
        assert str_util.deep_str({'a':[1,1,2,[u'哈哈','33',]],'测试值':(3,4,u'ff',)}) == {u'a': [1, 1, 2, [u'哈哈', u'33']], u'测试值': (3, 4, u'ff')}
        assert str_util.deep_str({'a':[1,1,2,['哈哈','33',]],u'测试值':(3,4,u'ff',)}, str_unicode=str_util.to_str) == {'a': [1, 1, 2, ['哈哈', '33']], '测试值': (3, 4, 'ff')}

        # 不能改变原参数值
        arg1 = {'aa':4.55, 'b1':{'ll':66.55, u'测试':554, '测试2':u'测试2值', 'c':[1,u'哈啊', '啊哈'], u'元组':(1,'22',3.55,set('abcd'), decimal.Decimal('55.6722'), datetime.datetime(2015, 6, 28, 14, 19, 41) )}}
        arg2 = copy.deepcopy(arg1)
        arg3 = str_util.deep_str(arg1, str_unicode=str_util.to_str)
        assert arg1 == arg2
        assert arg1 != arg3
        assert arg3 == {'aa':4.55, 'b1':{'ll':66.55, '测试':554, '测试2':'测试2值', 'c':[1,'哈啊', '啊哈'], '元组':(1,'22',3.55,set('abcd'), 55.6722, '2015-06-28 14:19:41')}}
        arg4 = str_util.deep_str(arg1, all2str=True)
        assert arg4 == {u'aa':u'4.55', u'b1':{u'll':u'66.55', u'测试':u'554', u'测试2':u'测试2值', u'c':[u'1',u'哈啊', u'啊哈'], u'元组':(u'1',u'22',u'3.55',set('abcd'), u'55.6722', u'2015-06-28 14:19:41')}}
        arg5 = str_util.deep_str(arg1, all2str='time')
        assert arg5 == {u'aa':4.55, u'b1':{u'll':66.55, u'测试':554, u'测试2':u'测试2值', u'c':[1,u'哈啊', u'啊哈'], u'元组':(1,u'22',3.55,set('abcd'), 55.6722, u'2015-06-28 14:19:41')}}

        # int, float 类型的转换
        a = {1:5.444, ('', 44.55):[12, 55.50]}
        assert str_util.deep_str(a) == a
        assert str_util.deep_str(a, all2str=True) == {u'1':u'5.444', (u'', u'44.55'):[u'12', u'55.5']}

        # 截取最大长度
        d = [u"eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字", {123456789012345:'123456789012345'}]
        assert str_util.deep_str(d, max='13') == [u"eval 处理是为了让“时...", {123456789012345:u'1234567890123...'}]
        assert str_util.deep_str(d, max=13, str_unicode=str_util.to_str) == ["eval 处理是为了让“时...", {123456789012345:'1234567890123...'}]

        # 类的转换
        class B(object):
            a = arg1
        class A(B):
            obj = arg1
            b = B
            def __init__(self, arg):
                self.arg = arg
            # 类里的函数测试
            def test2(self, arg):pass
            @staticmethod # 申明此方法是一个静态方法，外部可以直接调用
            def tt(a):pass
            @classmethod  # 申明此方法是一个类方法
            def class_method(class_name, arg1):pass

        c1 = A(arg1)
        assert c1.obj == arg1
        assert vars(c1) == {'arg':arg1} # 当前类不改变。 obj 是静态属性，不包含在 vars 内

        c2 = str_util.deep_str(c1, str_unicode=str_util.to_str)
        assert vars(c2) == {'a':arg3, 'b':B, 'obj':arg3, 'arg':arg3}
        c3 = str_util.deep_str(c1, all2str=True)
        assert vars(c3) == {'a':arg4, 'b':B, 'obj':arg4, 'arg':arg4}
        c4 = str_util.deep_str(c1, all2str='time')
        assert vars(c4) == {'a':arg5, 'b':B, 'obj':arg5, 'arg':arg5}


    # to_human 测试
    def test_toHuman(self):
        assert str_util.to_human({'a':"\u8d26\u53f7: ''',\"\"\"113590532\\n\u8d26\u6237\u4f59\u989d;\xE5\x8C\x85 "}) == u"""{
  "a": "账号: ''',\\"\\"\\"113590532\\\\n账户余额;包 "
}"""

        assert str_util.to_human("eval 处理是为了让“\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字") == u'eval 处理是为了让“时”,“包”等字符转为人可以阅读的文字'

        assert str_util.to_human('\xE5\x8C\x85\xE6\x9C\x88\xE5\xA5\x97\xE9\xA4\x90') == u"包月套餐"

    # mod 测试
    def test_mod(self):
        assert str_util.mod(u"哈哈%s呵呵", 22) == u"哈哈22呵呵"
        assert str_util.mod("哈哈%s呵呵", u"看xx看") == "哈哈看xx看呵呵"
        assert str_util.mod("哈哈%s呵呵") == "哈哈%s呵呵"
        assert str_util.mod(u"哈哈%s呵%s呵", (1,2)) == u"哈哈1呵2呵"
        assert str_util.mod(u"哈哈%(a)s呵%(b)d呵", {"a":u"好", 'b':55.32}) == u"哈哈好呵55呵"


    # json2str 测试
    def test_json2str(self):
        # json to str 测试,要求保持 list 顺序,中文兼容,双引号括起字符串(字符串里面的双引号前面有斜杠转移)
        value = {'a':[1,2,'呵xx呵', u'哈"哈', str_util.to_str('智汇云',encode='GBK')]}
        json_value = '{"a": [1, 2, "\\u5475xx\\u5475", "\\u54c8\\"\\u54c8", "\\u667a\\u6c47\\u4e91"]}'
        assert str_util.json2str(value) == json_value
        assert str_util.to_json(json_value) == str_util.deep_str(value)
        # 加入时间测试
        value2 = {'a':[1,2,'呵xx呵', u'哈"哈', str_util.to_str('智汇云',encode='GBK'), time.strptime('2014/03/25 19:05:33', '%Y/%m/%d %H:%M:%S')], u'eff_time': datetime.datetime(2015, 6, 28, 14, 19, 41), }
        value3 = {'a':[1,2,'呵xx呵', u'哈"哈', str_util.to_str('智汇云',encode='GBK'), "2014-03-25 19:05:33"], u'eff_time': "2015-06-28 14:19:41"}
        json_value2 = '{"a": [1, 2, "\\u5475xx\\u5475", "\\u54c8\\"\\u54c8", "\\u667a\\u6c47\\u4e91", "2014-03-25 19:05:33"], "eff_time": "2015-06-28 14:19:41"}'
        assert str_util.json2str(value2) == json_value2
        assert str_util.to_json(json_value2) == str_util.deep_str(value3)
        # eval 能将非标准json的内容转换过来
        json_value = u"{'a': [1, 2, '\\u5475xx\\u5475', '\\xE5\\x8C\\x85']}"
        assert str_util.to_json(json_value) == eval(json_value)


    # gzip 压缩测试
    def test_gzip(self):
        value = {'a':[1,2,'呵xx呵', u'哈"哈', str_util.to_str('智汇云',encode='GBK')]}
        json_value = '{"a": [1, 2, "\\u5475xx\\u5475", "\\u54c8\\"\\u54c8", "\\u667a\\u6c47\\u4e91"]}'
        gzip_value = str_util.gzip_encode(value)
        value1 = str_util.gzip_decode(gzip_value)
        assert value1 == json_value # 压缩之后会将 dict 转码成字符串
        assert len(gzip_value) < len(value1)


    # zlib 压缩测试
    def test_zlib(self):
        value = {'a':[1,2,'呵xx呵', u'哈"哈', str_util.to_str('智汇云',encode='GBK')]}
        json_value = '{"a": [1, 2, "\\u5475xx\\u5475", "\\u54c8\\"\\u54c8", "\\u667a\\u6c47\\u4e91"]}'
        zlib_value = str_util.zlib_encode(value)
        value2 = str_util.zlib_decode(zlib_value)
        assert value2 == json_value # 压缩之后会将 dict 转码成字符串
        assert len(zlib_value) < len(value2)


    def test_MD5(self):
        # md5 测试
        assert str_util.MD5('123456') == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5(u'123456', u'') == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5('1234', '56') == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5(u'12345', u'6') == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5(123456) == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5(1234, 56) == 'e10adc3949ba59abbe56e057f20f883e'
        assert str_util.MD5('哈哈') == '8c8fa3529ee34d4e69a0baafb7069da3'
        assert str_util.MD5(u'哈哈') == '8c8fa3529ee34d4e69a0baafb7069da3'

        # is_MD5 测试
        assert str_util.is_MD5('e10adc3949ba59abbe56e057f20f883e')
        assert str_util.is_MD5(str_util.MD5(u'哈哈'))
        assert not str_util.is_MD5('e10adc3949ba59abbe56e057f20f883') # 长度不对
        assert not str_util.is_MD5('e10adc3949ba59abbe56e057f20f88xy') # 包含字母: xy
        assert not str_util.is_MD5('e10adc3949ba59abbe56e057f20f88哈哈') # 包含中文

    def test_mobile(self):
        # is_mobile 测试
        assert str_util.is_mobile("13800138000")
        assert str_util.is_mobile("8613800138000") == False
        assert str_util.is_mobile("+8613800138000") == False
        assert str_util.is_mobile("1380013800o") == False
        assert str_util.is_mobile("188324005509") == False
        assert str_util.is_mobile(u"13800138000")
        assert str_util.is_mobile(unicode("13800138000"))
        assert str_util.is_mobile(u"1883240055哈") == False
        assert str_util.is_mobile("1883240055哈") == False
        assert str_util.is_mobile(13800138000)

    def test_email(self):
        # is_email 测试
        assert str_util.is_email("13800138000") == False
        assert str_util.is_email("13800138000@qq.com")
        assert str_util.is_email("13800138000#qq.com") == False
        assert str_util.is_email("13800138000?qq.com") == False
        assert str_util.is_email("@163.com.cn") == False
        assert str_util.is_email("163.com.test-3_3434@") == False
        assert str_util.is_email("test@163.com.cn")
        assert str_util.is_email("test-3_3434@163.co-m.cn")
        assert str_util.is_email(u"test@163.com.cn")
        assert str_util.is_email(unicode("test@163.com.cn"))
        # 邮箱不允许中文
        assert str_util.is_email("是13800138000@qq.com") == False
        assert str_util.is_email(u"是13800138000@qq.com") == False

    def test_create_random(self):
        # create_random 测试
        population = string.ascii_letters + string.digits

        # 位数必须大于 0
        has_error = False
        try:
            s = str_util.create_random(0)
        except:
            has_error = True
        assert has_error

        has_error2 = False
        try:
            s = str_util.create_random(-1)
        except:
            has_error2 = True
        assert has_error2

        s = str_util.create_random(1)
        assert len(s) == 1
        assert s in population

        ss = str_util.create_random(64)
        assert len(ss) == 64
        for s0 in ss:
            assert s0 in population

        # 判断重复函数(这里要求必须生指定的才算)
        for i in range(5):
            s1 = str_util.create_random(k=1, repeat_fun=lambda x:x!='5')
            assert s1 == '5'


if __name__ == "__main__":
    unittest.main()

