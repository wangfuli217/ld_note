#!python
# -*- coding:utf-8 -*-
'''
Created on 2014/9/23
Updated on 2016/3/1
@author: Holemar

本模块专门供加载模块、导入模块用
'''
import os
import sys
import glob
import logging


__all__=('get_path', 'load_modules')

def get_path(lib_path=None, current_path=None, **kwargs):
    '''
    @summary: 获取绝对路径(返回当前工作目录的路径，或者传参文件的路径)
    @param {string} lib_path: 要获取的相对路径
    @param {string} current_path: 参考位置(即相对于此文件的位置,默认值是当前工作目录)
    @return {sring}: 返回 lib_path 的绝对路径
    '''
    # 如果是用 py2exe 打包的程序,这样获取路径
    if hasattr(sys, "frozen"):
        path = os.path.dirname(sys.executable)
    # py 文件的获取路径
    elif current_path:
        path = os.path.dirname(current_path)
    else:
        path = os.getcwd()
    if not (path.endswith('/') or path.endswith('\\') or path==''):
        path += os.sep
    if lib_path:
        path += lib_path
    path = os.path.abspath(path) + os.sep
    return path


def load_modules(file_name='*.py', path=None):
    '''
    @summary: 加载指定的模块
    @param {string} file_name:模块文件名,可使用“*”匹配多个文件。
    @param {string} path:路径(指定上面模块文件的路径)
    @return {list}: 被加载的模块的列表
    '''
    module_list = []
    path = get_path(path)
    sys.path.append(path)
    for module_file in glob.glob(path + file_name):
        try:
            #print module_file ########
            # module_file 是一个包含文件后缀名的文件名，这里分隔出文件名和后缀
            module_name, ext = os.path.splitext(os.path.basename(module_file))
            module = __import__(module_name)
            module_list.append(module)
        except ImportError, e:
            logging.error(u"加载模块出错:%s" % e, exc_info=True)
    return module_list

