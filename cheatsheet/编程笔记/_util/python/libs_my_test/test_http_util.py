#!python
# -*- coding:utf-8 -*-
'''
公用函数(http请求处理) http_util.py 的测试
Created on 2014/7/16
Updated on 2016/9/5
@author: Holemar

依赖第三方库:
    tornado==3.1.1

通过用线程启动一个 tornado 服务器来测试 http 请求
(使用 mock 的方式需要很了解 urllib 库，暂没那功力，做不到)
todo:测试 压缩 和 线程 时，使用读取日志的方式，不太精确。后续需优化
'''
import os
import logging
import unittest
import threading

import __init__
from libs_my import http_util
from libs_my import str_util, tornado_util

# 用 Filter 类获取日志信息
NOW_LOG_RECORD = []
class TestFilter(logging.Filter):
    def filter(self, record):
        global NOW_LOG_RECORD
        NOW_LOG_RECORD.append(record) # 把 Filter 获取到的日志信息传递出去，供测试使用
        return True
http_util.logger.addFilter(TestFilter())


class TestHttpUtil(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(TestHttpUtil, cls).setUpClass()
        # 启动请求接收线程
        cls.port = tornado_util.get_port()
        cls.web = tornado_util.run(cls.port, worker='tornado', threads=True)

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(TestHttpUtil, cls).tearDownClass()
        cls.web._Thread__stop() # 停掉web线程

    # GET 测试
    def test_get(self):
        url = 'http://127.0.0.1:%d/test_get' % self.port
        param_url = url + '?a=11&b=22&c=%E5%93%88&d=%E5%93%88&e='
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        @tornado_util.fn(url=r"/test_get/?", method='get')
        def get_test_get(self, **kwargs):
            if self.request.body:
                return {"result": -1, "reason":'这是POST请求，请求方式有误！'}
            if (self.get_argument('a', '') == '11' and self.get_argument('b', '') == '22' and self.get_argument('c', '') == u'哈' and
                self.get_argument('d', '') == u'哈' and self.get_argument('e', '') == ''):
                return result
            else:
                return kwargs

        # 普通请求，原样返回
        res = http_util.get(param_url)
        assert isinstance(res, basestring)
        assert res == result

        # 参数转换
        res = http_util.get(url, {'a':11,'b':'22','c':'哈','d':u'哈','e':None})
        assert isinstance(res, basestring)
        assert res == result
        res2 = http_util.get(url, {'b':'22','c':'哈','d':u'哈','e':0})
        assert isinstance(res2, basestring)
        assert str_util.to_json(res2) == {'b':'22','c':u'哈','d':u'哈','e':'0'}

        # return_json 返回结果转换
        res = http_util.get(param_url, return_json=True)
        assert isinstance(res, dict)
        assert res == {"use_time": "0.0003", "reason": u"访问成功", "version": "2.0.0", "result": 0}

    # POST 测试
    def test_post(self):
        url = 'http://127.0.0.1:%d/test_post' % self.port
        param = {'a':11,'b':'22','c':'哈','d':u'哈','e':None}
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        @tornado_util.fn(url=r"/test_post/?", method='post')
        def get_test_post(self, **kwargs):
            if self.request.body is None:
                return {"result": -1, "reason":'这是GET请求，请求方式有误！'}
            if (self.get_argument('a', '') == '11' and self.get_argument('b', '') == '22' and self.get_argument('c', '') == u'哈' and
                self.get_argument('d', '') == u'哈' and self.get_argument('e', '') == ''):
                return result
            else:
                return kwargs

        # 无参数请求，原样返回
        res = http_util.post(url)
        assert isinstance(res, basestring)
        assert res == "{}"

        # 参数转换
        res = http_util.post(url, param)
        assert isinstance(res, basestring)
        assert res == result
        res2 = http_util.post(url, {'b':'22','c':'哈','d':u'哈','e':0})
        assert isinstance(res2, basestring)
        assert str_util.to_json(res2) == {'b':'22','c':u'哈','d':u'哈','e':'0'}

        # return_json 返回结果转换
        res = http_util.post(url, param, return_json=True)
        assert isinstance(res, dict)
        assert res == {"use_time": "0.0003", "reason": u"访问成功", "version": "2.0.0", "result": 0}

    # put,patch 请求 测试
    def test_put_patch(self):
        url = 'http://127.0.0.1:%d/test_put_patch' % self.port
        param = {'a':11,'b':'22','c':'哈','d':u'哈','e':None}
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        methods = ['put','patch']
        @tornado_util.fn(url=r"/test_put_patch/?", method=methods)
        def test_put_patch(self, **kwargs):
            if self.request.body is None:
                return {"result": -1, "reason":'这是GET请求，请求方式有误！'}
            if (self.get_argument('a', '') == '11' and self.get_argument('b', '') == '22' and self.get_argument('c', '') == u'哈' and
                self.get_argument('d', '') == u'哈' and self.get_argument('e', '') == ''):
                return result
            else:
                return kwargs

        for method in methods:
            fun = getattr(http_util, method)

            # 无参数请求，原样返回
            res = fun(url)
            assert isinstance(res, basestring)
            assert res == "{}"

            # 参数转换
            res = fun(url, param)
            assert isinstance(res, basestring)
            assert res == result
            res2 = fun(url, {'b':'22','c':'哈','d':u'哈','e':0})
            assert isinstance(res2, basestring)
            assert str_util.to_json(res2) == {'b':'22','c':u'哈','d':u'哈','e':'0'}

            # return_json 返回结果转换
            res = fun(url, param, return_json=True)
            assert isinstance(res, dict)
            assert res == {"use_time": "0.0003", "reason": u"访问成功", "version": "2.0.0", "result": 0}

        # get 请求，访问不了
        res = http_util.get(url)
        assert isinstance(res, basestring)
        assert res == "<html><title>405: Method Not Allowed</title><body>405: Method Not Allowed</body></html>"

        # post 请求，访问不了
        res = http_util.post(url)
        assert isinstance(res, basestring)
        assert res == "<html><title>405: Method Not Allowed</title><body>405: Method Not Allowed</body></html>"

    # delete,options 请求 测试
    def test_delete_options(self):
        url = 'http://127.0.0.1:%d/test_delete_options' % self.port
        param_url = url + '?a=11&b=22&c=%E5%93%88&d=%E5%93%88&e='
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        methods = ['delete','options']
        @tornado_util.fn(url=r"/test_delete_options/?", method=methods)
        def test_delete_options(self, **kwargs):
            if self.request.body is None:
                return {"result": -1, "reason":'这是GET请求，请求方式有误！'}
            return result

        for method in methods:
            fun = getattr(http_util, method)

            # 普通请求，原样返回
            res = fun(param_url)
            assert isinstance(res, basestring)
            assert res == result

        # get 请求，访问不了
        res = http_util.get(param_url)
        assert isinstance(res, basestring)
        assert res == "<html><title>405: Method Not Allowed</title><body>405: Method Not Allowed</body></html>"

        # post 请求，访问不了
        res = http_util.post(param_url)
        assert isinstance(res, basestring)
        assert res == "<html><title>405: Method Not Allowed</title><body>405: Method Not Allowed</body></html>"

    # 提交 json 测试
    def test_send_json(self):
        url = 'http://127.0.0.1:%d/test_send_json' % self.port
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        @tornado_util.fn(url=r"/test_send_json/?", method='post')
        def test_send_json(self, **kwargs):
            if self.request.body is None:
                return {"result": -1, "reason":'这是GET请求，请求方式有误！'}
            return str_util.to_json(self.request.body)

        # 提交 json
        param = {'a':11,'b':'22','c':'哈','d':u'哈','e':None}
        res = http_util.post(url, param, send_json=True)
        assert isinstance(res, basestring)
        assert str_util.to_json(res) == param

        param2 = {'b':'22','c':'哈','d':u'哈','e':0}
        res2 = http_util.post(url, param2, send_json=True)
        assert isinstance(res2, basestring)
        assert str_util.to_json(res2) == param2


    # gzip 压缩
    def test_gzip(self):
        url = 'http://127.0.0.1:%d/test_gzip' % self.port
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}' * 100

        @tornado_util.fn(url=r"/test_gzip/?", gzip_length=10)
        def get_test_gzip(self, **kwargs):
            if self.request.headers.get("Accept-Encoding", "") in ('gzip', 'deflate'):
                return result
            else:
                return {"result": -1, "reason":'这是没有压缩的请求，请求方式有误！'}

        # get 请求
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = []
        res = http_util.get(url, gzip=True)
        assert isinstance(res, basestring)
        assert res == result

        assert len(NOW_LOG_RECORD) >= 2
        record = NOW_LOG_RECORD[-2] # 倒数第二条日志，正是解压日志
        assert record is not None
        assert record.levelno == logging.INFO
        assert u'压缩请求' in record.msg
        assert record.method == 'GET'
        assert record.befor_length # 有写入解压前长度
        assert record.after_length # 有写入解压后长度
        assert record.after_length == len(result)
        assert record.befor_length < record.after_length # 解压后长度更长

        # post 请求
        NOW_LOG_RECORD = []
        res = http_util.post(url, gzip=True)
        assert isinstance(res, basestring)
        assert res == result

        assert len(NOW_LOG_RECORD) >= 2
        record = NOW_LOG_RECORD[-2] # 倒数第二条日志，正是解压日志
        assert record is not None
        assert record.levelno == logging.INFO
        assert u'压缩请求' in record.msg
        assert record.method == 'POST'
        assert record.befor_length # 有写入解压前长度
        assert record.after_length # 有写入解压后长度
        assert record.after_length == len(result)
        assert record.befor_length < record.after_length # 解压后长度更长

    # headers 设值
    def test_headers(self):
        url = 'http://127.0.0.1:%d/test_headers/' % self.port
        token = 'dfwerwer1548hgjhfre35656'

        @tornado_util.fn(url=r"/test_headers/")
        def get_test_test_headers(self, **kwargs):
            if self.request.headers.get("Accept-Token", "") == token:
                return 111
            else:
                return 222

        # get 请求
        res = http_util.get(url)
        assert isinstance(res, basestring)
        assert res == '222'

        res = http_util.get(url, headers={"Accept-Token":token})
        assert isinstance(res, basestring)
        assert res == '111'

        # post 请求
        res = http_util.post(url)
        assert isinstance(res, basestring)
        assert res == '222'

        res = http_util.post(url, headers={"Accept-Token":token})
        assert isinstance(res, basestring)
        assert res == '111'

    # 出错测试
    def test_error(self):
        # 设成默认异步请求
        http_util.init(repeat_time=3)
        url = 'http://127.0.0.1:%d/test_error' % self.port
        global error_times
        error_times = 0

        # 自定义一个出错页面
        class _ExceptionHandler(tornado_util.RequestHandler):
            def get(self):
                global error_times
                error_times += 1
                raise Exception('出错测试')
            post = get
        # 添加到请求地址列表
        tornado_util.add_apps(r"/test_error/?", _ExceptionHandler)

        # GET 请求，返回 None
        res = http_util.get(url)
        assert res == '<html><title>500: Internal Server Error</title><body>500: Internal Server Error</body></html>'
        assert error_times == 3 # 请求次数

        # POST 请求，返回 None
        error_times = 0
        res = http_util.post(url)
        assert res == '<html><title>500: Internal Server Error</title><body>500: Internal Server Error</body></html>'
        assert error_times == 3 # 请求次数

        # 改回默认值，避免影响其它测试
        http_util.init(repeat_time=1)

    # 异步测试
    def test_threads(self):
        # 设成默认异步请求
        http_util.init(threads=True)
        url = 'http://127.0.0.1:%d/test_threads' % self.port
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        @tornado_util.fn(url=r"/test_threads/?")
        def get_test_threads(self, **kwargs):
            return result

        # 异步 GET 请求，返回线程
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = []
        th1 = http_util.get(url)
        assert len(NOW_LOG_RECORD) == 0 # 通过日志查看有没有发启线程,因为发启线程肯定没有这么快打印日志
        assert isinstance(th1, threading.Thread)
        th1.join() # 等待线程返回，以便检查日志
        assert len(NOW_LOG_RECORD) >= 1
        record = NOW_LOG_RECORD[0]
        assert record is not None
        assert record.levelno == logging.INFO
        assert record.method == 'GET'
        log_msg = record.getMessage()
        assert url in log_msg
        assert result in log_msg

        # 异步 POST 请求，返回线程
        NOW_LOG_RECORD = []
        th2 = http_util.post(url)
        assert len(NOW_LOG_RECORD) == 0 # 通过日志查看有没有发启线程,因为发启线程肯定没有这么快打印日志
        assert isinstance(th2, threading.Thread)
        th2.join() # 等待线程返回，以便检查日志
        assert len(NOW_LOG_RECORD) >= 1
        record = NOW_LOG_RECORD[0]
        assert record is not None
        assert record.levelno == logging.INFO
        assert record.method == 'POST'
        log_msg = record.getMessage()
        assert url in log_msg
        assert result in log_msg

        # 改回默认值，避免影响其它测试
        http_util.init(threads=False)

    # 参数转换
    def test_urlencode(self):
        # 字典转请求参数
        param1 = {'name' : '测试用户', 'password' : 123456}
        assert http_util.urlencode(param1) == 'password=123456&name=%E6%B5%8B%E8%AF%95%E7%94%A8%E6%88%B7'
        assert http_util.urlencode(param1, encode='gbk') == 'password=123456&name=%B2%E2%CA%D4%D3%C3%BB%A7'
        param2 = {'name' : '测试用户', 'password' : {u'哈':[1,2,'3',u'测试']}}
        assert http_util.urlencode(param2) == 'password=%7B%22%5Cu54c8%22%3A+%5B1%2C+2%2C+%223%22%2C+%22%5Cu6d4b%5Cu8bd5%22%5D%7D&name=%E6%B5%8B%E8%AF%95%E7%94%A8%E6%88%B7'
        # 请求参数转字典
        assert str_util.deep_str(http_util.getRequestParams(http_util.urlencode(param1))) == str_util.deep_str(param1, all2str=True)
        assert str_util.deep_str(http_util.getRequestParams('http://xx.xx.com:8080/te?password=123456&name=%E6%B5%8B%E8%AF%95%E7%94%A8%E6%88%B7')) == str_util.deep_str(param1, all2str=True)
        assert str_util.deep_str(http_util.getRequestParams(http_util.urlencode(param2))) == {u'password': u'{"\\u54c8": [1, 2, "3", "\\u6d4b\\u8bd5"]}', u'name': u'测试用户'}

    # 文件类型获取
    def test_content_type(self):
        assert http_util.get_content_type('dsdd/dfsdf.txt') == 'text/plain'
        assert http_util.get_content_type('测试目录\\测试文件.js') == "application/x-javascript"
        # 获取不到后缀的
        assert http_util.get_content_type('dfsdf') == 'application/octet-stream'
        assert http_util.get_content_type('dfsdf.txt.') == 'application/octet-stream'
        assert http_util.get_content_type('dfsdf..') == 'application/octet-stream'
        assert http_util.get_content_type('dfsdf。txt') == 'application/octet-stream'

    # 文件上传测试
    def test_files(self):
        url = 'http://127.0.0.1:%d/test_files' % self.port
        result = '{"use_time": "0.0003", "reason": "\u8bbf\u95ee\u6210\u529f", "version": "2.0.0", "result": 0}'

        @tornado_util.fn(url=r"/test_files/?")
        def get_test_files(self, **kwargs):
            files = self.request.files
            for name, file_metas in files.items():
                for meta in file_metas:
                    filename = meta.get('filename', '')
                    if filename not in (os.path.basename(__file__), '__init__.py'):
                        return {"result": -1, "reason":'文件名有误！', 'file_name':filename}
                    file = open(filename, mode="rb")
                    file_content = file.read()
                    file.close()
                    if meta.get('body', '') != file_content:
                        return {"result": -2, "reason":'文件内容有误！', 'file_name':filename}
            if len(files) != 2:
                return {"result": -3, "reason":'文件数量有误！', 'file_length':len(files)}
            return result

        # 文件上传请求
        res = http_util.post(url, files=[
            {'name':'file1', 'file':__file__},
            {'name':'file2', 'file':'__init__.py'},
        ])
        assert isinstance(res, basestring)
        assert res == result

    # 请求方式测试
    def test_method(self):
        url = 'http://127.0.0.1:%d/get_test_method/' % self.port

        # 定义处理各种请求方式的类
        class MethodHandler(tornado_util.RequestHandler):
            def get(self): return self.finish('get')
            def post(self): return self.finish('post')
            def put(self): return self.finish('put')
            def delete(self): return self.finish('delete')
            def patch(self): return self.finish('patch')
            def options(self): return self.finish('options')

        tornado_util.add_apps(r"/get_test_method/", MethodHandler)

        # 测试请求
        res = http_util.get(url)
        assert isinstance(res, basestring) and res == "get"

        res = http_util.post(url)
        assert isinstance(res, basestring) and res == "post"

        res = http_util.put(url)
        assert isinstance(res, basestring) and res == "put"

        res = http_util.delete(url)
        assert isinstance(res, basestring) and res == "delete"

        res = http_util.patch(url)
        assert isinstance(res, basestring) and res == "patch"

        res = http_util.options(url)
        assert isinstance(res, basestring) and res == "options"



if __name__ == "__main__":
    unittest.main() # 执行所有

    '''
    # 执行指定函数
    suite = unittest.TestSuite()
    suite.addTest(TestHttpUtil("test_send_json"))
    suite.addTest(TestHttpUtil("test_delete_options"))
    unittest.TextTestRunner().run(suite)
    '''

