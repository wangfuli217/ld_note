
1. django 常用命令
    1) 创建一个项目：
       运行“django-admin.py startproject 项目名”(前提是“django-admin.py”在你的PATH系统变量下)

    2) 没有配置环境变量时，创建一个项目
       # Python 安装目录
       set workPath=D:/Holemar/Program/Python26
       # 建立新项目(“mysite”是项目名，可以任意定义名称)
       %workPath%/python.exe %workPath%/Lib/site-packages/django/bin/django-admin.py startproject 项目名

    3) 创建一个新的app
       # 在项目目录下，运行
       python manage.py startapp app名称

    4) 调用数据库操作的客户端(此客户端必须可用)
       python manage.py dbshell
       基于你的DATABASE_SERVER设置，django将计算出运行哪个命令行客户端


    Model 和 数据库 的命令
       1) syncdb
            python manage.py syncdb

          把模型同步到数据库。创建指定 app 中的 model 对应的数据库表。
          它检查数据库和你的 INSTALLED_APPS 中的所有 app 的所有模型，看看是否有些表已经存在，如果表不存在就创建表。
          如果是第一次使用此命令，会提示是否创建超级用户，输入用户名，Email和密码，接着可以看到在创建索引。
          注意: syncdb 不会同步改动或删除了的模型，如果你改动或删除了一个模型， syncdb 不会更新数据库。

       2) validate
            python manage.py validate

          验证 Model 的正确性，若Model全部有效，会提示：0 errors found.
          如果有错，也会提示出来

       3) sqlall [appname,....]
            python manage.py sqlall app名称

          打印指定 app 的 CREATE TABLE 的语句，包括原始数据，创建索引等.
          sqlall 命令事实上并没有接触数据库或建表，它仅仅将输出打印到屏幕上

       4) sqlreset [appname, ....]
            manage.py sqlreset app名称

          重置表结构，会删除表再重新建表。
          修改了 Model 后，如果不需要保留原来的数据，就使用这个命令更新数据库对应的表。


    South Model
       Django 1.7 中已经集成了South的代码，提供了3个新命令:

       1) makemigrations
          基于当前的 model 创建新的迁移策略文件

            python manage.py makemigrations app名称

       2) migrate
          用于执行迁移动作，具有 syncdb 的功能

            python manage.py migrate app名称

       3) sqlmigrate
          显示迁移的SQL语句，具有 sqlall 的功能

            python manage.py sqlmigrate app名称


2. 开始一个项目
   如果这是你第一次使用Django，你必须注意一些初始化过程
   运行“django-admin.py startproject mysite”将会在你的当前目录下创建一个mysite目录
   运行的命令行如:
     # Python 安装目录
     set workPath=D:/Holemar/Program/Python26
     # 建立新项目(“mysite”是项目名，可以任意定义名称)
     %workPath%/python.exe %workPath%/Lib/site-packages/django/bin/django-admin.py startproject mysite

   注意，如果你使用setup.py安装Django，django-admin.py应该在你的PATH系统变量下
   如果不在PATH里面，你可以从“Python安装目录/Lib/site-packages/django/bin/”找到它
   考虑符号链接它到你的PATH里面，例如/usr/local/bin
   一个项目就是一个Django实例的设置的集合，包括数据库配置、Django的专有设置以及应用程序专有设置
   项目的代码放在Web服务器以外的目录，这样避免别人可能从Web看到你的代码，增强安全性

   startproject创建了什么：
    /mysite/     # 目录，项目名称
    __init__.py  #
    manage.py    # 一个命令行工具，可以让你以多种方式与Django项目交互
    settings.py  # Django项目的配置
    urls.py      # Django项目的URL定义


3. 开发用服务器
   切换到mysite目录，运行“python manage.py runserver”,运行代码如:
        # Python 安装目录
        set pythonPath=D:/Program/Python26
        # 项目目录
        set webPath=D:/PythonTest/mysite
        # 运行“python manage.py runserver”
        %pythonPath%/python.exe %webPath%/manage.py runserver

   这样你就启动了Django开发用服务器，这是一个包含在Django中的开发阶段使用的轻量级Web服务器
   在Django中包含了这个服务器是为了快速开发，这样在产品投入应用之前，就可以不用处理生产环境中web server的配置工作了。
   这个服务器查看你的代码，如果有改动，它自动reload，让你不需重启快速修改你的项目
   这个服务器一次只能可靠地处理一个请求，而且根本没有经过任何安全性的检验
   默认情况下runserver命令启动服务器的端口为8000，只监听本地连接。如果希望改变端口，增加一个命令行参数即可:
   python manage.py runserver 8080
   也可以改变服务器监听的IP地址，当你同其它开发者分享一个开发站点时很有用
   python manage.py runserver 192.168.0.100:8080
   上面的命令使得Django监听任何网络接口，这样的话就允许其它计算机连接该服务器
   试着访问 http://127.0.0.1:8000/，你将会看到“Welcome to Django”的页面



4. 动态Web页面
   1) 建立一个web页面
      a.建立一个名为“views.py”的文件放在你的项目(mysite目录)里面
      b.“views.py”文件的内容，如：

            # 这个例子只是输出服务器内部时间
            # 首先，我们从 django.http模块 import HttpResponse类
            from django.http import HttpResponse
            # Python标准库的 datetime模块 包含一些处理日期和时间的类和方法，并且包含一个返回当前时间的方法
            import datetime

            # 这是一个视图方法，它只是一个Python方法，接受Web请求并返回Web应答
            # 每个视图方法都使用HttpRequest对象作为自己的第一个参数 (视图方法的名字可随意命名)
            def current_datetime(request):
                now = datetime.datetime.now()
                html = "It is now %s." % now
                # 这个应答可以是HTML内容、重定向、404错误、XML文档、图像等等
                # 最后，视图返回一个包含生成的HTML的HttpResponse对象
                return HttpResponse(html)

      c.URL配置
        修改django-admin.py startproject自动生成的URL配置文件“urls.py”,位于项目的首目录,内容如：

            # 导入 django.conf.urls.defaults模块的所有对象，包括一个叫 patterns 的方法
            from django.conf.urls.defaults import *
            # 导入 项目(这里项目名是 mysite)的 views 模组,即前面“views.py”写的内容
            from mysite import views

            urlpatterns = patterns('',
                # 第一个参数是一个正则表达式, 匹配URL地址, 使用'^now/$'，则只有“/now/”匹配
                # 第二个参数是要调用的视图方法
                (r'^now/$', views.current_datetime),
            )

      d.浏览器访问地址 http://127.0.0.1:8000/now/
   2) URL配置和松耦合
      在Django Web程序中，URL定义和视图方法是松耦合的，开发人员可以替换其中一个而不会对另一个产生影响
      对比之下，其他的web开发平台耦合了URL和程序，例如在basic php中，应用的URL取决于代码在文件系统中的位置，
      在CherryPy框架中，URL和应用中的方法名称是相对应的。这些方式看来非常方便，但是长远来看会造成难以管理的问题。
      举例来说，如果我们想改变这个应用的URL，可以对URLconf做一个非常快捷的修改，不用担心隐藏在这个URL之后的函数实现。
      类似的，如果我们想修改视图函数,修改它的逻辑，用不着影响URL就可以做到。
      更进一步，如果我们想把这个方法暴露到多个URL上，也可以通过修改URLconf轻易完成，而无需影响view的代码。
   3) URL模式通配符
      Django的URL配置允许任意的正则表达式来提供强大的URL匹配能力
      在URL模式里把希望保存的数据用括号括起来，我们正是在使用括号从匹配的文本中获得想要的参数数据。
      如: (r'^now/plus(\d{1,2})hours/$', hours_ahead), 把“(\d{1,2})”当成参数读取出来，注意,获取的值始终都是字符串类型。

      视图上获取URL模式的参数，从第二个参数开始接收即可，如:

        # 文件“urls.py”的内容如下：
        from django.conf.urls.defaults import *
        # 导入 mysite.views 模组
        from mysite import views
        urlpatterns = patterns('',
            (r'^now/$', views.current_datetime),
            # 传参数的URL模式：“(\d{1,2})”
            (r'^now/plus(\d{1,2})hours/$', views.hours_ahead),
        )

        # 文件“views.py”的内容如下：
        from django.http import HttpResponse
        import datetime
        # 此函数由于现在不需要用，内容省略
        def current_datetime(request):
            return HttpResponse('')
        # 参数request是一个HttpRequest对象, 而 offset是一个string，它的值是通过URL模式里的那一对括号从请求的URL中得到的。
        # 注意从URL中得到的值始终是string而不是integer，即使这个string是由纯数字构成的。参数offset的名称是随意起的。
        def hours_ahead(request, offset):
            # 把offset转换成整形。
            offset = int(offset)
            dt = datetime.datetime.now() + datetime.timedelta(hours=offset)
            html = "In %s hour(s), it will be %s." % (offset, dt)
            return HttpResponse(html)

        # 访问的测试网址如：
        http://127.0.0.1:8000/now/plus20hours/


4.生成静态页面
    import codecs, os
    from django.template.loader import get_template
    from django.template import Context
    from django.views.static import serve

    # 项目配置信息(项目路径)，在 setting 文件里的写法是： PROJECT_DIR = os.path.dirname(__file__)
    from xyt.settings import PROJECT_DIR

    # 写出文件
    news_file = codecs.open('%s/test.html' % os.path.abspath(PROJECT_DIR), 'wb', 'utf-8')
    try:
        t = get_template('news/newsContent.html')
        html = t.render(Context(locals()))
        news_file.write(html)
    except IOError, ioe:
        raise RpcError(ioe.message)
    finally:
        news_file.close()

    # 返回静态文件
    return serve(request, document_root=PROJECT_DIR, path="test.html")


5.获取参数
    def index(request, other_ars=False):
        # 判断请求类型
        if request.method == 'POST': # 判断发送方式
            print 'POST...'
        # 获取请求参数
        code = request.POST.get('code', '') # 获取post过来的值
        iacs = request.GET.get('iacs') # 获取get的值
        name = request.REQUEST.get('name','') # 获取请求的值
        # 获取请求 url
        scheme = request.META.get('wsgi.url_scheme', 'http') # http / https
        absolute_uri = request.build_absolute_uri() # 带域名的完整请求地址，如“http://127.0.0.1:8080/api/info/?a=1&b=2”
        full_url = request.get_full_path() # 获取带参数URL，如“/api/info/?a=1&b=2”
        url = request.path # 获取不带参数URL，如“/api/info/”
        host = request.get_host() # 获取主机地址，如“127.0.0.1:8080”
        post_data = request.body # post 请求体(发送 xml 或者 json 等内容时这样获取)
        get_data = request.META.QUERY_STRING # get 请求时的参数，如“a=1&b=2”
        return render_to_response('index.html', locals())
