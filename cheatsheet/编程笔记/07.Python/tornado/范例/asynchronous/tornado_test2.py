#!python
# -*- coding:utf-8 -*-
'''
Created on 2015/4/2
@author: Holemar
tornado 应用运行在 gevent 上
'''
import sys
import time
sys.path.append('../libs') # 导入第三方库, tornado + gevent

import tornado
import tornado.web

from gevent import monkey
monkey.patch_all()

# 有多个耗时请求
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        start = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        time.sleep(5)
        end = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        self.finish({'result':0, 'start':start, 'end':end})
        return

application = [
    (r"/test", MainHandler),
]

if __name__ == "__main__":
    from tornado.wsgi import WSGIApplication
    from gevent.pywsgi import WSGIServer
    server = WSGIServer(('', 13161), WSGIApplication(application))
    server.serve_forever()

# http://127.0.0.1:13161/test
