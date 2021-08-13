#!python
# -*- coding:utf-8 -*-
'''
Created on 2014/8/29
Updated on 2016/2/26
@author: Holemar

本模块专门供监控、调试用
'''
import os
import sys
import time
import types
import logging

from . import str_util, html_util

__all__=('init', 'get_version')
logger = logging.getLogger('libs_my.version')

# 请求默认值
CONFIG = {
    'version' : None, # {string} 版本号
    'db_fun': None, # {Function|list<Function>} 检查数据库连接是否正常的函数(需要空参,可直接调用,如 mysql_util.ping)
}

def init(**kwargs):
    '''
    @summary: 设置get和post函数的默认参数值
    @param {string} version: 版本号
    @param {Function|list<Function>} db_fun: 检查数据库连接是否正常的函数(需要空参,可直接调用,如 mysql_util.ping)
    '''
    global CONFIG
    CONFIG.update(kwargs)

#def get_version(version, db_fun=None, **kwargs):
def get_version(*args, **kwargs):
    '''
    @summary: 查看代码版本号,返回字典类型的内容
    @param {string} version: 此系统的版本号
    @param {Function|list<Function>} db_fun: 查看数据库连接是否正常的函数(需要空参,可直接调用,如 mysql_util.ping)
        需要查看多个数据库(如redis+mysql),可用列表传多个函数过来
    @return {dict}: {
             "result":{int}返回码, #0:成功, -1:数据库异常, 500:程序异常
             "reason":{string} 程序异常/正常的说明,
             "version":{string} 本程序版本号,
             "update_time":{string} 本程序更新时间, #格式为:"yyyy-MM-dd HH:mm:ss"
             "now": {string} 系统当前时间, # 格式为:"yyyy-MM-dd HH:mm:ss"
             "use_time": {string} 本接口反应所用的时间,单位秒
             }
    @example
        version_info = version.get_version(version="agw 1.2.0", db_fun=[cache_redis.ping, mysql_util.ping])
    '''
    global CONFIG
    try:
        start_time = time.time()
        version = args[0] if len(args) >= 1 else kwargs.pop('version', CONFIG.get('version'))
        db_fun = args[1] if len(args) >= 2 else kwargs.pop('db_fun', CONFIG.get('db_fun'))
        # 测试数据库是否连上
        db_success = True
        if db_fun:
            if isinstance(db_fun, (list,tuple,set)):
                for fun in db_fun:
                    db_success = db_success & fun()
            elif isinstance(db_fun, types.FunctionType):
                db_success = db_fun()
        res = {
               'result' : 0 if db_success else -1, # 成功/失败状态,0:成功, -1:数据库异常
               'reason':u'访问成功' if db_success else u'数据库异常',
               'version' : version,
               'update_time': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(os.path.getmtime(__file__))), # 本文件更新时间
               'now' : time.strftime('%Y-%m-%d %H:%M:%S'), # 系统时间,用来核对系统时间是否正确
               }
        use_time = time.time() - start_time
        res["use_time"] = "%.4f" %  use_time # 使用时间
        # 调用时有传其他参数，则格式化成方便人查看的模式返回
        if kwargs:
            res = html_util.to_html(str_util.to_human(res))
        return res
    except Exception, e:
        logger.error(u"[red]查询版本号出现异常[/red]，%s: %s", e.__class__.__name__, e, exc_info=True, extra={'color':True})
        return {"result":500, "reason":u'查询出现异常，%s: %s' % (e.__class__.__name__, e) }
        # 废弃下面获取错误信息的方法，效果跟上面一样
        #info = sys.exc_info()
        #logger.error(u"查询版本号出现异常，%s: %s" % (info[0].__name__, info[1]), exc_info=True, extra={'color':True})
        #return {"result":500, "reason":u'查询出现异常，%s: %s' % (info[0].__name__, info[1]) }
