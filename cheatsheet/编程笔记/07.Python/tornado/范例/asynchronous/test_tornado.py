#!python
# -*- coding:utf-8 -*-
'''
Created on 2015/4/2
@author: Holemar
tornado测试
'''
import sys
import time
sys.path.append('../libs') # 导入第三方库, tornado

import tornado
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.gen
import tornado.httpclient

# 这地址，是一个可高并发访问，且每个访问都固定需要 5 秒才返回的
url = "http://127.0.0.1:13161/test"

# 使用 tornado.gen.Task 和指明 tornado.web.asynchronous
class MainHandler1(tornado.web.RequestHandler):
    @tornado.web.asynchronous # 此写法必须指明为异步
    @tornado.gen.engine #用 @tornado.gen.coroutine 效果一样
    def get(self):
        start = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())

        http_client = tornado.httpclient.AsyncHTTPClient()
        response = yield tornado.gen.Task(http_client.fetch, url)
        res = response.body

        end = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        self.finish({'result':0, 'start':start, 'end':end, 'conten':res})
        return

# 只有一个耗时请求
class MainHandler2(tornado.web.RequestHandler):
    @tornado.gen.coroutine # 不能用 @tornado.gen.engine
    def get(self):
        start = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())

        http_client = tornado.httpclient.AsyncHTTPClient()
        response = yield http_client.fetch(url)
        res = response.body

        end = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        self.finish({'result':0, 'start':start, 'end':end, 'conten':res})
        return

# 有多个耗时请求
class MainHandler3(tornado.web.RequestHandler):
    @tornado.gen.coroutine # 不能用 @tornado.gen.engine
    def get(self):
        start = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())

        http_client = tornado.httpclient.AsyncHTTPClient()
        response1, response2 = yield [http_client.fetch(url),
                                      http_client.fetch(url)]
        res = response2.body

        end = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        self.finish({'result':0, 'start':start, 'end':end, 'conten':res})
        return


application = tornado.web.Application([
    (r"/a", MainHandler1),
    (r"/b", MainHandler2),
    (r"/c", MainHandler3),
])

if __name__ == "__main__":
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.listen(8088) # 监听端口号
    tornado.ioloop.IOLoop.instance().start() # 启动
    # 测试网址:
    # http://localhost:8088/a
    # http://localhost:8088/b
    # http://localhost:8088/c

'''
性能测试总结
    使用了 tornado.gen 之后,确实能增加 tornado 的并发能力。比起直接写的时候,单线程的并发能力来讲,已经是飞跃了。
    但是,单进程压力测试时发现,这样的并发能力,大概是 10 线程左右。 远远比不上使用 gevent 的 patch补丁 模式。
'''
