#!/usr/bin/env python
#coding=utf8
u'''
Created on 2015/5/23
@author: Holemar
开发环境:python 2.7

添加微信公众号菜单
把请求 post 到微信服务器即可,需保证 token, appid, appsecret 这3个配置跟微信服务器上的配置一致
'''

import time
import json
import logging
import urllib, urllib2


# 微信配置
token = 'tokenxxxxxbaibaihe'
appid = 'wx04adf67144462f96'
appsecret = 'c8a599765a9d8fb312e53ac6673ac27c'
http_host_prefix = 'http://www.yueban360.com'


def get_access_token(appid, appsecret):
    u'''获取 access_token,缓存此结果是必需的。如果是多进程的话，还需要用redis等来共享缓存
    每次调微信的接口获取 access_token,都会导致 access_token 被刷新, 且每天的获取次数有限。
    @return {dict}: {'access_token': 'token', 'expires_in': 7200}
    '''
    url = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s'% (appid, appsecret)
    f = urllib.urlopen(url)
    content = f.read()
    logging.info(u"url==>%s, result==>%s" % (url, content))
    data = json.loads(content)
    return data

def create_menu(access_token, item_list):
    u'''创建菜单(post到微信服务器上)'''
    url = 'https://api.weixin.qq.com/cgi-bin/menu/create?access_token=%s' % access_token
    assert  0 < len(item_list) < 4
    for item in item_list:
        if 'sub_button' in item:
            assert  0 < len(item['sub_button']) < 6
    data = json.dumps({'button': item_list}, ensure_ascii=False)
    req = urllib2.Request(url)
    req.add_header('Content-Type', 'application/json')
    response = urllib2.urlopen(req, data)
    content = response.read()
    logging.info(u"url==>%s, result==>%s" % (url, content))
    ret = json.loads(content)
    return ret

if __name__ == '__main__':
    ret = get_access_token(appid, appsecret)
    access_token = ret.get('access_token')
    item_list = [
                {'name':'美丽众筹', 'sub_button': [
                        {'type':'click', 'name':'了解美丽众筹', 'key': 'kickstart_about'}, # 按钮,会post请求过来
                        {'type': 'view', 'name':'发起美丽众筹', 'url': http_host_prefix + '/weixin/kick_start'} # 微信内置浏览器上打开此页面
                      ]
                },
                {'name': '百百盒', 'type': 'view', 'url': http_host_prefix + '/weixin/index' },
                {'name':'个人中心', 'sub_button': [
                        {'type':'view', 'name':'我的订单', 'url': http_host_prefix + '/weixin/my_orders' },
                        {'type': 'view', 'name':'我的现金券', 'url': http_host_prefix + '/weixin/voucher' },
                        {'type': 'view', 'name':'百百盒品牌', 'url': http_host_prefix + '/weixin/about' },
                        {'type': 'view', 'name':'意见反馈', 'url': http_host_prefix + '/weixin/feedback' },
                      ]
                },
           ]

    # 获取不到 access_token
    if not access_token:
        print ret
    # 创建菜单
    else:
        ret = create_menu(access_token, item_list)
        print ret
