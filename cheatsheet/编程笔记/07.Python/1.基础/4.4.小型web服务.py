
利用 Python 搭建一个简单的 Web 服务器,快速实现局域网内文件共享。
    1. cd 到准备做服务器根目录的路径下(这目录下的文件将会被共享)
    2. 运行命令：
       python -m Web服务器模块[端口号，默认8000]
       这里的“Web服务器模块”有如下三种：
            BaseHTTPServer: 提供基本的Web服务和处理器类，分别是 HTTPServer 和 BaseHTTPRequestHandler 。
            SimpleHTTPServer: 包含执行GET和HEAD请求的 SimpleHTTPRequestHandler 类。
            CGIHTTPServer: 包含处理 POST 请求和执行 CGIHTTPRequestHandler 类。

       运行如: python -m SimpleHTTPServer 8080

    3. 可以在浏览器中访问:
       http://$HOSTNAME:端口号/路径



有时候，我们需要在两台机器或服务之间做一些简便的、很基础的RPC之类的交互。
    我们希望用一种简单的方式使用B程序调用A程序里的一个方法——有时是在另一台机器上。仅内部使用。
    我并不鼓励将这里介绍的方法用在非内部的、一次性的编程中。我们可以使用一种叫做XML-RPC的协议 (相对应的是这个Python库)，来做这种事情。
    参考:http://en.wikipedia.org/wiki/XML-RPC
    http://docs.python.org/2/library/simplexmlrpcserver.html

    下面是一个使用 SimpleXMLRPCServer 模块建立一个快速的小的文件读取服务器的例子：

        from SimpleXMLRPCServer import SimpleXMLRPCServer

        def file_reader(file_name):

            with open(file_name, 'r') as f:
                return f.read()

        server = SimpleXMLRPCServer(('localhost', 8000))
        server.register_introspection_functions()

        server.register_function(file_reader)
        server.serve_forever()


    客户端：

        import xmlrpclib
        proxy = xmlrpclib.ServerProxy('http://localhost:8000/')
        a = proxy.file_reader('/tmp/secret.txt')
        # 下面是windows的路径写法
        a = proxy.file_reader('E:\\WebDisk\\编程资料\\notes\\readme.txt')
        print(a) # 打印出文件内容

    我们这样就得到了一个远程文件读取工具，没有外部的依赖，只有几句代码(当然，没有任何安全措施，所以只可以在家里这样做)。


