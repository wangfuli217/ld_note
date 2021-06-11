
#==== 范例1 ==================================================
import tornado
import tornado.httpserver
import tornado.ioloop
import tornado.web
import os.path

# 申明一个 add 函数, 提供给模板文件使用
def add(x, y):
    return (x+y)

# 网页访问处理
class MainHandler(tornado.web.RequestHandler):
    # 参数是 Application 配置中的关键字 参数定义。 比 prepare 更早执行。 一般只是把传入的参数存到成员变量中, 而不会产生一些输出或者调用像 send_error 之类的方法。
    def initialize(self, database):
        print('call initialize, database:', database)
        self.database = database

    # 无论使用了哪种 HTTP 方法, prepare 都会被调用到。prepare可以产生输出 信息。如果它调用了finish(或send_error` 等函数), 那么整个处理流程 就此结束。
    def prepare(self, *args, **kwargs):
        print('call prepare')
        tornado.web.RequestHandler.prepare(self, *args, **kwargs)

    # 处理 get 请求
    def get(self):
        self.set_header("Content-Type", "text/plain") # 设置头部信息,申明这是txt文件,不再按 HTML 来展现
        self.write("You wrote " + self.get_argument("message", '')) # get_argument方法接收参数
        items = ["item1","item2","item3", '222']
        # 可以先 write 一部分内容,再使用模板
        clent_ip = self.request.remote_ip
        self.write("\r\n<br/>You requested the clent_ip: " + clent_ip)
        self.write("\r\n<br/>short URL: " + self.request.uri) # 打印访问路径,不包括域名等
        self.write("\r\n<br/>fall URL: " + self.request.full_url()) # 打印完整的请求路径，包括域名

        # 第一个参数是模板文件, 后面不但可以传递参数, 还可以传递函数, 可扩展性很好而且很强大。
        self.render("templates.html", items=items, add=add)

    # 处理 post 请求
    def post(self):
        return self.get()

    # 执行 finish 前执行
    def on_finish(self):
        print('call on_finish')
        tornado.web.RequestHandler.on_finish(self)

    # post 和 get 处理之后的调用； data 是处理模板后的内容, string类型, 调用self.write或者什么都不显示时为None
    def finish(self, data=None):
        print('finish   data:' + str(data))
        super(MainHandler, self).finish(data)


# 找不到页面的处理
class NotFoundHandler(tornado.web.RequestHandler):
    def prepare(self):
        NOTFOUND_404 = "404.html" # 404文件地址
        if os.path.exists(NOTFOUND_404):
            #self.set_status(404) # 设 404 状态,浏览器可能会跳转到自己定义的找不到页面,要想全部显示一样就不要设置此状态
            self.render(NOTFOUND_404, url = self.request.full_url()) # 输出 404 模板页面
        else:
            self.send_error(404)


# 网址访问的配置
application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/static/(.*)", tornado.web.StaticFileHandler, {'path':os.path.join(os.path.dirname(__file__), "static")}), # 访问静态文件
    (r"/.*", NotFoundHandler), # 找不到页面,必须放在最后
])

if __name__ == "__main__":
    from tornado.options import define, options
    define("port", default=8088, help="run on the given port", type=int)

    # 单进程且单线程启动
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.listen(options.port) # 监听端口号
    tornado.ioloop.IOLoop.instance().start() # 启动

    # 启动命令行: python test.py -port=8081

    # 测试网址:
    # http://localhost:8088/

    '''
    # 上面是通用的单线程启动方式,并发能力差。 下面是多个子进程的方式启动(每个子进程还是单线程),并发能力比上面的强。但是只能 Linux 上这样写,因为用到 fork 函数
    sokets = tornado.netutil.bind_sockets(options.port) # 监听端口号
    import tornado.process; tornado.process.fork_processes(0) # 启动多个子进程,不指定子进程数量则默认按CPU核数来
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.add_sockets(sokets)
    tornado.ioloop.IOLoop.instance().start()
    '''

    '''
    # 这样写也同样可以启动多个子进程(每个子进程还是单线程)
    http_server = tornado.httpserver.HTTPServer(application) # 加载配置
    http_server.bind(options.port) # 监听端口号
    http_server.start(None) # cpu_num forking, 不指定子进程数量则默认按CPU核数来
    tornado.ioloop.IOLoop.instance().start() # 启动
    '''

