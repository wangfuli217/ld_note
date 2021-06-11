#!python
# -*- coding:utf-8 -*-
u'''
Created on 2015/5/5
@author: Holemar
开发环境:python 2.7,  tornado 3.1.1

验证URL部分同范例1的，这里不再改动
消息接收然后回复,用的post接口,这里简单地返回用户说的内容
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
        print(self.request.uri) # 请求地址
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
            print('url test sucessful !')
        # 验证不通过,返回其它内容
        else:
            self.finish('') # 验证不通过
            print('url test fail !')
        return

    def post(self):
        u'''鹦鹉学舌的应答返回'''
        print(u'请求地址:%s, 传来信息:%s' % (self.request.uri, self.request.body))
        msg_tree = ET.fromstring(self.request.body)
        data = {}
        for x in msg_tree:
            data[x.tag] = x.text
        content = data.get('Content') #获得用户所输入的内容
        msgType = data.get("MsgType")
        fromUser = data.get("FromUserName")
        toUser= data.get("ToUserName")
        content = u"您刚才说的是：%s,另外 MsgType:%s,FromUserName:%s,ToUserName:%s" % (content, msgType, fromUser, toUser)
        ret = u'''<xml>
            <ToUserName>%s</ToUserName>
            <FromUserName>%s</FromUserName>
            <CreateTime>%s</CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content>%s</Content>
        </xml>''' % (fromUser, toUser, int(time.time()), content) # 注意,这里的 ToUserName 和 ToUserName 反过来,因为这是回复
        self.finish(ret)
        print(u'返回信息:%s' % ret)
        return


application = tornado.web.Application([
    (r"/weixin/check/?", MainHandler)
])

if __name__ == "__main__":
    print 'start run ...'
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.listen(18088) # 监听端口号
    tornado.ioloop.IOLoop.instance().start() # 启动
