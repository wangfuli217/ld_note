#!python
# -*- coding:utf-8 -*-
'''
http请求公用函数(http请求处理,使用第三方库 curl)
Created on 2014/7/16
Updated on 2016/2/16
@author: Holemar

说明：
    1.依赖第三方库: curl, pycurl
    2.curl的源码被修改过,它的 get、post 函数被修改成允许接收字符串类型的参数(原本只允许接收 dict 类型,然后将 dict 转成字符串)
'''
import urllib
import urllib2

import curl, pycurl # 依赖第三方库: curl, pycurl

from . import http_util
from .http_util import *

def send(url, param=None, method='GET', **kwargs):
    """
    @summary: 发出请求获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(get请求时会拼接到 url 上)
    @param {string} method: 提交方式,目前只支持 GET 和 POST 两种
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @return {string}: 返回获取的页面内容字符串
    """
    # 超时时间
    timeout = kwargs.get('timeout', http_util.CONFIG.get('timeout', None))
    res = None
    # curl 不支持 https 请求,这里为此做特殊处理
    if url.strip().lower().startswith('https://'):
        response = urllib2.urlopen(url=url, data=param, timeout=timeout)
        res = response.read()
        response.close()
    # 发起 curl 请求
    else:
        # 开启 http 对象
        __http = curl.Curl()
        # 设置超时时间
        if timeout:
            __http.set_timeout(timeout)
        # post 方式
        if method == 'POST':
            res = __http.post(url, param)
        # get 方式
        else:
            res = __http.get(url, param)
        __http.close()
    return res

# 重写 http_util 的函数
http_util.send = send

def _get(self, url="", params=None):
    "Ship a GET request for a specified URL, capture the response."
    if params:
        if isinstance(params, dict):
            params = urllib.urlencode(params)
        url += "&" if "?" in url else "?"
        url += params
    self.set_option(pycurl.HTTPGET, 1)
    return self.__request(url)

def _post(self, cgi, params=''):
    "Ship a POST request to a specified CGI, capture the response."
    self.set_option(pycurl.POST, 1)
    if params:
        if isinstance(params, dict):
            params = urllib.urlencode(params)
    self.set_option(pycurl.POSTFIELDS, params)
    return self.__request(cgi)

# 修改 curl.Curl 的 get、post 函数，改成允许接收字符串类型的参数(原本只允许接收 dict 类型,然后将 dict 转成字符串)
setattr(curl.Curl, 'get', _get)
setattr(curl.Curl, 'post', _post)
