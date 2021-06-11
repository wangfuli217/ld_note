#!/usr/bin/env python
# -*- coding:utf-8 -*-

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web

from tornado.options import define, options

define("port", default=8888, help="run on the given port", type=int)


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.finish("Hello, world") # 使用 write 是还没输出完毕,可续可以继续 write。 而 finish 是最后调用,后续不再处理

    post = get # 定义 post 函数跟 get 函数同样的处理方法


class StoryHandler(tornado.web.RequestHandler):
    def get(self, story_id):
        self.set_header("Content-Type", "text/plain") # 设置头部信息,申明这是txt文件,不再按 HTML 来展现
        self.write("You wrote " + self.get_argument("message", '')) # get_argument方法接收参数
        # self.get_argument("message") # 这样接收参数，如果没有传递此参数过来则会出错
        # self.get_argument("message", 'default') # 这样接收参数，如果没有传递此参数则用后面的默认值，不会报错，建议使用

        # 不使用模板, 则可直接把内容 write 出去
        self.write("\r\nYou requested the story " + story_id)
        # 可以多次调用 write,把要显示的内容追加上去
        self.write(u"\r\n<input type='button' value='retrun' onclick='window.history.back();'/>")

    def post(self, story_id):
        self.get(story_id) # 这样调用 get 处理方式


# 更多的访问处理方式
class IndexHandler(tornado.web.RequestHandler):
    # 参数是 Application 配置中的关键字 参数定义。 比 prepare 更早执行。 一般只是把传入的参数存到成员变量中, 而不会产生一些输出或者调用像 send_error 之类的方法。
    def initialize(self, database):
        print('call initialize, database:', database)
        self.database = database

    # 无论使用了哪种 HTTP 方法, prepare 都会被调用到。prepare可以产生输出 信息。如果它调用了finish(或send_error` 等函数), 那么整个处理流程 就此结束。
    def prepare(self):
        print('call prepare')

    # 处理post过来的数据, 接收 service_method, argv 两个URL参数
    def post(self, service_method='', argv=''):
        print('method:POST...')
        print('service_method:' + service_method)
        print('argv:' + str(argv))

        print('request.arguments:' + str(self.request.arguments)) # form 表单提交的信息,返回 dict 类型,里面是各参数的值的数组
        print('application:' + str(self.application))

        # 获取get、post的参数
        appid = self.get_argument("appid", "")
        self.write("\r\n<br/>You requested the appid: " + appid)

        # 获取客户端ip (使用反向代理的得另外写)
        clent_ip = self.request.remote_ip
        self.write("\r\n<br/>You requested the clent_ip: " + clent_ip)

    # 处理get提交过来的数据
    def get(self, service_method='', argv=''):
        print('method:GET....')
        self.post(service_method, argv) # 转去调用 post 方法

    # post 和 get 处理之后的调用； data 是处理模板后的内容, string类型, 调用self.write或者什么都不显示时为None
    def finish(self, data=None):
        print('finish   data:' + str(data))
        super(IndexHandler, self).finish(data)


def main():
    tornado.options.parse_command_line() # 接收命令行参数
    print('start port:', options.port) # 显示一下端口值

    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/story/([0-9]+)", StoryHandler), # url 上正则表达式捕获到的值会传递给处理函数, 处理函数必须按这要求接收,不然会报错

        # service_method, argv 两个URL参数可传递给 get post 函数处理; database 传给 initialize 函数
        (r'^/index/(?P<service_method>.*?)(?P<argv>/.*?)?', IndexHandler, dict(database='test')),
    ])
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port) # 监听端口号
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()

# 启动命令:
#   python 2.get_arguments.py
#   python 2.get_arguments.py --port=8081

# 测试地址:
#    http://127.0.0.1:8081/
#    http://127.0.0.1:8081/story/555?message=mmmmm
#    http://127.0.0.1:8081/index/test/test2/kkkk?appid=xxx
