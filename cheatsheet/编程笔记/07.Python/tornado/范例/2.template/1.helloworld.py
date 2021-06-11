#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os.path
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web


from tornado.options import define, options

define("port", default=8888, help="run on the given port", type=int)


# 申明一个 add 函数, 提供给模板文件使用
def add(x, y):
    return (x+y)

# 网页访问处理
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        # 可以先 write 一部分内容,再使用模板
        clent_ip = self.request.remote_ip
        self.write("\r\n<br/>You requested the clent_ip: " + clent_ip)

        items = ["item1","item2","item3", '222']
        # 第一个参数是模板文件, 后面不但可以传递参数, 还可以传递函数, 可扩展性很好而且很强大。
        self.render("helloworld.html", items=items, add=add)


def main():
    tornado.options.parse_command_line() # 接收命令行参数
    print('start port:', options.port) # 显示一下端口值

    application = tornado.web.Application([
            (r"/", MainHandler),
        ],
        # 指定模板目录
        template_path=os.path.join(os.path.dirname(__file__), "templates"),
    )
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port) # 监听端口号
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()

# 启动命令:
#   python 1.helloworld.py
#   python 1.helloworld.py -port=8081
#   python 1.helloworld.py --port=8081

# 测试地址: http://127.0.0.1:8081/
