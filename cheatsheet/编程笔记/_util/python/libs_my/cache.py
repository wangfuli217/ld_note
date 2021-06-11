#!python
# -*- coding:utf-8 -*-
'''
缓存公用函数(内存缓存)
Created on 2014/7/16
Updated on 2016/3/7
@author: Holemar

相比缓存数据库的好处是可以缓存任何内容,包括类、函数等
fn 函数,目前针对被装饰器(Decorator)装饰过的函数,建议设置 name 参数来区分, 因为key会是装饰器的名称,容易导致缓存结果出错
由于有定时清空缓存机制，而且重启程序也会导致缓存全部清空，建议处理缓存信息获取不到的情况
'''

import re
import copy
import time
import types
import base64
import pickle
import thread
import logging
import datetime
import functools
from hashlib import md5


# 设置外部允许访问的函数
__all__=('init','fn','clear', 'get', 'put', 'expire', 'exists', 'pop', 'keys')
logger = logging.getLogger('libs_my.cache')


# 缓存用的字典
_value_cache = {}
_expire_cache = {}
# 缓存默认设置值
CONFIG = {
    'fn_timeout' : 30*60, # {int|long|float} fn装饰器的缓存时间(单位:秒,默认30分钟)
    'clear_expire' : 300, # 自动删除过期缓存的时间间隔(单位:秒。 设为0则不会自动删除,这容易导致内存占用过大以及内存溢出)
    'cron_clear' : False, # 是否开启每天定时清空缓存,设为 True 则会每天定时清空所有缓存, 否则不清空(这容易导致内存占用过大以及内存溢出)
    'clear_hour' : 2, # 指定每天清空缓存的时间(这设的 2 表示每天凌晨 2 点清空缓存,需要 cron_clear 参数设为 True 才生效)
}


def init(**kwargs):
    '''
    @summary: 修改缓存设置
    @param {int|long|float} fn_timeout: fn装饰器的缓存时间(单位:秒,默认30分钟)
    @param {int} clear_expire: 自动删除过期缓存的时间间隔(单位:秒。 设为0则不会自动删除,这容易导致内存占用过大以及内存溢出)
    @param {bool} cron_clear: 是否开启每天定时清空缓存,设为 True 则会每天定时清空所有缓存(默认),否则不清空(这容易导致内存占用过大以及内存溢出)
    @param {int} clear_hour: 指定每天清空缓存的时间(这设的 2 表示每天凌晨 2 点清空缓存,需要 cron_clear 参数设为 True 才生效)
    @param {Function|list<Function>} befor_clear: 清空缓存前调用的函数(需要空参,可直接调用)
    @param {Function|list<Function>} after_clear: 清空缓存后调用的函数(需要空参,可直接调用)
    '''
    global CONFIG
    CONFIG.update(kwargs)
    __set_clear_ts()

def clear():
    u"""
    @summary: 清除所有的缓存
    """
    global CONFIG
    global _value_cache
    global _expire_cache
    _value_cache.clear() # 这样写会不回收这片内存，导致内存占用越来越大，还需要下面写法
    _value_cache = {}
    _expire_cache.clear()
    _expire_cache = {}
    logger.info(u"清理缓存OK")

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

def get(key, default=None):
    '''
    @summary: 获取缓存的值
    @param {string} key: 缓存的key值
    @param {string} default: 默认的返回值
    @return {任意}: 缓存的结果,按存入时原样返回。 如果之前没有缓存这值或者缓存超时则返回 None
        如果指定默认值,则没有取到值时返回默认值
    '''
    # 如果有缓存,则返回缓存的值
    if exists(key):
        global _value_cache
        value = _value_cache.get(key)
        # 复杂类型,得深拷贝一份,避免外部修改了获取的值
        if value != None and not isinstance(value, (bool,int,long,float,complex, basestring, time.struct_time, datetime.datetime, datetime.date)):
            value = copy.deepcopy(value)
        return value
    # 没有此缓存则返回默认值或者 None
    return default

def put(key, value, timeout=None):
    '''
    @summary: 设置缓存的值
    @param {string} key: 缓存的key值
    @param {任意} value: 缓存的结果
    @param {int|long|float} timeout: 缓存的时间,单位:秒,为空表示永久缓存
    @return {bool} 缓存是否设置成功,成功则返回 True, 否则返回 False
    '''
    global _value_cache
    # 复杂类型,得深拷贝一份,避免外部修改了传入的值
    if value != None and not isinstance(value, (bool,int,long,float,complex, basestring, time.struct_time, datetime.datetime, datetime.date)):
        value = copy.deepcopy(value)
    _value_cache[key] = value
    expire(key, timeout=timeout) # 设置超时
    return True

def incr(key, add_num=None):
    '''
    @summary: 设置一个递增的整数
    @param {string} key: 缓存的key值
    @param {int|long} add_num: 要加上的值
    @return {int} 递增后的结果,首次调用时返回 1
    '''
    res = int(get(key) or 0) + (add_num or 1)
    put(key, res)
    return res

def decr(key, reduce_num=None):
    '''
    @summary: 设置一个递减的整数
    @param {string} key: 缓存的key值
    @param {int|long} reduce_num: 要减去的值
    @return {int} 递减后的结果,首次调用时返回 -1
    '''
    res = int(get(key) or 0) - (reduce_num or 1)
    put(key, res)
    return res

def expire(key, timeout=None):
    '''
    @summary: 设置超时时间
    @param {string} key: 缓存的key值
    @param {int|long|float} timeout: 缓存的时间,单位:秒,为空表示永久缓存
    @return {bool} 缓存超时时间是否设置成功,成功则返回 True, 否则返回 False
    '''
    if timeout:
        global _expire_cache
        if isinstance(timeout, (int,long,float)):
            _expire_cache[key] = time.time() + timeout
    return True

def exists(key):
    '''
    @summary: 判断此值是否存在于缓存中
    @param {string} key: 缓存的key值
    @return {bool}: 缓存中有此值,且没有超时则返回 True 。否则返回 False
    '''
    global _value_cache
    global _expire_cache
    if key not in _value_cache:
        return False
    # 判断是否超时
    _expire = _expire_cache.get(key)
    if _expire:
        now = time.time()
        if _expire < now: # 已经超时
            _value_cache.pop(key, None) # 清掉这缓存
            _expire_cache.pop(key, None)
            return False
    # 有此缓存,且并没有超时
    return True

def pop(*args):
    '''
    @summary: 删除指定的key,并且返回它的值
    @param {string} args: 缓存的key值； 要同时删除多个时,可以传多个参数
    @return {string|list}: 如果只有一个参数,则返回被删除的值
        如果有多个参数，则返回被删除的值的列表
    '''
    global _value_cache
    global _expire_cache
    value_list = []
    for key in args:
        if not exists(key): continue
        _value = _value_cache.pop(key, None) # 清掉这缓存
        # 复杂类型,得深拷贝一份,避免外部修改了获取的值
        if _value != None and not isinstance(_value, (bool,int,long,float,complex, basestring, time.struct_time, datetime.datetime, datetime.date)):
            _value = copy.deepcopy(_value)
        value_list.append(_value)
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
    global _value_cache
    return [key for key in _value_cache.keys() if re.match(re_key, key) and exists(key)]

def fn(*out_args, **out_kwargs):
    u"""
    @summary: 缓存函数执行结果
    @param {int|long|float} timeout: 缓存的时间,单位:秒,为空表示永久缓存
    @param {string} name: 当装饰已经有装饰器的函数时,设个名称来区分函数名。最好保证一个项目里面唯一。
    @param {lambda} judge: 判断返回值是否正确的函数(默认只要不是 None 就认为正确)
    @example
        @fn(30)
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


# 指定下次清空缓存的时间戳(清空之后会更新此值)
_CLEAT_TS = None

def __set_clear_ts():
    '''获取下次清空缓存的时间戳'''
    global CONFIG
    global _CLEAT_TS
    clear_hour = CONFIG.get('clear_hour', 2) # 几点钟
    next_datetime = datetime.datetime(*time.localtime()[:3]) + datetime.timedelta(days=1) + datetime.timedelta(hours=clear_hour) # 指定明天的几点钟
    _CLEAT_TS = time.mktime(next_datetime.timetuple()) # 指定明天几点钟的时间戳

def _clear_expire(loop=False):
    '''删除过期的缓存内容,否则会导致内存占用越来越大
    @param {bool} loop: 是否一直执行的清除缓存动作(为True则会一直执行，不中断。为False则只执行一次)
    '''
    global CONFIG
    global _CLEAT_TS
    global _expire_cache
    global _value_cache
    while True:
        try:
            # 定时清空缓存
            if CONFIG.get('cron_clear'):
                now = time.time()
                if now > _CLEAT_TS:
                    __set_clear_ts()
                    clear()
            # 清除过期的缓存
            expire_time = CONFIG.get('clear_expire')
            if expire_time:
                now = time.time()
                _expire_list = _expire_cache.items()
                for key, expire in _expire_list:
                    if expire < now: # 已经超时
                        _value_cache.pop(key, None) # 清掉这缓存
                        _expire_cache.pop(key, None)
                # 缓存越多则下次遍历时间越久，避免影响主程序性能
                expire_time += len(_expire_cache.keys()) // 100
            if loop:
                time.sleep(expire_time or 300)
            else:
                break
        except Exception, e:
            logger.error(u"[red]自动删除过期的缓存出错: %s[/red]", e, exc_info=True, extra={'color':True, 'Exception':e})

# 启动线程,自动删除过期的缓存内容
if CONFIG.get('clear_expire') or CONFIG.get('cron_clear'):
    __set_clear_ts()
    thread.start_new_thread(_clear_expire, (True,))
