#!python
# -*- coding:utf-8 -*-
'''
缓存公用函数(封装django的缓存机制)
Created on 2016/3/2
Updated on 2016/4/7
@author: Holemar

依赖第三方库:
    Django==1.8.1

使用 redis 缓存时(建议使用):
    外部调用方式跟使用内存缓存一样，只是配置不同(也还需要安装第三方库)

    依赖第三方库:
        redis==2.10.3
        django-redis==4.3.0

    配置缓存信息:
        CACHES = {
            "default": {
                "BACKEND": "django_redis.cache.RedisCache",
                "LOCATION": "redis://127.0.0.1:6379/0", # redis 连接信息
                'TIMEOUT': 300, # 默认缓存时间，单位：秒
                "OPTIONS": {
                    "CLIENT_CLASS": "django_redis.client.DefaultClient",
                }
            }
        }

    好处是:
        允许多进程、多服务器共享缓存内容；
        内存占用稳定,不易内存溢出及过大；
        缓存信息会自动保存到磁盘,允许永久保存

    说明:
        可以缓存绝大多数类型的值，但不保证是所有类型，至少得支持序列化的
        目前已确认支持:string(包括 str 和 unicode),int,long,float,dict,list,tuple,set,datetime,time,django的Model 类型
        dict,list,tuple,set 类型支持嵌套,但嵌套里面的内容必须是上述支持的类型。

注意:
    fn 函数,目前针对被装饰器(Decorator)装饰过的函数,建议设置 name 参数来区分, 因为key会是装饰器的名称,容易导致缓存结果出错

'''
import types
import logging
import functools
from hashlib import md5

from django.core.cache import DefaultCacheProxy, cache
try:
    from django.utils.six.moves import cPickle as pickle
except ImportError:
    import pickle

logger = logging.getLogger('libs_my.django.cache')


def pop(*args):
    '''
    @summary: 删除指定的key,并且返回它的值
    @param {string} args: 缓存的key值； 要同时删除多个时,可以传多个参数
    @return {string|list}: 如果只有一个参数,则返回被删除的值。如果有多个参数，则返回被删除的值的列表
    '''
    value_dict = cache.get_many(args)
    cache.delete_many(args)
    value_list = value_dict.values()
    # 处理返回值
    if len(args) <= 1:
        return value_list[0] if len(value_list) == 1 else None
    else:
        return value_list


def encode_param(args, kwargs):
    '''序列化参数，保证相同的参数返回相同的值，不同的参数返回不同的值'''
    #return repr((args, kwargs)) # repr 没法区分 Model 类型
    value = pickle.dumps((args, kwargs), pickle.HIGHEST_PROTOCOL)
    value = md5(value).hexdigest() # 防止返回值太长
    return value


def fn(*out_args, **out_kwargs):
    u"""
    @summary: 缓存函数执行结果
        目前仅支持:string,int,long,float,dict,list,tuple,set,time,datetime,django的Model 类型的缓存。
        dict,list,tuple,set 类型支持嵌套,但嵌套里面的内容必须是上述支持的类型。
    @param {int|long} timeout: 缓存时长(单位：秒, 默认缓存1分钟), 为空表示永久缓存
    @param {string} name: 当装饰已经有装饰器的函数时,设个名称来区分函数名。最好保证一个项目里面唯一。
    @param {lambda} judge: 判断返回值能否缓存(默认只要返回值不是 None 就缓存)
    @example
        @fn(30,True)
        def test_fun(): ...

        @fn
        def test_fun2(): ...
    """
    def wrapper1(method):
        @functools.wraps(method)
        def wrapper(*args, **kwargs):
            judge = out_kwargs.get('judge', lambda result: result!=None)
            timeout = out_kwargs.get('timeout', cache.default_timeout)
            name = out_kwargs.get('name', '')
            param = encode_param(args, kwargs)
            key = u"%s:%s:%s:%s" % (name, method.__module__, method.__name__, param)
            # 结果允许是 None, 0, False 等等值
            res = cache.get(key)
            if res != None or cache.has_key(key):
                logger.debug(u'读取缓存， key：%s， 返回：%s', key, res)
                if not judge or judge(res):
                    return res
            res = None
            # 函数执行有可能不成功
            try:
                res = method(*args, **kwargs)
                # 结果需要判断是否正确,不正确的不缓存；如果没有判断结果的函数,则不再判断,直接缓存
                if not judge or judge(res):
                    cache.set(key, res, timeout=timeout)
                    logger.debug(u'设置缓存%s秒，key：%s， 结果：%s',  timeout, key, res)
            except Exception, e:
                logger.error(u"[red]函数执行错误: %s[/red] %s %s.%s,参数:%s,%s", e, name, method.__module__, method.__name__, args, kwargs, exc_info=True,
                    extra={'color':True, 'Exception':e}
                )
            return res
        return wrapper

    # 如果调用此函数时不写参数
    if len(out_args) > 0:
        _method = out_args[0]
        if isinstance(_method, (types.FunctionType, types.MethodType)):
            method = _method
            return wrapper1(method)
        # 第一个参数,认为是过期时间
        elif isinstance(_method, (int, long, float)) and out_kwargs.get('timeout') is None:
            out_kwargs['timeout'] = _method

    # 写上缓存参数的调用方式
    return wrapper1


# 添加函数到 cache 里面
cache.pop = pop
cache.fn = fn
# 添加别名函数
exists = getattr(cache, 'has_key', None)
setattr(DefaultCacheProxy, 'exists', exists)

# 添加 expire 函数，如果没有的话
if not getattr(cache, 'expire', None):
    def expire(key, timeout=None):
        if timeout and cache.has_key(key):
            cache.set(key, cache.get(key), timeout=timeout)
        return True
    cache.expire = expire



# 具体的实现是 django_redis.cache.RedisCache
# 实际实现代码写在 django_redis.client.DefaultClient
# 可通过 cache.client 获取 DefaultClient 的实体类(可调用里面的 encode/decode 等函数,及 get_client 函数获取数据库连接)
# 可通过 cache._server 获取 redis 连接地址信息(字符串)
# 可通过 cache._params 获取配置信息(dict)

'''wiki 说明，缓存的用法：

h1. Cache 缓存的用法

h3. 参考文档

    http://python.usyiyi.cn/django/topics/cache.html

h3. 依赖的库

 * Django==1.8.1
 * redis==2.10.3
 * django-redis==4.3.0

h3. 配置缓存信息

    CACHES = {
        "default": {
            "BACKEND": "django_redis.cache.RedisCache",
            "LOCATION": "redis://127.0.0.1:6379/0", # redis 连接信息
            'TIMEOUT': 300, # 默认缓存时间，单位：秒
            "OPTIONS": {
                "CLIENT_CLASS": "django_redis.client.DefaultClient",
            }
        }
    }

h3. 单个view缓存

    <pre>
    from django.views.generic import View
    from django.views.decorators.cache import cache_page

    # view 写法1
    @cache_page(60 * 15)
    def my_view(request):
        ...

    # view 写法2
    class TestView(View):
        def get(self, request, *args, **kwargs):
            ...

    # 页面地址加入到配置中
    url(r'^now/$', my_view),
    url(r'^test/$', cache_page(60*60)(TestView.as_view())), # 写法2类型得这样写缓存
    </pre>


h3. 缓存基础用法

使用 cache.set(key, value, timeout=DEFAULT_TIMEOUT) 和 cache.get(key, default=None)

    <pre>
    from django.core.cache import cache

    cache.set('my_key', 'hello, world!', 30)
    print cache.get('my_key') # 打印: hello, world!

    # set 允许存放的 value 类型可以是 str,unicode,int,long,float,dict,list,tuple,set,datetime,time 以及 django的Model 类型
    # 其中 dict,list,tuple,set 可以多层嵌套，但嵌套在里面的也必须是上面支持的类型。 上面没列出的其它类型不一定能支持，具体需要测试一下。
    value2 = [{}, 222, '测试数据']
    cache.set('key2', value2)
    assert cache.set('key2') == value2 # get 获取的会是放进去的类型，不需要额外的转换

    # cache.set 的第三个参数 timeout 是可选值，表示超时时间，单位是秒，只能是int类型参数。不填时用配置的 TIMEOUT 值，没有写配置时默认是 300 秒。
    # cache.get 的第二个参数允许设置默认值，取不到缓存时返回默认值，没有设默认值则取不到时返回 None

    # cache.add 的用法，跟 cache.set 类似，当没有这个 key 的缓存时添加 value，如果已经有缓存则不添加也不修改原有缓存
    cache.set('add_key', 'Initial value')
    cache.add('add_key', 'New value')
    print cache.get('add_key') # 打印: Initial value
    </pre>

一次性读写多个值
使用 cache.set_many(data) 和 cache.get_many(keys)

    <pre>
    from django.core.cache import cache

    cache.set_many({'a': 1, 'b': 2, 'c': 3})
    # set_many 相当于运行多次 set，上面一句相当于写以下3句:
    #cache.set('a', 1)
    #cache.set('b', 2)
    #cache.set('c', 3)

    print cache.get_many(['a', 'b', 'c']) # 打印: {'a': 1, 'b': 2, 'c': 3}
    </pre>

删除值

    <pre>
    from django.core.cache import cache

    cache.delete('key') # 删除一个缓存值
    cache.delete_many(['key1', 'key2', 'key3']) # 一次性删除多个值
    cache.delete_pattern('key*') # 按正则匹配来删除多个值
    cache.clear() # 清空缓存，删除所有的缓存值
    </pre>

自增、自减
使用 cache.incr(key, delta=1) 和 cache.decr(key, delta=1)

    <pre>
    from django.core.cache import cache

    cache.add('num', 1) # 使用 incr 和 decr 函数前，必须先 set 值，否则会抛 ValueError 异常(这跟 redis 的自增自减不一样，如果有需要可以再打补丁修改成 redis 的模式)
    print cache.incr('num') # 打印：2

    # 默认是每次 incr 自增 1，但也可以指定增加多少
    print cache.incr('num', 10) # 打印:12

    # 默认是每次 decr 自减 1，但也可以指定减多少
    print cache.decr('num') # 打印:11
    print cache.decr('num', 5) # 打印:6
    </pre>

设过期时间
使用 cache.expire(key, timeout)

    <pre>
    import time
    from django.core.cache import cache

    cache.set('key1', 'value1')
    cache.expire('key1', 1) # 设置过期时间是 1 秒
    print cache.get('key1') # 打印：value1
    print cache.ttl('key1') # ttl 函数返回 key 剩余的缓存秒数，打印: 1

    time.sleep(1.1)
    print cache.get('key1') # 打印: None
    </pre>


判断 key 是否存在
使用 cache.has_key(key) 或者 cache.exists(key)
注： exists 函数是 has_key 函数的别名，调用的是同一个函数，只是为了兼容 redis 的使用习惯加上这个别名函数(打补丁加的)

    <pre>
    from django.core.cache import cache

    cache.set('key1', 'value1')
    print cache.has_key('key1') # 打印：True
    print cache.exists('key1') # 打印：True

    print cache.has_key('key2') # 打印：False
    </pre>

使用 pop(*args) 函数，取值的同时删除值
注： 这个是补丁加上的函数，原 django 的实现里面并没有这函数

    <pre>
    from django.core.cache import cache

    cache.set_many({'a': 1, 'b': 2, 'c': 3})
    print cache.pop('a') # 打印：1
    print cache.pop('a') # 打印：None

    # 也可以一次性取多个值，返回一个列表
    print cache.pop('b', 'c') # 打印: [2, 3]
    </pre>


h3. 缓存函数运行结果

我这里自定义了一个装饰器，用来缓存整个函数的运行结果。
可指定过期时间，及结果的验证函数，函数特定名称等。

    <pre>
    from django.core.cache import cache

    # 用法1， 不指定任何装饰器参数，使用默认的过期时间及结果验证
    @cache.fn
    def test1(a, b=2, c=None):
        logging.warn(u"test1 a=%s, b=%s, c=%s", a, b, c)
        return a+b

    print test1(1,b=22,c={'a':'aa','b':'bb'}) # 执行了函数，因为之前没有缓存，打印: 23
    print test1(1,b=22,c={'a':'aa','b':'bb'}) # 使用了缓存，log 没有再写，打印: 23


    # 用法2，指定过期时间
    @cache.fn(60) # 指定过期时间 60 秒
    def test2(a, b=2, c=None):
        logging.warn(u"a=%s, b=%s, c=%s", a, b, c)
        return a+b

    @cache.fn(timeout=60) # 指定过期时间 60 秒
    def test3(a, b=2, c=None):
        logging.warn(u"a=%s, b=%s, c=%s", a, b, c)
        return a+b

    # 指定返回结果的才使用缓存
    # 这里只有当返回结果里面的 'result' 值为 0 时才会缓存，其它结果不缓存
    @cache.fn(timeout=60, judge=lambda s: s.get('result')==0)
    def test4(a, b=2, c=None):
        logging.warn(u"test3 a=%s, b=%s, c=%s", a, b, c)
        return {'result':a, 'x':a+b}

    # 当函数被其它装饰器装饰的时候，需要额外指定 name 来区分，否则缓存的 key 不精确，有可能会导致返回错误结果
    # 由于实现的时候是根据函数的 method.__module__ 和 method.__name__ 来区分的，而有其它装饰器时获取的是装饰器的 method，所以没法具体区分。(后续有待改进)
    @cache.fn(name='foo')
    @timeit
    def foo(*args):
        return 1

    # 函数的参数，支持 django 的 model 类型。(cache.get 和 cache.set 支持的类型，这里都支持)
    @cache.fn
    def test1(model, model_list=None):
        logging.warn(u"test1 model=%s, model_list=%s", model, model_list)
        model_list.append(model)
        return model_list

    p = Person(name = u"呵呵", age = 111)
    p2 = Person(name = "哈哈", age = 22)
    # 把 model 类型的实体类用做参数，同样可以缓存
    res1 = test1(p, model_list=[p, p2])
    </pre>


h3. 写给后续改进

 * 具体的实现是 django_redis.cache.RedisCache
 * 配置里写的具体实现代码在 django_redis.client.DefaultClient
 * 通过 cache.client 可获取 django_redis.client.DefaultClient 的实体类，然后就可以调用里面的所有属性及函数了
 * 如果希望获取真实的 redis 连接实体，然后直接调用，可通过 cache.client.get_client(write=True) 获取到

'''
