#!python
# -*- coding:utf-8 -*-
'''
公用函数(ip处理) ip_util.py 的测试
Created on 2014/12/9
Updated on 2016/2/16
@author: Holemar
'''
import time
import logging
import unittest

import __init__
from libs_my import ip_util

class IpUtilTest(unittest.TestCase):
    def test_is_ip(self):
        # 判断是否正确的ip
        logging.warn(u'判断是否正确的ip')
        assert ip_util.is_ip('0.0.0.0')
        assert ip_util.is_ip('255.255.255.255')
        assert ip_util.is_ip('127.0.0.1')
        assert ip_util.is_ip('192.168.1.1')
        assert ip_util.is_ip('117.121.51.66')
        assert ip_util.is_ip('113.13.81.134')
        assert not ip_util.is_ip('1.1.11')
        assert not ip_util.is_ip('0.0.00.')
        assert not ip_util.is_ip('0.0.00.000')
        assert not ip_util.is_ip('11.12.51.256')
        assert not ip_util.is_ip('-11.12.51.26')
        assert not ip_util.is_ip('11.12.-1.21')
        assert not ip_util.is_ip('localhost')
        assert not ip_util.is_ip('www.xxx.com')
        assert not ip_util.is_ip('http://www.xxx.com')

    def test_is_local_ip(self):
        # 判断是否局域网的ip
        logging.warn(u'判断是否局域网的ip')
        assert not ip_util.is_local_ip('0.0.0.0')
        assert not ip_util.is_local_ip('255.255.255.255')
        assert ip_util.is_local_ip('127.0.0.1')
        assert ip_util.is_local_ip('127.127.0.1')
        assert ip_util.is_local_ip('10.10.55.66')
        assert ip_util.is_local_ip('172.16.0.0')
        assert ip_util.is_local_ip('172.16.55.66')
        assert ip_util.is_local_ip('172.31.255.255')
        assert not ip_util.is_local_ip('172.15.1.255')
        assert not ip_util.is_local_ip('172.32.1.23')
        assert ip_util.is_local_ip('192.168.0.0')
        assert ip_util.is_local_ip('192.168.1.1')
        assert ip_util.is_local_ip('192.168.1.101')
        assert ip_util.is_local_ip('192.168.255.255')
        assert not ip_util.is_local_ip('192.168.1.256') # ip 错误
        assert not ip_util.is_local_ip('117.121.51.66')
        assert not ip_util.is_local_ip('113.13.81.134')
        assert not ip_util.is_local_ip('localhost')

    def test_is_server_ip(self):
        # 服务器的ip列表 判断
        logging.warn(u'服务器的ip列表 判断测试')
        # 没有服务器ip,所以任何ip都返回 False
        ip_util.init(SERVER_IP_LIST=[])
        assert not ip_util.is_server_ip('127.0.0.1')
        assert not ip_util.is_server_ip('192.168.1.1')
        assert not ip_util.is_server_ip('117.121.51.66')
        assert not ip_util.is_server_ip('113.13.81.134')
        # 任何ip都认为是服务器ip
        ip_util.init(SERVER_IP_LIST=['*'])
        assert ip_util.is_server_ip('117.121.51.66')
        assert ip_util.is_server_ip('117.121.21.84')
        assert ip_util.is_server_ip('113.13.81.134')
        # 结尾有“*”通配符
        ip_util.init(SERVER_IP_LIST=['11.12.*'])
        assert ip_util.is_server_ip('11.12.51.255')
        assert ip_util.is_server_ip('11.12.0.0')
        assert not ip_util.is_server_ip('11.12.51.256') # 非正常ip
        assert not ip_util.is_server_ip('11.121.51.66')
        assert not ip_util.is_server_ip('211.12.51.66')
        assert not ip_util.is_server_ip('66.11.12.51')
        # 有“*”通配符
        ip_util.init(SERVER_IP_LIST=['*11.12.*', '11.12.*'])
        assert ip_util.is_server_ip('11.12.51.255')
        assert ip_util.is_server_ip('11.12.0.0')
        assert ip_util.is_server_ip('211.12.51.66')
        assert ip_util.is_server_ip('66.11.12.51')
        assert not ip_util.is_server_ip('11.12.51.256') # 非正常ip
        assert not ip_util.is_server_ip('11.121.51.66')
        assert not ip_util.is_server_ip('211.121.51.66')

    def test_get_host(self):
        logging.warn(u'获取本机ip测试')
        start_time = time.time()
        host = ip_util.get_host()
        use_time = time.time() - start_time
        assert ip_util.is_ip(host)
        assert not ip_util.is_local_ip(host)
        logging.warn(u'本机ip:%s, 用时:%.4f秒' % (host, use_time))
        # 逐个地址测试
        url_list = ip_util._get_host_net_list
        for url in url_list:
            start_time = time.time()
            ip_util._get_host_net_list = [url]
            ip_util._host_ip = None
            _host = ip_util.get_host()
            use_time = time.time() - start_time
            logging.warn(u'本机ip:%s, 用时:%.4f秒, 获取来源:%s' % (_host, use_time, url))
            if _host:
                assert _host == host


if __name__ == "__main__":
    unittest.main()
