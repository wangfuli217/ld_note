
操作请求数据
    对于 web 应用来说对客户端向服务器发送的数据作出响应很重要。
    在 Flask 中由全局 对象 request 来提供请求信息。
    如果你有一些 Python 基础，那么可能 会奇怪：既然这个对象是全局的，怎么还能保持线程安全？答案是本地环境：

  本地环境
    内部信息
        如果你想了解其工作原理和如何测试，请阅读本节，否则可以跳过本节。

        某些对象在 Flask 中是全局对象，但是不是通常意义下的全局对象。
        这些对象实际上是 特定环境下本地对象的代理。真拗口！但还是很容易理解的。

        设想现在处于处理线程的环境中。
        一个请求进来了，服务器决定生成一个新线程（或者 叫其他什么名称的东西，这个下层的东西能够处理包括线程在内的并发系统）。
        当 Flask 开始其内部请求处理时会把当前线程作为活动环境，并把当前应用和 WSGI 环境 绑定到这个环境（线程）。
        它以一种聪明的方式使得一个应用可以在不中断的情况下 调用另一个应用。

        这对你有什么用？基本上你可以完全不必理会。
        这个只有在做单元测试时才有用。
        在测试 时会遇到由于没有请求对象而导致依赖于请求的代码会突然崩溃的情况。
        对策是自己创建 一个请求对象并绑定到环境。
        最简单的单元测试解决方案是使用 test_request_context() 环境管理器。
        通过使用 with 语句可以 绑定一个测试请求，以便于交互。
        例如:

            import flask
            from flask import request
            app = flask.Flask(__name__)

            with app.test_request_context('/hello', method='POST'):
                # now you can do something with the request until the
                # end of the with block, such as basic assertions:
                assert request.path == '/hello'
                assert request.method == 'POST'

        另一种方式是把整个 WSGI 环境传递给 request_context() 方法:

            from flask import request

            with app.request_context(environ):  # environ 哪来的？
                assert request.method == 'POST'


请求对象
    请求对象在 API 一节中有详细说明这里不细谈（参见 request ）。
    这里简略地谈一下最常见的操作。
    首先，你必须从 flask 模块导入请求对象:

        from flask import request

    通过使用 method 属性可以操作当前请求方法，通过使用 form 属性处理表单数据。
    以下是使用两个属性的例子:

        @app.route('/login', methods=['POST', 'GET'])
        def login():
            error = None
            if request.method == 'POST':
                if valid_login(request.form['username'],
                               request.form['password']):
                    return log_the_user_in(request.form['username'])
                else:
                    error = 'Invalid username/password'
            # 如果请求访求是 GET 或验证未通过就会执行下面的代码
            return render_template('login.html', error=error)


    当 form 属性中不存在这个键时会发生什么？
    会引发一个 KeyError 。如果你不像捕捉一个标准错误一样捕捉 KeyError ，那么会显示一个 HTTP 400 Bad Request 错误页面。
    因此，多数情况下你不必处理这个问题。

    要操作 URL （如 ?key=value ）中提交的参数可以使用 args 属性:

        searchword = request.args.get('key', '')

    用户可能会改变 URL 导致出现一个 400 请求出错页面，这样降低了用户友好度。
    因此， 我们推荐使用 get 或通过捕捉 KeyError 来访问 URL 参数。

    完整的请求对象方法和属性参见 request 文档。
    http://dormousehole.readthedocs.org/en/latest/api.html#flask.request


Cookies
    要访问 cookies ，可以使用 cookies 属性。
    可以使用 request 的 set_cookie 方法来设置 cookies 。
    request 的 cookies 属性是一个包含了客户端传输的所有 cookies 的字典。
    在 Flask 中，如果能够使用 会话(session) ，那么就不要直接使用 cookies ，因为 会话比较安全一些。

    读取 cookies:

        from flask import request

        @app.route('/')
        def index():
            username = request.cookies.get('username')
            # 使用 cookies.get(key) 来代替 cookies[key] ，
            # 以避免当 cookie 不存在时引发 KeyError 。

    储存 cookies:

        from flask import make_response

        @app.route('/')
        def index():
            resp = make_response(render_template(...))
            resp.set_cookie('username', 'the username')
            return resp

    注意， cookies 设置在响应对象上。
    通常只是从视图函数返回字符串， Flask 会把它们 转换为响应对象。
    如果你想显式地转换，那么可以使用 make_response() 函数，然后再修改它。
    使用 延迟的请求回调 方案可以在没有响应对象的情况下设置一个 cookie 。
    同时可以参见 关于响应 。


会话(session)
    除了 request 之外还有一种称为 session 的对象，允许你在不同请求 之间储存信息。
    这个对象相当于用密钥签名加密的 cookie ，即用户可以查看你的 cookie ，但是如果没有密钥就无法修改它。
    使用会话之前你必须设置一个密钥。
    举例说明:

        from flask import Flask, session, redirect, url_for, escape, request

        app = Flask(__name__)

        @app.route('/')
        def index():
            if 'username' in session:
                return 'Logged in as %s' % escape(session['username'])
            return 'You are not logged in'

        @app.route('/login', methods=['GET', 'POST'])
        def login():
            if request.method == 'POST':
                session['username'] = request.form['username']
                return redirect(url_for('index'))
            return '''
                <form action="" method="post">
                    <p><input type=text name=username>
                    <p><input type=submit value=Login>
                </form>
            '''

        @app.route('/logout')
        def logout():
            # 如果会话中有用户名就删除它。
            session.pop('username', None)
            return redirect(url_for('index'))

        # 设置密钥，复杂一点：
        app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'

    这里用到的 escape() 是用来转义的。如果不使用模板引擎就可以像上例 一样使用这个函数来转义。


