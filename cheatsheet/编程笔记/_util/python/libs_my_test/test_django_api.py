#python
# -*- coding:utf-8 -*-
'''
公用函数(django API接口修饰器) django_api.py 的测试
Created on 2016/3/1
Updated on 2016/3/8
@author: Holemar
'''
import time
import logging
import datetime
import unittest

import __init__
from django.test import TestCase
from django.conf import settings
from django.http import HttpResponse
from django.conf.urls import url

from libs_my import str_util, django_api

@django_api.route
def now_page(request, **kw):
    t = request.GET.get('t', None)
    t2 = kw.get('t', None)
    if t:
        time.sleep(float(t))
    return {"t":t, 't2':t2}


# 用 Filter 类获取日志信息
NOW_LOG_RECORD = None
class TestFilter(logging.Filter):
    def filter(self, record):
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = record # 把 Filter 获取到的日志信息传递出去，供测试使用
        return True
django_api.logger.addFilter(TestFilter())


class DjangoApiTest(TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(DjangoApiTest, cls).setUpClass()

        # 定义 URL 配置信息
        settings.ROOT_URLCONF = [
                url(r'^now/$', now_page),
            ]

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(DjangoApiTest, cls).tearDownClass()
        # 还原配置信息
        settings.ROOT_URLCONF = []

    def test_now_page(self):
        logging.info(u'参数接收测试')
        response = self.client.get('/now/?t=0.0001')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(str_util.to_json(response.content), {'t':'0.0001', 't2':'0.0001'})

    def test_warn_time(self):
        logging.info(u'延迟到警告时间的访问测试')

        django_api.init(warn_time=-1) # 设置过期时间为必然过期的
        response = self.client.get('/now/?t=0.0001')
        self.failUnlessEqual(response.status_code, 200)
        self.failUnlessEqual(str_util.to_json(response.content), {'t':'0.0001', 't2':'0.0001'})

        global NOW_LOG_RECORD
        record = NOW_LOG_RECORD
        assert record is not None
        assert record.levelno == logging.WARNING
        assert u'接口耗时太长' in record.msg


if __name__ == "__main__":
    unittest.main()

