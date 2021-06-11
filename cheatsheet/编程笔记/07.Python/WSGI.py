
WSGI
　　Web服务器网关接口（Python Web Server Gateway Interface，缩写为WSGI)是Python应用程序或框架和Web服务器之间的一种接口，已经被广泛接受, 它已基本达成它了可移植性方面的目标。
    自从WSGI被开发出来以后，许多其它语言中也出现了类似接口。
　　WSGI 没有官方的实现, 因为WSGI更像一个协议. 只要遵照这些协议,WSGI应用(Application)都可以在任何实现(Server)上运行, 反之亦然。

历史背景
　　以前，如何选择合适的Web应用程序框架成为困扰Python初学者的一个问题，这是因为，一般而言，Web应用框架的选择将限制可用的Web服务器的选择，反之亦然。
    那时的Python应用程序通常是为CGI，FastCGI，mod_python中的一个而设计，甚至是为特定Web服务器的自定义的API接口而设计的。
　　WSGI是作为Web服务器与Web应用程序或应用框架之间的一种低级别的接口，以提升可移植Web应用开发的共同点。WSGI是基于现存的[[CGI]]标准而设计的。

特点
    Python Paste - WSGI底层工具集. 包括多线程, SSL和 基于Cookies, sessions等的验证(authentication)库. 可以用Paste方便得搭建自己的Web框架。
    WSGI:Python Web Server Gateway Interface v1.0
    它是 PEP3333中定义的（PEP3333的目标建立一个简单的普遍适用的服务器与Web框架之间的接口）
    WSGI是Python应用程序或框架和Web服务器之间的一种接口
    WSGI被广泛接受, 已基本达成它了可移植性方面的目标
    在Guido的 Blog 中反复提及, 个人认为WSGI是Python Web方面最Pythonic的
    类似于Java中的"servlet" API。


规范概览
    WSGI有两方：“服务器”或“网关”一方，以及“应用程序”或“应用框架”一方。
        服务方调用应用方，提供环境信息，以及一个回调函数（提供给应用程序用来将消息头传递给服务器方），并接收Web内容作为返回值。
    所谓的 WSGI中间件同时实现了API的两方，因此可以在WSGI服务和WSGI应用之间起调解作用：
        从WSGI服务器的角度来说，中间件扮演应用程序，而从应用程序的角度来说，中间件扮演服务器。“中间件”组件可以执行以下功能：
    重写环境变量后，根据目标URL，将请求消息路由到不同的应用对象。
    允许在一个进程中同时运行多个应用程序或应用框架。
    负载均衡和远程处理，通过在网络上转发请求和响应消息。
    进行内容后处理，例如应用XSLT样式表。


支持WSGI的Web应用框架有很多：
    BlueBream
    bobo
    Bottle
    CherryPy
    Django
    Flask
    Google App Engine's webapp2
    Gunicorn
    prestans
    Pylons
    Pyramid
    restlite
    Tornado
    Trac
    TurboGears
    Uliweb
    web.py
    web2py
    weblayer
    Werkzeug

