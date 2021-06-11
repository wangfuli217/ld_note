###模块导入###
>>> import pycurl
###创建curl对象###
>>> curl = pycurl.Curl()
###连接等待时间，0则不等待###
>>> curl.setopt(pycurl.CONNECTTIMEOUT,5)
###超时时间###
>>> curl.setopt(pycurl.TIMEOUT,5)
###下载进度条，非0则屏蔽###
>>> curl.setopt(pycurl.NOPROGRESS,0)
###指定HTTP重定向最大次数###
>>> curl.setopt(pycurl.MAXREDIRS,5)
###完成交互后强制断开连接，不重用###
>>> curl.setopt(pycurl.FORBID_REUSE,1)
###设置DNS信息保存时间，默认为120秒###
>>> curl.setopt(pycurl.DNS_CACHE_TIMEOUT,60)
###设置HTTP的User-Agent（自行设置时需跟着常规标准走）###
>>> curl.setopt(pycurl.USERAGENT,"www.ipython.me")
###设置请求的Url###
>>> curl.setopt(pycurl.URL,"http://www.ipython.me")
###将返回的HTTP HEADER定向到回调函数getheader###
>>> curl.setopt(pycurl.HEADERFUNCTION,getheader)
###将返回的内容定向到回调函数getbody###
>>> curl.setopt(pycurl.WRITEHEADERFUNCTION,getbody)
###将返回的HTTP HEADER定向到fileobj文件对象###
>>> curl.setopt(pycurl.WRITEHEADER,fileobj)
###将返回的HTML内容定向到fileobj文件对象###
>>> curl.setopt(pycurl.WRITEDATE,fileobj)
 
getinfo(option):
    对应libcurl的curl_easy_getinfo方法，参数option通过libcurl的常量指定。
 
>>> curl = pycurl.Curl()
###返回HTTP状态码###
>>> curl.getinfo(pycurl.HTTP_CODE)
###传输结束时所消耗的总时间###
>>> curl.getinfo(pycurl.TOTAL_TIME)
###DNS解析所消耗的时间###
>>> curl.getinfo(pycurl.NAMELOOKUP_TIME)
###建立连接所消耗的时间###
>>> curl.getinfo(pycurl.CONNECT_TIME)
###从建立连接到准备传输所消耗的时间###
>>> curl.getinfo(pycurl.PRETRANSFER_TIME)
###从建立连接到数据开始传输所消耗的时间###
>>> curl.getinfo(pycurl.STARTTRANSFER_TIME)
###重定向所消耗的时间###
>>> curl.getinfo(pycurl.REDIRECT_TIME)
###上传数据包大小###
>>> curl.getinfo(pycurl.SIZE_UPLOAD)
###下载数据包大小###
>>> curl.getinfo(pycurl.SIZE_DOWNLOAD)
###平均下载速度###
>>> curl.getinfo(pycurl.SPEED_DOWNLOAD)
###平均上传速度###
>>> curl.getinfo(pycurl.SPEED_UPLOAD)
###HTTP头部大小###
>>> curl.getinfo(pycurl.HEADER_SIZE)


------------------------------------------------
def curl_webSev(URL = 'www.baidu.com'):
    _Curl = pycurl.Curl()
    _Curl.setopt(pycurl.CONNECTTIMEOUT,5)
    _Curl.setopt(pycurl.TIMEOUT,5)
    _Curl.setopt(pycurl.NOPROGRESS,1)
    _Curl.setopt(pycurl.FORBID_REUSE,1)
    _Curl.setopt(pycurl.MAXREDIRS,1)
    _Curl.setopt(pycurl.DNS_CACHE_TIMEOUT,30)
    _Curl.setopt(pycurl.URL,URL)
    try:
        with open(os.path.dirname(os.path.realpath(__file__)) + "/content.txt",'w') as outfile:
            _Curl.setopt(pycurl.WRITEHEADER,outfile)
            _Curl.setopt(pycurl.WRITEDATA,outfile)
            _Curl.perform()
    except Exception as err:
        print "exec error!\n\t%s" %err
        sys.exit()
    print "Http Code:\t%s" %_Curl.getinfo(_Curl.HTTP_CODE)
    print "DNS lookup time:\t%s ms" %(_Curl.getinfo(_Curl.NAMELOOKUP_TIME) * 1000)
    print "Create conn time:\t%s ms" %(_Curl.getinfo(_Curl.CONNECT_TIME) * 1000)
    print "Ready conn time:\t%s ms" %(_Curl.getinfo(_Curl.PRETRANSFER_TIME) * 1000)
    print "Tran Star time:\t%s ms" %(_Curl.getinfo(_Curl.STARTTRANSFER_TIME) * 1000)
    print "Tran Over time:\t%s ms" %(_Curl.getinfo(_Curl.TOTAL_TIME) * 1000)
    print "Download size:\t%d bytes/s" %_Curl.getinfo(_Curl.SIZE_DOWNLOAD)
    print "HTTP header size:\t%d byte" %_Curl.getinfo(_Curl.HEADER_SIZE)
    print "Avg download speed:\t%s bytes/s" %_Curl.getinfo(_Curl.SPEED_DOWNLOAD)
 
if __name__ == '__main__':
    import os
    import sys
    import time
    import pycurl
    if len(sys.argv) == 2:
        curl_webSev(sys.argv[1])
    else:
        curl_webSev()
---------------------------------------------------------
# 以下是一个通过get方法获取大众点评杭州站页面的请求时间统计和字符统计的一个用法，也可以将结果显示，
# 只需要将最后一行的打开即可。

#! /usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import pycurl
import time
class Test:
    def __init__(self):
        self.contents = ''
    def body_callback(self, buf):
        self.contents = self.contents + buf
sys.stderr.write("Testing %s\n" % pycurl.version)
start_time = time.time()
url = 'http://www.dianping.com/'
t = Test()
c = pycurl.Curl()
c.setopt(c.URL, url)
c.setopt(c.WRITEFUNCTION, t.body_callback)
c.perform()
end_time = time.time()
duration = end_time - start_time
print c.getinfo(pycurl.HTTP_CODE), c.getinfo(pycurl.EFFECTIVE_URL)
c.close()
print 'pycurl takes %s seconds to get %s ' % (duration, url)
print 'lenth of the content is %d' % len(t.contents)
#print(t.contents)
    
# ----------------------------------------------------------------------
很多站点需要通过cookie识别，这里封装了三个函数，函数1是对cookile进行自动处理的函数，函数2是定主一个get方法，函数3定义一个post方法：
import pycurl
import StringIO
import urllib
#------------------------自动处理cookile的函数----------------------------------#
def initCurl():
'''初始化一个pycurl对象，
尽管urllib2也支持 cookie 但是在登录cas系统时总是失败，并且没有搞清楚失败的原因。
这里采用pycurl主要是因为pycurl设置了cookie后，可以正常登录Cas系统
'''
        c = pycurl.Curl()
        c.setopt(pycurl.COOKIEFILE, "cookie_file_name")#把cookie保存在该文件中
        c.setopt(pycurl.COOKIEJAR, "cookie_file_name")
        c.setopt(pycurl.FOLLOWLOCATION, 1) #允许跟踪来源
        c.setopt(pycurl.MAXREDIRS, 5)
        #设置代理 如果有需要请去掉注释，并设置合适的参数
        #c.setopt(pycurl.PROXY, ‘http://11.11.11.11:8080′)
        #c.setopt(pycurl.PROXYUSERPWD, ‘aaa:aaa’)
        return c
#-----------------------------------get函数-----------------------------------#
def GetDate(curl, url):
'''获得url指定的资源，这里采用了HTTP的GET方法
'''
        head = ['Accept:*/*',
                'User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64; rv:32.0) Gecko/20100101 Firefox/32.0']
        buf = StringIO.StringIO()
        curl.setopt(pycurl.WRITEFUNCTION, buf.write)
        curl.setopt(pycurl.URL, url)
        curl.setopt(pycurl.HTTPHEADER,  head)
        curl.perform()
        the_page =buf.getvalue()
        buf.close()
        return the_page
#-----------------------------------post函数-----------------------------------#
def PostData(curl, url, data):
'''提交数据到url，这里使用了HTTP的POST方法
备注，这里提交的数据为json数据，
如果需要修改数据类型，请修改head中的数据类型声明
'''
        head = ['Accept:*/*',
                'Content-Type:application/xml',
                'render:json',
                'clientType:json',
                'Accept-Charset:GBK,utf-8;q=0.7,*;q=0.3',
                'Accept-Encoding:gzip,deflate,sdch',
                'Accept-Language:zh-CN,zh;q=0.8',
                'User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64; rv:32.0) Gecko/20100101 Firefox/32.0']
        buf = StringIO.StringIO()
        curl.setopt(pycurl.WRITEFUNCTION, buf.write)
        curl.setopt(pycurl.POSTFIELDS,  data)
        curl.setopt(pycurl.URL, url)
        curl.setopt(pycurl.HTTPHEADER,  head)
        curl.perform()
        the_page = buf.getvalue()
        #print the_page
        buf.close()
        return the_page
#-----------------------------------post函数-----------------------------------#
c = initCurl()
html = GetDate(c, 'http://www.baidu.com')
print html

# ----------------------------------------------------------------------
这是一个将短链接转化为实际的url地址的示例

    import StringIO
    import pycurl
    c = pycurl.Curl()
    str = StringIO.StringIO()
    c.setopt(pycurl.URL, "http://t.cn/Rhevig4")
    c.setopt(pycurl.WRITEFUNCTION, str.write)
    c.setopt(pycurl.FOLLOWLOCATION, 1)
    c.perform()
    print c.getinfo(pycurl.EFFECTIVE_URL)
# http://www.361way.com/python-pycurl/3856.html

import pycurl
import StringIO
##### init the env ###########
c = pycurl.Curl()
c.setopt(pycurl.COOKIEFILE, "cookie_file_name")#把cookie保存在该文件中
c.setopt(pycurl.COOKIEJAR, "cookie_file_name")
c.setopt(pycurl.FOLLOWLOCATION, 1) #允许跟踪来源
c.setopt(pycurl.MAXREDIRS, 5)
#设置代理 如果有需要请去掉注释，并设置合适的参数
#c.setopt(pycurl.PROXY, 'http://11.11.11.11:8080')
#c.setopt(pycurl.PROXYUSERPWD, 'aaa:aaa')
########### get the data && save to file ###########
head = ['Accept:*/*','User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64; rv:32.0) Gecko/20100101 Firefox/32.0']
buf = StringIO.StringIO()
curl.setopt(pycurl.WRITEFUNCTION, buf.write)
curl.setopt(pycurl.URL, url)
curl.setopt(pycurl.HTTPHEADER,  head)
curl.perform()
the_page =buf.getvalue()
buf.close()
f = open("./%s" % ("img_filename",), 'wb')
f.write(the_page)
f.close()


########### Python Curl/Pycurl添加DNS解析支持 ###########
Pycurl底层使用libcurl，请先确定Libcurl是否已支持异步DNS解析c-ares，如不支持可升级libcurl支持异步DNS解析c-ares。
其实Libcurl更新支持为异步DNS如果已安装pycurl不用重新安装Pycurl，见http://www.haiyun.me/archives/1070.html
通过pip安装：
export PATH=/usr/local/curl/bin/:$PATH
export LD_LIBRARY_PATH="/usr/local/curl/lib/"
export PYCURL_SSL_LIBRARY=openssl
pip install pycurl

下载pycurl源码包安装：
wget http://pycurl.sourceforge.net/download/pycurl-7.19.5.1.tar.gz
tar zxvf pycurl-7.19.5.1.tar.gz 
cd pycurl-7.19.5.1
export LD_LIBRARY_PATH="/usr/local/curl/lib/"
python setup.py install --curl-config=/usr/local/curl/bin/curl-config --with-ssl

检查pycurl是否已支持异步DNS解析c-ares：
>>> import pycurl
>>> pycurl.version
'PycURL/7.19.5.1 libcurl/7.40.0 OpenSSL/1.0.1e zlib/1.2.7 c-ares/1.10.0'

安装pycurl后使用时遇到的一些错误：
pycurl.so: undefined symbol: CRYPTO_num_locks
原因：libcurl安装时--with-ssl支持

libcurl link-time ssl backend (openssl) is different from compile-time ssl backend (none/other)
原因：libcurl和pycurl编译时ssl后端不一致，调整见上和libcurl安装

pycurl: libcurl link-time version (7.19.7) is older than compile-time version (7.4.0)
原因：编译pycurl时使用的编译的libcurl动态库，不过现在pycurl现在加载的是系统自带的版本较旧的动态库，解决将编译的libcurl动态库添加到系统动态库，见ldconfig
