#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os.path
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web


from tornado.options import define, options

define("port", default=8888, help="run on the given port", type=int)

# 网页访问处理
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("hello world!")


# 找不到页面的处理
class NotFoundHandler(tornado.web.RequestHandler):
    def prepare(self):
        #self.set_status(404) # 设 404 状态,浏览器可能会跳转到自己定义的找不到页面,要想全部显示一样就不要设置此状态
        self.render("404.html", url = self.request.full_url()) # 输出 404 模板页面

        # 也可以简单地返回一个默认的 404 错误信息,只是这样不大友好
        #self.send_error(404)


def main():
    tornado.options.parse_command_line() # 接收命令行参数
    print('start port:', options.port) # 显示一下端口值

    application = tornado.web.Application([
            (r"/", MainHandler),
            # ... 假设这里还有好多的url ...
            (r"/static/(.*)", tornado.web.StaticFileHandler, {'path':os.path.join(os.path.dirname(__file__), "static")}), # 访问静态文件

            (r"/.*", NotFoundHandler), # 找不到页面,必须放在最后
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

# 测试地址: http://127.0.0.1:8081/static/test.js
