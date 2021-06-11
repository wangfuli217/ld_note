urllib Vs urllib2
    urllib2可以接受一个Request对象，并以此可以来设置一个URL的headers，但是urllib只接收一个URL。这意味着，
你不能伪装你的用户代理字符串等。
    urllib模块可以提供进行urlencode的方法，该方法用于GET查询字符串的生成，urllib2的不具有这样的功能。这就
是urllib与urllib2经常在一起使用的原因。

    urllib2模块定义的函数和类用来获取URL（主要是HTTP的），他提供一些复杂的接口用于处理： 
基本认证，重定向，Cookies等。
　　urllib2支持许多的"URL schemes"（由URL中的"："之前的字符串确定 - 例如“FTP”的URL方案如"ftp://python.org/"），
且他还支持其相关的网络协议（如FTP，HTTP）。我们则重点关注HTTP。


urllib2.urlopen(url[, data][, timeout])
　　urlopen方法是urllib2模块最常用也最简单的方法，它打开URL网址，url参数可以是一个字符串url或者是一个Request对象。
URL没什么可说的，Request对象和data在request类中说明，定义都是一样的。
　　对于可选的参数timeout，阻塞操作以秒为单位，如尝试连接（如果没有指定，将使用设置的全局默认timeout值）。
实际上这仅适用于HTTP，HTTPS和FTP连接。

import urllib2
response = urllib2.urlopen('http://python.org/')
html = response.read()

import urllib2
req = urllib2.Request('http://python.org/')
response = urllib2.urlopen(req)
the_page = response.read()

f = urllib2.urlopen(url)
with open("code2.zip", "wb") as code:
   code.write(f.read())
   
class urllib2.Request(url[, data][, headers][, origin_req_host][, unverifiable])
Request类是一个抽象的URL请求。5个参数的说明如下
　　URL——是一个字符串，其中包含一个有效的URL。
　　data——是一个字符串，指定额外的数据发送到服务器，如果没有data需要发送可以为"None"。
目前使用data的HTTP请求是唯一的。当请求含有data参数时，HTTP的请求为POST，而不是GET。数据应该是
缓存在一个标准的application/x-www-form-urlencoded格式中。
import urllib
import urllib2
url = 'http://www.someserver.com/cgi-bin/register.cgi'
values = {'name' : 'Michael Foord',
          'location' : 'Northampton',
          'language' : 'Python' }
data = urllib.urlencode(values)
req = urllib2.Request(url, data)
response = urllib2.urlopen(req)
the_page = response.read()

    headers——是字典类型，头字典可以作为参数在request时直接传入，也可以把每个键和值作为参数调用
add_header()方法来添加。作为辨别浏览器身份的User-Agent header是经常被用来恶搞和伪装的，因为一些HTTP
服务只允许某些请求来自常见的浏览器而不是脚本，或是针对不同的浏览器返回不同的版本。例如，Mozilla Firefox
浏览器被识别为“Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127
import urllib
import urllib2
url = 'http://www.someserver.com/cgi-bin/register.cgi'
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
values = {'name' : 'Michael Foord',
          'location' : 'Northampton',
          'language' : 'Python' }
headers = { 'User-Agent' : user_agent }
data = urllib.urlencode(values)
req = urllib2.Request(url, data, headers)
response = urllib2.urlopen(req)
the_page = response.read()
    
    标准的headers组成是(Content-Length, Content-Type and Host)，只有在Request对象调用urlopen()
（上面的例子也属于这个情况）或者OpenerDirector.open()时加入。两种情况的例子如下：
    使用headers参数构造Request对象，如上例在生成Request对象时已经初始化header，而下例是Request对象
调用add_header(key, val)方法附加header（Request对象的方法下面再介绍）：

import urllib2
req = urllib2.Request('http://www.example.com/')
req.add_header('Referer', 'http://www.python.org/')
r = urllib2.urlopen(req)

    OpenerDirector为每一个Request自动加上一个User-Agent header，所以第二种方法如下（urllib2.build_opener
会返回一个OpenerDirector对象，关于urllib2.build_opener类下面再说）：
import urllib2
opener = urllib2.build_opener()
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
opener.open('http://www.example.com/')

最后两个参数仅仅是对正确操作第三方HTTP cookies 感兴趣，很少用到：
　　origin_req_host——是RFC2965定义的源交互的request-host。默认的取值是cookielib.request_host(self)。
这是由用户发起的原始请求的主机名或IP地址。例如，如果请求的是一个HTML文档中的图像，这应该是包含该图像
的页面请求的request-host。
　　unverifiable ——代表请求是否是无法验证的，它也是由RFC2965定义的。默认值为false。一个无法验证的请求是，
其用户的URL没有足够的权限来被接受。例如，如果请求的是在HTML文档中的图像，但是用户没有自动抓取图像的权限，
unverifiable的值就应该是true。

http://www.cnblogs.com/wly923/archive/2013/05/07/3057122.html