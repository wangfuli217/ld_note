#!python
# -*- coding:utf-8 -*-

from . import log_util, http_util

# 日志长度不限
log_util.init(log_file=None, log_max=0)

def __deal(url, param=None, method='GET', return_json=True, judge=lambda res: res.get('success') == True, gzip=True, **kwargs):
    # get 方式
    if method == 'GET':
        res = http_util.get(url, param=param, return_json=return_json, gzip=gzip, **kwargs)
    # post 方式
    if method == 'POST':
        res = http_util.post(url, param=param, return_json=return_json, gzip=gzip, **kwargs)
    if return_json:
        if not isinstance(res, dict):
            log_util.error(u'返回内容类型不对,不是 dict 类型, 请求地址:%s, 参数:%s, 返回:%s', url, param, res)
            return res
    if judge:
        if not judge(res):
            log_util.error(u'返回内容验证不通过, 请求地址:%s, 参数:%s, 返回:%s', url, param, res)
            return res
    return res

# get 请求(简单封装一下)
def get(url, param=None, **kwargs):
    """get方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(会拼接到 url 上)
    @param {int} timeout: 超时时间(单位:秒)
    @param {boolean} return_json: 返回结果是否需要反 json 化
    @param {lambda} judge: 判断返回值是否正确的函数(默认返回json并且里面的 result 值为0)
    @return {string|dict}: 返回获取的页面内容字符串
    @example
        s = get('http://www.example.com?a=1&b=uu')
        s = get('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    return __deal(url, param=param, method='GET', **kwargs)

# post 请求(简单封装一下)
def post(url, param=None, **kwargs):
    """post方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(会拼接到 url 上)
    @param {int} timeout: 超时时间(单位:秒)
    @param {boolean} return_json: 返回结果是否需要反 json 化
    @param {lambda} judge: 判断返回值是否正确的函数(默认返回json并且里面的 result 值为0)
    @return {string|dict}: 返回获取的页面内容字符串
    @example
        s = post('http://www.example.com?a=1&b=uu')
        s = post('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    return __deal(url, param=param, method='POST', **kwargs)
