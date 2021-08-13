#!python
# -*- coding:utf-8 -*-
'''
ip公用函数(获取ip地址)
Created on 2014/7/18
Update on 2016/3/1
@author: Holemar
'''
import re
import socket
import urllib2


__all__=('init', 'auth_ip', 'is_server_ip', 'in_list', 'is_ip', 'is_local_ip', 'get_cherrypy_ip', 'get_tornado_ip', 'get_django_ip', 'get_host')

def init(**kwargs):
    '''
    @summary: 设置本文件的必要值及默认参数值
    @param {list|tuple|set} AUTH_IP_LIST: 信任的ip列表(列表里包含 'unlimited' 表示不限制, 允许“*”作为匹配符如: ['192.168.1.*', '1.*'])
    @param {list|tuple|set} SERVER_IP_LIST: 代理服务器的ip列表,获取客户端ip时会忽略这里配置的地址(允许“*”作为匹配符如: ['192.168.1.*', '1.*'])
    @param {list|tuple|set} get_host_net_list: 获取ip的网站地址
    '''
    # 信任的ip列表
    auth_ip_list = kwargs.get('AUTH_IP_LIST', None)
    if auth_ip_list != None and isinstance(auth_ip_list, (tuple, list, set)):
        global AUTH_IP_LIST
        AUTH_IP_LIST = auth_ip_list
    # 服务器的ip列表
    server_ip_list = kwargs.get('SERVER_IP_LIST', None)
    if server_ip_list != None and isinstance(server_ip_list, (tuple, list, set)):
        global SERVER_IP_LIST
        SERVER_IP_LIST = server_ip_list
    # 获取ip的网站地址
    get_host_net_list = kwargs.get('get_host_net_list', None)
    if get_host_net_list != None and isinstance(get_host_net_list, (tuple, list, set)):
        global _get_host_net_list
        _get_host_net_list.update(get_host_net_list)


# 信任的ip列表(列表里包含 'unlimited' 表示不限制, 允许*作为匹配符如: '192.168.1.*', '1.*')
AUTH_IP_LIST = []
# 服务器的ip列表
#SERVER_IP_LIST = ['113.31.*', '117.121.*']
SERVER_IP_LIST = []


def auth_ip(ip):
    u"""
    @summary: 检查IP地址是否信任地址
    @param {string} ip: 要检查的IP地址(必须传)
    @return {bool}: 如果IP是信任的则返回 True, 否则返回 False
    """
    global AUTH_IP_LIST
    if not AUTH_IP_LIST or "unlimited" in AUTH_IP_LIST or "*" in AUTH_IP_LIST:
        return True
    return in_list(ip, AUTH_IP_LIST)

def is_server_ip(ip):
    u"""
    @summary: 检查IP地址是否服务器地址
    @param {string} ip: 要检查的IP地址(必须传)
    @return {bool}: 如果IP是信任的则返回 True, 否则返回 False
    """
    global SERVER_IP_LIST
    if not SERVER_IP_LIST:
        return False
    return in_list(ip, SERVER_IP_LIST)

def in_list(ip, ip_list):
    '''
    @summary: 检查IP地址在ip列表里面
    @param {string} ip: 要检查的IP地址(必须传)
    @param {list|tuple|set} ip_list: 要判断的的ip列表(列表里允许“*”作为匹配符如: ['192.168.1.*', '1.*'])
    @return {bool}: 如果IP在列表里则返回 True, 否则返回 False
    '''
    if not ip_list:
        return False
    if not is_ip(ip):
        return False
    for x in ip_list:
        # 结尾有一个“*”通配符(写这里是为了提高效率,因为这种写法是最常用的,其实只用下面的“*”通配符完整判断就足够了)
        if x.endswith('*') and x.count('*') == 1:
            if ip.startswith(x.replace('*', '')):
                return True
        # 完整的ip
        elif is_ip(x):
            if x == ip:
                return True
        # 含有“*”通配符
        elif x.count('*') > 0:
            xs = x.split('*')
            if ip.startswith(xs[0]) and ip.endswith(xs[-1]) and len([xx for xx in xs if ip.find(xx) != -1]) == len(xs):
                return True
        # 不是完整ip地址,又没有通配符的,无法判断
        else:
            pass
    return False


def is_ip(ip):
    u"""
    @summary: 检查ip地址是否正确
    @param {string} ip: 要检查的ip地址
    @return {bool}:  如果输入的是正确的ip地址则返回 True, 否则返回 False
    """
    if not ip or not isinstance(ip, basestring):
        return False
    return len([i for i in ip.split('.') if i.isdigit() and (0 <= int(i) <= 255) and (not i.startswith('0') or len(i)==1) ])==4

def is_local_ip(ip):
    u"""
    @summary: 检查ip地址是否局域网地址
    @param {string} ip: 要检查的ip地址
    @return {bool}:  如果输入的是局域网内的ip地址则返回 True, 否则返回 False (IP格式错误返回 False)
    """
    if not is_ip(ip):
        return False
    # 127 开头,本机或者同一IP段
    if ip.startswith('127.'):
        return True
    # 局域网ip: 10.0.0.0-10.255.255.255 / 192.168.0.0-192.168.255.255
    if ip.startswith('10.') or ip.startswith('192.168.'):
        return True
    # 局域网ip: 172.16.0.0-172.31.255.255
    if ip.startswith('172.') and (16 <= int(ip.split('.')[1]) <= 31):
        return True
    # 除上述之外都是外网地址
    return False


def _get_remote_ip(ip_list):
    '''
    @summary: 获取接收的请求过来的ip地址
    @param {string} ip_list 请求中获取到的ip列表
    @return {string}: 发请求过来的IP地址
    '''
    # 可能有代理, 没有“.”的肯定不是IPv4格式
    if not ip_list or not ('.' in ip_list):
        return None
    if is_ip(ip_list) and not is_local_ip(ip_list) and not is_server_ip(ip_list):
        return ip_list
    # 包含多个ip地址
    if "," in ip_list:
        ipList = ip_list.strip().replace(' ','').split(",")
        for ip in ipList:
            if is_ip(ip) and not is_local_ip(ip) and not is_server_ip(ip):
                return ip
    return None

def get_cherrypy_ip(request=None):
    u"""
    @summary: 获取cherrypy接收的请求过来的IP地址
    @param {cherrypy.request} request 必须是 cherrypy 的请求
    @return {string}: 发请求过来的IP地址
    @example:
         ip = get_cherrypy_ip(cherrypy.request)
    """
    if request is None:
        import cherrypy
        request = cherrypy.request
    header = request.headers
    ip = ''
    ipList = header.get("X-Forwarded-For", "").split(",")
    if ipList:
        ip = ipList[0]
    if not ip:
        ip = header.get('X-Real-Ip')
    if not ip:
        ip = header.get('Remote-Addr')
    if not ip:
        ip = header.get('REMOTE-ADDR')
    return ip

def get_tornado_ip(request):
    '''
    @summary: 获取tornado接收的请求过来的ip地址
    @param {tornado.request} request 必须是 tornado 的请求
    @return {string}: 发请求过来的IP地址
    @example:
        class HsHandler(tornado.web.RequestHandler):
            def get(self):
                ip = get_tornado_ip(self.request)
                self.write(ip)
    '''
    headers = request.headers
    clent_ip = _get_remote_ip(headers.get("X-Forwarded-For", ""))
    if not clent_ip:
        clent_ip = _get_remote_ip(headers.get("X-Real-Ip", ""))
    if not clent_ip:
        clent_ip = _get_remote_ip(headers.get("Remote-Addr", ""))
    if not clent_ip:
        clent_ip = _get_remote_ip(request.remote_ip)
    return clent_ip

def get_django_ip(request):
    '''
    @summary: 获取django接收的请求过来的ip地址
    @param {django.request} request 必须是 django 的请求
    @return {string}: 发请求过来的IP地址
    '''
    clent_ip = _get_remote_ip(request.META.get('HTTP_X_FORWARDED_FOR', ''))
    if not clent_ip:
        clent_ip = _get_remote_ip(request.META.get("HTTP_X_REAL_IP", ""))
    if not clent_ip:
        clent_ip = _get_remote_ip(request.META.get("REMOTE_ADDR", ""))
    return clent_ip


def http_get(url, param=None):
    u"""
    @summary: 发出请求获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(get请求时会拼接到 url 上)
    @return {string}: 返回获取的页面内容字符串
    """
    response = urllib2.urlopen(url=url, data=param)
    res = response.read()
    response.close()
    return res

_host_ip = None # 缓存本机ip,没必要每次都去读取
# 获取本机ip地址的外部网站列表(写这里为了允许其它文件修改)
_get_host_net_list = set([
        "http://ip.taobao.com/service/getIpInfo.php?ip=myip",
        #"http://ip.qq.com/cgi-bin/myip", # 腾讯阻止了程序直接访问此页面，故获取不到
        "http://www.ip138.com/ips1388.asp", # 性能太慢，偶尔会卡住
        "http://www.whereismyip.com/",
    ])
def get_host():
    u"""
    @summary: 获取本机的外网ip地址
    @return {string}: 本机的外网ip地址
    """
    # 有缓存则直接返回缓存
    global _host_ip
    global _get_host_net_list
    if _host_ip:
        return _host_ip

    # 先用 socket 获取
    ip_list = socket.gethostbyname_ex(socket.gethostname())
    for ip in ip_list:
        # 忽略掉 空的地址/局域网的地址
        if is_ip(ip) and not is_local_ip(ip):
            _host_ip = ip
            return _host_ip
        # 有可能返回数组,再遍历一次
        elif isinstance(ip, (list, tuple)):
            for xi in ip:
                if is_ip(xi) and not is_local_ip(xi):
                    _host_ip = xi
                    return _host_ip

    # socket 获取的 ip 有可能只是局域网的,需要依赖外部网站获取外网ip
    for url in _get_host_net_list:
        try:
            res = http_get(url)
            this_ip = re.search('\d+\.\d+\.\d+\.\d+',res).group(0)
            if is_ip(this_ip):
                _host_ip = this_ip
                return _host_ip
        except:
            pass

    # 还取不到就没辙了
    return None


if __name__ == "__main__":
    #print ip_auth('1.1.1')
    print get_host()
