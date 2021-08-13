#!python
# -*- coding:utf-8 -*-
'''
http请求公用函数(http请求处理)
Created on 2014/7/16
Updated on 2016/9/5
@author: Holemar
'''
import os
import sys
import time
import urllib
import urllib2
import logging
import threading
from uuid import uuid4

from . import str_util

__all__=('init', 'get', 'post', 'send', 'multiple_send', 'urlencode', 'multiple_urlencode', 'choose_boundary', 'getRequestParams', 'get_content_type')
logger = logging.getLogger('libs_my.http_util')


# 请求默认值
CONFIG = {
    'timeout' : None, # {int} 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    'warning_time' : 5, # {int} 运行时间过长警告(超过这时间的将会警告,单位:秒)
    'send_json' : False, # {bool} 提交参数是否需要 json 化
    'return_json' : False, # {bool} 返回结果是否需要 json 化
    'threads' : False, # {bool} 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    'gzip' : False, # {string} 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    'repeat_time' : 1, # {int|long|float} 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    'judge' : (lambda result: result!=None), # {lambda} 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    'headers':{}, # {dict} 请求的头部信息
    'raise_error' : False, # {bool} 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    'default':None, # {任意} 默认的返回值
}

def init(**kwargs):
    '''
    @summary: 设置get和post函数的默认参数值
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    '''
    global CONFIG
    CONFIG.get('headers', {}).update(kwargs.pop('headers', {}))
    CONFIG.update(kwargs)

def send(url, param=None, method='GET', **kwargs):
    u"""
    @summary: 发出请求获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(get请求时会拼接到 url 上)
    @param {string} method: 提交方式,目前只支持 GET 和 POST 两种
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @return {string}: 返回获取的页面内容字符串
    """
    global CONFIG
    timeout = kwargs.get('timeout', CONFIG.get('timeout', None)) # 超时时间
    # 提交请求
    try:
        response = urllib2.urlopen(url=url, data=param, timeout=timeout)
        res = response.read()
        status_code = response.getcode() # 响应状态码,不是 200 时直接就报异常了
        response.close()
    except urllib2.HTTPError as e:
        status_code = e.code
        res = e.read()
    return status_code, res

def multiple_send(url, param=None, method='GET', **kwargs):
    u"""
    @summary: 发出请求获取网页内容(会要求服务器使用gzip压缩返回结果,也会提交文件等内容,需要服务器支持这些功能)
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(get请求时会拼接到 url 上)
    @param {string} method: 提交方式,目前只支持 GET 和 POST 两种
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {dict} headers: 请求的头部信息
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:deflate压缩)
    @return {string}: 返回获取的页面内容字符串
    """
    global CONFIG
    method = method.strip().upper()
    timeout = kwargs.get('timeout', CONFIG.get('timeout', None))
    headers = kwargs.get('headers', CONFIG.get('headers', {}))
    encoding = kwargs.get('encoding', 'gzip')
    boundary = kwargs.get('boundary', None)

    # 提交请求
    request = urllib2.Request(url=url, data=param, headers=headers)
    if encoding:
        if not isinstance(encoding, basestring):
            encoding = 'gzip'
        request.add_header('Accept-Encoding', encoding)
    if boundary:
        request.add_header('Content-Type', 'multipart/form-data; boundary=%s' % boundary)
    if method not in ('GET', 'POST'):
        request.get_method = lambda:method
    try:
        response = urllib2.urlopen(request, timeout=timeout)
        encoding = response.headers.get('Content-Encoding')
        status_code = response.getcode() # 响应状态码,不是 200 时直接就报异常了
        res = response.read()
        response.close()
    except urllib2.HTTPError as e:
        encoding = e.headers.get('Content-Encoding')
        status_code = e.code
        res = e.read()

    # 处理返回结果
    if encoding in ('gzip', 'deflate'):
        befor_len = len(res)
        if encoding == 'gzip':
            res = str_util.gzip_decode(res)
        elif encoding == 'deflate':
            res = str_util.zlib_decode(res)
        after_length = len(res)
        logger.info(u"%s %s 压缩请求: 解压前结果长度:%s, 解压后结果长度:%s, url:%s, param:%s", method, encoding, befor_len, after_length, url, param,
            extra={ 'method':method, 'url':url, 'param':param, 'result':res, 'encoding':encoding, 'befor_length':befor_len, 'after_length':after_length}
        )
    return status_code, res

def _handler(url, param=None, method='GET', **kwargs):
    '''请求处理函数
    1.判断请求是否成功,是否返回符合验证的值
    2.请求失败及返回值不对则重发请求
    3.返回结果是否需要 json 反序列化
    '''
    global CONFIG
    method = method.strip().upper()
    text = kwargs.get('default', CONFIG.get('default', None))
    _zip = kwargs.get('gzip', CONFIG.get('gzip', False))
    files = kwargs.get('files', None)
    return_json = kwargs.get('return_json', CONFIG.get('return_json', False))
    headers = kwargs.get('headers', CONFIG.get('headers', {}))
    repeat_time = int(kwargs.get('repeat_time', CONFIG.get('repeat_time', 1)))
    judge = kwargs.get('judge', CONFIG.get('judge', (lambda result: result!=None)))
    raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', False))

    # 允许出错时重复提交多次,只要设置了 repeat_time 的次数
    while repeat_time > 0:
        if _zip or files or headers or method not in ('GET', 'POST'):
            status_code, text = multiple_send(url, param=param, method=method, encoding=_zip, **kwargs)
        else:
            status_code, text = send(url, param=param, method=method, **kwargs)
        if status_code == 200: break

        # 请求异常,认为返回不正确
        repeat_time -= 1
        e = sys.exc_info()[1]
        logger.error(u"%s [red]请求错误:%s[/red]: url:%s, param:%s, 响应状态码:%s, 返回:%s", method, e, url, param, status_code, text,
            extra={'color':True, 'Exception':e, 'method':method, 'url':url, 'param':param, 'result':text}
        )
        if raise_error:
            raise

    try:
        # 转换 json 结果
        if return_json:
            res = str_util.to_str(text)
            res = str_util.to_json(res, raise_error=raise_error)
        else:
            res = text
        # 返回值正确
        if not judge or judge(res):
            return status_code, text, res
        # 返回值不正确
        else:
            logger.error(u"%s [yellow]返回不正确的值[/yellow]: url:%s, param:%s, files:%s, 返回:%s", method, url, param, files, res,
                extra={'color':True, 'method':method, 'url':url, 'param':param, 'result':res, 'files':files}
            )
    except Exception, e:
        logger.error(u"%s [red]接口返回内容错误[/red]: url:%s, param:%s, 返回:%s", method, url, param, res, exc_info=True,
            extra={'color':True, 'Exception':e, 'method':method, 'url':url, 'param':param, 'result':res}
        )
        if raise_error:
            raise

    return status_code, text, res

def _deal(url, param=None, method='GET', **kwargs):
    '''处理请求的主函数
    1.处理请求参数,转成url参数形式字符串,或者json字符串
    2.判断是否发起线程来请求
    3.记录日志
    '''
    start_time = time.time()
    global CONFIG
    res = kwargs.get('default', CONFIG.get('default', None))
    threads = kwargs.pop('threads', CONFIG.get('threads', False))
    warning_time = kwargs.get('warning_time', CONFIG.get('warning_time', 5))
    raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', False))
    files = kwargs.get('files', None)
    send_json = kwargs.get('send_json', CONFIG.get('send_json', False))
    headers = kwargs.get('headers', CONFIG.get('headers', {}))

    use_time = None
    try:
        # 提交异步请求(不处理返回结果)
        if threads:
            kwargs['threads'] = False # 避免递归发起线程
            th = threading.Thread(target=_deal, kwargs=dict(url=url, param=param, method=method,**kwargs))
            th.start() # 启动这个线程
            return th # 返回这个线程,以便 join 多个异步请求

        url = str_util.to_str(url)
        method = method.strip().upper()
        # get 方式的参数处理
        if method == 'GET':
            if param:
                # 参数拼接
                url += "&" if "?" in url else "?"
                url += urlencode(param)
            param = None
        # post、put、delete、patch、options 方式的参数处理
        else:
            if files:
                boundary = choose_boundary()
                kwargs['boundary'] = boundary
                param = multiple_urlencode(param, files=files, boundary=boundary)
            elif send_json:
                param = param if isinstance(param, basestring) else str_util.json2str(param)
                headers.update({'Content-Type':'application/json'})
                kwargs['headers'] = headers
            else:
                param = urlencode(param)

        # 提交请求
        status_code, text, res = _handler(url=url, param=param, method=method, **kwargs)

        # 是否输出为便于人阅读的模式
        log_param = (u', param:%s' % param) if param else ''
        # 记录花费时间
        use_time = time.time() - start_time
        if use_time > float(warning_time):
            logger.warn(u"%s [yellow]url 耗时太长, 用时:%.4f秒[/yellow] -->%s%s 返回-->%s", method, use_time, url, log_param, text,
                extra={'color':True, 'method':method, 'url':url, 'param':param, 'result':text, 'use_time':use_time}
            )
        else:
            logger.info(u"%s 用时:%.4f秒, url-->%s%s 返回-->%s", method, use_time, url, log_param, text,
                extra={'method':method, 'url':url, 'param':param, 'result':text, 'use_time':use_time}
            )
        return res
    except Exception, e:
        if not use_time:
            use_time = time.time() - start_time
        logger.error(u"%s 用时:%.4f秒, [red]请求错误:%s[/red]: url:%s, param:%s, 返回:%s", method, use_time, e, url, param, res, exc_info=True,
            extra={'color':True, 'Exception':e, 'method':method, 'url':url, 'param':param, 'result':res, 'use_time':use_time}
        )
        if raise_error:
            raise
    return res

def get(url, param=None, **kwargs):
    u"""
    @summary: get方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(get请求时会拼接到 url 上)
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = get('http://www.example.com?a=1&b=uu')
        s = get('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='GET', **kwargs)

def post(url, param=None, **kwargs):
    u"""
    @summary: post方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = post('http://www.example.com?a=1&b=uu')
        s = post('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='POST', **kwargs)

def put(url, param=None, **kwargs):
    u"""
    @summary: put方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = put('http://www.example.com?a=1&b=uu')
        s = put('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='PUT', **kwargs)

def delete(url, param=None, **kwargs):
    u"""
    @summary: delete方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = delete('http://www.example.com?a=1&b=uu')
        s = delete('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='DELETE', **kwargs)

def patch(url, param=None, **kwargs):
    u"""
    @summary: patch方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = patch('http://www.example.com?a=1&b=uu')
        s = patch('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='PATCH', **kwargs)

def options(url, param=None, **kwargs):
    u"""
    @summary: options方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数
    @param {int} timeout: 请求超时时间(单位:秒,设为 None 则是不设置超时时间)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} send_json: 提交参数是否需要 json 化
    @param {bool} return_json: 返回结果是否需要 json 化
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    @param {bool} gzip : 使用的压缩模式,值可为: gzip, deflate (值为 False 时不压缩,默认:不压缩)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {int|long|float} repeat_time: 提交请求的最大次数,默认只提交1次。(1表示只提交一次,失败也不再重复提交； 2表示允许重复提交2次,即第一次失败时再来一次,3表示允许重复提交3次...)
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要正常返回就认为正确, 当 repeat_time 参数大于 1 时不正确的返回值会自动再提交一次, 直至 repeat_time < 1 或者返回正确时为止)
    @param {dict} headers: 请求的头部信息
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认不抛出)。为 True则会抛出异常信息,否则不抛出
    @param {任意} default: 默认的返回值
    @return {string}: 返回获取的页面内容字符串
    @example
        s = options('http://www.example.com?a=1&b=uu')
        s = options('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    kwargs.pop('method', None)
    return _deal(url, param=param, method='OPTIONS', **kwargs)

def getRequestParams(url):
    '''
    @summary: 获取url里面的参数,以字典的形式返回
    @param {string} url: 请求地址
    @return {dict}: 以字典的形式返回请求里面的参数
    '''
    result = {}
    if not isinstance(url, basestring):
        if isinstance(url, dict):
            return url
        else:
            return result
    url = str_util.to_str(url)

    #li = re.findall(r'\w+=[^&]*', url) # 为了提高效率，避免使用正则
    i = url.find('?')
    if i != -1:
        url = url[i+1:]
    li = url.split('&')

    if not li:
        return result

    for ns in li:
        if not ns:continue
        (key,value) = ns.split('=', 1) if ns.find('=') != -1 else (ns, '')
        value = value.replace('+', ' '); # 空格会变成加号
        result[key] = urllib.unquote(value) # 值需要转码

    return result

def urlencode(param, encode='utf-8', send_json=False):
    u"""
    @summary: 将字典转成 url 参数
    @param {dict|string} param: 要提交到网页的参数(get方式会拼接到 url 上)
    @param {string} encode: 编码类型,默认是 utf-8 编码
    @param {bool} send_json: 提交参数是否需要 json 化
    @return {string}: 返回可以提交的字符串参数
    @example
        s = urlencode({'name' : '测试用户', 'password' : 123456})  # 返回:password=123456&name=%E6%B5%8B%E8%AF%95%E7%94%A8%E6%88%B7
    """
    if not param:
        return ''
    # 必须转码成str,用 unicode 转url编码中文会报错
    param = str_util.deep_str(param, encode=encode, str_unicode=str_util.to_str)
    if isinstance(param, dict):
        for k,v in param.iteritems():
            if v == None:
                param[k] = ''
            elif not isinstance(v, basestring):
                param[k] = str_util.json2str(v)
        param = urllib.urlencode(param)
    # 字符串类型,不再处理
    elif isinstance(param, basestring):
        pass
    # 其它类型,转成字符串
    else:
        param = str_util.json2str(param)
    return param

def choose_boundary():
    '''生成唯一标识'''
    return uuid4().hex

# 文件后缀对应的文件类型
__content_type = {
    "001" : "application/x-001",
    "301" : "application/x-301",
    "323" : "text/h323",
    "906" : "application/x-906",
    "907" : "drawing/907",
    "a11" : "application/x-a11",
    "acp" : "audio/x-mei-aac",
    "ai" : "application/postscript",
    "aif" : "audio/aiff",
    "aifc" : "audio/aiff",
    "aiff" : "audio/aiff",
    "anv" : "application/x-anv",
    "apk" : "application/vnd.android.package-archive",
    "asa" : "text/asa",
    "asf" : "video/x-ms-asf",
    "asp" : "text/asp",
    "asx" : "video/x-ms-asf",
    "au" : "audio/basic",
    "avi" : "video/avi",
    "awf" : "application/vnd.adobe.workflow",
    "biz" : "text/xml",
    "bmp" : "application/x-bmp",
    "bot" : "application/x-bot",
    "c4t" : "application/x-c4t",
    "c90" : "application/x-c90",
    "cal" : "application/x-cals",
    "cat" : "application/vnd.ms-pki.seccat",
    "cdf" : "application/x-netcdf",
    "cdr" : "application/x-cdr",
    "cel" : "application/x-cel",
    "cer" : "application/x-x509-ca-cert",
    "cg4" : "application/x-g4",
    "cgm" : "application/x-cgm",
    "cit" : "application/x-cit",
    "class" : "java/*",
    "cml" : "text/xml",
    "cmp" : "application/x-cmp",
    "cmx" : "application/x-cmx",
    "cot" : "application/x-cot",
    "crl" : "application/pkix-crl",
    "crt" : "application/x-x509-ca-cert",
    "csi" : "application/x-csi",
    "css" : "text/css",
    "cut" : "application/x-cut",
    "dbf" : "application/x-dbf",
    "dbm" : "application/x-dbm",
    "dbx" : "application/x-dbx",
    "dcd" : "text/xml",
    "dcx" : "application/x-dcx",
    "der" : "application/x-x509-ca-cert",
    "dgn" : "application/x-dgn",
    "dib" : "application/x-dib",
    "dll" : "application/x-msdownload",
    "doc" : "application/msword",
    "dot" : "application/msword",
    "drw" : "application/x-drw",
    "dtd" : "text/xml",
    "dwf" : "Model/vnd.dwf",
    #"dwf" : "application/x-dwf",
    "dwg" : "application/x-dwg",
    "dxb" : "application/x-dxb",
    "dxf" : "application/x-dxf",
    "edn" : "application/vnd.adobe.edn",
    "emf" : "application/x-emf",
    "eml" : "message/rfc822",
    "ent" : "text/xml",
    "epi" : "application/x-epi",
    #"eps" : "application/x-ps",
    "eps" : "application/postscript",
    "etd" : "application/x-ebx",
    "exe" : "application/x-msdownload",
    "fax" : "image/fax",
    "fdf" : "application/vnd.fdf",
    "fif" : "application/fractals",
    "fo" : "text/xml",
    "frm" : "application/x-frm",
    "g4" : "application/x-g4",
    "gbr" : "application/x-gbr",
    "gif" : "image/gif",
    "gl2" : "application/x-gl2",
    "gp4" : "application/x-gp4",
    "hgl" : "application/x-hgl",
    "hmr" : "application/x-hmr",
    "hpg" : "application/x-hpgl",
    "hpl" : "application/x-hpl",
    "hqx" : "application/mac-binhex40",
    "hrf" : "application/x-hrf",
    "hta" : "application/hta",
    "htc" : "text/x-component",
    "htm" : "text/html",
    "html" : "text/html",
    "htt" : "text/webviewhtml",
    "htx" : "text/html",
    "icb" : "application/x-icb",
    "ico" : "image/x-icon",
    #"ico" : "application/x-ico",
    "iff" : "application/x-iff",
    "ig4" : "application/x-g4",
    "igs" : "application/x-igs",
    "iii" : "application/x-iphone",
    "img" : "application/x-img",
    "ins" : "application/x-internet-signup",
    "ipa" : "application/vnd.iphone",
    "isp" : "application/x-internet-signup",
    "IVF" : "video/x-ivf",
    "java" : "java/*",
    "jfif" : "image/jpeg",
    "jpe" : "image/jpeg",
    #"jpe" : "application/x-jpe",
    "jpeg" : "image/jpeg",
    #"jpg" : "application/x-jpg",
    "jpg" : "image/jpeg",
    "js" : "application/x-javascript",
    "jsp" : "text/html",
    "la1" : "audio/x-liquid-file",
    "lar" : "application/x-laplayer-reg",
    "latex" : "application/x-latex",
    "lavs" : "audio/x-liquid-secure",
    "lbm" : "application/x-lbm",
    "lmsff" : "audio/x-la-lms",
    "ls" : "application/x-javascript",
    "ltr" : "application/x-ltr",
    "m1v" : "video/x-mpeg",
    "m2v" : "video/x-mpeg",
    "m3u" : "audio/mpegurl",
    "m4e" : "video/mpeg4",
    "mac" : "application/x-mac",
    "man" : "application/x-troff-man",
    "math" : "text/xml",
    "mdb" : "application/msaccess",
    "mdb" : "application/x-mdb",
    "mfp" : "application/x-shockwave-flash",
    "mht" : "message/rfc822",
    "mhtml" : "message/rfc822",
    "mi" : "application/x-mi",
    "mid" : "audio/mid",
    "midi" : "audio/mid",
    "mil" : "application/x-mil",
    "mml" : "text/xml",
    "mnd" : "audio/x-musicnet-download",
    "mns" : "audio/x-musicnet-stream",
    "mocha" : "application/x-javascript",
    "movie" : "video/x-sgi-movie",
    "mp1" : "audio/mp1",
    "mp2" : "audio/mp2",
    "mp2v" : "video/mpeg",
    "mp3" : "audio/mp3",
    "mp4" : "video/mpeg4",
    "mpa" : "video/x-mpg",
    "mpd" : "application/vnd.ms-project",
    "mpe" : "video/x-mpeg",
    "mpeg" : "video/mpg",
    "mpg" : "video/mpg",
    "mpga" : "audio/rn-mpeg",
    "mpp" : "application/vnd.ms-project",
    "mps" : "video/x-mpeg",
    "mpt" : "application/vnd.ms-project",
    "mpv" : "video/mpg",
    "mpv2" : "video/mpeg",
    "mpw" : "application/vnd.ms-project",
    "mpx" : "application/vnd.ms-project",
    "mtx" : "text/xml",
    "mxp" : "application/x-mmxp",
    "net" : "image/pnetvue",
    "nrf" : "application/x-nrf",
    "nws" : "message/rfc822",
    "odc" : "text/x-ms-odc",
    "out" : "application/x-out",
    "p10" : "application/pkcs10",
    "p12" : "application/x-pkcs12",
    "p7b" : "application/x-pkcs7-certificates",
    "p7c" : "application/pkcs7-mime",
    "p7m" : "application/pkcs7-mime",
    "p7r" : "application/x-pkcs7-certreqresp",
    "p7s" : "application/pkcs7-signature",
    "pc5" : "application/x-pc5",
    "pci" : "application/x-pci",
    "pcl" : "application/x-pcl",
    "pcx" : "application/x-pcx",
    "pdf" : "application/pdf",
    "pdx" : "application/vnd.adobe.pdx",
    "pfx" : "application/x-pkcs12",
    "pgl" : "application/x-pgl",
    "pic" : "application/x-pic",
    "pko" : "application/vnd.ms-pki.pko",
    "pl" : "application/x-perl",
    "plg" : "text/html",
    "pls" : "audio/scpls",
    "plt" : "application/x-plt",
    "png" : "image/png",
    "pot" : "application/vnd.ms-powerpoint",
    "ppa" : "application/vnd.ms-powerpoint",
    "ppm" : "application/x-ppm",
    "pps" : "application/vnd.ms-powerpoint",
    #"ppt" : "application/x-ppt",
    "ppt" : "application/vnd.ms-powerpoint",
    "pr" : "application/x-pr",
    "prf" : "application/pics-rules",
    "prn" : "application/x-prn",
    "prt" : "application/x-prt",
    "ps" : "application/postscript",
    #"ps" : "application/x-ps",
    "ptn" : "application/x-ptn",
    "pwz" : "application/vnd.ms-powerpoint",
    "r3t" : "text/vnd.rn-realtext3d",
    "ra" : "audio/vnd.rn-realaudio",
    "ram" : "audio/x-pn-realaudio",
    "ras" : "application/x-ras",
    "rat" : "application/rat-file",
    "rdf" : "text/xml",
    "rec" : "application/vnd.rn-recording",
    "red" : "application/x-red",
    "rgb" : "application/x-rgb",
    "rjs" : "application/vnd.rn-realsystem-rjs",
    "rjt" : "application/vnd.rn-realsystem-rjt",
    "rlc" : "application/x-rlc",
    "rle" : "application/x-rle",
    "rm" : "application/vnd.rn-realmedia",
    "rmf" : "application/vnd.adobe.rmf",
    "rmi" : "audio/mid",
    #"rmj" : "application/vnd.rn-realsystem-rmj",
    "rmm" : "audio/x-pn-realaudio",
    "rmp" : "application/vnd.rn-rn_music_package",
    "rms" : "application/vnd.rn-realmedia-secure",
    "rmvb" : "application/vnd.rn-realmedia-vbr",
    "rmx" : "application/vnd.rn-realsystem-rmx",
    "rnx" : "application/vnd.rn-realplayer",
    "rp" : "image/vnd.rn-realpix",
    "rpm" : "audio/x-pn-realaudio-plugin",
    "rsml" : "application/vnd.rn-rsml",
    "rt" : "text/vnd.rn-realtext",
    #"rtf" : "application/msword",
    "rtf" : "application/x-rtf",
    "rv" : "video/vnd.rn-realvideo",
    "sam" : "application/x-sam",
    "sat" : "application/x-sat",
    "sdp" : "application/sdp",
    "sdw" : "application/x-sdw",
    "sis" : "application/vnd.symbian.install",
    "sisx" : "application/vnd.symbian.install",
    "sit" : "application/x-stuffit",
    "slb" : "application/x-slb",
    "sld" : "application/x-sld",
    "slk" : "drawing/x-slk",
    "smi" : "application/smil",
    "smil" : "application/smil",
    "smk" : "application/x-smk",
    "snd" : "audio/basic",
    "sol" : "text/plain",
    "sor" : "text/plain",
    "spc" : "application/x-pkcs7-certificates",
    "spl" : "application/futuresplash",
    "spp" : "text/xml",
    "ssm" : "application/streamingmedia",
    "sst" : "application/vnd.ms-pki.certstore",
    "stl" : "application/vnd.ms-pki.stl",
    "stm" : "text/html",
    "sty" : "application/x-sty",
    "svg" : "text/xml",
    "swf" : "application/x-shockwave-flash",
    "tdf" : "application/x-tdf",
    "tg4" : "application/x-tg4",
    "tga" : "application/x-tga",
    "tif" : "image/tiff",
    #"tif" : "application/x-tif",
    "tiff" : "image/tiff",
    "tld" : "text/xml",
    "top" : "drawing/x-top",
    "torrent" : "application/x-bittorrent",
    "tsd" : "text/xml",
    "txt" : "text/plain",
    "uin" : "application/x-icq",
    "uls" : "text/iuls",
    "vcf" : "text/x-vcard",
    "vda" : "application/x-vda",
    "vdx" : "application/vnd.visio",
    "vml" : "text/xml",
    "vpg" : "application/x-vpeg005",
    "vsd" : "application/x-vsd",
    "vsd" : "application/vnd.visio",
    "vss" : "application/vnd.visio",
    "vst" : "application/vnd.visio",
    "vst" : "application/x-vst",
    "vsw" : "application/vnd.visio",
    "vsx" : "application/vnd.visio",
    "vtx" : "application/vnd.visio",
    "vxml" : "text/xml",
    "wav" : "audio/wav",
    "wax" : "audio/x-ms-wax",
    "wb1" : "application/x-wb1",
    "wb2" : "application/x-wb2",
    "wb3" : "application/x-wb3",
    "wbmp" : "image/vnd.wap.wbmp",
    "wiz" : "application/msword",
    "wk3" : "application/x-wk3",
    "wk4" : "application/x-wk4",
    "wkq" : "application/x-wkq",
    "wks" : "application/x-wks",
    "wm" : "video/x-ms-wm",
    "wma" : "audio/x-ms-wma",
    "wmd" : "application/x-ms-wmd",
    "wmf" : "application/x-wmf",
    "wml" : "text/vnd.wap.wml",
    "wmv" : "video/x-ms-wmv",
    "wmx" : "video/x-ms-wmx",
    "wmz" : "application/x-ms-wmz",
    "wp6" : "application/x-wp6",
    "wpd" : "application/x-wpd",
    "wpg" : "application/x-wpg",
    "wpl" : "application/vnd.ms-wpl",
    "wq1" : "application/x-wq1",
    "wr1" : "application/x-wr1",
    "wri" : "application/x-wri",
    "wrk" : "application/x-wrk",
    "ws" : "application/x-ws",
    "ws2" : "application/x-ws",
    "wsc" : "text/scriptlet",
    "wsdl" : "text/xml",
    "wvx" : "video/x-ms-wvx",
    "x_b" : "application/x-x_b",
    "x_t" : "application/x-x_t",
    "xap" : "application/x-silverlight-app",
    "xdp" : "application/vnd.adobe.xdp",
    "xdr" : "text/xml",
    "xfd" : "application/vnd.adobe.xfd",
    "xfdf" : "application/vnd.adobe.xfdf",
    "xhtml" : "text/html",
    #"xls" : "application/x-xls",
    "xls" : "application/vnd.ms-excel",
    "xlw" : "application/x-xlw",
    "xml" : "text/xml",
    "xpl" : "audio/scpls",
    "xq" : "text/xml",
    "xql" : "text/xml",
    "xquery" : "text/xml",
    "xsd" : "text/xml",
    "xsl" : "text/xml",
    "xslt" : "text/xml",
    "xwd" : "application/x-xwd",
}

def get_content_type(filename):
    '''根据文件名的后缀，获取文件类型
    @param {string} filename:文件名
    @return {string}: 返回文件类型
    '''
    global __content_type
    # 默认值(未知类型)
    default_type = 'application/octet-stream'
    if not filename or not isinstance(filename, basestring):
        return default_type
    filename = filename.strip()
    index = filename.rfind('.')
    if index != -1:
        ext = filename[index+1:] # 后缀
        return __content_type.get(ext.lower(), default_type) # 按后缀查
    return default_type


def multiple_urlencode(param=None, files=None, boundary=None, encode="utf-8"):
    u"""
    @summary: 将字典转成 url 参数
    @param {dict|string} param: 要提交到网页的参数(get方式会拼接到 url 上)
    @param {list<dict> | dict} files: 要提交到网页的文件列表,只有一个文件时可以传dict类型,多个文件传list<dict>类型
               里面的参数字典内容为: {
                    'name' : 提交表单时的名称
                    'filename':文件名,如: 'xxx.html', 可不传,会自动用 name 参数来填补
                    'content_type':文件类型,如: 'text/html', 不传时会根据文件名的后缀来自动填补
                    'body':文件二进制内容, 有这参数的内容时就不再获取 file 参数的内容
                    'file':文件路径,如: 'imgs/xxx.jpg', 当 body 参数没有内容时才会读取这参数
                  }
    @param {string} boundary: 分隔符
    @param {string} encode: 编码类型,默认是 utf-8 编码
    @return {string}: 返回可以提交的字符串参数
    @example
        s = urlencode({'name' : '测试用户', 'password' : 123456})  # 返回:password=123456&name=%E6%B5%8B%E8%AF%95%E7%94%A8%E6%88%B7
    """
    if not boundary:
        return ''

    data = []
    data.append('--%s' % boundary)

    if param:
        if isinstance(param, basestring):
            param = getRequestParams(param)
        if isinstance(param, dict):
            # 必须转码成str,用 unicode 转url编码中文会报错
            param = str_util.deep_str(param, encode=encode, str_unicode=str_util.to_str)
            for k,v in param.iteritems():
                # 值的处理
                if '"' in k:
                    k = k.replace('"', '\\"')
                if v == None:
                    v = ''
                elif not isinstance(v, basestring):
                    v = str_util.json2str(v)
                # 传入请求体
                data.append('Content-Disposition: form-data; name="%s"\r\n' % k)
                data.append(v)
                data.append('--%s' % boundary)

    if files:
        if isinstance(files, dict):
            files = [files]
        if isinstance(files, (list,tuple,set)):
            for item in files:
                name = str_util.to_str(item.get('name', 'file'), encode=encode).replace('"', '\\"')
                filename = str_util.to_str(item.get('filename', name), encode=encode).replace('"', '\\"')
                body = item.get('body')
                if not body:
                    file_path_encode = encode
                    if sys.platform == 'win32':
                        file_path_encode = "gb2312"
                    file_path = str_util.to_str(item.get('file'), encode=file_path_encode)
                    # 没有文件和二进制内容,则无法传输
                    if not file_path or not os.path.exists(file_path):
                        continue
                    f = open(file_path,'rb')
                    body = f.read()
                    f.close()
                    filename = str_util.to_str(item.get('filename', os.path.basename(file_path)), encode=encode).replace('"', '\\"') # 文件名称没传,默认使用文件路径的地址做
                content_type = str_util.to_str(item.get('content_type', get_content_type(filename)), encode=encode)
                # 传入请求体
                data.append('Content-Disposition: form-data; name="%s"; filename="%s"' % (name, filename))
                data.append('Content-Type: %s\r\n' % content_type)
                data.append(body)
                data.append('--%s\r\n' % boundary)

    if len(data) > 1:
        data.pop()
    data.append('--%s--\r\n' % boundary) # 最后结束符
    http_body='\r\n'.join(data)
    return http_body

