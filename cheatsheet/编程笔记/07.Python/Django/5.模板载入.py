
模板载入

1)直接读取文件
    前面例子都直接在Python代码里面写模板的内容，我们还需要把模板与代码分离
    一种简陋的方式就是把模板保存在文件系统中,然后使用Python内建的文件读取功能得到模板的内容，如：

    # 还是修改前面“views.py”文件的“current_datetime”函数为例
    from django.template import Template, Context
    from django.http import HttpResponse

    def current_datetime(request):
        # 以文件形式读取模板
        fp = open(r'D:\test\mysite\mytemplate.html')
        t = Template(fp.read())
        fp.close()
        return HttpResponse(t.render(Context({'name': 'Jhon'})))


2) 配置的模板载入
    Django提供了方便和强大的API来从硬盘载入模板，从而减少调用模板和模板本身的冗余
    首先你需要在settings文件里告诉Django你把模板放在什么位置。
    Django的settings文件是存放Django实例的配置的地方，它是一个简单的具有模块级变量的Python模块，其中每个设置都是一个变量
    当你运行“django-admin.py startproject mysite”时脚本会为你创建一个默认的settings文件“settings.py”
    由于settings文件仅仅是一个普通的Python模块，设置时可以运行一下以检测语法错误，这将避免settings文件出现Python语法错误

  1,TEMPLATE_DIRS设置: 它告诉Django的模板载入机制在哪里寻找模板
    默认情况下它是一个空的元组，选择一个你喜欢的存放模板的地方并添加到TEMPLATE_DIRS中去

    需要注意的一些事情：
    a. 你可以指定任何目录，只要那个目录下的目录和模板对于你的Web服务器运行时的用户是可读的
       如果你找不到一个放置模板的位置，我们推荐你在Django工程目录下创建一个目录
    b. 不要忘了模板目录最后的逗号，Python需要逗号来区分单元素元组和括号括起来的语句
       这是新手经常犯的错误，如果你想避免这个错误，可以用列表来替代元组，单元素列表不需要结尾的逗号,
       元组比列表略微高效，所以我们推荐使用元组。
    c. 使用绝对路径很简单，如果你想更灵活和松耦合，你可动态构建TEMPLATE_DIRS内容
       使用富有魔力的Python变量 __file__, 它会被自动设成当前代码所在的Python模块的文件名。
    d. 如果你使用Windows，加上硬盘号并使用Unix风格的前斜线而不是后斜线

    例如:
        # Linux/Unix 写法
        TEMPLATE_DIRS = (
            '/home/django/mysite/templates',
        )

        # Windows 写法(需使用Unix风格的前斜线而不是后斜线)
        TEMPLATE_DIRS = (
            'C:/www/django/templates',
        )

        # 列表写法
        TEMPLATE_DIRS = [
            '/home/django/mysite/templates'
        ]

        # 动态载入路径
        import os.path
        TEMPLATE_DIRS = (
            # os.path.join(os.path.basename(__file__), 'templates'),   # 书上的这写法会出问题 =_=!!
            os.path.join(os.path.dirname(os.path.realpath(__file__)), 'templates'), # 我自己改进的写法
        )


  2, 使用Django的模板载入

        # 还是修改前面“views.py”文件的“current_datetime”函数为例
        from django.template.loader import get_template
        from django.template import Context
        from django.http import HttpResponse
        import datetime

        def current_datetime(request):
            now = datetime.datetime.now()
            # 使用 django.template.loarder.get_template()方法载入模板
            # 读取配置指定目录下的文件,这里的配置是读取项目下的 templates目录的文件
            t = get_template('current_datetime.html')
            html = t.render(Context({'current_date': now}))
            return HttpResponse(html)

  3, render_to_response() 方法
     这是Django提供的一个捷径来使用一行代码完成载入模板，填充Context，渲染模板，返回HttpResponse对象的工作
     节省使用 get_template,Template,Context,HttpResponse 这些工作,代码如：

        # 还是修改前面“views.py”文件的“current_datetime”函数为例
        from django.shortcuts import render_to_response
        import datetime

        def current_datetime(request):
            now = datetime.datetime.now()
            # 第一个参数是使用的模板名，对应到模板目录的相对路径
            # 第二个参数是一个用来创建Context的字典；如果不提供第二个参数，它将使用一个空的字典
            return render_to_response('current_datetime.html', {'current_date': now})

  4,locals()小技巧
    locals()返回一个包含当前作用域里面的所有变量和它们的值的字典
    这让你传递值到模板时，保持代码整洁，避免冗余或者过度输入。
    最后要注意的是 locals()导致了一点点开销，因为Python不得不动态创建字典,如果手动指定context字典则可以避免这项开销。
    上面的代码可以重写：

        # 还是修改前面“views.py”文件的“current_datetime”函数为例,其余部分省略
        def current_datetime(request):
            current_date = datetime.datetime.now()
            # locals() 会将方法的所有变量序列化过去，所以变量名要保持一致
            return render_to_response('current_datetime.html', locals())
            return render_to_response('current_datetime.html', {'name1':value1, 'name2':value2}) # 效果相同的写法

  5,模板载入的子目录
    把模板存放模板目录的子目录下，即可通过相对地址访问到。
    因为 render_to_response()是对 get_template()的包装，所以可以在它身上作同样的事情。
    对子目录的深度并没有限制，Windows用户注意使用前斜线而不是后斜线，get_template()使用Unix风格文件名
    例如:
        t = get_template('dateapp/current_datetime.html')
