
简介
    Tornado( http://www.tornadoweb.org )是Facebook开源出来的框架, 其哲学跟Django近乎两个极端。
    Tornado走的是少而精的方向, 它也有提供模板功能;虽然不鼓励, 但作者是可以允许在模板进行少量编码(直接嵌入单行py代码)的。
    它也有模板, 有国际化支持, 甚至还有内置的OAuth/OpenID模块, 方便做第三方登录, 它其实也直接实现了Http服务器。
    但它没有ORM(仅有一个mysql的超简单封装), 甚至没有Session支持, 更不要说Django那样自动化的后台。
    Tornado本身是单线程的异步网络程序, 它默认启动时, 会根据CPU数量运行多个实例;充分利用CPU多核的优势。
    网站基本都会有数据库操作, 而Tornado是单线程的, 这意味着如果数据库查询返回过慢, 整个服务器响应会被堵塞。

    中文版的文档/教程： http://www.tornadoweb.cn/documentation


一、安装 Tornado
    目前最新版本的下载:  http://github.com/downloads/facebook/tornado/tornado-1.2.1.tar.gz

    解压之后, 进入解压的目录, 执行:
        python setup.py build
        python setup.py install

    如果开发环境是py2.6+, 也可以简单的把tornado目录添加到py的环境变量 PYTHONPATH 中, 这样就不需要编译setup.py(也就是不用安装的意思)


 安装:
    在py2.5, 2.6, 2.7上进行过测试, 如果要使用 tornado 的全部功能, 必须安装 PycURL (版本7.18.2 或者以上, http://pycurl.sourceforge.net/ ), 对py2.5必须安装JSON支持组件simplejson(http://pypi.python.org/pypi/simplejson/), py2.6+以上的JSON支持已经在标准库内实现。

    安装方式:
    下载tarball
    http://packages.debian.org/zh-cn/source/sid/python-tornado

    #Mac OS X 10.6 (Python 2.6+)
    sudo easy_install setuptools pycurl

    #Ubuntu Linux (Python 2.6+)
    sudo apt-get install python-pycurl

    #Ubuntu Linux (Python 2.5)
    sudo apt-get install python-dev python-pycurl python-simplejson


    Linux 的安装命令
    # 解压
    tar xvzf tornado-1.2.tar.gz
    # 进入解压的目录
    cd tornado-1.2
    # 安装
    python setup.py build
    sudo python setup.py install


    Windows 下安装则是直接解压“tornado-*.tar.gz”并运行
    # 进入解压的目录(目录名的“*”需要改成对应的名称)
    cd Django-*
    # 安装 Django
    python setup.py build
    python setup.py install

    安装完以后, 在Python交互环境下应该可以 import tornado 模块
    import tornado; print(tornado.version)  # 打印:  '1.2'



二、模块列表和简介:
    最重要的模块是web模块, 他作为web框架包含了 Tornado 包内大部分的有用的东西, 其他的工具和模块让web变的更有用

    主模块
        web – 用来创建FriendFeed的web框架, 他集成(混合)了大部分 Tornado 的重要功能特征
        escape – XHTML, JSON, and URL 编解码方法
        database -对MySQLdb的简单封装, 让mysql的使用更方便
        template – 基于python的模板渲染语言
        httpclient – 一个非阻塞http客户端, 设计它用来和web和httpserver协同工作
        auth – 第三方认证和认证方案的实现 (Google OpenID/OAuth, Facebook Platform, Yahoo BBAuth, FriendFeed OpenID/OAuth, Twitter OAuth)
        locale – 本地化和翻译支持
        options – 命令行和配置文件解析工具, 为了webserver环境做了优化

    底层模块
        httpserver – A very simple HTTP server built on which web is built
        iostream – A simple wrapper around non-blocking sockets to aide common reading and writing patterns
        ioloop – Core I/O loop

    随机模块:
        s3server – 一个实现了Amazon S3接口的web服务器, 基于本地文件存储


三、Tornado使用概览
  1.请求处理程序和请求参数
    Tornado 的 Web 程序会将 URL 或者 URL 范式映射到 tornado.web.RequestHandler 的子类上去。在其子类中定义了 get() 或 post() 方法, 用以处理不同的 HTTP 请求。

    下面的代码将 URL 根目录 “/” 映射到 “MainHandler”, 还将一个 URL 范式 “/story/([0-9]+)” 映射到 “StoryHandler”。
    正则表达式匹配的分组会作为参数引入 的相应方法中:
     class MainHandler(tornado.web.RequestHandler):
        def get(self):
            self.write("You requested the main page")

    class StoryHandler(tornado.web.RequestHandler):
        def get(self, story_id):
            self.write("You requested the story " + story_id)

    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/story/([0-9]+)", StoryHandler),
    ])


    你可以使用 get_argument() 方法来获取查询字符串参数(如果没有传递此参数过来则会出错), 以及解析 POST 的内容:
     class MainHandler(tornado.web.RequestHandler):
        def get(self):
            self.write('<html><body><form action="/" method="post">'
                       '<input type="text" name="message"/>'
                       '<input type="submit" value="Submit"/>'
                       '</form></body></html>')

        def post(self):
            self.set_header("Content-Type", "text/plain")
            self.write("You wrote " + self.get_argument("message"))

    上传的文件可以通过 self.request.files 访问到, 该对象将名称(HTML元素 <input type="file">的 name 属性)对应到一个文件列表。
    每一个文件都以字典的形式 存在, 其格式为: {"filename":..., "content_type":..., "body":...}。

    如果你想要返回一个错误信息给客户端, 例如“403 unauthorized”, 只需要抛出一个 tornado.web.HTTPError 异常:
     if not self.user_is_logged_in():
        raise tornado.web.HTTPError(403)

    请求处理程序可以通过 self.request 访问到代表当前请求的对象。该 HTTPRequest 对象包含了一些有用的属性, 包括:
     arguments - 所有的 GET 或 POST 的参数
     files - 所有通过 multipart/form-data POST 请求上传的文件
     path - 请求的路径 ( ? 之前的所有内容)
     headers - 请求的头信息

    可以通过查看源代码 httpserver 模组中 HTTPRequest 的定义, 从而了解到它的 所有属性。


  2.重写 RequestHandler 的方法函数
    除了 get()/post() 等以外, RequestHandler 中的一些别的方法函数, 这都是 一些空函数, 它们存在的目的是在必要时在子类中重新定义其内容。
    对于一个请求的处理 的代码调用次序如下:
     1.程序为每一个请求创建一个 RequestHandler 对象
     2.程序调用 initialize() 函数, 这个函数的参数是 Application 配置中的关键字 参数定义。(initialize 方法是 Tornado 1.1 中新添加的, 旧版本中你需要 重写 __init__ 以达到同样的目的) initialize 方法一般只是把传入的参数存 到成员变量中, 而不会产生一些输出或者调用像 send_error 之类的方法。
     3.程序调用 prepare()。无论使用了哪种 HTTP 方法, prepare 都会被调用到, 因此 这个方法通常会被定义在一个基类中, 然后在子类中重用。prepare可以产生输出 信息。如果它调用了finish(或send_error` 等函数), 那么整个处理流程 就此结束。
     4.程序调用某个 HTTP 方法: 例如 get()、 post()、 put() 等。如果 URL 的正则表达式模式中有分组匹配, 那么相关匹配会作为参数传入方法。

    其它设计用来被复写的方法有:
     get_error_html(self, status_code, exception=None, **kwargs) # 以字符串的形式 返回 HTML, 以供错误页面使用。
     get_current_user(self) # 查看下面的用户认证一节
     get_user_locale(self) # 返回 locale 对象, 以供当前用户使用。
     get_login_url(self) # 返回登录网址, 以供 @authenticated 装饰器使用(默认位置 在 Application 设置中)
     get_template_path(self) # 返回模板文件的路径(默认是 Application 中的设置)

  3.重定向(redirect)
    Tornado 中的重定向有两种主要方法: self.redirect, 或者使用 RedirectHandler。
    可以在使用 RequestHandler (例如 get)的方法中使用 self.redirect, 将用户 重定向到别的地方。另外还有一个可选参数 permanent, 你可以用它指定这次操作为永久性重定向。
    该参数会激发一个 301 Moved Permanently HTTP 状态, 这在某些情况下是有用的,  例如, 你要将页面的原始链接重定向时, 这种方式会更有利于搜索引擎优化(SEO)。

    permanent 的默认值是 False, 这是为了适用于常见的操作, 例如用户端在成功发送 POST 请求 以后的重定向。
     self.redirect('/page.html', permanent=True) # 可选参数 permanent，你可以用它指定这次操作为永久性重定向。

    RedirectHandler 会在初始化 Application 时自动生成。
    例如本站的下载 URL, 由较短的 URL 重定向到较长的 URL 的方式是这样的:
     application = tornado.wsgi.WSGIApplication([
        (r"/([a-z]*)", ContentHandler),
        (r"/static/tornado-0.2.tar.gz", tornado.web.RedirectHandler, dict(url="http://github.com/downloads/facebook/tornado/tornado-0.2.tar.gz")),
    ], **settings)

    RedirectHandler 的默认状态码是 301 Moved Permanently, 不过如果你想使用 302 Found 状态码, 你需要将 permanent 设置为 False。
     application = tornado.wsgi.WSGIApplication([
        (r"/foo", tornado.web.RedirectHandler, {"url":"/bar", "permanent":False}),
    ], **settings)

    注意, 在 self.redirect 和 RedirectHandler 中, permanent 的默认值是不同的。 这样做是有一定道理的, self.redirect 通常会被用在自定义方法中, 是由逻辑事件触发 的(例如环境变更、用户认证、以及表单提交)。而 RedirectHandler 是在每次匹配到请求 URL 时被触发。

