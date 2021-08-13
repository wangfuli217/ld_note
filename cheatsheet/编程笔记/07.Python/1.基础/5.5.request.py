
requests官方文档中文版: http://cn.python-requests.org/en/latest/

import requests
r = requests.get('http://www.zhidaow.com')  # 发送请求
print r.status_code  # 状态码,打印: 200
print r.headers['content-type']  # 返回头部信息,打印:'text/html; charset=utf8'
print r.headers # 返回头部信息,打印:{'content-encoding': 'gzip', 'transfer-encoding': 'chunked', 'content-type': 'text/html; charset=utf-8';  ... }
print r.encoding  # 获取网页编码信息,打印:'utf-8'
print r.text  #内容部分（PS，由于编码问题，建议这里使用 r.content ）,打印:u'<!DOCTYPE html>\n<html xmlns="http://www.w3.org/1999/xhtml"...'
print r.content #文档中说r.content是以字节的方式去显示，所以在IDLE中以b开头。但我在cygwin中用起来并没有，下载网页正好。所以就替代了urllib2的urllib2.urlopen(url).read()功能。
print r.json() # 如果返回内容是 json 格式,会自动转成 json 并返回


设置超时时间
    #我们可以通过timeout属性设置超时时间，一旦超过这个时间还没获得响应内容，就会提示错误。
    requests.get('http://github.com', timeout=0.001)


json 参数的请求
    payload = {'wd': '张亚楠', 'rn': '100'}
    r = requests.get("http://www.baidu.com/s", params=payload)
    print r.url # 打印请求地址,会将自动转码的内容打印出来
    # post 请求
    r = requests.post("http://www.baidu.com/s", params=payload)



代理访问
    采集时为避免被封IP，经常会使用代理。requests也有相应的proxies属性。

    import requests
    proxies = {
      "http": "http://10.10.1.10:3128",
      "https": "http://10.10.1.10:1080",
    }
    requests.get("http://www.zhidaow.com", proxies=proxies)
    #如果代理需要账户和密码，则需这样：
    proxies = {
        "http": "http://user:pass@10.10.1.10:3128/",
    }



官方文档
requests的具体安装过程请看：http://docs.python-requests.org/en/latest/user/install.html#install
requests的官方指南文档：http://docs.python-requests.org/en/latest/user/quickstart.html
requests的高级指南文档：http://docs.python-requests.org/en/latest/user/advanced.html#advanced
