#!python
# -*- coding:utf-8 -*-
u'''
Created on 2015/5/5
@author: Holemar
开发环境:python 2.7,  tornado 3.1.1

微信公众平台: http://mp.weixin.qq.com
登录后，进入开发者中心，修改服务配置
配置的URL为: http://www.xxx.com/weixin/check  (url目前仅支持80端口,且能外网直接访问,我这启动其它的端口然后用nginx转发)
配置的token为: tokenxxxxxbaibaihe
'''
import time
import hashlib
import xml.etree.ElementTree as ET

import tornado
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.gen
import tornado.httpclient

token = 'tokenxxxxxbaibaihe' # 需要对应微信上的配置

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        u'''微信验证接口'''
        print self.request.uri # 请求地址
        echostr = self.get_argument('echostr', 'no param')

        #还需要验证 signature, timestamp, nonce 这3个参数
        signature = self.get_argument('signature')
        timestamp = self.get_argument('timestamp')
        nonce = self.get_argument('nonce')
        # 这3个参数需要先排序再拼接, sha1 加密后的结果等于 signature 参数即为验证通过
        params = [token, timestamp, nonce]
        params.sort()
        tmpStr = hashlib.sha1(''.join(params)).hexdigest()
        # 验证通过后需要原样返回 echostr 参数的内容
        if signature == tmpStr:
            self.finish(echostr) # 需要原样返回这个 echostr 值才算验证通过
            print 'url test sucessful !'
        # 验证不通过,返回其它内容
        else:
            self.finish('') # 验证不通过
            print 'url test fail !'
        return

application = tornado.web.Application([
    (r"/weixin/check/?", MainHandler)
])

if __name__ == "__main__":
    print 'start run ...'
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.listen(18088) # 监听端口号
    tornado.ioloop.IOLoop.instance().start() # 启动
    # 测试网址:
    # http://localhost:18088/weixin/check?echostr=test_echostr&signature=test_signature&timestamp=test_timestamp&nonce=test_nonce
