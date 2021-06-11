
URL配置技巧
    修改django-admin.py startproject自动生成的URL配置文件“urls.py”,位于项目的首目录

    方法1：导入模组,使用“模组名.视图名”来指向视图
        from django.conf.urls.defaults import *
        from mysite import views
        urlpatterns = patterns('',
            (r'^now/$', views.current_datetime),
            (r'^now/plus(\d{1,2})hours/$', views.hours_ahead),
        )

    方法2：使用一个包含模块名字和方法名字的字符串,而不是方法对象本身来指向视图
        from django.conf.urls.defaults import *
        urlpatterns = patterns('',
            (r'^now/$', 'mysite.views.current_datetime'),
            (r'^now/plus(\d{1,2})hours/$', 'mysite.views.hours_ahead'),
        )

    方法3：提取出冗余的视图前缀，写在第一个参数里面，之后的参数使用简便的字符串名称
        from django.conf.urls.defaults import *
        # 都以'mysite.views'开始，它们是冗余的; 注意下面的第一个参数
        urlpatterns = patterns('mysite.views',
            (r'^now/$', 'current_datetime'),
            (r'^now/plus(\d{1,2})hours/$', 'hours_ahead'),
        )

    方法4：多种视图前缀时，可将多个patterns()加到一起
        # 旧的(全写在一起，没法提取前缀)：
        from django.conf.urls.defaults import *
        urlpatterns = patterns('',
            (r'^/?$', 'mysite.views.archive_index'),
            (r'^(\d{4})/([a-z]{3})/$', 'mysite.views.archive_month'),
            (r'^tag/(\w+)/$', 'weblog.views.tag'),
        )

        # 新的(分开写多个patterns函数，每个都可以提取前缀)：
        from django.conf.urls.defaults import *
        urlpatterns = patterns('mysite.views',
            (r'^/?$', 'archive_index'),
            (r'^(\d{4})/([a-z]{3})/$','archive_month'),
        )
        # 这里记住是用“+=”来写
        urlpatterns += patterns('weblog.views',
            (r'^tag/(\w+)/$', 'tag'),
        )

    1) 命名组
       URL中可以使用命名的正则表达式组来捕获URL并且传递关键字参数给视图
       一个Python方法可以使用关键字参数或者位置参数来调用，它们是一样的
       在关键字参数调用中，你指定你想传递的参数名和值
       在位置参数调用中，你简单的传递参数而不指定哪个参数匹配哪个值，关联在参数顺序中隐含
       在Python正则表达式中，命名组的语法是“(?P<name>pattern)”，其中name是组的名字，pattern是要匹配的模式

       例：
        # 文件“urls.py”的内容如下：
        from django.conf.urls.defaults import *
        from mysite import views

        urlpatterns = patterns('',
            (r'^test(\d{4})[.]html$', views.year_archive), # 未命名组
            (r'^test(?P<year>\d{4})(?P<month>\d{2})[.]html$', views.month_archive), # 命名组
        )


        # 文件“views.py”的内容如下：
        from django.http import HttpResponse

        # 未命名组, 参数必须按顺序抓取
        def year_archive(request, year):
            html = "the year is %s." % (year)
            return HttpResponse(html)

        # 命名组, 参数可以按名称抓取,不必再在乎顺序
        def month_archive(request, month, year):
            html = "the year is %s, month is %s" % (year, month)
            return HttpResponse(html)

        # 测试访问地址：
        http://127.0.0.1:8000/test2011.html  # views.year_archive 的访问
        http://127.0.0.1:8000/test201108.html # views.month_archive 的访问地址


      匹配和组算法
        如果你同时命名组和未命名组使用两种方式来处理相同的URL模式，URL配置解析器的算法：
        1，如果有命名的参数，Django将使用它，并且忽略未命名的参数
        2，否则，Django视所有的未命名参数为位置参数传递
        3，两种参数都有的情况下，Django将传递一些额外的关键字参数作为关键字参数


    2) 向视图方法传递额外选项
       额外URL配置选项的特性，URL配置中每个模式可能包含了另外一项：一个关键字参数的字典，它将被传递到视图方法中
       注：1.额外URL配置选项字典可以传递任何类型的Python对象，例如可以传递一个模型对象给它。
           2.当命名组与额外URL配置选项字典有冲突时，额外URL配置参数要比捕获的命名组参数优先级高。

       例：
        # 文件“urls.py”的内容如下：
        from django.conf.urls.defaults import *
        from mysite import views

        urlpatterns = patterns('',
            (r'^foo/$', views.foobar_view, {'template_name': 'template1.html'}), # 第三个参数提供额外参数的字典
            (r'^bar/$', views.foobar_view, {'template_name': 'template2.html'}),
        )

        # 文件“views.py”的内容如下：
        from django.shortcuts import render_to_response
        import datetime

        def foobar_view(request, template_name):
            now = datetime.datetime.now()
            return render_to_response(template_name, {'current_date': now})

    3) 伪造捕获的URL配置值
       视图方法仅仅关心它可以得到的参数, 而并不关心这些参数是否来自于URL捕获本身或者额外参数
       因此可以通过额外URL配置选项伪造捕获的URL值来处理具有相同视图的额外的URL

       例：
        # 文件“urls.py”的内容如下：
        from django.conf.urls.defaults import *
        from mysite import views

        # 这里的两个配置，调用同一个视图，而且都正常地传递参数
        urlpatterns = patterns('',
            (r'^mydata/birthday/$', views.my_view, {'month': 'jan', 'day': '06'}),
            (r'^mydata/(?P<month>\w{3})/(?P<day>\d{1,2})/$', views.my_view),
        )

    4) 使用默认视图参数
       它告诉视图如果一个参数值是 None 则使用默认值(好像可以使用伪造捕获的URL配置值来代替这功能)

       例：
        # 文件“urls.py”的内容如下：
        from django.conf.urls.defaults import *
        from mysite import views

        urlpatterns = patterns('',
            (r'^blog/$', views.page),
            (r'^blog/page(?P<num>\d+)/$', views.page),
        )

        # 文件“views.py”的内容如下：
        def page(request, num="1"):
            # Output the appropriate page of blog entries, according to num.
            # ...

    5) 特殊情况下的视图
       如果URL匹配多种模式，它会优先匹配上面的模式(这是短路逻辑)

       例：
        # 虽然第一种情况下的模式也匹配第二种，但它会执行第一种对应的视图
        urlpatterns = patterns('',
            ('^auth/user/add/$', 'views.auth.user_add_stage'),
            ('^([^/]+)/([^/]+)/add/$', 'views.main.add_stage'),
        )

    6) URL配置匹配的内容
       当一个请求过来，Django试图把URL当作普通的Python字符串而不是Unicode字符串来和URL配置模式匹配
       这不包括GET或POST参数，或者域名，它也不包括第一个斜线，因为每个URL都以斜线开头
        例如，对“http://www.example.com/myapp/”的请求, Django将试图匹配“myapp/”
        对“http://www.example.com/myapp/?page=3”, Django将试图匹配“myapp/”



引入其它URL配置
    URL匹配中使用 inclue() 函数
    指向 inclue() 的正则表达式不要包含$(结尾匹配符)，Django将截断匹配的URL并将剩下的部分转交给include的URL配置继续处理

    例如:
        # 文件“urls.py”的内容
        from django.conf.urls.defaults import *
        urlpatterns = patterns('mysite',
            (r'^weblog/', include('blog.urls')), # 视图前缀对 include 同样生效
            (r'^about/$', 'views.about'), # 可以混用include()和 非include()模式
        )

        # “mysite.blog.urls”的内容
        from django.conf.urls.defaults import *
        urlpatterns = patterns('',
            (r'^(\d{4})/$', 'mysite.blog.views.year_detail'),
            (r'^(\d{4})/(\d{2})/$', 'mysite.blog.views.month_detail'),
        )

        # 测试网址
        http://localhost:8000/weblob/2007/
        在第一个URL配置里，模式“r'^weblog/'”会匹配，因为它是一个include()，Django会截取所有匹配的文本，即这里是“'weblob/'”，
        然后剩下部分是“2007/”，它将匹配 mysite.blog.urls 的第一行


    include配置的父URL配置接受捕获的参数也可以传递到视图函数
    额外URL配置选项也可以与include()一起工作

    例如:
        # 文件“urls.py”的内容
        from django.conf.urls.defaults import *
        urlpatterns = patterns('mysite',
            (r'^weblog/', include('blog.urls'), {'name': 'Jhon'}),
        )


generic views
    1, 渲染模板
       django.views.generic.simple.direct_to_template
       渲染一个给定的模板，并把在URL里捕获的参数组成字典作为{{ params }} 变量传递给它。

       例：
        # 文件“urls.py”的内容
        from django.conf.urls.defaults import *
        urlpatterns += patterns('django.views.generic.simple',
            (r'^foo/(?P<pid>\d+)/$', 'direct_to_template', {'template': 'test.html'}),
        )

        # 模板文件“test.html”的内容, 可获取到变量
        <div>id: {{ params.pid }}</div>


    2, 重定向到另一URL
       django.views.generic.simple.redirect_to
       重定向到另一个URL，给定的URL可能包含字典样式的string格式，它将插入到URL
       如果给定的URL是 None, Django将返回一个 HTTP 410(不可用)信息

       例：
        # 文件“urls.py”的内容
        from django.conf.urls.defaults import *
        urlpatterns = patterns('django.views.generic.simple',
            (r'^test(\d{4})[.]html$', 'mysite.views.year_archive'), # 跳转到的网址
            (r'^foo/(?P<year>\d+)/$', 'redirect_to', {'url': r'/test%(year)s.html'}), # 页面跳转
            ('^bar/$', 'redirect_to', {'url': None}), # 请求将返回一个410 HTTP错误
        )

        # 测试网址
        输入网址：  http://127.0.0.1:8000/foo/2011/
        将会跳转到：http://127.0.0.1:8000/test2011.html

        # 获取参数
        URL 的“(?P<name>...)”的参数，需要通过“%(name)s”来获取
        页面跳转时，网址会改变。

