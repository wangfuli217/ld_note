#!python
# -*- coding: utf-8 -*-
'''
cherrypy 应用运行在 gevent 上
'''

#from gevent import wsgi
from gevent import pywsgi as wsgi # 感觉这个会更好

import cherrypy
import gevent

class Root:
  @cherrypy.expose
  def index(self):
    gevent.sleep(5)
    return 'Hello, world'

root = Root()

# 启动方式1
app = cherrypy.Application(root, '')
wsgi.WSGIServer(('', 8888), app).serve_forever()

# 启动方式2
def application(environ, start_response):
    cherrypy.tree.mount(root, '/')
    return cherrypy.tree(environ, start_response)
wsgi.WSGIServer(('', 8888), application).serve_forever()

