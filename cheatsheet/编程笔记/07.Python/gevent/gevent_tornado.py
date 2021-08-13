#!python
# -*- coding: utf-8 -*-
'''
Tornado应用运行在Gevent上 (gevent_tornado.py)
'''
import time

import tornado.web

# 网页访问处理
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        time.sleep(0.02)
        self.write('{"result":0}')


# 网址访问的配置
application = [
    (r"/.*", MainHandler),
]

if __name__ == "__main__":
    # 纯 tornado 启动
    #import tornado
    #import tornado.httpserver
    #import tornado.ioloop
    #http_server = tornado.httpserver.HTTPServer(tornado.web.Application(application)) # 加载配置
    #http_server.listen(13152) # 监听端口号
    #tornado.ioloop.IOLoop.instance().start() # 启动

    # gevent + tornado 启动
    import gevent
    from gevent import monkey
    import tornado.wsgi
    import gevent.pywsgi
    #monkey.patch_socket()
    monkey.patch_all(socket=True, time=True) # 由于上述代码是用 time.sleep ，所以还需要加上 time 补丁才可以看到效果
    server = gevent.pywsgi.WSGIServer(('', 13152), tornado.wsgi.WSGIApplication(application))
    server.serve_forever()
else:
    application = tornado.wsgi.WSGIApplication(application)

    # 测试网址:
    # http://localhost:13152/
    # http://117.121.21.90:13152/story/555
    # http://172.16.12.62:13152/story/555
    # http://127.0.0.1:13152/index/test/test2/kkkk


#nohup python test_tornado.py >/dev/null &
# gunicorn 的启动方式:
#nohup -w 8 gunicorn -b 0.0.0.0:13152  -k gevent test_tornado:application &

