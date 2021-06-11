本文主要用python实现了对网站的模拟登录。通过自己构造post数据来用Python实现登录过程。

当你要模拟登录一个网站时，首先要搞清楚网站的登录处理细节（发了什么样的数据，给谁发等...）。我是通过HTTPfox来抓取http数据包来分析该网站的登录流程。同时，我们还要分析抓到的post包的数据结构和header，要根据提交的数据结构和heander来构造自己的post数据和header。

分析结束后，我们要构造自己的HTTP数据包，并发送给指定url。我们通过urllib2等几个模块提供的API来实现request请求的发送和相应的接收。
大部分网站登录时需要携带cookie，所以我们还必须设置cookie处理器来保证cookie。

具体代码和讲解如下


#!/usr/bin/python

import HTMLParser
import urlparse
import urllib
import urllib2
import cookielib
import string
import re

#登录的主页面
hosturl = '******' //自己填写
#post数据接收和处理的页面（我们要向这个页面发送我们构造的Post数据）
posturl = '******' //从数据包中分析出，处理post请求的url

#设置一个cookie处理器，它负责从服务器下载cookie到本地，并且在发送请求时带上本地的cookie
cj = cookielib.LWPCookieJar()
cookie_support = urllib2.HTTPCookieProcessor(cj)
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)
urllib2.install_opener(opener)

#打开登录主页面（他的目的是从页面下载cookie，这样我们在再送post数据时就有cookie了，否则发送不成功）
h = urllib2.urlopen(hosturl)

#构造header，一般header至少要包含一下两项。这两项是从抓到的包里分析得出的。
headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0.1',
           'Referer' : '******'}
#构造Post数据，他也是从抓大的包里分析得出的。
postData = {'op' : 'dmlogin',
            'f' : 'st',
            'user' : '******', //你的用户名
            'pass' : '******', //你的密码，密码可能是明文传输也可能是密文，如果是密文需要调用相应的加密算法加密
            'rmbr' : 'true',   //特有数据，不同网站可能不同
            'tmp' : '0.7306424454308195'  //特有数据，不同网站可能不同

            }

#需要给Post数据编码
postData = urllib.urlencode(postData)

#通过urllib2提供的request方法来向指定Url发送我们构造的数据，并完成登录过程
request = urllib2.Request(posturl, postData, headers)
print request
response = urllib2.urlopen(request)
text = response.read()
print text
