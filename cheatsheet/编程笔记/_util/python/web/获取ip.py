#-*- coding: utf-8 -*-


#推荐做法(兼容windows和linux)
######################################################
import re, urllib2
import socket

def is_ip(ip):
    """检查ip地址是否正确
    @param {string} ip: 要检查的ip地址
    @return {boolean}:  如果输入的是正确的ip地址则返回 True, 否则返回 False
    """
    if not ip or not isinstance(ip, (str, unicode)):
        return False
    return len([i for i in ip.split('.') if i.isdigit() and (0 <= int(i) <= 255)])==4

def is_local_ip(ip):
    """检查ip地址是否局域网地址
    @param {string} ip: 要检查的ip地址
    @return {boolean}:  如果输入的是局域网内的ip地址则返回 True, 否则返回 False
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

get_host_cache = None # 缓存本机ip,没必要每次都去读取
def get_host():
    """获取本机ip"""
    # 有缓存则直接返回缓存
    global get_host_cache
    if get_host_cache:
        return get_host_cache

    # 当网站上获取不到, 用 socket 获取
    ip_list = socket.gethostbyname_ex(socket.gethostname())
    for ip in ip_list:
        # 忽略掉 空的地址/局域网的地址
        if is_ip(ip) and not is_local_ip(ip):
            get_host_cache = ip
            return get_host_cache
        # 有可能返回数组,再遍历一次
        elif isinstance(ip, (list, tuple)):
            for xi in ip:
                if is_ip(xi) and not is_local_ip(xi):
                    get_host_cache = xi
                    return get_host_cache

    # 抓取网站的提供的本机ip地址
    def visit_ip(url):
        try:
            opener = urllib2.urlopen(url)
            res = opener.read()
            opener.close()
            return re.search('\d+\.\d+\.\d+\.\d+',res).group(0)
        except:
            return None
    # socket 获取的 ip 有可能只是局域网的,需要依赖外部网站获取外网ip
    net_list = [
        "http://www.whereismyip.com/",
        "http://iframe.ip138.com/ic.asp",
    ]
    for url in net_list:
        try:
            this_ip = visit_ip(url)
            if is_ip(this_ip):
                get_host_cache = this_ip
                return get_host_cache
        except:
            pass

    # 还取不到就没辙了
    return None

print get_host()





######################################################
import re, urllib2
from subprocess import Popen, PIPE
import socket

print "本机的私网IP地址为：" + re.search('\d+\.\d+\.\d+\.\d+',Popen('ipconfig', stdout=PIPE).stdout.read()).group(0)
#print "本机的公网IP地址为：" + re.search('\d+\.\d+\.\d+\.\d+',urllib2.urlopen("http://www.whereismyip.com").read()).group(0)

# 缓存ip,没必要每次都去获取
local_ip = None
def getip():
    '''
        返回公网ip,取不到时返回None
    '''
    global local_ip
    if local_ip: return local_ip

    ip_list = [
        "http://www.ip138.com/ip2city.asp",
        "http://www.whereismyip.com/",
        "http://www.bliao.com/ip.phtml"
    ]
    for ip_url in ip_list:
        try:
            local_ip = visit_ip(ip_url)
            return local_ip
        except:
            pass
    return None

def visit_ip(url):
    '''
        访问网页，以获取网页上显示的ip内容
    '''
    opener = urllib2.urlopen(url)
    if url == opener.geturl():
        str = opener.read()
    return re.search('\d+\.\d+\.\d+\.\d+',str).group(0)


#print "本机的公网IP地址为：" + getip()


#直接获取本地IP(局域网)
'''
    getsocketname:获得本机的信息（IP和port）
    getpeername：获得远程机器的信息（IP和port）
    fileno：每一个socket对应一个fd，使用此方法可以获得fd，为一个整数
'''
print socket.gethostbyname(socket.gethostname())
print socket.gethostbyname_ex(socket.gethostname())


######################################################
#linux下:
import socket
import fcntl
import struct
def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915, # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])
#get_ip_address('lo')环回地址
#get_ip_address('eth0')主机ip地址
