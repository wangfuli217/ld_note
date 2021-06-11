#!python
# -*- coding:utf-8 -*-
'''
接口公用函数(django 框架的 API接口 封装)
Created on 2015/10/18
Updated on 2016/3/4
@author: Holemar

环境:
    python 2.7.9
    Django==1.8.1

本模块专门供 django 框架的 API接口 函数修饰用
统一处理 django 请求的请求地址、压缩返回值、异常处理、接口耗时、访问ip验证等
'''
import os
import time
import json
import random
import logging
from functools import wraps

from django.db.models import Q
from django.utils.decorators import available_attrs
from django.http import JsonResponse # json形式返回结果
from django.http.response import HttpResponse

from . import str_util

logger = logging.getLogger('libs_my.django.api')


# 请求默认值
CONFIG = {
    'warn_time' : 5, # {int}:接口运行过久，该警告的时间(单位:秒)
}

def init(**kwargs):
    '''
    @summary: 设置各函数的默认参数值
    @param {int} warn_time: 接口运行过久，该警告的时间(单位:秒,默认 5 秒)
    '''
    global CONFIG
    CONFIG.update(kwargs)


def route(view_func):
    '''
    @summary: 过滤请求函数,判断返回时长、记录日志等
    '''
    def wrapped_view(request, *args, **kwargs):
        global CONFIG
        start_time = time.time()
        url = u"访问:%s" % request.path
        res = None
        param = None
        try:
            param = dict(request.GET)
            param.update(request.POST)
            # 参数里的 value 如果只有一个值时,直接取出来
            param = {key:values[0] if len(set(values)) == 1 else values for key, values in param.iteritems()}
            param.update(kwargs)
            res = view_func(request, *args, **param)
        # 请求被调函数时,参数不对应
        except TypeError, e:
            logger.error(u"[red]请求参数错误:%s[/red] URL:%s, 参数: %s", e, url, (args, param), exc_info=True, extra={'color':True})
            res = {"success": False, 'message': u'请求参数错误'}
        # 请求被调函数时,抛出其它异常
        except Exception, e:
            logger.error(u'[red]接口异常:%s[/red] URL:%s, 参数: %s', e, url, (args, param), exc_info=True, extra={'color':True})
            res = {"success": False, 'message': u'请求失败'}
        finally:
            # 记录调用该接口的耗时
            used_time = time.time() - start_time
            # 记录访问日志
            if used_time >= CONFIG.get('warn_time', 2): # 耗时太长
                logger.warn(u'[yellow]接口耗时太长:%.4f秒[/yellow] URL:%s, 参数: %s 返回:%s', used_time, url, (args, param), res, extra={'color':True})
            else: # 普通日志
                logger.info(u'耗时:%.4f秒, URL:[green]%s[/green], 参数: %s 返回:%s', used_time, url, (args, param), res, extra={'color':True})
        # 返回值处理
        result = JsonResponse({"success": False, 'message': u'请求失败'})
        if isinstance(res, HttpResponse):
            result = res
        elif isinstance(res, basestring):
            result = HttpResponse(res)
        else:
            result = HttpResponse(str_util.json2str(res, raise_error=False))
        return result
    # 将函数变成可访问的接口地址
    wrapped_view.csrf_exempt = True
    return wraps(view_func, assigned=available_attrs(view_func))(wrapped_view)
