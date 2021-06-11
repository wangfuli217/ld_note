
Django Middleware 中间件

Django 处理一个 Request 的过程是首先通过中间件, 然后再通过默认的 URL 方式进行的。
我们可以在 Middleware 这个地方把所有 Request 拦截住, 用我们自己的方式完成处理以后直接返回 Response 。
因此了解中间件的构成是非常必要的。


Initializer: __init__(self)
    出于性能的考虑, 每个已启用的中间件在每个服务器进程中只初始化一次。
    也就是说 __init__() 仅在服务进程启动的时候调用, 而在针对单个 request 处理时并不执行。

    对一个 middleware 而言, 定义 __init__() 方法的通常原因是检查自身的必要性。
    如果 __init__() 抛出异常 django.core.exceptions.MiddlewareNotUsed, 则 Django 将从 middleware 栈中移出该 middleware。

    在中间件中定义 __init__() 方法时, 除了标准的 self 参数之外, 不应定义任何其它参数。


Request 预处理函数: process_request(self, request)
    这个方法的调用时机在 Django 接收到 request 之后, 但仍未解析URL以确定应当运行的 view 之前。Django 向它传入相应的 HttpRequest 对象, 以便在方法中修改。

    process_request() 应当返回 None 或 HttpResponse 对象。
    如果返回 None, Django 将继续处理这个 request, 执行后续的中间件, 然后调用相应的 view。
    如果返回 HttpResponse 对象, Django 将不再执行任何其它的中间件(无视其种类)以及相应的view。 Django将立即返回该 HttpResponse 。


View预处理函数: process_view(self, request, callback, callback_args, callback_kwargs)
    这个方法的调用时机在 Django 执行完 request 预处理函数(process_request)并确定待执行的 view 之后, 但在 view 函数实际执行之前。

    参数:
        request: HttpRequest 对象。
        callback: Django 将调用的处理 request 的 python 函数. 这是实际的函数对象本身, 而不是字符串表述的函数名。
        args: 将传入 view 的位置参数列表, 但不包括 request 参数(它通常是传入view的第一个参数)。
        kwargs: 将传入 view 的关键字参数字典。

    如同 process_request(), process_view() 应当返回 None 或 HttpResponse 对象。
    如果返回 None, Django 将继续处理这个 request, 执行后续的中间件, 然后调用相应的 view 。
    如果返回 HttpResponse 对象, Django 将不再执行 任何 其它的中间件(不论种类)以及相应的 view, Django 将立即返回。

Response 后处理函数: process_response(self, request, response)
    这个方法的调用时机在 Django 执行 view 函数并生成 response 之后。
    该处理器能修改 response 的内容；一个常见的用途是内容压缩, 如 gzip 所请求的 HTML 页面。

    这个方法的参数相当直观:  request 是 request 对象, 而 response 则是从 view 中返回的 response 对象。

    process_response() 必须返回 HttpResponse 对象. 这个 response 对象可以是传入函数的那一个原始对象（通常已被修改）, 也可以是全新生成的。


Exception 后处理函数: process_exception(self, request, exception)
    这个方法只有在 request 处理过程中出了问题并且 view 函数抛出了一个未捕获的异常时才会被调用。
    这个钩子可以用来发送错误通知, 将现场相关信息输出到日志文件, 或者甚至尝试从错误中自动恢复。

    这个函数的参数除了一贯的 request 对象之外, 还包括 view 函数抛出的实际的异常对象 exception 。

    process_exception() 应当返回 None 或 HttpResponse 对象。
    如果返回 None, Django 将用框架内置的异常处理机制继续处理相应 request 。
    如果返回 HttpResponse 对象, Django 将使用该 response 对象, 而短路框架内置的异常处理机制。

