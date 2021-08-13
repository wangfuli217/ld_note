#!python
# -*- coding:utf-8 -*-
'''
缓存公用函数(redis缓存，且封装redis的调用)
Created on 2014/7/16
Updated on 2016/3/2
@author: Holemar

依赖第三方库:
    redis==2.10.3

好处是:
    允许多进程、多服务器共享缓存内容；
    内存占用稳定,不易内存溢出及过大；
    缓存信息会自动保存到磁盘,允许永久保存

注意:
    使用前必须先设置 redis 数据库的连接
    fn 函数,目前针对被装饰器(Decorator)装饰过的函数,建议设置 name 参数来区分, 因为key会是装饰器的名称,容易导致缓存结果出错

#todo: 不能保证缓存所有类型的值,目前确认支持: str,unicode,int,long,float,dict,list,tuple,set,datetime,time 类型
 dict,list,tuple,set 类型支持嵌套,但嵌套里面的内容必须是上述支持的类型。
 这之外的类型,有可能支持,也可能不支持,需自行测试。
'''
import types
import base64
import pickle
import logging
import functools
from hashlib import md5

import redis


__all__=('init', 'get_conn', 'ping', 'clear', 'get', 'put', 'incr', 'decr', 'expire', 'exists', 'pop', 'keys', 'fn')
logger = logging.getLogger('libs_my.cache')


# redis 连接池
__connection_pool = None

# 请求默认值
CONFIG = {
    'fn_timeout' : 60, # {int} fn装饰器的缓存时间(单位:秒,默认1分钟)
    # redis 数据库连接配置
    'host': '127.0.0.1',
    'port': 6379,
    'password':'',
    'db':3,   # 数据库 库名
}


def init(**kwargs):
    '''
    @summary: 设置各函数的默认参数值及数据库连接
    @param {int} fn_timeout: fn装饰器的缓存时间(单位:秒,默认1分钟)
    @param {string} host: 地址
    @param {int} port: 端口
    @param {string} password: 登录密码
    @param {int} db: 数据库名
    @param {dict} db: redis 数据库连接配置
    @return {bool}: 是否成功连接上数据库,失败时返回False
    '''
    global CONFIG
    global __connection_pool
    CONFIG.update(kwargs)
    conn_config = {'host':CONFIG['host'], 'port': CONFIG['port'], 'password': CONFIG['password'], 'db':CONFIG['db']}
    __connection_pool = redis.Redis(connection_pool=redis.ConnectionPool(**conn_config))
    res = __connection_pool.ping()
    if not res:
        __connection_pool = None
        logger.error(u"[red]redis 连接异常, 无法连接上！[/red]", extra={'color':True})
        raise RuntimeError(u'无法连接 redis, 请检查配置信息！')
    return res

def get_conn():
    '''
    @summary: 获取 redis 数据库连接
    @return {redis object}: redis数据库连接,连接不上会返回 None
    '''
    global __connection_pool
    if __connection_pool is None:
        res = init()
        if not res:
            logger.error(u"[red]redis 连接异常, 无法连接上！[/red]", extra={'color':True})
            raise RuntimeError(u'无法连接 redis, 请检查配置信息！')
    return __connection_pool

def ping():
    '''
    @summary: 探测redis数据库是否连上
    @return {bool}: 能连上则返回True, 否则返回False
    '''
    res = False
    try:
        conn = get_conn()
        # 取不到 redis 连接,说明连不上
        if not conn:
            logger.error(u"[red]redis 连接异常, 无法连接上！[/red]", extra={'color':True})
            return res
        res = conn.ping()
    # 连不上redis
    except Exception, e:
        logger.error(u"[red]redis 连接异常: %s[/red]", e, exc_info=True, extra={'color':True, 'Exception':e})
    return res


def clear():
    u"""
    @summary: 清除所有的缓存
    @return {ing|long}: 被删除的key的数量
    """
    conn = get_conn()
    res = conn.flushdb()
    if res:
        logger.info(u"清理redis缓存OK")
    else:
        logger.warn(u'清理redis缓存失败！')
    return res

def encode(value, to_md5=False):
    u"""
    @summary: 转化参数成redis可保存的字符串(类似序列化)
    @param {任意} value: 需缓存的值
    @param {bool} to_md5: 是否转成 MD5 的返回值(不可逆，但字符串长度小，用做key)
    @return {string}: 可缓存的值
    """
    #return repr(value) # repr 只能支持基本类型，不能支持复杂类型
    pickled = pickle.dumps(value, pickle.HIGHEST_PROTOCOL)
    if to_md5:
        return md5(pickled).hexdigest()
    return base64.b64encode(pickled)

def decode(value):
    u"""
    @summary: 转化缓存的字符串成原来类型(类似反序列化)
    @param {string} value: 缓存的值
    @return {任意}: 缓存前的值
    """
    #return eval(value) # 跟 repr 对应，只能支持基本类型，不能支持复杂类型
    return pickle.loads(base64.b64decode(value))

def get(key, default=None):
    '''
    @summary: 获取缓存的值
    @param {string} key: 缓存的key值
    @param {string} default: 默认的返回值
    @return {string|int|long|float|dict|list|tuple|set|datetime|time}: 缓存的结果,按存入时原样返回。
    '''
    conn = get_conn()
    res = conn.get(key)
    if res is None:
        #if conn.exists(key):return res
        return default
    res = decode(res)
    return res

def put(key, value, timeout=None):
    '''
    @summary: 设置缓存的值
    @param {string} key: 缓存的key值
    @param {string|int|long|float|dict|list|tuple|set|datetime|time} value: 缓存的结果
    @param {int|long} timeout: 缓存的时间,单位:秒,为空表示永久缓存
    @return {bool} 缓存是否设置成功,成功则返回 True, 否则返回 False
    '''
    conn = get_conn()
    # 由于 redis 不能支持多重嵌套的 json 内容存储,只好统一改用 string 存储了
    value = encode(value)
    if timeout:
        if timeout > 0:
            conn.setex(key, value, int(timeout))
        # timeout <= 0 时直接过期，不用再保存
        else:
            return True
    else:
        conn.set(key, value)
    return True

def incr(key, add_num=None):
    '''
    @summary: 设置一个递增的整数
    @param {string} key: 缓存的key值
    @param {int|long} add_num: 要加上的值
    @return {int} 递增后的结果,首次调用时返回 1
    '''
    conn = get_conn()
    if add_num:
        res = int(conn.get(key) or 0) + add_num
        conn.set(key, res)
    else:
        res = conn.incr(key)
    return res

def decr(key, reduce_num=None):
    '''
    @summary: 设置一个递减的整数
    @param {string} key: 缓存的key值
    @param {int|long} reduce_num: 要减去的值
    @return {int} 递减后的结果,首次调用时返回 -1
    '''
    conn = get_conn()
    if reduce_num:
        res = int(conn.get(key) or 0) - reduce_num
        conn.set(key, res)
    else:
        res = conn.decr(key)
    return res

def expire(key, timeout=None):
    '''
    @summary: 设置超时时间
    @param {string} key: 缓存的key值
    @param {int|long} timeout: 缓存的时间,单位:秒,为空表示永久缓存
    @return {bool} 缓存超时时间是否设置成功,成功则返回 True, 否则返回 False
    '''
    conn = get_conn()
    if timeout:
        if timeout <= 0:
            conn.delete(key)
        else:
            conn.expire(key, int(timeout))
    return True

def exists(key):
    '''
    @summary: 判断此值是否存在于缓存中
    @param {string} key: 缓存的key值
    @return {bool} 缓存中有此值,且没有超时则返回 True 。否则返回 False
    '''
    conn = get_conn()
    return conn.exists(key)

def pop(*args):
    '''
    @summary: 删除指定的key,并且返回它的值
    @param {string} args: 缓存的key值； 要同时删除多个时,可以传多个参数
    @return {string|list}: 如果只有一个参数,则返回被删除的值。如果有多个参数，则返回被删除的值的列表
    '''
    conn = get_conn()
    value_list = []
    for arg in args:
        _value = conn.get(arg)
        if isinstance(_value, basestring):
            _value = decode(_value)
        if _value != None:
            value_list.append(_value)
    conn.delete(*args)
    # 处理返回值
    if len(args) <= 1:
        if len(value_list) == 1:
            return value_list[0]
        else:
            return None
    else:
        return value_list

def keys(re_key):
    '''
    @summary: 根据正则返回匹配的key值列表
    @param {string} re_key:要匹配的正则字符串
    @return {list}: 匹配到的所有key值列表,匹配不到则返回空列表
    '''
    conn = get_conn()
    # 使用 redis 缓存
    keys_list = conn.keys(re_key)
    return keys_list

def fn(*out_args, **out_kwargs):
    u"""
    @summary: 缓存函数执行结果
        目前仅支持:string,int,long,float,dict,list,tuple,set,datetime 类型的缓存。
        dict,list,tuple,set 类型支持嵌套,但嵌套里面的内容必须是上述支持的类型。
    @param {int|long} timeout: 缓存时长(单位：秒, 默认缓存1分钟), 为空表示永久缓存
    @param {string} name: 当装饰已经有装饰器的函数时,设个名称来区分函数名。最好保证一个项目里面唯一。
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要返回值不是 None 就认为正确)
    @example
        @fn(30,True)
        def test_fun(): ...

        @fn
        def test_fun2(): ...
    """
    def wrapper1(method):
        @functools.wraps(method)
        def wrapper(*args, **kwargs):
            global CONFIG
            judge = out_kwargs.get('judge', lambda result: result!=None)
            timeout = out_kwargs.get('timeout', CONFIG.get('fn_timeout', None))
            name = out_kwargs.get('name', '')
            param = encode((args, kwargs), to_md5=True)
            key = u"%s:%s:%s:%s" % (name, method.__module__, method.__name__, param)
            # 结果允许是 None, 0, False 等等值
            res = get(key)
            if res != None or exists(key):
                logger.debug(u'读取缓存， key：%s， 返回：%s', key, res)
                if not judge or judge(res):
                    return res
            res = None
            # 函数执行有可能不成功
            try:
                # 没有缓存,或者缓存超时
                res = method(*args, **kwargs)
                # 结果需要判断是否正确,不正确的不缓存；如果没有判断结果的函数,则不再判断,直接缓存
                if not judge or judge(res):
                    put(key, res, timeout=timeout)
                    logger.debug(u'设置缓存， key：%s， 结果：%s', key, res)
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

    # 写上缓存的调用方式
    return wrapper1

