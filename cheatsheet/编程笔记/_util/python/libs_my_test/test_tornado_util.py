#!python
# -*- coding:utf-8 -*-
'''
公用函数(tornado 框架的请求处理) tornado_util.py 的测试
Created on 2014/7/16
Updated on 2016/3/4
@author: Holemar
'''
import json
import logging
import unittest

import __init__
from tornado.web import Application
from tornado.testing import AsyncHTTPTestCase

from libs_my import str_util, tornado_util, version


@tornado_util.fn(url=r"/version/?", auth_ips=[])
def get_version(self, **kwargs):
    u'''
    @summary: 查看版本号接口
    '''
    return version.get_version(**kwargs)


@tornado_util.fn(url=r"/test_param/(?P<num>[0-9]+)/(?P<service>[^/]*?)/",
                 paramter_error={'result':1, 'reason':u'请求参数错误'}, paramter_exclude=["'",])
def param_fun(self, num, service, a, b, c=2, **kwargs):
    u'''测试访问参数'''
    if self != None: assert self.request.uri.startswith('/test_param/') # 内部调用时 self 参数为 None,无法获取请求地址
    return {'self':str(self), 'num':num, 'service':service, 'a':a, 'b':b, 'c':c}

@tornado_util.fn(url=r"/test_ip", auth_ips=['117.121.21.90'], ip_limited={'result':2, 'reason':u'IP地址被限制'})
def ip_fun(self, **kwargs):
    u'''测试访问ip'''
    return {'result':0, 'reason':u'访问成功'}

# 这里测试用类的方式写,看是否会成功加载
class TestIpClass:
    @tornado_util.fn(url=r"/test_ip2", auth_ips=['117.121.21.91', '127.0.0.1'], ip_limited={'result':2, 'reason':u'IP地址被限制'})
    def ip_fun2(self, **kwargs):
        u'''测试访问ip'''
        assert self.request.headers.get('HOST', '').startswith('localhost:') # 由于本机测试,所以是 localhost + 随机端口
        return {'result':0, 'reason':u'访问成功'}

# 最后加上找不到页面时的处理
tornado_util.add_not_found()

class DealTest(AsyncHTTPTestCase):
    def get_app(self):
        app = tornado_util.get_apps()
        return Application( app )

    def test_version(self):
        u'''version接口,要求默认添加进来'''
        logging.warn(u'version接口测试。。。')
        response = self.fetch("/version")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!')
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result.get('result'), 0, u'返回结果的result值不对!')

    def test_param(self):
        u'''参数测试'''
        logging.warn(u'参数测试。。。')
        # 发请求调用,接收到的参数，全为字符串类型
        response = self.fetch("/test_param/555/run/?a=1&b=2&c=3&b=4&c=3")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result.get('num'), '555', u'返回结果的参数值不对!') # 接收url地址参数
        self.assertEqual(result.get('service'), 'run', u'返回结果的参数值不对!')
        self.assertEqual(result.get('a'), '1', u'返回结果的参数值不对!') # 接收到的参数，全为字符串类型
        self.assertEqual(result.get('b'), ['2','4'], u'返回结果的参数值不对!') # 多个同名参数
        self.assertEqual(result.get('c'), '3', u'返回结果的参数值不对!') # c 参数重复写了,要求会过滤掉
        self.assertTrue(result.get('self') != 'None', u'首参数有内容!') # 首参数是请求类

        # 发请求调用,请求参数不足时
        response = self.fetch("/test_param/555/run/?a=1")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result, {'result':1, 'reason':u'请求参数错误'}, u'返回结果的参数值不对!') # 返回参数错误提示

        # 内部程序直接调用,接收到的参数跟调用传参一样,且首参数为空
        result = param_fun(555, 'service', a=1, b=2, c=3)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!') # 内部程序直接调用,返回原始结果
        self.assertEqual(result.get('num'), 555, u'返回结果的参数值不对!') # 参数是传来的原始参数
        self.assertEqual(result.get('service'), 'service', u'返回结果的参数值不对!')
        self.assertEqual(result.get('a'), 1, u'返回结果的参数值不对!')
        self.assertEqual(result.get('b'), 2, u'返回结果的参数值不对!')
        self.assertEqual(result.get('c'), 3, u'返回结果的参数值不对!')
        self.assertEqual(result.get('self'), 'None', u'返回结果的参数值不对!')

        # 内部程序直接调用,参数错误时
        result = param_fun(555, 'service')
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!') # 内部程序直接调用,返回原始结果
        self.assertEqual(result, {'result':1, 'reason':u'请求参数错误'}, u'返回结果的参数值不对!') # 返回参数错误提示

        # 发请求调用,参数中带有非法字符时,返回参数错误
        response = self.fetch("/test_param/555/run/?a=1&c=3&b=4%27ss&c=3")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result, {'result':1, 'reason':u'请求参数错误'}, u'返回结果的参数值不对!') # 返回参数错误提示

        # 发请求调用,参数中带有非法字符时,返回参数错误
        response = self.fetch("/test_param/555/run/?a=1&b=2&c=3&b=s'ss&c=3")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result, {'result':1, 'reason':u'请求参数错误'}, u'返回结果的参数值不对!') # 返回参数错误提示

    def test_ip(self):
        u'''访问ip测试'''
        logging.warn(u'访问ip测试。。。')
        # 发请求调用,请求ip必定为 127.0.0.1, 但这ip不在信任ip列表里面,所以会被拒绝访问
        response = self.fetch("/test_ip?a=1&b=2&c=3")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result.get('result'), 2, u'返回结果的参数值不对!') # ip拒绝时的返回值

        # 发请求调用,请求ip必定为 127.0.0.1, 而这ip在信任ip列表里面,所以正常访问
        response = self.fetch("/test_ip2?a=1&b=2&c=3")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!') # 网页调用,返回字符串结果
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result.get('result'), 0, u'返回结果的参数值不对!') # 正常访问时的返回值

    def test_not_found(self):
        u'''访问一个找不到的地址时,要求能有默认返回值'''
        logging.warn(u'找不到页面测试。。。')
        response = self.fetch("/xxxx?aa=4444")
        result = response.body
        self.assertTrue(isinstance(result, basestring), u'返回结果的类型不对!')
        result = json.loads(result)
        self.assertTrue(isinstance(result, dict), u'返回结果的类型不对!')
        self.assertEqual(result.get('result'), -4, u'返回结果的result值不对!')


if __name__ == "__main__":
    unittest.main()
