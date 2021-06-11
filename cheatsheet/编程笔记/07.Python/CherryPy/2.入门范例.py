
一.对象
  1. 官方的一个入门的例子：
    例:
        import cherrypy

        class HelloWorld:
            def index(self):
                return "Hello world!"
            index.exposed = True

        cherrypy.quickstart(HelloWorld())

        # 启动命令(假设这段示例代码写在 test.py 文件里面, 在文件所在目录运行)： python test.py
        # 测试访问地址: http://localhost:8080


   在上面的例子中，创建了一个HelloWorld类，类有一个方法index。
   在cherrypy中，方法名即是被访问的路径；即当访问 http://localhost:8080/hello 时，会自动调用 index() 方法。方法的返回值即是输入到浏览器的内容。
   类似于web服务器的index.html，当访问web服务器时，会自动把index.html发送回来。
   当不指定访问哪个方法时，cherrypy就会自动将对http://localhost:8080/的访问定位到index上。
   在类中，方法必须带有一个参数self。
   当方法会定义之后，必须要使用 .exposed = True 或者在方法前申明 @cherrypy.expose 来表示此能够被浏览器访问到。
   最后，把类的一个实例即对象传递给quickstart()，来启动服务器。


  2.在对象中包含对象
     例:
        import cherrypy

        class OnePage(object):
            def index(self):
                return "one page!"
            index.exposed = True

        class HelloWorld(object):
            one = OnePage()

            @cherrypy.expose  # 这里试试用 @cherrypy.expose 过滤器
            def index(self):
                return "hello world"
            #index.exposed = True

        root = HelloWorld()
        cherrypy.quickstart(root)

        # 测试访问地址: http://localhost:8080       访问的还是 root.index()
        # 测试访问地址: http://localhost:8080/one   访问的是 root.one.index()


二.函数
    也可以直接定义函数，但是得让函数成为实例的成员。
    注意，在外部定义的函数和类里定义的方法不一样，后者带有一个表示类自身的参数 self, 而前者不带。

     例:
        import cherrypy

        class HelloWorld:
            def index(self):
                return "Hello world!"
            index.exposed = True

        def foo():
            return 'Foo!'

        root = HelloWorld()
        root.foo = foo
        foo.exposed = True
        cherrypy.quickstart(root)

        # 测试访问地址: http://localhost:8080       访问的还是 root.index()
        # 测试访问地址: http://localhost:8080/foo   访问的是 root.foo()


三.多层路径
     当有如http://localhost/foo/2008/12/11 类似的url时cherrypy如何处理？

     例:
        import cherrypy

        class HelloWorld:
            def index(self):
                return "Hello world!"
            index.exposed = True

        def foo(year, month, day):
            return '{0}-{1}-{2}'.format(year, month, day)
        foo.exposed = True

        root = HelloWorld()
        root.foo = foo
        cherrypy.quickstart(root)

        # 当访问 “http://localhost:8080/foo/2008/12/11” 时，会输出2008-12-11.
        # 当访问 “http://localhost:8080/foo?year=2009&month=12&day=11” 时，会输出2009-12-11.


    另一个例子：
        import cherrypy

        class HelloWorld:
            def index(self):
                return "Hello world!"
            index.exposed = True

        class Blog:
            def default(self, year, month, day):
                return '{0}-{1}-{2}'.format(year, month, day)
            default.exposed = True

            def another(self, year, month, day):
                return '{0}-{1}-{2}'.format(year, month, day)
            another.exposed = True

        root = HelloWorld()
        root.blog = Blog()
        cherrypy.quickstart(root)

    # 当访问 http://localhost:8080/blog/2008/12/11 或者 http://localhost:8080/blog/another/2008/12/11 时会出现与上例一样的结果。
    注意：此例中的 default 方法，和 index()有类似的行为。 当不给出具体要执行的方法时，若参数个数匹配，则就会执行 default() 方法。
    另外：多层路径也可以使用:对象.对象...方法


四.表单的数据
    对如下表单：
    <form action="http://localhost:8080/doLogin" method="post">
        <p>Username</p>
        <input type="text" name="username" value="" size="15" maxlength="40"/>
        <p>Password</p>
        <input type="password" name="password" value="" size="10" maxlength="40"/>
        <p><input type="submit" value="Login"/></p>
        <p><input type="reset" value="Clear"/></p>
    </form>

    要获取表单中的数据，则：
        import cherrypy

        class HelloWorld:
            def index(self):
                return "Hello world!"
            index.exposed = True

            @cherrypy.expose
            def doLogin(self, username = None, password = None):
                return '{0}-{1}'.format(username, password)

        cherrypy.quickstart(HelloWorld())
        # 测试访问地址: http://localhost:8080/doLogin?username=111&password=222

    如果表单中有超过2个条目的数据，则会出错，这时可以修改下doLogin的参数，使它能够忽略多余的参数：
        def doLogin(self, username = None, password = None, **oth):

    或者直接:
        def doLogin(self, **form):
            return '{0}-{1}'.format(form['username'], form['password'])

    方法 doLogin 其实与方法 default 表现的行为一致，只是用的地方不一样。
    所以在 default 中不能使用字典参数，否则难以区分是要跳转到新函数还是本函数接收参数


返回内容
    返回 json 内容
        import os
        import cherrypy

        class HelloWorld:
            @cherrypy.expose
            @cherrypy.tools.json_out()  # 指定按json格式返回
            def index(self):
                return {'a':"Hello world!", 'b':998}

        current_dir = os.path.dirname(os.path.abspath(__file__))
        # 配置静态解析的地址
        conf = {
                '/static': {'tools.staticdir.on':True, "tools.staticdir.dir": os.path.join(current_dir,"static")}
                 }
        # 修改默认配置
        cherrypy.config.update({'server.socket_host':'0.0.0.0', # 面向外网
                            'server.socket_port':18083, # 设置端口号
                            #'server.socket_queue_size':100,
                            #'server.max_request_header_size':10 * 1024 * 1024,
                            'server.thread_pool':250,
                            #'tools.encode.on':False,
                            #'tools.encode.encoding':'utf8',
                            'response.headers.Content-Type': 'application/json; charset=UTF-8',
                            'engine.autoreload.on':False,
                            'tools.gzip.on': True, # 开启 gzip 压缩模式
                            # session 设置
                            'session_filter.on':True,
                            'sessionFilter.storageType'="File",
                            'sessionFilter.storagePath'="/tmp/sessions",
                            'sessionFilter.Timeout':60,
                            })
        # 三个参数：第一个是访问的类，第二个是访问地址的前缀，第三个是配置信息
        cherrypy.quickstart(HelloWorld(), "/", config=conf)


        # 测试访问地址: http://localhost:8080   显示: {"a":"Hello world!", "b":998}
        此例子中，如果去掉“@cherrypy.tools.json_out()”这句，则页面显示：ab


修改端口号
    python代码中改:
        cherrypy.server.socket_port = 9990  # 修改监听端口，默认8080
        cherrypy.quickstart(HelloWorld()) # 改完端口再启动



http://blog.csdn.net/woods2001/article/details/7356615
http://blog.csdn.net/gashero/article/details/892481
http://blog.csdn.net/gashero/article/details/892504

CherryPy 主要核心设置选项
[global] cherrypy.server.socket_port  # 监听端口，默认8080
[global] cherrypy.server.log_file  # 记录日志，默认关闭
[global] cherrypy.server.log_access_file  # 存储访问日志，默认是显示到屏幕上
[global] cherrypy.server.log_to_screen  # 将日志显示到屏幕，默认为True，发布站点最好用False并写入文件
[global] cherrypy.server.log_tracebacks  # 将跟踪信息写入日志，默认为True。False时只写入500错误
[global] cherrypy.server.max_request_header_size  # 最大header请求大小(bytes)，默认500KB，超过了返回403错误，全局设置，0为不限制。
[global] cherrypy.server.default_content_type  # 返回信息的缺省类型，默认text/html，(by gashero)全局的
[/path] cherrypy.server.max_request_body_size  # 最大body请求大小(bytes)，默认为100MB。如果请求大于此数字，返回413错误。限制用户上传文件大小的好办法。可以具体到目录。0为不限制。

