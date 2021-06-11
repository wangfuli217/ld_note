#python
# -*- coding:utf-8 -*-
'''
公用函数(django 页面中间件) django_cache.py 的测试
Created on 2016/3/2
Updated on 2016/7/1
@author: Holemar
'''
import time
import copy
import logging
import datetime
import unittest

import __init__
from django.db import models
from django.test import TestCase
from django.conf import settings
from django.http import HttpResponse
from django.conf.urls import url
from django.views.generic import View
from django.views.decorators.cache import cache_page


# 如果有redis服务器的，则定义缓存配置信息。没有则使用默认的内存缓存
'''
settings.CACHES = {
        "default": {
            "BACKEND": "django_redis.cache.RedisCache",
            "LOCATION": "redis://127.0.0.1:6379/3",
            'TIMEOUT': 1, # 默认缓存时间
            "OPTIONS": {
                "CLIENT_CLASS": "django_redis.client.DefaultClient",
            }
        }
    }
'''

#from django.core.cache import cache
#from libs_my import django_cache # 必须导入，否则没有补丁
from libs_my.django_cache import cache, pop, fn # 这样可以替换上面两行

# 定义页面
@cache_page(2)
def now_page(request):
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    t = request.GET.get('t', None)
    context = u'now is %s, t is %s' % (now, t)
    return HttpResponse(context)

class TestView(View):
    def get(self, request, *args, **kwargs):
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        t = request.GET.get('t', None)
        context = u'now is %s, t is %s' % (now, t)
        return HttpResponse(context)

class PageTest(TestCase):
    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(PageTest, cls).setUpClass()

        # 页面地址加入到配置中(由于缓存必须先设了配置之后才可以导入，所以这里延后加入地址)
        settings.ROOT_URLCONF = [
                url(r'^now/$', now_page),
                url(r'^test/$', cache_page(60*60)(TestView.as_view())), # View 类型得这样写缓存
            ]

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(PageTest, cls).tearDownClass()
        # 还原配置信息
        settings.ROOT_URLCONF = []

    def test_page(self):
        u'''页面请求测试'''
        logging.info(u'页面请求测试')
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        response = self.client.get('/now/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s, t is None' % now)

        response = self.client.get('/test/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s, t is None' % now)

        time.sleep(1) # 睡 1 秒后，返回结果还是没变，说明缓存起作用了

        response = self.client.get('/now/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s, t is None' % now)

        response = self.client.get('/test/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s, t is None' % now)


# 测试用的类
class TestObject(object):
    def __init__(self, a, b=None):
        self.a = a
        self.b = b

    def __eq__(self, obj):
        return self.a == getattr(obj, 'a', None) and self.b == getattr(obj, 'b', None)

class FunctionTest(unittest.TestCase):
    def setUp(self):
        u"""初始化"""
        super(FunctionTest, self).setUp()
        # 是否缓存的标识
        self.cache_time = 0
        # 先清空之前的缓存,避免多次测试互相干扰
        cache.clear()
        if getattr(cache, 'keys', None):
            assert cache.keys('*') == []

    def test_base(self):
        u'''基础函数测试'''
        logging.info(u'测试 get put 等基本函数')
        key = '123*456'
        value = """ '"'"xxx.!1!1@#$%^&*()_+=-\|][{}?><,.;:'"+-*/.25eww """ # 特殊字符串
        assert cache.get(key) == None
        cache.set(key, value)
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
        if getattr(cache, 'keys', None):
            assert cache.keys(None) == []

    def test_pop(self):
        u'''pop函数测试'''
        logging.info(u'测试 pop 函数')
        key = '123*456'
        value = """ '"'"xxx.!1!1@#$%^&*()_+=-\|][{}?><,.;:'"+-*/.25eww """ # 特殊字符串
        cache.set(key, value)
        assert pop(key) == value
        assert cache.exists(key) == False
        cache.set('a1', value)
        cache.set('a2', value)
        assert pop('a2', 'a1') == [value, value]
        # 特殊参数检查
        assert pop(None) == None
        assert pop(None, None) == []

    def test_incr_decr(self):
        logging.info(u'测试 自增、自减 函数')
        key1 = 'key1'
        cache.set(key1, 0) # 必须先设置，才可以使用 incr, decr
        assert cache.incr(key1) == 1
        assert cache.incr(key1) == 2
        assert cache.incr(key1, 10) == 12
        assert cache.incr(key1) == 13
        assert cache.decr(key1) == 12

        key2 = 'key2'
        cache.set(key2, 0)
        assert cache.decr(key2) == -1
        assert cache.decr(key2) == -2
        assert cache.decr(key2, 10) == -12
        assert cache.decr(key2) == -13
        assert cache.incr(key2) == -12

    def test_timeout(self):
        logging.info(u'测试 过期时间')
        key1 = 'key1'
        key2 = 'key2'
        value = 'value1'

        # 设置过期时间 1 秒，过期前取值正常返回
        cache.set(key1, value, timeout=1) # set 函数的过期测试
        assert cache.get(key1) == value
        assert cache.exists(key1) == True

        # expire 函数的过期测试(内存缓存时，没有这个函数)
        cache.set(key2, value)
        cache.expire(key2, 1)
        assert cache.get(key2) == value
        assert cache.exists(key2) == True

        # 让它们过期
        time.sleep(1.01)
        assert cache.exists(key1) == False
        assert cache.exists(key2) == False

    def test_chinese(self):
        u'''中文检查'''
        logging.info(u'测试 中文缓存')
        key = u'123*45测试key。6'
        value = u"""
            '"'"哈哈嘿嘿|“‘’”
            """ # unicode 中文
        cache.set(key, value)
        assert cache.get(key) == value
        value = """
            '"'"哈哈嘿嘿|“‘’”
           """ # str 中文
        cache.set(key, value)
        assert cache.get(key) == value

    def test_keys(self):
        if not getattr(cache, 'keys', None):
            logging.info(u'缓存里面没有 keys 函数，无法测试')
            return

        logging.info(u'测试 keys 函数及返回长度检查')
        cache.set('a1', 1)
        cache.set('b1', 1555L)
        cache.set('c1', 1)
        cache.set('d1', 2, -1) # 已过期
        assert cache.get('d1') == None
        cache.set('a2', 1)
        cache.set('b2', 1.0245)
        cache.set('c2', 1)
        assert set(cache.keys('a*')) == set(['a1', 'a2'])
        assert set(cache.keys('*1')) == set(['a1', 'b1', 'c1'])
        assert len(cache.keys('*')) == 6
        assert cache.pop('a1', 'a2') == [1,1] # 取多个值,并删除
        assert cache.pop('a1') == None
        assert set(cache.pop('a1', 'b1', 'b2')) == set([1555L, 1.0245]) # 取多个值,并删除
        assert cache.pop('a1', 'b1', 'b2') == []

    def test_set_json(self):
        logging.info(u'测试 get put 函数存储非字符串情况')
        key = u'""""哈哈'
        value = {u"aa":u"哈哈", "bb":"嘿嘿", 0:[1,2,3],2:{'cc':[2.01,547L]}, '嘿嘿':set(u'哆来咪')} # 嵌套json
        cache.set(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        assert cache.pop(key) is None
        value = datetime.datetime.now() # datetime 类型的存储
        cache.set(key, value)
        assert cache.get(key) == value
        assert cache.pop(key) == value
        assert cache.pop(key) is None
        value = time.localtime() # time 类型的存储
        cache.set(key, value)
        assert time.mktime(cache.get(key)) == time.mktime(value) # 避免夏令时引起的判断不同
        assert time.mktime(cache.pop(key)) == time.mktime(value) # 避免夏令时引起的判断不同
        assert cache.pop(key) is None


    def test_fn(self):
        logging.info(u'调用 fn 函数时不写参数')

        @cache.fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        assert self.cache_time == 0
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 使用了缓存

    def test_fn2(self):
        logging.info(u'调用 fn 函数时不写参数')

        @fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        assert self.cache_time == 0
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 1  # 使用了缓存

    def test_fn_timeout(self):
        logging.info(u'fn 写上缓存时间的调用方式,缓存1秒')
        cache.default_timeout = 1

        @cache.fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @cache.fn(1) # 相当于: fn(1) (test2) (arg1, arg2)
        def test2(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @cache.fn(timeout=1) # 相当于: fn(timeout=1) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"a=%s, b=%s, c=%s", a, b, c)
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

        time.sleep(1.1)  # 暂停一下,让缓存过期
        logging.info(u'缓存超时后')
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 使用了缓存

    def test_fn_timeout2(self):
        logging.info(u'fn 写上缓存时间的调用方式,缓存1秒')
        cache.default_timeout = 1

        @fn # 相当于: fn(test1) (arg1, arg2)
        def test1(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test1 a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @fn(1) # 相当于: fn(1) (test2) (arg1, arg2)
        def test2(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"a=%s, b=%s, c=%s", a, b, c)
            return a+b

        @fn(timeout=1) # 相当于: fn(timeout=1) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"a=%s, b=%s, c=%s", a, b, c)
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

        time.sleep(1.1)  # 暂停一下,让缓存过期
        logging.info(u'缓存超时后')
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 没有缓存
        test1(1,b=22,c={'a':'aa','b':'bb'})
        test2(1,b=22,c={'a':'aa','b':'bb'})
        test3(1,b=22,c={'a':'aa','b':'bb'})
        assert self.cache_time == 9  # 使用了缓存

    def test_fn_judge(self):
        logging.info(u'judge 判断')

        @cache.fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test3 a=%s, b=%s, c=%s", a, b, c)
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

    def test_fn2_judge(self):
        logging.info(u'judge 判断')

        @fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test3 a=%s, b=%s, c=%s", a, b, c)
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
        logging.info(u'只传 judge,不传 timeout')

        @cache.fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test3 a=%s, b=%s, c=%s", a, b, c)
            return {'result':a, 'x':a+b}

        @cache.fn(judge=lambda s: s.get('result')==0) # 相当于: fn(judge=xxx) (test4) (arg1, arg2)
        def test4(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test4 a=%s, b=%s, c=%s", a, b, c)
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

    def test_fn2_judge2(self):
        logging.info(u'只传 judge,不传 timeout')

        @fn(1, judge=lambda s: s.get('result')==0) # 相当于: fn(1, judge=xxx) (test3) (arg1, arg2)
        def test3(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test3 a=%s, b=%s, c=%s", a, b, c)
            return {'result':a, 'x':a+b}

        @fn(judge=lambda s: s.get('result')==0) # 相当于: fn(judge=xxx) (test4) (arg1, arg2)
        def test4(a, b=2, c=None):
            self.cache_time += 1
            logging.info(u"test4 a=%s, b=%s, c=%s", a, b, c)
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
        logging.info(u'缓存 json / number / bool 类型的值')

        @cache.fn(judge=False) # 相当于: fn(judge=False) (test5) (arg1, arg2)
        def test5(a):
            self.cache_time += 1
            logging.info(u"test5 a=%s", a)
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

    def test_fn_result2(self):
        logging.info(u'缓存 json / number / bool 类型的值')

        @fn(judge=False) # 相当于: fn(judge=False) (test5) (arg1, arg2)
        def test5(a):
            self.cache_time += 1
            logging.info(u"test5 a=%s", a)
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
        logging.info(u'缓存 object 类型的值')

        @cache.fn
        def test_object(a):
            self.cache_time += 1
            logging.info(u"test_object a=%s", a)
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

    def test_fn_object2(self):
        logging.info(u'缓存 object 类型的值')

        @fn
        def test_object(a):
            self.cache_time += 1
            logging.info(u"test_object a=%s", a)
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
            logging.info(u"test5 a=%s", a)
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

    def test_fn_mul2(self):
        u'''复杂类型参数'''

        @fn(judge=False) # 相当于: fn(judge=False) (test5) (arg1, arg2)
        def test5(a):
            self.cache_time += 1
            logging.info(u"test5 a=%s", a)
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

    def test_fn_name2(self):
        u'''区分被 装饰器(Decorator) 包装的函数(单纯依靠 method.__module__, method.__name__ 是无法区分的),所以必须设置 name 参数'''

        def timeit(func):
            def wrapper(*args, **kwargs):
                res = func(*args, **kwargs)
                return res
            return wrapper

        @fn(name='foo')
        @timeit # 相当于: timeit(foo)()
        def foo():
            self.cache_time += 1
            return 1

        @fn(name='foo2')
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


# 定义测试 model
class Person(models.Model):
    class Meta:
        db_table = 'persons'
        app_label = 'test'

    created_at = models.DateTimeField('created_at', auto_now_add = True)
    updated_at = models.DateTimeField('updated_at', auto_now = True)
    name = models.CharField("name", max_length = 20)
    age = models.IntegerField("age")

    def __eq__(self, obj):
        return (self.id == obj.id and
            self.name == obj.name and
            self.age == obj.age and
            self.created_at == obj.created_at and
            self.updated_at == obj.updated_at
            )


class ModelTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(ModelTest, cls).setUpClass()
        # 加入测试 model
        settings.INSTALLED_APPS = ['test']

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(ModelTest, cls).tearDownClass()
        # 还原配置信息
        settings.INSTALLED_APPS = []

    def test_model(self):
        u'''django.db.models.Model 测试'''
        logging.info(u'Model 测试')
        p = Person(name = "a", age = 111)
        cache.set('my_key', p)
        p2 = cache.get('my_key')
        assert id(p) != id(p2) # 不同的内存地址(经过了redis)
        assert p == p2 # 交给 model 里面的 __eq__ 函数比较

        # 嵌套测试
        value2 = {u'测试值':[p, p2]}
        cache.set('my_key2', value2)
        res = cache.get('my_key2')
        assert id(value2) != id(res) # 不同的内存地址
        assert value2.keys() == res.keys()
        assert value2 == res

    def test_fn_model(self):
        logging.info(u'fn 参数包含 Model 的测试')
        self.cache_time = 0
        @cache.fn
        def test1(model, model_list=None):
            self.cache_time += 1
            logging.info(u"test1 model=%s, model_list=%s", model, model_list)
            model_list.append(model)
            return model_list

        p = Person(name = u"呵呵", age = 111)
        p2 = Person(name = "哈哈", age = 22)

        # 没有缓存时
        res1 = test1(p, model_list=[p, p2])
        assert self.cache_time == 1
        assert res1 == [p, p2, p]

        # 使用缓存
        res2 = test1(p, model_list=[p, p2])
        assert self.cache_time == 1
        assert res1 == res2

        # 不能使用缓存
        res3 = test1(p2, model_list=[p2, p])
        assert self.cache_time == 2
        assert res1 != res3
        assert res3 == [p2, p, p2]


if __name__ == "__main__":
    unittest.main()

