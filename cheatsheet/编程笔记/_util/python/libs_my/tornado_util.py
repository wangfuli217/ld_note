#!python
# -*- coding:utf-8 -*-
'''
Created on 2014/9/18
Updated on 2016/5/19
@author: Holemar

依赖第三方库:
    tornado==3.1.1

本模块专门供 tornado 框架的请求函数修饰用
统一处理 tornado请求的请求地址、压缩返回值、异常处理、接口耗时、访问ip验证等
'''
import time
import types
import random
import socket
import logging
import threading

from tornado.web import RequestHandler

from . import str_util, ip_util

__all__=('init', 'fn', 'run', 'get_apps', 'add_apps', 'add_not_found', 'get_port')
logger = logging.getLogger('libs_my.tornado_util')

# 请求默认值
CONFIG = {
    'method' : ['get', 'post'], # {string|list<string>}:接口允许的访问方式,如: GET, POST, PUT, DELETE, PATCH, OPTIONS
    'paramter_exclude' : [], # {tuple|list}: 请求参数不能包含的字符
    'paramter_error' : {'result':-1, 'reason':u'请求参数错误'}, # {任意}: 请求参数错误时的返回值
    'ip_limited' : {'result':-2, 'reason':u'IP地址被限制'}, # {任意}: ip地址受到限制时的返回值
    'unknow_error' : {'result':-3, 'reason':u"未知错误!"}, # {任意}: 发生未知错误时的返回值
    'not_found' :  {'result':-4, 'reason':u"请求地址不存在,请检查!"}, # {任意}: 页面找不到时的返回值
    'gzip_length' : 4000, # {int}:返回内容的长度大于多少，才会启用压缩模式返回(设为None值则永不压缩,默认4000字符以上才会压缩)
    'warn_time' : 5, # {int}:接口运行过久，该警告的时间(单位:秒)
}

# 请求地址列表
Web_Applications = []
Wsgi_Application = None

def init(**kwargs):
    '''
    @summary: 设置各函数的默认参数值
    @param {string|list<string>} method: 接口允许的访问方式,如: GET, POST
    @param {tuple|list} paramter_exclude : 请求参数不能包含的字符
    @param {任意} paramter_error: 请求参数错误时的返回值
    @param {任意} ip_limited: ip地址受到限制时的返回值
    @param {任意} unknow_error: 发生未知错误时的返回值
    @param {任意} not_found : 页面找不到时的返回值
    @param {int} gzip_length: 返回内容的长度大于多少，才会启用压缩模式返回(设为None值则永不压缩)
    @param {int} warn_time: 接口运行过久，该警告的时间(单位:秒,默认 5 秒)
    '''
    global CONFIG
    CONFIG.update(kwargs)

def get_apps(*args, **kwargs):
    '''
    @summary: 获取请求地址列表
    @return {list}: 请求地址列表
    '''
    global Web_Applications
    return Web_Applications

def add_apps(url, handler, **kwargs):
    '''
    @summary: 添加请求地址列表及处理类
    @param {string|list<string>} url: 此请求的访问地址,指向多个地址可用列表及正则表达式
    @param {class} handler: 此请求的处理类
    @return {list}: 请求地址列表
    '''
    global Web_Applications
    global Wsgi_Application
    if isinstance(url, basestring):
        Web_Applications.append((url, handler))
        if Wsgi_Application:
            Wsgi_Application.add_handlers(".*$", [(url, handler)])
    # 指向多个地址
    elif isinstance(url, (list,tuple,set)):
        for item in url:
            add_apps(item, handler)
    return Web_Applications

def add_not_found(**kwargs):
    '''
    @summary: 添加所有url配置都找不到的地址(必须在最后添加)
    @param {任意} not_found : 页面找不到时的返回值
    '''
    global CONFIG
    # 地址找不到时的返回内容
    not_found = kwargs.get('not_found', CONFIG.get('not_found'))

    # 定义找不到地址时的 Handler 类
    class NotFoundHandler(RequestHandler):
        def get(self):
            request = self.request
            ip = ip_util.get_tornado_ip(request)
            url = u"来源ip:%s 访问:[green]%s[/green]" % (ip, request.uri)
            if request.body and len(request.body) < 2000:
                url = u"%s POST内容:[green]%s[/green]" % (url, request.body)
            logger.error(u'[red]请求地址不存在[/red], %s 返回:%s' , url, not_found, extra={'color':True})
            self.finish(not_found)
            return

        # post 跟 get 请求同样处理
        post = get

    # 添加到请求地址列表
    add_apps(r"/.*", NotFoundHandler)

def get_port(port=None):
    '''
    @summary: 探测本机的此端口是否可用，不可用则返回另一个可用的端口
    @param {int} port : 被探测的端口
    @return {int}: 可用的程序启动端口
    '''
    port = port or random.randint(5000, 65535)
    while 1:
        sock = socket.socket()
        try:
            sock.bind(('', port))
            return port
        except:
            port = random.randint(5000, 65535)
        finally:
            sock.close()

def run(port, worker='gevent', threads=False, **kwargs):
    '''
    @summary: 启动 tornado 服务
    @param {int} port: web服务绑定的访问端口
    @param {string} worker: 启动的worker,默认使用 gevent 的,以便使用协程
    @param {bool} threads: 是否线程启动，且返回此线程
    '''
    global Wsgi_Application
    add_not_found()
    app = get_apps()
    logger.info(u'监听端口:%s,程序正在启动......', port)
    # gevent + tornado 启动
    if worker=='gevent':
        from tornado.wsgi import WSGIApplication
        from gevent.pywsgi import WSGIServer
        Wsgi_Application = WSGIApplication(app)
        server = WSGIServer(('', port), Wsgi_Application)
        logger.info(u'程序启动成功.') # 启动后没法输出日志，所以只能提前了
        server.serve_forever()
    # 纯 tornado 启动
    else:
        from tornado.web import Application
        from tornado.httpserver import HTTPServer
        from tornado.ioloop import IOLoop
        Wsgi_Application = Application(app)
        http_server = HTTPServer(Wsgi_Application) # 加载配置
        http_server.listen(port) # 监听端口号
        logger.info(u'程序启动成功.') # 启动后没法输出日志，所以只能提前了
        instance = IOLoop.instance()
        if threads:
            th = threading.Thread(target=instance.start)
            th.start() # 启动这个线程
            return th # 返回这个线程
        else:
            instance.start() # 启动


def zip_response(self, result):
    '''
    @summary: 压缩返回值
    @return {string}: 压缩后的字符串
    '''
    headers = self.request.headers
    encoding = headers.get('Accept-Encoding', '')
    if encoding in ('gzip', 'deflate'):
        self.set_header('Content-Encoding', encoding)
        if encoding == 'gzip':
            result = str_util.gzip_encode(result)
        elif encoding == 'deflate':
            result = str_util.zlib_encode(result)
    return result

def fn(*out_args, **out_kwargs):
    '''
    @summary: 过滤tornado请求函数,判断返回时长、是否压缩、是否过滤访问ip、记录日志等
    @param {string|list<string>} url: 此函数绑定的访问地址,指向多个地址可用列表及正则表达式
    @param {string|list<string>} method: 接口允许的访问方式,如: GET, POST, PUT, DELETE, PATCH, OPTIONS
    @param {list<string>} auth_ips: 允许访问此接口的ip列表
    @param {tuple|list} paramter_exclude : 请求参数不能包含的字符
    @param {任意} paramter_error: 请求参数错误时的返回值
    @param {任意} ip_limited: ip地址受到限制时的返回值
    @param {任意} unknow_error: 发生未知错误时的返回值
    @param {int} gzip_length: 返回内容的长度大于多少，才会启用压缩模式返回(设为None值则永不压缩)
    @param {int} warn_time: 接口运行过久，该警告的时间(单位:秒,默认 5 秒)

    @example
        @tornado_util.fn(url=r"/ad_conf", method=['get', 'post'])
        def ad_conf(self, brandid, uid, pv, v='', flag='', **kwargs):
            res = views.ad_conf(brandid, uid, pv, v)
            if flag and flag == res.get('flag'):
                return {"result":101, "reason":""}
            return res
    '''
    global CONFIG
    # 定义请求处理函数
    def _deal_func(self, *args, **kwargs):
        url = None # 请求地址及参数
        res = None # 返回值
        start_time = time.time()
        try:
            request = self.request
            ip = ip_util.get_tornado_ip(request) or '127.0.0.1'
            url = u"来源ip:%s 访问:[green]%s[/green]" % (ip, request.uri)
            if request.body and len(request.body) < 2000:
                url = u"%s POST内容:[green]%s[/green]" % (url, request.body)
            logger.debug(url.replace('[green]', '').replace('[/green]', '')) # 访问时打印一下日志,便于中途异常没捕获到时追查

            # 访问ip验证
            auth_ips = out_kwargs.get('auth_ips', ip_util.AUTH_IP_LIST)
            if auth_ips and 'unlimited' not in auth_ips:
                trust_ip = ip_util.in_list(ip, auth_ips)
                if not trust_ip:
                    logger.error(u"[red]访问ip被限制[/red]:%s" , url, extra={'color':True})
                    res = out_kwargs.get('ip_limited', CONFIG.get('ip_limited'))

            # 执行具体业务。 下面主要是处理传参
            if res is None:
                paramter_exclude = out_kwargs.get('paramter_exclude', CONFIG.get('paramter_exclude'))
                #kwargs.update(dict([(k, values[-1] if len(set(values)) == 1 else values) for k, values in request.arguments.iteritems() if k not in kwargs and values[-1] not in paramter_exclude])) # 这写法不能涵盖下面防止SQL注入功能,且太难懂
                # 将参数直接传给具体业务函数
                arguments = request.arguments
                for k, values in arguments.items():
                    if k in kwargs: continue # 路径上已经获取到这个key则以路径的为主,因为参数的还可以从 self 参数获取,而路径的只能靠这了
                    # 有可能传多个同名参数,这时返回list。 如果多个同名参数是重复传的话,只获取其中一个
                    value = values[0] if len(set(values)) == 1 else values
                    # 判断参数值里面是否包含非法字符,接口防止 SQL 注入用
                    if value and paramter_exclude:
                        for exclude in paramter_exclude:
                            if isinstance(value, basestring):
                                if exclude in value: raise TypeError(u"参数中包含非法字符:%s" % exclude)
                            elif isinstance(value, list):
                                for v in value:
                                    if exclude in v: raise TypeError(u"参数中包含非法字符:%s" % exclude)
                    kwargs[k] = value
                func = out_kwargs['function']
                args = str_util.to_str(args)
                kwargs = str_util.to_str(kwargs) # 避免参数中文的乱码问题
                res = func(self, *args, **kwargs)

            # 处理返回值: 如果返回值不是字符串,需要转成字符串输出
            if not isinstance(res, basestring):
                res = str_util.json2str(res)
                # 设置返回类型
                self.set_header("Content-Type", "application/json; charset=UTF-8")
            else:
                self.set_header("Content-Type", "text/html;charset=UTF-8")

        # 请求被调函数时,参数不对应
        except TypeError, e:
            logger.error(u"[red]请求参数错误:%s[/red], %s, 参数: %s, %s", e, url, args, kwargs, exc_info=True, extra={'color':True})
            res = out_kwargs.get('paramter_error', CONFIG.get('paramter_error'))
        # 请求被调函数时,抛出其它异常
        except Exception, e:
            logger.error(u'[red]接口异常:%s[/red]: %s 返回:%s', e, url, res, exc_info=True, extra={'color':True})
            res = out_kwargs.get('unknow_error', CONFIG.get("unknow_error"))
        finally:
            # 记录调用该接口的耗时
            used_time = time.time() - start_time
            # 记录访问日志
            if used_time > out_kwargs.get('warn_time', CONFIG.get('warn_time', 5)): # 耗时太长
                logger.warn(u'[yellow]接口耗时太长:%.4f秒[/yellow], %s 返回:%s', used_time, url, res, extra={'color':True})
            else: # 普通日志
                logger.info(u'耗时:%.4f秒, %s 返回:%s', used_time, url, res, extra={'color':True})

            # 完成,输出结果
            if not self._finished:
                if res != None:
                    # 判断是否需要压缩结果
                    gzip_length = out_kwargs.get('gzip_length', CONFIG.get('gzip_length', 4000))
                    if gzip_length and len(res) > gzip_length:
                        res = zip_response(self, res)
                    self.finish(res)
                else:
                    self.finish()
            return

    # 定义 tornado 的web请求 Handler 类
    method_dict = {}
    # 判断 get 和 post 请求哪个需要限制
    _method = out_kwargs.get('method', CONFIG.get('method'))
    if _method:
        if isinstance(_method, basestring): _method = [_method]
        if isinstance(_method, (list,tuple,set)):
            for _item in _method:
                _item = str(_item).strip().lower()
                method_dict[_item] = _deal_func
    _DealHandler = type('_DealHandler', (RequestHandler,), method_dict)

    # 处理此装饰器没有装饰器参数,及第一个装饰器参数直接写url地址的情况
    if len(out_args) > 0:
        _function = out_args[0]
        if isinstance(_function, (types.FunctionType, types.MethodType)) and len(out_args)==1 and not out_kwargs:
            out_kwargs['function'] = _function
            # 当调用此装饰器时不写参数,需在外层另外定义请求地址,故返回 RequestHandler 类以供外层定义请求地址时用
            return _DealHandler

        # 第一个参数,认为是请求地址
        if isinstance(_function, basestring) and out_kwargs.get('url') is None:
            out_kwargs['url'] = _function

    # 处理调用此装饰器时带上装饰器参数,及直接调用处理函数时
    def wrapper_out(method):
        # 处理请求地址、出错返回值等
        urls = out_kwargs.get('url')
        out_kwargs['function'] = method
        # 添加到请求地址列表
        add_apps(urls, _DealHandler)

        # 返回需执行的函数,以便直接调用
        def wrapper(*args, **kwargs):
            # 函数执行有可能不成功
            try:
                return method(None, *args, **kwargs) # 因为被调用函数需要加上首参数 self, 这里约定内部调用是此参数为 None
            except TypeError, e:
                logger.error(u"[red]函数执行错误:%s[/red] %s.%s,参数:%s,%s", e, method.__module__, method.__name__, args, kwargs, exc_info=True, extra={'color':True})
                return out_kwargs.get('paramter_error', CONFIG.get('paramter_error'))
            except Exception, e:
                logger.error(u"[red]函数执行错误:%s[/red] %s.%s,参数:%s,%s", e, method.__module__, method.__name__, args, kwargs, exc_info=True, extra={'color':True})
                return out_kwargs.get('unknow_error', CONFIG.get("unknow_error"))
        return wrapper

    return wrapper_out
