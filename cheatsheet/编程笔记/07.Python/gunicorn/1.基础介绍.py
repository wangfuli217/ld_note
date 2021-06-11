
Gunicorn (Green Unicorn)是一个 Python WSGI UNIX 的 HTTP 服务器。
这是一个预先叉工人模式(pre-fork worker)，从Ruby的独角兽(Unicorn)项目移植。
该Gunicorn服务器与各种Web框架兼容，我们只要简单配置执行，轻量级的资源消耗，以及相当迅速。
它的特点是与各个web结合紧密，部署特别方便。
缺点也很多，不支持HTTP 1.1，并发访问性能不高。

参见 Gunicorn 官网： http://gunicorn.org/#quickstart
阅读gunicorn代码文档: http://gunicorn.readthedocs.org/en/latest/


特点：
    本身支持WSGI、Django、Paster
    自动辅助进程管理
    简单的 Python配置
    自动管理多个worker进程
    各种服务器的可扩展钩子
    与 Python 2.x > = 2.5 兼容


安装 gunicorn  ~
  方式一:最简单的使用 easy_install / pip 安装或者更新
	pip install gunicorn
    easy_install gunicorn # 两种安装方式都可以

  方式二:下载源码安装
    git clone git://github.com/benoitc/gunicorn.git
    cd gunicorn
    sudo python setup.py install


最简单的运行方式就是：
	gunicorn code:application
	# 其中code就是指code.py，application就是那个wsgifunc的名字。
    # 这样运行的话， gunicorn 默认作为一个监听 127.0.0.1:8000 的web server，可以在本机通过： http://127.0.0.1:8000 访问。


如果要通过网络访问，则需要绑定不同的地址(也可以同时设置监听端口)：
    gunicorn -b 10.2.20.66:8080 code:application


在多核服务器上，为了支持更多的并发访问并充分利用资源，可以使用更多的 gunicorn 进程：
    gunicorn -w 8 code:application
    # 这样就可以启动8个进程同时处理HTTP请求，提高系统的使用效率及性能。 -w 参数表示进程数


gunicorn 默认使用同步阻塞的网络模型(-k sync)，对于大并发的访问可能表现不够好， 它还支持其它更好的模式，比如：gevent或meinheld。
    #  gevent
    gunicorn -k gevent code:application

    #  meinheld
    gunicorn -k egg:meinheld#gunicorn_worker code:application

    当然，要使用这两个东西需要另外安装，具体请参考各自的文档。


需要特殊的初始化方式
    假如在文件里以一个特别的函数初始化 app, 比如

    def init_app(arg0, arg1):
        # ...
        return app

    可以如此法启动
        gunicorn -b 0.0.0.0:8000 -w 4 -k gevent 'test:init_app("value0", "value1")'
        # 看起来有点类似于传命令行参数.



可以通过 -c 参数传入一个配置文件实现。
gunicorn 的配置文件
    [root@66 tmp]# cat gun.conf
    import os
    import multiprocessing
    #workers = 4
    workers = multiprocessing.cpu_count() * 2 + 1
    bind = '127.0.0.1:5000'
    backlog = 2048
    worker_class = "sync"
    debug = True
    proc_name = 'gunicorn.proc'
    pidfile = '/tmp/gunicorn.pid'
    logfile = '/var/log/gunicorn/debug.log'
    loglevel = 'debug'


参数说明：
    -b --bind          ip及端口号，如： -b 10.2.20.66:8080 / --bind='0.0.0.0:5000'
    -w --workers       进程数量，如： -w 8 / --workers=4
    -k --worker-class  网络阻塞模型，如： -k gevent / --worker-class="egg:meinheld#gunicorn_worker"
    -c --config        参数配置文件，如： -c gun.conf / --config=config.py

