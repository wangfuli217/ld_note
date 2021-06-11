
模板
    Tornado 模板其实就是 HTML 文件(也可以是任何文本格式的文件), 其中包含了 Python 控制结构和表达式, 这些控制结构和表达式需要放在规定的格式标记符(markup)中。
    Tornado 的模板支持“控制语句”和“表达语句”, 控制语句是使用 {% 和 %} 包起来的 例如 {% if len(items) > 2 %}。表达语句是使用 {{ 和 }} 包起来的, 例如 {{ items[0] }}。
    控制语句和对应的 Python 语句的格式基本完全相同。支持 if 、 for 、 while 和 try, 这些语句逻辑结束的位置需要用 {% end %} 做标记。我们还通过 extends 和 block 语句实现了模板继承。这些在 template 模块(http://github.com/facebook/tornado/blob/master/tornado/template.py) 的代码文档中有着详细的描述。


tornado的文档非常的匮乏, 不过这是表面现象, 其实个中乾坤都在源文件里, 源文件的注释里有非常的文档资料, 值得仔细研究。
    A simple template system that compiles templates to Python code.
    一个简单的模板系统, 将模板编译成python代码

Basic usage looks like:
基本的用法如下:

    t = template.Template("<html>{{ myvalue }}</html>")
    print t.generate(myvalue="XXX")

Loader is a class that loads templates from a root directory and caches the compiled templates:
加载器是一个从根目录加载模板文件并编译缓存模板的类

    loader = template.Loader("/home/btaylor")
    print loader.load("test.html").generate(myvalue="XXX")

We compile all templates to raw Python. Error-reporting is currently... uh, interesting. Syntax for the templates:
我们编译所有模板为python代码, (目前会报错。。。。注: 可能是开发时候写下来的)

    ### base.html
    <html>
      <head>
        <title>{% block title %}Default title{% end %}</title>
      </head>
      <body>
        <ul>
          {% for student in students %}
            {% block student %}
              <li>{{ escape(student.name) }}</li>
            {% end %}
          {% end %}
        </ul>
      </body>
    </html>

    ### bold.html
    {% extends "base.html" %}

    {% block title %}
        {% try %}
            {{title}} {% comment '当页面上传来 title 变量时使用此变量,否则会抛异常而使用下面的值' %}
        {% except %}
            A bolder title
        {% end %}
    {% end %}

    {% block title2 %} title2 {% end %} {% comment 'titile2 是不会显示在页面上的,因为继承的模块没有这个 block, 但也不会报错' %}

    {% block student %}
      <li><span style="bold">{{ escape(student.name) }}</span></li>
    {% end %}

Unlike most other template systems, we do not put any restrictions on the expressions you can include in your statements.
if and for blocks get translated exactly into Python, you can do complex expressions like:
与其他模板系统不同的是, 我们没有对你在模板声名中植入的表达式做任何限制。
if 和 for 块完全支持Python的语法, 你可以使用完整的写法, 如下:

   {% for student in [p for p in people if p.student and p.age > 23] %}
     <li>{{ escape(student.name) }}</li>
   {% end %}

Translating directly to Python means you can apply functions to expressions easily, like the escape() function in the examples above. You can pass
functions in to your template just like any other variable:
直接转义成python代码意味着你可以轻松的在表达式里调用方法, 譬如上面调用escape函数的例子, 你也可以将函数当成任何其他变量一样的传递到模板中

   ### Python code
   def add(x, y):
      return x + y
   template.execute(add=add)

   ### The template
   {{ add(1, 2) }}

We provide the functions escape(), url_escape(), json_encode(), and squeeze() to all templates by default.
每个模板默认提供了 escape(), url_escape(), json_encode(), and squeeze() 这几个函数


Typical applications do not create `Template` or `Loader` instances by hand, but instead use the `render` and `render_string` methods of `tornado.web.RequestHandler`, which load templates automatically based on the ``template_path`` `Application` setting.
默认的application不会手动创建Template和Loader的实例, 而是通过调用`tornado.web.RequestHandler`实例中的 render, render_string 方法。
这些方法通过Application的setting里面的`template_path`这一项的设置自动加载目录里的模板

Syntax Reference
Template expressions are surrounded by double curly braces: ``{{ ... }}``.
The contents may be any python expression, which will be escaped according to the current autoescape setting and inserted into the output.
Other template directives use ``{% %}``.
These tags may be escaped as ``{{!`` and ``{%!`` if you need to include a literal ``{{`` or ``{%`` in the output.

模板表达式用两个大括号包裹起来: ``{{ ... }}``.
内容可以是任何Python表达式, 表达式会使用当前的 autoescape 设置转义并插入到输出中。
其他模板指令使用 `{%    %}`。这些标签会被转义成 ``{{!``和 ``{%!`` , 如果你需要插入 ``{{``或者 ``{%``到输出中。

``{% apply *function* %}...{% end %}``
    Applies a function to the output of all template code between ``apply`` and ``end``:
    将这个标签之间的模板输出作为一个参数应用到一个方法, 如下:
    {% apply linkify %}{{name}} said: {{message}}{% end %}

``{% autoescape *function* %}``
    Sets the autoescape mode for the current file.
    This does not affect other files, even those referenced by ``{% include %}``.
    Note that autoescaping can also be configured globally, at the `Application` or `Loader`.:
    这个标签用来设置当前文件的自动转义模式。这项设置对其他文件无效, 即时是哪些插入了当前文件的模板。
    自动转义也能够在Application和Loader中全局设置。

        {% autoescape xhtml_escape %}
        {% autoescape None %}

``{% block *name* %}...{% end %}``
    Indicates a named, replaceable block for use with ``{% extends %}``.
    Blocks in the parent template will be replaced with the contents of the same-named block in a child template.:
    表示一个命名的可以被替换的块,  和``{% extends %}``一起使用。在父模板中的这些块将被自模板中同名的块替代

        <!-- base.html -->
        <title>{% block title %}Default title{% end %}</title>
        <!-- mypage.html -->
        {% extends "base.html" %}
        {% block title %}My page title{% end %}

``{% comment ... %}``
    A comment which will be removed from the template output.
    Note that there is no ``{% end %}`` tag; the comment goes from the word ``comment`` to the closing ``%}`` tag.
    注释块, 不会输出。主意不需要 `{% end %}` 标签；
    {% comment 备注信息 %}, {# 备注信息 #} 这两种写法都可以

``{% extends *filename* %}``
    Inherit from another template.
    Templates that use ``extends`` should contain one or more ``block`` tags to replace content from the parent template.
    Anything in the child template not contained in a ``block`` tag will be ignored.  For an example, see the ``{% block %}`` tag.
    继承其他的模板。
    使用extends标签的模板需要包含一个到多个block标签用来替换父模板中的同名的块。
    子模板中任何不在块中的内容将被忽略掉。例子可参见 ``{% block %}``标签那一节

``{% for *var* in *expr* %}...{% end %}``
    Same as the python ``for`` statement.
    for 循环标签, 等同于Python中的for表达式

``{% from *x* import *y* %}``
    Same as the python ``import`` statement.
    import 标签, 等同于 import 表达式

``{% import *module* %}``
    Same as the python ``import`` statement.
    import 标签的另一种写法

``{% if *condition* %}...{% elif *condition* %}...{% else %}...{% end %}``
    Conditional statement - outputs the first section whose condition is true.  (The ``elif`` and ``else`` sections are optional)
    if 条件表达式标签, 等同于python的 if ... elif ... else ... 表达式


``{% include *filename* %}``
    Includes another template file.
    The included file can see all the local variables as if it were copied directly to the point of the ``include`` directive (the ``{% autoescape %}`` directive is an exception).
    Alternately, ``{% module Template(filename, **kwargs) %}`` may be used to include another template with an isolated namespace.
    引用另外的模板文件。
    被引入的文件可以访问引入它的模板的所有locals变量, 相当于是直接copy了被引入模板文件的内容。
    autoescape节有例子。
    另外``{% module Template(filename,**kwargs) %}``可以用来引入一个模板文件在一个独立的namespace中

``{% module *expr* %}``
    Renders a `~tornado.web.UIModule`.  The output of the ``UIModule`` is not escaped:
    插入一个UI模块的标签, UI模块的输出没有经过转义的
        {% module Template("foo.html", arg=42) %}

``{% raw *expr* %}``
    Outputs the result of the given expression without autoescaping.
    不经过转义输出一个表达式的值, 默认情况下会把内容转码成 html 的显示格式

``{% set *x* = *y* %}``
    Sets a local variable.
    创建一个本地变量, 如:
    {% set index = 0 %}
    {% for ar in Result.archives %}
        {% set index += 1 %}
    {% end %}

``{% try %}...{% except %}...{% finally %}...{% end %}``
    Same as the python ``try`` statement.
    和Python 的 try ... except ...  块特性一致

``{% while *condition* %}... {% end %}``
    Same as the python ``while`` statement.
    和Python里 while 语句一致

