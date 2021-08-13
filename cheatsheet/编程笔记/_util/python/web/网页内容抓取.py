

# python2
###### post ###########################
import urllib2, urllib
import sys
import time,datetime
import logging
import json


def http_get(url, param = None, timeout = 21, isJson = False, log_max=100):
    """get方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(会拼接到 url 上)
    @param {int} timeout: 超时时间(单位:秒)
    @param {boolean} isJson: 返回结果是否需要反 json 化
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制)
    @return {string}: 返回获取的页面内容字符串
    @example
        s = http_get('http://www.example.com?a=1&b=uu')
        s = http_get('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    res = None
    use_time = None
    try:
        start = time.clock()
        url = to_str(url)
        if param:
            if isinstance(param, dict):
                param = to_str(param, True) # 必须转码成str,用 unicode 转url编码中文会报错
                param = urllib.urlencode(param)
            # 参数拼接
            url += "&" if "?" in url else "?"
            url += param
        f = urllib2.urlopen(url = url, timeout=timeout)
        res = f.read()
        f.close()
        res = to_unicode(res)
        end =time.clock()
        use_time = unicode(end - start)
        if not log_max or len(res) <= log_max:
            # 日志会遇到编码问题而报错，很冤枉地影响到程序运行
            try:
                logging.info(u"url -->%s, 用时:%s秒, 返回 -->%s" % (url, use_time, res))
            except:
                logging.info(u"url -->%s, 用时:%s秒" % (url, use_time))
        else:
            logging.info(u"url -->%s, 用时:%s秒" % (url, use_time))
        if isJson:
            res = json.loads(res)
            for key, value in res.items():
                res[key] = to_unicode(value) # value 里面的中文显示 unicode 编码,后续优化
        return res
    except:
        if not use_time:
            end =time.clock()
            use_time = unicode(end - start)
        logging.error(u"url 接口调用错误: url:%s, 用时:%s秒, 返回:%s" % (url, use_time, res), exc_info=True)
        raise RuntimeError(u"url 接口调用错误: url:%s, 用时:%s秒, 返回:%s" % (url, use_time, res))
    return res

def post(url, param = None, timeout = 21, isJson = False, log_max=None):
    """post方式获取网页内容
    @param {string} url: 要获取内容的网页地址(GET请求时可直接将请求参数写在此url上)
    @param {dict|string} param: 要提交到网页的参数(会拼接到 url 上)
    @param {int} timeout: 超时时间(单位:秒)
    @param {boolean} isJson: 返回结果是否需要反 json 化
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制)
    @return {string}: 返回获取的页面内容字符串
    @example
        s = post('http://www.example.com?a=1&b=uu')
        s = post('http://www.example.com?a=1', {'name' : 'user1', 'password' : '123456'})
    """
    res = None
    use_time = None
    try:
        start = time.clock()
        url = to_str(url)
        if param:
            param = to_str(param, True)
            if isinstance(param, dict):
                # 转url编码前必须转码成str,用 unicode 转url编码中文会报错
                param = urllib.urlencode(param)
            else:
                param = str(param)
        else:
            param = ''
        f = urllib2.urlopen(url = url, data = param, timeout=timeout)
        res = f.read()
        f.close()
        res = to_unicode(res)
        end =time.clock()
        use_time = unicode(end - start)
        if not log_max or len(res) <= log_max:
            # 日志会遇到编码问题而报错，很冤枉地影响到程序运行
            try:
                logging.info(u"url -->%s, param:%s, 用时:%s秒, 返回 -->%s" % (url, param, use_time, res))
            except:
                logging.info(u"url -->%s, param:%s, 用时:%s秒" % (url, param, use_time))
        else:
            logging.info(u"url -->%s, param:%s, 用时:%s秒" % (url, param, use_time))
        if isJson:
            res = json.loads(res)
            for key, value in res.items():
                res[key] = to_unicode(value) # value 里面的中文显示 unicode 编码,后续优化
        return res
    except:
        if not use_time:
            end =time.clock()
            use_time = unicode(end - start)
        logging.error(u"url 接口调用错误: url:%s, param:%s, 用时:%s秒, 返回:%s" % (url, param, use_time, res), exc_info=True)
        raise RuntimeError(u"url 接口调用错误: url:%s, param:%s, 用时:%s秒, 返回:%s" % (url, param, use_time, res))
    return res


def to_unicode(value, number2str=False):
    """将字符转为 unicode 编码
    @param {任意} value 将要被转码的值,类型可以是:str,unicode,int,long,float,double,dict,list,tuple,其它类型
    @param {boolean} number2str 是否要将数值类型也转成字符串
    @return {unicode|type(value)} 返回转成 unicode 的字符串,或者原本的参数类型
    """
    if value == None:
        return u'' if number2str else None
    if isinstance(value, unicode):
        return value
    # 字符串类型,需要按它原本的编码来解码出 unicode,编码不对会报异常
    if isinstance(value, str):
        for encoding in ("utf-8", "gbk", "cp936", sys.getdefaultencoding(), "gb2312", "gb18030", "big5", "latin-1", "ascii"):
            try:
                value = value.decode(encoding)
                break # 如果上面这句执行没错，说明是这种编码
            except:
                pass
    # 考虑是否需要转成字符串的类型
    if isinstance(value, (bool,int,long,float,complex)):
        return unicode(value) if number2str else value
    # time 类型转成字符串,需要写格式
    if isinstance(value, time.struct_time):
        return time.strftime('%Y-%m-%d %H:%M:%S', value) if number2str else value
    # datetime 类型转成字符串,需要写格式
    if isinstance(value, datetime.datetime):
        return value.strftime('%Y-%m-%d %H:%M:%S') if number2str else value
    # list,tuple 类型,递归转换(tuple类型的会变成list)
    if isinstance(value, (list,tuple,set)):
        arr = []
        for item in value:
            arr.append(to_unicode(item, number2str))
        # 尽量不改变原类型
        if isinstance(value, list):
            return arr
        if isinstance(value, tuple):
            return tuple(arr)
        if isinstance(value, set):
            return set(arr)
    # dict 类型,递归转换(只转换里面的value,不转换key)
    if isinstance(value, dict):
        for key1,value1 in value.items():
            value[key1] = to_unicode(value1, number2str)
        return value
    # 其它类型
    return unicode(value) if number2str else value


def to_str(value, number2str=False, encode="utf-8"):
    """将字符转为utf8编码
    @param {任意} value 将要被转码的值,类型可以是:str,unicode,int,long,float,double,dict,list,tuple,其它类型
    @param {boolean} number2str 是否要将数值类型也转成字符串
    @param {string} encode 编码类型,默认是 utf-8 编码
    @return {str|type(value)} 返回转成 unicode 的字符串,或者原本的参数类型
    """
    try:
        # 字符串类型的,先转成 unicode,再转成 utf8 编码的 str,这样就可以避免编码错误了
        if isinstance(value, (str,unicode)):
            value = to_unicode(value)
            value = value.encode(encode)
            return value
        # list,tuple 类型,递归转换(tuple类型的会变成list)
        if isinstance(value, (list,tuple,set)):
            arr = []
            for item in value:
                arr.append(to_str(item, number2str))
            # 尽量不改变原类型
            if isinstance(value, list):
                return arr
            if isinstance(value, tuple):
                return tuple(arr)
            if isinstance(value, set):
                return set(arr)
        # dict 类型,递归转换(只转换里面的value,不转换key)
        if isinstance(value, dict):
            for key1,value1 in value.items():
                # 字典里面的 key 也转成 utf8 编码
                if isinstance(key1, unicode):
                    del value[key1]
                    key1 = to_str(key1)
                value[key1] = to_str(value1, number2str)
            return value
        # 其它类型,可以部分地交给 to_unicode 处理
        return to_unicode(value, number2str).encode(encode) if number2str else value
    except:
        return value


s = http_get('http://www.ideawu.net/', {'name' : 'www', 'password' : '123456'})
s = http_get('http://www.ideawu.net/', "name=www&password=123456")
s = http_get('http://www.ideawu.net/?name=www&password=123456')
s = post('http://www.ideawu.net/', {'name' : 'www', 'password' : '123456'})
print(s)


# python2
###### get ###########################
import urllib2
import cookielib

def download(url):
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookielib.CookieJar()))
    opener.addheaders = [('User-agent', 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322)')]
    f = opener.open(url)
    s = f.read()
    f.close()
    return s

s = download("http://www.baidu.com/")
print(s)





# python3
#################################
import urllib.request, urllib.error
import http.cookiejar

def download(url):
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
    opener.addheaders = [('User-agent', 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322)')]
    f = opener.open(url)
    s = f.read()
    f.close()
    return s

s = download("http://www.baidu.com/")
print(s)

