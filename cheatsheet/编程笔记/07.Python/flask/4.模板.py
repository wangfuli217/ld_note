
渲染模板
    在 Python 内部生成 HTML 不好玩，且相当笨拙。
    因为你必须自己负责 HTML 转义，以 确保应用的安全。
    因此， Flask 自动为你配置的 Jinja2(http://jinja.pocoo.org/docs/) 模板引擎。

    使用 render_template() 方法可以渲染模板，你只要提供模板名称和需要 作为参数传递给模板的变量就行了。
    下面是一个简单的模板渲染例子:

        import flask
        app = flask.Flask(__name__)

        @app.route('/hello/')
        @app.route('/hello/<name>')
        def hello(name=None):
            return flask.render_template('hello.html', name=name)

        if __name__ == '__main__':
            app.run()

    Flask 会在 templates 文件夹内寻找模板。
    因此，如果你的应用是一个模块，那么模板 文件夹应该在模块旁边；如果是一个包，那么就应该在包里面：

    情形 1: 一个模块:

        /application.py
        /templates
            /hello.html

    情形 2: 一个包:

        /application
            /__init__.py
            /templates
                /hello.html

    你可以充分使用 Jinja2 模板引擎的威力。更多内容，详见官方 Jinja2 模板文档(http://jinja.pocoo.org/docs/templates/) 。


模板举例：

    <!doctype html>
    <title>Hello from Flask</title>
    {% if name %}
      <h1>Hello {{ name }}!</h1>
    {% else %}
      <h1>Hello World!</h1>
    {% endif %}

    在模板内部你也可以访问 request 、:class:~flask.session 和 g 对象，以及 get_flashed_messages() 函数。

    不理解什么是 g 对象？它是某个可以根据需要储存信息的 东西。
    更多信息参见 g() 对象的文档和 在 Flask 中使用 SQLite 3 文档:
        http://dormousehole.readthedocs.org/en/latest/api.html#flask.g
        http://dormousehole.readthedocs.org/en/latest/patterns/sqlite3.html

    模板在继承使用的情况下尤其有用，其工作原理 模板继承 方案 文档。
    简单的说，模板继承可以使每个页面的特定元素（如页头，导航，页尾）保持 一致。

    自动转义默认开启。
    因此，如果 name 包含 HTML ，那么会被自动转义。
    如果你可以 信任某个变量，且知道它是安全的 HTML （例如变量来自一个把 wiki 标记转换为 HTML 的模块），那么可以使用 Markup 类把它标记为安全的。
    否则请在模板 中使用 |safe 过滤器。
    更多例子参见 Jinja2 文档。



下面简单介绍一下 Markup 类的工作方式：
    >>> from flask import Markup
    >>> Markup('<strong>Hello %s!</strong>') % '<blink>hacker</blink>'
    Markup(u'<strong>Hello &lt;blink&gt;hacker&lt;/blink&gt;!</strong>')
    >>> Markup.escape('<blink>hacker</blink>')
    Markup(u'&lt;blink&gt;hacker&lt;/blink&gt;')
    >>> Markup('<em>Marked up</em> &raquo; HTML').striptags()
    u'Marked up \xbb HTML'

    在 0.5 版更改.

