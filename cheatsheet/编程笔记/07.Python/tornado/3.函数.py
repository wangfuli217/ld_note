
五、函数
    Tornado 模板的 表达语句可以是包括函数调用在内的任何 Python 表述。模板中的相关代码, 会在一个单独 的名字空间中被执行, 这个名字空间包括了以下的一些对象和方法。(注意, 下面列表中 的对象或方法在使用 RequestHandler.render 或者 render_string 时才存在的 , 如果你在 RequestHandler 外面直接使用 template 模块, 则它们中的大部分是不存在的)。

    escape: tornado.escape.xhtml_escape 的別名
        转成html编码,如: escape(" ") 显示成 "&nbsp;"
    xhtml_escape: tornado.escape.xhtml_escape 的別名
    url_escape: tornado.escape.url_escape 的別名
    json_encode: tornado.escape.json_encode 的別名
    squeeze: tornado.escape.squeeze 的別名
    linkify: tornado.escape.linkify 的別名
    datetime: Python 的 datetime 模组
    handler: 当前的 RequestHandler 对象
    request: handler.request 的別名
    current_user: handler.current_user 的別名
    locale: handler.locale 的別名
    _: handler.locale.translate 的別名
    static_url: for handler.static_url 的別名
    xsrf_form_html: handler.xsrf_form_html 的別名
    reverse_url: Application.reverse_url 的別名
    Application 设置中 ui_methods 和 ui_modules 下面的所有项目
    任何传递给 render 或者 render_string 的关键字参数


1.转码
    所有的模板输出都已经通过 tornado.escape.xhtml_escape 自动转义(escape)
    这种默认行为, 可以通过以下几种方式修改:
        1.将 autoescape=None 传递给 Application 或者 TemplateLoader
        2.在模板文件中加入 {% autoescape None %}
        3.简单表达语句 {{ ... }} 写成 {% raw ...%}。
    另外你可以在上述位置将 autoescape 设为一个自定义函数, 而不仅仅是 None 。

2.Cookie 和安全 Cookie
    可以使用 set_cookie, get_cookie 方法在用户的浏览中设置及获取 cookie:
     class MainHandler(tornado.web.RequestHandler):
        def get(self):
            if not self.get_cookie("mycookie"):
                self.set_cookie("mycookie", "myvalue")
                self.write("Your cookie was not set yet!")
            else:
                self.write("Your cookie was set!")

    Cookie 很容易被恶意的客户端伪造。假如想在 cookie 中保存当前登陆用户的 id 之类的信息, 则需要对 cookie 作签名以防止伪造。
    Tornado 通过 set_secure_cookie 和 get_secure_cookie 方法直接支持了这种功能。 要使用这些方法, 需要在创建应用时提供一个密钥, 名字为 cookie_secret。
    可以把它作为一个关键词参数传入应用的设置中:
     application = tornado.web.Application([
        (r"/", MainHandler),
    ], cookie_secret="61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=")

    签名过的 cookie 中包含了编码过的 cookie 值, 另外还有一个时间戳和一个 HMAC 签名。
    如果 cookie 已经过期或者 签名不匹配, get_secure_cookie 将返回 None, 这和没有设置 cookie 时的 返回值是一样的。
    上面例子的安全 cookie 版本如下:
     class MainHandler(tornado.web.RequestHandler):
        def get(self):
            if not self.get_secure_cookie("mycookie"):
                self.set_secure_cookie("mycookie", "myvalue")
                self.write("Your cookie was not set yet!")
            else:
                self.write("Your cookie was set!")

3.用户认证
    当前已经认证的用户信息被保存在每一个请求处理器的 self.current_user 当中,  同时在模板的 current_user 中也是。默认情况下, current_user 为 None 。
    要在应用程序实现用户认证的功能, 需要复写请求处理中 get_current_user() 这个方法, 在其中判定当前用户的状态, 比如通过 cookie。
    下面的例子让用户简单地使用一个 nickname 登陆应用, 该登陆信息将被保存到 cookie 中:
     class BaseHandler(tornado.web.RequestHandler):
        def get_current_user(self):
            return self.get_secure_cookie("user")

    class MainHandler(BaseHandler):
        def get(self):
            if not self.current_user:
                self.redirect("/login")
                return
            name = tornado.escape.xhtml_escape(self.current_user)
            self.write("Hello, " + name)

    class LoginHandler(BaseHandler):
        def get(self):
            self.write('<html><body><form action="/login" method="post">'
                       'Name: <input type="text" name="name"/>'
                       '<input type="submit" value="Sign in"/>'
                       '</form></body></html>')

        def post(self):
            self.set_secure_cookie("user", self.get_argument("name"))
            self.redirect("/")

    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/login", LoginHandler),
    ], cookie_secret="61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=")


    对于那些必须要求用户登陆的操作, 可以使用装饰器 tornado.web.authenticated。
    如果一个方法套上了这个装饰器, 但是当前用户并没有登陆的话, 页面会被重定向到 login_url(应用配置中的一个选项)
    上面的例子可以被改写成:
     class MainHandler(BaseHandler):
        @tornado.web.authenticated
        def get(self):
            name = tornado.escape.xhtml_escape(self.current_user)
            self.write("Hello, " + name)

    settings = {
        "cookie_secret": "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
        "login_url": "/login",
    }
    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/login", LoginHandler),
    ], **settings)

    如果你使用 authenticated 装饰器来装饰 post() 方法, 那么在用户没有登陆的状态下,  服务器会返回 403 错误。
    Tornado 内部集成了对第三方认证形式的支持, 比如 Google 的 OAuth 。参阅 auth 模块(https://github.com/facebook/tornado/blob/master/tornado/auth.py) 的代码文档以了解更多信息。 Checkauth 模块以了解更多的细节。
    在 Tornado 的源码中有一个 Blog 的例子, 你也可以从那里看到 用户认证的方法(以及如何在 MySQL 数据库中保存用户数据)。


4.跨站伪造请求的防范
    跨站伪造请求(Cross-site request forgery), 简称为 XSRF, 是个性化 Web 应用中常见的一个安全问题。
    当前防范 XSRF 的一种通用的方法, 是对每一个用户都记录一个无法预知的 cookie 数据, 然后要求所有提交的请求中都必须带有这个 cookie 数据。如果此数据不匹配 , 那么这个请求就可能是被伪造的。
    Tornado 有内建的 XSRF 的防范机制, 要使用此机制, 你需要在应用配置中加上 xsrf_cookies 设定:
     settings = {
        "cookie_secret": "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
        "login_url": "/login",
        "xsrf_cookies": True,
    }
    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/login", LoginHandler),
    ], **settings)


    如果设置了 xsrf_cookies, 那么 Tornado 的 Web 应用将对所有用户设置一个 _xsrf 的 cookie 值, 如果 POST PUT DELET 请求中没有这个 cookie 值, 那么这个请求会被直接拒绝。
    如果开启了这个机制, 那么在所有被提交的表单中, 都需要加上一个域来提供这个值。可以通过在模板中使用专门的函数 xsrf_form_html() 来做到这一点:
     <form action="/new_message" method="post">
      {{ xsrf_form_html() }}
      <input type="text" name="message"/>
      <input type="submit" value="Post"/>
    </form>


    如果提交的是 AJAX 的 POST 请求, 还需要在每一个请求中通过脚本添加上 _xsrf 这个值, 下面是 使用了 jQuery 的 js 代码:
     function getCookie(name) {
        var r = document.cookie.match("\\b" + name + "=([^;]*)\\b");
        return r ? r[1] : undefined;
    }

    jQuery.postJSON = function(url, args, callback) {
        args._xsrf = getCookie("_xsrf");
        $.ajax({url: url, data: $.param(args), dataType: "text", type: "POST",
            success: function(response) {
            callback(eval("(" + response + ")"));
        }});
    };


    对于 PUT 和 DELETE 请求(以及不使用将 form 内容作为参数的 POST 请求) 来说, 也可以在 HTTP 头中以 X-XSRFToken 这个参数传递 XSRF token。
    如果需要针对每一个请求处理器定制 XSRF 行为, 你可以重写 RequestHandler.check_xsrf_cookie()。
    例如你需要使用一个不支持 cookie 的 API,  可以通过将 check_xsrf_cookie() 函数设空来禁用 XSRF 保护机制。
    然而如果需要同时支持 cookie 和非 cookie 认证方式, 那么只要当前请求是通过 cookie 进行认证的, 你就应该对其使用 XSRF 保护机制, 这一点至关重要。


5.静态文件和主动式文件缓存
    通过在应用配置中指定 static_path 选项来提供静态文件服务:
     settings = {
        "static_path": os.path.join(os.path.dirname(__file__), "static"),
        "cookie_secret": "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
        "login_url": "/login",
        "xsrf_cookies": True,
    }
    application = tornado.web.Application([
        (r"/", MainHandler),
        (r"/login", LoginHandler),
        (r"static/(.*)", tornado.web.StaticFileHandler, dict(path=settings['static_path'])),
    ], **settings)


    这样配置后, 所有以 “/static/” 开头的请求, 都会直接访问到指定的静态文件目录,  比如 http://localhost:8888/static/foo.png 会从指定的静态文件目录中访问到 foo.png 这个文件。同时 “/robots.txt” 和 “/favicon.ico” 也是会自动作为静态文件处理(即使它们不是以 “/static/” 开头)。
    (正则表达式 的匹配分组的目的是向 StaticFileHandler 指定所请求的文件名称, 抓取到的分组会以 方法参数的形式传递给处理器。)

    为了提高性能, 在浏览器主动缓存静态文件是个不错的主意。这样浏览器就不需要发送 不必要的 If-Modified-Since 和 Etag 请求, 从而影响页面的渲染速度。
    Tornado 可以通过内建的“静态内容分版(static content versioning)”来直接支持这种功能。

    要使用这个功能, 在模板中就不要直接使用静态文件的 URL 地址了, 你需要在 HTML 中使用 static_url() 这个方法来提供 URL 地址:
     <html>
       <head>
          <title>FriendFeed - {{ _("Home") }}</title>
       </head>
       <body>
         <div><img src="{{ static_url("images/logo.png") }}"/></div>
       </body>
     </html>

    static_url() 函数会将相对地址转成一个类似于 “/static/images/logo.png?v=aae54” 的 URI, v 参数是 logo.png 文件的散列值,  Tornado 服务器会把它发给浏览器, 并以此为依据让浏览器对相关内容做永久缓存。
    由于 v 的值是基于文件的内容计算出来的, 如果你更新了文件, 或者重启了服务器 , 那么就会得到一个新的 v 值, 这样浏览器就会请求服务器以获取新的文件内容。
    如果文件的内容没有改变, 浏览器就会一直使用本地缓存的文件, 这样可以显著提高页面的渲染速度。

    在生产环境下, 可能会使用 nginx(http://nginx.org/) 这样的更有利于静态文件 伺服的服务器, 可以将 Tornado 的文件缓存指定到任何静态文件服务器上面, 下面是 FriendFeed 使用的 nginx 的相关配置:
     location /static/ {
        root /var/friendfeed/static;
        if ($query_string) {
            expires max;
        }
     }


6.本地化
    不管有没有登陆，当前用户的 locale 设置可以通过两种方式访问到：请求处理器的 self.locale 对象、以及模板中的 locale 值。
    Locale 的名称（如 en_US）可以通过 locale.name 这个变量访问到，可以使用 locale.translate 来进行本地化 翻译。
    在模板中，有一个全局方法叫 _()，它的作用就是进行本地化的翻译。这个 翻译方法有两种使用形式：
       _("Translate this string")

    它会基于当前 locale 设置直接进行翻译，还有一种是：
       _("A person liked this", "%(num)d people liked this", len(people)) % {"num": len(people)}

    这种形式会根据第三个参数来决定是使用单数或是复数的翻译。上面的例子中，如果 len(people) 是 1 的话，就使用第一种形式的翻译，否则，就使用第二种形式 的翻译。
    常用的翻译形式是使用 Python 格式化字符串时的“固定占位符(placeholder)”语法，（例如上面的 %(num)d），和普通占位符比起来，固定占位符的优势是使用时没有顺序限制。

    一个本地化翻译的模板例子：
     <html>
       <head>
          <title>FriendFeed - {{ _("Sign in") }}</title>
       </head>
       <body>
         <form action="{{ request.path }}" method="post">
           <div>{{ _("Username") }} <input type="text" name="username"/></div>
           <div>{{ _("Password") }} <input type="password" name="password"/></div>
           <div><input type="submit" value="{{ _('Sign in') }}"/></div>
           {{ xsrf_form_html() }}
         </form>
       </body>
     </html>

    默认情况下，我们通过 Accept-Language 这个头来判定用户的 locale，如果没有， 则取 en_US 这个值。
    如果希望用户手动设置一个 locale 偏好，可以在处理请求的 类中复写 get_user_locale 方法：
     class BaseHandler(tornado.web.RequestHandler):
        def get_current_user(self):
            user_id = self.get_secure_cookie("user")
            if not user_id: return None
            return self.backend.get_user_by_id(user_id)

        def get_user_locale(self):
            if "locale" not in self.current_user.prefs:
                # Use the Accept-Language header
                return None
            return self.current_user.prefs["locale"]

        def get(self):
            user_locale = self.locale.get("zh_CN")  # 获取指定编码的内容, 英文是: en_US
            print user_locale.translate("Username") # 显示中文的字符串
            print user_locale.translate("Password")
            self.render("index.html")

    如果 get_user_locale 返回 None, 那么就会再去取 Accept-Language header 的值。

    可以使用 tornado.locale.load_translations 方法获取应用中的所有已存在的翻译。
    它会找到包含有特定名字的 CSV 文件的目录，如 es_GT.csv fr_CA.csv 这 些 csv 文件。
    然后从这些 CSV 文件中读取出所有的与特定语言相关的翻译内容。
    典型的用例里面，我们会在 Tornado 服务器的 main() 方法中调用一次该函数：
     def main():
        tornado.locale.load_translations(os.path.join(os.path.dirname(__file__), "translations")) # 本地化的 CSV 文件目录,此目录如果不存在则出错
        start_server() # 启动服务

    translations 目录下的 zh_CN.csv 文件内容(指定编码内容):
        "Username","用户名"
        "Password","密码"
        "Sign in","登录"


    可以使用 tornado.locale.get_supported_locales() 方法得到支持的 locale 列表。
    Tornado 会依据用户当前的 locale 设置以及已有的翻译，为用户选择 一个最佳匹配的显示语言。
    比如，用户的 locale 是 es_GT 而翻译中只支持了 es， 那么 self.locale 就会被设置为 es。
    如果找不到最接近的 locale 匹配，self.locale 就会就会取备用值 es_US。

    查看 locale 模块(https://github.com/facebook/tornado/blob/master/tornado/locale.py) 的代码文档以了解 CSV 文件的格式，以及其它的本地化方法函数。


7.UI 模块
    Tornado 支持一些 UI 模块，它们可以帮你创建标准的，易被重用的应用程序级的 UI 组件。
    这些 UI 模块就跟特殊的函数调用一样，可以用来渲染页面组件，而这些组件可以有自己的 CSS 和 JavaScript。

    例如你正在写一个博客的应用，你希望在首页和单篇文章的页面都显示文章列表，你可以创建 一个叫做 Entry 的 UI 模块，让他在两个地方分别显示出来。
    首先需要为你的 UI 模块 创建一个 Python 模组文件，就叫 uimodules.py 好了:
     class Entry(tornado.web.UIModule):
        def render(self, entry, show_comments=False):
            return self.render_string("module-entry.html", entry=entry, show_comments=show_comments)

    然后通过 ui_modules 配置项告诉 Tornado 在应用当中使用 uimodules.py：
     import ui_modules # 导入自定义的 UI 文件
     class HomeHandler(tornado.web.RequestHandler):
        def get(self):
            entries = self.db.query("SELECT * FROM entries ORDER BY date DESC")
            self.render("home.html", entries=entries)

    class EntryHandler(tornado.web.RequestHandler):
        def get(self, entry_id):
            entry = self.db.get("SELECT * FROM entries WHERE id = %s", entry_id)
            if not entry: raise tornado.web.HTTPError(404)
            self.render("entry.html", entry=entry)

    application = tornado.web.Application([
        (r"/", HomeHandler),
        (r"/entry/([0-9]+)", EntryHandler),
    ], ui_modules=uimodules)


    在 home.html 中，你不需要写繁复的 HTML 代码，只要引用 Entry 就可以了：
     {% for entry in entries %}
       {% module Entry(entry) %}
     {% end %}

    在 entry.html 里面，你需要使用 show_comments 参数来引用 Entry 模块，用来 显示展开的 Entry 内容：
     {% module Entry(entry, show_comments=True) %}

    你可以为 UI 模型配置自己的 CSS 和 JavaScript ，只要复写 embedded_css、 embedded_javascript、javascipt_files、css_files 就可以了：
     class Entry(tornado.web.UIModule):
        def embedded_css(self):
            return ".entry { margin-bottom: 1em; }"

        def render(self, entry, show_comments=False):
            return self.render_string("module-entry.html", show_comments=show_comments)

    即使一页中有多个相同的 UI 组件，UI 组件的 CSS 和 JavaScript 部分只会被渲染一次。
    CSS 是在页面的 <head> 部分，而 JavaScript 被渲染在页面结尾 </body> 之前的位置。

    在不需要额外 Python 代码的情况下，模板文件也可以当做 UI 模块直接使用。
    例如前面的例子可以以下面的方式实现，只要把这几行放到 module-entry.html中就可以了：
     {{ set_resources(embedded_css=".entry { margin-bottom: 1em; }") }}
    <!-- more template html... -->

    这个修改过的模块式模板可以通过下面的方法调用：
     {% module Template("module-entry.html", show_comments=True) %}

    set_resources 函数只能在 {% module Template(...) %} 调用的模板中访问到。
    和 {% include ... %} 不同，模块式模板使用了和它们的上级模板不同的命名 空间——它们只能访问到全局模板命名空间和它们自己的关键字参数。



    http://sebug.net/paper/books/tornado/#_4
    http://www.tornadoweb.cn/documentation

    Tornado中文版文档:
    https://github.com/breezemind/tornado/tree/master/website/templates/cn

