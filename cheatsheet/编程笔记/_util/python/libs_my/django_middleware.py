#!python
# -*- coding:utf-8 -*-
'''
公用中间件(django 框架的 中间件)
Created on 2016/2/29
Updated on 2016/8/29
@author: Holemar

依赖第三方库:
    Django==1.8.1

本模块专门供 django 框架的请求页面过滤用
统一处理 django 页面的异常处理、接口耗时、访问ip获取等
需要添加到 配置文件的 MIDDLEWARE_CLASSES 列表中才生效
'''
import logging
from time import time

from django.conf import settings

# VIEW 超时警告时间(单位：秒， 执行时间大于这个数值则发启警告， 配置成 0 或者 None 则关闭此警告)
VIEW_WARN_TIME = getattr(settings, 'VIEW_WARN_TIME', 1)
logger = logging.getLogger('libs_my.django.middleware')


class XForwardedForMiddleware(object):
    def process_request(self, request):
        '''Request 预处理，修正 ip 值，让 request.META['REMOTE_ADDR'] 可以直接获取到正确的 ip
        如果有需要，也可以用来做 ip 验证
        '''
        ip = request.META.get("HTTP_X_FORWARDED_FOR", request.META.get('REMOTE_ADDR', ''))
        ip = ip.split(",")[0].strip()
        ip = request.META.get("HTTP_X_REAL_IP", ip)
        request.META['REMOTE_ADDR'] = ip
        return None


def get_param(request):
    '''获取请求参数'''
    try:
        param = request.body
        return param
    except:
        pass
    try:
        param = request.read()
        request._body = param
        return param
    except:
        pass
    try:
        param = {key:values[0] if len(set(values)) == 1 else values for key, values in dict(request.POST).iteritems()}
        return param
    except:
        pass
    return None


class RunTimeMiddleware(object):
    def process_view(self, request, view_func, view_args, view_kwargs):

        # 获取 view 执行时间
        start_time = time()
        url = request.get_full_path()
        post_param = get_param(request)
        try:
            # 执行 view
            response = view_func(request, *view_args, **view_kwargs)
            return response
        # 错误处理，用于记录错误日志
        except Exception, e:
            logger.error(u'%s 请求 %s 异常: %s，参数:%s', request.method, url, e, post_param, exc_info=True, extra={'Exception': e, 'url': url, 'params': post_param})
            # 不处理错误，继续抛给其它中间件处理
            raise
        # 记录view执行超时日志
        finally:
            duration = time() - start_time
            if VIEW_WARN_TIME and duration >= VIEW_WARN_TIME:
                logger.warn(u'%s 请求超时，耗时:%.4f秒，地址:%s，参数:%s', request.method, duration, url, post_param, extra={'duration': duration, 'url': url, 'params': post_param})
