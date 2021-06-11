
路由
    现代 web 应用都使用漂亮的 URL ，有助于人们记忆，对于使用网速较慢的移动设备尤其有利。
    如果用户可以不通过点击首页而直达所需要的页面，那么这个网页会更得到用户的青睐，提高回头率。

    如前文所述， route() 装饰器用于把一个函数绑定到一个 URL 。
    下面是一些基本的例子:

        from flask import Flask
        app = Flask(__name__)

        @app.route('/')
        def index():
            return 'Index Page'

        @app.route('/hello')
        def hello():
            return 'Hello World'

        if __name__ == '__main__':
            app.run()

    但是能做的不仅仅是这些！你可以动态变化 URL 的某些部分，还可以为一个函数指定多个规则。


URL变量规则
    通过把 URL 的一部分标记为 <variable_name> 就可以在 URL 中添加变量。
    标记的部分会作为关键字参数传递给函数。
    通过使用 <converter:variable_name> ，可以选择性的加上一个转换器，为变量指定规则。
    请看下面的例子(只写上核心部分，像 import 和 app 、 run 这些相同的忽略掉, 下面示例同样):

        @app.route('/user/<username>')
        def show_user_profile(username):
            # show the user profile for that user
            return 'User %s' % username

        @app.route('/post/<int:post_id>')  # 当参数不是int类型会报404
        def show_post(post_id):
            # show the post with the given id, the id is an integer
            return 'Post %d' % post_id

    现有的转换器有：
        int	    接受整数
        float	接受浮点数
        path	和缺省情况相同，但也接受斜杠


唯一的 URL / 重定向行为
    Flask 的 URL 规则都是基于 Werkzeug 的路由模块的。其背后的理念是保证漂亮的 外观和唯一的 URL 。这个理念来自于 Apache 和更早期的服务器。

    假设有如下两条规则:

        @app.route('/projects/')
        def projects():
            return 'The project page'

        @app.route('/about')
        def about():
            return 'The about page'

    它们看上去很相近，不同之处在于 URL 定义中尾部的斜杠。

    第一个函数中 prjects 的 URL 是中规中矩的，尾部有一个斜杠，看起来就如同一个文件夹。
    访问一个没有斜杠结尾的 URL 时 Flask 会自动进行重定向，帮你在尾部加上一个斜杠。
    # 访问“http://localhost:5000/projects” 和 “http://localhost:5000/projects/” 效果一样，都会重定向到后一个网址

    但是在第二个函数中， URL 没有尾部斜杠，因此其行为表现与一个文件类似。
    如果 访问这个 URL 时添加了尾部斜杠就会得到一个 404 错误。
    # 访问“http://localhost:5000/about”正常， 而访问“http://localhost:5000/about/”会报404

    为什么这样做？因为这样可以在省略末尾斜杠时仍能继续相关的 URL 。
    这种重定向 行为与 Apache 和其他服务器一致。同时， URL 仍保持唯一，帮助搜索引擎不重复 索引同一页面。


URL 构建
    如果可以匹配 URL ，那么 Flask 也可以生成 URL 吗？当然可以。
    url_for() 函数就是用于构建指定函数的 URL 的。
    它把函数名称作为 第一个参数，其余参数对应 URL 中的变量。未知变量将添加到 URL 中作为查询参数。
    例如：

        from flask import Flask, url_for
        app = Flask(__name__)

        @app.route('/')
        def index():
            pass

        @app.route('/login')
        def login():
            pass

        @app.route('/user/<username>')
        def profile(username):
            pass

        with app.test_request_context():
            print url_for('index')  # 打印: /
            print url_for('login')  # 打印: /login
            print url_for('login', next='/')  # 打印: /login?next=/
            print url_for('profile', username='John Doe')  # 打印: /user/John%20Doe

    （例子中还使用 test_request_context() 方法。这个 方法的作用是告诉 Flask 我们正在处理一个请求，而实际上也许我们正处在交互 Python shell 之中，并没有真正的请求。详见下面的 本地环境 ）。

    为什么不在把 URL 写死在模板中，反而要动态构建？有三个很好的理由：
        1.反向解析通常比硬编码 URL 更直观。同时，更重要的是你可以只在一个地方改变 URL ，而不用到处乱找。
        2.URL 创建会为你处理特殊字符的转义和 Unicode 数据，不用你操心。
        3.如果你的应用是放在 URL 根路径之外的地方（如在 /myapplication 中，不在 / 中）， url_for() 会为你妥善处理。


HTTP 方法
    HTTP （ web 应用使用的协议）协议中有访问 URL 的不同方法。
    缺省情况下，一个路由 只回应 GET 请求，但是可以通过 methods 参数使用不同方法。
    例如:

        from flask import request

        # 限定访问方式
        @app.route('/login', methods=['GET', 'POST'])
        def login():
            if request.method == 'POST':
                do_the_login()
            else:
                show_the_login_form()

    如果当前使用的是 GET 方法，会自动添加 HEAD ，你不必亲自操刀。
    同时还会确保 HEAD 请求按照 HTTP RFC （说明 HTTP 协议的文档）的要求来处理，因此你可以 完全忽略这部分 HTTP 规范。
    与 Flask 0.6 一样， OPTIONS 自动为你处理好。


静态文件
    动态的 web 应用也需要静态文件，一般是 CSS 和 JavaScript 文件。
    理想情况下你的 服务器已经配置好了为你的提供静态文件的服务。
    在开发过程中， Flask 也能做好这个 工作。只要在你的包或模块旁边创建一个名为 static 的文件夹就行了。
    静态文件位于 应用的 /static 中。

    使用选定的 'static' 端点就可以生成相应的 URL 。:

        print url_for('static', filename='style.css') # 打印： static/style.css 。

