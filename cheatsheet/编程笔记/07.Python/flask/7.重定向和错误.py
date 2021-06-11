
重定向和错误
    使用 redirect() 函数可以重定向。
    使用 abort() 可以更早 退出请求，并返回错误代码:

        from flask import abort, redirect, url_for

        @app.route('/')
        def index():
            return redirect(url_for('login')) # 重定向到 login 页面

        @app.route('/login')
        def login():
            abort(401) # 表示禁止访问
            this_is_never_executed()

    上例实际上是没有意义的，它让一个用户从索引页重定向到一个无法访问的页面（401 表示禁止访问）。
    但是上例可以说明重定向和出错跳出是如何工作的。

    默认情况下每种出错代码都会对应显示一个黑白的出错页面。
    使用 errorhandler() 装饰器可以定制出错页面:

        from flask import render_template

        @app.errorhandler(404) # 指定 404 错误时的处理页面
        def page_not_found(error):
            return render_template('page_not_found.html'), 404

    注意 render_template() 后面的 404 ，这表示页面对就的出错代码是 404 ，即页面不存在。缺省情况下 200 表示一切正常。

