#!python
# -*- coding:utf-8 -*-

'''
公用函数 cache.py 的测试类
Created on 2014/7/16
Updated on 2016/3/7
@author: Holemar
'''
import copy
import time
import logging
import datetime
import unittest

import __init__
from libs_my import cache

# 测试用的类
class TestObject(object):
    def __init__(self, a, b=None):
        self.a = a
        self.b = b

    def __eq__(self, obj):
        return self.a == getattr(obj, 'a', None) and self.b == getattr(obj, 'b', None)

class CacheTest(unittest.TestCase):
    def setUp(self):
        u"""初始化"""
        super(CacheTest, self).setUp()

        # 是否缓存的标识
        self.cache_time = 0
        # 先清空之前的缓存,避免多次测试互相干扰
        cache.clear()
        assert cache.keys('.*') == []

    def test_base(self):
        u'''基础函数测试'''
        logging.warn(u'测试 get put 等基本函数')
        key = '123*456'
        value = """ '"'"xxx.!1!1@#$%^&*()_+=-\|][{}?><,.;:'"+-*/.25eww """ # 特殊字符串
        assert cache.get(key) == None
        cache.put(key, value)
        assert cache.get(key) == value
        assert cache.exists(key) == True
        assert cache.pop(key) == value
        assert cache.exists(key) == False
        assert cache.get(key) == None
        assert cache.get(key, 0) == 0 # 默认值检查
        # 特殊参数检查
        assert cache.get(None) == None
        assert cache.exists(None) == False
        assert cache.pop(None) == None
        assert cache.pop(None, None) == []
        assert cache.keys(None) == []

    def test_incr_decr(self):
        logging.warn(u'测试 自增、自减 函数')
        key1 = 'key1'
        assert cache.incr(key1) == 1
        assert cache.incr(key1) == 2
        assert cache.incr(key1, 10) == 12
        assert cache.incr(key1) == 13
        assert cache.decr(key1) == 12
        assert cache.incr('mykey', 10) == 10

        key2 = 'key2'
        assert cache.decr(key2) == -1
        assert cache.decr(key2) == -2
        assert cache.decr(key2, 10) == -12
        assert cache.decr(key2) == -13
        assert cache.incr(key2) == -12
        assert cache.decr('mykey2', 10) == -10

    def test_timeout(self):
        logging.warn(u'测试 过期时间')
        key1 = 'key1'
        key2 = 'key2'
        value = 'value1'

        # 设置过期时间 0.1 秒，过期前取值正常返回
        assert cache.put(key1, value, 0.1) # put 函数的过期测试
        assert cache.get(key1) == value
        assert cache.exists(key1) == True

        assert cache.put(key2, value)
        assert cache.expire(key2, 0.1) # expire 函数的过期测试
        assert cache.get(key2) == value
        assert cache.exists(key2) == True

        # 让它们过期
        time.sleep(0.11)
        assert cache.exists(key1) == False
        assert cache.exists(key2) == False

    def test_chinese(self):
        u'''中文检查'''
        logging.warn(u'测试 中文缓存')
        key = '123*45测试key。6'
        value = u"""
            '"'"哈哈嘿嘿|“‘’”
            """ # unicode 中文
        cache.put(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        value = """
            '"'"哈哈嘿嘿|“‘’”
           """ # str 中文
        cache.put(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        cache.pop(key)

    def test_keys(self):
        logging.warn(u'测试 keys 函数及返回长度检查')
        cache.put('a1', 1)
        cache.put('b1', 1555L)
        cache.put('c1', 1)
        cache.put('d1', 1, 0.01)
        time.sleep(0.02) # 让上面的过期
        assert cache.get('d1') == None
        cache.put('a2', 1)
        cache.put('b2', 1.0245)
        cache.put('c2', 1)
        assert set(cache.keys('a')) == set(['a1', 'a2'])
        assert set(cache.keys('.1')) == set(['a1', 'b1', 'c1'])
        assert len(cache.keys('.')) == 6
        assert cache.pop('a1', 'a2') == [1,1] # 取多个值,并删除
        assert cache.pop('a1') == None
        assert set(cache.pop('a1', 'b1', 'b2')) == set([1555L, 1.0245]) # 取多个值,并删除
        assert cache.pop('a1', 'b1', 'b2') == []

    def test_set_json(self):
        logging.warn(u'测试 get put 函数存储非字符串情况')
        key = '""""哈哈'
        value = {u"aa":u"哈哈", "bb":"嘿嘿", 0:[1,2,3],2:{'cc':[2.01,547L]}, '嘿嘿':set(u'哆来咪')} # 嵌套json
        cache.put(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        assert cache.pop(key) is None
        value = datetime.datetime.now() # datetime 类型的存储
        cache.put(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        assert cache.pop(key) is None
        value = time.localtime() # time 类型的存储
        cache.put(key, value)
        assert time.mktime(cache.get(key)) == time.mktime(value) # 避免夏令时引起的判断不同
        assert time.mktime(cache.pop(key)) == time.mktime(value) # 避免夏令时引起的判断不同
        assert cache.pop(key) is None


    def test_fn(self):
        logging.warn(u'调用 fn 函数时不写参数')

        @cache.fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        assert self.cache_time == 0
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 使用了缓存

    def test_fn_timeout(self):
        cache.init(fn_timeout = 0.1)
        logging.warn(u'fn 写上缓存时间的调用方式,缓存0.1秒')

        @cache.fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @cache.fn(0.1) # 相当于: fn(0.1) (test2) (arg1, arg2)
        def test2(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @cache.fn(timeout=0.1) # 相当于: fn(timeout=0.1) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"a=%s, b=%s, c=%s", a, b, c)
            return a+b

        assert self.cache_time == 0
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 3  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 3  # 使用了缓存
        cache.clear()
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 6  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 6  # 使用了缓存

        time.sleep(0.11)  # 暂停一下,让缓存过期
        logging.warn(u'缓存超时后')
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 使用了缓存
        cache.init(fn_timeout = 30*60) # 修改回去，避免干扰

    def test_fn_judge(self):
        logging.warn(u'judge 判断')

        @cache.fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"test3 a=%s, b=%s, c=%s", a, b, c)
            return {'result':a, 'x':a+b}

        assert self.cache_time == 0
        test3(0,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 没有缓存
        test3(0,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 使用了缓存
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 2  # 没有缓存(可能是参数不同,也可能是返回值不允许缓存)
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 3  # 确定了没有缓存(确定是返回值不允许缓存)
        test3(0,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 3  # 使用了缓存

    def test_fn_judge2(self):
        logging.warn(u'只传 judge,不传 timeout')

        @cache.fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"test3 a=%s, b=%s, c=%s", a, b, c)
            return {'result':a, 'x':a+b}

        @cache.fn(judge=lambda s: s.get('result')==0) # 相当于: fn(judge=xxx) (test4) (arg1, arg2)
        def test4(a, b=2, c=None):
            self.cache_time += 1
            logging.warn(u"test4 a=%s, b=%s, c=%s", a, b, c)
            return {'result':a, 'x':a+b}

        assert self.cache_time == 0
        test4(0,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 没有缓存
        test4(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 2  # 没有缓存
        test4(0,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 2  # 使用了缓存
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 3  # 确定了没有缓存(确定是返回值不允许缓存)

    def test_fn_result(self):
        logging.warn(u'缓存 json / number / bool 类型的值')

        @cache.fn(judge=False) # 相当于: fn(judge=False) (test5) (arg1, arg2)
        def test5(a):
            self.cache_time += 1
            logging.warn(u"test5 a=%s", a)
            return a

        assert self.cache_time == 0
        assert None == test5(None)
        assert self.cache_time == 1  # 没有缓存
        assert None == test5(None)
        assert self.cache_time == 1  # 使用了缓存
        assert False == test5(False)
        assert self.cache_time == 2  # 没有缓存
        assert False == test5(False)
        assert self.cache_time == 2  # 使用了缓存
        assert 0 == test5(0)
        assert self.cache_time == 3  # 没有缓存
        assert 0 == test5(0)
        assert self.cache_time == 3  # 使用了缓存
        assert '0' == test5('0')
        assert self.cache_time == 4  # 没有缓存
        assert '0' == test5('0')
        assert self.cache_time == 4  # 使用了缓存
        assert {} == test5({})
        assert self.cache_time == 5  # 没有缓存
        assert {} == test5({})
        assert self.cache_time == 5  # 使用了缓存
        assert [] == test5([])
        assert self.cache_time == 6  # 没有缓存
        assert [] == test5([])
        assert self.cache_time == 6  # 使用了缓存
        assert 'None' == test5('None') # 字符串类型的参数 'None' 与 None, 0 与 '0', False 与 'False' 不同
        assert self.cache_time == 7  # 没有缓存
        assert 'None' == test5('None')
        assert self.cache_time == 7  # 使用了缓存
        assert None == test5(None)
        assert self.cache_time == 7  # 使用了缓存
        assert 'False' == test5('False')
        assert self.cache_time == 8  # 没有缓存
        assert 'False' == test5('False')
        assert self.cache_time == 8  # 使用了缓存
        assert False == test5(False)
        assert self.cache_time == 8  # 使用了缓存


    def test_fn_object(self):
        logging.warn(u'缓存 object 类型的值')

        @cache.fn
        def test_object(a):
            self.cache_time += 1
            logging.warn(u"test_object a=%s", a)
            return a

        a = TestObject(u'哈哈1', ['呵呵', set('gogo')])
        b = TestObject('哈哈2', [u'呵呵2', set('gogo')])
        assert self.cache_time == 0
        assert a == test_object(a)
        assert self.cache_time == 1  # 没有缓存
        assert a == test_object(a)
        assert self.cache_time == 1  # 使用了缓存
        assert b == test_object(b)
        assert self.cache_time == 2  # 没有缓存
        assert b == test_object(b)
        assert self.cache_time == 2  # 使用了缓存

    def test_fn_mul(self):
        u'''复杂类型参数'''

        @cache.fn(judge=False) # 相当于: fn(judge=False) (test5) (arg1, arg2)
        def test5(a):
            self.cache_time += 1
            logging.warn(u"test5 a=%s", a)
            return a

        assert self.cache_time == 0
        now = datetime.datetime.now()
        arg1 = {'aa':4.55, 'b1':{'ll':66.55, u'测试':554, '测试2':u'测试2值', 'c':[1,u'哈啊', '啊哈'], 3:now}}
        assert arg1 == test5(copy.deepcopy(arg1)) # 不能改变传过来的参数
        assert self.cache_time == 1  # 没有缓存
        assert arg1 == test5(copy.deepcopy(arg1))
        assert self.cache_time == 1  # 使用了缓存
        arg2 = 44444444444444444444444444466666666L
        assert arg2 == test5(arg2)
        assert self.cache_time == 2  # 没有缓存
        assert arg2 == test5(arg2)
        assert self.cache_time == 2  # 使用了缓存
        arg3 = set([1,u'哈啊', '啊哈'])
        assert arg3 == test5(arg3)
        assert self.cache_time == 3  # 没有缓存
        assert arg3 == test5(arg3)
        assert self.cache_time == 3  # 使用了缓存
        arg4 = (arg1,arg2,arg3,)
        assert arg4 == test5(arg4)
        assert self.cache_time == 4  # 没有缓存
        assert arg4 == test5(arg4)
        assert self.cache_time == 4  # 使用了缓存
        arg5 = {'b1':{'测试2':u'测试2值', u'测试':554, 'c':[1,u'哈啊', '啊哈'],'ll':66.55, 3:now},'aa':4.55} # dict 类型内容顺序测试
        assert arg1 == test5(arg5)
        #todo:dict类型内容顺序不同,应该允许缓存,但事实上不行(缓存的key值不同导致)
        assert self.cache_time == 5  # 没有缓存
        assert arg1 == test5(arg5)
        assert self.cache_time == 5  # 使用了缓存
        # 缓存后,修改传入缓存的内容，看会不会影响缓存结果
        arg6 = copy.deepcopy(arg5)
        arg5['aa'] = 3 # 修改传入值
        res5 = test5(arg6)
        assert self.cache_time == 5  # 使用了缓存
        assert arg1 == res5
        assert arg5 != res5
        res5['aa'] = 3 # 修改返回值
        assert arg5 == res5
        res6 = test5(arg6)
        assert self.cache_time == 5  # 使用了缓存
        assert arg1 == res6

    def test_fn_name(self):
        u'''区分被 装饰器(Decorator) 包装的函数(单纯依靠 method.__module__, method.__name__ 是无法区分的),所以必须设置 name 参数'''

        def timeit(func):
            def wrapper(*args, **kwargs):
                res = func(*args, **kwargs)
                return res
            return wrapper

        @cache.fn(name='foo')
        @timeit # 相当于: timeit(foo)()
        def foo():
            self.cache_time += 1
            return 1

        @cache.fn(name='foo2')
        @timeit # 相当于: timeit(foo2)()
        def foo2():
            self.cache_time += 1
            return 2

        assert self.cache_time == 0
        assert 1 == foo()
        assert self.cache_time == 1  # 没有缓存
        assert 1 == foo()
        assert self.cache_time == 1  # 使用了缓存
        assert 2 == foo2()
        assert self.cache_time == 2  # 没有缓存
        assert 2 == foo2()
        assert self.cache_time == 2  # 使用了缓存

    def test_clear_expire(self):
        u'''删除过期测试'''
        logging.warn(u'测试 删除过期的缓存')
        key1 = 'key1'
        key2 = 'key2'
        value = 'value1'
        # 设置过期时间 0.1 秒，过期前取值正常返回
        assert cache.put(key1, value, 0.1) # put 函数的过期测试
        assert cache.put(key2, value)
        assert cache.expire(key2, 0.1) # expire 函数的过期测试

        # 让它们过期
        time.sleep(0.11)
        cache._clear_expire() # 删除过期缓存
        assert len(cache._expire_cache) == 0
        assert len(cache._value_cache) == 0


if __name__ == "__main__":
    unittest.main()

