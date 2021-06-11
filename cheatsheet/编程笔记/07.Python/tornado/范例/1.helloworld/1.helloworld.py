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
        self.write("Hello, world")


def main():
    tornado.options.parse_command_line() # 接收命令行参数
    print('start port:', options.port) # 显示一下端口值

    application = tornado.web.Application([
        (r"/", MainHandler),
    ])
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port) # 监听端口号
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()

# 启动命令:
#   python 1.helloworld.py
#   python 1.helloworld.py -port=8081
#   python 1.helloworld.py --port=8081

# 测试地址: http://127.0.0.1:8888/
