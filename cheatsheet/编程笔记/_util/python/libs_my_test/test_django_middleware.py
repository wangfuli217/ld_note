#python
# -*- coding:utf-8 -*-
'''
公用函数(django 页面中间件) django_middleware.py 的测试
Created on 2016/2/29
Updated on 2016/8/29
@author: Holemar
'''
import re
import time
import random
import logging
import datetime
import unittest
import threading

import __init__
from django.test import TestCase
from django.conf import settings
from django.http import HttpResponse
from django.conf.urls import url


def now_page(request):
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    context = 'now is %s' % now
    t = request.GET.get('t', None)
    if t:
        time.sleep(float(t))
    return HttpResponse(context)

def ip_page(request):
    forward_ip = request.META.get("HTTP_X_FORWARDED_FOR", None)
    real_ip = request.META.get("HTTP_X_REAL_IP", None)
    remote_ip = request.META.get('REMOTE_ADDR', None)
    context = "HTTP_X_FORWARDED_FOR:%s, HTTP_X_REAL_IP:%s, REMOTE_ADDR:%s" % (forward_ip, real_ip, remote_ip)
    return HttpResponse(context)


# 用 Filter 类获取日志信息
NOW_LOG_RECORD = []
class TestFilter(logging.Filter):
    def filter(self, record):
        global NOW_LOG_RECORD
        NOW_LOG_RECORD.append(record) # 把 Filter 获取到的日志信息传递出去，供测试使用
        return True
from libs_my import django_middleware
django_middleware.logger.addFilter(TestFilter())


def _send(client):
    sleep_time = random.random()
    try:
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        response = client.get('/now/?t=%.4f' % sleep_time)
        assert response.status_code == 200
        assert response.content == 'now is %s' % now
    except Exception, e:
        django_middleware.logger.error(u'延迟到警告时间的访问测试，出现异常，睡眠时间:%s', sleep_time, exc_info=True)


class MiddlewareTest(TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(MiddlewareTest, cls).setUpClass()

        # 定义 URL 配置信息
        settings.ROOT_URLCONF = [
                url(r'^$', now_page),
                url(r'^now/$', now_page),
                url(r'^ip/$', ip_page),
            ]
        # 定义中间件
        settings.MIDDLEWARE_CLASSES = [
                'libs_my.django_middleware.XForwardedForMiddleware',
                'libs_my.django_middleware.RunTimeMiddleware',
            ]

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(MiddlewareTest, cls).tearDownClass()
        # 还原配置信息
        settings.ROOT_URLCONF = []
        settings.MIDDLEWARE_CLASSES = []

    def _test_now_page(self):
        u'''无延迟的访问测试'''
        logging.info(u'无延迟的访问测试')
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        response = self.client.get('/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s' % now)

        response = self.client.get('/now/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s' % now)

    def test_post(self):
        u'''post请求测试'''
        logging.info(u'post请求测试')
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        response = self.client.post('/now/', {'a':111, 'b':'%E5%93%88%E5%93%88%E5%93%88'})
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, u'now is %s' % now)

    def _test_warn_time(self):
        u'''延迟到警告时间的访问测试'''
        logging.info(u'延迟到警告时间的访问测试')
        # 约定 VIEW 超时警告时间，时间值改成必然超时的，以便测试
        django_middleware.VIEW_WARN_TIME = -1
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = []

        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        response = self.client.get('/now/?t=0.001')
        assert response.status_code == 200
        assert response.content == 'now is %s' % now

        assert len(NOW_LOG_RECORD) == 1
        record = NOW_LOG_RECORD[0]
        assert record is not None
        assert record.levelno == logging.WARNING
        assert u'请求超时' in record.msg
        assert record.duration # 有写入执行时间
        #assert record.duration >= 0.001 # float 数值有误差
        assert abs(record.duration - 0.001) < 0.001
        assert record.duration <= 0.01

        # 还原 VIEW 超时警告时间
        django_middleware.VIEW_WARN_TIME = 1

    def _test_warn_threading(self):
        u'''高并发时的延迟警告测试'''
        logging.info(u'高并发时的延迟警告测试')
        # 约定 VIEW 超时警告时间，时间值改成必然超时的，以便测试
        django_middleware.VIEW_WARN_TIME = -1
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = []

        lines = 100
        tl = []
        # 每次线程都等待所有的一起结束,避免主程序结束而线程未结束导致发不成功
        for i in range(lines):
            th = threading.Thread(target=_send, args=(self.client,))
            tl.append(th)
            th.start() # 启动这个线程
        for th in tl:
            th.join() # 等待线程返回

        assert len(NOW_LOG_RECORD) == lines
        for record in NOW_LOG_RECORD:
            assert record is not None
            assert record.levelno == logging.WARNING
            assert u'请求超时' in record.msg
            assert record.duration # 有写入执行时间
            assert record.url # 有写入请求 url
            sleep_time = float(re.search('\/now\/\?t=(0\.\d{4}?)', record.url).groups()[0])
            #assert record.duration >= sleep_time # float 数值有误差
            assert abs(record.duration - sleep_time) < 0.01
            assert record.duration <= sleep_time + 0.01

        # 还原 VIEW 超时警告时间
        django_middleware.VIEW_WARN_TIME = 3

    def _test_exception(self):
        u'''出错页面的访问测试'''
        logging.info(u'出错页面的访问测试')
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = []
        has_error = False
        try:
            response = self.client.get('/now/?t=xx') # 执行 float 的时候会报错
        except:
            has_error = True # 上面程序要求必须报错
        assert has_error
        assert len(NOW_LOG_RECORD) == 1
        record = NOW_LOG_RECORD[0]
        assert record is not None
        assert record.levelno == logging.ERROR
        assert u'请求' in record.msg and u'异常' in record.msg
        assert record.Exception
        assert type(record.Exception) == ValueError

    def _test_ip_page(self):
        u'''获取ip测试'''
        logging.info(u'获取ip测试')
        response = self.client.get('/ip/')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, 'HTTP_X_FORWARDED_FOR:None, HTTP_X_REAL_IP:None, REMOTE_ADDR:127.0.0.1')

        # 预设 header 后看结果(有 HTTP_X_FORWARDED_FOR 及 REMOTE_ADDR 时,优先取 HTTP_X_FORWARDED_FOR 的第一个值)
        header = {"HTTP_X_FORWARDED_FOR":'112.112.112.112,113.113.113.113', 'REMOTE_ADDR':'114.114.114.114'}
        response = self.client.get('/ip/?xxx=111', **header)
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, 'HTTP_X_FORWARDED_FOR:112.112.112.112,113.113.113.113, HTTP_X_REAL_IP:None, REMOTE_ADDR:112.112.112.112')

        # 预设 header 后看结果(有 HTTP_X_FORWARDED_FOR 、HTTP_X_REAL_IP 及 REMOTE_ADDR 时,优先取 HTTP_X_REAL_IP)
        header = {"HTTP_X_FORWARDED_FOR":'112.112.112.112,113.113.113.113', 'HTTP_X_REAL_IP':'115.115.115.115', 'REMOTE_ADDR':'114.114.114.114'}
        response = self.client.get('/ip/?xxx=111', **header)
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(response.content, 'HTTP_X_FORWARDED_FOR:112.112.112.112,113.113.113.113, HTTP_X_REAL_IP:115.115.115.115, REMOTE_ADDR:115.115.115.115')


if __name__ == "__main__":
    unittest.main()

