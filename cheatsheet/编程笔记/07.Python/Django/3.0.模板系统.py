
Django模板系统

1) 模板系统基础
    Django模板是一个string文本，它用来分离一个文档的展现和数据
    模板定义了placeholder和表示多种逻辑的tags来规定文档如何展现
    通常模板用来输出HTML，但是Django模板也能生成其它基于文本的形式

2) 变量和模板标签
    1，变量
        用“{{}}”包围起来，如：{{person_name}}，这表示把给定变量的值插入。

    2，块标签
        用“{%%}”包围起来，如：{%if a1%}
        块标签的含义很丰富，它告诉模板系统做一些事情。如：for标签,if标签等等
        模板系统也支持{%else%}等其它逻辑语句

    3，过滤器，过滤器是改变变量显示的方式
        如：“{{ship_date|date:"F j, Y"}}”把ship_date变量传递给过滤器，并给 date 过滤器传递了一个参数“F j, Y”，
        date 过滤器以给定参数的形式格式化日期，过滤器使用管道字符“|”
    4，注释
        用“{# #}”包围的是注释
        注意，模板渲染时注释不会输出，一个注释不能分成多行(多行时认为不是注释)。
        如：{# This is a comment #}

        需要多行注释时，需使用 comment 标签
        {% comment %}
            {% if ... %}
              ....
            {% endif %}
        {% endcomment %}

    5，Django模板支持多种内建的块标签，并且可以定义自己的标签。

    6, include 模板标签
        这个标签允许引入另一个模板的内容，标签的参数是要引入的模板的名字，
        名字可以是变量，也可以是单引号或双引号表示的 string, 例如:
        {% include 'nav.html' %}
        {% include 'includes/nav.html' %}
        {% include template_name %}  {# 变量 template_name 里包含有模板的路径和名称 #}
        注意，请求的模板名前面会加上 TEMPLATE_DIRS(settings.py 里面配置的模板路径)
        如果被引入的模板中包含任何的模板代码，如标签和变量等，它将用父模板的context计算它们
        如果给定的模板名不存在，Django将做下面两件事情中的一件：
            a.如果DEBUG设置为True，你将看到一个TemplateDoesNotExist异常的错误页面
            b.如果DEBUG设置为False，标签将什么也不显示

    7, block 模板标签(模板继承)
        用“{% block %}”和“{% endblock %}”包围起来。父模版定义而子版使用。如下：

        {# 父模版的内容 #}
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
        <html>
            <head>
                <title>{% block title %}{% endblock %}</title>
            </head>
        <body>
            <h1>My helpful timestamp site</h1>
            {% block content %}{% endblock %}
            {% block footer %} {# 如果有输入这个模板，则使用输入的，没有则使用这里定义的内容 #}
              <hr><p>Thanks for visiting my site.</p>
            {% endblock %}
        </body>
        </html>

        {# 子版的内容, 使用父模版，父模版的名称是“base.html” #}
        {% extends "base.html" %} {# 使用 extends 标签来引入父模版 #}
        {% block title %}The current time{% endblock %} {# 给父模版的 block title 赋值 #}
        {% block content %}
            <p>It is now {{ current_date }}.</p> {# 变量也可以像一般的使用 #}
        {% endblock %}
        {# 没有给母版的 block footer 赋值，则这块使用父模版默认的 #}

        它是这样工作的：
            1，当你载入模板时，模板引擎发现{% extends %}标签，注意到这是一个子模板；模板引擎马上载入父模板base.html
            2，模板引擎在base.html里发现了{% block %}标签，就用子模板的内容替换了这些块
            于是定义的{% block 块名称 %}和{% block content %}被使用
            注意，既然子模板没有定义footer块，那么模板系统直接使用父模板的值；父模板的内容可以作为后援方案。

        关于模板继承的小提示：
            a. 如果在模板里使用{% extends %}的话，这个标签必须在所有模板标签的最前面，否则模板继承不工作
            b. 通常基本模板里的{% block %}越多越好，子模板不必定义所有的父block，钩子越多越好
            c. 如果你在很多模板里复制代码，很可能你应该把这些代码移动到父模板里
            d. 如果你需要得到父模板的块内容，{{ block.super }}变量可以帮你完成工作
            当你需要给父块添加内容而不是取代它的时候这就很有用
            e. 不能在同一模板里定义多个同名的{% block %}，不管是父模板还是子模板都不能这样做，否则抛错。
            f. 你给{% extends %}传递的模板名同样会被 get_template()使用，所以会加上TEMPLATE_DIRS设置
            g. 大部分情况下，{% extends %}的参数是硬编码的 string,但是也可以是变量，这将增进动态效果。
            h. 子模板中{% block %}标签以外的任何内容都不会被渲染。

3) 使用模板系统
    在Python代码中使用模板系统，请按照下面的步骤：
    1，用模板代码创建一个 Template 对象
        Django也提供指定模板文件路径的方式创建 Template 对象
    2，使用一些给定变量 Context 调用 Template 对象的 render() 方法
        这将返回一个完全渲染的模板，它是一个 string ，其中所有的变量和块标签都会根据 Context 得到值

4) 例子,以修改前面的“views.py”文件的“current_datetime”函数为例，访问地址还是“/now/”：

    # 文件“views.py”的内容如下：
    # Template 类在 django.template 模块中,使用模板必须先导入它; 导入 Context 为了传递参数
    from django.template import Template, Context
    from django.http import HttpResponse
    import datetime

    # 调用模板的形式来显示
    def current_datetime(request):
        now = datetime.datetime.now()
        # 创建一个 Template 对象
        t = Template("<html><body><div style='color:red'>It is now {{ current_date }}.</div></body></html>")
        # 传递参数; Context 的参数是一个映射变量名和变量值的字典
        c = Context({"current_date": now})
        html = t.render(c)
        return HttpResponse(html)

    # 访问的测试网址如下:
    http://127.0.0.1:8000/now/

5) TemplateSyntaxError异常
    如果模板代码有语法错误，调用Template()方法会触发TemplateSyntaxError异常,可能出于以下情况：
    1，不合法的块标签
    2，合法块标签接受不合法的参数
    3，不合法的过滤器
    4，合法过滤器接受不合法的参数
    5，不合法的模板语法
    6，块标签没关

6) 渲染模板(给模板传参数)
    可以通过给一个 context 来给 Template 对象传递数据
    context是一个变量及赋予的值的集合，模板使用它来得到变量的值，或者对于块标签求值
    这个context由django.template模块的Context类表示
    它的初始化函数有一个可选的参数：一个映射变量名和变量值的字典
    通过context调用Template对象的render()方法来填充模板
    变量名必须以字母(A-Z或a-z)开始，可以包含数字，下划线和小数点，变量名大小写敏感
    修改上面“views.py”文件的“current_datetime”函数为例

    # 只写要显示的这一个函数，其它内容省略
    def current_datetime(request):
        raw_template = """<html><body>
        <p>Dear {{ person_name }},</p>
        <p>Thanks for ordering {{ product }} from {{ company }}. It's scheduled to
           ship on {{ ship_date|date:"F j, Y" }}.</p> {# 过滤器 #}

        {% if ordered_warranty %} {# if标签 #}
        <p>Your warranty information will be included in the packaging.</p>
        {% endif %} {# if结束标签 #}

        <p>Sincerely,<br />{{ company }}</p>
        </body></html>"""
        t = Template(raw_template)
        c = Context({'person_name': 'John Smith',   # 字符串的传参
            'product': 'Super Lawn Mower',
            'company': 'Outdoor Equipment',
            'ship_date': datetime.date(2009, 4, 2), # 过滤器赋值
            'ordered_warranty': True})              # Boolean型赋值,为if标签用
        html = t.render(c)
        return HttpResponse(html)

7) 同一个模板渲染多次
    一旦创建了一个模板对象，可以渲染多个context
    使用同一个模板来渲染多个context的话，创建一次 Template 对象然后调用render()多次会更高效,如

    # 差做法，效率低下
    for name in ('John', 'Julie', 'Pat'):
        t = Template('Hello, {{ name }}') # 多次创建 Template 对象,然后逐个渲染
        print(t.render(Context({'name'： name})))

    # 好做法，效率高
    t = Template('Hello, {{ name }}') # 只创建一个 Template 对象,然后多次渲染
    for name in ('John', 'Julie', 'Pat'):
        print(t.render(Context({'name': name})))

    另外:
        Django的模板解析非常快，在后台，大部分的解析通过一个单独的对正则表达式的调用来做
        这与基于XML的模板引擎形成鲜明对比，XML解析器比Django的模板渲染系统慢很多

8) Context变量查找
    模板系统能优雅的处理更复杂的数据结构，如列表，字典和自定义对象
    在Django模板系统中处理复杂数据结构的关键是使用“.”符号
    使用小数点来得到字典的key，属性，对象的索引和方法等。如：

    # 修改上面“views.py”文件的“current_datetime”函数为例, 只写要显示的这一个函数，其它内容省略
    def current_datetime(request):
        raw_template = """<html><body>
        <p>{{ person.name }} is {{ person.age }} years old.</p> {# 显示： Sally is 43 years old. #}
        <p>The month is {{ date.month }} and the year is {{ date.year }}.</p> {# date.year 显示1993, date.month 显示5 #}
        <p>Item 2 is {{ items.2 }}.</p> {# “.”也可以调用列表的索引 #}
        <p>{{ var }} -- {{var.upper }} -- {{ var.isdigit }}.</p> {# “.”访问对象的方法,这里访问字符串的方法 #}
        </body></html>"""
        t = Template(raw_template)
        c = Context({'person': {'name': 'Sally', 'age': '43'},   # 通过“.”访问字典的key
            'date': datetime.date(1993, 5, 2), # 通过“.”来访问对象的属性
            'items': ['apples', 'bananas', 'carrots'], # “.”也可以调用列表的索引
            'var': 'hello'})  # “.”访问对象的方法,这里访问字符串的方法
        html = t.render(c)
        return HttpResponse(html)

    注:
        负数的列表索引是不允许的，例如模板变量{{ items.-1 }}将触发TemplateSyntaxError
        调用方法时你不能加括号，你也不能给方法传递参数 ;只能调用没有参数的方法

    当模板系统遇到变量名里有小数点时会按以下顺序查找：
        1，字典查找，如 foo["bar"]
        2，属性查找，如 foo.bar
        3，方法调用，如 foo.bar()
        4，列表的索引查找，如 foo[bar]
        小数点可以多级纵深查询，例如{{ person.name.upper }}表示字典查询person['name']然后调用upper()方法

9) 方法调用
    方法调用要比其他的查询稍微复杂一点，下面是需要记住的几点：
    1，在方法查询的时候，如果一个方法触发了异常，这个异常会传递从而导致渲染失败，但是如果异常有一个值为 True 的 silent_variable_failure 属性，这个变量会渲染成空字符串, 如：

    # 将会抛出异常
    def current_datetime(request):
        # 函数里面定义内部类
        class PersonClass4:
            def first_name(self):
                raise AssertionError, "foo"
        t = Template("My name is {{ person.first_name }}.")
        p = PersonClass4()
        html = t.render(Context({"person": p}))
        return HttpResponse(html)

    # 将显示：“My name is .”
    def current_datetime(request):
        # 定义异常类
        class SilentAssetionError(AssertionError):
            silent_variable_failure = True
        # 所抛异常的 silent_variable_failure 属性的值为 True
        class PersonClass4:
            def first_name(self):
                raise SilentAssetionError
        t = Template("My name is {{ person.first_name }}.")
        p = PersonClass4()
        html = t.render(Context({"person": p}))
        return HttpResponse(html)

  2，方法调用仅仅在它没有参数时起作用，否则系统将继续查找下一个类型(列表索引查询)
  3，显然一些方法有副作用，让系统访问它们是很愚蠢的，而且很可能会造成安全性问题。
     例如对象有一个delete()方法，模板系统不应该允许调用它，如："{{ object.delete }}"
     为了防止这种状况，可以在方法里设置一个方法属性“alters_data=True”,模板系统就不会执行这个方法,如：

        # 类里面的 delete 方法，其它部分省略
        def delete(self):
            # Delete the object
        # 定义这方法的属性
        delete.alters_data = True

10) 不合法的变量的处理
    默认情况下如果变量不存在，模板系统会把它渲染成空 string,
    在现实情形下，一个web站点因为一个模板代码语法的错误而变得不可用是不可接受的。
    也可以通过设置Django配置更改Django的缺省行为。
    如：

    # 空的 Context(), 显示: Your name is .
    def current_datetime(request):
        t = Template('Your name is {{ name }}.')
        return HttpResponse(t.render(Context()))

    # 变量不存在时渲染成空字符串, 显示：Your name is , My Name is .
    def current_datetime(request):
        # 模板中的变量没有被赋值，则显示空字符串
        t = Template('Your name is {{ name }}, My Name is {{ my.name }}.')
        c = Context({'var': 'hello',  # Context 传的值模板不接收,则这个值不显示
            'Name': 'hello'}) # 名称是区分大小写的,所以这个值也传不过去
        return HttpResponse(t.render(c))

11) Context对象
    大多数情况下初始化 Context 对象会传递一个字典给 Context(),
    一旦初始化了Context，就可以使用标准Python字典语法增减 Context 对象的 items,如

    # 空的 Context
    print(Context()) # 打印： [{}]

    c = Context({"foo": "bar"})
    print(c['foo']) # 打印: bar
    del c['foo'] # 删减 Context 的 items 也是允许的
    c['newvariable'] = 'hello' # 也可以随时增加 Context 的 items

    # Context对象是一个 stack(栈), 还可以push()和pop()
    print(c) # 打印： [{'newvariable': 'hello'}]
    c.push() # 插入一个字典到列表后面
    print(c) # 打印： [{'newvariable': 'hello'}, {}]
    c.pop()  # 删去列表的一个字典
    print(c) # 打印： [{'newvariable': 'hello'}]
    # 如果 pop() 得太多的话,它将触发 django.template.ContextPopException
    c.pop()  # 这将会抛出异常


12) Django模板系统的限制
   1，模板不能设置和改变变量的值(内置Django模板标签不允许这样做)
   2，模板不能调用原生Python代码
   此外，所有这些功能都可以通过自定义标签来做


13) 关闭自动转义功能
    Django 的模板中会对 HTML标签 和 JS 等语法标签进行自动转义，原因显而易见，这样是为了安全。但是有的时候我们可能不希望这些HTML元素被转义。

    为了在 Django 中关闭 HTML 的自动转义有两种方式，如果是一个单独的变量我们可以通过过滤器“|safe”的方式告诉Django这段代码是安全的不必转义。比如：
        <p>这行代表会被自动转义</p>: {{ data }}
        <p>这行代表不会被自动转义</p>: {{ data|safe }}
    其中第二行我们关闭了 Django 的自动转义。


    我们还可以通过 {%autoescape off%} 的方式关闭整段代码的自动转义，比如下面这样：
        {% autoescape off %}
            Hello {{ name }}
        {% endautoescape %}

        {% autoescape off %}
            This will not be auto-escaped: {{ data }}.
            Nor this: {{ other_data }}
            {% autoescape on %}
                Auto-escaping applies again: {{ name }}
            {% endautoescape %}
        {% endautoescape %}


    另外需要注意的一点是autoescape是存在继承性的，比如你在父模板中有一个autoescape标签并且参数为off，那么继承它的子模板也会在相应的部分继承这一特性。比如：

        # base.html
        {% autoescape off %}
            <h1>{% block title %}{% endblock %}</h1>
            {% block content %}{% endblock %}
        {% endautoescape %}

        # child.html
        {% extends "base.html" %}
        {% block title %}This & that{% endblock %}
        {% block content %}{{ greeting }}{% endblock %}


    最后要提一下 字符串的default过滤器，比如下面这个例子：
        {{ data|default:"This is a string literal." }}

    如果你在default:后面的缺省值中包含了HTML特殊字符，那么是不会被转义的，比如你应该按照下面第一种的方式来写，而不是第二种：
        # 正确的写法
        {{ data|default:"3 &lt; 2" }}
        # 错误的写法
        {{ data|default:"3 < 2" }}
